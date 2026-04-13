# summary-contract split scope clarification 拆分记忆

## 本轮继续深入的核心判断

在上一刀已经把：

- `99-headless print 的 suggestion 不是生成即交付.md`

补成：

- `99` 只拆 delivery/accounting ledger

之后，

当前最自然的后继节点，

不是直接去：

- `208`

做整组收束，

而是先让：

- `100-Claude Code 的 summary 不是同一条 transport-lifecycle contract.md`

自己在开头把页内主语说死。

## 为什么这轮值得单独提交

### 判断一：当前缺口不在“100 有没有对象分家”，而在“100 会不会被读成结果尾流的大杂烩”

`100` 正文已经把：

- `task_summary`
- `post_turn_summary`

在 carrier、message union、清理/恢复、常规输出路径上逐层拆开了。

但如果读者在进入第一性原理前，

还没先被提醒：

- 这页只抓 summary contract split

就仍然容易把：

- `result` terminal semantics
- observer restore
- suggestion settlement

这些相邻问题一起压回“尾部 housekeeping”。

所以当前最小有效修正，

不是补更多证据，

而是把页内主语前置。

### 判断二：这刀比先去做 `208` 更稳

并行只读分析已经指出：

- `208` 的职责是消费 `100-104` 这组页之间的关系
- 它不是 `99` 后的第一刀

如果现在直接去补 `208`，

结构上会变成：

- 新根页 `100` 还没先把自己的主语钉死
- 就先做了后设编目

顺序会发空。

所以当前更稳的推进顺序是：

- 先补 `100`
- 再决定是否要去 `101`
- 等 `100-104` 再齐一点后，才回到 `208`

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `100-Claude Code 的 summary 不是同一条 transport-lifecycle contract.md`
   的导语和第一性原理之间，
   增加一句范围声明：
   - 这页只抓 `task_summary / post_turn_summary` 的 summary contract split；`result` terminal semantics、observer restore 与 suggestion settlement 在这里只作为边界参照，不另起主语

这样：

- `100`
  不再像一页“所有尾部 summary 细节的汇总”
- `101/103/104`
  也更自然退回后继节点和侧枝的位置
- `208`
  以后再来做结构收束时，根页主语会更稳

## 苏格拉底式自审

### 问：为什么不直接去补 `101`？

答：因为 `101` 讨论的是 result terminal cursor vs raw stream tail，而当前更前提的问题是 `100` 自己还没在开头把“我只抓 summary contract split”写成一句。

### 问：为什么这句不会和 `208` 重复？

答：因为 `208` 讲的是跨页拓扑和阅读顺序；这里讲的是 `100` 页内主语范围。前者是 map，后者是 local scope guard。

### 问：为什么不把 `observer restore` 或 `suggestion settlement` 直接点名成下一页？

答：因为这句的目标是收窄主语，不是展开目录。只要先把“这里只作边界参照，不另起主语”钉死，后继节点自然会回到各自的位置。
