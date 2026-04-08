# Headless print result-convergence reading chain 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/207-task triad、result return-path、flush ordering、authoritative idle、semantic last result 与 suggestion delivery：为什么 headless print 的 92-99 不是并列细页，而是一条从多账本前提走到延迟交付的收束链.md`
- `05-控制面深挖/92-registerTask、task_started、task_notification、notifyCommandLifecycle、queued_command attachment 与 source_uuid：为什么 headless print 的任务结果不会落在同一层账本.md`
- `05-控制面深挖/93-task_started、task_progress、task_notification、drainSdkEvents、remoteBackgroundTaskCount 与 notifyCommandLifecycle：为什么 headless print 的后台任务三段式事件不是同一层生命周期.md`
- `05-控制面深挖/95-enqueuePendingNotification、emitTaskTerminatedSdk、print.ts parser、No continue 与 foreground done：为什么 headless print 的任务结果不会走同一条回流路径.md`
- `05-控制面深挖/96-drainSdkEvents、heldBackResult、task_started、task_progress、session_state_changed(idle) 与 finally_post_flush：为什么 headless print 的 SDK event flush 不是一次普通 drain.md`
- `05-控制面深挖/97-heldBackResult、bg-agent do-while、notifySessionStateChanged(idle)、lastMessage 与 authoritative turn over：为什么 headless print 的 idle 不是普通 finally 状态切换.md`
- `05-控制面深挖/98-lastMessage stays at the result、SDK-only system events、pendingSuggestion、heldBackResult 与 post_turn_summary：为什么 headless print 的主结果语义不会让给晚到系统事件.md`

边界先说清：

- 这页不是 headless print 全景图。
- 这页不替代 92-99 各页的细节证明。
- 这页只抓“92 是根页、93-98 是主干、94/99 是挂枝”的阅读链。

## 1. 阅读链总表

| 节点 | 作用 | 在链上的位置 |
| --- | --- | --- |
| 92 | 先钉死 task ledger / command ledger / attachment ledger 分裂 | 根页 |
| 207 | 说明主干与挂枝怎么排 | 结构收束页 |
| 93 | 先分 `task` triad 与 queue lifecycle pair | 主干起点 |
| 94 | 只细化 `task_progress/workflow_progress` 为 host projection | 93 的 progress 挂枝 |
| 95 | 先分 XML re-entry 与 direct SDK close | 主干 |
| 96 | 解释多站位 flush ordering 为什么是时序护栏 | 主干 |
| 97 | 解释 `idle` 为什么是 authoritative turn-over | 主干 |
| 98 | 解释 result 为什么保住 semantic last-message | 主干 |
| 99 | 解释 suggestion 为什么晚于真实交付才记账 | 98 的 delivery 挂枝 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 93-99 都在讲 result，所以可以并列读 | 93/95/96/97/98 是主干，94/99 是挂枝 |
| 94 是 95 的前置正文 | 94 只细化 progress projection，不定义 result return-path |
| 99 是另一种 result semantics | 99 讨论的是 result 之后的 suggestion delivery/accounting |
| `drainSdkEvents()`、`heldBackResult` 就是稳定功能名 | 它们只是实现证据，稳定层要写 path、ordering、delivery 合同 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | 多账本分裂、triad vs pair、host progress、return-path split、idle 晚于 held-back result、result 保住主结果语义、suggestion 在真实交付后才进入 tracking |
| 条件公开 | 不同宿主消费厚度不同；部分 terminal `task_notification` 不回到模型；延后 suggestion 在新命令先到时可被丢弃 |
| 内部/实现层 | `drainSdkEvents()` 的站位、`heldBackResult`、`pendingSuggestion`、`pendingLastEmittedEntry`、`lastEmitted` 等 staging 细节 |

## 4. 六个检查问题

- 我现在缺的是 92 的账本前提，还是 93-98 的收束主干？
- 我现在在问主干节点，还是只是在问 94/99 这样的挂枝？
- 这一步首先在回答 host、model、output，还是 delivery/accounting？
- 这句话在 helper 名改掉以后还成立吗？
- 我是不是把“晚到很重要”误写成“晚到就应该篡位”？
- 我是不是把“已经生成”误写成“已经交付”？

## 5. 源码锚点

- `claude-code-source-code/src/utils/task/framework.ts`
- `claude-code-source-code/src/utils/sdkEventQueue.ts`
- `claude-code-source-code/src/utils/task/sdkProgress.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx`
- `claude-code-source-code/src/utils/commandLifecycle.ts`
- `claude-code-source-code/src/utils/suggestionState.ts`
- `claude-code-source-code/src/utils/sessionState.ts`
