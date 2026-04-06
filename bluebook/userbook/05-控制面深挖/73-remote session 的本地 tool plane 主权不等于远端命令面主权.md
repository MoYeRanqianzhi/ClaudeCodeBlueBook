# `toolPermissionContext`、`initialMsg.mode`、`message.permissionMode`、`applyPermissionUpdate` 与 `computeTools`：为什么 remote session 的本地 tool plane 主权不等于远端命令面主权

## 用户目标

不是只知道 remote session 里：

- 本地 tool plane 还在重算
- `mcp.tools` 还能继续渗进来
- `toolPermissionContext` 会影响 built-in tools

而是继续追问：

- 到底是谁在主导这张本地工具面？
- 远端 `slash_commands` 会不会顺手决定本地工具池？
- `toolPermissionContext` 是一次性启动参数，还是会在会话中持续改写？
- 这些改写来自远端初始化、历史恢复，还是本地权限弹层与持久化规则更新？

如果这些问题不先拆开，读者最容易把 remote session 的本地工具面写成两种都不对的话：

- “远端决定本地工具池。”
- “本地工具池只是启动时的一次性默认值。”

源码都不支持。

## 第一性原理

remote session 的本地 tool plane 更像：

- `local authority shell`
- with `remote-derived inputs`

也就是：

1. 工具池的装配权在本地 REPL。
2. 装配时使用的 `toolPermissionContext` 会被多种来源持续改写。
3. 远端能提供输入，但并不直接持有本地工具池这张表的主权。

更稳的提问不是：

- “remote session 当前有哪些 tools？”

而是：

- “当前本地工具池是谁装出来的；`toolPermissionContext` 是怎样被恢复、改写、再喂回 `computeTools()` 的；如果不先拆开，会把主权误写到远端，还是误写成启动时死值？”

只要这三层不先拆开，正文就会把 remote session 的工具面写扁。

这里也先卡住边界：

- 这页讲的是 remote session 下本地 tool plane 的主权来源。
- 不重复 72 页对 tool plane 仍然存活的总论。
- 不展开完整 tool approval 生命周期。
- 不展开 direct connect / bridge 模式，只聚焦当前 remote session REPL。

## 第一层：工具池装配器明确在本地，不在远端

### `computeTools()` 直接从本地 store 取 `toolPermissionContext` 和 `mcp.tools`

`REPL.tsx` 的 `computeTools()` 明确做了：

- `const state = store.getState()`
- `assembleToolPool(state.toolPermissionContext, state.mcp.tools)`
- `mergeAndFilterTools(combinedInitialTools, assembled, state.toolPermissionContext.mode)`

这说明真正装配本地工具池的人不是远端，而是：

- 当前这个本地 REPL 进程

### 远端影响的是输入，不是最终装配权

远端当然会通过消息、事件和审批请求影响本地状态，但这些影响最后仍要经过：

- 本地 `setAppState(...)`
- 本地 `toolPermissionContext`
- 本地 `computeTools()`

才能变成当前工具池。

因此更准确的说法不是：

- “远端直接下发工具池”

而是：

- “远端提供可影响本地工具池的输入，而本地 REPL 仍保留装配权”

## 第二层：第一次关键输入来自 `initialMsg.mode` 和 `allowedPrompts`

### `REPL.tsx` 在处理初始消息时，会把 mode/rules 原子写进 `toolPermissionContext`

`REPL.tsx` 在初始化消息路径里明确做了：

- `applyPermissionUpdates(prev.toolPermissionContext, buildPermissionUpdates(initialMsg.mode, initialMsg.allowedPrompts))`

如果是 `auto`，还会进一步：

- `stripDangerousPermissionsForAutoMode(...)`

最后把结果写回：

- `toolPermissionContext: updatedToolPermissionContext`

### 这说明启动后的本地工具面不是只继承 CLI 启动默认值

它至少还会继续吃一层：

- 当前 remote session 恢复/初始化时带回来的 mode
- `allowedPrompts` 规则

因此更准确的理解是：

- 初始工具面主权在本地
- 但它会先吃一层 remote-derived permission context restore

只要这一层没拆开，正文就会把本地工具池误写成纯本地默认值。

## 第三层：第二次关键输入来自历史消息回放里的 `message.permissionMode`

### rewind / restore 路径会从消息里恢复 `toolPermissionContext.mode`

`REPL.tsx` 在恢复状态时，会检查：

- `message.permissionMode`

如果它和当前模式不同，就写回：

- `toolPermissionContext.mode = message.permissionMode`

### 这说明本地工具面的 mode 不是只跟“当前控制台按钮”走

它还跟：

- 你恢复到了哪条历史消息
- 该消息记录的 `permissionMode`

有关。

也就是说，本地工具面主权并不是单一“当前 UI 按钮状态”，而是会被：

- transcript restore

回写。

只要这一层没拆开，读者就会把工具面 mode 误写成只由当前显式切换动作决定。

## 第四层：第三次关键输入来自本地权限弹层与持久化规则更新

### 本地 sandbox / worker-sandbox 允许持久化时，会直接 `applyPermissionUpdate(...)`

`REPL.tsx` 在本地网络权限弹层确认时，如果用户选择持久化，就会构造：

- `addRules`

更新，然后：

- `toolPermissionContext: applyPermissionUpdate(prev.toolPermissionContext, update)`
- `persistPermissionUpdate(update)`

worker sandbox 那条路径也做同样的事。

### 这说明 remote session 的本地工具面仍然会被本地用户行为继续改写

它不是单纯接受远端恢复值；它还会继续被：

- 本地 REPL 里的用户批准动作
- 本地 settings 持久化规则

塑形。

因此更准确的结论是：

- remote session 的本地工具面不是“纯远端主权”
- 也不是“纯启动主权”
- 而是“本地持续治理 + 远端输入参与”

只要这一层没拆开，正文就会低估本地权限治理对工具面的持续主导。

## 第五层：`setToolPermissionContext(...)` 进一步证明这是本地治理对象

### `setToolPermissionContext(...)` 不只是替换 state，还会触发 queued item recheck

`REPL.tsx` 里的 `setToolPermissionContext(...)` 做两件事：

- 更新 `toolPermissionContext`
- 然后遍历 `toolUseConfirmQueue`，让已排队条目 `recheckPermission()`

这说明 `toolPermissionContext` 在本地并不是一个静态字段，而是：

- 当前本地审批系统的治理对象

### `preserveMode` 也说明本地会主动处理 mode 泄漏问题

同一段代码还专门处理：

- `preserveMode`

防止 worker / coordinator 模式值错误泄回主线程状态。

这再次说明本地 REPL 不是被动接收远端 permission state，而是在：

- 本地维护 mode 的正确所有权边界

只要这一层没拆开，正文就会把 `toolPermissionContext` 误写成远端投影，而不是本地治理状态。

## 第六层：所以 `toolPermissionContext` 才是 remote session 本地 tool plane 的真正主轴，不是 `slash_commands`

把前几层合起来，更准确的结构是：

### 远端 `slash_commands`

主要回答：

- 本地命令 discoverability / command-plane 暴露面

### 本地 `toolPermissionContext`

主要回答：

- 当前 built-in tool 能不能存在
- deny rules 怎样裁 MCP tools
- 当前 mode 怎样改变 tool pool

也就是说，两者服务的是不同本地主轴：

- `slash_commands` -> command plane
- `toolPermissionContext` -> tool plane

如果把这两条线混写，就会错误地把工具面主权交给远端命令面。

## 第七层：这会带来哪些真实使用误判

### 误判一：远端发布什么命令，本地就据此决定工具池

错在把：

- command plane discoverability

误当成：

- tool plane authority

### 误判二：工具池只是启动时 `initialTools` 的残留

错在漏掉：

- `computeTools()` 会继续读 fresh store state
- `toolPermissionContext` 还会被继续改写

### 误判三：本地权限弹层只影响单次批准，不影响工具面结构

错在漏掉：

- `applyPermissionUpdate(...)`
- `persistPermissionUpdate(...)`
- queued item recheck

### 误判四：恢复旧消息只会影响 transcript，不会影响工具面 mode

错在漏掉：

- `message.permissionMode`

也会回写 `toolPermissionContext.mode`

## 第八层：稳定、条件与内部边界

### 稳定可见

- remote session 的本地 tool plane 装配权在本地 REPL。
- `toolPermissionContext` 是这张本地工具面的主轴。
- 这个 context 会被初始化恢复、历史恢复和本地持久化更新持续改写。

### 条件公开

- 具体 `initialMsg.mode` / `allowedPrompts` 是否存在，依赖当前 session 恢复内容。
- `message.permissionMode` 是否出现，依赖回放到的消息。
- 本地用户是否选择持久化规则，会影响后续工具面裁剪。

### 内部 / 实现层

- `buildPermissionUpdates(...)` 的细节。
- `stripDangerousPermissionsForAutoMode(...)` 的内部规则。
- 各个 MCP tool 最终如何被 deny rules 命中。

## 第九层：最稳的记忆法

把 remote session 的本地 tool plane 记成一句话：

- `local tool plane, remote-fed context`

再补一句：

- `slash_commands` 管命令面，`toolPermissionContext` 管工具面

只要这两句没一起记住，后续分析就会继续把：

- 本地工具面

误写成远端命令面的附庸。

## 源码锚点

- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/hooks/useMergedTools.ts`
- `claude-code-source-code/src/tools.ts`
- `claude-code-source-code/src/utils/toolPool.ts`
- `claude-code-source-code/src/utils/permissions/PermissionUpdate.ts`
