# 安全载体家族强请求清理重新激活治理与强请求清理就绪治理分层速查表：activation truth、readiness state、consumer gate、runtime revocation与governor question

## 1. 这一页服务于什么

这一页服务于 [426-安全载体家族强请求清理重新激活治理与强请求清理就绪治理分层](../426-安全载体家族强请求清理重新激活治理与强请求清理就绪治理分层.md)。

如果 `426` 的长文解释的是：

`为什么“对象已经接管 current world”仍不等于“对象当前真的 ready for use”，`

那么这一页只做一件事：

`把 activation truth、readiness state、consumer gate、runtime revocation 与 stronger-request cleanup current gap 压成一张矩阵。`

## 2. 强请求清理重新激活治理与强请求清理就绪治理分层矩阵

| positive control / cleanup current gap | activation truth | readiness state / consumer gate | runtime revocation / surface honesty | cleanup current gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| MCP connection state machine | object is already in current world | object may still be `connected / failed / needs-auth / pending / disabled` | typed state itself is the first readiness truth | stronger-request cleanup has no explicit ready-state machine yet | who decides whether a reactivated cleanup object is actually usable now | `src/services/mcp/types.ts:179-226` |
| plugin reconnect path | `/reload-plugins` reseeds current world | new clients re-enter `pending` before they can become connected | pending stays explicit instead of hidden | stronger-request cleanup has no pending-after-reactivation law | who decides that returned cleanup truth must re-pass readiness rather than inherit it | `src/services/mcp/useManageMCPConnections.ts:149-153,765-853` |
| explicit enable path | operator re-admits object into lifecycle | enable still goes through `pending -> reconnect` | operator intent remains weaker than proof | stronger-request cleanup has no explicit enable-to-ready adjudication path | who decides that “come back” is weaker than “ready now” | `src/services/mcp/useManageMCPConnections.ts:1109-1123` |
| user-facing readiness grammar | active object is visible in UI / CLI | status stays split into `connected / pending / needs-auth / failed / disabled` | `/mcp` and notifications continue surfacing failure/auth truth | stronger-request cleanup has no ready / not-ready surface grammar | who decides what non-ready truth must remain visible instead of being hidden behind activation success | `src/hooks/notifs/useMcpConnectivityStatus.tsx:25-63`; `src/commands/plugin/ManagePlugins.tsx:513-519`; `src/cli/handlers/mcp.tsx:26-35` |
| downstream consumer gate | object is already active in session | tool may consume only when `client.type === 'connected'` and capability exists | hard gate rejects weaker facts | stronger-request cleanup has no consumer hard gate for returned carriers | who decides when reactivated cleanup truth is strong enough for downstream readers and tools | `src/tools/ReadMcpResourceTool/ReadMcpResourceTool.ts:78-95` |
| runtime revocation | object was once active and connected | runtime may demote it to `needs-auth` | new evidence rewrites old ready verdict | stronger-request cleanup has no runtime revocation grammar yet | who governs post-activation trust once runtime proof says “not ready anymore” | `src/services/tools/toolExecution.ts:1599-1628` |

## 3. 三个最重要的判断问题

判断一句

`既然旧 stronger-request truth 已经重新接管当前世界，所以它现在一定能继续被消费`

有没有越级，先问三句：

1. 这里说的是 `activation truth`，还是 `readiness truth`
2. 当前对象只是已经 visible，还是已经给出了 consumer gate 能接受的 stronger fact
3. 这里给出的只是 reload / takeover summary，还是已经给出 runtime 仍未撤销的 current ready verdict

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| `对象回来了，所以现在一定 ready` | active != ready |
| `pending 只是过场，不算制度事实` | pending is a formal readiness state |
| `用户显式 enable 了，所以系统应立刻相信它` | operator intent != runtime proof |
| `用户看见对象了，所以 reader 可以继续用它` | visibility != consumability |
| `刚刚 reload 成功，所以能力证明也自动成立` | takeover summary != capability proof |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup readiness grammar 不是：

`truth entered current world -> therefore consumer may use it`

而是：

`truth entered current world -> readiness state adjudicated -> non-ready truth surfaced -> consumer gate enforced -> runtime revocation allowed`

只有这些层被补上，
stronger-request cleanup reactivation-governance 才不会继续停留在：

`系统已经知道怎样让对象接管 current world，却没人正式决定它接管之后此刻到底配不配被继续消费。`
