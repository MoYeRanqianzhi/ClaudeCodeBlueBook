# `--remote`、`/session`、`remoteSessionUrl`、`claude assistant [sessionId]` 与 remote-safe commands：为什么远端会话 client、viewer 与 bridge host 不是同一种远程工作流

## 用户目标

不是只知道 Claude Code 里“能 `--remote`、能 `/session`、还能 `claude assistant [sessionId]`”，而是先分清三类不同对象：

- 哪些入口是在创建并进入一个远端会话 client。
- 哪些入口是在附着到一个已经存在的远端会话做 viewer。
- 哪些入口虽然也通向远端协作，但其实属于 bridge host / remote-control，而不是 remote session client。

如果这些对象不先拆开，读者最容易把下面这些东西混成同一种“远程工作流”：

- `claude --remote`
- `/session`
- footer 左侧的 `remote` pill
- `remoteSessionUrl`
- `claude assistant [sessionId]`
- `viewerOnly`
- `remoteConnectionStatus`
- `remoteBackgroundTaskCount`
- `REMOTE_SAFE_COMMANDS`
- `BRIDGE_SAFE_COMMANDS`

## 第一性原理

Claude Code 里的“远端工作”至少沿着四条轴线分化：

1. `Session Ownership`：这条远端会话是当前入口创建的，还是当前入口只是附着进去。
2. `Client Shape`：当前 REPL 是一个可发送请求的 remote session client，还是一个更偏 viewer 的附着客户端。
3. `UI Surface`：当前展示的是 remote session URL、remote mode pill，还是 bridge host 自己的 connect/session surfaces。
4. `Command Contract`：当前允许的命令集合，是 remote-safe 的 REPL 客户端命令，还是 bridge inbound 可执行命令。

因此更稳的提问不是：

- “它们不都是远程工作吗？”

而是：

- “这次是我创建远端会话、附着已有会话，还是把本机暴露成 bridge host；当前 REPL 又是按哪种客户端合同在运行？”

只要这四条轴线没先拆开，正文就会把 `--remote`、`/session`、`assistant` 和 remote-control 全写成一种远程入口。

## 第一层：`--remote` 创建的是一条远端会话，然后把当前 REPL 变成它的 client

### `--remote` 的第一步是创建远端 session，而不是开本地 bridge

`main.tsx` 处理 `--remote` 时会：

- 检查描述是否为空
- 调 `teleportToRemoteWithErrorHandling(...)`
- 拿到 `createdSession`

这说明它首先回答的问题是：

- “要不要在远端创建一条新 session”

而不是：

- “要不要把当前本机暴露成 bridge environment”

### TUI gate 关闭时，它甚至不会进入本地 REPL 主线

`main.tsx` 写得很明确：

- 若 `tengu_remote_backend` 没开
- 就只打印 `Created remote session`、`View:`、`Resume with: claude --teleport ...`
- 然后退出

这说明 `--remote` 的对象从一开始就是：

- 远端 session 创建流

而不是：

- “本地一直在线的 bridge host”

### 进入 TUI 时，当前 REPL 变成 remote session client

若 remote TUI gate 开启，`main.tsx` 会：

- `setIsRemoteMode(true)`
- `switchSession(createdSession.id)`
- 创建 `remoteSessionConfig`
- 设置 `remoteSessionUrl`
- 预先把命令过滤到 `remoteCommands`
- `initialTools: []`

因此更准确的理解是：

- `--remote` = 先创建远端 session，再让当前 REPL 以 remote session client 形态接上去

而不是：

- “本地开一个远控桥，然后顺便给远端开网页”

### `/remote-control is active` 这类系统文案不应被误读成对象完全等价

`main.tsx` 在 `--remote` 进入 TUI 的分支里，会注入一条 system message：

- `/remote-control is active. Code in CLI or at ${remoteSessionUrl}`

这条文案会让读者非常容易误判成：

- `--remote` 与 remote-control host 是同一对象

但结合整条运行链看，更稳的理解应是：

- 这里展示的是“远端会话已经可从另一端继续”
- 不是在宣告 `--remote` 已经退化成 bridge host

因此正文必须继续按：

- remote session client
- bridge host

两条对象线分别书写，而不能被单条提示文案带偏。

## 第二层：`/session` 与 footer 的 `remote` pill 只属于 `remoteSessionUrl` 这条链，不属于所有 remote 模式

### `remoteSessionUrl` 在 `AppState` 里就是给 `--remote` 模式准备的

`AppStateStore` 直接把它注释成：

- `Remote session URL for --remote mode`

而 `main.tsx` 的 `--remote` 分支也会把：

- `remoteSessionUrl = ${getRemoteSessionUrl(createdSession.id)}?m=0`

写进初始状态。

这说明 `remoteSessionUrl` 不是：

- 任意 remote 模式都有的统一字段

而是：

- 远端 session client 这条链自己的 URL surface

### `/session` 只认 `remoteSessionUrl`

`commands/session/session.tsx` 的逻辑非常硬：

- 没有 `remoteSessionUrl` 就显示
  `Not in remote mode. Start with claude --remote to use this command.`
- 有 `remoteSessionUrl` 才展示 QR 和 URL

所以 `/session` 回答的问题不是：

- “当前任何远端相关模式的链接是什么”

而是：

- “当前 `--remote` 这条 remote session client 的会话链接是什么”

### footer 左侧的 `remote` pill 也只依赖这条 URL

`PromptInputFooterLeftSide.tsx` 里：

- `remoteSessionUrl` 在 mount 时从 `AppState` 取一次
- 只有它存在时，才渲染 `remote` 链接 pill

这说明你在 footer 看见 `remote` pill，不是在说明：

- “当前处于任何一种 remote mode”

而是在说明：

- “这条 REPL 当前持有一个 `remoteSessionUrl`，可以直接打开对应远端会话”

### 所以 `/session` 与 remote pill 都不是 generic remote-mode UI

更稳的区分是：

- `remote mode` 是更宽的运行形态
- `remoteSessionUrl`、`/session`、remote pill 是其中更窄的一条 URL surface

## 第三层：`claude assistant [sessionId]` 是 viewer client，不是 `--remote` 的另一种写法

### `assistant [sessionId]` 的对象是“附着现有 session”，不是“创建新 session”

`main.tsx` 在 assistant 分支里：

- 已经先拿到 `targetSessionId`
- 然后 `createRemoteSessionConfig(..., viewerOnly = true)`
- 再把当前 REPL 接过去

这说明它回答的问题不是：

- “我要不要新建一个远端 session”

而是：

- “我要不要把当前 REPL 附着到一条已经存在的远端 session 上”

### 它和 `--remote` 共用 remote session client 基础设施，但合同不同

assistant 分支和 `--remote` 分支都：

- `setIsRemoteMode(true)`
- 使用 `createRemoteSessionConfig(...)`
- `filterCommandsForRemoteMode(commands)`
- `initialTools: []`

但 assistant 会额外设置：

- `viewerOnly = true`
- `isBriefOnly = true`
- `kairosEnabled = false`
- `replBridgeEnabled = false`

这说明两者不是完全不同系统，但也绝不是：

- 一个只是名字不同的 `--remote`

### `viewerOnly` 是两条远端链最关键的分水岭

`createRemoteSessionConfig()` 把 `viewerOnly` 明确做成独立字段。

而 `useRemoteSession.ts` 里，`viewerOnly` 会改变多个用户可感知行为：

- 转换消息时要把 tool results 转成可见内容
- 不去接管 session title
- 不启用“session may be unresponsive”的本地超时重连提示
- `Ctrl+C` 不应该中断远端 agent

因此更稳的第一性原理是：

- `--remote`：我创建并驱动这条远端 session
- `assistant [sessionId]`：我附着并观看/交互，但不接管远端 agent 主体

## 第四层：remote-safe commands 是 remote session client 的命令合同，不是 bridge inbound contract

### `REMOTE_SAFE_COMMANDS` 解决的是“远端会话 client 在本地 REPL 里该显示哪些命令”

`commands.ts` 里：

- `REMOTE_SAFE_COMMANDS` 包含 `/session`、`exit`、`clear`、`help`、`theme`、`usage`、`mobile` 等
- `filterCommandsForRemoteMode(commands)` 只保留这一组

`main.tsx` 和 assistant / `--remote` 两个分支都会先做这个过滤。

这说明它回答的问题是：

- “当前 REPL 作为 remote session client 时，哪些本地命令还成立”

### `BRIDGE_SAFE_COMMANDS` 则是另一类问题

同一文件里还有：

- `BRIDGE_SAFE_COMMANDS`
- `isBridgeSafeCommand(cmd)`

它解决的是：

- 输入通过 Remote Control bridge 从 mobile/web 过来时，哪些 slash command 可以安全执行

因此它不是：

- `REMOTE_SAFE_COMMANDS` 的另一种叫法

而是：

- inbound bridge command contract

### 所以 remote-safe 与 bridge-safe 连对象都不同

更稳的区分是：

- `REMOTE_SAFE_COMMANDS`：当前 REPL 作为 remote session client 时，本地 UI 该允许什么
- `BRIDGE_SAFE_COMMANDS`：远端通过 bridge 进来的 slash command 允许什么

只要这一层不拆开，正文就会把两套 allowlist 混成同一个“远程命令白名单”。

## 第五层：`remoteConnectionStatus` 与 `remoteBackgroundTaskCount` 更像 viewer / remote client 运行面，不是 bridge host 状态

### 这组状态不属于 bridge 那套 `replBridge*`

`AppStateStore` 把它们单独列在：

- `remoteConnectionStatus`
- `remoteBackgroundTaskCount`

并紧接着才进入：

- `replBridgeEnabled`
- `replBridgeConnected`
- `replBridgeSessionActive`

这说明产品从状态树层面就承认：

- remote session client / viewer
- always-on bridge

不是同一条状态链。

### `remoteBackgroundTaskCount` 的对象是“远端 daemon child 里跑着的任务”

`useRemoteSession.ts` 写得非常清楚：

- viewer 自己的 `AppState.tasks` 是空的
- 任务活在另一进程
- `remoteBackgroundTaskCount` 由 WS 事件驱动

所以更准确的理解是：

- 它不是本地当前 REPL 的后台任务计数

而是：

- 当前附着的远端 session 背后，那台远端 worker 里还在跑多少任务

### Spinner 也把它和本地任务一起折叠成 brief idle 状态

`Spinner.tsx` 会把：

- 本地 background tasks
- `remoteBackgroundTaskCount`

加总，并且同时看：

- `remoteConnectionStatus`

来决定显示：

- `Reconnecting…`
- `Disconnected`
- `n in background`

这说明这组状态确实会被用户感知，但应写成：

- remote viewer / client 的运行面

而不是：

- bridge host 的连接状态页

## 第六层：稳定主线、条件面与内部面要继续保护

### 稳定可见或相对稳定可见的

- `claude --remote`
- `/session`
- footer 的 `remote` pill
- `claude assistant [sessionId]`
- remote-safe commands 的存在本身

这些都属于 reader-facing 主线，适合进入正文。

### 条件公开或应降权写入边界说明的

- `--remote` 在 non-TUI gate 下只打印并退出
- `assistant [sessionId]` 是 KAIROS feature-gated
- `viewerOnly` 是内部字段，但其用户可见后果值得写
- `remoteConnectionStatus` / `remoteBackgroundTaskCount` 更适合写成运行面说明，不必扩展所有内部细节

### 更应留在实现边界说明的

- 远端消息转换的完整细节
- WebSocket / ingress 协议实现
- session title 更新的全部底层调用
- 所有 reconnect / timeout 细枝末节

这些只作为作者判断依据，不回流正文主线。

## 最后的判断公式

当你看到 `--remote`、`/session`、assistant viewer 与 remote-safe commands 时，先问七个问题：

1. 这次是我在创建一条新的远端 session，还是附着到已有 session？
2. 当前 REPL 是 remote session client，还是更偏 viewer client？
3. 当前 surface 依赖的是 `remoteSessionUrl`，还是只是 remote-mode 布尔状态？
4. 现在这组状态属于 remote session 运行面，还是 bridge host 运行面？
5. 这里约束的是 remote-safe commands，还是 bridge inbound commands？
6. 我现在看的，是 `--remote` 链，还是 `assistant [sessionId]` viewer 链？
7. 我是不是把远端 session client、viewer 与 bridge host 又压成了一种远程工作流？

只要这七问先答清，就不会把这些对象误写成同一条“远程模式”。

## 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/commands/session/session.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
- `claude-code-source-code/src/commands.ts`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/components/Spinner.tsx`
