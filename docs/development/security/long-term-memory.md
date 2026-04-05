# 安全专题长期记忆

## 当前稳定边界

- `bluebook/security/` 正文不再承载“下一步写什么”“后续应新增哪章”“这一链条应视作几段小循环”这类推进记忆。
- `bluebook/security/appendix/` 只承载速查矩阵，不承载章节推进提示。
- `bluebook/security/source-notes/` 只承载单机制源码剖面，不承载研究推进日志。
- 安全专题后续候选、目录编排判断与编辑规则统一沉淀到 `docs/development/security/`。

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
- `147-151`: `receipt -> completion -> finality -> forgetting -> liability release` signer ladder

## 当前最值得继续深化的候选

- 候选 `154`
  方向：`audit close` 仍不等于 `irreversible erasure / evidence destruction`
  原因：`153` 已经证明“表面可封不等于证据可封”，下一层最自然的问题就是“即使 transcript、metadata、history 不再参与恢复或审计，它们是否已经等于被不可逆销毁”
  证据起点：`src/utils/sessionStorage.ts` 的 transcript file / tail metadata / loadFullLog 路径、file-history backup 目录，以及任何显式删除、覆盖、GC、compaction 保留边界相关实现

## 持续约束

- 以后如果安全正文再次出现“下一步最自然的延伸就是”“最值钱的候选”这类句式，应优先迁回本文件，而不是继续留在正文。
- 如果某条未来设计推论直接回答的是 Claude Code 机制本体，例如字段为什么要升级、signer 为什么要继续拆层，可以留在正文。
- 如果某条推论主要回答的是蓝皮书接下来该怎么写、该往哪个目录继续长，就写到这里。
