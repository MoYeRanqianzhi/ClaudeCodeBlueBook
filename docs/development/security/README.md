# 安全专题开发记忆

`docs/development/security/` 只放安全专题的隔离记忆，不放蓝皮书正文。

这里承接三类内容：

- 安全专题写作边界与目录职责
- 安全专题后续研究候选与章节推进记忆
- 为了防止正文再次被污染而沉淀的编辑规则

## 目录四层结构

- `bluebook/security/`: 主线论证层，只保留问题、证据、机制、第一性原理、苏格拉底式自我约束与技术启示
- `bluebook/security/appendix/`: 速查矩阵层，只保留压缩表、对照卡与索引
- `bluebook/security/source-notes/`: 源码剖面层，只保留单机制、单协议、单文件群证据拆解
- `docs/development/security/`: 隔离记忆层，只保留候选、目录编排、编辑规则与研究推进日志

## 当前内容

- [editorial-boundary.md](editorial-boundary.md): 正文、附录、源码剖面与记忆层的边界规则
- [long-term-memory.md](long-term-memory.md): 安全专题的长期记忆与当前候选
- [../research-log.md](../research-log.md): 跨轮研究流水账与每轮新增证据摘要

## 和 `bluebook/security/` 的分工

- `bluebook/security/`: 主线论证，只保留问题、证据、机制、哲学判断与技术启示
- `bluebook/security/appendix/`: 速查矩阵与压缩表
- `bluebook/security/source-notes/`: 单机制、单协议、单文件群源码剖面
- `docs/development/security/`: 研究推进、后续候选、编辑准则与隔离记忆

## 当前纪律

- 正文如果出现“下一步最自然的延伸”“最值钱的候选”“未来应继续拆成哪层”这类作者推进句式，优先迁回本目录
- 持久化记忆优先沉淀到 [long-term-memory.md](long-term-memory.md) 与 [../research-log.md](../research-log.md)
- 目录优化先调角色分工，再调推荐链长度；不要让正文、附录、源码剖面与记忆层重新混写
