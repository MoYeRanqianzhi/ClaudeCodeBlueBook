# onConnectionAttempt、dynamicMcpState与reregisterChannelHandlerAfterReconnect的强请求清理重新并入治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `397` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 线未来谁来决定对象是否已经恢复，`

而是：

`stronger-request cleanup 线一旦已经拿到 recovered truth，谁来决定这份真相何时真正重新进入当前 tool/status/event world。`

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

把 raw reconnect result、`appState` / `dynamicMcpState` 回填、tool/status read model、elicitation handler 与 channel handler rebind 并排，
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
| control-plane reintegration | `src/cli/print.ts:3148-3204,3255-3288,3391-3441` | 为什么 print mode 里 recovery 之后还要单独写回 state 与重绑 handlers |
| next-turn tool visibility | `src/cli/print.ts:1471-1485` | 为什么 recovered tools 只有写进 `dynamicMcpState` 才能真正回到下一轮工具池 |
| current status visibility | `src/cli/print.ts:1610-1627` | 为什么 recovered clients 只有写进 current state 才能回到 status plane |
| event/channel re-entry | `src/cli/print.ts:1253-1280,4786-4835` | 为什么 live interaction surface 的回归还需要单独 rebind |
| pseudo-tool replacement | `src/tools/McpAuthTool/McpAuthTool.ts:134-165` | 为什么 auth/reconnect 成功之后还要把 placeholder 工具替换成 real tools |

## 4. `reconnectMcpServerImpl()` 先证明：recovery result 是原材料，不是完成态

`client.ts:2137-2194` 很值钱。

这里 `reconnectMcpServerImpl()` 负责做的是：

1. fresh reconnect
2. fresh fetch tools/commands/resources
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
raw recovery result 只是 reintegration 的输入材料，不是 completed current-world verdict。

## 5. `onConnectionAttempt()` 再证明：standard path 上，reintegration 至少拆成“state projection + event re-entry”两步

`useManageMCPConnections.ts:293-332` 很值钱。

`onConnectionAttempt()` 在拿到 result 后，
先做：

`updateServer({ ...client, tools, commands, resources })`

然后只在 `client.type === 'connected'` 时：

`registerElicitationHandler(client.client, client.name, setAppState)`

这说明 even on the standard TUI path，
repo 也明确承认：

1. result 要先投影进 current state
2. 事件交互面还要单独重新接回

所以 reintegration 不是 recovery 的同义词，
而是 recovery 之后的一整段 projection choreography。

## 6. `print.ts` 证明：control plane 上，reintegration 至少拆成 state plane、tool plane 与 event plane 三层

`print.ts:3148-3204` 的 `mcp_reconnect` 很硬。

这里在 `reconnectMcpServerImpl()` 后，
系统继续做了四件事：

1. 写回 `appState.mcp.clients`
2. 写回 `appState.mcp.tools/commands/resources`
3. 更新 `dynamicMcpState`
4. 只有 `connected` 时才 `registerElicitationHandlers()` 与 `reregisterChannelHandlerAfterReconnect()`

`3255-3288` 的 `mcp_toggle` 也是同样制度。

`3391-3441` 的 auth-complete background path 更值钱：

1. recovery result 已经存在
2. 仍然要单独 `setAppState`
3. 仍然要单独更新 `dynamicMcpState`

这说明 print/headless 世界里，
至少存在三层不同 reintegration 问题：

1. state plane
2. tool/status visibility plane
3. event/channel plane

任何一层没接回，
都不该被偷写成“当前世界已经重新接回对象”。

## 7. `dynamicMcpState`、`buildAllTools()` 与 `buildMcpServerStatuses()` 证明：reintegration 决定下一轮 consumer 到底看见什么

`print.ts:1471-1485` 很值钱。

这里 `buildAllTools()` 会把：

`dynamicMcpState.tools`

并入下一轮真实工具池。

`1610-1627` 又说明 `buildMcpServerStatuses()` 会把：

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
而是当前 consumer world 是否真的收到恢复结果的 authoritative gate。

## 8. `registerElicitationHandlers()`、`reregisterChannelHandlerAfterReconnect()` 与 `McpAuthTool` 再证明：live interaction plane 与 real tool world 都有单独的 re-entry grammar

`print.ts:1253-1280` 的 `registerElicitationHandlers()` 很硬。

它只对：

1. `connected`
2. 未注册
3. 非 SDK

client 才重新接回 request handler。

`4786-4835` 的 `reregisterChannelHandlerAfterReconnect()` 也同样严格：

1. 非 `connected` 直接返回
2. 未通过 gate 直接返回
3. 通过后才重新挂回 channel notification handler

而 `McpAuthTool.ts:134-165` 又把 tool plane 的 reintegration 写得很清楚：

1. `clearMcpAuthCache()`
2. `reconnectMcpServerImpl()`
3. 清掉旧 pseudo-tool
4. 把 real tools / commands / resources swap 回 `appState`

这说明 repo 对 reintegration 的理解不是：

`recovered proof exists -> current world naturally absorbs it`

而是：

`不同 consumer plane 要各自完成自己的 re-entry choreography`

这也是 Claude Code 多重安全术真正先进的地方：
它不把“恢复”偷写成单一事件，
而是把恢复后的 world re-entry 再拆成 state、tool、status、event 四个相互校验的面。

## 9. 苏格拉底式自反诘问：我是不是又把“恢复成立”误认成了“当前世界已经重新接回它”

如果对这组代码做更严格的自我审查，
至少要追问六句：

1. 如果 recovery governance 已经等于 reintegration governance，为什么 `reconnectMcpServerImpl()` 还只返回 raw result，而不直接改 current state？
   因为 repo 自己已经承认 recovered truth 还只是输入材料。
2. 如果 `connected` 已经足够，为什么 `onConnectionAttempt()` 仍要 `updateServer()` 再单独注册 handler？
   因为 standard path 上的 current-world projection 也是单独步骤。
3. 如果 `setAppState` 已经足够，为什么 print control path 还要更新 `dynamicMcpState`？
   因为 next-turn tool/status visibility 不由单一 snapshot 自动担保。
4. 如果 dynamic state 已经更新，为什么 live interaction plane 还要 `registerElicitationHandlers()` 与 `reregisterChannelHandlerAfterReconnect()`？
   因为 event plane 的回归仍有自己的 gate。
5. 如果 auth+reconnect 闭环已经说明 everything is back，为什么 `McpAuthTool` 还要手动清 placeholder、换回 real tools？
   因为 pseudo-world 与 real world 从来不是同一句 truth。
6. 如果 stronger-request cleanup 线还没正式长出 reintegration grammar，是不是说明这层只属于工程细节？
   恰恰相反。越是把它当细节，越容易让“恢复”偷签“当前世界正式接纳它”。

这一串反问最终逼出一句更稳的判断：

`reintegration 的关键，不在 recovered proof 有没有出现，而在系统能不能正式决定这份 proof 何时重新成为当前世界的一部分。`

## 10. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 线未来只要补出 recovery governance，就已经足够成熟。`

而是：

repo 在 `reconnectMcpServerImpl()` 的 raw recovery result、`useManageMCPConnections.ts` 的 state projection + handler attach、`print.ts` 对 `appState` / `dynamicMcpState` 的回填、`buildAllTools()` / `buildMcpServerStatuses()` 的 consumer read model、`reregisterChannelHandlerAfterReconnect()` 的 live interaction re-entry，以及 `McpAuthTool` 的 pseudo-tool -> real tools swap 上，已经明确展示了 reintegration governance 的存在；因此 `artifact-family cleanup stronger-request cleanup-recovery-governor signer` 仍不能越级冒充 `artifact-family cleanup stronger-request cleanup-reintegration-governor signer`。

因此：

`stronger-request cleanup 线真正缺的不是“它已经恢复了吗”，而是“它现在已经重新成为当前世界的一部分了吗”。`
