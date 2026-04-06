# Remote Control `transport rebuild`、initial flush、`flush gate` 与 `sequence resume` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/54-transport rebuild、initial flush、flush gate 与 sequence resume：为什么 CCR v2 remote bridge 的重建 transport、历史续接与 connected 不是同一步.md`
- `05-控制面深挖/44-session token refresh、child sync 与 bridge reconnect：为什么 standalone remote-control 的 child 刷新、heartbeat 续租与 v2 重派发不是同一种 token refresh.md`
- `05-控制面深挖/47-poll、heartbeat、reconnecting、give up 与 sleep reset：为什么 bridge 的保活、回连预算与放弃条件不是同一种重试.md`

边界先说清：

- 这页不是 `remoteBridgeCore.ts` 状态机总表
- 这页只抓 transport 接棒、initial flush、flush 边界与 sequence resume 的消费语义

## 1. 六类对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Replacement Trigger` | 什么入口会把 continuity 带入 transport replacement | `onRefresh` / `recoverFromAuthFailure()` |
| `Transport Handoff` | 新 JWT / epoch 怎样接到同一 session 的新读写链路上 | `rebuildTransport(...)` |
| `Read Resume Cursor` | 新 transport 从哪里继续读 | `initialSequenceNum` |
| `Initial Flush Boundary` | 历史 flush 完成前，新消息是否先排队 | `flushHistory(...)` / `FlushGate` |
| `Connected Verdict` | 什么时候才算真的进入 `connected` | `flushHistory(...)` 后的 `drainFlushGate()` |
| `Selective Drop During Recovery` | 哪些对象不该穿过旧链路污染恢复边界 | `control_request` / `control_response` / `result` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `proactive refresh` = `401 recovery` | 一个失效前接棒，一个失效后补救 |
| JWT 刷新 = 热换 transport auth header | `/bridge` bump epoch 后必须 rebuild transport |
| rebuild = replay 整段历史 | 新 transport 按旧 sequence 高水位续读 |
| transport 一 connect 就等于 fully connected | initial flush 与 drain 结束后才会推到 `connected` |
| `flushGate` = 普通 retry queue | 它首先是 flush / rebuild 的顺序边界 |
| recovery 期间所有写入都统一补发 | 普通消息可 queue，control / result 会被故意 drop |
| reconnecting = refresh 机制本身 | 它只是恢复期的状态投影之一 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | refresh / auth recovery 最终会在同一 session 上重建整段 transport；新 transport 会从旧 sequence 高水位继续读；initial flush 与后续 drain 不是同一批写入 |
| 条件公开 | `proactive refresh` 与 `401 recovery` 共享 rebuild 合同但触发不同；401 打断初始 flush 时会重置 `initialFlushDone`；control / result 在 recovery 中会被故意 drop |
| 内部/实现层 | `authRecoveryInFlight`、`connectDeadline`、`recentPostedUUIDs`、具体 close code 与 gate 状态机 |

## 4. 七个检查问题

- 当前是在失效前主动 refresh，还是已经 401 后补救？
- 这里是在换 token，还是在换整段带新 epoch 的 transport？
- 新 transport 应该从哪里继续读，是否会整段 replay？
- 当前跨越的是 initial flush / rebuild 边界，还是稳定发送面？
- 这里的 `connected` 是 transport 刚 ready，还是 history flush 与 gate drain 已经完成？
- 这条写入是普通消息、可以 queue，还是 control / result、应该 drop？
- 我是不是又把 auth recovery 与 reconnect budget / backoff 写成一回事了？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/remoteBridgeCore.ts`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts`
- `claude-code-source-code/src/bridge/flushGate.ts`
