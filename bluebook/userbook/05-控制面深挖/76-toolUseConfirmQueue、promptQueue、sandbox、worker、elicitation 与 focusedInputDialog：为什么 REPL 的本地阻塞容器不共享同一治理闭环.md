# `toolUseConfirmQueue`、`promptQueue`、`sandboxPermissionRequestQueue`、`workerSandboxPermissions`、`elicitation.queue` 与 `focusedInputDialog`：为什么 REPL 里的本地阻塞式输入与审批容器看起来同族，却不共享同一主权与治理闭环

## 用户目标

不是只知道 REPL 里会出现很多“挡住输入、等用户处理”的东西：

- 工具审批卡片
- hook prompt 选择框
- network access 弹层
- worker waiting 指示
- MCP elicitation 对话框

而是继续追问更细的结构问题：

- 这些容器为什么都能让 REPL 进入 waiting，却不能写成同一种 permission system？
- 为什么有的容器只是等待态指示，有的容器却真的带着 allow / reject / recheck 治理闭环？
- 为什么它们看起来像同一家 modal family，但渲染槽位、动作语义、主权位置都不同？

如果这些问题不先拆开，正文最容易把它们压成一句模糊的话：

- “REPL 里所有弹出来的阻塞式对话框，本质上都是同一个审批队列。”

源码并不是这样工作的。

## 第一性原理

更稳的提问不是：

- “这里是不是一个 modal？”

而是五个更底层的问题：

1. 这个容器的事件从哪里来？
2. 它装的是决策对象，还是只装等待态？
3. 它改变的是本地权限上下文、promise 回调，还是仅仅显示状态？
4. 它走 overlay，还是走 bottom/modal 槽位？
5. `Escape` / cancel / recheck 对它到底意味着什么？

只要这五轴不先拆开，后续就会把：

- shared blocking shell

误写成：

- shared governance loop

## 第一层：REPL 确实维护了一整个“阻塞式输入与审批容器家族”

`REPL.tsx` 明确同时维护了多组会阻塞输入的容器：

- `toolUseConfirmQueue`
- `sandboxPermissionRequestQueue`
- `promptQueue`
- `workerSandboxPermissions.queue`
- `elicitation.queue`

同时还维护两种等待态指示：

- `pendingWorkerRequest`
- `pendingSandboxRequest`

这些对象会一起影响：

- `isWaitingForApproval`
- `waitingFor`
- `hasActivePrompt`
- `focusedInputDialog`

这说明从 REPL 宿主视角看，它们确实属于：

- one blocking-input family

但这还不能推出：

- one governance family

只要这一层没拆开，读者就会把“同属阻塞式宿主容器”误写成“同属同一控制面”。

## 第二层：`focusedInputDialog` 证明它们共用的是宿主仲裁器，不是同一种语义

### REPL 会把这些容器压进同一套焦点仲裁规则

`getFocusedInputDialog()` 会按优先级选择：

- `sandbox-permission`
- `tool-permission`
- `prompt`
- `worker-sandbox-permission`
- `elicitation`

并在用户正在输入时压住其中一部分对话框。

这说明它们共享的是：

- focus arbitration
- input suppression
- waiting-state accounting

### 但共享仲裁器，不等于共享主权

更准确的说法是：

- REPL 把不同来源的阻塞事件统一编排进一张宿主排队表

而不是：

- REPL 把这些事件统一纳入同一种审批权威

只要这一层没拆开，正文就会把 `focusedInputDialog` 的统一调度能力误写成统一治理能力。

## 第三层：`toolUseConfirmQueue` 是治理型容器，不只是显示型容器

### `ToolUseConfirm` 自带治理协议

`PermissionRequest.tsx` 定义的 `ToolUseConfirm` 不是一条普通 UI 记录，而是一组可执行治理接口：

- `onUserInteraction()`
- `onAbort()`
- `onAllow(...)`
- `onReject(...)`
- `recheckPermission()`

这说明 `toolUseConfirmQueue` 里装的不是单纯“渲染素材”，而是：

- governance-bearing decision entries

### 本地权限上下文变化还会主动重检这条队列

`REPL.tsx` 里的 `setToolPermissionContext(...)` 会在上下文变化后遍历当前 queue，逐项执行：

- `item.recheckPermission()`

这点极关键，因为它说明：

- `toolUseConfirmQueue` 真实处在权限治理闭环里

只要这一层没拆开，读者就会把 `toolUseConfirmQueue` 和别的 promise queue 一起写成普通“弹窗列表”。

## 第四层：`promptQueue` 共享了对话框外壳，却不共享 permission governance

### `requestPrompt(...)` 只是一个 prompt 协议回调工厂

`Tool.ts` 里 `requestPrompt` 的定义非常直接：

- 只在交互式 REPL 场景可用
- 返回一个 `PromptRequest -> PromptResponse` 的 promise 风格回调

`REPL.tsx` 的 `requestPrompt(...)` 则只是把：

- `request`
- `title`
- `toolInputSummary`
- `resolve`
- `reject`

塞进 `promptQueue`

### `PromptDialog` 复用的是 `PermissionDialog` 壳，不是 `PermissionRequest` 治理协议

`PromptDialog.tsx` 虽然也渲染进：

- `PermissionDialog`

但它做的事情只是：

- 展示 `request.message`
- 展示 options
- `onRespond(...)` 时 resolve
- `onAbort()` 时 reject

它没有：

- `permissionUpdates`
- `recheckPermission()`
- `toolPermissionContext` 写入
- `ToolUseConfirm` 语义

因此更准确的结论不是：

- promptQueue 是另一种 permission queue

而是：

- promptQueue 是 prompt-protocol container over shared modal shell

只要这一层没拆开，正文就会把“共用 `PermissionDialog` 外壳”误写成“共用 `PermissionRequest` 治理逻辑”。

## 第五层：`sandboxPermissionRequestQueue` 是本地 network approval 容器，但它和 `toolUseConfirmQueue` 仍不是同一种治理对象

### 它管理的是 host access ask，不是 `ToolUseConfirm`

`sandboxPermissionRequestQueue` 的条目只包含：

- `hostPattern`
- `resolvePromise`

它不是 `ToolUseConfirm`，也不走 tool-specific permission component。

### 它会真正改写本地权限规则，但改写方式完全不同

用户在 `SandboxPermissionRequest` 里选择允许并持久化时，REPL 会：

- 构造 `addRules`
- `applyPermissionUpdate(...)`
- `persistPermissionUpdate(update)`
- `SandboxManager.refreshConfig()`

同时它还有两个额外特征：

- 同 host 多请求会批量 resolve / remove
- bridge 连着时可以把 network ask 外发给远端用户参与竞速

因此更准确的说法是：

- sandboxPermissionRequestQueue 是 host-based approval queue

不是：

- another `ToolUseConfirmQueue`

只要这一层没拆开，读者就会把“也能持久化规则”误写成“和工具审批是同一种条目协议”。

## 第六层：`pendingWorkerRequest` / `pendingSandboxRequest` 不是决策容器，而是 worker 侧等待态

### worker 请求权限时，自己并不弹决策框

`swarmWorkerHandler.ts` 会在 worker 侧：

- 通过 mailbox 把 permission request 发给 leader
- 把 `pendingWorkerRequest` 写进 `AppState`

worker 的 REPL 只会显示：

- `WorkerPendingPermission`

而不是本地 allow / reject UI。

同样地，worker 请求 sandbox host 时：

- 会写入 `pendingSandboxRequest`
- 只显示等待 leader 批准的 indicator

### 所以 pending state 是“我在等别人批”，不是“我自己来批”

这点必须单独拆开，因为从 REPL 的 waiting 角度看，它和其它容器都会让界面进入 waiting，但从主权角度看它只是：

- waiting-state indicator

不是：

- decision-bearing container

只要这一层没拆开，正文就会把 worker pending 误写成“另一种本地审批框”。

## 第七层：`workerSandboxPermissions.queue` 与 leader-side worker ask 是“替别人决策”的容器

### leader 侧会真正收到来自 worker 的 sandbox ask

`useInboxPoller.ts` 会把 worker 发来的 sandbox permission request 收进：

- `workerSandboxPermissions.queue`

然后 REPL 在 `focusedInputDialog === 'worker-sandbox-permission'` 时渲染：

- `SandboxPermissionRequest`

### 它能决策，但决策对象不是当前本地主线程自己的 ask

leader 在这里做的事情是：

- 代表 worker 允许/拒绝某个 host
- 通过 mailbox 回发结果

所以这是一类：

- proxy approval container

而不是：

- self-owned local ask container

它与 `pendingSandboxRequest` 正好形成 worker/leader 两端的镜像错位。

## 第八层：`elicitation.queue` 既不是工具审批，也不是 hook prompt

### `elicitation.queue` 来自 MCP server 的 elicitation 协议

`services/mcp/client.ts` 与 `services/mcp/elicitationHandler.ts` 都会把事件压进：

- `elicitation.queue`

条目里带的是：

- `serverName`
- `requestId`
- `params`
- `signal`
- `waitingState`
- `respond(...)`

### 它还是一个两阶段 / 可外部完成的对话框

这条线和 `promptQueue` 最大的不同在于：

- 它会收到 completion notification
- queue item 还能被标记 `completed: true`
- dialog 会对 waiting/dismiss 作出不同响应

因此更准确的结论不是：

- elicitation = MCP 版 promptQueue

而是：

- elicitation 是 server-driven interactive protocol queue

只要这一层没拆开，正文就会把 MCP elicitation 混回 hook prompt。

## 第九层：同一家 modal family，连渲染槽位都不一样

### `tool-permission` 是 overlay

REPL 明确把：

- `focusedInputDialog === 'tool-permission'`

单独渲染成：

- `toolPermissionOverlay`

挂进 `FullscreenLayout.overlay`

### 其余很多容器则走 bottom/modal 槽位

而：

- `SandboxPermissionRequest`
- `PromptDialog`
- `WorkerPendingPermission`
- `worker-sandbox-permission`
- `ElicitationDialog`

主要出现在 `FullscreenLayout.bottom`

这说明即使在宿主渲染层，它们也不是：

- one modal slot

而是：

- one blocked-input family with divergent render lanes

只要这一层没拆开，正文就会把所有“挡住输入”的对象写成同一个对话框层。

## 第十层：这会带来哪些高频误判

### 误判一：会让 REPL waiting 的都属于同一审批队列

错在漏掉：

- waiting-state family
- 不等于 governance family

### 误判二：`PromptDialog` 也是 `PermissionRequest`

错在漏掉：

- 它只复用 `PermissionDialog` 壳
- 不复用 `ToolUseConfirm` 协议

### 误判三：worker pending 代表 worker 本地可以自己批准

错在漏掉：

- 这只是等待 leader 的 indicator

### 误判四：sandbox queue 和 tool queue 只是不同皮肤

错在漏掉：

- 一个是 `ToolUseConfirm`
- 一个是 host-based `resolvePromise`

### 误判五：elicitation 只是 MCP 版 hook prompt

错在漏掉：

- 它有 server-driven completion / waiting 两阶段协议

### 误判六：所有阻塞式容器都在同一个 modal slot 里渲染

错在漏掉：

- `tool-permission` 走 overlay
- 其余很多走 bottom/modal

## 第十一层：稳定、条件与内部边界

### 稳定可见

- REPL 维护了一组统一的阻塞式输入与审批容器家族。
- `toolUseConfirmQueue`、`promptQueue`、sandbox/worker/elicitation 容器会一起参与 waiting/focus 仲裁。
- 它们看起来同族，但不共享同一主权与治理闭环。

### 条件公开

- `promptQueue` 只在交互式 REPL 场景通过 `requestPrompt(...)` 可用。
- sandbox ask 是否与 bridge 竞速，取决于 bridge callbacks 是否存在。
- worker pending / worker sandbox 容器只有 swarm worker / leader 场景才出现。
- elicitation queue 的两阶段 waiting/completed 行为取决于 MCP server 是否发 completion notification。

### 内部 / 实现层

- `focusedInputDialog` 的优先级顺序细节。
- `toolPermissionOverlay` 与 bottom 槽位的具体实现组织。
- `sandboxBridgeCleanupRef` 的 sibling cleanup 细节。
- `promptQueueUseCount`、survey 抑制、spinner 抑制等宿主协同细节。

## 第十二层：最稳的记忆法

先记三句：

- `same waiting family` 不等于 `same governance family`
- `shared modal shell` 不等于 `shared permission protocol`
- `pending indicator` 不等于 `decision container`

只要这三句没有一起记住，后续分析就会继续把：

- REPL 里的阻塞式容器家族

误写成：

- 一整套同构审批队列

## 源码锚点

- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/components/permissions/PermissionRequest.tsx`
- `claude-code-source-code/src/components/hooks/PromptDialog.tsx`
- `claude-code-source-code/src/Tool.ts`
- `claude-code-source-code/src/types/hooks.ts`
- `claude-code-source-code/src/hooks/toolPermission/handlers/swarmWorkerHandler.ts`
- `claude-code-source-code/src/hooks/useInboxPoller.ts`
- `claude-code-source-code/src/services/mcp/client.ts`
- `claude-code-source-code/src/services/mcp/elicitationHandler.ts`
- `claude-code-source-code/src/state/AppStateStore.ts`
