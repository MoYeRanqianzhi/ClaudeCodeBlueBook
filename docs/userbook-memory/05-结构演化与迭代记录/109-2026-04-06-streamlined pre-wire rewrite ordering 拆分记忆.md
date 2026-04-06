# streamlined pre-wire rewrite ordering 拆分记忆

## 本轮继续深入的核心判断

106 已经说明：

- `stream-json --verbose` 走的是 raw wire contract

但如果只停在那个层面，读者仍然会保留一个顺序上的误读：

- streamlined output 只是 raw wire 或 terminal semantics 之后补的一层显示优化

这轮要补的更窄一句是：

- streamlined transformer 发生在 write 之前
- 它改写的是 outgoing wire message
- 不是 terminal semantics 后处理

## 为什么这轮必须单列

如果不单列，正文最容易在两种错误里摇摆：

- 把 streamlined 写成 raw write 之后的 decoration
- 把 `lastMessage` 写成仍然在主导这条路径的“写什么”

这两种都会把：

- gate
- transformer signature
- write-time projection
- terminal cursor

四层对象重新压平。

## 本轮最关键的新判断

### 判断一：`transformToStreamlined` 在 streaming loop 内、`structuredIO.write(...)` 之前运行

这是这页最值钱的顺序证据。

### 判断二：streamlined 分支写出的是 transformed object，而不是原始 `message`

所以它不是“原始消息照发，再补一份简化版”。

### 判断三：`lastMessage` 随后明确排除 `streamlined_*`

这说明 streamlined family 属于 pre-terminal projection，而不是 terminal cursor 主合同。

## 苏格拉底式自审

### 问：为什么这页不能并回 106？

答：因为 106 讲 raw wire contract 面向哪一层对象；109 讲这条 contract 内部的 rewrite timing。

### 问：为什么这页不能并回 101？

答：因为 101 讲 semantic last-message；109 讲 `streamlined_*` 为什么根本不属于那套终态 cursor 主线。

### 问：为什么要反复强调 gate？

答：因为不强调 gate，就会滑成“所有 `stream-json` 都会 streamlined”的错误泛化。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/109-createStreamlinedTransformer、structuredIO.write、lastMessage 与 streamlined_*：为什么 headless print 的 streamlined output 不是 terminal semantics 后处理，而是 pre-wire rewrite.md`
- `bluebook/userbook/03-参考索引/02-能力边界/98-streamlined pre-wire rewrite ordering 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/109-2026-04-06-streamlined pre-wire rewrite ordering 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 109
- 索引层只补 98
- 记忆层只补 109

不需要新增目录，只更新导航即可。

## 下一轮候选

1. 单独拆 direct connect 里 `streamlined_*` family 与 `post_turn_summary` family 的过滤为什么不是同一种 suppress reason。
2. 单独拆更宽 `StdoutMessage`、builder/control transport 与 direct-connect callback surface 为什么不是同一张可见性表。
3. 单独拆 `shouldIncludeInStreamlined(...)`、assistant/result 双入口与 null suppression 为什么不是同一种“消息简化”。
