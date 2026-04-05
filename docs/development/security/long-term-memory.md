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
- `147-159`: `receipt -> completion -> finality -> forgetting -> liability release -> archive close -> audit close -> irreversible erasure -> retention governance -> retention enforcement honesty -> cleanup isolation -> artifact-family cleanup constitution -> artifact-family cleanup rationale` signer/governor/honesty/isolation/constitution/rationale ladder

## 当前最值得继续深化的候选

- 候选 `160`
  方向：`artifact-family cleanup rationale signer` 仍不等于 `artifact-family cleanup metadata signer`
  原因：`159` 已经证明不同 family 的制度理由目前散落在 path、permission、resume、comment 与 cleanup helper 的组合里，且 `plansDirectory` 与 `cleanupOldPlanFiles()` 已经暴露理由漂移。所以下一层更值钱的问题不再只是“为什么这些 family 应该不同”，而是“谁来把 family duty、reader scope、recovery duty、cleanup root 与 drift check 正式对象化”，否则制度理由仍会继续作为隐式 folklore 存活
  证据起点：`src/utils/plans.ts`、`src/utils/cleanup.ts`、`src/utils/permissions/filesystem.ts`、`src/utils/sessionEnvironment.ts`、`src/utils/fileHistory.ts` 与 `src/utils/settings/types.ts` 之间目前分散承载 rationale 的位置

## 持续约束

- 以后如果安全正文再次出现“下一步最自然的延伸就是”“最值钱的候选”这类句式，应优先迁回本文件，而不是继续留在正文。
- 如果某条未来设计推论直接回答的是 Claude Code 机制本体，例如字段为什么要升级、signer 为什么要继续拆层，可以留在正文。
- 如果某条推论主要回答的是蓝皮书接下来该怎么写、该往哪个目录继续长，就写到这里。
