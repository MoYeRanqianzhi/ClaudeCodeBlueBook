# 安全载体家族强请求清理重新投影治理与强请求清理重新担保治理分层速查表：assurance ceiling、success silence、caveat budget与governor question

## 1. 这一页服务于什么

这一页服务于 [463-安全载体家族强请求清理重新投影治理与强请求清理重新担保治理分层](../463-安全载体家族强请求清理重新投影治理与强请求清理重新担保治理分层.md)。

如果 `463` 的长文解释的是：

`为什么 current truth 即便已经被不同 surface 重新讲述，也还不能自动升级成“现在可以放心继续依赖”的更强担保，`

那么这一页只做一件事：

`把 assurance ceiling、success silence、caveat budget 与 stronger-request cleanup current gap 压成一张矩阵。`

## 2. 强请求清理重新投影治理与强请求清理重新担保治理分层矩阵

| positive control / cleanup current gap | reprojection decision | reassurance decision | assurance mechanism | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| tool description / auth-url guidance | decide how auth path should be explained to tool users | decide whether guidance may promise automatic availability, and how strong that promise may be | `McpAuthTool` description + auth-url message | who decides whether a repair path may be described as automatically restoring usable truth | `tools/McpAuthTool/McpAuthTool.ts:55-60,182-191` |
| silent-auth result | decide silent auth completion should be surfaced | decide whether surface may say `should now be available` rather than stronger all-clear | `McpAuthTool` silent-auth message | who decides when post-repair success is only tentative reassurance rather than definitive availability | `tools/McpAuthTool/McpAuthTool.ts:193-196` |
| auth-complete interactive menu | decide how auth completion should be retold to interactive users | decide whether auth success can be upgraded to `Connected`, or must retain `still requires authentication` / `manual restart` caveats | `MCPRemoteServerMenu` auth-complete branching | who decides when upstream success still requires a weaker, caveated assurance surface | `components/mcp/MCPRemoteServerMenu.tsx:95-107,277-288` |
| reconnect dialog | decide how one-shot reconnect result should be narrated | decide whether this surface may issue only operation-local reassurance rather than system-wide reassurance | `MCPReconnect` success/auth/failure copy | who decides the scope limit of reassurance after one repair operation succeeds | `components/mcp/MCPReconnect.tsx:40-63` |
| health CLI | decide how current probe truth should be shown to health readers | decide that probe readers get narrow glyph reassurance, not future-wide guarantees | `/mcp` health glyph grammar | who decides what a health-check surface may imply and what it must not imply | `cli/handlers/mcp.tsx:26-35` |
| notification surface | decide which truths deserve proactive publication | decide that negative states are published while positive all-clear can remain silent | `useMcpConnectivityStatus()` selective negative notifications | who decides when silence is more honest than broadcasting positive reassurance | `hooks/notifs/useMcpConnectivityStatus.tsx:25-63` |
| stronger-request cleanup current gap | reprojection question is now visible | no explicit reassurance grammar yet | old path / promise / receipt world still lack formal graded-positive-lexicon and publication-ceiling governance | who decides which restored cleanup statements may carry local reassurance, which may carry broader reassurance, and which must stay silent | current cleanup line evidence set |

## 3. 三个最重要的判断问题

判断一句“cleanup reassurance 已经足够强”有没有越级，先问三句：

1. 这里回答的只是 current truth 被怎样重讲，还是已经回答用户现在可以背负多大的继续依赖
2. 当前 surface 说的是 narrow probe truth、operation-local truth，还是更强的 cross-surface all-clear
3. 当前正向句子有没有保留必要 caveat，或者 repo 此刻更诚实的动作其实是保持对称沉默

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “既然 truth 已经重讲出来，就等于可以放心继续依赖” | reprojection != reassurance |
| “Authentication successful 就等于所有后续 consumer 都恢复好了” | auth-success retelling != stronger all-clear |
| “`✓ Connected` 就说明没有任何后续人工动作了” | probe reassurance != global reassurance |
| “某次 reconnect 成功就说明全系统都已经重新稳定” | operation-local reassurance != durable system-wide reassurance |
| “没看到 warning/toast，就说明系统已经正式宣布成功” | selective silence can be a safer reassurance policy than positive publication |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup reassurance grammar 不是：

`current truth has been reprojected -> every positive surface may speak with the same strength`

而是：

`current truth has been reprojected -> choose reader scope -> choose operation scope -> choose caveat budget -> choose whether to publish -> then decide the reassurance ceiling`

只有中间这些层被补上，
stronger-request cleanup reprojection governance 才不会继续停留在：

`它能说 current truth 是什么，却没人正式决定哪些句子现在配承载多强的继续依赖担保。`
