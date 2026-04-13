# terminal-cursor vs raw-tail scope clarification 拆分记忆

## 本轮继续深入的核心判断

在上一刀已经把：

- `100-Claude Code 的 summary 不是同一条 transport-lifecycle contract.md`

补成：

- 这页只抓 `task_summary / post_turn_summary` 的 summary contract split

之后，

当前最自然的下一刀，

不是直接跳去：

- `208`

做总纲收束，

而是先让：

- `101-headless print 的 result 是最终输出语义，却不是流读取终点.md`

自己在开头把页内主语收紧。

## 为什么这轮值得单独提交

### 判断一：当前缺口不在“101 有没有分 terminal cursor 和 raw tail”，而在“101 会不会把 payload、cursor、tail、收口证据写成一层”

`101` 正文已经把这些层逐步拆开：

- `lastMessage` 是 filtered terminal cursor
- `result` 决定 final payload
- raw stream tail 仍可继续存在
- idle / suggestion / late `task_notification` 是尾流边界对象
- `outputFormat` switch / `gracefulShutdownSync` 是收口证据

但如果读者在进入第一性原理前，

还没先被提醒这页的主语到底是什么，

就仍然容易把：

- 最后一个 raw frame
- 最终输出语义
- turn-settled signal
- stream-visible tail
- exit semantics

压回一句：

- “最后一个消息是谁”

所以这一刀真正补的，

不是更多事实，

而是对象层级的范围声明。

### 判断二：这句必须分三层写，不能用一条宽总括糊过去

并行只读分析指出，

宽总括会有几个风险：

- 把 `result` 和 `lastMessage` 混成同一对象
- 把 `session_state_changed(idle)` 写成无条件稳定尾流真相
- 把 `prompt_suggestion` 抬成和 `result` 同级的稳定公开对象
- 把 `outputFormat switch` / `gracefulShutdownSync` 误写成 message family

所以当前最稳的写法必须同时说清：

- terminal contract 的主对象
- 仅作边界参照的尾流对象
- 仅作收口证据的实现层对象

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `101-headless print 的 result 是最终输出语义，却不是流读取终点.md`
   的导语和第一性原理之间，
   增加一句范围声明：
   - 本页只抓 headless print 如何在默认 text/json 收口里以 `lastMessage` 保持 terminal cursor、以 `result` 决定 final payload 与 exit semantics
   - 这套 terminal contract 不等于“最后一个 raw stream frame”
   - `session_state_changed('idle')`、late `task_notification`、条件启用的 `prompt_suggestion` 只作 tail/settled/terminal-inert 边界参照
   - `outputFormat` switch 与 `gracefulShutdownSync` 只作收口证据

这样：

- `101`
  不再像一页“最后一个消息是谁”的大杂烩
- `102`
  更自然退回 delivered vs settled 的后继节点
- `208`
  以后再来做结构收束时，`101` 的页内主语会更稳

## 苏格拉底式自审

### 问：为什么不直接去补 `102`？

答：因为 `102` 讨论的是 delivered ledger vs settlement ledger，而当前更前提的问题是 `101` 自己还没在开头把 terminal contract 的对象层级说成一句。

### 问：为什么这句要把 `outputFormat switch` 和 `gracefulShutdownSync` 也点出来？

答：因为这页最容易把实现证据和 runtime message family 混成同一类对象。点出它们只是收口证据，能减少这种串层。

### 问：为什么这句不会和 `100` 重复？

答：`100` 的主语是 summary contract split；`101` 的主语是 terminal cursor vs raw stream tail。两页虽然相邻，但对象层级完全不同。
