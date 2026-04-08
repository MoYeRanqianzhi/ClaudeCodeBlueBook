# 安全载体家族强请求清理step-up重授权治理与强请求清理续打治理分层速查表：resumable request、human loop、request identity与governor question

## 1. 这一页服务于什么

这一页服务于
[370-安全载体家族强请求清理step-up重授权治理与强请求清理续打治理分层](../370-安全载体家族强请求清理step-up重授权治理与强请求清理续打治理分层.md)。

如果 `370` 的长文解释的是：

`为什么某次更强授权即便已经成功，也还不等于先前那个被挡下的强请求已经被合法续打，`

那么这一页只做一件事：

`把 resumable request、human loop、request identity 与 stronger-request cleanup current gap 压成一张矩阵。`

## 2. 强请求清理 step-up 重授权治理与强请求续打治理分层矩阵

| positive control / cleanup current gap | step-up reauthorization decision | continuation decision | continuation / retry mechanism | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| same-call retry loop | decide current authority level now permits trying the stronger path | decide whether the old blocked call may continue as the same call under bounded retry | `callMCPToolWithUrlElicitationRetry()` + max `3` retries + accept / decline / cancel grammar | who decides whether higher-authority success revives the same blocked stronger request instead of merely restoring general capability | `client.ts:2813-3024` |
| tool-layer retry wording | decide prerequisite or policy block has been lifted | decide whether the caller must explicitly reissue the same call | `then retry this call` + `You may retry it if you would like` | who decides when repaired prerequisites still require an explicit continuation act | `toolExecution.ts:595,1096` |
| auth-success availability ceiling | decide auth / reconnect restored stronger authority or availability | decide whether old blocked stronger request has actually been replayed | `will become available automatically` / `should now be available` | who decides whether restored availability can stand in for same-request continuation | `McpAuthTool.ts:55-60,126-205` |
| connected / reconnected copy | decide principal now has higher-authority access | decide whether current success copy still preserves caveated causal break from the old blocked request | `Authentication successful. Connected / Reconnected ...` | who decides whether auth-success copy is only restoration or actual request continuation | `MCPRemoteServerMenu.tsx:258-292` |
| future readiness ceiling | decide auth success can restore eventual ability to use the server | decide whether continuation is deferred to a future run rather than granted now | `The server will connect when the agent runs.` | who decides when restored authority only permits future readiness, not immediate same-request continuation | `MCPAgentServerMenu.tsx:60-77` |
| control auth choreography | decide auth completion / user-action state is updated | decide whether old blocked request identity, budget, and consent are also restored | `mcp_authenticate` / `mcp_oauth_callback_url` success + `requiresUserAction` | who decides whether control-plane auth completion still stops short of same-request continuation | `print.ts:3310-3508` |
| stronger-request cleanup current gap | step-up question is now visible | no explicit continuation grammar yet | old path / promise / receipt world still lack formal same-request retry actor / budget / consent governance | who decides whether old blocked cleanup truth is merely re-authorized or truly continued as the same request | current cleanup line evidence set |

## 3. 三个最重要的判断问题

判断一句
“既然更强授权已经拿到了，所以刚才那个被挡下的强请求当然就算接着打完了”
有没有越级，
先问三句：

1. 这里回答的是 authority sufficiency，还是已经回答 old blocked request 的 identity / budget / consent 是否仍然有效
2. 当前看到的是 availability / connected / reconnected copy，还是已经有了 same-call retry grammar
3. 如果 repo 在别的 continuation path 上显式写 `retry this call`，为什么这里还要把 auth success 自动压成 same-request continuation

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “scope 升够了，所以原请求自然就续上了” | reauthorization != continuation |
| “工具重新可见了，所以旧 blocked call 算完成了” | availability != same-request replay |
| “Connected / Reconnected 就等于把刚才那件事接上了” | restored state != preserved request identity |
| “既然未来能连上，当前就算续打成功” | future readiness != current continuation |
| “auth flow 结束了，所以旧请求的预算、同意和因果链都还在” | auth completion != continuation signature |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup continuation grammar 不是：

`higher authority restored -> old stronger request is assumed continued`

而是：

`higher authority restored -> decide if same request still exists -> decide retry actor / budget / consent -> only then continue or explicitly decline continuation`

只有中间这些层被补上，
stronger-request cleanup step-up reauthorization governance 才不会继续停留在：

`它能说主体现在已经够格，却没人正式决定刚才那件事现在还算不算同一件事继续。`
