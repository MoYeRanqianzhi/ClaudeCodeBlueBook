# 安全载体家族重新激活治理与就绪治理分层速查表：reactivation decision、readiness decision、positive control、cleanup readiness gap与governor question

## 1. 这一页服务于什么

这一页服务于 [171-安全载体家族重新激活治理与就绪治理分层：为什么artifact-family cleanup reactivation-governor signer不能越级冒充artifact-family cleanup readiness-governor signer](../171-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E9%87%8D%E6%96%B0%E6%BF%80%E6%B4%BB%E6%B2%BB%E7%90%86%E4%B8%8E%E5%B0%B1%E7%BB%AA%E6%B2%BB%E7%90%86%E5%88%86%E5%B1%82%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88artifact-family%20cleanup%20reactivation-governor%20signer%E4%B8%8D%E8%83%BD%E8%B6%8A%E7%BA%A7%E5%86%92%E5%85%85artifact-family%20cleanup%20readiness-governor%20signer.md)。

如果 `171` 的长文解释的是：

`为什么决定新的 truth 何时接管 active world，与决定这个 active world 何时真正 ready for use，仍然是两层治理主权，`

那么这一页只做一件事：

`把 repo 里现成的 reactivation decision / readiness decision 正例，与 cleanup 线当前仍缺的 readiness grammar，压成一张矩阵。`

## 2. 重新激活治理与就绪治理分层矩阵

| line | reactivation decision | readiness decision | positive control | cleanup readiness gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| MCP client lifecycle | decide plugin reload should re-run connection management and seed clients into current world | decide whether each client is `connected / pending / needs-auth / failed / disabled` | `MCPServerConnection` union + `pluginReconnectKey` pending init | cleanup line has no explicit state machine for “already active but not yet usable” | who decides a restored cleanup object is merely active vs actually usable | `types.ts:162-203`; `useManageMCPConnections.ts:143-153,765-853` |
| interactive UI/status | decide current world should surface the reloaded object | decide whether UI should show activate, needs auth, failed, or connected truth | `useMcpConnectivityStatus()` + `getMcpStatus()` + `/mcp` health | cleanup line has no explicit surface for readiness degradation after activation | who signs readiness truth on user-facing surfaces after reactivation | `useMcpConnectivityStatus.tsx:25-63`; `ManagePlugins.tsx:512-519`; `handlers/mcp.tsx:26-35` |
| tool consumption | decide object is in current active world | decide whether a downstream tool may consume it | `ReadMcpResourceTool` requires `connected` | cleanup line has no explicit consumer gate for “active but not ready” artifacts | who decides when restored cleanup truth is strong enough for downstream consumption | `ReadMcpResourceTool.ts:78-95` |
| runtime downgrade | decide object was previously active | decide whether auth/runtime evidence revokes readiness now | `connected -> needs-auth` demotion on `McpAuthError` | cleanup line has no explicit rule for revoking readiness after reactivation | who governs readiness revocation when restored cleanup truth later proves unusable | `toolExecution.ts:1599-1628` |

## 3. 三个最重要的判断问题

判断一句“cleanup reactivation 已经完整”有没有越级，先问三句：

1. 这只是 reactivation decision，还是已经明确对象当前是否真正 ready for use
2. 当前 surface 看到的是 active truth，还是 already-connected / authenticated / consumable truth
3. 如果 readiness 会被运行时证据撤销，那么谁来决定它何时降级、何时恢复

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “已经 reload 了，所以现在当然能用” | reactivation != readiness |
| “pending 只是过渡，不算治理层” | pending is an explicit non-ready state |
| “needs-auth 只是提示，不影响当前 truth” | auth gap is a readiness failure |
| “工具面能看到对象，就能直接消费它” | consumer surfaces still require `connected` |
| “连通过一次就说明之后一直 ready” | readiness can be revoked at runtime |

## 5. 一条硬结论

真正成熟的 comeback grammar 不是：

`truth enters active world -> usable truth is assumed`

而是：

`truth enters active world -> run readiness state machine -> expose pending/auth/failure outcomes -> allow downstream consumption only on ready truth`

只有中间三层被补上，
cleanup reactivation governance 才不会继续停留在“知道新的 truth 已经接进当前世界，却没人正式决定它现在到底能不能被使用”的半治理状态。
