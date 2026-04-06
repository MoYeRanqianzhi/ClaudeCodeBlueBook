# Task progress host projection vs model layer 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/94-task_progress、workflow_progress、drainSdkEvents、useRemoteSession、PhaseProgress 与 removed task_progress attachment：为什么 headless print 的进展流属于宿主投影而不是模型图层.md`
- `05-控制面深挖/93-task_started、task_progress、task_notification、drainSdkEvents、remoteBackgroundTaskCount 与 notifyCommandLifecycle：为什么 headless print 的后台任务三段式事件不是同一层生命周期.md`

边界先说清：

- 这页不是完整 SDK triad 总图。
- 这页不替代 93 对 triad vs queue lifecycle 的拆分。
- 这页只抓 `task_progress/workflow_progress` 的宿主投影性质。

## 1. 五个关键对象总表

| 对象 | 作用 | 更接近什么 |
| --- | --- | --- |
| `task_progress` | 后台任务实时进展事件 | host progress stream |
| `workflow_progress` | 客户端重建 phase tree 的增量 | progress tree delta |
| `useRemoteSession` early return | 把 triad 当 status signals 处理 | non-renderable host consumer |
| `drainSdkEvents()` 排序 | 让进展流先于模型结果层落流 | stream ordering gate |
| removed `task_progress` attachment | 证明它不再属于普通附件层 | model-layer exclusion |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `task_progress` 是更细粒度的 `<task-notification>` | 它首先是 SDK/host progress stream |
| `workflow_progress` 是给模型看的 workflow 摘要 | 它是给 client upsert/groupByPhase 的 delta |
| 远端能收到它，说明它是 renderable message | `useRemoteSession` 明确把它当 status signal 并 early return |
| `task_progress` 理应留在 transcript/attachment 层 | `messages.ts` 已把 `task_progress` 列为 removed legacy attachment type |
| `print.ts` 先发 SDK events 只是实现细节 | 这个排序本身在声明宿主投影流优先于模型结果层 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `task_progress/workflow_progress` 属于宿主投影流，不是模型图层；它们与 `<task-notification>` 不在同一层 |
| 条件公开 | progress summaries/workflow flush 会影响这条流的厚度；不同宿主对它的消费厚度不同 |
| 内部/实现层 | phase tree fold、节流/批量、drainSdkEvents 与其它流的精确排序 |

## 4. 六个检查问题

- 这里的进展是在服务 host，还是在服务模型？
- `workflow_progress` 是结构化 delta，还是 prompt 内容？
- 这条事件会不会被当成 renderable message？
- 这里讨论的是 triad vs pair，还是 progress stream vs model layer？
- `task_progress` 还在 attachment 层吗？
- 我是不是把 host projection stream 写成模型结果层了？

## 5. 源码锚点

- `claude-code-source-code/src/utils/task/sdkProgress.ts`
- `claude-code-source-code/src/utils/sdkEventQueue.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/tasks/LocalAgentTask/LocalAgentTask.tsx`
- `claude-code-source-code/src/utils/messages.ts`
