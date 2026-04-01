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
- 已补风控专题 `24-信号融合、连续性断裂与“像被封了”的生成机制`，把资格、组织、设备、授权、计费、诊断信号如何压缩成封号体感单独抽成一章
- 已补风控专题 `25-问题导向索引：按症状、源码入口与合规动作阅读风控专题`，把症状、章节、源码入口、支持路径与 `risk/` 的问题主线压到同一张检索页
- 已补风控专题 `27-判定非对称性矩阵：哪些路径要快放行，哪些路径必须硬收口`，把 selective failure semantics 从设计哲学下沉成工程对照表
- 已补风控专题 `26-苏格拉底附录：如果要把误伤再降一半，系统该追问什么`，把平台改进、研究方法反思与用户自保标准提升到“总伤害最小化”视角

## 下一步待办

- 补 bridge / direct-connect / remote-session 三类宿主路径的更细时序图
- 补一章“多 Agent 协作模式与 prompt 模板”
- 补源码目录级索引表，把 `services/`、`tools/`、`commands/` 细分到二级目录
- 给 `SDKMessageSchema` 与 control subtype 做更细的 message-response crosswalk casebook，并补更细宿主接入样例
- 给 `SDKMessage`、`worker_status`、`external_metadata` 做更细字段级 crosswalk，并补 consumer subset 对照表
- 补 `REPL.tsx` / Ink 更细的 transcript mode、message actions、PromptInput 交互链
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
- direct connect 与 `RemoteSessionManager` 当前实现的 control surface 明显窄于 `StructuredIO` 全量 schema，后续必须持续避免把“schema 全集”和“某个宿主已支持的子集”写成同一层事实。
- bridge 当前虽然明显宽于 direct connect / `RemoteSessionManager`，但仍不是完整 control subtype 全集；后续必须避免把它直接等同于完整 SDK host。
- 显式失败路径目前已经能被解释为架构原则，但尚未对 `authRecoveryInFlight`、transport close code、prompt timeout 等失败语义做完全文级整理，后续仍要继续补。
- request / response / follow-on message 的闭环主线已经建立，但仍未把所有 subtype 做成统一 casebook；后续若继续深化，应防止不同闭环粒度混写。
- 运行时真相的双通道主线已经建立，但仍未把每个状态项都标清“时间线 / 快照 / 恢复 / consumer subset”四层；后续若继续深化，应防止再次退回单通道叙述。
