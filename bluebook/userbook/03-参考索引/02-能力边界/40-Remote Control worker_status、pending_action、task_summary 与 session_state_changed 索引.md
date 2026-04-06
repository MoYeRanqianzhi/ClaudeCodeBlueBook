# Remote Control `worker_status`、`pending_action`、`task_summary` 与 `session_state_changed` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/51-worker_status、requires_action_details、pending_action、task_summary、post_turn_summary 与 session_state_changed：为什么远端看到的运行态不是同一张面.md`
- `02-能力地图/01-运行时主链/04-会话真相层：实时状态、Transcript 与恢复账本.md`
- `05-控制面深挖/30-remoteConnectionStatus、remoteBackgroundTaskCount、BriefIdleStatus 与 viewerOnly：为什么远端会话的连接告警、后台任务与 bridge 重连不是同一张运行态面.md`

## 1. 六类远端运行态投影总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Phase Surface` | 当前粗粒度在 idle / running / requires_action 哪一态 | `worker_status` |
| `Typed Block Context` | 阻塞时最核心的结构化上下文是什么 | `requires_action_details` |
| `Queryable Block JSON` | 前端可直接读取的完整阻塞 JSON 是什么 | `external_metadata.pending_action` |
| `Mid-turn Progress` | 这一轮进行到哪里了 | `task_summary` |
| `Post-turn Recap` | 刚刚这一轮做了什么 | `post_turn_summary` |
| `SDK Broadcast` | 非 CCR 消费方怎样知道 turn 已 idle / running | `session_state_changed` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `worker_status` = `pending_action` | 一个是粗粒度相位，一个是阻塞 JSON 上下文 |
| `requires_action_details` = `pending_action` | 一个 typed、一个 queryable JSON mirror |
| `task_summary` = `pending_action` | 一个讲进度，一个讲阻塞 |
| `task_summary` = `post_turn_summary` | 一个是 mid-turn progress，一个是 post-turn recap |
| `session_state_changed` = `worker_status` | 一个是 SDK 事件广播，一个是 CCR worker state surface |
| 看到 `requires_action` 就知道完整卡点 | 还需要 details 或 `pending_action` |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `idle / running / requires_action`、远端 waiting-for-input、mid-turn `task_summary`、post-turn summary 作为观察面 |
| 条件公开 | `requires_action_details`、`pending_action`、`session_state_changed` 事件、`pending_action.input` 的前端解析面 |
| 内部/实现层 | metadata listener wiring、具体 subtype、Datadog / proto 路径、env gate |

## 4. 六个高价值判断问题

- 我现在看到的是 phase、block context、mid-turn progress，还是 post-turn recap？
- 这是通过 worker state PUT 走的，还是通过 SDK 事件流广播的？
- 当前 waiting-for-input 是粗粒度 requires_action，还是具体 pending_action JSON？
- 我是不是又把 `task_summary` 和阻塞原因写成了同一个“当前动作”？
- 我是不是又把 `session_state_changed` 和 `worker_status` 写成了同一种投影？
- 我是不是又把能力地图总览重写成了控制面长文？

## 5. 源码锚点

- `claude-code-source-code/src/utils/sessionState.ts`
- `claude-code-source-code/src/cli/transports/ccrClient.ts`
- `claude-code-source-code/src/cli/remoteIO.ts`
- `claude-code-source-code/src/utils/sdkEventQueue.ts`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts`
