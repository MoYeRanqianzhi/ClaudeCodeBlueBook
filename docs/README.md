# 开发与记忆文档

`docs/` 只放研究过程、长期记忆和版本记录，不承载蓝皮书正文。正文去记忆化批次、目录治理调整、待办候选与研究推进摘要也统一留在这里。当前目录由根目录文档、`development/` 下研究材料、`development/security/` 下安全专题隔离记忆文档，以及 `userbook-memory/` 下 userbook 作者记忆组成。

更硬一点说，`docs/` 在整套目录里的发言权是零：

- 它保存为什么改、改了什么、下一轮该警惕什么。
- 它不负责重新宣布什么是真的，也不负责替正文补做裁决。

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
- `docs/` 只保留记忆与演进说明，不拥有正文的改判权、对象承认权或 verdict 签发权
