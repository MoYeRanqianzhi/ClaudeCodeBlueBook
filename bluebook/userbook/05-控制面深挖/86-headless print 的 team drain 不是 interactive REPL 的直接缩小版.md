# `SHUTDOWN_TEAM_PROMPT`、`inputClosed`、`hasWorkingInProcessTeammates`、`waitForTeammatesToBecomeIdle` 与 `hasActiveInProcessTeammates`：为什么 headless print 的 team drain 不是 interactive REPL 的直接缩小版

## 用户目标

85 页已经把 in-process teammate 的状态投影拆开了：

- `status`
- `shutdownRequested`
- `awaitingPlanApproval`
- `isIdle`

不会被所有消费者压成同一层状态。

但如果继续往下看 headless `print.ts`，读者还会遇到另一个很容易误判的现象：

- 为什么输入流一关闭，`print` 并不会立刻退出？
- 为什么它会先等待 in-process teammates 变 idle，再判断是否要注入 `SHUTDOWN_TEAM_PROMPT`？
- 为什么它一边看 `hasWorkingInProcessTeammates(...)`，一边又看 `hasActiveInProcessTeammates(...)` 和 `teamContext.teammates`？
- 为什么这条 headless drain 逻辑和 interactive REPL 虽然都在处理团队收口，却不像 REPL 那样先靠用户继续交互推进？

如果这些问题不拆开，读者很容易把 headless `print` 写成一句过度平面的判断：

- “`-p/--print` 只是没有 UI 的 REPL；输入结束后自然就跟 REPL 一样收口。”

源码不是这样工作的。

## 第一性原理

更稳的提问不是：

- “headless 模式什么时候退出？”

而是四个更底层的问题：

1. 对 headless 宿主来说，`inputClosed` 到底意味着“可以退出”，还是“应该进入 drain 阶段”？
2. 它首先关心的是 teammate 是否还在 working，还是整个 team 是否仍未清理？
3. 它是在等待普通 UI 交互，还是必须主动注入系统提醒来驱动模型收口？
4. 它需要的是真正 terminal，还是“先 idle 再 shutdown”的两段式收束？

只要这四轴不先拆开，后续就会把：

- headless team drain

误写成：

- interactive REPL close

## 第二层：headless print 的 team drain 是三段式，不是一键收口

从 `print.ts` 的逻辑看，headless 团队收口至少有三段：

| 阶段 | 判定对象 | 主要动作 |
| --- | --- | --- |
| 输入关闭前 | `inputClosed === false` | 正常处理主输入与 teammate 消息 |
| 输入关闭后、但仍有 working teammate | `hasWorkingInProcessTeammates(...)` | 先等 working teammates 变 idle |
| 输入关闭后、idle 之后仍有 active swarm | `hasActiveInProcessTeammates(...)` 或 `teamContext.teammates` 非空 | 注入 `SHUTDOWN_TEAM_PROMPT`，驱动真正团队 shutdown |

这张表最重要的作用是先钉住一个事实：

- `inputClosed`

并不是：

- 现在就能结束

而是：

- 现在进入 headless drain protocol

## 第三层：`SHUTDOWN_TEAM_PROMPT` 说明 headless 必须显式驱动团队收口

`print.ts` 里有一段非常直白的系统提醒：

- non-interactive mode 不能在 team shut down 前把最终响应交给用户
- 必须：
  1. `requestShutdown`
  2. 等待 shutdown approvals
  3. `cleanup`
  4. 然后再准备最终响应

这段 prompt 的意义很重要：

- headless 模式不能依赖用户在 REPL 里继续点下一步
- 也不能把“还有团队没收口”默默吞掉

所以它必须：

- 主动把团队收口义务回灌给模型

这和 interactive REPL 有根本差异：

- interactive 可以继续靠用户/当前会话交互推进
- headless 需要在 input 结束后自己进入一个 system-driven shutdown phase

## 第四层：headless 先等 “working -> idle”，而不是直接发 shutdown

### `hasWorkingInProcessTeammates(...)` 只看 still-processing teammates

`utils/teammate.ts` 里这条 helper 的判断是：

- `task.type === 'in_process_teammate'`
- `task.status === 'running'`
- `!task.isIdle`

也就是说，这里关心的是：

- 还有没有 teammate 正在真正干活

而不是：

- 还有没有 teammate 存在

### `waitForTeammatesToBecomeIdle(...)` 也只等到 idle，不等到 completed

它会：

- 收集所有 `running && !isIdle` 的 teammate task
- 给每个 task 注册 `onIdleCallbacks`
- 等所有人进入 idle

这说明 headless print 的第一步不是：

- 等所有 in-process teammate 完全结束

而是：

- 先等所有 still-working teammate 停到 idle

这和 85 页的状态投影正好对上：

- idle 不等于 terminal
- 但 idle 足够支持进入下一阶段 drain 决策

## 第五层：进入 idle 后，headless 还会再看“team 是否仍未清理”

`print.ts` 在 input closed 分支里，等完 working teammates 变 idle 后，会重新取一遍 state，然后同时看两件事：

### 条件一：`teamContext.teammates` 是否仍然非空

这更接近：

- team members not cleaned up

即使当前没人再 working，只要团队成员记录还在，就还不算收口完成。

### 条件二：`hasActiveInProcessTeammates(...)`

这条 helper 的判断更宽：

- `task.type === 'in_process_teammate'`
- `task.status === 'running'`

它不要求：

- `!isIdle`

所以这一步关心的是：

- 还有没有 in-process teammate task 仍处于 active lifecycle

而不是：

- 他们此刻有没有在真正工作

因此 headless print 形成了一个很稳的两段判断：

1. 先看 “是否还在 working”
2. 再看 “是否还算 active swarm / 未清理团队”

这也是为什么它不能被写成：

- “input 一断就直接 prompt shutdown”

## 第六层：`shutdownPromptInjected` 只负责“轮询阶段不要重复注入”

在 team mailbox 轮询循环中，`print.ts` 有一个：

- `shutdownPromptInjected`

它的作用是：

- 当 input 已关闭且仍有 active teammates 时
- 在这条轮询路径里只注入一次 shutdown prompt

但注意，这个变量并不等于：

- 整个 headless drain 只会尝试一次 shutdown

因为在轮询循环外、进入 `if (inputClosed)` 的主收口分支后，如果 `hasActiveSwarm` 仍然为真，代码还会再次：

- `enqueue(SHUTDOWN_TEAM_PROMPT)`
- `run()`

这说明更稳的结论是：

- `shutdownPromptInjected` 只是局部去重闸

而不是：

- 全局 shutdown state machine

## 第七层：headless 的 active teammate 轮询本身就是专用宿主逻辑

`print.ts` 里还有一段轮询语义：

- 只要还有 active teammates
- 就持续 poll unread teammate mailbox
- 没有 active teammates 才停止 poll

日志甚至直接写：

- `No more active teammates, stopping poll`

这说明 headless print 的队友管理并不是：

- “顺手读几条 teammate message”

而是：

- 把 active swarm 生命周期并入主 run loop

因此最不该写错的一句是：

- headless print 不只是一个单回合输出器，它还承担 team-drain coordinator 的一部分职责

## 第八层：为什么这条路径不是 interactive REPL 的直接缩小版

把前面几层压起来，差异就清楚了。

### interactive REPL 更像持续宿主

- 有持续输入面
- 有 `focusedInputDialog`
- 有本地 inbox pending/processed
- 收口常常分散在 poller、attachment bridge、当前交互回合里

### headless print 更像有限 run-loop 宿主

- input 会真正关闭
- 关闭后不能直接结束，而要 drain
- drain 时要主动注入 `SHUTDOWN_TEAM_PROMPT`
- 还要先等 working teammates idle，再判断 active swarm 是否仍未清理

所以更稳的说法不是：

- “print 像 REPL，只是少了 UI”

而是：

- “print 有一条专门为 non-interactive team drain 设计的 shutdown protocol”

## 第九层：为什么 86 不和 84 合并

84 页已经回答的是：

- `useInboxPoller`
- `attachments.ts`
- `print.ts`

为什么不共享同一条宿主路径。

86 再往下时，真正新的价值不再是宿主横向比较，而是：

- headless print 自己的输入关闭 -> idle drain -> active swarm shutdown prompt 这条内部收口链

也就是说：

- 84 是 host-path comparison
- 86 是 print-specific drain protocol

两者主语不同，不该揉成一篇。

## 第十层：最常见的假等式

### 误判一：`inputClosed` 就等于可以退出

错在漏掉：

- 它只是进入 team drain 阶段的开始

### 误判二：只要没有 teammate 在工作，就说明 headless 可以结束

错在漏掉：

- 还要看 active in-process teammates
- 还要看 `teamContext.teammates` 是否仍未清理

### 误判三：headless 会像 interactive 一样自然收口，不需要额外 prompt

错在漏掉：

- `SHUTDOWN_TEAM_PROMPT` 是专门为 non-interactive 模式准备的系统驱动收口

### 误判四：`shutdownPromptInjected` 是整个 shutdown 流程的唯一闸门

错在漏掉：

- 它只限制轮询阶段重复注入，不是全局状态机

### 误判五：`waitForTeammatesToBecomeIdle(...)` 等到的就是 terminal

错在漏掉：

- 它只等到 idle
- idle 不是 completed

## 第十一层：稳定、条件与内部边界

### 稳定可见

- headless `print` 在 input 关闭后会进入一条专门的 team drain 协议，而不是立刻退出。
- 这条协议先等 working in-process teammates 进入 idle，再判断 active swarm 是否仍需 shutdown。
- `SHUTDOWN_TEAM_PROMPT` 是 headless/non-interactive 团队收口的显式系统驱动。
- `hasWorkingInProcessTeammates` 与 `hasActiveInProcessTeammates` 不是同一层判断。

### 条件公开

- 只有存在 team / teammates / in-process teammate 任务时，这条 drain 才有意义。
- 某些收口判断还依赖 `teamContext.teammates` 是否已被 cleanup。
- pane-based teammate 与 in-process teammate 对 “仍活着” 的判定厚度不同。
- 轮询阶段与 inputClosed 主收口分支会在不同位置使用 shutdown prompt。

### 内部 / 实现层

- `shutdownPromptInjected` 的具体作用域。
- 轮询间隔、`enqueue/run` 时机、关闭 output stream 前的 suggestion/hook 清理。
- `SHUTDOWN_TEAM_PROMPT` 的具体文案。
- 哪些 state 刷新点要重新 `getAppState()`。

## 第十二层：苏格拉底式自检

### 问：为什么不直接在 input 关闭时立即 request shutdown？

答：因为还有一个更细的阶段判断。headless 先想知道：当前是否还有 teammate 正在真正工作；如果有，就先 drain 到 idle，再统一进入 shutdown 协议。

### 问：如果都已经 idle，为什么还不直接结束？

答：因为 idle 只说明暂时没在工作，不等于团队已清理完毕。`teamContext.teammates` 和 active in-process tasks 仍可能存在。

### 问：为什么这页不算重复写 85 的 `isIdle`？

答：85 解释的是 `isIdle` 如何投影给不同消费者；86 解释的是 headless print 如何把 `isIdle` 用在 team drain 协议里。一个讲状态投影，一个讲收口流程。

### 问：为什么这页值得单独成文，而不是只在 84 最后加一节？

答：因为 84 讲三条宿主路径的横向差异；86 讲 print 自己的内部 shutdown drain 协议。问题和层级不同。

## 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/utils/teammate.ts`
- `claude-code-source-code/src/tasks/InProcessTeammateTask/types.ts`
- `claude-code-source-code/src/utils/swarm/inProcessRunner.ts`
