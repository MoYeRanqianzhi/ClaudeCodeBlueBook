# task progress host projection 拆分记忆

## 本轮继续深入的核心判断

93 已经把 SDK triad 和 queue lifecycle 拆开了。

下一步最自然不是继续讲 triad 总论，而是继续往下压到：

- `task_progress`
- `workflow_progress`

为什么它们首先属于宿主投影层，而不是模型图层。

## 为什么这轮必须把 progress host projection 单列

如果不单列，读者会把 93 的结论停在：

- triad 和 queue lifecycle 不是一层

但更深一层真正关键的事实是：

- triad 内部也不是均质的
- `task_progress/workflow_progress` 明显更偏宿主投影
- `<task-notification>` 才更像结果回流 envelope

## 本轮最关键的新判断

### 判断一：`workflow_progress` 的注释已经直接暴露了 host fold 语义

这是本轮最值钱的切口。

### 判断二：`useRemoteSession` 的 “status signals, not renderable messages” 是宿主层外证

这句非常适合进正文。

### 判断三：`messages.ts` 把 `task_progress` 列为 removed attachment type，是模型层外证

这进一步说明它不该再被写成普通 transcript/attachment 内容。

### 判断四：`print.ts` 的排序本身就是语义

它不是“先 flush 一下缓存”，而是在声明宿主进展流优先于模型结果流。

## 为什么这轮不并回 93

93 讲 triad vs queue lifecycle。
94 讲 triad 内部哪一段天然属于 host projection。

主语继续变窄，不该揉回去。

## 苏格拉底式自审

### 问：为什么这轮最先该拆 `workflow_progress`？

答：因为它的注释已经把“客户端重建 phase tree”的宿主用途写得非常硬。

### 问：为什么 removed attachment type 这种“负证据”值得写？

答：因为它能非常直接地证明：这层对象已经不再被当作普通模型附件层经营。

### 问：为什么排序能成为正文论据？

答：因为排序不是中性的，它决定谁先作为宿主流落到输出面，谁后作为模型/结果层出现。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/94-task_progress、workflow_progress、drainSdkEvents、useRemoteSession、PhaseProgress 与 removed task_progress attachment：为什么 headless print 的进展流属于宿主投影而不是模型图层.md`
- `bluebook/userbook/03-参考索引/02-能力边界/83-Task progress host projection vs model layer 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/94-2026-04-06-task progress host projection 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小改动：

- 长文层只补 94
- 索引层只补 83
- 记忆层只补 94

不把 93-94 重新揉成一篇大的 SDK triad 总论。

## 下一轮候选

1. 单独拆 foreground direct SDK `task_notification` 与 XML re-entry `task-notification` 的宿主分工。
2. 单独拆 `drainSdkEvents()` 为什么在 finally / heldBackResult / waitingForAgents 周围多次冲刷。
3. 单独拆 `workflow_progress` 与 PhaseProgress 折叠树的客户端重建合同。
