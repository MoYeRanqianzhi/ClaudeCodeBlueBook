# `canBatchWith`、`joinPromptValues`、`batchUuids`、`replayUserMessages`、`task-notification` 与 `orphaned-permission`：为什么 headless print 的 prompt batching 不是普通批量出队

## 用户目标

88 页已经把 headless `print` 的主线程队列讲清了一半：

- 它靠单个 `run()` 做 main-thread drain
- 它靠 `enqueue + run()` 和 post-finally `peek(...)` 保活

但再往下一层，读者马上会碰到另一组容易写错的问题：

- 既然 `run()` 已经醒了，为什么不直接把主线程队列一口气批量吃完？
- 为什么只有 `prompt` 会合批，而 `task-notification`、`orphaned-permission` 不会？
- 为什么 `canBatchWith(...)` 要卡 `workload` 和 `isMeta`，而不是只看“是不是 prompt”？
- 为什么多个命令都并进一次 `ask()` 了，代码却还要维护 `batchUuids`、replay 和 per-uuid lifecycle？
- 为什么 REPL 的队列批处理看上去也会合批，但规则又不完全一样？

如果这些问题不拆开，读者就会把这里误写成：

- “既然这是单消费者 pump，那 batching 就只是多 `dequeue()` 几次的性能优化。”

源码不是这样设计的。

## 第一性原理

更稳的提问不是：

- “这里有没有 batch？”

而是五个更底层的问题：

1. 这里合并的到底是 prompt payload，还是命令治理语义？
2. 哪些命令可以无损并入同一次 `ask()`，哪些不行？
3. `workload` 和 `isMeta` 在这里是装饰字段，还是合批边界？
4. 合批以后，哪个 `uuid` 代表这次 turn，其他 `uuid` 又如何不丢？
5. REPL 和 headless `print` 的 batching 是同一条规则，还是只长得像？

只要这五轴不先拆开，后续就会把：

- bounded turn coalescing with identity repair

误写成：

- generic bulk dequeue

## 第二层：这里做的是“单 turn 合批”，不是“普通批量出队”

`print.ts` 在 `drainCommandQueue()` 里写得很直接：

- 默认还是一次拿一条 `dequeue(isMainThread)`
- 只有 `prompt` mode 才会进入 `while (canBatchWith(command, peek(isMainThread)))`
- `task-notification` 和 `orphaned-permission` 明确单发

注释给的定义也很关键：

- 目的是把长 turn 期间排起来的 follow-up prompts 合并成一次后续 `ask()`
- 避免排成 N 个独立 follow-up turn

所以这里的 batching 不是：

- “队列里还有东西就顺手都吞掉”

而是：

- “把可以安全并进同一次模型回合的 prompt，压成一次 turn”

## 第三层：`joinPromptValues()` 合并的是输入载荷，不是执行主权

`joinPromptValues()` 的规则很克制：

- 如果都是字符串，就用换行连接
- 只要混入 block array，就先统一转成 blocks 再拼接

这说明它关心的是：

- 如何把多个 prompt value 变成一个合法的 `ask({ prompt })` 输入

它不负责：

- 合并 side effects
- 合并 orphaned permission state
- 合并不同可见性或不同 workload 的执行语义

所以 `joinPromptValues()` 解决的是：

- payload merge

不是：

- governance merge

## 第四层：`canBatchWith()` 说明什么边界绝对不能糊掉

`canBatchWith(head, next)` 的条件非常少，但每个都很重：

- `next` 必须存在
- `next.mode === 'prompt'`
- `next.workload === head.workload`
- `next.isMeta === head.isMeta`

这意味着 headless `print` 的 prompt batching 不是按“文本都像 prompt”来合批，而是按：

- prompt 类型一致
- workload attribution 一致
- meta/visible 语义一致

来合批。

顺手还要看清一个实现层细节：

- 优先级和 main-thread 过滤是 `dequeue(...)` / `peek(...)` 先做的
- `canBatchWith(...)` 自己并不判断 priority

所以更准确的说法是：

- 它对“当前 drain 序列里下一个会被看到的主线程命令”做 workload/meta 边界判定

## 第五层：`workload` 和 `isMeta` 不是装饰字段，而是 batching 的合同边界

源码注释已经把两个字段为什么不能糊掉写明了。

### `workload`

合批时必须 workload 一致，因为：

- 合并后的 turn 只会跑一次 `ask()`
- `runWithWorkload(cmd.workload ?? options.workload, ...)` 只会挂一个 workload 上下文
- cron prompt 这类系统注入还会靠 `WORKLOAD_CRON` 做 QoS / attribution

所以如果不同 workload 混进同一次 turn，就会把 attribution 写坏。

### `isMeta`

合批时 `isMeta` 也必须一致，因为：

- proactive tick、cron prompt、channel/system 注入这类 meta prompt 不该和普通用户 prompt 共用同一可见性语义
- 注释明确说了，若和普通 head 命令合并，meta 的 hidden-in-transcript 标记会丢

所以这里保护的不是“代码整洁”，而是：

- attribution 不串层
- hidden/meta 语义不串层

## 第六层：为什么 `task-notification` 和 `orphaned-permission` 必须单发

`drainCommandQueue()` 注释已经把结论写死：

- non-prompt commands carry side effects or orphanedPermission state
- so they process singly

这句非常值钱。

### `task-notification`

它不是普通文本 prompt。

在真正走进 `ask()` 之前，代码会先：

- 解析 XML 里的 `<task-id>`、`<tool-use-id>`、`<status>`、`<summary>`、`<usage>`
- 必要时先发一个 SDK `task_notification` system event
- 然后才 fall through，让模型看到这个结果

所以它既有：

- 对 SDK consumer 的事件副作用

又有：

- 对模型的 follow-up 输入意义

这不是一个“随便可以并进别的 batch 的文本块”。

### `orphaned-permission`

它也不是普通文本 prompt。

它携带的是：

- `permissionResult`
- `assistantMessage`

这样的 orphaned permission 状态。

这类命令的治理对象不是“拼成一段文字”，而是“补上一条本该对齐到某个 tool use 的权限响应”。所以它也必须单发。

## 第七层：`batchUuids`、最后一个 `uuid` 与 replay，说明 batching 不是把命令身份抹平

这是 89 最值得钉死的一段。

当多个 prompt 被并成一个 `command` 时，代码会：

- 用 `joinPromptValues(...)` 合并内容
- 把合并后命令的 `uuid` 设成 batch 里的最后一个 `uuid`

旁边的注释解释得很清楚：

- QueryEngine 的 `messagesToAck` 只会自然给合并后 `command.uuid` 做 replay

所以剩下那些被吞进 batch、但不再占据主 `command.uuid` 的命令，并没有被放弃。代码另外做了两层补偿：

1. `options.replayUserMessages && batch.length > 1` 时，先为其余 `uuid` 手工发 `SDKUserMessageReplay`
2. `batchUuids` 中所有 `uuid` 都会走 `notifyCommandLifecycle(..., 'started')` 和 `notifyCommandLifecycle(..., 'completed')`

这说明 batching 真正减少的是：

- 模型 turn 数

而不是：

- 每条命令的可追踪身份

所以这里不该写成：

- “多个命令合成一次以后，只剩最后一个 `uuid` 重要”

更准确的是：

- “ask() 只吃一个代表 `uuid`，但外围还会把其余 `uuid` 的 replay 与 lifecycle 债补回来”

## 第八层：REPL 也会 batching，但规则更宽；headless `print` 更窄

REPL 侧的 `processQueueIfReady()` 也会批处理，但它的规则不同：

- slash command 和 `bash` 单发
- 其他 non-slash commands 会把“同 mode”的 main-thread commands 一起 `dequeueAllMatching(...)`
- 然后整个数组交给 `executeInput(commands)`

也就是说，REPL 更接近：

- same-mode drain

而 headless `print` 更接近：

- prompt-only coalescing with workload/meta guards

两者相同点在于：

- 都不是“队列里还有就全吞”
- 都会先保住不能乱合的命令边界

两者不同点在于：

- REPL 批的是一组 commands
- headless `print` 批的是“一次 ask() 的 prompt 输入”
- REPL 的规则主要按 mode 分组
- headless `print` 还要额外守 `workload`、`isMeta`、per-uuid replay/lifecycle

所以 89 更稳的对照句是：

- REPL 做的是 queue batch dispatch
- headless `print` 做的是 single-turn prompt coalescing

## 第九层：这对使用者意味着什么

如果你从使用层往回看，这套设计会产生三个重要表象：

1. 长 turn 期间连续堆起来的同类 prompt，可能被压成一次后续回合，而不是一条条分别触发模型。
2. cron / proactive / 其他 meta prompt 不会随便并进普通用户 prompt，因为 `isMeta` 是硬边界。
3. background task result、orphaned permission 这类带治理副作用的命令，不会被当作普通 prompt 文本一起糊进 batch。

所以“看上去只是一次 follow-up turn”不代表：

- 前面排队的多条命令消失了

也不代表：

- 系统允许所有主线程命令随便混批

## 第十层：为什么 89 不和 88 合并

88 回答的是：

- 队列怎么保活
- 为什么要 explicit re-entry
- 为什么 finally 后还要 `peek(...)`

89 回答的已经是另一层问题：

- 既然 `run()` 在 drain，什么东西能并进同一次 turn
- 哪些身份与副作用不能被 batching 抹掉

前者讲：

- liveness / re-entry

后者讲：

- merge boundary / identity repair

主语已经变了，不该揉成一页。

## 第十一层：最常见的假等式

### 误判一：batching 就是“多 `dequeue()` 几次”

错在漏掉：

- 这里合并的是 prompt turn，不是泛化批量出队

### 误判二：只要都是 prompt，就都能合批

错在漏掉：

- `workload` 和 `isMeta` 也是硬边界

### 误判三：多个命令并成一次 `ask()`，其余 `uuid` 就没意义了

错在漏掉：

- replay 与 lifecycle 还会把其余 `uuid` 的可追踪性补回来

### 误判四：`task-notification` 只是长得特殊一点的 prompt 文本

错在漏掉：

- 它先有 SDK 事件副作用，再进入模型 turn

### 误判五：REPL 和 headless `print` 的 batching 是同一条规则

错在漏掉：

- REPL 是 same-mode dispatch
- headless `print` 是 prompt-only turn coalescing，并额外守 workload/meta/uuid 边界

## 第十二层：稳定、条件与内部边界

### 稳定可见

- headless `print` 的 batching 不是普通批量出队，而是受约束的 prompt turn 合批。
- `task-notification`、`orphaned-permission` 因为携带副作用或特殊状态，按单发处理。
- `workload`、`isMeta` 是 batching 的真实边界，不是装饰字段。
- 合批不会抹掉每条命令的身份；其余 `uuid` 会通过 replay 和 lifecycle 补回。

### 条件公开

- 只有 `prompt` mode 才会尝试进入 `canBatchWith(...)`。
- replay 补偿受 `options.replayUserMessages` 控制。
- 真正被继续吞进 batch 的，是当前 `peek(isMainThread)` 能看到且 workload/meta 匹配的下一条主线程 prompt。

### 内部 / 实现层

- `joinPromptValues()` 对 string / block array 的具体拼接策略。
- “最后一个 `uuid` 作为 ask 代表”的实现选择。
- `notifyCommandLifecycle(...)`、`messagesToAck`、`SDKUserMessageReplay` 的协作细节。
- priority 与 `peek(...)` 的先后关系。

## 第十三层：苏格拉底式自检

### 问：这里的 batching 减少的到底是什么？

答：减少的是模型 turn 数，不是每条命令的身份账本。

### 问：为什么 `workload` 这种看上去像 attribution 的字段，会决定能不能合批？

答：因为合批后的 turn 只会跑一次 workload 上下文；如果 workload 混批，attribution 就会串层。

### 问：为什么 `task-notification` 明明最后也会进模型，却仍不能和 prompt 混成一团？

答：因为它先承担 SDK 事件副作用，再承担 prompt 输入角色。副作用对象不是普通文本。

### 问：为什么这一页还要拿 REPL 对照？

答：因为不对照，读者就会把 `print` 的 batching 误写成“和 REPL 一样的 same-mode drain”，从而看不见 workload/meta/uuid 这三条更窄的边界。

## 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/utils/queueProcessor.ts`
- `claude-code-source-code/src/hooks/useQueueProcessor.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
