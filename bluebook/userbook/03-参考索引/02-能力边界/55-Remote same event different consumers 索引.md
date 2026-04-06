# Remote same event different consumers 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/66-stream_event、task_started、status、remote pill 与 BriefIdleStatus：为什么同一 remote session 事件不会以同样厚度出现在每个消费者里.md`
- `05-控制面深挖/51-worker_status、requires_action_details、pending_action、task_summary、post_turn_summary 与 session_state_changed：为什么远端看到的运行态不是同一张面.md`
- `05-控制面深挖/64-remoteSessionUrl、remoteConnectionStatus、remoteBackgroundTaskCount 与 busy_waiting_idle：为什么 remote session 的持续状态面和 direct connect 的当前交互面不是同一种状态来源.md`

边界先说清：

- 这页不是 remote 事件种类索引
- 这页不是跨模式对照索引
- 这页只抓 remote session 内部“同一事件，被不同消费者不同厚度消费”的差异

## 1. 六类对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Streaming Consumer` | 当前事件要不要持续更新正文 | `stream_event` |
| `Counter Consumer` | 当前事件要不要折叠成后台任务计数 | `task_started/task_notification` |
| `Warning Consumer` | 当前事件要不要形成连接 warning | `remoteConnectionStatus` |
| `Mode Consumer` | 当前是不是 remote 模式 | `remoteSessionUrl` / `remote` pill |
| `Transcript Event` | 当前事件要不要落一条 message | `Status: ...` |
| `Internal Control Consumer` | 当前事件还要不要影响内部行为 | `isCompactingRef` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 一条 remote 事件应该在每个 UI 面都可见 | 不同消费者只吃自己需要的投影 |
| `stream_event` 也应出现在 footer / idle | 它主要服务流式正文 |
| `task_started/task_notification` 就是正文 system message | 它们主要服务后台任务计数 |
| `Status: compacting` 就是完整 compaction 状态 | 还有内部控制层 |
| `remote` pill = 连接态 warning | 它只是模式标记 |
| 某面没显示 = 事件没到本地 | 可能只是投给了别的消费者 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | remote session 的不同消费者拿到的是不同厚度的投影，而不是事件原文复刻 |
| 条件公开 | streaming 依赖 callbacks；后台计数依赖 task 事件； warning 依赖连接状态； mode pill 依赖 initial URL |
| 内部/实现层 | `isCompactingRef`、重复 compacting suppress、具体 stream handler 细节 |

## 4. 七个检查问题

- 当前事件服务哪个消费者？
- 它进 streaming、计数、warning，还是模式标记？
- 它会保留原文，还是被折叠？
- 它写进 `AppState` 了吗？
- 当前不可见，是不属于这个消费者，还是根本没到？
- 我是不是把 pill、warning、counter、streaming 写成一张面了？
- 我是不是把事件投影厚度写平了？

## 5. 源码锚点

- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/components/Spinner.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/remote/sdkMessageAdapter.ts`
