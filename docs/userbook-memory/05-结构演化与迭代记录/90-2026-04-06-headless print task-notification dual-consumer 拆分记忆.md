# headless print task-notification dual-consumer 拆分记忆

## 本轮继续深入的核心判断

89 已经把 `task-notification` 为什么不能混进普通 prompt batch 讲清了一层。

下一步最自然不是继续讲 batching，而是继续往下压到：

- `task-notification` 为什么要先喂 SDK
- 又为什么不能停在 SDK
- 为什么还要继续 fall through 给模型

因为这才是“它不是普通进度提示”的真正证据。

## 为什么这轮必须把 dual-consumer 语义单列

如果不单列，读者会把 89 的结论停在：

- `task-notification` 是一种特殊的单发命令

但更深一层真正关键的事实是：

- 它不是只发给一个消费者
- 它是一份被 SDK consumer 和模型双重消费的任务结果 envelope
- `<status>` 还进一步决定了它是不是 terminal close bookend

## 本轮最关键的新判断

### 判断一：XML queue ingress 只是入口，不是终点

`enqueuePendingNotification(..., mode: 'task-notification')` 只是把 envelope 送进统一命令队列。

### 判断二：`print.ts` 对它的核心合同是“先 SDK，后模型”

这轮最值钱的一句应该写成：

- emit SDK event, then fall through to `ask()`

### 判断三：`<status>` 是 terminal gate，不是装饰字段

没有 `<status>` 的 statusless ping 不能拿来给 SDK consumer 关任务。

### 判断四：`emitTaskTerminatedSdk(...)` 和 XML 解析不是双保险重复发

它们是互补路径；两边都发会 double-emit。

### 判断五：这不是 headless 的偶发分支，而是跨 TUI / coordinator / headless 的统一结果回流合同

所以 90 需要显式拉上 `query.ts` 与 `coordinatorMode.ts` 做对照。

## 为什么这轮不并回 89

89 讲的是：

- 为什么 `task-notification` 不能混批

90 讲的是：

- 为什么它既喂 SDK，又喂模型
- 为什么 `<status>` 决定 SDK close 语义
- 为什么 direct SDK emit 与 XML queue 是互补关系

这两个主语不能揉在一起。

## 苏格拉底式自审

### 问：为什么这轮最先该拆 `<status>`，而不是先写更多任务来源？

答：因为 `<status>` 一旦不拆，读者就看不见“终态关单”和“普通进度 ping”之间的运行时边界。

### 问：为什么必须写 `emitTaskTerminatedSdk(...)`，不然会怎样？

答：不写它，读者就会自然脑补“XML 和 direct emit 一起发更安全”，这会直接把源码的 anti-double-emit 合同写反。

### 问：为什么还要拉 coordinator 提示词？

答：因为那是最直接的外证：源码甚至要专门提醒模型“它看起来像 user message，但其实不是”。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/90-task-notification、<task-id>、<status>、emitTaskTerminatedSdk、enqueuePendingNotification 与 fall through to ask：为什么 headless print 的 task-notification 不是普通进度提示.md`
- `bluebook/userbook/03-参考索引/02-能力边界/79-Headless print task-notification dual-consumer semantics 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/90-2026-04-06-headless print task-notification dual-consumer 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小改动：

- 长文层只补 90
- 索引层只补 79
- 记忆层只补 90

不把 89-90 重新揉成“task-notification 总论”。

## 下一轮候选

1. 单独拆 `emitTaskTerminatedSdk(...)` 与 task runtime 里的 anti-double-emit 家族。
2. 单独拆 statusless stall ping、progress ping 与 terminal close 三类 `task-notification`。
3. 单独拆 coordinator mode 提示词里 `<task-notification>` 的“看起来像 user message，但其实不是”语义后果。
