# sdk task triad vs queue lifecycle 拆分记忆

## 本轮继续深入的核心判断

92 已经把 task result multi-ledger split 拆出来了。

下一步最自然不是继续重复 ledger，而是继续往下压到：

- `task_started`
- `task_progress`
- terminal `task_notification`

这一组三段式 SDK 事件，与：

- `notifyCommandLifecycle(started/completed)`

这套 queue 两段式账本为什么不能写成一层生命周期。

## 为什么这轮必须把 triad vs pair 单列

如果不单列，读者会把 92 的结论停在：

- 任务、命令、attachment 是不同账本

但更深一层真正关键的事实是：

- 即使只看“宿主任务事件”与“queue 生命周期”，它们也不是同一条时间轴
- `task_progress` 的存在最能暴露这件事

## 本轮最关键的新判断

### 判断一：SDK task triad 是按 `task_id` 组织的宿主事件流

它回答的是 task runtime，而不是 command drain。

### 判断二：queue lifecycle pair 是按 `uuid` 组织的命令消费流

它回答的是 queued command 是否被 turn 消费。

### 判断三：foreground direct SDK `task_notification` 是关键反例

它证明 terminal `task_notification` 本身也不等于一定会进 LLM loop。

### 判断四：`task_progress` 是宿主实时进展流，不是模型结果流

这是本轮最适合作为第一性原理切口的一点。

## 为什么这轮不并回 92

92 讲 parallel ledgers。
93 讲 triad vs pair 的时间轴错位。

主语再一次变窄，不该揉成一页。

## 苏格拉底式自审

### 问：为什么这轮最先该拆 `task_progress`？

答：因为它最能证明这条 SDK 事件流不是在服务模型回合，而是在服务宿主实时态。

### 问：为什么 foreground direct SDK `task_notification` 值得进正文？

答：因为它直接否定了“terminal task_notification 一定会触发 XML parser/LLM loop”的常见误判。

### 问：为什么 remote counter 是好外证？

答：因为它把 triad 的宿主侧功能直接暴露出来了：这是一条 host status projection 流。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/93-task_started、task_progress、task_notification、drainSdkEvents、remoteBackgroundTaskCount 与 notifyCommandLifecycle：为什么 headless print 的后台任务三段式事件不是同一层生命周期.md`
- `bluebook/userbook/03-参考索引/02-能力边界/82-SDK task triad vs queue lifecycle 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/93-2026-04-06-sdk task triad vs queue lifecycle 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小改动：

- 长文层只补 93
- 索引层只补 82
- 记忆层只补 93

不把 92-93 重新揉成一篇大的 task-runtime 总论。

## 下一轮候选

1. 单独拆 `task_progress` 与 `workflow_progress` 为什么是宿主图层，而不是模型图层。
2. 单独拆 foreground direct SDK `task_notification` 与 XML re-entry `task_notification` 的宿主分工。
3. 单独拆 `drainSdkEvents()` 的排序为什么要压在 command queue 之前。
