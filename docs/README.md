# 开发与记忆文档

`docs/` 只放研究过程、长期记忆、证据索引和版本记录，不承载蓝皮书正文。正文 first-answer order 统一回 [../bluebook/README.md](../bluebook/README.md)，目录法、发言权与入口升级规则统一回 [development/00-研究方法.md](development/00-研究方法.md)；这里默认只保存“为什么改、改了什么、下一轮该警惕什么”。

更准确地说：

- 这里保存过程与记忆。
- 这里不重签正文对象、frontdoor formula 或 verdict。

## 当前内容

- [changelog.md](changelog.md): 文档演进记录
- [development/00-研究方法.md](development/00-研究方法.md): 研究方法与证据约束
- [development/01-章节规划.md](development/01-章节规划.md): 蓝皮书章节规划与优先级
- [development/02-证据索引.md](development/02-证据索引.md): 源码证据锚点
- [development/03-反思与迭代准则.md](development/03-反思与迭代准则.md): 写作约束与迭代方法
- [development/long-term-memory.md](development/long-term-memory.md): 长期记忆与持续研究约束
- [development/research-log.md](development/research-log.md): 研究日志、证据回写与待办
- [development/security/README.md](development/security/README.md): 安全专题隔离记忆入口
- [development/security/editorial-boundary.md](development/security/editorial-boundary.md): 安全专题正文与记忆边界
- [development/security/long-term-memory.md](development/security/long-term-memory.md): 安全专题长期记忆与后续候选
- [userbook-memory/README.md](userbook-memory/README.md): userbook 作者记忆、结构演化与写作边界

## 何时看这里

- 想看正式蓝皮书正文：去 [../bluebook/README.md](../bluebook/README.md)
- 想看面向使用者的正文：去 [../bluebook/userbook/README.md](../bluebook/userbook/README.md)
- 想确认研究方法、证据边界、当前是 `mirror present` 还是 `public-evidence only`：先看 [development/00-研究方法.md](development/00-研究方法.md)
- 想知道当前还缺什么证据或后续该补什么：看 `development/research-log.md`
- 想确认哪些内容刚被从正文迁出、为什么迁出：先看 `changelog.md` 与 `development/long-term-memory.md`

## 维护约定

- 正式章节一律写入 `bluebook/`
- 研究过程、长期记忆、证据索引与变更记录一律写入 `docs/`
- userbook 的作者记忆统一写入 `docs/userbook-memory/`
- 专题级推进记忆优先写入对应 `docs/development/<topic>/`
- `README` 只保留稳定入口，不重复正文目录
- 若这里出现与正文 owner law 冲突的句子，一律以 `bluebook/README + development/00` 为准
