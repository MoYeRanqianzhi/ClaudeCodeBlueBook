# 安全载体家族强请求清理重新投影治理与强请求清理重新担保治理分层速查表：assurance ceiling、caveat budget、success silence与governor question

## 1. 这一页服务于什么

这一页服务于 [431-安全载体家族强请求清理重新投影治理与强请求清理重新担保治理分层](../431-安全载体家族强请求清理重新投影治理与强请求清理重新担保治理分层.md)。

如果 `431` 的长文解释的是：

`为什么“对象已经被某个 surface 重讲出来”仍不等于“这句重讲已经配承载继续依赖的正向担保”，`

那么这一页只做一件事：

`把 assurance ceiling、caveat budget、success silence 与不同 surface 的正向词法上限压成一张矩阵。`

## 2. 强请求清理重新投影治理与强请求清理重新担保治理分层矩阵

| positive control / cleanup current gap | reprojection decision | reassurance decision | assurance ceiling / caveat mechanism | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| auth guidance | decide auth truth should be retold to the caller | decide whether guidance is only path-level help or already stronger reassurance | `will become available automatically` vs `should now be available` | who decides how strong a positive sentence may be after auth/reconnect progress | `src/tools/McpAuthTool/McpAuthTool.ts:55-60,182-195` |
| auth-complete branch | decide auth-complete result should be shown to the user | decide whether auth success may be followed by caveat rather than all-clear | `Authentication successful` + `still requires authentication` / `manual restart` / `reconnection failed` | who decides when upstream success still requires explicit caveat instead of strong reassurance | `src/components/mcp/MCPRemoteServerMenu.tsx:95-107,279-288` |
| reconnect dialog | decide reconnect outcome should be retold to the operator | decide whether this is only operation-local reassurance or broader system reassurance | `Successfully reconnected` / `requires authentication` / `Failed to reconnect` | who decides how far a local repair result may reassure the user | `src/components/mcp/MCPReconnect.tsx:40-63` |
| health probe | decide current truth should be compressed for health readers | decide whether health may only offer narrow probe reassurance | `✓ / ! / ✗` glyph grammar | who decides the reassurance ceiling for health-only readers | `src/cli/handlers/mcp.tsx:26-35` |
| notification surface | decide whether to publish a truth at all | decide whether positive silence is safer than explicit reassurance | publish only `failed / needs-auth`, suppress positive symmetry | who decides which positive truths should remain silent rather than over-promise | `src/hooks/notifs/useMcpConnectivityStatus.tsx:25-63` |
| control auth flow | decide auth/control facts should be emitted to SDK readers | decide whether `requiresUserAction` and callback success are weaker than stronger all-clear | `requiresUserAction: true/false` + callback success/error split | who decides how much reassurance a control-plane auth fact may carry | `src/cli/print.ts:3359-3367,3491-3505` |
| stronger-request cleanup current gap | reprojection question is now visible | no explicit reassurance grammar yet | old path / promise / receipt world still lack formal assurance-ceiling and silence policy governance | who decides how much current cleanup retelling may safely reassure downstream users | current cleanup line evidence set |

## 3. 三个最重要的判断问题

判断一句

`旧 stronger-request truth 既然已经被正向重讲，所以现在当然可以放心继续依赖`

有没有越级，先问三句：

1. 这里回答的是 retelling grammar，还是已经回答这句重讲现在配承载多强的依赖负荷
2. 当前看到的是 auth/reconnect 的局部正向词法，还是已经给出了没有 caveat 的更强 reassurance
3. 如果某些 surface 的最诚实动作是 success silence，那么谁在治理这种“故意不说好消息”的上限

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| `被正向重讲了，所以现在可以放心依赖` | retelling != reassurance |
| `Authentication successful` 自然等于 all-clear | upstream success still may need caveat |
| `Successfully reconnected` 就代表全系统恢复稳定 | operation-local reassurance != global reassurance |
| `✓ Connected` 足以承担全部担保责任 | narrow probe reassurance != broad dependence guarantee |
| `没有 success toast 就只是体验问题` | positive silence is a formal governance choice |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup reassurance grammar 不是：

`truth was retold positively -> stronger reassurance is assumed`

而是：

`truth was retold -> choose assurance ceiling -> preserve caveat budget -> decide whether to speak positively at all -> only then allocate dependence liability`

只有中间这些层被补上，
stronger-request cleanup reprojection governance 才不会继续停留在：

`它能说对象现在该怎样被重讲，却没人正式决定这些重讲里哪些现在敢被当真。`
