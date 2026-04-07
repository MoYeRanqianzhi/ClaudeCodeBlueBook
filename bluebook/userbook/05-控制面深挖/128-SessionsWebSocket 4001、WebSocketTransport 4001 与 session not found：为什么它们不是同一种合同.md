# `SessionsWebSocket 4001`、`WebSocketTransport 4001` 与 `session not found`：为什么它们不是同一种合同

## 用户目标

126 已经把 `SessionsWebSocket` 内部的 terminality policy 拆成：

- permanent rejection
- `4001` special budget
- ordinary reconnect budget

127 又把 compaction recovery 合同拆成：

- `status=compacting`
- keep-alive
- `COMPACTION_TIMEOUT_MS`
- `4001`
- `compact_boundary`

继续往下读时，读者仍然很容易把“`4001 session not found`”压成一句：

- 某条会话不存在
- 那就是同一种错误
- 只是有的地方重试，有的地方不重试

于是正文就会滑成一句看似顺、实际上错误的话：

- “`4001` 的协议语义是全局固定的，只是不同组件给它配了不同 retry policy。”

从当前源码看，这也不成立。

同样是 `4001`，至少有两种不同合同：

1. `SessionsWebSocket` 的 compaction-aware stale window exception
2. `WebSocketTransport` 的 permanent close / session reaped contract

它们共用同一个 close code，但不是同一种会话合同。

## 第一性原理

更稳的提问不是：

- “4001 到底算可重试还是不可重试？”

而是先问五个更底层的问题：

1. 当前是哪一个 transport / component 在解释这个 code？
2. 当前 code 指向的是哪一种资源：remote session subscribe，还是另一层 transport session？
3. 当前组件把它当作 stale window、reaped session，还是 definitive invalidation？
4. 当前恢复动作由谁负责：组件自己、上层 caller，还是根本不恢复？
5. 当前看到的 `4001` 是不是已经带上了本组件自己的 contract 前提？

只要这五轴先拆开，`4001` 就不会再被写成一个跨组件全局固定的“协议真义”。

## 第一层：`SessionsWebSocket` 里的 `4001` 是 compaction-aware exception，不是 permanent close

`SessionsWebSocket.ts` 顶部注释写得非常明确：

- `4001 (session not found)` is handled separately
- can be transient during compaction

`handleClose(closeCode)` 也真的把它单列为：

- 不属于 `PERMANENT_CLOSE_CODES`
- 先走 `sessionNotFoundRetries`
- 在预算内 `scheduleReconnect(...)`
- 预算耗尽后才 `onClose`

这说明在 `SessionsWebSocket` 里，`4001` 回答的问题不是：

- “会话已经 definitively 不存在，立刻 stop”

而是：

- “当前 remote session subscribe 可能正处在 compaction stale window，需要给一条有预算的恢复机会”

所以这一层的主语是：

- stale-window exception

不是：

- permanent invalidation

## 第二层：`WebSocketTransport` 里的 `4001` 是 permanent close family，不是 stale exception

`WebSocketTransport.ts` 顶部的 `PERMANENT_CLOSE_CODES` 直接包含：

- `4001 // session expired / not found`

而 close 处理路径里，只要：

- `PERMANENT_CLOSE_CODES.has(closeCode)`
- 且 `!headersRefreshed`

就会：

- `state = 'closed'`
- `onCloseCallback?.(closeCode)`
- 不再 reconnect

所以在 `WebSocketTransport` 里，`4001` 回答的问题更接近：

- 这条 transport 所在的 session / ingress token 已经失效或被 reaped

它不是：

- compaction 期间短暂 stale，可用 special budget 平滑过去

所以更稳的写法应是：

- `WebSocketTransport 4001` 属于 permanent close family

而不是：

- “只是同一个 4001，在这里没开 retry”

## 第三层：同样的 code，在不同组件里指向的资源对象并不一样

这一步最容易被漏掉。

因为很多人看到的只是：

- close code `4001`

却忘了当前 transport 连的根本不是同一类资源。

### `SessionsWebSocket`

- 连的是 remote session `/subscribe`
- 面向的是 remote session event stream

### `WebSocketTransport`

- 是另一层更泛化的 transport
- 注释里直接提到 session reaped / handshake rejection
- caller 还可能自己接管 recovery

所以 `4001` 这串数字在两层里虽然相同，

但它绑定的资源对象、生命周期边界、恢复主权都不同。

这也就是为什么更稳的句子必须写成：

- same code, different contract owner

而不是：

- same code, same contract, different retry count

## 第四层：`SessionsWebSocket` 的 `4001` 合同建立在 compaction 语境上

127 已经讲过：

- compaction 会反复 re-emit `compacting`
- 会延长 timeout
- 结束时发 `compact_boundary`

而 `SessionsWebSocket` 顶部注释又把 `4001` 直接绑定到：

- transient during compaction

这说明 `SessionsWebSocket 4001` 并不是一个抽象普遍规则。

它更像：

- 为 remote session compaction stale window 定制的 exception contract

如果把这一层漏掉，正文就会误写成：

- 所有 `session not found` 都天然可重试

这与当前组件语义不符。

## 第五层：`WebSocketTransport` 的 `4001` 反而在“睡眠醒来 / session reaped”语境里更像终局

`WebSocketTransport.ts` 的注释写得也很直白：

- system sleep/wake 后重置 reconnect budget 再试
- server will reject with permanent close codes `(4001/1002)` if session was reaped during sleep

也就是说在这层里，`4001` 更像是在说：

- 你原来那条 transport session 已经不是原来那条 session 了

它的语义重心不是：

- 暂时 stale

而是：

- reaped / expired / handshake-rejected permanent close family

所以如果把这层也写成：

- “compaction 里的临时 not found”

就把 transport 语境彻底写错了。

## 第六层：同样都可能走 `onClose`，但 close sink 相同不等于 code semantics 相同

`SessionsWebSocket` 里：

- `4001` 预算耗尽后才 `onClose`

`WebSocketTransport` 里：

- `4001` 本来就在 `PERMANENT_CLOSE_CODES`
- 满足条件就直接 `onCloseCallback`

所以如果只看最后都进入：

- closed / onClose

很容易误判成：

- 两层只是 retry budget 不同

但更准确的拆法是：

- sink 相同
- reason 不同
- contract owner 不同

这也是这页最该强调的一点。

## 第七层：因此 “4001 是否可重试” 不是全局协议真相，而是组件语义

把前面几层压成一句，最稳的一句其实是：

- `4001` 的 meaning is component-scoped

也就是说：

- 在 `SessionsWebSocket` 里，它被解释成 compaction stale-window exception
- 在 `WebSocketTransport` 里，它被解释成 permanent close family

所以 userbook 正文里最该避免的一种写法就是：

- “4001 就是会话不存在，但有时为了体验会重试。”

这句话把：

- code semantics
- component semantics
- retry policy

三层都压平了。

## 第八层：为什么它不是 126、127 的重复页

### 它不是 126

126 讲的是：

- `SessionsWebSocket` 内部三种 terminality bucket

128 则讲：

- 同一个 `4001` 跨组件时，为什么已经不是同一种合同

一个讲：

- intra-component taxonomy

一个讲：

- cross-component semantic split

### 它不是 127

127 讲的是：

- compaction recovery contract 内部五张表

128 则只取其中一个点继续往外压：

- `4001` 放到别的 transport 里以后，语义为什么变了

一个讲：

- compaction recovery layering

一个讲：

- session-not-found contract divergence

## 第九层：最常见的假等式

### 误判一：`4001` 在任何 transport 里都该可重试

错在漏掉：

- `WebSocketTransport` 明确把它放进 permanent close family

### 误判二：`4001` 在任何 transport 里都该直接 stop

错在漏掉：

- `SessionsWebSocket` 把它当成 compaction stale-window exception

### 误判三：同一个 code 共享同一个协议真义，只是 retry policy 不同

错在漏掉：

- 当前解释它的是不同组件、不同资源对象、不同恢复主权

### 误判四：只要最终都 `onClose`，终止语义就已经一致

错在漏掉：

- close sink 一致，不等于 contract reason 一致

### 误判五：`session not found` 这个字面意义已经足够解释行为差异

错在漏掉：

- 还必须看当前组件把它放在哪个 contract bucket 里

## 第十层：stable / conditional / internal

### 稳定可见

- `SessionsWebSocket` 当前把 `4001` 单独 special-handle
- `WebSocketTransport` 当前把 `4001` 放进 permanent close family
- 因此 “4001 是否可重试” 当前不是全局稳定真义，而是组件语义

### 条件公开

- `SessionsWebSocket 4001` 的 special handling 建立在 compaction stale window 语境上
- `WebSocketTransport 4001` 的 permanent close 还受 `headersRefreshed` 等当前路径条件影响
- `autoReconnect` 关闭时，`WebSocketTransport` 还会让 caller 自己接管恢复

### 内部 / 灰度层

- `MAX_SESSION_NOT_FOUND_RETRIES = 3`
- `headersRefreshed` 判定
- sleep detection / reconnect budget reset
- 当前 permanent code 列表

这些更适合作为：

- 当前实现证据

而不是：

- 对外稳定承诺

## 第十一层：苏格拉底式自审

### 问：我现在写的是 `SessionsWebSocket 4001`，还是 `WebSocketTransport 4001`？

答：如果答不出来，就说明又把组件语义压平了。

### 问：我是不是把 “同一个 code” 错写成 “同一个合同”？

答：如果是，就忽略了 contract owner。

### 问：我是不是把 compaction stale window 误写成了全局 `4001` 规律？

答：如果是，就把 conditional contract 写过头了。

### 问：我是不是只看了最终 `onClose`，就断言终止语义相同？

答：如果是，就把 sink 和 reason 混了。

## 源码锚点

- `claude-code-source-code/src/remote/SessionsWebSocket.ts`
- `claude-code-source-code/src/cli/transports/WebSocketTransport.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/services/compact/compact.ts`
