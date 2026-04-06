# standalone remote-control work intake 拆分记忆

## 本轮继续深入的核心判断

第 42 页已经拆开：

- register / poll / ack / heartbeat / stop / archive / deregister

第 44 页已经拆开：

- token refresh timing
- child sync
- heartbeat auth
- v2 reconnect refresh

但 standalone remote-control 仍缺一层非常容易继续混写的 intake contract 语义：

- `decodeWorkSecret`
- `ackWork`
- `healthcheck`
- `existingHandle`
- at-capacity non-ack
- invalid `session_id`
- unknown work type

如果不单独补这一批，正文会继续犯七种错：

- 把 poll 到 work 写成自动 ack
- 把 decode failure 写成普通 session failure
- 把 existing session refresh 写成新 spawn 的轻量版
- 把 at-capacity break 写成 error
- 把 invalid `session_id` 和 unknown work type 写成同一种兼容处理
- 把 healthcheck 写成空 prompt session
- 把 intake contract 和 lifecycle verb 再次压回一层

## 苏格拉底式自审

### 问：为什么这批不能塞回第 42 页？

答：第 42 页解决的是：

- lifecycle verbs 在 environment/work/session 三层分别操作什么

而本轮问题已经换成：

- 一条 work 刚进入本 bridge 时，先怎样过 validity / commitment / routing

也就是：

- lifecycle objects

继续下钻到：

- intake contract

所以需要新起一页。

### 问：为什么这批也不能塞回第 44 页？

答：第 44 页解决的是：

- existing session 上 token freshness 怎样传播

而本轮更偏：

- 这条 work 到底要不要进入 existing session refresh path
- 为什么有的 work 会被故意不 ack

也就是：

- auth continuity

之后的：

- work routing and commitment

所以不能再混回 44。

### 问：为什么不能把它写成“poll loop 补充说明”？

答：因为真正需要拆开的不是：

- poll loop 里又多了几条 if/else

而是：

- validity、claim、routing、compatibility sink 是四种不同问题

如果只写 poll loop 补充，最有价值的第一性原理骨架会继续丢失。

### 问：这批最该防的偷换是什么？

答：

- 看见 work = claim work
- intake invalidity = runtime failure
- existing session refresh = spawn
- capacity deferral = error

只要这四组没拆开，standalone remote-control 的 intake 正文就还会继续糊。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/45-work secret、ack timing、existing session refresh 与 unknown work：为什么 standalone remote-control 的 work intake 不是同一种领取.md`
- `bluebook/userbook/03-参考索引/02-能力边界/34-Remote Control work secret、ack timing、existing session refresh 与 unknown work 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/45-2026-04-06-standalone remote-control work intake 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- decode validity / ack timing / routing / compatibility sink 的分层
- existing session refresh 是独立 intake path
- at-capacity non-ack 是 deliberate deferral，不是 error
- poisoned work 要 stop，不是 ack

### 不应写进正文的

- every throttle sleep detail
- every reclaim-cycle note
- all non-fatal ack failure comments
- full dedup implementation trivia

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### `ackWork()` 最值得保留的不是函数本身，而是“ack 之前先 commit”

这是这一批的核心骨架。

### decode failure 与 unknown type 必须分开

一个是 poisoned intake，一个是 forward compatibility。

把这两者写平，正文就会立刻失真。

### existing session refresh 路径非常关键

如果忽略它，bridge intake 会被误写成：

- healthcheck
- else spawn

这种过度简化模型。

## 并行 agent 结果

本轮 agent 主要用于旁证：确认 `healthcheck/poll_due` 不值得独立成页，而 intake contract 值得独立出来。

正文判断仍以主线本地源码复核为准。

## 后续继续深入时的检查问题

1. 这条 work 当前处在 validity、claim，还是 routing 阶段？
2. 我是不是又把 ack 写成 poll 后固定动作？
3. 我是不是又把 capacity defer 写成 error？
4. 我是不是又把 existing session refresh 写成 spawn？
5. 我是不是把 poisoned work 与 unknown type 写平了？

只要这五问没先答清，下一页继续深入就会重新滑回：

- intake 语义混写
- 或 poll loop 噪音污染正文

而不是用户真正可用的 standalone remote-control intake 正文。
