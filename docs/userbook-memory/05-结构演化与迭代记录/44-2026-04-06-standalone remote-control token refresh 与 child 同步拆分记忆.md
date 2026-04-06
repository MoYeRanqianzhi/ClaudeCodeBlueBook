# standalone remote-control token refresh 与 child 同步拆分记忆

## 本轮继续深入的核心判断

第 41 页已经拆开：

- URL
- secret
- session token
- worker epoch

第 42 页已经拆开：

- register
- poll
- ack
- heartbeat
- archive / deregister

但 standalone remote-control 仍缺一层非常容易继续混写的时间维度认证语义：

- `sessionIngressTokens`
- `handle.updateAccessToken(...)`
- `update_environment_variables`
- `tokenRefresh.schedule(...)`
- `bridge/reconnect`

如果不单独补这一批，正文会继续犯六种错：

- 把 bridge 写成只有一份 token 账本
- 把 scheduler 写成 token 已经送进 child
- 把 v1 child sync 与 v2 reconnect 写成同一种 refresh
- 把 heartbeat token continuity 和 child token continuity 混成一条线
- 把 `updateAccessToken(...)` 写成“只是改个字段”
- 把 refresh cancel / follow-up timer 写成无关紧要的实现噪音

## 苏格拉底式自审

### 问：为什么这批不能塞回第 41 页？

答：第 41 页解决的是：

- 各种 credential object 分别是什么

而本轮问题已经换成：

- 这些 credential 在长任务里怎样随着时间传播、刷新和分叉

也就是：

- static credential taxonomy

之后的：

- runtime auth continuity

所以不能再混回 41。

### 问：为什么这批也不能塞回第 42 页？

答：第 42 页解决的是：

- heartbeat、stop、archive 等 lifecycle verb 在操作哪层对象

而本轮更偏：

- heartbeat 到底拿哪份 token
- refresh 到底怎样进 child
- v2 为什么要改走 reconnect

也就是：

- lifecycle verbs

之后的：

- auth freshness propagation

所以不能再混回 42。

### 问：为什么不能把它写成“token 细节补充”？

答：因为真正要拆开的不是：

- 还有几个 token 字段没提

而是：

- child、heartbeat、server 三个 consumer 的 token continuity 本来就不同
- scheduler 与 delivery strategy 也不是同一层

如果只写“token 细节”，正文会继续缺失最有价值的第一性原理骨架。

### 问：这批最该防的偷换是什么？

答：

- 一份 token = 全部认证状态
- refresh timing = refresh delivery
- v1 refresh = v2 refresh
- child token continuity = heartbeat continuity

只要这四组没拆开，standalone remote-control 的 auth continuity 正文就还会继续糊。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/44-session token refresh、child sync 与 bridge reconnect：为什么 standalone remote-control 的 child 刷新、heartbeat 续租与 v2 重派发不是同一种 token refresh.md`
- `bluebook/userbook/03-参考索引/02-能力边界/33-Remote Control token refresh、child sync 与 heartbeat 认证索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/44-2026-04-06-standalone remote-control token refresh 与 child 同步拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- `sessionIngressTokens` 与 `handle.accessToken` 分属不同 consumer
- scheduler 只负责 timing，不负责 delivery
- v1 refresh 走 child sync
- v2 refresh 走 server re-dispatch
- session 结束 / shutdown 时要 cancel refresh timers

### 不应写进正文的

- every retry constant and failure counter detail
- all debug log wording
- full `getAccessToken()` failure branches
- every transport header refresh implementation detail

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### `sessionIngressTokens` 最容易被忽略

它不是一个无聊的 map，而是：

- heartbeat token continuity 的独立账本

如果没有它，正文会自动滑向“bridge 只有一份 token 状态”。

### scheduler 的真正价值是把时间从传输策略里拆出来

这是本轮最值得保留的骨架：

- schedule/refresh/cancel 是 timing engine
- child sync / reconnect 是 delivery strategy

### v2 之所以重要，不是因为它又多一个 token 名词

而是因为：

- 它直接证明“refresh 不一定等于把新 token 推进现有 child”

这条对照非常值得持续保留。

## 并行 agent 结果

本轮 agent 对这条线给出了同向结论：这页应作为 page 41 与 page 42 之间的时间维度补缝，而不是并回已有 taxonomy / lifecycle 页面。

## 后续继续深入时的检查问题

1. 我当前讲的是 child、heartbeat，还是 server 的 token consumer？
2. 我当前讲的是 timing，还是 delivery？
3. 我是不是又把 v1 sync 与 v2 reconnect 写成了同一种 refresh？
4. 我是不是又把 heartbeat token 和 child token 写成了同一份状态？
5. 我是不是又把 scheduler 细节噪音污染进正文？

只要这五问没先答清，下一页继续深入就会重新滑回：

- token 语义混写
- 或实现噪音污染正文

而不是用户真正可用的 standalone remote-control auth continuity 正文。
