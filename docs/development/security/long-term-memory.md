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

## 本轮已净化的正文段

本轮已经从 `bluebook/security/` 中移除统一模式的尾段元信息，覆盖两段主线：

1. `41-67`
   完成差异、恢复 signer、留痕、清理、词法与续租链
2. `95-105`
   资格重签发、中间态、承诺上限、默认动作路由、错误路径禁令与投影协议链

这些章节现在只保留主论证、技术启示和结语，不再自带未来章节编排提示。

## 当前安全主线分段记忆

- `41-49`: 完成差异控制面与宿主盲区显化
- `50-67`: 恢复 signer、留痕、清理、词法与续租治理
- `95-105`: 资格生命周期、承诺上限与投影协议
- `147-167`: `receipt -> completion -> finality -> forgetting -> liability release -> archive close -> audit close -> irreversible erasure -> retention governance -> retention enforcement honesty -> cleanup isolation -> artifact-family cleanup constitution -> artifact-family cleanup rationale -> artifact-family cleanup metadata -> artifact-family cleanup runtime-conformance -> artifact-family cleanup anti-drift verification -> artifact-family cleanup repair-governance -> artifact-family cleanup migration-governance -> artifact-family cleanup sunset-governance -> artifact-family cleanup tombstone-governance -> artifact-family cleanup resurrection-governance` signer/governor/honesty/isolation/constitution/rationale/metadata/conformance/verifier/repair/migration/sunset/tombstone/resurrection ladder

## 当前最值得继续深化的候选

- 候选 `168`
  方向：`artifact-family cleanup resurrection-governor signer` 仍不等于 `artifact-family cleanup re-entitlement-governor signer`
  原因：`167` 已经证明旧对象回来需要单独的 resurrection authority；但对象回来，并不自动回答它是否恢复旧 identity、旧配置、旧 secrets、旧 scope 与旧可用资格。也就是：谁配决定 resurrected path、promise、receipt 是否重新获得旧 entitlement，这仍是另一层 re-entitlement governance 问题
  证据起点：`src/utils/plugins/pluginOptionsStorage.ts` 的 `deletePluginOptions()`、`src/services/plugins/pluginOperations.ts` 的 `setPluginEnabledOp()`、`src/utils/plans.ts` 的 `copyPlanForFork()` 与 cleanup 线潜在的旧 path / old receipt 世界形成对照：repo 已展示对象可回来，但“回来后算不算原来的那个可用对象”仍是另一层主权

## 持续约束

- 以后如果安全正文再次出现“下一步最自然的延伸就是”“最值钱的候选”这类句式，应优先迁回本文件，而不是继续留在正文。
- 如果某条未来设计推论直接回答的是 Claude Code 机制本体，例如字段为什么要升级、signer 为什么要继续拆层，可以留在正文。
- 如果某条推论主要回答的是蓝皮书接下来该怎么写、该往哪个目录继续长，就写到这里。
