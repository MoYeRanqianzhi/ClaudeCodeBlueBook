# staging-inertness scope clarification 拆分记忆

## 本轮继续深入的核心判断

在上一刀已经把：

- `102-headless print 的已交付 suggestion 不一定留下 accepted、ignored telemetry.md`

补成：

- `102` 只抓 delivered ledger vs settlement gate

之后，

当前最自然的下一刀，

不是回去并到：

- `103`
- `208`

也不是直接在 `104` 正文深处再补新事实，

而是先让：

- `104-headless print 的 deferred suggestion staging 会留下 inert stale slot.md`

自己在开头把页内主语收紧成一句。

## 为什么这轮值得单独提交

### 判断一：当前缺口不在“104 有没有讲 inert stale slot”，而在“104 会不会被读成 102 的已确认外部 bug 版”

`104` 正文已经把这些层拆得很细：

- `pendingLastEmittedEntry` 是 incomplete staging record
- 它只在 deferred-delivery 路径上创建
- promotion 的外层 gate 是 `pendingSuggestion`
- 某些 cleanup 分支确实会留下非对称残影
- 但从当前控制流推断，这个残影更像 inert stale staging

但如果读者在进入第一性原理前，

还没先被明确提醒：

- 这里不再重讲 staging 为什么存在
- 这里也不再裁定 delivered suggestion 为什么不一定 settlement

就仍然很容易把：

- incomplete staging record
- delivered suggestion
- settled telemetry
- visible protocol bug

重新压成一句：

- “既然留下了残影，那就是另一种已交付 suggestion 没清干净”

所以这一刀真正补的，

不是更多事实，

而是范围声明。

### 判断二：这句必须把 stable、conditional 与推断边界一起点出来

并行与本地只读分析都指向同一个风险：

- 不对称残留是真实存在的
- 但“它更像 inert”是基于当前控制流的克制推断

如果只写：

- “这里只讲 stale slot”

还不够稳，

因为读者仍会把三层对象写平：

- stable facts：
  - `pendingLastEmittedEntry` 不是完整已交付记录
  - promotion 仍受 `pendingSuggestion` gate 约束
- conditional boundaries：
  - cleanup path 是否已经清掉 `pendingSuggestion`
  - 新 prompt 是否会先把残影清掉
- inferred / gray edge：
  - 当前残影是否真能升级成 visible consequence
  - 这不是公开稳定合同，只是基于现有路径的更稳判断

所以当前最稳的说法必须同时说明：

- 本页主语是 cleanup asymmetry 与 staging inertness
- delivery / settlement 留在相邻页
- “更像 inert”必须保留推断边界

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `104-headless print 的 deferred suggestion staging 会留下 inert stale slot.md`
   的导语和第一性原理之间，
   增加一句范围声明：
   - 本页不重讲 `99` 的 staging creation / promotion
   - 也不重讲 `102` 的 delivered vs settled telemetry
   - 这里只拆 `pendingSuggestion` 已清而 `pendingLastEmittedEntry` 仍残留时，为什么这个 deferred staging slot 通常仍停留在 inert internal residue
   - 这里裁定的是 cleanup asymmetry 能否通向 visible consequence
   - 不是再把残影抬成新的 delivered suggestion、settled outcome 或外部协议 bug

这样：

- `102 -> 104`
  的主链边界终于在页首对齐
- `104`
  不再像 `102` 的“bug verdict 版”或 `99` 的附录
- `208`
  以后再来做整组收束时，
  `104` 的 inertness 主语会更稳

## 苏格拉底式自审

### 问：为什么不直接回去补 `208`？

答：因为 `208` 讲的是 `100-104` 的跨页拓扑，而当前更前提的问题是 `104` 自己还没在页首把“我只抓 cleanup asymmetry 与 staging inertness”写成一句。先做后设总图，会让局部页主语继续发空。

### 问：为什么这句还要显式说“不重讲 102”？

答：因为 `104` 最容易被听成 `102` 的“已确认外部协议 bug”版本。先把 delivered-vs-settled 账本从页首剥开，才能让 inert stale slot 成为当前主语。

### 问：为什么这句还要显式说“不重讲 99”？

答：因为 `99` 讨论的是 staging 为什么存在、怎样被 promotion；`104` 讨论的是部分 cleanup 之后为什么残影通常仍不构成外部后果。前者是 creation semantics，后者是 inertness judgment，不先切开就会重新压平。

### 问：为什么要把“更像 inert”保留为推断，而不是写成稳定合同？

答：因为当前能稳定证明的是“不对称存在”与“promotion 受 `pendingSuggestion` gate 约束”；至于残影最终是否永远不会形成 visible consequence，仍然是基于现有控制流的克制推断，不该伪装成公开合同。
