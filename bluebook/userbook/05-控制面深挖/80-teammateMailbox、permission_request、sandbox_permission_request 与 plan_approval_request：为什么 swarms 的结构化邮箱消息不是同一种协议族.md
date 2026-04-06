# `teammateMailbox`、`permission_request`、`sandbox_permission_request` 与 `plan_approval_request`：为什么 swarms 的结构化邮箱消息不是同一种协议族

## 用户目标

不是只知道 swarms 里存在很多结构化 mailbox 消息：

- `permission_request`
- `permission_response`
- `sandbox_permission_request`
- `sandbox_permission_response`
- `plan_approval_request`
- `plan_approval_response`

而是继续追问更细的协议问题：

- 为什么它们都走 teammate mailbox，却不能写成同一种“审批消息”？
- 哪几类是在镜像 SDK control family，哪几类已经是更高层的 workflow family？
- 为什么 plan approval 看起来也像“请 leader 批准”，却和 permission / sandbox 的 ask-response 结构完全不同？

如果这些问题不先拆开，前面的 approval shell 分析就会在协议层重新塌回一句模糊的话：

- “swarms 里所有给 leader 发的结构化消息，本质上都是同一种审批请求。”

源码并不是这样工作的。

## 第一性原理

更稳的提问不是：

- “这是不是一条发给 leader 的 JSON 消息？”

而是四个更底层的问题：

1. request payload 在描述什么对象？
2. response payload 在返回什么语义？
3. 主要 consumer 是 queue/callback，还是状态迁移 / workflow 迁移？
4. leader 收到后是在等待用户决策，还是直接自动处理？

只要这四轴不先拆开，后续就会把：

- mailbox transport sameness

误写成：

- protocol family sameness

## 第二层：三类消息族总表

| 消息族 | request payload | response payload | primary consumer | leader 行为 |
| --- | --- | --- | --- | --- |
| tool permission family | `tool_name`、`tool_use_id`、`input`、`permission_suggestions` | `updated_input`、`permission_updates` 或 error | `ToolUseConfirm` rewrap + worker callback | 等待用户决策 |
| sandbox host family | `hostPattern.host`、worker identity | `allow: boolean` | `workerSandboxPermissions.queue` + sandbox callback | 等待用户决策 |
| plan approval family | `planFilePath`、`planContent`、`requestId` | `approved`、`feedback?`、`permissionMode?` | plan mode state transition / teammate task state | leader 侧默认 auto-approve |

这张表最重要的作用是先建立一个事实：

- 同样都是 mailbox message
- 但描述对象、返回对象、consumer 和 leader 行为都不同

## 第三层：`permission_request` 族是在镜像 tool control 语义

### request payload 明显贴着 `can_use_tool`

`teammateMailbox.ts` 里 `PermissionRequestMessage` 直接携带：

- `tool_name`
- `tool_use_id`
- `description`
- `input`
- `permission_suggestions`

并且注释明确说：

- field names align with SDK `can_use_tool`

### response payload 也在镜像 control response

`PermissionResponseMessage` 则是：

- `subtype: success | error`
- success 时带 `updated_input` / `permission_updates`

这说明这族消息的协议角色非常清楚：

- mailbox transport over tool control semantics

它不是一般性的“请 leader 批准我做某事”，而是：

- 明确针对 tool permission continuation 的消息族

## 第四层：`sandbox_permission_request` 族不是 tool control 镜像，而是 host approval 最小协议

### request payload 只关心 host

`SandboxPermissionRequestMessage` 的 request payload 只有：

- `requestId`
- worker identity
- `hostPattern.host`
- `createdAt`

它不携带：

- `tool_use_id`
- `updated_input`
- `permission_suggestions`

### response payload 也只是 `allow: boolean`

`SandboxPermissionResponseMessage` 只有：

- `requestId`
- `host`
- `allow`

所以这族消息更准确地说是：

- host approval queue protocol

而不是：

- mailbox version of tool control response

只要这一层没拆开，读者就会把 sandbox host ask 误写成 “简化版 permission_request”。

## 第五层：`plan_approval_request` 族已经是 workflow protocol，不是 permission protocol

### request payload 携带的是 plan artifact，不是 tool/host ask

`PlanApprovalRequestMessageSchema` 带的是：

- `planFilePath`
- `planContent`
- `requestId`

这说明 request 在描述的是：

- a plan artifact for workflow transition

而不是：

- a tool use
- a host access attempt

### response payload 驱动的是 plan mode transition

`plan_approval_response` 带：

- `approved`
- `feedback?`
- `permissionMode?`

`useInboxPoller.ts` 在 worker 侧收到来自 `team-lead` 的 approved response 后，会：

- 读取 `permissionMode`
- `applyPermissionUpdate(...)`
- 退出 plan mode

这说明这族消息本质上是：

- workflow state transition protocol

不是：

- permission continuation protocol

## 第六层：leader 对这三类消息的默认行为也完全不同

### permission / sandbox：leader 主要是在主持交互

对 `permission_request` 和 `sandbox_permission_request`：

- leader 要么排进 queue
- 要么显示 approval shell
- 等用户 decide

也就是说 leader 主要扮演：

- interactive approval host

### plan approval：leader 默认 auto-approve

`useInboxPoller.ts` 对 `planApprovalRequests` 的 leader-side 逻辑是：

- 发现 request
- 生成 `plan_approval_response`
- 默认 `approved: true`
- 继承 / 转换 leader 当前 `permissionMode`
- 直接写回 teammate mailbox

然后只把原 request 当 regular message 继续透传给模型做上下文。

这和前两族的语义完全不同：

- leader 在这里主要扮演 workflow gatekeeper

不是：

- queue-based approval host

## 第七层：所以三族消息落在三种不同的 consumer 上

### permission family -> queue + callback

- leader 侧 `ToolUseConfirmQueue`
- worker 侧 permission callback registry

### sandbox family -> host queue + callback

- leader 侧 `workerSandboxPermissions.queue`
- worker 侧 sandbox callback registry

### plan approval family -> state transition + task state helper

- worker 侧 plan mode state transition
- in-process teammate 任务态更新
- leader 侧 auto-approve writer

更准确的结论不是：

- “它们都是 mailbox approval request”

而是：

- “它们共享 transport，但属于三种不同的 consumer family”

## 第八层：为什么这页不把 `shutdown_request` 一起并进来

`teammateMailbox.ts` 里当然还有：

- `shutdown_request`
- `shutdown_approved`
- `shutdown_rejected`

但这页先故意不把它混进来，原因是：

- permission / sandbox / plan approval 都围绕 approval / transition
- shutdown 更像 lifecycle termination family

把它强塞进来，只会让这页重新失去焦点。

所以这页只讲：

- approval-adjacent mailbox families

不讲：

- lifecycle termination family

## 第九层：这会带来哪些高频误判

### 误判一：`permission_request` 和 `sandbox_permission_request` 只是字段多少不同

错在漏掉：

- 前者镜像 tool control continuation
- 后者只是 host approval 最小协议

### 误判二：`plan_approval_request` 也是另一种 permission ask

错在漏掉：

- 它描述的是 plan artifact
- 它驱动的是 workflow state transition

### 误判三：三族消息都需要 leader 等用户交互

错在漏掉：

- plan approval 默认 auto-approve

### 误判四：它们都应该回到某个 callback registry

错在漏掉：

- plan approval 更主要回到 state transition，不是 callback continuation

### 误判五：transport 一样，所以协议层也一样

错在漏掉：

- payload shape
- response semantics
- consumer shape
- leader behavior

这四轴全都不同。

## 第十层：稳定、条件与内部边界

### 稳定可见

- `permission_request`、`sandbox_permission_request`、`plan_approval_request` 虽然都走 teammate mailbox，但不是同一种协议族。
- tool permission、host approval、plan workflow 三族消息的 payload 和 consumer 都不同。
- plan approval 不是 queue-based permission continuation，而是 workflow state transition。

### 条件公开

- 只有 swarms / teammates / plan-mode-required 等对应运行条件满足时，这些协议才会出现。
- plan approval response 只接受来自 `team-lead` 的消息。
- 某些族会回退到本地处理，某些族则直接 auto-approve。

### 内部 / 实现层

- mailbox JSON 的具体字段命名。
- in-process teammate task state helper 的联动。
- unread message 分类、mark-as-read、regular message pass-through 等调度细节。
- `shutdown_request` 等相邻消息族的具体形状。

## 第十一层：最稳的记忆法

先记三句：

- `permission_request` = tool control continuation family
- `sandbox_permission_request` = host approval family
- `plan_approval_request` = workflow transition family

再补一句：

- `same mailbox transport` 不等于 `same protocol family`

只要这四句没有一起记住，后续分析就会继续把：

- swarms 的结构化邮箱消息

误写成：

- 一整套同构审批协议

## 源码锚点

- `claude-code-source-code/src/utils/teammateMailbox.ts`
- `claude-code-source-code/src/hooks/useInboxPoller.ts`
- `claude-code-source-code/src/tools/ExitPlanModeTool/ExitPlanModeV2Tool.ts`
- `claude-code-source-code/src/utils/swarm/permissionSync.ts`
- `claude-code-source-code/src/hooks/useSwarmPermissionPoller.ts`
