# 研究日志

## 当前基线

- 日期: `2026-04-01`
- 工作目录: `/home/mo/m/projects/cc/analysis`
- 研究源码: `claude-code-source-code/`
- 目标版本: `v2.1.88`

## 已确认结论

### A. 启动与入口

- CLI 先走 fast path，再决定是否 import `main.js`。
- `main.tsx` 是总控层，不只是 TUI 入口。
- init 显式区分 trust 前后的行为边界。

证据:

- `claude-code-source-code/src/entrypoints/cli.tsx:28-33`
- `claude-code-source-code/src/entrypoints/cli.tsx:95-185`
- `claude-code-source-code/src/main.tsx:585-855`
- `claude-code-source-code/src/entrypoints/init.ts:62-88`

### B. 核心 agent loop

- `QueryEngine` 管会话生命周期。
- `query.ts` 负责 streaming、tool use、fallback、compaction、recovery。
- transcript 在 query 前就会先落盘。

证据:

- `claude-code-source-code/src/QueryEngine.ts:209-333`
- `claude-code-source-code/src/QueryEngine.ts:430-463`
- `claude-code-source-code/src/query.ts:659-865`

### C. 能力系统

- tool 是统一执行原语。
- commands 与 skills 都被收敛进统一命令装配过程。
- skills 支持 frontmatter 声明权限、hooks、model、paths、agent。

证据:

- `claude-code-source-code/src/Tool.ts:362-792`
- `claude-code-source-code/src/commands.ts:445-517`
- `claude-code-source-code/src/skills/loadSkillsDir.ts:185-261`

### D. 扩展与边界

- MCP 是正式扩展总线，支持多 transport、多 config scope、policy/dedup。
- Remote session 与 Remote Control bridge 是两条不同远程路径。
- 多 Agent 建立在 task runtime 上，而不是 prompt hack。

证据:

- `claude-code-source-code/src/services/mcp/types.ts:9-27`
- `claude-code-source-code/src/services/mcp/config.ts:1258-1290`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts:87-141`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts:57-87`
- `claude-code-source-code/src/Task.ts:6-29`

### E. Session / state surface

- SDK 入口已经声明 `getSessionMessages`、`listSessions`、`getSessionInfo`、`renameSession`、`tagSession`、`forkSession` 等 session API，但在当前提取树里这些函数体仍是 stub，必须区分“文档化意图”和“当前可见实现”。
- control protocol 已经形成更完整的 runtime state surface，包括 `get_context_usage`、`rewind_files`、`seed_read_state`、`get_settings`。
- session/state 的后端不是单一 transcript，而是 transcript、metadata、layered memory、session memory、file history / rewind 的组合状态面。

证据:

- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:167-272`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:175-519`
- `claude-code-source-code/src/utils/sessionStorage.ts:198-258`
- `claude-code-source-code/src/utils/sessionStorage.ts:4739-5105`
- `claude-code-source-code/src/utils/fileHistory.ts:45-320`

### F. Agent orchestration 与 isolation

- AgentTool 真正提供的是编排器，而不是薄的“再起一个模型调用”。
- 多 Agent 的核心不只是并发，而是上下文、权限、文件系统、历史链与环境的分层隔离。
- `createSubagentContext(...)`、worktree、remote isolation、sidechain transcript 与 cleanup 共同构成“隔离优先于并发”的实现基础。

证据:

- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx:318-764`
- `claude-code-source-code/src/tools/AgentTool/runAgent.ts:95-859`
- `claude-code-source-code/src/utils/forkedAgent.ts:253-625`
- `claude-code-source-code/src/tools/EnterWorktreeTool/EnterWorktreeTool.ts:52-127`
- `claude-code-source-code/src/tools/ExitWorktreeTool/ExitWorktreeTool.ts:67-320`

### G. Unified extension surface

- Claude Code 的扩展面不是“plugins、skills、agents 各自一套系统”，而是目录约定、frontmatter 与 manifest 共同驱动的统一声明式装配面。
- skills / legacy commands / agents 共享大量 frontmatter 语义，但默认值与 trust boundary 按对象类型不同。
- plugin manifest 解决的是 bundle-level distribution 与 install-time trust，而不是取代本地 `.claude/*` 的高信任配置面。
- plugin agent 故意忽略 `permissionMode`、`hooks`、`mcpServers`，表明团队刻意把 plugin 内部单体升权和 manifest 级安装批准分开。

证据:

- `claude-code-source-code/src/utils/frontmatterParser.ts:10-232`
- `claude-code-source-code/src/utils/markdownConfigLoader.ts:28-360`
- `claude-code-source-code/src/skills/loadSkillsDir.ts:185-315`
- `claude-code-source-code/src/tools/AgentTool/loadAgentsDir.ts:541-748`
- `claude-code-source-code/src/utils/plugins/schemas.ts:429-898`
- `claude-code-source-code/src/utils/plugins/loadPluginCommands.ts:218-340`
- `claude-code-source-code/src/utils/plugins/loadPluginAgents.ts:153-168`

### H. Permission chain 与 auto mode

- 权限系统必须按“初始 mode 决议 -> context 装配 -> rule/tool check -> mode 覆写 -> classifier/hooks/headless fallback”理解，不能只看 permission dialog。
- auto mode 的安全性并不只来自 classifier，还来自进入 auto 前对危险 allow rule 的 strip，以及 classifier 前的多层 fast-path / bypass-immune safety check。
- `verifyAutoModeGateAccess(...)` 返回 transform function 而不是静态 context，说明作者明确在处理 gate 异步校验与用户中途切 mode 的竞争问题。

证据:

- `claude-code-source-code/src/utils/permissions/PermissionMode.ts:42-140`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:510-645`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:689-1033`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:1078-1158`
- `claude-code-source-code/src/utils/permissions/permissions.ts:473-1471`

### I. SDK host surface is event stream, not answer stream

- `SDKMessageSchema` 的公共面已经覆盖 user / assistant / `stream_event`、result、system、hook / tool / auth、task / persistence、rate-limit / elicitation / suggestion 等多类消息。
- `system:init` 暴露的不是欢迎文本，而是 runtime 装配态快照。
- 对宿主来说，Claude Code SDK 的价值不只是“拿到模型回复”，而是“接入运行中的事件脉搏、状态变化与执行摘要”。

证据:

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1290-1302`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1347-1455`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1457-1602`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1604-1779`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1794-1880`

### J. Claude API stream is recoverable execution trajectory

- `query.ts` 在调模型前准备的是工作集、工具、权限、budget、MCP readiness 等执行上下文，而不是裸消息数组。
- 流式解析阶段必须处理 `message_start -> content_block_* -> message_delta -> message_stop`，并在 `message_delta` 上对已 yield 的 assistant message 做原地 mutation，才能保持 transcript 引用一致性。
- streaming fallback、missing tool result repair、reactive compact、max output recovery 共同维护的是“可恢复执行轨迹”，而不是单纯的文本续写。

证据:

- `claude-code-source-code/src/query.ts:123-179`
- `claude-code-source-code/src/query.ts:650-930`
- `claude-code-source-code/src/query.ts:980-1265`
- `claude-code-source-code/src/query.ts:1368-1728`
- `claude-code-source-code/src/services/api/claude.ts:588-673`
- `claude-code-source-code/src/services/api/claude.ts:1270-1335`
- `claude-code-source-code/src/services/api/claude.ts:1979-2365`
- `claude-code-source-code/src/services/api/claude.ts:2366-2475`
- `claude-code-source-code/src/services/api/claude.ts:2560-2825`
- `claude-code-source-code/src/services/api/claude.ts:2924-3025`

### K. MCP is a governed connection plane

- MCP 至少要按 config scope、transport、connection state、control surface 四层理解。
- `needs-auth`、`pending`、`disabled`、`failed`、`connected` 说明它不是一个简单 connect / fail 布尔量。
- plugin MCP 通过动态 scope、名称重写与环境变量分层解析，进一步说明这是受治理的连接平面，而不是“manifest 里顺手带几个 server”。

证据:

- `claude-code-source-code/src/services/mcp/types.ts:10-257`
- `claude-code-source-code/src/services/mcp/config.ts:1253-1569`
- `claude-code-source-code/src/services/mcp/client.ts:340-421`
- `claude-code-source-code/src/services/mcp/client.ts:595-1128`
- `claude-code-source-code/src/services/mcp/client.ts:1216-1402`
- `claude-code-source-code/src/services/mcp/useManageMCPConnections.ts:333-450`
- `claude-code-source-code/src/services/mcp/useManageMCPConnections.ts:765-1128`
- `claude-code-source-code/src/utils/plugins/mcpPluginIntegration.ts:341-620`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:157-173`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:374-452`

## 本轮输出

- 已建立蓝皮书主索引
- 已写四个核心章节初稿
- 已把“公开能力 vs gated/incomplete 能力”单独拆章，避免误导
- 已补“功能全景与 API 支持”主线章节
- 已补命令矩阵、SDK 控制协议、MCP/远程传输三篇接口文档
- 已补第一性原理与苏格拉底反思章节，以及内部迭代准则
- 已补 REPL、权限状态机、上下文压缩恢复链三篇架构深挖
- 已补 SDK 消息字典、控制请求矩阵、上下文经济学、安全观四篇专题文档
- 已补 PromptInput/消息渲染链、内置命令域索引、产品实验与演化方法
- 已补 `services/compact/*` 细拆、命令字段与可用性索引、构建期开关/运行期开关/兼容层专题
- 已补工具协议与 `ToolUseContext`、会话存储/记忆/回溯状态面、状态优先于对话三篇专题
- 已补会话与状态 API 手册，明确区分 SDK 文档化接口与当前提取实现边界
- 已补 AgentTool 与隔离编排专题，把 fork/background/worktree/remote 收拢成统一编排面
- 已补“隔离优先于并发”专题，并把第一性原理阅读路径显式映射到目录
- 已补扩展 Frontmatter 与插件 Agent 手册，把 skills / agents / plugins / manifest 收拢成统一扩展面
- 已补权限系统全链路与 Auto Mode 细拆，把 mode、rule、classifier、headless fallback 串成完整状态机
- 已补“统一配置语言优于扩展孤岛”专题，并把扩展面提升为单独阅读链
- 已补 `SDKMessageSchema` 与事件流手册，把 SDK 从“答案流”纠正为“runtime event stream”
- 已补 MCP 配置与连接状态机，把 scope、transport、connection state、control surface 收拢成统一连接平面
- 已补 Claude API 与流式工具执行专题，把 query loop、stream parser、tool executor、fallback、recovery 串成完整执行链
- 已同步更新主索引、API/架构 README、章节规划、证据索引、长期记忆与反思准则

## 下一步待办

- 补一章“多 Agent 协作模式与 prompt 模板”
- 补源码目录级索引表，把 `services/`、`tools/`、`commands/` 细分到二级目录
- 给 `SDKMessageSchema` 与 control subtype 做完整对照表，并补宿主接入样例
- 补 `REPL.tsx` / Ink 更细的 transcript mode、message actions、PromptInput 交互链
- 补 `StructuredIO` / `RemoteIO` 的 host-CLI 协议与时序
- 补命令索引的更细表格化版本与 workflow/dynamic skills 交叉核对
- 补 feature gate / runtime gate / compat shim 的统一时序与迁移图
- 继续把 session/state API 与子代理状态回收做成字段级索引与时序图
- 补一章“MCP 实战配置与集成范式”
- 把插件市场、manifest、MCPB、LSP、channels 的产品层边界继续写成实战与策略手册

## 当前风险

- 这份源码不是完整内部 monorepo，不能把 gated/internal 痕迹直接当成公开事实。
- `query.ts` 仍有大量细节未拆完，尤其是 compact / reactive compact / media recovery 分支。
- plugin 市场能力的基础设施很完整，但现阶段不能夸大其生态成熟度。
- SDK 入口可见，但部分 `runtimeTypes` / `toolTypes` / `controlTypes` 源文件未在当前提取树中展开，接口分析需持续标注这层边界。
- `services/compact/*` 已明显显示多条 gated/ant-only 路径，不能把 cached microcompact、API-native clear edits 等直接当作所有 build 的公开能力。
- `commands/` 目录很多模块名与最终 slash name 可能不完全同名，虽然字段级索引已补，但 workflow/dynamic skills 仍需继续核实。
- session/state 面横跨 `sessionStorage.ts`、`fileHistory.ts`、SessionMemory、SDK control schema，后续必须继续防止“API、机制、产品行为”三层混写。
- session API 在 `agentSdkTypes.ts` 中的实现可见度仍不完整，后续写作必须继续强调“入口已声明”不等于“当前提取树里已有完整实现”。
- 多 Agent 隔离逻辑横跨 `AgentTool.tsx`、`runAgent.ts`、`forkedAgent.ts`、worktree tools，后续若继续细拆时应防止把“并发能力”和“隔离约束”混成一个概念。
- 扩展面虽然已经能被解释为统一配置语言，但 plugin manifest、marketplace、MCPB、LSP 仍存在明显的产品成熟度差异，后续不能把 schema 支持直接写成生态成熟。
- 权限系统的很多细节受 ant-only feature、classifier gate、fail-open/fail-closed 配置影响，后续必须持续区分“源码路径存在”和“公开构建稳定可用”。
- `stream_event`、`research`、`advisor`、`claudeai-proxy`、`ws-ide` 等痕迹里混有 internal / host-specific 信号，后续不能直接当作稳定公共契约。
- Claude API 流式执行链与当前 Anthropic event shape、tool execution harness 强绑定，后续若源码升级，最可能先变化的是恢复细节与引用写回策略。
