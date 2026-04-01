# 研究日志

## 当前基线

- 日期: `2026-04-02`
- 工作目录: `/home/mo/m/projects/cc/analysis/.worktrees/mainloop`
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

### L. Claude Code is host-integrated runtime, not terminal shell

- `StructuredIO` 的职责不是“把 stdin/stdout 包一层”，而是维持 request correlation、cancel、duplicate/orphan 防护、permission race 与 schema-validated control flow。
- `RemoteIO` 没有发明一套 remote-only protocol，而是在 `StructuredIO` 之上扩 transport、token refresh、CCR v2 internal events、bridge-only keepalive。
- direct connect 与 `RemoteSessionManager` 都复用了同一控制语义，但当前支持面明显窄于完整 `StructuredIO`：它们更接近宿主适配器，而不是完整 CLI worker control plane。

证据:

- `claude-code-source-code/src/cli/print.ts:587-620`
- `claude-code-source-code/src/cli/print.ts:1021-1048`
- `claude-code-source-code/src/cli/print.ts:5199-5232`
- `claude-code-source-code/src/cli/structuredIO.ts:135-162`
- `claude-code-source-code/src/cli/structuredIO.ts:275-429`
- `claude-code-source-code/src/cli/structuredIO.ts:470-773`
- `claude-code-source-code/src/cli/remoteIO.ts:35-240`
- `claude-code-source-code/src/server/directConnectManager.ts:40-210`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts:87-323`
- `claude-code-source-code/src/remote/SessionsWebSocket.ts:74-403`

### M. Protocol superset is not the same as adapter subset

- `controlSchemas.ts` 给出的是完整协议全集，但 bridge、direct connect、`RemoteSessionManager` 当前实现的是不同宽度的子集。
- bridge 当前显式处理中等宽度的 inbound control request：`initialize`、`set_model`、`set_max_thinking_tokens`、`set_permission_mode`、`interrupt`，并单独为 `can_use_tool` 构建 permission callback 面。
- direct connect 与 `RemoteSessionManager` 当前更窄，主要围绕 `can_use_tool` 与 `interrupt`，不能把它们直接写成完整 SDK host。
- `handleIngressMessage(...)` 只把 `control_response`、`control_request` 和 `user` inbound message 单独分流，也说明 bridge 不是“把所有 SDKMessage 原样搬进 REPL”。

证据:

- `claude-code-source-code/src/bridge/bridgeMessaging.ts:126-208`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts:243-391`
- `claude-code-source-code/src/bridge/replBridge.ts:1190-1235`
- `claude-code-source-code/src/bridge/replBridge.ts:1528-1819`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:422-456`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:824-878`
- `claude-code-source-code/src/hooks/useReplBridge.tsx:367-586`
- `claude-code-source-code/src/server/directConnectManager.ts:81-200`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts:153-297`

### N. Explicit failure matters as much as success path

- bridge、direct connect、`RemoteSessionManager` 都不把 unknown control subtype 静默吞掉，而是显式回 error，避免 server 因等待 reply 而挂死连接。
- outbound-only bridge 对 mutable request 也显式回 error，避免“看起来成功但本地没生效”的假成功错觉。
- `StructuredIO` 把 abort、cancel、duplicate/orphan 防护都做成显式协议动作或显式 reject，而不是依赖宿主自己猜测请求是否还有效。

### O. `query.ts` is a turn runtime kernel, not a thin model loop

- `query.ts` 维护的是 `State + while(true) + continue sites + terminal reasons` 的 turn runtime。
- `continue` 不是简单 retry，而是“同一次 `query()` 调用内替换下一轮状态”的 self-loop。
- tool follow-up、recovery、stop hook blocking、token budget continuation 都被统一规约成内部 continue。
- transcript / resume 不是 query 之外的附属日志，而是 turn runtime 的恢复契约。

证据：

- `claude-code-source-code/src/query.ts:203-235`
- `claude-code-source-code/src/query.ts:365-540`
- `claude-code-source-code/src/query.ts:652-950`
- `claude-code-source-code/src/query.ts:1065-1305`
- `claude-code-source-code/src/query.ts:1363-1714`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-99`
- `claude-code-source-code/src/utils/conversationRecovery.ts:159-273`
- `claude-code-source-code/src/utils/sessionRestore.ts:409-545`

### P. Permission system is a typed decision engine, not a modal UX

- 权限链必须按 `typed model -> context/materialization -> rule/tool engine -> mode transform -> automation -> relay/renderer -> hard enforcement` 理解。
- permission modal 只是 `ask` 分支的 renderer，不是安全本体。
- 同一个 `ask` 可以由本地 UI、SDK host、bridge/channel、swarm leader、permission prompt tool 共同消费。
- sandbox、workspace trust、managed policy、MCP approval/auth 是正交的硬边界。

证据：

- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:510-645`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:689-1033`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1061-1312`
- `claude-code-source-code/src/services/tools/toolHooks.ts:332-417`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts:43-236`
- `claude-code-source-code/src/cli/structuredIO.ts:534-653`
- `claude-code-source-code/src/cli/print.ts:4146-4340`
- `claude-code-source-code/src/utils/sandbox/sandbox-adapter.ts:172-260`

### Q. Host truth is tri-surface: event stream, snapshot, recovery

- 宿主真相至少分成三层：`SDKMessage` 时间线、`worker_status/external_metadata` 快照、transcript/internal-events 恢复面。
- `request_id`、`tool_use_id`、`uuid`、`session_id`、`parentUuid` 是跨平面的关键主键。
- `control_request / control_response / control_cancel_request` 才是宿主命令闭环。
- `worker_status` 与 `session_state_changed` 比 `system:status` 更接近 authoritative running/idle 真相。

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-519`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:578-612`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1457-1779`
- `claude-code-source-code/src/utils/sessionState.ts:1-149`
- `claude-code-source-code/src/cli/structuredIO.ts:469-773`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:1-118`
- `claude-code-source-code/src/utils/sessionStorage.ts:1307-1637`
- `claude-code-source-code/src/utils/sessionRestore.ts:99-177`

### R. `services` are subsystem planes; `utils` are invariant kernels

- `services/` 更像执行、连接、记忆、治理、观测五个长生命周期子平面。
- `utils-heavy` 的关键不在 helper 多，而在 shared invariant 多：cache-key prefix、tool ordering、fork contract、session truth 都是跨域基础设施。
- 真正的工程债务主要是热点文件过大，而不是 `services` / `utils` 边界崩坏。

证据：

- `claude-code-source-code/src/services/tools/toolExecution.ts:1-260`
- `claude-code-source-code/src/services/tools/toolOrchestration.ts:19-132`
- `claude-code-source-code/src/services/mcp/useManageMCPConnections.ts:143-450`
- `claude-code-source-code/src/services/SessionMemory/sessionMemory.ts:134-387`
- `claude-code-source-code/src/utils/queryContext.ts:30-41`
- `claude-code-source-code/src/utils/toolPool.ts:43-73`
- `claude-code-source-code/src/utils/forkedAgent.ts:46-110`
- `claude-code-source-code/src/utils/markdownConfigLoader.ts:1-240`

### S. Multi-agent prompt quality comes from runtime contract, not wording tricks

- coordinator、fresh subagent、fork、team/swarm、workflow 需要分开写，不能都叫“subagent prompt”。
- worker prompt 必须自包含，因为 worker 看不到主线程对话。
- team/swarm 的关键是 team context、mailbox、task list、名字寻址与 leader 审批，而不是普通 prompt 复述。
- Prompt 模板最可靠的来源是源码里的角色合同：`coordinatorMode.ts`、`AgentTool/prompt.ts`、`TeamCreateTool/prompt.ts`、`messages.ts`。

证据：

- `claude-code-source-code/src/coordinator/coordinatorMode.ts:111-260`
- `claude-code-source-code/src/tools/AgentTool/prompt.ts:48-112`
- `claude-code-source-code/src/tools/TeamCreateTool/prompt.ts:37-166`
- `claude-code-source-code/src/utils/messages.ts:3457-3490`
- `claude-code-source-code/src/utils/swarm/inProcessRunner.ts:871-1043`

### T. Recovery is a multi-surface persistence system, not transcript replay

- Claude Code 的恢复链至少分成主 transcript、sidechain transcript、task output、state restore 四层。
- `TaskOutput` 负责长输出与进度观察，不等于 transcript。
- `loadConversationForResume(...)` 与 `restoreSessionStateFromLog(...)` 做的是 runtime re-materialization，而不是只读回消息。
- v1 ingress、v2 internal-events、本地 JSONL 最终都服务同一恢复面。

证据：

- `claude-code-source-code/src/utils/sessionStorage.ts:1451-1545`
- `claude-code-source-code/src/utils/conversationRecovery.ts:456-541`
- `claude-code-source-code/src/utils/sessionRestore.ts:99-147`
- `claude-code-source-code/src/tasks/LocalMainSessionTask.ts:358-416`
- `claude-code-source-code/src/utils/task/TaskOutput.ts:32-110`
- `claude-code-source-code/src/utils/task/TaskOutput.ts:257-388`
- `claude-code-source-code/src/cli/transports/ccrClient.ts:789-854`

### U. Capability atlas now requires object truth, not just plane truth

- “全部功能和 API”不能只按能力平面写，还必须继续补命令 truth、工具 truth、任务 truth、服务 truth、宿主 truth 五张对象表。
- `TaskType` 与 `getAllTasks()` 的差异说明 task model truth 与 task registry truth 必须分开写。
- `constants/tools.ts` 说明 async agent、in-process teammate、coordinator 拥有不同的工具子集 truth，不能把“系统支持某工具”写成单层判断。
- `src/services/` 的约 `20` 个一级子域说明能力大量沉在 subsystem planes 里，而不只长在 commands/tools 上。

证据：

- `claude-code-source-code/src/Task.ts:6-124`
- `claude-code-source-code/src/tasks.ts:1-39`
- `claude-code-source-code/src/constants/tools.ts:36-112`
- `claude-code-source-code/src/tools.ts:193-250`
- `claude-code-source-code/src/services/`

### V. Governance APIs are formal control planes, not misc helpers

- channels、`get_context_usage`、`get_settings` / `apply_flag_settings` 应一起写成治理型 API。
- channels 体现外部输入治理；context usage 体现上下文预算治理；settings 则体现配置真相与运行态治理。
- 这三条 API 共同说明 Claude Code 不只开放“让你做事”的接口，也开放“让你约束 runtime”的接口。

证据：

- `claude-code-source-code/src/services/mcp/channelNotification.ts:1-280`
- `claude-code-source-code/src/utils/messages.ts:5496-5507`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:175-288`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:467-507`

### W. Prompt magic, unified budgeter, and source quality are now explicit philosophy axes

- Prompt 魔力更准确的结构应写成“角色合同 + 工具边界 + 缓存结构 + 状态反馈 + 协作语法”。
- 安全、成本与体验必须共用预算器，因为它们分别约束动作空间、上下文空间与认知噪音。
- 源码质量不能只写成卫生层评价，而应写成 contract、失败语义、恢复路径和共享基础设施如何直接决定产品能力。

证据：

- `claude-code-source-code/src/utils/systemPrompt.ts:29-123`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:24-260`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:510-645`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/query.ts:369-540`
- `claude-code-source-code/src/query.ts:1065-1247`

### U. REPL front-end is a cognitive control plane, not a chat shell

- transcript mode 不是历史视图，而是 pager/runtime。
- sticky prompt、search、message actions、teammate view、queued commands 共同组成前台状态机。
- 前台主语切换与锚点保持，是长会话和多 Agent 可用性的核心部分。

证据：

- `claude-code-source-code/src/screens/REPL.tsx:4183-4595`
- `claude-code-source-code/src/components/Messages.tsx:229-320`
- `claude-code-source-code/src/components/FullscreenLayout.tsx:1-120`
- `claude-code-source-code/src/components/VirtualMessageList.tsx:43-99`
- `claude-code-source-code/src/components/VirtualMessageList.tsx:289-767`
- `claude-code-source-code/src/components/messageActions.tsx:1-176`

### V. Product reality is shaped by migration layers and consumer subsets

- Claude Code 的能力边界至少要按 build-time gate、runtime gate、compat shim、consumer subset 四层理解。
- marketplace、plugin manifest、MCPB、LSP、channels 都属于扩展/产品边界，但不处于同一成熟度和同一职责层。
- schema 存在、安装流存在、adapter 消费存在，不等于同一条产品能力链已经完整打通。

证据：

- `claude-code-source-code/src/entrypoints/cli.tsx:18-26`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts:120-202`
- `claude-code-source-code/src/services/mcp/channelNotification.ts:1-220`
- `claude-code-source-code/src/services/mcp/channelAllowlist.ts:1-67`
- `claude-code-source-code/src/utils/plugins/marketplaceManager.ts:1-169`
- `claude-code-source-code/src/utils/plugins/schemas.ts:1-180`
- `claude-code-source-code/src/utils/plugins/mcpbHandler.ts:1-220`
- `claude-code-source-code/src/services/lsp/manager.ts:1-180`

证据:

- `claude-code-source-code/src/cli/structuredIO.ts:362-429`

### O. 风控、账号治理与封号技术

- 客户端源码没有暴露一个单点“ban user”逻辑；更可信的结构是身份鉴权、账号资格、组织策略、远程设置、遥测 targeting 与本地执行边界的组合治理。
- `policyLimits` 和 `remoteManagedSettings` 都是服务端下发的控制面，具备缓存、轮询、热更新和 fail-open/stale-cache 退化路径，说明客户端是治理执行端，不是唯一决策端。
- telemetry 与 GrowthBook 明确绑定用户、会话、设备、组织、订阅、rate limit tier 等属性，说明平台具备按账号与组织维度分流能力和观测行为的基础设施。
- Auto mode、sandbox、workspace trust、trusted device 解决的是动作级或设备级安全边界，不应直接等同于账号封禁；其中 bridge trusted device 明确属于 elevated auth enforcement。
- `forceLoginOrg` 使用服务端 profile 作为组织权威来源并明确 fail-closed，说明组织绑定属于硬边界，不信任本地可写缓存。
- managed settings 对危险 shell settings、非安全 env vars 和 hooks 的变更会触发阻塞确认或直接退出，说明远程下发不仅是配置同步，也是受审查的治理命令通道。
- 从合规使用角度，最能降低误伤和能力撤回风险的不是“规避风控”，而是保持身份源、组织归属、设备和网络环境的可解释一致性，并准备完整支持证据。
- 从技术先进性角度，这套系统的核心不在单个检测器，而在“身份连续性维护 + 远程策略下发 + 本地动作收口 + 高安全会话 + 观测闭环”的分层组合。
- bridge / REPL 相关逻辑明确把 401 风暴、跨进程 backoff、连续失败上限当成一等问题，说明“抑制失败扩散”本身也是风控设计的一部分。
- `403 insufficient_scope` 在 MCP OAuth 里被显式识别为 step-up auth，而不是普通 refresh 失败，说明作者非常清楚地区分“身份失效”和“授权范围不足”。
- rate limit / extra usage exhausted 属于计费与消耗层，而 `not enabled for your account` 更接近 entitlement/rollout；它们都不应被粗暴归类为“封号”。
- 从更高抽象看，Claude Code 的治理闭环至少包含“识别主体 -> 观测主体 -> 判定资格 -> 下发边界 -> 阻断/放行动作 -> 失败与恢复”六段时序，研究风控不能只盯某个点。
- 系统在 failure semantics 上采取明显的 selective fail-open / fail-closed 哲学：资格缓存与普通配置同步更偏向减少误伤，而组织边界、危险变更、高安全远程能力与复杂解析路径更偏向强收口。
- 对用户保护最有价值的不是“继续试错”，而是先识别错误语义、冻结变量、保留证据，再按身份/资格/组织/本地执行/高安全会话这几个层级选择支持路径。
- 图解层面的抽象已经稳定：Remote Control 的成立至少经历“订阅 -> 组织画像 -> entitlement gate -> 组织 policy -> trust / trusted device / env register”这条链，而误伤处置也可以稳定压缩成“识别语义 -> 冻结变量 -> 证据保全 -> 分层支持路径”。
- 平台正义视角下，这套系统最值得继续追问的不是“它能不能挡住风险”，而是“它能否把资格缺失、组织治理、动作阻断与真正处罚清楚地区分给用户”，以及“高波动环境用户是否承担了过高的解释成本”。
- 更细的 bridge / trusted device / 401 recovery 时序已经足以说明：高安全远程会话不是普通请求恢复逻辑的延长，而是“身份恢复 -> 凭证重取 -> transport 重建 -> cleanup/backoff”的独立系统。
- 一页式速查卡已经可以稳定给出：不同错误语义对应不同治理层、不同用户动作和不同支持路径；这对减少用户把所有问题误读成“封号”非常重要。
- 这套系统已经可以被提炼成一组可迁移的 agent 治理法则：主体连续性优先、资格与处罚分离、组织治理独立、高安全远程会话独立建模、本地动作治理前置、策略数据化、selective failure semantics、step-up auth 与 token expiry 分离、失败风暴治理、解释层与支持路径一体化。
- 单页总纲已经稳定形成：主体层、资格层、组织层、观测层、动作层、高安全会话层、计费层、哲学层和用户处置层，可以作为后续所有风险研究的统一骨架。
- 更稳妥的“高封号率中国用户”技术表述不是平台一定针对，而是高波动网络、身份路径分裂、设备/网络切换、组织与权益错配更容易把多层连续性问题压缩成“像被封了”的单一体感。
- 给平台方最有价值的改进建议集中在：更细 reason code、结构化诊断包、高安全远程链路状态可视化、资格与处罚语义分离、以及面向高波动环境用户的低成本恢复路径。

证据:

- `claude-code-source-code/src/utils/auth.ts:83-149`
- `claude-code-source-code/src/utils/auth.ts:1360-1561`
- `claude-code-source-code/src/utils/auth.ts:1923-2000`
- `claude-code-source-code/src/entrypoints/cli.tsx:132-159`
- `claude-code-source-code/src/services/policyLimits/index.ts:167-210`
- `claude-code-source-code/src/services/policyLimits/index.ts:505-526`
- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:410-555`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:22-72`
- `claude-code-source-code/src/components/ManagedSettingsSecurityDialog/utils.ts:24-117`
- `claude-code-source-code/src/utils/managedEnv.ts:93-177`
- `claude-code-source-code/src/utils/user.ts:34-135`
- `claude-code-source-code/src/utils/telemetryAttributes.ts:29-70`
- `claude-code-source-code/src/services/analytics/growthbook.ts:29-47`
- `claude-code-source-code/src/components/AutoModeOptInDialog.tsx:9-10`
- `claude-code-source-code/src/bridge/trustedDevice.ts:15-33`
- `claude-code-source-code/src/bridge/bridgeMain.ts:198-269`
- `claude-code-source-code/src/bridge/initReplBridge.ts:189-220`
- `claude-code-source-code/src/hooks/useReplBridge.tsx:31-40`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts:17-87`
- `claude-code-source-code/src/cli/structuredIO.ts:490-504`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts:265-283`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts:373-390`
- `claude-code-source-code/src/server/directConnectManager.ts:88-98`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts:199-213`
- `claude-code-source-code/src/services/mcp/client.ts:335-370`
- `claude-code-source-code/src/services/mcp/auth.ts:1344-1470`
- `claude-code-source-code/src/services/rateLimitMessages.ts:41-104`
- `claude-code-source-code/src/services/analytics/growthbook.ts:892-903`
- `claude-code-source-code/src/utils/permissions/permissions.ts:843-875`
- `claude-code-source-code/src/services/mcp/officialRegistry.ts:62-67`
- `claude-code-source-code/src/Tool.ts:743-756`
- `claude-code-source-code/src/hooks/notifs/useCanSwitchToExistingSubscription.tsx:11-58`
- `claude-code-source-code/src/bridge/bridgeApi.ts:100-138`
- `claude-code-source-code/src/services/api/sessionIngress.ts:144-182`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts:57-84`
- `claude-code-source-code/src/services/mcp/client.ts:2311-2334`
- `claude-code-source-code/src/commands/remote-setup/index.ts:10-16`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:529-589`
- `claude-code-source-code/src/bridge/replBridge.ts:2272-2303`
- `claude-code-source-code/src/bridge/trustedDevice.ts:89-180`
- `claude-code-source-code/src/services/analytics/firstPartyEventLoggingExporter.ts:570-609`
- `claude-code-source-code/src/utils/plugins/pluginLoader.ts:1922-1929`
- `claude-code-source-code/src/services/policyLimits/index.ts:618-629`
- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:432-442`
- `claude-code-source-code/src/utils/diagLogs.ts:14-31`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts:72-83`
- `claude-code-source-code/src/hooks/notifs/useCanSwitchToExistingSubscription.tsx:21-35`

### O. Host protocol is a closed loop, not RPC

- `initialize` 不只返回 `control_response(success)`，还会继续通过 `system:init` 把 runtime 装配态发给宿主。
- `set_permission_mode` 不只返回 success/error，还会通过 `system:status` 把 mode 变化广播出来。
- `can_use_tool` 的真正完成也不是 response 本身，而是 `requires_action -> running/idle` 与后续 tool/task/system messages 一起形成闭环。
- SDK 非交互 session 还会通过 `sdkEventQueue` 补发 `task_started`、`task_progress`、`task_notification`、`session_state_changed`，说明宿主真相来自持续事件流，而不是单次 ack。

证据:

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1457-1880`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/utils/sdkEventQueue.ts:1-121`
- `claude-code-source-code/src/cli/print.ts:1051-1076`

### P. Remote recovery is layered state machine, not plain reconnect

- `SessionsWebSocket` 对 `4003`、`4001`、一般 reconnect budget 做了分级处理。
- `remoteBridgeCore` 把 `401` 看成 JWT/epoch/transport rebuild 问题，而不是普通 socket close。
- `authRecoveryInFlight` 期间主动 drop `control_request` / `control_response` / `control_cancel_request` / `result`，说明作者宁可丢消息，也不愿制造 stale-epoch 的假成功。
- `RemoteIO` 又在更外层补了 token refresh callback、keepalive 与 CCR state reporting，说明“恢复”还包括远端状态真相回写。

证据:

- `claude-code-source-code/src/remote/SessionsWebSocket.ts:234-403`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:456-588`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:780-878`
- `claude-code-source-code/src/cli/remoteIO.ts:71-85`
- `claude-code-source-code/src/cli/remoteIO.ts:155-196`

### Q. Runtime truth is dual-channel, not pure event stream

- Claude Code 对宿主暴露的不只是 `SDKMessage` 时间线，还包括 `worker_status`、`requires_action_details` 与 `external_metadata` 快照。
- `notifySessionStateChanged(...)`、`notifySessionMetadataChanged(...)`、`onChangeAppState(...)` 构成统一 choke point，让 permission mode、pending action、model 等状态不会因为 mutation path 分散而失同步。
- `WorkerStateUploader` 说明这不是零散 side effect，而是明确设计过的 merge / retry / last-value 语义。
- `CCRClient.initialize()` 还会主动清理 stale `pending_action` / `task_summary`，说明“恢复后真相”是状态面的一部分，而不是后处理。

证据:

- `claude-code-source-code/src/utils/sessionState.ts:1-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:19-91`
- `claude-code-source-code/src/cli/remoteIO.ts:111-168`
- `claude-code-source-code/src/cli/transports/ccrClient.ts:476-545`
- `claude-code-source-code/src/cli/transports/ccrClient.ts:645-662`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:1-118`

### R. Consumer subset and compatibility shim are part of the API reality

- `coreSchemas.ts` 声明了消息全集，但 `sdkMessageAdapter`、direct connect、`messages/mappers.ts` 明确证明并非每个 consumer 都完整消费它。
- `auth_status`、`tool_use_summary`、`rate_limit_event` 在 remote adapter 里会被主动忽略。
- `system:local_command_output` 甚至会被降级成 `assistant`，以适配尚未认识该 subtype 的下游。
- 因此“schema 存在”与“所有宿主完整渲染”必须继续分开写。

证据:

- `claude-code-source-code/src/remote/sdkMessageAdapter.ts:223-267`
- `claude-code-source-code/src/utils/messages/mappers.ts:145-196`
- `claude-code-source-code/src/server/directConnectManager.ts:100-109`

### S. Prompt magic is runtime assembly, not mystical wording

- `queryContext`、`getSystemPrompt`、`buildEffectiveSystemPrompt`、`systemPromptSections`、attachments 共同说明 Claude Code 的 prompt 是分层装配链，不是单段字符串。
- 动态 agent list、deferred tools、MCP instructions delta、fork cache sharing 说明 prompt 设计始终服从 cache stability 与 token economics。
- coordinator / worker / fork / proactive 各自的 prompt 合同不同，所谓“魔力”更多来自角色契约与 runtime 约束，而不是几句文案本身。

证据:

- `claude-code-source-code/src/utils/queryContext.ts:1-41`
- `claude-code-source-code/src/constants/prompts.ts:444-579`
- `claude-code-source-code/src/utils/systemPrompt.ts:27-121`
- `claude-code-source-code/src/tools/AgentTool/prompt.ts:48-95`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:1-170`

### T. Security is a layered policy-and-runtime closure system

- trust 判定、managed policy、typed permission model、tool-local validator、classifier / hook、sandbox、MCP / remote protocol 构成统一安全架构；UI modal 只是 `ask` 的一种 renderer。
- `policySettings` 与 remote managed settings 证明组织治理是单独平面，不应和普通用户设置混写。
- sandbox、SSRF guard、MCP auth 又说明安全不止于 permission decision，还要下沉到文件系统、网络和外部 trust domain。

证据:

- `claude-code-source-code/src/components/TrustDialog/TrustDialog.tsx:208-208`
- `claude-code-source-code/src/utils/settings/settings.ts:675-675`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1158-1262`
- `claude-code-source-code/src/utils/sandbox/sandbox-adapter.ts:172-266`
- `claude-code-source-code/src/utils/hooks/ssrfGuard.ts:5-17`

### U. Source quality comes from engineered invariants, not local elegance

- `query.ts` 与 `QueryGuard` 说明 turn lifecycle 被显式状态机化。
- `Tool` 接口与 toolExecution pipeline 说明扩展能力先进入平台 ABI，再进入具体实现。
## 2026-04-02 第二十八轮

目标:

- 优化蓝皮书目录结构，使其更适合继续扩张
- 把第一性原理从六问升级为八问
- 给后续 API 全集与哲学深挖预留导航层

结论:

### I. 蓝皮书已经需要显式的 navigation 层

- 现在主线、机制、接口、哲学、风险、实践已经足够多，如果继续只把阅读路径压在 `bluebook/README.md`，检索成本会继续上升。
- `navigation/` 更适合作为蓝皮书内部导航层，单独承担“从什么问题进入”和“这章属于哪一平面”。

证据:

- `bluebook/README.md`
- `docs/development/01-章节规划.md`

### II. Claude Code 的第一性原理应从六问升级为八问

- 旧写法已经覆盖观察、决策、行动、记忆、协作、恢复。
- 但源码已经清楚显示它还在持续处理治理与经济两个问题：
  - 治理：账号、组织、策略、遥测、remote managed settings、trusted device
  - 经济：prompt cache、tool/result budget、compact、输出外置、认知控制面

证据:

- `claude-code-source-code/src/query.ts:571-703`
- `claude-code-source-code/src/services/analytics/growthbook.ts:1-1`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:1-1`
- `claude-code-source-code/src/tools/AgentTool/prompt.ts:191-243`
- `claude-code-source-code/src/cli/structuredIO.ts:59-173`

### III. 目录优化不是审美问题，而是可持续研究的基础设施

- 当章节跨越主线、API、架构、哲学、风险之后，如果不明确“章节所属平面”，后续写作会反复混写：
  - 功能全集
  - 公开支持边界
  - 设计解释
  - 风控治理
- 所以目录结构本身已经变成研究质量的一部分。

## 2026-04-02 第二十七轮

- `lazySchema`、`toolPool`、`WorkerStateUploader`、`promptCacheBreakDetection` 说明 schema、cache、retry、merge 都被做成正式结构对象。
- 真正的工程债务集中在少数超大核心文件，而不是整体架构缺少方法。

证据:

- `claude-code-source-code/src/query.ts:203-268`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-1`
- `claude-code-source-code/src/Tool.ts:158-792`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:1-118`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:1-170`

### V. Token economy is a four-layer system, not just compact

- Claude Code 的省 token 主要不是靠单次摘要，而是靠稳定前缀、动态目录外移、工具输出外置、最后才 compact 的四层经济系统。
- `messages.ts` 的 normalize/shaping 行为，本质上更像“上下文编译器”，先修消息拓扑与体积，再决定要不要做摘要。
- shell / local command / task output 被 tag 化、截断、落盘，本质是在把“可再生的大块输出”搬出上下文。

证据:

- `claude-code-source-code/src/utils/analyzeContext.ts:363-1164`
- `claude-code-source-code/src/query.ts:365-468`
- `claude-code-source-code/src/utils/messages.ts:1989-2534`
- `claude-code-source-code/src/utils/toolResultStorage.ts:769-941`
- `claude-code-source-code/src/utils/toolSearch.ts:545-646`
- `claude-code-source-code/src/utils/task/TaskOutput.ts:32-282`

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
- 已补 `StructuredIO` 与 `RemoteIO` 宿主协议手册，把 host-facing control protocol 做成单独 API 章节
- 已补 `StructuredIO` 与 `RemoteIO` 控制平面专题，把 request correlation、cancel、duplicate/orphan、防乱序与远程 transport 串成完整架构链
- 已补“宿主控制平面优于聊天外壳”专题，把 Claude Code 从 terminal shell 视角提升为 host-integrated runtime
- 已把 `bluebook/` 目录进一步收紧为宿主链、事件链、连接链、策略链、会话链、协作链六条阅读线
- 已补 control subtype 与宿主适配矩阵，明确区分 schema 全集与宿主子集
- 已补 bridge / direct-connect / remote-session 的适配器分层专题，明确 bridge 是中等宽度控制面而不是薄 websocket wrapper
- 已补“协议全集不等于适配器子集”专题，把这条边界上升为正式写作原则
- 已把 `bluebook/` 目录进一步扩展为宿主链、适配器链、事件链、连接链、策略链、会话链、协作链七条阅读线
- 已补 control protocol 字段级对照与最小宿主接入样例，补强 request/response 封套与 payload 字段支持
- 已补宿主路径时序与竞速专题，把本地 host、bridge、direct-connect、remote-session 四条链收拢成统一时序视角
- 已补“显式失败优于假成功”专题，把 explicit error / cancel / reject 提升为 Agent runtime 的正式设计原则
- 已把 `bluebook/` 目录进一步扩展为宿主链、适配器链、时序链、事件链、连接链、策略链、会话链、协作链八条阅读线
- 已补 SDK 消息与 Control 闭环对照表，把 request / response / follow-on SDKMessage 串成闭环视角
- 已补远程恢复与重连状态机，把 `4001` / `4003` / `401` / epoch rebuild / worker_status 回写收拢成分层恢复模型
- 已补“闭环状态机优于单向请求”专题，把 Claude Code 从宿主控制面进一步提升为 control-loop runtime
- 已把 `bluebook/` 目录进一步扩展为宿主链、适配器链、时序链、闭环链、事件链、连接链、策略链、会话链、协作链九条阅读线
- 已补状态消息、外部元数据与宿主消费矩阵，把 `SDKMessage`、`worker_status`、`external_metadata` 与 consumer subset 放到同一张 API 图里
- 已补双通道状态同步与外部元数据回写专题，把事件时间线与状态快照回写收拢成统一架构图
- 已补“外化状态优于推断状态”专题，把宿主真相从“自己猜”提升为“主动外化”
- 已把 `bluebook/` 目录进一步扩展为状态同步链，并把“真相面”加入第一性原理阅读路径
- 已补系统提示词、Frontmatter 与上下文注入手册，把 CLI / SDK / agent / skill / attachment prompt surface 收拢成统一 API 面
- 已补提示词装配链与上下文成形专题，把 prompt 魔力从“文案”上升为装配链、角色合同与 cache 稳定性
- 已补安全分层、策略收口与沙箱边界专题，把 trust、policy、sandbox、SSRF、MCP auth 收拢成统一安全架构
- 已补源码质量、分层与工程先进性专题，把 query turn state、Tool ABI、schema/cache/retry 结构化为工程质量主线
- 已补消息塑形、输出外置与 Token 经济专题，把 message shaping、tool result budget、deferred delta、compact 顺序收拢成统一上下文经济链
- 已补“提示词魔力来自运行时而非咒语”和“工程化质量优于聪明技巧”两篇哲学专题
- 已把 `bluebook/` 目录进一步扩展为 Prompt 链、安全链、工程链、上下文链
- 已补提示词控制、知识注入与记忆 API 手册，把 CLI / SDK initialize / `CLAUDE.md` / typed memory / attachment surface 放到同一层
- 已补插件、Marketplace、MCPB、LSP、channels 接入边界手册，把格式支持、产品边界、信任与治理模型显式拆开
- 已补提示词契约分层、知识层栈、多 Agent 任务对象三篇架构专题，把 prompt contract、knowledge stack、task/mailbox runtime 从主线下沉为机制专题
- 已补 `CLAUDE.md`、记忆层与上下文注入实践指南，把规则层、长期记忆、会话连续性、临时 prompt 约束的使用边界写成实战路径
- 已补“Prompt 不是文本技巧而是契约分层”“安全与 Token 经济不是权衡而是同一优化”“生态成熟度必须与协议支持分开叙述”三篇哲学专题
- 已把 `bluebook/` 主线继续提升为“运行时契约、知识层与生态边界”，并把目录阅读链扩展为契约链、知识链、安全经济链、协作运行时链、生态边界链

### R. 能力全集必须和公开度 / 成熟度一起叙述

- 当前源码基线同时包含“正式公共表面”“正式宿主表面”“声明存在但实现未闭合的入口”“gated/internal 痕迹”“受策略与组织约束的产品面”。
- `agentSdkTypes.ts` 暴露了 session 管理函数族，但当前提取树里多个函数体仍是显式 `not implemented`，因此蓝皮书必须持续区分“声明接口”和“可见实现”。
- `README.md` 明确指出公开源码仍缺失 `108` 个 `feature()` 相关模块，因此“公开源码边界”与“内部真实能力全集”不能混写。
- 后续“全部功能和 API”章节必须继续按“能力平面 + 公开度 / 成熟度矩阵”双层写法推进，而不是回到单层能力清单。

证据：

- `claude-code-source-code/package.json:2-19`
- `claude-code-source-code/README.md:70-74`
- `claude-code-source-code/README.md:250-280`
- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:103-272`
- `claude-code-source-code/src/main.tsx:1497-1520`
- `claude-code-source-code/src/main.tsx:1635-1688`

### S. API 写作已进入“总表先行”阶段

- 现在已经有两份总表型文档分别负责“能力平面 + 公开度矩阵”与“命令 / 工具 / 会话 / 宿主 / 协作 API 全谱系”。
- 这意味着后续再补任何单篇 API 章节时，都必须先回到总表检查：它位于哪个平面，属于哪个公开度标签，是否只是 adapter 子集。
- 主线 `08` 负责给出判断标准，`api/23` 与 `api/24` 负责把判断标准落成可检索索引，这三层已经形成稳定写作骨架。

证据：

- `bluebook/08-能力全集、公开度与成熟度矩阵.md`
- `bluebook/api/23-能力平面、公开度与宿主支持矩阵.md`
- `bluebook/api/24-命令、工具、会话、宿主与协作API全谱系.md`

### T. Prompt、安全与源码质量三条母线已经收编为正式专题

- prompt 魔力现在不再只按“runtime contract”抽象描述，而被进一步下沉成“角色合同、缓存结构、状态晚绑定、多 Agent 语法”四层机制。
- 安全与 token 经济现在不再只写成两篇并列专题，而被进一步统一成“预算器”视角，明确动作空间和上下文空间是同构约束。
- 源码质量现在不再只写成泛泛“工程先进”，而是同时写“公开镜像仍然先进的原因”和“热点大文件、测试面缺失、镜像不完整”三类真实局限。

证据：

- `bluebook/architecture/31-提示词合同、缓存稳定性与多Agent语法.md`
- `bluebook/architecture/32-安全、权限、治理与Token预算统一图.md`
- `bluebook/architecture/33-公开源码镜像的先进性、热点与技术债.md`
- `bluebook/philosophy/21-Prompt魔力来自约束叠加与状态反馈.md`
- `bluebook/philosophy/22-安全、成本与体验必须共用预算器.md`
- `bluebook/philosophy/23-源码质量不是卫生而是产品能力.md`

### U. workflow 当前最稳的写法是“对象模型已可见，执行内核仍缺席”

- `local_workflow` 已经是正式 `TaskType`，而不是评论性术语。
- `LocalWorkflowTaskState` 已进入 `TaskState` / `BackgroundTaskState` 联合类型，说明 workflow 是后台任务对象，不是命令宏。
- SDK 进度面允许携带 `workflow_progress`，说明宿主已经被预留了 phase/progress 消费面。
- transcript 与 worktree 命名都显式提到 `subagents/workflows/<runId>/` 与 `wf_<runId>-<idx>`，说明 workflow 是独立 sidechain runtime。
- 但 `LocalWorkflowTask` 主体实现当前公开镜像未展开，因此后续必须继续区分“对象模型已可证实”与“执行机理未完整公开”。

证据：

- `claude-code-source-code/src/Task.ts:6-84`
- `claude-code-source-code/src/tasks/types.ts:1-27`
- `claude-code-source-code/src/utils/task/framework.ts:111-128`
- `claude-code-source-code/src/utils/task/sdkProgress.ts:1-34`
- `claude-code-source-code/src/utils/sessionStorage.ts:232-258`
- `claude-code-source-code/src/utils/worktree.ts:1021-1052`

### V. REPL 的 search、selection、scroll 共同维护的是前台认知真相

- transcript search 不是对 raw transcript 做 grep，而是对 render truth 做索引，显式剔除不可见 sentinel 与 system reminder。
- selection 子系统显式维护 anchor/focus、drag scroll、keyboard scroll 与 scrolled-off rows，目的是让高亮与复制结果尽量一致。
- scroll / sticky prompt 不是视觉润色，而是在长对话里维持“当前正在回复哪个 prompt”的因果锚点。
- PromptInput footer 与 teammate view 进一步把后台任务、agent transcript 与输入路由收进同一前台状态机。

证据：

- `claude-code-source-code/src/utils/transcriptSearch.ts:1-166`
- `claude-code-source-code/src/ink/selection.ts:1-220`
- `claude-code-source-code/src/ink/components/ScrollBox.tsx:1-210`
- `claude-code-source-code/src/screens/REPL.tsx:879-910`
- `claude-code-source-code/src/screens/REPL.tsx:1248-1374`
- `claude-code-source-code/src/screens/REPL.tsx:2068-2140`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx:417-462`

### W. channels 与托管策略最适合概括成“输入预算 + 管理员预算”

- channels 不是普通 MCP，而是 capability、OAuth、org policy、session opt-in 与 allowlist 联合约束的外部输入面。
- `allowedChannelPlugins` 一旦设置就替换 Anthropic ledger，说明管理员接管的是最终信任决策，而不是“推荐插件列表”。
- permission relay 是第二层 opt-in：除了 channel capability，还必须声明 `claude/channel/permission`。
- 危险 remote managed settings 变化会触发阻塞式安全对话，说明管理员权力本身也被放进预算器，而不是静默全权生效。

证据：

- `claude-code-source-code/src/services/mcp/channelAllowlist.ts:1-67`
- `claude-code-source-code/src/services/mcp/channelNotification.ts:120-310`
- `claude-code-source-code/src/services/mcp/channelPermissions.ts:1-204`
- `claude-code-source-code/src/interactiveHelpers.tsx:237-283`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:15-56`
- `claude-code-source-code/src/utils/settings/types.ts:896-920`
- `claude-code-source-code/src/utils/plugins/pluginPolicy.ts:1-17`

### X. API atlas 已补到“目录级拓扑 + 动态暴露即预算”这一层

- `api/30` 把 `commands / tools / services / state-query / host control / frontend truth` 六个目录级平面挂到一张能力地图上，避免“字段表齐了，但能力地形仍然不可检索”。
- `api/29` 现在应继续按“动态能力暴露本身也是 token 策略”理解：减少无关工具、稳定 built-in 前缀、把 deferred tools 外移，本质上都在维护 prompt cache 与预算主路径。

证据：

- `claude-code-source-code/src/commands.ts:224-320`
- `claude-code-source-code/src/tools.ts:193-367`
- `claude-code-source-code/src/query.ts:369-395`
- `claude-code-source-code/src/services/api/claude.ts:1270-1355`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:28-158`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-220`
- `claude-code-source-code/src/cli/structuredIO.ts:135-162`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/Task.ts:6-124`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`

### Y. 第一性原理实践最稳的写法应收敛为“目标、预算、对象、边界、回写”

- 使用专题不能继续只给命令清单，而应先帮助读者判断：这次任务属于 session、task/workflow、worktree 还是单轮对话。
- 更稳的 Claude Code 使用法不是“写更长 prompt”，而是先分目标预算、动作预算、上下文预算、协作预算与治理预算，再决定哪些状态进入稳定层，哪些状态只做晚绑定。
- 长任务若仍被当作多轮聊天来承载，通常已经在逆用 Claude Code；应升级到 task/workflow/session/worktree 等正式对象。

证据：

- `claude-code-source-code/src/utils/systemPrompt.ts:29-122`
- `claude-code-source-code/src/query/tokenBudget.ts:3-92`
- `claude-code-source-code/src/utils/toolPool.ts:43-79`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:28-158`
- `claude-code-source-code/src/Task.ts:6-106`
- `claude-code-source-code/src/utils/task/framework.ts:101-117`
- `claude-code-source-code/src/utils/sessionStorage.ts:231-258`
- `claude-code-source-code/src/utils/worktree.ts:1022-1058`
- `claude-code-source-code/src/utils/transcriptSearch.ts:9-59`
- `claude-code-source-code/src/ink/selection.ts:19-63`
- `claude-code-source-code/src/services/mcp/channelPermissions.ts:1-18`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:15-73`

### Z. Prompt 深线已升级到“可重放、可观测、可编译、可分层”

- `stopHooks` 会保存 `CacheSafeParams`，让 `/btw` 和 post-turn forks 复用与主线程一致的安全前缀；这说明 prompt 不只是单轮文本，而是可重放前缀资产。
- `get_context_usage` 已把 `systemPromptSections`、`systemTools`、`attachmentsByType`、`messageBreakdown` 暴露出来，说明 prompt 结构本身已经进入可观测预算面。
- `memdir` 与 `systemPromptSectionCache` 说明 prompt 正在按 section 编译和缓存，而不是每轮重写整段 memory 指南。
- `nullRenderingAttachments` 进一步说明“模型可见真相”和“用户可见真相”被显式分层，这是 prompt 低噪音注入的前提。

证据：

- `claude-code-source-code/src/query/stopHooks.ts:84-99`
- `claude-code-source-code/src/commands/btw/btw.tsx:183-227`
- `claude-code-source-code/src/utils/forkedAgent.ts:70-141`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:220-305`
- `claude-code-source-code/src/components/ContextVisualization.tsx:110-149`
- `claude-code-source-code/src/memdir/memdir.ts:121-128`
- `claude-code-source-code/src/memdir/memdir.ts:187-205`
- `claude-code-source-code/src/bootstrap/state.ts:1641-1653`
- `claude-code-source-code/src/components/messages/nullRenderingAttachments.ts:4-69`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:332-460`

### Z. 入口索引层必须被当成正式产物，而不是维护附录

- 当正文已经长出 `api/30`、`architecture/36/37/38`、`guides/06` 这类新判断标准时，`bluebook/README.md`、`navigation/*`、专题 README 若不立刻同步，就会让读者继续沿过时链路阅读。
- 这说明检索层本身也是蓝皮书结构的一部分，不只是排版工作；它决定读者是否能按“问题 -> 平面 -> 章节”而不是按文件名碰运气进入正文。

证据：

- `bluebook/README.md`
- `bluebook/navigation/01-第一性原理阅读地图.md`
- `bluebook/navigation/02-能力、API与治理检索图.md`
- `bluebook/api/README.md`
- `bluebook/architecture/README.md`
- `bluebook/guides/README.md`
- `bluebook/philosophy/README.md`

## 下一步待办

- 补 `SDKMessage`、control、snapshot、recovery 四面统一的宿主实现 casebook
- 补 `query.ts` / `sessionStorage.ts` / `REPL.tsx` / `replBridge.ts` 四个热点文件的债务与分层图
- 补 bridge / direct-connect / remote-session 三类宿主路径的更细时序图
- 继续把源码目录级索引表下沉到二级目录与代表性叶子模块
- 补 `REPL.tsx` / Ink 更细的 transcript mode、message actions、PromptInput 交互链
- 补命令索引的更细表格化版本与 workflow/dynamic skills 交叉核对
- 补 feature gate / runtime gate / compat shim 的统一时序与迁移图
- 继续把 session/state API 与子代理状态回收做成字段级索引与时序图
- 补一章“MCP 实战配置与集成范式”
- 补一章“治理型 API 的宿主实践样例”

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
- direct connect 与 `RemoteSessionManager` 当前实现的 control surface 明显窄于 `StructuredIO` 全量 schema，后续必须持续避免把“schema 全集”和“某个宿主已支持的子集”写成同一层事实。
- bridge 当前虽然明显宽于 direct connect / `RemoteSessionManager`，但仍不是完整 control subtype 全集；后续必须避免把它直接等同于完整 SDK host。
- 显式失败路径目前已经能被解释为架构原则，但尚未对 `authRecoveryInFlight`、transport close code、prompt timeout 等失败语义做完全文级整理，后续仍要继续补。
- request / response / follow-on message 的闭环主线已经建立，但仍未把所有 subtype 做成统一 casebook；后续若继续深化，应防止不同闭环粒度混写。
- 运行时真相的双通道主线已经建立，但仍未把每个状态项都标清“时间线 / 快照 / 恢复 / consumer subset”四层；后续若继续深化，应防止再次退回单通道叙述。
- `query.ts`、`sessionStorage.ts`、`REPL.tsx`、`replBridge.ts` 等热点文件依然很大；后续若继续写“源码先进性”，必须同时写基础设施优点与热点文件债务。
- workflow engine 的类型入口和 transcript 归档语义当前可见，但主体实现未完整展开；后续必须持续区分“已可证实的 task 维度”与“尚未完全展开的引擎细节”。
