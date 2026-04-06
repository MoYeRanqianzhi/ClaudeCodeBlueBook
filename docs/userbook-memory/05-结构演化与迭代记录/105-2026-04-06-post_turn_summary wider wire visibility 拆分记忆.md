# post_turn_summary wider wire visibility 拆分记忆

## 本轮继续深入的核心判断

100 已经把 `post_turn_summary` 放回了 summary family 的 transport/lifecycle 图里。

101 又把它放到了 terminal tail 的语义里。

但这两页之后，读者仍然最容易留下一个过粗印象：

- 不在 core SDK message 里 = 完全不可见

这轮要补的就是这个细缝：

- `post_turn_summary` 是 not core SDK-visible
- 但不是 not visible at all

## 为什么这轮必须单列

如果不单列，正文会在两个方向里来回摆：

- 要么把它写成“反正 internal，就别管”
- 要么把它写成“既然 wire 里承认它，那就等于普通可见消息”

这两种都会把层级写平。

## 本轮最关键的新判断

### 判断一：可见性至少分四层

- core SDK-visible
- stdout/control wire-visible
- terminal-visible
- callback-visible

### 判断二：当前源码硬证据证明的是 admissibility + filtering，不是 emission frequency

这一点必须单独钉死，防止正文继续超出源码可证边界。

### 判断三：`directConnectManager` 是本轮最值钱的新证据

因为它把“raw wire 可见”与“callback 可见”拆成了两层，不再只是 `print.ts` 一家过滤。

## 苏格拉底式自审

### 问：为什么这页不能并回 100？

答：因为 100 的主语是 summary family transport/lifecycle；105 的主语是 `post_turn_summary` 自己的 visibility ladder，已经更窄。

### 问：为什么这页不能并回 101？

答：因为 101 的主语是 terminal semantics；105 继续往外拆 raw wire 与 callback surface，不再只谈终态语义。

### 问：为什么要特别避免写“通常会 emit”？

答：因为当前源码稳能证明的是 schema 接纳与 consumer 过滤；具体 emit 频率不在这页证据范围内。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/105-post_turn_summary、SDKMessageSchema、StdoutMessageSchema、print.ts 与 directConnectManager：为什么它不是 core SDK-visible，却不等于完全不可见.md`
- `bluebook/userbook/03-参考索引/02-能力边界/94-post_turn_summary wider-wire visibility 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/105-2026-04-06-post_turn_summary wider wire visibility 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 105
- 索引层只补 94
- 记忆层只补 105

不把它并回 100，也不把它并回 101。

## 下一轮候选

1. 单独拆 `model` 为什么在 metadata restore 里属于 separate override，而不是 `externalMetadataToAppState(...)` 的对称逆映射。
2. 单独拆 direct connect 路径对 `post_turn_summary` 的过滤为什么属于 consumer path，而不是 summary existence contract。
3. 单独拆 `stream-json --verbose` 为什么看到的是更宽 raw wire，而不是普通 core SDK message surface。
