# task result multi-ledger split 拆分记忆

## 本轮继续深入的核心判断

91 已经把 close-signal family 拆开了。

下一步最自然不是继续围绕 `<status>` 写变体，而是继续往下压到：

- `task_id` 账本
- command `uuid` 账本
- attachment / transcript 内容账本

因为真正最容易被误写成“一层任务状态”的，是这三套并行记账。

## 为什么这轮必须把 multi-ledger split 单列

如果不单列，读者会把 90/91 的结论停在：

- 任务结果会喂给 SDK、模型，并以不同 close signal 结束

但更深一层真正关键的事实是：

- 这些消费路径背后并不是同一本账
- `task_started/task_notification`、`notifyCommandLifecycle`、attachment 内容各自有不同主键和证明力

## 本轮最关键的新判断

### 判断一：`task_id` 和 command `uuid` 是两套不同主键

这句必须钉死，否则后面所有“状态一致性”都会写糊。

### 判断二：attachment 被模型看见，不等于 task ledger 或 command ledger 同步完成

这是把“内容层”和“状态层”分开的关键。

### 判断三：`source_uuid` 缺失是非常值钱的边界证据

它直接证明 task-notification 世界并不完全落在 command ledger 上。

### 判断四：remote viewer 是宿主层外证

它证明宿主可以只靠 task bookend 事件流记账，而完全不依赖本地 task store。

## 为什么这轮不并回 90/91

90 讲 dual-consumer。
91 讲 close-signal family。
92 讲 parallel ledgers。

主语再次变化，不该揉成一篇。

## 苏格拉底式自审

### 问：为什么这轮最先该拆主键，而不是先讲 UI 差异？

答：因为 UI 差异只是投影；`task_id` 和 `uuid` 的分裂才是根。

### 问：为什么 `source_uuid` 缺失能进正文，而不是只放记忆？

答：因为它不是偶然实现细节，而是“command ledger 不是完整真账本”的直接证据。

### 问：为什么 remote viewer 例子这么重要？

答：因为它能从宿主外侧再次证明：task ledger 和 local task store 都不是同一对象。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/92-registerTask、task_started、task_notification、notifyCommandLifecycle、queued_command attachment 与 source_uuid：为什么 headless print 的任务结果不会落在同一层账本.md`
- `bluebook/userbook/03-参考索引/02-能力边界/81-Task result multi-ledger split 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/92-2026-04-06-task result multi-ledger split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小改动：

- 长文层只补 92
- 索引层只补 81
- 记忆层只补 92

不把 90-92 重新揉成一篇大的 task runtime 总论。

## 下一轮候选

1. 单独拆 `source_uuid` 缺失对 dedup / transcript / replay 的连锁后果。
2. 单独拆 remote viewer 为什么只靠 WS task bookend 也能维护后台任务态。
3. 单独拆 `task_started` / `task_progress` / terminal `task_notification` 三段式与 queue-side lifecycle 的错位。
