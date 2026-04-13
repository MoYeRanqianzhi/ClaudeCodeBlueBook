# `lastEmitted`、`logSuggestionOutcome`、`interrupt`、`end_session` 与 `output.done`：为什么 headless print 的已交付 suggestion 不一定留下 accepted、ignored telemetry

## 用户目标

99 已经把一条关键边界钉死了：

- suggestion 的生成、交付、记账不是同一步

101 又把另一条边界钉死了：

- `result` 是最终输出语义，但不是流读取终点

但真正往下接协议或读统计的人，很快还会碰到第三个更细的问题：

- suggestion 明明已经真实交付给 consumer 了，为什么统计上却不一定留下 accepted / ignored 结果？
- `interrupt`、`end_session`、output close 这些路径，到底是在取消生成、取消交付，还是直接放弃 telemetry 结算？
- `lastEmitted` 为什么既像“已交付账本”，又会在某些收口路径里被直接抹掉？
- suggestion analytics 的 settlement，到底是绑在“已经显示”，还是绑在“下一次 prompt 到来”？

如果这些问题不拆开，正文最容易滑成一句错误总结：

- “只要 suggestion 已经显示出去，系统最后总会记一笔 accepted 或 ignored。”

源码不是这么设计的。

本页不重讲 99 页的 suggestion delivery，也不重讲 101 页的 session settle 与 raw stream tail；这里只拆一条更窄的边界：某条 suggestion 在进入 `lastEmitted` 之后，何时才有资格通过 `logSuggestionOutcome(...)` 结算为 accepted / ignored，以及为什么 `interrupt`、`end_session` 与 `output.done()` 这类收口路径可以结束 cleanup，却仍不替这条已交付 suggestion 补做 telemetry verdict。换句话说，delivered 只说明 consumer 已经见过 suggestion，accepted / ignored 仍取决于后续 prompt evidence；会话是否 settle、尾流是否清完，是相邻页讨论的另一层合同。

## 第一性原理

更稳的提问不是：

- “suggestion 有没有显示出去？”

而是先问五个更底层的问题：

1. suggestion 已交付，和 suggestion outcome 已结算，是同一件事吗？
2. `logSuggestionOutcome(...)` 什么时候才会真正触发？
3. 如果用户在看到 suggestion 后直接 `interrupt` 或 `end_session`，系统应该记 ignored，还是直接不结算？
4. 如果输出流关闭而下一次 prompt 永远不来，`lastEmitted` 还会不会被结算？
5. 这里讨论的是 suggestion delivery ledger，还是 telemetry settlement ledger？

只要这五轴不先拆开，后续就会把：

- delivered suggestion
- settled suggestion outcome

误写成：

- “显示过就等于最后一定会记 accepted / ignored”

## 第一层：`lastEmitted` 证明“已经交付”，但不等于“已经结算”

99 页已经说明：

- 只有 suggestion 真正交付给 consumer 后，才会进入 `lastEmitted`

这意味着 `lastEmitted` 回答的问题是：

- 最近哪一条 suggestion 已经真实显示过

但源码里真正负责结算 telemetry 的函数是：

- `logSuggestionOutcome(...)`

而它不是在“交付瞬间”触发的，而是在：

- 下一次 `prompt` command 到来时

才尝试用：

- 上一条 `lastEmitted`
- 当前用户输入

去结算 accepted / ignored。

所以更准确的说法是：

- `lastEmitted` 是 delivered ledger
- `logSuggestionOutcome(...)` 才是 telemetry settlement gate

不是：

- “一旦进了 `lastEmitted`，统计就已经落账”

## 第二层：源码把 outcome logging 明确绑在“下一次 prompt 到来”

`print.ts` 在新 command 开始前的 suggestion 处理顺序非常关键：

1. abort in-flight suggestion generation
2. 清掉 `pendingSuggestion`
3. 清掉 `pendingLastEmittedEntry`
4. 如果存在 `lastEmitted`
5. 且当前 command 的 `mode === 'prompt'`
6. 且能提取到真正的用户输入文本
7. 才调用 `logSuggestionOutcome(...)`

这说明系统守的根本不是：

- “已交付 suggestion 最终一定会有一个 outcome”

而是：

- “只有当下一次真正的 prompt 输入到来时，才有证据把这条 suggestion 结算成 accepted 或 ignored”

所以这里最硬的一句应该是：

- suggestion outcome settlement 绑定在 next prompt

不是：

- “绑定在 suggestion delivery”

而且这条边界还比“下一次 command”更窄：

- 必须是 `prompt` mode
- 最好还能抽到真正的 text input

否则即使已经进入 prompt 分支，telemetry 也不一定真的落账。

## 第三层：`interrupt` 与 `end_session` 会直接放弃这笔 telemetry settlement

这正是本页最值钱的新边界。

`print.ts` 在处理：

- `interrupt`
- `end_session`

时都会做几件事：

- abort 当前回合
- abort suggestion generation
- 把 `suggestionState.abortController` 清空
- 把 `suggestionState.lastEmitted` 清空
- 把 `suggestionState.pendingSuggestion` 清空

但它们都不会调用：

- `logSuggestionOutcome(...)`

这说明如果用户已经看见了一条 suggestion，然后不是继续发下一条 prompt，而是直接：

- `interrupt`
- `end_session`

那么系统的行为不是：

- 自动把它记成 ignored

而是：

- 直接放弃这条已交付 suggestion 的 accepted / ignored 结算

所以从 telemetry 角度看，这里存在一个非常明确的洞：

- delivered suggestion can disappear without settled outcome

## 第四层：output close / shutdown 也不是“补记 ignored”的兜底器

很多人会自然假设：

- 如果没有下一次 prompt，关闭输出流前系统总该顺手补记一笔 ignored

源码没有这么做。

在：

- input closed 且当前不在 running
- 或 run loop 结束准备 `output.done()`

这些路径里，系统会：

- 最多等待 in-flight suggestion generation 结束一小段时间
- abort abortController
- finalize hooks
- `output.done()`

但不会：

- 对已经存在的 `lastEmitted` 触发 `logSuggestionOutcome(...)`

这说明 output close 回答的问题不是：

- suggestion analytics 应该怎样结算

而是：

- 输出流何时安全关闭

所以更准确的理解应是：

- output close 可能保住“生成完成”
- 但不会补做“outcome settlement”

## 第五层：这和 99 页讨论的“未交付 suggestion 可被丢弃”不是同一个问题

99 页讲的是：

- 未交付 suggestion 在新命令到来前可以被丢弃
- 因为它根本还没有真实显示给 consumer

102 页讲的主语已经换了：

- suggestion 已经真实交付
- 但 accepted / ignored telemetry 仍然可能永远不结算

前者讨论的是：

- delivery boundary

后者讨论的是：

- settlement boundary

如果不把这两页分开，正文就会把：

- 未交付不记账

和：

- 已交付但未 settlement

重新压成同一个“统计细节”

## 第六层：为什么 `output.done()` 前还要等 in-flight suggestion，却仍不能算 telemetry 完整收口

`print.ts` 在关闭输出前会：

- 如果 `suggestionState.inflightPromise` 还在，就最多等它一段时间

这条逻辑的价值在于：

- 给 push suggestion generation 一个完成并输出的机会

但这和 telemetry completeness 不是一回事。

因为即便 generation 赶上了、delivery 赶上了，只要后面没有：

- next prompt

系统仍然不会自动调用：

- `logSuggestionOutcome(...)`

所以这里必须避免一句看似顺的误写：

- “等待 in-flight suggestion 完成，就说明 suggestion 逻辑完整收口了。”

更准确的说法是：

- 它最多保证 generation / delivery 更完整
- 不保证 accepted / ignored settlement 完整

## 第七层：`logSuggestionOutcome(...)` 的统计语义反过来证明“没有 prompt，就没有 verdict”

`promptSuggestion.ts` 里的 `logSuggestionOutcome(...)` 会产出：

- `outcome: accepted | ignored`
- `timeToAcceptMs` 或 `timeToIgnoreMs`
- `similarity`

这些字段都需要一个前提：

- 当前用户输入已经出现

否则系统连：

- 用户是采纳了建议
- 还是忽略了建议
- 还是根本直接结束了会话

都没法从现有合同里稳定推出。

这也解释了为什么源码宁可：

- 不结算

也不愿意：

- 在 `interrupt` / `end_session` / output close 时武断补记一个 ignored

所以这页更底层的原则是：

- telemetry settlement 需要 evidence，不只是需要 displayed suggestion

## 第八层：最常见的假等式

### 误判一：suggestion 只要已经显示，就最终一定会结算 accepted / ignored

错在漏掉：

- `logSuggestionOutcome(...)` 只在下一次 prompt 到来时才会触发

### 误判二：`interrupt` 等价于“用户忽略了 suggestion”

错在漏掉：

- `interrupt` 路径会清 `lastEmitted`，但不会补记 ignored

### 误判三：`end_session` 只是更温和的 ignored

错在漏掉：

- `end_session` 同样直接放弃 telemetry settlement

### 误判四：output close 会兜底补记一笔 outcome

错在漏掉：

- close 路径会等 generation / delivery，但不会主动做 `logSuggestionOutcome(...)`

### 误判五：99 已经解释完 suggestion accounting，这一页是重复

错在漏掉：

- 99 讲 delivery and delayed accounting
- 102 讲 post-delivery cleanup and missing settlement

## 第九层：稳定、条件与内部边界

### 稳定可见

- `lastEmitted` 表示 suggestion 已真实交付，不表示 outcome 已结算。
- `logSuggestionOutcome(...)` 只在下一次 prompt 到来时才会结算 accepted / ignored。
- `interrupt` 与 `end_session` 可以让已交付 suggestion 直接失去 telemetry settlement。
- output close 不会自动补记 suggestion outcome。

### 条件公开

- suggestion 是否已经进入 `lastEmitted`，会决定后续是“未交付直接放弃”，还是“已交付但未结算”。
- 当前后续动作是 prompt、interrupt、end_session 还是直接 close，会决定这条 suggestion 是否最终有 settled outcome。
- 即使进入 prompt 分支，如果当前输入抽不到真正 text，`lastEmitted` 也可能在没有 outcome 的情况下被清掉。

### 内部 / 灰度层

- `pendingLastEmittedEntry` 在某些中断分支里未被同步清掉的 staging 细节。
- 具体 telemetry event 名、内部 ant-only payload 与后端统计消费方式。

## 第十层：苏格拉底式自检

### 问：为什么这页不能并回 99？

答：因为 99 的主语是 delivery / accounting delay；这页的主语是 post-delivery cleanup 与 missing settlement，已经不是同一层问题。

### 问：为什么这页不能并回 101？

答：因为 101 讲的是 terminal semantics 与 stream tail；这页讲的是 suggestion telemetry verdict 为何不会自动随着收口路径落账。

### 问：为什么 `interrupt` / `end_session` 值得进正文，而不只是实现细节？

答：因为它们直接改变“已显示 suggestion 是否还会留下 accepted / ignored 统计”这个对接入方和分析方都很重要的外部后果。

### 问：为什么 output close 不能被写成“suggestion 完整收口”？

答：因为它最多保证 generation / delivery 更完整，不能保证 verdict settlement 完整。

## 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts`
