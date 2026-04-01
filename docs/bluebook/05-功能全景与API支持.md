# 功能全景与 API 支持

这一章回答两个问题:

1. Claude Code 到底支持哪些能力面。
2. 这些能力分别通过什么接口暴露出来。

为了避免“看到一点功能就写一点功能”的碎片化，本章按 runtime 表面来组织。

## 1. 从第一性原理看，Claude Code 至少有六个接口表面

如果把 Claude Code 当作一个 coding agent runtime，而不是一个聊天框，它至少要暴露六类接口:

1. 人类交互接口: CLI、REPL、slash command。
2. 执行接口: tool、task、subagent。
3. 扩展接口: skill、plugin、MCP。
4. 自动化接口: headless、SDK、structured IO。
5. 远程接口: remote session、bridge、CCR transport。
6. 状态接口: transcript、session、context usage、settings、rewind。

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

### 2.5 MCP / transport 面

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

### 2.6 远程与桥接面

远程执行面并不是单一 websocket，而是:

- `StructuredIO` 负责 control request/response 语义
- `RemoteIO` 负责 transport、session token、CCR v2、keepalive
- bridge / remote session 分担不同的产品角色

证据:

- `claude-code-source-code/src/cli/structuredIO.ts:135-162`
- `claude-code-source-code/src/cli/remoteIO.ts:31-42`
- `claude-code-source-code/src/cli/remoteIO.ts:111-168`

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

如果目标真的是“尽量覆盖全部功能和 API”，下一阶段优先级应是:

1. 把 slash command 按功能域做完整目录表。
2. 把 `SDKMessageSchema` 的消息变体做完整表格。
3. 把 control request/response subtype 做协议矩阵。
4. 把 MCP config scope、transport、auth/needs-auth/error 状态做状态机图。

本章对应的详细接口文档:

- [命令与功能矩阵](../api/01-%E5%91%BD%E4%BB%A4%E4%B8%8E%E5%8A%9F%E8%83%BD%E7%9F%A9%E9%98%B5.md)
- [Agent SDK 与控制协议](../api/02-Agent%20SDK%E4%B8%8E%E6%8E%A7%E5%88%B6%E5%8D%8F%E8%AE%AE.md)
- [MCP 与远程传输](../api/03-MCP%E4%B8%8E%E8%BF%9C%E7%A8%8B%E4%BC%A0%E8%BE%93.md)
- [SDK 消息与事件字典](../api/04-SDK%E6%B6%88%E6%81%AF%E4%B8%8E%E4%BA%8B%E4%BB%B6%E5%AD%97%E5%85%B8.md)
- [控制请求与响应矩阵](../api/05-%E6%8E%A7%E5%88%B6%E8%AF%B7%E6%B1%82%E4%B8%8E%E5%93%8D%E5%BA%94%E7%9F%A9%E9%98%B5.md)
