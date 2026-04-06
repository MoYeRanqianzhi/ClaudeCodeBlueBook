# `<status>`、statusless ping、`emitTaskTerminatedSdk`、`enqueuePendingNotification` 与 double-emit：为什么 headless print 的 `task-notification` 不是同一种关单信号

## 用户目标

90 页已经把 `task-notification` 的双重消费者合同讲清了：

- SDK consumer 会消费它
- 模型也会继续消费它

但继续再往下一层，读者又会撞上另一组很容易写错的问题：

- 既然都叫 `task-notification`，它们是不是都在表达“任务结束了”？
- 为什么有的通知必须带 `<status>` 才能关单？
- 为什么有的 stall / progress ping 故意不带 `<status>`？
- 为什么某些路径不走 XML queue，而要直接 `emitTaskTerminatedSdk(...)`？
- 为什么源码反复强调：如果两条路都发，会 double-emit？

如果这些问题不拆开，读者就会把这里误写成：

- “`task-notification` 本质上都是一种完成信号，只是字段多少不同。”

源码不是这样设计的。

## 第一性原理

更稳的提问不是：

- “这里有没有 `task-notification`？”

而是五个更底层的问题：

1. 这里真正承担“关任务账”的信号到底是什么？
2. 没有 `<status>` 的通知在运行时里算 close，还是只算 ping？
3. direct `emitTaskTerminatedSdk(...)` 和 XML queue 到底谁在负责 terminal close？
4. 为什么源码宁可分两条路，也不愿意两边都发？
5. 这一层讨论的是 dual-consumer envelope，还是 close-signal family？

只要这五轴不先拆开，后续就会把：

- multiple task-result signal families

误写成：

- one generic completion notification

## 第二层：这里至少有三种不同信号，不是一种

从 headless `print` 和 task runtime 合起来看，至少要把这三类东西拆开：

1. 带 `<status>` 的 terminal XML notification
2. 不带 `<status>` 的 statusless ping / stall signal
3. 不走 XML queue、直接 `emitTaskTerminatedSdk(...)` 的 terminal close

它们都和任务结果有关，但不属于同一种语义层。

## 第三层：带 `<status>` 的 XML notification 才是“可被 `print.ts` 解析成 close event”的那一类

`print.ts` 的逻辑很直接：

- 先从 XML 里匹配 `<status>`
- 只有 `statusMatch` 存在，才 `output.enqueue({ subtype: 'task_notification', ... })`

而且源码还特意做了状态归一化：

- `killed` 会映射成 SDK 侧的 `stopped`

所以更准确的说法是：

- 带 `<status>` 的 XML notification，是 terminal close bookend 的一类来源

不是：

- “任何 task-notification XML 都能关单”

## 第四层：statusless ping 不是 close，只是进度或阻塞信号

`LocalShellTask` 的 stall 检测把这件事写得非常明白：

- 它故意不带 `<status>`
- 因为 `print.ts` 把 `<status>` 视为 terminal signal
- statusless notification 会被 SDK emitter 跳过
- 它只是一类 progress ping / blocked-on-input 提示

这条注释非常值钱，因为它直接把两类对象拆开了：

### terminal close

- 带 `<status>`
- 允许 SDK consumer 关任务

### statusless ping

- 不带 `<status>`
- 允许模型和用户看到“有事发生了”
- 但不允许 SDK consumer 把任务误关成 `completed`

所以 statusless ping 的主语不是：

- “任务结束”

而是：

- “任务有进展 / 有阻塞 / 需要注意”

## 第五层：direct `emitTaskTerminatedSdk(...)` 是另一条 terminal close 路，不是补发版 XML

`sdkEventQueue.ts` 的注释已经把边界写死：

- 那些“任务进入 terminal，但不会再走 enqueuePendingNotification-with-<task-id>”的路径
- 必须 direct `emitTaskTerminatedSdk(...)`

原因也一并说明了：

- 如果该路径本来就会再经过 XML queue，`print.ts` 会解析出同一个 SDK event
- 两边都发会 double-emit

所以 direct emit 不是：

- “我再补发一遍，更保险”

而是：

- “这条路径不会经过 XML close，所以必须在这里自己关任务”

## 第六层：为什么某些路径必须 direct emit

源码里至少能看到两类清晰例子。

### 例子一：`stopTask.ts`

这里的注释直接写了：

- suppressing the XML notification also suppresses `print.ts`'s parsed SDK event
- so emit it directly so SDK consumers see the task close

这说明一旦这条停任务路径主动 suppress XML，就不能指望：

- 稍后 `print.ts` 替你关单

### 例子二：`inProcessRunner.ts`

这里同样写了：

- `notified:true` pre-set -> no XML notification -> `print.ts` won't emit the SDK task_notification
- close the task_started bookend directly

所以 direct emit 的职责很清楚：

- 不是重复发
- 是在“没有 XML close 的世界线里”补上 terminal close

## 第七层：为什么 anti-double-emit 是这页最重要的第一性原理

如果不先抓住 anti-double-emit，就很容易犯一个看似稳妥、其实完全相反的错误：

- “terminal task 最好 XML 和 direct SDK 两边都发，反正多一层保险。”

源码明确反对这个做法，因为：

- XML close 会被 `print.ts` 解析成 SDK event
- direct emit 也会生成 SDK event
- 两边都发，SDK consumer 就会收到重复 close

这不只是日志重复，而是会直接污染：

- bg-task dot
- subagent panel
- task bookend
- 任何依赖 `task_notification` close 语义的宿主状态机

所以这页最不该写错的一句是：

- close signal 必须一条路负责到底，不能双发

## 第八层：这和 90 的区别是什么

90 回答的是：

- 为什么同一个 `task-notification` 要先喂 SDK，再喂模型

91 继续往下后，问题已经换成：

- 哪些 `task-notification` 真能关单
- 哪些只是 ping
- 哪些 terminal close 必须 direct emit

前者讲：

- who consumes

后者讲：

- what actually closes

主语不同，不该揉成一页。

## 第九层：最常见的假等式

### 误判一：所有 `task-notification` 都在表达“任务结束”

错在漏掉：

- statusless ping 只是 progress / stall signal，不是 close

### 误判二：有 XML 就一定能让 SDK consumer 关单

错在漏掉：

- 只有带 `<status>` 的 terminal XML 才会被 `print.ts` 解析成 close event

### 误判三：direct `emitTaskTerminatedSdk(...)` 是 XML close 的补发版

错在漏掉：

- 它只该出现在“不走 XML close”的路径

### 误判四：双发比漏发更安全

错在漏掉：

- 源码明确把 double-emit 当成要避免的错误，而不是兜底机制

### 误判五：90 已经讲了 dual-consumer，这页就没必要了

错在漏掉：

- dual-consumer 讲的是“谁来消费”
- 这页讲的是“哪种信号真的关单”

## 第十层：稳定、条件与内部边界

### 稳定可见

- 带 `<status>` 的 terminal XML notification 能被 `print.ts` 解析成 SDK close event。
- statusless `task-notification` 不是 close，只是 progress / stall signal。
- 某些 terminal 路径不会再经过 XML queue，必须 direct `emitTaskTerminatedSdk(...)`。
- XML close 和 direct SDK close 不能双发。

### 条件公开

- XML 是否带 `<status>`，决定 `print.ts` 是否把它当 terminal close。
- 某条 terminal 路径最终走 XML 还是走 direct emit，取决于该任务实现是否 suppress / pre-set 了 XML notification。
- 不同任务类型对 progress ping、stall signal、terminal close 的分层不同。

### 内部 / 实现层

- `killed -> stopped` 的归一化细节。
- `notified:true`、suppress flag、abort branch 等具体判断。
- 各任务实现里何时构造 statusless envelope，何时直接 emit。

## 第十一层：苏格拉底式自检

### 问：为什么这页最先该拆 `<status>`，而不是先枚举全部任务来源？

答：因为 `<status>` 决定了“这是不是 close signal”。来源再多，如果先不拆这个门槛，所有来源都会被误写成同一种结束通知。

### 问：为什么 direct emit 值得单独成页内主角？

答：因为它直接揭示了一个很容易写反的事实：terminal close 不是一律走 XML queue。

### 问：为什么 anti-double-emit 要反复强调？

答：因为它不是实现癖好，而是整个 task close 状态机的一条守门规则。

## 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/tasks/LocalShellTask/LocalShellTask.tsx`
- `claude-code-source-code/src/utils/sdkEventQueue.ts`
- `claude-code-source-code/src/tasks/stopTask.ts`
- `claude-code-source-code/src/utils/swarm/inProcessRunner.ts`
