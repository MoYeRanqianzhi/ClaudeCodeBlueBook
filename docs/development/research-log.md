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

### AT. Evasion attempts generally trade short-term friction relief for higher long-term proof burden

- `auth.ts` 明确禁止 managed session 回退到用户终端私有凭证来源，说明“换一条凭证路径先过再说”在受管上下文里本身就会制造 wrong-org 或 wrong-context 风险。
- `trustedDevice.ts` 中 env token precedence 与 fresh-login enrollment 说明，高安全链路有自己的证明要求；用替代 token / 替代路径临时顶上，并不能稳定替代正确的主体链和设备链。
- `channelAllowlist.ts` 和 `pluginOnlyPolicy.ts` 又说明，即使是扩展面或替代批准面，也被显式放进 allowlist / admin-trusted 边界里；能发声不等于有资格替用户放权。
- 更高抽象看，规避思路的共同问题是：它们试图绕开一层证明，却会同时破坏身份路径、组织边界、批准链或主体连续性中的另一层，因此长期看通常不是最优策略。

证据:

- `claude-code-source-code/src/utils/auth.ts:83-110`
- `claude-code-source-code/src/bridge/trustedDevice.ts:65-115`
- `claude-code-source-code/src/services/mcp/channelAllowlist.ts:1-77`
- `claude-code-source-code/src/utils/settings/pluginOnlyPolicy.ts:1-56`

### AU. Governance is easier to explain when sovereignty and recovery agency are split

- `settings.ts` 的 policySettings first-source-wins 说明组织主权是正式上位裁决层，而不是普通 merge 参与者。
- `pluginOnlyPolicy.ts` 进一步表明管理员不只决定“内容”，还决定“哪些来源还有资格发声”。
- `channelNotification.ts` 和 `channelAllowlist.ts` 则说明替代批准面可以代行批准，但其合法性仍受平台 gate、组织 policy、allowlist 和 session opt-in 共同约束。
- `permissionSetup.ts` 展示了另一类主权：系统可以阻止 mode transition（例如 gate 未开启时不允许进入 auto mode），说明自动化/本地选择权仍受上位边界约束。
- 更高抽象看，平台主权、组织主权、用户主权、替代批准面和自动恢复主权并不对等；很多混乱感来自读者把“能发信号”“能代批”“能恢复”和“能最终裁决”误当成同一件事。

证据:

- `claude-code-source-code/src/utils/settings/settings.ts:675-726`
- `claude-code-source-code/src/utils/settings/pluginOnlyPolicy.ts:1-56`
- `claude-code-source-code/src/services/mcp/channelNotification.ts:220-318`
- `claude-code-source-code/src/services/mcp/channelAllowlist.ts:1-77`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:593-633`

### AV. User-interest protection is often better framed as asset preservation than immediate continuation

- `sessionStorage.ts` 的 transcriptPath/sessionProjectDir 逻辑说明 transcript 文件本身是会话主资产；路径漂移会直接伤害恢复和 hooks 的正确性。
- `reAppendSessionMetadata()` 说明 title/tag 等元数据会被持续保尾部化，本质是在保护会话资产而不是单纯优化展示。
- `sessionRestore.ts` 会在 resume 时同时接管 session ID、recording 文件名、cost state、metadata 和 worktree 绑定，说明恢复的对象是一整套资产关系，而非单一消息列表。
- `asciicast.ts` 与 `errorLogSink.ts` 又说明录屏、JSONL 错误日志、MCP 日志都被设计成会话相关资产；一旦风控窗口里把这些资产保护住，用户即使暂时不能继续运行，也仍保有恢复与自证抓手。
- 更高抽象看，用户利益保护不应只被理解成“马上继续用”，更应被理解成“在异常窗口里最大化工作连续性资产的可恢复性和可证据化”。

证据:

- `claude-code-source-code/src/utils/sessionStorage.ts:203-255`
- `claude-code-source-code/src/utils/sessionStorage.ts:694-740`
- `claude-code-source-code/src/utils/sessionRestore.ts:437-520`
- `claude-code-source-code/src/utils/asciicast.ts:12-104`
- `claude-code-source-code/src/utils/errorLogSink.ts:1-198`

### AW. A large share of support cost is really template cost

- `authStatus()` 已经能输出足够多的主体/组织/订阅信息，说明高质量求助文本所需的大部分主体状态其实已经可低成本获得。
- 前面的通知面和状态面又已经能把 local MCP failed、claude.ai connector unavailable、needs-auth 分层提示，这意味着用户如果仍只写“被封了”，问题往往不在证据缺失，而在表达模板缺失。
- 更高抽象看，很多误伤恢复效率低，并不是系统完全没有状态面，而是用户、管理员和平台支持缺少一套统一的最短高质量文本模板。

证据:

- `claude-code-source-code/src/cli/handlers/auth.ts:233-315`
- `claude-code-source-code/src/hooks/notifs/useMcpConnectivityStatus.tsx:1-88`

### AX. China-facing access ecology should be analyzed with explicit epistemic boundaries

- Anthropic 官方支持国家/地区页面当前未列出中国大陆，Claude Code 相关文档又明确要求互联网连接完成认证和 AI 处理，并支持 Claude.ai、API、Bedrock、Vertex 等官方路径；这解释了中国用户面临的基础接入摩擦不是单一网络问题，而是入口层摩擦。
- Anthropic 官方还公开写了第三方 LLM gateway / proxy 的集成文档，这说明“兼容入口”是被产品面显式考虑过的接入形态，但不等于任何第三方入口都与官方全链路能力等价。
- AnyRouter 自身公开文档明确把自己定位为 Claude Code 中转/API 转发入口，强调国内直连、免费额度、无信用卡门槛，并公开展示基于 `ANTHROPIC_BASE_URL` 的使用方式。
- AnyRouter FAQ 还公开承认 `claude --offline` 的相关检查主要看 Google 连通性，且 `fetch` 仍依赖 Claude 国际版服务，说明第三方兼容入口重写的是部分接入面，而不是整个官方能力面。
- 公开社区材料能够支持“中转站/兼容代理是中国用户常见实际使用方式”这一观察，但不能自动推出某个具体幕后公司关系。
- 截至当前检索到的公开资料，我未找到足够可靠证据证明 AnyRouter 与智谱存在明确控制/运营关系；这类说法应保持在“未证实传闻”或“一般性战略推演”层面。
- 智谱官网公开材料能够支持另一类更稳健的推断：其确实高度重视 coding/agentic workflow、API 平台、agent 产品和开发者流量，并使用大规模 token 激励；但这与 AnyRouter 的具体归属关系不是同一层事实。
- Claude Code 源码还能进一步校正认知边界：客户端虽支持 `ANTHROPIC_BASE_URL`，但会显式区分第一方 Anthropic host 与第三方 host；工具搜索、流式接口、Remote Control、OAuth 上传/附件、远程托管设置等能力都表明第三方兼容入口通常只能部分重写接入问题，不能自动等价官方全链路。

证据:

- `https://www.anthropic.com/supported-countries`
- `https://docs.anthropic.com/zh-CN/docs/claude-code/setup`
- `https://docs.anthropic.com/zh-TW/docs/claude-code/third-party-integrations`
- `https://docs.anthropic.com/zh-CN/docs/claude-code/amazon-bedrock`
- `https://docs.anyrouter.top/`
- `https://www.whois.com/whois/anyrouter.top`
- `https://www.zhipuai.cn/zh`
- `claude-code-source-code/src/utils/preflightChecks.tsx:19-21`
- `claude-code-source-code/src/utils/preflightChecks.tsx:130-130`
- `claude-code-source-code/src/utils/apiPreconnect.ts:56-60`
- `claude-code-source-code/src/services/api/filesApi.ts:30-36`
- `claude-code-source-code/src/utils/model/providers.ts:21-36`
- `claude-code-source-code/src/utils/toolSearch.ts:282-307`
- `claude-code-source-code/src/services/api/claude.ts:2607-2618`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts:19-23`
- `claude-code-source-code/src/utils/auth.ts:1611-1616`
- `claude-code-source-code/src/tools/BriefTool/upload.ts:121-122`
- `claude-code-source-code/src/bridge/inboundAttachments.ts:77-83`
- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:188-201`

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
- 已补风控专题 `56-反规避原则：为什么任何绕过思路都会回到更高风险与更高证明负担`，把“规避冲动”改写为第一性原理层面的反规避论证
- 已补风控专题 `57-终局总指南：Claude Code风控研究的最佳最全合规版`，把后期全部研究压缩成一份面向用户和平台构建者的终局合规总结
- 已补风控专题 `58-治理主权与恢复主动权：谁能关、谁能开、谁能替你说 yes`，把平台、组织、用户、替代批准面和自动恢复主权收束成一张主权图
- 已补风控专题 `59-资产保全与退出策略：账号风控窗口里真正该保护的不是面子而是工作连续性`，把用户利益保护进一步压缩成 transcript、日志、录屏和 worktree 资产保全逻辑
- 已补风控专题 `60-结构化求助模板库：用户、管理员与平台支持的最短高质量文本`，把状态面和分流逻辑转化成可直接复制的高质量求助文本
- 已补风控专题 `61-中国用户使用生态与认识论边界：官方路径、中转站与幕后叙事该如何判断`，把官方门槛、AnyRouter 这类中转站、以及 AnyRouter/智谱 关系的证据边界明确分层
- Anthropic 官方 settings 文档进一步确认了用户、项目、本地、managed 四层设置作用域；其中 `.claude/settings.local.json` 是 gitignored 的个人项目覆盖层，而 `cleanupPeriodDays` 默认 30 天、设为 `0` 会禁用会话持久性并让 `/resume` 失效，这对退出策略和本地证据保全非常关键。
- Anthropic 官方 data usage / monitoring 文档进一步确认：Statsig、Sentry、`/bug`、会话质量调查都存在显式开关；同时 OTel 可以导出 `session.id`、`organization.id`、`user.account_uuid` 和 `claude_code.cost.usage` 等指标，说明用户的隐私最小化与支持可解释性之间确实存在张力。
- Anthropic 官方 costs 文档进一步确认了 `/cost`、团队成本管理与正式支持路径的重要性；从用户利益保护角度看，一个缺少标准化成本面和正式支持面的中转入口，应被视为更高的沉没成本风险源，而不是单纯“更便宜”。
- 源码进一步确认 `ANTHROPIC_BASE_URL` 依赖不仅存在于 env，还会进入 settings / worktree 传播面；`worktree.ts` 会复制 `settings.local.json`，这意味着中转站依赖一旦写入 local settings，可能沿 worktree 扩散，退出时必须做本地配置清点，而不能只删一个 shell 变量。
- 已补风控专题 `62-中国用户利益保护与中转站退出策略：把接入便利转化为可控退出权`，把本地资产主权、成本止损、worktree 配置扩散、组织监控证据和 staged exit 收束成单独一章
- 截至 2026 年 4 月 2 日再次核对 Anthropic 官方 supported countries 与 setup / llm gateway 文档后可以更明确地写：对中国用户而言，Claude Code 的困难不是单一网络问题，而是地区边界、资格边界、在线运行时边界和支持边界的叠加；而 gateway / proxy 作为架构形态本身是被官方文档承认的，但这不等于对任何具体 relay 背书。
- 截至 2026 年 4 月 2 日核对 AnyRouter 公开文档与 WHOIS 后可以更明确地写：AnyRouter 公开卖点确实集中在“国内直连、免费额度、无需信用卡、Claude Code 兼容”，说明它卖的是低摩擦接入权；但公开资料仍不足以把 AnyRouter 与智谱关系写成已证事实。
- 截至 2026 年 4 月 2 日核对智谱官方 Claude Code 文档与更新页后可以更明确地写：智谱已经公开把 Claude Code 作为目标宿主来争夺，直接提供 `ANTHROPIC_BASE_URL` / `ANTHROPIC_AUTH_TOKEN` 配置、Claude 到 GLM 的模型映射与面向 Claude Code 的价格叙事；这说明国内厂商的战略重点已经从单纯“模型替代”前移到“工作流入口竞争”。
- 源码进一步确认这种入口竞争在技术上确实可行但不等于官方等价：`providers.ts` 区分 first-party 与第三方 host，`toolSearch.ts` 明确提示很多 `ANTHROPIC_BASE_URL` 代理不支持 `tool_reference`，`auth.ts` 对第一方账号信息有单独语义，说明兼容入口更准确的产品定义是“部分等价的工作流接入层”而不是“完整官方替身”。
- 已补风控专题 `63-中国用户为什么在买入口而不是买模型：Claude Code 的地区摩擦、兼容层补贴与工作流争夺`，把中国用户困难、AnyRouter 这类中转站、智谱公开 Claude-compatible 战略、以及补贴兼容入口背后的入口争夺哲学压成独立一章
- 继续加深第 `63` 章后，可以更稳地把两个技术结论写实：AnyRouter FAQ 已经说明 relay 只能重写部分外部依赖，不能自动抹平 Google 连通性和网页 Fetch 等前置条件；`bridgeEnabled.ts` 又进一步证明 gateway deployment 与 claude.ai OAuth entitlement 不等价，因此“兼容入口”最准确的定义是“接入层与工作流层的部分替身”，不是完整第一方等价物。
- 进一步把这一板块收尾后，可以更清楚地把“等价”拆成四层：传输层、认证层、资格层、治理层。源码已经足够支持这一点：`apiPreconnect.ts` / `filesApi.ts` / `providers.ts` 证明上游可配置是正式现实，但 `auth.ts`、`bridgeEnabled.ts`、`toolSearch.ts` 又证明第一方身份、高阶 entitlement 与 beta 能力并不会因为兼容入口存在而自动等价。
- `worktree.ts` 对 `settings.local.json` 的复制进一步说明，入口选择不是一次性临时变量，而会沉淀成 worktree 扩散面与退出成本。因此“官方直连、官方云厂商路径、第三方 gateway、国内 Claude-compatible 入口”最合适的比较框架，不是谁更像，而是谁替代了哪一层语义、又把哪一层责任重新转嫁给用户。
- 已补风控专题 `64-官方路径、云厂商路径与兼容入口的能力语义差清单：哪些只是能跑，哪些更接近等价`，作为 `61-64` 这一组“中国用户 / 中转生态 / 退出权 / 入口竞争”板块的细致收尾。
- 开始新开 `bluebook/security/` 子目录后，可以更明确地把 Claude Code 的安全性与风控拆开：风控更关心资格、撤权与误伤，安全更关心 trust、permission mode、managed env、外部能力收口与远程 entitlement 的运行时边界。
- 第一批安全专题已经落地 `security/00` 与 `security/01`：`managedEnv.ts` 说明 trust 前只允许受信来源的 env 先进入运行时，防止项目目录借 `ANTHROPIC_BASE_URL` 等变量污染宿主；`setup.ts` 说明 bypassPermissions 不是随手可开的快捷模式，而要求 sandbox / no-internet 等额外外部边界；`dangerousPatterns.ts` 与 `permissionSetup.ts` 则说明系统真正警惕的是“危险 allow rule 绕过仲裁层”，而不是能力本身存在。
- 第二批安全专题继续压实后，可以更系统地写出四条工程判断：`pathValidation.ts` 把 safety check 放在 working-dir 自动允许之前，说明安全优先于目录便利；`auth.ts` 与 `managedEnv.ts` 共同说明认证来源与配置来源都被分层治理，真正危险的是运行时语义被污染；`WebFetchTool/preapproved.ts` 把预批准 GET 域名和 sandbox 网络权限刻意分离，说明读取语义与写入语义被分别治理；`hooksConfigSnapshot.ts` 则说明 hooks 的核心问题不是脚本本身，而是谁拥有插入执行点的主权。
- `secureStorage/*` 还显示出另一条成熟设计：系统先争取 OS keychain 这类更安全介质，再在必要时降级到 plaintext，并显式告知风险；同时 `fallbackStorage.ts` 还处理了旧凭证遮蔽新凭证这一类真实运行时故障，说明它的安全设计不是抽象口号，而是具体到凭证新旧、缓存和回退顺序的工程治理。
- 最后一轮收尾后，`security/06` 已经把这组专题重新压成六条最小公理：来源先于值、仲裁先于放行、外部世界不是默认可信上下文、高阶资格不等于传输层连通、高风险便利必须由更强边界补偿、安全设计必须可解释。这样一来，`bluebook/security/` 已经形成了从方法论、机制、哲学到第一性原理反思的完整独立板块。
- 继续往细粒度手册推进后，权限链的时序已经能更明确写成状态机：`transitionPermissionMode()` 负责 plan/auto 的上下文切换、危险规则剥离与恢复；`permissions.ts` 里的 `safetyCheck` 明确高于 bypass 与大部分 fast-path；auto mode classifier 也不是唯一裁判，而是排在 acceptEdits fast-path、safe-tool allowlist 与若干 bypass-immune 条件之后的中段仲裁器。这使得 `security/07` 可以把权限系统从概念层推进到时序层。
- 再往下压后，配置与受管环境的主权结构也足够清晰：`SETTING_SOURCES` 定义了 later-overrides-earlier 的基础顺序，但 `managedEnv.ts` 又把 trust 前后 env 应用拆成两层；`managedEnvConstants.ts` 把 provider-routing 与 auth 主链变量单独列成 host-managed 风险面；`permissionsLoader.ts`、`hooksConfigSnapshot.ts` 与 `sandbox-adapter.ts` 则说明 managed-only 不只是只读，而是可以把 permission、hooks、sandbox 域与读路径这些整类安全策略重新收口。因此 `security/08` 可以把“谁能改配置”升级为“谁拥有运行时主权”。 
- 把外部入口进一步压成风险矩阵后，可以更明确地区分：MCP 的主风险是上下文与工具面扩张，WebFetch 的主风险是读写语义混淆，hooks 的主风险是隐形执行点与主权冲突，gateway 的主风险则是身份/路由漂移与“兼容但不等价”的语义错觉。这样 `security/09` 不再只是重复“外部能力要收口”，而是把风险分成读取、写入、执行、身份与上下文污染五个正交维度。 
- 再往产品层推进后，可以更稳地得出一个判断：系统其实已经拥有不少“安全状态面零件”，例如 `permissionExplainer.ts`、`createPermissionRequestMessage()`、`status.tsx` 对 setting sources 的呈现、`ManagedSettingsSecurityDialog`、`getBridgeDisabledReason()` 与 auto-mode gate notification；问题不在于完全没有解释层，而在于这些解释仍然分散，尚未汇成一张统一安全仪表盘。因此 `security/10` 的重点不是再描述机制，而是指出“从结构化安全到可解释安全”之间还差哪一步产品化。 
- 继续把安全专题收束到平台构建者层后，可以更稳定地提炼出一组可迁移法则：来源先于值、mode 即安全语义、真正危险的是绕过仲裁层、外部能力要按攻击面建模、兼容不等于 entitlement 等价、解释层必须产品化、以及 public build 边界必须与代码边界同时治理。这样 `security/11` 不再只是总结，而是把 Claude Code 的安全性压缩成可被其他 Agent 平台直接借鉴的一组设计原则。 
- 再往平台产品路线图推进后，现有源码中的零件与缺口关系也更清楚了：`Settings/Status.tsx`、`SandboxConfigTab.tsx`、`PluginSettings.tsx`、`ManagedSettingsSecurityDialog`、`permissionExplainer.ts`、`getBridgeDisabledReason()` 已经分别暴露了 setting sources、sandbox 约束、managed-only 指引、危险设置审批、权限解释和 entitlement 失败原因，但它们仍然分散在局部节点中。于是 `security/12` 可以把下一代产品化重点明确压成统一安全状态面、来源血缘、规则优先级解释、风险标签、managed-only 标识和支持证据包这类高收益改进，而不是继续堆更多零散 gate。 
- 安全专题扩到 `00-12` 后，再单独补一个 `13-安全专题二级索引` 就很有必要：安全目录现在已经同时覆盖方法论、机制、状态机、主权矩阵、攻击面矩阵、可解释性和平台路线图，如果没有问题导向入口，读者很容易重新退回线性顺读。这个二级索引把专题按问题、攻击面、主权冲突、平台改进四种入口重新组织，后续继续扩充章节时也更不容易破坏整体可读性。 
- 继续往“总图化”推进后，安全专题已经足够成熟，可以单独补一个 `14-安全控制面总图`：它把 trust、配置来源、permission mode、动作仲裁、环境隔离、外部入口、身份 entitlement 和解释层重新串成一条全链结构图谱。这样一来，`security/00-13` 不再只是散点深化，而能被重新压回同一张总图，作为后续继续新增章节时的参照坐标。 
- 在这之后，再单独补一个 `15-来源主权总表` 就有了明确价值：`settings/settings.ts` 里的 policy first-source-wins、`managedEnv.ts` 的 host-managed provider env、`permissionsLoader.ts` / `hooksConfigSnapshot.ts` / `mcp/config.ts` / `pluginOnlyPolicy.ts` 的 managed-only 与 plugin-only 收口、以及 `managedPlugins.ts` / `marketplaceHelpers.ts` 对插件供应链主权的收束，已经足够支持一张“谁能定义、谁能覆盖、谁能最终收口”的总表。这让安全专题不只是在讲机制，而是在讲整套系统的主权编排。 
- 有了总图和总表之后，再单独补一个 `16-安全反模式与反公理` 就很自然了：`shadowedRuleDetection.ts` 说明“规则写上去”不等于规则真正可达，`managedEnv.ts` 说明 project/local settings 不是随意改写主链的合法入口，`bridgeEnabled.ts` 说明兼容不等于 entitlement 等价，`validation.ts` 说明系统宁愿过滤坏规则也不让一个坏值毒化整份设置文件。把这些负面教材单独收束后，安全专题就不再只有“正面原则”，也有了一套“哪些做法会慢慢掏空边界”的反公理。 
- 到这里再补一个 `17-终局总指南` 就很有价值了：安全专题已经从方法论一路扩到总图、总表、反模式和产品路线图，继续线性加章节的收益开始下降；更值得做的是把 `00-16` 压缩成一份最短、最高密度、最适合引用的终局版，让读者可以先抓全局判断，再按 `13-二级索引` 回到局部细读。 
- 在终局版之后，安全专题开始适合往“检测技术内核”而不是“更大总论”推进，所以补一个 `18-安全检测技术内核` 很有价值：`dangerousPatterns.ts` / `permissionSetup.ts` 说明 Claude Code 会先审 allow rule 本身是否在绕过 classifier，`permissions.ts` 说明 `safetyCheck` 与 content-specific ask 不是可被 mode 轻易抹平的普通分支，`pathValidation.ts` 说明真正高阶的检测对象不是路径字符串，而是 shell expansion、tilde 变体、UNC、glob 与 symlink 共同形成的路径语义，`mcp/config.ts` / `mcpValidation.ts` / `preapproved.ts` / `managedEnv.ts` 则共同证明外部入口、输出预算和来源主权属于同一条更宽的检测链。 
- 继续往下推，一个自然的下一章不是再堆更多机制，而是把 `18` 抽象成安全不变量，于是单独补一个 `19-安全不变量` 是合理的：Claude Code 真正在守住的并不是零散规则，而是几条更底层的约束，例如结构性危险高于模式便利、来源合法性高于配置值、语义等价高于文本等价、外部能力必须按能力语义治理、局部坏值不应毒化全局、解释层本身就是边界的一部分。把这些不变量单独写出来后，安全专题就不再只是“模块分析”，而开始有了更稳的理论骨架。 
- 继续往源码内核层下钻后，可以更明确地把安全检测技术单独抽成一章：`dangerousPatterns.ts` / `permissionSetup.ts` / `permissions.ts` 说明系统先防“危险 allow rule 架空仲裁层”，`pathValidation.ts` 说明它防的不是路径复杂而是路径语义漂移，`WebFetchTool/preapproved.ts` / `mcpValidation.ts` / `services/mcp/config.ts` 说明外部入口被拆成读取、输出半径、连接定义权三类治理对象，`managedEnv.ts` / `settings.ts` / `validation.ts` / `pluginOnlyPolicy.ts` 则说明真正高风险的是低信任来源改写高风险运行时主链。因此补一个 `18-安全检测技术内核` 是有明确价值的，它把“安全控制面”进一步压成“检测链控制面”。 
- 安全专题做到这里后，目录结构也应该从纯线性主目录升级成“主线 + 附录证据”：新增 `security/appendix/` 承载模块到结论的证据索引、图表和速查材料，能避免主目录继续无限拉长，也更符合后续继续做图谱化、表格化和证据化维护的方向。 
- 在此基础上，再补一页 `appendix/02-安全检测速查表` 也很有价值：它把“风险对象 -> 检测模块 -> 第一硬拦截层 -> classifier 是否能替代 -> 最短结论”压成一张表，能明显降低后续继续扩写时对长文主线的反复跳转成本，也让 `security/18` 的高密度结论更适合被检索和引用。 
- 当 `18-安全检测技术内核` 和 `19-安全不变量` 都成形后，再补一个 `20-边界失真理论` 就很自然了：这时安全专题已经不缺模块级证据，也不缺约束级总结，真正缺的是更高一层的统一解释。把规则失真、指称失真、主权失真、接口失真和解释失真压进同一套理论之后，`dangerousPatterns.ts`、`pathValidation.ts`、`managedEnv.ts`、`mcp/config.ts`、`permissionExplainer.ts` 这些原本分散的模块，就不再只是“不同文件里的不同检测”，而能被理解成同一条边界传递链上的不同修复点。这样 `security/20` 不重复技术细节，而是把整个安全专题推进到真正的本体论层。 
- 有了 `18/19/20` 这三层之后，再补一个 `appendix/03-边界失真速查表` 的价值就很明确了：安全主线已经同时覆盖“检测链”“不变量”“失真理论”，但如果没有一张把三者压回同一视图的表，后续引用时仍然需要在三个章节之间来回跳转。把“失真类型 -> 被破坏的不变量 -> 主要检测模块 -> 第一硬拦截层 -> 用户症状”放进同一张表后，安全专题就第一次拥有了从源码、原则到用户感知的统一索引面。 
- 继续往源码里的状态面下钻后，可以更明确地把 `21-安全状态面源码解剖` 单独写出来：`utils/status.tsx` 与 `components/Settings/Status.tsx` 说明系统已经有总览型摘要，但主要展示结果状态而不是因果图；`remoteManagedSettings/securityCheck.tsx` 与 `ManagedSettingsSecurityDialog.tsx` 说明高风险 managed 变更已经被做成阻断式增量审批；`SandboxConfigTab.tsx` 说明执行包络已有深度可见性；`PluginSettings.tsx` 说明插件错误已经能按来源与控制主体分流；`bridge/bridgeEnabled.ts` 说明 entitlement 失败已经被解释成分步骤证明链。这样一来，安全专题就可以更稳地提出一个源码级结论：系统并不缺安全状态零件，缺的是把主体、主权、包络、外部入口和资格链汇成统一控制台的联结层。 
- 在 `21-安全状态面源码解剖` 之后，再补一页 `appendix/04-安全状态面速查表` 也很有价值：长文已经解释了为什么状态面碎片化是结构问题，但如果没有一张“视图 -> 当前暴露事实 -> 缺失因果 -> 最短跳转”的表，后续引用时还是得重新读整章。把 `Status`、managed dialog、sandbox tab、plugin settings、bridge reason 这些现有视图压进一张表后，安全专题第一次能从“用户现在看到哪个界面”直接反推“系统现在暴露的是哪一类安全事实”。 
- 再往前走一步后，可以更明确地把 `22-安全证明链` 单独写出来：前面章节已经分别解释了检测链、不变量、边界失真和状态面碎片，但真正还没有被显式命名的是“系统凭什么认为当前可安全执行”。把主体链、主权链、授权链、包络链、外部能力链和增量审批链压成同一套证明结构后，`permissions.ts`、`pathValidation.ts`、`managedEnv.ts`、`mcp/config.ts`、`bridgeEnabled.ts`、`securityCheck.tsx` 这些模块就不再只是不同层的防线，而会被重新理解成同一条安全证明系统的不同证明节点。这样安全专题就从“控制面”推进到了“可证明性控制面”。 
- 有了 `22-安全证明链` 之后，再补一个 `appendix/05-安全证明链速查表` 也就顺理成章：长文已经解释了六条证明链是什么，但实际检索时仍然需要快速回答“这条链在证明什么、关键问题是什么、断了以后会怎样”。把六条链压进同一张矩阵后，安全专题第一次能从“哪条证明链失效”直接回到源码入口、失效后果和用户侧症状，这让后续继续做状态图、术语表或控制台设计时都有了更稳定的索引基面。 
- 在此基础上，再补一页 `appendix/06-统一安全控制台总图` 也很自然：`21` 已经解释了状态面为何碎片化，`22` 已经解释了系统为何需要六条证明链，但如果后续要真正讨论“下一代统一安全控制台长什么样”，还需要一张把主体、主权、仲裁、包络、外部能力、增量审批和状态投影全部压到同一页的总图。这样安全专题就第一次同时拥有了长文、矩阵和单页结构图三种表达层级。 
- 当 `21/22` 都成立后，再补一个 `23-统一安全控制台字段设计` 就有了明确价值：前面章节已经说明系统为什么需要统一控制台，也说明了统一控制台最少该有哪些面，但还没有回答“字段到底从哪里来”。`AppStateStore.ts` 已经保留了 bridge、mcp、plugins、toolPermissionContext 等大量状态字段，`coreSchemas.ts` 又把 status/auth_status/mcp status 拆成多条结构化消息，`types/permissions.ts` 还定义了非常丰富的 `PermissionDecisionReason` 枚举。这说明系统并不缺字段，缺的是按安全语义进行字段归一化和派生解释。因此 `23` 的意义，是把安全专题从“控制面图”进一步推进到“控制台数据模型图”。 
- 在 `23-统一安全控制台字段设计` 之后，再补一个 `appendix/07-统一安全控制台字段速查表` 也很有价值：长文已经解释字段分组与缺口，但实际实现阶段更需要一张“字段组 -> 现有来源 -> 缺失派生字段 -> 展示层级”的矩阵。把这些内容压成一页后，后续无论是继续写控制台卡片设计、诊断路径，还是回到源码补字段，都有了直接可操作的实现索引。 
- 再往前走一步后，再补一个 `appendix/08-统一安全控制台卡片速查表` 也就顺理成章：`24` 已经解释了为什么控制台应由七张卡片组成，但实现时仍需要一张更短的卡片矩阵，直接回答“这张卡主导哪条证明链、默认回答什么问题、该给什么动作”。这样安全专题就把统一控制台从长文概念、单页总图、字段模型一路推进到了真正可执行的卡片级信息架构。 
- 再往前推进一步后，可以更明确地把 `24-统一安全控制台卡片设计` 单独写出来：`23` 已经解释了控制台需要哪些字段组，但产品实现并不会直接渲染字段表，而会渲染卡片、摘要块和诊断块。结合 `AppStateStore.ts`、`coreSchemas.ts`、`types/permissions.ts`、`sdkMessageAdapter.ts` 这些源码，可以更稳地得出一个结论：当前最大的瓶颈不是采集不到字段，而是结构化状态在宿主适配层被过早压扁，导致后续控制台必须重新猜测因果。因此 `24` 的核心价值，是把“字段设计”推进成“卡片设计”，并明确断链诊断卡才是真正的统一控制台心脏。 
- 再往前推进一步后，可以更明确地把 `25-统一安全控制台最短诊断路径` 单独写出来：`24` 已经说明控制台应由哪几张卡组成，但一张控制台如果不能把用户带到最短动作，就仍然只是更漂亮的观察面。`controlSchemas.ts` 已经暴露出 `mcp_status`、`reload_plugins`、`mcp_reconnect`、`mcp_toggle`、`get_settings`、`apply_flag_settings` 这些控制动作；`remoteManagedSettings/index.ts` 又说明 managed settings 已经拥有“审批 -> 应用 / 回退”的闭环；`sdkMessageAdapter.ts` 则反过来暴露出一个关键缺口：结构化状态在宿主适配层被过早压成文本或直接丢弃。这样一来，`25` 的核心价值就很明确了：把控制台从“状态面 + 解释面”推进成“状态 -> 断链 -> 动作 -> 回读验证”的行动型控制面。 
- 在 `25-统一安全控制台最短诊断路径` 之后，再补一个 `appendix/09-统一安全控制台最短诊断速查表` 也很自然：长文已经解释了四段闭环，但实现和产品讨论时往往更需要一张“当前状态 -> 断裂证明链 -> 最短动作 -> 默认回读验证”的矩阵。把 bridge、主权、仲裁、包络、外部能力、增量审批这几类典型路径压进一页后，安全专题就第一次拥有了可直接拿来做诊断路由和交互流程设计的最短动作表。 
- 继续往前推进后，可以更明确地把 `26-统一安全控制台交互状态机` 单独写出来：`25` 已经解决了“状态 -> 断链 -> 动作 -> 回读”的最短闭环，但还没有回答这些对象怎样跨页面、跨宿主保持同一条因果链。`controlSchemas.ts` 说明协议层动作和回读源已经够用，`sdkMessageAdapter.ts` 又说明 `status` 会被压成薄文本、`auth_status` 甚至会被直接忽略，`bridgeStatusUtil.ts` 与 `PromptInputFooter.tsx` 则说明 bridge 状态目前主要被做成 footer pill 而不是控制对象。相对地，`remoteManagedSettings/index.ts` 与 `securityCheck.tsx` 已经展示了真正成熟的交互链条：拉取、判定、审批、应用或回退、热刷新。因此 `26` 的核心结论不是“再做一页 UI”，而是下一代统一安全控制台必须先统一交互状态机与宿主适配契约。 
- 在 `26-统一安全控制台交互状态机` 之后，再补一个 `appendix/10-统一安全控制台交互速查表` 就很自然了：长文已经把页面切换、动作触发、刷新回读、验证和升级压成六段状态机，但实现和评审时仍然需要一张更短的交互矩阵。把六段状态、三类典型动作绑定、默认刷新源和宿主保真底线放进一页后，安全专题第一次拥有了可以直接拿来做产品评审、协议对齐和宿主降级检查的最小交互契约表。 
- 继续往前推进后，可以更明确地把 `27-安全对象协议` 单独写出来：`26` 已经指出统一控制台离落地只差交互状态机与宿主适配契约，但还没有回答“宿主之间到底在传什么”。`coreSchemas.ts` 说明协议层本来就有 `status`、`auth_status`、`post_turn_summary`、`tool_progress` 这类结构化对象；`AppStateStore.ts` 也已经保留了 `toolPermissionContext`、bridge 多字段、`mcp.clients`、plugin errors 等对象槽位；真正的问题出在 `sdkMessageAdapter.ts` 与 `bridgeMessaging.ts` 这类边界层，它们会把对象压成文本、缩成子集或直接忽略。因此 `27` 的核心结论是：统一安全控制台下一步最该做的不是新页面，而是先把“哪些安全对象必须跨宿主保真、哪些允许显式降级”写成正式协议。 
- 在 `27-安全对象协议` 之后，再补一个 `appendix/11-安全对象协议速查表` 就很自然了：长文已经把主体、主权、授权、包络、外部能力和交互证明六类对象说清楚，但实现和评审时仍需要一张更短的对象矩阵。把对象族、协议来源、宿主槽位、常见压扁点和最低降级规则压进一页后，安全专题就第一次拥有了可直接用于宿主接入评审和对象保真检查的对象级索引表。 
- 继续往前推进后，可以更明确地把 `28-显式降级理论` 单独写出来：`27` 已经说明安全控制台必须先有对象协议，但还没有回答“窄宿主是否天然不合格”。`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 很关键，因为它们都只正式支持 `can_use_tool` 和 `interrupt` 这一类极窄控制面，但会对其他 subtype 显式返回 error；`bridgeMessaging.ts` 则代表更宽但仍非全集的子集宿主。与此相对，真正危险的不是这些显式子集，而是 `sdkMessageAdapter.ts` 这类把对象静默压扁或忽略的路径。因此 `28` 的核心结论是：多宿主、多宽度本身不是安全问题，隐性子集才是安全问题，下一步应把“显式降级”提升成正式宿主语义。 
- 在 `28-显式降级理论` 之后，再补一个 `appendix/12-宿主降级速查表` 就很自然了：长文已经把 bridge、direct connect、remote session manager 和适配层的差异解释清楚，但实现和评审时仍然需要一张更短的宿主矩阵。把宿主类型、支持子集、显式失败方式和安全风险压进一页后，安全专题就第一次拥有了直接用于宿主分级和降级风险检查的宿主级速查表。 
- 继续往前推进后，可以更明确地把 `29-宿主资格等级` 单独写出来：`28` 已经解释了为什么显式降级重要，但还没有回答“宿主到底有资格承担哪一层责任”。`StructuredIO.ts` 之所以关键，不在于它接了控制消息，而在于它处理 duplicate / orphan / cancel / resolved tool_use_id 这一整套一致性问题；`RemoteIO.ts` 则更进一步，承担了 restored worker state、internal event read/write、delivery / state / metadata 回写；`remoteBridgeCore.ts` 又把 401 恢复窗口中的动作丢弃和状态回写纪律做实。相比之下，`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 更像诚实的控制宿主，而 `sdkMessageAdapter.ts` 最多只是投影型观察宿主。因此 `29` 的核心结论是：统一安全控制台不该再只区分“完整/不完整宿主”，而应正式区分观察宿主、控制宿主与证明宿主。 
- 在 `29-宿主资格等级` 之后，再补一个 `appendix/13-宿主资格速查表` 就很自然了：长文已经把观察、控制、证明三层责任说清楚，但实现评审时仍然需要一张更短的资格矩阵。把三层资格、最低责任、典型实现和“不能声称什么”压进一页后，安全专题就第一次拥有了可以直接拿来做宿主标注和资格审计的责任级速查表。 
- 继续往前推进后，可以更明确地把 `30-安全真相源层级` 单独写出来：`29` 已经说明不同宿主承担的责任不同，但还没有回答“它们到底在依赖哪一层真相”。`sessionState.ts` 已经把 requires_action 真相拆成 typed details 和 `external_metadata.pending_action` 两条路径；`WorkerStateUploader.ts` 又明确告诉我们 `worker_status` 与 `external_metadata` 是一层 mergeable、可重试、可复制的 worker 真相，而不是原始事件本体；`ccrClient.ts` 则负责 init 时清 stale metadata、读回 worker state，并持续 reportState/reportMetadata；`onChangeAppState.ts` 和 `print.ts` 再把复制真相灌回本地交互真相。这使得 `30` 的核心结论很清楚：安全控制面真正要治理的，不只是对象和宿主，还是真相层级本身，任何单一表面都不能冒充全部安全真相。 
- 在 `30-安全真相源层级` 之后，再补一个 `appendix/14-安全真相源速查表` 就很自然了：长文已经把实时真相、语义真相、复制真相、本地真相和 UI 投影五层关系说清楚，但实际实现和评审时仍然需要一张更短的真相矩阵。把五层真相、各自回答的问题、优势、局限和最常见误读压进一页后，安全专题就第一次拥有了可以直接用于真相源辨识和误读校正的层级速查表。 
- 继续往前推进后，可以更明确地把 `31-安全真相仲裁` 单独写出来：`30` 已经说明真相必须分层，但还没有回答“冲突时谁说了算”。`print.ts` 明确要求 restore 与 hydrate 并行等待，避免 SSE catchup 落在 fresh default 上；`coreSchemas.ts` 与 `sdkEventQueue.ts` 又把 `session_state_changed(idle)` 直接命名为 authoritative turn-over signal；`WorkerStateUploader.ts` 与 `ccrClient.ts` 则说明复制层接受延迟一致，但不接受 stale crash residue；`onChangeAppState.ts` 进一步表明本地状态必须经统一 choke point 才能升级成外部真相。这使得 `31` 的核心结论很清楚：多层真相如果没有优先级，就只是多份意见，真正成熟的安全控制面必须明确恢复顺序、语义事件、复制清理、本地镜像和 UI 跟随之间的仲裁规则。 
- 在 `31-安全真相仲裁` 之后，再补一个 `appendix/15-安全真相仲裁速查表` 就很自然了：长文已经把恢复优先级、语义优先级、复制清理、本地镜像和 UI 无仲裁权说清楚，但实现和评审时仍需要一张更短的冲突矩阵。把冲突场景、胜出真相、败方不能赢的原因和禁止误读压进一页后，安全专题就第一次拥有了可直接用于仲裁检查和冲突排障的真相优先级速查表。 
- 继续往前推进后，可以更明确地把 `32-安全裂脑防御` 单独写出来：`31` 已经回答了真相冲突时谁优先，但还没有解释为什么源码里会反复出现单一 choke point、镜像、去重、清理和恢复串行化。`onChangeAppState.ts` 与 `sessionState.ts` 已经把 mode 和语义状态更新收口成单一出口；`StructuredIO.ts` 直接把 duplicate / orphan response 视为一等问题；`ccrClient.ts` 会在 init 时清 stale `pending_action` / `task_summary`；`remoteBridgeCore.ts` 又通过 `authRecoveryInFlight`、flushGate 和 stale transport 守卫避免双重 /bridge fetch、stale epoch 和 silent message loss。这使得 `32` 的核心结论很清楚：Claude Code 的深层安全性不只是边界收口，也是一套反裂脑工程，它真正持续在防的是同一安全事实在不同层或不同时刻长成两份互相打架的真相。 
- 在 `32-安全裂脑防御` 之后，再补一个 `appendix/16-安全裂脑速查表` 就很自然了：长文已经把 mode 分叉、pending_action 分叉、duplicate response、crash residue 和并发恢复这些裂脑场景讲清楚，但实现和评审时仍然需要一张更短的裂脑矩阵。把分叉场景、收口闸门、镜像链、守卫策略和失效后果压进一页后，安全专题就第一次拥有了可直接用于反裂脑代码审计和改动评审的高风险场景表。 
- 继续往前推进后，可以更明确地把 `33-安全单写者原则` 单独写出来：`32` 已经解释了系统为什么持续防裂脑，但还没有把更底层的设计公理点破。`onChangeAppState.ts` 与 `sessionState.ts` 已经把关键语义更新收口成单一出口；`StructuredIO.ts` 直接声明 outbound drain loop 是 only writer；`WorkerStateUploader.ts` 又把 worker 真相写入约束成 1 in-flight + 1 pending、top-level last value wins；`AppStateStore.ts` 甚至在能力状态上直接写出 single source of truth。这使得 `33` 的核心结论很清楚：Claude Code 很多高质量安全实现，真正共同依赖的不是“再加同步”，而是先决定谁有资格成为关键安全事实的唯一作者，其余层只能镜像、恢复或投影。 
- 在 `33-安全单写者原则` 之后，再补一个 `appendix/17-安全单写者速查表` 就很自然了：长文已经把 mode 外化、会话语义、outbound 顺序、worker 复制真相、资格布尔量和恢复路径这些“唯一作者”讲清楚，但实现和评审时仍然需要一张更短的作者权矩阵。把关键事实、正式作者、合法镜像层与越权后果压进一页后，安全专题就第一次拥有了可直接用于检查“某层是不是在偷偷变成第二作者”的改动审查表。 
- 继续往前推进后，可以更明确地把 `34-安全提交语义` 单独写出来：`33` 已经回答了“谁有资格写”，但还没有回答“什么时候算真的写成”。`sessionState.ts` 已经把本地语义、metadata 镜像和 SDK 事件拆成不同层；`WorkerStateUploader.ts` 与 `ccrClient.ts` 又把 enqueue、PUT 成功、恢复读取和 init 注册分开；`print.ts` 进一步把 result 可见性、`heldBackResult`、`flushInternalEvents()` 与 `idle` turn-over 顺序明确排好；`sessionStorage.ts` 则表明 resume 依赖 internal events 账本而不是普通可见事件。这使得 `34` 的核心结论很清楚：Claude Code 的深层安全性不只治理写权限，还治理提交边界，它不允许“本地已改”“远端已见”“持久化已落”和“恢复可重建”被误写成同一个词。 
- 在 `34-安全提交语义` 之后，再补一个 `appendix/18-安全提交边界速查表` 也很自然：长文已经把语义、复制、可见、持久和恢复五层提交讲清楚，但实现和评审时仍需要一张更短的边界矩阵。把“哪一层算提交、哪一层还不算、源码入口和最危险误读”压进一页后，安全专题就第一次拥有了可直接用于提交边界审查的五层检查表。 
- 继续往前推进后，可以更明确地把 `35-安全多账本原则` 单独写出来：`34` 已经回答了“哪一层算提交”，但还没有回答“为什么这些层不能共用同一本账”。`sessionState.ts` 先维护语义账本，再把状态镜像给 metadata 与 SDK event；`ccrClient.ts` 明确区分 `reportState/reportMetadata`、`writeEvent(...)` 与 `writeInternalEvent(...)`，分别服务复制账、可见账与恢复账；`print.ts` 在 going idle 前先 flush internal events；`sessionStorage.ts` 的 `hydrateFromCCRv2InternalEvents(...)` 又说明 resume 读取的是恢复账而不是普通前端事件。这使得 `35` 的核心结论很清楚：Claude Code 的深层安全性不只是多层提交边界，更是多账本结构，每一本账都服务不同读者、不同边界和不同误判成本。 
- 在 `35-安全多账本原则` 之后，再补一个 `appendix/19-安全多账本速查表` 就很自然了：长文已经把语义账、复制账、可见账与恢复账的职责差别讲清楚，但实现和评审时仍然需要一张更短的账本矩阵。把每本账的主要读者、主要写入口、提交边界与误判成本压进一页后，安全专题就第一次拥有了可直接用于回答“这个读者到底该信哪一本账”的速查表。 
- 继续往前推进后，可以更明确地把 `36-安全账本投影原则` 单独写出来：`35` 已经回答了“为什么有多本账”，但还没有回答“为什么不同宿主不可能都看到全部账”。`coreSchemas.ts` 与 `controlSchemas.ts` 先给出宽协议全集；`StructuredIO.ts` 则明确默认宿主没有恢复账与 internal-event flush；`RemoteIO.ts` 通过 `CCRClient`、internal event reader/writer、`reportState/reportMetadata` 和 `restoredWorkerState` 拿到更厚的投影；`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 又只正式支持 `can_use_tool` 这一类窄 control 子集；`remoteBridgeCore.ts` 虽然更宽，但在 recovery 窗口仍会主动 drop 一部分控制与结果。这使得 `36` 的核心结论很清楚：宿主不是完整安全控制台，而是多账本系统上的条件化投影，协议全集绝不等于宿主全集。 
- 在 `36-安全账本投影原则` 之后，再补一个 `appendix/20-宿主账本投影速查表` 就很自然了：长文已经把默认 `StructuredIO`、`RemoteIO + CCR v2`、`DirectConnect`、`RemoteSessionManager` 与 `remoteBridgeCore` 这些宿主的账本子集差别讲清楚，但实现和评审时仍然需要一张更短的宿主矩阵。把“每类宿主能看到哪些账、能写哪些账、明显缺哪几本账、最危险的误读是什么”压进一页后，安全专题就第一次拥有了可直接用于宿主接入评审和解释责任分配的速查表。 
- 在 `37-安全解释权限` 之后，再补一个 `appendix/21-安全解释权限速查表` 就很自然了：长文已经把不同宿主的解释边界讲清楚，但实现和评审时仍然需要一张更短的权限矩阵。把“每类宿主实际看到了什么、明显没看到什么、可以诚实说什么、绝不能替系统说什么”压进一页后，安全专题就第一次拥有了可直接用于解释责任分配和宿主 UI 文案审查的速查表。 

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
- 继续往前推进后，可以更明确地把 `37-安全解释权限` 单独写出来：`36` 已经回答了“宿主只能看到哪些账本子集”，但还没有回答“它凭什么替完整控制面下结论”。`controlSchemas.ts` 与 `coreSchemas.ts` 说明协议全集本身不能直接推出解释权全集；`StructuredIO.ts` 说明默认宿主没有恢复账与 internal-event 面；`RemoteIO.ts` 说明更厚宿主的解释权也依赖初始化与 transport 条件；`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 的窄 control 子集说明窄宿主最合理的是局部解释；`remoteBridgeCore.ts` 在 recovery 窗口主动 drop 一部分事实，则进一步说明解释权限还会随时序窗口动态收窄。这使得 `37` 的核心结论很清楚：解释权不是默认附赠能力，而是从当前可见账本边界反推出来的受限权限。 
- 继续往前推进后，可以更明确地把 `38-安全未知语义` 单独写出来：`37` 已经回答了“谁有解释权”，但还没有回答“系统在没有足够依据时该怎么办”。`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 对 unsupported subtype 显式回 error，说明“不支持”必须被显式表达而不是静默等待；`StructuredIO.ts` 用 `null` 与 no-op 表达“当前没有恢复账/持久面”；`RemoteIO.ts` 在条件不成立时直接 fail loudly，而不是偷偷退成伪完整模式；`remoteBridgeCore.ts` 在 recovery 窗口直接 drop control 和 result，则说明“当前不可判定”必须被显式保留；`sdkEventQueue.ts` 只在 authoritative turn-over signal 成立后才授予完整解释权，则进一步说明成熟系统宁可晚一点说，也不能早一点猜。这使得 `38` 的核心结论很清楚：不知道不是失败残渣，而是安全控制面必须拥有的一等语义。 
- 在 `38-安全未知语义` 之后，再补一个 `appendix/22-安全未知语义速查表` 就很自然了：长文已经把 unsupported、无账本、条件未成立和恢复窗口不可判定这些“未知”讲清楚，但实现和评审时仍然需要一张更短的未知矩阵。把“系统当前缺什么、正确做法是什么、错误做法是什么、硬猜后会坏什么”压进一页后，安全专题就第一次拥有了可直接用于审查伪解释和伪成功路径的速查表。 
- 继续往前推进后，可以更明确地把 `39-安全声明等级` 单独写出来：`38` 已经回答了“什么时候必须说不知道”，但还没有回答“在知道时为什么也不能只说 yes/no”。`SDKRateLimitInfoSchema` 把 allowed 拆成 `allowed / allowed_warning / rejected`；MCP 连接状态被拆成 `connected / failed / needs-auth / pending / disabled`；`post_turn_summary` 继续把运行结论细分成 `blocked / waiting / completed / review_ready / failed`，并附带 `status_detail` 与 `is_noteworthy`；`SDKAPIRetryMessageSchema` 又把失败声明细化成 typed error、HTTP status 与 retry budget；`CCRInitFailReason` 和 `OrgValidationResult` 则说明初始化和组织校验都更偏向“typed reason + descriptive message”而不是裸布尔。这样一来，源码已经很清楚地说明：成熟安全控制面不是二元裁决器，而是一台会按强度、理由和条件分级说话的声明机器。 
- 在 `39-安全声明等级` 之后，再补一个 `appendix/23-安全声明等级速查表` 就很自然了：长文已经把允许类、连接类、运行类、重试类和初始化/校验类声明的分级逻辑讲清楚，但实现和评审时仍然需要一张更短的声明矩阵。把“声明族、典型等级、典型字段、真正表达什么、最危险的压扁误读”压进一页后，安全专题就第一次拥有了可直接用于下游接口评审和语义压缩审查的速查表。 
- 继续往前推进后，可以更明确地把 `40-安全动作语法` 单独写出来：`39` 已经回答了“结论为什么要分级”，但还没有回答“结论给出后，正确下一步动作为何也必须被编码进协议”。`PermissionUpdateSchema` 与 `SDKControlPermissionRequestSchema` 说明权限请求天然带着建议修法而不是只有阻断；`useDirectConnect.ts`、`useRemoteSession.ts` 与 `useSSHSession.ts` 说明这些 suggestions 会被宿主直接消费；`SDKPostTurnSummaryMessageSchema` 继续把 `recent_action`、`needs_action` 与 `artifact_urls` 放进同一条 turn 摘要；`SDKControlRewindFilesResponseSchema` 与 `SDKAPIRetryMessageSchema` 又把修复可行性和等待/重试策略编码成 typed 分支；`MCPServerConnection`、`handleRemoteAuthFailure()`、`channelNotification.ts` 与 `useManageMCPConnections.ts` 则说明 `needs-auth / pending / disabled / failed` 的真正价值，在于把恢复路径拆开；`OrgValidationResult` 和 `CCRInitFailReason` 最后进一步证明 typed reason 的意义不是分类本身，而是防止错误补救。这样一来，源码已经很清楚地说明：成熟安全控制面不是静态声明面板，而是一台会把状态、理由、等级与下一步动作一起编码出来的控制语法机。 
- 在 `40-安全动作语法` 之后，再补一个 `appendix/24-安全动作语法速查表` 就很自然了：长文已经解释了为什么成熟控制面必须把声明和动作绑在一起，但实现、评审与宿主接入时更需要一张更短的动作矩阵。把 `can_use_tool`、`requires_action`、`post_turn_summary`、`api_retry`、MCP 五态、`rewind_files`、`OrgValidationResult` 与 `CCRInitFailReason` 压成“声明族 / 典型状态 / 正确下一步 / 最危险错误动作 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于检查状态压缩是否会误导动作路径的速查表。 
- 继续往前推进后，可以更明确地把 `41-安全动作归属` 单独写出来：`40` 已经回答了“下一步该做什么”，但还没有回答“谁来做、写到哪、持续多久”。`PermissionUpdateDestinationSchema` 先把动作目的地拆成 `userSettings / projectSettings / localSettings / session / cliArg`；`supportsPersistence()` 又明确说明只有三类 settings 目标配拥有持久化资格，`session` 与 `cliArg` 不能被偷偷升格成长期授权；`PermissionPromptToolResultSchema` 与 `PermissionDecisionClassificationSchema` 则继续把宿主压回“忠实报告用户实际动作”的见证层，防止宿主把一次性允许偷偷变成永久允许；`useManageMCPConnections.ts` 又把 `auth`、`policy`、`disabled` 三类 gate 显式映射给用户、管理员或无人可立即修复的不同主体；`api_retry` 与 `rewind dry_run` 最后进一步说明系统自动动作和人工确认动作不能混写。这样一来，源码已经很清楚地说明：成熟安全控制面不只是在给动作，还在给动作的责任归属、写入层级与时间边界。 
- 在 `41-安全动作归属` 之后，再补一个 `appendix/25-安全动作归属速查表` 就很自然了：长文已经解释了为什么动作需要继续绑定主体、作用域和持久层，但实现、评审与宿主接入时更需要一张更短的归属矩阵。把权限更新 destination、用户临时/永久决定、`requires_action`、`api_retry`、MCP 五态、rewind 预演/执行、组织校验失败等压成“信号 / 执行主体 / 写入范围 / 持久性 / 最危险越权者 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“对的动作是否会被错误主体代做”的速查表。 
- 继续往前推进后，可以更明确地把 `42-安全动作完成权` 单独写出来：`41` 已经回答了“谁来做、写到哪、持续多久”，但还没有回答“谁有资格宣布已经做完”。`SDKSessionStateChangedMessageSchema` 与 `sdkEventQueue.ts` 先把 `session_state_changed(idle)` 写成 authoritative turn-over signal；`print.ts` 又明确要求 going idle 前先 `flushInternalEvents()`，说明局部收尾不能抢在事件持久化前宣布完成；`SDKFilesPersistedEventSchema` 与 `print.ts` 继续把文件持久化拆成独立事件，拒绝让普通 result 冒充落盘确认；`ccrClient.flush()` 的注释又进一步强调 delivery confirmation 与 server state 不是同一回事；`remoteBridgeCore.ts` 最后在 401 recovery 窗口主动 drop control/result，说明不可靠窗口里的局部执行痕迹不配拥有完成解释权。这样一来，源码已经很清楚地说明：成熟安全控制面不只是在给动作和归属，还在严格限制谁能对“完成”这件事签字。 
- 在 `42-安全动作完成权` 之后，再补一个 `appendix/26-安全动作完成权速查表` 就很自然了：长文已经解释了为什么执行信号不能直接等于完成信号，但实现、评审与宿主接入时更需要一张更短的完成矩阵。把 `session_state_changed(idle)`、`flushInternalEvents()`、`files_persisted`、queue drain、401 recovery、rewind dry-run 与重启后 stale metadata 清理压成“动作 / 执行信号 / 完成签字信号 / 仍然不够的信号 / 最危险提前宣布 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查伪完成与提前宣布问题的速查表。 
- 继续往前推进后，可以更明确地把 `43-安全完成投影` 单独写出来：`42` 已经回答了“谁能对完成签字”，但还没有回答“不同宿主到底看到了多少签字链”。`session_state_changed(idle)` 与 `sdkEventQueue.ts` 给 SDK 流消费者暴露了一条强完成事件；`RemoteIO` 则继续接上 `restoredWorkerState`、internal-event read/write、`reportState`、`reportMetadata` 与 `flushInternalEvents()`，形成更厚的完成投影；默认 `StructuredIO` 反过来明确把恢复账与 internal-event flush 设成 `null` / no-op / zero，说明这类宿主不配自称拥有同等完成视角；`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 又把 control surface 收窄到几乎只剩 `can_use_tool`，进一步压缩了它们对整条完成链的资格；`remoteBridgeCore.ts` 最后说明 even 更厚的 bridge 也会在 recovery 窗口主动 drop result/control，从而临时收窄完成投影。这样一来，源码已经很清楚地说明：成熟安全控制面不只定义完成签字权，还定义不同宿主最多能看到多少完成签字链。 
- 在 `43-安全完成投影` 之后，再补一个 `appendix/27-安全完成投影速查表` 就很自然了：长文已经解释了不同宿主只能看到完成签字链的子集，但实现、评审与宿主接入时更需要一张更短的宿主矩阵。把 SDK 流消费者、RemoteIO/CCR、默认 StructuredIO、bridge 正常 / recovery 窗口、DirectConnectManager、RemoteSessionManager 压成“宿主 / 可见完成信号 / 缺失账本 / 最安全说法上限 / 最危险误读 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“这个宿主是不是把局部完成说得过满”的速查表。 
- 继续往前推进后，可以更明确地把 `44-安全完成差异显化` 单独写出来：`43` 已经回答了“不同宿主看到的是不同子集”，但还没有回答“这种差异是否应该被用户显式看到”。`buildMcpProperties()` 会把异质 MCP 状态压成计数摘要；`sdkMessageAdapter.ts` 会把结构化 status 压成 generic informational text；`bridgeStatusUtil.ts` 又把 bridge 状态压成 `active / reconnecting / failed / connecting` 四个总体标签；可 `replBridgeTransport.ts` 同时明确写出 connected 只是 write-readiness，不是 read-readiness。这说明底层早已承认宿主差异，但展示层仍会在多个地方重新压平。这样一来，源码已经很清楚地说明：下一代统一安全控制台不该只内部保留宿主差异，而必须把“当前宿主缺哪条完成链、因此这条状态最多能说到哪一步”显式做成用户可见语义。 
- 在 `44-安全完成差异显化` 之后，再补一个 `appendix/28-安全完成差异显化速查表` 就很自然了：长文已经解释了为什么界面必须显式展示宿主差异，但实现、评审与产品设计时更需要一张更短的界面矩阵。把 `/status` 的 MCP 摘要、remote `sdkMessageAdapter`、bridge 总体标签、repl bridge transport label、StructuredIO / RemoteIO / DirectConnect / RemoteSessionManager 这些典型压缩点压成“当前界面 / 当前压缩写法 / 被隐藏的盲区 / 最少必须显化的字段 / 最不该继续复用的文案 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“展示层是否又把底层宿主差异抹平”的速查表。 
- 继续往前推进后，可以更明确地把 `45-安全完成差异字段` 单独写出来：`44` 已经回答了“这些差异必须显式展示”，但还没有回答“到底该用哪些字段展示”。`AppStateStore.ts` 已经明确定义了 `remoteConnectionStatus`、`replBridgeEnabled / Connected / SessionActive / Reconnecting / Error`、`mcp.clients` 等状态槽位；`replBridgeTransport.ts` 又把 write-readiness 与 read-readiness 显式分开；`StructuredIO.ts` 和 `RemoteIO.ts` 则进一步把恢复账、internal-event flush 与 pending depth 的有无做成可观察差异；`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 最后再把 `supported_control_subtypes` 的天然收窄暴露出来。这样一来，源码已经很清楚地说明：统一安全控制台真正缺的不是更多状态词，而是一组能稳定表达 `host_kind / projection_grade / missing_ledgers / readiness_split / supported_control_subtypes / completion_claim_ceiling` 的正式字段。 
- 在 `45-安全完成差异字段` 之后，再补一个 `appendix/29-安全完成差异字段速查表` 就很自然了：长文已经解释了统一安全控制台最少该补哪些字段，但实现、评审与产品设计时更需要一张更短的字段矩阵。把 `host_kind`、`projection_grade`、`missing_ledgers[]`、`write_ready/read_ready`、`label_basis`、`supported_control_subtypes[]`、`restored_worker_state_supported`、`internal_event_flush_supported`、`recovery_window_open` 与 `completion_claim_ceiling` 压成“字段 / 主要来源 / 推荐展示层级 / 缺失后最可能的误导 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“宿主盲区有没有被字段化”的速查表。 
- 继续往前推进后，可以更明确地把 `46-安全完成差异卡片` 单独写出来：`45` 已经回答了“该有哪些字段”，但还没有回答“字段该挂到哪张卡、按什么优先级显示”。`Status.tsx` 与 `status.tsx` 说明当前 `/status` 面偏向摘要 property 列表，天然容易把宿主盲区埋深；`BridgeDialog.tsx` 说明现有桥接对话框会显示 status label、error、environment/session id 和 footer，但不会优先表达 completion ceiling；`IdeStatusIndicator.tsx` 与 `useIdeConnectionStatus.ts` 又说明 IDE 状态被压成 connected/pending/disconnected 三态；`useMcpConnectivityStatus.tsx` 则继续把 MCP 问题压成 failed / needs-auth 计数通知。这说明统一安全控制台下一步最关键的不是再补字段，而是按解释上限优先级把这些字段挂回主体与资格卡、外部能力卡、警告层和动作层，避免再次在卡片层被埋掉。 
- 在 `46-安全完成差异卡片` 之后，再补一个 `appendix/30-安全完成差异卡片速查表` 就很自然了：长文已经解释了这些字段该挂到哪张卡、按什么优先级显示，但实现、评审与设计讨论时更需要一张更短的卡片矩阵。把 `completion_claim_ceiling`、recovery suspension 字段、`host_kind`、`projection_grade`、`missing_ledgers[]`、`write_ready/read_ready`、`supported_control_subtypes[]` 等压成“字段组 / 推荐卡片挂载点 / 展示优先级 / 默认动作 / 最危险埋深方式 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“这些宿主盲区字段有没有被挂到正确位置”的速查表。 
- 继续往前推进后，可以更明确地把 `47-安全完成差异升级规则` 单独写出来：`46` 已经回答了“字段该挂到哪张卡”，但还没有回答“哪些问题该立即抢占界面、哪些只需中层提示”。`notifications.tsx` 已经把 `immediate / high / medium / low` 做成正式注意力仲裁语义；`useReplBridge.tsx` 对 `Remote Control failed` 直接给 `immediate`，说明实时推翻当前完成结论的问题必须马上抢断；`useManagePlugins.ts` 与 `useManageMCPConnections.ts` 则把 flagged plugins 与 channels blocked 放进 `high`，说明会改写下一步动作路径的问题需要强提醒；`useIDEStatusIndicator.tsx` 与 `useMcpConnectivityStatus.tsx` 又把 IDE disconnected、MCP failed / needs-auth 放进 `medium`，说明显著退化但不必抢断的宿主差异适合中层提示；而 plugin reload pending 与 statusline trust blocked 则被放在 `low`。这样一来，源码已经很清楚地说明：宿主盲区显化不只需要字段和卡片，还需要一套基于误导风险的升级规则。 
- 在 `47-安全完成差异升级规则` 之后，再补一个 `appendix/31-安全完成差异升级规则速查表` 就很自然了：长文已经解释了哪些宿主盲区必须抢占界面、哪些只需中层提示，但实现、评审与设计讨论时更需要一张更短的升级矩阵。把 `completion_claim_ceiling`、recovery suspension、`host_kind`、`projection_grade`、`missing_ledgers[]`、`write_ready/read_ready`、`supported_control_subtypes[]`、MCP failed / needs-auth、IDE disconnected、plugin reload pending 等压成“字段组 / 默认优先级 / 升级条件 / 绝不应降到哪一层 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“宿主盲区有没有被正确升级”的速查表。 
- 继续往前推进后，可以更明确地把 `48-安全完成差异交互路由` 单独写出来：`47` 已经回答了“哪些宿主盲区该抢占界面”，但还没有回答“它们一旦变化时，卡片、通知、动作和清除条件是否会一起改口”。`notifications.tsx` 已经把 `immediate/high/medium/low` 和当前通知抢占做成正式注意力仲裁；`PromptInput/Notifications.tsx` 又说明用户真正只会看到一个 `notifications.current`；相对地，`Status.tsx` 与 `utils/status.tsx` 仍主要是属性摘要层，`BridgeDialog.tsx` 会显示 status label、error、environment/session id 和 footer，却不会把 completion ceiling、missing ledgers 与动作收口一起联动；`useIdeConnectionStatus.ts` 和 `IdeStatusIndicator.tsx` 也仍把宿主资格压成低维状态。这说明源码已经拥有“注意力路由”“状态摘要”“宿主差异承认”三种成熟局部能力，但还缺最后一层统一状态机：当盲区变宽时，必须原子地降低主卡结论、升级通知、收紧动作并延后清除旧结论。这样一来，安全专题就能继续从“显示什么”推进到“同一安全事实如何在同一时刻只保留一种可行动解释”。 
- 在 `48-安全完成差异交互路由` 之后，再补一个 `appendix/32-安全完成差异交互路由速查表` 就很自然了：长文已经解释了为什么宿主盲区必须被路由成卡片改口、通知抢位、动作收口和清除守纪的同一时刻联动，但实现、评审与协议对齐时更需要一张更短的联动矩阵。把 recovery window、bridge hard fail、`completion_claim_ceiling` 下调、`missing_ledgers[]` 新增、`write_ready/read_ready` 分裂、subtype 缺口、channels blocked、flagged plugins、IDE disconnected、MCP failed / needs-auth、plugin reload pending 等压成“触发器 / 典型字段 / 卡片更新 / 通知优先级 / 动作收口 / 清除条件 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“这些宿主盲区有没有被成套路由，而不是只改一条提示文案”的速查表。 
- 继续往前推进后，可以更明确地把 `49-安全完成差异清除纪律` 单独写出来：`48` 已经回答了宿主盲区变化时卡片、通知、动作和清除条件必须一起联动，但还没有回答“什么证据出现之后，系统才有资格真的删除旧告警、撤销旧结论、恢复旧动作”。`notifications.tsx` 已经说明删除与失效是显式动作，不是自然蒸发；`ccrClient.ts` 会在 worker init 时主动清掉 prior crash 留下的 stale `pending_action/task_summary`，并把 `state_restored` 的记录放到成功初始化之后；`print.ts` 又明确要求 restore 与 hydrate 并行等待，避免 SSE catchup 落在 fresh default 上；`remoteBridgeCore.ts` 则在 401 recovery 窗口直接 drop control/result，而不是抢先宣布恢复；`sdkEventQueue.ts` 最后再把 `session_state_changed(idle)` 命名为 authoritative turn-over。这样一来，源码已经很清楚地说明：对宿主盲区而言，降级可以基于风险迹象，恢复必须基于 fresh 回读与正式 signer，下一代统一安全控制台必须把“不要过早忘记旧风险”提升成独立纪律。 
- 在 `49-安全完成差异清除纪律` 之后，再补一个 `appendix/33-安全完成差异清除纪律速查表` 就很自然了：长文已经解释了为什么宿主盲区恢复时不能先删旧告警，而必须等待足够强的 fresh 证据，但实现、评审与协议对齐时更需要一张更短的清除矩阵。把 recovery window、bridge fail、`completion_claim_ceiling` 下调、`missing_ledgers[]`、stale metadata、authoritative idle、`files_persisted`、IDE disconnected、MCP failed / needs-auth、channels blocked、flagged plugins 等压成“旧结论 / 禁止依赖的弱信号 / 允许清除的 fresh 证据 / 允许先恢复什么 / 绝不能先恢复什么 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“控制面是不是在抢先恢复、抢先遗忘旧风险”的速查表。 
- 继续往前推进后，可以更明确地把 `50-安全恢复签字层级` 单独写出来：`49` 已经回答了“恢复必须等待 fresh 证据”，但还没有回答“不同强度的 fresh 证据到底分别有资格恢复什么”。`replBridgeTransport.ts` 已经明确 connected 只是 write-readiness，不是 read-readiness；`BridgeDialog.tsx` 仍主要消费 status label 和 error，这类信号最多只能当活性 signer；`ccrClient.ts` 与 `remoteIO.ts` 则把 `state_restored / restoredWorkerState / reportState / reportMetadata` 做成更强一层的恢复与状态 signer；`sdkEventQueue.ts` 又把 `session_state_changed(idle)` 命名为 authoritative turn-over；`print.ts` 最后再把 `files_persisted` 单独分出，说明 effect signer 也不能并入普通 result。这样一来，源码已经很清楚地说明：成熟安全控制面不该只有“恢复 / 未恢复”两档，而应正式区分活性 signer、restore signer、state signer、effect signer 与 explanation signer，并让不同层级对象只接受与自己同阶的恢复签字。 
- 在 `50-安全恢复签字层级` 之后，再补一个 `appendix/34-安全恢复签字层级速查表` 就很自然了：长文已经解释了为什么恢复证据必须分层签字，但实现、评审与宿主对齐时更需要一张更短的 signer 矩阵。把活性 signer、restore signer、state signer、effect signer、explanation signer 压成“signer 层级 / 典型来源 / 可恢复对象 / 不可恢复对象 / 最危险误读 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“某个绿色信号有没有越级替更高层对象签字”的速查表。 
- 继续往前推进后，可以更明确地把 `51-安全恢复中间态` 单独写出来：`50` 已经回答了恢复 signer 的层级，但还没有回答“系统恢复到一半时到底该如何命名自己”。`replBridgeTransport.ts` 已经明确 `outboundOnly` 用于 mirror-mode attachments，只启用写路径而不接收入站 prompt/control；同文件又明确 `isConnectedStatus()` 只是 write-readiness，不是 read-readiness；`ccrClient.ts` 与 `print.ts` 则共同说明 restore 和 hydrate 解决的是“不是 fresh default”，并不自动等于 fresh；`DirectConnectManager.ts` 与 `RemoteSessionManager.ts` 最后再说明某些宿主即使在线也只支持 `can_use_tool` 这种窄 control 面。与此同时，`bridgeStatusUtil.ts` 却会把 `sessionActive || connected` 压成同一个 `Remote Control active`。这样一来，源码已经很清楚地说明：部分恢复状态不是例外，而是正式状态族，下一代统一安全控制台必须显式区分 `mirror-only`、`write-ready/read-blind`、`restored-but-not-fresh`、`control-narrow`、`result-ready/effects-pending` 等中间态，避免再次把半恢复读成全恢复。 
- 在 `51-安全恢复中间态` 之后，再补一个 `appendix/35-安全恢复中间态速查表` 就很自然了：长文已经解释了为什么部分恢复必须被正式命名，但实现、评审与宿主接入对齐时更需要一张更短的中间态矩阵。把 `mirror-only`、`write-ready/read-blind`、`restored-but-not-fresh`、`control-narrow`、`result-ready/effects-pending`、`state-ready/explanation-pending` 压成“中间态 / 典型来源 / 当前可见账本 / 当前可用动作 / 禁止文案 / 默认跳转 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“这个半恢复状态有没有被正确命名、有没有被压平成同一句绿色文案”的速查表。 
- 继续往前推进后，可以更明确地把 `52-安全恢复文案禁令` 单独写出来：`51` 已经回答了半恢复状态必须被正式命名，但还没有回答“即使系统知道自己只恢复到一半，它到底被允许说哪些词”。`bridgeStatusUtil.ts` 当前会把 `sessionActive || connected` 压成 `Remote Control active`；`status.tsx` 会把 IDE 与 MCP 压成 `Connected to ...`、`Installed ...`、`Not connected`、`connected / need auth / pending / failed` 这类摘要词；而通知层在 `useIDEStatusIndicator.tsx` 与 `useMcpConnectivityStatus.tsx` 里反而更擅长说缺口语言。这样一来，源码已经很清楚地说明：下一代统一安全控制台不只要有中间态词汇表，还必须给语言本身建立禁令，禁止在半恢复状态下继续使用过满绿色词，并要求所有恢复态文案遵守“已恢复部分 + 当前缺口 + 默认下一步”的受约束句式。 
- 在 `52-安全恢复文案禁令` 之后，再补一个 `appendix/36-安全恢复文案禁令速查表` 就很自然了：长文已经解释了为什么半恢复状态下必须禁止过满绿色词，但实现、评审与文案校验时更需要一张更短的规则矩阵。把 L0 活性 signer、`mirror-only`、`write-ready/read-blind`、L1 restore signer、`restored-but-not-fresh`、L2 state signer、`control-narrow`、L3 effect signer、`result-ready/effects-pending`、L4 explanation signer 压成“对象层级 / 当前证据强度 / 禁止词 / 允许词 / 默认句式 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“某句绿色文案有没有超出当前证据强度”的速查表。 
- 继续往前推进后，可以更明确地把 `53-安全恢复跳转纪律` 单独写出来：`52` 已经回答了恢复文案必须受约束，但还没有回答“诚实文案接下来应把用户带去哪里”。`useManagePlugins.ts` 已经把 flagged plugins 指向 `/plugins`、把 activation pending 指向 `/reload-plugins`；`useMcpConnectivityStatus.tsx` 已把 failed / needs-auth 统一指向 `/mcp`；`ChannelsNotice.tsx` 与 `PromptInput/Notifications.tsx` 又把 auth bottleneck 指向 `/login`；`RemoteCallout.tsx` 与 `bridgeMain.ts` 最后说明 Remote Control 域应回到 `/remote-control`；而 IDE 插件断连与安装失败则更倾向先去 `/status`。这样一来，源码已经很清楚地说明：Claude Code 现有系统其实已经有一套分散的默认修复路径语义，下一代统一安全控制台应该把它正式提升为恢复跳转纪律，让每种半恢复状态都绑定一个 dominant repair path，而不是把路由责任继续外包给用户。 
- 在 `53-安全恢复跳转纪律` 之后，再补一个 `appendix/37-安全恢复跳转纪律速查表` 就很自然了：长文已经解释了为什么每种半恢复状态都必须绑定唯一 dominant repair path，但实现、评审与交互校验时更需要一张更短的路由矩阵。把 flagged plugins、plugin activation pending、MCP failed / needs-auth、channels auth bottleneck、global not logged in、IDE plugin not connected、IDE install failed、bridge attach / enable / disconnect、`mirror-only`、`write-ready/read-blind`、`restored-but-not-fresh` 等压成“状态 / 中间态 / 当前缺口归属 / 默认跳转 / 次级跳转 / 禁止歧义 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“某个半恢复状态有没有唯一默认修复路径”的速查表。 
- 继续往前推进后，可以更明确地把 `54-安全恢复验证闭环` 单独写出来：`53` 已经回答了半恢复状态必须绑定唯一默认修复路径，但还没有回答“用户执行了这条路径之后，控制面凭什么宣布问题真的解决了”。`refreshActivePlugins()` 已明确区分旧 `needsRefresh` 路径的 stale data 与新的全量重建路径，说明 `/reload-plugins` 的 verifier 是 cache 清空、状态重载和 `pluginReconnectKey` bump；`reconnectMcpServerImpl()` 又把 MCP reconnect 分成 clear cache、`connectToServer()`、以及 tools/commands/resources 重新可见三段；`ChannelsNotice.tsx` 和 `teleport.tsx` 则进一步表明 `/login` 常常还只是起点，后面仍要 restart 或 `/status` 重新核对；`bridgeMain.ts` 最后说明 `bridge/reconnect` 成功与否、pointer 是否保留、是否需要重试都不能由发起动作本身替代。这样一来，源码已经很清楚地说明：repair action 解决的是修复意图，recovery closure 解决的是真相闭环，下一代统一安全控制台必须要求每条 repair path 都声明自己的 verifier readback 和最终 signer，而不是把“用户已经执行过命令”误当成“系统已经恢复”。 
- 在 `54-安全恢复验证闭环` 之后，再补一个 `appendix/38-安全恢复验证闭环速查表` 就很自然了：长文已经解释了为什么 repair action 不等于 recovery closure，但实现、评审与交互实现时更需要一张更短的闭环矩阵。把 `/reload-plugins`、MCP reconnect、`/login`、`/remote-control` / bridge reconnect、restore+hydrate、`session_state_changed(idle)`、`files_persisted` 等压成“repair path / verifier readback / 最终 signer / 可清除对象 / 禁止的假闭环 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“某条修复路径有没有 verifier、有没有 signer、有没有在动作执行后就提前宣布闭环”的速查表。 
- 继续往前推进后，可以更明确地把 `55-安全恢复自动验证门槛` 单独写出来：`54` 已经回答了 repair action 必须经过 verifier 和 signer 关环，但还没有回答“哪些闭环系统可以自动完成，哪些必须停留在人工确认态”。`PluginInstallationManager.ts` 已经在同一模块里明示了这条分界：新 marketplace 安装允许 auto-refresh，而 updates only 只设置 `needsRefresh`；`useManagePlugins.ts` 又进一步强调某些 auto-refresh 曾因 stale-cache bug 被拿掉，必须退回人工 `/reload-plugins`；`useManageMCPConnections.ts` 则展示了系统对 remote transport 自动重连的强主权，包括 backoff、重试上限和最终状态回写；相对地，`ChannelsNotice.tsx` 与 `teleport.tsx` 明确把 `/login` 后的 restart / `/status` 复核留给用户，而 `bridgeMain.ts` 也把 transient reconnect failure 留在 “try running the same command again” 的人工确认态。这样一来，源码已经很清楚地说明：自动撤警的真正门槛不是有没有修复命令，而是系统是否同时拥有 action ownership、verification ownership 与 interpretation ownership；只有三权都在系统手里，控制面才配 auto-close。 
- 在 `55-安全恢复自动验证门槛` 之后，再补一个 `appendix/39-安全恢复自动验证门槛速查表` 就很自然了：长文已经解释了为什么只有在三权都在系统手里时才配 auto-close，但实现、评审与自动化策略设计时更需要一张更短的门槛矩阵。把新 marketplace 安装后的 plugin auto-refresh、plugin updates only、remote MCP transport automatic reconnection、`/login` 后认证恢复、bridge reconnect transient retry、restore+hydrate、authoritative idle / `files_persisted` 等压成“repair path / action ownership / verification ownership / signer ownership / auto-close 许可 / 何时必须转人工确认 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“这条恢复路径到底有没有资格自动撤警”的速查表。 
- 继续往前推进后，可以更明确地把 `56-安全恢复留痕纪律` 单独写出来：`55` 已经回答了哪些闭环该自动完成、哪些必须停在人工确认，但还没有回答“那些未闭环恢复会不会被系统静默忘掉”。`PluginInstallationManager.ts` 已明确把 auto-refresh 失败回退成 `needsRefresh=true`；`useManagePlugins.ts` 又强调 `/reload-plugins` 消费前不得自动 reset `needsRefresh`；`useManageMCPConnections.ts` 则把重连过程显式外化成 `pending`、`reconnectAttempt`、`maxReconnectAttempts`，最终成功收敛或失败落成 `failed`；`bridgeMain.ts` 更进一步要求 transient reconnect failure 保留 pointer、提示再次运行同一命令，并且 crash-recovery pointer 会立即写入并按小时刷新；`notifications.tsx` 最后说明即使是 UI 痕迹的删除，也必须靠显式 `invalidates`、timeout 或 remove。这些证据合在一起已经很清楚地说明：下一代统一安全控制台不只要会判断什么时候不能 auto-close，还必须强制未闭环恢复保留可重试、可回访、可解释的痕迹，避免“问题没解决但系统已经忘了”。 
- 在 `56-安全恢复留痕纪律` 之后，再补一个 `appendix/40-安全恢复留痕纪律速查表` 就很自然了：长文已经解释了为什么未闭环恢复必须保留痕迹，但实现、评审与状态面设计时更需要一张更短的留痕矩阵。把 plugin auto-refresh 失败、plugin updates 待应用、plugin hooks 局部加载失败、MCP automatic reconnection 进行中 / 放弃、bridge transient reconnect failure、crash-recovery / 长会话风险、通知未被 invalidated 等压成“失败场景 / 留痕对象 / 再进入入口 / 何时允许清除 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“这个恢复失败有没有被控制面记住，而不是被静默蒸发”的速查表。 
- 继续往前推进后，可以更明确地把 `57-安全恢复清理权限边界` 单独写出来：`56` 已经回答了未闭环恢复必须保留痕迹，但还没有回答“这些痕迹到底谁有权删”。`notifications.tsx` 已经把提示清理限制在 timeout、`invalidates` 和 `removeNotification` 这类窄权限里；`refresh.ts` 则把 `needsRefresh=false` 严格绑在 `refreshActivePlugins()` 这一条真正消费闭环的路径上，`useManagePlugins.ts` 还明确说不得在别处 reset；`PluginInstallationManager.ts` 进一步说明 auto-refresh 失败时只能把清理权退回挂起态，而不能假清理；`useManageMCPConnections.ts` 同样把 reconnect timer、pending、failed 的清理权限制在成功、最终失败或显式域内动作上；`bridgeMain.ts` 最后则把 pointer 清理权收得更高，只在 archive+deregister、stale、fatal 等高权场景才清。这些证据合在一起已经很清楚地说明：恢复痕迹不是普通 UI 状态，而是带有清理权限边界的控制对象，下一代统一安全控制台必须把“谁有权忘记失败”正式做成一条权限规则。 
- 继续往前推进后，可以更明确地把 `58-安全恢复清理门槛` 单独写出来：`57` 已经回答了“谁有权清理恢复痕迹”，但还没有回答“即便清理者正确，什么时候才允许清理”。`notifications.tsx` 说明即便是 notification owner，也必须等待 timeout、`invalidates` 或显式 remove 才能删提示；`refresh.ts` 说明 `needsRefresh=false` 只能发生在全量 plugin rebuild 与 `pluginReconnectKey` bump 之后，而不是 reload 一开始；`PluginInstallationManager.ts` 与 `useManagePlugins.ts` 又共同说明 plugin 域即便是 owner，也会在 updates only 场景故意停在 `needsRefresh`，等待用户显式 `/reload-plugins`；`useManageMCPConnections.ts` 则把 reconnect trace 保留到成功收敛、最终失败或手工域内动作接管为止；`bridgeMain.ts` 最后把 pointer 保留跨过 resumable shutdown、transient reconnect failure 和长会话刷新，只在 archive+deregister、stale 或 fatal 时才清。这些证据合在一起已经很清楚地说明：成熟恢复控制面不只需要清理权限边界，还需要清理门槛边界，也就是 owner 只能在对应闭环证据足够强时才配删除 trace。 
- 在 `58-安全恢复清理门槛` 之后，再补一个 `appendix/42-安全恢复清理门槛速查表` 就很自然了：长文已经解释了为什么 owner 正确也不等于现在就能清，但实现、评审与状态机设计时更需要一张更短的门槛矩阵。把 notification timeout/`invalidates`、plugin full rebuild、updates only 的手工 `/reload-plugins`、MCP retry budget 收敛或终止、bridge pointer 的 archive+deregister / stale / fatal 等压成“trace / owner / minimum clearer / threshold evidence / auto-clear 许可 / manual confirmation 要求 / forbidden early clear / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“系统是不是在证据还不够强时就提前忘记恢复痕迹”的速查表。 
- 继续往前推进后，可以更明确地把 `59-安全恢复隐藏权与删除权` 单独写出来：`58` 已经回答了“什么时候才允许删除恢复痕迹”，但还没有回答“界面上不再显示，是不是就等于正式删除”。`PromptInput/Notifications.tsx` 已经说明 hint 可以按局部谓词出现和消失，voice mode 甚至会直接替换全部通知；`BridgeDialog.tsx` 与 `status.tsx` 又把 bridge、IDE、MCP 的复杂状态压成 label、footer 和计数摘要；相对地，`replBridgeTransport.ts` 明确说明 `isConnectedStatus()` 只是 write-readiness，不是 read-readiness；`sessionState.ts` 与 `ccrClient.ts` 最后才是真正把 `pending_action`、`task_summary`、`worker_status` 与 delivery status 写入、清空和镜像进正式账本的地方。这些证据合在一起已经很清楚地说明：成熟控制面必须把 surface hiding、projection rewrite、authoritative trace clearing 和 explanation closing 分开，否则“看不见了”就会被用户误读成“已经不存在”。 
- 在 `59-安全恢复隐藏权与删除权` 之后，再补一个 `appendix/43-安全恢复隐藏权与删除权速查表` 就很自然了：长文已经解释了为什么表层“没显示了”不等于正式删除，但实现、评审与控制台语义设计时更需要一张更短的分层矩阵。把 `PromptInput/Notifications.tsx` 的 surface hider、`BridgeDialog.tsx` / `status.tsx` 的 projection owner、`replBridgeTransport.ts` 的 readiness reporter、`sessionState.ts` / `ccrClient.ts` 的 authoritative trace writer，以及更高层 explanation closer 压成“层级 / 典型对象 / 可以做什么 / 不能做什么 / 真正删除者 / 最危险误读 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“表层隐藏动作有没有被误当成正式清理动作”的速查表。 
- 继续往前推进后，可以更明确地把 `60-安全恢复显式语义` 单独写出来：`59` 已经回答了“表层隐藏不等于正式删除”，但还没有回答“控制面应该用什么词来稳定地区分这些状态”。`useTasksV2.ts` 已经把 hidden 做成 `getSnapshot() -> undefined` 但内部 cache 保留的正式语义；`Messages.tsx` 直接维护 `hiddenMessageCount`，明确告诉用户“这些消息是隐藏，不是删除”；`PromptInput/Notifications.tsx` 又提供了 suppressed/replaced 的前景语义；相对地，`sessionState.ts` 与 `ccrClient.ts` 才真正展示 cleared 语义：`pending_action: null`、`task_summary: null` 与 stale metadata 的正式清理；而 resolved 则仍要等待更高层 signer 与解释闭环。这些证据合在一起已经很清楚地说明：成熟控制面必须把 hidden、suppressed、cleared、resolved 做成不同词法，否则系统仍会被一句“没事了”重新压平。 
- 在 `60-安全恢复显式语义` 之后，再补一个 `appendix/44-安全恢复显式语义速查表` 就很自然了：长文已经解释了为什么恢复控制面必须把 hidden、suppressed、cleared、resolved 做成不同词法，但实现、评审与文案审查时更需要一张更短的词法矩阵。把 `useTasksV2.ts` 的 hidden、`PromptInput/Notifications.tsx` 的 suppressed、`sessionState.ts` / `ccrClient.ts` 的 cleared，以及更高层 explanation closure 的 resolved 压成“语义 / 最短定义 / 典型对象 / 允许系统说什么 / 禁止误说什么 / 对应责任层 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“系统是否又把不同责任层状态压成同一句‘没事了’”的速查表。 
- 继续往前推进后，可以更明确地把 `61-安全恢复词法主权` 单独写出来：`60` 已经回答了“控制面必须保留 hidden、suppressed、cleared、resolved 四类词”，但还没有回答“谁有资格使用这些词”。`useIdeConnectionStatus.ts` 先把 IDE 压成 `connected / pending / disconnected / null`；`useIDEStatusIndicator.tsx` 再把同域状态扩写成 `disconnected`、`plugin not connected`、`install failed` 等通知词；`status.tsx` 又把它们压成 `Connected to ...`、`Installed ...`、`Not connected` 这类摘要；`bridgeStatusUtil.ts` 更进一步把 `sessionActive || connected` 统一说成 `Remote Control active`；`PromptInputFooter.tsx` 还明确把 failed state 从 footer pill 分流到 notification；`useMcpConnectivityStatus.tsx` 与 `status.tsx` 则分别对 MCP 输出动作导向通知与盘点导向摘要。这些证据合在一起已经很清楚地说明：成熟控制面不只要有显式词法，还必须有词法主权，也就是不同组件只能在自己的表达 ceiling 内转述状态，而不能各自发明恢复语言。 
- 在 `61-安全恢复词法主权` 之后，再补一个 `appendix/45-安全恢复词法主权速查表` 就很自然了：长文已经解释了为什么不同 surface 不能各自发明恢复语言，但实现、评审与文案仲裁时更需要一张更短的命名矩阵。把 IDE 基础 hook、IDE 通知层、`/status` IDE 摘要、bridge status label/footer、MCP 通知层、`/status` MCP 摘要以及 authoritative writer 压成“surface / visible inputs / max allowed lexicon / forbidden stronger terms / 为什么不能说更满 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“某个界面是不是在输入不够的情况下说得太满”的速查表。 
- 继续往前推进后，可以更明确地把 `62-安全恢复词法仲裁` 单独写出来：`61` 已经回答了“谁有资格给状态命名”，但还没有回答“当多个界面同时发声时谁的话算数”。`notifications.tsx` 已经把 `current / queue / immediate / invalidates / fold` 做成正式的注意力仲裁；`useIDEStatusIndicator.tsx` 与 `useMcpConnectivityStatus.tsx` 会把错误、断连和 needs-auth 推进 notification 轨道；相对地，`status.tsx` 继续输出平缓摘要；`bridgeStatusUtil.ts` 与 footer 又给出另一个更压缩的 bridge 词法；`BridgeDialog.tsx` 还会在 dialog 内生成自己的 status label 与 footer text。这些证据合在一起已经很清楚地说明：成熟控制面不只需要命名主权，还需要词法仲裁，也就是当多个 surface 同时描述同一恢复事实时，系统必须正式决定谁能代表当前真相、谁必须让位降级。 
- 在 `62-安全恢复词法仲裁` 之后，再补一个 `appendix/46-安全恢复词法仲裁速查表` 就很自然了：长文已经解释了为什么多个 surface 同时存在时还必须继续仲裁谁能代表当前真相，但实现、评审与跨面语义对齐时更需要一张更短的仲裁矩阵。把 notification current、`/status` summary、footer pill、dialog / card detail 以及 authoritative writer / higher signer 压成“surface / role / lexical authority level / 典型词法 / 冲突时赢谁 / 冲突时输给谁 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“低主权 surface 是否在词法冲突里没有让位”的速查表。 
- 继续往前推进后，可以更明确地把 `63-安全恢复词法失效` 单独写出来：`62` 已经回答了“多个 surface 冲突时谁的话算数”，但还没有回答“当更强的新证据出现时，旧词是否应该继续留在界面上”。`notifications.tsx` 已经把 `invalidates`、`removeNotification()`、`fold` 和 priority 抢占做成正式机制；`useIDEStatusIndicator.tsx` 也在状态变化时显式 `removeNotification(...)`，使旧 hint、旧 disconnected、旧 install-error 失效；`PromptInput/Notifications.tsx` 里 external editor hint 会按条件消失，voice mode 甚至会整层替换通知前景；`PromptInputFooter.tsx` 还明确把 failed state 从 footer pill 分流出去。这些证据合在一起已经很清楚地说明：成熟控制面不只要仲裁哪个词更该被信，还必须在更强新证据出现时显式撤销旧的弱词，避免把互相冲突的解释并排留给用户自己整合。 
- 在 `63-安全恢复词法失效` 之后，再补一个 `appendix/47-安全恢复词法失效速查表` 就很自然了：长文已经解释了为什么更强新证据出现时旧词必须退场，但实现、评审与跨面语义校验时更需要一张更短的失效矩阵。把 notification `invalidates`、IDE hint/disconnected/install-error 的显式 `removeNotification(...)`、external editor hint 的条件消失、voice mode 的整层替换，以及 bridge failed 对 footer 弱词的分流压成“new stronger evidence / invalidated old lexicon / affected surfaces / 失效动作 / 为什么必须失效 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“更强新证据出现后旧词有没有及时退场”的速查表。 
- 继续往前推进后，可以更明确地把 `64-安全恢复绿色词租约` 单独写出来：`63` 已经回答了“高风险新证据出现时旧词必须失效”，但还没有回答“为什么这些绿色词本来就这么容易被收回”。`notifications.tsx` 已经通过 timeout、`invalidates`、`fold` 把 immediate 提示做成短期前景租约；`useTasksV2.ts` 进一步说明即便所有任务刚变成 `completed`，系统也要先经过 hide delay 和再确认，才真正把它们隐藏；`bridgeStatusUtil.ts` 中的 `Remote Control active` 只要出现 `error` 或 `reconnecting` 就会立刻被更强词覆盖；`PromptInputFooter.tsx` 又明确把 failed state 从 footer pill 撤出；`status.tsx` 里的 `Connected to ...`、`Installed ...` 与 `n connected` 也都只是当前盘点视图下的暂时正向词。这些证据合在一起已经很清楚地说明：成熟控制面里的大多数绿色词都不应被视作永久承诺，而应被设计成带续租条件和撤租触发器的可撤销租约。 
- 继续往前推进后，可以更明确地把 `65-安全恢复续租信号` 单独写出来：`64` 已经回答了“绿色词本质上是可撤销租约”，但还没有回答“这些租约靠什么续租”。`CCRClient.ts` 已经在初始化后启动 heartbeat 定时器，并持续用 `/worker/heartbeat` 保持 worker 存活租约；`bridgePointer.ts` 与 `bridgeMain.ts` 又把 crash-recovery pointer 设计成按 mtime 和小时 refresh 续租的对象；`bridgeMain.ts` 的 `heartbeatActiveWorkItems()` 进一步说明 active work 也要持续续租，401/403 则触发 re-dispatch，404/410 则转 fatal；`useTasksV2.ts` 最后用 fallback poll 与 recheck 说明 even local “completed” 也要靠持续观察续租。这些证据合在一起已经很清楚地说明：成熟控制面不仅要把绿色词设计成可撤销租约，还要为这些租约绑定 heartbeat、poll、refresh、recheck 等续租信号；没有续租信号的绿色词，不应继续被信任。 
- 继续往前推进后，可以更明确地把 `66-安全恢复续租失败分级` 单独写出来：`65` 已经回答了“绿色词必须持续续租”，但还没有回答“续租失败后应落到哪一级”。`useTasksV2.ts` 已经给出 `hidden` 这种非失败型退场；`useIdeConnectionStatus.ts` 与 `useManageMCPConnections.ts` 又提供了 `pending` 与自动重连链；`bridgeMain.ts` 的 `heartbeatActiveWorkItems()` 进一步区分 `auth_failed`、`failed`、`fatal`；`bridgePointer.ts` 则让 pointer 独立拥有 `stale` 语义。这些证据合在一起已经很清楚地说明：lease failure 不是一个二元断裂，而是一条关于“剩余恢复能力”的分级梯子，成熟控制面必须把 hidden、pending、reconnecting、auth_failed、failed、stale 等状态明确分层，而不能一律压成同一句“挂了”。 
- 继续往前推进后，可以更明确地把 `67-安全恢复失败路径选择器` 单独写出来：`66` 已经回答了“不同 lease failure 应落到不同层级”，但还没有回答“这些层级下一步把用户带去哪里”。`McpAuthTool.ts` 已经把 claude.ai connector 与不支持 OAuth 的 transport 直接导向 `/mcp`，可用 OAuth 的情形则返回 URL 并在后台 reconnect；`useManageMCPConnections.ts` 又表明 `pending` 的默认动作应是等待自动恢复而不是立刻人工修；`bridge/replBridge.ts` 则把 `reconnecting` 绑定到 env reconnect / fresh token 获取，把 `session expired` 明确绑定到 `/remote-control to reconnect`；而 `useTasksV2.ts` 的 `hidden` 又说明有些状态根本不应导向 repair path。这些证据合在一起已经很清楚地说明：成熟控制面不只要把 failure 状态分层，还必须把它们直接绑定到不同的 next repair path，避免用户在 `/mcp`、`/login`、`/status`、`/remote-control`、等待与重试之间盲猜。 
- 在 `67-安全恢复失败路径选择器` 之后，再补一个 `appendix/51-安全恢复失败路径选择器速查表` 就很自然了：长文已经解释了为什么不同 failure tier 必须直接绑定不同的 next repair path，但实现、评审与交互路径设计时更需要一张更短的路径矩阵。把 `hidden`、`pending`、`reconnecting`、`auth_failed / needs-auth`、`failed`、`stale / expired` 压成“failure tier / dominant repair path / forbidden wrong path / 为什么不能走错 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“系统是否仍把不同失败层级都丢给用户自己猜路径”的速查表。 
- 继续往前推进后，可以更明确地把 `68-安全恢复错误路径禁令` 单独写出来：`67` 已经回答了“每个 failure tier 的 dominant repair path 是什么”，但还没有回答“为什么系统不能只提示正确路径，而必须同时禁止邻近 wrong path”。`useManageMCPConnections.ts` 已经表明 `pending` 期间自动恢复预算仍在推进，所以抢先人工重置对象就是错误接管；`replBridge.ts` 又把 `reconnecting` 明确绑定到 env reconnect 与 fresh token 获取，说明此时过早宣判 terminal failure 或立刻整重建都是错法；`McpAuthTool.ts`、`bridgeMain.ts` 与 channels auth gate 则进一步说明 `auth_failed / needs-auth` 属于资格域根因，不能拿 generic reconnect 去掩盖；而 `bridgePointer.ts` 与 `session expired · /remote-control to reconnect` 又证明 stale / expired 的真正修复是重建 fresh anchor，而不是继续信旧对象。这些证据合在一起已经很清楚地说明：成熟控制面不只要给出 dominant repair path，还必须把最危险、最邻近、最容易被误选的 wrong path 正式做成禁令，否则恢复系统仍会把大量错误动作留给用户自己试错。 
- 在 `68-安全恢复错误路径禁令` 之后，再补一个 `appendix/52-安全恢复错误路径禁令速查表` 就很自然了：长文已经解释了为什么系统不只要给出 dominant repair path，还必须主动禁止邻近 wrong path，但实现、评审与状态机设计时更需要一张更短的禁令矩阵。把 `hidden`、`pending`、`reconnecting`、`auth_failed / needs-auth`、`failed`、`stale / expired` 压成“failure tier / dominant repair path / forbidden adjacent path / block reason / release condition / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“某个 failure tier 是否既给出正确路径、又正式排除了最危险邻近错法”的速查表。 
- 继续往前推进后，可以更明确地把 `69-安全恢复合法性` 单独写出来：`68` 已经回答了“系统必须禁止邻近 wrong path”，但还没有回答“哪一类 wrong path 最危险、为什么它们经常伪装成合理 cleanup”。`bridgeMain.ts` 已经明确写出：只要 single-session bridge 仍可 `--continue`，就必须跳过 `archive + deregister + clear pointer`，否则恢复命令会变成谎言；同文件又进一步区分了 transient reconnect failure 与 fatal reconnect failure，前者不得 deregister、pointer 也必须保留，因为那本身就是 retry mechanism；`replBridge.ts` 则在多个 await 窗口里反复检查 poll loop 是否已经自行恢复，一旦恢复就停止后续 stop/archive/rebuild，防止把刚恢复的 session 再次摧毁；`useManagePlugins.ts` 与 `PluginInstallationManager.ts` 又说明 `needsRefresh` 不是脏位，而是待消费恢复信号，不允许自动刷新、提前 reset，auto-refresh 失败时还要回退到手工 `/reload-plugins`；`useManageMCPConnections.ts` 与 `client.ts` 最后则说明 stale client、旧 timer、旧 closure、旧 keychain cache 都必须按正确顺序拆除，否则 fresh reconnect 会退化成伪恢复。这些证据合在一起已经很清楚地说明：成熟控制面真正保护的不是“当前是否整洁”，而是“未来是否仍然可恢复”，因此只要剩余可恢复性仍在，destructive cleanup 就必须被视为非法动作。 
- 在 `69-安全恢复合法性` 之后，再补一个 `appendix/53-安全恢复合法性速查表` 就很自然了：长文已经解释了为什么 cleanup 不是默认合法动作，但实现、评审与恢复状态机设计时更需要一张更短的合法性矩阵。把 single-session resume 价值、transient retry 价值、poll-loop 已恢复对象、生存中的 pointer、`needsRefresh`、fresh credential 路径这些 recoverability asset 压成“recoverability asset / carrier object / forbidden destructive cleanup / 为什么仍受保护 / release condition / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“某个 cleanup 会不会把 future recovery 一起删掉”的速查表。 
- 继续往前推进后，可以更明确地把 `70-安全多重窄门` 单独写出来：前面的章节已经分别解释了 mode、trust、rules、hooks、bridge、MCP 与 channel 的局部边界，但还没有回答“为什么这些边界必须串成多重窄门，而不是让最终 permission dialog 一把兜底”。`permissions.ts` 已经说明 content-specific ask rule 与 path safety check 对 bypass mode 仍然免疫，说明 bypass 不是总后门；`setup.ts` 又进一步把 `--dangerously-skip-permissions` 收在 root / sandbox 这类环境门之后；`hooks.ts` 则把 workspace trust 做成所有 hook 的统一前门，拒绝把任意命令执行权分散给各个 hook 自己判断；`interactiveHandler.ts` 又把本地 UI、bridge、channel、hook、classifier 做成多源并发但 resolve-once 的单一裁决，避免安全裂脑；`commands.ts` 与 `useReplBridge.tsx` 进一步说明远端连全量命令面都看不到，只能看到 bridge-safe 子集；`mcp/utils.ts`、`mcp/config.ts`、`channelPermissions.ts` 与 `coreSchemas.ts` 最后又把 project MCP server 与 channel relay 的能力发布继续收在 approval、allowlist、capability opt-in 与 structured event 之后。这些证据合在一起已经很清楚地说明：Claude Code 的安全哲学不是“先给出全部能力，再靠最后一个弹窗补权限”，而是“能力本来就只能被系统逐层借出”，这正是它比大量单门式 agent 系统更成熟的地方。 
- 在 `70-安全多重窄门` 之后，再补一个 `appendix/54-安全多重窄门速查表` 就很自然了：长文已经解释了为什么能力必须先经过环境门、信任门、内容门、决议门与发布门，但实现、评审与权限面产品化时更需要一张更短的能力借出矩阵。把 environment gate、bypass-immune content gate、workspace-trust gate、resolve-once decision gate、bridge publish gate、project MCP approval gate 与 channel relay gate 压成“gate / protected capability / admission condition / forbidden shortcut / 为什么不能绕过 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“某项能力到底卡在第几重门、又最怕被哪个 shortcut 绕过”的速查表。 
- 继续往前推进后，可以更明确地把 `71-安全能力发布主权` 单独写出来：`70` 已经回答了“能力必须经过多重窄门才能被借出”，但还没有回答“谁有资格把借出的结果宣布成前台入口”。`useReplBridge.tsx` 已经表明 remote `system/init` 不会直接转发本地全量 tools、mcpClients 与 plugins，而是主动 redact 并只发布 bridge-safe commands；`systemInit.ts` 又说明 `system/init` 本身正是 remote picker 与 gate UI 的上游能力发布协议；`main.tsx` 与 `commands.ts` 进一步在 remote mode 进入 REPL 前就预过滤 commands，防止 local-only 命令短暂露出；`REPL.tsx` 收到 remote init 后还会再次按 authoritative remote slash command set 收窄本地可见命令；`mcp/utils.ts` 与 `mcp/config.ts` 又说明 project MCP server 不是写进配置就自动变成可见能力，而必须先从 `pending/rejected` 走到 `approved` 才能进入 merge；`coreSchemas.ts` 与 `print.ts` 最后则进一步证明 capability field 本身的出现也受 allowlist 约束，IDE 是否显示 Enable-channel prompt 取决于被批准后才出现的 experimental capability。这些证据合在一起已经很清楚地说明：在 Claude Code 里，入口可见性本身就是安全承诺，不是任何宿主或 adapter 都配自报，只有 authoritative publish set 才有资格宣布“现在可用”。 
- 在 `71-安全能力发布主权` 之后，再补一个 `appendix/55-安全能力发布主权速查表` 就很自然了：长文已经解释了为什么入口可见性本身也是安全主权，但实现、评审与宿主适配设计时更需要一张更短的发布矩阵。把 REPL bridge `system/init`、remote mode 预过滤、remote init 二次收窄、project MCP approval、channel capability field 与 IDE prompt 输出压成“surface / authoritative publisher / visible capability / publish condition / forbidden overclaim / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“某个表面是不是在没有主权的情况下把能力说得太满”的速查表。 
- 继续往前推进后，可以更明确地把 `72-安全能力撤回主权` 单独写出来：`71` 已经回答了“谁有资格把能力发布成入口”，但还没有回答“谁有资格把已发布入口正式撤回”。`REPL.tsx` 已经表明一旦收到 authoritative remote slash command set，本地就必须按它收窄命令面，不能继续保留更多入口；`main.tsx` 与 `commands.ts` 进一步说明最成熟的撤回甚至会前移成预过滤，让不该存在的 local-only 命令一开始就不出现；`useManageMCPConnections.ts` 则说明 stale MCP client 的撤回不是局部隐藏，而是要随着 timer、onclose closure 与 cache 一起拆链，否则旧能力会继续以伪形式存活；`mcp/utils.ts` 与 `mcp/config.ts` 又说明 project MCP approval 的失效会一路传导成配置集合中的正式撤回；`print.ts` 最后则进一步证明 capability field 本身在 allowlist 不成立时就必须被删除，避免 dead button 继续替系统作错误承诺。这些证据合在一起已经很清楚地说明：在 Claude Code 里，能力撤回和能力发布一样都是主权动作，不是任何镜像层或局部状态都能越权决定，只有掌握 publish sovereignty 的 authoritative publisher 才有资格正式改口。 
- 在 `72-安全能力撤回主权` 之后，再补一个 `appendix/56-安全能力撤回主权速查表` 就很自然了：长文已经解释了为什么能力撤回同样属于主权动作，但实现、评审与宿主适配设计时更需要一张更短的撤回矩阵。把 remote authoritative command shrink、remote mode 预过滤、stale MCP client 剔除、project MCP approval 失效以及 channel capability 删除压成“surface / revocation authority / retraction trigger / retraction action / forbidden stale promise / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“某个表面是不是在上游主权已收回后仍继续保留旧入口”的速查表。 
- 继续往前推进后，可以更明确地把 `73-安全能力恢复主权` 单独写出来：`72` 已经回答了“谁有资格把入口撤回”，但还没有回答“谁有资格把曾被撤回的入口重新恢复为可见可用”。`useManageMCPConnections.ts` 已经表明 MCP server 被重新启用时并不是界面直接翻绿，而是先落盘 enabled state，再标为 `pending`，随后走 reconnect；同文件还说明新的 config、plugin server 与 claude.ai server 重新出现时，都会先作为 `newClients` / `pending` 重新进入 `mcp.clients`，说明恢复必须由配置主权层重新纳入候选集合；`mcp/utils.ts` 与 `mcp/config.ts` 又说明 project MCP server 只有重新回到 `approved` 并通过 policy filter，才会再次进入最终 merged configs；`useManagePlugins.ts` 与 `refresh.ts` 则进一步说明 plugin 能力的恢复不能靠通知层自我乐观重置，而必须由 `/reload-plugins -> refreshActivePlugins()` 正式消费 `needsRefresh` 并重建 commands、agents、MCP 与 LSP；`print.ts` 最后又说明 channel capability 的恢复也不是按钮自己亮起，而是 allowlist entry 写入后还要通过 `gateChannelServer(...)`，失败则立即 rollback。这些证据合在一起已经很清楚地说明：在 Claude Code 里，能力恢复不是旧授权自动续命，而是一次新的授权与重新接线，因此只有掌握原始 gate 结果的 authoritative publisher，才有资格把入口重新恢复为“现在可用”。 
- 在 `73-安全能力恢复主权` 之后，再补一个 `appendix/57-安全能力恢复主权速查表` 就很自然了：长文已经解释了为什么能力恢复本质上是重新授权，但实现、评审与宿主适配设计时更需要一张更短的恢复矩阵。把 MCP re-enable、newClients 回归、project approval 回归、`/reload-plugins -> refreshActivePlugins()` 以及 channel allowlist + gate 通过后恢复 capability 压成“surface / restoration authority / regrant path / 恢复前中间态 / forbidden premature return / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“某个入口是不是在没有重新经过主权链签字的情况下被提前恢复”的速查表。 
- 继续往前推进后，可以更明确地把 `74-安全能力声明主权` 单独写出来：`73` 已经回答了“谁有资格把入口恢复回来”，但还没有回答“谁有资格把能力状态说成 `enabled`、`pending`、`connected`、`active` 或 `failed`”。`mcp/types.ts` 已经先从底层把 MCP server 正式分成 `connected / failed / needs-auth / pending / disabled` 五类，说明并非所有表面都能自造状态词；`useIdeConnectionStatus.ts` 又把 IDE 基础 hook 继续压成 `connected / pending / disconnected / null` 这种窄声明；相对地，`status.tsx` 才把这些底层状态投影成 `/status` 可见的 `Connected to ...`、`Installed ...`、`Not connected ...` 以及 `n connected / n need auth / n pending / n failed` 盘点摘要；`bridgeStatusUtil.ts` 与 `PromptInputFooter.tsx` 又进一步说明 footer pill 只配说 `Remote Control active / reconnecting / failed / connecting…` 这套更窄词法，甚至 failed 还要从 footer 分流到 notification；而 `useIDEStatusIndicator.tsx` 与 `useMcpConnectivityStatus.tsx` 最后则证明通知层只配说 `IDE plugin not connected · /status for info`、`install failed (see /status for info)`、`n MCP servers failed · /mcp`、`n need auth · /mcp` 这类提醒性词法，并主动把用户转介到 `/status` 或 `/mcp`。这些证据合在一起已经很清楚地说明：在 Claude Code 里，能力状态词本身就是一种解释权限，不同表面只能在自己的 lexical ceiling 内发言，掌握局部事实的层不配替系统说完整真相。 
- 在 `74-安全能力声明主权` 之后，再补一个 `appendix/58-安全能力声明主权速查表` 就很自然了：长文已经解释了为什么能力状态词本身也是解释权限，但实现、评审与多表面词法校验时更需要一张更短的声明矩阵。把 MCP type layer、IDE 基础 hook、`/status` 摘要、bridge footer pill、IDE 通知层与 MCP 通知层压成“surface / visible inputs / max allowed lexicon / forbidden stronger claim / 为什么不能说得更满 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“某个表面是不是在没有足够事实的情况下把能力状态说得太满”的速查表。 
- 继续往前推进后，可以更明确地把 `75-安全能力声明仲裁` 单独写出来：`74` 已经回答了“不同表面各自最多配把能力状态说到哪一步”，但还没有回答“当这些表面同时说话甚至互相打架时，到底谁赢什么”。`notifications.tsx` 已经把通知当前项与队列做成显式仲裁器，并用 `immediate / high / medium / low` 与 `invalidates` 明确区分当前谁先抢到注意力，这说明 notification lane 解决的是 attention arbitration，而不是最终真相；`useReplBridge.tsx` 又把 `Remote Control failed` 做成 `priority: immediate` 通知，而 `PromptInputFooter.tsx` 则明确写明 failed 不该留在 footer pill，说明高风险否定词必须抢到前景、低占位连续反馈必须让位；`useIDEStatusIndicator.tsx` 进一步证明同一通知域内部也有先后级，generic disconnected 会在 install error 或 JetBrains plugin not connected 出现时被主动移除；与此同时，`useIDEStatusIndicator.tsx` 与 `useMcpConnectivityStatus.tsx` 反复把用户导向 `/status for info` 与 `/mcp`，而 `status.tsx` 又确实拥有安装信息、连接信息与 server counts 这种更完整盘点输入，说明 notification 赢的是“先看我”，`/status` 赢的是“最终去哪里确认”。这些证据合在一起已经很清楚地说明：在 Claude Code 里，真正成熟的不是“每个表面都能显示状态”，而是系统已经开始把注意力优先级和真相解释权拆开治理，避免谁更显眼谁就被误读成更权威。 
- 在 `75-安全能力声明仲裁` 之后，再补一个 `appendix/59-安全能力声明仲裁速查表` 就很自然了：长文已经解释了为什么 notification、`/status`、footer 与 hook 之间不是一条简单胜负链，而是 attention arbitration、lexical ceiling、聚合解释与连续性弱词这几类权力的分治，但实现、评审与跨宿主适配时更需要一张更短的仲裁矩阵。把 MCP type layer、IDE 基础 hook、notification queue、IDE / MCP 通知层、bridge failed notification、`/status` / `/mcp` 摘要面与 footer pill 压成“surface / authority kind / primary evidence / 冲突时赢什么 / 冲突时输给谁 / forced handoff / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“某个表面到底该赢注意力、赢解释权，还是应该立刻闭嘴让位”的速查表。 
- 继续往前推进后，可以更明确地把 `76-安全能力显式让位` 单独写出来：`75` 已经回答了“冲突时谁该赢什么”，但还没有回答“新的强状态到来后，旧的弱状态到底要不要被正式宣布作废”。`notifications.tsx` 已经把 `invalidates` 直接写进基础通知协议，并且注释明说被 invalidated 的通知既会从队列移除，也会在当前显示态下被立即清掉；同文件又进一步说明 `priority: immediate` 不只是插队，还会在重排 `current + queue` 时过滤掉被新状态废止的旧项，而即便不是 immediate，只要 `invalidatesCurrent` 成立，系统也会清 timeout、把 current 置空，说明“显式让位”不是紧急态专属特权，而是一条通用的互斥语义纪律。`useIDEStatusIndicator.tsx` 则把这条纪律落在具体能力状态上：generic disconnected 一旦遇到 install error 或 JetBrains plugin not connected，就必须被主动 `removeNotification(...)`，说明原因态必须驱逐症状态；`useReplBridge.tsx` 和 `PromptInputFooter.tsx` 又形成另一条证据链：`Remote Control failed` 会以 `priority: immediate` 抢到前景，而 footer 明确拒绝承载 failed，说明高风险否定词必须驱逐旧的连续性弱词；`useFastModeNotification.tsx` 最后则提供了一个成对 `invalidates` 的对称样例，证明团队已经把“新状态正式废止旧状态”抽象成可复用原语，而不是只在某个安全 hook 里手工补丁。这些证据合在一起已经很清楚地说明：Claude Code 的成熟之处不只是能做状态仲裁，而是知道哪些旧状态必须被正式宣布过时，不能留给 timeout 慢慢消失。 
- 在 `76-安全能力显式让位` 之后，再补一个 `appendix/60-安全能力显式让位速查表` 就很自然了：长文已经解释了为什么更高风险、更具体的新状态必须主动驱逐旧的弱状态，但实现、评审与跨表面状态机设计时更需要一张更短的驱逐矩阵。把任意带 `invalidates` 的新通知、`priority: immediate` 新通知、IDE install failed、JetBrains plugin not connected、bridge failed 与 fast mode started / expired 这些对称状态压成“incoming state / evicted state / eviction mechanism / 为什么新状态必须赢 / 若不驱逐会出现什么 stale risk / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“新状态是否真的把旧真相赶下了屏幕，而不是只在表面上暂时盖住它”的速查表。 
- 继续往前推进后，可以更明确地把 `77-安全状态替换语法` 单独写出来：`76` 已经回答了“什么情况下必须显式驱逐旧状态”，但还没有回答“状态变化是不是都该用同一种编辑动作”。`notifications.tsx` 已经在基础协议层同时定义了 `fold` 与 `invalidates`，说明作者明确知道“重复事件聚合”和“互斥真相替换”不是一回事；同文件又进一步把同 key 的重复通知走 `fold into current / queued notification`，而互斥新状态走 `invalidatesCurrent` 与 queue filter，说明底层已经形成两条完全不同的替换路径；`removeNotification(...)` 又把“拥有者撤回自身状态”单独抽出来，配合 `useSettingsErrors.tsx`、`Notifications.tsx` 里的 external-editor-hint 以及 `PromptInput.tsx` 里的 ultrathink / ultraplan / stash-hint，可以看出 remove 的语义是生命周期收尾，而不是新状态推翻旧状态；`useTeammateShutdownNotification.ts` 则证明 `fold` 真正保护的是重复事件的聚合语义，不是简单少刷几条；`Notifications.tsx:286-330` 最后还说明不少状态根本不该互相替代，而应该正交共存，例如当前通知槽、IDE 状态、token warning、memory usage 与 sandbox hint 会同时挂在 footer 区域。这些证据合在一起已经很清楚地说明：Claude Code 的高级之处不只是会做状态替换，而是已经隐含了一套 replacement grammar，能够区分新增、折叠、失效、移除与共存这几种完全不同的状态编辑动词。 
- 在 `77-安全状态替换语法` 之后，再补一个 `appendix/61-安全状态替换语法速查表` 就很自然了：长文已经解释了为什么状态变化不能统一压成“再发一条通知”，但实现、评审与统一安全控制台协议设计时更需要一张更短的编辑矩阵。把同一语义的重复事件、互斥新状态、拥有者主动收尾、高优先级前景抢位、正交维度共存以及原因态覆盖症状态这些 change pattern 压成“change pattern / operator / safe effect / forbidden shortcut / 如果走错会发生什么 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“这次状态变化到底该折叠、作废、撤回还是共存”的速查表。 
- 继续往前推进后，可以更明确地把 `78-安全状态编辑主权` 单独写出来：`77` 已经回答了“应该使用哪一种编辑动词”，但还没有回答“这些动词的主语到底是谁”。`notifications.tsx` 已经把 `removeNotification` 暴露成 `key: string` 的全局接口，说明从纯 API 能力上看，任何拿到 hook 的调用方理论上都能删任何通知；但真实使用里，`useSettingsErrors.tsx`、`Notifications.tsx` 和 `PromptInput.tsx` 又基本都遵守“自己增、自己撤”的 owner discipline，说明工程实践已经形成了本地所有者惯例；`useTeammateShutdownNotification.ts` 则把 `fold` 严格留在同一 teammate lifecycle family 内，说明聚合权本质上是一种语义压缩权；`useFastModeNotification.tsx` 又把 `invalidates` 严格限制在 fast mode 冷却状态家族内部，说明废止权本质上是一种互斥关系解释权；`useIDEStatusIndicator.tsx` 最后则给出了家族级 sibling 编辑的更复杂例子，同一 IDE status family owner 会在 disconnected、JetBrains plugin not connected 与 install error 之间决定谁该出现、谁该退场。这些证据合在一起已经很清楚地说明：Claude Code 并不是“谁都在乱改谁的状态”，而是已经形成了明显的家族所有权直觉，只是这种主权目前更多靠约定和局部文件边界维持，还没有被完全提升成 capability-encoded interface。 
- 在 `78-安全状态编辑主权` 之后，再补一个 `appendix/62-安全状态编辑主权速查表` 就很自然了：长文已经解释了为什么 replacement grammar 之后还必须继续回答编辑主语，但实现、评审与下一代统一安全控制台接口设计时更需要一张更短的主权矩阵。把 teammate lifecycle、fast mode cooldown、settings error、external editor hint、ultrathink / ultraplan / stash-hint、IDE status family 以及 notification 全局 current 槽这些 status family 压成“status family / allowed editor / allowed operator / 依据是什么 / forbidden outsider / 若被 outsider 编辑会出什么问题 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“这次状态编辑到底是不是由正确主语执行”的速查表。 
- 继续往前推进后，可以更明确地把 `79-安全状态家族作用域` 单独写出来：`78` 已经回答了“谁通常在编辑谁的状态”，但还没有回答“这个主语现在到底被编码在哪里”。`notifications.tsx` 已经说明通知系统对身份、fold、去重、失效、删除的判断全部只看全局 `key` 相等，说明在抽象层里它根本不知道什么是 fast mode family、IDE family 或 teammate family；但业务代码里又明显在手工使用 family scope，例如 `useFastModeNotification.tsx` 里成组的 `fast-mode-*` 常量、`useIDEStatusIndicator.tsx` 里成组的 `ide-status-*` 状态、`useTeammateShutdownNotification.ts` 里的 `teammate-*` 键名，以及 `useSettingsErrors.tsx` 里先声明常量再使用的 `settings-errors`，都说明作者已经在通过命名前缀和本地常量隐含表达“这几条状态是一家人”；`PromptInput.tsx` 里 `external-editor-error` 在两个分支共享同一 key 也进一步证明 key 在现实里承担的是“家族内状态槽位”的作用，而不是单次消息实例 ID。这些证据合在一起已经很清楚地说明：Claude Code 当前并不是没有作用域，而是作用域主要停留在 key 命名规则和文件边界中，还没有被提升为 notifications 协议层真正理解的 family scope。 
- 在 `79-安全状态家族作用域` 之后，再补一个 `appendix/63-安全状态家族作用域速查表` 就很自然了：长文已经解释了为什么全局 key 字符串不是长期安全边界，但实现、评审与下一代统一安全控制台接口设计时更需要一张更短的作用域矩阵。把 `fast-mode-*`、`ide-status-*`、`teammate-*`、`mcp-* / mcp-claudeai-*`、`external-editor-*`、`settings-errors` 这类单成员家族以及 notifications 全局 key 空间压成“key pattern / implicit family / 当前靠什么维持作用域 / current guarantee / scope risk / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“当前这条状态边界到底是正式 scope，还是只是命名自觉”的速查表。 
- 继续往前推进后，可以更明确地把 `80-安全状态句柄化` 单独写出来：`79` 已经回答了“真正的长期边界应当是 family scope，而不是裸 key”，但还没有回答“那这个 scope 下一步该进入什么接口载体”。`notifications.tsx` 已经把 `Notification` 的身份核心压成 `key: string`，`addNotification` / `removeNotification` 也都只接受裸 `Notification` 或裸 key；`AppStateStore.ts` 进一步说明 notifications 在 store 里只有 `current` 与 `queue` 两个数组位置，没有 family、owner、allowed operator 或 scope token 之类 metadata，说明作用域知识一旦进入状态对象就会被抹平；但对照 `bridge/replBridge.ts`，Claude Code 又已经在高风险远程控制面里明确定义了 `ReplBridgeHandle`，把 `sendControlRequest`、`sendControlResponse`、`sendControlCancelRequest`、`sendResult` 与 `teardown` 这组能力绑在一个受限 handle 上；`replBridgeHandle.ts` 的注释更是直接说明 handle 的闭包捕获了创建 session 的 `sessionId` 与 token 语义，独立重建这些上下文会引入 staging/prod token divergence 风险。这些证据合在一起已经很清楚地说明：Claude Code 并不是不知道 handle 的价值，它已经在 bridge 这种高风险控制面证明了“能力应该挂在句柄上而不是靠名字重推导”；因此对下一代统一安全控制台来说，notification/state 子系统最自然的演化方向就是从裸 key 走向 scoped opaque handle。 
- 在 `80-安全状态句柄化` 之后，再补一个 `appendix/64-安全状态句柄化速查表` 就很自然了：长文已经解释了为什么 family scope 的下一步不该只是更多命名规则，而应升级成句柄能力对象，但实现、评审与统一安全控制台协议设计时更需要一张更短的句柄化矩阵。把 notifications identity、notifications store、family-driven replace logic、bridge control plane 与 bridge handle global pointer 这些 subsystem 压成“current carrier / missing scope / 推荐 handle 字段 / migration gain / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“当前这里到底还停留在名字寻址，还是已经升级成能力寻址”的速查表。 
- 继续往前推进后，可以更明确地把 `81-安全能力闭包绑定` 单独写出来：`80` 已经回答了“状态边界的下一步应是 handle”，但还没有回答“handle 真正有安全价值的原因是什么”。`replBridge.ts` 已经说明 `ReplBridgeHandle` 给出的不是裸 session id，而是一组直接依赖 `currentSessionId`、`transport` 与 `doTeardownImpl` 的方法，这意味着调用方拿到的是 creator-bound capability，而不是让自己填参数的 helper；`replBridgeHandle.ts` 的注释更是直接把这点说透：handle 的闭包捕获了创建该 session 的 `sessionId` 与 `getAccessToken`，独立重建这些值会引入 staging/prod token divergence 风险；`useReplBridge.tsx` 里导出的 `permissionCallbacks` 也证明 handle 不只绑定静态对象，还把 `pendingPermissionHandlers` 这种关系账本一起包进局部上下文里；`bridgeDebug.ts` 则进一步说明即便是 debug 能力，也仍然优先暴露受限句柄而不是整套内部状态。这些证据合在一起已经很清楚地说明：handle 的真正安全价值，不在“对象化”本身，而在于它把正确的上下文、生命周期和关系账本一起绑住，避免后来者在错误上下文里重建出看似相同的能力。 
- 在 `81-安全能力闭包绑定` 之后，再补一个 `appendix/65-安全能力闭包绑定速查表` 就很自然了：长文已经解释了为什么 handle 真正承载的是创建时上下文，但实现、评审与下一代统一安全控制台 handle 设计时更需要一张更短的闭包矩阵。把 `ReplBridgeHandle`、全局 `replBridgeHandle` 指针、基于 `handle_0` 的 `permissionCallbacks`、`BridgeDebugHandle` 以及 notifications 当前的裸 key 模型压成“handle / surface / captured context / forbidden re-derivation / security gain / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“当前这个能力对象到底有没有把关键上下文真正绑在自己身上”的速查表。 
- 继续往前推进后，可以更明确地把 `82-安全上下文重推导禁令` 单独写出来：`81` 已经回答了“真正成熟的 handle 会把关键上下文绑进闭包”，但还没有回答“哪些上下文可以像标题一样重推导，哪些绝不能交给调用方二次重算”。`replBridgeHandle.ts` 已经直接写出：handle 的闭包捕获了创建 session 的 `sessionId` 与 `getAccessToken`，独立重推导会带来 staging/prod token divergence 风险；`replBridge.ts` 又多处强调 `currentSessionId stays the same`，说明 session continuity 本身就是被刻意保护的控制对象，而不是普通派生值；同文件还通过 `onServerControlRequest` 的注释说明 callback 应直接捕获 `transport/currentSessionId`，避免在回调链上重新线程化这些关键上下文；`1512-1524` 的 pointer write race 注释更进一步证明，在 reconnect 非原子窗口里，如果让错误的再次写入发生，旧 session 会被重新写回当前指针；而与之形成鲜明对照的是 `initReplBridge.ts` 对 title 的说明，作者明确说它只是 cosmetic only，因此允许在第 1 次和第 3 次 prompt 上再次派生。这些证据合在一起已经很清楚地说明：Claude Code 并不是反对一切重推导，它反对的是对 authority-bearing context 的重推导；真正的分界线不是“值能不能算出来”，而是“这次重算会不会重新定义谁在谁的边界里行动”。 
- 在 `82-安全上下文重推导禁令` 之后，再补一个 `appendix/66-安全上下文重推导禁令速查表` 就很自然了：长文已经解释了为什么必须区分可重推导的 cosmetic context 与不可重推导的 authority context，但实现、评审与下一代统一安全控制台设计时更需要一张更短的禁令矩阵。把 bridge session title、`ReplBridgeHandle` methods、全局 `replBridgeHandle` 指针、bridge reconnect path、server control callback wiring 以及 notifications 当前模型压成“surface / re-derivable context / forbidden authority context / 为什么不能交给调用方重算 / failure mode / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“当前这段上下文到底只是展示派生值，还是承载授权连续性”的速查表。 
- 本轮补入 `83-安全授权连续性`：`82` 已经回答了“哪些上下文不能重推导”，但还没有继续回答“为什么这些上下文一旦漂移就会构成安全问题”。`replBridgeHandle.ts` 已经把 `sessionId/getAccessToken` 看成 creator-bound continuity，而不是独立参数；`replBridge.ts` 又把 reconnect-in-place 的价值直接写成 `currentSessionId stays the same`、mobile URL 继续有效、`previouslyFlushedUUIDs` 保留，这说明系统真正想保住的是同一条授权与账本链，而不是单个字段值；同文件对 Strategy 1 / Strategy 2 的分叉、对 callback 捕获 `transport/currentSessionId` 的注释，以及对 pointer write race 可能把 archived old session 重新写回当前指针的警告，则进一步说明 Claude Code 真正防的是 boundary continuity 被静默替换；与之对照，`initReplBridge.ts` 的 title 与 `status.tsx` / `useIDEStatusIndicator.tsx` 的摘要提示都被明确放在 cosmetic / summary 层。这些证据合在一起已经很清楚地说明：成熟控制面真正需要保护的不是值本身，而是“当前是谁、正通过哪条通道、在谁的边界里继续行动”的授权连续性。 
- 同步补入 `appendix/67-安全授权连续性速查表`：长文已经解释了为什么 session、token、transport、pointer、title 与 `/status` 这些 context 实际属于不同 continuity class，但实现、评审与统一安全控制台设计时更需要一张更短的连续性矩阵。把 bridge session identity、token semantics、control callback transport binding、bridge pointer、session title 与 `/status` / IDE notification summary 压成“context / continuity owner / same-boundary requirement / allowed substitution / explicit break signal / boundary failure / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“这里到底是在延续原授权边界，还是已经发生换届却仍被说成同一对象”的速查表。 
- 本轮继续补入 `84-安全失效边界复活禁令`：`83` 已经回答了“真正的保护对象是授权连续性”，但还没有把 continuity failure 里最危险的一种单独命名出来。`replBridge.ts` 在 `doReconnect()` 开始时提升 `v2Generation`，明确要让 stale transport / handshake 失效；`stopWork` await 后如果 poll loop 已恢复，则直接放弃 archive，防止把新 transport 正连接的 session 销毁；重新注册环境后若 `transport !== null` 也立即让位，不再继续旧修复分支；Strategy 2 又明确先 archive orphaned old session；pointer refresh timer 则专门防止把 now-archived old session 重写回 current pointer。`bridgeMain.ts` 进一步说明 stale pointer 必须在 session gone 时清除，而 transient reconnect failure 必须保留 pointer 作为 retry 机制，fatal failure 才清；shutdown path 还直说错误的 archive+deregister 会让 resume command 变成 lie。这些证据合在一起已经很清楚地说明：Claude Code 不只是防 stale state，它在防已失效旧边界被重新认证成当前边界。 
- 同步补入 `appendix/68-安全失效边界复活禁令速查表`：长文已经解释了为什么 stale transport、orphaned session、旧 pointer、失效 resume 入口都不只是旧状态，而是潜在 revival path，但实现、评审与下一代统一安全控制台设计时更需要一张更短的复活禁令矩阵。把 in-flight stale v2 transport、旧 `currentWorkId`、旧 reconnect 分支、orphaned old session、crash-recovery pointer、server-gone resumed session、fatal reconnect 后的旧 pointer 以及 shutdown 后错误保留的 resume 入口压成“stale object / revival path / current guard / why guard exists / boundary consequence / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“这里是在处理旧状态，还是在无意中把死边界重新写成活边界”的速查表。 
- 本轮继续补入 `85-安全边界换届协议`：`84` 已经回答了“最危险的是失效旧边界复活”，但还没有继续回答“既然旧边界不能复活，新边界该如何合法上任”。`replBridge.ts` 已经把 Strategy 2 写成先 `archiveSession(currentSessionId)` 再 `createSession(...)`，说明新边界出现必须以旧边界退役为前提；同文件又在新 session 建立后立刻更新 bridge session id，并重置 `lastTransportSequenceNum`、`recentInboundUUIDs` 与 title derivation latch，再重写 pointer、清空 `previouslyFlushedUUIDs`，说明换届真正难的不是换一个 id，而是把所有 session-scoped ledger 一起重绑；`620-645` 与 `1402-1413` 还通过 `v2Generation` 与 stale handshake discard 明确剥夺旧 transport 在新边界上继续发言的资格；`1595-1663` 最后则把 perpetual teardown 与 non-perpetual clean exit 区分成“挂起可恢复”和“正式退役”两套制度，而 `bridgePointer.ts` 的 TTL 清理又说明 pointer 本质上是 current boundary 的恢复公证物。这些证据合在一起已经很清楚地说明：Claude Code 不只是在阻止复活，它还实现了一套显式的边界换届协议。 
- 同步补入 `appendix/69-安全边界换届协议速查表`：长文已经解释了为什么 continuation、succession、suspension 与 retirement 不能继续压成同一个“重新连一下”，但实现、评审与统一安全控制台设计时更需要一张更短的换届矩阵。把 reconnect in place、Strategy 2 换届、新 session 切换完成、stale transport 返回、perpetual teardown、non-perpetual clean exit 与 stale/invalid pointer 读取压成“break trigger / old boundary disposition / new boundary action / required reset / allowed continuity claim / forbidden fake continuity / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“系统当前到底是在续接、换届、挂起还是退役，以及有没有任何旧账本仍在伪装连续性”的速查表。 
- 本轮继续补入 `86-安全恢复承诺诚实性`：`85` 已经回答了“系统应如何续接、换届、挂起和退役”，但还没有继续回答“系统何时才有资格向用户承诺仍可恢复”。`bridgeMain.ts` 已经直接写出：如果打印 resume command 的同时 archive+deregister，就会让 printed resume command 变成 lie；`--continue` 路径又不是盲读一个本地文件，而是 worktree-aware 地挑 freshest pointer，并把来源 worktree 一并打印出来，说明恢复承诺必须精确指向真实对象；`bridgePointer.ts` 会主动清 stale/invalid pointer，防止用户被持续 re-prompt 到 backend 已清理的死边界；resume path 上如果 session gone 或没有 `environment_id`，系统还会同步清理对应 pointer，说明失败处理同时也是 promise revocation；另一方面，transient reconnect failure 故意保留 pointer，并明确说 `The session may still be resumable`，而 fatal failure 才清 pointer，说明 `try again` 这类文案也不是安慰语，而是有真实 retry path 作支撑的承诺；`2700-2728` 最后还说明 pointer 只在 `single-session` 下写，因为 multi-session 下写 pointer 会与后续恢复语义冲突。这些证据合在一起已经很清楚地说明：Claude Code 在治理的不是“恢复功能好不好用”，而是恢复承诺本身是否诚实。 
- 同步补入 `appendix/70-安全恢复承诺诚实性速查表`：长文已经解释了为什么 printed resume command、`--continue`、pointer、`Resuming session ...` 与 `try running the same command again` 都属于 promise surface，但实现、评审与统一安全控制台设计时更需要一张更短的承诺矩阵。把 resumable shutdown 提示、worktree-aware `--continue`、stale/invalid pointer、session-gone resume failure、transient reconnect retry、fatal reconnect invalidation、single-session pointer 写入条件与 REPL perpetual pointer 保留压成“surface / promise basis / allowed promise / invalidation trigger / required cleanup / forbidden lie / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“这里是在帮助用户，还是在对一个并不真实的恢复资格继续作出承诺”的速查表。 
- 本轮继续补入 `87-安全恢复资格签发权`：`86` 已经回答了“恢复承诺必须诚实”，但还没有继续回答“谁有资格签发或撤回这种承诺”。`bridgeMain.ts` 已经说明 printed resume command 只有在 `single-session + initialSessionId + !fatalExit` 时才会出现，说明 shutdown hint 的 signer 不是 pointer 或 session id，而是掌握退出制度语义的主流程；`--continue` 也不是让某个 pointer 文件单独宣布“可恢复”，而是先由 worktree-aware pointer resolver 选 freshest candidate，再交给 session fetch / `environment_id` 校验继续核验，说明恢复资格签发权在 Claude Code 里天然分成“候选发现权 -> 对象核验权 -> 最终承诺权”；`bridgePointer.ts` 只配做 schema/TTL/freshness 过滤，并不配单独签发最终恢复资格；另一方面，`bridgeMain.ts:2524-2540` 又说明 `may still be resumable` 这种 retry 型承诺只有 failure semantics owner 才配发，因为它依赖 transient/fatal 区分和 pointer 是否保留；`2700-2728` 与 `replBridge.ts:479-488,1595-1663` 最后还说明 pointer write/clear 本身就是恢复资格的发布/撤回动作，必须由掌握模式兼容性与完整 teardown truth 的控制层执行。这些证据合在一起已经很清楚地说明：Claude Code 不只是在治理 promise honesty，它还在治理 promise issuance authority。 
- 同步补入 `appendix/71-安全恢复资格签发权速查表`：长文已经解释了为什么 printed resume command、worktree pointer resolver、pointer validity check、session existence verifier、transient retry hint、pointer publication 与 pointer revocation 都分别属于不同层级的 signer 或 pre-signer，但实现、评审与统一安全控制台设计时更需要一张更短的签发矩阵。把这些 surface 压成“surface / signer / truth inputs / max allowed claim / forced handoff / forbidden overclaim / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“这里到底是在做 candidate filtering、verified eligibility，还是已经越权替整条控制面签发恢复资格”的速查表。 
- 本轮继续补入 `88-安全恢复资格证据门槛`：`87` 已经回答了“谁配签发恢复资格”，但还没有继续回答“signer 到底要拿到哪些最小证据，才配把候选升级成资格”。`bridgeMain.ts` 已经说明 pointer 只是第一块 entry ticket，没有 pointer 直接退出；但仅有 pointer 还不够，`resumeSessionId` 还必须先过 `validateBridgeId(...)`，再主动刷新 OAuth token，避免 expired-but-present token 把身份问题伪装成 `not found`；接着 session 必须真实存在且带 `environment_id`，否则立即清 pointer 并终止恢复；即便 session 存在，backend 返回的 env 还必须和 resume 目标一致，否则只能降级成 fresh session fallback；最后 reconnect failure 仍要继续区分 transient 与 fatal，决定是保留 pointer 还是撤回资格，而 `single-session` 模式约束又说明 mode compatibility 本身也是门槛的一部分。这些证据合在一起已经很清楚地说明：Claude Code 判断 resumability 依赖的不是单信号，而是一组最小 truth bundle。 
- 同步补入 `appendix/72-安全恢复资格证据门槛速查表`：长文已经解释了为什么 valid pointer、valid session id、fresh auth context、session existence、`environment_id`、environment continuity、reconnectability、failure semantics 与 mode compatibility 都分别属于 resumability proof bundle 的一部分，但实现、评审与统一安全控制台设计时更需要一张更短的证据矩阵。把这些 evidence piece 压成“evidence piece / owner / threshold / if missing or failed / resulting downgrade / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“当前是在根据 proof bundle 发声，还是在根据 hope bundle 发声”的速查表。 
- 本轮继续补入 `89-安全恢复资格降级语法`：`88` 已经回答了“恢复资格需要最小 truth bundle”，但还没有继续回答“当 truth bundle 的不同部分失败时，系统到底该怎么改口”。`bridgeMain.ts` 已经给出了至少七种不同结果：没有 pointer candidate 时是 `No recent session found`，这对应的是 `no-candidate`；id 非法时是 `Invalid session ID`，这对应 `invalid-candidate`；session 不存在时是 `Session ... not found`，这对应 `dead-session`；session 没有 `environment_id` 时，对应的是 `non-attachable-object`；environment mismatch 则不会压成 generic failed，而是明确降级到 `Creating a fresh session instead`；reconnect 失败还进一步分成 `retryable` 与 `fatal-nonresumable`。这些证据合在一起已经很清楚地说明：Claude Code 不只是判断恢复资格成败，它还在为恢复资格失败建立一套结果语法。 
- 同步补入 `appendix/73-安全恢复资格降级语法速查表`：长文已经解释了为什么 `no-candidate`、`invalid-candidate`、`dead-session`、`non-attachable-object`、`fresh-session-fallback`、`retryable` 与 `fatal-nonresumable` 这些结果分别对应不同 meaning、不同下一步和不同 cleanup，但实现、评审与统一安全控制台设计时更需要一张更短的降级矩阵。把这些 result 压成“resume result / meaning / next action / cleanup policy / forbidden flattening / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“系统当前是在精确改口，还是又把完全不同的失败语义重新压扁成 generic failed”的速查表。 
- 本轮继续补入 `90-安全恢复资格清理权限`：`89` 已经回答了“不同恢复失败必须被分层降级”，但还没有继续回答“这些不同结果到底谁有权清理恢复 carrier”。`bridgeMain.ts` 已经说明 resumable shutdown 时要 early return，禁止 archive+deregister 与 pointer clear；而真正 archive+deregister 之后才会 clear pointer，说明 clean exit 下的 `clear` 发生在退役真相之后；没有 `--continue` 时清 pointer 是主流程基于“旧 crash 残留不应 linger”作出的 startup-level 清理；`!session`、`!environment_id` 这类对象级失败则由 verifier 层清 `resumePointerDir`；`transient` reconnect failure 明确禁止清 pointer，因为 pointer 本身就是 retry mechanism，而 `fatal` 才允许清；`replBridge.ts` 又进一步说明 perpetual suspend 不只是不清，甚至会刷新 pointer mtime，反过来 non-perpetual clean exit 才会在 archive+deregister 之后 clear；`bridgePointer.ts` 则把 carrier 自清理权限制在 schema invalid / TTL stale 这类硬门槛。这些证据合在一起已经很清楚地说明：Claude Code 不把 clear pointer 当 housekeeping，而是把它当恢复资格的撤回权来治理。 
- 同步补入 `appendix/74-安全恢复资格清理权限速查表`：长文已经解释了为什么 stale/invalid pointer、fresh-start leftover pointer、dead-session pointer、non-attachable-object pointer、transient reconnect pointer、fatal reconnect pointer、resumable shutdown pointer 与 non-perpetual clean-exit pointer 分别由不同 clearer 拥有不同 clear trigger，但实现、评审与统一安全控制台设计时更需要一张更短的清理权限矩阵。把这些 carrier 压成“carrier / clearer / clear trigger / why this layer owns clearing / forbidden premature clear / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“这次 clear 到底是合理撤权，还是某个局部层在越权提前抹掉仍真实存在的恢复资格”的速查表。 
- 本轮继续补入 `91-安全恢复资产保全义务`：`90` 已经回答了“谁有权清理恢复资格”，但还没有继续回答“在资格尚未被正式撤回前，哪些恢复资产反而必须被制度性保留”。`bridgeMain.ts` 已经说明 resumable shutdown 不是简单地“不清”，而是故意保留 session、environment、pointer 和 `--continue` 提示这一整套恢复资产；transient reconnect failure 也明确要求保留 pointer，因为它本身就是 retry mechanism；`replBridge.ts` 则说明 perpetual suspend 不只是避免清理，还要 refresh pointer mtime，以免长时会话失去 recoverability；同文件对 pointer 的定义也是 `recoverable trail`，表明它本身就是事故恢复资产；而 `bridgePointer.ts` 又表明系统默认是“先保留，除非证明 stale/invalid”，并非“先清掉，除非证明还该留”；`bridgeMain.ts:2316-2326` 最后又补齐边界：只有当前主路径已明确不再承认它相关时，旧 pointer 才应被清掉。这些证据合在一起已经很清楚地说明：Claude Code 不只是在治理撤回权，它还在治理恢复资产的保全义务。 
- 同步补入 `appendix/75-安全恢复资产保全义务速查表`：长文已经解释了为什么 resumable shutdown 保留的 session/environment、transient reconnect pointer、REPL perpetual pointer、crash-recovery pointer、pointer freshness 与 fresh-start leftover pointer 分别由不同 preservation owner 管辖，并具有不同 expiry basis，但实现、评审与统一安全控制台设计时更需要一张更短的保全矩阵。把这些 asset 压成“asset / preservation owner / why preserve / expiry basis / forbidden early loss / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“当前系统到底是在合理保全仍真实存在的恢复利益，还是在过早丢失恢复资产”的速查表。 
- 本轮继续补入 `92-安全恢复资产续保协议`：`91` 已经回答了“哪些恢复资产必须被保留”，但还没有继续回答“这些资产何时仍算新鲜、何时会因为缺乏续保而被时间性误杀”。`bridgePointer.ts` 已经明确把 staleness anchor 绑定到 file `mtime`，并说明这样做是为了和 backend rolling `BRIDGE_LAST_POLL_TTL = 4h` 对齐；pointer write 也明确支持同内容重写以 bump staleness clock，说明续保是正式协议动作；`replBridge.ts` 又在 work dispatch 时自动 refresh pointer mtime，让活跃会话自然积累 freshness proof；但对 idle 的 perpetual 边界，作者又额外引入 hourly timer，因为仅靠用户 prompt 驱动的刷新不足以保护 idle-but-live 边界；suspend 前还会额外补写一次 freshness proof，避免会话带着旧时效进入 suspend；`bridgeMain.ts` 最后在 standalone path 上复用了同样的 hourly refresh 设计，而 `bridgePointer.ts` 的 freshest 选择又进一步说明 freshness proof 不只决定真假，还决定多份恢复资产之间的仲裁优先级。这些证据合在一起已经很清楚地说明：Claude Code 不只是在保留恢复资产，它还在持续续保这些资产的时效证明。 
- 同步补入 `appendix/76-安全恢复资产续保协议速查表`：长文已经解释了为什么 crash-recovery pointer、high-activity REPL pointer、idle perpetual pointer、suspend checkpoint pointer、standalone pointer、多 worktree candidate set 与 backend-aligned liveness proof 都分别依赖不同 freshness signal 和 refresh cadence，但实现、评审与统一安全控制台设计时更需要一张更短的续保矩阵。把这些 asset 压成“asset / freshness signal / refresh cadence / freshness owner / stale consequence / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“当前恢复资产是否真的仍新鲜可信，还是已经在时间维度上悄悄退化成伪资产”的速查表。 
- 本轮继续补入 `93-安全恢复新鲜度仲裁`：`92` 已经回答了“恢复资产必须持续续保 freshness proof”，但还没有继续回答“多个候选同时存在时，到底谁代表当前活边界”。`bridgeMain.ts` 已明确把当前目录定位为 fast path，并在 miss 后 fanout 到 git worktree siblings；`bridgePointer.ts` 又把 stale / invalid candidate 在入场前就清出候选集，说明新鲜度比较之前先有 admission gate；同文件最后明确以 `ageMs` 最低者为 freshest winner，说明 freshness 不只判断真假，还决定 winner priority；`replBridge.ts` 则进一步表明 even prior pointer 也要先过 `source === 'repl'` 的制度同类性过滤；`bridgeMain.ts` 还把 winner 的 `pointerDir` 一路带到 deterministic failure 清理分支，确保 dead-session / no-environment / fatal reconnect failure 时能精确撤销刚才胜出的 carrier，而 transient reconnect failure 又明确保留 pointer，说明恢复仲裁真正治理的不是“某次 lookup 是否成功”，而是“哪个候选仍保有恢复价值”。这些证据合在一起已经很清楚地说明：Claude Code 的恢复控制面不是按路径亲缘选入口，而是按候选合法性与活性新鲜度仲裁谁有资格代表当前边界。 
- 同步补入 `appendix/77-安全恢复新鲜度仲裁速查表`：长文已经解释了为什么 current-dir pointer、sibling-worktree pointer、stale / invalid candidate、wrong-source prior pointer、selected winner provenance、dead-session winner、no-environment winner、transient reconnect failure 与 fatal reconnect failure 分别服从不同的 admission gate、winner rule 与 loser handling，但实现、评审与统一安全控制台设计时更需要一张更短的仲裁矩阵。把这些对象压成“candidate / admission gate / arbitration basis / winner rule / loser handling / forbidden shortcut / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“系统当前到底是在选出最能证明边界仍活着的候选，还是又把路径偶然性误当成恢复真相”的速查表。 
- 本轮继续补入 `94-安全恢复资格对象`：`93` 已经回答了“多个候选中谁胜出”，但还没有继续回答“被胜出、被续保、被撤销的到底是什么对象”。`bridgePointer.ts` 已经说明 pointer 即使存在，也必须继续通过 schema 与 TTL 才配代表恢复资格；`bridgeMain.ts` 又进一步说明 session 不存在、没有 `environment_id` 或 environment 已换届时，本地 pointer 不足以维持原恢复资格，必须服从服务端边界真相；`replBridge.ts` 则把同一边界连续性和旧边界归档写得更清楚，说明系统保护的不是“任一还能跑的 transport / session”，而是“原边界下的继续行动权”；`useManagePlugins.ts` 与 `refresh.ts` 又给出第二组强证据：plugin 文件已变化并不等于能力已激活，真正合法的恢复是完整的 Layer-3 refresh；`utils.ts` 与 `useManageMCPConnections.ts` 最后再给出第三组强证据：MCP client 即使仍在内存，只要 config 缺席或 hash 已变，就必须被视为 stale 并送回 reconnect / pending 流程。这些证据合在一起已经很清楚地说明：Claude Code 保护的不是恢复工件，而是这些工件背后那份仍被当前边界承认的继续行动权。 
- 同步补入 `appendix/78-安全恢复资格对象速查表`：长文已经解释了为什么 crash-recovery pointer、resumed bridge session、active plugin capability set、MCP server capability set 与 reconnecting bridge transport 分别具有不同的 boundary binding、freshness proof、revocation gate 与 regrant path，但实现、评审与统一安全控制台设计时更需要一张更短的对象矩阵。把这些对象压成“artifact / boundary binding / freshness proof / revocation gate / regrant path / forbidden shortcut / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“系统当前治理的到底只是工件残留，还是工件背后那份真正的 entitlement object”的速查表。 
- 在 `66-安全恢复续租失败分级` 之后，再补一个 `appendix/50-安全恢复续租失败分级速查表` 就很自然了：长文已经解释了为什么不同 lease failure 必须分层表达剩余恢复能力，但实现、评审与恢复路径设计时更需要一张更短的失败梯子矩阵。把 `hidden`、`pending`、`reconnecting`、`auth_failed`、`failed`、`stale` 压成“lease failure type / 典型状态 / recovery capacity / next repair path / 为什么不能压成 generic failed / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“系统是否把剩余恢复能力完全不同的失败状态压扁了”的速查表。 
- 在 `65-安全恢复续租信号` 之后，再补一个 `appendix/49-安全恢复续租信号速查表` 就很自然了：长文已经解释了为什么绿色词必须靠 heartbeat、poll、refresh、recheck 持续续租，但实现、评审与状态机设计时更需要一张更短的续租矩阵。把 worker `idle` / 存活类绿色词、crash-recovery pointer 的 `fresh/resumable`、active work 健康租约、task completion 后可隐藏的绿色词，以及 notification 前景词压成“lexicon / renewal signal / cadence / failure branch / 为什么需要续租 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“某个绿色词有没有绑定明确续租信号与失败分支”的速查表。 
- 在 `64-安全恢复绿色词租约` 之后，再补一个 `appendix/48-安全恢复绿色词租约速查表` 就很自然了：长文已经解释了为什么大多数绿色词更像租约而不是产权，但实现、评审与状态语义设计时更需要一张更短的租约矩阵。把 immediate notification 前景词、任务完成后的“可隐藏”正向词、`Remote Control active`、`/status` 的 `Connected to ...`、`n connected` 以及更高层 signer 的 `resolved` 压成“positive lexicon / renewal condition / revocation trigger / lease length / 为什么只是租约 / 关键证据”之后，安全专题就第一次拥有了一张可直接用于审查“短租约绿色词有没有被误说成长期承诺”的速查表。 
- 继续往前推进后，可以更明确地把 `57-安全恢复清理权限边界` 单独写出来：`56` 已经回答了未闭环恢复必须保留痕迹，但还没有回答“这些痕迹到底谁有权删”。`notifications.tsx` 已经把提示清理限制在 timeout、`invalidates` 和 `removeNotification` 这类窄权限里；`refresh.ts` 则把 `needsRefresh=false` 严格绑在 `refreshActivePlugins()` 这一条真正消费闭环的路径上，`useManagePlugins.ts` 还明确说不得在别处 reset；`PluginInstallationManager.ts` 进一步说明 auto-refresh 失败时只能把清理权退回挂起态，而不能假清理；`useManageMCPConnections.ts` 同样把 reconnect timer、pending、failed 的清理权限制在成功、最终失败或显式域内动作上；`bridgeMain.ts` 最后则把 pointer 清理权收得更高，只在 archive+deregister、stale、fatal 等高权场景才清。这些证据合在一起已经很清楚地说明：恢复痕迹不是普通 UI 状态，而是带有清理权限边界的控制对象，下一代统一安全控制台必须把“谁有权忘记失败”正式做成一条权限规则。 
