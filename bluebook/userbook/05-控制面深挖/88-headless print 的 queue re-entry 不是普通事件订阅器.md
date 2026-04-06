# `running`、`peek(isMainThread)`、`drainCommandQueue`、`setOnEnqueue`、cron `onFire` 与 post-finally recheck：为什么 headless print 的 queue re-entry 不是普通事件订阅器

## 用户目标

87 页已经把 `print` 的 active teammate polling 和 unread mailbox ingestion 拆出来了：

- active teammates 还活着，就持续 poll
- unread teammate mailbox 会被折返进主 run loop

但如果继续再往下一层看，读者又会撞上另一个很容易被想当然带偏的问题：

- 为什么 `enqueue(...)` 之后不能简单理解为“队列里有东西，订阅器自然会处理”？
- 为什么 `print.ts` 要维护一个 `running` 互斥标志？
- 为什么 `run()` 在 finally 里先把 `running = false`，然后又要在后面立刻 `peek(isMainThread)` 再补一次 `run()`？
- 为什么 UDS inbox callback、cron scheduler、orphaned permission callback 都是“enqueue + kick off run()”，而不是靠某个总是在线、会在 idle 时自动排空队列的 subscriber？

如果这些问题不拆开，读者就会把 headless `print` 的 queue 语义误写成：

- “就是个普通事件循环，谁 enqueue 谁就自动被后台消费者拿走。”

源码不是这样工作的。

## 第一性原理

更稳的提问不是：

- “这里是不是有个队列？”

而是四个更底层的问题：

1. 这个队列有没有一个在 idle 时负责自动排空的 subscriber？
2. `run()` 是被动被队列驱动，还是被外部显式 kick？
3. `running` 保护的是并发执行，还是消息不丢失？
4. `peek(isMainThread)` 的存在是在优化性能，还是在修补 race window？

只要这四轴不先拆开，后续就会把：

- explicit run-loop re-entry

误写成：

- passive event subscription

## 第二层：headless print 的主循环其实是 “单消费者 + 显式再入”

从 `print.ts` 看，这条主循环的骨架可以先压成三句：

1. 只有一个 `run()` 在消费主线程队列
2. 任何跨 idle 边界的外部来源想让队列被处理，都要显式 `void run()`
3. `run()` 自己在退出前还要再做一次 post-finally queue re-check，防止 race 导致消息 stranded

这三句比“有一个队列”更接近真实设计。

## 第三层：`running` 首先是一把互斥锁，不是后台订阅器的状态灯

`print.ts` 在顶层就定义了：

- `let running = false`

这把锁的作用不是：

- 表示系统是否空闲

而是：

- 保证同一时刻只有一个 `run()` 在消费主线程命令队列

这能解释为什么这么多地方都会写：

- `enqueue(...)`
- `void run()`

而不是害怕“会不会重复启动两个消费者”。

因为真正的消费者只有一个：

- `run()` 自己

别的入口只是：

- try-kick the consumer

## 第四层：`drainCommandQueue()` 明确只吃 main-thread commands

`print.ts` 里这段逻辑非常关键：

- `const isMainThread = (cmd) => cmd.agentId === undefined`
- `while ((command = dequeue(isMainThread))) { ... }`

注释也讲得很直白：

- subagent notifications 不在这里 drain
- 由 subagent 自己的 mid-turn gate 处理

所以 headless print 的主 run loop 从一开始就不是：

- “一个总管一切的全局消息总线”

而是：

- “一个只 drain main-thread queued commands 的单消费者”

这也是为什么：

- 任何主线程外部事件想让事情继续
- 都必须主动把东西 enqueue 到这条 main-thread queue
- 再显式 kick `run()`

## 第五层：post-finally queue re-check 是这条设计最值钱的证据

这是这页最值得钉死的一段代码。

finally 里，`print.ts` 会：

- flush internal events
- `notifySessionStateChanged('idle')`
- drain sdk events
- `running = false`
- `idleTimeout.start()`

然后，离开 finally 之后，代码又紧接着写：

- 如果 `peek(isMainThread) !== undefined`
- 就 `void run(); return`

旁边的注释明确解释了 race：

- 可能在最后一次 `dequeue()` 之后、`running = false` 之前
- 又有新消息到达并调用了 `run()`
- 但那个调用看到 `running === true`，于是直接返回
- 结果队列里会留下 stranded message

这说明 `peek(isMainThread)` 的存在不是装饰，而是在修一个真实语义漏洞：

- 单消费者 + 显式 kick

如果没有这个 post-finally recheck，这条系统就不是“慢一点”，而是：

- 可能丢 run opportunity

## 第六层：为什么这证明它不是普通事件订阅器

如果这是一条普通的 queue subscriber 设计，那么：

- 队列里有东西
- subscriber 自己会继续醒来

就不需要在 finally 之后再手写：

- `peek(...)`
- `void run()`

更不需要专门解释：

- 某个消息会 stranded in the queue

只有在这种设计里：

- 外部事件只是 try-kick
- 真正 drain 必须靠单个 `run()` 实例继续拿锁执行

这个补丁式再入检查才变得必要。

但要把这句写准，还得和 REPL 做对照。

统一 command queue 在 `messageQueueManager.ts` 里每次变更都会 `notifySubscribers()`；interactive REPL 则通过 `useQueueProcessor()` 配合 `useSyncExternalStore(subscribeToCommandQueue, ...)`，在：

- queue 发生变化
- 当前没有 query 在跑
- 也没有本地 JSX UI 阻塞输入

时调用 `processQueueIfReady()` 去继续消费队列。

这才更接近：

- “队列变化本身会唤醒一个 idle drain consumer”

而 `print.ts` 虽然也订阅了 `subscribeToCommandQueue(...)`，但那段订阅只做一件事：

- 当当前 turn 持有 `abortController`，且队列里出现 `priority = 'now'` 的消息时
- 中断当前 in-flight turn

它不是 idle drain 订阅器，也不会在空闲时替你 dequeue 主线程队列。

所以这里真正该写的是：

- headless print 没有像 REPL 那样负责 idle drain 的 queue subscriber

## 第七层：UDS inbox callback 直接暴露了“没有 idle drain 总订阅器”这件事

`print.ts` 设置 UDS inbox callback 时，逻辑非常简单：

- `setOnEnqueue(() => { if (!inputClosed) void run() })`

这句最关键的含义不是：

- “UDS 收到消息了”

而是：

- “有人 enqueue 了，但系统不会自己保证 idle 状态下的 main-thread queue 被 drain，所以这里显式 kick 一次 run”

如果存在一个像 REPL 那样总是在线、负责 idle drain 的 subscriber，这里本不需要：

- 手动 `void run()`

这就是 88 页想强调的第一种外部再入入口。

## 第八层：cron scheduler 的注释把设计意图写得更直白

cron scheduler 这段注释几乎是本页的明文答案：

- fired prompts 会 `enqueue + kick off run()`
- unlike REPL, there's no queue subscriber here that drains on enqueue while idle
- `run()` mutex makes this safe
- post-run recheck picks up queued command

这几句已经把 headless print 的队列模型说透了：

- 没有像 REPL 那样在 idle 时因 queue 变化自动 drain 的 subscriber
- 只有显式 kick 的单消费者
- 互斥锁负责防并发
- post-run recheck 负责补 race window

所以最不该写错的一句是：

- headless print 的 queue 不是“订阅式自动排空”，而是“显式触发式排空”

## 第九层：orphaned permission callback 再次复用同一模式

`structuredIO.setUnexpectedResponseCallback(...)` 处理 orphaned permission response 时，也会传一个：

- `onEnqueued: () => { void run() }`

注释说明得很直接：

- 一个 session 的第一条消息，可能不是用户 prompt，而是 orphaned permission check
- 所以必须 kick off the loop

这和 UDS / cron 的模式完全一致：

- enqueue alone is not enough
- you must wake the single consumer

所以这里不是某个特例，而是 headless print queue 模型的一致外露。

顺手也要把一句话收紧：

- 不是每个 `enqueue(...)` 点都会立刻 `void run()`

例如 MCP channel notification handler 会把消息 enqueue 到同一条队列里，但不立刻 kick `run()`；它更接近：

- 借当前正在运行的 turn
- 或 post-run recheck
- 来完成后续收口

所以本页更准确的结论不是：

- “所有 enqueue 点都会自己启动消费者”

而是：

- “那些必须跨 idle 边界唤醒主消费者的入口，会显式 kick `run()`”

## 第十层：`waitingForAgents` 进一步证明 run() 不是“拿一条命令就走”

`run()` 在主 command drain 完后，还会根据：

- 是否还有 running background tasks
- 是否还有 main-thread queued commands

进入一个：

- `do { ... } while (waitingForAgents)`

的循环。

这意味着 `run()` 不是：

- 一次 dequeue -> 一次消费 -> 结束

而是：

- drain commands
- 在必要时继续等待 agents
- 然后再 loop back 看有没有新主线程命令

这更像：

- manually-driven event pump

而不是：

- passive subscriber callback

## 第十一层：为什么 88 不和 87 合并

87 页已经回答的是：

- active teammates 还活着时
- `print` 会持续 poll unread mailbox

88 页继续往下后，问题已经换了：

- unread / cron / UDS / orphaned response 被 enqueue 以后
- 为什么还要显式 kick `run()`
- 为什么 finally 后还要再 peek 一次队列

也就是说：

- 87 讲 mailbox ingestion loop
- 88 讲 queue re-entry / single-consumer pump semantics

两者虽然紧邻，但主语不同，不该揉成一篇。

## 第十二层：最常见的假等式

### 误判一：`enqueue(...)` 之后自然会有人来处理

错在漏掉：

- 这里没有总是在线的 idle subscriber

### 误判二：`running` 只是“当前忙不忙”的 UI 状态

错在漏掉：

- 它首先是 queue consumer 的互斥锁

### 误判三：post-finally `peek(isMainThread)` 只是性能优化

错在漏掉：

- 它是在补 stranded queue item 的 race window

### 误判四：UDS / cron / orphaned permission 是三套完全不同的流程

错在漏掉：

- 它们在 queue 模型上都复用：enqueue + explicit `run()`

### 误判五：headless print 的 run loop 跟 REPL 一样有个持续排队订阅器

错在漏掉：

- REPL 的 subscriber 链是 `messageQueueManager.ts` + `useQueueProcessor.ts`
- `print.ts` 里的 `subscribeToCommandQueue(...)` 只服务 `'now'` 中断，不负责 idle drain

### 误判六：所有 enqueue 点都会自己 `void run()`

错在漏掉：

- 有些来源只 enqueue，由当前活跃 run 或 post-run recheck 兜底
- 显式 kick 主要出现在跨 idle 边界的外部入口

## 第十三层：稳定、条件与内部边界

### 稳定可见

- headless `print` 的主线程队列不是被动订阅式排空，而是单消费者 `run()` 配合显式再入触发来排空。
- `running` 保护的是单消费者互斥。
- 跨 idle 边界的外部来源，如 UDS、cron、orphaned permission，会通过 `enqueue + run()` 触发这条主循环。
- post-finally `peek(isMainThread)` recheck 是这条模型里防止 stranded queue item 的关键补偿。

### 条件公开

- 不同 enqueue 来源的触发前提不同：UDS 受 `!inputClosed` 限制，cron 受 feature/gate 与 `isLoading` 限制，orphaned permission 受 unexpected response 触发。
- 并非每个 enqueue 来源都会立刻 `void run()`；例如 channel notification handler 可能只 enqueue，由活跃 turn 或 post-run recheck 收口。
- `waitingForAgents` 只在存在 background task 或主线程队列待处理时继续循环。
- proactive tick 也会受 `peek(isMainThread) === undefined && !inputClosed` 约束。

### 内部 / 实现层

- `POLL_INTERVAL_MS`、`idleTimeout.start()`、`runPhase` 具体值。
- `canBatchWith(...)`、`joinPromptValues(...)` 的批处理细节。
- `peek(isMainThread)` 的具体 predicate 定义。
- `structuredIO.flushInternalEvents()` 与 `drainSdkEvents()` 的顺序。

## 第十四层：苏格拉底式自检

### 问：如果 finally 已经把 `running = false`，为什么不等下一次 enqueue 自己触发？

答：因为那次 enqueue 可能早在 `running` 还是 true 时就发生了，并且那次触发已经因为看到 mutex 被占而返回了。post-finally recheck 就是修这个窗口。

### 问：如果有 cron/UDS/orphaned callback，为什么还说没有 subscriber？

答：因为这些不是持续 drain 的订阅器，只是外部来源在 enqueue 后显式 kick 一次 `run()`。真正 drain 队列的仍只有单个 `run()`。

### 问：为什么这页不算重复写 87 的 polling？

答：因为 87 讲的是“为什么要一直看 mailbox”；88 讲的是“看到了以后，为什么要通过单消费者 re-entry 模型折返进主 loop”。前者讲 ingest，后者讲 pump。

### 问：为什么这页值得单独成文，而不是附在 `print.ts` 总论里？

答：因为这条 queue re-entry 语义是 headless print 最容易被误解的运行时合同之一，单独拆开更稳，也更利于后续继续压图。

## 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/utils/messageQueueManager.ts`
- `claude-code-source-code/src/hooks/useQueueProcessor.ts`
- `claude-code-source-code/src/utils/queueProcessor.ts`
