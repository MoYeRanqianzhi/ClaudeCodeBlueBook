# headless print prompt batching 拆分记忆

## 本轮继续深入的核心判断

88 已经把 headless `print` 的 queue re-entry / single-consumer pump 拆清了。

下一步最自然不是回头重讲 queue，而是继续往下压到：

- prompt batching
- workload / meta 边界
- per-uuid replay 与 lifecycle 补偿

因为真正容易被写成“只是性能优化”的，恰恰是这一层。

## 为什么这轮必须把 batching 单列

如果不单列，读者会把 88 的结论停在：

- `run()` 会继续 drain queue

但更深一层真正关键的事实是：

- drain 不等于 bulk dequeue
- 这里只有受约束的 prompt turn 合批
- 合批同时还在修补 workload attribution、meta 可见性和 per-uuid 身份账本

## 本轮最关键的新判断

### 判断一：`joinPromptValues()` 合并的是 prompt payload，不是执行主权

所以它能做字符串/blocks 拼接，但不能替代 side-effect 边界治理。

### 判断二：`canBatchWith()` 的三条硬边界是 mode、workload、`isMeta`

这轮最值得强调的是：

- `workload` 和 `isMeta` 不是附带字段，而是 batching 合同的一部分

### 判断三：`task-notification` 与 `orphaned-permission` 必须单发

原因不是“作者懒得合批”，而是：

- 前者先承担 SDK 事件副作用
- 后者携带 orphaned permission 状态

### 判断四：batching 减少的是 turn 数，不是每条命令的身份账本

所以源码才会同时保留：

- 最后一个 `uuid` 代表 ask
- 其余 `uuid` 的 replay 补偿
- `batchUuids` 的 started/completed lifecycle

### 判断五：REPL 和 headless `print` 不能写成同一条 batching 规则

更稳的写法应该是：

- REPL 更像 same-mode dispatch
- headless `print` 更像 prompt-only turn coalescing

## 为什么这轮不并回 88

可以合并，但那会重新模糊两个主语：

- 88 讲的是 queue 保活、显式再入与 stranded message race
- 89 讲的是哪些命令能并进同一次 turn，以及并完后怎样补命令身份债

这两个层级不该揉成一页。

## 苏格拉底式自审

### 问：为什么这轮最先该拆 `workload` / `isMeta`，而不是继续写更多 queue 例外？

答：因为 queue 例外再多，也还是 88 的主语；而 workload/meta 一旦不拆，读者会直接把 batching 写成“都是 prompt 就并”。

### 问：为什么 replay / lifecycle 值得写，而不是留给内部实现层？

答：因为它决定了一个很关键的用户可见误判：一次 turn 并不等于前面那些命令的身份消失了。

### 问：为什么还要拉 REPL 来对照？

答：因为只有拉上 REPL 的 same-mode drain，读者才看得见 headless `print` 到底额外多守了哪些边界。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/89-canBatchWith、joinPromptValues、batchUuids、replayUserMessages、task-notification 与 orphaned-permission：为什么 headless print 的 prompt batching 不是普通批量出队.md`
- `bluebook/userbook/03-参考索引/02-能力边界/78-Headless print prompt batching and per-uuid replay 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/89-2026-04-06-headless print prompt batching 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小改动：

- 长文层只补 89
- 索引层只补 78
- 记忆层只补 89

不把 88-89 重新揉成一篇泛化的“headless queue & batching 总论”。

## 下一轮候选

1. 单独拆 `task-notification` 从 XML 解析、SDK 事件到模型 follow-up 的双重身份。
2. 单独拆 `workload` 在 headless `print`、cron、子任务里的传播与 attribution 厚度。
3. 单独拆 prompt batching 为什么和 `priority` 不是一条显式边界。
