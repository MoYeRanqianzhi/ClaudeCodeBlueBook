# 安全载体家族强请求清理step-up重授权治理与强请求清理续打治理分层速查表：same-request identity、retry budget、future readiness与governor question

## 1. 这一页服务于什么

这一页服务于
[307-安全载体家族强请求清理step-up重授权治理与强请求清理续打治理分层](../307-安全载体家族强请求清理step-up重授权治理与强请求清理续打治理分层.md)。

如果 `307` 的长文解释的是：

`为什么“现在已经被授权到足以尝试更强 cleanup 动作”仍不等于“先前那个被挡下的 stronger cleanup request 现在已经合法地以同一请求名义继续”，`

那么这一页只做一件事：

`把 same-request identity、retry budget、future readiness 与 stronger-request cleanup current gap 压成一张矩阵。`

## 2. 强请求清理 step-up 重授权治理与续打治理分层矩阵

| line | step-up reauthorization decision | continuation decision | state continuity ceiling / positive control | cleanup continuation gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| URL elicitation retry | decide the caller now has what it needs to try again after the barrier is lifted | decide whether the same tool call should loop back and retry, with a max-attempt budget | `callMCPToolWithUrlElicitationRetry()` + `MAX_URL_ELICITATION_RETRIES = 3` + hook/user accept grammar | stronger-request cleanup line has no explicit grammar for resuming the same blocked cleanup request with bounded attempts | who decides whether a blocked stronger cleanup request is still the same request worth retrying, and how many times | `client.ts:2813-3024` |
| deferred tool discovery | decide the missing prerequisite is now satisfiable because the tool can be loaded | decide whether the same call should be retried after schema discovery | `Load the tool first ... then retry this call.` | stronger-request cleanup line has no explicit same-call-after-prerequisite-fix wording | who decides whether prerequisite repair reopens the same cleanup call rather than requiring a wholly new request | `toolExecution.ts:583-596` |
| permission denied recovery | decide the command is now approved to run | decide whether the model/user may retry the same command after hook approval | `You may retry it if you would like.` | stronger-request cleanup line has no explicit post-approval continuation wording for stronger requests | who decides whether newly granted stronger cleanup permission merely exists, or reauthorizes the old blocked command to continue | `toolExecution.ts:1073-1100` |
| preserved step-up auth state | decide the next OAuth flow should continue targeting the stronger scope after revoke / re-auth | do not decide that the old blocked stronger cleanup request is resumed as the same request | `preserveStepUpState: true` + preserved `stepUpScope` / `discoveryState` only carry higher-authority target continuity | stronger-request cleanup line still needs a separate owner for old request identity, retry actor and budget | who decides whether preserved step-up intent is only authority continuity, or a warrant to continue the old blocked request now | `MCPRemoteServerMenu.tsx:263-289`; `auth.ts:579-617,903-935,1884-1898` |
| auth success restoration | decide stronger auth / reconnect / tool availability has been restored | do not explicitly decide that the old blocked stronger cleanup request is resumed as the same request | auth success updates connection/tool availability, reconnect state and `requiresUserAction`, but not same-request replay | stronger-request cleanup line still needs an explicit continuation owner even if stronger authorization becomes available | who decides whether auth success only restores availability, or also binds that success back to the original blocked stronger cleanup request | `McpAuthTool.ts:57-60,134-196`; `MCPRemoteServerMenu.tsx:279-289`; `print.ts:3310-3508` |
| agent-server auth | decide the server is authenticated for future use | explicitly refuse immediate same-request continuation by deferring connection to future agent execution | `The server will connect when the agent runs.` | stronger-request cleanup line has no explicit distinction between future readiness and current request continuation | who decides whether a stronger cleanup authorization affects this request now, or only some future run | `MCPAgentServerMenu.tsx:65-71` |

## 3. 四个最重要的判断问题

判断一句
“更高授权已经拿到，所以旧 stronger cleanup request 也算自然继续了”
有没有越级，
先问四句：

1. 这里回答的只是 authority level 是否足够，还是已经回答 old blocked request 是否仍配被视为同一请求
2. 这里有没有明确写出 retry actor、retry wording、retry budget 与 consent path
3. 这里保留的是 stronger-scope intent，还是 old request identity
4. 这里签的是 immediate same-call continuation，还是只签 future availability / future readiness

## 4. 最常见的六类误读

| 误读 | 实际问题 |
| --- | --- |
| “auth success 了，旧 stronger cleanup request 就算已经继续了” | reauthorization != continuation |
| “step-up scope 被保留了，所以旧 request identity 也被保留了” | state continuity != same-request continuation |
| “工具重新 available 了，所以被挡下的调用等于已经替你接上了” | availability != same-request replay |
| “reconnect 成功就说明原因果链还在” | reconnect success != causal continuity for the old request |
| “scope 已经升够，retry 预算自然也一并批准了” | higher authority != retry budget / consent approval |
| “未来 run 能连上，就等于当前 cleanup request 已恢复” | future readiness != current continuation |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup continuation grammar 不是：

`step-up reauthorization succeeded -> the blocked stronger cleanup request may be treated as implicitly resumed`

而是：

`step-up reauthorization succeeded -> inspect whether the old request still counts as the same request -> decide actor / consent / retry budget -> say explicitly whether it should retry now, later, or not at all`

即便 repo 还保留了：

`stepUpScope`

也只能说明：

`higher-authority target continuity exists`

不能说明：

`the old blocked stronger cleanup request has already been granted same-request continuation`

只有中间这些层被补上，
stronger-request cleanup step-up reauthorization governance 才不会继续停留在：

`它能决定主体现在够不够格做更强 cleanup 动作，却没人正式决定先前那条被挡下的 stronger cleanup request 现在是否仍配以同一请求的名义继续。`
