# 安全载体家族强请求清理重新投影治理与强请求清理重新担保治理分层速查表：reader lease、positive lexicon、fallback discipline与governor question

## 1. 这一页服务于什么

这一页服务于 [367-安全载体家族强请求清理重新投影治理与强请求清理重新担保治理分层](../367-安全载体家族强请求清理重新投影治理与强请求清理重新担保治理分层.md)。

如果 `367` 的长文解释的是：

`为什么某个 surface 即便已经把 current truth 重新讲出来，也还不等于系统已经允许用户继续放心依赖，`

那么这一页只做一件事：

`把 reader lease、positive lexicon、fallback discipline 与 stronger-request cleanup current gap 压成一张矩阵。`

## 2. 强请求清理重新投影治理与强请求清理重新担保治理分层矩阵

| positive control / cleanup current gap | reprojection decision | reassurance decision | reassurance ceiling / fallback mechanism | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| graded auth tool wording | decide auth truth should be retold to tool readers | decide whether wording may promise future availability or only probable availability now | `will become available automatically` vs `should now be available` | who decides how strong a positive sentence may become before it over-signs future reliance | `McpAuthTool.ts:55-60,184-195` |
| auth-complete branch copy | decide auth result should be re-told in remote-server menu | decide whether `Authentication successful` may escalate to all-clear or must keep caveats | `Connected / Reconnected / still requires auth / reconnection failed / manual restart` branching | who decides whether auth-success retelling may carry stronger assurance or must remain caveated | `MCPRemoteServerMenu.tsx:95-107,279-288` |
| reconnect dialog | decide operation result should be re-told to the operator | decide whether operation-local success is enough for broader reassurance | `Successfully reconnected` vs auth / failure copy | who decides how far a local reconnect success may be generalized | `MCPReconnect.tsx:45-58` |
| health surface | decide current probe truth should be shown in `/mcp` | decide whether a narrow health glyph may stand for broad rely-safe reassurance | `✓ / ! / ✗` narrow glyph grammar | who decides the reassurance ceiling of a probe-only surface | `handlers/mcp.tsx:26-35` |
| selective publication | decide which negative truths deserve active publication | decide whether positive truths should remain silent to avoid over-promising | notifications only for `failed / needs-auth` | who decides when silence is safer than explicit positive assurance | `useMcpConnectivityStatus.tsx:25-63` |
| control proof gate | decide auth/reconnect progress should be reported to control readers | decide whether success payload may omit caveat, or must still expose `requiresUserAction` / proof gates | `requiresUserAction` bit + callback validation + success/error envelope | who decides whether a control success may already be relied on, or is still contingent on further proof | `print.ts:2736-2760,3358-3366,3478-3508`; `auth.ts:864-875,1082,1116` |
| stronger-request cleanup current gap | reprojection question is now visible | no explicit reassurance grammar yet | old path / promise / receipt world still lack formal assurance ceiling and positive-silence discipline | who decides how much dependence each cleanup retelling may legitimately carry | current cleanup line evidence set |

## 3. 三个最重要的判断问题

判断一句“旧 stronger-request truth 既然已经被讲出来，所以现在当然可以继续放心依赖”有没有越级，先问三句：

1. 这里回答的是怎样 retell current truth，还是已经回答这句 retelling 现在允许用户背负多大的继续依赖
2. 当前看到的是 operation-local success / auth-success / health success，还是已经拿到了 stronger all-clear
3. 如果系统刻意保留 caveat 或 success silence，为什么我还要把它误读成无条件 reassurance

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “已经被重新讲出来，所以当然可以继续依赖” | reprojection != reassurance |
| “Authentication successful 就等于 everything is fine” | auth-success retelling != strongest all-clear |
| “health 绿了，所以全局都放心” | probe reassurance != global reassurance |
| “局部 reconnect 成功，所以系统整体都担保了” | operation-local reassurance != system-wide reassurance |
| “没有 success toast 就说明没有正向结论” | positive silence can be a deliberate reassurance policy |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup reassurance grammar 不是：

`truth was re-told -> reader may safely rely`

而是：

`truth was re-told -> set assurance ceiling -> keep caveat where needed -> stay silent where stronger promise would over-sign`

只有中间这些层被补上，
stronger-request cleanup reprojection governance 才不会继续停留在：

`它能说对象已经被重新讲给你听，却没人正式决定这句讲述现在到底担保到什么程度。`
