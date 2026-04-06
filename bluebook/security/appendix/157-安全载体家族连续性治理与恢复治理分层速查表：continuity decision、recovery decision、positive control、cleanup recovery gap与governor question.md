# 安全载体家族连续性治理与恢复治理分层速查表：continuity decision、recovery decision、positive control、cleanup recovery gap与governor question

## 1. 这一页服务于什么

这一页服务于 [173-安全载体家族连续性治理与恢复治理分层：为什么artifact-family cleanup continuity-governor signer不能越级冒充artifact-family cleanup recovery-governor signer](../173-安全载体家族连续性治理与恢复治理分层：为什么artifact-family%20cleanup%20continuity-governor%20signer不能越级冒充artifact-family%20cleanup%20recovery-governor%20signer.md)。

如果 `173` 的长文解释的是：

`为什么决定旧的可用性线还要不要继续，与决定什么新的证据足以重新宣布对象已经恢复，仍然是两层治理主权，`

那么这一页只做一件事：

`把 repo 里现成的 continuity decision / recovery decision 正例，与 cleanup 线当前仍缺的 recovery grammar，压成一张矩阵。`

## 2. 连续性治理与恢复治理分层矩阵

| line | continuity decision | recovery decision | positive control | cleanup recovery gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| remote auth failure | decide old usable line is no longer self-healing and must fall out of continuity | decide new credential proof is now required before restored truth may re-enter | `UnauthorizedError -> needs-auth` + auth cache + `createMcpAuthTool()` fallback | cleanup line has no explicit grammar for “continuity broke, now fresh proof is required” | who decides a broken cleanup line must stop pretending to recover itself and wait for new evidence | `client.ts:1079-1137,2301-2334` |
| reconnect pipeline | decide whether a retry/reconnect should be attempted again | decide whether fresh credentials, fresh cache invalidation, and a new `connected` result are enough to count as restored usable truth | `clearKeychainCache()` + `clearServerCache()` + only-`connected` fetch of tools/commands/resources | cleanup line has no explicit rule for what fresh source-of-truth is required before saying “recovered” | who signs recovery after a cleanup object is retried with new state and new credentials | `client.ts:2137-2163` |
| auth flow | decide continuity cannot proceed on old credentials | decide whether auth URL, callback, token exchange, and post-auth reconnect have all closed the loop | `performMCPOAuthFlow()` + silent/interactive re-auth split + callback/state validation | cleanup line has no explicit recovery pipeline for new proof collection after continuity failure | who decides a cleanup object has enough new authorization evidence to re-enter usable service | `auth.ts:578-616,930-1040,1581-1614,1755-1778` |
| control-plane recovery | decide operator-triggered retry/enable starts a new attempt line | decide whether control message can report success only after actual recovered connection result | `mcp_reconnect` / `mcp_toggle` send success only on `connected` | cleanup line has no explicit operator-facing contract distinguishing “retry started” from “recovery complete” | who decides what user-facing control surface may truthfully say “recovered” | `print.ts:3133-3204,3206-3295` |
| auth callback vs restored service | decide auth phase is still in progress or continuity is waiting on new evidence | decide whether auth completion alone is enough, or reconnect/world reinsertion must still happen | `mcp_authenticate` + `mcp_oauth_callback_url` split auth-only promise from reconnect path | cleanup line has no explicit distinction between “callback accepted” and “service restored” | who stops callback/auth events from impersonating recovered cleanup truth | `print.ts:3310-3455,3463-3505` |
| consumer recovery surface | decide recovery is still pending, still needs auth, or still failed | decide when real tools or success messages may be handed back to the consumer | `McpAuthTool` background reconnect + `MCPReconnect` connected-only success branch | cleanup line has no explicit consumer-side recovery verdict for when old artifacts may be treated as restored | who decides when restored cleanup truth is ready to be returned to downstream consumers as recovered | `McpAuthTool.ts:37-47,115-165`; `MCPReconnect.tsx:30-63` |

## 3. 三个最重要的判断问题

判断一句“cleanup continuity 已经完整”有没有越级，先问三句：

1. 这里回答的只是旧线还要不要继续，还是已经回答什么新的凭据和新连接结果足以宣布恢复成立
2. 当前看到的是 retry/auth started/callback arrived，还是已经拿到了新的 `connected` 与 tool/world restoration truth
3. 如果 auth phase 和 reconnect phase 被拆开了，那么谁配签 `recovered`，谁只配签 `recovering`

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “系统还在 retry，所以它其实已经恢复了” | continuity != recovery |
| “拿到 auth URL 就说明马上能用了” | auth start is not recovery verdict |
| “callback 回来了，所以对象已经恢复” | callback completion != reconnect completion |
| “重新连过一次，所以世界已经恢复” | attempt != restored truth |
| “真实工具很快就会回来，所以现在可以按 recovered 写” | consumer promise still needs explicit recovery gate |

## 5. 一条硬结论

真正成熟的 recovery grammar 不是：

`continuity broke -> start retry/auth flow -> recovered truth is assumed`

而是：

`continuity broke -> gather fresh credential proof -> run fresh reconnect -> verify connected result -> swap tools/world back in -> only then sign recovered truth`

只有中间这些层被补上，
cleanup continuity governance 才不会继续停留在：

`它能说对象还在恢复，却没人正式决定它到底什么时候已经恢复。`
