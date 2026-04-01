# 功能全景与 API 支持

这一章回答两个问题:

1. Claude Code 到底支持哪些能力面。
2. 这些能力分别通过什么接口暴露出来。

为了避免“看到一点功能就写一点功能”的碎片化，本章按 runtime 表面来组织。

## 1. 从第一性原理看，Claude Code 至少有七个接口表面

如果把 Claude Code 当作一个 coding agent runtime，而不是一个聊天框，它至少要暴露七类接口:

1. 人类交互接口: CLI、REPL、slash command。
2. 执行接口: tool、task、subagent。
3. 扩展接口: skill、plugin、MCP。
4. 自动化接口: headless、SDK、structured IO。
5. 宿主控制接口: control request/response、permission handshake、interrupt、settings/context/state control。
6. 远程接口: remote session、bridge、CCR transport、direct connect。
7. 状态接口: transcript、session、context usage、settings、rewind。

Claude Code 强的原因之一，是它几乎把这六类接口都做成了正式模块，而不是临时拼接。

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

## 3. API 支持不是一层，而是四层

从源码看，Claude Code 的“API”至少可以拆成四层。

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

### 3.4 传输 API

这是跨进程、跨网络、跨环境的连接语义:

- stdio
- structured IO
- SSE/WebSocket/HTTP
- session ingress
- CCR v2 internal events

## 4. 目前蓝皮书对“API 支持”的增强点

这一轮相较前一版，补的是三类缺口:

1. 不再只讲架构，还补命令、工具、SDK、MCP、远程这些实际接口面。
2. 不再把 public/gated/internal 混写，而是把接口边界和能力边界分开。
3. 不再只看“模型如何调用工具”，而是把“外部宿主如何控制 CLI”也纳入 API 版图。

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
- [宿主控制平面优于聊天外壳](philosophy/09-%E5%AE%BF%E4%B8%BB%E6%8E%A7%E5%88%B6%E5%B9%B3%E9%9D%A2%E4%BC%98%E4%BA%8E%E8%81%8A%E5%A4%A9%E5%A4%96%E5%A3%B3.md)
