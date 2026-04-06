# `task-notification`、`<task-id>`、`<status>`、`emitTaskTerminatedSdk`、`enqueuePendingNotification` 与 fall through to `ask`：为什么 headless print 的 `task-notification` 不是普通进度提示

## 用户目标

89 页已经把一件事讲清了：

- `task-notification` 不能和普通 `prompt` 混批

但如果继续往下看，读者很容易又掉进另一个误区：

- 既然它叫 `task-notification`，那它是不是只是一个给用户看的进度提示？
- 为什么 `print.ts` 要先把它解析成 SDK `task_notification` system event，然后又故意不 `continue`，还要把它继续送进 `ask()`？
- 为什么有些 `<task-notification>` 带 `<status>`，有些又故意不带？
- 为什么 `emitTaskTerminatedSdk(...)` 和 `enqueuePendingNotification(..., mode: 'task-notification')` 两条路同时存在，却又不能双发？
- 为什么源码文档还会强调：它“看起来像 user-role message，但其实不是”？

如果这些问题不拆开，读者就会把这里误写成：

- “task-notification 就是一种背景任务进度提示，最多顺手给模型看一眼。”

源码不是这样设计的。

## 第一性原理

更稳的提问不是：

- “这里是不是任务通知？”

而是五个更底层的问题：

1. 这条对象首先是 queued command、XML envelope、SDK event，还是模型输入？
2. 哪些消费者在读它，先后顺序是什么？
3. `<status>` 在这里是可有可无的文本字段，还是 terminal bookend 的开关？
4. `emitTaskTerminatedSdk(...)` 和 XML 通道是互补，还是重复？
5. TUI / coordinator / headless `print` 对这类对象的消费合同是一致的，还是分裂的？

只要这五轴不先拆开，后续就会把：

- dual-consumer task result envelope

误写成：

- ordinary progress hint

## 第二层：`task-notification` 是“双重消费者合同”，不是单层通知

headless `print` 对 `task-notification` 的核心处理链可以先压成三句：

1. 它先作为 `mode: 'task-notification'` 的 queued command 被 enqueue
2. `print.ts` 在 drain 时会先解析 XML，并在 terminal 条件满足时发 SDK `task_notification` event
3. 然后它不会停在 SDK 层，而是继续 fall through 到 `ask()`，让模型也看见这条结果

所以它不是：

- 单层通知

而是：

- 同一份任务结果，被 SDK consumer 和模型各消费一层

## 第三层：源头就不是“普通文本”，而是结构化 XML envelope

任务框架侧把这件事写得非常直白。

`enqueueTaskNotification(...)` 会生成：

- `<task-notification>`
- `<task-id>`
- 可选 `<tool-use-id>`
- `<task-type>`
- `<output-file>`
- `<status>`
- `<summary>`

这样的 XML，再以：

- `enqueuePendingNotification({ value: message, mode: 'task-notification' })`

送进统一命令队列。

`LocalAgentTask`、`LocalMainSessionTask`、`RemoteAgentTask` 等任务路径也都沿用这类 envelope。

所以在 queue 里，这东西虽然长得像一段字符串，但它从一开始承载的就是：

- 任务身份
- 终态状态
- 输出文件
- 摘要
- 可选 usage / result / worktree 等任务元数据

不是：

- 任意一段普通提示词文本

## 第四层：`print.ts` 先发 SDK system event，再故意 fall through 给模型

`print.ts` 对 `task-notification` 的注释已经把设计意图写明了：

- Task notifications arrive when background agents complete
- Emit an SDK system event for SDK consumers
- then fall through to ask() so the model sees the agent result and can act on it
- this matches TUI behavior regardless of coordinator mode

这说明 headless `print` 里这条对象有两个明确消费者：

### 第一层消费者：SDK / host / IDE 类消费者

`print.ts` 会从 XML 里解析：

- `task-id`
- `tool-use-id`
- `output-file`
- `status`
- `summary`
- `usage`

然后在 terminal 条件满足时 `output.enqueue({ type: 'system', subtype: 'task_notification', ... })`。

### 第二层消费者：模型本身

紧接着代码明确写了：

- `// No continue -- fall through to ask() so the model processes the result`

所以这里不是“SDK 看完就结束”，而是：

- SDK 看一层
- 模型再看一层

## 第五层：`<status>` 不是装饰字段，而是 terminal bookend 开关

这里最容易被写错。

`print.ts` 只会在：

- XML 里真的存在 `<status>`

时才发 SDK `task_notification` system event。

注释给的原因非常直接：

- `<status>` 表示 terminal notification
- 没有 `<status>` 的 `enqueueStreamEvent` 是 progress ping
- 如果把 statusless 事件也当 terminal close 发出去，会默认成 `completed`
- 这样会把还没结束的任务错误关单

`LocalShellTask` 也在源头注释了同一个约束：

- 某些 stall / interactive-input 检测通知故意不带 `<status>`
- 因为 `print.ts` 把 `<status>` 视为 terminal signal
- statusless notification 会被 SDK emitter 跳过，只作为 progress ping

所以这层真正该写的是：

- `<status>` 决定“能不能给 SDK consumer 关任务账”

不是：

- “有没有 status 只是文本更完整一点”

## 第六层：`emitTaskTerminatedSdk(...)` 和 XML 通道是互补关系，不是双保险重复发

`sdkEventQueue.ts` 的注释把这层讲得很透：

- `emitTaskTerminatedSdk(...)` 用于那些“任务进入 terminal，但不会再走 enqueuePendingNotification-with-<task-id>”的路径
- 因为 `print.ts` 解析 XML 也会生成同一个 SDK event
- 如果两边都发，就会 double-emit

这解释了为什么源码同时保留两条路：

### XML 路

- 适合那些确实会把 `<task-notification>` 放进统一命令队列、再由 `print.ts` 解析的路径

### direct SDK bookend 路

- 适合那些抑制了 XML notification、或 kill / abort / foreground path 不再经过 XML 队列的路径

所以两者不是：

- 谁都发一遍更安全

而是：

- 谁负责 terminal close，要看这条任务结果最后走不走 XML queue

## 第七层：这和 TUI / coordinator 的合同不是割裂的，而是同构

`print.ts` 注释已经明确写了：

- this matches TUI behavior where useQueueProcessor always feeds notifications to the model regardless of coordinator mode

而 `query.ts` 的主循环也能看到同样的合同：

- main thread / subagent 会按各自 agent scope 抓 queued commands
- `prompt` 和 `task-notification` 都会被转成 attachments 送进当前 turn
- 被实际消费的 `prompt` / `task-notification` command 会记录 lifecycle

另外，`coordinatorMode.ts` 甚至直接提醒模型：

- worker results arrive as user-role messages containing `<task-notification>` XML
- they look like user messages but are not

这三个锚点合在一起说明：

- `task-notification` 被“再喂给模型”不是 headless 特例
- 它是跨 TUI / coordinator / headless 都成立的一条 interaction contract

## 第八层：为什么它不是普通进度提示

如果它只是普通进度提示，那么：

- SDK consumer 消费完就够了
- 不需要继续送进 `ask()`
- 不需要 coordinator prompt 专门提醒模型识别 `<task-notification>` 开头
- 也不需要在 `query.ts` 里把它当 attachments 喂进当前 turn

源码恰好反着做了。

这说明 `task-notification` 的设计目标不是：

- “展示一下后台任务状态”

而是：

- “把后台任务结果重新折返进会话主循环，让宿主和模型都能据此继续行动”

## 第九层：这对使用者意味着什么

从使用层往回看，这套设计会产生四个重要表象：

1. 后台 agent / shell / main session 完成时，你看到的不只是 UI 提示，而是一条会重新影响后续模型行为的结果信号。
2. SDK consumer 可以靠 `task_notification` system event 更新任务状态、面板或徽标。
3. 模型仍会看到同一份结果，因此能继续总结、接续、派生下一步动作。
4. 并非所有 `task-notification` 都会关任务；没有 `<status>` 的 statusless ping 只是一类进度/阻塞提示。

所以“同样叫 task-notification”内部其实至少分两类：

- terminal close bookend
- statusless progress / stall signal

## 第十层：为什么 90 不和 89 合并

89 讲的是：

- 为什么 `task-notification` 不能和普通 prompt 混批
- 为什么它要单发

90 继续往下以后，问题已经变成：

- 这条单发对象为什么既喂 SDK，又喂模型
- `<status>` 为什么决定 SDK close 语义
- direct SDK bookend 和 XML queue 为什么不能双发

前者讲：

- batching boundary

后者讲：

- dual-consumer semantics

主语不同，不该揉成一页。

## 第十一层：最常见的假等式

### 误判一：`task-notification` 就是后台进度提示

错在漏掉：

- 它还会 fall through 到 `ask()`，重新影响模型后续行为

### 误判二：有 XML 就一定会发 SDK close event

错在漏掉：

- 只有带 `<status>` 的 terminal notification 才会发 close bookend

### 误判三：`emitTaskTerminatedSdk(...)` 和 XML 路径一起发更稳

错在漏掉：

- 两边都发会 double-emit

### 误判四：它在 headless 里才会回流给模型

错在漏掉：

- `print.ts` 明说这是在对齐 TUI behavior
- `query.ts` 也把 `task-notification` 当 attachments 喂进当前 turn

### 误判五：它看起来像 user-role message，所以就是普通 user message

错在漏掉：

- `coordinatorMode.ts` 明确提醒：它看起来像，但不是

## 第十二层：稳定、条件与内部边界

### 稳定可见

- `task-notification` 不是普通进度提示，而是会被 SDK consumer 和模型双重消费的任务结果 envelope。
- 带 `<status>` 的 terminal notification 会转换成 SDK `task_notification` system event。
- 同一对象在 SDK 层消费后不会终止，还会继续 fall through 给模型处理。
- `emitTaskTerminatedSdk(...)` 与 XML queue 路径是互补关系，不应双发。

### 条件公开

- 只有存在 `<status>` 时，`print.ts` 才会发 terminal SDK event。
- statusless notification 仍可能进入模型，但不会给 SDK consumer 关任务。
- 哪条任务终态走 XML queue，哪条直接走 `emitTaskTerminatedSdk(...)`，取决于具体任务路径是否抑制了 XML notification。

### 内部 / 实现层

- XML 各字段的精确解析方式。
- `killed -> stopped` 的状态归一化。
- `<usage>`、`<result>`、`<worktree>` 等可选块的细节。
- agentId / main-thread / subagent 的具体 queue drain 作用域。

## 第十三层：苏格拉底式自检

### 问：为什么一定要强调“先给 SDK，再给模型”？

答：因为这正是它不等于普通进度提示的根本证据。普通提示只需展示；这类对象还要驱动后续推理。

### 问：为什么 `<status>` 值得单独拆，不只是顺手提一句？

答：因为它直接决定“SDK 是否会把任务关单”。这不是文本层区别，而是运行时合同。

### 问：为什么还要引入 `emitTaskTerminatedSdk(...)`？

答：因为不把互补路径讲清，读者就会天然以为“XML 和 direct SDK emit 同时发更安全”，而源码明确说那会 double-emit。

### 问：为什么这一页还要拉 TUI / coordinator 对照？

答：因为只有对照后，读者才看得见这不是某个 headless 特化分支，而是一条跨宿主的统一任务结果回流协议。

## 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/utils/task/framework.ts`
- `claude-code-source-code/src/tasks/LocalAgentTask/LocalAgentTask.tsx`
- `claude-code-source-code/src/tasks/LocalMainSessionTask.ts`
- `claude-code-source-code/src/tasks/LocalShellTask/LocalShellTask.tsx`
- `claude-code-source-code/src/utils/sdkEventQueue.ts`
- `claude-code-source-code/src/query.ts`
- `claude-code-source-code/src/coordinator/coordinatorMode.ts`
