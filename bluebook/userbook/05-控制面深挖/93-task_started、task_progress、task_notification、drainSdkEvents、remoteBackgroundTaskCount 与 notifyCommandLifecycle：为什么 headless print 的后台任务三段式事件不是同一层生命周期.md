# `task_started`、`task_progress`、`task_notification`、`drainSdkEvents`、`remoteBackgroundTaskCount` 与 `notifyCommandLifecycle`：为什么 headless print 的后台任务三段式事件不是同一层生命周期

## 用户目标

92 页已经把一件事钉死了：

- 任务结果不会落在同一层账本

但如果再往下一层看，读者仍然很容易把另一组很像的对象写成一层：

- `task_started`
- `task_progress`
- terminal `task_notification`
- queued command 的 `notifyCommandLifecycle(started/completed)`

尤其在 headless `print` 里，你会同时看到：

- `drainSdkEvents()`
- queued `task-notification` command
- `<task-notification>` 进入模型回合
- remote `background` counter 被更新

如果这些不继续拆，读者就会自然把它们压成一句：

- “后台任务开始、进展、结束，系统都在用同一条生命周期流表达。”

源码不是这样设计的。

## 第一性原理

更稳的提问不是：

- “这里是不是任务生命周期事件？”

而是五个更底层的问题：

1. 这条信号是在服务宿主/SDK，还是在服务模型回合？
2. 它的主键是 `task_id`，还是 queued command `uuid`？
3. 它描述的是 task runtime 三段式，还是 queued command 被 drain 的两段式？
4. 它会不会进入 LLM loop？
5. 它是为了维护 background counter / panel / host 状态，还是为了驱动模型继续思考？

只要这五轴不先拆开，后续就会把：

- SDK task triad plus queue-side lifecycle

误写成：

- one unified lifecycle

## 第二层：这里其实是“两条时间轴”，不是一条

从源码往回压，至少要拆出两条不同时间轴：

### 任务三段式时间轴

- `task_started`
- `task_progress`
- terminal `task_notification`

这是：

- 按 `task_id` 记的 SDK / host 任务事件流

### 队列两段式时间轴

- `notifyCommandLifecycle(uuid, 'started')`
- `notifyCommandLifecycle(uuid, 'completed')`

这是：

- 按 queued command `uuid` 记的命令消费事件流

所以最先要钉死的一句是：

- 一个是 task runtime triad
- 一个是 queue consumption pair

不是：

- 同一条生命周期的不同命名

## 第三层：`task_started` / `task_progress` / terminal `task_notification` 是按 `task_id` 的宿主事件流

`sdkEventQueue.ts` 已经把这组对象的类型拆得很干净：

- `TaskStartedEvent`
- `TaskProgressEvent`
- `TaskNotificationSdkEvent`

而且字段也明确表明它们在记 task，不在记 command：

- `task_id`
- `tool_use_id`
- `description`
- `usage`
- `last_tool_name`
- `workflow_progress`
- `status`

这条流回答的是：

- 某个后台 task 何时注册
- 何时产生进展
- 何时 terminal close

所以它更接近：

- host-observable task runtime

## 第四层：`task_progress` 特别能说明“这不是模型回合事件”

`emitTaskProgress(...)` 的注释写得很直接：

- 它发的是 `task_progress` SDK event
- 共享给 background agents 与 workflows
- 参数都是已经计算好的 primitives

而 `print.ts` 在主循环里也特别照顾这类事件：

- `drainSdkEvents()` 会先于 command queue 被 flush
- 注释明确说这样做是为了让 `task_started/task_progress` 先于 `task_notification` 出现在输出流上
- 另一个注释又说：这样 background agent progress 会 real-time streamed，而不是等到 result 才一起批出来

这说明 `task_progress` 的主语根本不是：

- “模型现在看到了一条新内容”

而是：

- “宿主现在要实时看到后台任务进展”

## 第五层：foreground direct SDK `task_notification` 再次证明这组三段式不等于 XML queue

`AgentTool.tsx` 里有一段非常关键的注释：

- foreground agent 完成而且没有 backgrounded 时
- 会直接 `enqueueSdkEvent({ subtype: 'task_notification', ... })`
- goes through `drainSdkEvents()`
- does NOT trigger the `print.ts` XML task_notification parser
- does NOT trigger the LLM loop

这条证据非常值钱，因为它说明：

- terminal `task_notification` 这个名字本身，并不保证它会走模型可见的 XML envelope

它也可以只是：

- SDK task triad 的 closing bookend

所以更稳的写法是：

- terminal `task_notification` 至少分宿主 bookend 路和 XML re-entry 路

## 第六层：`notifyCommandLifecycle(...)` 记的是 queued command 被消费，不是 task runtime 进展

`commandLifecycle.ts` 的接口极窄：

- 只有 `uuid`
- 只有 `started/completed`

它完全不知道：

- `task_progress`
- `status`
- `workflow_progress`
- `last_tool_name`

这说明它不在描述：

- 任务过程

它只在描述：

- 某条 queued command 什么时候进入、什么时候退出一次消费路径

所以你不能把：

- `task_progress`

和：

- `notifyCommandLifecycle(started/completed)`

看成同一套状态的不同厚度。

前者是：

- task runtime stream

后者是：

- command drain bookkeeping

## 第七层：`print.ts` 自己就在主动把两条流错开

`print.ts` 的 do-while 主循环注释几乎已经是本页明文答案：

- 先 `drainSdkEvents()`，把 `task_started/task_progress` 冲到前面
- 再 `await drainCommandQueue()`
- 当 background agents 完成后，它们的 notifications 入队，循环再重跑

另一个注释还说：

- progress events precede `task_notification` on the stream

这说明在 headless `print` 的设计里：

- 实时 SDK 进展流
- queued command / model follow-up 流

不是自然混在一起，而是被刻意分层排序。

如果它们真是同一层生命周期，这种“先冲 SDK triad，再 drain queue”的排序就没有必要。

## 第八层：remote host 侧再次证明这组 triad 是宿主态，不是本地 task store 或模型附件

`useRemoteSession.ts` 和 `AppStateStore.ts` 给了这页一个很强的宿主侧外证：

- `remoteBackgroundTaskCount` 是由 WS 上的 `task_started/task_notification` 驱动
- `task_progress` 直接 return，不参与计数
- 这些 signals 被标注为 status signals, not renderable messages
- viewer 模式下本地 `AppState.tasks` 为空，真实 tasks 在另一个进程

这说明 remote host 关心的是：

- task triad 是否能驱动 background counter

而不是：

- queued command lifecycle
- attachment 内容去重
- 本地 task store 镜像

所以 triad 这条流的宿主定位非常明确：

- host status projection

## 第九层：为什么 93 不和 92 合并

92 回答的是：

- 为什么 task ledger、command ledger、attachment ledger 不是同一本账

93 继续往下后，问题已经变成：

- 为什么 `task_started/task_progress/task_notification` 这组三段式 SDK 事件本身，也不能和 queue-side lifecycle 混写

92 讲：

- ledger separation

93 讲：

- SDK event triad vs queue lifecycle

主语已经更窄，也更靠近 runtime 流本身，不该揉成一页。

## 第十层：最常见的假等式

### 误判一：`task_started/task_progress/task_notification` 就是任务版的 `notifyCommandLifecycle`

错在漏掉：

- 前者按 `task_id`
- 后者按 command `uuid`
- 前者是三段式，后者是两段式

### 误判二：所有 terminal `task_notification` 都会进入模型回合

错在漏掉：

- foreground direct SDK `task_notification` 明确不会触发 XML parser，也不会触发 LLM loop

### 误判三：`task_progress` 也是一种模型可见的结果提示

错在漏掉：

- 它首先是 real-time streamed SDK progress event
- `useRemoteSession` 甚至把它当 non-renderable status signal 直接 return

### 误判四：remote background counter 是本地 task store 或模型附件的投影

错在漏掉：

- 它是 event-sourced from `task_started/task_notification`

### 误判五：既然 `print.ts` 都会处理这些对象，那它们自然在同一层

错在漏掉：

- `print.ts` 恰恰是在主动把 SDK triad 与 command queue 错序分层

## 第十一层：稳定、条件与内部边界

### 稳定可见

- `task_started/task_progress/terminal task_notification` 构成按 `task_id` 组织的 SDK task triad。
- `notifyCommandLifecycle(started/completed)` 构成按 command `uuid` 组织的 queue consumption pair。
- 这两条时间轴不是同一层生命周期。
- 一部分 terminal `task_notification` 只服务 SDK/host，不进入 LLM loop。

### 条件公开

- 是否走 XML parser / LLM loop，取决于该 terminal `task_notification` 是 direct SDK 路还是 XML re-entry 路。
- remote host 会消费 `task_started/task_notification` 做 background count，但忽略 `task_progress` 的 renderable surface。
- `print.ts` 会刻意把 `task_started/task_progress` 冲在 queued command 前面。

### 内部 / 实现层

- `workflow_progress` 的具体折叠方式。
- foreground / background / remote agent 各自产生 triad 的细分路径。
- queued command lifecycle listener 的具体宿主绑定。

## 第十二层：苏格拉底式自检

### 问：为什么这页最先该拆 `task_progress`，而不是继续围绕 `task_notification` 写变体？

答：因为 `task_progress` 最能暴露“这是一条宿主实时事件流，而不是模型输入流”。

### 问：为什么 foreground direct SDK `task_notification` 这么关键？

答：因为它直接打破了“terminal task_notification 一定会触发模型回合”的直觉。

### 问：为什么 remote counter 值得写进正文？

答：因为它从宿主侧再次证明 triad 是 host status projection，而不是本地任务账本或 attachment 投影。

## 源码锚点

- `claude-code-source-code/src/utils/sdkEventQueue.ts`
- `claude-code-source-code/src/utils/task/sdkProgress.ts`
- `claude-code-source-code/src/utils/task/framework.ts`
- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/utils/commandLifecycle.ts`
