# `shutdown_request`、`shutdown_approved`、`shutdown_rejected`、`teammate_terminated`、`pending` 与 `processed`：为什么 shutdown 生命周期不会走同一条 mailbox routing 通道

## 用户目标

82 页已经把 shutdown lifecycle 的显示层拆开了：

- `shutdown_request`
- `shutdown_rejected`
- `shutdown_approved`
- `teammate_terminated`
- `stopping`

不会落在同一块可见消息面。

但如果继续深一层，读者还会立刻遇到另一个更底层的问题：

- 为什么 `shutdown_request` 和 `shutdown_approved` 看起来更像“先给 handler 处理，再决定怎么显示”？
- 为什么 `shutdown_rejected` 更像一条直接回到普通 teammate message 流的可见回复？
- 为什么 `teammate_terminated` 根本不是从同一条 mailbox response 路径里长出来的，而是 leader 本地 later-stage 注入？
- 为什么有的消息会停在 file mailbox unread，有的会进入 `AppState.inbox.pending`，还有的又会变成 `processed` 等待清理？

如果这些问题不拆开，读者就会把 shutdown family 再次误写成一句太平的话：

- “同一生命周期里的信号，当然该走同一条 mailbox routing 通道。”

源码不是这样工作的。

## 第一性原理

更稳的提问不是：

- “这些 shutdown 相关对象是不是都来自 teammate mailbox？”

而是四个更底层的问题：

1. 这条信号最初来自 file mailbox，还是 leader 本地 `AppState.inbox`？
2. 它应该先交给 protocol handler，还是先作为普通消息交给显示层？
3. 它是 unread file message，还是 `pending/processed` 本地队列消息？
4. 它表达的是 lifecycle negotiation，还是 cleanup completion shadow？

只要这四轴不先拆开，后续就会把：

- lifecycle family sameness

误写成：

- routing channel sameness

## 第二层：shutdown 生命周期的四条通道

| 路由层 | 代表对象 | 更接近什么 |
| --- | --- | --- |
| structured file-mailbox route | `shutdown_request`、`shutdown_approved` | handler-first lifecycle signal |
| regular file-mailbox route | `shutdown_rejected` | visible reply |
| local pending inbox route | `teammate_terminated`、busy 时延后提交的 regular messages | leader 本地待投递影子队列 |
| local processed cleanup route | attachment 已中途投递过的 pending inbox message | mid-turn delivery cleanup |

这张表最重要的作用是先建立一个事实：

- 同一 shutdown 生命周期
- 同时跨 file mailbox 与本地 inbox 两套容器
- 也跨 structured handler 与 regular message 两套消费逻辑

## 第三层：`shutdown_request` 与 `shutdown_approved` 先走 structured protocol 通道

`isStructuredProtocolMessage(...)` 明确把下面这些类型视为：

- 应优先交给 `useInboxPoller`
- 不应先被 attachment bridge 当原始文本吞掉

其中 shutdown family 只包括：

- `shutdown_request`
- `shutdown_approved`

不包括：

- `shutdown_rejected`

`attachments.ts` 也明确写了：

- 只有 non-structured mailbox messages 才会在 attachment 建好后直接标记为已读
- structured protocol messages 要保留 unread，等 `useInboxPoller` 来路由

这意味着 `shutdown_request` 和 `shutdown_approved` 的默认路线是：

1. 先留在 file mailbox unread
2. 优先交给 poller / handler
3. 做完协议层动作后，再决定是否透传到 regular message 流

它们不是简单的“拿到即显示”的消息。

## 第四层：`shutdown_request` 是 handler-first 之后再透传

`useInboxPoller.ts` 在 unread 分类里会单独抓：

- `shutdownRequests`

teammate 一侧对它的处理是：

- 先保留原始 JSON
- 作为 shutdown request 走专门分支
- 再把它推回 `regularMessages`

所以 `shutdown_request` 的真实路线不是：

- unread file mailbox -> transcript

而是：

- unread file mailbox -> shutdown handler branch -> regularMessages -> teammate message wrapper -> model / UI

这能解释两个表面矛盾同时成立：

- 它是 structured protocol message
- 但用户最后又能在 rich message 面看到它

因为它不是绕开 handler，而是：

- handler-first, visible-later

## 第五层：`shutdown_approved` 更极端，它先驱动 cleanup，再决定是否透传

`shutdown_approved` 的路线比 request 还偏 control signal。

在 leader 侧，`useInboxPoller.ts` 收到它后会先做：

- `killPane(...)`（条件满足时）
- `removeTeammateFromTeamFile(...)`
- `unassignTeammateTasks(...)`
- 从 `teamContext.teammates` 删除成员
- 注入一条本地 `teammate_terminated` system message

然后它仍然会把原始 approved message：

- `regularMessages.push(m)`

也就是说，approved 的真实路线更像：

- unread file mailbox -> cleanup side effects -> inject local shadow -> optional pass-through into regularMessages

而 82 页已经证明，后面的 pass-through 并不等于“它就一定会在主显示面占位”，因为 rich render 和 attachment 可见计数又会继续过滤它。

所以对 approved 来说，最稳的结论不是：

- “它是否显示”

而是：

- “它先驱动 cleanup，再由显示层裁切”

## 第六层：`shutdown_rejected` 没走同一条 structured 通道

这是这一批最关键的不对称点。

### 它不在 structured protocol 白名单里

`isStructuredProtocolMessage(...)` 没有列出：

- `shutdown_rejected`

### unread 分类里也没有对应的专门数组

`useInboxPoller.ts` 会单列：

- `shutdownRequests`
- `shutdownApprovals`

但没有：

- `shutdownRejections`

因此对 poller 而言，rejected 更自然地落进：

- `regularMessages`

### attachment bridge 也因此更容易把它当 visible reply 消费

`attachments.ts` 会：

- 读取 unread file mailbox
- 和 `AppState.inbox.pending` 合并
- dedup
- 对 non-structured mailbox messages 标记为已读

所以 rejected 的默认角色更接近：

- human-visible lifecycle reply

而不是：

- handler-first control signal

这正好和 82 页的显示层结论吻合：

- request / rejected 更偏可读对话
- approved 更偏 cleanup signal

## 第七层：`teammate_terminated` 根本不是同一条 mailbox response

`teammate_terminated` 不是 teammate 发回的 `shutdown_*` mailbox 消息。

它是在 leader cleanup 完成后，由本地代码额外注入到：

- `AppState.inbox.messages`

并且初始状态就是：

- `status: 'pending'`

这条路径至少出现两次：

- `useInboxPoller.ts` 的 shutdown approval cleanup path
- `TeamsDialog.tsx` 的直接 kill / remove teammate path

所以更准确的说法不是：

- “approved 之后会再收到一条 teammate_terminated mailbox response”

而是：

- “leader 本地会为 cleanup completion 注入一个 system shadow”

## 第八层：`pending -> processed -> cleanup` 是 leader 本地 inbox 的第二条通道

`useInboxPoller.ts` 和 `attachments.ts` 共同定义了另一条本地投递路线。

### busy 时，regular teammate messages 先排进 `AppState.inbox.pending`

当 session 忙或有 `focusedInputDialog` 时，poller 不会立即提交 `regularMessages`，而是：

- 把它们排进 `AppState.inbox.messages`
- `status: 'pending'`

### idle 时，poller 会把 pending 作为新一轮 teammate message 提交

空闲时，poller 会：

- 读 `pendingMessages`
- 格式化 XML wrapper
- `onSubmitTeammateMessage(formatted)`

提交成功后就从 `AppState.inbox.messages` 中删除这些 pending。

### attachment bridge 可以 mid-turn 抢先消费 pending message

`attachments.ts` 在 leader transcript attachment 路径下会把：

- file mailbox unread
- `AppState.inbox.pending`

合并去重后做成 `teammate_mailbox` attachment。

然后它会把被 attachment 中途投递过的 pending message 改成：

- `status: 'processed'`

### 下一轮 poller 再把 processed 清掉

`useInboxPoller.ts` 在下一次轮询时会先清理：

- `processedMessages`

注释也写得很直白：

- 它们已经在 mid-turn attachment 里送达过了

所以 `teammate_terminated` 的典型路线更像：

- local inject -> pending -> attachment mid-turn delivery -> processed -> cleanup removal

而不是：

- unread file mailbox -> direct transcript

## 第九层：headless / print 路径会镜像 cleanup，但不一定复用同样的本地 inbox 阶段

`print.ts` 在 headless 路径里也会处理：

- unread file mailbox 中的 `shutdown_approved`

并镜像 interactive cleanup：

- 移除 teammate
- `unassignTeammateTasks(...)`
- 从 `teamContext` 删除成员

之后它直接把 unread messages 格式化进 prompt queue。

这说明：

- shutdown family 的 cleanup contract 在 interactive 和 headless 都存在
- 但具体是否经过 `pending/processed` 这套本地 inbox 状态机，是条件化的

所以 `pending/processed` 不该被写成 shutdown family 的普遍公开合同，而更适合写成：

- interactive leader-side local delivery path

## 第十层：routing split 会直接塑造用户能观察到的“消息厚度”

如果把前面几层合起来看，就会发现：

- request 之所以还能长成 rich card，是因为它走了 handler-first 后再透传
- approved 之所以常被看到的是 cleanup 后果而不是正文，是因为它先走 cleanup，再被显示层裁切
- rejected 之所以更像普通回复，是因为它直接落在 regular message route
- `teammate_terminated` 之所以像系统影子，是因为它根本来自 leader 本地 `pending` 注入通道

所以 82 页里那种“可见面不对称”并不是偶然 UI 选择，而是：

- 更深的 routing split 投影到显示层之后的结果

## 第十一层：最常见的假等式

### 误判一：同属 shutdown family，所以都先走 structured handler

错在漏掉：

- `shutdown_rejected` 没走同一份 structured protocol 白名单

### 误判二：`teammate_terminated` 是 teammate 发回的第四种 shutdown response

错在漏掉：

- 它是 leader cleanup 后本地注入的 system shadow

### 误判三：approved 既然也会 `regularMessages.push(m)`，那就等于和 rejected 走同一路

错在漏掉：

- approved 是 cleanup-first, visible-later
- rejected 更像 regular-first visible reply

### 误判四：`pending/processed` 是所有 shutdown 消息的必经阶段

错在漏掉：

- 这更像 interactive leader-side local delivery path
- 不是所有 file mailbox message 的统一宿命

### 误判五：attachment 看到的 mailbox 就是 file mailbox 的原样投影

错在漏掉：

- 它会合并 `AppState.inbox.pending`
- dedup
- 折叠 idle
- 过滤部分对象
- 并把某些 pending 改成 processed

### 误判六：headless 和 interactive 的 shutdown 路由完全相同

错在漏掉：

- cleanup contract 相近
- 本地 inbox 状态机不必完全相同

## 第十二层：稳定、条件与内部边界

### 稳定可见

- shutdown 生命周期不会走单一的 mailbox routing 通道。
- `shutdown_request` 与 `shutdown_approved` 更接近 structured handler-first route。
- `shutdown_rejected` 更接近 regular visible reply route。
- `teammate_terminated` 更接近 leader 本地 injected shadow route。

### 条件公开

- `pending/processed` 这套状态机主要是 interactive leader-side local delivery path。
- headless / print 会镜像 shutdown cleanup，但不必复用同样的本地 inbox 阶段。
- request / approved 虽然先走 handler，但之后仍可能 re-enter regular message 流。
- 某条信号最终是否进入当前显示面，还要再经过 82 页讨论的显示层裁切。

### 内部 / 实现层

- `isStructuredProtocolMessage(...)` 具体白名单内容。
- `pending -> processed -> cleanup` 的精确时机。
- attachment dedup key、idle collapse、processed cleanup 的具体机制。
- `teammate_terminated` 注入时的文案生成和 task unassign 细节。

## 第十三层：苏格拉底式自检

### 问：如果同属 shutdown lifecycle，为什么不直接统一成一种 handler？

答：因为这些对象承担的职责不同。request/approved 更偏 control signal，rejected 更偏 visible reply，teammate_terminated 更偏 cleanup completion shadow。

### 问：如果 approved 最后也会透传，为什么还要强调 cleanup-first？

答：因为 cleanup 才是它的主职责；后续透传只是 secondary path，而且显示层还会继续裁切它。

### 问：如果 rejected 没走 structured 通道，这算不算正文里应该强调的稳定合同？

答：应强调“不对称 routing 的结果”是用户可见事实，但不应把那份具体白名单上升成长期稳定公开合同。

### 问：如果 `teammate_terminated` 也能显示成 summary，为什么不把它当普通 mailbox reply？

答：因为它的来源已经变了。summary 只是显示层压缩能力，不会反向改变它是本地 cleanup shadow 这一事实。

## 源码锚点

- `claude-code-source-code/src/utils/teammateMailbox.ts`
- `claude-code-source-code/src/utils/attachments.ts`
- `claude-code-source-code/src/hooks/useInboxPoller.ts`
- `claude-code-source-code/src/components/messages/AttachmentMessage.tsx`
- `claude-code-source-code/src/components/messages/ShutdownMessage.tsx`
- `claude-code-source-code/src/components/messages/PlanApprovalMessage.tsx`
- `claude-code-source-code/src/components/messages/UserTeammateMessage.tsx`
- `claude-code-source-code/src/components/teams/TeamsDialog.tsx`
- `claude-code-source-code/src/cli/print.ts`
