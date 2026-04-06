# Bridge Permission Callbacks、Control Request 与 Bridge-safe Commands：为什么远端的权限提示、会话控制与命令白名单不是同一种控制合同

## 用户目标

不是只知道 Claude Code “远端也能点权限、好像还能改模型或 permission mode、某些 slash command 在手机上又能跑”，而是先分清四类不同控制对象：

- 哪些是权限提示的响应回路。
- 哪些是会话级控制请求。
- 哪些是 remote-control bridge inbound 的命令白名单。
- 哪些只是 remote session client 自己在本地 REPL 里的可见命令集合。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“远端控制”：

- `can_use_tool`
- `replBridgePermissionCallbacks`
- `channelPermissionCallbacks`
- `set_permission_mode`
- `set_model`
- `set_max_thinking_tokens`
- `BRIDGE_SAFE_COMMANDS`
- `REMOTE_SAFE_COMMANDS`
- `viewerOnly`

## 第一性原理

Claude Code 的远端控制面至少沿着四条轴线分化：

1. `Decision Object`：当前是在回答某个具体工具调用能不能执行，还是在修改整条 session 的控制参数。
2. `Transport`：当前决定来自本地 UI、bridge、频道消息，还是别的自动化检查。
3. `Command Contract`：当前约束的是 bridge inbound slash command，还是 remote session client 本地可见命令。
4. `Ownership`：当前远端侧是一个 bidirectional bridge controller，还是只是 remote session viewer / client。

因此更稳的提问不是：

- “远端现在是不是有控制权？”

而是：

- “它现在是在响应单次权限提示、在改整条 session 的控制参数、还是只拥有一小组被允许的命令；这条控制又是通过哪条 transport 过来的？”

只要这四条轴线没先拆开，正文就会把权限响应、控制请求和命令白名单写成同一种“远端控制”。

## 第一层：`can_use_tool` 是单次权限提示回路，不是 generic session control

### bridge permission callbacks 的对象是“某一次工具调用能不能执行”

`useReplBridge.tsx` 在非 outbound-only 分支里会构造：

- `replBridgePermissionCallbacks`

其中：

- `sendRequest(...)` 发送 `control_request`
- `request.subtype = 'can_use_tool'`
- 带上 `tool_name`、`input`、`tool_use_id`、`description`

这说明它回答的问题不是：

- “整条 session 现在是什么模式”

而是：

- “这一次具体工具调用，远端要不要允许它继续”

### `useCanUseTool` 把它接进的是交互权限分支，不是通用命令执行流

`useCanUseTool.tsx` 调用 `handleInteractivePermission(...)` 时，会把：

- `bridgeCallbacks: appState.replBridgePermissionCallbacks`
- `channelCallbacks: appState.channelPermissionCallbacks`

一起传进去。

这说明 bridge permission callbacks 不是独立控制平面，而是：

- 交互权限系统里的一个 racer

它与本地 UI、channel callbacks、hooks、classifier 同时竞争谁先给出结论。

### `claim()` 的存在说明“谁先响应”才是这个回路的第一性原理

`PermissionContext.ts` 里：

- `claim()` 是原子 check-and-mark
- 谁先 claim，谁赢

而 `interactiveHandler.ts` 也明确写了：

- local / CCR / channel / hook / classifier 是并行竞争
- whichever side responds first wins via `claim()`

因此更准确的理解是：

- `can_use_tool` 不是一个单线“远端审批流程”
- 而是一场带原子抢占的竞态决策

### 所以权限提示回路不等于“远端拥有整条 session”

更稳的区分是：

- `can_use_tool`：单次工具调用是否放行
- session control：模型、thinking、permission mode 这类整条会话参数

两者都走 control message，但不是同一种对象。

## 第二层：`set_permission_mode`、`set_model`、`set_max_thinking_tokens` 是 session control request，不是权限审批

### bridge inbound `control_request` 不只包含 `can_use_tool`

`bridgeMessaging.ts` 的注释写得很清楚：

- inbound `control_request` subtype 包括
  `initialize`
  `set_model`
  `can_use_tool`

并强调：

- 必须及时响应，否则 server 会 kill WS

这说明 control request 是更宽的一层：

- 它包含权限提示
- 也包含会话参数控制

### `onSetModel` 与 `onSetMaxThinkingTokens` 改的是 session 运行参数

`useReplBridge.tsx` 初始化 bridge 时，会把：

- `onSetModel(model)`
- `onSetMaxThinkingTokens(maxTokens)`

挂到 bridge handle 上。

它们做的分别是：

- 改 `mainLoopModelForSession`
- 改当前 `thinkingEnabled`

这说明这些 request 的对象是：

- 当前 session 的运行参数

而不是：

- 某一次工具调用是否批准

### `onSetPermissionMode` 更说明这是 session contract，不是单次 prompt

同一处代码里，`onSetPermissionMode(mode)` 还会：

- 先跑 policy guards
- 校验 `bypassPermissions` 是否被禁用
- 校验 `auto` gate 是否可用
- 再通过 `transitionPermissionMode(...)` 更新 `toolPermissionContext.mode`

这说明它解决的问题是：

- 当前 session 整体处于哪种 permission mode

而不是：

- 某一个 `can_use_tool` prompt 的 yes/no

### 因而“能回答权限提示”与“能修改 permission mode”不是同一层控制权

更稳的区分是：

- `can_use_tool`：单次工具权限决策
- `set_permission_mode`：整条 session 的权限模式状态
- `set_model` / `set_max_thinking_tokens`：整条 session 的推理参数状态

只要这一层不拆开，正文就会把所有 control_request 误写成“审批按钮”。

## 第三层：`BRIDGE_SAFE_COMMANDS` 与 `REMOTE_SAFE_COMMANDS` 不是同一张白名单

### `BRIDGE_SAFE_COMMANDS` 的对象是 bridge inbound slash command

`commands.ts` 对这组集合写得非常清楚：

- 这是收到自 mobile/web 的 Remote Control bridge 输入后
- 哪些 `local` command 可以安全执行
- `local-jsx` 默认 blocked
- `prompt` commands 默认 allowed

并且默认白名单只有：

- `compact`
- `clear`
- `cost`
- `summary`
- `releaseNotes`
- `files`

这说明它回答的问题是：

- “远端 bridge 客户端输入进来的 slash command，哪些能真正落地执行”

### `REMOTE_SAFE_COMMANDS` 的对象则是 remote session client 本地 REPL 的命令集合

同一文件里，`REMOTE_SAFE_COMMANDS` 包含：

- `/session`
- `exit`
- `clear`
- `help`
- `theme`
- `usage`
- `mobile`

并由：

- `filterCommandsForRemoteMode(commands)`

用于预过滤 `--remote` / `assistant` 这类 remote session REPL。

这说明它回答的问题是：

- “当前 REPL 作为 remote session client / viewer 时，哪些本地命令还应该展示出来”

### 因而两张白名单连方向都不一样

更稳的区分是：

- `BRIDGE_SAFE_COMMANDS`：外面打进来的命令，能不能过桥执行
- `REMOTE_SAFE_COMMANDS`：当前本地 REPL 在 remote session 模式下，还该保留哪些本地命令

它们都叫“safe”，但 safe 的对象完全不同。

## 第四层：`viewerOnly` 进一步限制的是远端 session client 的控制合同，不是 bridge 权限回路

### `viewerOnly` 不接管 session title，也不做主动超时重连警告

`useRemoteSession.ts` 里：

- `viewerOnly` 时不更新 session title
- 不启用 `Remote session may be unresponsive. Attempting to reconnect…` 这条本地超时警告

这说明 viewerOnly 的心智不是：

- “完整控制者”

而是：

- “附着到已有 session 的较弱客户端”

### `viewerOnly` 下 `Ctrl+C` 也不应该打断远端 agent

同一处代码还明确写了：

- viewerOnly 时 `Ctrl+C` should never interrupt the remote agent

这再次说明：

- viewerOnly 的合同是受限的

而不是：

- 与 bridge controller 完全同权

### 所以 viewerOnly 不应与 bridge callbacks 混写成同一类“远端控制”

更稳的区分是：

- bridge callbacks：处理单次权限 prompt / session control request
- viewerOnly：定义 remote session attach client 的控制边界

一个是 control path，一个是 client role。

## 第五层：channel permission callbacks 说明远端权限响应不止 bridge 一条 transport

### AppState 里本来就把 bridge 与 channel 权限回路并排放着

`AppStateStore` 里：

- `replBridgePermissionCallbacks`
- `channelPermissionCallbacks`

被明确并排存放。

其中注释还直接写出：

- channel permission prompts 走 Telegram / iMessage 等
- 它们会和 local UI + bridge + hooks + classifier 一起 race

这说明产品从状态设计层面就承认：

- bridge 只是权限响应 transport 之一

而不是：

- “所有远端权限都等于 mobile/web bridge”

### channel permission relay 与 bridge relay 是平行 racer

`interactiveHandler.ts` 里：

- bridge block 先发送 `can_use_tool`
- channel block 通过 active channels 发送 yes/no 提示
- 两边都和 local UI / hook / classifier 竞争 claim

这说明正文写“远端权限响应”时，不能把 bridge 写成唯一 transport。

### 因而“远端能点权限”也应继续分 transport

更稳的写法是：

- 本地 UI
- bridge callback
- channel callback
- hooks / classifier

它们都可能给出决策，但不是一回事。

## 第六层：稳定主线、条件面与内部面要继续保护

### 稳定可见或相对稳定可见的

- 远端可以参与权限提示这一事实
- `permission mode`、`model`、`thinking` 这类 session control request 的存在
- `BRIDGE_SAFE_COMMANDS` 与 `REMOTE_SAFE_COMMANDS` 的对象差异
- viewerOnly 会收窄可做的控制动作

这些都适合进入 reader-facing 正文。

### 条件公开或应降权处理的

- `channelPermissionCallbacks` 依赖 active channels
- `set_permission_mode` 的可用性受 policy / gate / launch mode 影响
- `BRIDGE_SAFE_COMMANDS` 是显式 allowlist，不应被写成“所有命令都能在手机上跑”
- viewerOnly 的具体后果应写，但内部实现细节不应写太满

### 更应留在实现边界说明的

- control_request / control_response 的完整消息格式
- auth recovery / WS timeout 的实现细节
- hook / classifier / channel 所有竞态细枝末节
- 所有 `AppState` 函数字段的实现方式

这些只保留为作者判断依据，不回流正文主线。

## 最后的判断公式

当你看到远端在“改东西”“点权限”“跑命令”时，先问七个问题：

1. 现在是在回答单次 `can_use_tool`，还是在改整条 session 的控制参数？
2. 这个决策来自本地 UI、bridge、channel，还是别的 racer？
3. 这里约束的是 bridge inbound 命令，还是 remote session client 本地命令？
4. 这条远端侧是 bidirectional bridge controller，还是 viewerOnly client？
5. 我看到的是 permission response，还是 session control request？
6. 我是不是把 `BRIDGE_SAFE_COMMANDS` 与 `REMOTE_SAFE_COMMANDS` 混成一张白名单？
7. 我是不是把权限提示、会话控制与命令白名单又压成了同一种“远端控制”？

只要这七问先答清，就不会把远端控制合同写糊。

## 源码锚点

- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/hooks/useCanUseTool.tsx`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts`
- `claude-code-source-code/src/hooks/toolPermission/PermissionContext.ts`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/commands.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/services/mcp/channelPermissions.ts`
