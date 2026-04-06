# 安全载体家族强请求清理重新激活治理与强请求清理就绪治理分层速查表：state machine、consumer gate、runtime revocation与governor question

## 1. 这一页服务于什么

这一页服务于 [235-安全载体家族强请求清理重新激活治理与强请求清理就绪治理分层：为什么artifact-family cleanup stronger-request cleanup-reactivation-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-readiness-governor signer](../235-安全载体家族强请求清理重新激活治理与强请求清理就绪治理分层.md)。

如果 `235` 的长文解释的是：

`为什么“新的 truth 已接进 current active world”仍不等于“这个当前世界现在真的 ready for use”，`

那么这一页只做一件事：

`把 state machine、consumer gate、runtime revocation 与 stronger-request cleanup current gap 压成一张矩阵。`

## 2. 强请求清理重新激活治理与强请求清理就绪治理分层矩阵

| positive control / cleanup current gap | active-world fact | readiness state / gate | runtime revocation / consumer effect | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| MCP object in current world | client already exists in active world | `connected / pending / needs-auth / failed / disabled` | non-ready states remain first-class | who decides whether returned cleanup truth is usable rather than merely present | `types.ts:179-203` |
| reactivation-triggered reconnect | `/reload-plugins` already restarted lifecycle | new client still starts `pending` | readiness must be re-adjudicated after activation | who decides when stronger-request cleanup active truth stops being merely activated and becomes ready | `useManageMCPConnections.ts:149-153,765-853` |
| surface-level readiness grammar | object already visible on notification/UI/CLI | `failed / needs-auth / pending / connected` remain separate | stale active world is not overclaimed as usable | who decides how current cleanup world exposes not-ready truth to readers | `useMcpConnectivityStatus.tsx:25-63`; `ManagePlugins.tsx:512-519`; `handlers/mcp.tsx:26-35` |
| downstream consumer gate | active truth already exists | tool accepts only `connected` + capability-present | non-ready truth is rejected at consumption boundary | who decides whether downstream cleanup readers may consume returned truth now | `ReadMcpResourceTool.ts:78-95` |
| runtime downgrade | object may have been connected once | readiness can drop to `needs-auth` | ready truth is revocable in-use | who decides when a once-ready cleanup truth must stop being consumable | `toolExecution.ts:1599-1628` |
| explicit enable path | active object reappears after toggle | enable still starts at `pending` rather than `connected` | readiness remains future-determined | who decides whether explicit reactivation may skip readiness adjudication | `useManageMCPConnections.ts:1109-1123` |
| stronger-request cleanup current gap | reactivation question is now visible | no explicit readiness grammar yet | old path / promise / receipt world still lack formal ready-for-use adjudication | who decides whether returned cleanup truth is actually consumable now | current cleanup line evidence set |

## 3. 三个最重要的判断问题

判断一句
“既然旧 stronger-request truth 已经重新接入当前世界，所以它现在当然可以继续用了”
有没有越级，
先问三句：

1. 这里说的是 `active-world fact`，还是 `readiness state`
2. 当前下游 consumer 是否真的只接受 ready truth
3. 这个 ready verdict 会不会被运行时新证据撤销

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “对象在 current world 里，所以已经 ready” | present != ready |
| “pending 也差不多能用了” | pending != consumable |
| “reload 过一次，所以一直 ready” | active swap != lasting readiness |
| “UI 看到它了，所以 tool 可以安全消费” | visible != downstream-safe |
| “之前 connected 过一次，所以现在也还是 connected” | ready truth is revocable |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup readiness grammar 不是：

`truth entered current world -> therefore truth is usable`

而是：

`truth entered current world -> readiness state adjudicated -> consumer gate enforced -> runtime revocation governed`

只有这些层被补上，
stronger-request cleanup reactivation-governance 才不会继续停留在：

`系统已经知道新的 truth 何时接入当前世界，却没人正式决定它现在到底能不能被继续使用。`
