# 安全专题长期记忆

## 当前稳定边界

- `bluebook/security/` 正文不再承载“下一步写什么”“后续应新增哪章”“这一链条应视作几段小循环”这类推进记忆。
- `bluebook/security/appendix/` 只承载速查矩阵，不承载章节推进提示。
- `bluebook/security/source-notes/` 只承载单机制源码剖面，不承载研究推进日志。
- 安全专题后续候选、目录编排判断与编辑规则统一沉淀到 `docs/development/security/`。
- `154` 已经稳定写出一条新边界：`read-path filtering`、`semantic removal`、`local rewrite`、`workspace rewind delete` 与 `retention cleanup` 不是同一种删除，`audit close` 也因此不能越级冒充 `irreversible erasure`。
- `155` 已经稳定写出另一条治理边界：`cleanupPeriodDays` 的声明、settings merge、intent honesty guard、housekeeping scheduler 与 destructive executor 不是同一层，`irreversible erasure` 也因此不能越级冒充 `retention governance`。
- `156` 已经稳定写出执行诚实性边界：retention declaration、future-write suppression、runtime scheduling、cleanup execution 与 post-hoc side-effect explanation 不是同一层，`retention governance` 也因此不能越级冒充 `retention enforcement honesty`。
- `157` 已经稳定写出清理隔离边界：task-output isolation repair、project-dir cleanup sweep、shared temp readability 与 live-session ledger 不是同一层，`retention enforcement honesty` 也因此不能越级冒充 `cleanup isolation`。
- `158` 已经稳定写出家族宪法边界：task outputs、scratchpad、tool-results、transcripts、plans、file-history 与 session-env 当前处在多种 cleanup constitution 并存的世界里，`cleanup isolation` 也因此不能越级冒充 `artifact-family cleanup constitution`。
- `159` 已经稳定写出制度理由边界：不同 artifact family 不只是活在不同 cleanup constitution 里，还活在不同 risk object、reader scope、recovery duty 与 host visibility 下；尤其 `plansDirectory` 与 `cleanupOldPlanFiles()` 的不对称已经暴露出 storage rationale 与 cleanup rationale 可能漂移，`artifact-family cleanup constitution` 也因此不能越级冒充 `artifact-family cleanup rationale`。
- `160` 已经稳定写出制度元数据边界：不同 artifact family 的制度理由虽然已经存在，但仍主要散落在 path helper、permission helper、resume helper、settings schema、注释与 cleanup dispatcher 之间；`cleanupOldMessageFilesInBackground()` 的硬编码调度与 `plansDirectory` 的传播失灵已经说明 `artifact-family cleanup rationale` 仍不能越级冒充 `artifact-family cleanup metadata`。
- `161` 已经稳定写出运行时符合性边界：即便 metadata signal 存在，runtime 仍可能展示 temporal gap、propagation gap 与 receipt gap；`cleanupPeriodDays=0` 的“startup delete”文案、`shouldSkipPersistence()` 的即时抑写、`backgroundHousekeeping` 的延迟调度、validation skip 与 `CleanupResult` 的未汇总共同说明 `artifact-family cleanup metadata` 仍不能越级冒充 `artifact-family cleanup runtime-conformance`。
- `162` 已经稳定写出反漂移验证边界：一次 runtime conform 仍不等于系统已经具备长期 anti-drift verification；`microCompact.ts` 的 source-of-truth test、`switchSession()` 的原子防漂移与 `verifyAutoModeGateAccess()` 的 live re-verification 共同构成 repo 的正对照，而 cleanup 线当前仍缺同等级 verifier，因此 `artifact-family cleanup runtime-conformance` 仍不能越级冒充 `artifact-family cleanup anti-drift verification`。
- `163` 已经稳定写出修复治理边界：repo 在 auto-mode 与 plugin 线已明确展示 verification 与 governance consequence 的分层，但 cleanup 线当前仍未正式分配 drift 报警后的 repair authority；因此 `artifact-family cleanup anti-drift verification` 仍不能越级冒充 `artifact-family cleanup repair-governance`。
- `164` 已经稳定写出迁移治理边界：repo 在模型、配置键、插件缓存与 plan continuity 上已明确展示 migration governance 的存在，说明决定“怎么修”与决定“旧世界怎样退场”仍然是两层主权；因此 `artifact-family cleanup repair-governance` 仍不能越级冒充 `artifact-family cleanup migration-governance`。
- `165` 已经稳定写出退役治理边界：repo 在模型退役日期、迁移通知、legacy runtime remap、plugin orphan grace window 与 search visibility cutoff 上已明确展示 sunset governance 的存在，说明决定“旧世界怎样过渡”与决定“兼容期何时正式结束”仍然是两层主权；因此 `artifact-family cleanup migration-governance` 仍不能越级冒充 `artifact-family cleanup sunset-governance`。
- `166` 已经稳定写出墓碑治理边界：repo 在 `tombstone` messages、`.orphaned_at` markers、marker-driven exclusion grammar 与 migration timestamps 上已明确展示 tombstone governance 的存在，说明决定“旧世界何时结束”与决定“结束后还留下什么最小残留标记”仍然是两层主权；因此 `artifact-family cleanup sunset-governance` 仍不能越级冒充 `artifact-family cleanup tombstone-governance`。
- `167` 已经稳定写出复活治理边界：repo 在 authoritative marker clearing、Layer-3 plugin refresh、`needsRefresh` / `/reload-plugins`、plan recovery 与 forked new-slug policy 上已明确展示 resurrection governance 的存在，说明决定“结束后留什么墓碑”与决定“旧对象怎样重新回到 current world”仍然是两层主权；因此 `artifact-family cleanup tombstone-governance` 仍不能越级冒充 `artifact-family cleanup resurrection-governance`。
- `168` 已经稳定写出再赋权治理边界：repo 在 `deletePluginOptions()`、`setPluginEnabledOp()`、policy blocking、settings divergence guard 与 `copyPlanForFork()` 的 new-slug policy 上已明确展示 re-entitlement governance 的存在，说明决定“旧对象怎样回来”与决定“回来后恢复哪些旧资格”仍然是两层主权；因此 `artifact-family cleanup resurrection-governance` 仍不能越级冒充 `artifact-family cleanup re-entitlement-governance`。
- `169` 已经稳定写出重配置治理边界：repo 在 `savePluginOptions()`、`getUnconfiguredOptions()`、`saveMcpServerUserConfig()`、`getUnconfiguredChannels()`、`needs-config` 与 `PluginOptionsFlow` / `ManagePlugins` 的 `configured / skipped / take effect` grammar 上已明确展示 reconfiguration governance 的存在，说明决定“对象回来后是否重新具备资格”与决定“它拿回资格后按哪组 current config 重新工作”仍然是两层主权；因此 `artifact-family cleanup re-entitlement-governance` 仍不能越级冒充 `artifact-family cleanup reconfiguration-governance`。
- `170` 已经稳定写出重新激活治理边界：repo 在 `refreshActivePlugins()` 的 Layer-3 refresh primitive、`/reload-plugins` 的 take-effect contract、`useManagePlugins()` 的 `needsRefresh` discipline、`PluginInstallationManager` 的 mode-sensitive auto-refresh policy 与 `print.ts` 的 headless auto-consume path 上已明确展示 reactivation governance 的存在，说明决定“当前 config truth 是什么”与决定“这组 truth 何时真正接管 running session”仍然是两层主权；因此 `artifact-family cleanup reconfiguration-governance` 仍不能越级冒充 `artifact-family cleanup reactivation-governance`。
- `171` 已经稳定写出就绪治理边界：repo 在 `MCPServerConnection` 的 `connected / pending / needs-auth / failed / disabled` 联合状态机、`pluginReconnectKey` 触发的 pending 初始化、`useMcpConnectivityStatus()` 与 `/mcp` health 的失败/鉴权显化、`ReadMcpResourceTool` 的 connected hard gate，以及 `toolExecution.ts` 对 connected client 的运行时降级路径上已明确展示 readiness governance 的存在，说明决定“新的 truth 何时接管 active world”与决定“这个 active world 何时真正可用”仍然是两层主权；因此 `artifact-family cleanup reactivation-governance` 仍不能越级冒充 `artifact-family cleanup readiness-governance`。
- `172` 已经稳定写出连续性治理边界：repo 在 `useManageMCPConnections.ts` 的 auto-reconnect/backoff/give-up/cancel path、stale reconnect timer 清理、manual reconnect 与 toggle control、`toolExecution.ts` 对 connected client 的运行时 readiness 撤销，以及 `print.ts` 对 pending/failed SDK clients 的 pool-level re-init 上已明确展示 continuity governance 的存在，说明决定“这个 active world 现在能不能用”与决定“这种可用性在时间里怎样继续成立”仍然是两层主权；因此 `artifact-family cleanup readiness-governance` 仍不能越级冒充 `artifact-family cleanup continuity-governance`。
- `173` 已经稳定写出恢复治理边界：repo 在 `handleRemoteAuthFailure()` 的 `needs-auth` demotion 与 auth cache、`reconnectMcpServerImpl()` 的 fresh keychain/cache reconnect、`performMCPOAuthFlow()` 的 silent/interactive 凭据闭环、`print.ts` 对 `mcp_reconnect` / `mcp_authenticate` / `mcp_oauth_callback_url` 的分层 choreography，以及 `McpAuthTool` / `MCPReconnect` 对 consumer-side result 的 discipline 上已明确展示 recovery governance 的存在，说明决定“旧线还要不要继续”与决定“什么新的证据足以重新宣布它已经回来”仍然是两层主权；因此 `artifact-family cleanup continuity-governance` 仍不能越级冒充 `artifact-family cleanup recovery-governance`。
- `174` 已经稳定写出重新并入治理边界：repo 在 `reconnectMcpServerImpl()` 的 raw recovery result、`useManageMCPConnections.ts` 的 `onConnectionAttempt()` / `updateServer()` / `registerElicitationHandler()`、`print.ts` 对 `appState` / `dynamicMcpState` 的 reinsertion、`buildAllTools()` / `buildMcpServerStatuses()` 的 consumer read model，以及 `reregisterChannelHandlerAfterReconnect()` 与 `McpAuthTool` 的 pseudo-tool replacement 上已明确展示 reintegration governance 的存在，说明决定“恢复是否成立”与决定“恢复后的真相何时重新成为当前世界的一部分”仍然是两层主权；因此 `artifact-family cleanup recovery-governance` 仍不能越级冒充 `artifact-family cleanup reintegration-governance`。
- `175` 已经稳定写出重新投影治理边界：repo 在 `buildMcpServerStatuses()` 的 control projection、`ManagePlugins.tsx` / `MCPListPanel.tsx` 的 status grammar、`useMcpConnectivityStatus()` 的 selective notification policy、`handlers/mcp.tsx` 的 health glyph grammar，以及 `MCPReconnect.tsx` 与 control response envelope 的 action/status copy 上已明确展示 reprojection governance 的存在，说明决定“恢复后的对象何时重新成为当前世界的一部分”与决定“这份当前真相怎样被不同 reader surface 重新讲述”仍然是两层主权；因此 `artifact-family cleanup reintegration-governance` 仍不能越级冒充 `artifact-family cleanup reprojection-governance`。
- `176` 已经稳定写出重新担保治理边界：repo 在 `McpAuthTool` 的 graded positive lexicon、`MCPRemoteServerMenu` 的 `Authentication successful` branching 与 `manual restart` caveat、`MCPReconnect` 的 operation-local success copy、`handlers/mcp.tsx` 的 narrow health glyph grammar，以及 `useMcpConnectivityStatus()` 的 selective negative publication policy 上已明确展示 reassurance governance 的存在，说明决定“这份当前真相怎样被不同 reader surface 重新讲述”与决定“这些讲述里哪些现在配承载多强的继续依赖担保”仍然是两层主权；因此 `artifact-family cleanup reprojection-governance` 仍不能越级冒充 `artifact-family cleanup reassurance-governance`。
- `177` 已经稳定写出用时重验证治理边界：repo 在 `ReadMcpResourceTool` 的 `connected` hard gate、`ListMcpResourcesTool` 的 `ensureConnectedClient` fresh reconnect 注释、`ensureConnectedClient()` 的 reconnect-or-throw primitive，以及 `toolExecution.ts` 的 current-context filter 与 `McpAuthError -> needs-auth` demotion 上已明确展示 use-time revalidation governance 的存在，说明决定“哪些 surface 现在配给出多强的正向 reassurance”与决定“真正 consumer 在使用瞬间是否已经重新拿到 fresh enough 的 current-use proof”仍然是两层主权；因此 `artifact-family cleanup reassurance-governance` 仍不能越级冒充 `artifact-family cleanup use-time revalidation-governance`。
- `178` 已经稳定写出 step-up 重授权治理边界：repo 在 `wrapFetchWithStepUpDetection()` 的 `403 insufficient_scope` detection、`ClaudeAuthProvider.tokens()` 的 refresh-token suppression、`markStepUpPending()` 的 pending scope 记录、`performMCPOAuthFlow()` 对 cached step-up scope 的复用，以及 `client.ts` 在真实 transport fetch 上挂接 step-up detection 的做法上已明确展示 step-up reauthorization governance 的存在，说明决定“真正 consumer 在使用瞬间是否已经 fresh enough to use”与决定“这份 fresh proof 对当前更强请求的 authority level 是否已经足够”仍然是两层主权；因此 `artifact-family cleanup use-time revalidation-governance` 仍不能越级冒充 `artifact-family cleanup step-up reauthorization-governance`。

## 本轮已净化的正文段

本轮已经从 `bluebook/security/` 中移除统一模式的尾段元信息，覆盖三段主线：

1. `41-67`
   完成差异、恢复 signer、留痕、清理、词法与续租链
2. `95-105`
   资格重签发、中间态、承诺上限、默认动作路由、错误路径禁令与投影协议链
3. `154-168`
   cleanup signer ladder 的尾段作者推进记忆已改写成源码锚定的苏格拉底自我约束，不再把下一候选、下一层目录计划或 future control-plane roadmap 混进正文

这些章节现在只保留主论证、技术启示和结语，不再自带未来章节编排提示。

## 当前安全主线分段记忆

- `41-49`: 完成差异控制面与宿主盲区显化
- `50-67`: 恢复 signer、留痕、清理、词法与续租治理
- `95-105`: 资格生命周期、承诺上限与投影协议
- `147-178`: `receipt -> completion -> finality -> forgetting -> liability release -> archive close -> audit close -> irreversible erasure -> retention governance -> retention enforcement honesty -> cleanup isolation -> artifact-family cleanup constitution -> artifact-family cleanup rationale -> artifact-family cleanup metadata -> artifact-family cleanup runtime-conformance -> artifact-family cleanup anti-drift verification -> artifact-family cleanup repair-governance -> artifact-family cleanup migration-governance -> artifact-family cleanup sunset-governance -> artifact-family cleanup tombstone-governance -> artifact-family cleanup resurrection-governance -> artifact-family cleanup re-entitlement-governance -> artifact-family cleanup reconfiguration-governance -> artifact-family cleanup reactivation-governance -> artifact-family cleanup readiness-governance -> artifact-family cleanup continuity-governance -> artifact-family cleanup recovery-governance -> artifact-family cleanup reintegration-governance -> artifact-family cleanup reprojection-governance -> artifact-family cleanup reassurance-governance -> artifact-family cleanup use-time revalidation-governance -> artifact-family cleanup step-up reauthorization-governance` signer/governor/honesty/isolation/constitution/rationale/metadata/conformance/verifier/repair/migration/sunset/tombstone/resurrection/re-entitlement/reconfiguration/reactivation/readiness/continuity/recovery/reintegration/reprojection/reassurance/revalidation/reauthorization ladder

## 当前最值得继续深化的候选

- `176` 已经稳定写出重新担保治理边界。下一候选暂不固化。
- `177` 已经稳定写出用时重验证治理边界。下一候选仍暂不固化。
- `178` 已经稳定写出 step-up 重授权治理边界。下一候选仍暂不固化。
- 当前只稳定保留一个 open question：在 step-up reauthorization 之上，repo 是否还存在更强的 `reattestation / durable reliance authorization` 层。现有证据已经足以说明 positive reassurance、live-use revalidation 与 stronger-scope reauthorization 被拆成三层，但还不足以证明 repo 已经出现独立的 cross-consumer stronger attestation signer。
- 继续观察的证据起点：`wrapFetchWithStepUpDetection()` 的 `insufficient_scope` detection、`tokens()` 的 refresh suppression、cached `stepUpScope` continuation 已经证明 live use 不等于 higher-authority success；但是否还要继续上提到更强的 durable reliance authorization，目前仍不应提前写回正文标题。

## 持续约束

- 以后如果安全正文再次出现“下一步最自然的延伸就是”“最值钱的候选”这类句式，应优先迁回本文件，而不是继续留在正文。
- 如果某条未来设计推论直接回答的是 Claude Code 机制本体，例如字段为什么要升级、signer 为什么要继续拆层，可以留在正文。
- 如果某条推论主要回答的是蓝皮书接下来该怎么写、该往哪个目录继续长，就写到这里。
