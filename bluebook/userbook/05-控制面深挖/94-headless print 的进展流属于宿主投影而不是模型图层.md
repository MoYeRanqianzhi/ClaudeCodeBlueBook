# `task_progress`、`workflow_progress`、`drainSdkEvents`、`useRemoteSession`、`PhaseProgress` 与 removed `task_progress` attachment：为什么 headless print 的进展流属于宿主投影而不是模型图层

## 用户目标

93 页已经把后台任务的 SDK triad 和 queue lifecycle 拆开了：

- `task_started / task_progress / task_notification` 是一条 triad
- `notifyCommandLifecycle(started/completed)` 是另一条 pair

但继续往下一层看，读者还是很容易把 `task_progress` 想成：

- “另一种会被模型看见的结果消息”

尤其当你看到：

- `task_progress`
- `workflow_progress`
- `drainSdkEvents()`
- `remoteBackgroundTaskCount`
- `PhaseProgress`

这些名字都围着“进展”打转时，很容易自然滑向一个错误结论：

- “后台任务的进展本质上和 `<task-notification>` 一样，只是展示厚度不同。”

源码不是这样设计的。

## 第一性原理

更稳的提问不是：

- “这里有没有进展事件？”

而是五个更底层的问题：

1. 这条进展流首先是在服务宿主面板，还是在服务模型回合？
2. `workflow_progress` 是给模型看的语义块，还是给 host 叠相位树用的 delta？
3. `task_progress` 会不会像 queued command 一样进入 transcript / attachment？
4. 为什么 `print.ts` 要在 command queue 前先 flush 这条流？
5. remote/session/viewer 消费它时，关心的是内容渲染，还是状态投影？

只要这五轴不先拆开，后续就会把：

- host-side progress projection stream

误写成：

- model-visible progress layer

## 第二层：`task_progress` 不是模型图层，它首先是宿主投影流

`sdkProgress.ts` 的注释已经给出最稳的起点：

- `emitTaskProgress(...)` 发的是 `task_progress` SDK event
- 它被 background agents 和 workflows 共用
- 调用方传进来的都是已经算好的 primitives

这说明它在设计上就不是：

- 一段需要模型理解和续写的提示内容

而是：

- 一份让宿主 / client 直接投影进展态的结构化事件

## 第三层：`workflow_progress` 更直接暴露了“这是 host fold，不是模型内容”

`sdkEventQueue.ts` 对 `workflow_progress` 的注释非常关键：

- 它是 workflow state changes 的 delta batch
- clients upsert by ``${type}:${index}``
- 再按 `phaseIndex` group
- 用和 `PhaseProgress.tsx` 相同的 fold 去重建 phase tree

这几句已经把主语写死了：

- 这不是 prompt 内容
- 这不是 transcript 附件
- 这是一份给客户端重建 phase tree 的结构化增量

所以 `workflow_progress` 更接近：

- host-side progress tree delta

不是：

- 模型该继续读写的语义片段

## 第四层：`useRemoteSession` 明文说了这类对象是 status signals, not renderable messages

这页最不该漏掉的一句，其实就在 `useRemoteSession.ts`：

- 对 `task_started/task_notification/task_progress` 的处理会 return early
- 注释直接写：these are status signals, not renderable messages

而且 remote 侧的消费方式也说明了这一点：

- `task_started` 增加 running task set
- `task_notification` 从 running task set 删除
- `task_progress` 直接 return

这意味着 remote host 关心的是：

- 这些事件如何驱动后台任务状态投影

不是：

- 把它们渲染成 transcript 正文给用户或模型继续消费

## 第五层：`print.ts` 先 flush `task_progress`，就是在主动把它从模型图层前置剥离

`print.ts` 的顺序设计也非常值钱：

- 先 `drainSdkEvents()`
- 注释写明：让 `task_started/task_progress` 先于 `task_notification` 落到流上
- 还强调：background agent progress 应该 real-time streamed，而不是等到 result 才一起发

如果 `task_progress` 和 `<task-notification>` 属于同一模型图层，这种顺序并没有特殊价值。

只有在它被设计成：

- 一条宿主先行消费的实时状态流

时，`print.ts` 才需要故意把它排在 command queue 前面。

## 第六层：`task_progress` 甚至已经不再是普通 attachment 类型

`messages.ts` 里还有一个很硬的边界证据：

- `task_progress` 被列进 `LEGACY_ATTACHMENT_TYPES`
- 注释写的是 `removed in PR #19337`

这说明在当前源码语义里，`task_progress` 已经不是：

- 正常 attachment / transcript 图层的一员

而是更明确地退回到了：

- SDK / host progress projection

这也能反过来解释，为什么前面几页里一直要把：

- `task_progress`
- queued command attachment
- `<task-notification>`

分成不同层。

## 第七层：`LocalAgentTask` 也把受众写得很直白

`LocalAgentTask.tsx` 的注释非常直接：

- Emit summary to SDK consumers (e.g. VS Code subagent panel)
- No-op in TUI

这句话几乎已经是本页的宿主侧明文答案：

- 同一条 `task_progress` 在 TUI 里根本不承担主要图层职责
- 它的重点受众是 SDK consumer / panel

所以这不是：

- 通用消息层

而是：

- consumer-specific host projection

## 第八层：为什么 `task_progress` 不该和 `<task-notification>` 写成同一种“进展消息”

两者表面上都在讲任务进展，但职能完全不同。

### `task_progress`

- 没有进入 XML parser / LLM loop 的设计意图
- 主要驱动 host / SDK consumer 的进展投影
- 可以携带 `workflow_progress` 这类 phase tree delta

### `<task-notification>` / queued `task-notification`

- 会进入模型回合
- 可能带 `<status>` 形成 terminal close
- 会被 attachment / transcript / dedup 逻辑处理

所以更稳的写法是：

- `task_progress` 是宿主进展投影流
- `<task-notification>` 是模型可见的结果回流 envelope

## 第九层：为什么 94 不和 93 合并

93 回答的是：

- triad vs queue lifecycle

94 继续往下后，主语已经换成：

- triad 里的 `task_progress/workflow_progress`
- 为什么它们首先属于 host projection，而不是 model layer

前者讲：

- 生命周期时间轴的错位

后者讲：

- triad 内部哪一段天然属于宿主图层

所以不该揉成一页。

## 第十层：最常见的假等式

### 误判一：`task_progress` 只是更细粒度的 `<task-notification>`

错在漏掉：

- 它首先是 SDK progress stream，不是 XML result envelope

### 误判二：`workflow_progress` 是给模型看的 workflow 内容摘要

错在漏掉：

- 注释明确说它是给 client upsert + groupByPhase 重建 phase tree 的 delta

### 误判三：remote host 看到这些对象，说明它们本来就是 renderable messages

错在漏掉：

- `useRemoteSession` 明确 return early，并注明它们是 status signals, not renderable messages

### 误判四：`task_progress` 当然也应该像 attachment 一样留在 transcript 层

错在漏掉：

- `messages.ts` 已把 `task_progress` 列为 removed legacy attachment type

### 误判五：`print.ts` 只是顺手先发 SDK events，没有语义差别

错在漏掉：

- 它就是在有意把宿主实时进展流排在模型结果流之前

## 第十一层：稳定、条件与内部边界

### 稳定可见

- `task_progress` 首先是宿主/SDK consumer 的进展投影流，不是模型图层。
- `workflow_progress` 是给客户端重建 phase tree 的结构化 delta。
- `task_progress` 与 `<task-notification>` 不属于同一层“进展消息”。
- `print.ts` 会主动把这条进展流排在 command queue / 模型结果层之前。

### 条件公开

- `task_progress` 的发出受调用方是否启用相应 summaries / workflow flush 控制。
- remote/session/viewer 会消费这条流做状态投影，但不把它当 renderable messages。
- 不同宿主对这条流的厚度不同：TUI 可能 no-op，SDK/IDE panel 则会用它。

### 内部 / 实现层

- `workflow_progress` 的具体 upsert key 与 phase tree fold 细节。
- 各任务类型生成 progress 的频率、节流与批量策略。
- `drainSdkEvents()` 与 heldBackResult / idle transition 的排序细节。

## 第十二层：苏格拉底式自检

### 问：为什么这页最先该拆 `workflow_progress`，而不是继续补更多 terminal 路径？

答：因为 `workflow_progress` 的注释已经直接把“host fold”写在脸上，它是最不该再被误写成模型内容层的对象。

### 问：为什么 `messages.ts` 里 removed attachment type 值得进正文？

答：因为它是一个非常硬的边界证据：`task_progress` 已经不再被当作普通消息附件层来经营。

### 问：为什么 `print.ts` 的排序这么关键？

答：因为排序本身就是语义声明：谁应该先被宿主看见，谁才是后面的模型结果流。

## 源码锚点

- `claude-code-source-code/src/utils/task/sdkProgress.ts`
- `claude-code-source-code/src/utils/sdkEventQueue.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/tasks/LocalAgentTask/LocalAgentTask.tsx`
- `claude-code-source-code/src/utils/messages.ts`
