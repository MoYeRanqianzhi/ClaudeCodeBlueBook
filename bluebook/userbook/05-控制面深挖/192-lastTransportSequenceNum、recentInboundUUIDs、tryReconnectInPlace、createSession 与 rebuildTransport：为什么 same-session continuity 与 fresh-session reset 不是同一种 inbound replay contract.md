# `lastTransportSequenceNum`、`recentInboundUUIDs`、`tryReconnectInPlace`、`createSession` 与 `rebuildTransport`：为什么 same-session continuity 与 fresh-session reset 不是同一种 inbound replay contract

## 用户目标

191 已经把 shared ingress reader 内部拆成：

- control bypass
- outbound echo drop
- inbound replay guard
- non-user ignore

但如果正文停在这里，读者还是很容易把 `recentInboundUUIDs` 继续写平：

- 不就是 transport 重建时顺手带着的一层 dedup 吗？
- 既然 v1 / v2 都会遇到 reconnect，为什么不统一成“每次重建都清空”？
- `lastTransportSequenceNum` 和 `recentInboundUUIDs` 不都是防 replay 吗，保留或归零是不是实现偏好？
- v2 `rebuildTransport(...)` 明明也换了 transport，为什么没有像 v1 fresh-session 那样立刻清空这两层状态？

这句还不稳。

从当前源码看，还得继续拆开两种完全不同的 read-side contract：

1. same-session continuity
2. fresh-session reset

如果这两层不先拆开，后面就会把：

- `lastTransportSequenceNum`
- `recentInboundUUIDs`
- `tryReconnectInPlace(...)`
- `createSession(...)`
- `rebuildTransport(...)`

重新压成一句模糊的“reconnect 时的 replay 去重策略”。

## 第一性原理

更稳的提问不是：

- “为什么有时保留 replay 状态，有时清空 replay 状态？”

而是先问六个更底层的问题：

1. 当前路径是在延续同一个 server session，还是已经切到了一个全新的 session？
2. 当前状态绑定的是 transport 实例，还是 session 的 inbound event stream？
3. 当前风险是“同一 session 因 transport swap 重放旧事件”，还是“新 session 从 1 开始时被旧游标污染”？
4. 当前保留一张账是在避免重复转发，还是会把新 session 的有效事件错杀掉？
5. 当前分析的是 initial history flush，还是 live ingress continuity？
6. 我是不是把主游标和 safety net 写成了同一种 replay 账？

只要这六轴不先拆开，后面就会把：

- same-session carryover
- fresh-session reset
- seq cursor
- inbound UUID guard

混成一张“reconnect replay 表”。

## 第一层：`tryReconnectInPlace(...)` / `rebuildTransport(...)` 先回答“同一个 session 能不能继续读”

`replBridge.ts` 的环境重建路径先尝试：

- `tryReconnectInPlace(requestedEnvId, currentSessionId)`

注释直接写明：

- success 时 `currentSessionId` 保持不变
- mobile / web 的 URL 保持有效
- `previouslyFlushedUUIDs` 保留

这里先回答的问题不是：

- 该不该清 replay state

而是：

- 旧 session 本身有没有继续活着，当前读入链是不是还在描述同一条 server stream

`remoteBridgeCore.ts` 的 `rebuildTransport(...)` 也是同一逻辑：

- `sessionId` 是常量
- rebuild 只交换 JWT / epoch
- 新 transport 继续连回同一个 session

所以更准确的理解不是：

- “两边都只是 reconnect，只是实现手法不同”

而是：

- 只要还在同一个 session 上，read-side continuity 就应该尽量延续

## 第二层：`lastTransportSequenceNum` 和 `recentInboundUUIDs` 不是同一种账，但共享同一条 session 边界

`replBridge.ts` 早已把两层写开：

- `lastTransportSequenceNum` 是 SSE event-stream 的 high-water mark
- `recentInboundUUIDs` 是 inbound prompt replay 的 defensive dedup

`bridgeMessaging.ts` 也把职责写得很直白：

- seq-num carryover 是 primary fix
- `recentInboundUUIDs` 只是 safety net

所以这里不能把二者写成同一种账。

但它们又共享同一个更高层事实：

- 二者都描述“这个 session 的 read-side continuity”

这正是为什么：

- same-session rebuild 该一起保留
- fresh-session reset 该一起归零

所以更准确的理解不是：

- “一个是 seq，一个是 UUID，所以生命周期当然各自为政”

而是：

- 含义不同，但 session 边界相同

## 第三层：v1 一旦落到 `createSession(...)` fresh-session path，旧 read-side state 必须立即归零

`replBridge.ts` 在 `archiveSession(currentSessionId)` 之后，如果重新 `createSession(...)` 成功，就立刻：

- `currentSessionId = newSessionId`
- `lastTransportSequenceNum = 0`
- `recentInboundUUIDs.clear()`

而且注释把原因说得非常硬：

- 旧 seq 带到新 stream 会让 `from_sequence_num=OLD_SEQ` 对着从 1 开始的新流，导致事件被静默跳过
- inbound UUID dedup 也是 session-scoped

这说明这里回答的问题不是：

- “transport 刚重建，顺手清一些缓存”

而是：

- 旧 session 的 read-side continuity 状态绝不能污染新 session

这也是为什么代码强调：

- reset 必须在 session swap 后、任何 `await` 之前发生

因为一旦：

- `bridgeSessionId` 已经是 B
- `getSSESequenceNum()` 还残留 A

持久化窗口就会写出一份看起来合法、实际有毒的组合。

所以这不是 generic reconnect cleanup。

这是：

- fresh-session reset boundary

## 第四层：v2 `rebuildTransport(...)` 不是 fresh-session reset，而是 same-session continuity 的延长

`remoteBridgeCore.ts` 的 `rebuildTransport(...)` 先做：

- `const seq = transport.getLastSequenceNum()`
- `transport.close()`
- `createV2ReplTransport(... initialSequenceNum: seq ...)`

随后：

- `wireTransportCallbacks()`
- `transport.connect()`

中间完全没有：

- `recentInboundUUIDs.clear()`

也没有：

- 换 `sessionId`

更关键的是同文件前面已经把这句写死：

- `sessionId` is const
- rebuildTransport swaps JWT/epoch, same session
- no reset needed

这说明 v2 的 transport rebuild 回答的问题不是：

- 旧 replay state 该不该作废

而是：

- 在同一个 session 上，如何跨 JWT / epoch / transport incarnation 继续读同一条 inbound stream

所以更准确的理解不是：

- “v2 没清空只是因为少写了一步”

而是：

- v2 恰恰是在利用 same-session continuity，明确拒绝 fresh-session reset

## 第五层：同属 same-session 也不是同一种 continuity，`recentInboundUUIDs` 不是可恢复 ledger

这里还有一个很容易写错的细节：

- `reusedPriorSession` 并不等于恢复 `recentInboundUUIDs`

`replBridge.ts` 在每次 `initBridgeCore()` 都会新建：

- `const recentInboundUUIDs = new BoundedUUIDSet(2000)`

perpetual resume / crash recovery 真正从外部种回来的，是：

- `initialSSESequenceNum`

而不是：

- `recentInboundUUIDs`

这说明 `recentInboundUUIDs` 的真实身份不是：

- 可跨 bridge reset 恢复的 durable replay ledger

而是：

- bridge-instance-local、session-incarnation-scoped 的 ingress guard

所以更准确地说：

- 同一个 bridge 实例里的 same-session transport continuity，会继续沿用这张 guard
- 整个 bridge 重新初始化时，即便复用了 prior session，也只会恢复主游标，不会恢复这张 UUID guard
- 一旦 fresh-session 落成，这两层 state 更要一起归零

这句如果不补，读者就会把：

- same-session transport rebuild
- same-session bridge re-init
- fresh-session reset

三种 continuity 压成两种。

## 第六层：这页不是 189，也不是 191

这页最容易和两篇旧文混写。

先和 189 划清：

- 189 讨论的是 initial history 要不要再 flush 给 server
- 192 讨论的是 live ingress continuity 状态要不要跨 transport / session 保留

189 的主语是：

- server 端是否已经持有那段历史

192 的主语是：

- 当前 reader 还在不在描述同一个 inbound event stream

再和 191 划清：

- 191 讨论 `handleIngressMessage(...)` 一旦收到帧，内部怎么分 control / echo / replay / non-user
- 192 讨论这些 reader-side replay state 什么时候应该延续，什么时候必须归零

191 的主语是：

- reader 内部 consumer split

192 的主语是：

- reader 外部 continuity boundary

如果把这两层重新压平，就会把：

- ingress consumer contract
- inbound replay lifetime

又写回一句模糊的“bridge 的读侧去重逻辑”。

## 结论

更稳的一句应该是：

- 同一个 bridge 实例里的 same-session continuity 要保留 `lastTransportSequenceNum` 与 `recentInboundUUIDs`
- fresh-session reset 必须把它们一起归零
- bridge re-init 即便复用 prior session，也不会恢复 `recentInboundUUIDs`

因为这里保护的不是“transport 是否重建过”，而是：

- 当前 read-side continuity 还是否属于同一个 session incarnation

一旦这句成立，就不会再把：

- `tryReconnectInPlace(...)`
- `createSession(...)`
- `rebuildTransport(...)`

写成同一种 reconnect 语义。
