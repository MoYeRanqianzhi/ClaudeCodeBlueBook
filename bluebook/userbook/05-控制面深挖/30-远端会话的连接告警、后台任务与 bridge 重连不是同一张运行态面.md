# `remoteConnectionStatus`、`remoteBackgroundTaskCount`、`BriefIdleStatus` 与 `viewerOnly`：为什么远端会话的连接告警、后台任务与 bridge 重连不是同一张运行态面

## 用户目标

不是只知道 Claude Code 里“assistant 会显示 `Reconnecting…`、有时右边还有 `n in background`、`--remote` 底部又有个 `remote` pill”，而是先分清五类不同对象：

- 哪些是 remote session 自己的运行态字段。
- 哪些只是 brief / assistant UI 对这些字段的投影。
- 哪些计数来自远端 daemon child，而不是本地 REPL。
- 哪些属于 `viewerOnly` 改写出来的 ownership 边界。
- 哪些仍然属于底层共享传输的 reconnect 机制，而不是 viewer 自己的控制权。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“远端状态”：

- `remoteConnectionStatus`
- `remoteBackgroundTaskCount`
- `BriefSpinner`
- `BriefIdleStatus`
- `remoteSessionUrl`
- footer 的 `remote` pill
- `viewerOnly`
- `replBridgeConnected` / `replBridgeReconnecting`

## 第一性原理

Claude Code 里的“远端运行态”至少沿着四条轴线分化：

1. `Runtime Object`：当前字段描述的是 remote session 连接态、远端后台任务、还是 bridge host 自己的连接态。
2. `Event Source`：当前状态来自 WebSocket 生命周期、`task_started` / `task_notification` 事件，还是启动时一次性写入的 URL surface。
3. `UI Projection`：当前对象最终投影到 brief status line、系统提示消息、footer pill，还是 bridge dialog。
4. `Ownership`：当前是本地 remote client 在负责 title / interrupt / watchdog，还是只是共享底层 transport，而不拥有这些上层控制动作。

因此更稳的提问不是：

- “assistant / remote 不都是连到远端吗？”

而是：

- “我现在看到的是 remote session 的哪一种运行态对象；它是谁写入的、投影到哪个 UI、ownership 又落在谁手里？”

只要这四条轴线没先拆开，正文就会把远端连接告警、后台任务、viewerOnly 与 bridge 重连写成一张状态面。

## 第一层：`remoteConnectionStatus` 与 `remoteBackgroundTaskCount` 是 remote session 运行态字段，不是 bridge host 状态

### `AppState` 先放 remote session 运行态，后放 `replBridge*`

`AppStateStore.ts` 在状态树里先定义：

- `remoteSessionUrl`
- `remoteConnectionStatus`
- `remoteBackgroundTaskCount`

然后才进入：

- `replBridgeEnabled`
- `replBridgeConnected`
- `replBridgeSessionActive`
- `replBridgeReconnecting`

这说明产品在状态树层面就承认：

- remote session client / viewer 的运行态
- always-on bridge host 的运行态

不是同一条状态链。

### `remoteConnectionStatus` 回答的是“订阅这条 remote session 的流现在怎样”

`useRemoteSession.ts` 里，`onConnected`、`onReconnecting`、`onDisconnected` 会直接写：

- `connected`
- `reconnecting`
- `disconnected`

这说明它回答的问题不是：

- “bridge host 现在有没有 Ready / Connected”

而是：

- “当前 remote session 订阅流是否联通、是否正在回连、是否已断开”

### `remoteBackgroundTaskCount` 回答的是“远端 worker 里还有多少后台任务”

同一个 hook 里，`task_started` 与 `task_notification` 会维护一个 `runningTaskIdsRef`，再把计数写回：

- `remoteBackgroundTaskCount`

并且注释直接写出：

- viewer 的 `AppState.tasks` 是空的
- 任务活在另一进程

所以更准确的理解是：

- 这个数字不是本地 REPL task 列表的镜像

而是：

- 当前附着的远端 worker / daemon child 里还跑着多少任务

## 第二层：`BriefSpinner` 与 `BriefIdleStatus` 是 brief / assistant 的状态投影，不是 generic remote 状态页

### `BriefSpinner` 把连接告警和后台任务压成一条短状态线

`Spinner.tsx` 里的 `BriefSpinner` 会同时读取：

- `remoteConnectionStatus`
- `remoteBackgroundTaskCount`
- 本地 background task 数

然后把它们投影成左右两段：

- 左侧 `Reconnecting...` / `Disconnected`
- 右侧 `n in background`

这说明 brief 状态线回答的问题不是：

- “bridge dialog 里所有远端状态长什么样”

而是：

- “在 brief 模式下，用户现在最需要知道的连接与任务摘要是什么”

### `BriefIdleStatus` 只在 brief-only 且当前空闲时挂载

`REPL.tsx` 里，只有满足下面这些条件才挂 `BriefIdleStatus`：

- 不再显示 spinner
- 当前不在 loading
- `isBriefOnly`
- 不在查看 teammate transcript

这说明它不是：

- generic remote mode 的公共底栏

而是：

- brief / assistant viewer 在空闲时保持版面稳定的专用状态投影

### 因而 `BriefIdleStatus` 不应被写成“远端状态总览”

更稳的区分是：

- `remoteConnectionStatus` / `remoteBackgroundTaskCount`：运行态对象
- `BriefSpinner` / `BriefIdleStatus`：brief / assistant 的 UI 投影

一个是状态树对象，一个是显示层结果。

## 第三层：`remoteBackgroundTaskCount` 与本地 `tasks` 会并排折叠，但它不是本地任务列表

### Spinner 合并计数，不代表两者同源

`Spinner.tsx` 会把：

- 本地 `tasks` 里的 background task
- `remoteBackgroundTaskCount`

加总后显示为：

- `n in background`

这会让读者非常容易误判成：

- “remoteBackgroundTaskCount 只是 tasks 的另一种名字”

但 `useRemoteSession.ts` 已经把它们拆得非常明确：

- 本地任务来自本地 `AppState.tasks`
- 远端任务来自 WS 里的 task lifecycle 事件

### viewer 模式下尤其不能把这个数字当成本地任务

在 `viewerOnly` 路径里，本地并不承担远端 worker 的执行主链。

因此更稳的理解应是：

- 本地 brief UI 只是帮你看见远端还有多少事在跑

而不是：

- 本地 REPL 自己真的持有了那批任务对象

### 所以“有后台任务”与“本地 task 面板有内容”不是同一句话

只要这一层不拆开，正文就会把：

- brief 状态里的 `n in background`
- 本地 task / teammate 面板

误写成同一种任务可见面。

## 第四层：`viewerOnly` 改的是 ownership，不是底层 transport 是否存在 reconnect

### `viewerOnly` 的合同是“不拥有上层控制动作”

`RemoteSessionManager.ts` 的配置注释已经直接写出：

- `viewerOnly` 时 `Ctrl+C` / `Escape` 不发送 interrupt
- 60 秒本地 reconnect timeout 被禁用
- session title 不更新
- 这条路径用于 `claude assistant`

而 `useRemoteSession.ts` 的实现也对应体现为：

- 仍可向远端 session 发送用户消息
- 不接管 session title
- 不启动“Remote session may be unresponsive...” 的本地 watchdog 提示
- `cancelRequest()` 不发送远端 interrupt

这说明 `viewerOnly` 解决的问题不是：

- “当前是不是纯只读 viewer”

也不是：

- “底层 WebSocket 要不要自动回连”

而是：

- “本地这个附着客户端是不是当前 session 的上层控制 owner”

### `claude assistant` 与 `--remote` 的差别首先是 ownership，不只是入口名字

`main.tsx` 里：

- `claude assistant [sessionId]` 会创建 `viewerOnly = true` 且 `isBriefOnly = true`
- `--remote` 进入 TUI 时则写入 `remoteSessionUrl`，走可发送请求的 remote client 合同

这说明两者虽然共用 remote session 基础设施，但不是：

- 一个只是另一个的别名

而是：

- 一个是附着式 viewer
- 一个是创建并驱动 session 的 remote client

### 所以“viewer 不会重连”是错误命题

更稳的写法是：

- viewer 不拥有 title / interrupt / watchdog 这些上层动作
- 但底层共享 transport 仍然可能自行回连

只要这句话没写准，正文就会把：

- `viewerOnly`
- `SessionsWebSocket`

误压成一种“要么全有、要么全无”的重连能力。

## 第五层：底层共享 transport 会回连，但这不等于 viewer 拥有同样的运行态控制权

### `SessionsWebSocket` 的 reconnect 机制根本不认识 `viewerOnly`

`RemoteSessionManager.ts` 创建 `SessionsWebSocket` 时只传：

- `sessionId`
- `orgUuid`
- `getAccessToken`
- callbacks

并没有把 `viewerOnly` 往下传。

而 `SessionsWebSocket.ts` 自己也会根据 close code、retry budget 和 backoff 调：

- `scheduleReconnect(...)`

这说明底层 transport 的回连是共享机制，不是 viewer 专属能力。

### `viewerOnly` 与共享 transport 的关系应写成“ownership split”

更稳的区分是：

- 底层 transport：为了把 event stream 接回来，仍会尝试 reconnect
- 上层 viewer contract：不拥有 title rewrite、主动 timeout 警告、interrupt 控制

因此这批正文真正要保护的边界不是：

- “viewer 会不会 reconnect”

而是：

- “reconnect 这件事里，底层 transport 与上层控制 ownership 分别属于谁”

## 第六层：`remote` pill 与 “Attached to assistant session ...” 也不是同一张 surface

### footer 的 `remote` pill 只属于 `remoteSessionUrl` 这条链

`PromptInputFooterLeftSide.tsx` 里，footer 左侧只有在拿到：

- `remoteSessionUrl`

时，才渲染：

- `remote` 链接 pill

而 `main.tsx` 的 `--remote` 分支正是把这条 URL 写进初始状态。

这说明 `remote` pill 回答的问题不是：

- “当前是不是任意一种 remote mode”

而是：

- “当前 REPL 有没有一条可直接打开的 remote session URL”

### assistant viewer 走的是另一条 surface

`claude assistant [sessionId]` 分支不会把 `remoteSessionUrl` 作为同一类 footer surface 主打一遍，而是先注入：

- `Attached to assistant session ...`

这说明 assistant viewer 的主心智是：

- 我已附着到一条现有 session

不是：

- 我持有一条 `--remote` 风格的会话 URL surface

### 因而 remote pill 不能当 generic remote-mode detector

更稳的区分是：

- `remoteSessionUrl` / remote pill：`--remote` 这条 client URL surface
- attached info message：assistant viewer 的附着提示 surface

## 第七层：稳定主线、条件面与内部面要继续保护

### 稳定可见或相对稳定可见的

- `Reconnecting...` / `Disconnected` 这类 brief 连接告警
- `n in background` 这类远端后台任务摘要
- `viewerOnly` 对 title / interrupt / watchdog ownership 的用户可见后果
- remote pill 与 assistant attach message 属于不同 surface

这些都适合进入 reader-facing 正文。

### 条件公开或应降权写入边界说明的

- `claude assistant` 的 attach path 与 brief-only 挂载条件
- `remoteSessionUrl` 只在 `--remote` TUI 链上成立
- `viewerOnly` 是内部配置字段，但其后果值得写
- remote runtime surface 会随不同入口投影成不同 UI

### 更应留在实现边界说明的

- timeout 常量、compaction 特判、close code retry budget
- reconnect 时清空 task / tool 状态的补偿逻辑
- ping interval、force reconnect、echo filter 等底层传输细节
- `useState(() => store.getState().remoteSessionUrl)` 这类显示层实现技巧

这些只作为作者判断依据，不回流正文主线。

## 最后的判断公式

当你看到远端状态里出现 `Reconnecting...`、`n in background`、`remote` pill 或 `viewerOnly` 时，先问七个问题：

1. 现在这个对象属于 remote session 运行态，还是 bridge host 运行态？
2. 这个数字来自本地 `tasks`，还是来自远端 task lifecycle 事件？
3. 我看到的是状态树字段，还是 brief UI 的投影结果？
4. 当前 surface 依赖的是 `remoteSessionUrl`，还是只是 attach 成功后的提示消息？
5. 这里的 reconnect 指的是共享 transport，还是本地 viewer 的上层控制权？
6. `viewerOnly` 改的是 transport 机制，还是 title / interrupt / watchdog ownership？
7. 我是不是又把 remote session runtime、assistant brief surface 与 bridge host 状态压成了一张“远端状态面”？

只要这七问先答清，就不会把远端连接告警、后台任务、viewerOnly 与 bridge 重连写糊。

## 源码锚点

- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/components/Spinner.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts`
- `claude-code-source-code/src/remote/SessionsWebSocket.ts`
