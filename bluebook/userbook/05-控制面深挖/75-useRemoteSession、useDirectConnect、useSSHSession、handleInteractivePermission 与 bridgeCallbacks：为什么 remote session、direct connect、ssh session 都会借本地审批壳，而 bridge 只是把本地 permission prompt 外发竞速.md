# `useRemoteSession`、`useDirectConnect`、`useSSHSession`、`handleInteractivePermission` 与 `bridgeCallbacks`：为什么 remote session、direct connect、ssh session 都会借本地审批壳，而 bridge 只是把本地 permission prompt 外发竞速

## 用户目标

不是只知道：

- remote session 会在本地弹出审批卡片
- direct connect / ssh session 也会在本地弹出审批卡片
- bridge 连上以后，远端用户也可能参与批准

而是继续追问更细的结构问题：

- 这些“看起来都像本地审批框”的路径，到底是不是同一种 permission topology？
- `ToolUseConfirm` 出现在本地 queue 里，究竟表示“远端 ask 被导入了本地审批壳”，还是“本地 ask 被导出给远端参与竞速”？
- 为什么 bridge 也会牵扯 `control_request` / `control_response`，却不能直接写成另一种 remote ask？

如果这些问题不先拆开，正文最容易把四条路径压扁成一句假话：

- “凡是会弹本地审批框的，最终都在走同一种本地权限系统。”

源码并不是这样工作的。

## 第一性原理

更稳的提问不是：

- “谁会弹 `PermissionRequest`？”

而是四个更底层的问题：

1. ask 是从远端导入，还是先在本地生成？
2. 本地复用的是审批壳，还是完整治理闭环？
3. 用户答案最终回流到哪里？
4. 本地 `recheckPermission()` 到底有没有真实治理意义？

只要这四轴不先拆开，后续就会把：

- imported remote ask

误写成：

- exported local ask

也会把：

- 本地审批壳

误写成：

- 本地审批主权

## 第一层：remote session、direct connect、ssh session 共享的是“导入远端 ask -> 本地审批壳”

### 三条 remote ask 线都会主动构造本地 `ToolUseConfirm`

`useRemoteSession.ts`、`useDirectConnect.ts` 和 `useSSHSession.ts` 在 `onPermissionRequest(...)` 里都做了同一类动作：

- 先按 `tool_name` 查找本地工具
- 找不到就 `createToolStub(...)`
- 再用 `createSyntheticAssistantMessage(...)` 造一条本地 assistant 形状消息
- 最后构造 `ToolUseConfirm` 并塞进 `toolUseConfirmQueue`

这说明三条线共享的首先不是：

- 本地权限主权

而是：

- 本地审批壳

### 所以“本地弹框”只是壳层共性，不是主权共性

更准确的说法是：

- remote session、direct connect、ssh session 都会把远端 `can_use_tool` 导入本地审批壳

而不是：

- 三条线都把本地 permission engine 当成最终权威

只要这一层没拆开，读者就会把共同的 UI 外观误写成共同的治理拓扑。

## 第二层：但 remote session 与 direct connect / ssh session 共享壳层，不共享同样厚度的 return contract

### remote session 有更厚的 pending request / cancel 治理面

`RemoteSessionManager.ts` 会：

- 把 `can_use_tool` 放进 `pendingPermissionRequests`
- 识别 `control_cancel_request`
- 通过 `onPermissionCancelled(...)` 通知本地移除相应 queue item
- 再由 `respondToPermissionRequest(...)` 发回 `control_response`

这说明 remote session 的 return path 不只是：

- 把 allow / deny 发回去

还包括：

- 本地可见的 pending request 管理
- 远端主动取消 ask 的回传链

### direct connect / ssh session 更像“薄 return path 的 imported ask”

`useDirectConnect.ts` 和 `useSSHSession.ts` 虽然同样会在本地造 `ToolUseConfirm`，但它们更像：

- thin imported ask family

原因是：

- `DirectConnectSessionManager` 只在收到 `control_request` 时把 `can_use_tool` 交给 hook
- 回答时只发一条 `control_response`
- `control_cancel_request` 没有像 `RemoteSessionManager` 那样在本地形成对等的 pending map + cancel callback 治理面

`useSSHSession.ts` 则进一步说明：

- SSH child process 这条线在审批壳上几乎贴着 direct connect 走
- 它的真正差异更多在 transport / reconnect / stderr shutdown 合同

因此更准确的结论不是：

- remote session = direct connect = ssh session

而是：

- 三者都属于 imported remote ask over local approval shell
- 但 remote session 的 return contract 更厚，direct connect / ssh 更薄

## 第三层：bridge 不是“又一条导入远端 ask 的线”，而是“本地 ask 向远端外发竞速”

### bridge 的 ask 先在本地生成，不是先从远端导入

bridge 这条线的真正起点不在 `useRemoteSession(...)` 或 `useDirectConnect(...)`，而在：

- `useCanUseTool(...)`
- `handleInteractivePermission(...)`

这里先发生的是：

- 本地 `createPermissionContext(...)`
- 本地 `hasPermissionsToUseTool(...)`
- 本地交互式 `ToolUseConfirm` 构造

也就是说，bridge 对应的 ask 首先是：

- locally originated ask

不是：

- remotely imported ask

### `bridgeCallbacks.sendRequest(...)` 只是把本地 ask 外发给远端参与竞速

`handleInteractivePermission.ts` 在有 `bridgeCallbacks` 时会：

- `sendRequest(...)` 把本地 ask 发给 bridge 远端
- `onResponse(...)` 等待远端答复
- 用 `claim()` 让本地用户、本地 hook/classifier、远端 bridge 响应互相竞速

这说明 bridge 的拓扑更准确地说是：

- local authority
- with remote prompt relay

而不是：

- remote authority over local shell

只要这一层没拆开，读者就会把 bridge 误写成“第四种 remote ask queue”。

## 第四层：`recheckPermission()` 的意义会直接暴露两种拓扑的方向相反

### imported remote ask：`recheckPermission()` 没有本地治理意义

remote session 页已经拆过：

- `onUserInteraction()` 对 remote ask 是 no-op
- `recheckPermission()` 对 remote ask 是 no-op

这代表：

- ask 虽然住进了本地 queue
- 但本地并没有获得对这条 ask 的治理主权

### exported local ask：`recheckPermission()` 真的能改写结果，并反向取消 bridge ask

`handleInteractivePermission.ts` 里，本地 ask 的 `recheckPermission()` 会：

- 重新执行 `hasPermissionsToUseTool(...)`
- 一旦本地规则变成 allow，就 `claim()`
- 再 `bridgeCallbacks.cancelRequest(...)`

这点极关键，因为它说明 bridge 下的 ask：

- 主权一直在本地
- 远端只是参与 prompt 竞速

更准确的对照是：

- imported remote ask：queue 在本地，治理不在本地
- exported local ask：queue 在本地，治理也在本地，远端只是 relay peer

## 第五层：这会带来哪些高频误判

### 误判一：只要本地弹出同一种 `PermissionRequest`，就说明背后是同一权限系统

错在漏掉：

- `ToolUseConfirm` 的壳层共性
- 不等于 ask origin 相同
- 更不等于 authority return path 相同

### 误判二：bridge 只是另一种 remote `can_use_tool`

错在漏掉：

- bridge ask 先在本地 `useCanUseTool(...)` 里生成
- 之后才通过 `bridgeCallbacks.sendRequest(...)` 外发

### 误判三：remote session、direct connect、ssh session 的审批合同完全等价

错在漏掉：

- remote session 有 `pendingPermissionRequests`
- 有 `control_cancel_request`
- 有本地 cancel callback 治理面

而 direct connect / ssh 更接近薄壳回发。

### 误判四：bridge 远端一旦回应，本地就只是被动接受

错在漏掉：

- `claim()` 竞速
- 本地 `recheckPermission()` 可先赢
- 本地还能反向 `cancelRequest(...)`

### 误判五：同样叫 `control_request` / `control_response`，拓扑方向就一定相同

错在漏掉：

- imported remote ask 和 exported local ask 在协议名上可以相似
- 但 ask 的生成点、治理点、回流点完全不同

## 第六层：稳定、条件与内部边界

### 稳定可见

- remote session、direct connect、ssh session 都会把远端 ask 导入本地审批壳。
- bridge 的 prompt 先在本地生成，再可选外发给远端参与竞速。
- 同一种本地审批 UI 不等于同一种 permission topology。

### 条件公开

- bridge relay 只有在 `bridgeCallbacks` 存在且已连通时才参与。
- remote session 会处理 `control_cancel_request`；direct connect / ssh 的可见 cancel 合同更薄。
- direct connect 与 ssh session 的差异主要落在 transport / reconnect / stderr shutdown，而不是审批壳形状本身。

### 内部 / 实现层

- `createSyntheticAssistantMessage(...)` 的具体结构。
- `createToolStub(...)` 的具体降级细节。
- `bridgeRequestId`、`claim()`、`pendingPermissionHandlers` 的实现组织方式。
- `ToolUseConfirm.toolUseContext` 的 stub 适配细节。

## 第七层：最稳的记忆法

先记两句：

- `imported remote ask -> local approval shell`
- `exported local ask -> remote bridge relay`

再补一句：

- `same modal shell` 不等于 `same authority topology`

只要这三句没有一起记住，后续分析就会继续把：

- 本地审批壳

误写成：

- 同一张权限主权图

## 源码锚点

- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/hooks/useSSHSession.ts`
- `claude-code-source-code/src/hooks/useCanUseTool.tsx`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/remote/remotePermissionBridge.ts`
