# 功能全景与 API 支持

这一章回答两个问题:

1. Claude Code 到底支持哪些能力面。
2. 这些能力分别通过什么接口暴露出来。

为了避免“看到一点功能就写一点功能”的碎片化，本章按 runtime 表面来组织。

## 1. 从第一性原理看，Claude Code 至少有八个接口表面

如果把 Claude Code 当作一个 coding agent runtime，而不是一个聊天框，它至少要暴露八类接口:

1. 人类交互接口: CLI、REPL、slash command。
2. 执行接口: tool、task、subagent。
3. 扩展接口: skill、plugin、MCP。
4. 自动化接口: headless、SDK、structured IO。
5. 宿主控制接口: control request/response、permission handshake、interrupt、settings/context/state control。
6. 远程接口: remote session、bridge、CCR transport、direct connect。
7. 状态接口: transcript、session、context usage、settings、rewind、`worker_status` / `external_metadata`。
8. 协作接口: coordinator、team context、task list、task progress、workflow progress、task notification。

Claude Code 强的原因之一，是它几乎把这八类接口都做成了正式模块，而不是临时拼接。

## 2. 功能总矩阵

### 2.1 交互与工作流控制

源码中内置 `COMMANDS()` 主列表约 `61` 个命令项，此外还会动态叠加:

- bundled skills
- builtin plugin skills
- skill dir commands
- workflow commands
- plugin commands
- plugin skills
- dynamic skills

证据:

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

## 3. API 支持不是一层，而是五层

从源码看，Claude Code 的“API”至少可以拆成五层。

### 3.1 人类命令 API

这是用户最容易感知的一层:

- `claude` CLI 参数
- slash commands
- REPL 行为与本地 UI commands

### 3.2 结构化能力 API

这是模型与 runtime 的核心约定:

- Tool schema
- ToolUseContext
- Permission decision
- Task lifecycle

### 3.3 控制协议 API

这是 SDK host 与 CLI 进程之间的协议:

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

### 3.5 协作与任务 API

这一层更贴近多 Agent 与 workflow：

- `task_started`
- `task_progress`
- `task_notification`
- workflow progress
- coordinator / worker prompt contract

它说明 Claude Code 的正式对外面已经覆盖“协作运行时”，而不是只覆盖“单 agent 对话”。

### 3.4 传输 API

这是跨进程、跨网络、跨环境的连接语义:

- stdio
- structured IO
- SSE/WebSocket/HTTP
- session ingress
- CCR v2 internal events

### 3.5 状态同步 API

这是最容易被漏写，但对宿主最关键的一层:

- `worker_status`
- `requires_action_details`
- `external_metadata`
- delivery ack
- 远程恢复后的状态回写

## 4. 目前蓝皮书对“API 支持”的增强点

这一轮相较前一版，补的是四类缺口:

1. 不再只讲架构，还补命令、工具、SDK、MCP、远程这些实际接口面。
2. 不再把 public/gated/internal 混写，而是把接口边界和能力边界分开。
3. 不再只看“模型如何调用工具”，而是把“外部宿主如何控制 CLI”也纳入 API 版图。
4. 不再把宿主集成只写成事件流，而开始把状态回写、外部 metadata 与 consumer subset 也纳入 API 版图。

## 5. 仍然存在的边界

需要明确三点:

1. `agentSdkTypes.ts` 会 re-export `runtimeTypes`、`toolTypes`、`controlTypes` 等子模块，但这份提取源码里没有看到这些源码文件；因此本章对 SDK 的判断以入口、schema 和已知导出为准。
2. 出现于公开源码中的 schema 或函数名，不等于它已经是对外稳定承诺。
3. 被 `feature()` 或 GrowthBook gate 控制的接口，不应直接写成“所有用户都可用”。

## 6. 下一步应该怎么继续补

如果目标真的是“尽量覆盖全部功能和 API”，这一轮已经补上三块关键缺口:

1. 把命令面从功能域索引推进到字段级与可用性级。
2. 把 compact 从 query 主链推进到 `services/compact/*` 的算法层。
3. 把 feature gate 从概念描述推进到 build-time / runtime / compat shim 三层。

在此基础上，下一阶段优先级应是:

1. 把 `SDKMessageSchema` 的消息变体继续做完整表格。
2. 把 control request/response subtype 做更细的协议时序图。
3. 把 MCP config scope、transport、auth/needs-auth/error 状态做状态机图。
4. 把 Skills / Plugins / MCP 三层扩展面的统一模型继续下沉到字段级索引。
5. 把 AgentTool、team、worktree、remote 的编排语义继续做成时序图与状态图。
6. 把 permissions / auto mode / classifier / headless fallback 补到与工具面同等级的可检索粒度。
7. 把 SDK 事件流与 Claude API 流式执行链补到字段级与时序级。
8. 把 MCP config scope、auth、needs-auth/pending/disabled/failed 状态补成完整状态机。
9. 把 bridge / direct-connect / remote-session 三类宿主路径继续做成对照图。
10. 把 transport plane、control plane、host adapter 三层边界继续做成对照图。
11. 把 control subtype 的协议全集与宿主适配矩阵并排写清。
12. 把 control protocol 的字段级对照表与最小宿主接入样例补齐。
13. 把 `SDKMessage`、`worker_status`、`requires_action_details`、`external_metadata` 做成状态同步矩阵。
14. 把 adapter 忽略、过滤、降级消息的 consumer subset 与兼容层写清。
15. 把 `set_model` / `apply_flag_settings` / `set_permission_mode` / `can_use_tool` 做成字段级闭环 casebook。
16. 把 `system:status`、`session_state_changed`、`worker_status`、`external_metadata` 的真相边界继续做成对照图。
17. 把 transcript、internal events、external metadata 三条恢复路径继续写清它们各自负责的状态范围。

本章对应的详细接口文档:

- [命令与功能矩阵](api/01-%E5%91%BD%E4%BB%A4%E4%B8%8E%E5%8A%9F%E8%83%BD%E7%9F%A9%E9%98%B5.md)
- [内置命令域索引](api/06-%E5%86%85%E7%BD%AE%E5%91%BD%E4%BB%A4%E5%9F%9F%E7%B4%A2%E5%BC%95.md)
- [命令字段与可用性索引](api/07-%E5%91%BD%E4%BB%A4%E5%AD%97%E6%AE%B5%E4%B8%8E%E5%8F%AF%E7%94%A8%E6%80%A7%E7%B4%A2%E5%BC%95.md)
- [工具协议与 ToolUseContext](api/08-%E5%B7%A5%E5%85%B7%E5%8D%8F%E8%AE%AE%E4%B8%8EToolUseContext.md)
- [会话与状态 API 手册](api/09-%E4%BC%9A%E8%AF%9D%E4%B8%8E%E7%8A%B6%E6%80%81API%E6%89%8B%E5%86%8C.md)
- [扩展 Frontmatter 与插件 Agent 手册](api/10-%E6%89%A9%E5%B1%95Frontmatter%E4%B8%8E%E6%8F%92%E4%BB%B6Agent%E6%89%8B%E5%86%8C.md)
- [SDKMessageSchema 与事件流手册](api/11-SDKMessageSchema%E4%B8%8E%E4%BA%8B%E4%BB%B6%E6%B5%81%E6%89%8B%E5%86%8C.md)
- [MCP 配置与连接状态机](api/12-MCP%E9%85%8D%E7%BD%AE%E4%B8%8E%E8%BF%9E%E6%8E%A5%E7%8A%B6%E6%80%81%E6%9C%BA.md)
- [StructuredIO 与 RemoteIO 宿主协议手册](api/13-StructuredIO%E4%B8%8ERemoteIO%E5%AE%BF%E4%B8%BB%E5%8D%8F%E8%AE%AE%E6%89%8B%E5%86%8C.md)
- [Control 子类型与宿主适配矩阵](api/14-Control%E5%AD%90%E7%B1%BB%E5%9E%8B%E4%B8%8E%E5%AE%BF%E4%B8%BB%E9%80%82%E9%85%8D%E7%9F%A9%E9%98%B5.md)
- [Control 协议字段对照与宿主接入样例](api/15-Control%E5%8D%8F%E8%AE%AE%E5%AD%97%E6%AE%B5%E5%AF%B9%E7%85%A7%E4%B8%8E%E5%AE%BF%E4%B8%BB%E6%8E%A5%E5%85%A5%E6%A0%B7%E4%BE%8B.md)
- [SDK 消息与 Control 闭环对照表](api/16-SDK%E6%B6%88%E6%81%AF%E4%B8%8EControl%E9%97%AD%E7%8E%AF%E5%AF%B9%E7%85%A7%E8%A1%A8.md)
- [状态消息、外部元数据与宿主消费矩阵](api/17-%E7%8A%B6%E6%80%81%E6%B6%88%E6%81%AF%E3%80%81%E5%A4%96%E9%83%A8%E5%85%83%E6%95%B0%E6%8D%AE%E4%B8%8E%E5%AE%BF%E4%B8%BB%E6%B6%88%E8%B4%B9%E7%9F%A9%E9%98%B5.md)
- [系统提示词、Frontmatter 与上下文注入手册](api/18-%E7%B3%BB%E7%BB%9F%E6%8F%90%E7%A4%BA%E8%AF%8D%E3%80%81Frontmatter%E4%B8%8E%E4%B8%8A%E4%B8%8B%E6%96%87%E6%B3%A8%E5%85%A5%E6%89%8B%E5%86%8C.md)
- [Agent SDK 与控制协议](api/02-Agent%20SDK%E4%B8%8E%E6%8E%A7%E5%88%B6%E5%8D%8F%E8%AE%AE.md)
- [MCP 与远程传输](api/03-MCP%E4%B8%8E%E8%BF%9C%E7%A8%8B%E4%BC%A0%E8%BE%93.md)
- [SDK 消息与事件字典](api/04-SDK%E6%B6%88%E6%81%AF%E4%B8%8E%E4%BA%8B%E4%BB%B6%E5%AD%97%E5%85%B8.md)
- [控制请求与响应矩阵](api/05-%E6%8E%A7%E5%88%B6%E8%AF%B7%E6%B1%82%E4%B8%8E%E5%93%8D%E5%BA%94%E7%9F%A9%E9%98%B5.md)
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
