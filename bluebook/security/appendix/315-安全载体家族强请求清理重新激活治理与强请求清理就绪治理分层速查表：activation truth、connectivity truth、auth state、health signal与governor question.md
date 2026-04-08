# 安全载体家族强请求清理重新激活治理与强请求清理就绪治理分层速查表：activation truth、connectivity truth、auth state、health signal与governor question

## 1. 这一页服务于什么

这一页服务于 [331-安全载体家族强请求清理重新激活治理与强请求清理就绪治理分层：为什么artifact-family cleanup stronger-request cleanup-reactivation-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-readiness-governor signer](../331-安全载体家族强请求清理重新激活治理与强请求清理就绪治理分层.md)。

如果 `331` 的长文解释的是：

`为什么“对象已经被重新接进 current world”仍不等于“对象当前真的 ready for use”，`

那么这一页只做一件事：

`把 activation truth、connectivity truth、auth state、health signal 与 stronger-request cleanup current gap 压成一张矩阵。`

## 2. 强请求清理重新激活治理与强请求清理就绪治理分层矩阵

| positive control / cleanup current gap | activation truth | readiness / connectivity truth | health / auth signal | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| MCP connection state machine | object is present in current world | object may still be `connected / pending / needs-auth / failed / disabled` | typed state itself is the first readiness signal | who decides whether a reactivated cleanup object is actually usable now | `types.ts:179-226` |
| plugin reconnect path | `/reload-plugins` reseeds current world | new clients re-enter `pending` before they can become connected | pending is explicit, not hidden | who decides that reactivated cleanup truth must re-pass readiness rather than auto-inherit it | `useManageMCPConnections.ts:140-153,765-853` |
| explicit enable path | object is re-admitted | enable still goes through `pending -> reconnect` | explicit operator intent still not enough for ready proof | who decides that “come back” is weaker than “ready now” | `useManageMCPConnections.ts:1109-1123` |
| user-facing readiness grammar | active object is visible in UI / CLI | status stays split into `connected / pending / needs-auth / failed / disabled` | `/mcp` and notifications surface health/auth failure separately | who decides what non-ready truth must remain visible instead of being hidden behind activation success | `useMcpConnectivityStatus.tsx:25-80`; `ManagePlugins.tsx:513-519`; `mcp.tsx:26-35` |
| downstream consumer gate | object is active in session | tool can consume only when `client.type === 'connected'` and capability exists | hard gate rejects weaker facts | who decides when reactivated cleanup truth is strong enough for downstream readers and tools | `ReadMcpResourceTool.ts:78-95` |
| runtime revocation | object was active and once connected | runtime may demote it to `needs-auth` | new evidence rewrites ready verdict | who governs post-activation trust once runtime proof says “not ready anymore” | `toolExecution.ts:1599-1628` |
| stronger-request cleanup current gap | reactivation question is now visible | no explicit cleanup readiness grammar yet | old path / promise / receipt world still lack formal ready/not-ready surface and consumer gate | who decides whether returned cleanup truth may be safely consumed now rather than merely being active | current cleanup line evidence set |

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
