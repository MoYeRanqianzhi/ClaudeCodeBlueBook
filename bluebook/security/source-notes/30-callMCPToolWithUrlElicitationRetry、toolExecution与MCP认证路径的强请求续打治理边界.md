# callMCPToolWithUrlElicitationRetry、toolExecution 与 MCP 认证路径的强请求续打治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `179` 时，
真正需要被单独钉住的已经不是：

`cleanup 线未来谁来决定当前 stronger authority 是否已经足够，`

而是：

`cleanup 线如果未来已经拿到了 stronger authority，谁来决定先前那个被挡下的 stronger request 现在是否仍配被视为同一请求继续。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`step-up reauthorization governor 不等于 stronger-request continuation governor。`

这句话还不够硬。
所以这里单开一篇，只盯住：

- `src/services/mcp/client.ts`
- `src/services/tools/toolExecution.ts`
- `src/tools/McpAuthTool/McpAuthTool.ts`
- `src/components/mcp/MCPRemoteServerMenu.tsx`
- `src/components/mcp/MCPAgentServerMenu.tsx`
- `src/cli/print.ts`

把 explicit retry / continuation positive control 与 auth-success restoration path 并排，
逼出一句更硬的结论：

`Claude Code 已经在多个路径里明确展示：old blocked request 的 continuation grammar 必须单独写出 trigger、actor、budget 与 consent；MCP auth 路径当前主要签的是 availability / reconnect / future readiness，而不是 original blocked stronger request replay。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 完全没有 stronger-request continuation。`

而是：

`Claude Code 已经在 URL elicitation retry、tool search retry 与 permission-denied retry 上明确写出了 continuation grammar；正因为如此，MCP auth 成功路径只说 reconnect / available / connected / future run readiness，就更说明它们没有越级替“原 blocked stronger request 是否继续”签字。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| bounded same-call retry | `src/services/mcp/client.ts:2813-3024` | 为什么 old call continuation 需要 retry loop、retry budget 与 accept/decline/cancel grammar |
| retry wording at tool layer | `src/services/tools/toolExecution.ts:586-606,1068-1105` | 为什么 prerequisite repair / permission recovery 仍要单独说 `retry this call` |
| auth success restoration | `src/tools/McpAuthTool/McpAuthTool.ts:126-205` | 为什么 auth success 主要签 tools/resources become available，而不是 old blocked stronger request replay |
| UI reconnect messaging | `src/components/mcp/MCPRemoteServerMenu.tsx:258-292` | 为什么 connected / reconnected success copy 仍不等于 same-request continuation |
| deferred future readiness | `src/components/mcp/MCPAgentServerMenu.tsx:60-77` | 为什么 auth success 甚至可以只签 future-run readiness，而不签当前 request continuation |
| control-plane auth choreography | `src/cli/print.ts:3310-3508` | 为什么 control path 主要签 auth completion / reconnect / tool registration，而不是旧 stronger request replay |

## 4. `callMCPToolWithUrlElicitationRetry()` 先证明：同一请求续打需要自己的一整套 grammar

`client.ts:2813-3024` 很值钱。

`callMCPToolWithUrlElicitationRetry()` 至少做了五件 continuation governor 才会做的事：

1. 只在 `ErrorCode.UrlElicitationRequired` 上进入续打路径
2. 把 continuation 限定为最多 `3` 次 retry
3. 先运行 elicitation hooks，再决定是否进入 UI / structuredIO / queue
4. 只有 `accept` / `retry` 成立时，才 loop back 到原 tool call
5. 明确记录 `Elicitation ... completed, retrying tool call`

这条证据非常硬。

因为它不是在说：

`能力现在回来了，你再试试。`

而是在制度上正式回答：

1. 哪一类中断可以走续打
2. 续打之前谁有 veto / approve 权
3. 这次继续是否仍算同一条 tool call
4. 最多还能继续几次
5. 用户/钩子拒绝后要如何收口

这正是 continuation governance 的本体。

## 5. `toolExecution.ts` 再证明：连 prerequisite fix 与 permission recovery 都不会被偷写成“旧请求已自然继续”

`toolExecution.ts:586-606` 很硬。

deferred tool discovery path 的提示不是：

`tool schema will now exist, so the prior call is implicitly resumed`

而是：

`Load the tool first ... then retry this call.`

这句话非常值钱。

因为它把：

`same call`

明文保留下来，
同时又拒绝把 prerequisite 修复偷写成“系统已经自动帮你接着打完”。

`toolExecution.ts:1068-1105` 再给出第二组强证据。

PermissionDenied hook 解封后，
repo 的话术是：

`The PermissionDenied hook indicated this command is now approved. You may retry it if you would like.`

这里同样没有把：

`now approved`

压成：

`already continued`

而是继续保留：

1. 当前只是 approval truth
2. 是否继续 old command 仍要再说一次
3. continuation actor 仍在调用者 / 模型 / 用户这一侧

所以这两条 tool path 一起说明：

`restored prerequisite`

和

`same-request continuation`

不是同一个 signer。

## 6. `McpAuthTool`、`MCPRemoteServerMenu`、`MCPAgentServerMenu` 与 `print.ts` 再证明：MCP auth 路径当前签的是恢复可用，不是旧 stronger request 的 replay

`McpAuthTool.ts:126-205` 很值钱。

OAuth 完成后，
它的 background continuation 会：

1. 清 auth cache
2. reconnect server
3. 把 real tools / commands / resources swap 回 app state

但它对外说的话只是：

1. `the server's tools will become available automatically`
2. `The server's tools should now be available`

这说明它签的是：

`capability availability after auth`

不是：

`the original blocked stronger request has now been retried / resumed / completed`

`MCPRemoteServerMenu.tsx:258-292` 同样如此。

这里文案的焦点是：

1. `Authentication successful. Connected ...`
2. `Authentication successful. Reconnected ...`
3. 或 `manually restart Claude Code`

这仍然是：

`connection-level recovery truth`

不是：

`request-level continuation truth`

`print.ts:3310-3508` 更能说明问题。

`mcp_authenticate` / `mcp_oauth_callback_url` 做的是：

1. 返回 auth URL / `requiresUserAction`
2. 等待 auth promise
3. auth 完成后 reconnect
4. 更新 `appState` / `dynamicMcpState`

整个 choreography 的重点是：

`让认证与注册闭环成立`

而不是：

`把某条旧 stronger request 重新作为同一请求送回执行`

`MCPAgentServerMenu.tsx:60-77` 最硬。

它直接说：

`The server will connect when the agent runs.`

这说明同样一条 auth success，
完全可以只签：

`future-run readiness`

而不签：

`current request continuation`

这条证据极其关键。

因为它让我们看到：

`auth success`

并没有一个天然固定的 continuation ceiling。

它能说到哪里，
完全取决于具体 path 有没有把 continuation grammar 单独写出来。

## 7. 为什么这层不等于 `178` 的 step-up gate

这里必须单独讲清楚，
否则容易把 `179` 误读成 `178` 的尾注。

`178` 问的是：

`当前 fresh current-use proof 是否已经拥有足够高的 authority level 去执行更强请求。`

`179` 问的是：

`即便 authority level 现在已经足够，先前那个被挡下的 stronger request 是否仍应以同一请求名义继续。`

所以：

1. `178` 的典型形态是 insufficient-scope detection、refresh suppression、step-up pending、scope persistence
2. `179` 的典型形态是 retry loop、retry wording、accept/decline/cancel、same-call relation、future-run deferral

前者 guarding authority elevation，
后者 guarding causal continuation。

两者都很重要，
但不是同一个 signer。

这里还要再压一层谨慎说明：

`auth.ts` 的 comment 已经表明 SDK internal path 里会出现局部 retry。  
这并不反驳 `179`。

因为 `179` 并没有声称：

`repo 在 auth 附近完全没有 retry behavior`

它只是在说：

`这些局部 retry behavior 仍不等于 user-visible / policy-rich old-request continuation governance。`

## 8. 这篇源码剖面给主线带来的四条技术启示

### 启示一

repo 已经明确展示：

`higher authority acquired != old stronger request continued`

### 启示二

repo 已经明确展示：

`retry grammar needs trigger, actor, budget, and wording`

### 启示三

repo 已经明确展示：

`availability / reconnect truth should not impersonate same-request continuation truth`

### 启示四

repo 已经明确展示：

`future readiness is itself a legitimate ceiling, and that is exactly why it cannot be flattened into immediate continuation`

这四句合起来，
正好说明为什么 cleanup 线未来不能把 step-up success 直接偷写成 old destructive request replay。

## 9. 一条硬结论

这组源码真正说明的不是：

`只要补出 stronger authorization，cleanup 线就已经具备了完整的 stronger-request continuation grammar。`

而是：

`repo 已经在 callMCPToolWithUrlElicitationRetry() 的 bounded retry loop、toolExecution.ts 的 retry wording，以及 McpAuthTool / MCPRemoteServerMenu / MCPAgentServerMenu / print.ts 的 auth-success restoration wording 之间，清楚展示了 stronger-request continuation governance 的独立存在；因此 artifact-family cleanup step-up reauthorization-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request continuation-governor signer。`

因此：

`cleanup 线真正缺的，不只是更高 authority level 的正式 gate，还包括“旧 stronger request 现在是否仍配以同一请求名义继续”的专门 continuation grammar。`
