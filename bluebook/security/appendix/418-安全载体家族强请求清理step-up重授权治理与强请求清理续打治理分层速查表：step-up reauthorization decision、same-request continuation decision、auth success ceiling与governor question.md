# 安全载体家族强请求清理step-up重授权治理与强请求清理续打治理分层速查表：step-up reauthorization decision、same-request continuation decision、auth success ceiling与governor question

## 1. 这一页服务于什么

这一页服务于 [434-安全载体家族强请求清理step-up重授权治理与强请求清理续打治理分层](../434-安全载体家族强请求清理step-up重授权治理与强请求清理续打治理分层.md)。

如果 `434` 的长文解释的是：

`为什么当前主体即便已经拿到更高 authority，也还不能自动回答先前那个被挡下的 stronger cleanup request 是否仍配以同一请求名义继续，`

那么这一页只做一件事：

`把 step-up reauthorization decision、same-request continuation decision、auth success ceiling 与 stronger-request cleanup current gap 压成一张矩阵。`

## 2. 强请求清理step-up重授权治理与强请求清理续打治理分层矩阵

| positive control / cleanup current gap | step-up reauthorization decision | same-request continuation decision | continuation mechanism | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| URL elicitation retry path | decide current principal now has enough authority to attempt stronger action | decide whether original blocked tool call is still the same call, with retry budget and consent grammar | `callMCPToolWithUrlElicitationRetry()` bounded retry + hook/user accept + queue wait | who decides when a stronger cleanup request is not just newly authorized, but legitimately continued as the same request | `src/services/mcp/client.ts:2813-3024` |
| tool-layer retry wording | decide prerequisite/approval condition is now satisfied | decide whether continuation is still optional and still framed as retrying the original call | `then retry this call` + `You may retry it if you would like` | who decides whether restored preconditions reopen the same cleanup request rather than merely enabling a new attempt | `src/services/tools/toolExecution.ts:593-595,1093-1097` |
| auth success tool path | decide tools/resources may become available after auth | decide whether old blocked stronger cleanup request is actually replayed or merely made possible again | `McpAuthTool` reconnect + real-tools swap + availability wording | who decides when auth success only restores capability availability, not same-request continuation | `src/tools/McpAuthTool/McpAuthTool.ts:126-195` |
| interactive auth menu | decide current surface may say connected/reconnected after auth | decide whether that success copy still stops below same-request continuation | `MCPRemoteServerMenu` success/caveat branches | who decides when auth success is merely recovery truth, not request-level continuation truth | `src/components/mcp/MCPRemoteServerMenu.tsx:263-288` |
| future-run readiness path | decide current principal is authorized for future agent use | decide that no immediate continuation of the blocked request is signed | `The server will connect when the agent runs.` | who decides when stronger cleanup authorization only signs future readiness and not current same-request replay | `src/components/mcp/MCPAgentServerMenu.tsx:64-71` |
| control auth choreography | decide auth callback/reconnect/writeback have completed | decide whether original blocked stronger request is resumed, or only the environment is restored for future attempts | `mcp_authenticate` / `mcp_oauth_callback_url` control flow | who decides whether control-plane auth completion implies same-request continuation or merely environment restoration | `src/cli/print.ts:3310-3505` |
| stronger-request cleanup current gap | higher-authority question is now visible | no explicit same-request continuation grammar yet | old path / promise / receipt world still lack formal retry actor, consent, retry budget, and old-request identity governance | who decides when a stronger cleanup request remains the same request after reauthorization rather than merely becoming newly possible | current cleanup line evidence set |

## 3. 三个最重要的判断问题

判断一句

`既然当前主体现在已经 upscoped enough，所以刚才那条 stronger cleanup request 自然继续`

有没有越级，先问三句：

1. 这里回答的是 authority sufficiency，还是已经回答 old blocked request 是否仍应被视为同一请求
2. 当前看到的是 availability / reconnect / readiness truth，还是已经看到了 explicit retry wording、retry budget 与 consent grammar
3. 如果 auth success 后系统只说 `connected`、`available` 或 `will connect when the agent runs`，谁来为 same-request continuation 签字

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| `更高 authority 已拿到，所以原 stronger request 自然算继续了` | reauthorization != continuation |
| `工具重新可见了，所以旧调用已经算恢复` | availability != same-request replay |
| `connected/reconnected 就代表因果链还在` | recovery truth != continuation truth |
| `现在可以 retry，就说明系统已经替你 retry 了` | retry permission != retry execution |
| `future readiness 文案也算立即续打` | future-run readiness != immediate same-request continuation |

## 5. 一条硬结论

真正成熟的 stronger-request continuation grammar 不是：

`higher authority has been granted -> the blocked stronger request is assumed to continue`

而是：

`higher authority has been granted -> inspect old request identity -> choose retry actor -> choose consent path -> apply retry budget -> then decide whether the same request may continue`

只有中间这些层被补上，
stronger-request cleanup step-up reauthorization governance 才不会继续停留在：

`它能决定现在够不够格再尝试，却没人正式决定刚才那条被挡下的请求现在是否仍该被算作同一条继续。`
