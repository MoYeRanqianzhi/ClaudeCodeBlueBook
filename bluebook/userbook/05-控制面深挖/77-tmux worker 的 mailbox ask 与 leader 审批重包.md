# `swarmWorkerHandler`、`useInboxPoller`、`permissionSync`、`useSwarmPermissionPoller` 与 `workerBadge`：为什么 tmux worker 的 mailbox ask 会在 leader 侧重包成 `ToolUseConfirm`，却不等于 leader 自己的本地审批

## 用户目标

不是只知道 swarm 里会出现一种现象：

- worker 需要权限时
- leader 那边会弹出一个看起来和本地主线程几乎一样的 `PermissionRequest`
- 卡片上多了一个 `@worker` badge

而是继续追问更细的结构问题：

- 这是不是说明 worker ask 已经被 leader 的本地权限系统彻底接管？
- 为什么 worker 自己只显示 waiting indicator，而 leader 却能看到完整的工具审批卡片？
- `ToolUseConfirmQueue`、`pendingWorkerRequest`、mailbox response callback 三者到底各在 ask 生命周期里扮演什么角色？

如果这些问题不先拆开，正文最容易写成一句过平的话：

- “tmux worker 的权限请求就是 leader 的本地 `ToolUseConfirm`。”

源码并不是这样工作的。

## 第一性原理

更稳的提问不是：

- “leader 那边是不是也弹了同一个审批框？”

而是四个更底层的问题：

1. ask 是在哪个进程里生成的？
2. ask 在哪一侧被重新包装进 UI 壳？
3. 批准结果回到哪里继续执行？
4. 哪一侧拥有真正的 permission context 与 continuation？

只要这四轴不先拆开，后续就会把：

- leader-visible shell

误写成：

- leader-owned local approval

## 第一层：worker ask 的起点在 worker 自己，不在 leader

### `handleSwarmWorkerPermission(...)` 先在 worker 侧决定是否要上报

`swarmWorkerHandler.ts` 的流程很清楚：

- 先检查 `isAgentSwarmsEnabled()` 和 `isSwarmWorker()`
- bash classifier 若能本地自动批准，就直接结束
- 否则才创建 mailbox permission request

这说明 tmux worker ask 的真正起点不是：

- leader 的 `ToolUseConfirmQueue`

而是：

- worker 自己的 `PermissionContext`

### worker 侧创建的是 mailbox request，不是本地 `ToolUseConfirm`

worker 侧做的动作是：

- `createPermissionRequest(...)`
- `registerPermissionCallback(...)`
- `sendPermissionRequestViaMailbox(request)`
- `setAppState(...pendingWorkerRequest...)`

这里最关键的一点是：

- worker 侧并没有把 ask 放进自己的 `toolUseConfirmQueue`

只要这一层没拆开，读者就会误以为 worker 和 leader 两边都在跑同一份完整审批卡片。

## 第二层：worker 自己只拿到 waiting indicator，而不是本地决策卡片

### `pendingWorkerRequest` 是状态指示，不是决策容器

`swarmWorkerHandler.ts` 在发送 mailbox request 之后，只会把：

- `pendingWorkerRequest`

写进 `AppState`

而 `REPL.tsx` 对这个对象做的事情也只是：

- 让 `isWaitingForApproval` 变成 true
- 在 `waitingFor` 里显示 `worker request`
- 渲染 `WorkerPendingPermission`

这说明 worker 自己的 UI 语义是：

- I am waiting for leader approval

不是：

- I am showing a local permission card

### 所以 worker 本地看到的是 pending state，不是 approval shell

更准确的说法不是：

- “worker 把 ask 弹给自己，然后同步给 leader”

而是：

- “worker 只保留等待态和 callback，真正可交互的审批壳出现在 leader 一侧”

## 第三层：leader 侧会把 mailbox ask 重包成标准 `ToolUseConfirm`

### `useInboxPoller(...)` 会把 mailbox permission request 导入 leader 的 `ToolUseConfirmQueue`

`useInboxPoller.ts` 在 leader 侧发现 mailbox permission request 后，会：

- 通过 `getLeaderToolUseConfirmQueue()` 拿到当前 REPL 的 queue setter
- 用 `findToolByName(getAllBaseTools(), parsed.tool_name)` 查本地工具
- 构造一条 `ToolUseConfirm` entry
- `setToolUseConfirmQueue(queue => [...queue, entry])`

这一步的意义是：

- worker ask 在 leader 侧获得了标准工具审批 UI 壳

### 这也是为什么 leader 能看到同款 tool-specific permission UI

源码注释已经写明：

- 这样 tmux worker 就能复用和 in-process teammate 一样的 tool-specific UI

也就是说，leader 侧得到的是：

- rewrapped approval shell

不是：

- worker ask 被重生为 leader 自己的本地 ask

## 第四层：但这份 leader-side `ToolUseConfirm` 仍然明显不是 leader 自己的本地 ask

### 它带着 `workerBadge`

leader 侧重包出来的 `ToolUseConfirm` 会显式携带：

- `workerBadge: { name: parsed.agent_id, color: 'cyan' }`

这说明它一开始就在告诉用户：

- 这是替某个 worker 决策

### 它的 `assistantMessage` 和 `toolUseContext` 都是壳层适配

这份 entry 还会使用：

- `createAssistantMessage({ content: '' })`
- `toolUseContext: {} as ToolUseConfirm['toolUseContext']`

这说明它只是为了进入同一套审批 UI 协议而做的壳层填充。

### 它的 `onUserInteraction()` / `recheckPermission()` 也是 no-op

leader-side worker entry 里：

- `onUserInteraction()` no-op
- `recheckPermission()` no-op，并注明 permission state is on the worker side

这几乎把主权边界写死了：

- leader 拥有审批壳
- worker 拥有 permission state

只要这一层没拆开，正文就会继续把 “同款 `ToolUseConfirm`” 误写成 “同款 leader 本地审批”。

## 第五层：leader 的 allow / reject / abort 不会在 leader 本地闭环，而是回发 worker

leader-side `ToolUseConfirm` 的三个出口都不是继续执行 leader 本地工具，而是：

- `sendPermissionResponseViaMailbox(...)`

其中：

- `onAllow(...)` 会带回 `updatedInput` 和 `permissionUpdates`
- `onReject(...)` 会带回 `feedback`
- `onAbort()` 会带回 rejected response

这说明 leader 在这里真正做的事情是：

- render local shell
- collect user choice
- send answer back to worker

因此更准确的说法不是：

- “leader 本地批准了这次工具调用”

而是：

- “leader 本地只主持了一次审批交互，真正的 continuation 仍回到 worker”

## 第六层：worker 侧 callback 才是 ask 生命周期恢复执行的地方

### `useSwarmPermissionPoller` 维护的是 worker 侧 callback registry

worker 发送 request 前就会：

- `registerPermissionCallback({ requestId, toolUseId, onAllow, onReject })`

之后 mailbox response 回来时：

- `useInboxPoller` 检测 permission response
- `processMailboxPermissionResponse(...)` 查 module-level registry
- 调用 worker 侧的 `onAllow` / `onReject`

### 真正的 continuation 与 permission update 应用都发生在 worker

worker 侧 callback 在 `onAllow(...)` 里会：

- 清空 `pendingWorkerRequest`
- 用 leader 回来的 `updatedInput` 合并原始输入
- 执行 `ctx.handleUserAllow(...)`

`onReject(...)` 则会：

- 清空 `pendingWorkerRequest`
- `ctx.cancelAndAbort(...)`

这说明：

- leader 拿到的是 approval interaction
- worker 持有的是 execution continuation

只要这一层没拆开，正文就会把 mailbox response 错写成 leader 的本地工具结果。

## 第七层：tmux worker ask 与 74/75/76 的关系是什么

### 它不像 74 那样是 remote container ask

74 页讲的是：

- remote session 的远端 ask 借本地壳

而这里的 worker ask：

- 起点就在另一个本地 worker 进程
- transport 是 teammate mailbox

所以这不是 container remote ask。

### 它也不像 75 那样只是 imported remote ask vs exported local ask 总拓扑

75 页讲的是几条大拓扑：

- remote session
- direct connect
- ssh session
- bridge relay

本页则更细，专门回答：

- 多进程 swarm 里，一个本地 worker ask 为什么会在另一个本地 leader REPL 里长成同款 `ToolUseConfirm`

### 它也不等于 76 的本地 modal family 总论

76 页讲的是：

- REPL 宿主里不同阻塞容器的家族差异

本页则进一步回答：

- 为什么其中某一种 `ToolUseConfirm`，其实可能来自 tmux worker mailbox rewrap

因此更准确的定位是：

- 74: remote approval shell vs authority
- 75: approval topology across remote families
- 76: local modal family inside one REPL host
- 77: cross-process mailbox ask rewrapped into leader local shell

## 第八层：这会带来哪些高频误判

### 误判一：leader 侧看到 `ToolUseConfirm`，就说明 ask 起点在 leader

错在漏掉：

- ask 起点在 worker 的 `swarmWorkerHandler(...)`

### 误判二：worker 自己也有同款审批卡片，只是同步到了 leader

错在漏掉：

- worker 只有 `pendingWorkerRequest` indicator

### 误判三：leader-side worker entry 和 leader 自己的本地 ask 是同一类 `ToolUseConfirm`

错在漏掉：

- `workerBadge`
- 空 `assistantMessage` 载体
- stub `toolUseContext`
- `recheckPermission()` no-op

### 误判四：leader 批准后，leader 本地就完成了治理闭环

错在漏掉：

- 结果通过 mailbox 回到 worker callback
- worker 才继续执行并应用 permission updates

### 误判五：tmux worker ask 和 remote session ask 只是 transport 不同

错在漏掉：

- remote session ask 来自 container control plane
- worker ask 来自 worker 本地 `PermissionContext`

### 误判六：leader 一定能为任意 worker tool 重包出同款 UI

错在漏掉：

- 若 `findToolByName(getAllBaseTools(), parsed.tool_name)` 找不到工具，leader 会直接跳过 ask
- 这里没有 remote session 那种 `createToolStub(...)` 降级壳

## 第九层：稳定、条件与内部边界

### 稳定可见

- worker 权限请求会先在 worker 侧变成 `pendingWorkerRequest`。
- leader 会把 mailbox ask 重包进本地 `ToolUseConfirmQueue`，并显示 `workerBadge`。
- leader 的选择会通过 mailbox 回流 worker，worker 才恢复 continuation。

### 条件公开

- 只有 `isAgentSwarmsEnabled()` 且 `isSwarmWorker()` 时才走这条线。
- worker 若 classifier 本地已批准，就不会上报 leader。
- mailbox 发送失败时，worker 会回退到本地交互处理。
- leader 只有在拿到 queue setter 且本地能识别对应 tool 时，才会真正重包 UI。

### 内部 / 实现层

- mailbox pending/resolved 目录与 lockfile 细节。
- module-level callback registry 的组织方式。
- `createAssistantMessage({ content: '' })` 的空载体构造。
- dedupe、desktop notification、markMessagesAsRead 失败后的重复保护。

## 第十层：最稳的记忆法

先记三句：

- `worker-originated ask`
- `leader-visible shell`
- `worker-owned continuation`

再补一句：

- `same ToolUseConfirm skin` 不等于 `same leader-local ask`

只要这四句没有一起记住，后续分析就会继续把：

- tmux worker mailbox ask

误写成：

- leader 自己的本地权限弹层

## 源码锚点

- `claude-code-source-code/src/hooks/toolPermission/handlers/swarmWorkerHandler.ts`
- `claude-code-source-code/src/hooks/useInboxPoller.ts`
- `claude-code-source-code/src/hooks/useSwarmPermissionPoller.ts`
- `claude-code-source-code/src/utils/swarm/permissionSync.ts`
- `claude-code-source-code/src/utils/swarm/leaderPermissionBridge.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/components/permissions/PermissionRequest.tsx`
