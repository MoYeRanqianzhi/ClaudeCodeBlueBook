# `readUnreadMessages`、`markMessagesAsRead`、`enqueue`、`run`、`hasActiveInProcessTeammates` 与 `POLL_INTERVAL_MS`：为什么 headless print 的 active teammate polling 不是被动 inbox reader

## 用户目标

86 页已经把 headless `print` 的 team drain 拆成了一条专门协议：

- `inputClosed`
- `hasWorkingInProcessTeammates(...)`
- `waitForTeammatesToBecomeIdle(...)`
- `hasActiveInProcessTeammates(...)`
- `SHUTDOWN_TEAM_PROMPT`

但如果继续往下一层看，读者还会马上遇到另一个更细的困惑：

- 为什么 `print.ts` 明明已经在跑自己的 query loop，却还要额外持续 poll teammate mailbox？
- 为什么它不是像 `useInboxPoller` 那样“收到 unread -> 分类 -> busy 时排队 -> idle 时再投递”？
- 为什么它会在读到 unread 后立刻 `markMessagesAsRead(...)`，然后把整批 unread 直接 `enqueue(...); run()`？
- 为什么它即使没有新 unread，也会因为 teammates 还活着继续 500ms 轮询？

如果这些问题不拆开，读者就会把这条 headless 逻辑误写成：

- “只是一个被动的 inbox reader，顺便把 unread teammate message 打进 prompt。”

源码不是这样工作的。

## 第一性原理

更稳的提问不是：

- “它有没有读 unread mailbox？”

而是四个更底层的问题：

1. 这个 loop 的停止条件是“没有 unread”，还是“没有 active teammates”？
2. unread 被读到后，是进入本地延迟队列，还是立刻并入主 run loop？
3. mark-read 的时机是“已经可靠排队之后”，还是“读到就先去重消重”？
4. 这条 loop 的职责是被动收信，还是持续维持 headless swarm run loop 的活性？

只要这四轴不先拆开，后续就会把：

- active teammate polling

误写成：

- passive mailbox consumption

## 第二层：headless print 的 mailbox loop 其实围绕 “active teammates” 而不是 “unread count”

`print.ts` 的这段逻辑先做的不是：

- 先读 unread

而是：

- 先判断 teammates 是否仍然 active

其停止条件是：

- `hasActiveInProcessTeammates(refreshedState)`
- 或 `teamContext.teammates` 仍非空

只有当这两者都不成立时，代码才会：

- `No more active teammates, stopping poll`

这说明这段 loop 的真正主语不是：

- unread mailbox

而是：

- active swarm lifecycle

mailbox unread 只是这条 loop 在运行中不断采样的一种输入。

## 第三层：这是一条 “轮询 active swarm -> 吸收 unread -> 递归喂回 run loop” 的闭环

把这段 loop 压成最小模型，可以看到它至少有四步：

| 步骤 | 判定/动作 | 语义 |
| --- | --- | --- |
| 1 | 判断 `hasActiveTeammates` | 只要 swarm 还活着，就继续 loop |
| 2 | `readUnreadMessages(...)` | 从 file mailbox 吸收新的 teammate 输入 |
| 3 | 若有 unread，则 `markMessagesAsRead(...)` + 格式化 + `enqueue(...); run()` | 把 teammate 输入并回主 run loop |
| 4 | 若无 unread，则 `sleep(POLL_INTERVAL_MS)` | 保持活性，等待下一波 teammate 输出 |

这张表最重要的作用是先钉住一个事实：

- unread 不是唯一触发器
- 活着的 teammate 本身就是 loop 持续存在的理由

所以它更接近：

- swarm runtime pump

而不是：

- passive inbox reader

## 第四层：为什么 `print` 在读到 unread 后要立刻 mark read

这条路径和 interactive `useInboxPoller` 一个非常重要的差异在这里。

### headless print 的做法

在 `unread.length > 0` 时，`print.ts` 会先：

- `markMessagesAsRead(...)`

然后：

- 对整批 unread 做 shutdown-approved cleanup
- 把整批 unread 格式化为 teammate XML wrapper
- `enqueue({ mode: 'prompt', value: formatted, ... })`
- `void run(); return`

这说明 headless 这里更重视：

- 去重与单次消费

而不是：

- “先确保本地持久化排队，再安全 mark read”

### interactive poller 的做法

`useInboxPoller.ts` 则恰恰相反：

- 先分类
- idle 时直接 submit，否则进 `AppState.inbox.pending`
- 只有在“已经成功提交或可靠排队”后才统一 `markRead()`

所以最稳的比较不是：

- “两者都在读 unread”

而是：

- print 走 immediate-read + enqueue/run path
- poller 走 classify + deliver-or-queue + then-mark-read path

## 第五层：headless 没有 poller 那套 `pending/processed` 本地 inbox 状态机

83-84 已经说明：

- interactive `useInboxPoller` / `attachments.ts`

会共享一套：

- `pending`
- `processed`

的本地 inbox 生命周期。

`print.ts` 这条 loop 则不是这样。

它在读到 unread 后的目标是：

- 直接把消息包进 prompt
- 立刻 kick 当前 run loop

而不是：

- 放进某个本地 inbox，等 session idle 再投递

因此 headless print 的 unread mailbox loop 更接近：

- prompt injection loop

而不是：

- local inbox buffering loop

## 第六层：`enqueue(...); run(); return` 说明 teammate mailbox 被并进主回合，而不是旁路消费

这里最容易被低估的一点是：

- unread teammate message 不是被 loop 自己“消费掉”

它真正做的事情是：

1. 把 unread 打包成 prompt
2. 丢回主队列
3. 立刻重新触发 `run()`
4. 自己 `return`，让下一轮 run 接手

这说明 teammate mailbox 在 headless 里不是一条旁路控制流，而是：

- 主 run loop 的再入入口

所以更准确的说法不是：

- “print 顺便处理一下 teammate 消息”

而是：

- “print 把 teammate mailbox 持续折返到主 run loop”

## 第七层：为什么 “没有 unread” 时也要继续轮询

如果这条 loop 只是 passive inbox reader，那么：

- 没有 unread

本来就可以结束本轮。

但实际代码是：

- 若无 unread 且 teammates 仍 active
- `await sleep(POLL_INTERVAL_MS)`
- 然后继续下一轮

这说明 headless print 的真正等待对象不是 unread 本身，而是：

- active teammates 将来可能产生的新输出

这也是为什么：

- 轮询间隔
- active teammate stop condition

在这条路径里比“当前 unread 数量”更接近核心语义。

## 第八层：为什么这条 loop 不等同于 86 的 team drain 协议

86 页的主语是：

- input 关闭后，如何 drain 到 team shutdown

87 页的主语则更细：

- 在 teammates 仍 active 时，headless print 如何持续吸收 unread 并递归并回主 run loop

两者关系是：

- 86 讲 stop/close semantics
- 87 讲 active polling / unread absorption semantics

所以 87 不该被压回 86 的一个小节。

## 第九层：为什么这条 loop 也不等于 interactive `useInboxPoller`

两者虽然都：

- 读 teammate mailbox
- 处理 shutdown-approved cleanup
- 最终把普通消息喂给模型

但关键差异很大：

| 维度 | `print.ts` | `useInboxPoller.ts` |
| --- | --- | --- |
| loop 持续条件 | active teammates 是否仍存在 | REPL effect / session busy-idle state |
| unread 处理 | 立刻 mark read，再 enqueue/run | 先分类、先 deliver-or-queue，再 mark read |
| 本地缓冲 | 无对等 `pending/processed` inbox 状态机 | 有 `pending/processed` inbox 状态机 |
| unread 无新消息时 | 继续 500ms poll | 结束本次 effect，等下一轮触发 |

所以最稳的结论不是：

- “print 是 headless poller”

而是：

- “print 有一条围绕 active teammates 持续运转的 mailbox ingestion loop”

## 第十层：最常见的假等式

### 误判一：只要 unread 清空了，这条 loop 就可以停

错在漏掉：

- loop 停止条件是 no active teammates，不是 no unread

### 误判二：`markMessagesAsRead(...)` 的时机和 interactive poller 一样保守

错在漏掉：

- print 这条线是 immediate-read + enqueue/run

### 误判三：headless 里也有一套 `pending/processed` inbox 生命周期

错在漏掉：

- 那是 interactive poller/attachment bridge 这边的本地 inbox 协议

### 误判四：这条 loop 只是顺手把 unread 变成 prompt

错在漏掉：

- 它其实在维持 active swarm runtime 的吸收闭环

### 误判五：87 和 86 是同一页内容

错在漏掉：

- 86 讲 drain protocol
- 87 讲 active polling / unread mailbox ingestion

## 第十一层：稳定、条件与内部边界

### 稳定可见

- headless `print` 的 teammate mailbox loop 以 “是否仍有 active teammates” 为持续条件，而不是以 “是否还有 unread” 为持续条件。
- 在这条 loop 里，unread teammate messages 会被立刻格式化进 prompt，并通过 `enqueue/run` 折返进主 run loop。
- 这条逻辑不是 interactive `useInboxPoller` 的直接简化版。
- headless `print` 更接近 active swarm runtime 的 ingestion loop，而不是被动收信器。

### 条件公开

- 只有 leader + swarm + active teammates 存在时，这条 polling loop 才有意义。
- shutdown-approved cleanup 仍会在这条 loop 里触发，但其后续显示厚度还会受 84/86 的宿主与 drain 逻辑影响。
- 轮询间隔、当前队列状态、递归 `run()` 的再入时机，都会影响这条 loop 的运行厚度。

### 内部 / 实现层

- `POLL_INTERVAL_MS = 500` 的具体数值。
- `peek(isMainThread)` 和 run 再入保护的细节。
- `markMessagesAsRead(...)` 立即执行这一时机的实现取舍。
- teammate XML wrapper 的具体拼装格式。

## 第十二层：苏格拉底式自检

### 问：如果没有 unread，为什么不结束？

答：因为 loop 的主语不是 unread，而是 active teammates。只要 teammates 还活着，将来就可能继续产生日志、通知、shutdown reply。

### 问：如果都立刻 mark read 了，消息不会丢吗？

答：这条路径的设计取舍不是“先本地 inbox 缓冲再安全 mark read”，而是“立刻接管 unread，并把它折返进主 run loop”。这是 headless host 的不同协议，不应拿 interactive 标准硬套。

### 问：为什么它要 `return` 给下一轮 `run()`，而不是在当前循环里直接处理格式化后的 prompt？

答：因为 teammate mailbox 在这里被视为主队列的再入来源，而不是 loop 自己的旁路执行器。

### 问：为什么这页不算重复写 84/86？

答：84 讲 host-path 比较，86 讲 team drain，87 讲 active polling + unread ingestion。主语和粒度都不同。

## 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/hooks/useInboxPoller.ts`
- `claude-code-source-code/src/utils/teammate.ts`
