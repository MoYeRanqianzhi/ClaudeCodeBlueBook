# direct connect suppress-reason split for streamlined and post_turn_summary 拆分记忆

## 本轮继续深入的核心判断

108 已经说明：

- `post_turn_summary` 被 direct connect 过滤，属于 callback consumer-path narrowing

109 又说明：

- `streamlined_*` 来自 pre-wire rewrite

但如果只停在这两页，读者仍然很容易把它们压成一句太粗的话：

- 反正它们都在 `directConnectManager` 的 skip list 里，所以本质上就是同一种应该被静默掉的内部消息

这轮要补的更窄一句是：

- `streamlined_*` 与 `post_turn_summary` 的 callback exclusion result 相同
- 但 upstream provenance 不同
- 所以不是同一种 suppress reason

## 为什么这轮必须单列

如果不单列，正文最容易在两种错误里摇摆：

- 把 `streamlined_*` 写成另一种 raw summary tail
- 把 `post_turn_summary` 写成另一种 projection artifact

这两种都会把：

- parse/callback 同表结果
- conditional rewrite provenance
- raw summary provenance

三层对象重新压平。

## 本轮最关键的新判断

### 判断一：同样被 callback 挡住，不等于同样来自同一种上游对象

这是这页最值钱的分层。

### 判断二：`streamlined_*` 的 suppress reason 更接近“projection family 不进 callback”

不是“background summary 不进 callback”。

### 判断三：`post_turn_summary` 的 suppress reason 更接近“raw summary tail 不进 callback”

不是“write-time rewrite artifact 不进 callback”。

## 苏格拉底式自审

### 问：为什么这页不能并回 108？

答：因为 108 讲 `post_turn_summary` 自己的 callback narrowing；110 讲它和 `streamlined_*` 在同一 skip list 里时，为什么不能压成同一种 suppress reason。

### 问：为什么这页不能并回 109？

答：因为 109 讲 `streamlined_*` 的 rewrite timing；110 讲它与 `post_turn_summary` 的 provenance split。

### 问：为什么要反复强调 provenance？

答：因为没有 provenance 这层，读者会把 “同样过滤” 直接写成 “同一种消息族”。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/110-streamlined_*、post_turn_summary、createStreamlinedTransformer 与 directConnectManager：为什么同样在过滤名单里，却不是同一种 suppress reason.md`
- `bluebook/userbook/03-参考索引/02-能力边界/99-direct connect suppress-reason split: streamlined_* vs post_turn_summary 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/110-2026-04-06-direct connect suppress-reason split for streamlined and post_turn_summary 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 110
- 索引层只补 99
- 记忆层只补 110

不需要新增目录，只更新导航即可。

## 下一轮候选

1. 单独拆更宽 `StdoutMessage`、builder/control transport 与 direct-connect callback surface 为什么不是同一张可见性表。
2. 单独拆 `shouldIncludeInStreamlined(...)`、assistant/result 双入口与 null suppression 为什么不是同一种“消息简化”。
3. 单独拆 `result` 在 streamlined path 里 passthrough、在 `lastMessage` 里保终态主位，为什么不是同一种“保留原样”。
