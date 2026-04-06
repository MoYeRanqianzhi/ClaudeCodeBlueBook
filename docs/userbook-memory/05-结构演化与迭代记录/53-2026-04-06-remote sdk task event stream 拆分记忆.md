# remote sdk task event stream 拆分记忆

## 本轮继续深入的核心判断

第 04 页已经拆开：

- Agent / Task / Team / Cron 的高层能力组织

第 30 页已经拆开：

- remoteBackgroundTaskCount
- remoteConnectionStatus
- ownership / viewerOnly

第 51 页已经拆开：

- 远端运行态投影面

但还缺一层非常容易继续混写的“SDK 任务事件流面”：

- `task_started`
- `task_progress`
- `task_notification`
- `session_state_changed`

如果不单独补这一批，正文会继续犯六种错：

- 把 `task_started` 写成持续运行状态
- 把 `task_progress` 写成终结通知
- 把 `task_notification` 写成进度更新
- 把 `session_state_changed` 写成 task 事件
- 把 background count 变化写成 progress signal
- 把 finally drain 末尾的多条事件压成同一种结束通知

## 苏格拉底式自审

### 问：为什么这批不能塞回第 04 页？

答：第 04 页解决的是：

- 多任务 / 多代理 / cron 的高层能力组织

而本轮问题已经换成：

- 这些 task lifecycle 怎样通过 SDK event stream 被远端消费方看到

也就是：

- delivery semantics for task/session events

不是：

- task capability overview

### 问：为什么这批不能塞回第 30 页？

答：第 30 页解决的是：

- 远端连接告警
- background count
- ownership

而本轮问题已经换成：

- 哪些事件负责维护 background count
- 哪些事件根本不该被当成 count / ownership signal

也就是：

- event semantics under remote consumption

不是：

- runtime surface overview

### 问：为什么这批不能塞回第 51 页？

答：第 51 页解决的是：

- `worker_status`
- `pending_action`
- `task_summary`
- `session_state_changed`

而本轮问题已经换成：

- SDK 任务 bookend / progress / turn-over 事件

也就是：

- event stream for tasks and turns

不是：

- worker state projection

### 问：为什么不能写成“SDK 事件大全”？

答：因为真正值得写进正文的不是：

- 所有 subtype
- 所有 queue 细节
- 所有 XML parser 旁支

而是：

- task begin / progress / end bookend
- turn-over signal
- 背景计数是如何被这些事件折出来的

如果写成事件大全，正文会再次掉回目录学。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/53-task_started、task_progress、task_notification 与 session_state_changed：为什么远端消费方收到的不是同一种事件流.md`
- `bluebook/userbook/03-参考索引/02-能力边界/42-Remote Control task_started、task_progress、task_notification 与 session_state_changed 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/53-2026-04-06-remote sdk task event stream 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- task started / progress / terminal 的 bookend 区分
- `session_state_changed` 是 turn-over signal，不是 task 事件
- background count 是 started / terminal 事件折出来的派生状态

### 不应写进正文的

- queue 上限
- drain 次序实现细节
- XML parser / output stream 胶水
- 所有 system subtype 总表

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### `task_started` / `task_notification` 是算 count 的两端 bookend

这是本批第一根骨架。

并且要继续记住：

- `task_notification` 的稳定合同是 terminal bookend
- 不是“只走 direct SDK emit”
- 普通终结路径还可能经由 `print.ts` 解析带 `<status>` 的 XML，再落成同名 SDK event

正文应写合同，不应把某一条实现入口误写成唯一真相。

### `task_progress` 只该当成中途帧

这是本批第二根骨架。

### `session_state_changed(idle)` 是 turn-over signal

这是本批第三根骨架。

但需要继续保护一个边界：

- turn state 语义稳定存在
- `session_state_changed` 作为 SDK subtype 的外发仍受 env gate 控制

因此正文不能把它写成“永远无条件可见”的稳定事件。

## 审校后新增的正文约束

- 第 53 页只保留 event contract，不重讲第 30 页的完整 remote count 投影面。
- 第 53 页只把 `session_state_changed` 当作 task event 的对照面，不重讲第 51 页的完整 turn-state 投影面。
- 正文里的检查问题要保持读者中性语气，避免写成“我是不是又……”这种作者自审口吻。

如果不持续提醒，正文很容易把它重新写成：

- “又一条状态更新”

## 并行 agent 处理策略

本轮继续按多 agent 旁路勘探执行：

- 一路判断这批是否与 04 / 30 / 51 重复
- 一路收敛 stable / conditional / internal 边界
- 一路给路径与标题命名

主线程在本轮不等待 agent 结论先落笔，因为本地生产链与消费链已经足够收敛本批边界。

## 后续继续深入时的检查问题

1. 我当前讲的是 task capability，还是 task/session event delivery？
2. 我是不是又把 `task_progress` 写成了终结通知？
3. 我是不是又把 `session_state_changed` 写成了 task 事件？
4. 我是不是又把 background count 写成了单独源字段？
5. 我是不是又把 finally drain 末尾的多条事件压成一种结束通知？
6. 我是不是又把正文滑回 SDK 事件大全？

只要这六问没先答清，下一页继续深入就会重新滑回：

- task/session 事件混写
- 或事件目录学污染正文

而不是用户真正可用的远端 SDK 任务事件流正文。
