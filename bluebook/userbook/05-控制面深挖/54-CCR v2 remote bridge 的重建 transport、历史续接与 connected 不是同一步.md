# `transport rebuild`、initial flush、`flush gate` 与 `sequence resume`：为什么 CCR v2 remote bridge 的重建 transport、历史续接与 `connected` 不是同一步

## 用户目标

不是只知道 CCR v2 remote bridge 里“JWT 快过期会 refresh、401 以后会 reconnect、源码里还有 flush gate 和 sequence number”，而是先分清七类不同对象：

- 哪些是在决定“何时该拿一份新的 `/bridge` 凭证”。
- 哪些是在 token 还没爆掉前主动做 refresh。
- 哪些是在旧 transport 已经 401 后做 auth recovery。
- 哪些是在拿到新 JWT / epoch 后，必须整段重建 transport，而不是热换一个 header。
- 哪些是在 transport 切换期间把写入暂存起来，避免历史 flush 与新消息串写。
- 哪些是在新 transport 上从旧流的 sequence 高水位继续，而不是从头 replay。
- 哪些在 auth recovery 期间根本不该补发，而要故意丢弃旧链路上的控制消息与结果。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“bridge reconnect”：

- `createTokenRefreshScheduler(...)`
- `onRefresh`
- `recoverFromAuthFailure()`
- `rebuildTransport(...)`
- `FlushGate`
- `initialFlushDone`
- `initialSequenceNum`
- `authRecoveryInFlight`
- `control_request` / `control_response` / `result`

## 第一性原理

CCR v2 remote bridge 的“transport continuity”至少沿着五条轴线分化：

1. `Auth Trigger`：当前是在 token 过期前主动刷新，还是已经被 401 打断后补救。
2. `Epoch Continuity`：当前是在延续同一条 session，还是已经拿到新一代 worker epoch，必须换整段 transport。
3. `Read Continuity`：当前是在旧流基础上续读，还是把整段事件流从头 replay。
4. `Write Safety`：当前新写入应该先排队、直接发出，还是故意丢弃。
5. `Flush Boundary`：当前正在做的是历史 flush、rebuild 过渡，还是稳定运行态下的普通发送。

因此更稳的提问不是：

- “bridge 不是已经 refresh / reconnect 了吗？”

而是：

- “现在是在决定何时 refresh、在 401 后补救、在重建 transport、在保护 flush 边界，还是在沿旧 sequence 继续读；这批写入到底该 queue、resume，还是 drop？”

只要这五条轴线没先拆开，正文就会把 refresh timer、401 recovery、transport rebuild、flush gate 与 sequence resume 写成同一种 reconnect。

这里也要主动卡住一个边界：

- 这页讲的是 CCR v2 remote bridge 的 transport continuity 合同
- 不重复 44 页对 refresh scheduler、child sync 与 v2 refresh strategy 的分层
- 不重复 47 页对 reconnecting budget、poll cadence 与 give up 的重试面
- 不重复 50 页对 CCR v2 worker 初始化、heartbeat 与 self-exit 的生命周期合同
- 这页也不是 `remoteBridgeCore.ts` 内部状态机总表

## 第一层：`proactive refresh` 与 `401 recovery` 只是 replacement 入口，不是 continuity 本身

### 一个发生在“快过期之前”，一个发生在“已经失效之后”

`remoteBridgeCore.ts` 对两条路径分得很清楚：

- `createTokenRefreshScheduler(...)` 会在过期前触发 `onRefresh`
- `transport.setOnClose(...)` 收到 `401` 时，会进入 `recoverFromAuthFailure()`

这说明它们回答的问题不是：

- “是不是反正都叫 reconnect”

而是：

- 当前是在失效前主动续命，还是在旧 transport 已被认证失败打断后补救

### 但两条路径最终都会落到同一个 continuity 入口：`rebuildTransport(...)`

两条路径都会：

- 重新调用 `/bridge` 取 fresh credentials
- 带着新的 `worker_jwt` 与 `worker_epoch`
- 进入 `rebuildTransport(...)`

所以更准确的理解应是：

- `proactive refresh` / `401 recovery`：触发语义
- `rebuildTransport(...)`：共同的接棒合同

只要这一层没拆开，正文就会把：

- “什么时候触发恢复”
- “恢复后怎样接棒”

写成同一个动作。

## 第二层：`rebuildTransport(...)` 不是热换 JWT，而是在同一 session 上带着新 epoch 重建整段 transport

### `/bridge` 每调用一次都会 bump server-side epoch

`remoteBridgeCore.ts` 的注释写得很硬：

- 每次 `/bridge` 调用都会 bump epoch
- 只换 JWT、不换 transport，会让旧 `CCRClient` 带着 stale epoch heartbeat
- 结果很快就会撞上 `409`

这说明这里回答的问题不是：

- “把 Authorization header 换一下不就好了”

而是：

- 旧 transport 已经绑定旧 epoch，必须整体退场，新 transport 才有合法写入权

### 所以系统重建的是一整套读写 transport，而不是单个 token 字段

`rebuildTransport(...)` 会：

- 读取旧 transport 的 `getLastSequenceNum()`
- `close()` 旧 transport
- 用新的 JWT / epoch 调 `createV2ReplTransport(...)`
- 重新 wire callbacks
- 再次 `connect()`

同时注释也明确写出：

- `sessionId` 是 const
- rebuild transport 不会重建一条新 session
- 变化的是 auth / epoch 绑定的 transport，不是会话身份本身

更准确的区分是：

- fresh credentials：只是拿到新凭证
- transport rebuild：把新凭证与新 epoch 绑定到同一 session 上的一条新读写链路

只要这一层没拆开，正文就会把 refresh 误写成 JWT hot-swap。

## 第三层：`sequence resume` 解决的是“从哪里继续读”，不是“整段历史重新播放”

### 新 transport 会从旧流的高水位 sequence 接着读

`rebuildTransport(...)` 会先取：

- `transport.getLastSequenceNum()`

然后把它作为：

- `initialSequenceNum`

传给新的 `createV2ReplTransport(...)`。

`replBridgeTransport.ts` 也把语义写得很清楚：

- 新 SSETransport 首次连接会带 `from_sequence_num / Last-Event-ID`
- 目标是从旧流停下来的地方继续
- 否则 server 会把整段 session history 从 `seq 0` 重放

这说明它回答的问题不是：

- “reconnect 后是不是重新收一遍全部事件”

而是：

- “新 transport 应该从旧流的哪一个高水位继续消费”

### 所以 `rebuild` 与 `replay from zero` 不是同一个恢复动作

更准确的理解应是：

- transport rebuild：换 transport / 换 epoch
- sequence resume：续读位置不回到零点

只要这一层没拆开，正文就会把“换了一条 transport”误写成“整段会话重播”。

## 第四层：`flush gate` 保护的是写入边界，不是 generic retry queue

### 初始 flush 与 rebuild 期间，新写入会先被 gate 住

`remoteBridgeCore.ts` 在两个时机都会 `flushGate.start()`：

- 启动初始 connect 且存在 `initialMessages` 时
- 进入 `rebuildTransport(...)` 时

而 `FlushGate` 自己的注释说明得很直接：

- flush 期间的新消息必须先 queue
- 否则历史 flush 与新消息会交错到 server

这说明它回答的问题不是：

- “错误恢复时统一排一个 retry backlog”

而是：

- “在历史 flush 或 transport 切换完成前，普通消息先不要穿过这条边界”

### 所以 `flush gate` 的首要职责是防串写、防静默丢失

`rebuildTransport(...)` 的注释还补了另一层风险：

- 旧 transport 在 epoch 过期后，写入可能 silently no-op
- 如果不先 gate，新写入可能既加进 `recentPostedUUIDs`，又没有真正送达

更准确的理解应是：

- `flush gate`：顺序与安全边界
- retry/backoff：另一层存活预算

只要这一层没拆开，正文就会把 flush gate 误写成普通“失败重试队列”。

## 第五层：initial flush 与后续 drain 不是同一步，所以 `connected` 也不是“transport 刚一连上”

### 系统会先 flush eligible history，再 drain gate 里的新消息

`onConnect` 的逻辑是：

- 若还没完成初始 flush，就先跑 `flushHistory(initialMessages)`
- 成功后才 `drainFlushGate()`
- 然后再把状态推到 `connected`

这说明这里回答的问题不是：

- “连上以后所有消息一起发出去”

而是：

- 历史消息要先按既定边界补齐，后到的新消息要在 flush 之后另行 drain

### 401 打断初始 flush 时，还会显式重置 `initialFlushDone`

`recoverFromAuthFailure()` 里专门写明：

- 如果 401 打断了初始 flush
- 就把 `initialFlushDone = false`
- 让新 transport 在下次 `onConnect` 时重新执行这次 flush

更准确的区分是：

- 初始 history flush：启动/重建后的历史补齐
- flush-gated drain：flush 期间新到消息的后续发送

只要这一层没拆开，正文就会把“history restore”与“live write drain”写成一锅。

## 第六层：auth recovery 期间，不同写入对象的命运并不相同

### 普通消息可以 queue，但旧 transport 上的 control / result 会被故意丢弃

`remoteBridgeCore.ts` 在 auth recovery 期间对几类对象做了不同处理：

- `writeMessages(...)` 会继续经过 `flushGate.enqueue(...)`
- `sendControlRequest(...)` / `sendControlResponse(...)` / `sendControlCancelRequest(...)` 会直接 drop
- `sendResult()` 也会直接 drop

这说明它回答的问题不是：

- “401 期间所有写入都统一等待重发”

而是：

- 哪些普通消息可以在新 transport 上接着写
- 哪些控制面 / 收口面对象如果继续沿旧链路发送，只会污染恢复边界

### 所以“queue everything”会把控制面写坏

更准确的理解应是：

- 普通消息：可以经由 gate 等待新 transport
- `control_request` / `control_response` / `result`：在 auth recovery 期间宁可 drop，也不沿旧 epoch 发出

只要这一层没拆开，正文就会把“消息防丢”误写成“所有对象都必须补发”。

## 第七层：`reconnecting`、`connected` 与 refresh success 不是同一张状态面

### 401 recovery 会显式进入 `reconnecting`

`recoverFromAuthFailure()` 一开始就会：

- `onStateChange?.('reconnecting', 'JWT expired — refreshing')`

而 `proactive refresh` 的目标则更像：

- 在旧 transport 真的炸掉前，把新 transport 接上

这说明它回答的问题不是：

- “只要 token 更新成功，用户侧状态词就都一样”

而是：

- 当前是否已经被认证失败打断，从而需要公开进入一段恢复中的过渡态

### 所以 proactive path 与 401 path 不应被压成一种“刷新成功”

更准确的理解应是：

- `proactive refresh`：预防式接棒
- `401 recovery`：打断后的恢复态

只要这一层没拆开，正文就会把 auth trigger 与状态投影写平。

## 第八层：稳定、条件与内部三层要分开保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | CCR v2 refresh / auth recovery 最终会在同一 session 上重建整段 transport；新 transport 会从旧 sequence 高水位继续读；initial flush 与后续 drain 是两段不同写入边界 |
| 条件公开 | `proactive refresh` 与 `401 recovery` 共用 rebuild 合同但触发不同；401 中断初始 flush 会触发 `initialFlushDone` 重置；auth recovery 期间 control / result 会被故意丢弃 |
| 内部/实现层 | `authRecoveryInFlight`、`connectDeadline`、`recentPostedUUIDs`、具体 close code、`FlushGate` 的具体状态机细节 |

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `proactive refresh` = `401 recovery` | 一个是失效前接棒，一个是失效后补救 |
| JWT 刷新 = 热换 header | `/bridge` bump epoch 后必须 rebuild transport |
| transport rebuild = 从头 replay 全部历史 | 新 transport 会从旧 sequence 高水位继续读 |
| `flushGate` = generic retry queue | 它首先是 flush / rebuild 期间的顺序与安全边界 |
| auth recovery 时所有写入都该补发 | 普通消息可 queue，control / result 会被故意 drop |
| 初始 flush = 后续 live drain | 一个是历史补齐，一个是 flush 后的新消息排空 |

## 六个检查问题

- 当前是在失效前主动 refresh，还是已经 401 后做 recovery？
- 当前动作是在换 token，还是在换整段绑定新 epoch 的 transport？
- 新 transport 现在应该从哪里继续读，是否会把整段流从头 replay？
- 当前写入跨越的是初始 flush / rebuild 边界，还是稳定运行态？
- 这条写入是普通消息，可以 queue，还是 control / result，应该在 recovery 中 drop？
- 我现在看到的是 auth 恢复语义，还是 47 页里的 reconnect budget / backoff 语义？

## 源码锚点

- `claude-code-source-code/src/bridge/remoteBridgeCore.ts`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts`
- `claude-code-source-code/src/bridge/flushGate.ts`
