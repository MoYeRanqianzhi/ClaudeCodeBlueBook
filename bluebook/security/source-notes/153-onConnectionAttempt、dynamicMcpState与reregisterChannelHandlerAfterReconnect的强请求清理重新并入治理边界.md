# onConnectionAttempt、dynamicMcpState与reregisterChannelHandlerAfterReconnect的强请求清理重新并入治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `302` 时，
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
| raw recovery result | `src/services/mcp/client.ts:2137-2194` | 为什么 reconnect 成功本身还不等于 current-world membership |
| standard reintegration path | `src/services/mcp/useManageMCPConnections.ts:293-332` | 为什么 connection result 还要经过 state update 与 handler attach |
| control-plane reintegration | `src/cli/print.ts:3133-3204,3255-3445` | 为什么 print mode 里 recovery 之后还要单独写回 state 与重绑 handlers |
| next-turn tool visibility | `src/cli/print.ts:1474-1490` | 为什么 recovered tools 只有写进 `dynamicMcpState` 才能真正回到下一轮工具池 |
| current status visibility | `src/cli/print.ts:1612-1626` | 为什么 recovered clients 只有写进 current state 才能回到 status plane |
| event / channel re-entry | `src/cli/print.ts:1263-1285,4786-4835` | 为什么 live interaction surface 的回归还需要单独 rebind |
| pseudo-tool replacement | `src/tools/McpAuthTool/McpAuthTool.ts:134-168` | 为什么 auth / reconnect 成功之后还要把 placeholder 工具替换成 real tools |

## 4. `reconnectMcpServerImpl()` 先证明：recovery result 是原材料，不是完成态

`src/services/mcp/client.ts:2137-2194`
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

`src/services/mcp/useManageMCPConnections.ts:293-332`
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

`src/cli/print.ts:3255-3295`
的 `mcp_toggle`
也是同样制度。

`src/cli/print.ts:3391-3445`
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

`src/cli/print.ts:1474-1490`
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

`src/tools/McpAuthTool/McpAuthTool.ts:134-168`
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

这组源码给出的技术启示至少有四条：

1. raw recovery result 应被视作原材料，而不是 current-world truth
2. state writeback、dynamic tool-state writeback 与 handler rebind 必须分层
3. consumer read model 应只读取 reintegrated truth，而不是后台成功回执
4. placeholder 工具世界与真实工具世界的替换，本身就是一层独立治理动作

用苏格拉底式反问压缩，
可以得到四个自检问题：

1. 如果 reconnect 返回值已经等于 reintegration complete，为什么 repo 还要显式写回 `appState` 与 `dynamicMcpState`？
2. 如果 appState 已更新就等于所有 plane 都已回归，为什么还要单独重绑 elicitation 和 channel handlers？
3. 如果 consumer 会自动看见 raw result，为什么 `buildAllTools()` 与 `buildMcpServerStatuses()` 只从 reintegrated state 读？
4. 如果 pseudo-tool 自然会消失，为什么 `McpAuthTool` 还要显式按 prefix 清理再换回 real tools？

## 11. 安全设计的哲学本质：真正被治理的不是“它是否已经恢复”，而是“恢复后的真相何时再次被允许成为当前世界的一部分”

如果把这章压到最深处，
Claude Code 在这里展示的并不是普通的状态写回技巧，
而是一种更硬的安全哲学：

`recovery re-establishes truth; reintegration re-authorizes membership.`

这套哲学至少包含四个原则：

1. `raw result is not world membership`
2. `state writeback is not event re-entry`
3. `tool visibility is not handler visibility`
4. `consumer world reads reintegrated truth, not background success`

所以这一层的哲学本质不是：

`它是不是已经好了`

而是：

`好了以后，制度什么时候才愿意再次把它算进当前世界。`

## 12. 苏格拉底式自我反思：如果要把这层分析做得更严，最该防什么偷换

第一问：

`我是不是把 reconnect 返回值误判成了 current-world membership？`

如果是，
`reconnectMcpServerImpl()` 只返回 raw result 的事实已经直接反驳我。

第二问：

`我是不是把 appState 写回误判成了所有 plane 都已回归？`

如果是，
`registerElicitationHandlers()` 与 `reregisterChannelHandlerAfterReconnect()` 已经直接反驳我。

第三问：

`我是不是把 dynamic tool pool 更新误判成了 live handler plane 也已回来？`

如果是，
tool plane 与 event plane 的分层证据已经直接反驳我。

第四问：

`我是不是把 control-plane success 误判成了 consumer 世界已经全部看见它？`

如果是，
`buildAllTools()` / `buildMcpServerStatuses()` 只从 reintegrated state 读世界的事实已经直接反驳我。

第五问：

`我是不是又在 reintegration 层偷偷带入了 reprojection 的 stronger judgment？`

如果是，
我就需要立刻收手。
因为这一章最硬的纪律就是：

`只证明“恢复后的真相何时重新并入当前世界”，不越级证明“这份真相随后如何被不同 reader surface 重新讲述”。`
