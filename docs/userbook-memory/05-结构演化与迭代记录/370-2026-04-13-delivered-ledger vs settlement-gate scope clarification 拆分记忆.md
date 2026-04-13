# delivered-ledger vs settlement-gate scope clarification 拆分记忆

## 本轮继续深入的核心判断

在上一刀已经把：

- `101-headless print 的 result 是最终输出语义，却不是流读取终点.md`

补成：

- `101` 只抓 terminal cursor vs raw stream tail

之后，

当前最自然的下一刀，

不是直接跳去：

- `103`
- `104`
- `208`

而是先让：

- `102-headless print 的已交付 suggestion 不一定留下 accepted、ignored telemetry.md`

自己在开头把页内主语收紧成一句。

## 为什么这轮值得单独提交

### 判断一：当前缺口不在“102 有没有讲 settlement”，而在“102 会不会被读成 99 的 delivery 续篇，或 101 的 tail 附录”

`102` 正文已经把这些层拆得很细：

- `lastEmitted` 是 delivered ledger
- `logSuggestionOutcome(...)` 是 settlement gate
- next prompt evidence 决定 accepted / ignored 能不能真正落账
- `interrupt` / `end_session` / `output.done()` 可以直接放弃 settlement

但如果读者在进入第一性原理前，

还没先被明确提醒：

- 这里不再重讲 delivery 总论
- 这里也不再裁定 session settle / raw tail

就仍然很容易把：

- displayed suggestion
- accepted / ignored verdict
- cleanup close path
- turn-settled signal
- tail drain

重新压回一句：

- “suggestion 既然都显示了，后面只剩尾部收口细节”

所以这一刀真正补的，

不是更多事实，

而是范围声明。

### 判断二：这句必须把 stable、conditional 与 gray 三层同时点出来

并行只读分析指出，

如果只写：

- “这里只有 delivered != settled”

还不够稳，

因为读者仍可能把不同层级写平：

- stable contract：
  - `lastEmitted` 只证明 delivered
  - `logSuggestionOutcome(...)` 才决定 verdict settlement
- conditional boundaries：
  - 后续动作是 next prompt、`interrupt`、`end_session` 还是 `output.done()`
  - 当前能否抽到真正的 text input
- gray / deeper internal：
  - `pendingLastEmittedEntry`
  - deferred staging 残影
  - 更后面的 inert stale slot

所以当前最稳的说法必须同时说明：

- 本页主语是 delivered ledger vs settlement gate
- cleanup / close path 只是 verdict 会不会发生的条件边界
- stale staging 留待 `104` 再继续下压

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `102-headless print 的已交付 suggestion 不一定留下 accepted、ignored telemetry.md`
   的导语和第一性原理之间，
   增加一句范围声明：
   - 本页不重讲 `99` 的 suggestion delivery
   - 也不重讲 `101` 的 session settle 与 raw stream tail
   - 这里只拆某条 suggestion 进入 `lastEmitted` 后，何时才有资格通过 `logSuggestionOutcome(...)` 结算为 accepted / ignored
   - `interrupt`、`end_session` 与 `output.done()` 只作为 settlement-abandon / close-path 边界
   - turn settle 与 tail drain 留在相邻页

这样：

- `101 -> 102`
  的主链边界终于在页首对齐
- `102`
  不再像一页 suggestion 总论或 tail housekeeping 附录
- `104`
  后面再去讲 inert stale slot 时，
  `102` 的 delivered-vs-settled 主语会更稳

## 苏格拉底式自审

### 问：为什么不直接去补 `104`？

答：因为 `104` 讨论的是 deferred staging 为什么会留下 inert stale slot，而当前更前提的问题是 `102` 自己还没在开头把“我只抓 delivered ledger vs settlement gate”写成一句。现在跳去 `104`，会让 `102 -> 104` 的主链再次发空。

### 问：为什么 `interrupt` / `end_session` / `output.done()` 值得在范围声明里点名？

答：因为它们不是普通 cleanup 噪音，而是“已交付 suggestion 是否还会留下 accepted / ignored telemetry verdict”的分水岭。把它们只放在正文深处，读者仍会误听成实现细节。

### 问：为什么这句还要显式说“不重讲 101”？

答：因为 `102` 最容易被听成 `101` 里 `prompt_suggestion` 的后续附录。先把 session settle / raw tail 从页首剥开，才能让 delivered vs settled 账本真正成为当前主语。

### 问：为什么这句还要显式说“不重讲 99”？

答：因为 `99` 讲的是 generated / pending / delivered / tracking 准入，而 `102` 讲的是 delivered 之后为什么仍可能没有 settled verdict。前者是 delivery boundary，后者是 settlement boundary，不先切开就会重新压平。
