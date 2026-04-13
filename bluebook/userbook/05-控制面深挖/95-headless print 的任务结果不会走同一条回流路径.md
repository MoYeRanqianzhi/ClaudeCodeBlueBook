# `enqueuePendingNotification`、`emitTaskTerminatedSdk`、`print.ts` parser、No continue 与 foreground done：为什么 headless print 的任务结果不会走同一条回流路径

## 用户目标

94 页已经把 `task_progress / workflow_progress` 从模型图层里剥出去了。

但继续再往下一层看，读者还会碰到一组特别容易被“名字一样”误导的问题：

- 为什么有些任务结果会进 XML queue，然后被 `print.ts` 解析，再继续 fall through 到 `ask()`？
- 为什么另一些任务结果只发一个 SDK `task_notification`，明确不触发 XML parser，也不触发 LLM loop？
- 为什么同样叫“task result”，backgrounded 路和 foregrounded 路的回流语义完全不同？
- 为什么源码有时明确 suppress XML，然后要求 direct `emitTaskTerminatedSdk(...)`？

如果这些问题不拆开，读者就会把这里误写成：

- “任务结束以后系统总会沿着同一条路径把结果回流回来，只是多一层少一层包装。”

源码不是这样设计的。

这里分的是单次 task result 的 runtime return path：XML queue、SDK `task_notification` event 与 model re-entry 只是同一条回流轴上的不同节点，不是 generic `resume / continue` source 或 bridge continuity 的来源问题。

## 第一性原理

更稳的提问不是：

- “这里是不是 task_notification？”

而是五个更底层的问题：

1. 这条结果需要不需要重新进入模型回合？
2. 宿主是不是已经在前台看着它，不需要再把结果折回 prompt 面？
3. 这条终态会不会再经过 XML queue？
4. SDK close bookend 应该由谁负责发？
5. 这次 result return path 面向的是 host、model，还是两者？

只要这五轴不先拆开，后续就会把：

- multiple task-result return paths

误写成：

- one generic return path

## 第二层：至少有两条任务结果回流路径，不是一条

从源码往回压，至少要拆出两条主路径：

### XML re-entry 路

- 任务结果先被包装成 `<task-notification>` XML
- `enqueuePendingNotification(..., mode: 'task-notification')`
- `print.ts` 解析 XML
- 在 terminal 情况下给 SDK consumer 发 `task_notification`
- 然后不 `continue`，继续 fall through 到 `ask()`

### direct SDK terminal 路

- 不走 XML queue
- 直接 `enqueueSdkEvent(...)` 或 `emitTaskTerminatedSdk(...)`
- 通过 `drainSdkEvents()` 落到输出流
- 不触发 `print.ts` XML parser
- 不触发 LLM loop

所以这里首先不是：

- “同一条路上的不同阶段”

而是：

- “不同语义前提下的两条回流路径”

## 第三层：backgrounded 路径为什么要走 XML re-entry

`print.ts` 对 queued `task-notification` 的注释已经给了最核心的答案：

- Emit an SDK system event for SDK consumers
- then fall through to `ask()` so the model sees the agent result and can act on it

这说明 XML re-entry 路解决的是：

- 模型还需要看见这条结果
- 会话主循环还要据此继续行动

这也是为什么任务框架和 background session 完成路径会选择：

- 生成 `<task-notification>` XML
- `enqueuePendingNotification({ value: message, mode: 'task-notification' })`

比如：

- `utils/task/framework.ts` 的通用任务通知
- `LocalMainSessionTask` 的 background session completion

这些路径的共同点是：

- 结果不仅要让 host 知道
- 还要重新进入会话主循环

## 第四层：foreground direct SDK 路为什么故意不进 XML parser / LLM loop

`AgentTool.tsx` 的注释把这件事说得非常直白：

- foreground agent 完成且没有 backgrounded 时
- goes through `drainSdkEvents()`
- does NOT trigger the `print.ts` XML task_notification parser
- does NOT trigger the LLM loop

`LocalMainSessionTask` 的 foreground path 也写得很明白：

- Foregrounded: no XML notification (TUI user is watching)
- but SDK consumers still need to see the `task_started` bookend close

这里最重要的第一性原理其实是：

- 用户/宿主已经在前台看着，不需要再把结果折回模型 prompt 面

所以 foreground direct SDK 路解决的是：

- host bookend / panel / counter 需要关单

而不是：

- 再喂模型一次同样的结果

## 第五层：为什么 suppress XML 之后必须 direct emit

还有第三类关键路径，不是纯 foreground，也不是普通 background XML：

- 代码显式 suppress / pre-set 了 XML notification

这时源码要求的不是“那就算了”，而是：

- direct `emitTaskTerminatedSdk(...)`

`stopTask.ts` 的注释非常清楚：

- suppressing the XML notification also suppresses `print.ts`'s parsed SDK event
- so emit it directly so SDK consumers see the task close

`inProcessRunner.ts` 也同样写了：

- `notified:true` pre-set -> no XML notification -> `print.ts` won't emit the SDK task_notification
- close the `task_started` bookend directly

这说明 direct emit 在这类路径上的职责是：

- 接管本来会由 XML parser 负责的 SDK close 账

而不是：

- 再多补一层保险

## 第六层：为什么两条路不能混成“一条更稳的双发路径”

这页最不该写错的一句，是 anti-double-emit 的含义。

`sdkEventQueue.ts` 的注释已经把边界钉死：

- 如果路径既会走 `enqueuePendingNotification-with-<task-id>`
- 又 direct `emitTaskTerminatedSdk(...)`
- `print.ts` 会解析 XML 成同一个 SDK event
- 两边都发，就会 double-emit

所以系统的要求从来不是：

- “XML 和 direct SDK 两边都发，最稳”

而是：

- “根据 return path 选择唯一负责的 close 通道”

## 第七层：同一类任务也可能分叉成不同回流路径

最值钱的证据之一，其实不是“不同任务类型不同”，而是：

- 同一类任务，也会因为 foreground/background/suppressed 条件不同，走不同回流路径

最清楚的例子就是 `LocalMainSessionTask`：

### backgrounded 完成

- 生成 `<task-notification>` XML
- `enqueuePendingNotification(...)`
- 允许 `print.ts` 解析并在必要时再喂模型

### foregrounded 完成

- 不发 XML
- direct `emitTaskTerminatedSdk(...)`
- 只为了让 SDK consumer 看到 close bookend

这说明回流路径的主导维度不是：

- 任务类名本身

而是：

- 当前结果是否还需要回到模型主循环

## 第八层：这和 90-94 的关系

90 讲的是：

- `task-notification` 为什么是 dual-consumer envelope

91 讲的是：

- close-signal family

92 讲的是：

- 多账本分裂

93 讲的是：

- SDK triad vs queue lifecycle

94 讲的是：

- `task_progress/workflow_progress` 属于 host projection

95 再往下一层后，主语已经换成：

- 同一份 task result 究竟选哪条 return path

也就是：

- XML re-entry path
- direct SDK close path

的分叉条件。

## 第九层：最常见的假等式

### 误判一：所有 task result 最终都会重新进入模型回合

错在漏掉：

- foreground direct SDK `task_notification` 明确不触发 LLM loop

### 误判二：所有 terminal close 都应该优先走 XML，再由 `print.ts` 解析

错在漏掉：

- foreground / suppressed 路径本来就不会再走 XML queue

### 误判三：direct `emitTaskTerminatedSdk(...)` 只是 XML 路的补发版

错在漏掉：

- 它在某些路径上是唯一 close 通道

### 误判四：backgrounded/foregrounded 只影响展示，不影响回流路径

错在漏掉：

- 是否回到模型主循环，正是回流路径分叉的根因

### 误判五：双发更稳

错在漏掉：

- 双发会直接污染 SDK close 状态机

## 第十层：稳定、条件与内部边界

### 稳定可见

- task result 至少有 XML re-entry 和 direct SDK terminal 两条回流路径。
- XML re-entry 路会让结果重新进入 `print.ts` parser，并继续 fall through 到 `ask()`。
- direct SDK terminal 路只服务宿主/SDK close，不触发 XML parser，也不触发 LLM loop。
- XML 和 direct close 不能双发。

### 条件公开

- backgrounded / foregrounded / suppressed XML 等条件会改变结果回流路径。
- 某些路径需要模型继续看见结果，因此走 XML re-entry。
- 某些路径用户/宿主已在前台观察，只需要 close bookend，因此走 direct SDK 路。

### 内部 / 实现层

- `notified:true`、suppress flag、foreground registration 等具体分支。
- 哪些任务类型默认生成 XML envelope，哪些路径偏向 direct SDK emit。
- `drainSdkEvents()` 与 heldBackResult / queue drain 的具体排序。

## 第十一层：苏格拉底式自检

### 问：为什么这页最先该拆 foreground/background，而不是继续枚举 task 类型？

答：因为决定回流路径的关键不是任务类型名字，而是“结果要不要再回到模型回合”。

### 问：为什么 `LocalMainSessionTask` 这么值钱？

答：因为它在同一任务家族内部同时暴露了 XML re-entry 和 direct SDK close 两种路径。

### 问：为什么 anti-double-emit 还要在这页再强调一次？

答：因为一旦开始谈“多条回流路径”，读者最自然的误判就是“那就两条都走更保险”。这恰好是源码明确要避免的。

## 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/utils/sdkEventQueue.ts`
- `claude-code-source-code/src/utils/task/framework.ts`
- `claude-code-source-code/src/tasks/LocalMainSessionTask.ts`
- `claude-code-source-code/src/tasks/stopTask.ts`
- `claude-code-source-code/src/utils/swarm/inProcessRunner.ts`
- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx`
