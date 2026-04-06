# `status`、`shutdownRequested`、`awaitingPlanApproval`、`isIdle`、`recentActivities` 与 `[stopping]`：为什么 in-process teammate 的状态投影不是同一层状态

## 用户目标

81-84 已经把 shutdown family 连续拆到了：

- lifecycle family
- visible surfaces
- routing split
- host paths

但如果继续沿 in-process teammate 这条线往下看，读者还会撞上另一类误判：

- 为什么某个 teammate 的 `task.status` 还是 `running`，但 spinner 已经显示 `[stopping]`？
- 为什么另一个 teammate 也是 `running`，却显示 `[awaiting approval]`？
- 为什么还有的 `running` teammate 在 footer / detail dialog 里会被写成 `idle`？
- 为什么 headless waiters 判断“还有没有 working teammate”时，主要只看 `isIdle`，而不是看这些更细的标签？

如果这些问题不拆开，读者就会把 in-process teammate 再次误写成一句过度平面的状态机：

- “running / completed / failed 就够了，其它 UI 只是装饰。”

源码并不是这样工作的。

## 第一性原理

更稳的提问不是：

- “这个 teammate 现在是什么状态？”

而是四个更底层的问题：

1. source-of-truth 是 `task.status`，还是附加 flag？
2. 这个消费者需要的是 lifecycle verdict、activity label，还是 drain/wait 判断？
3. 这个消费者会把几个状态轴压成一条文案，还是只看其中一个 flag？
4. 它想知道的是“任务是否终止”，还是“当前是否还能继续占着工作槽位”？

只要这四轴不先拆开，后续就会把：

- layered runtime state

误写成：

- single status enum

## 第二层：in-process teammate 实际上有两层状态

`InProcessTeammateTaskState` 里至少同时存在两层对象：

### 第一层：通用 task lifecycle

- `status`
- `error`
- `result`

这层更接近：

- running / completed / failed / killed

### 第二层：in-process teammate 专属 flag

- `awaitingPlanApproval`
- `isIdle`
- `shutdownRequested`
- `progress.recentActivities`
- `progress.lastActivity`

这层更接近：

- 当前在等什么
- 当前是否空闲
- 当前是否已进入停机流程
- 当前最近在做什么

所以更稳的第一句不是：

- “teammate 只有一个状态”

而是：

- “teammate 至少有 lifecycle 层和 activity/projection 层两层状态”

## 第三层：创建与写入时机本身就说明它不是单层状态机

### 初始生成时，三类 flag 全部单独存放

`spawnInProcess.ts` 初始化 in-process teammate 时，会显式写入：

- `awaitingPlanApproval: false`
- `isIdle: false`
- `shutdownRequested: false`
- `status: 'running'`

这说明设计一开始就没有把它们折叠进一个枚举。

### `shutdownRequested` 由 terminate path 单独置位

`InProcessBackend.ts` 的 graceful terminate 在发送 `shutdown_request` 后，会调用：

- `requestTeammateShutdown(...)`

而这个 helper 只改：

- `shutdownRequested: true`

前提还是：

- `task.status === 'running'`

也就是说，一个 teammate 可以同时满足：

- `status === 'running'`
- `shutdownRequested === true`

这已经足够说明：

- `[stopping]` 不是 terminal status

### `awaitingPlanApproval` 由 plan exit path 单独置位

`ExitPlanModeV2Tool.ts` 给 leader 发 `plan_approval_request` 后，会调用：

- `setAwaitingPlanApproval(..., true)`

对应的 response helper 再把它置回：

- `false`

因此一个 teammate 也可以同时满足：

- `status === 'running'`
- `awaitingPlanApproval === true`

### `isIdle` 由 runner 循环前后单独翻转

`inProcessRunner.ts` 在每轮真正开工前会把 task 设成：

- `status: 'running'`
- `isIdle: false`

在一轮结束、等待下一次 prompt 时，又会把它设成：

- `isIdle: true`

但这里并不会同步把 `status` 改成 `completed`。

所以：

- `running + isIdle`

同样是一个稳定存在的组合。

## 第四层：同一个 `running` teammate 至少会被四种消费者压成四种不同厚度

| 消费者 | 最关心什么 | 压缩后的投影 |
| --- | --- | --- |
| `describeTeammateActivity` / footer / detail dialog | 现在该怎么用一句话描述它 | `stopping` / `awaiting approval` / `idle` / `working` |
| `TeammateSpinnerLine` | 当前 spinner 行该显示什么 | `[stopping]` / `[awaiting approval]` / `Idle for ...` / recent activity |
| `BackgroundTaskStatus` pill strip | 该不该按 idle 排序、该不该 dim | 主要只看 `isIdle` |
| `hasWorkingInProcessTeammates` / `waitForTeammatesToBecomeIdle` | 现在还算不算占着 working 槽位 | `status === running && !isIdle` |

这张表最重要的作用是先钉住一个事实：

- 这些消费者不是在读同一层状态
- 而是在从同一份 task state 中抽不同的投影

## 第五层：`describeTeammateActivity` 是一条“优先级压缩链”

`taskStatusUtils.tsx` 的 `describeTeammateActivity(...)` 不是简单地回 `task.status`。

它的优先级是：

1. `shutdownRequested` -> `stopping`
2. `awaitingPlanApproval` -> `awaiting approval`
3. `isIdle` -> `idle`
4. `recentActivities` summary
5. `lastActivity.activityDescription`
6. fallback `working`

这条链说明：

- activity label 的首要任务不是解释生命周期
- 而是把“当前最值得用户知道的运行态”压成一句话

所以它天然会把多个 flag 压成一个文案，而不是保留原始状态结构。

## 第六层：spinner 行并不只是“把 activity 文案再画一遍”

`TeammateSpinnerLine.tsx` 也有自己的优先级链：

1. `shutdownRequested` -> `[stopping]`
2. `awaitingPlanApproval` -> `[awaiting approval]`
3. `isIdle` -> `Idle for ...` 或 `pastTenseVerb for ...`
4. 否则显示 recent activity / last activity / random verb

但它还会额外叠加：

- 选中态 / 高亮态
- stats
- enter-to-view hint
- preview lines

所以 spinner 行不是“原始状态展示器”，更像：

- state projection + list-row affordance

这也是为什么：

- 同一个 teammate
- 在 detail dialog、footer 和 spinner tree 里
- 可以看起来像相似但不完全相同的状态

## 第七层：pill strip 与 waiter 更粗暴，它们几乎只看 `isIdle`

这页最容易被忽略、但最值钱的对照在这里。

### `BackgroundTaskStatus` 的 pill strip 只按 `isIdle` 排序

`BackgroundTaskStatus.tsx` 给 teammate pill 排序时只比较：

- `a.isIdle !== b.isIdle`

并把：

- 非 idle 放前面
- idle 放后面

所以在这条消费者里：

- `shutdownRequested`
- `awaitingPlanApproval`

都不会直接成为排序轴。

### headless / waiter 也主要只看 `isIdle`

`hasWorkingInProcessTeammates(...)` 和 `waitForTeammatesToBecomeIdle(...)` 的判断都类似：

- `task.type === 'in_process_teammate'`
- `task.status === 'running'`
- `!task.isIdle`

这意味着：

- 只要还没 idle
- 即便它已经 `shutdownRequested`
- 或已经 `awaitingPlanApproval`

它仍会被这些 drain/wait 逻辑视为：

- 还在占着 working 槽位

这解释了一个非常容易误解的现象：

- `[stopping]` 不等于“不再是 working teammate”

在 drain / wait 语义里，它依然可能被算作 working。

## 第八层：terminal status 和 projected activity 不是同一维度

`isTerminalStatus(...)` 只把下面这些当成 finished：

- `completed`
- `failed`
- `killed`

这和：

- `stopping`
- `awaiting approval`
- `idle`

不是同一维度。

因此最不该写错的一句是：

- `idle` / `stopping` / `awaiting approval` 都不是 terminal status

它们更接近：

- running task 的内部运行态投影

## 第九层：为什么这页不继续写 shutdown host path 或 mailbox routing

因为 81-84 已经把 shutdown 那条线拆得够细了。

85 页真正新增的视角是：

- 同一份 in-process teammate task state
- 如何被不同消费者压成不同厚度

这条线虽然承接 shutdown / plan approval / idle，但主角已经从：

- mailbox / host path

转成了：

- state projection

如果把这页再写回 shutdown routing，就会把不同问题重新混成一锅。

## 第十层：最常见的假等式

### 误判一：`status === running` 就足够解释 UI

错在漏掉：

- `shutdownRequested`
- `awaitingPlanApproval`
- `isIdle`

这些 flag 会继续重写用户看到的标签

### 误判二：`idle` 就等于 task 已完成

错在漏掉：

- `isIdle` 可以和 `status === running` 同时成立

### 误判三：`[stopping]` 就等于 terminal

错在漏掉：

- 它只是 `shutdownRequested` 的投影
- drain / wait 逻辑可能仍把它算作 working

### 误判四：`awaiting approval` 只是 UI 文案

错在漏掉：

- 它来自单独的 task flag
- 会影响 spinner / activity label

### 误判五：所有消费者都在看同一层状态

错在漏掉：

- detail / footer 看 activity compression
- spinner 看 list-row projection
- pill strip 看 `isIdle`
- waiter 看 `status + !isIdle`

## 第十一层：稳定、条件与内部边界

### 稳定可见

- in-process teammate 不是单一状态枚举，而是 `status` 加多组 flag 的组合状态。
- `shutdownRequested`、`awaitingPlanApproval`、`isIdle` 都会稳定影响用户看到的运行态投影。
- `idle`、`stopping`、`awaiting approval` 更接近 running task 的内部投影，而不是 terminal status。
- 不同消费者会从同一份 task state 提取不同厚度的状态面。

### 条件公开

- headless drain / wait 逻辑最稳定地依赖 `status === running && !isIdle`。
- spinner / footer / detail dialog 会额外受 recent activity、highlight/select 状态影响。
- 某些 generic icon/color helper 的优先级和具体 in-process teammate 组件不必完全一致。
- `shutdownRequested`、`awaitingPlanApproval` 是否同时成立，更接近运行时边缘条件，而不是用户级稳定承诺。

### 内部 / 实现层

- 各消费者的具体优先级顺序。
- `onIdleCallbacks` 的注册与清空时机。
- `recentActivities` summary 的折叠实现。
- spinner verb、past tense verb、preview 行等附加展示细节。

## 第十二层：苏格拉底式自检

### 问：如果 `status` 已经存在，为什么还要单独存这些 flag？

答：因为 `status` 只描述通用生命周期，不足以表达“正在停机”“正在等计划批准”“当前只是 idle 但尚未结束”这些运行态。

### 问：如果 `stopping` / `idle` / `awaiting approval` 都不是 terminal，那它们到底是什么？

答：它们是 running task 的内部投影，服务不同消费者的当前态理解，而不是最终态判断。

### 问：如果不同消费者给出不同文案，这算不算状态不一致？

答：不算。它们本来就在读不同层：有人关心活动摘要，有人关心是否 idle，有人关心是否还要等待。

### 问：为什么这页值得单独成文，而不是只在 shutdown 系列里带一句？

答：因为这页解释的是更一般的 in-process teammate 状态投影机制。shutdown 只是其中一个 flag 维度，不再是唯一主角。

## 源码锚点

- `claude-code-source-code/src/tasks/InProcessTeammateTask/types.ts`
- `claude-code-source-code/src/utils/swarm/spawnInProcess.ts`
- `claude-code-source-code/src/tasks/InProcessTeammateTask/InProcessTeammateTask.tsx`
- `claude-code-source-code/src/tools/ExitPlanModeTool/ExitPlanModeV2Tool.ts`
- `claude-code-source-code/src/utils/inProcessTeammateHelpers.ts`
- `claude-code-source-code/src/utils/swarm/backends/InProcessBackend.ts`
- `claude-code-source-code/src/utils/swarm/inProcessRunner.ts`
- `claude-code-source-code/src/utils/teammate.ts`
- `claude-code-source-code/src/components/tasks/taskStatusUtils.tsx`
- `claude-code-source-code/src/components/Spinner/TeammateSpinnerLine.tsx`
- `claude-code-source-code/src/components/tasks/BackgroundTask.tsx`
- `claude-code-source-code/src/components/tasks/BackgroundTaskStatus.tsx`
- `claude-code-source-code/src/components/tasks/InProcessTeammateDetailDialog.tsx`
