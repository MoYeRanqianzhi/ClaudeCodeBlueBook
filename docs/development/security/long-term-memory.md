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
- `147-161`: `receipt -> completion -> finality -> forgetting -> liability release -> archive close -> audit close -> irreversible erasure -> retention governance -> retention enforcement honesty -> cleanup isolation -> artifact-family cleanup constitution -> artifact-family cleanup rationale -> artifact-family cleanup metadata -> artifact-family cleanup runtime-conformance` signer/governor/honesty/isolation/constitution/rationale/metadata/conformance ladder

## 当前最值得继续深化的候选

- 候选 `162`
  方向：`artifact-family cleanup runtime-conformance signer` 仍不等于 `artifact-family cleanup anti-drift verifier signer`
  原因：`161` 已经证明即便 runtime 可能执行，也还缺正式的 family-by-family conformance receipt，更缺一层去持续校验 scheduler、executor、permission、resume 与 metadata 没有再次分叉。也就是：谁配长期验证 temporal gap、propagation gap 与 receipt gap 是否被真正修复，而不是只在某次运行中暂时看起来符合
  证据起点：`src/utils/cleanup.ts`、`src/utils/backgroundHousekeeping.ts`、`src/utils/sessionStorage.ts`、`src/utils/plans.ts`、`src/utils/permissions/filesystem.ts`、`src/utils/settings/types.ts` 当前展示的延迟、跳过、传播与回执缺口

## 持续约束

- 以后如果安全正文再次出现“下一步最自然的延伸就是”“最值钱的候选”这类句式，应优先迁回本文件，而不是继续留在正文。
- 如果某条未来设计推论直接回答的是 Claude Code 机制本体，例如字段为什么要升级、signer 为什么要继续拆层，可以留在正文。
- 如果某条推论主要回答的是蓝皮书接下来该怎么写、该往哪个目录继续长，就写到这里。
