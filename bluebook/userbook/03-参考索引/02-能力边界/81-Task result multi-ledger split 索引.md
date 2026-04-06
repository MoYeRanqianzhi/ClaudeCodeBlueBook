# Task result multi-ledger split 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/92-registerTask、task_started、task_notification、notifyCommandLifecycle、queued_command attachment 与 source_uuid：为什么 headless print 的任务结果不会落在同一层账本.md`
- `05-控制面深挖/90-task-notification、<task-id>、<status>、emitTaskTerminatedSdk、enqueuePendingNotification 与 fall through to ask：为什么 headless print 的 task-notification 不是普通进度提示.md`
- `05-控制面深挖/91-<status>、statusless ping、emitTaskTerminatedSdk、enqueuePendingNotification 与 double-emit：为什么 headless print 的 task-notification 不是同一种关单信号.md`

边界先说清：

- 这页不是 task system 总图。
- 这页不替代 90/91 对 dual-consumer 与 close-signal family 的拆分。
- 这页只抓 `task_id` 账本、command `uuid` 账本、attachment 内容账本三层分裂。

## 1. 五个关键对象总表

| 对象 | 作用 | 更接近什么 |
| --- | --- | --- |
| `task_started` / `task_notification` | 按 `task_id` 记任务 bookend | task ledger |
| `notifyCommandLifecycle(...)` | 按 queued command `uuid` 记命令消费 | command ledger |
| `queued_command` attachment | 记录模型看到了哪条内容 | attachment ledger |
| `source_uuid` 缺失的 task-notification | 证明命令账本不是完整真相 | ledger gap marker |
| `remoteBackgroundTaskCount` | 证明宿主可只靠 SDK task 事件记账 | host-side event ledger |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `task_started/task_notification` 和 `notifyCommandLifecycle` 在记同一件事 | 前者按 `task_id`；后者按 queued command `uuid` |
| 模型看到了 `<task-notification>`，就等于任务账本已经更新完 | attachment 被消费，不等于 task ledger / command ledger 同步完成 |
| 所有 task-notification 都能靠 command `uuid` 追踪 | 一部分 task-notification 没有 `source_uuid` |
| remote viewer 的后台任务数就是本地 `AppState.tasks` 的镜像 | viewer 可单靠 WS 上的 task 事件流记账 |
| 这些都叫“任务状态”，所以可以混写 | 它们分别回答 task、command、attachment、host event 四类问题 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | task ledger、command ledger、attachment ledger 不是同一层；它们会围绕同一份任务结果分别记账 |
| 条件公开 | 只有带 `uuid` 的 queued command 才能进 command lifecycle；某些 task-notification 只能在 attachment 层按文本去重；不同宿主消费厚度不同 |
| 内部/实现层 | fallback origin、replace register skip duplicate start、viewer/task store 的具体折叠方式 |

## 4. 六个检查问题

- 这里在按 `task_id` 记账，还是按 command `uuid` 记账？
- 这层是在服务 SDK/宿主，还是在服务模型输入？
- 这条记录能证明任务完成，还是只证明命令被消费？
- 这条 task-notification 有 `source_uuid` 吗？
- 这里讨论的是 close signal，还是多账本分裂？
- 我是不是把 parallel ledgers 写成 one unified result state 了？

## 5. 源码锚点

- `claude-code-source-code/src/utils/task/framework.ts`
- `claude-code-source-code/src/utils/sdkEventQueue.ts`
- `claude-code-source-code/src/utils/commandLifecycle.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/query.ts`
- `claude-code-source-code/src/utils/messages.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/state/AppStateStore.ts`
