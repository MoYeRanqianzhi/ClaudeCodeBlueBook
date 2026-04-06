# remote runtime state projection 拆分记忆

## 本轮继续深入的核心判断

能力地图那页已经拆开：

- 实时账 vs 恢复账
- `SessionState`
- `pending_action`
- `task_summary`

第 30 页已经拆开：

- 远端连接告警
- 后台任务
- ownership / viewerOnly

第 50 页已经拆开：

- CCR v2 worker lifecycle

但还缺一层非常容易继续混写的“远端运行态投影面”：

- `worker_status`
- `requires_action_details`
- `pending_action`
- `task_summary`
- `post_turn_summary`
- `session_state_changed`

如果不单独补这一批，正文会继续犯六种错：

- 把 `worker_status` 与 `pending_action` 写成同一种状态
- 把 `requires_action_details` 与 `pending_action` 写成同一种载体
- 把 `task_summary` 写成阻塞原因
- 把 `task_summary` 与 `post_turn_summary` 写成同一个摘要
- 把 `session_state_changed` 与 `worker_status` 写成同一种 delivery
- 把能力地图总览再抄成一篇控制面长文

## 苏格拉底式自审

### 问：为什么这批不能塞回能力地图那页？

答：能力地图那页解决的是：

- 实时账 vs 恢复账
- 哪些属于真相层，哪些属于恢复账

而本轮问题已经换成：

- 这些实时对象被怎样投影给远端
- phase / block context / progress / delivery surface 怎样彼此错位

也就是：

- projection surfaces for remote consumers

不是：

- runtime truth overview

### 问：为什么这批不能塞回第 30 页？

答：第 30 页解决的是：

- remoteConnectionStatus
- remoteBackgroundTaskCount
- viewer ownership

而本轮关注的是：

- 远端“当前这轮在干嘛、卡在哪、何时 turn over”的投影

也就是：

- task/turn runtime surfaces

不是：

- connection / ownership surfaces

### 问：为什么这批不能塞回第 50 页？

答：第 50 页解决的是：

- worker init
- state restore
- heartbeat / keep_alive
- self-exit

而本轮问题已经换成：

- worker lifecycle 之外，远端消费方实际读到的是哪几张不同状态面

也就是：

- consumer-facing state projection

不是：

- worker lifecycle contract

### 问：为什么不能写成“远端状态字段大全”？

答：因为真正值得写进正文的不是：

- 所有字段名字
- 所有 SDK schema
- 所有 proto / Datadog 路径

而是：

- 哪些是粗粒度相位
- 哪些是阻塞上下文
- 哪些是 mid-turn progress
- 哪些是 post-turn recap
- 哪些是状态广播

如果写成字段大全，正文会再次掉回作者记忆与目录学。

本轮 agent 旁证补了一条很有价值的收束：

- 路径 56 更适合挂成 `索引 40 -> 能力地图总览 -> 20 -> 50 -> 51`
- 这样先补 runtime truth，总结宿主合同，再补 worker lifecycle，最后再读投影面

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/51-worker_status、requires_action_details、pending_action、task_summary、post_turn_summary 与 session_state_changed：为什么远端看到的运行态不是同一张面.md`
- `bluebook/userbook/03-参考索引/02-能力边界/40-Remote Control worker_status、pending_action、task_summary 与 session_state_changed 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/51-2026-04-06-remote runtime state projection 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- phase、block context、mid-turn progress、post-turn recap、SDK broadcast 的层次分离
- `requires_action` 为什么仍需要 typed details 和 JSON mirror
- `task_summary` / `post_turn_summary` 为什么都是观察面但时间尺度不同

### 不应写进正文的

- SDK schema 枚举细节
- proto / Datadog 路径
- env gate 旁支
- 远端前端具体解析实现细节
- 与能力地图页重复的“实时账 vs 恢复账”通论

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### `worker_status` 和 `session_state_changed` 必须写成两种 delivery surface

这是本批第一根骨架。

### `requires_action_details` 与 `pending_action` 是 typed / JSON 双轨

这是本批第二根骨架。

### `task_summary` / `post_turn_summary` 只应写成观察面

这是本批第三根骨架。

如果不持续提醒，正文很容易把它们重新抬成“会话主状态”。

### 相邻 metadata 键继续留在记忆，不拉回正文

这是本批第四根骨架。

尤其是：

- `permission_mode`
- `model`
- `is_ultraplan_mode`
- 其他 SDK / proto / Datadog 旁支

这些只应作为作者判断依据，不应稀释这页主面。

## 并行 agent 处理策略

本轮继续按多 agent 旁路勘探执行：

- 一路判断这批是否与能力地图总览或第 30 / 50 页重复
- 一路收敛 stable / conditional / internal 边界
- 一路给路径与标题命名

主线程在本轮不等待 agent 结论先落笔，因为本地查重和源码投影链已经足够收敛本批边界。

## 后续继续深入时的检查问题

1. 我当前讲的是 runtime truth，还是 remote projection surface？
2. 我是不是又把 `worker_status` 和 `pending_action` 写成了同一状态？
3. 我是不是又把 `task_summary` 写成了阻塞原因？
4. 我是不是又把 `task_summary` 与 `post_turn_summary` 写成了同一个摘要？
5. 我是不是又把 `session_state_changed` 和 `worker_status` 写成了同一种 delivery？
6. 我是不是又把正文滑回远端状态字段大全？

只要这六问没先答清，下一页继续深入就会重新滑回：

- 投影层级混写
- 或字段目录学污染正文

而不是用户真正可用的远端运行态投影正文。
