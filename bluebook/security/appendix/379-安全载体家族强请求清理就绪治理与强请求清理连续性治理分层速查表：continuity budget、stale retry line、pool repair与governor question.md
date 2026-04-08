# 安全载体家族强请求清理就绪治理与强请求清理连续性治理分层速查表：continuity budget、stale retry line、pool repair与governor question

## 1. 这一页服务于什么

这一页服务于 [395-安全载体家族强请求清理就绪治理与强请求清理连续性治理分层](../395-安全载体家族强请求清理就绪治理与强请求清理连续性治理分层.md)。

如果 `395` 的长文解释的是：

`为什么“对象此刻已经 ready for use”仍不等于“这份可用性接下来会继续成立”，`

那么这一页只做一件事：

`把 continuity budget、stale retry line、operator control、runtime downgrade、pool repair 与 stronger-request cleanup current gap 压成一张矩阵。`

## 2. 强请求清理就绪治理与强请求清理连续性治理分层矩阵

| positive control / cleanup current gap | readiness decision | continuity decision | time-axis mechanism / operator control | cleanup current gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| disconnect after current readiness | decide whether client is currently `connected / pending / needs-auth / failed / disabled` | decide whether to keep retrying, how long to back off, and when to give up | `MAX_RECONNECT_ATTEMPTS` + exponential backoff + `pending` retry state + final give-up | stronger-request cleanup has no explicit retry / give-up budget after readiness breaks | who decides whether a restored cleanup truth should keep fighting to stay usable after it falls out of readiness | `useManageMCPConnections.ts:88-90,333-464` |
| reload and stale continuity cleanup | decide which current clients are newly pending vs currently disabled | decide which old retry line must be revoked because current world has changed | stale reconnect timer cleanup + stale connected cleanup + `/reload-plugins` reseed | stronger-request cleanup has no explicit stale-line revocation grammar | who revokes stale cleanup continuity attempts so old worlds cannot impersonate current truth | `useManageMCPConnections.ts:765-853` |
| operator intervention | decide current object is disabled, pending, or connected | decide whether a human-triggered reconnect restarts continuity, and whether disable should stop all pending retries | `reconnectMcpServer()` cancel-and-retry + `toggleMcpServer()` disable cancel / enable pending reconnect | stronger-request cleanup has no explicit stop / restart continuity authority | who is allowed to stop trying, retry again, or restart continuity after ready truth breaks | `useManageMCPConnections.ts:1043-1123` |
| runtime degradation | decide current ready truth has fallen to `needs-auth` | decide whether degraded truth waits for re-auth, re-enters continuity attempts, or exits usable service | `connected -> needs-auth` downgrade on `McpAuthError` | stronger-request cleanup has no explicit runtime downgrade continuity path | who governs a once-ready cleanup truth after runtime evidence proves it is no longer safely usable | `services/tools/toolExecution.ts:1599-1628` |
| SDK client pool | decide whether individual SDK clients are still pending or failed | decide whether the current SDK usable pool must be re-initialized to restore continuity | `hasPendingSdkClients` / `hasFailedSdkClients` trigger `setupSdkMcpClients()` re-init | stronger-request cleanup has no pool-level repair grammar yet | who decides when continuity failure is no longer local and requires rebuilding the whole usable pool | `print.ts:1392-1426` |
| downstream consumption | decide whether consumer may read now | refuse to let one successful current read impersonate a temporal continuity promise | `ReadMcpResourceTool` connected hard gate | stronger-request cleanup has no distinction between current readability and temporal dependability | who decides when returned cleanup truth is only readable now versus continuously dependable over time | `ReadMcpResourceTool.ts:78-95` |

## 3. 三个最重要的判断问题

判断一句“既然旧 stronger-request truth 现在已经 ready，所以它当然会继续稳定可用”有没有越级，先问三句：

1. 这里说的是 current-time readiness，还是已经明确回答 ready truth 断掉之后怎样继续、暂停或终止
2. 这里处理的是单个对象当前能不能被消费，还是整个 usable world 怎样跨时间继续成立
3. 如果 ready truth 会被运行时新证据撤销，那么谁来决定它之后是重连、重建、等待，还是正式放弃

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “当前 connected，所以连续性已经成立” | readiness != continuity |
| “auto-reconnect 只是实现细节” | retry budget and give-up semantics are explicit governance |
| “旧 retry line 留着也无所谓” | stale continuity line can impersonate current truth |
| “manual reconnect 只是按钮，不算制度主权” | operator stop/restart semantics are part of continuity authority |
| “当前一次读成功，就说明之后还能持续读” | one current read is not a temporal continuity guarantee |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup continuity grammar 不是：

`current object is ready -> temporal continuity is assumed`

而是：

`current object is ready -> watch for disconnect/degrade -> decide retry/backoff/give-up/reseed/re-init -> keep or revoke usable continuity over time`

只有中间这些层被补上，
stronger-request cleanup readiness governance 才不会继续停留在：

`系统已经知道旧 truth 现在能不能用，却没人正式决定这种可用性在时间里如何继续成立。`
