# handleRemoteAuthFailure、reconnectMcpServerImpl与performMCPOAuthFlow的强请求清理恢复治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `333` 时，
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
| control-plane recovery choreography | `src/cli/print.ts:3133-3505` | 为什么 retry / auth / callback / success 被拆成不同 control facts |
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

`先清旧 credential / cache truth -> 再拿新 connect result -> 再重建 current tool / resource world`

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

`src/cli/print.ts:3310-3505`
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

1. 等待 auth flow
2. 跑 reconnect
3. 只有 reconnect 成功才把结果交回

`src/components/mcp/MCPReconnect.tsx:15-63`
也是同样制度：

1. `pending` / `needs-auth` / `failed` 都不是 success
2. 只有 `connected` 才显示成功分支

这说明 consumer-facing plane 也拒绝偷签 recovery truth。

也就是说，
不仅核心状态机不允许把“正在恢复”偷写成“已恢复”，
连面向用户与下游 consumer 的表面也一样不允许。

## 9. 更深一层的技术先进性：Claude Code 把“恢复成立”绑定到 fresh proof，而不是绑定到 good intention

这组源码给出的技术启示至少有四条：

1. continuity 断裂后，系统必须明确切换到 fresh-proof world
2. cache invalidation 是 recovery proof 的一部分，不是实现细节
3. auth / callback / reconnect / tool return 必须分成不同 verdict，不能偷签
4. consumer surface 也必须遵守 recovered-truth discipline，而不只是底层状态机遵守

用苏格拉底式反问压缩，
可以得到四个自检问题：

1. 如果没有 fresh credential proof，系统凭什么说自己理解“恢复”？
2. 如果没有 cache invalidation，新的 reconnect result 凭什么不被旧世界污染？
3. 如果 auth callback 一到就算 recovered，系统到底还把 reconnect 视作什么？
4. 如果 pseudo-tool 不肯等到真实 reconnect 完成，consumer surface 凭什么不偷签恢复？

## 10. 这篇源码剖面给主线带来的五条技术启示

### 启示一

repo 已经在 `needs-auth` demotion 上明确展示：

`continuity broken`

之后必须显式切到

`fresh-proof recovery plane`

### 启示二

repo 已经在 `reconnectMcpServerImpl()` 上明确展示：

`fresh reconnect verdict`

必须建立在 fresh cache / credential invalidation 之上。

### 启示三

repo 已经在 `performMCPOAuthFlow()` 上明确展示：

`恢复`

可以 silent，也可以 interactive，
但都不能没有新的 auth evidence。

### 启示四

repo 已经在 control plane 上明确展示：

`auth-start`

和

`recovered`

必须是不同 verdict。

### 启示五

repo 已经在 `McpAuthTool` 与 `MCPReconnect` 上明确展示：

`consumer-side discipline`

也必须服从 recovered-truth gate。

## 11. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 只要补出 continuity governance，就已经足够成熟。`

而是：

`Claude Code 在 needs-auth demotion、fresh reconnect verdict、new credential proof、control-plane recovery choreography 与 consumer-side recovery discipline 上已经明确展示了 recovery governance 的存在；因此 artifact-family cleanup stronger-request cleanup-continuity-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-recovery-governor signer。`

再压成一句：

`cleanup 线真正缺的不是“谁来决定旧线还要不要继续”，而是“谁来决定什么新证据足以正式宣布它已经恢复”。`
