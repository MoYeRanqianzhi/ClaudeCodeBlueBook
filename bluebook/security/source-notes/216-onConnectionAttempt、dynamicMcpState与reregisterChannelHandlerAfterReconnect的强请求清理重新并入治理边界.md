# onConnectionAttempt、dynamicMcpState与reregisterChannelHandlerAfterReconnect的强请求清理重新并入治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `365` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 线未来谁来决定对象是否已经恢复，`

而是：

`stronger-request cleanup 线一旦已经拿到 recovered truth，谁来决定这份真相何时真正重新进入当前 tool / status / event world。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`recovery governor 不等于 reintegration governor。`

这句话还不够硬。
所以这里单开一篇，
只盯住：

- `src/services/mcp/client.ts`
- `src/services/mcp/useManageMCPConnections.ts`
- `src/cli/print.ts`
- `src/tools/McpAuthTool/McpAuthTool.ts`

把 raw reconnect result、`appState` / `dynamicMcpState` 回填、tool / status read model、elicitation handler 与 channel handler rebind 并排，
直接钉死 stronger-request cleanup 线当前仍缺的不是 recovery proof，
而是 `current-world reintegration governance grammar`。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 recovery，没有 reintegration。`

而是：

`Claude Code 已经在 MCP 线上明确把“恢复是否成立”和“恢复后的真相何时重新成为当前世界的一部分”拆成两层；stronger-request cleanup 线当前缺的不是文化，而是这套 reintegration governance 还没被正式接到旧 cleanup artifact family 上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| raw recovery result | `src/services/mcp/client.ts:2137-2198` | 为什么 reconnect 成功本身还不等于 current-world membership |
| standard reintegration path | `src/services/mcp/useManageMCPConnections.ts:296-332,1048-1122` | 为什么 connection result 还要经过 state update 与 handler attach |
| control-plane reintegration | `src/cli/print.ts:3133-3445` | 为什么 print mode 里 recovery 之后还要单独写回 state 与重绑 handlers |
| next-turn tool visibility | `src/cli/print.ts:1472-1485` | 为什么 recovered tools 只有写进 `dynamicMcpState` 才能真正回到下一轮工具池 |
| current status visibility | `src/cli/print.ts:1612-1626` | 为什么 recovered clients 只有写进 current state 才能回到 status plane |
| event / channel re-entry | `src/cli/print.ts:1263-1285,4786-4835` | 为什么 live interaction surface 的回归还需要单独 rebind |
| pseudo-tool replacement | `src/tools/McpAuthTool/McpAuthTool.ts:124-165` | 为什么 auth / reconnect 成功之后还要把 placeholder 工具替换成 real tools |

## 4. `reconnectMcpServerImpl()` 先证明：recovery result 是原材料，不是完成态

`src/services/mcp/client.ts:2137-2198`
很值钱。

这里 `reconnectMcpServerImpl()`
负责做的是：

1. fresh reconnect
2. fresh fetch tools / commands / resources
3. 返回 raw result object

它不负责：

1. 写回 `appState`
2. 更新 `dynamicMcpState`
3. 重绑 elicitation handler
4. 重绑 channel handler

这条证据非常硬。

它说明 repo 自己已经拒绝把：

`recovery proof exists`

偷写成：

`reintegration complete`

也就是说，
raw recovery result 只是 reintegration 的输入材料，
不是 completed current-world verdict。

## 5. `onConnectionAttempt()` 再证明：standard path 上，reintegration 至少拆成“state projection + event re-entry”两步

`src/services/mcp/useManageMCPConnections.ts:296-332`
很值钱。

`onConnectionAttempt()`
在拿到 result 后，
先做：

`updateServer({ ...client, tools, commands, resources })`

然后只在 `client.type === 'connected'` 时：

`registerElicitationHandler(client.client, client.name, setAppState)`

这说明即便在标准 TUI path，
repo 也明确承认：

1. result 要先投影进 current state
2. 事件交互面还要单独重新接回

所以 reintegration 不是 recovery 的同义词，
而是 recovery 之后的一整段 projection choreography。

`src/services/mcp/useManageMCPConnections.ts:1048-1122`
又继续把这层主权写给 operator path：

1. `reconnectMcpServer()` 先拿 raw `result`
2. 再交给 `onConnectionAttempt(result)` 做 reintegration
3. `toggleMcpServer()` enable path 也先标 `pending`
4. 然后 reconnect
5. 最后仍回到 `onConnectionAttempt(result)`

这说明连 hooks 世界内部也拒绝把：

`reconnect 成功`

偷写成：

`当前世界已经自动重新接回它`

## 6. `print.ts` 证明：control plane 上，reintegration 至少拆成 state plane、tool plane 与 event plane 三层

`src/cli/print.ts:3133-3204`
的 `mcp_reconnect`
很硬。

这里在 `reconnectMcpServerImpl()` 后，
系统继续做了四件事：

1. 写回 `appState.mcp.clients`
2. 写回 `appState.mcp.tools / commands / resources`
3. 更新 `dynamicMcpState`
4. 只有 `connected` 时才 `registerElicitationHandlers()` 与 `reregisterChannelHandlerAfterReconnect()`

`src/cli/print.ts:3206-3295`
的 `mcp_toggle`
也是同样制度。

`src/cli/print.ts:3310-3445`
的 auth-complete background path 更值钱：

1. recovery result 已经存在
2. 仍然要单独 `setAppState`
3. 仍然要单独更新 `dynamicMcpState`

这说明 print / headless 世界里，
至少存在三层不同 reintegration 问题：

1. state plane
2. tool / status visibility plane
3. event / channel plane

任何一层没接回，
都不该被偷写成：

`当前世界已经重新接回对象`

## 7. `dynamicMcpState`、`buildAllTools()` 与 `buildMcpServerStatuses()` 证明：reintegration 决定下一轮 consumer 到底看见什么

`src/cli/print.ts:1472-1485`
很值钱。

这里 `buildAllTools()`
会把：

`dynamicMcpState.tools`

并入下一轮真实工具池。

`src/cli/print.ts:1612-1626`
又说明 `buildMcpServerStatuses()`
会把：

`dynamicMcpState.clients`

并入当前 status response。

这意味着：

`recovered object`

如果还没被 reintegrate 进 `dynamicMcpState`，
那么：

1. next turn tool pool 不一定看见它
2. status plane 不一定看见它

这条证据很关键。
它说明 reintegration 不是附属 UI 操作，
而是当前 consumer world
是否真的收到恢复结果的 authoritative gate。

## 8. `registerElicitationHandlers()` 与 `reregisterChannelHandlerAfterReconnect()` 再证明：live interaction plane 也有单独的 re-entry grammar

`src/cli/print.ts:1263-1285`
的 `registerElicitationHandlers()`
很硬。

它只对：

1. `connected`
2. 未注册
3. 非 SDK

client 才重新接回 request handler。

`src/cli/print.ts:4786-4835`
的 `reregisterChannelHandlerAfterReconnect()`
也同样严格：

1. 非 `connected` 直接返回
2. 未通过 gate 直接返回
3. 通过后才重新挂回 channel notification handler

这说明 event plane / channel plane 的 re-entry，
并不是 raw recovery result 自动携带的。
它是单独的 reintegration authority。

如果 stronger-request cleanup 线未来没有这类 live interaction reintegration grammar，
那它就仍然回答不了：

`恢复后的旧对象现在有没有重新回到那些真正会在当前世界里发生活动的面。`

## 9. `McpAuthTool` 给出最强 tool-plane 正例：恢复完成后还要把 placeholder world 换回 real world

`src/tools/McpAuthTool/McpAuthTool.ts:124-165`
特别值钱。

这里在 auth promise resolve 之后，
系统还要继续：

1. `clearMcpAuthCache()`
2. `reconnectMcpServerImpl()`
3. 把旧 pseudo-tool 按 prefix 清掉
4. 把 real tools / commands / resources swap 回 `appState`

这说明 repo 对 tool plane 的理解不是：

`auth 成功了，所以恢复完成了，所以真实工具自然就在了`

而是：

`恢复成立后，real tool world 仍要被单独 reintegrate 回来`

这条证据把 reintegration
从“state bookkeeping”提升成了真正的
model-visible world re-entry。

## 10. 更深一层的技术先进性：Claude Code 连“恢复是否成立”和“恢复后的真相何时再次成为当前世界的一部分”都继续拆开

这组源码给出的技术启示至少有五条：

1. raw result 不应自动变成 reader-visible truth
2. state plane、tool plane、status plane 与 event plane 的 re-entry 需要分层治理
3. dynamic mutable state 是 next-turn world visibility 的正式 gate，不是杂项缓存
4. placeholder -> real world swap 本身是恢复后的一次单独主权动作
5. control success grammar 必须绑定 reintegration choreography，而不能只绑定 reconnect effort

用苏格拉底式反问压缩，
可以得到五个自检问题：

1. 如果 reconnect 成功就等于 reintegrated，为什么 repo 还要额外写回 `appState` 和 `dynamicMcpState`？
2. 如果 state writeback 已经足够，为什么 handler 还要单独重绑？
3. 如果恢复结果天然对下一轮可见，为什么工具池和状态池都只从 reintegrated state 读？
4. 如果 auth 结束就自动等于真实工具回归，为什么 `McpAuthTool` 还要显式做 prefix replacement？
5. 如果 control plane 只是报告 reconnect effort，为什么 repo 还要把 success 绑定到实际的 writeback 与 rebind choreography？

## 11. 苏格拉底式自反诘问：我是不是又把“对象已经 recovered”误认成了“它已经重新属于当前世界”

如果对这组代码做更严格的自我审查，
至少要追问六句：

1. 如果 recovery grammar 已经足够强，为什么还要再拆 reintegration？
   因为恢复是否成立，不等于恢复后的真相怎样重新进入当前世界。
2. 如果 reconnect 已经回到 `connected`，是不是就说明下一轮 consumer 已经看见它？
   不是。next-turn visibility 还取决于 `dynamicMcpState` 与 `appState` 的 writeback。
3. 如果状态已经写回了，是不是就说明 event plane 也回来了？
   不是。handler rebind 仍是单独步骤。
4. 如果 auth flow 结束并返回了成功，是不是就说明 pseudo-tool 已经退出世界？
   不是。placeholder -> real tools 的 swap 仍需单独执行。
5. 如果 control plane 已经返回 success，是不是就能自动推出所有消费面已完全一致？
   不能。success grammar 必须重新检查它到底绑定了哪些 reintegration choreography。
6. 如果 cleanup 线现在还没有显式 reintegration 代码，是不是说明这层还不值得写？
   恰恰相反。越是缺这层明确 grammar，越容易把“它已经回来”偷写成“它已经重新属于当前世界”。`

这一串反问最终逼出一句更稳的判断：

`reintegration 的关键，不在对象是不是已经 recovered，而在系统能不能正式决定这份 recovered truth 何时重新成为 current world 的一部分。`

## 12. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 只要补出 recovery governance，就已经足够成熟。`

而是：

`Claude Code 在 raw reconnect result、state writeback、dynamic tool-state writeback、tool/status read model re-entry、event/channel handler rebind 与 pseudo-tool replacement 上已经明确展示了 reintegration governance 的存在；因此 artifact-family cleanup stronger-request cleanup-recovery-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-reintegration-governor signer。`

再压成一句：

`cleanup 线真正缺的不是“它已经回来”，而是“它什么时候重新属于当前世界”。`
