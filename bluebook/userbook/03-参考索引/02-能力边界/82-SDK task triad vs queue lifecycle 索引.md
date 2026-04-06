# SDK task triad vs queue lifecycle 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/93-task_started、task_progress、task_notification、drainSdkEvents、remoteBackgroundTaskCount 与 notifyCommandLifecycle：为什么 headless print 的后台任务三段式事件不是同一层生命周期.md`
- `05-控制面深挖/92-registerTask、task_started、task_notification、notifyCommandLifecycle、queued_command attachment 与 source_uuid：为什么 headless print 的任务结果不会落在同一层账本.md`

边界先说清：

- 这页不是 task runtime 全景。
- 这页不替代 92 对多账本分裂的拆分。
- 这页只抓 SDK task triad 与 queue lifecycle pair 的时间轴错位。

## 1. 五个关键对象总表

| 对象 | 作用 | 更接近什么 |
| --- | --- | --- |
| `task_started` | 注册后台 task 的开始 bookend | task triad start |
| `task_progress` | 实时宿主进展流 | host progress stream |
| terminal `task_notification` | triad closing bookend | task triad close |
| `notifyCommandLifecycle(started/completed)` | queued command 消费账本 | queue lifecycle pair |
| `drainSdkEvents()` | 强制 triad 先于 queue 内容落流 | stream ordering gate |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `task_started/task_progress/task_notification` 就是任务版 command lifecycle | 前者是按 `task_id` 的三段式 triad；后者是按 `uuid` 的两段式 pair |
| 所有 terminal `task_notification` 都会进模型回合 | direct SDK terminal event 不触发 XML parser，也不触发 LLM loop |
| `task_progress` 也是一种模型可见提示 | 它首先是宿主实时进展流 |
| remote background counter 是本地 task store 或 attachment 的镜像 | 它是 event-sourced from `task_started/task_notification` |
| `print.ts` 同时处理这些对象，所以它们本来就在同一层 | `print.ts` 明确先排 SDK triad，再排 queue 内容 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | SDK task triad 与 queue lifecycle 不是同一层时间轴；一部分 terminal `task_notification` 只服务 SDK/host |
| 条件公开 | 是否走 XML parser / LLM loop，取决于 terminal event 走 direct SDK 还是 XML re-entry 路；remote host 只把 `task_started/task_notification` 用于 background count |
| 内部/实现层 | workflow_progress 折叠、foreground/background 细分路径、listener 绑定位置 |

## 4. 六个检查问题

- 这里在按 `task_id` 记 triad，还是按 `uuid` 记 pair？
- 这条事件的消费者是 host，还是模型？
- 这条 terminal `task_notification` 会不会触发 LLM loop？
- 这里的 `task_progress` 是内容层提示，还是宿主实时流？
- 这里讨论的是多账本分裂，还是 triad vs pair 的时间轴错位？
- 我是不是把 host progress stream 写成了模型可见结果层？

## 5. 源码锚点

- `claude-code-source-code/src/utils/sdkEventQueue.ts`
- `claude-code-source-code/src/utils/task/sdkProgress.ts`
- `claude-code-source-code/src/utils/task/framework.ts`
- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/utils/commandLifecycle.ts`
