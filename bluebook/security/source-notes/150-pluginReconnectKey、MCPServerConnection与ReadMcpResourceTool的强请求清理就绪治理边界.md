# pluginReconnectKey、MCPServerConnection与ReadMcpResourceTool的强请求清理就绪治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `299` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 旧对象的 current truth 何时接入当前世界，`

而是：

`stronger-request cleanup 旧对象即便已经接入当前世界，谁来决定这个当前世界现在到底能不能被继续使用。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`reactivation governor 不等于 readiness governor。`

这句话还不够硬。
所以这里单开一篇，
只盯住：

- `src/services/mcp/types.ts`
- `src/services/mcp/useManageMCPConnections.ts`
- `src/hooks/notifs/useMcpConnectivityStatus.tsx`
- `src/commands/plugin/ManagePlugins.tsx`
- `src/cli/handlers/mcp.tsx`
- `src/tools/ReadMcpResourceTool/ReadMcpResourceTool.ts`
- `src/services/tools/toolExecution.ts`

把 `pluginReconnectKey` 触发后的 pending 初始化、显式 enable 仍回到 pending、`connected / needs-auth / failed` surface grammar、tool hard gate 与运行时降级并排，
直接钉死 stronger-request cleanup 线当前仍缺的不是 active-world takeover，
而是 `ready-for-use adjudication grammar`。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 reactivation，没有 readiness。`

而是：

`Claude Code 在 MCP 线上已经明确把“对象进入 current world”和“对象当前是否真的可用”拆成两层；stronger-request cleanup 线当前缺的不是这种文化，而是这套 readiness governance 还没被正式接到旧 cleanup artifact family 上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| readiness state machine | `src/services/mcp/types.ts:179-226` | 为什么 current-world object 仍可处于多种 not-ready 状态 |
| reactivation-triggered pending | `src/services/mcp/useManageMCPConnections.ts:149-153,765-853` | 为什么 `/reload-plugins` 之后不是直接 ready，而是重新进入 pending lifecycle |
| explicit enable still pending | `src/services/mcp/useManageMCPConnections.ts:1109-1123` | 为什么 even explicit enabling 也只是重新进入 readiness 流程 |
| user-facing readiness grammar | `src/hooks/notifs/useMcpConnectivityStatus.tsx:25-63`; `src/commands/plugin/ManagePlugins.tsx:513-519`; `src/cli/handlers/mcp.tsx:26-35` | 为什么 UI / CLI 继续把 `needs-auth / failed / pending / connected` 分开 |
| tool consumption hard gate | `src/tools/ReadMcpResourceTool/ReadMcpResourceTool.ts:86-95` | 为什么 downstream tool 只接受 ready truth，而不是 mere reactivation |
| runtime revocation | `src/services/tools/toolExecution.ts:1599-1628` | 为什么一个已连接对象仍可能在运行时失去 readiness |

## 4. `MCPServerConnection` 先证明：repo 公开承认 active world 里可以合法存在 non-ready object

`src/services/mcp/types.ts:179-226`
非常值钱。

这里没有把对象状态写成：

`present / absent`

而是明确拆成：

1. `connected`
2. `failed`
3. `needs-auth`
4. `pending`
5. `disabled`

一旦 union type 本身已经这么写，
系统就已经在类型层承认：

`object is in current world`

并不自动等于：

`object is ready`

从第一性原理看，
这是非常先进的安全设计。

它拒绝把“对象已经被当前世界看见”偷写成“对象已经被当前世界信任并可继续消费”。

## 5. `pluginReconnectKey` 与 `initializeServersAsPending()` 再证明：reactivation 之后仍要经过 readiness 过渡层

`src/services/mcp/useManageMCPConnections.ts:149-153`
明确把 `_pluginReconnectKey` 挂进 hook 依赖里，
而
`src/services/mcp/useManageMCPConnections.ts:765-853`
的 effect 注释又直接写出：

`Re-runs on session change (/clear) and on /reload-plugins (pluginReconnectKey).`

更关键的是 re-run 后系统做的不是：

`mark all ready`

而是：

1. 清除 stale plugin clients，
   防止旧配置与 ghost tools 继续污染当前世界
2. 对新 client 按 disabled / pending 初始化
3. 让连接流程重新开始

这里最硬的点在 `819-825`：

不是 disabled 的新 client 会被直接加成：

`type: 'pending'`

这说明 `pluginReconnectKey` 的制度含义不是：

`readiness granted`

而是：

`readiness must be re-adjudicated`

换句话说，
reactivation 只把对象带回 current lifecycle，
并没有替它把 readiness 一并签了。

## 6. `toggleMcpServer()` 再加一条强证据：显式 enable 也只是重新开启 readiness 流程

`src/services/mcp/useManageMCPConnections.ts:1109-1123`
再给出一个更直接的正例。

在 disabled -> enabled 的路径上，
系统做的不是：

`set connected`

而是：

1. 先 `setMcpServerEnabled(serverName, true)`
2. 再 `updateServer({ type: 'pending' })`
3. 然后才 `reconnectMcpServerImpl(...)`
4. 最后交给 `onConnectionAttempt(result)`

这说明 even explicit enable 也不自动等于 ready。

也就是说，
就算用户已经明确表达了：

`我要让它回来`

系统仍继续坚持：

`回来之后还要再证明你现在可用`

这正是 readiness governance 比 reactivation governance 更强的地方。

## 7. `useMcpConnectivityStatus()`、`getMcpStatus()` 与 `/mcp` health 一起证明：surface 层也拒绝把 active truth 冒充成 ready truth

`src/hooks/notifs/useMcpConnectivityStatus.tsx:25-63`
在 user-facing notification 上只盯两种状态：

1. `failed`
2. `needs-auth`

这不是细枝末节。
它说明系统继续追问的是：

`现在能不能用`

而不是：

`它是不是已经在 current world 里`

`src/commands/plugin/ManagePlugins.tsx:513-519`
又把 status 显式枚举为：

`connected / disabled / pending / needs-auth / failed`

而
`src/cli/handlers/mcp.tsx:26-35`
则把 health grammar 压成：

1. `✓ Connected`
2. `! Needs authentication`
3. `✗ Failed to connect`

当 notification、管理界面与 CLI health 都保留这组分层时，
repo 就已经在多个 consumer surface 上明确承认：

`reactivation`

之后仍然有一整层：

`readiness adjudication`

没有被偷掉。

## 8. `ReadMcpResourceTool` 给出最强消费侧正例：可用性消费面只接受 `connected`

`src/tools/ReadMcpResourceTool/ReadMcpResourceTool.ts:86-95`
很硬。

它找到 client 后，
先检查：

`if (client.type !== 'connected') throw ...`

再检查：

`if (!client.capabilities?.resources) throw ...`

这说明 tool consumer 的制度不是：

`只要对象已经在 active world 里，就可以继续消费`

而是：

`只有 readiness verdict 已经强到 connected + capability-present，我才消费它`

这条证据非常值钱。
因为它把 readiness 从 UI 提示提升成了真正的 downstream gate。

从 cleanup 研究角度看，
这意味着将来旧 path、旧 promise、旧 receipt 即便已经 reactivated，
也仍不自动说明：

`下游 reader 已经可以安全消费它。`

## 9. `toolExecution.ts` 再证明：readiness 不是静态标签，而是会被运行时证据持续撤销的主权

`src/services/tools/toolExecution.ts:1599-1628`
直接给出一个更强反例。

这里在 `McpAuthError` 时，
会把一个原本 `connected` 的 client 更新成：

`type: 'needs-auth'`

而且只在原状态确实是 `connected` 时才改。

这等于说明：

1. readiness 不是 once-connected forever-connected
2. runtime evidence 可以推翻旧 readiness verdict
3. consumer world 必须接受“刚才还是 ready，现在又不 ready 了”的制度现实

Claude Code 在这里的先进性非常高：

`它不把“历史上曾经连通过”当成永久通行证，而是允许当前证据随时撤销旧的 ready truth。`

## 10. 更深一层的技术先进性：Claude Code 连“对象已在场”与“对象值得继续信任”都继续拆开

如果把这组源码放在一起看，
Claude Code 在这层真正先进的地方至少有四点：

1. 它把 `pending / needs-auth / failed / connected` 做成 typed state machine
2. 它让 reactivation 之后先回到 `pending`，拒绝跳过 readiness adjudication
3. 它让 surface grammar 与 tool gate 一起维护 readiness honesty
4. 它让 runtime error 有权推翻旧 ready verdict

这说明 repo 的安全设计不是：

`尽量把对象放回 current world 就好`

而是：

`让每个 consumer 都只在足够强的 ready truth 上继续行动。`

## 11. 苏格拉底式自我反思：如果我要把这层边界看得更准，最该防什么

第一问：

`我是不是把 active-world fact 误判成了 ready-for-use fact？`

如果是，
`MCPServerConnection` 的 union type 已经直接反驳我。

第二问：

`我是不是把 pending 当成了“马上就好，所以可以忽略”？`

如果是，
`ReadMcpResourceTool` 的 `connected` hard gate 已经直接反驳我。

第三问：

`我是不是把用户触发过 reload 或 enable，就误判成 readiness 已签发？`

如果是，
`initializeServersAsPending()` 与 `toggleMcpServer()` 已经直接反驳我。

第四问：

`我是不是把一次曾经 connected 过，当成了现在仍然 ready？`

如果是，
`toolExecution.ts` 在 `McpAuthError` 时的 runtime downgrade 已经直接反驳我。

第五问：

`我是不是又在 readiness 层偷偷带入了 continuity 或 recovery 的 stronger judgment？`

如果是，
我就需要立刻收手。
因为这一层最硬的纪律就是：

`只证明“现在能不能被继续消费”，不越级证明“之后一定会持续可用或一定可被恢复”。`
