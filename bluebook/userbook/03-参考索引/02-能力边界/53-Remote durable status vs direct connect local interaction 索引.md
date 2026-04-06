# Remote durable status vs direct connect local interaction 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/64-remoteSessionUrl、remoteConnectionStatus、remoteBackgroundTaskCount 与 busy_waiting_idle：为什么 remote session 的持续状态面和 direct connect 的当前交互面不是同一种状态来源.md`
- `05-控制面深挖/62-Connected to server、Remote session initialized、busy_waiting_idle、PermissionRequest 与 stderr disconnect：为什么 direct connect 的可见状态面不是同一张远端状态板.md`
- `05-控制面深挖/30-remoteConnectionStatus、remoteBackgroundTaskCount、BriefIdleStatus 与 viewerOnly：为什么远端会话的连接告警、后台任务与 bridge 重连不是同一张运行态面.md`

边界先说清：

- 这页不是 remote session 事件流索引
- 这页不是 direct connect 状态面索引
- 这页只抓“持续状态来源”与“当前交互态来源”的差异

## 1. 六类对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Mode Marker` | 当前是不是 remote session 模式 | `remoteSessionUrl` / `remote` pill |
| `Durable Remote Status` | 当前远端会话是否有可复用持续状态 | `remoteConnectionStatus` |
| `Durable Remote Counter` | 当前远端后台任务数是多少 | `remoteBackgroundTaskCount` |
| `Local Interaction State` | 当前 TUI 是忙、等，还是闲 | `busy / waiting / idle` |
| `Startup Hint` | 当前只是一次性启动提示吗 | `Connected to server at ...` |
| `Consumer Scope` | 这条状态会被多少 UI 面共享 | footer / spinner / pill / current REPL |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `busy / waiting / idle` = 远端连接态 | 这是本地交互态 |
| `Reconnecting...` = 当前 prompt 忙 | 这是 remote session 的持续连接态 |
| `n in background` = direct connect 忙闲信号 | 这是 remote session 的后台任务计数 |
| `remote` pill = 当前远端正在工作 | 它只是模式标记 |
| `Connected to server at ...` = 持续状态 | 这是启动提示 |
| 两种远端模式只是 UI 文案不同 | 更根本的区别是状态来源与可复用性不同 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | remote session 有 `AppState` 支撑的持续状态面；direct connect 主要只有当前 REPL 的交互态 |
| 条件公开 | `remote` pill 依赖 `remoteSessionUrl`； remote 持续状态依赖事件流； direct connect waiting 依赖本地审批阻塞 |
| 内部/实现层 | event-sourced 计数、stream event 消费、isCompactingRef、布局细节 |

## 4. 七个检查问题

- 当前状态写进 `AppState` 了吗？
- 它会被多个组件共享，还是只服务当前 REPL？
- 它描述的是远端会话本身，还是本地交互节奏？
- 这是模式标记、启动提示，还是持续状态？
- 当前 `waiting` 是不是本地审批阻塞？
- 当前 `Reconnecting...` / `n in background` 是不是依赖 remote 事件流？
- 我是不是又把 durable status 和 local interaction 写成同一种来源了？

## 5. 源码锚点

- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/components/Spinner.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
