# Headless print task-notification dual-consumer semantics 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/90-task-notification、<task-id>、<status>、emitTaskTerminatedSdk、enqueuePendingNotification 与 fall through to ask：为什么 headless print 的 task-notification 不是普通进度提示.md`
- `05-控制面深挖/89-canBatchWith、joinPromptValues、batchUuids、replayUserMessages、task-notification 与 orphaned-permission：为什么 headless print 的 prompt batching 不是普通批量出队.md`

边界先说清：

- 这页不是 task system 全景图。
- 这页不替代 89 对 `task-notification` 单发原因的拆分。
- 这页只抓 `task-notification` 被 SDK consumer 和模型双重消费这一层语义。

## 1. 五个关键对象总表

| 对象 | 作用 | 更接近什么 |
| --- | --- | --- |
| `enqueuePendingNotification(..., mode: 'task-notification')` | 把任务结果包装成 queued command | XML queue ingress |
| `<status>` | 决定是否是 terminal close bookend | terminal gate |
| `output.enqueue({ subtype: 'task_notification' })` | 给 SDK consumer 发系统事件 | SDK close event |
| `// No continue -- fall through to ask()` | 让模型继续消费同一份结果 | model re-entry |
| `emitTaskTerminatedSdk(...)` | 覆盖“不走 XML queue”的 terminal 路径 | direct SDK bookend |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `task-notification` 只是普通进度提示 | 它是 SDK consumer 和模型双重消费的任务结果 envelope |
| 只要有 task-notification XML，就一定会发 SDK close | 只有带 `<status>` 的 terminal notification 才会发 |
| XML 路和 `emitTaskTerminatedSdk(...)` 一起发更稳 | 两者是互补路径；双发会重复记账 |
| 它在 headless 里才会回流给模型 | TUI / `query.ts` / coordinator 合同也会把它喂回模型 |
| 它看起来像 user-role message，所以就是普通 user message | coordinator 提示词明确说“看起来像，但不是” |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `task-notification` 是双重消费者合同；terminal `<status>` 会转成 SDK `task_notification`；同一对象随后仍会 fall through 给模型 |
| 条件公开 | statusless notification 不会给 SDK consumer 关任务，但仍可能进入模型；direct SDK bookend 只用于“不走 XML queue”的终态路径 |
| 内部/实现层 | XML 解析细节、状态归一化、usage/result/worktree 可选块、各任务实现各自何时抑制 XML |

## 4. 六个检查问题

- 这里的 `task-notification` 首先是在服务 SDK，还是在服务模型？
- `<status>` 在这里是文本补充，还是 terminal gate？
- 这条终态为什么走 XML queue，而不是 direct SDK emit？
- 这条 statusless ping 为什么不能当 close event？
- 这里讨论的是“单发原因”，还是“双重消费者合同”？
- 我是不是把 dual-consumer envelope 写成了普通进度提示？

## 5. 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/utils/task/framework.ts`
- `claude-code-source-code/src/tasks/LocalAgentTask/LocalAgentTask.tsx`
- `claude-code-source-code/src/tasks/LocalMainSessionTask.ts`
- `claude-code-source-code/src/tasks/LocalShellTask/LocalShellTask.tsx`
- `claude-code-source-code/src/utils/sdkEventQueue.ts`
- `claude-code-source-code/src/query.ts`
- `claude-code-source-code/src/coordinator/coordinatorMode.ts`
