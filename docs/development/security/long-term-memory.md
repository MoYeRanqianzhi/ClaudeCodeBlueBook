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
- `147-158`: `receipt -> completion -> finality -> forgetting -> liability release -> archive close -> audit close -> irreversible erasure -> retention governance -> retention enforcement honesty -> cleanup isolation -> artifact-family cleanup constitution` signer/governor/honesty/isolation/constitution ladder

## 当前最值得继续深化的候选

- 候选 `159`
  方向：`artifact-family cleanup constitution signer` 仍不等于 `artifact-family cleanup rationale signer`
  原因：`158` 已经证明当前 repo 是多宪法并存，而非统一删除法。但下一层更值钱的问题不再只是“它们不同”，而是“为什么这些 family 必须不同”。也就是：谁配解释 task outputs/scratchpad 走 temp-dir session constitution，而 plans、file-history、session-env、tool-results、transcripts 分别落在别的 constitution 上；这需要从风险对象、恢复职责、读者范围与宿主可见性重新抽象每个 family 的制度理由
  证据起点：`src/utils/task/diskOutput.ts`、`src/utils/permissions/filesystem.ts`、`src/utils/toolResultStorage.ts`、`src/utils/sessionStorage.ts`、`src/utils/plans.ts` 与 `src/utils/cleanup.ts` 中不同 family 的存储作用域、权限注释与 cleanup root 设计

## 持续约束

- 以后如果安全正文再次出现“下一步最自然的延伸就是”“最值钱的候选”这类句式，应优先迁回本文件，而不是继续留在正文。
- 如果某条未来设计推论直接回答的是 Claude Code 机制本体，例如字段为什么要升级、signer 为什么要继续拆层，可以留在正文。
- 如果某条推论主要回答的是蓝皮书接下来该怎么写、该往哪个目录继续长，就写到这里。
