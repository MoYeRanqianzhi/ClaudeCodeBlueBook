# 安全载体家族step-up重授权治理与强请求续打治理分层速查表：step-up reauthorization decision、stronger-request continuation decision、positive control、cleanup continuation gap与governor question

## 1. 这一页服务于什么

这一页服务于 [179-安全载体家族step-up重授权治理与强请求续打治理分层：为什么artifact-family cleanup step-up reauthorization-governor signer不能越级冒充artifact-family cleanup stronger-request continuation-governor signer](../179-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8Fstep-up%E9%87%8D%E6%8E%88%E6%9D%83%E6%B2%BB%E7%90%86%E4%B8%8E%E5%BC%BA%E8%AF%B7%E6%B1%82%E7%BB%AD%E6%89%93%E6%B2%BB%E7%90%86%E5%88%86%E5%B1%82%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88artifact-family%20cleanup%20step-up%20reauthorization-governor%20signer%E4%B8%8D%E8%83%BD%E8%B6%8A%E7%BA%A7%E5%86%92%E5%85%85artifact-family%20cleanup%20stronger-request%20continuation-governor%20signer.md)。

如果 `179` 的长文解释的是：

`为什么“现在已经被授权到足以尝试更强动作”仍不等于“先前那个被挡下的更强请求现在已经合法地以同一请求名义继续”，`

那么这一页只做一件事：

`把 repo 里现成的 step-up reauthorization decision / stronger-request continuation decision 正例，与 cleanup 线当前仍缺的 continuation grammar，压成一张矩阵。`

## 2. step-up 重授权治理与强请求续打治理分层矩阵

| line | step-up reauthorization decision | stronger-request continuation decision | positive control | cleanup continuation gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| URL elicitation retry | decide the caller now has what it needs to try again after the elicitation barrier is lifted | decide whether the same tool call should loop back and retry, with a max-attempt budget | `callMCPToolWithUrlElicitationRetry()` | cleanup line has no explicit grammar for resuming the same stronger cleanup request with bounded attempts | who decides whether a blocked stronger cleanup request is still the same request worth retrying, and how many times | `client.ts:2813-3024` |
| deferred tool discovery | decide the missing prerequisite is now satisfiable because the tool can be loaded | decide whether the same call should be retried after schema discovery | `then retry this call` | cleanup line has no explicit “same call after prerequisite fix” wording | who decides whether prerequisite repair reopens the same cleanup call rather than requiring a wholly new request | `toolExecution.ts:586-606` |
| permission denied recovery | decide the command is now approved to run | decide whether the model/user may retry the same command after hook approval | `You may retry it if you would like` | cleanup line has no explicit post-approval continuation wording for stronger requests | who decides whether newly granted stronger cleanup permission merely exists, or reauthorizes the old blocked command to continue | `toolExecution.ts:1068-1105` |
| MCP auth tool / remote menu / print | decide stronger auth / reconnect / tool availability has been restored | do not explicitly decide that the old blocked stronger request is resumed as the same request | auth success updates connection/tool availability but not same-request replay | cleanup line would still need an explicit continuation owner even if stronger authorization becomes available | who decides whether auth success only restores availability, or also binds that success back to the original blocked stronger cleanup request | `McpAuthTool.ts:126-205`; `MCPRemoteServerMenu.tsx:258-292`; `print.ts:3310-3508` |
| agent-server auth | decide the server is authenticated for future use | explicitly refuse immediate same-request continuation by deferring connection to future agent execution | `The server will connect when the agent runs` | cleanup line has no explicit distinction between future readiness and current request continuation | who decides whether a stronger cleanup authorization affects this request now, or only some future run | `MCPAgentServerMenu.tsx:60-77` |

## 3. 三个最重要的判断问题

判断一句“更高授权已经拿到，所以旧 stronger request 也算自然继续了”有没有越级，先问三句：

1. 这里回答的只是 authority level 是否足够，还是已经回答 old blocked request 是否仍配被视为同一请求
2. 这里有没有明确写出 retry actor、retry wording、retry budget 与 consent path
3. 这里签的是 immediate same-call continuation，还是只签 future availability / future readiness

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “auth success 了，旧 stronger request 就算已经继续了” | reauthorization != continuation |
| “工具重新 available 了，所以被挡下的调用等于已经替你接上了” | availability != same-request replay |
| “reconnect 成功就说明原因果链还在” | reconnect success != causal continuity for the old request |
| “scope 已经升够，retry 预算自然也一并批准了” | higher authority != retry budget / consent approval |
| “未来 run 能连上，就等于当前 request 已恢复” | future readiness != current continuation |

## 5. 一条硬结论

真正成熟的 stronger-request continuation grammar 不是：

`step-up reauthorization succeeded -> the blocked stronger request may be treated as implicitly resumed`

而是：

`step-up reauthorization succeeded -> inspect whether the old request still counts as the same request -> decide actor / consent / retry budget -> say explicitly whether it should retry now, later, or not at all`

只有中间这些层被补上，
cleanup step-up reauthorization governance 才不会继续停留在：

`它能决定主体现在够不够格做更强动作，却没人正式决定先前那条被挡下的更强动作现在是否仍配以同一请求的名义继续。`
