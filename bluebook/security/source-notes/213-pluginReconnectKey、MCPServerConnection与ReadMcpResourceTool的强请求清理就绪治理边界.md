# pluginReconnectKey、MCPServerConnection与ReadMcpResourceTool的强请求清理就绪治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `362` 时，
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
| reactivation-triggered pending | `src/services/mcp/useManageMCPConnections.ts:140-153,765-853` | 为什么 `/reload-plugins` 之后不是直接 ready，而是重新进入 pending lifecycle |
| explicit enable still pending | `src/services/mcp/useManageMCPConnections.ts:1109-1123` | 为什么 even explicit enabling 也只是重新进入 readiness 流程 |
| user-facing readiness grammar | `src/hooks/notifs/useMcpConnectivityStatus.tsx:25-80`; `src/commands/plugin/ManagePlugins.tsx:513-519`; `src/cli/handlers/mcp.tsx:26-35` | 为什么 UI / CLI 继续把 `needs-auth / failed / pending / connected` 分开 |
| tool consumption hard gate | `src/tools/ReadMcpResourceTool/ReadMcpResourceTool.ts:78-95` | 为什么 downstream tool 只接受 ready truth，而不是 mere reactivation |
| runtime revocation | `src/services/tools/toolExecution.ts:1599-1628` | 为什么一个已连接对象仍可能在运行时失去 readiness |

## 4. `MCPServerConnection` 先证明：repo 公开承认 active world 里可以合法存在 non-ready object

`types.ts:179-226`
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

`useManageMCPConnections.ts:140-153`
明确把 `_pluginReconnectKey` 挂进 hook 依赖里，
而
`useManageMCPConnections.ts:765-853`
的 effect 注释又直接写出：

`Re-runs on session change (/clear) and on /reload-plugins (pluginReconnectKey).`

更关键的是 re-run 后系统做的不是：

`mark all ready`

而是：

1. 清除 stale plugin clients，防止旧配置与 ghost tools 继续污染当前世界
2. 对新 client 按 disabled / pending 初始化
3. 让连接流程重新开始

这里最硬的点在于：

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

`useManageMCPConnections.ts:1109-1123`
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

`useMcpConnectivityStatus.tsx:25-80`
在 user-facing notification 上只盯两种状态：

1. `failed`
2. `needs-auth`

这不是细枝末节。
它说明系统继续追问的是：

`现在能不能用`

而不是：

`它是不是已经在 current world 里`

`ManagePlugins.tsx:513-519`
又把 status 显式枚举为：

`connected / disabled / pending / needs-auth / failed`

而
`mcp.tsx:26-35`
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

`ReadMcpResourceTool.ts:78-95`
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

`toolExecution.ts:1599-1628`
直接给出一个更强反例。

这里在 `McpAuthError` 时，
会把一个原本是 `connected` 的 client 更新成：

`type: 'needs-auth'`

而且只在原状态确实是 `connected` 时才改。

这等于说明：

1. readiness 不是永久席位
2. runtime evidence 可以撤销 readiness
3. consumer 已能使用过一次，也不等于当前仍然可继续使用

这是一条非常重要的哲学边界：

`ready once`

不等于

`ready now`

更不等于

`ready until proven otherwise by silence`

Claude Code 的先进性就在于，
它要求新的运行时证据重新改写 readiness verdict，
而不是拿旧 verdict 继续遮蔽新风险。

## 10. 这篇源码剖面给主线带来的五条技术启示

1. repo 已经在 typed union 上明确展示：active-world object 仍可能是 formally non-ready object。
2. repo 已经在 `pending` 初始化上明确展示：reactivation 之后仍要经过 readiness 过渡层。
3. repo 已经在 health / auth surface grammar 上明确展示：ready/not-ready 需要继续显化，而不是被 activation 成功掩盖。
4. repo 已经在 `ReadMcpResourceTool` 上明确展示：consumer gate 只能接受 readiness truth。
5. repo 已经在 `toolExecution.ts` 上明确展示：readiness 可以被新的运行时证据持续撤销。

## 11. 苏格拉底式自反诘问：我是不是又把“对象已经接回当前世界”误认成了“这个当前世界现在真的可以继续信它”

如果对这组代码做更严格的自我审查，
至少要追问六句：

1. 如果 reactivation grammar 已经足够强，为什么还要再拆 readiness？
   因为 truth 已进入 current world，不等于 downstream consumer 现在可以继续用它。
2. 如果 client 已经 visible，是不是就说明它 ready？
   不是。visible、pending、needs-auth、failed 与 connected 被显式拆开。
3. 如果用户已经执行了 `/reload-plugins`，是不是就说明所有下游能力都已经可用？
   也不对。reload summary 不是 capability proof。
4. 如果对象曾经 connected 过一次，是不是就说明现在仍然可以信它？
   不能这样推。`toolExecution.ts` 直接证明 readiness 会被运行时撤销。
5. 如果 explicit enable 都不自动等于 ready，是不是系统太保守？
   恰恰相反。它是在拒绝把 operator intent 偷写成 capability proof。
6. 如果 cleanup 线现在还没有显式 readiness 代码，是不是说明这层还不值得写？
   恰恰相反。越是缺这层明确 grammar，越容易把“已接回当前世界”偷写成“现在已经可继续消费”。`

这一串反问最终逼出一句更稳的判断：

`readiness 的关键，不在对象会不会回到 current world，而在系统能不能正式决定这个 current world 此刻到底敢不敢继续信它。`

## 12. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 未来只要补出 reactivation governance，就已经足够成熟。`

而是：

`Claude Code 在 typed readiness state machine、pending lifecycle、surface-level health grammar、tool hard gate 与 runtime revocation 上已经明确展示了 readiness governance 的存在；因此 artifact-family cleanup stronger-request cleanup-reactivation-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-readiness-governor signer。`

再压成一句：

`cleanup 线真正缺的不是“谁来把对象接回 current world”，而是“谁来决定这个 current world 现在到底敢不敢继续用它”。`
