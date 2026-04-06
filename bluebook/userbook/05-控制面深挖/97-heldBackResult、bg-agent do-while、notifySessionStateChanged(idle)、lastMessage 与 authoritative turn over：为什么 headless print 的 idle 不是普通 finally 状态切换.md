# `heldBackResult`、bg-agent do-while、`notifySessionStateChanged(idle)`、`lastMessage` 与 authoritative turn over：为什么 headless print 的 idle 不是普通 finally 状态切换

## 用户目标

96 页已经把 `drainSdkEvents()` 的多站位 flush ordering 拆开了。

但如果继续再往下一层看，读者又会碰到另一个特别容易被低估的问题：

- 为什么 `notifySessionStateChanged('idle')` 一定要放在这个位置？
- 为什么源码要特地强调：idle 必须晚于 `heldBackResult` flush 和 bg-agent do-while exit？
- 为什么 finally 里的 idle 不是“函数快结束了，顺手切个状态”？
- 为什么 late `task_notification` drain 和 `lastMessage stays at the result` 也会牵扯进 idle 语义？

如果这些问题不拆开，读者就会把这里误写成：

- “`idle` 不过是 finally 里的一次普通状态回写。”

源码不是这样设计的。

## 第一性原理

更稳的提问不是：

- “这里什么时候切到 idle？”

而是五个更底层的问题：

1. 这个 idle 信号是在描述“代码跑到 finally”，还是在描述“这一回合真正结束”？
2. 为什么 `heldBackResult` 没 flush 完前不能先 idle？
3. 为什么 bg-agent do-while 没退出前不能先 idle？
4. 为什么 late `task_notification` bookend 也会影响 idle 的可信度？
5. 为什么这些 SDK events 虽然要在 idle 前后落流，却又不能抢走 `lastMessage` 的主位？

只要这五轴不先拆开，后续就会把：

- authoritative turn-over signal

误写成：

- ordinary finally status flip

## 第二层：这里的 idle 首先是“turn is over”信号，不是 finally 标记

`sdkEventQueue.ts` 的注释已经把这句写得很硬：

- The `'idle'` transition fires AFTER `heldBackResult` flushes and the bg-agent do-while loop exits
- so SDK consumers can trust it as the authoritative `"turn is over"` signal even when result was withheld for background agents

而且这不只是实现注释里的说法。`coreSchemas.ts` 在 SDK schema 描述里也重复了同一句合同：

- `'idle'` fires after `heldBackResult` flushes and the bg-agent do-while exits
- authoritative turn-over signal

这句话本身就是本页的核心结论：

- 这里的 idle 不是“函数快结束”
- 而是“这一轮主循环的有效结果、后台等待、迟到 bookend 都收拢完了”

所以更准确的说法是：

- idle 是 authoritative turn-over signal

不是：

- finally 中随手切换的 busy/idle 标志

## 第三层：为什么 `heldBackResult` 没 flush 完前绝不能 idle

`print.ts` 先做了一件非常关键的事：

- 如果有 `heldBackResult`，先把它 `output.enqueue(...)`
- 然后才进入 finally 里的 idle 分支

这和 `sdkEventQueue.ts` 那句注释正好对上：

- 有些 result 会因为 background agents 还活着而被压后
- 但只要 result 还没真正发出去，就不能声称“这一回合已经结束”

否则宿主会看到一种非常危险的假象：

- 状态已经 idle
- 但真正的主结果还没出来

这会直接把：

- “当前回合的最终结果什么时候落地”

和：

- “后台任务还在不在拖住当前回合”

写成两张互相打架的时间线。

所以 `heldBackResult` 在这里不是细节，而是 idle 可信度的前置条件。

## 第四层：为什么 bg-agent do-while 没退出前也不能 idle

`print.ts` 的 do-while 不是装饰结构。

它在做的是：

- drain command queue
- 检查是否还有 running background tasks
- 没有 main-thread queued commands 时就 sleep
- loop back 再看

也就是说，只要 bg-agent 仍在影响当前回合的后续收口，系统就还没有资格说：

- turn is over

这也是为什么 `sdkEventQueue.ts` 特地把：

- bg-agent do-while loop exits

写进 idle 注释，而不是只写“finally 结束时”。

更准确的说法是：

- idle 不是 run() 自己的局部结束
- idle 是 run() 对当前回合外延影响全部收口后的结束

## 第五层：late `task_notification` bookend 也是 idle 合同的一部分

`print.ts` finally 里的注释已经说得很直白：

- idle `session_state_changed` SDK event
- plus any terminal `task_notification` bookends emitted during bg-agent teardown
- should reach the output stream before we block on the next command

这说明 finally 里的 flush 不是只在保护 idle 自己，而是在保护：

- idle
- late-arriving terminal task bookends

这两者的相对顺序。

如果没有这层，宿主就可能先收到：

- idle

却稍后才收到：

- 某个真正把后台任务关掉的 terminal `task_notification`

那 host 侧就会被迫面对一个语义冲突：

- 这一回合说自己结束了
- 但任务 bookend 还没关干净

所以 idle 的可信度依赖于：

- late task bookends 也被一起收拢完

## 第六层：`lastMessage` 过滤进一步说明 idle 要“及时但不篡位”

`print.ts` 还有一个非常值钱的注释：

- SDK-only system events are excluded so `lastMessage` stays at the result
- 包括 `session_state_changed(idle)` 和 finally 里 late-drained `task_notification`

这说明系统在这里同时守着两件看似相反、其实必须并存的要求：

1. idle 和 late task bookend 必须按时落流
2. 但它们不能抢走 result 作为主结果消息的语义主位

所以 idle 的设计目标不是：

- “最后一个消息就是 idle”

而是：

- “宿主必须及时收到 authoritative turn-over signal，但 transcript/主结果语义仍由 result 占位”

这也再次证明：

- idle 不是正文结果层
- idle 是宿主状态层

## 第七层：为什么 finally 里的 idle 仍然不是“finally 层对象”

表面上看，它确实发生在 finally 里。

但源码的真实合同已经把它从 finally 的局部语义里拉出来了：

- 它要晚于 `heldBackResult`
- 晚于 bg-agent do-while
- 还要和 late task bookend 排序
- 还不能抢 result 的 `lastMessage`

这四条一加上，idle 的主语已经不再是：

- finally 块内的一次状态切换

而是：

- headless turn completion protocol 的收口信号

## 第八层：为什么 97 不和 96 合并

96 回答的是：

- `drainSdkEvents()` 为什么要多站位、多次冲刷

97 继续往下后，问题已经换成：

- 这些 flush 最终在服务哪个最关键的时序结论
- 也就是 `idle` 为什么能被信任为 authoritative turn-over signal

前者讲：

- flush ordering contract

后者讲：

- idle signal semantics

主语不同，不该揉成一页。

## 第九层：最常见的假等式

### 误判一：idle 就是 finally 结束时的状态回写

错在漏掉：

- 它还受 `heldBackResult`、bg-agent do-while、late bookends 的共同约束

### 误判二：只要 main loop 不在跑了，就可以先发 idle

错在漏掉：

- 结果可能还被 hold back
- 背景任务 teardown 也可能还在补 late close bookend

### 误判三：idle 既然很重要，那它理应成为 `lastMessage`

错在漏掉：

- 系统明确要求 result 保持主结果语义主位

### 误判四：late `task_notification` 只是体验细节，不影响 idle 定义

错在漏掉：

- finally 注释明确把它们纳入 idle 前的收口合同

### 误判五：96 已经讲过 flush 了，这页没必要

错在漏掉：

- 96 讲的是“怎么 flush”
- 97 讲的是“这些 flush 最终在让 idle 成为什么”

## 第十层：稳定、条件与内部边界

### 稳定可见

- headless `print` 的 `session_state_changed(idle)` 是 authoritative turn-over signal，不是普通 finally 状态切换。
- 它必须晚于 `heldBackResult` flush 和 bg-agent do-while exit。
- finally 里的 late terminal `task_notification` bookends 也是 idle 合同的一部分。
- 这些 SDK events 要及时落流，但不能抢走 result 的主结果语义。

### 条件公开

- 是否存在 `heldBackResult`、bg-agent teardown、late terminal bookends，会改变 idle 这次收口的实际价值。
- 非交互/headless 路径下，SDK consumer 才真正消费这条 idle 信号。
- 如果没有背景任务或 hold-back，idle 仍然走同一合同，只是保护对象更少。

### 内部 / 实现层

- `runPhase`、`finally_post_flush`、internal event flush 的具体顺序。
- idleTimeout 与 running mutex 的联动。
- `lastMessage` 过滤和 transcript 持久化的具体实现细节。

## 第十一层：苏格拉底式自检

### 问：为什么这页最先该拆 `heldBackResult`，而不是再去写更多 background task 例子？

答：因为 `heldBackResult` 最能直接证明 idle 不是“函数结束”，而是“结果真正落地以后”的状态。

### 问：为什么 late task bookend 值得进正文？

答：因为它说明 idle 的定义不仅包含主结果，还包含后台 teardown 的补尾收口。

### 问：为什么 `lastMessage` 过滤能成为 idle 语义的证据？

答：因为它证明系统要的是“可被宿主信任的 idle”，而不是“把 idle 挤成主结果消息”。

## 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/utils/sdkEventQueue.ts`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
