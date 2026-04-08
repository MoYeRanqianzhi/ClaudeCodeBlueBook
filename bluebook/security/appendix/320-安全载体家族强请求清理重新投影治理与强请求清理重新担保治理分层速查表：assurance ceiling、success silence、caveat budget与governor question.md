# 安全载体家族强请求清理重新投影治理与强请求清理重新担保治理分层速查表：assurance ceiling、success silence、caveat budget与governor question

## 1. 这一页服务于什么

这一页服务于
[336-安全载体家族强请求清理重新投影治理与强请求清理重新担保治理分层](../336-安全载体家族强请求清理重新投影治理与强请求清理重新担保治理分层.md)。

如果 `336` 的长文解释的是：

`为什么“对象已经被正确重讲”仍不等于“这些重讲已经足以承载继续依赖”，`

那么这一页只做一件事：

`把 assurance ceiling、success silence、caveat budget、proof gate 与 stronger-request cleanup current gap 压成一张矩阵。`

## 2. 强请求清理重新投影治理与强请求清理重新担保治理分层矩阵

| reassurance surface / cleanup current gap | reprojection decision | reassurance decision | assurance / caveat mechanism | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| auth guidance | decide how auth story should be narrated to tool users | decide whether that narration may promise automatic availability, tentative availability, or only manual recovery | `will become available automatically` / `should now be available` / `authenticate manually` | who decides how strong a positive auth sentence may be before it becomes overclaim | `McpAuthTool.ts:60,105,187,195,202` |
| auth-complete menu | decide how auth completion is re-told to menu readers | decide how much caveat must remain after upstream success | `Connected / Reconnected / still requires authentication / reconnection failed` | who decides whether auth success may be upgraded, caveated, or held below all-clear | `MCPRemoteServerMenu.tsx:103-107,281-288` |
| reconnect dialog | decide how one-shot reconnect result is narrated to the operator | decide whether that narration is only operation-local reassurance or something stronger | `Successfully reconnected` vs auth/failure copy | who decides the scope limit of reassurance after one repair operation succeeds | `MCPReconnect.tsx:45-61` |
| health surface | decide how current truth is compressed for probe readers | decide the maximum reassurance that glyph-level health may safely provide | `✓ Connected / ! Needs authentication / ✗ Failed to connect` | who decides the reassurance ceiling of health-only readers | `handlers/mcp.tsx:30-34` |
| notification publication | decide which truths deserve proactive publication | decide whether positive silence is safer than symmetric success reassurance | only negative notifications for `failed / needs-auth` | who decides which readers should not receive explicit positive reassurance even when truth improved | `useMcpConnectivityStatus.tsx:25-63` |
| control auth response | decide how control readers are told auth flow state | decide whether control plane may offer all-clear or only action-state reassurance | `requiresUserAction: true/false` on success envelope | who decides whether control success still carries user-action uncertainty | `print.ts:3360-3366` |
| callback / proof gate | decide how callback path is represented to control and auth surfaces | decide whether positive reassurance may stand only after proof passes validation | invalid callback rejection, `authPromise` wait, `state mismatch`, `No silent fallback` | who decides what proof must exist before positive reassurance may be emitted | `print.ts:3481-3505`; `auth.ts:864-875,1082,1116` |
| stronger-request cleanup current gap | reprojection question is now visible | no explicit reassurance grammar yet | old path / promise / receipt world still lack formal assurance ceiling, caveat budget, success silence and proof-gated positive-signal governance | who decides which cleanup retellings may actually carry dependence-bearing reassurance | current cleanup line evidence set |

## 3. 三个最重要的判断问题

判断一句
“旧 stronger-request truth 既然已经被某个 surface 正向讲出来，所以现在当然可以放心继续依赖”
有没有越级，
先问三句：

1. 这里回答的是 current truth 该怎样重讲，还是已经回答这句重讲现在配承载多强依赖
2. 当前看到的是 success 句子，还是已经看到 proof gate 关闭、caveat budget 清空、scope discipline 明确成立
3. 如果某些 surface 故意保持 success silence、只回 `requiresUserAction`、或保留 manual restart caveat，这是不是正说明系统在克制 reassurance liability

## 4. 最常见的六类误读

| 误读 | 实际问题 |
| --- | --- |
| “讲出来了，所以就能放心依赖了” | reprojection != reassurance |
| “Authentication successful 就等于 all clear” | upstream success still needs caveat governance |
| “Successfully reconnected 就代表系统完全恢复” | operation-local reassurance != global reassurance |
| “`✓ Connected` 就等于所有后续依赖都安全” | narrow probe reassurance != dependence-safe guarantee |
| “没有 success toast 就说明系统没处理好” | positive silence can be an honest reassurance policy |
| “control response success 就表示完全不用再验证” | generic success can still encode action-state uncertainty or proof-not-yet-finished truth |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup reassurance grammar 不是：

`truth has been positively retold -> dependence-bearing reassurance is assumed`

而是：

`truth has been retold -> inspect reader -> inspect scope -> inspect caveat budget -> inspect proof gate -> decide whether this retelling may carry reassurance at all`

只有中间这些层被补上，
stronger-request cleanup reprojection governance 才不会继续停留在：

`它能说当前真相该怎样被讲出来，却没人正式决定这些讲述里哪些现在配承载继续依赖。`
