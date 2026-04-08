# callMCPToolWithUrlElicitationRetry、toolExecution与MCP认证路径的强请求清理续打治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `370` 时，
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

把 bounded retry / two-phase waiting grammar、explicit retry wording、auth-success restoration wording，以及 future-readiness ceiling 并排，
逼出一句更硬的结论：

`Claude Code 已经在多个路径里明确展示：old blocked request 的 continuation grammar 必须单独写出 trigger、actor、budget 与 consent；MCP auth 成功路径当前主要签的是 availability / reconnect / future readiness，而不是 original blocked stronger cleanup request replay。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 完全没有 stronger-request continuation。`

而是：

`Claude Code 已经在 URL elicitation retry、tool discovery retry 与 permission-denied retry 上明确写出了 continuation grammar；正因为如此，MCP auth 成功路径即便已经保留 step-up state、完成更强授权、恢复连接或回填工具，也更说明这些路径没有越级替“原 blocked stronger cleanup request 是否继续”签字。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| bounded same-call retry | `src/services/mcp/client.ts:2813-3024` | 为什么 old call continuation 需要 retry loop、retry budget、hook / user accept grammar 与 waiting flow |
| retry wording at tool layer | `src/services/tools/toolExecution.ts:595,1096` | 为什么 prerequisite repair / permission recovery 仍要单独说 `retry this call` |
| auth success restoration | `src/tools/McpAuthTool/McpAuthTool.ts:55-60,184-195` | 为什么 auth success 主要签 tools / resources become available，而不是 old blocked stronger cleanup request replay |
| UI reconnect messaging | `src/components/mcp/MCPRemoteServerMenu.tsx:281-288` | 为什么 connected / reconnected success copy 仍不等于 same-request continuation |
| deferred future readiness | `src/components/mcp/MCPAgentServerMenu.tsx:71` | 为什么 auth success 甚至可以只签 future-run readiness，而不签当前 request continuation |
| control-plane auth choreography | `src/cli/print.ts:3362,3366,3478-3508` | 为什么 control path 主要签 auth completion / action-state change，而不是旧 stronger cleanup request replay |

## 4. `callMCPToolWithUrlElicitationRetry()` 先证明：同一请求续打需要自己的一整套 grammar

`client.ts:2813-3024`
很值钱。

`callMCPToolWithUrlElicitationRetry()` 至少做了七件 continuation governor 才会做的事：

1. 只在 `ErrorCode.UrlElicitationRequired` 上进入续打路径
2. 把 continuation 限定为最多 `3` 次 retry
3. 先运行 elicitation hooks，再决定是否进入 structuredIO / queue
4. 只有 `accept` 成立时，才 loop back 到原 tool call
5. 对 `decline / cancel` 明确返回 `could not complete`
6. 在 REPL queue path 里把 `Retry now`、`showCancel` 与 `onWaitingDismiss` 写成两阶段等待语法
7. 明确记录 `retrying tool call`

这条证据非常硬。

因为它不是在说：

`能力现在回来了，你再试试`

而是在制度上正式回答：

1. 哪一类中断可以走续打
2. 续打之前谁有 veto / approve 权
3. 这次继续是否仍算同一条 tool call
4. 最多还能继续几次
5. 用户 / 钩子拒绝后要如何收口
6. waiting 阶段与真正 retry 阶段如何分开

这正是 continuation governance 的本体。

## 5. `toolExecution.ts` 再证明：连 prerequisite fix 与 permission recovery 都不会被偷写成“旧请求已自然继续”

`toolExecution.ts:595`
很硬。

deferred tool discovery path 的提示不是：

`tool schema will now exist, so the prior call is implicitly resumed`

而是：

`then retry this call`

这句话非常值钱。

因为它把：

`same call`

明文保留下来，
同时又拒绝把 prerequisite 修复偷写成“系统已经自动帮你接着打完”。

`toolExecution.ts:1096`
再给出第二组强证据。

PermissionDenied hook 解封后，
repo 的话术是：

`You may retry it if you would like.`

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

不是一回事。

## 6. `McpAuthTool`、`MCPRemoteServerMenu`、`MCPAgentServerMenu` 与 `print.ts` 再证明：auth success 主要签 availability / readiness ceiling，而不签 same-request replay

`McpAuthTool.ts:55-60,126-205`
主要签的是：

1. `the server's real tools will become available automatically`
2. `the server's tools should now be available`

`MCPRemoteServerMenu.tsx:258-292`
主要签的是：

1. `Authentication successful. Connected / Reconnected ...`
2. 或带 caveat 的 auth-success copy

`MCPAgentServerMenu.tsx:60-77`
更直接：

`The server will connect when the agent runs.`

`print.ts:3310-3508`
则主要签：

1. auth flow completion
2. 当前是否仍需要用户动作
3. callback proof 是否过关

这些路径共同说明：

1. auth success 可签 availability
2. auth success 可签 reconnect
3. auth success 可签 future readiness
4. auth success 可签 control completion

但它们仍没有单独签出：

`the original blocked stronger request is now resumed as the same request`

这条缺口非常值钱。

因为正是 repo 在其他路径里把 continuation grammar 写得足够清楚，
才更能反衬这里没有越级签字。

## 7. 更深一层的技术先进性：Claude Code 连“主体现在够格了”和“旧请求现在可以继续了”都继续拆开

这组源码给出的技术启示至少有五条：

1. restored authority should not automatically imply same-request replay
2. continuation 需要自己的 actor、budget、consent 与 settlement 语法
3. future readiness 是一种独立 ceiling，不应被误当成 current continuation
4. higher-authority continuity 与 request-identity continuity 必须分层
5. 明确拒绝自动续打，往往比偷写“已经接上了”更诚实

从源码设计思路看，
Claude Code 的先进性不在于“权限恢复后它会帮你自动做完很多事”，
而在于：

`它知道什么时候只能说“你现在可以再试”，却不能越级说“我已经替你把刚才那件事接着做完了”。`

## 8. 用苏格拉底式反问压缩这篇源码剖面的核心

可以得到五个自检问题：

1. 如果 higher-authority success 已经足够，为什么 `callMCPToolWithUrlElicitationRetry()` 还要单独写 retry budget、hook accept 与 waiting flow？
2. 如果 prerequisite repair 已经等于 same-call continuation，为什么 `toolExecution.ts` 还要明说 `retry this call`？
3. 如果 higher-authority continuity 已经保留了，为什么它仍不等于 old request identity continuity？
4. 如果 auth success 已经接上了旧 blocked request，为什么 `MCPAgentServerMenu` 还只敢说 `when the agent runs`？
5. 如果系统已经替你恢复因果连续性，为什么 print / control path 还主要只签 auth completion 与 availability，而不签 original request replay？

这些反问共同逼出同一个结论：

`Claude Code 不只在治理主体现在够不够格，也在治理那个旧动作现在是否仍然算同一个动作。`

## 9. 苏格拉底式自反诘问：我是不是又把“现在已经够格尝试更强动作”误认成了“刚才那条被挡下的动作已经自然续打”

如果对这组代码做更严格的自我审查，
至少要追问六句：

1. 如果 step-up reauthorization 已经足够强，为什么还要再拆 continuation？
   因为现在够不够格，不等于刚才那件事还算不算同一件事继续。
2. 如果某条 stronger request 先前被挡下，现在 scope 已经升够，是不是就说明旧 request 身份、旧预算、旧 consent 也都自然延续？
   不是。authority continuity 不替代 request-identity continuity。
3. 如果工具已经重新可用，是不是就说明 old blocked call 已被代表性完成？
   不是。availability ceiling 与 same-call continuation 是两层主权。
4. 如果 auth success 文案已经出现，为什么 repo 还在别的 continuation path 上坚持 `retry this call` 这种显式 wording？
   因为真正 continuation grammar 需要单独写出 trigger、actor 与 budget。
5. 如果 future readiness 已经成立，为什么还不能把它压成 current same-request continuation？
   因为 future-run readiness 明确保留了时间和请求边界的断裂。
6. 如果 cleanup 线现在还没有显式 continuation 代码，是不是说明这层还不值得写？
   恰恰相反。越是缺这层明确 grammar，越容易把“你现在可以再试”偷写成“刚才那件事已经自然接上了”。`

这一串反问最终逼出一句更稳的判断：

`continuation 的关键，不在系统是否恢复了做这件事的资格，而在系统能不能正式决定刚才那件事是否仍配以同一件事的名义继续。`

## 10. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 只要补出 step-up reauthorization governance，就已经足够成熟。`

而是：

`Claude Code 在 bounded same-call retry、explicit retry wording、auth success restoration wording、higher-authority continuity 与 future-readiness ceiling 上已经明确展示了 continuation governance 的存在；因此 artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer 仍不能越级冒充artifact-family cleanup stronger-request continuation-governor signer。`

再压成一句：

`cleanup 线真正缺的不是“它现在够不够格”，而是“刚才那件事现在还算不算同一件事继续”。`
