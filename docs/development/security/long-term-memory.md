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
- `147-157`: `receipt -> completion -> finality -> forgetting -> liability release -> archive close -> audit close -> irreversible erasure -> retention governance -> retention enforcement honesty -> cleanup isolation` signer/governor/honesty/isolation ladder

## 当前最值得继续深化的候选

- 候选 `158`
  方向：`cleanup-isolation signer` 仍不等于 `artifact-family cleanup constitution signer`
  原因：`157` 已经证明 task outputs、tool-results、transcripts 与 live-session ledger 目前并不处在同一套隔离宪法里。下一层最自然的问题因此变成：为什么 task output family 已经被提升到 session-scoped isolation，而 persisted tool-results/transcripts 仍主要服从项目目录 sweep；也就是谁配为不同 artifact family 制定不同 cleanup preflight gate，而不是假定一种删除规则适用于所有载体
  证据起点：`src/utils/task/diskOutput.ts` 对 task output family 的专门修补，`src/utils/toolResultStorage.ts` 与 `src/utils/cleanup.ts` 对 tool-results/session files 的路径与 sweep 逻辑，以及任何与 artifact-family-specific cleanup gating 相关的源码

## 持续约束

- 以后如果安全正文再次出现“下一步最自然的延伸就是”“最值钱的候选”这类句式，应优先迁回本文件，而不是继续留在正文。
- 如果某条未来设计推论直接回答的是 Claude Code 机制本体，例如字段为什么要升级、signer 为什么要继续拆层，可以留在正文。
- 如果某条推论主要回答的是蓝皮书接下来该怎么写、该往哪个目录继续长，就写到这里。
