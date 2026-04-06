# `useInboxPoller`、`attachments`、`print`、`shutdown_approved`、`teammate_terminated` 与 `pending-processing`：为什么 interactive、attachment bridge 与 headless print 不共享同一条 shutdown 收口宿主路径

## 用户目标

83 页已经把 shutdown family 再往下一层压到了 routing：

- `shutdown_request`
- `shutdown_approved`
- `shutdown_rejected`
- `teammate_terminated`

并不会共用同一条 mailbox routing 通道。

但如果继续深一层，读者还会立刻撞上另一个更宿主侧的问题：

- 为什么 interactive `useInboxPoller` 看到 `shutdown_approved` 后，会做 cleanup、注入 `teammate_terminated`，还把消息排进 `pending`？
- 为什么 `attachments.ts` 也会镜像一部分 shutdown cleanup，却又不注入同样的 `teammate_terminated` shadow？
- 为什么 `print.ts` 也会处理 `shutdown_approved`，却直接把 unread 格式化进 prompt queue，而不是复用 `pending/processed` 本地 inbox 状态机？

如果这些问题不拆开，读者就会把三条宿主路径误写成一句过度简化的话：

- “interactive、attachment bridge 和 headless print 本质上就是同一条 shutdown 收口链。”

源码不是这样工作的。

## 第一性原理

更稳的提问不是：

- “这几个地方是不是都在处理 shutdown_approved？”

而是四个更底层的问题：

1. 当前宿主的主要目标是 interactive delivery、attachment bridge，还是 headless run loop？
2. 当前宿主有没有自己的本地 inbox 状态机，还是直接驱动 prompt queue？
3. 当前宿主处理 shutdown 的重点是 cleanup side effect，还是用户可见消息投递？
4. 当前宿主需要不需要额外注入本地 system shadow 来维持状态一致？

只要这四轴不先拆开，后续就会把：

- shared cleanup contract

误写成：

- shared host path

## 第二层：三条宿主路径总表

| 宿主路径 | 主要对象 | 最优先目标 |
| --- | --- | --- |
| interactive poller | `useInboxPoller.ts` | 在交互 REPL 中同时完成 cleanup 与消息继续投递 |
| attachment bridge | `attachments.ts` | 在当前回合中桥接 mailbox + pending inbox，避免 mid-turn 丢消息 |
| headless print | `print.ts` | 在无交互 REPL 的 run loop 中完成 cleanup 并继续推进 prompt queue |

这张表最重要的作用是先建立一个事实：

- 三条路径都能处理 shutdown
- 但它们首先服务的宿主职责并不一样

所以不该期待它们在 shutdown 收口上完全同构。

## 第三层：interactive `useInboxPoller` 是最完整的“cleanup + 本地投递”双栈路径

`useInboxPoller.ts` 在 leader 侧碰到 `shutdown_approved` 时，会做四件事：

1. 条件满足时 `killPane(...)`
2. `removeTeammateFromTeamFile(...)`
3. `unassignTeammateTasks(...)`
4. `setAppState(...)` 同时更新：
   - `teamContext.teammates`
   - 相关 task 完成态
   - `AppState.inbox.messages += teammate_terminated(pending)`

然后它还会把原始 approved message：

- `regularMessages.push(m)`

更往后，如果当前 session 空闲，poller 会：

- 直接 `onSubmitTeammateMessage(formatted)`

如果当前 session 忙或有 `focusedInputDialog`，poller 会：

- 把 regularMessages 先排进 `AppState.inbox.messages`
- `status: 'pending'`

所以 interactive path 的特征非常清楚：

- 它既是 cleanup host
- 也是本地 inbox delivery host

这是三条路径里最“重”的那条。

## 第四层：attachment bridge 不是新的主宿主，而是 mid-turn delivery 补桥

`attachments.ts` 的 shutdown 处理看起来和 poller 很像，但第一性原理不同。

它首先做的是：

- 把 unread file mailbox messages
- 和 `AppState.inbox.pending`

合并、去重、折叠 idle，生成：

- `teammate_mailbox` attachment

然后才顺便镜像一部分 shutdown cleanup：

- `shutdown_approved` -> remove teammate / unassign tasks / mutate `teamContext`

这条路径最关键的差异有三条：

### 差异一：它不注入 `teammate_terminated`

和 interactive poller 不同，attachment path 在 shutdown cleanup 之后只会：

- 修改 `teamContext`

但不会额外：

- `AppState.inbox.messages += teammate_terminated`

所以 attachment bridge 关心的是：

- 当前回合不要丢掉 mailbox / pending 消息

而不是：

- 构造完整的本地 cleanup shadow 叙事

### 差异二：它有 `pending -> processed` 状态改写

attachment 建好以后，它会把被这次 attachment 中途送达过的 `pendingInboxMessages` 改成：

- `status: 'processed'`

下一轮 poller 再清理这些 processed。

也就是说，这条路径不是新的交互主线，而是：

- mid-turn bridge
- 然后把控制权还给 poller cleanup

### 差异三：它会故意跳过 viewed teammate / in-process teammate 的 leader inbox

注释直接写明：

- viewing teammate transcript 时不应泄漏 leader inbox
- in-process teammate 也不应吃到 leader 的 queued messages

这说明 attachment path 的核心边界是：

- mailbox bridge under current viewing context

不是：

- universal shutdown host

## 第五层：headless `print.ts` 也做 cleanup，但没有本地 inbox 双阶段

`print.ts` 在 headless 路径中收到 unread mailbox 后，会先：

- `markMessagesAsRead(...)`
- 对其中的 `shutdown_approved` 做 remove teammate / unassign / mutate `teamContext`

然后它直接把 unread 格式化成：

- teammate XML wrapper

并：

- `enqueue({ mode: 'prompt', value: formatted, ... })`
- `run()`

这条路径和 interactive poller 最大的不同是：

- 它没有一套对等的 `pending -> processed -> cleanup` 本地 inbox 交接

更准确地说：

- print 是 headless run-loop host
- 不是 REPL-local inbox host

所以它当然会复用部分 cleanup contract，但不会复刻 poller 的全部消息状态机。

## 第六层：三条路径共享的是 cleanup contract，不是同一宿主语义

把三条路径的共同部分压出来，真正稳定的公共核其实只有这些：

- 都认识 `shutdown_approved`
- 都会把 teammate 从团队上下文中移除
- 都会做 task unassign / team file cleanup 的某种子集

但一旦离开这层公共核，差异就立刻出现：

| 对象 | interactive poller | attachment bridge | headless print |
| --- | --- | --- | --- |
| `teammate_terminated` 注入 | 有 | 无 | 无 |
| 本地 `pending/processed` inbox 状态机 | 有 | 会消费并改写 | 基本无 |
| 提交下一轮 teammate message 的主通道 | `onSubmitTeammateMessage(...)` / queue pending | 生成 attachment，交给当前回合 | `enqueue(...); run()` |
| 首要职责 | interactive host | mid-turn bridge | headless run loop |

所以更稳的结论不是：

- “三条路径都在做同一件事”

而是：

- “三条路径共享 cleanup contract，但各自服从不同宿主语义”

## 第七层：为什么 interactive path 需要 `teammate_terminated`，而另外两条不必强求

这是这一批最值得钉住的问题。

interactive poller 在 cleanup 后额外注入：

- `type: 'teammate_terminated'`
- `status: 'pending'`

其作用不是重复表达 approved，而是：

- 让交互 REPL 在自己的本地 inbox / transcript /状态面中有一个统一的系统影子

而 attachment bridge 不做这一步，是因为它本来就不是主宿主，它只是：

- 把当前回合已经存在的 file mailbox + pending inbox 拉进 attachment

headless print 不做这一步，则是因为它的主要宿主结构是：

- enqueue / run

而不是：

- 维护 REPL-local inbox shadow narrative

所以 `teammate_terminated` 不是 shutdown cleanup 的普适输出，而是：

- interactive host 的本地一致性工具

## 第八层：`pending/processed` 也不该上升成 shutdown 普遍合同

83 页已经说明了：

- `pending -> processed -> cleanup`

更接近 interactive leader-side local delivery path。

84 页再从宿主角度看，就更清楚了：

- interactive poller 是这套状态机的 owner
- attachment bridge 是这套状态机的 temporary consumer / marker
- print path 根本没有义务复刻这套双阶段状态

所以最不该写错的一句是：

- `pending/processed` 是 interactive host 的消息生命周期

而不是：

- shutdown family 的统一生命周期

## 第九层：headless 还有自己的 shutdown prompt 收口，不应混回 interactive 逻辑

`print.ts` 还有一个只属于 headless run loop 的动作：

- 当 input 已关闭、teammates 还活着时，注入 `SHUTDOWN_TEAM_PROMPT`

这再次说明它的宿主目标不同：

- interactive poller 关心 REPL 当前是否忙、是否有 focused dialog
- print 关心 headless run loop 何时该主动进入团队收口

这条逻辑不该被混回 interactive shutdown 主线，否则会把：

- headless session control

和：

- interactive local inbox delivery

写成同一层。

## 第十层：最常见的假等式

### 误判一：`attachments.ts` 只是 `useInboxPoller` 的轻量包装

错在漏掉：

- attachment bridge 有自己的合并、去重、pending/processed 改写与 viewing-context 边界

### 误判二：`print.ts` 只是没有 UI 的 `useInboxPoller`

错在漏掉：

- print 直接驱动 enqueue / run
- 还有 headless shutdown prompt
- 不复刻同样的本地 inbox 状态机

### 误判三：既然三条路径都处理 `shutdown_approved`，那它们应该同样注入 `teammate_terminated`

错在漏掉：

- `teammate_terminated` 更像 interactive host 的本地一致性工具

### 误判四：`pending/processed` 是 shutdown cleanup 的普遍阶段

错在漏掉：

- 它更像 interactive host 的消息交接协议

### 误判五：三条路径的差异只是代码复用程度不同

错在漏掉：

- 它们首先服务的宿主职责不同

## 第十一层：稳定、条件与内部边界

### 稳定可见

- interactive `useInboxPoller`、attachment bridge 与 headless `print` 都会处理 shutdown cleanup，但不共享同一条宿主路径。
- 三条路径共享一部分 cleanup contract，但各自服务不同宿主职责。
- `teammate_terminated` 更接近 interactive host 的本地一致性影子，而不是 shutdown cleanup 的通用输出。
- `pending/processed` 更接近 interactive local inbox 状态机，而不是 shutdown family 的统一生命周期。

### 条件公开

- attachment bridge 只在 leader transcript / 当前 viewing context 下消费 `pending` inbox。
- print path 只在 headless run loop 下显式注入 shutdown prompt。
- 某些 cleanup 动作依赖 pane backend、team file、teammate 是否仍存在于 teamContext。
- attachment 与 interactive 对 `shutdown_approved` 的后续显示厚度，还会再受 82 页的显示层裁切影响。

### 内部 / 实现层

- `processedMessages` 的清理时机。
- `pendingInboxMessages` 的去重 key、标记顺序和具体状态值。
- `SHUTDOWN_TEAM_PROMPT` 具体内容与注入时机。
- 哪些路径会或不会把 approved 原样继续透传到后续 prompt。

## 第十二层：苏格拉底式自检

### 问：如果三条路径共享 cleanup contract，为什么不干脆抽成完全同一条总线？

答：因为 cleanup contract 只是公共核。真正支配行为的是宿主职责：interactive host、mid-turn bridge、headless run loop 根本不是同一种宿主。

### 问：如果 attachment 也会做 cleanup，为什么还不能把它叫第二个 poller？

答：因为它没有承担 poller 的持续交付职责，它只是在当前回合桥接 mailbox 与本地 pending inbox，并把控制权交还给主宿主。

### 问：如果 print 也处理 unread mailbox，为什么不能说它就是 headless poller？

答：因为它的收口方式是 enqueue / run，而不是 REPL-local inbox 的 pending/processed 状态机；它还带着 headless 专属 shutdown prompt。

### 问：为什么这页不把 `request/rejected/approved` 再重新讲一遍？

答：因为 81-83 已经把 family、visible surfaces、routing split 拆出来了。84 只抓宿主路径差异，避免重复。

## 源码锚点

- `claude-code-source-code/src/hooks/useInboxPoller.ts`
- `claude-code-source-code/src/utils/attachments.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/utils/teammateMailbox.ts`
- `claude-code-source-code/src/components/teams/TeamsDialog.tsx`
