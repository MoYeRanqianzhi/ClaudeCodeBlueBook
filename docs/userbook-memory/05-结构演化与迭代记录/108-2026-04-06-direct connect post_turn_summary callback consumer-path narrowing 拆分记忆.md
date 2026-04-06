# direct connect post_turn_summary callback consumer-path narrowing 拆分记忆

## 本轮继续深入的核心判断

105 已经说明：

- `post_turn_summary` 不是 core SDK-visible
- 但它仍在更宽 `StdoutMessage` / stdout-control wire surface 里

可如果只停在那个层面，读者仍然会保留一个很常见的误读：

- `directConnectManager` 都把它过滤掉了，所以 direct connect 根本不会收到它

这轮要补的更窄一句是：

- direct connect 对 `post_turn_summary` 的过滤说明的是 callback consumer-path narrowing
- 不是 raw wire existence denial

## 为什么这轮必须单列

如果不单列，正文最容易在两种错误里摇摆：

- 把 manager 过滤写成“协议本体没有这条消息”
- 把 parse widening 写成“callback 理应看见它，只是偶然没显示”

这两种都会把：

- `StdoutMessage`
- `SDKMessage`
- manager skip list
- `onMessage(...)`

四层对象重新压平。

## 本轮最关键的新判断

### 判断一：`isStdoutMessage(...)` 与 `onMessage: (message: SDKMessage) => void` 回答的不是同一个问题

前者回答 raw ingress admissibility，后者回答 callback delivery contract。

### 判断二：`post_turn_summary` 是被 manager 显式 strip，而不是在 parse 时自然掉出

所以 callback 缺席不能反推 wire 缺席。

### 判断三：direct connect 这条线暴露给用户的 callback surface，本来就是更宽 wire 上的一层 consumer-specific projection

因此“没交给 callback”最准确的读法就是：

- consumer path 被收窄了

而不是：

- 消息不存在

## 苏格拉底式自审

### 问：为什么这页不能并回 61？

答：因为 61 的主语是 direct connect 的 broad transcript surface；108 的主语是 `post_turn_summary` 在 direct-connect ingress 与 callback contract 之间的单点分叉。

### 问：为什么这页不能并回 105？

答：因为 105 讲 visibility ladder；108 讲 ladder 里 direct-connect 这一格为什么属于 consumer-path narrowing，而不是 existence claim。

### 问：为什么要反复强调“不是 arrival cadence 证明”？

答：因为当前源码稳能证明的是 parse widening 与 manager filtering，不是每轮 runtime arrival。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/108-StdoutMessage、SDKMessage、onMessage 与 post_turn_summary：为什么 direct connect 对 summary 的过滤不是消息不存在，而是 callback consumer-path 收窄.md`
- `bluebook/userbook/03-参考索引/02-能力边界/97-Direct connect post_turn_summary callback consumer-path narrowing 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/108-2026-04-06-direct connect post_turn_summary callback consumer-path narrowing 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 108
- 索引层只补 97
- 记忆层只补 108

不需要新增目录，只更新导航即可。

## 下一轮候选

1. 单独拆 `streamlined` transformer 为什么在 raw wire write 之前工作，而不是 terminal semantics 之后补写。
2. 单独拆 direct connect 里 `streamlined_*` family 与 `post_turn_summary` family 的过滤为什么不是同一种 suppress reason。
3. 单独拆更宽 `StdoutMessage`、builder/control path 与 direct-connect callback surface 为什么不是同一张可见性表。
