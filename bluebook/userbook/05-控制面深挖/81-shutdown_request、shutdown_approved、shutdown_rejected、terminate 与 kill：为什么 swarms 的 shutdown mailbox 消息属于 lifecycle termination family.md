# `shutdown_request`、`shutdown_approved`、`shutdown_rejected`、`terminate` 与 `kill`：为什么 swarms 的 shutdown mailbox 消息属于 lifecycle termination family

## 用户目标

不是只知道 swarms 里还有一组 shutdown 相关 mailbox 消息：

- `shutdown_request`
- `shutdown_approved`
- `shutdown_rejected`

而是继续追问更稳的问题：

- 为什么它们虽然也走 teammate mailbox，却不该并回 80 页那组 approval-adjacent protocol family？
- 为什么 `terminate()` 发的是 mailbox request，而 `kill()` 却是另一条更硬的后门？
- 为什么 `shutdown_request` 在 teammate 一侧会被优先处理，而 `shutdown_approved` 在 leader 一侧又常常不作为普通对话继续展示？

如果这些问题不先拆开，读者就会把：

- “也是一条发给 teammate 的结构化 JSON 消息”

误写成：

- “也是另一种 approval request”

源码并不是这样工作的。

## 第一性原理

更稳的提问不是：

- “这是不是又一个 ask-response 消息？”

而是四个更底层的问题：

1. request payload 在描述 tool / host / plan，还是 teammate 的存活与退出？
2. response payload 在返回 continuation 数据，还是终止判决？
3. primary consumer 是 queue / callback，还是 shutdown cleanup / topology mutation？
4. leader 发起后是在等待某次动作继续，还是在请求某个 teammate 结束当前生命周期？

只要这四轴不先拆开，后续就会把：

- mailbox transport sameness

误写成：

- lifecycle semantics sameness

## 第二层：shutdown family 总表

| 阶段 | 消息 | primary consumer | 核心语义 |
| --- | --- | --- | --- |
| request | `shutdown_request` | teammate inbox poller / model decision loop | 请求某个 teammate 结束当前生命周期 |
| approve | `shutdown_approved` | leader cleanup path / backend terminate path | 同意终止，并触发真实退出与成员清理 |
| reject | `shutdown_rejected` | leader 可见消息层 | 拒绝终止，继续工作 |

这张表最重要的作用是先建立一个事实：

- 这一族消息的主语不是某次 tool use 能不能继续
- 也不是某个 host 能不能访问
- 而是某个 teammate 要不要进入终止生命周期

所以它更准确的名字不是：

- approval protocol family

而是：

- lifecycle termination family

## 第三层：发起点已经在暗示它不是普通 approval ask

shutdown request 的发起点同时出现在三处：

- `TeamsDialog.tsx` 里，team lead 在 teammate 列表按 `s`，发送“graceful shutdown requested”
- `PaneBackendExecutor.ts` 的 `terminate()`，给 pane teammate 发 mailbox `shutdown_request`
- `InProcessBackend.ts` 的 `terminate()`，给 in-process teammate 发同类 mailbox request

这里最关键的对照是：

- `terminate()` = 先发 `shutdown_request`
- `kill()` = 直接走更强制的 backend kill path

也就是说，源码一开始就把两件事拆开了：

- 请求对方自行结束
- 宿主直接强杀

如果 shutdown 只是另一种 permission ask，就不需要再额外保留一条 `kill()` 硬路径。

## 第四层：`shutdown_request` 在 teammate 侧不是排队审批，而是生命周期中断

`useInboxPoller.ts` 会把 unread mailbox 消息分成：

- `shutdownRequests`
- `shutdownApprovals`
- 以及其它 regular / permission / sandbox / plan 消息

但 teammate 一侧处理 `shutdown_request` 的方式非常特殊：

- 它不会被重包进 `ToolUseConfirmQueue`
- 不会进入 `workerSandboxPermissions.queue`
- 而是保留原始 JSON，作为 regular teammate message 继续送给 UI 和模型

注释写得很直白：

- UI component 会把它渲染好
- model 会通过 tool prompt 文档收到 approve / reject 的操作说明

这已经和 approval shell 那条线明显不同：

- 这里不是 host 为某次 continuation 代为决策
- 而是 teammate 自己要对“是否退出”作出判断

## 第五层：in-process runner 甚至把 shutdown 请求放在普通未读消息之前

`inProcessRunner.ts` 会先扫描 unread mailbox：

- 如果找到 `shutdown_request`
- 就优先于普通 unread backlog 处理

日志里还会显式记录：

- 这条 shutdown request 被优先于多少条 unread message 处理

返回对象也不是 generic new message，而是：

- `{ type: 'shutdown_request', ... }`

后续 runner 会把它包装成 teammate message：

- 送进当前 prompt
- 写入 transcript
- 让模型用 shutdown approval / rejection 工具作答

这说明 shutdown request 在运行时的角色不是：

- 普通 coordination message

而是：

- lifecycle interrupt

## 第六层：`SendMessageTool` 把 shutdown decision 单独做成结构化终止合同

`SendMessageTool.ts` 的 structured message 分类里，shutdown 明确独立于 plan approval：

- `shutdown_request`
- `shutdown_response`
- `plan_approval_response`

并且 call 路由会分成三条专门分支：

- `handleShutdownRequest`
- `handleShutdownApproval`
- `handleShutdownRejection`

这说明 shutdown 不是借用别人的 response envelope，而是自己有一套 termination contract。

### approval 路径返回的是终止确认，不是 continuation data

`handleShutdownApproval(...)` 会：

- 构造 `shutdown_approved`
- 附带自身 `paneId` 和 `backendType`（如果拿得到）
- 发回 `team-lead`

然后按 backend 分两路退出：

- `in-process` teammate 直接 abort 自己的 task controller
- 其它路径优先尝试从 AppState 找 abort controller，找不到再 `gracefulShutdown(...)`

这和 tool permission response 的区别非常大：

- 它不会回 `updated_input`
- 不会回 `permission_updates`
- 不会驱动某次工具继续执行

它回的是：

- “我同意结束自己，并开始退出”

### rejection 路径要求给出 reason

`SendMessageTool` 的输入校验明确要求：

- `shutdown_response` 只能发给 `team-lead`
- 如果是 reject，必须提供 `reason`

所以 reject 也不是沉默失败，而是显式 lifecycle verdict：

- 我拒绝退出
- 原因是什么
- 我会继续工作

## 第七层：leader 侧真正特殊消费的是 `shutdown_approved`，不是 `shutdown_rejected`

`useInboxPoller.ts` 的 unread 分类只单独抓：

- `shutdown_request`
- `shutdown_approved`

却没有单独开一个 `shutdown_rejected` 队列。

这不是遗漏，而是语义区别：

- `shutdown_approved` 会触发真实 cleanup side effect
- `shutdown_rejected` 更像需要展示给 leader 看的显式回复

leader 收到 `shutdown_approved` 后会做两件大事：

1. 如果有 `paneId` 和 `backendType`，就尝试 kill pane
2. 把对应 teammate 从 `teamContext.teammates` 和 team file 里移除

也就是说，approved 不是“再显示一条用户消息”那么简单，而是：

- topology mutation trigger

相反，rejected 主要回到消息展示层，告诉 leader：

- 这名 teammate 没退出
- 原因是什么

## 第八层：UI 也在强化这条 termination / effect 分层

`ShutdownMessage.tsx` 会专门渲染：

- `shutdown_request`
- `shutdown_rejected`

并给出清晰 summary。

但它对 `shutdown_approved` 的处理是：

- 直接返回 `null`

`UserTeammateMessage.tsx` 和 `AttachmentMessage.tsx` 也都会预先过滤：

- `shutdown_approved`

所以 UI 传达出来的模型并不是：

- request / approved / rejected 三条都同样属于可持续对话内容

而是：

- request 和 rejected 是可读的生命周期对话
- approved 更像一条控制后果，重点在退出与清理

这进一步证明它不该被写成普通 approval workflow。

## 第九层：`terminate()` 与 `kill()` 是这页最稳的用户级区分

如果只从用户角度记一个最实用的判断，就是：

- `terminate()` 代表“请求对方自己收尾退出”
- `kill()` 代表“宿主直接强制结束”

`TeamsDialog.tsx` 里也把这两个动作拆成两个按键：

- `s` = shutdown
- `k` = kill teammate

而 `PaneBackendExecutor.ts` 里：

- `terminate()` 只写 mailbox `shutdown_request`
- `kill()` 才直接操作 pane backend

所以最不该写错的一句是：

- shutdown 不是 kill 的同义词

它更像：

- graceful termination request

## 第十层：交互模式与 headless 模式在终止收口上是一致的

这条 shutdown family 不只存在于交互 REPL。

`print.ts` 在 headless / print 模式下也会额外处理：

- `shutdown_approved`

并把对应 teammate 从 team file 中移除。

也就是说，interactive `useInboxPoller` 和 headless `print.ts` 在一个关键事实上是对齐的：

- approved 不是普通聊天消息
- 它会引发宿主侧的真实清理后果

这让 shutdown family 的“termination contract”更稳，不只是某个 UI 组件的偶然设计。

## 第十一层：为什么这页不并回 80 页

80 页已经回答的是：

- `permission_request`
- `sandbox_permission_request`
- `plan_approval_request`

为什么共享 mailbox transport，却不属于同一种 approval-adjacent protocol family。

81 页继续往下拆时，如果把 shutdown 也并进去，会重新失焦，因为 shutdown 最核心的问题不是：

- 该不该批准一次 continuation

而是：

- 某个 teammate 是否进入终止生命周期

所以两页的最稳分工是：

- 80 = approval-adjacent mailbox families
- 81 = lifecycle termination mailbox family

## 第十二层：最常见的假等式

### 误判一：`shutdown_request` 也是另一种 permission ask

错在漏掉：

- 它的对象是 teammate liveness
- 不是 tool continuation / host access / plan transition

### 误判二：`shutdown_approved` 只是“允许退出”的对话文本

错在漏掉：

- 它会触发 pane kill
- 会移除 teammate
- 会改写 team topology

### 误判三：`shutdown_rejected` 和 `shutdown_approved` 会被同样消费

错在漏掉：

- approved 主要驱动 cleanup
- rejected 主要回到可见消息层

### 误判四：`terminate()` 就是 `kill()`

错在漏掉：

- 前者先走 mailbox request
- 后者才是强制 backend termination

### 误判五：既然也走 mailbox，它就该并回 approval family

错在漏掉：

- shutdown family 关注的是生命周期终止
- approval family 关注的是 continuation / transition 决定

## 第十三层：稳定、条件与内部边界

### 稳定可见

- `shutdown_request`、`shutdown_approved`、`shutdown_rejected` 构成一组独立的 shutdown mailbox family。
- 这组消息更接近 lifecycle termination，而不是 approval continuation。
- `terminate()` 和 `kill()` 是两条不同路径：前者请求 graceful shutdown，后者直接强制结束。
- `shutdown_approved` 会触发真实 teammate cleanup，而不是只增加一条普通对话消息。

### 条件公开

- pane teammate 才会稳定走 `paneId` / `backendType` -> `killPane(...)` 这条分支。
- in-process teammate 更依赖 abort controller / graceful shutdown。
- `shutdown_approved` 是否在当前展示面可见，取决于渲染路径；很多 UI 会主动过滤。
- shutdown request 可来自 Teams UI，也可来自 backend terminate path 或 structured message tool。

### 内部 / 实现层

- `requestId` 生成方式、message schema helper、JSON 字段命名。
- unread 分类、mark-as-read、regular pass-through 的具体调度顺序。
- `paneId`、`backendType` 是否可用，取决于成员记录和 backend 类型。
- 具体日志文本与 fallback abort/graceful shutdown 的细枝节。

## 第十四层：苏格拉底式自检

### 问：如果它真是 approval protocol，为什么不排进现有 approval queue？

答：因为 shutdown 的被决策对象不是某次动作，而是 teammate 自己的生命周期。consumer 也不是 queue + continuation callback，而是模型判决 + cleanup side effect。

### 问：如果它真只是“消息展示”，为什么 `shutdown_approved` 会被过滤？

答：因为 approved 的价值主要不在继续阅读，而在触发退出、kill pane、移除成员这些控制后果。

### 问：如果它真和 `kill()` 等价，为什么源码要保留两条路径？

答：因为 graceful termination request 和 forced termination 本来就是两种不同宿主动作。

### 问：如果它真应该并回 80 页，80 页为什么还要先把它排除？

答：因为 80 页讨论的是 approval-adjacent family，shutdown 讨论的是 lifecycle termination family，主语不同。

## 源码锚点

- `claude-code-source-code/src/utils/teammateMailbox.ts`
- `claude-code-source-code/src/hooks/useInboxPoller.ts`
- `claude-code-source-code/src/utils/swarm/inProcessRunner.ts`
- `claude-code-source-code/src/utils/swarm/backends/PaneBackendExecutor.ts`
- `claude-code-source-code/src/utils/swarm/backends/InProcessBackend.ts`
- `claude-code-source-code/src/tools/SendMessageTool/SendMessageTool.ts`
- `claude-code-source-code/src/components/messages/ShutdownMessage.tsx`
- `claude-code-source-code/src/components/messages/UserTeammateMessage.tsx`
- `claude-code-source-code/src/components/messages/AttachmentMessage.tsx`
- `claude-code-source-code/src/components/teams/TeamsDialog.tsx`
- `claude-code-source-code/src/cli/print.ts`
