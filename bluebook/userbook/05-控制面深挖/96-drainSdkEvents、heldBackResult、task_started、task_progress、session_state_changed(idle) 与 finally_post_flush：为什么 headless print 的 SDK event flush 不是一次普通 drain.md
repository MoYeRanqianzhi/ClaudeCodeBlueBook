# `drainSdkEvents`、`heldBackResult`、`task_started`、`task_progress`、`session_state_changed(idle)` 与 `finally_post_flush`：为什么 headless print 的 SDK event flush 不是一次普通 drain

## 用户目标

95 页已经把 task result 的回流路径拆开了：

- XML re-entry 路
- direct SDK close 路

但如果继续往下一层看，读者又会撞上一种很容易被低估的实现：

- `drainSdkEvents()` 在 `print.ts` 里为什么要出现这么多次？
- 为什么 mid-turn、do-while 顶部、finally/idle 前后都要 flush？
- 为什么还要专门和 `heldBackResult`、`session_state_changed(idle)`、late `task_notification` bookend 排顺序？
- 为什么这不是简单的“有空就把 SDK 队列倒出去”？

如果这些问题不拆开，读者就会把这里误写成：

- “SDK event queue 不过是随手清空一下，哪里 flush 都差不多。”

源码不是这样设计的。

## 第一性原理

更稳的提问不是：

- “这里有没有 drain SDK events？”

而是五个更底层的问题：

1. 这次 flush 是想让谁先看见事件，host 还是模型？
2. 这次 flush 防的是进展被拖后，还是 result 抢跑，还是 idle 信号落后？
3. 如果只保留一次 drain，会丢掉哪种时序保证？
4. `heldBackResult` 与 `session_state_changed(idle)` 在这里为什么都要和 drain 排顺序？
5. 这里讨论的是“有没有事件”，还是“事件按什么顺序落流”？

只要这五轴不先拆开，后续就会把：

- staged SDK event flush ordering

误写成：

- one generic queue drain

## 第二层：`drainSdkEvents()` 在这里不是一次，而是至少三类语义站位

从 `print.ts` 看，`drainSdkEvents()` 至少出现在三类关键位置：

1. do-while 顶部，先于 command queue drain
2. mid-turn 输出阶段，先于 result 或普通消息落流
3. finally / idle transition 之前与之后的收尾冲刷

它们都叫 `drainSdkEvents()`，但在运行时合同里不是一回事。

## 第三层：do-while 顶部那次 flush 是“进展抢先”，不是“顺手清空”

`print.ts` 在主 do-while 顶部的注释已经把意图写明：

- Drain SDK events (`task_started`, `task_progress`) before command queue
- so progress events precede `task_notification` on the stream

这说明第一类 flush 的核心目标是：

- 在 queued command 被重新 drain 之前
- 先把宿主态的 start/progress 事件推到流上

它保护的不是：

- 队列别积压

而是：

- 进展信号不要落后于后面的结果 envelope

如果没有这一层，读者和宿主就可能先看到：

- 一条 `task-notification` 结果

再补看到：

- 本该更早出现的 `task_started/task_progress`

那就会把 runtime 时序写反。

## 第四层：mid-turn 那几次 flush 是“不要让 result 抢跑”

`print.ts` 在真正把消息推到输出流前，又做了两种 flush。

### result 前 flush

注释写得很直白：

- Flush pending SDK events so they appear before result on the stream

也就是说，`message.type === 'result'` 时，这一层保护的是：

- 先把已累积的 SDK 事件发出去
- 再发本 turn 的 result

### 非 result 输出前 flush

另一段注释同样明确：

- Flush SDK events (`task_started`, `task_progress`) so background agent progress is streamed in real-time, not batched until result

所以 mid-turn flush 的核心问题不是：

- “这里也顺便清一下”

而是：

- 不要让 progress 只能等到 result 才一起被看见

这两层共同保证的是：

- 进展先于结果
- 进展不被 result 一起拖后

## 第五层：`heldBackResult` 说明 flush 还在给“被压住的 result”让路

`print.ts` 有个非常值钱的对象：

- `heldBackResult`

它的语义是：

- 后台 agent 还在跑时，不立刻把 result 发出去

而 `sdkEventQueue.ts` 对 `session_state_changed(idle)` 的注释又补上了另一层时序合同：

- `'idle' transition fires AFTER heldBackResult flushes and the bg-agent do-while loop exits`

这说明：

- 有些 result 会被刻意压后
- 但在它们被压后的这段时间里，SDK event queue 不能跟着一起闷住

否则 host 会看到：

- result 没出来
- progress 也不出来
- idle 还没到

那整个后台任务时序就会塌掉。

所以 `drainSdkEvents()` 在这里的职责之一，是给：

- held-back result 之前的宿主事件

留出独立落流空间。

## 第六层：finally / idle 前后的 flush 是“不要让 idle 抢在晚到 bookend 前面”

`finally` 里的那次 flush 是本页最容易被误写成“收尾顺手清空”的地方。

源码注释其实讲得非常精确：

- 先 `notifySessionStateChanged('idle')`
- 然后 drain，使 idle `session_state_changed` SDK event
- 以及 bg-agent teardown 期间可能晚到的 terminal `task_notification` bookends
- 在真正阻塞等下一条命令前先落到输出流

这说明 finally 那次 flush 保护的不是：

- “退出前再清一次缓存”

而是：

- idle 事件和晚到 close bookend 的相对顺序

如果没有这层，系统就会出现一个很糟糕的时序歧义：

- 宿主先被告知 idle
- 但某些 terminal `task_notification` 还没真正落流

那 host 侧的 bg-task dot、subagent panel、turn-over 判定就会出现“任务好像没关干净，主循环却先 idle 了”的错觉。

## 第七层：`lastMessage` 过滤再次证明这些 flush 有严格层级含义

`print.ts` 还有一段很容易被忽略的过滤逻辑：

- SDK-only system events 会从 `lastMessage` 候选中被排除
- 注释明确说，是为了让 `lastMessage` 继续停在真正的 result 上
- 包括 finally 里 late-drained 的 `task_notification` 和 `session_state_changed(idle)`

这说明 SDK flush 再多，也不等于这些事件就被当成：

- turn 的正文结果

它们被设计成：

- 必须按时落流
- 但又不能篡改 result 作为主结果消息的地位

所以 `drainSdkEvents()` 的时序设计本质上是在同时守两件事：

1. 让 host 及时看到 SDK 事件
2. 不让这些事件抢占 result/lastMessage 的语义主位

## 第八层：为什么 96 不和 93/94/95 合并

93 讲的是：

- triad vs queue lifecycle

94 讲的是：

- progress projection 属于宿主图层

95 讲的是：

- task result return-path split

96 继续往下后，主语已经换成：

- 同一条 SDK event queue 为什么要分阶段、多次、按顺序冲刷

也就是说，这页讲的是：

- flush ordering contract

而不是：

- 事件家族或回流路径本身

## 第九层：最常见的假等式

### 误判一：`drainSdkEvents()` 到处都一样，只是多余保险

错在漏掉：

- do-while 顶部、mid-turn、finally 各自保护不同的时序合同

### 误判二：progress 晚一点和 result 一起出来也没关系

错在漏掉：

- 源码明确要求 progress 先于 `task_notification` / result 落流

### 误判三：finally 那次 drain 只是退出前清缓存

错在漏掉：

- 它是在保护 idle 事件与晚到 terminal bookend 的顺序

### 误判四：既然 SDK events 会多次 drain，它们自然也会变成 `lastMessage`

错在漏掉：

- `lastMessage` 过滤明确把这些 SDK-only system events 排除在外

### 误判五：`heldBackResult` 只影响 result，不影响 SDK flush 设计

错在漏掉：

- `session_state_changed(idle)` 的注释明确把 heldBackResult flush 也纳入了时序合同

## 第十层：稳定、条件与内部边界

### 稳定可见

- `drainSdkEvents()` 在 headless `print` 里不是一次普通 drain，而是多站位的时序护栏。
- do-while 顶部 flush 保护 progress/start 先于 queued result layer 落流。
- mid-turn flush 保护 progress 不被 result 拖后。
- finally flush 保护 idle 事件和晚到 terminal bookend 在阻塞前先落到输出流。
- 这些 SDK-only 事件虽然要按时落流，但不会夺走 result 的 `lastMessage` 语义主位。

### 条件公开

- 是否存在 `heldBackResult`、bg-agent teardown、晚到 terminal bookend，会改变 flush 的实际价值。
- 只有在非交互/headless 路径里，SDK event queue 才会被 drain/消费。
- 结果是 result 还是普通消息，也会改变 mid-turn flush 的保护目标。

### 内部 / 实现层

- `runPhase` 与具体 flush 站位。
- `heldBackResult`、suggestionState 与 bg-agent 生命周期的精细联动。
- `lastMessage` 过滤和 transcript 持久化的具体判定范围。

## 第十一层：苏格拉底式自检

### 问：为什么这页最先该拆 finally drain，而不是继续列更多 task 类型？

答：因为 finally 那次 drain 最像“顺手清缓存”，也是最容易把系统真正的 idle/bookend 时序合同写没的一处。

### 问：为什么 `heldBackResult` 值得在这一页出现？

答：因为一旦 result 可以被压后，SDK 事件什么时候先落流就不再是“体验优化”，而是状态一致性的必要条件。

### 问：为什么 `lastMessage` 过滤能成为 flush 论据？

答：因为它证明系统要的不是“多发事件”，而是“既及时，又不篡位”的时序布局。

## 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/utils/sdkEventQueue.ts`
