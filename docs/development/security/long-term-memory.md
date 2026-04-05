# 安全专题长期记忆

## 当前稳定边界

- `bluebook/security/` 正文不再承载“下一步写什么”“后续应新增哪章”“这一链条应视作几段小循环”这类推进记忆。
- `bluebook/security/appendix/` 只承载速查矩阵，不承载章节推进提示。
- `bluebook/security/source-notes/` 只承载单机制源码剖面，不承载研究推进日志。
- 安全专题后续候选、目录编排判断与编辑规则统一沉淀到 `docs/development/security/`。
- `154` 已经稳定写出一条新边界：`read-path filtering`、`semantic removal`、`local rewrite`、`workspace rewind delete` 与 `retention cleanup` 不是同一种删除，`audit close` 也因此不能越级冒充 `irreversible erasure`。

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
- `147-154`: `receipt -> completion -> finality -> forgetting -> liability release -> archive close -> audit close -> irreversible erasure` signer ladder

## 当前最值得继续深化的候选

- 候选 `155`
  方向：`irreversible erasure` 仍不等于 `retention-policy sovereignty / destruction governance`
  原因：`154` 已经证明“退出 audit world”不等于“载体被 destroy”；而 `cleanup.ts`、`backgroundHousekeeping.ts` 与 settings schema 又说明真正 delete/rm 的时机其实受 `cleanupPeriodDays + background housekeeping` 控制。下一层最自然的问题因此变成：谁配定义保留期，谁只配执行删除，谁又只是在读路径里做过滤却不配宣称自己掌握 destruction policy
  证据起点：`src/utils/cleanup.ts` 的 `getCutoffDate/cleanupOldSessionFiles/cleanupOldFileHistoryBackups`，`src/utils/backgroundHousekeeping.ts` 的后台调度，以及 `src/utils/settings/types.ts` 对 `cleanupPeriodDays` 的语义定义

## 持续约束

- 以后如果安全正文再次出现“下一步最自然的延伸就是”“最值钱的候选”这类句式，应优先迁回本文件，而不是继续留在正文。
- 如果某条未来设计推论直接回答的是 Claude Code 机制本体，例如字段为什么要升级、signer 为什么要继续拆层，可以留在正文。
- 如果某条推论主要回答的是蓝皮书接下来该怎么写、该往哪个目录继续长，就写到这里。
