# `lastMessage stays at the result`、SDK-only system events、`pendingSuggestion`、`heldBackResult` 与 `post_turn_summary`：为什么 headless print 的主结果语义不会让给晚到系统事件

## 用户目标

97 页已经把一件事钉死了：

- `session_state_changed(idle)` 不是普通 finally 状态切换，而是 authoritative turn-over signal

但继续往下一层看，读者又会碰到另一个很容易写糊的问题：

- 既然 idle、late `task_notification`、`task_progress`、`post_turn_summary` 都会在结果后面继续落流，为什么系统还坚持让 `lastMessage` 停在 result？
- 为什么这些 SDK-only system events 要按时送达，却又不能抢占“最后一条主消息”的语义主位？
- 为什么 `pendingSuggestion` 也要在 `heldBackResult` 真正发出以后才算 delivered？
- 为什么 `sessionState.ts` 甚至会担心 trailing idle event 把某些 client 的 `isWorking()` heuristics 钉在 Running？

如果这些问题不拆开，读者就会把这里误写成：

- “谁最后到达输出流，谁就是这一轮真正的最后消息。”

源码不是这样设计的。

## 第一性原理

更稳的提问不是：

- “最后一条消息是什么？”

而是五个更底层的问题：

1. 系统在区分“最后落流的事件”和“最后的主结果语义”吗？
2. 为什么 SDK-only system events 要及时到达，但又不能成为 `lastMessage`？
3. `heldBackResult` 存在时，suggestion 的交付顺序为什么也要跟着让路？
4. `post_turn_summary` 和 idle 这种尾随事件在这里属于正文，还是属于宿主状态层？
5. 如果不守这个语义主位，哪些 consumer / heuristic 会被写坏？

只要这五轴不先拆开，后续就会把：

- semantic last result vs late system tail

误写成：

- simple chronological last event

## 第二层：这里有两种“最后”概念，不是一种

从 `print.ts` 和 `sessionState.ts` 合起来看，至少要把两层“最后”拆开：

### 语义上的最后主结果

- `result`
- 或与 result 同步交付的 suggestion 语义

### 时间上的尾随系统事件

- `session_state_changed(idle)`
- finally late-drained `task_notification`
- `task_started/task_progress`
- `post_turn_summary`

系统明确要求：

- 尾随系统事件可以晚到
- 但主结果语义不能被它们挤掉

## 第三层：`print.ts` 直接写明了“`lastMessage` stays at the result”

这页最重要的一句，源码已经直接写出来了：

- SDK-only system events are excluded so `lastMessage` stays at the result
- 包括 `session_state_changed(idle)` 和 finally 里 late task_notification drain after result

这不是推理出来的偏好，而是实现层显式写死的合同。

它说明系统要的不是：

- “谁最后输出谁是主消息”

而是：

- “result 保持这一轮主结果语义，系统尾随事件不能篡位”

而且这里的“主结果语义”不是抽象修辞，而是 CLI 行为本身依赖的对象：

- `lastMessage` 在 non-verbose 路径里会决定最终输出与退出语义
- 后面还有多处 `lastMessage.type !== 'result'` 的检查
- shutdown 也只有在 `lastMessage` 是带 `is_error` 的 `result` 时才会走对应失败语义

所以如果让 trailing idle / late `task_notification` 覆盖掉 `lastMessage`，系统面对的就不是“措辞不够稳”，而是：

- `json` / 默认文本模式可能直接报 `No messages returned`
- 退出状态也可能跟真正的 result 不一致

## 第四层：为什么 SDK-only system events 要“及时但不篡位”

到这里最容易犯的错是以为：

- 既然这些事件不能当主消息，那就无所谓什么时候来

源码恰好反着做了：

- 96/97 已经说明它们必须按时落流
- 但 `lastMessage` 过滤又禁止它们夺走 result 主位

这说明系统在同时守两件事：

1. host / SDK consumer 要及时收到状态尾流
2. transcript / main result semantics 仍然必须锚在 result

所以这里更准确的说法不是：

- “这些系统事件不重要”

而是：

- “这些系统事件重要，但它们属于尾流状态层，不属于主结果层”

## 第五层：`heldBackResult` 进一步说明“主结果语义”不是按到达时间算的

`heldBackResult` 的存在已经说明：

- 结果可以被刻意压后

而 suggestion 逻辑又把这件事再往前推进了一层。

`print.ts` 对 prompt suggestion 明写了：

- Defer emission if the result is being held for background agents
- so that prompt_suggestion always arrives after result
- Only set `lastEmitted` when the suggestion is actually delivered

这句特别值钱，因为它表明：

- suggestion 的交付语义也要让位于主结果落地

系统守的不是：

- “有 suggestion 就先发 suggestion”

而是：

- “只要主结果还没真正交付，依附它的 suggestion 也不能先占位”

## 第六层：`pendingSuggestion` / `pendingLastEmittedEntry` 说明“已生成”不等于“已交付”

`suggestionState` 里专门分了：

- `pendingSuggestion`
- `pendingLastEmittedEntry`
- `lastEmitted`

而真正发生 `heldBackResult` 时，代码会：

- 把 suggestion 暂存在 pending
- 等 `heldBackResult` 真正 `output.enqueue(...)` 后
- 再把 suggestion 发出去
- 再把 `lastEmitted` 记成已交付

所以这条语义非常清楚：

- 生成顺序
- 输出顺序
- 记账顺序

并不是同一回事。

其中真正被系统当成 authoritative delivery 的，是：

- result 先落地
- suggestion 再落地

## 第七层：`post_turn_summary` 也被归入尾流系统层，而不是主结果层

`print.ts` 的 `lastMessage` 过滤名单里不止有：

- `session_state_changed`
- `task_notification`
- `task_started`
- `task_progress`

还包括：

- `post_turn_summary`

这说明系统非常明确地把这些对象看成同一类：

- 可以晚到
- 可能很重要
- 但不该重写本轮“主结果是谁”的语义判定

所以 `post_turn_summary` 在这里不是：

- 最终主结论

而是：

- 主结果之后的辅助尾流

## 第八层：`sessionState.ts` 进一步暴露了为什么这条语义边界必须存在

`sessionState.ts` 对 idle 镜像到 SDK 事件流的注释非常关键：

- idle lets scmuxd flip IDLE and show the bg-task dot instead of a stuck generating spinner
- 但在某些 client 里，trailing idle event currently pins them at "Running..." 的 heuristic 风险仍存在

这条注释很值钱，因为它说明：

- consumer 真的会把尾随系统事件拿去做状态 heuristic

也正因为如此，系统才更要把：

- “宿主状态尾流”

和：

- “主结果消息语义”

分开，不然某些 client 既会在状态层被写坏，也会在 transcript/结果层被写坏。

## 第九层：为什么 98 不和 97 合并

97 回答的是：

- 为什么 idle 是 authoritative turn-over signal

98 继续往下后，主语已经换成：

- 为什么 authoritative tail signals 仍然不能抢走 result 的 semantic last-message 地位

前者讲：

- idle signal semantics

后者讲：

- semantic result rank vs late system tail

主语不同，不该揉成一页。

## 第十层：最常见的假等式

### 误判一：谁最后输出，谁就是这一轮最后的主消息

错在漏掉：

- 系统明确要求 `lastMessage` 停在 result
- 而且 CLI 的最终输出与退出语义真的依赖这一点

### 误判二：SDK-only system events 既然不算主消息，就无所谓顺序

错在漏掉：

- 它们必须及时到达，只是不能篡位

### 误判三：suggestion 一生成就算已经交付

错在漏掉：

- `heldBackResult` 存在时，suggestion 会被 pending，直到 result 真正落地

### 误判四：`post_turn_summary` 属于最终主结论层

错在漏掉：

- 它也被列进 `lastMessage` 过滤的 SDK-only/system tail 家族

### 误判五：97 已经讲过 idle，这页只是重复

错在漏掉：

- 97 讲 idle 为什么可信
- 98 讲可信的尾流系统事件为什么仍不能成为 semantic last result

## 第十一层：稳定、条件与内部边界

### 稳定可见

- headless `print` 明确把 `lastMessage` 语义锚在 result，而不是锚在最后到达的 SDK-only system event。
- `session_state_changed(idle)`、late `task_notification`、`task_progress`、`post_turn_summary` 都属于尾流系统层。
- `heldBackResult` 存在时，suggestion 也必须让位于主结果的实际交付顺序。
- “已生成”不等于“已交付”；suggestion 的记账也遵守这一点。

### 条件公开

- 是否存在 `heldBackResult` 会改变 suggestion 的输出与记账时机。
- 不同 consumer 可能拿尾随系统事件去做 heuristics，因此这条语义边界会直接影响 host 行为。
- 不是每轮都会出现 late tail，但系统合同必须为其保留语义主位边界。

### 内部 / 实现层

- `pendingSuggestion`、`pendingLastEmittedEntry`、`lastEmitted` 的细节。
- `lastMessage` 过滤的具体名单。
- `post_turn_summary` 与 `task_summary` 的细分职责。

## 第十二层：苏格拉底式自检

### 问：为什么这页最先该拆 `heldBackResult` 和 suggestion 的关系？

答：因为它最直接证明“主结果语义不是按生成时间算，而是按真实交付顺序算”。

### 问：为什么 `post_turn_summary` 也值得写进正文？

答：因为它证明被排除在 semantic last result 之外的，不只是 idle 或 task bookend，而是一整个尾流系统层。

### 问：为什么 `sessionState.ts` 的 heuristic 风险能当证据？

答：因为它说明这条边界不是文档偏好，而是真会影响 consumer 行为的运行时合同。

## 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/utils/sessionState.ts`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
