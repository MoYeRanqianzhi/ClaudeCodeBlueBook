# Remote Control `task_started`、`task_progress`、`task_notification` 与 `session_state_changed` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/53-task_started、task_progress、task_notification 与 session_state_changed：为什么远端消费方收到的不是同一种事件流.md`
- `05-控制面深挖/04-Agent、Task、Team、Cron：并行执行而不失控.md`
- `05-控制面深挖/30-remoteConnectionStatus、remoteBackgroundTaskCount、BriefIdleStatus 与 viewerOnly：为什么远端会话的连接告警、后台任务与 bridge 重连不是同一张运行态面.md`

边界先说清：

- 这页不是 SDK system subtype 总表
- 这页只抓 task bookend、progress frame 与 turn-over signal 的消费语义

## 1. 五类 SDK 事件对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Task Start Bookend` | 有一条新 task 生命周期开始了吗 | `task_started` |
| `Task Progress Frame` | 任务现在进行到哪里了 | `task_progress` |
| `Task Terminal Bookend` | 任务是否已经 completed / failed / stopped | `task_notification` |
| `Turn State Broadcast` | 当前主回合是不是 idle / running / requires_action | `session_state_changed` |
| `Derived Background Count` | 当前还有多少后台 task 在跑 | `runningTaskIdsRef` / `n in background` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `task_started` = 持续运行状态 | 它只是开始 bookend |
| `task_progress` = 终结通知 | 它是中途进度帧 |
| `task_notification` = 又一条 progress 更新 | 它是 terminal bookend |
| `session_state_changed` = task lifecycle 事件 | 它是 foreground turn 状态广播 |
| 收到 progress = background count 该变化 | 计数主要看 started / notification |
| finally 一起出来 = 同一种结束通知 | task end 与 turn-over 是两层信号 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `task_started` / `task_notification` 作为 task bookend、`task_progress` 作为中途进度帧 |
| 条件公开 | `session_state_changed` 的 SDK 发射、`workflow_progress`、foreground task_notification 直发路径、remote session 用 task bookend 折 count |
| 内部/实现层 | queue 上限、drain 次序、XML parser 旁支、flush 时机胶水 |

## 4. 六个检查问题

- 当前事件在描述 task lifecycle，还是 foreground turn state？
- 这是开始、进度，还是终结 bookend？
- 这个事件应该让消费方改 task count，还是改 turn state？
- 当前看到的是中途进度，还是终结通知？
- 当前看到的是 task 事件，还是回合状态广播？
- finally 末尾的多条事件，是不是仍然属于不同层级的结束信号？

## 5. 源码锚点

- `claude-code-source-code/src/utils/sdkEventQueue.ts`
- `claude-code-source-code/src/utils/task/framework.ts`
- `claude-code-source-code/src/utils/task/sdkProgress.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/utils/sessionState.ts`
- `claude-code-source-code/src/cli/print.ts`
