# handleRemoteAuthFailure、reconnectMcpServerImpl与performMCPOAuthFlow的强请求清理恢复治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `301` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 线未来谁来维持旧的可用性线，`

而是：

`stronger-request cleanup 线一旦 continuity 已经断裂，谁来决定什么新的凭据、什么新的连接结果、什么新的工具世界，才配正式宣布旧 truth 已经恢复。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`continuity governor 不等于 recovery governor。`

这句话还不够硬。
所以这里单开一篇，
只盯住：

- `src/services/mcp/client.ts`
- `src/services/mcp/auth.ts`
- `src/cli/print.ts`
- `src/tools/McpAuthTool/McpAuthTool.ts`
- `src/components/mcp/MCPReconnect.tsx`

把 `needs-auth` demotion、auth cache、fresh reconnect、OAuth callback、background reconnect 与 tool swap 并排，
直接钉死 stronger-request cleanup 线当前仍缺的不是 temporal continuity，
而是 `fresh-proof recovery governance grammar`。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 continuity，没有 recovery。`

而是：

`Claude Code 已经在 MCP 线上明确把“旧线还要不要继续”和“什么新的证据足以宣布恢复成立”拆成两层；stronger-request cleanup 线当前缺的不是这种文化，而是这套 recovery governance 还没被正式接到旧 cleanup artifact family 上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| auth-failure demotion | `src/services/mcp/client.ts:337-360,1105-1137,2288-2345` | 为什么 continuity 断裂后会正式转入 `needs-auth` / auth-tool grammar |
| fresh reconnect verdict | `src/services/mcp/client.ts:2137-2194` | 为什么 recovery 需要 fresh cache / credential invalidation 和新的 `connected` result |
| new credential evidence | `src/services/mcp/auth.ts:579-616,847-1055,1568-1795` | 为什么恢复可以 silent 或 interactive，但都必须拿到新的 auth proof |
| control-plane recovery choreography | `src/cli/print.ts:3133-3475` | 为什么 retry / auth / callback / success 被拆成不同 control facts |
| consumer-side recovery discipline | `src/tools/McpAuthTool/McpAuthTool.ts:39-195`; `src/components/mcp/MCPReconnect.tsx:15-63` | 为什么 consumer 只在真正 recovered 后才拿回 real tools 或 success message |

## 4. `handleRemoteAuthFailure()` 先证明：continuity 一旦断裂，repo 会显式切到 recovery plane

`src/services/mcp/client.ts:337-360`
很值钱。

这里 `handleRemoteAuthFailure()` 的制度非常清楚：

1. 记录 `tengu_mcp_server_needs_auth`
2. 写入 `setMcpAuthCacheEntry(name)`
3. 返回 `type: 'needs-auth'`

它做的不是继续装作：

`旧线自己还能慢慢好`

而是明确宣布：

`旧线的 self-healing 已经不够了，现在需要新证据。`

`src/services/mcp/client.ts:1105-1137`
把这个判断落到真正 transport 上。

SSE、HTTP 与 `claudeai-proxy`
一旦遇到 `UnauthorizedError` 或 401，
就直接调用这条 demotion path。

`src/services/mcp/client.ts:2288-2345`
则更进一步把 demotion 写成 current-time grammar：

1. 如果近期已被判成 `needs-auth`，就跳过 connect
2. 如果 discovery 已有而 token 仍缺，也跳过 connect
3. 当前只返回 `needs-auth` + `createMcpAuthTool(name, config)`

这条证据很硬。

它说明 repo 不允许 continuity 的残影继续冒充 recovered truth。
一旦旧线跌进 auth gap，
系统就显式把问题改写成：

`请带来新的恢复证据。`

## 5. `reconnectMcpServerImpl()` 再证明：恢复 verdict 不是“又试了一次”，而是“新证据重新闭环了”

`src/services/mcp/client.ts:2137-2194`
是这一层最强的恢复锚点。

这里在 reconnect 前，
先做的不是立刻连接，
而是：

1. `clearKeychainCache()`
2. `clearServerCache(name, config)`

随后才重新：

`connectToServer(name, config)`

如果 reconnect 结果不是 `connected`，
函数就直接返回空的：

1. `tools`
2. `commands`

只有在真的 `connected` 之后，
才重新抓：

1. `fetchToolsForClient(client)`
2. `fetchCommandsForClient(client)`
3. `fetchResourcesForClient(client)`

这说明 recovery governance 的制度不是：

`系统还愿意再试，所以恢复已经成立`

而是：

`先清旧 credential/cache truth -> 再拿新 connect result -> 再重建 current tool/resource world`

这一步把 recovery 从“努力”升级成了“新闭环”。

## 6. `performMCPOAuthFlow()` 证明：恢复可以 silent，也可以 interactive，但都必须拿到新的 proof

`src/services/mcp/auth.ts:847-1055`
的 `performMCPOAuthFlow()`
非常硬。

它在标准 OAuth 路径上明确要求：

1. 先读 cached step-up scope / resource metadata URL
2. 先清旧的本地 token
3. 获取或复用 auth metadata
4. 生成新的 redirect / callback listener
5. 生成新的 OAuth state
6. 收到新的 authorization code
7. 完成新的 token exchange

`src/services/mcp/auth.ts:579-616`
又说明即便是在 revoke / re-auth 场景里，
repo 也只是保留 step-up scope 与 discovery state，
不会把旧 token 直接当成恢复成立的充分证据。

`src/services/mcp/auth.ts:1568-1795`
则把 XAA 恢复路径拆成两类：

1. `id_token` 在缓存里时，可尝试 silent exchange
2. `id_token` 不在缓存里时，明确记录需要 interactive re-auth，
   并回落到 `needs-auth`

这条证据非常值钱。

它说明 recovery 的本体不是：

`必须人工重新登录`

也不是：

`系统自己再试一下就会好`

而是：

`无论 silent 还是 interactive，都必须出现新的 credential proof`

## 7. `print.ts` 证明：control plane 明确把 retry、auth、callback 与 recovered 分成不同 verdict

`src/cli/print.ts:3133-3295`
的 `mcp_reconnect` 与 `mcp_toggle`
很值钱。

这里只在 `result.client.type === 'connected'` 时才：

1. 更新 `appState`
2. 重新注册 handlers
3. 返回 control success

否则就明确返回 error，
即便系统确实已经跑过 reconnect 流程。

这说明 control plane 的制度不是：

`尝试过恢复，就可以说恢复成功`

`src/cli/print.ts:3310-3475`
的 `mcp_authenticate` 与 `mcp_oauth_callback_url`
则更强。

这里先返回的只是：

1. `authUrl`
2. `requiresUserAction`

随后 background promise 才继续：

1. 等待 `oauthPromise`
2. 再运行 `reconnectMcpServerImpl()`
3. 再把 client / tools / commands / resources 写回 `appState`

manual callback path 又显式要求：

1. 先校验 callback URL
2. 先只等待 auth promise 完成
3. reconnect 交给后续 `mcp_reconnect`

这说明 repo 公开承认：

`auth callback accepted`

并不自动等于：

`service recovered`

从设计角度看，
这是一种很强的 control-plane honesty grammar：

1. auth-start 只签 auth-start
2. auth-done 只签 auth-done
3. reconnect-success 才签 reconnect-success
4. 不允许上游较弱事件偷签下游较强事实

## 8. `McpAuthTool` 与 `MCPReconnect` 再证明：consumer surface 也拒绝偷签 recovery truth

`src/tools/McpAuthTool/McpAuthTool.ts:39-195`
把自己的定位写得非常清楚：

1. 它只是 pseudo-tool
2. 真实工具要等 OAuth flow 完成后回来
3. 返回 auth URL 不等于返回真实工具世界

它在 background continuation 里走的也是：

1. `performMCPOAuthFlow()`
2. `clearMcpAuthCache()`
3. `reconnectMcpServerImpl(serverName, config)`
4. 再把 real tools / commands / resources swap 回 `appState`

这说明 auth tool 的制度不是：

`URL 发出去了，所以恢复成立了`

而是：

`auth proof 完成并且 reconnect 也闭环后，真实工具世界才回来`

`src/components/mcp/MCPReconnect.tsx:15-63`
则给出同样的 consumer discipline：

1. `connected` 才给
   `Successfully reconnected`
2. `needs-auth` 继续要求
   `Use /mcp to authenticate`
3. `pending / failed / disabled`
   都不偷写成 success

这条证据很硬。
它说明 consumer 世界同样拒绝把“恢复尝试中”越级冒充成“恢复完成”。

## 9. 更深一层的技术先进性：Claude Code 连“继续努力”与“重新值得相信”都继续拆开

这组源码给出的技术启示至少有四条：

1. 安全系统不能把 retry 和 recovery 混成同一条词法
2. fresh cache invalidation 是恢复签字前的必要卫生动作
3. control-plane 成功回执必须和 consumer world restoration 分层
4. proof collection、reconnect verdict 与 tool-world restoration 必须串成可审计链，而不是隐式魔法

用苏格拉底式反问压缩，
可以得到四个自检问题：

1. 如果没有 fresh proof，系统凭什么说自己不是只在重复旧失败？
2. 如果 callback arrival 已经等于恢复成功，那 reconnect verdict 还存在做什么？
3. 如果真实工具世界还没回来，consumer 又凭什么按 recovered truth 行动？
4. 如果 silent / interactive 路径都可能成立，系统又凭什么不把“恢复”定义在新的证据上，而定义在恢复方式上？

## 10. 安全设计的哲学本质：真正被治理的不是“系统有没有继续努力”，而是“什么新证据足以重新值得相信”

如果把这章压到最深处，
Claude Code 在这里展示的并不是普通的 OAuth 与 reconnect 技巧，
而是一种更硬的安全哲学：

`recovery is not persistence of effort; recovery is re-authorization of trust.`

这套哲学至少包含四个原则：

1. `fresh proof over continued motion`
2. `cache invalidation over stale confidence`
3. `phase honesty over single success slogan`
4. `consumer restoration over control-plane optimism`

所以这一层的哲学本质不是：

`系统还愿不愿意继续试`

而是：

`系统凭什么现在又值得重新被信任。`

## 11. 苏格拉底式自我反思：如果要把这层分析做得更严，最该防什么偷换

第一问：

`我是不是把旧 continuity line 仍在运行，误判成了 recovered truth 已成立？`

如果是，
`handleRemoteAuthFailure()` 和 `needs-auth` demotion 已经直接反驳我。

第二问：

`我是不是把一次 reconnect attempt 误判成了恢复 verdict？`

如果是，
`reconnectMcpServerImpl()` 只接受 fresh `connected` 结果并重建 tools/world 的做法已经直接反驳我。

第三问：

`我是不是把 auth URL、callback 或 silent exchange 这些中间事件误判成了最终恢复？`

如果是，
`print.ts` 把 auth-start、callback 与 reconnect-success 拆层的控制面语法已经直接反驳我。

第四问：

`我是不是只看 control-plane success，而忽略了 consumer 世界是否拿回真实工具？`

如果是，
`McpAuthTool` 与 `MCPReconnect` 的 consumer discipline 已经直接反驳我。

第五问：

`我是不是又在 recovery 层偷偷带入了 reintegration 的 stronger judgment？`

如果是，
我就需要立刻收手。
因为这一章最硬的纪律就是：

`只证明“什么 fresh proof 足以重新签 recovery verdict”，不越级证明 recovered truth 何时已经重新并入所有 current-world 读者与状态面。`
