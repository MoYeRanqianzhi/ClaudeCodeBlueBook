# `can_use_tool`、`ToolUseConfirm`、`createToolStub`、`recheckPermission` 与 `manager.respondToPermissionRequest`：为什么 remote session 的远端工具审批会借用本地权限队列 UI，却不会直接接管本地 tool plane

## 用户目标

不是只知道 remote session 里：

- 远端会发 `can_use_tool`
- 本地会弹出 `PermissionRequest`
- 用户点允许 / 拒绝后远端继续

而是继续追问这个更细的边界：

- 远端 `can_use_tool` 进入本地之后，到底是“本地权限系统接管了这次审批”，还是“本地只借了一个现成 UI 队列外壳”？
- 本地 `toolUseConfirmQueue` 和本地 `toolPermissionContext` 是不是同一层主权？
- 为什么 `setToolPermissionContext()` 会触发队列重检，但 remote session 塞进来的 queue item 却可以完全不重检？

如果这些问题不先拆开，读者最容易把 remote session 的工具审批写成一句过平的话：

- “远端的工具审批走进了本地权限队列，所以本地权限系统就接管了这次工具审批。”

源码并不是这样工作的。

## 第一性原理

remote session 的 `can_use_tool` 更准确地说是：

- `remote authority`
- over a `local approval shell`

也就是：

1. 远端请求借用本地 `toolUseConfirmQueue` 和 `PermissionRequest` UI 来显示与收集用户答案。
2. 但这条 queue item 并不自动进入本地那套真正的权限治理链。
3. 最终决策仍通过 `manager.respondToPermissionRequest(...)` 回到远端容器。

更稳的提问不是：

- “remote session 有没有本地权限弹层？”

而是：

- “本地队列 UI 和本地权限主权是不是同一个对象；如果把二者压成一层，会把主权误写给本地，还是忽略远端容器真正的决策回路？”

只要这三层不先拆开，正文就会把 remote queue UI 写成 remote tool plane 主权本地化。

这里也先卡住边界：

- 这页讲的是 remote session 的 `can_use_tool` 请求如何借用本地 queue/UI。
- 不重复 73 页对本地 tool plane 主权来源的总论。
- 不重复 remote-control bridge / direct connect 的 `can_use_tool` 专题。
- 不展开完整 hook classifier / auto-approval 体系，只聚焦 queue 与 authority 的错位。

## 第一层：remote session 的 `can_use_tool` 确实会被包装成本地 `ToolUseConfirm`

### `useRemoteSession.onPermissionRequest(...)` 直接构造 `ToolUseConfirm`

`useRemoteSession.ts` 在 `onPermissionRequest` 里：

- 先按 `request.tool_name` 查找本地工具对象
- 找不到就 `createToolStub(request.tool_name)`
- 用 `createSyntheticAssistantMessage(request, requestId)` 造一条本地 assistant 形状消息
- 再构造一份 `ToolUseConfirm`

最后直接：

- `setToolUseConfirmQueue(queue => [...queue, toolUseConfirm])`

这说明 remote `can_use_tool` 在本地确实会获得：

- 一个标准的 queue item
- 一个标准的本地审批 UI 外观

### 但“有 queue item”不等于“进入本地权限治理链”

这只是说明：

- 本地 UI 容器被复用

还没能说明：

- 本地权限主权也被复用

只要这一层没拆开，读者就会把 queue item 的存在本身误写成主权转移。

## 第二层：这个 remote `ToolUseConfirm` 连 `tool` 和 `assistantMessage` 都可以是本地合成外壳

### 找不到工具对象时会 `createToolStub(...)`

`useRemoteSession.ts` 明确写了：

- `findToolByName(...) ?? createToolStub(request.tool_name)`

这说明 remote queue item 甚至不要求：

- 本地工具池里真的已有一个完整 tool 对象

### assistant message 也是 `createSyntheticAssistantMessage(...)`

同时它也不是等待一条真实流式 assistant message 自然出现，而是主动造：

- synthetic assistant message

来给本地 UI 和 transcript 外观提供载体。

这两点合起来说明：

- remote `can_use_tool` 借的是本地 UI 协议壳
- 不是本地真实工具生命周期对象

只要这一层没拆开，读者就会把 queue item 误当成“本地工具系统已经真正认领了这次调用”。

## 第三层：remote queue item 的 `onAllow / onReject / onAbort` 只是把答案发回远端

### 三个出口都调用 `manager.respondToPermissionRequest(...)`

`useRemoteSession.ts` 里的 remote `ToolUseConfirm`：

- `onAllow(...)` -> `manager.respondToPermissionRequest(requestId, response)`
- `onReject(...)` -> `manager.respondToPermissionRequest(requestId, response)`
- `onAbort(...)` -> `manager.respondToPermissionRequest(requestId, response)`

然后再：

- 从本地 queue 里删掉这项

### 这说明本地 UI 负责收集答案，远端负责继续执行

更准确的说法不是：

- “本地 queue 决定了是否允许工具运行”

而是：

- “本地 queue 收到用户答案后，负责把它送回远端，让远端继续自己的权限与执行链”

只要这一层没拆开，正文就会把本地 UI 的交互终点误写成决策终点。

## 第四层：`onUserInteraction()` 与 `recheckPermission()` 的 no-op 一起暴露了壳层边界

### `onUserInteraction()` 也是 no-op，说明交互壳不等于本地治理壳

remote `ToolUseConfirm` 里还有一个很容易漏掉的细节：

- `onUserInteraction() { /* No-op for remote — classifier runs on the container */ }`

这意味着即使用户已经在本地界面上看到审批卡片并开始交互，本地也没有因此接管：

- classifier 前置链
- 交互后的本地治理补动作

更准确的说法是：

- 本地负责承载交互壳
- classifier / permission state 仍留在 container 一侧

### `recheckPermission()` 的 no-op 则说明 queue 进入本地，不等于重判主权进入本地

remote `ToolUseConfirm.recheckPermission()` 也明确是 no-op

`useRemoteSession.ts` 在 remote queue item 里直接写了：

- `recheckPermission() { /* No-op for remote — permission state is on the container */ }`

这句注释几乎把主权边界写明了：

- permission state is on the container

### 而本地 `setToolPermissionContext(...)` 恰恰会要求 queue item 重检

`REPL.tsx` 的 `setToolPermissionContext(...)` 在更新 context 后，会遍历当前 queue：

- `item.recheckPermission()`

这在本地权限治理链里是关键动作，因为一条新规则可能让排队中的请求立刻变成可自动批准或可直接拒绝。

因此一对比就很清楚：

- remote queue item 的 `onUserInteraction()` 没有把 classifier / 治理前置链搬到本地
- 本地 queue item：`recheckPermission()` 有治理意义
- remote queue item：`recheckPermission()` 故意无意义

这就是本页最关键的错位证据。

只要这一层没拆开，读者就会把“都在同一个 queue 里”误判成“都受同一个权限治理循环支配”。

## 第五层：真正的本地权限治理链在 `useCanUseTool(...)`，不是在 remote queue 壳里

### `useCanUseTool(...)` 会创建真正的 `PermissionContext`

本地路径里，`useCanUseTool.tsx` 会：

- `createPermissionContext(...)`
- `createPermissionQueueOps(setToolUseConfirmQueue)`
- `hasPermissionsToUseTool(...)`
- 然后把 ask/allow/deny 决策送进 `handleCoordinatorPermission` / `handleSwarmWorkerPermission` / `handleInteractivePermission`

这说明本地路径里的 queue，不只是 UI 容器，而是：

- 权限决策上下文的一部分

### `PermissionContext` 的 queue ops 也是真正可更新、可移除、可重检的治理接口

`PermissionContext.ts` 里 `createPermissionQueueOps(...)` 提供：

- `push`
- `remove`
- `update`

这条路径才和：

- `setToolPermissionContext`
- `recheckPermission`
- `hasPermissionsToUseTool`

形成闭环。

因此更准确的结论是：

- remote session 借用了 queue 形状
- 本地 `useCanUseTool(...)` 才拥有完整的权限治理闭环

## 第六层：所以 remote `can_use_tool` 更像“UI 承载复用”，不是“权限引擎复用”

把前几层合起来，更准确的结构是：

### remote path 借用的东西

- `toolUseConfirmQueue`
- `PermissionRequest` 视觉组件
- `ToolUseConfirm` 数据形状
- synthetic message / tool stub 这些 UI 适配器

### remote path 没有借走的东西

- 本地 `hasPermissionsToUseTool(...)` 决策链
- 本地 `PermissionContext` 治理闭环
- 本地 `recheckPermission()` 的再裁剪意义
- 本地 `toolPermissionContext` 对当前 remote ask 的自动再判定权

因此更准确的总结不是：

- “远端审批走进了本地权限系统”

而是：

- “远端审批走进了本地权限队列 UI，但主权没有一起迁过来”

## 第七层：这会带来哪些真实使用误判

### 误判一：只要进入了 `toolUseConfirmQueue`，就说明本地权限逻辑已经接管

错在漏掉：

- remote queue item 的 `recheckPermission()` 是 no-op

### 误判二：本地修改 `toolPermissionContext` 后，排队中的 remote ask 会自动重判

错在漏掉：

- remote queue item 根本不参与本地权限重判闭环

### 误判三：只要用户在本地开始交互，就说明本地 classifier / 治理前置逻辑也开始接管

错在漏掉：

- `onUserInteraction()` 对 remote queue item 是 no-op
- 注释已经明确 classifier runs on the container

### 误判四：queue 里显示的是本地真实工具对象和真实 assistant message

错在漏掉：

- `createToolStub(...)`
- `createSyntheticAssistantMessage(...)`

### 误判五：允许 / 拒绝按钮的点击已经在本地完成最终决策

错在漏掉：

- 最终只是把响应发回 `manager.respondToPermissionRequest(...)`

## 第八层：稳定、条件与内部边界

### 稳定可见

- remote `can_use_tool` 会借用本地 `toolUseConfirmQueue` 和 `PermissionRequest` UI。
- remote queue item 的 `onUserInteraction()` 是 no-op，classifier 仍在 container 侧。
- remote queue item 的 `recheckPermission()` 是 no-op。
- 最终响应通过 `manager.respondToPermissionRequest(...)` 返回远端。

### 条件公开

- 具体 `tool_name` 能否映射到本地真实工具对象，取决于本地工具池；映射不到时会退化为 stub。
- 是否出现本地批准 / 拒绝 / 中止动作，取决于用户交互。
- 这页不替远端容器内部批准逻辑做承诺。

### 内部 / 实现层

- synthetic message 的具体结构。
- `PermissionRequest` 组件内部渲染细节。
- `hasPermissionsToUseTool(...)` 的完整决策树。

## 第九层：最稳的记忆法

把 remote `can_use_tool` 记成一句话：

- `remote authority, local approval shell`

再补一句：

- `queue reuse` 不等于 `governance reuse`

只要这两句没有一起记住，后续分析就会继续把：

- 本地 queue UI

误写成：

- 本地权限主权

## 源码锚点

- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/hooks/useCanUseTool.tsx`
- `claude-code-source-code/src/hooks/toolPermission/PermissionContext.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
