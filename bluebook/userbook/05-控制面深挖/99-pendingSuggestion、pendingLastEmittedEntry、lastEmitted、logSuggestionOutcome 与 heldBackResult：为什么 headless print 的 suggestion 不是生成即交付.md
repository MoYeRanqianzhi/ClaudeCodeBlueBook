# `pendingSuggestion`、`pendingLastEmittedEntry`、`lastEmitted`、`logSuggestionOutcome` 与 `heldBackResult`：为什么 headless print 的 suggestion 不是生成即交付

## 用户目标

98 页已经把一件事讲清了：

- 主结果语义不会让给晚到系统事件

但再往下一层看，读者又会碰到另一组很容易被写糊的问题：

- 模型已经算出了 suggestion，为什么系统还不立刻把它当成“已发出”？
- 为什么有了 `pendingSuggestion`、`pendingLastEmittedEntry`、`lastEmitted` 三层状态？
- 为什么 `heldBackResult` 一旦存在，suggestion 的输出顺序和接受追踪记账都要一起延后？
- 为什么新命令一来，系统宁可丢弃 pending suggestion，也不把它硬塞出去？

如果这些问题不拆开，读者就会把这里误写成：

- “suggestion 一旦生成，就已经算交付给用户了；后面只是异步补个显示。”

源码不是这样设计的。

## 第一性原理

更稳的提问不是：

- “suggestion 什么时候生成？”

而是五个更底层的问题：

1. suggestion 的生成时间，和它的交付时间，是同一件事吗？
2. suggestion 何时才能进入 acceptance tracking 的账本？
3. 为什么 `heldBackResult` 会改变 suggestion 的输出顺序？
4. 如果 suggestion 还没真正交付，新命令到来时系统应该保它还是丢它？
5. 这里讨论的是 prompt suggestion 文本本身，还是 suggestion delivery ledger？

只要这五轴不先拆开，后续就会把：

- delayed delivery and delayed accounting

误写成：

- immediate suggestion delivery

## 第二层：这里至少有三种状态，不是一种

从 `suggestionState` 往回压，至少要拆出三层：

1. `pendingSuggestion`
2. `pendingLastEmittedEntry`
3. `lastEmitted`

它们不是同一份对象换名字，而是在描述三种不同事实：

- suggestion 已生成，但还没真正发出去
- 与之配套的接受追踪元数据也先被挂起
- suggestion 真正交付后，才进入可用于 `logSuggestionOutcome(...)` 的已交付账本

所以更准确的说法是：

- suggestion 有生成态、待交付态、已交付态

不是：

- “只有一份 suggestion，后面只是显示细节”

## 第三层：源码明写了“生成不等于交付”

`print.ts` 对 suggestion 的注释已经把这层讲得很清楚：

- Defer emission if the result is being held for background agents
- so that prompt_suggestion always arrives after result
- Only set `lastEmitted` when the suggestion is actually delivered
- deferred suggestions may be discarded before delivery if a new command arrives first

这四句几乎就是 99 的明文答案：

- suggestion 可以先生成
- 但如果 result 还在 hold back，它不能先交付
- 只有真正 `output.enqueue(...)` 之后，才算 delivered
- 在 delivered 之前，它甚至可以被安全丢弃

所以这里系统真正关心的不是：

- “模型有没有算出 suggestion”

而是：

- “consumer 有没有真的收到这条 suggestion”

## 第四层：`heldBackResult` 为什么会把 suggestion 一起往后拖

`print.ts` 在 suggestion 生成那段直接写了：

- if `heldBackResult`
- 把 suggestion 放进 `pendingSuggestion`
- 把 suggestion 对应的 tracking 元数据放进 `pendingLastEmittedEntry`

而不是立即：

- `output.enqueue(suggestionMsg)`
- `lastEmitted = lastEmittedEntry`

原因也明写在注释里：

- prompt_suggestion always arrives after result

这说明系统守的不是：

- “suggestion 越快给出去越好”

而是：

- “主结果先落地，suggestion 再作为附属尾流出现”

也就是说，`heldBackResult` 不只影响 result 自己，还会级联影响：

- suggestion 的交付顺序
- suggestion 的记账时机

## 第五层：为什么 `pendingLastEmittedEntry` 必须和 `pendingSuggestion` 成对存在

这里最容易被忽略的是第二个 pending：

- `pendingLastEmittedEntry`

它的意义不是重复缓存 suggestion 文本，而是缓存：

- `text`
- `promptId`
- `generationRequestId`

这些 acceptance tracking 所需元数据。

系统把 suggestion 文本和 tracking 元数据分成两块待交付对象，说明它在守一条更细的边界：

- 不是“等 suggestion 发完再随手补记一笔”

而是：

- “只有 suggestion 真正发出去，这笔 tracking 元数据才有资格升级成 `lastEmitted`”

所以 `pendingLastEmittedEntry` 的存在本身就在说明：

- 接受追踪账本只认真实交付，不认纯生成

## 第六层：`lastEmitted` 是“已交付 suggestion”的账本，不是“最近生成 suggestion”的账本

真正落到 `lastEmitted` 的路径只有两种：

### 直接交付路径

- 没有 `heldBackResult`
- 立即 `output.enqueue(suggestionMsg)`
- 立即 `lastEmitted = lastEmittedEntry`

### 延后交付路径

- `heldBackResult` 先落地
- 若还有 `pendingSuggestion`
- 再 `output.enqueue(pendingSuggestion)`
- 再把 `pendingLastEmittedEntry` 升级为 `lastEmitted`
- 并补上 `emittedAt: Date.now()`

这说明 `lastEmitted` 记录的不是：

- 最近算出来的 suggestion

而是：

- 最近真正被 consumer 看见、可以拿来和后续 prompt 比较接受度的 suggestion

## 第七层：为什么新命令到来时可以丢掉 pending suggestion

`print.ts` 还有一段特别值钱的逻辑：

- 新 command 开始前，先 abort in-flight suggestion generation
- 清掉 `pendingSuggestion`
- 清掉 `pendingLastEmittedEntry`
- 如果存在 `lastEmitted`，并且当前 command 是 `prompt`
- 才用当前输入去 `logSuggestionOutcome(...)`

这说明系统做了一个非常明确的价值排序：

1. 当前主回合和真正已交付的 suggestion 优先
2. 还没交付的 suggestion 不享有保留权

所以如果新命令先来了，系统宁可：

- 丢掉 pending suggestion

也不会：

- 把它补发出去，再试图假装它被用户看见过

这也正是注释里那句：

- deferred suggestions may be discarded before delivery if a new command arrives first

的真实含义。

## 第八层：`logSuggestionOutcome(...)` 为什么只能对 `lastEmitted` 生效

`logSuggestionOutcome(...)` 的触发条件非常克制：

- 必须已经存在 `lastEmitted`
- 当前 command 必须是 `prompt`
- 还要能提取出真正的用户输入文本

然后才会把：

- 上一条已交付 suggestion 文本
- 当前用户输入
- `emittedAt`
- `promptId`
- `generationRequestId`

拿去记接受结果。

这说明 acceptance tracking 的前提不是：

- suggestion 曾经被模型生成过

而是：

- suggestion 曾经被真正发出，并且用户随后给了可比较的 prompt 输入

所以 `lastEmitted` 的设计本身就在防一个很常见的统计污染：

- 把从未真正展示给用户的 suggestion，也当成“被拒绝/被忽略”的样本

## 第九层：为什么 99 不和 98 合并

98 回答的是：

- 为什么 `lastMessage` 语义不会让给晚到系统尾流

99 继续往下后，问题已经换成：

- suggestion 的生成、交付、接受追踪为什么是三步
- 以及为什么 `heldBackResult` 会把 suggestion delivery ledger 一起拖后

前者讲：

- semantic last result rank

后者讲：

- suggestion delivery and accounting semantics

主语已经变了，不该揉成一页。

## 第十层：最常见的假等式

### 误判一：suggestion 一生成就算已交付

错在漏掉：

- `heldBackResult` 存在时，它会先进入 `pendingSuggestion`

### 误判二：`lastEmitted` 记录的是最近生成的 suggestion

错在漏掉：

- 它只记录最近真正交付给 consumer 的 suggestion

### 误判三：`pendingLastEmittedEntry` 只是多余缓存

错在漏掉：

- 它保护的是 tracking 元数据只能在真实交付后升级

### 误判四：新命令来了，最好把 pending suggestion 也顺手发掉

错在漏掉：

- 系统宁可丢弃未交付 suggestion，也不伪造一次并不存在的用户可见交付

### 误判五：acceptance tracking 只需要 suggestion 文本，不需要交付语义

错在漏掉：

- `logSuggestionOutcome(...)` 只接受 `lastEmitted`，不接受 pending/generated suggestion

## 第十一层：稳定、条件与内部边界

### 稳定可见

- headless `print` 的 suggestion 不是生成即交付，而是有明确的待交付与已交付边界。
- `heldBackResult` 会同时延后 suggestion 的输出与接受追踪记账。
- `lastEmitted` 只记录真正交付过的 suggestion。
- 未交付 suggestion 可以被安全丢弃，不会被伪装成交付过。

### 条件公开

- 是否存在 `heldBackResult` 会改变 suggestion 的输出顺序和记账时机。
- 当前 command 是否为 `prompt`，会影响是否触发 `logSuggestionOutcome(...)`。
- 新命令或 abort/shutdown 会清掉未交付 suggestion。

### 内部 / 实现层

- `pendingSuggestion`、`pendingLastEmittedEntry`、`lastEmitted` 的具体字段布局。
- `inflightPromise`、abortController 与 suggestion suppression 的细节。
- acceptance tracking 的具体统计去向和上报细节。

## 第十二层：苏格拉底式自检

### 问：为什么这页最先该拆 `pendingLastEmittedEntry`，而不是只写 `pendingSuggestion`？

答：因为真正被延后的不只是 suggestion 文本，还有 acceptance tracking 的元数据升级资格。

### 问：为什么“可被丢弃”值得进正文？

答：因为它直接证明系统的判据不是“有没有生成”，而是“有没有真实交付”。

### 问：为什么 `logSuggestionOutcome(...)` 是这页的关键证据？

答：因为它把交付边界从 UI/输出顺序问题，升级成了统计/记账语义问题。

## 源码锚点

- `claude-code-source-code/src/cli/print.ts`
