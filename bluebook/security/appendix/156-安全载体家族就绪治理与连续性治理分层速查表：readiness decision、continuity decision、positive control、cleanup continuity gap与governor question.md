# 安全载体家族就绪治理与连续性治理分层速查表：readiness decision、continuity decision、positive control、cleanup continuity gap与governor question

## 1. 这一页服务于什么

这一页服务于 [172-安全载体家族就绪治理与连续性治理分层：为什么artifact-family cleanup readiness-governor signer不能越级冒充artifact-family cleanup continuity-governor signer](../172-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E5%B0%B1%E7%BB%AA%E6%B2%BB%E7%90%86%E4%B8%8E%E8%BF%9E%E7%BB%AD%E6%80%A7%E6%B2%BB%E7%90%86%E5%88%86%E5%B1%82%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88artifact-family%20cleanup%20readiness-governor%20signer%E4%B8%8D%E8%83%BD%E8%B6%8A%E7%BA%A7%E5%86%92%E5%85%85artifact-family%20cleanup%20continuity-governor%20signer.md)。

如果 `172` 的长文解释的是：

`为什么决定对象现在能不能用，与决定这种可用性在断连、退化、重试和人工干预下怎样继续成立，仍然是两层治理主权，`

那么这一页只做一件事：

`把 repo 里现成的 readiness decision / continuity decision 正例，与 cleanup 线当前仍缺的 continuity grammar，压成一张矩阵。`

## 2. 就绪治理与连续性治理分层矩阵

| line | readiness decision | continuity decision | positive control | cleanup continuity gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| remote transport lifecycle | decide whether client is currently `connected / pending / needs-auth / failed` | decide whether to keep retrying after disconnect, how long to back off, and when to give up | `MAX_RECONNECT_ATTEMPTS` + exponential backoff + `pending` retry state + final give-up | cleanup line has no explicit grammar for “ready truth broke, keep trying or stop” | who decides whether a restored cleanup object should keep fighting to stay usable after it falls out of readiness | `useManageMCPConnections.ts:87-90,333-466` |
| reload and stale cleanup | decide which current clients are newly pending vs currently disabled | decide which old continuity attempts must be canceled because config/session truth has changed | stale reconnect timer cleanup + stale connected cleanup + `/reload-plugins` reseed | cleanup line has no explicit rule for canceling old continuity attempts when current truth is replaced | who revokes stale continuity attempts so old cleanup worlds cannot impersonate new ones | `useManageMCPConnections.ts:765-853` |
| operator intervention | decide current object is disabled, pending, or connected | decide whether a human-triggered reconnect restarts continuity, and whether disable should stop all pending retries | `reconnectMcpServer()` cancel-and-retry + `toggleMcpServer()` disable cancel / enable pending reconnect | cleanup line has no explicit operator control surface for continue, stop, or restart continuity | who is allowed to stop trying, retry again, or restart continuity after readiness breaks | `useManageMCPConnections.ts:1043-1123` |
| runtime degradation | decide current ready truth has fallen to `needs-auth` | decide whether degraded truth waits for re-auth, re-enters continuity attempts, or exits usable service | `connected -> needs-auth` downgrade on `McpAuthError` | cleanup line has no explicit rule for post-ready degradation and re-entry after runtime evidence revokes readiness | who governs a restored cleanup truth after runtime evidence proves it is no longer safely usable | `toolExecution.ts:1599-1628` |
| SDK client pool | decide whether individual SDK clients are still pending or failed | decide whether the current SDK usable pool must be re-initialized to restore continuity | `hasPendingSdkClients` / `hasFailedSdkClients` trigger `setupSdkMcpClients()` re-init | cleanup line has no pool-level continuity grammar for rebuilding usable current world after partial degradation | who decides when continuity failure is no longer local and requires rebuilding the whole usable pool | `print.ts:1392-1426` |
| downstream consumption | decide whether consumer may read now | refuse to let one successful current read impersonate a temporal continuity promise | `ReadMcpResourceTool` connected hard gate | cleanup line has no explicit distinction between “currently readable” and “continuously dependable” | who decides when restored cleanup truth is only readable now versus continuously dependable over time | `ReadMcpResourceTool.ts:78-95` |

## 3. 三个最重要的判断问题

判断一句“cleanup readiness 已经完整”有没有越级，先问三句：

1. 这只是 readiness decision，还是已经明确回答 ready truth 断掉之后怎样继续、暂停或终止
2. 这里处理的是对象当前能不能被消费，还是对象能否跨重试、重鉴权与时间流逝继续维持可消费性
3. 如果 ready truth 会被运行时证据撤销，那么谁来决定它之后是重连、重建、等待，还是正式放弃

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “当前 connected，所以连续性已经成立” | readiness != continuity |
| “auto-reconnect 只是实现细节” | retry budget and give-up semantics are explicit governance |
| “needs-auth 只是局部报错，不影响连续性判断” | readiness downgrade is exactly where continuity starts to matter |
| “手动 reconnect 只是按钮，不算治理层” | operator stop/restart semantics are part of continuity authority |
| “当前一次读成功，就说明之后还能持续读” | one current read is not a temporal continuity guarantee |

## 5. 一条硬结论

真正成熟的 comeback grammar 不是：

`current object is ready -> temporal continuity is assumed`

而是：

`current object is ready -> watch for disconnect/degrade -> decide retry/backoff/give-up/re-init -> keep or revoke usable continuity over time`

只有中间这些层被补上，
cleanup readiness governance 才不会继续停留在：

`它能说对象现在能用，却没人正式决定这种可用性在时间里如何继续成立。`
