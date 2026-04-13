# callMCPToolWithUrlElicitationRetry、toolExecution与MCP认证路径的强请求清理续打治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `434` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 线未来谁来决定当前 authority level 是否已经足够，`

而是：

`stronger-request cleanup 线如果未来已经拿到了更高 authority，谁来决定先前那个被挡下的 stronger cleanup request 现在是否仍配被视为同一请求继续。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`step-up reauthorization governor 不等于 stronger-request continuation governor。`

这句话还不够硬。

所以这里单开一篇，
只盯住：

- `src/services/mcp/client.ts`
- `src/services/tools/toolExecution.ts`
- `src/tools/McpAuthTool/McpAuthTool.ts`
- `src/components/mcp/MCPRemoteServerMenu.tsx`
- `src/components/mcp/MCPAgentServerMenu.tsx`
- `src/cli/print.ts`

把 bounded retry / two-phase waiting grammar、explicit retry wording 与 auth-success restoration wording 并排，
逼出一句更硬的结论：

`Claude Code 已经在多个路径里明确展示：old blocked request 的 continuation grammar 必须单独写出 trigger、actor、budget 与 consent；MCP auth 成功路径当前主要签的是 availability / reconnect / future readiness，而不是 original blocked stronger cleanup request replay。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 完全没有 stronger-request continuation。`

而是：

`Claude Code 已经在 URL elicitation retry、tool discovery retry 与 permission-denied retry 上明确写出了 continuation grammar；正因为如此，MCP auth 成功路径只说 reconnect / available / connected / future-run readiness，就更说明它们没有越级替“原 blocked stronger cleanup request 是否继续”签字。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| bounded same-call retry | `src/services/mcp/client.ts:2813-3024` | 为什么 old call continuation 需要 retry loop、retry budget、hook/user accept grammar 与 waiting flow |
| retry wording at tool layer | `src/services/tools/toolExecution.ts:593-595,1093-1097` | 为什么 prerequisite repair / permission recovery 仍要单独说 `retry this call` |
| auth success restoration | `src/tools/McpAuthTool/McpAuthTool.ts:126-195` | 为什么 auth success 主要签 tools/resources become available，而不是 old blocked stronger cleanup request replay |
| UI reconnect messaging | `src/components/mcp/MCPRemoteServerMenu.tsx:263-288` | 为什么 connected / reconnected success copy 仍不等于 same-request continuation |
| deferred future readiness | `src/components/mcp/MCPAgentServerMenu.tsx:64-71` | 为什么 auth success 甚至可以只签 future-run readiness，而不签当前 request continuation |
| control-plane auth choreography | `src/cli/print.ts:3310-3505` | 为什么 control path 主要签 auth completion / reconnect / dynamic registration，而不是旧 stronger cleanup request replay |

## 4. `callMCPToolWithUrlElicitationRetry()` 先证明：同一请求续打需要自己的一整套 grammar

`src/services/mcp/client.ts:2813-3024`
很值钱。

`callMCPToolWithUrlElicitationRetry()` 至少做了七件 continuation governor 才会做的事：

1. 只在 `ErrorCode.UrlElicitationRequired` 上进入续打路径
2. 把 continuation 限定为最多 `3` 次 retry
3. 先运行 elicitation hooks，再决定是否进入 structuredIO / queue
4. 只有 `accept` 成立时，才 loop back 到原 tool call
5. 对 `decline` / `cancel` 明确返回 `could not complete`
6. 在 REPL queue path 里把 `Retry now`、`showCancel` 与 `onWaitingDismiss` 写成两阶段等待语法
7. 明确记录 `Elicitation ... completed, retrying tool call`

这条证据非常硬。

因为它不是在说：

`能力现在回来了，你再试试。`

而是在制度上正式回答：

1. 哪一类中断可以走续打
2. 续打之前谁有 veto / approve 权
3. 这次继续是否仍算同一条 tool call
4. 最多还能继续几次
5. 用户/钩子拒绝后要如何收口
6. waiting 阶段与真正 retry 阶段如何分开

这正是 continuation governance 的本体。

## 5. `toolExecution.ts` 再证明：连 prerequisite fix 与 permission recovery 都不会被偷写成“旧请求已自然继续”

`src/services/tools/toolExecution.ts:593-595`
很硬。

deferred tool discovery path 的提示不是：

`tool schema will now exist, so the prior call is implicitly resumed`

而是：

`Load the tool first ... then retry this call.`

这句话非常值钱。

因为它把：

`same call`

明文保留下来，
同时又拒绝把 prerequisite 修复偷写成“系统已经自动帮你接着打完”。

`src/services/tools/toolExecution.ts:1093-1097`
再给出第二组强证据。

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

## 6. `McpAuthTool`、`MCPRemoteServerMenu`、`MCPAgentServerMenu` 与 `print.ts` 再证明：MCP auth 路径当前签的是恢复可用，不是旧 stronger cleanup request 的 replay

`src/tools/McpAuthTool/McpAuthTool.ts:126-195`
很值钱。

OAuth 完成后，
它的 background continuation 会：

1. 清 auth cache
2. reconnect server
3. 把 real tools / commands / resources swap 回 `appState`

但它对外说的话只是：

1. `the server's tools will become available automatically`
2. `The server's tools should now be available`

这说明它签的是：

`capability availability after auth`

不是：

`the original blocked stronger cleanup request has now been retried / resumed / completed`

`src/components/mcp/MCPRemoteServerMenu.tsx:263-288`
同样如此。

这里文案的焦点是：

1. `Authentication successful. Reconnected ...`
2. `Authentication successful. Connected ...`
3. `still requires authentication`
4. `reconnection failed`
5. `manually restart Claude Code`

这仍然是：

`connection-level recovery truth`

不是：

`request-level continuation truth`

`src/cli/print.ts:3310-3505`
更能说明问题。

`mcp_authenticate` / `mcp_oauth_callback_url` 做的是：

1. 返回 auth URL / `requiresUserAction`
2. 等待 auth promise
3. auth 完成后 reconnect
4. 回填 `appState` / `dynamicMcpState`
5. 在 manual callback path 把 reconnect 留给另一条 control choreography

整个 choreography 的重点是：

`让认证与注册闭环成立`

而不是：

`把某条旧 stronger cleanup request 重新作为同一请求送回执行`

`src/components/mcp/MCPAgentServerMenu.tsx:64-71`
最硬。

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

## 7. 为什么这层不等于 `284` 的 step-up 重授权剖面

这里必须单独讲清楚，
否则很容易把 `284` 和这一篇写成一篇。

`284` 最值钱的地方是回答：

`为什么 current-use truth 与 stronger authority truth 不是同一条 gate。`

它处理的是：

1. `403 insufficient_scope`
2. refresh suppression
3. pending step-up scope
4. higher-authority reauthorization flow

这一篇则进一步回答：

`即便 higher authority 已经拿到，先前那个被挡下的 stronger cleanup request 是否仍配以同一请求名义继续。`

它处理的是：

1. old request identity
2. retry budget
3. retry actor
4. consent path
5. immediate retry 与 future readiness 的分层

如果把这两层压成一句：

`scope 升够了，所以原请求自然继续`

就等于把：

`authority sufficiency`

偷写成：

`request continuity`

这正是这一篇源码剖面要防的越级。

## 8. 苏格拉底式自反诘问：我是不是又把“现在已经被授权到足够强”误认成了“刚才那条被挡下的请求现在自然就继续了”

如果对这组代码做更严格的自我审查，
至少要追问六句：

1. 如果 step-up success 已经等于原 stronger cleanup request 合法续打，为什么 `callMCPToolWithUrlElicitationRetry()` 还要单独维护 retry loop、retry budget 与 `retrying tool call` 文案？
   因为 authority success 不自动回答“是不是这同一条调用继续”。
2. 如果工具 `should now be available` 已经等于原请求继续成功，为什么 `toolExecution.ts` 还要再明确说 `then retry this call` 或 `You may retry it if you would like`？
   因为 availability truth 不拥有替 old call continuation 签字的资格。
3. 如果 auth 完成已经自动恢复原 stronger cleanup request，为什么 `MCPAgentServerMenu` 还会说 `The server will connect when the agent runs`？
   因为 auth success 可以只签 future readiness，而不签 immediate same-request continuation。
4. 如果 reconnect 成功已经足够，为什么 continuation grammar 还要关心 `accept / decline / cancel`？
   因为 same-request continuation 仍要单独治理 consent。
5. 如果 higher authority 已经升够，为什么 retry budget 还不是自动批准的？
   因为 request identity 与 authority sufficiency 是两层不同主权。
6. 如果 cleanup 线还没正式长出 continuation grammar，是不是说明这层只是重试细节？
   恰恰相反。越是把它当重试细节，越容易让 `upscoped enough` 偷签 `same request legitimately continued`。

这一串反问最终逼出一句更稳的判断：

`continuation 的关键，不在当前 principal 是否已经够格，而在系统能不能正式决定刚才那条被挡下的请求是否仍应被视为同一条继续。`

## 9. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 未来只要补出 step-up grammar，就已经足够成熟。`

而是：

repo 已经在 `callMCPToolWithUrlElicitationRetry()` 的 bounded retry / waiting grammar、`toolExecution.ts` 的 explicit retry wording，以及 `McpAuthTool`、`MCPRemoteServerMenu`、`MCPAgentServerMenu` 与 `print.ts` 的 availability / reconnect / future-readiness ceiling 上，明确展示了 continuation governance 的存在与边界；因此 `artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer` 仍不能越级冒充 `artifact-family cleanup stronger-request continuation-governor signer`。

因此：

`stronger-request cleanup 线真正缺的，不只是“谁来决定现在够不够格再尝试”，还包括“谁来决定刚才那条被挡下的请求现在是否仍该被算作同一条继续”。`
