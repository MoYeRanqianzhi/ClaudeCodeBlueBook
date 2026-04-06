# `remoteSessionUrl`、`remoteConnectionStatus`、`remoteBackgroundTaskCount` 与 `busy/waiting/idle`：为什么 remote session 的持续状态面和 direct connect 的当前交互面不是同一种状态来源

## 用户目标

不是只知道：

- `--remote` / `assistant` viewer 会显示 `remote` pill、`Reconnecting...`、`n in background`
- direct connect 里会看到 `busy / waiting / idle`
- 两边看起来都像“远端状态”

而是先拆开六类不同对象：

- 哪些是在说 remote session 会把状态写进 `AppState`，供多个消费者复用。
- 哪些是在说 direct connect 只在当前 REPL 里翻本地交互态。
- 哪些是在说 `remoteSessionUrl` 是持续存在的模式标记，不是当前工作态。
- 哪些是在说 `remoteConnectionStatus` / `remoteBackgroundTaskCount` 是跨组件共享的持续状态。
- 哪些是在说 `busy / waiting / idle` 只是当前 TUI 的本地派生态。
- 哪些是在说两者虽然都像状态，但一个是“可复用远端状态”，另一个是“当前交互节奏”。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“远端状态”：

- `remote` pill
- `Reconnecting...`
- `Disconnected`
- `n in background`
- `busy`
- `waiting`
- `idle`
- `Connected to server at ...`

## 第一性原理

这两条远端链的状态来源至少沿着五条轴线分化：

1. `Authority`：当前状态到底描述远端会话本身，还是当前本地 TUI 是否忙。
2. `Persistence`：这条状态会不会写进 `AppState`，被多个消费者复用。
3. `Consumer Scope`：它只影响当前 REPL，还是会同时影响 footer / spinner / pill / activity。
4. `Update Driver`：它由 event-sourced 远端事件驱动，还是由本地 `setIsLoading` / queue 长度驱动。
5. `Failure Semantics`：断开后是继续留下可观察状态，还是直接退出。

因此更稳的提问不是：

- “它们不都是远端模式里的状态吗？”

而是：

- “当前这条状态是在描述远端会话本身、当前本地交互节奏，还是一个一次性启动提示；它会不会被别的 UI 面共享，还是只在当前 REPL 生效？”

只要这五条轴线没先拆开，正文就会把 remote session 的持续状态面和 direct connect 的当前交互面写成同一种来源。

这里也要主动卡住几个边界：

- 这页讲的是 remote session 的持续状态来源与 direct connect 的当前交互态来源。
- 不重复 30 页对 `remoteConnectionStatus` / `remoteBackgroundTaskCount` / `viewerOnly` 的拆分。
- 不重复 51 页对 remote runtime event families 的拆分。
- 不重复 62 页对 direct connect 可见状态面的内部来源拆分。
- 不重复 63 页对 direct connect transcript mode 与 raw stream 的可见性差异。

## 第一层：remote session 会把一部分远端状态正式写进 `AppState`

### `AppStateStore` 里直接定义了 remote 专属状态槽位

`AppStateStore.ts` 里可以直接看到：

- `remoteSessionUrl`
- `remoteConnectionStatus`
- `remoteBackgroundTaskCount`

而且这些都有默认初值。

这说明 remote session 回答的问题不是：

- “当前 REPL 要不要显示个 spinner”

而是：

- “这条远端会话当前有哪些可被全局 UI 共享的持续状态”

### 所以它天生就是“跨消费者状态”，不是单组件私有状态

只要这一层没拆开，正文就会把 remote session 的状态写成某个组件内部临时变量。

## 第二层：`useRemoteSession` 真的在持续维护这几个状态槽位

### 连接态和后台任务数都走 `setAppState(...)`

`useRemoteSession.ts` 里有两条很硬的写回链：

- `setConnStatus(...)` -> `remoteConnectionStatus`
- `writeTaskCount()` -> `remoteBackgroundTaskCount`

并且：

- `task_started` 会加任务
- `task_notification` 会减任务
- `onReconnecting` / `onDisconnected` 会清理计数并更新连接态

这说明 remote session 回答的问题不是：

- “当前这次 prompt 还在不在跑”

而是：

- “远端会话目前处于什么连接态、后台任务态，并把这份状态持续广播给本地 UI”

### 它还会消费 `stream_event`，持续驱动远端输出流

`useRemoteSession.ts` 对 `converted.type === 'stream_event'` 会继续走：

- `handleMessageFromStream(...)`

这说明 remote session 的状态与消息面，都是“持续远端会话”的一部分。

只要这一层没拆开，正文就会把 remote session 写成和 direct connect 一样的本地 loading 翻转器。

## 第三层：这些持续状态会被多个 UI 消费者同时消费

### `BriefIdleStatus` 直接读取 `remoteConnectionStatus` 与 `remoteBackgroundTaskCount`

`Spinner.tsx` 里的 `BriefIdleStatus` 会直接订阅：

- `s.remoteConnectionStatus`
- `s.remoteBackgroundTaskCount`

然后渲染：

- `Reconnecting...` / `Disconnected`
- `${n} in background`

这说明它回答的问题不是：

- “当前 REPL 这一轮是不是还在 loading”

而是：

- “无论当前有没有 prompt in flight，这条 remote session 的持续状态该怎样在 UI 上显示”

### `PromptInputFooterLeftSide` 也消费 `remoteSessionUrl`

`PromptInputFooterLeftSide.tsx` 会把：

- `remoteSessionUrl`

渲染成：

- `remote` pill / link

这说明 remote session 至少有两类全局消费者：

- 模式标记消费者
- 连接/后台任务状态消费者

只要这一层没拆开，正文就会把 remote session 的状态写成只给 spinner 用的临时变量。

## 第四层：direct connect 的 `busy / waiting / idle` 不是持续远端状态，而是当前 TUI 的交互节奏

### direct connect 不往 `AppState.remoteConnectionStatus` 里写自己的连接态

和 `useRemoteSession` 相比，direct connect 那条线的关键更新是：

- `setIsLoading(true/false)`
- `toolUseConfirmQueue`
- fatal `stderr` disconnect

并没有对应的：

- `setAppState(... remoteConnectionStatus ...)`
- `setAppState(... remoteBackgroundTaskCount ...)`

### 它的 `busy / waiting / idle` 只是 REPL 本地派生

`REPL.tsx` 里：

- `isLoading = isQueryActive || isExternalLoading`
- `isWaitingForApproval = ...`
- `sessionStatus = waiting ? 'waiting' : isLoading ? 'busy' : 'idle'`

这说明 direct connect 回答的问题不是：

- “这条远端会话对全局 UI 来说是什么状态”

而是：

- “当前这个 TUI，从交互节奏看是忙、等，还是空闲”

只要这一层没拆开，正文就会把 `busy / waiting / idle` 误写成和 `remoteConnectionStatus` 同级的远端状态。

## 第五层：两者最大的差别，是“可复用持续状态”对“当前交互态”的差别

### remote session 的状态可跨组件、跨时刻复用

比如：

- 当前没有新的 prompt
- 仍然可以看到 `Reconnecting...`
- 仍然可以看到 `n in background`

因为这些状态不是依赖当前 prompt 的 loading，而是依赖远端会话自己的持续事件。

### direct connect 的状态更像“本地这一轮怎么走”

比如：

- 发送消息时进入 `busy`
- 权限审批时进入 `waiting`
- 收到 `result` 后回到 `idle`

即使这时远端 server 还在别处有别的信息，本地也没有对应的持久状态槽去表达。

只要这一层没拆开，正文就会把两条线都写成“只是在显示远端当前状态”。

## 第六层：一次性提示也不能和持续状态混写

### direct connect 的 `Connected to server at ...` 只是启动提示

它来自 `main.tsx` 的本地注入。

### remote session 的 `remote` pill 也只是模式标记

它来自 `remoteSessionUrl`，不是连接工作态本身。

所以更准确的理解应是：

- 启动提示
- 模式标记
- 持续连接态
- 当前交互态

这四类对象都不应混写成一张状态板。

## 第七层：stable、conditional 与 internal 三层要分开保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | remote session 拥有 `AppState` 支撑的持续状态面；direct connect 主要只有当前 REPL 的交互态；两者不是同一种状态来源 |
| 条件公开 | `remote` pill 依赖 `remoteSessionUrl`；`Reconnecting...` / `Disconnected` / `n in background` 依赖 remote session 事件流； direct connect 的 `waiting` 依赖本地 approval/dialog 阻塞 |
| 内部/实现层 | `task_started` / `task_notification` 的 event-sourced 计数实现、`stream_event` 消费细节、`isCompactingRef` 的内部用途、Spinner/BriefIdleStatus 的具体布局 |

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `busy / waiting / idle` = remote session 的连接态 | 这是当前 TUI 的本地派生态 |
| `Reconnecting...` = 当前 prompt 还在 loading | 这是 remote session 的持续连接态 |
| `n in background` = direct connect 的忙闲状态 | 这是 remote session 的后台任务计数 |
| `remote` pill = 当前远端正在工作 | 它只是模式标记 |
| `Connected to server at ...` = 一条持续状态 | 它只是启动提示 |
| 两条远端模式都只是“显示状态不同” | 更根本的区别是状态来源、持久性和复用范围不同 |

## 七个检查问题

- 当前这条状态写进 `AppState` 了吗，还是只在当前 REPL 派生？
- 它会不会被 spinner / footer / pill 等多个消费者共享？
- 它描述的是远端会话本身，还是当前 TUI 的交互节奏？
- 这是模式标记、启动提示、持续状态，还是当前交互态？
- 当前 `waiting` 是不是只是本地审批阻塞？
- 当前 `Reconnecting...` / `n in background` 是不是依赖远端事件流？
- 我是不是又把 remote session 的持续状态面和 direct connect 的当前交互面写成同一种来源了？

## 源码锚点

- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/components/Spinner.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
