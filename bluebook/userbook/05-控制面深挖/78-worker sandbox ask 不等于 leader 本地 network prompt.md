# `sendSandboxPermissionRequestViaMailbox`、`workerSandboxPermissions`、`pendingSandboxRequest` 与 sandbox callback：为什么 worker sandbox ask 不等于 leader 本地 network prompt

## 用户目标

不是只知道 swarm 里还存在另一种看起来很像的现象：

- worker 请求 network access 时
- leader 那边会出现一个 `SandboxPermissionRequest`
- worker 自己只显示 “Waiting for leader to approve network access”

而是继续追问更细的结构问题：

- 这是不是说明 worker 的 sandbox ask 已经被 leader 的本地 network prompt 完整接管？
- `pendingSandboxRequest`、`workerSandboxPermissions.queue`、sandbox callback 这三段链路，到底谁负责状态、谁负责 UI、谁负责 continuation？
- 这条线和上一页 worker tool permission mailbox ask 到底是同构，还是只是在“worker -> leader -> worker”这一层同构？

如果这些问题不先拆开，正文最容易写成一句过平的话：

- “worker 的 sandbox 请求就是 leader 本地的 `SandboxPermissionRequest`。”

源码并不是这样工作的。

## 第一性原理

更稳的提问不是：

- “leader 有没有看到同一个 network access 弹层？”

而是四个更底层的问题：

1. sandbox ask 在哪一侧生成？
2. leader 侧拿到的是本地 ask，还是 mailbox ask 的队列化重包？
3. worker 自己到底持有什么对象？
4. allow/deny 最终在哪边 resolve 原 promise？

只要这四轴不先拆开，后续就会把：

- leader-side host approval queue

误写成：

- leader-owned local sandbox prompt

## 第一层：worker sandbox ask 的起点仍然在 worker，不在 leader

### worker 先决定是否尝试 mailbox 上报

`REPL.tsx` 在 network access 路径里先判断：

- `isAgentSwarmsEnabled()`
- `isSwarmWorker()`

满足时就：

- `generateSandboxRequestId()`
- `sendSandboxPermissionRequestViaMailbox(host, requestId)`

这说明 ask 的起点不是：

- leader 的 `workerSandboxPermissions.queue`

而是：

- worker 自己的 sandbox runtime path

### mailbox 发送失败还会回退到 worker 本地 `sandboxPermissionRequestQueue`

更关键的是，若 mailbox 发送失败，worker 会直接：

- `setSandboxPermissionRequestQueue(...)`

这说明 worker sandbox ask 首先属于：

- worker-owned ask

leader 队列只是其中一种上报路径，不是 ask 的起点。

## 第二层：worker 自己只持有 pending state 与 sandbox callback

### worker 侧成功上报后，不会弹本地 sandbox 对话框

worker 上报成功后会：

- `registerSandboxPermissionCallback({ requestId, host, resolve })`
- `setAppState(...pendingSandboxRequest...)`

也就是说，worker 保留下来的只有：

- 原 promise 的 resolve callback
- 一个 pending indicator

### worker 本地看到的是 `pendingSandboxRequest`，不是本地决策框

`REPL.tsx` 会用 `pendingSandboxRequest`：

- 参与 `isWaitingForApproval`
- 在 `waitingFor` 里显示 `sandbox request`
- 渲染 `WorkerPendingPermission`

因此更准确的说法不是：

- “worker 先弹本地 network prompt，再同步给 leader”

而是：

- “worker 只保留等待态和 callback，真正可交互的 host approval UI 在 leader 一侧”

## 第三层：leader 侧把 mailbox ask 排进 `workerSandboxPermissions.queue`

### `useInboxPoller(...)` 会把 mailbox sandbox request 收进 leader AppState

leader 侧检测到 mailbox 里的 `sandbox_permission_request` 后，会：

- 解析 `workerId`
- `workerName`
- `workerColor`
- `host`
- `createdAt`

然后把这些对象追加进：

- `workerSandboxPermissions.queue`

### 这说明 leader 侧拿到的是 host-approval queue item，不是普通本地 `sandboxPermissionRequestQueue`

这里最关键的差异是：

- leader 自己的本地 network ask 进入 `sandboxPermissionRequestQueue`
- worker 发来的 mailbox ask 进入 `workerSandboxPermissions.queue`

也就是说，leader 虽然显示的是同款 `SandboxPermissionRequest` 组件，但底层装配对象并不是同一个 queue family。

只要这一层没拆开，正文就会把这两种 host prompt 混成一类 ask。

## 第四层：leader 侧显示的是同款 `SandboxPermissionRequest`，但它仍然不是 leader 自己的本地 ask

### `focusedInputDialog === 'worker-sandbox-permission'` 走的是单独分支

REPL 对 worker sandbox ask 的渲染分支是：

- `worker-sandbox-permission`

并从：

- `workerSandboxPermissions.queue[0]`

取出：

- `requestId`
- `workerName`
- `host`

再渲染：

- `SandboxPermissionRequest`

### 也就是说：同款组件，不同队列，不同主权

leader 侧这里复用的是：

- host approval shell

但它并没有把 ask 变成：

- leader 自己本地发起的 network prompt

只要这一层没拆开，后续分析就会继续把 `same component` 误写成 `same ask ownership`。

## 第五层：leader 的 allow/deny 不是在 leader 本地闭环，而是回发 worker

leader 侧在 `worker-sandbox-permission` 分支里做的事情是：

- `sendSandboxPermissionResponseViaMailbox(workerName, requestId, host, allow, teamName)`

然后才：

- 可选地把 allow 持久化成本地 `domain:` 规则
- 从 `workerSandboxPermissions.queue` 弹出该项

这说明 leader 在这里真正做的是：

- host approval interaction
- mailbox response return
- optional local config side-effect

不是：

- 直接在 leader 本地 resolve 那个原 worker promise

## 第六层：worker 侧 callback 才是真正 resolve 原 promise 的地方

### `processSandboxPermissionResponse(...)` 只做一件事：调用 worker 侧注册的 resolve

`useSwarmPermissionPoller.ts` 维护了：

- `pendingSandboxCallbacks`

当 mailbox response 回来时：

- `useInboxPoller` 调 `processSandboxPermissionResponse({ requestId, host, allow })`
- 它查 registry
- 删除 callback
- `callback.resolve(allow)`

### 所以 worker continuation 是 `resolveShouldAllowHost(...)`，不在 leader

worker 在最初发 ask 时传进去的就是：

- `resolveShouldAllowHost`

leader 无法直接触碰这条 continuation，它只能：

- 通过 mailbox 把 allow/deny 回发回来

这点和上一页的 tool permission mailbox ask 很对称，但对象已从：

- `ToolUseConfirm` continuation

切换成：

- sandbox host promise continuation

## 第七层：这条线和 77 页哪里相同，哪里不同

### 相同点：worker 起点、leader 可见队列、worker 回流

两页共同的骨架都是：

- ask 起点在 worker
- leader 得到可交互壳
- 结果回到 worker callback

### 不同点：这一页不是 `ToolUseConfirm` rewrap，而是 host approval queue rewrap

77 页讲的是：

- leader 把 worker ask 重包进 `ToolUseConfirmQueue`

本页讲的是：

- leader 把 worker sandbox ask 排进 `workerSandboxPermissions.queue`

因此更准确的对照是：

- 77 = tool approval shell over mailbox
- 78 = host approval queue over mailbox

### 不同点二：leader 这里还可能顺手修改本地 host 规则

在 worker-sandbox 分支里，leader 允许时还能：

- `applyPermissionUpdate(...)`
- `persistPermissionUpdate(...)`
- `SandboxManager.refreshConfig()`

这说明这一页必须单独写，因为它多出一个：

- local config side-effect

而不只是“回发 worker”。

## 第八层：这会带来哪些高频误判

### 误判一：worker 的 sandbox ask 就是 leader 本地的 `sandboxPermissionRequestQueue` 条目

错在漏掉：

- 它实际进入的是 `workerSandboxPermissions.queue`

### 误判二：worker 自己也先弹了本地 network prompt

错在漏掉：

- 上报成功后，worker 只有 `pendingSandboxRequest`

### 误判三：leader 决定后，原 promise 就在 leader 侧解决了

错在漏掉：

- 真正 `resolveShouldAllowHost(...)` 在 worker callback

### 误判四：这条线和 77 页完全一样，只是对象从 tool 换成 host

错在漏掉：

- 这里用的是 `workerSandboxPermissions.queue`
- 还有本地 host 规则持久化副作用

### 误判五：leader 的允许操作一定只影响 worker，不影响 leader 本地环境

错在漏掉：

- `persistToSettings && allow` 时会修改 leader 本地 `domain:` 规则并 refresh sandbox config

### 误判六：mailbox 发送总会成功，所以 worker 不会本地 fallback

错在漏掉：

- mailbox 失败时，worker 会回退到本地 `sandboxPermissionRequestQueue`

## 第九层：稳定、条件与内部边界

### 稳定可见

- worker sandbox ask 上报成功后，worker 自己只显示 `pendingSandboxRequest`。
- leader 会把 mailbox sandbox ask 排进 `workerSandboxPermissions.queue` 并显示同款 host approval UI。
- 结果会经 mailbox 回流 worker callback，worker 才 resolve 原 promise。

### 条件公开

- 只有 swarms enabled 且当前是 swarm worker 时才走这条线。
- mailbox 发送失败时会回退到 worker 本地 sandbox prompt。
- leader 是否把 allow 持久化为本地 host 规则，取决于 `persistToSettings` 和 `allow`。
- 只有 leader 侧收到合法的 sandbox mailbox message，才会进入 `workerSandboxPermissions.queue`。

### 内部 / 实现层

- `sandbox_permission_request` / `sandbox_permission_response` 的消息 JSON 形状。
- callback registry 的 module-level 组织方式。
- desktop notification 与 queue append 的时机。
- workerColor、createdAt、selectedIndex 这些渲染/调度辅助字段。

## 第十层：最稳的记忆法

先记三句：

- `worker-originated sandbox ask`
- `leader-visible host approval queue`
- `worker-owned sandbox callback`

再补一句：

- `same SandboxPermissionRequest skin` 不等于 `same leader-local network prompt`

只要这四句没有一起记住，后续分析就会继续把：

- worker sandbox mailbox ask

误写成：

- leader 自己的本地 network prompt

## 源码锚点

- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/hooks/useInboxPoller.ts`
- `claude-code-source-code/src/hooks/useSwarmPermissionPoller.ts`
- `claude-code-source-code/src/utils/swarm/permissionSync.ts`
- `claude-code-source-code/src/utils/teammateMailbox.ts`
- `claude-code-source-code/src/state/AppStateStore.ts`
