# 安全载体家族强请求清理重新投影治理与强请求清理重新担保治理分层速查表：assurance ceiling、success silence、requiresUserAction与governor question

## 1. 这一页服务于什么

这一页服务于
[304-安全载体家族强请求清理重新投影治理与强请求清理重新担保治理分层](../304-安全载体家族强请求清理重新投影治理与强请求清理重新担保治理分层.md)。

如果 `304` 的长文解释的是：

`为什么“对象已经被正确重讲”仍不等于“这些讲述已经足以承载继续依赖”，`

那么这一页只做一件事：

`把 assurance ceiling、success silence、requiresUserAction、manual caveat 与 stronger-request cleanup current gap 压成一张矩阵。`

## 2. 强请求清理重新投影治理与强请求清理重新担保治理分层矩阵

| positive control / cleanup current gap | reprojection decision | reassurance decision | assurance-ceiling mechanism | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| auth guidance | decide how auth story should be narrated to the user/model | decide whether that narration is stronger guidance, tentative reassurance, or manual-fallback only | `will become available automatically` vs `should now be available` vs `authenticate manually` | who decides how strong a positive auth statement may be before it becomes overclaim | `McpAuthTool.ts:57-60,182-202` |
| auth-complete menu branching | decide how auth completion is re-told to menu readers | decide whether auth success may be upgraded to all-clear, or must retain restart/auth caveats | `Authentication successful` branches into `Connected / Reconnected / still requires authentication / reconnection failed` | who decides whether upstream success facts still need caveat budget before readers may rely on them | `MCPRemoteServerMenu.tsx:92-117,270-289` |
| reconnect dialog | decide how reconnect result is narrated to the operator | decide whether operation-local success is merely local reassurance or stronger global reassurance | `Successfully reconnected` vs auth/failure copy | who decides how much reassurance a single reconnect operation may carry | `MCPReconnect.tsx:40-63` |
| health surface | decide how current truth is compressed for health readers | decide the maximum reassurance health glyphs may safely provide | `✓ Connected / ! Needs authentication / ✗ Failed to connect` | who decides the reassurance ceiling of health-only readers | `handlers/mcp.tsx:26-35` |
| notification publication | decide which truths are proactively published | decide whether positive silence is safer than symmetric success reassurance | only negative notifications for `failed / needs-auth` | who decides which readers should not receive explicit positive reassurance even when truth improved | `useMcpConnectivityStatus.tsx:25-63` |
| control auth response | decide how control readers are told auth flow state | decide whether control plane may give all-clear or only weaker action-state reassurance | `requiresUserAction: true/false` on success envelope | who decides whether control readers should hear “take action”, “auth completed”, or a stronger assurance claim | `print.ts:2736-2760,3339-3367` |
| callback / proof gate | decide how callback path is represented to control/auth surfaces | decide whether reassurance may be emitted only after proof passes validation | invalid callback rejection, authPromise wait, state mismatch hard-fail, no silent fallback | who decides what proof must exist before any positive reassurance can stand | `print.ts:3480-3505`; `auth.ts:864-875,1054-1092,1109-1139` |
| stronger-request cleanup current gap | reprojection question is now visible | no explicit reassurance grammar yet | old path / promise / receipt world still lack formal assurance ceiling, caveat budget, success silence, and proof-gated positive signal governance | who decides which positive retellings may actually carry dependence-bearing reassurance | current cleanup line evidence set |

## 3. 三个最重要的判断问题

判断一句
“旧 stronger-request truth 既然已经被某个 surface 正向讲出来，所以现在当然可以放心继续依赖”
有没有越级，
先问三句：

1. 这里说的是 current truth 已经被重讲，还是已经回答这句重讲现在配承载多强的依赖负荷
2. 当前看到的是局部 surface 的 positive wording，还是已经看到 system-wide reassurance signer
3. 如果某些 surface 故意不发 success toast、只回 `requiresUserAction` 或保留 manual restart caveat，这是不是正说明系统在克制 reassurance liability

## 4. 最常见的六类误读

| 误读 | 实际问题 |
| --- | --- |
| “讲出来了，所以就能放心依赖了” | reprojection != reassurance |
| “Authentication successful 就等于 all clear” | upstream success still needs caveat governance |
| “Successfully reconnected 就代表系统完全恢复” | operation-local success != global reassurance |
| “✓ Connected 就等于所有后续依赖都安全” | narrow probe reassurance != dependence-safe guarantee |
| “没有 success toast 就说明系统没处理好” | positive silence can be an honest reassurance policy |
| “control response success 就代表完全没后续动作了” | generic success can still encode `requiresUserAction` or proof-gated uncertainty |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup reassurance grammar 不是：

`truth has been positively retold -> dependence-bearing reassurance is assumed`

而是：

`truth has been retold -> inspect reader -> inspect scope -> inspect caveat budget -> inspect proof gate -> decide whether this retelling may carry reassurance at all`

只有中间这些层被补上，
stronger-request cleanup reprojection governance 才不会继续停留在：

`它能说当前真相该怎样被讲出来，却没人正式决定这些讲述里哪些现在配承载继续依赖。`
