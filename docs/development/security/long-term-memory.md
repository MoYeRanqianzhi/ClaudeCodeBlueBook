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
- `147-162`: `receipt -> completion -> finality -> forgetting -> liability release -> archive close -> audit close -> irreversible erasure -> retention governance -> retention enforcement honesty -> cleanup isolation -> artifact-family cleanup constitution -> artifact-family cleanup rationale -> artifact-family cleanup metadata -> artifact-family cleanup runtime-conformance -> artifact-family cleanup anti-drift verification` signer/governor/honesty/isolation/constitution/rationale/metadata/conformance/verifier ladder

## 当前最值得继续深化的候选

- 候选 `163`
  方向：`artifact-family cleanup anti-drift verifier signer` 仍不等于 `artifact-family cleanup repair-governor signer`
  原因：`162` 已经证明 cleanup 线真正缺的是显式 verifier grammar；但 verifier 即便补出，也只配发现 drift、拒绝沉默与签发报警，并不自动拥有修复主权。也就是：谁配决定应修 metadata、修 scheduler、修 executor、修 permission plane，还是改文案降级承诺，仍是另一层 governance 问题
  证据起点：`src/services/compact/microCompact.ts`、`src/bootstrap/state.ts`、`src/utils/permissions/permissionSetup.ts` 与 cleanup 线当前的 gap 形成的正反对照：当前可见代码证明 verifier 与 repair 在 repo 其他子系统也不是同一动作

## 持续约束

- 以后如果安全正文再次出现“下一步最自然的延伸就是”“最值钱的候选”这类句式，应优先迁回本文件，而不是继续留在正文。
- 如果某条未来设计推论直接回答的是 Claude Code 机制本体，例如字段为什么要升级、signer 为什么要继续拆层，可以留在正文。
- 如果某条推论主要回答的是蓝皮书接下来该怎么写、该往哪个目录继续长，就写到这里。
