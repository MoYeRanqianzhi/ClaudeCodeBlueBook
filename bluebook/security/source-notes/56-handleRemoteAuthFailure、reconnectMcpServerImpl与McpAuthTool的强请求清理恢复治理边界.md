# handleRemoteAuthFailure、reconnectMcpServerImpl 与 McpAuthTool 的强请求清理恢复治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `205` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 线未来谁来维持旧的可用性线，`

而是：

`stronger-request cleanup 线一旦 continuity 已经断裂，谁来决定什么新的凭据、什么新的连接结果、什么新的工具世界，才配正式宣布旧 truth 已经恢复。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`continuity governor 不等于 recovery governor。`

这句话还不够硬。
所以这里单开一篇，只盯住：

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
| auth-failure demotion | `src/services/mcp/client.ts:1079-1137,2301-2334` | 为什么 continuity 断裂后会正式转入 `needs-auth` / auth-tool grammar |
| fresh reconnect verdict | `src/services/mcp/client.ts:2137-2163` | 为什么 recovery 需要 fresh cache/credential invalidation 和新的 `connected` result |
| new credential evidence | `src/services/mcp/auth.ts:578-616,930-1040,1581-1614,1755-1778` | 为什么恢复可以 silent 或 interactive，但都必须拿到新的 auth proof |
| control-plane recovery choreography | `src/cli/print.ts:3133-3204,3206-3295,3310-3455,3463-3505` | 为什么 retry/auth/callback/success 被拆成不同 control facts |
| consumer-side recovery discipline | `src/tools/McpAuthTool/McpAuthTool.ts:37-47,115-165`; `src/components/mcp/MCPReconnect.tsx:30-63` | 为什么 consumer 只在真正 recovered 后才拿回 real tools 或 success message |

## 4. `handleRemoteAuthFailure()` 先证明：continuity 一旦断裂，repo 会显式切到 recovery plane

`client.ts:1079-1137` 很值钱。

这里在 SSE、HTTP 和 `claudeai-proxy` transport 上，
如果连接过程碰到 `UnauthorizedError` 或 401，
系统做的不是：

`继续把它算成旧 continuity line 的普通波动`

而是直接走：

`handleRemoteAuthFailure()`

把结果改成：

`type: 'needs-auth'`

`client.ts:340-360` 又把这条路径收紧成三步：

1. 记录 `needs_auth` 事件
2. 写入 `setMcpAuthCacheEntry(name)`
3. 返回 `needs-auth`

更关键的是 `2301-2334`。

这里如果 server 近期已经被判成 needs-auth，
或者已经有 discovery state 但没有 token，
系统就会：

1. `Skipping connection (cached needs-auth)`
2. 直接给出 `needs-auth`
3. 只暴露 `createMcpAuthTool(name, config)`

这条证据很硬。
它说明 repo 不会让 continuity 的残影继续冒充 recovered truth。

一旦旧线已经掉进 auth gap，
系统会正式要求新的恢复证据。

## 5. `reconnectMcpServerImpl()` 再证明：恢复 verdict 不是“又试了一次”，而是“新证据重新闭环了”

`client.ts:2137-2163` 是这一层最强的恢复锚点。

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
3. `resources`

只有在真的 `connected` 之后，
才重新抓：

1. `fetchToolsForClient(client)`
2. `fetchCommandsForClient(client)`
3. `fetchResourcesForClient(client)`

这说明 recovery governance 的制度不是：

`系统还愿意再试，所以恢复已经成立`

而是：

`先清旧 credential/cache truth -> 再拿新 connect result -> 再重建 current tool/resource world -> 只有这样才配说 recovered`

## 6. `performMCPOAuthFlow()` 证明：恢复可以 silent，也可以 interactive，但都必须拿到新的 proof

`auth.ts:930-1040` 的 `performMCPOAuthFlow()` 很硬。

它明确要求：

1. 获取或复用 auth metadata
2. 生成新的 redirect / callback listener
3. 生成新的 OAuth state
4. 收到新的 authorization code
5. 完成新的 token exchange

`578-616` 又说明即便是在 re-auth，
repo 也只是保留 step-up scope 与 discovery state，
并不会把旧 token 直接当成恢复成立的充分证据。

`1581-1614` 与 `1755-1778` 更进一步把恢复路径拆成两类：

1. XAA cached `id_token` 存在时，可走 silent re-auth
2. `id_token` 不在缓存里时，就明确落回 `needs-auth`，要求 interactive re-auth

这条证据非常值钱。

它说明 recovery 的本体不是：

`一定要人工重新登录`

也不是：

`系统自己跑一会儿就会好`

而是：

`无论 silent 还是 interactive，都必须出现新的 credential proof`

## 7. `print.ts` 证明：control plane 明确把 retry、auth、callback 与 recovered 分成不同 verdict

`print.ts:3133-3204` 的 `mcp_reconnect` 很值钱。

这里只在 `result.client.type === 'connected'` 时才：

1. 重新注册 handlers
2. 发送 control success

否则就明确返回 error。

`3206-3295` 的 `mcp_toggle` 也是同样纪律：
enable 之后 reconnect 失败，不会被偷写成恢复成功。

`3310-3455` 的 `mcp_authenticate` 更强。

这里先返回的只是：

1. `authUrl`
2. `requiresUserAction`

随后才在 background 里：

1. 等待 `oauthPromise`
2. 再运行 `reconnectMcpServerImpl()`
3. 再把 client/tools/commands/resources 写回 `appState`

`3463-3505` 的 `mcp_oauth_callback_url` 则更明确：

1. 它等待 auth-only promise
2. manual callback path 的 reconnect 交给后续 `mcp_reconnect`

这说明 repo 公开承认：

`auth callback accepted`

并不自动等于：

`service recovered`

## 8. `McpAuthTool` 与 `MCPReconnect` 再证明：consumer surface 也拒绝偷签 recovery truth

`McpAuthTool.ts:37-47` 把自己的定位写得很清楚：

1. 它只是 pseudo-tool
2. 真实工具要等 OAuth flow 完成后回来

`115-165` 更硬：

1. 先启动 `performMCPOAuthFlow()`
2. 等 `oauthPromise` resolve
3. 再 `clearMcpAuthCache()`
4. 再 `reconnectMcpServerImpl(serverName, config)`
5. 再把 real tools / commands / resources swap 回 `appState`

这说明 auth tool 的制度不是：

`URL 发出去了，所以恢复成立了`

而是：

`auth proof 完成并且 reconnect 也闭环后，真实工具世界才回来`

`MCPReconnect.tsx:30-63` 也是同样的 consumer discipline：

1. `connected` 才显示 success
2. `needs-auth` 明确提示去 authenticate
3. `pending / failed / disabled` 都不算 recovered

这等于说明 UI surface 也没有把 recovering 写成 recovered。

## 9. 这篇源码剖面给主线带来的四条技术启示

### 启示一

repo 已经在 `needs-auth` demotion 上明确展示：

`continuity broken != recovery started`

### 启示二

repo 已经在 fresh reconnect pipeline 上明确展示：

`new attempt != restored truth`

### 启示三

repo 已经在 OAuth flow 上明确展示：

`auth completed != service recovered`

### 启示四

repo 已经在 tool swap 与 success surface 上明确展示：

`recovered proof != recovered world projection`

这四句合起来，
正好说明为什么 stronger-request cleanup 线未来不能把 continuity governance 直接偷写成 complete recovery。

## 10. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 线未来只要补出 continuity governance，就已经足够成熟。`

而是：

repo 在 `handleRemoteAuthFailure()` 的 `needs-auth` demotion 与 auth cache、`reconnectMcpServerImpl()` 的 fresh reconnect、`performMCPOAuthFlow()` 的 silent/interactive 凭据闭环、`print.ts` 对 retry/auth/callback/reconnect 的分层 choreography，以及 `McpAuthTool` / `MCPReconnect` 的 consumer-side recovery discipline 上，已经明确展示了 recovery governance 的存在；因此 `artifact-family cleanup stronger-request cleanup-continuity-governor signer` 仍不能越级冒充 `artifact-family cleanup stronger-request cleanup-recovery-governor signer`。

因此：

`stronger-request cleanup 线真正缺的不是“旧线还要不要继续”，而是“什么新的证据足以重新宣布它已经回来”。`
