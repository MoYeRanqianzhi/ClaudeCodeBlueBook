# 功能全景与 API 支持

这一章回答两个问题:

1. Claude Code 到底支持哪些能力面。
2. 这些能力分别通过什么接口暴露出来。

为了避免“看到一点功能就写一点功能”的碎片化，本章按 runtime 表面来组织。

## 0. 先带着三条判断读功能表

这一章虽然在列能力面，但更稳的读法不是把它当“功能总清单”，而是先带着三句判断来读：

1. Prompt 线
   - 这些接口最终在帮助什么合法进入模型
2. 治理线
   - 这些接口最终在决定什么扩张配进入当前世界
3. 源码质量线
   - 这些接口是主路径能力、宿主子集、声明先行，还是仍需按证据梯度克制表述

如果不先带着这三句判断，本章就很容易重新退回：

- “能力很多”
- “接口很多”
- “好像什么都支持”

第一性原理上，接口面不是功能炫耀，而是 runtime 决定什么能进入模型、什么能进入当前世界、什么又能以何种代价持续存在的合法入口。

所以本章里每列出一个“能力面”，都还要继续追问四次。最小顺序应固定为：

1. 入口是否存在
2. 当前公开实现是否闭合
3. 当前是否进入主路径或至少进入稳定子集
4. 当前是否已被允许，并且已形成可对外承诺的产品面

如果这四问还回答不清，就不要继续停在功能总览页：

1. 回 `09`
   - 先定义世界进入模型、扩张定价与当前真相保护
2. 回 `navigation/05`
   - 先校正你到底在模仿功能表还是控制面
3. 回 `navigation/15`
   - 先找 first reject path
4. 回 `navigation/41`
   - 再确认高阶总结是否已经压回第一性原理

## 1. 八个接口表面只是索引，不是前门答案

如果把 Claude Code 当作一个 coding agent runtime，而不是一个聊天框，它至少要暴露八类接口:

1. 人类交互接口: CLI、REPL、slash command。
2. 执行接口: tool、task、subagent。
3. 扩展接口: skill、plugin、MCP。
4. 自动化接口: headless、SDK、structured IO。
5. 宿主控制接口: control request/response、permission handshake、interrupt、settings/context/state control。
6. 远程接口: remote session、bridge、CCR transport、direct connect。
7. 状态接口: transcript、session、context usage、settings、rewind、`worker_status` / `external_metadata`。
8. 协作接口: coordinator、team context、task list、task progress、workflow progress、task notification。

这八个表面只回答一件事：

- Claude Code 的 runtime 远不止“几个命令 + 几个工具”，而是把交互、执行、宿主、远程、状态、协作与扩展都做成了正式 surface。

但它们还不是前门答案，更不是产品承诺。真正要继续回答的仍是四层问题：

1. 它是否正式存在
2. 当前公开实现是否闭合
3. 当前是否进入主路径或稳定子集
4. 当前是否已形成可对外承诺的产品面

治理线里还要额外补一句：

- `Context Usage`、mode 条、token 百分比与 dashboard 投影都不是功能前门答案；它们只能在 `decision window / current admission / product promise` 已经分清后，作为宿主消费投影继续出现

因此下面的长表只负责给出代表入口与对象 truth，不再抢答“是否支持到哪一层”。更细的矩阵与对象总表，统一回到 `08`、`api/23`、`api/24` 与 `api/30`。

## 2. 代表性能力面与对象 truth 索引

下面各节只保留代表入口，用来回答：

- 这一面确实存在什么正式对象
- 当前公开树里能看到哪些实现真相

它们默认还没有替你回答：

- 当前是否进入主路径
- 当前是否已被允许
- 当前是否已形成产品承诺

### 2.1 交互与工作流控制

源码中同时存在三层命令面：

- `src/commands/` 下可见 `86` 个一级命令目录
- `COMMANDS()` 主列表作为 builtin 控制平面
- `getCommands()` 在运行时继续叠加 skills、plugins、workflow 与 dynamic skills

因此 Claude Code 的命令面不能只按 builtin slash command 理解。除此之外，它还会动态叠加:

- bundled skills
- builtin plugin skills
- skill dir commands
- workflow commands
- plugin commands
- plugin skills
- dynamic skills

证据:

- `claude-code-source-code/src/commands.ts:224-346`
- `claude-code-source-code/src/commands.ts:258-346`
- `claude-code-source-code/src/commands.ts:449-469`
- `claude-code-source-code/src/commands.ts:476-517`

这说明 slash command 不是旁路，而是产品的正式控制平面。

### 2.2 工具执行面

本地 `src/tools/` 一级目录中约有 `42` 个工具子目录，`getAllBaseTools()` 则定义了运行时基础工具全集。

其中稳定主路径工具包括:

- `BashTool`
- `FileReadTool`
- `FileEditTool`
- `FileWriteTool`
- `NotebookEditTool`
- `WebFetchTool`
- `WebSearchTool`
- `TodoWriteTool`
- `AgentTool`
- `SkillTool`
- `AskUserQuestionTool`
- MCP 资源与任务相关工具

证据:

- `claude-code-source-code/src/tools.ts:193-250`
- `claude-code-source-code/src/tools.ts:271-367`

### 2.3 命令/技能/插件三层能力面

`Command` 在类型层被明确分成三类:

- `prompt`
- `local`
- `local-jsx`

并带有:

- `availability`
- `isEnabled`
- `loadedFrom`
- `whenToUse`
- `allowedTools`
- `context`
- `agent`
- `effort`

证据:

- `claude-code-source-code/src/types/command.ts:25-57`
- `claude-code-source-code/src/types/command.ts:74-152`
- `claude-code-source-code/src/types/command.ts:175-206`

这意味着 Claude Code 的命令面本质上也是一套可组合的 API。

### 2.4 SDK / automation 面

SDK 公开入口 `agentSdkTypes.ts` 暴露了至少两类东西:

- 类型与 schema 导出的公共面
- 会话、查询、session 管理、SDK-MCP server 构造等函数面

显式可见函数包括:

- `tool(...)`
- `createSdkMcpServer(...)`
- `query(...)`
- `unstable_v2_createSession(...)`
- `unstable_v2_resumeSession(...)`
- `unstable_v2_prompt(...)`
- `getSessionMessages(...)`
- `listSessions(...)`
- `getSessionInfo(...)`
- `renameSession(...)`
- `tagSession(...)`
- `forkSession(...)`

证据:

- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:17-31`
- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:73-107`
- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:111-272`

### 2.5 宿主与控制协议面

`StructuredIO`、`controlSchemas.ts`、`print.ts` 共同说明：

- Claude Code 有正式的 `control_request` / `control_response` / `control_cancel_request` 协议。
- host 可以发 `interrupt`、`get_context_usage`、`mcp_status`、`mcp_set_servers`、`get_settings` 等控制请求。
- `StructuredIO` 内部显式维护 `pendingRequests`、`resolvedToolUseIds`、统一 FIFO outbound。

这意味着 Claude Code 的自动化面并不止于“脚本化 query”，还包括“宿主级控制平面”。

证据:

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-173`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:175-519`
- `claude-code-source-code/src/cli/structuredIO.ts:135-162`
- `claude-code-source-code/src/cli/structuredIO.ts:333-429`
- `claude-code-source-code/src/cli/structuredIO.ts:470-773`

### 2.6 MCP / transport 面

MCP 在 Claude Code 中既是 client 扩展总线，也是可反向暴露的 server 表面。

支持的 transport 类型至少包括:

- `stdio`
- `sse`
- `sse-ide`
- `http`
- `ws`
- `sdk`

证据:

- `claude-code-source-code/src/services/mcp/types.ts:10-26`
- `claude-code-source-code/src/services/mcp/types.ts:124-161`

### 2.7 远程与桥接面

远程执行面并不是单一 websocket，而是至少三条路径:

- `StructuredIO` 负责 control request/response 语义
- `RemoteIO` 负责 transport、session token、CCR v2、keepalive
- `DirectConnectSessionManager` 与 `RemoteSessionManager` 进一步把宿主面窄化成 direct-connect 与 remote-session 两类接入器

证据:

- `claude-code-source-code/src/cli/structuredIO.ts:135-162`
- `claude-code-source-code/src/cli/remoteIO.ts:31-42`
- `claude-code-source-code/src/cli/remoteIO.ts:111-168`
- `claude-code-source-code/src/server/directConnectManager.ts:40-210`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts:87-323`

### 2.8 状态回写与宿主真相面

Claude Code 的状态接口不只体现在：

- `SDKMessage`
- session API
- transcript / rewind

还体现在宿主真相回写面：

- `worker_status`
- `requires_action_details`
- `external_metadata.pending_action`
- `external_metadata.permission_mode`
- `external_metadata.model`

这说明它给宿主暴露的不是“只读消息流”，而是“消息流 + 可查询状态快照”的组合 API。

证据：

- `claude-code-source-code/src/utils/sessionState.ts:1-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:19-91`
- `claude-code-source-code/src/cli/transports/ccrClient.ts:476-545`
- `claude-code-source-code/src/cli/transports/ccrClient.ts:645-662`
- `claude-code-source-code/src/cli/remoteIO.ts:111-168`

### 2.9 提示词与上下文注入面

Claude Code 还有一层经常被低估的正式接口面：

- `--system-prompt`
- `--append-system-prompt`
- SDK `initialize.systemPrompt`
- SDK `initialize.appendSystemPrompt`
- agent `getSystemPrompt()`
- skill `getPromptForCommand(...)`
- attachment / reminder 注入

也就是说，prompt 在 Claude Code 中不是一段隐藏常量，而是一组可装配注入面。

但这层表面真正值钱的不是“可以注入多少 prompt”，而是这些入口最终都要回到请求装配控制面：`authority chain`、`section registry`、`protocol transcript` 与 `continuation qualification` 是否仍围绕同一个 `compiled request truth`。

证据:

- `claude-code-source-code/src/main.tsx:1343-1387`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-72`
- `claude-code-source-code/src/utils/systemPrompt.ts:27-121`
- `claude-code-source-code/src/skills/loadSkillsDir.ts:181-344`
- `claude-code-source-code/src/tools/AgentTool/loadAgentsDir.ts:474-731`

### 2.10 协作与 workflow 面

Claude Code 还有一层常被低估的正式接口面：

- coordinator system prompt
- worker / teammate prompt addendum
- `team_context` / `teammate_mailbox` attachments
- `task_started` / `task_progress` / `task_notification`
- workflow progress delta

这意味着它暴露的不只是“起一个 subagent”：

- 还有多 Agent 协作协议
- task 生命周期事件
- workflow 分阶段进度

证据：

- `claude-code-source-code/src/coordinator/coordinatorMode.ts:111-260`
- `claude-code-source-code/src/utils/messages.ts:3457-3490`
- `claude-code-source-code/src/utils/swarm/inProcessRunner.ts:871-1043`
- `claude-code-source-code/src/utils/sdkEventQueue.ts:1-118`
- `claude-code-source-code/src/utils/task/sdkProgress.ts:1-35`

### 2.11 恢复与持久化面

Claude Code 还有一层很容易被误算进“内部实现”的正式表面：

- transcript
- sidechain transcript
- `output_file`
- resume / continue
- file history / rewind

这说明它暴露的不是一次性执行 API，而是：

- 可恢复执行 API

证据：

- `claude-code-source-code/src/utils/sessionStorage.ts:1451-1545`
- `claude-code-source-code/src/utils/conversationRecovery.ts:456-541`
- `claude-code-source-code/src/utils/sessionRestore.ts:99-147`
- `claude-code-source-code/src/tasks/LocalMainSessionTask.ts:358-416`
- `claude-code-source-code/src/utils/task/TaskOutput.ts:32-110`

### 2.12 任务、工作流与服务平面

如果继续把“全部功能支持”往下压，会发现还有两层经常被漏写：

1. 任务与工作流面：
   - `TaskType` 当前显式区分 `local_bash`、`local_agent`、`remote_agent`、`in_process_teammate`、`local_workflow`、`monitor_mcp`、`dream`
   - `getAllTasks()` 当前显式注册 `LocalShellTask`、`LocalAgentTask`、`RemoteAgentTask`、`DreamTask`，并按 gate 注入 `LocalWorkflowTask` 与 `MonitorMcpTask`
2. 服务平面：
   - `src/services/` 当前至少可见约 `20` 个一级子域，覆盖 `api`、`compact`、`mcp`、`plugins`、`SessionMemory`、`remoteManagedSettings`、`policyLimits`、`analytics` 等

这意味着 Claude Code 的能力面不仅是“命令 + 工具 + SDK”，还包括：

- 后台任务对象模型
- workflow 执行与可视化
- 长生命周期服务子系统

证据：

- `claude-code-source-code/src/Task.ts:6-124`
- `claude-code-source-code/src/tasks.ts:1-39`
- `claude-code-source-code/src/services/`

### 2.13 对象 truth 与回链

前面的长表到这里应当停住。它们的职责只是把代表对象摆出来，避免蓝皮书把 runtime 缩成几个命令、几个工具和一条 `query()`。

如果继续追问“当前到底承诺到哪”，就不该让这些长表在前门里继续抢答，而应回到矩阵页和对象 truth 页：

- [能力平面、公开度与宿主支持矩阵](api/23-%E8%83%BD%E5%8A%9B%E5%B9%B3%E9%9D%A2%E3%80%81%E5%85%AC%E5%BC%80%E5%BA%A6%E4%B8%8E%E5%AE%BF%E4%B8%BB%E6%94%AF%E6%8C%81%E7%9F%A9%E9%98%B5.md)
- [命令、工具、会话、宿主与协作 API 全谱系](api/24-%E5%91%BD%E4%BB%A4%E3%80%81%E5%B7%A5%E5%85%B7%E3%80%81%E4%BC%9A%E8%AF%9D%E3%80%81%E5%AE%BF%E4%B8%BB%E4%B8%8E%E5%8D%8F%E4%BD%9CAPI%E5%85%A8%E8%B0%B1%E7%B3%BB.md)
- [源码目录级能力地图：commands、tools、services、状态与宿主平面](api/30-%E6%BA%90%E7%A0%81%E7%9B%AE%E5%BD%95%E7%BA%A7%E8%83%BD%E5%8A%9B%E5%9C%B0%E5%9B%BE%EF%BC%9Acommands%E3%80%81tools%E3%80%81services%E3%80%81%E7%8A%B6%E6%80%81%E4%B8%8E%E5%AE%BF%E4%B8%BB%E5%B9%B3%E9%9D%A2.md)

这些回链的价值不在新增字段，而在于把：

- 命令控制平面
- 工具执行平面
- 任务/团队协作平面
- worktree / remote / trigger 自动化平面
- query / session / control / remote 接入平面

重新放回同一张能力与接入地图，并按四层判断继续拆开。

## 3. API 支持不是一层，而是至少七层

从源码看，Claude Code 的“API”至少可以拆成七层。

### 3.1 人类命令 API

这是用户最容易感知的一层：

- `claude` CLI 参数
- slash commands
- REPL 行为与本地 UI commands

### 3.2 结构化能力 API

这是模型与 runtime 的核心约定：

- Tool schema
- ToolUseContext
- Permission decision
- Task lifecycle

### 3.3 控制协议 API

这是 SDK host 与 CLI 进程之间的协议：

- initialize
- can_use_tool
- interrupt
- get_context_usage
- mcp_status
- reload_plugins
- rewind_files
- get_settings
- mcp_set_servers

以及其他控制消息。

### 3.4 状态真相 API

这一层的重点不是 request/response，而是宿主如何知道“当前到底发生了什么”：

- `SDKMessage`
- `worker_status`
- `external_metadata`
- `session_state_changed`
- `pending_action`

这一层决定 Claude Code SDK 更像 runtime event/state API，而不是普通回答 API。

### 3.5 传输与宿主 API

这是跨进程、跨网络、跨环境的连接语义：

- stdio
- structured IO
- SSE / WebSocket / HTTP
- session ingress
- CCR v2 internal events

### 3.6 Prompt 与知识注入 API

这是这一轮继续补强后更清晰的一层：

- `--system-prompt`
- `--append-system-prompt`
- SDK initialize `systemPrompt` / `appendSystemPrompt`
- `CLAUDE.md` / `.claude/*`
- typed memory / `MEMORY.md`
- nested memory / relevant memories

它说明 Claude Code 的上下文控制面不只是一段 system prompt，而是一组分层注入表面。

### 3.7 协作与生态 API

这一层覆盖两类以前容易被低估的能力：

1. 协作运行时：
   - `task_started`
   - `task_notification`
   - coordinator / worker contract
   - mailbox / team context
2. 生态接入：
   - builtin plugin
   - marketplace plugin
   - MCPB / DXT
   - LSP
   - channels

它说明 Claude Code 的正式能力面，已经超出了“单 agent + 单 prompt + 单工具集”。

### 3.8 公开度与成熟度 API

这一轮继续下沉后，还需要再补一层：

- 哪些入口属于公共主路径
- 哪些入口属于宿主主路径
- 哪些当前只是声明先行
- 哪些虽然能看见，但仍受 gate、policy、账号与 adapter 子集约束

如果不把这一层写出来，功能全景仍然会不够稳，因为“看见了入口”和“能稳定接入”之间还差一个完整判断步骤。

## 4. 这章真正要纠正哪些判断误差

这章真正要纠正的，不是“知识不够多”，而是四类判断误差：

1. 不再只讲架构，而忽略命令、工具、SDK、MCP、远程这些正式接口面。
2. 不再把 public/gated/internal 混写，而是把接口边界、能力边界和产品边界分开。
3. 不再只看“模型如何调用工具”，而是把“外部宿主如何控制 CLI”也纳入 API 版图。
4. 不再把宿主集成只写成事件流，而是把状态回写、外部 metadata 与 consumer subset 也纳入 API 真相面。
5. 不再只问“有没有接口”，而开始问“它属于公共主路径、宿主主路径、声明先行还是产品受限”。

## 5. 仍然存在的边界

需要明确三点:

1. `agentSdkTypes.ts` 会 re-export `runtimeTypes`、`toolTypes`、`controlTypes` 等子模块，但这份提取源码里没有看到这些源码文件；因此本章对 SDK 的判断以入口、schema 和已知导出为准。
2. 出现于公开源码中的 schema 或函数名，不等于它已经是对外稳定承诺。
3. 被 `feature()` 或 GrowthBook gate 控制的接口，不应直接写成“所有用户都可用”。

## 6. 如果要继续把能力表读稳，优先回到哪里

如果你正在追问“Claude Code 到底暴露了哪些正式能力面”，优先回：

- [能力全集、公开度与成熟度矩阵](08-%E8%83%BD%E5%8A%9B%E5%85%A8%E9%9B%86%E3%80%81%E5%85%AC%E5%BC%80%E5%BA%A6%E4%B8%8E%E6%88%90%E7%86%9F%E5%BA%A6%E7%9F%A9%E9%98%B5.md)
- [命令与功能矩阵](api/01-%E5%91%BD%E4%BB%A4%E4%B8%8E%E5%8A%9F%E8%83%BD%E7%9F%A9%E9%98%B5.md)
- [内置命令域索引](api/06-%E5%86%85%E7%BD%AE%E5%91%BD%E4%BB%A4%E5%9F%9F%E7%B4%A2%E5%BC%95.md)
- [命令字段与可用性索引](api/07-%E5%91%BD%E4%BB%A4%E5%AD%97%E6%AE%B5%E4%B8%8E%E5%8F%AF%E7%94%A8%E6%80%A7%E7%B4%A2%E5%BC%95.md)
- [能力平面、公开度与宿主支持矩阵](api/23-%E8%83%BD%E5%8A%9B%E5%B9%B3%E9%9D%A2%E3%80%81%E5%85%AC%E5%BC%80%E5%BA%A6%E4%B8%8E%E5%AE%BF%E4%B8%BB%E6%94%AF%E6%8C%81%E7%9F%A9%E9%98%B5.md)
- [命令、工具、会话、宿主与协作 API 全谱系](api/24-%E5%91%BD%E4%BB%A4%E3%80%81%E5%B7%A5%E5%85%B7%E3%80%81%E4%BC%9A%E8%AF%9D%E3%80%81%E5%AE%BF%E4%B8%BB%E4%B8%8E%E5%8D%8F%E4%BD%9CAPI%E5%85%A8%E8%B0%B1%E7%B3%BB.md)
- [源码目录级能力地图：commands、tools、services、状态与宿主平面](api/30-%E6%BA%90%E7%A0%81%E7%9B%AE%E5%BD%95%E7%BA%A7%E8%83%BD%E5%8A%9B%E5%9C%B0%E5%9B%BE%EF%BC%9Acommands%E3%80%81tools%E3%80%81services%E3%80%81%E7%8A%B6%E6%80%81%E4%B8%8E%E5%AE%BF%E4%B8%BB%E5%B9%B3%E9%9D%A2.md)

如果你正在追问“宿主如何接入、控制、恢复与消费真相”，优先回：

- [Agent SDK 与控制协议](api/02-Agent%20SDK%E4%B8%8E%E6%8E%A7%E5%88%B6%E5%8D%8F%E8%AE%AE.md)
- [StructuredIO 与 RemoteIO 宿主协议手册](api/13-StructuredIO%E4%B8%8ERemoteIO%E5%AE%BF%E4%B8%BB%E5%8D%8F%E8%AE%AE%E6%89%8B%E5%86%8C.md)
- [Control 子类型与宿主适配矩阵](api/14-Control%E5%AD%90%E7%B1%BB%E5%9E%8B%E4%B8%8E%E5%AE%BF%E4%B8%BB%E9%80%82%E9%85%8D%E7%9F%A9%E9%98%B5.md)
- [Control 协议字段对照与宿主接入样例](api/15-Control%E5%8D%8F%E8%AE%AE%E5%AD%97%E6%AE%B5%E5%AF%B9%E7%85%A7%E4%B8%8E%E5%AE%BF%E4%B8%BB%E6%8E%A5%E5%85%A5%E6%A0%B7%E4%BE%8B.md)
- [SDK 消息与 Control 闭环对照表](api/16-SDK%E6%B6%88%E6%81%AF%E4%B8%8EControl%E9%97%AD%E7%8E%AF%E5%AF%B9%E7%85%A7%E8%A1%A8.md)
- [状态消息、外部元数据与宿主消费矩阵](api/17-%E7%8A%B6%E6%80%81%E6%B6%88%E6%81%AF%E3%80%81%E5%A4%96%E9%83%A8%E5%85%83%E6%95%B0%E6%8D%AE%E4%B8%8E%E5%AE%BF%E4%B8%BB%E6%B6%88%E8%B4%B9%E7%9F%A9%E9%98%B5.md)
- [MCP 与远程传输](api/03-MCP%E4%B8%8E%E8%BF%9C%E7%A8%8B%E4%BC%A0%E8%BE%93.md)

如果你正在追问“Prompt、记忆、扩展与生态怎样进入这套 runtime”，优先回：

- [系统提示词、Frontmatter 与上下文注入手册](api/18-%E7%B3%BB%E7%BB%9F%E6%8F%90%E7%A4%BA%E8%AF%8D%E3%80%81Frontmatter%E4%B8%8E%E4%B8%8A%E4%B8%8B%E6%96%87%E6%B3%A8%E5%85%A5%E6%89%8B%E5%86%8C.md)
- [提示词控制、知识注入与记忆 API 手册](api/21-%E6%8F%90%E7%A4%BA%E8%AF%8D%E6%8E%A7%E5%88%B6%E3%80%81%E7%9F%A5%E8%AF%86%E6%B3%A8%E5%85%A5%E4%B8%8E%E8%AE%B0%E5%BF%86API%E6%89%8B%E5%86%8C.md)
- [扩展 Frontmatter 与插件 Agent 手册](api/10-%E6%89%A9%E5%B1%95Frontmatter%E4%B8%8E%E6%8F%92%E4%BB%B6Agent%E6%89%8B%E5%86%8C.md)
- [MCP 配置与连接状态机](api/12-MCP%E9%85%8D%E7%BD%AE%E4%B8%8E%E8%BF%9E%E6%8E%A5%E7%8A%B6%E6%80%81%E6%9C%BA.md)
- [插件、Marketplace、MCPB、LSP与Channels接入边界手册](api/22-%E6%8F%92%E4%BB%B6%E3%80%81Marketplace%E3%80%81MCPB%E3%80%81LSP%E4%B8%8EChannels%E6%8E%A5%E5%85%A5%E8%BE%B9%E7%95%8C%E6%89%8B%E5%86%8C.md)

如果你正在追问“这些接口为什么要按这种方式设计”，优先回：

- [compact 算法与上下文管理细拆](architecture/08-compact%E7%AE%97%E6%B3%95%E4%B8%8E%E4%B8%8A%E4%B8%8B%E6%96%87%E7%AE%A1%E7%90%86%E7%BB%86%E6%8B%86.md)
- [会话存储、记忆与回溯状态面](architecture/09-%E4%BC%9A%E8%AF%9D%E5%AD%98%E5%82%A8%E8%AE%B0%E5%BF%86%E4%B8%8E%E5%9B%9E%E6%BA%AF%E7%8A%B6%E6%80%81%E9%9D%A2.md)
- [AgentTool 与隔离编排](architecture/10-AgentTool%E4%B8%8E%E9%9A%94%E7%A6%BB%E7%BC%96%E6%8E%92.md)
- [权限系统全链路与 Auto Mode](architecture/11-%E6%9D%83%E9%99%90%E7%B3%BB%E7%BB%9F%E5%85%A8%E9%93%BE%E8%B7%AF%E4%B8%8EAuto%20Mode.md)
- [ClaudeAPI 与流式工具执行](architecture/12-ClaudeAPI%E4%B8%8E%E6%B5%81%E5%BC%8F%E5%B7%A5%E5%85%B7%E6%89%A7%E8%A1%8C.md)
- [StructuredIO 与 RemoteIO 控制平面](architecture/13-StructuredIO%E4%B8%8ERemoteIO%E6%8E%A7%E5%88%B6%E5%B9%B3%E9%9D%A2.md)
- [Bridge 与宿主适配器分层](architecture/14-Bridge%E4%B8%8E%E5%AE%BF%E4%B8%BB%E9%80%82%E9%85%8D%E5%99%A8%E5%88%86%E5%B1%82.md)
- [宿主路径时序与竞速](architecture/15-%E5%AE%BF%E4%B8%BB%E8%B7%AF%E5%BE%84%E6%97%B6%E5%BA%8F%E4%B8%8E%E7%AB%9E%E9%80%9F.md)
- [远程恢复与重连状态机](architecture/16-%E8%BF%9C%E7%A8%8B%E6%81%A2%E5%A4%8D%E4%B8%8E%E9%87%8D%E8%BF%9E%E7%8A%B6%E6%80%81%E6%9C%BA.md)
- [宿主控制平面优于聊天外壳](philosophy/09-%E5%AE%BF%E4%B8%BB%E6%8E%A7%E5%88%B6%E5%B9%B3%E9%9D%A2%E4%BC%98%E4%BA%8E%E8%81%8A%E5%A4%A9%E5%A4%96%E5%A3%B3.md)
- [协议全集不等于适配器子集](philosophy/10-%E5%8D%8F%E8%AE%AE%E5%85%A8%E9%9B%86%E4%B8%8D%E7%AD%89%E4%BA%8E%E9%80%82%E9%85%8D%E5%99%A8%E5%AD%90%E9%9B%86.md)
- [显式失败优于假成功](philosophy/11-%E6%98%BE%E5%BC%8F%E5%A4%B1%E8%B4%A5%E4%BC%98%E4%BA%8E%E5%81%87%E6%88%90%E5%8A%9F.md)
- [闭环状态机优于单向请求](philosophy/12-%E9%97%AD%E7%8E%AF%E7%8A%B6%E6%80%81%E6%9C%BA%E4%BC%98%E4%BA%8E%E5%8D%95%E5%90%91%E8%AF%B7%E6%B1%82.md)
