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

### R. Claude Code repeatedly builds authoritative surfaces, not scattered semi-truths

- `onChangeAppState(...)` 说明 mode sync 的成熟修法不是补更多 mutation callsite，而是把外部可见 mode 真相统一收口到一个 state diff choke point。
- `getAllBaseTools()`、`assembleToolPool(...)`、`mergeAndFilterTools(...)` 说明工具真相至少分成“基础全集”“运行时组合”“多路径共享组合逻辑”三层权威面，而且 capability、policy、prompt-cache 稳定性三者共用同一入口。
- `coreSchemas.ts` 与 `sandboxTypes.ts` 说明 SDK 类型、runtime 校验、settings schema 被刻意设计成共源，而不是 IDE 类型和 runtime shape 各写各的。
- `sessionStorage.ts` 对 `sessionProjectDir`、subagent transcript path、`currentSessionWorktree` tri-state 的处理说明恢复系统最怕 split-brain，路径和 worktree 真相不能由 hooks / resume / cwd 各自推导。
- `pluginPolicy.ts` 说明权威真相面最好同时是 leaf module，这样 single source of truth 不会再次被依赖图污染成多处半真相。
- 更抽象地说，Claude Code 正在把“名词真相”推进到 schema / pure leaf，把“动词真相”推进到 chokepoint / state machine。

证据:

- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/utils/sessionState.ts:27-146`
- `claude-code-source-code/src/tools.ts:188-367`
- `claude-code-source-code/src/utils/toolPool.ts:20-79`
- `claude-code-source-code/src/utils/api.ts:119-259`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1-8`
- `claude-code-source-code/src/entrypoints/sandboxTypes.ts:1-6`
- `claude-code-source-code/src/utils/sessionStorage.ts:203-258`
- `claude-code-source-code/src/utils/sessionStorage.ts:533-822`
- `claude-code-source-code/src/utils/plugins/pluginPolicy.ts:1-20`

### S. Claude Code prefers object escalation over endless continuation

- `compact` 主要吸收的是上下文压力，不是协作压力；`ContextSuggestions` 已经在用 token / read / memory / autocompact 信号区分这些上下文类问题。
- `TaskCreateTool` 明确把“3 步以上、non-trivial、需要跟踪”的工作推进到 task object，说明复杂任务的正式承载体是 lifecycle object，不是继续聊天。
- `checkTokenBudget(...)` 在接近阈值或出现 diminishing returns 时停止 continue，这意味着 token budget 不只是省 token 逻辑，也是对象升级信号。
- `EnterWorktreeTool` 与 `createWorktreeForSession(...)` 说明 worktree 是独立 cwd / branch / resume state 的强隔离对象，不是 branch 语法糖；但产品暴露仍然要求用户显式提出 worktree。
- `sessionStorage.ts` 对 subagent transcript、worktree-state 的持久化说明 session 的职责是恢复多对象宇宙，而不是只保存一串聊天历史。

证据:

- `claude-code-source-code/src/query/tokenBudget.ts:1-75`
- `claude-code-source-code/src/utils/analyzeContext.ts:1000-1098`
- `claude-code-source-code/src/utils/contextSuggestions.ts:31-233`
- `claude-code-source-code/src/Task.ts:6-121`
- `claude-code-source-code/src/utils/task/framework.ts:31-117`
- `claude-code-source-code/src/tools/TaskCreateTool/prompt.ts:7-49`
- `claude-code-source-code/src/tools/EnterWorktreeTool/prompt.ts:1-36`
- `claude-code-source-code/src/tools/EnterWorktreeTool/EnterWorktreeTool.ts:68-116`
- `claude-code-source-code/src/utils/worktree.ts:702-770`
- `claude-code-source-code/src/utils/sessionStorage.ts:247-285`
- `claude-code-source-code/src/utils/sessionStorage.ts:804-822`
- `claude-code-source-code/src/utils/sessionStorage.ts:2884-2917`

### T. Prompt magic keeps descending into an explainable stability system

- `promptCacheBreakDetection` 不是简单“缓存断点统计”，而是 pre-call snapshot + post-call token verification 的两阶段诊断器：先记录所有可能影响 server-side cache key 的客户端状态，再用真实 `cache_read_input_tokens` 下降验证 break 是否真的发生。
- 它追踪的不只 system prompt 文本，还包括 tools hash、per-tool schema hash、cache_control、globalCacheStrategy、betas、effort、extraBody 等，说明 Claude Code 把 prompt 看成整条 request surface，而不是一段文案。
- `claude.ts` 显式把 defer-loading tools 排除出 cache detection，因为这些工具不会真正进入 API prompt；这说明作者关心的是“实际发给模型的稳定性对象”，不是本地代码里潜在可见的对象。
- `notifyCacheDeletion(...)`、`notifyCompaction(...)` 与 TTL / server-side 分流说明系统已经把“预期下降”“TTL 过期”“疑似服务端逐出”从真正 client-side break 中分离出来，prompt 失稳不再被一概写成本地 prompt 问题。
- 更抽象地说，Claude Code 的 prompt 魔力正在从“共享前缀资产”继续升级成“可解释稳定性系统”：不仅能复用前缀，还能解释前缀为什么稳定、为什么失稳。

证据:

- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:28-119`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:220-433`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:437-706`
- `claude-code-source-code/src/services/api/claude.ts:1457-1486`
- `claude-code-source-code/src/services/api/claude.ts:2380-2391`
- `claude-code-source-code/src/utils/toolPool.ts:55-71`
- `claude-code-source-code/src/tools.ts:329-367`
- `claude-code-source-code/src/query/stopHooks.ts:92-99`

### U. QueryGuard turns local query state into a synchronous control plane

- `QueryGuard` 不是 loading helper，而是三态 `idle / dispatching / running` 的同步状态机，并通过 `useSyncExternalStore` 暴露给 REPL，作者已明确把它定义为 local query in flight 的 single source of truth。
- `dispatching` 这个中间态专门治理“队列刚出队、异步链还没到 onQuery”这段空窗；如果没有它，queue processor 和 submit path 都会在同一个异步 gap 里把系统误认成 idle。
- `handlePromptSubmit` 会在 `processUserInput(...)` 前先 `reserve()`，说明系统要求“先占住运行权，再开始 await 链”，而不是等真正 query 启动后再补 loading state。
- `tryStart()` / `end(generation)` / `forceEnd()` 把 stale finally、cancel-resubmit race 做成显式代际裁决，说明作者已经把 finally 视为潜在 stale writer，而不是天然可信的 cleanup path。
- `useQueueProcessor` 不再拥有自己的 reservation/finally，而是完全订阅 `queryGuard`；这说明本地查询 authority 已经升级成一个局部控制协议，而不只是 util 类。

证据:

- `claude-code-source-code/src/utils/QueryGuard.ts:1-104`
- `claude-code-source-code/src/screens/REPL.tsx:897-918`
- `claude-code-source-code/src/screens/REPL.tsx:2113-2135`
- `claude-code-source-code/src/screens/REPL.tsx:2866-2928`
- `claude-code-source-code/src/utils/handlePromptSubmit.ts:426-607`
- `claude-code-source-code/src/hooks/useQueueProcessor.ts:1-59`

### V. Remote failure is a layered semantics system, not “disconnect and reconnect”

- `SessionsWebSocket` 已经把 close code 分成 permanent close、session-not-found limited retry、一般 reconnect 三类；这说明连接层失败不是单一布尔值，而是预算化分级。
- `remoteBridgeCore` 把 `401` 做成 transport-semantic change：必须 refresh OAuth、重新取 remote credentials、rebuild transport、切换 epoch，而不是只换 token 继续。
- `authRecoveryInFlight` 期间主动 drop `control_request/response/cancel/result`，说明系统宁可显式丢弃，也不接受陈旧 transport 上制造“好像发出去了”的假成功。
- `replBridge` 在 transport permanent close 后进一步尝试 env reconnect，说明 close code 之外还有“环境级恢复”一层；`envLessBridgeConfig` 则把 connect/archive/http/heartbeat 等超时预算显式制度化。
- `initReplBridge` 在 preflight 阶段主动避免 expired-and-unrefreshable token 继续发请求，说明失败语义还包括 fail-closed 的 guaranteed-fail path 消毒，而不是只覆盖 post-close recovery。

证据:

- `claude-code-source-code/src/remote/SessionsWebSocket.ts:21-36`
- `claude-code-source-code/src/remote/SessionsWebSocket.ts:234-299`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:456-588`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:824-878`
- `claude-code-source-code/src/bridge/replBridge.ts:887-965`
- `claude-code-source-code/src/bridge/initReplBridge.ts:192-215`
- `claude-code-source-code/src/cli/transports/WebSocketTransport.ts:38-58`
- `claude-code-source-code/src/bridge/envLessBridgeConfig.ts:13-33`

### W. Plugin runtime truth and editable truth must stay separate

- `checkEnabledPlugins()` 明确是 authoritative enabled check，因为它基于 merged settings 处理 policy > local > project > user，再把 `--add-dir` 作为更低优先级来源合并；这意味着“当前是否启用”不是某个单一 scope 的布尔值。
- `getPluginEditableScopes()` 则显式声明自己不是 authoritative enabled check，它解决的是“如果用户要写回，哪个 user-editable scope 拥有这个插件”；说明 editable truth 和 runtime truth 不是同一层。
- `pluginPolicy.ts` 把 policy-blocked plugin 作为 leaf single source of truth，避免安装、启用、UI 过滤各处各写一套企业策略判断。
- 真正的 startup 总控链路并不在 `pluginStartupCheck.ts`，而在 `REPL.tsx -> performStartupChecks -> PluginInstallationManager -> reconciler -> refresh`；`pluginStartupCheck.ts` 更像 enable/scope 计算辅助模块，而不是启动总控。
- `installedPluginsManager.ts` 明确把 installation state 与 enablement state 分离：安装是全局资产面，scope/enablement 仍以 settings.json 为 source of truth；同时 `installed_plugins.json` 只是 persistent metadata，不等于 live session state。loader 的 cache-on-miss materialization 也不自动回写安装记录。
- policy 也不是单轴：除了插件级 block，还有 marketplace source 级策略限制；“插件被禁”与“来源被禁”不是同一个问题。

证据:

- `claude-code-source-code/src/utils/plugins/pluginPolicy.ts:1-20`
- `claude-code-source-code/src/utils/plugins/pluginStartupCheck.ts:30-71`
- `claude-code-source-code/src/utils/plugins/pluginStartupCheck.ts:75-159`
- `claude-code-source-code/src/utils/plugins/performStartupChecks.tsx:24-61`
- `claude-code-source-code/src/services/plugins/PluginInstallationManager.ts:51-90`
- `claude-code-source-code/src/utils/plugins/pluginIdentifier.ts:98-117`
- `claude-code-source-code/src/utils/plugins/installedPluginsManager.ts:4-12`
- `claude-code-source-code/src/utils/plugins/installedPluginsManager.ts:488-537`
- `claude-code-source-code/src/utils/plugins/installedPluginsManager.ts:1033-1164`
- `claude-code-source-code/src/utils/plugins/marketplaceHelpers.ts:472-520`

### X. Unified first principle, multiple budget implementations

- `policySettings` 在 `settings.ts` 里采用 first-source-wins（remote > HKLM/plist > file/drop-ins > HKCU），这说明它更像高阶控制平面，而不是普通 merge source。
- `sandboxTypes` 主要承担策略契约角色，而 `sandbox-adapter` 继续把 `allowManagedDomainsOnly`、`allowManagedReadPathsOnly`、`failIfUnavailable`、`allowUnsandboxedCommands` 等写成运行时硬执行；schema 不是终点，adapter enforcement 才是边界完成点。
- 安全模型是明显不对称的：危险 remote managed settings 触发 blocking dialog；`forceLoginOrgUUID` fail-closed；`--dangerously-skip-permissions` 只在隔离且无公网时放行。这说明治理和安全不是“越严越好”，而是在不同风险面做不同 fail-open / fail-closed 策略。
- Claude Code 实际上不是一个总预算器，而是至少三套：工具结果对象/消息级预算、上下文 headroom/autocompact 预算、turn continuation/token target 预算。它们治理的对象和阶段不同，但共同服务于“限制无序扩张”的同一原则。
- “省 token”最先发生在工具结果外置与聚合替换，不在 summarize 历史；`applyToolResultBudget()` 运行在 `microcompact` / `autocompact` 之前，就是这条顺序的最强证据。

证据:

- `claude-code-source-code/src/utils/settings/settings.ts:74-110`
- `claude-code-source-code/src/utils/settings/settings.ts:319-343`
- `claude-code-source-code/src/utils/settings/settings.ts:645-689`
- `claude-code-source-code/src/entrypoints/sandboxTypes.ts:1-133`
- `claude-code-source-code/src/utils/sandbox/sandbox-adapter.ts:152-235`
- `claude-code-source-code/src/utils/sandbox/sandbox-adapter.ts:475-560`
- `claude-code-source-code/src/utils/sandbox/sandbox-adapter.ts:720-752`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:1-69`
- `claude-code-source-code/src/components/ManagedSettingsSecurityDialog/utils.ts:20-87`
- `claude-code-source-code/src/utils/managedEnvConstants.ts:75-125`
- `claude-code-source-code/src/utils/auth.ts:1914-1955`
- `claude-code-source-code/src/setup.ts:400-439`
- `claude-code-source-code/src/services/tools/toolExecution.ts:1403-1458`
- `claude-code-source-code/src/utils/toolResultStorage.ts:272-357`
- `claude-code-source-code/src/utils/toolResultStorage.ts:575-924`
- `claude-code-source-code/src/query.ts:369-383`
- `claude-code-source-code/src/services/compact/autoCompact.ts:33-140`
- `claude-code-source-code/src/query/tokenBudget.ts:1-75`

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
- 风控研究已经可以稳定沉淀成一张源码地图：身份与组织、资格与订阅、组织策略与远程下发、遥测与实验开关、本地动作治理、高安全远程会话、连接认证子系统、解释层与支持层这八组入口。
- 典型案例推演已经足够说明：401、not enabled、policy denied、needs-auth、rate limit 这五类“像被封了”的体感，背后实际上对应不同治理层和完全不同的处理顺序。

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

### V. 判定非对称性矩阵与边界成本函数

- GrowthBook 安全限制 gate 和 entitlement gate 的缓存语义并不一致，说明平台明确区分“安全限制不能轻放”和“资格误伤要尽量减少”这两类成本函数。
- `isRemoteManagedSettingsEligible()` 愿意接受 externally injected token 的资格假阳性，以避免把企业治理完全漏掉，表明“多一次查询”被认为比“治理不可见”便宜得多。
- `policyLimits` 的主路径整体偏 fail-open，但 `ESSENTIAL_TRAFFIC_DENY_ON_MISS` 又在高敏感场景下保留局部 fail-closed，说明平台不是在选一种哲学，而是在按策略伤害面细分。
- `validateForceLoginOrg()` 强制以 profile 端点确认组织权威来源，本地可写缓存不能替代；组织边界因此被放在“不能模糊”的层级。
- dangerous managed settings 变更要经过交互式确认，拒绝则退出，说明“远程配置”在高风险情况下已经被提升为“治理命令”，而不只是同步配置。
- `bridgeEnabled` 与 `bridgeMain` 的组合明确区分了资格不足、画像不全、session token 过期、环境失效等不同远程失败语义；401/403 会先恢复，404/410 更接近终局失败。
- `rateLimitMessages` 和 `diagLogs` 进一步说明：计费真相与支持证据被刻意从处罚语义里剥离出来，这能显著降低“所有失败都像封号”的认知污染。

证据:

- `claude-code-source-code/src/services/analytics/growthbook.ts:851-975`
- `claude-code-source-code/src/services/remoteManagedSettings/syncCache.ts:32-112`
- `claude-code-source-code/src/services/policyLimits/index.ts:167-220`
- `claude-code-source-code/src/services/policyLimits/index.ts:497-526`
- `claude-code-source-code/src/utils/auth.ts:1917-1989`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:14-73`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts:16-87`
- `claude-code-source-code/src/bridge/bridgeMain.ts:198-285`
- `claude-code-source-code/src/services/rateLimitMessages.ts:17-120`
- `claude-code-source-code/src/utils/diagLogs.ts:14-94`
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

### S. Risk control is signal fusion around continuity, not a single ban verdict

- `bridgeEnabled.ts` 把“Remote Control 不可用”拆成订阅缺失、full-scope token 缺失、组织画像缺失、gate 未放开、build 不支持等多类诊断，说明资格拒绝是分层语义，不是单点处罚。
- `validateForceLoginOrg()` 在 `forceLoginOrgUUID` 存在时对“无法证明组织归属”也 fail-closed，说明组织边界优先级高于可用性，网络或画像问题也会被收敛成拒绝体验。
- `policyLimits` 整体偏 fail-open，但 dangerous managed settings 变化会弹本地阻塞确认框，拒绝后直接退出，说明系统在普通连续性与危险边界之间做分级治理。
- `trustedDevice`、`bridgeApi`、`sessionIngress` 共同体现“高安全会话连续性”思路：trusted device 有独立 enrollment 窗口，401 只做有条件恢复，409 优先恢复服务端状态真相。
- `mcp/auth.ts` 把 `403 insufficient_scope` 单独转为 step-up pending，而不是误走 refresh，说明“授权不足”被明确定义为不同于“凭证失效”的治理语义。
- `rateLimitMessages.ts` 与 `useCanSwitchToExistingSubscription.tsx` 明确把 usage limit、extra usage、订阅未激活写成独立解释路径，进一步证明很多“不能用”并不是处罚。
- `diagLogs.ts` 与 MCP 通知路径体现出无 PII 诊断和 anti-nag 设计，说明平台已把误伤后的支持成本与解释成本纳入工程边界。

证据:

- `claude-code-source-code/src/bridge/bridgeEnabled.ts:17-82`
- `claude-code-source-code/src/utils/auth.ts:1917-1999`
- `claude-code-source-code/src/services/policyLimits/index.ts:1-111`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:1-64`
- `claude-code-source-code/src/bridge/trustedDevice.ts:17-174`
- `claude-code-source-code/src/bridge/bridgeApi.ts:15-122`
- `claude-code-source-code/src/services/api/sessionIngress.ts:47-169`
- `claude-code-source-code/src/services/mcp/auth.ts:1345-1468`
- `claude-code-source-code/src/services/mcp/auth.ts:1614-1667`
- `claude-code-source-code/src/services/rateLimitMessages.ts:1-179`
- `claude-code-source-code/src/hooks/notifs/useCanSwitchToExistingSubscription.tsx:1-48`
- `claude-code-source-code/src/hooks/notifs/useMcpConnectivityStatus.tsx:1-80`
- `claude-code-source-code/src/utils/config.ts:194-211`
- `claude-code-source-code/src/utils/diagLogs.ts:1-60`

### T. Risk research now has a question-oriented navigation layer

- 现有 `risk/` 章节已经能覆盖方法、机制、失效、误伤、平台改进，但目录层面仍偏顺序阅读，不利于遇到具体症状时快速定位。
- 把“怀疑被封”“Remote Control 失效”“中国用户连续性破坏”“计费还是风控”“needs-auth / insufficient_scope”这类问题改造成显式入口后，研究目录就从线性蓝皮书升级为问题驱动蓝皮书。
- 这类重组不新增事实判断，但显著降低了在章节、源码模块地图、速查卡之间反复跳转的成本。
- 后续如果继续扩写，只要先判断新内容属于哪类问题，再决定挂到哪条入口链，就能减少重复章节和概念漂移。

### U. A second Socratic pass should optimize for total harm, not only strict gating

- 如果把风控目标只写成“拦住不该放的行为”，会低估误伤、解释不足、恢复失败和支持成本带来的总伤害。
- 更高标准的治理目标应是同时降低：滥用伤害、误伤伤害、失败风暴伤害、解释成本和申诉成本。
- 当前源码已经明显在做这件事的一部分，例如更细错误语义、无 PII 诊断、step-up 区分、trusted device、dangerous settings 显式确认，但对用户可见 reason code、会前体检和结构化证据包仍有继续提升空间。
- 这意味着下一轮研究不能只继续找 gate，还应继续研究 preflight、reason code、证据导出和平台正义这些“解释层基础设施”。

### V. User self-protection should optimize continuity discipline, not retry volume

- `checkGate_CACHED_OR_BLOCKING(...)` 对 entitlement gate 明显偏向减少 stale `false` 误伤，说明平台本身就在努力避免把用户主动触发的功能误判成不可用。
- `isRemoteManagedSettingsEligible()` 接受 externally injected token 的资格假阳性，说明“多一次查询”被认为比“把企业治理完全漏掉”代价更低，也提醒用户不要把一次额外查询误解成针对性限制。
- `bridgeMain` 的 `heartbeatActiveWorkItems()` 明确区分 `auth_failed` 和 `fatal`，说明高安全远程失败并不都是终局处罚，用户首先要分语义，而不是放大成统一封号体感。
- `useMcpConnectivityStatus.tsx` 只对“曾经成功连接过”的 claude.ai connector 做 `failed/needs-auth` 提示，说明“最近一次成功时间”是高价值诊断证据。
- `rateLimitMessages.ts` 把 usage、session、weekly、extra usage、reset time 等单独建模，说明很多“突然不能用”本质是计费/额度语义，不应被误写成处罚。
- 更高抽象看，用户最有效的合规自保不是规避检测，而是保持身份、组织、设备、网络和证据链的连续性，并在故障窗口里冻结变量、减少噪声。

证据:

- `claude-code-source-code/src/services/analytics/growthbook.ts:892-935`
- `claude-code-source-code/src/services/remoteManagedSettings/syncCache.ts:32-111`
- `claude-code-source-code/src/bridge/bridgeMain.ts:198-269`
- `claude-code-source-code/src/hooks/notifs/useMcpConnectivityStatus.tsx:25-87`
- `claude-code-source-code/src/services/rateLimitMessages.ts:17-103`

### W. Technical sophistication is the collaboration of signal, decision, recovery, and explanation planes

- `initializeTelemetryAfterTrust()` 先等待 remote managed settings，再初始化 telemetry，说明观测层本身就受治理层约束，而不是治理之外的旁路。
- `checkSecurityRestrictionGate(...)` 与 `checkGate_CACHED_OR_BLOCKING(...)` 使用不同缓存语义，说明安全限制和 entitlement 并不是同一类 gate。
- `checkManagedSettingsSecurity(...)` 把危险设置变化提升为交互式确认，说明平台会把某些远程配置变化当成“治理命令”，而不只是普通同步。
- `mcp/client.ts` 把远程认证失败提升为 `needs-auth` 状态并缓存，说明子系统失败被建模成有记忆的连接状态，而不是瞬时异常。
- `remoteBridgeCore.ts` 在 401 恢复窗口主动 drop stale control/result 消息，说明恢复层优先保护因果一致性，而不是表面不断。
- `diagLogs.ts` 明确禁止 PII，说明解释层追求的是低敏感度可解释性，而不是无限制地收集更多数据。
- 更高抽象看，Claude Code 风控技术的先进性不在秘密检测器，而在信号层、判定层、恢复层、解释层被整合成一套可持续演进的控制平面。

证据:

- `claude-code-source-code/src/entrypoints/init.ts:241-280`
- `claude-code-source-code/src/services/analytics/growthbook.ts:851-935`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:14-73`
- `claude-code-source-code/src/services/mcp/client.ts:335-370`
- `claude-code-source-code/src/services/mcp/client.ts:2311-2334`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:529-588`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:824-878`
- `claude-code-source-code/src/utils/diagLogs.ts:14-57`

### X. Preflight and shortest-recovery paths are already implicit in the source

- `useCanSwitchToExistingSubscription()` 已经能识别“你有 Pro/Max 权益，但当前没激活到此身份路径”，并直接提示 `/login to activate`，说明权益恢复最短路径在部分场景里已存在。
- `getBridgeDisabledReason()` 已经把 Remote Control 的资格前提拆成订阅、full-scope token、组织画像、gate、build 五类诊断，这本质上已经是一个准 preflight 系统。
- `trustedDevice` enrollment 依赖 fresh login 后的短窗口，说明某些高安全能力天然需要“会前体检”，而不是等到失败后再做 lazy 修补。
- `errors.ts` 已把 token revoked、组织不允许、通用 auth error、模型不可用、refusal 等分成不同恢复文案，说明最短恢复路径在 API 错误层已具雏形。
- 更高抽象看，平台当前更像“拥有分散的 preflight 零件”，而不是“没有 preflight”；下一步最值得补的是把这些零件组合成显式的预检面。

证据:

- `claude-code-source-code/src/hooks/notifs/useCanSwitchToExistingSubscription.tsx:10-58`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts:38-87`
- `claude-code-source-code/src/bridge/trustedDevice.ts:89-180`
- `claude-code-source-code/src/services/api/errors.ts:838-883`
- `claude-code-source-code/src/services/api/errors.ts:1109-1177`

### Y. Semantic compression tax is a real governance cost

- `getBridgeDisabledReason()` 已经把订阅、full-scope、组织画像、gate、build 拆开，但对用户而言这些差异仍可能被主观压缩成统一的“不能用”体感。
- `errors.ts` 已把 token revoked、组织不允许、通用 auth、model not available、refusal 做分类，说明系统内部有更细 reason families，但体验层仍可能进一步塌缩。
- `useCanSwitchToExistingSubscription()` 证明“没有能力”和“能力未激活到当前路径”根本不是一回事，若提示未被正确吸收，用户很容易误判成权限被收回。
- `mcp/client.ts` 把远程 auth failure 提升成 `needs-auth` 的连接状态，而不是全局账号状态，但用户直觉上仍容易把 connector 故障外推成整套账号不稳定。
- `sessionIngress.ts` 把多种 401 类连续性问题统一翻译成“Please run /login”，恢复上很务实，但也会让不同底层原因在体验层被压缩为同一动作。
- 更高抽象看，系统内部的多层治理语义若没有被充分结构化地暴露给用户，就会把解释负担转嫁给用户和支持团队，这就是语义压缩税。

证据:

- `claude-code-source-code/src/bridge/bridgeEnabled.ts:57-83`
- `claude-code-source-code/src/services/api/errors.ts:838-883`
- `claude-code-source-code/src/services/api/errors.ts:1109-1177`
- `claude-code-source-code/src/hooks/notifs/useCanSwitchToExistingSubscription.tsx:17-58`
- `claude-code-source-code/src/services/mcp/client.ts:335-370`
- `claude-code-source-code/src/services/api/sessionIngress.ts:144-147`
- `claude-code-source-code/src/services/api/sessionIngress.ts:355-359`
- `claude-code-source-code/src/services/api/sessionIngress.ts:462-467`

### Z. Identity is assembled from multiple truth sources, not one

- `config.ts` 持久化了 `oauthAccount`、`cachedStatsigGates`、`cachedGrowthBookFeatures`、`claudeCodeFirstTokenDate` 等状态，说明本地快照本身就是治理真相的一部分。
- `storeOAuthAccountInfo(...)` 会把服务端 profile 摘要持久化进 `oauthAccount`，但 `validateForceLoginOrg()` 又明确要求关键组织边界必须重新向 `/api/oauth/profile` 取权威真相，说明快照真相和权威真相被刻意分层。
- `user.ts` 和 `telemetryAttributes.ts` 会把 `deviceId/sessionId/accountUuid/organizationUuid/subscriptionType/rateLimitTier/firstTokenTime` 重新拼成 GrowthBook/telemetry 用户模型，说明观测层看到的是“组装后的你”。
- `growthbook.ts` 同时依赖本地 cached features 与 fresh value；某些 cached `true` 可直接放行，cached `false` 则要阻塞复核，说明 gate 真相也有自己的时间层。
- `sessionStorage.ts` 与 `sessionIngress.ts` 维护的是另一条会话连续性真相面：`Last-Uuid` 链、409 adopt server UUID、401 bad token，它不等同于账号画像真相。
- 更高抽象看，很多“明明还是同一个账号，为什么系统前后说法变了”的体验，来自本地快照、服务端画像、gate 缓存与会话连续性在短时间内没有同步收敛。

证据:

- `claude-code-source-code/src/utils/config.ts:440-449`
- `claude-code-source-code/src/utils/config.ts:783-795`
- `claude-code-source-code/src/services/oauth/client.ts:517-565`
- `claude-code-source-code/src/utils/auth.ts:1919-1999`
- `claude-code-source-code/src/utils/user.ts:31-47`
- `claude-code-source-code/src/utils/user.ts:78-127`
- `claude-code-source-code/src/utils/telemetryAttributes.ts:29-70`
- `claude-code-source-code/src/services/analytics/growthbook.ts:466-480`
- `claude-code-source-code/src/services/analytics/growthbook.ts:770-789`
- `claude-code-source-code/src/services/analytics/growthbook.ts:921-935`
- `claude-code-source-code/src/utils/sessionStorage.ts:1238-1260`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-75`
- `claude-code-source-code/src/services/api/sessionIngress.ts:138-147`

### AA. Proof burden transfer is a fairness issue, not just a support issue

- `getBridgeDisabledReason()`、`useCanSwitchToExistingSubscription()`、`errors.ts` 已在主动承担一部分解释责任，说明平台并非完全把恢复路径留给用户自己猜。
- `validateForceLoginOrg()` 在关键边界上仍要求用户补完组织与 scope 的证明链，说明某些证明责任无法被平台完全内包。
- `diagLogs.ts` 和 startup/connectivity notifications 说明支持体系正在承接内部细语义与外部有限提示之间的翻译责任。
- 对高波动环境用户而言，更高的连续性维护成本，本质上也是更高的证明成本；这解释了为什么“高封号体感”常常不是更高惩罚，而是更高举证难度。
- 更高抽象看，可证明性的成本分配是否公平，本身就是平台正义问题，而不只是 UX 或支持效率问题。

证据:

- `claude-code-source-code/src/bridge/bridgeEnabled.ts:57-83`
- `claude-code-source-code/src/hooks/notifs/useCanSwitchToExistingSubscription.tsx:17-58`
- `claude-code-source-code/src/services/api/errors.ts:838-883`
- `claude-code-source-code/src/services/api/errors.ts:1109-1177`
- `claude-code-source-code/src/utils/auth.ts:1919-1999`
- `claude-code-source-code/src/utils/diagLogs.ts:14-57`

### AB. Error families should map to shortest support paths

- `errors.ts` 已将 `invalid_api_key`、`token_revoked`、`oauth_org_not_allowed`、`auth_error`、`bedrock_model_access`、`connection_error`、`ssl_cert_error`、`rate_limit` 等拆成不同分类，说明系统内部已有较完整的 error families。
- `useCanSwitchToExistingSubscription()` 与 `getBridgeDisabledReason()` 进一步说明 entitlement/订阅激活问题不应被混写进通用 auth 家族。
- `mcp/useManageMCPConnections.ts` 把 `needs-auth` 与 `failed/pending/disabled` 明确区分，说明连接域问题本来就应走单独支持路径。
- `rateLimitMessages.ts` 把 session/weekly/Opus/Sonnet/extra usage/reset time 拆开，说明计费家族本身已具独立支持语义。
- 更高抽象看，真正成熟的解释层不只要有错误分类，还要把每个错误家族绑定到最短恢复动作和支持归属，否则复杂度仍会回流到用户和支持团队。

证据:

- `claude-code-source-code/src/services/api/errors.ts:154-219`
- `claude-code-source-code/src/services/api/errors.ts:838-883`
- `claude-code-source-code/src/services/api/errors.ts:1109-1181`
- `claude-code-source-code/src/hooks/notifs/useCanSwitchToExistingSubscription.tsx:17-58`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts:57-83`
- `claude-code-source-code/src/services/mcp/useManageMCPConnections.ts:755-759`
- `claude-code-source-code/src/services/rateLimitMessages.ts:143-220`

### AC. Proof surfaces should be productized, not left as scattered diagnostics

- `authStatus()` 已经能输出当前 `authMethod`、`orgId`、`orgName`、`subscriptionType` 等核心事实，说明平台已有自证面雏形。
- `commands/bridge/bridge.tsx` 的 `checkBridgePrerequisites()` 已把 policy、资格、版本、token 组成完整 preflight，说明高价值能力的前提检查其实已经存在，只是还未统一产品化。
- `useCanSwitchToExistingSubscription()` 与 `useMcpConnectivityStatus()` 已在产品层提供轻量提示，分别覆盖订阅激活与连接域状态，说明平台并非没有用户面零件。
- `diagLogs.ts` 则构成支持侧的低敏感度证据面，说明“用户仪表盘”和“支持仪表盘”本来就共享一套可证明性基础设施。
- 更高抽象看，当前系统缺的不是诊断零件，而是把 `auth status`、资格 preflight、startup notification、support diagnostics 收敛成同一张用户可执行状态面。

证据:

- `claude-code-source-code/src/cli/handlers/auth.ts:232-317`
- `claude-code-source-code/src/commands/bridge/bridge.tsx:467-503`
- `claude-code-source-code/src/hooks/notifs/useCanSwitchToExistingSubscription.tsx:17-58`
- `claude-code-source-code/src/hooks/notifs/useMcpConnectivityStatus.tsx:25-64`
- `claude-code-source-code/src/utils/diagLogs.ts:14-57`

### AD. Failure handling is a four-layer budget: retry, cooldown, cached denial, terminal stop

- `withRetry.ts` 说明很多 401/403/408/409/429/529 不是统一失败，而是进入不同重试预算；CCR 模式、persistent retry、subscriber gates 等都会改变是否重试。
- `handleOAuth401Error()` 明确先检查“是不是别的进程已经恢复了”，说明恢复预算先处理并发与重复成本，再处理刷新本身。
- `fastMode.ts` 把 runtime state 建模成 `active/cooldown`，说明某些失败的正确动作不是继续试，而是进入正式冷却层。
- `mcp/client.ts` 的 15 分钟 `needs-auth` cache 说明系统会对某些路径做短期必败记忆，而不是每次都重新撞墙。
- `initReplBridge.ts` 对 dead token 做跨进程 fail count 和记忆，达到阈值后直接跳过注册，说明 bridge 也有自己的缓存拒绝层。
- `bridgeMain.ts` / `replBridge.ts` 把 `auth_failed` 与 `fatal` 分开，并在 fatal/auth_failed 后 backoff，说明终止层和恢复层并非同一语义。

证据:

- `claude-code-source-code/src/services/api/withRetry.ts:91-98`
- `claude-code-source-code/src/services/api/withRetry.ts:696-780`
- `claude-code-source-code/src/utils/auth.ts:1345-1392`
- `claude-code-source-code/src/utils/fastMode.ts:178-233`
- `claude-code-source-code/src/services/mcp/client.ts:257-263`
- `claude-code-source-code/src/services/mcp/client.ts:363-370`
- `claude-code-source-code/src/services/mcp/client.ts:2311-2322`
- `claude-code-source-code/src/bridge/initReplBridge.ts:169-239`
- `claude-code-source-code/src/bridge/bridgeMain.ts:659-730`
- `claude-code-source-code/src/bridge/replBridge.ts:2080-2105`

### AE. Organization governance is a three-party coordination problem

- `policyLimits` 表明平台负责下发策略接口和客户端消费链，而不是把组织限制硬编码到本地。
- `remoteManagedSettings` 进一步说明组织治理会进入本地运行时：读取缓存、远程拉取、危险设置确认、热更新。
- `securityCheck.tsx` 表明危险变更并非管理员单方面静默生效，终端用户仍是本地最后一跳确认者。
- 更高抽象看，很多“像封号”的体验并不是平台与用户的二元问题，而是平台、管理员、用户三方责任边界没有被清楚对齐。

证据:

- `claude-code-source-code/src/services/policyLimits/index.ts:217-320`
- `claude-code-source-code/src/services/policyLimits/index.ts:505-535`
- `claude-code-source-code/src/services/policyLimits/index.ts:618-629`
- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:410-560`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:22-73`

### AF. Risk control can be reduced to three proof chains

- `isClaudeAISubscriber()`、`hasProfileScope()`、`getOauthAccountInfo()` 共同说明“有 token”不等于主体链成立，主体链需要凭证、来源、画像一起闭合。
- `getBridgeDisabledReason()` 则表明资格链要额外证明订阅、full-scope、组织画像与 feature gate，而不仅是主体存在。
- `sessionIngress.ts` 与 `mcp/client.ts` 进一步说明会话链是独立事实面：`Last-Uuid`、401、409 adopt server UUID、`needs-auth` 都不等同于主体链或资格链。
- 更高抽象看，很多“像被封了”的体验不是单点风控，而是主体链、资格链、会话链中至少一条未能持续成立。

证据:

- `claude-code-source-code/src/utils/auth.ts:1564-1617`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts:57-83`
- `claude-code-source-code/src/utils/auth.ts:1919-1999`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-75`
- `claude-code-source-code/src/services/api/sessionIngress.ts:138-147`
- `claude-code-source-code/src/services/mcp/client.ts:335-360`
- `claude-code-source-code/src/services/mcp/client.ts:2311-2322`

### AG. Shared vocabulary reduces semantic mismatch across user, admin, and support

- `getBridgeDisabledReason()` 已能把用户最常感受到的“不能用”拆成订阅、full-scope、组织画像、gate 等共享 reason family 雏形。
- `useCanSwitchToExistingSubscription()` 把“已有权益但未激活”做成单独提示，说明 entitlement/activation 本来就应与 auth_error 分开命名。
- `useMcpConnectivityStatus()` 对 `failed`、`needs-auth`、connector unavailable 使用不同提示，说明连接域本来就需要单独词汇。
- `errors.ts` 进一步把 `token_revoked`、`oauth_org_not_allowed`、`auth_error` 区分成不同错误族，说明支持侧早已有共享词汇基础。
- `diagLogs.ts` 则提供了低敏感度事件面，支持团队可以在不看 PII 的前提下沿这些 reason family 做调查。
- 更高抽象看，很多误伤不是因为没有答案，而是三方没用同一套词汇描述同一个失败；共享词汇本身就是降低总伤害的治理基础设施。

证据:

- `claude-code-source-code/src/bridge/bridgeEnabled.ts:70-83`
- `claude-code-source-code/src/hooks/notifs/useCanSwitchToExistingSubscription.tsx:21-35`
- `claude-code-source-code/src/hooks/notifs/useMcpConnectivityStatus.tsx:36-63`
- `claude-code-source-code/src/services/api/errors.ts:838-883`
- `claude-code-source-code/src/services/api/errors.ts:1109-1133`
- `claude-code-source-code/src/utils/diagLogs.ts:14-30`

### AE. Governance uses multiple clocks, not one static boundary

- `mcp/auth.ts` 会在 token 距离过期 5 分钟时主动刷新，说明会话治理在时间上前移，而不是等 401 才处理。
- `envLessBridgeConfig.ts` 也默认把 `token_refresh_buffer_ms` 设为 300_000，说明 5 分钟预刷新是跨模块时间哲学。
- `trustedDevice.ts` 明确要求 trusted device enrollment 必须发生在 fresh login 后 10 分钟内，说明高安全能力依赖“会话新鲜度”这一时间边界。
- `mcp/client.ts` 把 `needs-auth` 缓存 15 分钟，说明某些失败状态会被短期记忆，而不是每次重新判断。
- `ccrClient.ts` / `envLessBridgeConfig.ts` 使用 20 秒 heartbeat 对应 60 秒 TTL，`withRetry.ts` 用 30 秒切片 keepalive，说明会话连续性在秒级被周期性再证明。
- `useReplBridge.tsx` 与 `initReplBridge.ts` 的 3 次失败阈值、`withRetry.ts` 的 6 小时 reset cap，则说明恢复预算还有更长时间尺度的熔断与等待上界。
- 更高抽象看，很多“刚刚还能用、后来像被封了”的体验，不是新处罚，而是多个治理时钟在高波动环境中同时错位。

证据:

- `claude-code-source-code/src/services/mcp/auth.ts:1645-1660`
- `claude-code-source-code/src/bridge/envLessBridgeConfig.ts:17-23`
- `claude-code-source-code/src/bridge/envLessBridgeConfig.ts:51-53`
- `claude-code-source-code/src/bridge/trustedDevice.ts:94-97`
- `claude-code-source-code/src/services/mcp/client.ts:257-263`
- `claude-code-source-code/src/services/mcp/client.ts:368-370`
- `claude-code-source-code/src/cli/transports/ccrClient.ts:32-33`
- `claude-code-source-code/src/services/api/withRetry.ts:96-98`
- `claude-code-source-code/src/services/api/withRetry.ts:444-459`
- `claude-code-source-code/src/services/api/withRetry.ts:500-505`
- `claude-code-source-code/src/services/api/withRetry.ts:818-821`
- `claude-code-source-code/src/hooks/useReplBridge.tsx:35-40`
- `claude-code-source-code/src/bridge/initReplBridge.ts:169-239`

### AF. Long-horizon user safety is mostly continuity-cost management

- `auth.ts` 的缓存失效、401 去重、跨进程刷新锁，说明系统显式在对抗“多实例、多缓存、多时钟”导致的身份分叉；用户长期混用多条身份路径，会抬高主体链重证明成本。
- `mcp/auth.ts` 与 `envLessBridgeConfig.ts` 都采用 5 分钟级的预刷新缓冲，说明成熟控制面更关心“不要带着快过期凭证进入长链路”，而不是“等出错后再补救”。
- `mcp/client.ts` 的 `needs-auth` 15 分钟缓存，以及 `toolExecution.ts` 把局部连接域直接标记为 `needs-auth`，说明局部认证失效会被短期记忆；用户应先局部恢复，避免把子系统问题扩大成全局重置。
- `trustedDevice.ts` 把 fresh login 10 分钟窗口与 90 天滚动 token 结合起来，说明高安全能力依赖的是“设备连续性 + 会话新鲜度”，不是普通登录成功后的自动延伸。
- `remoteManagedSettings/index.ts`、`policyLimits/index.ts` 与 `securityCheck.tsx` 共同表明：平台治理是缓慢轮询、校验和缓存、危险变更强确认的组合；长期频繁切组织、切环境、切机器，会显著增加资格链与会话链的解释成本。
- 更高抽象看，合规自保的核心不是对抗检测，而是长期降低主体链、资格链、会话链的重证明成本。

证据:

- `claude-code-source-code/src/utils/auth.ts:1303-1556`
- `claude-code-source-code/src/services/mcp/auth.ts:1633-1668`
- `claude-code-source-code/src/bridge/envLessBridgeConfig.ts:14-23`
- `claude-code-source-code/src/bridge/envLessBridgeConfig.ts:47-90`
- `claude-code-source-code/src/services/mcp/client.ts:257-337`
- `claude-code-source-code/src/services/tools/toolExecution.ts:1599-1623`
- `claude-code-source-code/src/bridge/trustedDevice.ts:17-27`
- `claude-code-source-code/src/bridge/trustedDevice.ts:87-98`
- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:1-23`
- `claude-code-source-code/src/services/policyLimits/index.ts:1-23`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:14-57`

### AG. The control plane can be compressed into a small set of axioms

- `bridgeEnabled.ts` 与 `trustedDevice.ts` 共同说明：权限越高，所需证明越重；claude.ai 订阅、profile scope、组织画像、fresh login、trusted device 并不是可替换条件，而是高能力路径的叠加证明。
- `growthbook.ts` 的 `checkGate_CACHED_OR_BLOCKING()` 明确承认 stale `false` 比 stale `true` 更容易伤害用户，因此对负向拒绝要求更强的新鲜证据；这是“高伤害拒绝比低伤害放行更谨慎”的工程化版本。
- `permissions.ts` 与 `shadowedRuleDetection.ts` 说明这种非对称甚至内建在本地权限引擎里：deny / ask / safety check 先于 bypass 和 allow 执行，宽规则遮蔽窄 allow 还会被显式标记。
- `auth.ts` 的 `validateForceLoginOrg()` 强制去服务端 profile 验证组织，而不是信任本地可写配置；这表明本地真相只能作加速层，不能单独承担裁决。
- `settings.ts` 与 `permissionsLoader.ts` 还说明治理看重“来源可信度”而不只看“配置内容”本身：危险模式和某些自动行为不信任 projectSettings，企业托管策略甚至可以直接压缩规则面。
- `remoteManagedSettings/index.ts` 的 fail-open 与 `securityCheck.tsx` 的危险设置强确认共同表明：治理策略必须按风险等级切换，不能一律 fail-open 或一律 fail-closed。
- `errors.ts`、`mcp/client.ts`、`toolExecution.ts` 则说明系统允许局部撤权、局部失效、局部恢复，而不是把所有失败压成单一“封禁”语义。
- `diagLogs.ts` 进一步说明可解释性也要受限于低敏感证据面；平台并没有把“无限采集”当成成熟风控的前提。
- 更高抽象看，这套系统的核心哲学可以压缩为：持续证明、分层放权、受控恢复、低敏感诊断。

证据:

- `claude-code-source-code/src/bridge/bridgeEnabled.ts:15-88`
- `claude-code-source-code/src/bridge/trustedDevice.ts:17-27`
- `claude-code-source-code/src/bridge/trustedDevice.ts:87-98`
- `claude-code-source-code/src/services/analytics/growthbook.ts:891-929`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1-220`
- `claude-code-source-code/src/utils/permissions/shadowedRuleDetection.ts:1-220`
- `claude-code-source-code/src/utils/auth.ts:1917-1969`
- `claude-code-source-code/src/utils/settings/settings.ts:1-220`
- `claude-code-source-code/src/utils/permissions/permissionsLoader.ts:1-220`
- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:431-500`
- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:604-604`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:14-57`
- `claude-code-source-code/src/services/api/errors.ts:838-878`
- `claude-code-source-code/src/services/api/errors.ts:1109-1132`
- `claude-code-source-code/src/services/mcp/client.ts:319-360`
- `claude-code-source-code/src/services/tools/toolExecution.ts:1599-1623`
- `claude-code-source-code/src/utils/diagLogs.ts:13-30`

### AH. Support routing quality depends on preserving first-party evidence surfaces

- `sessionIngress.ts` 把每个 session 的远程追加串成单链，409 时会采纳服务端链头并继续，401 则立即停止；这说明会话问题首先是链路一致性问题，不是“多试几次”问题。
- `errorLogSink.ts` 把错误和 MCP 调试写成带 `timestamp`、`cwd`、`sessionId`、`version` 的 JSONL，说明支持路径天然偏好结构化证据而不是口头描述。
- `diagLogs.ts` 提供了无 PII 的事件与时长面，适合在用户、管理员、平台支持之间共享而不暴露过多敏感内容。
- `sessionStorage.ts` 的 `tengu_resume_consistency_delta` 说明恢复一致性已经被当成可观测对象；“恢复后前后不一致”不应被简化成用户感受问题。
- `asciicast.ts` 说明终端录制在存在时可以跟随 session ID 重命名并成为补充证据面，适合重建故障发生过程。
- `toolResultStorage.ts` 明确把“已经被模型看到的内容”冻结成决策边界；从支持角度看，第一现场证据价值高于后续大量变更后的证据。
- `settings.ts`、`permissionsLoader.ts`、`mcp/config.ts` 还说明管理员路径必须先确认是不是 managed-only 策略接管，而不是默认把一切都转成平台封禁叙事。
- 更高抽象看，支持效率取决于三件事：正确归属、结构化证据、保护第一现场。

证据:

- `claude-code-source-code/src/services/api/sessionIngress.ts:28-171`
- `claude-code-source-code/src/utils/errorLogSink.ts:1-198`
- `claude-code-source-code/src/utils/diagLogs.ts:13-30`
- `claude-code-source-code/src/utils/sessionStorage.ts:2208-2235`
- `claude-code-source-code/src/utils/asciicast.ts:20-104`
- `claude-code-source-code/src/utils/toolResultStorage.ts:440-505`
- `claude-code-source-code/src/utils/toolResultStorage.ts:642-690`
- `claude-code-source-code/src/utils/settings/settings.ts:675-726`
- `claude-code-source-code/src/utils/permissions/permissionsLoader.ts:40-130`
- `claude-code-source-code/src/services/mcp/config.ts:338-355`

### AI. The repository itself is treated as a potentially hostile input source

- `permissions.ts` 把 deny / ask / safety check 放在 bypass 和 always-allow 之前，说明系统默认更重视“先避免错误放权”，而不是“尽快让配置生效”。
- `shadowedRuleDetection.ts` 会把宽 deny/ask 遮蔽窄 allow 视为显式不可达规则，说明规则面的可解释性本身就是治理目标之一。
- `settings.ts` 明确把 `projectSettings` 排除在 dangerous mode、auto mode、plan mode 相关高风险 opt-in 之外，并直接写明是 malicious project / RCE risk。
- `permissionsLoader.ts` 的 `allowManagedPermissionRulesOnly` 表明企业托管可以直接收缩权限规则面，而不只是提高某条规则优先级。
- `settings.ts` 对 `policySettings` 使用 first source wins，说明某些治理面关心的首先是“来源是否可信”，而不是“把所有来源都合并一下”。
- `mcp/config.ts` 又进一步展示了 allow/deny 的非对称：allow 可以被托管垄断，deny 仍允许用户保留自我保护权。
- 更高抽象看，Claude Code 的信任模型不是“项目声明什么就信什么”，而是“共享对象不能自动替操作者声明高风险同意”。

证据:

- `claude-code-source-code/src/utils/permissions/permissions.ts:1161-1295`
- `claude-code-source-code/src/utils/permissions/shadowedRuleDetection.ts:1-220`
- `claude-code-source-code/src/utils/settings/settings.ts:675-726`
- `claude-code-source-code/src/utils/settings/settings.ts:875-940`
- `claude-code-source-code/src/utils/permissions/permissionsLoader.ts:28-130`
- `claude-code-source-code/src/services/mcp/config.ts:338-355`

### AJ. Auth continuity is engineered as a multi-cache, multi-process coordination problem

- `saveOAuthTokensIfNeeded()` 不会让 refresh 过程里的空 `subscriptionType` / `rateLimitTier` 覆盖已有稳定值，说明作者在主动防止局部不完整响应破坏连续主体画像。
- `handleOAuth401Error()` 先清缓存并重读 secure storage，若发现另一个终端已经写入新 token 就直接接上，而不是立刻强制重登；401 被当作连续性再协商，而不是简单失败。
- `checkAndRefreshOAuthTokenIfNeeded()` 通过 mtime 检测、pending promise 去重、跨进程 lockfile 和锁后二次确认，对抗多终端并发刷新造成的 relogin loops。
- `macOsKeychainStorage.ts` 的 stale-while-error、TTL、generation guard 说明在安全存储短时不稳定时，系统宁可短时保留旧真相，也不愿立刻把所有子系统打成未登录。
- `login.tsx` 在登录成功后会重同步 GrowthBook、policy limits、managed settings、trusted device 与 authVersion，说明登录本质上是控制面重建动作，不是单一按钮事件。
- `trustedDevice.ts` 进一步证明高安全远程链路有独立于普通登录的认证连续性要求：fresh login 10 分钟窗口、旧 token 清理、再 enrollment。
- 更高抽象看，Claude Code 的认证问题不是“有没有登录”，而是“多个子系统是否仍共享足够新鲜的同一主体真相”。

证据:

- `claude-code-source-code/src/utils/auth.ts:1193-1252`
- `claude-code-source-code/src/utils/auth.ts:1303-1556`
- `claude-code-source-code/src/utils/secureStorage/macOsKeychainStorage.ts:25-111`
- `claude-code-source-code/src/commands/login/login.tsx:20-61`
- `claude-code-source-code/src/bridge/trustedDevice.ts:41-98`

### AK. Recovery is constrained by freeze semantics and single-chain continuity

- `sessionIngress.ts` 通过 per-session sequential append、`Last-Uuid`、409 adopt server UUID 与 401 immediate fail，把远程 transcript 明确建模成单链追加，而不是自由并发写入。
- `sessionStorage.ts` 对 sidechain/main-thread 的注释说明，本地可有局部分支，但权威远程链仍必须单线；否则就会出现 409、悬挂 parentUuid 与 resume 断链。
- `toolResultStorage.ts` 明确把“模型已经见过的结果”冻结成后续决策边界：已替换的要 byte-identical 重放，已见未替换的不能事后再改写，以保持 prompt cache 稳定。
- `withRetry.ts` 与 `fastMode.ts` 则把短等待保持 fast mode、长等待进入 cooldown 做成显式状态机；失败窗口并非空白，而是带状态的窗口。
- `replBridge.ts` 又说明某些 stale transport/work state 若继续硬撑，会形成 10 分钟以上 dead window，因此系统宁可 tear down 旧状态以换取快速重分发。
- `sessionStorage.ts` 的 `tengu_resume_consistency_delta` 表明恢复前后的一致性本身就是正式监控对象，不是附带体验问题。
- 更高抽象看，Claude Code 恢复逻辑优先保护链头一致性与已见前缀稳定，因此用户在故障窗口里乱试，往往是在一个已冻结部分历史事实的系统里继续叠加噪声。

证据:

- `claude-code-source-code/src/services/api/sessionIngress.ts:28-171`
- `claude-code-source-code/src/utils/sessionStorage.ts:1228-1261`
- `claude-code-source-code/src/utils/sessionStorage.ts:2208-2235`
- `claude-code-source-code/src/utils/toolResultStorage.ts:440-505`
- `claude-code-source-code/src/utils/toolResultStorage.ts:642-690`
- `claude-code-source-code/src/utils/toolResultStorage.ts:939-970`
- `claude-code-source-code/src/services/api/withRetry.ts:261-301`
- `claude-code-source-code/src/services/api/withRetry.ts:433-505`
- `claude-code-source-code/src/utils/fastMode.ts:178-228`
- `claude-code-source-code/src/bridge/replBridge.ts:1028-1055`

### AL. High-volatility users need rights-preserving discipline more than evasive tactics

- `errors.ts` 的 `token_revoked`、`oauth_org_not_allowed`、generic auth_error 以及 CCR 专用 auth 提示，说明平台内部已有比较明确的身份/组织错误分层；用户若只说“被封了”会丢失最短分流路径。
- `rateLimitMessages.ts` 把 reset time、session limit、weekly limit、out of extra usage 显式建模，说明很多“突然不能继续”并不是处罚，而是额度/冷却窗口；用户利益保护首先要求不要把这类问题误报成封禁。
- `diagLogs.ts` 提供无 PII 的 diagnostics 事件面，意味着高波动环境用户可以在较低敏感度前提下保留第一现场，而不必在证据保护和隐私之间二选一。
- 结合前面认证连续性、冻结语义、支持分流的证据，可以得出一个更高层结论：对高波动环境用户，最有效的权益保护不是规避检测，而是稳定主路径、减少连续性噪声、保留第一现场并用共享词汇描述问题。

证据:

- `claude-code-source-code/src/services/api/errors.ts:838-878`
- `claude-code-source-code/src/services/rateLimitMessages.ts:143-199`
- `claude-code-source-code/src/utils/diagLogs.ts:13-30`

### AM. Identity continuity is bound to config-home path, storage slot, and org-scoped managed context

- `envUtils.ts` 把 Claude 的本地状态根绑定到 `CLAUDE_CONFIG_DIR` 或 `~/.claude`，说明 config home 本身就是连续性边界的一部分。
- `macOsKeychainHelpers.ts` 用 config-dir 路径哈希参与 keychain service name，意味着不同 config home 对应不同 secure-storage 槽位，而不是同一身份池。
- `plainTextStorage.ts` 与 `fallbackStorage.ts` 则说明即使走 plaintext fallback，也仍沿同一 config home 写 `.credentials.json`，并尽量删除旧主存储以免 stale 凭证遮蔽 fresh 凭证。
- `auth.ts` 的 managed OAuth context 明确禁止 CCR / Claude Desktop 这类受管环境回退到用户终端自己的 API key 来源；凭证存在不等于这条身份路径对当前环境合法。
- `validateForceLoginOrg()` 进一步对组织不匹配做 fail-closed，并明确要求移除错误 env token 或重新按正确组织登录。
- 更高抽象看，Claude Code 在验证的不只是 token，而是“这个 token 是否沿正确 config root、正确 storage slot、正确运行场景和正确组织边界进入当前环境”。

证据:

- `claude-code-source-code/src/utils/envUtils.ts:5-14`
- `claude-code-source-code/src/utils/secureStorage/index.ts:1-16`
- `claude-code-source-code/src/utils/secureStorage/macOsKeychainHelpers.ts:23-40`
- `claude-code-source-code/src/utils/secureStorage/plainTextStorage.ts:8-57`
- `claude-code-source-code/src/utils/secureStorage/fallbackStorage.ts:20-58`
- `claude-code-source-code/src/utils/auth.ts:83-110`
- `claude-code-source-code/src/utils/auth.ts:1917-2000`

### AN. The system’s technical sophistication is in observability-coupled control, not just more gates

- `permissionLogging.ts` 把 permission accept/reject 正式接入 analytics、OTel 和 code-edit metrics，说明权限判定本身就是控制面事件，而非本地黑箱结果。
- `telemetry/events.ts` 给事件加上 session-scoped attributes 与 monotonic `event.sequence`，`sessionTracing.ts` 又把 interaction / tool / llm_request 做成统一 tracing 语义，说明系统把时序与归属当成一等事实。
- `perfettoTracing.ts` 进一步把 agent hierarchy、API 时长、tool 执行、等待时间写成 Perfetto trace，代表它不仅记录结果，还记录跨 agent 的运行机制。
- `bridgeMain.ts` 的 heartbeat/re-dispatch/ack-after-commit 逻辑说明系统在很多关键点上优化的是“不可恢复损失窗口最小化”，而不是表面吞吐或单次成功率最大化。
- `firstPartyEventLoggingExporter.ts` 还会把本 session 的事件批量落盘并重试前批次，说明观测连续性本身也是正式工程目标。
- 更高抽象看，Claude Code 的先进性不在 gate 数量，而在把权限、恢复、观测、实验和分布式时序组织成同一张控制平面。

证据:

- `claude-code-source-code/src/hooks/toolPermission/permissionLogging.ts:1-220`
- `claude-code-source-code/src/utils/telemetry/events.ts:1-63`
- `claude-code-source-code/src/utils/telemetry/sessionTracing.ts:1-220`
- `claude-code-source-code/src/utils/telemetry/perfettoTracing.ts:1-220`
- `claude-code-source-code/src/bridge/bridgeMain.ts:196-320`
- `claude-code-source-code/src/bridge/bridgeMain.ts:832-890`
- `claude-code-source-code/src/services/analytics/firstPartyEventLoggingExporter.ts:130-240`

### AO. Many seemingly inconsistent choices become coherent under a multi-loss objective

- `growthbook.ts` 的 `checkGate_CACHED_OR_BLOCKING()` 说明 stale `true` 和 stale `false` 的损失不对称；系统优先减少错误阻断而不是追求表面判定对称。
- `remoteManagedSettings/index.ts` 的 stale-cache / fail-open，与 `securityCheck.tsx` 的危险变更强确认，说明低风险和高风险路径在损失排序上不同。
- `withRetry.ts`、`fastMode.ts` 与 `rateLimitMessages.ts` 说明平台显式把短时等待、长时 cooldown、reset time 变成正式状态，而不是把一切都简化成继续重试。
- `bridgeMain.ts` 的 ack-after-commit、heartbeat-before-backoff 与 re-dispatch 逻辑说明系统更怕不可恢复丢失窗口，而不是短时多做一次重发或多留一个 stale 状态。
- `permissions.ts` 与 `settings.ts` 的 deny/ask 优先、projectSettings 不可信，则说明高风险错误放权的损失被排在很前面。
- 更高抽象看，Claude Code 的风控不是在最小化一个指标，而是在平台安全、不可恢复状态、用户误伤、支持解释成本之间做动态平衡。

证据:

- `claude-code-source-code/src/services/analytics/growthbook.ts:891-929`
- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:431-500`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:14-57`
- `claude-code-source-code/src/services/api/withRetry.ts:261-304`
- `claude-code-source-code/src/utils/fastMode.ts:178-228`
- `claude-code-source-code/src/services/rateLimitMessages.ts:143-199`
- `claude-code-source-code/src/bridge/bridgeMain.ts:196-269`
- `claude-code-source-code/src/bridge/bridgeMain.ts:832-890`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1161-1295`
- `claude-code-source-code/src/utils/settings/settings.ts:875-940`

### AP. Approval itself is treated as a governed trust surface

- `permissionLogging.ts` 把 accept/reject 来源显式建模为 config/user/hook/classifier，并把批准结果写入 analytics、OTel 和 toolDecisions，说明批准不是无来源事件。
- `channelPermissions.ts` 允许 Telegram/iMessage/Discord 之类 channel relay 参与 permission prompt，但批准必须通过结构化事件而非普通文本；源码还明确指出真正的 trust boundary 是 allowlist。
- `channelAllowlist.ts` 进一步说明替代批准面必须先通过 `{marketplace, plugin}` allowlist 和总开关 gate，而不是任何能发消息的插件都自动拥有批准资格。
- 更高抽象看，Claude Code 在治理的不只是动作本身，也在治理“谁有资格替用户说 yes”。批准权本身就是风控对象。

证据:

- `claude-code-source-code/src/hooks/toolPermission/permissionLogging.ts:1-240`
- `claude-code-source-code/src/services/mcp/channelPermissions.ts:1-240`
- `claude-code-source-code/src/services/mcp/channelAllowlist.ts:1-77`

### AQ. The system often prefers partial revocation over whole-subject bans

- `mcp/client.ts` 与 `toolExecution.ts` 在认证失败时倾向于只把对应连接打成 `needs-auth`，而不把主体整体判死，说明连接域可以被局部撤权。
- `bridgeMain.ts` / `replBridge.ts` 把 `auth_failed` 与 `fatal` 分开，说明高安全会话链的失效也会分层，而不是一律理解成终局封禁。
- `errors.ts` 与 `rateLimitMessages.ts` 把 quota limit、capacity 429、extra usage requirement 等分开表达，说明时间窗口撤权与主体处罚并不是同一层语义。
- `mcp/config.ts` 和托管权限相关代码还说明组织经常收回的是“谁能放权”的权力，而不是主体本身。
- 更高抽象看，Claude Code 更偏向保住主体，再按连接、能力、时间窗口或自扩权力做局部撤回；用户把这些都压成“被封了”会丢失结构诊断。

证据:

- `claude-code-source-code/src/services/mcp/client.ts:337-360`
- `claude-code-source-code/src/services/tools/toolExecution.ts:1599-1623`
- `claude-code-source-code/src/bridge/bridgeMain.ts:198-267`
- `claude-code-source-code/src/bridge/replBridge.ts:2018-2041`
- `claude-code-source-code/src/services/api/errors.ts:520-575`
- `claude-code-source-code/src/services/rateLimitMessages.ts:143-199`
- `claude-code-source-code/src/services/mcp/config.ts:338-355`

### AR. High-volatility users benefit most from low-cost status surfaces and fixed operating order

- `authStatus()` 已经能输出 `authMethod`、`apiProvider`、`orgId`、`subscriptionType` 等最关键状态，这说明平台至少为用户提供了低成本的会前/故障时自检入口。
- `useMcpConnectivityStatus.tsx` 会把 local MCP failed、claude.ai connector unavailable、needs-auth 分开提示，并且只对“曾经连通过”的 claude.ai connector 提高提醒优先级，说明平台在鼓励用户按状态变化而不是按情绪升级问题。
- 结合前面认证连续性、局部撤权和支持分流的证据，可以推导出一个更严格的运行 SOP：平时固定主路径，开工前先看状态面，故障窗口先冻结变量，再按共享词汇和结构化证据升级求助。

证据:

- `claude-code-source-code/src/cli/handlers/auth.ts:233-315`
- `claude-code-source-code/src/hooks/notifs/useMcpConnectivityStatus.tsx:1-88`

### AS. Many platform-side gains now depend more on productizing existing surfaces than inventing new gates

- `authStatus()` 已经提供主体、组织、订阅、provider 维度的低成本状态面，但仍主要停留在命令输出层。
- `status.tsx` 已经能汇总 MCP connected / needs-auth / failed / pending，说明连接健康面已经具备产品化基础。
- `MCPListPanel.tsx` 进一步把 enterprise / user / local / project / claude.ai connector 分层展示，意味着连接状态不仅存在，而且已经有分层 UI 语义。
- `useMcpConnectivityStatus.tsx` 说明平台已经掌握“状态变化优于静态坏状态”的提示原则，只是还没有完全扩展到统一风控状态面。
- 更高抽象看，误伤进一步下降的主要瓶颈不再只是缺少底层能力，而是这些现有状态面、证据面和分流面还没完全前置成统一产品。

证据:

- `claude-code-source-code/src/cli/handlers/auth.ts:233-315`
- `claude-code-source-code/src/utils/status.tsx:1-180`
- `claude-code-source-code/src/components/mcp/MCPListPanel.tsx:1-160`
- `claude-code-source-code/src/hooks/notifs/useMcpConnectivityStatus.tsx:1-88`

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
- 已补风控专题 `24-信号融合、连续性断裂与“像被封了”的生成机制`，把资格、组织、设备、授权、计费、诊断信号如何压缩成封号体感单独抽成一章
- 已补风控专题 `25-问题导向索引：按症状、源码入口与合规动作阅读风控专题`，把症状、章节、源码入口、支持路径与 `risk/` 的问题主线压到同一张检索页
- 已补风控专题 `27-判定非对称性矩阵：哪些路径要快放行，哪些路径必须硬收口`，把 selective failure semantics 从设计哲学下沉成工程对照表
- 已补风控专题 `26-苏格拉底附录：如果要把误伤再降一半，系统该追问什么`，把平台改进、研究方法反思与用户自保标准提升到“总伤害最小化”视角
- 已补风控专题 `41-连续性成本最小化：把合规自保从故障窗口扩展到日常操作纪律`，把分钟级故障纪律上升到日级、周级的连续性成本管理
- 已补风控专题 `42-风控最小公理与反公理：从第一性原理重写控制面哲学`，把散点机制压缩成持续证明、分层放权、受控恢复的最小原则集
- 已补风控专题 `43-支持联动附录：按症状、证明链、归属方与证据面快速分流`，把用户、管理员、平台支持的分流规则和证据面合并成一张运行手册
- 已补风控专题 `44-仓库不是可信主体：从权限优先级到托管收口的信任边界`，把权限顺序、托管收口和项目不可信原则收束成同一套信任模型
- 已补风控专题 `45-认证连续性工程：缓存、锁、密钥链与为什么不要乱换登录路径`，把认证问题从“登录成功/失败”提升为多缓存、多进程的连续性工程
- 已补风控专题 `46-冻结语义与单链恢复：为什么故障窗口越乱试越像被封了`，把恢复问题从“多试几次”提升为单链、一致性和前缀稳定问题
- 已补风控专题 `47-高波动环境用户的合规权益保护：如何降低误伤并缩短自证路径`，把中国/高波动环境用户的利益保护收束成稳定主路径、证据保全和共享词汇三条主线
- 已补风控专题 `48-身份路径绑定：配置根、托管环境与组织闭锁为什么必须一致`，把 config root、storage slot、managed context 与 forceLoginOrg 收束成同一条身份路径模型
- 已补风控专题 `49-检测先进性再评估：风控不是规则堆积，而是观测驱动的分布式控制平面`，把高级性从“gate 很多”提升为“观测-恢复-判定一体化控制面”
- 已补风控专题 `50-损失函数视角：平台究竟在最小化什么，而用户又在失去什么`，把 fail-open、fail-closed、cooldown 与误伤统一翻译成多目标损失平衡
- 已补风控专题 `51-批准链分析：谁有资格替用户说“可以”，以及这本身为何是风控问题`，把权限批准、替代审批面和 allowlist 收束成正式信任边界
- 已补风控专题 `52-局部撤权优于全局封号：能力撤回、连接降级与主体保全的治理哲学`，把大量“像封号”的体验重新分层为连接、能力、时间窗口和自扩权力撤回
- 已补风控专题 `53-高波动环境严格运行SOP：从日常纪律到升级求助的四阶段手册`，把中国/高波动环境用户的合规建议压成可执行顺序
- 已补风控专题 `54-如果要把误伤再降一半：平台必须把哪些现有能力前置成产品`，把改进重点从“再加 gate”转向“统一状态面、证据面和升级面”
- 已补风控专题 `55-后期研究索引：41-54的二级导航、问题入口与最短阅读链`，把后期高密度章节拆成四条二级主线，改善检索结构

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

### AA. 源码质量深线已升级到“显式失败、反竞争条件、chokepoint 与 leaf module”

- `StructuredIO`、`DirectConnectManager`、`RemoteSessionManager`、`bridgeMessaging` 反复体现同一原则：unsupported / unknown / outbound-only control request 必须显式回 error，不能制造假成功。
- `updateTaskState(...)`、`generateTaskAttachments(...)` 与 mailbox attachment 去重逻辑说明作者不是按“单次调用正确”写代码，而是按 stale snapshot、duplicate response、双来源消息这些 race-aware 主路径写代码。
- `onChangeAppState(...)`、`assembleToolPool(...)`、`promptCacheBreakDetection.ts` 说明 Claude Code 倾向于用少数 chokepoint 统一维护 mode sync、tool truth、cache break 解释等全局不变量。
- `pluginPolicy.ts`、`normalization.ts`、`toolPool.ts`、`teammateViewHelpers.ts` 等 leaf module 则说明作者会主动切断循环依赖和模块图污染，以保护这些 chokepoint 不被反向拖垮。

证据：

- `claude-code-source-code/src/cli/structuredIO.ts:135-162`
- `claude-code-source-code/src/cli/structuredIO.ts:533-658`
- `claude-code-source-code/src/server/directConnectManager.ts:81-99`
- `claude-code-source-code/src/server/directConnectManager.ts:188-200`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts:189-213`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts:126-157`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts:215-283`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/tools.ts:193-367`
- `claude-code-source-code/src/utils/task/framework.ts:48-71`
- `claude-code-source-code/src/utils/task/framework.ts:158-248`
- `claude-code-source-code/src/utils/attachments.ts:3583-3665`
- `claude-code-source-code/src/utils/plugins/pluginPolicy.ts:1-20`
- `claude-code-source-code/src/services/mcp/normalization.ts:1-23`
- `claude-code-source-code/src/utils/toolPool.ts:43-79`
- `claude-code-source-code/src/state/teammateViewHelpers.ts:5-21`

### AB. 宿主 API 深线已升级到“失败语义、取消请求与 transcript 防腐层”

- `control_response(error)`、`control_cancel_request`、orphan/duplicate response 不能再被当成边角协议；它们共同决定 host control loop 是否仍然活着。
- `notifySessionStateChanged(...)`、`external_metadata.pending_action`、`permission_mode` 外化说明失败之后系统不会让宿主继续猜当前状态。
- `ensureToolResultPairing(...)` 说明 transcript repair 也应被视为正式 API 现实的一部分，而不是内部补丁层。

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:606-619`
- `claude-code-source-code/src/cli/structuredIO.ts:362-429`
- `claude-code-source-code/src/cli/structuredIO.ts:469-520`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts:265-283`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts:373-383`
- `claude-code-source-code/src/server/directConnectManager.ts:81-99`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts:159-170`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts:189-213`
- `claude-code-source-code/src/utils/sessionState.ts:92-130`
- `claude-code-source-code/src/cli/print.ts:5241-5270`
- `claude-code-source-code/src/utils/messages.ts:5133-5188`

### AC. Prompt 深线还应继续升级到“辅助循环共享前缀资产网络”

- `CacheSafeParams` 不只服务主线程本轮请求，还被 `/btw`、prompt suggestion、session memory、extract memories、auto-dream、agent summary 这些辅助循环复用。
- 这说明 Claude Code 的 prompt 魔力并不是“主线程 system prompt 很强”，而是主线程持续生产可被旁路循环继承的 prefix asset。
- 真正的设计单位因此不只是单次 query，而是“主线程 + 多个 post-turn / side-loop fork”组成的前缀共享网络。

证据：

- `claude-code-source-code/src/query/stopHooks.ts:92-99`
- `claude-code-source-code/src/commands/btw/btw.tsx:183-227`
- `claude-code-source-code/src/cli/print.ts:2274-2298`
- `claude-code-source-code/src/utils/forkedAgent.ts:70-141`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts:184-221`
- `claude-code-source-code/src/services/SessionMemory/sessionMemory.ts:315-325`
- `claude-code-source-code/src/services/extractMemories/extractMemories.ts:371-427`
- `claude-code-source-code/src/services/autoDream/autoDream.ts:224-233`
- `claude-code-source-code/src/services/AgentSummary/agentSummary.ts:81-109`
- `claude-code-source-code/src/tools/AgentTool/runAgent.ts:721-729`

### AC. 预算器深线已升级到“观测型预算与实际调优方法”

- `get_context_usage` 暴露的不只是总 token，还显式暴露 `systemPromptSections`、`systemTools`、`deferredBuiltinTools`、`mcpTools`、`skills`、`attachmentsByType` 与 `toolCallsByType`，这说明 prompt 预算已被外化成可诊断对象。
- `ContextVisualization` 证明这些字段不是纯 SDK 调试残留，而是前台实际消费的正式观测面。
- 预算观测必须和 `pending_action`、`permission_mode`、`session_state_changed` 一起理解，否则宿主仍会把“预算问题”“审批阻塞”“模式变化”混成一种“系统卡住”。
- `ContextSuggestions` 与 worker init 时对 stale `pending_action` 的清理进一步说明：Claude Code 不是只想让你“看见预算”，而是想形成“观测 -> 建议 -> 调优”的闭环，并防止 crash 后沿用过期阻塞真相。

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:175-305`
- `claude-code-source-code/src/utils/analyzeContext.ts:918-1085`
- `claude-code-source-code/src/utils/contextSuggestions.ts:31-220`
- `claude-code-source-code/src/commands/context/context.tsx:12-60`
- `claude-code-source-code/src/components/ContextVisualization.tsx:110-220`
- `claude-code-source-code/src/components/ContextSuggestions.tsx:11-45`
- `claude-code-source-code/src/utils/sessionState.ts:92-130`
- `claude-code-source-code/src/cli/transports/ccrClient.ts:476-487`
- `claude-code-source-code/src/state/onChangeAppState.ts:50-92`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:332-460`

### AD. 预算深线已升级到“观测 -> 建议 -> 调优”的闭环

- `get_context_usage`、`/context` 与 `ContextVisualization` 共享同一条采集路径，观测的是模型实际会看到的工作集，而不是 REPL 原始历史。
- `ContextSuggestions` 说明 Claude Code 不满足于告诉你“哪里胖”，还会继续把预算结构翻译成下一步动作建议。
- 这意味着预算在 Claude Code 里不只是控制器，也是建议器；它既约束系统，也帮助人类和宿主决定下一步该改 prompt、改工具面，还是改对象选择。

证据：

- `claude-code-source-code/src/utils/analyzeContext.ts:918-1085`
- `claude-code-source-code/src/utils/contextSuggestions.ts:31-220`
- `claude-code-source-code/src/commands/context/context.tsx:12-60`
- `claude-code-source-code/src/commands/context/context-noninteractive.ts:16-120`
- `claude-code-source-code/src/components/ContextVisualization.tsx:14-20`
- `claude-code-source-code/src/components/ContextVisualization.tsx:105-245`
- `claude-code-source-code/src/components/ContextSuggestions.tsx:11-45`
- `claude-code-source-code/src/cli/print.ts:2961-2978`

### AE. 安全深线还应升级到“输入边界控制平面”

- `policySettings` 最关键的作用不是“多一个 enterprise source”，而是把“谁有资格扩张运行时边界”建模成一等 authority source。
- Claude Code 明显采用不对称安全模型：allow/allowlist/可执行 hook 这类扩权输入可以被锁到 managed source；deny 与自我限制仍允许来自本地来源。这在 sandbox、permission rules、hooks、MCP allowlist 上都能看到同构模式。
- `sandboxTypes -> settings/types -> sdk/coreTypes -> sandbox-adapter` 说明安全边界是正式 contract 再编译成 runtime hard boundary，而不是工具内部零散判断。
- `sandbox-adapter` 不只执行限制，还会 deny write 到 settings 文件、managed drop-ins 和 `.claude/skills`，说明 runtime boundary 还在反向保护 control plane 本身不被 agent 篡改。
- `remoteManagedSettings` 更像策略分发与热更新通道；真正的安全边界仍在 source gating、settings merge 与 adapter enforcement。

证据：

- `claude-code-source-code/src/utils/settings/constants.ts:159-180`
- `claude-code-source-code/src/utils/settings/settings.ts:319-343`
- `claude-code-source-code/src/utils/settings/settings.ts:665-689`
- `claude-code-source-code/src/utils/managedEnv.ts:93-135`
- `claude-code-source-code/src/entrypoints/sandboxTypes.ts:1-133`
- `claude-code-source-code/src/entrypoints/sdk/coreTypes.ts:1-16`
- `claude-code-source-code/src/utils/settings/types.ts:655-655`
- `claude-code-source-code/src/utils/permissions/permissionsLoader.ts:27-120`
- `claude-code-source-code/src/utils/hooks/hooksConfigSnapshot.ts:9-83`
- `claude-code-source-code/src/services/mcp/config.ts:337-360`
- `claude-code-source-code/src/utils/settings/pluginOnlyPolicy.ts:1-58`
- `claude-code-source-code/src/utils/sandbox/sandbox-adapter.ts:172-247`
- `claude-code-source-code/src/utils/sandbox/sandbox-adapter.ts:743-752`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:15-60`
- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:321-337`
- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:457-550`
- `claude-code-source-code/src/utils/settings/changeDetector.ts:437-447`

### AF. Claude Code 真正在预算的是“无序自由度”

- 更高一层的统一解释不是“单一预算器”，而是 Claude Code 在同时约束动作空间、权威空间、上下文空间与时间空间的无序扩张。
- 工具过滤、`policySettings` 的 first-source-wins、memoized system sections、tool result replacement、turn continuation、cache-break explanation 这些看似分散的机制，本质上都在反对“先全暴露再事后补救”。
- prompt 稳定性不只是性能技巧，而是运行时治理的一部分；如果 authority、tool order、sections、fork prefix 都会漂移，系统就既不安全，也不稳定，还更贵。
- Claude Code 共享的不只是原则，也共享方法：typed decision、frozen decisions、stable prefix、explicit observability。
- `get_context_usage` 外化 `systemPromptSections` 与 `messageBreakdown`，说明这套反扩张系统并不是内部优化，而是正式控制面真相。

证据：

- `claude-code-source-code/src/tools.ts:345-364`
- `claude-code-source-code/src/utils/toolPool.ts:63-74`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1167-1259`
- `claude-code-source-code/src/utils/settings/settings.ts:322-343`
- `claude-code-source-code/src/utils/settings/settings.ts:675-689`
- `claude-code-source-code/src/constants/systemPromptSections.ts:17-50`
- `claude-code-source-code/src/utils/toolResultStorage.ts:272-320`
- `claude-code-source-code/src/utils/toolResultStorage.ts:740-772`
- `claude-code-source-code/src/query.ts:369-383`
- `claude-code-source-code/src/query/tokenBudget.ts:1-75`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-315`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:437-470`
- `claude-code-source-code/src/utils/forkedAgent.ts:47-79`
- `claude-code-source-code/src/query/stopHooks.ts:92-99`
- `claude-code-source-code/src/commands/btw/btw.tsx:183-210`
- `claude-code-source-code/src/utils/analyzeContext.ts:1353-1363`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:175-215`

### AG. 源码先进性更适合压成“五种不变量治理模式”

- `query.ts` 更像 query runtime 的 control-plane chokepoint，而不是单纯的大文件；预算、snip、microcompact、恢复、续轮都被明确排进一条主链。
- `QueryGuard`、`tokenBudget` 与 `state.transition.reason` 说明 Claude Code 偏爱 typed decision / typed transition，而不是让复杂状态继续留在布尔泥团里。
- `normalizeMessagesForAPI()` 与 `claude.ts` 请求出口承担的是 authoritative surface，负责统一合法化 API 输入与最终 wire shape。
- `QueryGuard` generation、防 orphan tool_use、frozen replacement fate 等都说明它按 race-aware runtime 写代码，默认真实世界会中断、重试、fallback、resume。
- `Tool.ts` 把模型序列化、UI 渲染、搜索文本、自动分类输入拆开，说明它理解的“工具”是 contract，而不是一个 `call()`。

证据：

- `claude-code-source-code/src/query.ts:265-420`
- `claude-code-source-code/src/query.ts:1190-1235`
- `claude-code-source-code/src/query.ts:1700-1735`
- `claude-code-source-code/src/query/config.ts:1-43`
- `claude-code-source-code/src/query/deps.ts:1-37`
- `claude-code-source-code/src/QueryEngine.ts:176-210`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-108`
- `claude-code-source-code/src/query/tokenBudget.ts:22-75`
- `claude-code-source-code/src/utils/messages.ts:1989-2045`
- `claude-code-source-code/src/utils/messages.ts:5200-5225`
- `claude-code-source-code/src/Tool.ts:158-220`
- `claude-code-source-code/src/Tool.ts:362-390`
- `claude-code-source-code/src/Tool.ts:557-595`
- `claude-code-source-code/src/Tool.ts:717-750`
- `claude-code-source-code/src/utils/toolResultStorage.ts:835-924`

### AH. Prompt 魔力更像“上下文准入编译器”

- 更强的表述不是“稳定前缀”，而是 Claude Code 有一条上下文准入编译链：先定来源优先级，再分 static/dynamic block，再锁定 schema/header 字节，最后在 compaction 时保住意图连续性。
- `buildEffectiveSystemPrompt()`、dynamic boundary、`splitSysPromptPrefix()` 与 `buildSystemPromptBlocks()` 共同说明 prompt 是编译产物，不是字符串拼接结果。
- `toolSchemaCache` 与 sticky beta headers 说明 prompt 稳定性真正追求的是 byte-level determinism，而不只是语义大致相同。
- `yoloClassifier` 复用 `CLAUDE.md` 前缀给权限分类器，说明安全判断也必须共享同一上下文准入真相。
- compaction 在保留 primary intent / current work / next step 的同时，去掉会重注入的 attachments，并在 context-collapse 接管时主动让路，说明“省 token”不能破坏语义连续性。

证据：

- `claude-code-source-code/src/utils/settings/settings.ts:798-812`
- `claude-code-source-code/src/utils/settings/types.ts:542-548`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1417-1445`
- `claude-code-source-code/src/utils/systemPrompt.ts:25-56`
- `claude-code-source-code/src/constants/prompts.ts:343-355`
- `claude-code-source-code/src/constants/prompts.ts:492-510`
- `claude-code-source-code/src/utils/api.ts:300-340`
- `claude-code-source-code/src/utils/toolSchemaCache.ts:1-20`
- `claude-code-source-code/src/services/api/claude.ts:1405-1418`
- `claude-code-source-code/src/services/api/claude.ts:3213-3234`
- `claude-code-source-code/src/utils/permissions/yoloClassifier.ts:442-470`
- `claude-code-source-code/src/services/compact/prompt.ts:55-95`
- `claude-code-source-code/src/services/compact/compact.ts:120-215`
- `claude-code-source-code/src/services/compact/autoCompact.ts:200-220`

### AI. Prompt 组装深线还应升级到“稳定前缀 + 动态尾部 + 旁路 fork”

- `SYSTEM_PROMPT_DYNAMIC_BOUNDARY` 不是注释，而是 prompt cache topology 的正式边界；system prompt 的 static/dynamic 分层被源码显式固定。
- `systemPromptSection` / `DANGEROUS_uncachedSystemPromptSection` 说明 section cache 属于 prompt runtime 本体；稳定是默认，破坏稳定必须被显式承认。
- built-in tool 前缀、session-stable tool schema、deferred tools discovered set 共同说明“工具暴露”也是 prompt assembly 的一部分，而不是另一个独立子系统。
- 高波动信息被不断迁出主 prompt/tool description，改成 deferred/agent/MCP delta attachments，本质是在把变化从前缀搬到尾部。
- `CacheSafeParams`、prompt suggestion、speculation、session memory 说明 Claude Code 真正依赖的是 prefix asset network：辅助智能旁路 fork，并复用主线程前缀，而不是继续膨胀主循环。
- `normalizeMessagesForAPI()` 说明模型最终看到的是 protocol transcript，而不是 UI transcript；prompt assembly 的最后一步是协议化整形。

证据：

- `claude-code-source-code/src/constants/prompts.ts:104-114`
- `claude-code-source-code/src/constants/prompts.ts:343-355`
- `claude-code-source-code/src/constants/prompts.ts:492-510`
- `claude-code-source-code/src/constants/prompts.ts:560-578`
- `claude-code-source-code/src/constants/systemPromptSections.ts:17-50`
- `claude-code-source-code/src/utils/systemPrompt.ts:25-56`
- `claude-code-source-code/src/utils/api.ts:300-340`
- `claude-code-source-code/src/tools.ts:345-364`
- `claude-code-source-code/src/utils/toolSchemaCache.ts:1-20`
- `claude-code-source-code/src/utils/attachments.ts:1448-1495`
- `claude-code-source-code/src/utils/mcpInstructionsDelta.ts:20-52`
- `claude-code-source-code/src/utils/toolSearch.ts:385-430`
- `claude-code-source-code/src/utils/toolSearch.ts:540-560`
- `claude-code-source-code/src/query.ts:1001-1001`
- `claude-code-source-code/src/query/stopHooks.ts:92-99`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts:184-220`
- `claude-code-source-code/src/services/PromptSuggestion/speculation.ts:402-420`
- `claude-code-source-code/src/services/PromptSuggestion/speculation.ts:740-759`
- `claude-code-source-code/src/services/SessionMemory/sessionMemory.ts:303-325`
- `claude-code-source-code/src/utils/messages.ts:1989-2045`

### AJ. Claude Code 接受“轻微陈旧”，来换取系统级确定性

- `getSessionStartDate`、memoized `getSystemContext/getUserContext` 说明 Claude Code 不把“每次都最新”当成最高目标，而把“会话内前缀尽量稳定”放在更高优先级。
- section cache 与 sticky beta headers 共同说明：系统默认接受受控陈旧，拒绝无规律漂移。
- 这种轻微陈旧并不是放弃更新，而是配合 delta attachments 把变化迁到尾部，以更便宜的方式回写。
- 从 prompt 运行时看，这是一条非常成熟的取舍：与其追求所有信息绝对实时，不如先保证跨轮一致性、fork 复用性与 cache 可解释性。

证据：

- `claude-code-source-code/src/constants/common.ts:17-24`
- `claude-code-source-code/src/context.ts:116-165`
- `claude-code-source-code/src/constants/systemPromptSections.ts:17-50`
- `claude-code-source-code/src/utils/toolSchemaCache.ts:1-20`
- `claude-code-source-code/src/services/api/claude.ts:1398-1418`
- `claude-code-source-code/src/services/api/claude.ts:1460-1478`
- `claude-code-source-code/src/services/api/claude.ts:1640-1674`
- `claude-code-source-code/src/utils/attachments.ts:1448-1495`
- `claude-code-source-code/src/utils/mcpInstructionsDelta.ts:20-52`

### AK. Prompt 运行时并不会把 UI transcript 直接喂给模型

- `normalizeMessagesForAPI()` 本质上是 protocol compiler：attachment reorder、virtual message strip、targeted strip、tool_reference boundary 注入、adjacent user merge、tool_result hoist 都发生在 API 边界前。
- attachment-origin 内容会被统一包成 `<system-reminder>`，随后再尽量 smoosh 进最后一个 `tool_result`，说明 runtime 在主动区分“辅助上下文”和“真实用户输入”。
- tool_reference 的边界注入与 sibling 迁移说明 Claude Code 在处理的是 server-side prompt 语义，而不是前台显示语义。
- `extractDiscoveredToolNames(messages)` 说明 protocol transcript 不只是重放历史，还承担 deferred tool 暴露的记忆功能。
- 结论应升级为：UI transcript 服务人类可见真相，protocol transcript 服务模型侧协议真相；二者相关，但不相同。

证据：

- `claude-code-source-code/src/utils/messages.ts:1760-1858`
- `claude-code-source-code/src/utils/messages.ts:1989-2045`
- `claude-code-source-code/src/utils/messages.ts:2130-2195`
- `claude-code-source-code/src/utils/messages.ts:2440-2485`
- `claude-code-source-code/src/utils/messages.ts:5200-5225`
- `claude-code-source-code/src/utils/toolSearch.ts:540-560`
- `claude-code-source-code/src/services/api/claude.ts:1145-1175`

### AL. Claude Code 偏爱渐进暴露，而不是全量声明

- `ToolSearch + deferred tools` 说明能力可以先存在，但不必先全量暴露给模型；运行时更偏爱“发现 -> 回填”闭环。
- `toolSchemaCache` 与 delta attachments 说明即使能力要变化，也尽量把变化留在尾部或增量，而不是主前缀。
- `strictPluginOnlyCustomization`、`allowManagedPermissionRulesOnly` 说明这种“先限制模型可见世界”也发生在 authority/source 层，而不只发生在 tool 层。
- 这条线的更强哲学表述应是：先限制模型可见世界，再要求模型聪明；否则安全、token、cache、治理四条线会同时变差。

证据：

- `claude-code-source-code/src/utils/toolSchemaCache.ts:1-20`
- `claude-code-source-code/src/utils/toolSearch.ts:385-430`
- `claude-code-source-code/src/utils/toolSearch.ts:540-560`
- `claude-code-source-code/src/services/api/claude.ts:1145-1175`
- `claude-code-source-code/src/utils/attachments.ts:1448-1495`
- `claude-code-source-code/src/utils/mcpInstructionsDelta.ts:20-52`
- `claude-code-source-code/src/utils/settings/types.ts:542-548`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1417-1445`

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
