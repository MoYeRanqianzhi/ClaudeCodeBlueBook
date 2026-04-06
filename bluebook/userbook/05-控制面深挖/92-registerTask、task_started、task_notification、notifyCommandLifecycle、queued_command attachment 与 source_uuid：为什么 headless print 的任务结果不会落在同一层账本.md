# `registerTask`、`task_started`、`task_notification`、`notifyCommandLifecycle`、queued_command attachment 与 `source_uuid`：为什么 headless print 的任务结果不会落在同一层账本

## 用户目标

91 页已经把 `task-notification` 的 close-signal family 拆开了：

- 带 `<status>` 的 terminal XML
- statusless ping
- direct `emitTaskTerminatedSdk(...)`

但如果继续往下看，读者又会被另一种“名字都差不多”的错觉带偏：

- `task_started` / `task_notification`、`notifyCommandLifecycle(started/completed)`、以及模型看到的 `<task-notification>` 内容，难道不都在表达同一件事？
- 如果任务结束了，为什么还会同时看到 task bookend、queued command lifecycle 和 attachment 内容三套痕迹？
- 为什么一套用 `task_id`，一套用 `uuid`，还有一套甚至只能靠 prompt 文本去重？
- 为什么 remote viewer 只认 `system/task_started` 与 `system/task_notification`，本地 `AppState.tasks` 却可以是空的？
- 为什么 `task-notification` 进入模型回合时，有时根本没有可用的 command `uuid`？

如果这些问题不拆开，读者就会把这里误写成：

- “任务结果无非就是换个名字落在同一套状态账本里。”

源码不是这样工作的。

## 第一性原理

更稳的提问不是：

- “这里记录了任务结果没有？”

而是五个更底层的问题：

1. 这套记录是按 `task_id` 记账，还是按 queued command `uuid` 记账？
2. 这套记录是在服务 SDK/宿主，还是在服务模型输入，还是在服务本地 queue 生命周期？
3. 这条记录能不能单独证明“任务完成了”，还是只能证明“某条命令被消费了”？
4. 如果某条 `task-notification` 没有 `uuid`，谁来负责它的身份账本？
5. remote / viewer / headless / TUI 看到的是同一本账，还是不同投影？

只要这五轴不先拆开，后续就会把：

- parallel ledgers for task result handling

误写成：

- one unified result state

## 第二层：这里至少有三套账本，不是一套

从源码往回压，至少要拆出三层：

1. 任务账本：`task_started` / `task_notification`，按 `task_id` 记
2. 命令账本：`notifyCommandLifecycle(started/completed)`，按 queued command `uuid` 记
3. 模型/转录账本：`queued_command` attachment、`origin.kind = task-notification`、以及 `<task-notification>` 内容本身

这三层都和“任务结果”有关，但不是同一个对象，更不能互相替代。

## 第三层：`task_started` / `task_notification` 是任务账本，主键是 `task_id`

`registerTask(...)` 在任务框架里做的事非常明确：

- 把 task 写进 `AppState.tasks`
- 如果不是 replacement resume，就 `enqueueSdkEvent({ subtype: 'task_started', task_id, ... })`

`emitTaskTerminatedSdk(...)` 也同样按：

- `task_id`
- `tool_use_id`
- `status`
- `summary`

来发 terminal `task_notification` close bookend。

`print.ts` 解析 terminal XML task-notification 时，最终生成的 SDK event 也是：

- `subtype: 'task_notification'`
- `task_id`

这说明这套账本在回答的是：

- 某个 task 是否开始 / 结束

而不是：

- 某条 queued command 是否已被 drain

## 第四层：`notifyCommandLifecycle(...)` 是命令账本，主键是 command `uuid`

`commandLifecycle.ts` 本身就把边界写得极窄：

- 只有 `uuid`
- 只有 `started | completed`

它不认识：

- `task_id`
- `status`
- `summary`
- `output_file`

所以它关心的根本不是任务状态，而是：

- 某条队列命令的消费生命周期

`print.ts` 在 headless drain 时会对 `batchUuids` 发：

- `notifyCommandLifecycle(uuid, 'started')`
- `notifyCommandLifecycle(uuid, 'completed')`

`query.ts` 在 TUI mid-turn drain 时，也会对真正被消费的 queued commands 做同样的事。

所以这套账本回答的是：

- 这条 queued command 有没有被 turn 消费

不是：

- 这个后台任务是否已经关闭 bookend

## 第五层：模型/转录账本记录的是“看见了什么内容”，不是前两套状态机

`query.ts` 会把：

- `prompt`
- `task-notification`

这两类 queued command 转成 attachments 喂给当前 turn。

`messages.ts` 还会在 `queued_command` attachment 上补一层 origin：

- 如果 `attachment.commandMode === 'task-notification'`
- 就 fallback 成 `{ kind: 'task-notification' }`

这说明模型/转录层真正关心的是：

- 这条内容如何作为附件进入消息流
- 在 transcript / brief / dedup / visibility 里怎么被解释

它既不是：

- task ledger

也不是：

- command lifecycle ledger

## 第六层：为什么 `task-notification` 特别容易暴露“三本账不是一本”

`task-notification` 比普通 prompt 更容易暴露三本账的分裂，因为它天然同时跨了三层：

### 任务层

- 后台 task 的开始/结束，要靠 `task_started` / `task_notification` bookend

### 队列层

- 如果它通过统一命令队列流动，还可能作为 queued command 被消费

### 模型层

- 最终 `<task-notification>` 内容又会作为 attachment / user-role-like envelope 被模型看见

所以它不是“一个对象三种显示”，而是：

- 三套账都可能围绕同一份任务结果记一笔

## 第七层：为什么有些 `task-notification` 连 command `uuid` 都没有

这是 92 最值钱的证据之一。

`REPL.tsx` 在 dedup queued `task-notification` attachments 时，注释明确写了：

- `source_uuid` is not set on task-notification QueuedCommands
- enqueuePendingNotification callers don't pass uuid
- 所以这里只能用 prompt text 去重

这句话直接说明：

- 并不是每条 `task-notification` 都有稳定的 queued-command `uuid`

也就进一步说明：

- 你不能指望 command lifecycle 那套账本去完整代表 task 结果

因为有些 `task-notification` 根本没带那本账的主键。

## 第八层：`query.ts` 也把两本账分开了

`query.ts` 的逻辑特别能说明问题：

- 它先把 `prompt` / `task-notification` 转成 attachments
- 然后只对那些真正被消费、并且带 `uuid` 的 queued command 记录 `notifyCommandLifecycle(...)`

这意味着：

- 附件进入模型回合
- 不等于 task ledger 自动更新
- 也不等于 command lifecycle 一定有完整账本

换句话说：

- attachment 被消费，是一层事实
- command `uuid` 被 started/completed，是另一层事实
- task `task_id` 被 bookend close，又是第三层事实

## 第九层：remote viewer 再次证明任务账本和本地任务状态不是一回事

`AppStateStore.ts` 对 remote viewer 的注释写得很直接：

- `remoteBackgroundTaskCount` 是 event-sourced from `system/task_started` and `system/task_notification` on the WS
- local `AppState.tasks` 在 viewer mode 一直是空的
- 因为真实 tasks 活在另一个进程

这条证据特别重要，因为它把“同一层账本”的直觉彻底打破了：

- 远端 viewer 可以只靠 SDK task bookend 维护任务计数
- 完全不需要本地 `AppState.tasks`

所以至少在宿主层面：

- task ledger
- local task store

就已经不是一回事。

## 第十层：为什么 92 不和 90/91 合并

90 讲的是：

- `task-notification` 为什么先喂 SDK，再喂模型

91 讲的是：

- 哪些 close signal 真能关单

92 继续往下后，问题已经换成：

- 这几套“看起来都在记录任务结果”的账本，为什么主键不同、消费者不同、可证明的事实也不同

前两页讲：

- 消费路径与 close family

这一页讲：

- ledger separation

主语已经变了，不该揉成一页。

## 第十一层：最常见的假等式

### 误判一：`task_started/task_notification` 和 `notifyCommandLifecycle` 在记同一件事

错在漏掉：

- 前者按 `task_id`
- 后者按 queued command `uuid`

### 误判二：模型看到 `<task-notification>`，就等于 task ledger 已经完整更新

错在漏掉：

- 模型附件账本只证明“内容被送进回合”，不自动证明任务账本或命令账本完成

### 误判三：所有 `task-notification` 都能靠 command `uuid` 追踪

错在漏掉：

- 一部分 queued `task-notification` 根本没有 `source_uuid`

### 误判四：remote viewer 看到的后台任务数，就是本地 `AppState.tasks` 的镜像

错在漏掉：

- 它是由 WS 上的 `task_started/task_notification` 事件驱动的另一套账本

### 误判五：这几层都是“任务状态”，所以可以混写

错在漏掉：

- 它们分别回答的是 task、command、attachment 三种不同问题

## 第十二层：稳定、条件与内部边界

### 稳定可见

- `task_started/task_notification` 是按 `task_id` 组织的任务账本。
- `notifyCommandLifecycle(...)` 是按 queued command `uuid` 组织的命令账本。
- attachment / transcript 层记录的是模型看到了什么内容，不等于前两套状态机。
- 这三套账本会围绕同一份任务结果留下痕迹，但不属于同一层。

### 条件公开

- 只有真正带 `uuid` 的 queued command，命令账本才有 started/completed 可记。
- 某些 `task-notification` 没有 `source_uuid`，只能在转录层按 prompt 文本去重。
- remote / viewer / headless / TUI 各自消费的账本厚度不同。

### 内部 / 实现层

- attachment fallback origin 的细节。
- replacement registerTask 时为什么跳过 duplicate `task_started`。
- 各宿主对 `AppState.tasks`、remoteBackgroundTaskCount、queued command attachments 的具体折叠方式。

## 第十三层：苏格拉底式自检

### 问：为什么这页最先该拆“主键”，而不是先拆 UI 展示？

答：因为一旦不先拆 `task_id` 和 `uuid`，所有 UI 投影都会被误解成同一套状态的不同显示。

### 问：为什么 `source_uuid` 缺失值得进正文？

答：因为它直接证明“命令账本并不能完整覆盖 task-notification 世界”，这不是实现细节，而是边界证据。

### 问：为什么 remote viewer 的例子这么关键？

答：因为它证明甚至连本地 task store 都不是唯一真账本，SDK task 事件流本身就可以独立构成宿主态。

## 源码锚点

- `claude-code-source-code/src/utils/task/framework.ts`
- `claude-code-source-code/src/utils/sdkEventQueue.ts`
- `claude-code-source-code/src/utils/commandLifecycle.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/query.ts`
- `claude-code-source-code/src/utils/messages.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/state/AppStateStore.ts`
