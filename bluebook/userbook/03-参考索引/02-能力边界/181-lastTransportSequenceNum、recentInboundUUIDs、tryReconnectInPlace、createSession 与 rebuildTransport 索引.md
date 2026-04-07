# `lastTransportSequenceNum`、`recentInboundUUIDs`、`tryReconnectInPlace`、`createSession` 与 `rebuildTransport` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/192-lastTransportSequenceNum、recentInboundUUIDs、tryReconnectInPlace、createSession 与 rebuildTransport：为什么 same-session continuity 与 fresh-session reset 不是同一种 inbound replay contract.md`
- `05-控制面深挖/189-reusedPriorSession、previouslyFlushedUUIDs、createCodeSession 与 flushHistory：为什么 v1 continuity ledger 与 v2 fresh-session replay 不是同一种 history contract.md`
- `05-控制面深挖/191-handleIngressMessage、recentPostedUUIDs、recentInboundUUIDs 与 onInboundMessage：为什么 outbound echo drop、inbound replay guard 与 non-user ignore 不是同一种 ingress consumer contract.md`

边界先说清：

- 这页不是 history flush 总页。
- 这页不是 dedup family 总页。
- 这页只抓 read-side replay continuity 的保留与归零边界。

## 1. 五层对象

| 对象 | 当前更像什么 | 关键位置 |
| --- | --- | --- |
| `lastTransportSequenceNum` | same-session read-stream high-water mark | `replBridge.ts` |
| `recentInboundUUIDs` | session-scoped inbound replay guard | `bridgeMessaging.ts` + `replBridge.ts` |
| `tryReconnectInPlace(...)` | same-session continuity path | `replBridge.ts` |
| `createSession(...)` | fresh-session reset boundary | `replBridge.ts` |
| `rebuildTransport(...)` | same-session transport rebuild | `remoteBridgeCore.ts` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| transport rebuild = session reset | same-session rebuild 要保留 read-side continuity；fresh-session 才要归零 |
| `lastTransportSequenceNum` = `recentInboundUUIDs` | 一个是主游标，一个是 replay safety net |
| v2 不清 `recentInboundUUIDs` = v2 没有 replay state | 恰好相反，它是在同一个 session 上延续那张账 |
| `reusedPriorSession` = 恢复 `recentInboundUUIDs` | 真正会被持久化种回来的主要是 seq seed，不是这张 guard |
| 这页 = 189 的补篇 | 189 讲 history flush；这页讲 live ingress continuity |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | same-session continuity 保留 read-side replay state；fresh-session reset 归零它 |
| 条件公开 | v1 只有 `tryReconnectInPlace(...)` 成功时才保留旧 session 的 read-side 状态；bridge re-init 只会重种 seq seed |
| 内部/灰度层 | JWT 刷新、worker epoch、proactive refresh、SSE reconnect 预算细节 |

## 4. 五个检查问题

- 我现在写的是 history replay，还是 live ingress continuity？
- 我是不是把 transport rebuild 和 session swap 写成同一种 reset？
- 我是不是把 `lastTransportSequenceNum` 和 `recentInboundUUIDs` 压成一张账？
- 我是不是误把 v2 的“不清空”写成“没有这层状态”？
- 我是不是又回卷到 189 或 191 的主语了？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/bridgeMessaging.ts`
- `claude-code-source-code/src/bridge/replBridge.ts`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts`
