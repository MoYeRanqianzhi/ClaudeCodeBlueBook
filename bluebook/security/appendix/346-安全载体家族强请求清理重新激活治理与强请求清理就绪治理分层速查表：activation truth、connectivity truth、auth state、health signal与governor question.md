# 安全载体家族强请求清理重新激活治理与强请求清理就绪治理分层速查表：activation truth、connectivity truth、auth state、health signal与governor question

## 1. 这一页服务于什么

这一页服务于 [362-安全载体家族强请求清理重新激活治理与强请求清理就绪治理分层](../362-安全载体家族强请求清理重新激活治理与强请求清理就绪治理分层.md)。

如果 `362` 的长文解释的是：

`为什么“对象已经被重新接进 current world”仍不等于“对象当前真的 ready for use”，`

那么这一页只做一件事：

`把 activation truth、connectivity truth、auth state、health signal 与 stronger-request cleanup current gap 压成一张矩阵。`

## 2. 强请求清理重新激活治理与强请求清理就绪治理分层矩阵

| positive control / cleanup current gap | activation truth | readiness / connectivity truth | health / auth signal | cleanup current gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| MCP connection state machine | object is present in current world | object may still be `connected / pending / needs-auth / failed / disabled` | typed state itself is the first readiness signal | stronger-request cleanup has no explicit ready-state machine yet | who decides whether a reactivated cleanup object is actually usable now | `types.ts:179-226` |
| plugin reconnect path | `/reload-plugins` reseeds current world | new clients re-enter `pending` before they can become connected | pending is explicit, not hidden | stronger-request cleanup has no explicit pending-after-reactivation rule | who decides that reactivated cleanup truth must re-pass readiness rather than auto-inherit it | `useManageMCPConnections.ts:140-153,765-853` |
| explicit enable path | object is re-admitted | enable still goes through `pending -> reconnect` | explicit operator intent still not enough for ready proof | stronger-request cleanup has no explicit enable-to-ready adjudication path | who decides that “come back” is weaker than “ready now” | `useManageMCPConnections.ts:1109-1123` |
| user-facing readiness grammar | active object is visible in UI / CLI | status stays split into `connected / pending / needs-auth / failed / disabled` | `/mcp` and notifications surface health/auth failure separately | stronger-request cleanup has no ready/not-ready surface grammar | who decides what non-ready truth must remain visible instead of being hidden behind activation success | `useMcpConnectivityStatus.tsx:25-80`; `ManagePlugins.tsx:513-519`; `mcp.tsx:26-35` |
| downstream consumer gate | object is active in session | tool can consume only when `client.type === 'connected'` and capability exists | hard gate rejects weaker facts | stronger-request cleanup has no consumer hard gate for returned carriers | who decides when reactivated cleanup truth is strong enough for downstream readers and tools | `ReadMcpResourceTool.ts:78-95` |
| runtime revocation | object was active and once connected | runtime may demote it to `needs-auth` | new evidence rewrites ready verdict | stronger-request cleanup has no runtime revocation grammar yet | who governs post-activation trust once runtime proof says “not ready anymore” | `toolExecution.ts:1599-1628` |

## 3. 三个最重要的判断问题

判断一句“既然旧 stronger-request truth 已经重新接进当前世界，所以它现在一定能用”有没有越级，先问三句：

1. 这里说的是 `activation truth`，还是 `readiness truth`
2. 当前对象只是已经 visible，还是已经 `connected`
3. 这里给出的只是 reload summary，还是已经给出 consumer gate 能接受的 capability proof

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “对象回来了，所以现在一定 ready” | active != ready |
| “pending 只是过场，不算制度事实” | pending is a formal readiness state |
| “用户能看见对象，所以 reader 可以继续用它” | visibility != consumability |
| “曾经 connected 过一次，所以现在仍可依赖” | connected-once != connected-now |
| “reload summary 就是 capability proof” | activation summary != consumer-ready proof |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup readiness grammar 不是：

`truth entered current world -> therefore consumer may use it`

而是：

`truth entered current world -> readiness state adjudicated -> health/auth failure surfaced -> consumer gate enforced -> runtime revocation handled`

只有这些层被补上，
stronger-request cleanup reactivation-governance 才不会继续停留在：

`系统已经知道怎样把对象接回 current world，却没人正式决定它回来之后此刻到底敢不敢继续被使用。`
