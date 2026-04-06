# headless print queue reentry 拆分记忆

## 本轮继续深入的核心判断

87 页已经把 headless print 的 mailbox ingestion loop 拆开了。

下一步最自然不是继续围绕 unread mailbox 写更多变体，而是继续往下压到：

- queue re-entry
- single-consumer pump

因为这才是 headless print 运行时合同里最容易被想成“普通事件订阅器”的地方。

## 为什么这轮必须把 queue re-entry 单列

如果不单列，读者会把 87 的结论停在：

- print 会持续 poll unread mailbox

但更深一层真正关键的事实是：

- poll 到的东西不是自动被某个订阅器接走
- 而是必须显式 `enqueue + run()`
- 并靠 post-finally `peek(...)` 修 race

## 本轮最关键的新判断

### 判断一：这里只有一个真正的 main-thread consumer

那就是：

- `drainCommandQueue()` inside `run()`

### 判断二：UDS / cron / orphaned callback 都是显式 kick，不是 subscriber

它们都只是：

- enqueue
- `void run()`

### 判断二补正：`“没有 subscriber”` 这句话说得太粗

更准确的说法应该是：

- 没有像 REPL 那样负责 idle drain 的 subscriber

因为源码里还有两类容易混淆的东西：

- REPL 侧确实有 `messageQueueManager.ts` + `useQueueProcessor.ts` 形成的订阅式 queue drain
- `print.ts` 自己也订阅了 `subscribeToCommandQueue(...)`，但只为了 `'now'` priority interrupt，不负责 drain

这轮要把这个对照补进正文和索引，避免把“没有 idle drain subscriber”写成“完全没有任何 subscriber”。

### 判断三：post-finally `peek(isMainThread)` 是为 stranded queue item 补洞

这不是可有可无的优化，而是这套 single-consumer 模型的关键补偿。

### 判断四：88 必须和 87 分开

87 讲 mailbox ingestion；88 讲 queue pump / re-entry。继续压在一起会重新失焦。

## 为什么这轮不直接写更大的 headless queue 总图

可以，但现在更值钱的是先把：

- explicit re-entry != passive subscription

这条判断钉死。

如果不先写 88，后面即使画总图，读者仍会把 finally 之后那次 `peek(...)` 看成“可有可无的细节”。

但正文也不能因此过度绝对化。

例如：

- MCP channel notification handler 会只 enqueue、不立刻 `run()`

这提醒我，真正稳定的结论不是“所有 enqueue 点都手动 kick”，而是：

- 跨 idle 边界、必须唤醒主消费者的入口，会显式 kick `run()`
- 其他来源可能借活跃 turn 或 post-run recheck 收口

## 苏格拉底式自审

### 问：为什么 finally 后的 `peek(...)` 值得单列一页？

答：因为它把整个模型暴露出来了。只有在“外部来源只能 try-kick，真正 drain 靠单消费者”这套结构里，那个补偿才必不可少。

### 问：为什么不把 cron/UDS/orphaned 各自做成长文？

答：因为这轮主轴是它们共享的 queue model，而不是各自业务面。业务面后续需要时再拆。

### 问：为什么 88 不算重复写 84/86 的 host path？

答：84 讲宿主横向差异，86 讲 drain 协议，88 讲 queue re-entry 机制。它们不是同一个层级。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/88-running、peek(isMainThread)、drainCommandQueue、setOnEnqueue、cron onFire 与 post-finally recheck：为什么 headless print 的 queue re-entry 不是普通事件订阅器.md`
- `bluebook/userbook/03-参考索引/02-能力边界/77-Headless print queue re-entry and single-consumer pump 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/88-2026-04-06-headless print queue reentry 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小改动：

- 长文层只补 88
- 索引层只补 77
- 记忆层只补 88

不把 81-88 重新揉成一篇大而泛的 headless/shutdown 总论。

## 下一轮候选

1. 把 81-88 压成一张 termination family 八层导航图。
2. 单独拆 teammate pill strip、spinner tree、detail dialog 三种前台状态面的厚度差。
3. 单独拆 headless `print` 的 batching 与 `canBatchWith/peek` 组合语义。
