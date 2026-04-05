# 安全偏斜处置回执速查表：receipt surface、matching key、completion signal、orphan handling与cleanup receipt implication

## 1. 这一页服务于什么

这一页服务于 [146-安全偏斜处置回执协议：为什么handoff不等于闭环，强signer必须用request_id、completion notification与orphan reconciliation正式签收](../146-安全偏斜处置回执协议：为什么handoff不等于闭环，强signer必须用request_id、completion notification与orphan reconciliation正式签收.md)。

如果 `146` 的长文解释的是：

`为什么 handoff 之后还必须有 receipt / completion / reconciliation，`

那么这一页只做一件事：

`把 receipt surface、matching key、completion signal、orphan handling 与 cleanup receipt implication 压成一张矩阵。`

## 2. 回执矩阵

| receipt surface | matching key | completion signal | orphan handling | cleanup receipt implication | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| StructuredIO pending ledger | `request_id` | `resolve/reject` + request deletion | 未知 response 先走 duplicate check，再交 `unexpectedResponseCallback` | cleanup handoff 未来也应进入 pending cleanup ledger，而非 fire-and-forget | `structuredIO.ts:135-158,510-529`; `structuredIO.ts:374-399` |
| `control_response` receipt | `request_id` | `success/error` + `schema.parse()` + lifecycle completed | duplicate late responses 由 `resolvedToolUseIds` 吸收 | cleanup response 未来也应有正式 request/response schema 与 receipt closure | `structuredIO.ts:362-429` |
| bridge stale-prompt teardown | resolved `request_id` | `onControlRequestResolved` callback | 用于取消 claude.ai 上 stale permission prompt | cleanup signer 一旦签收，也应同步撤掉 stale weak surfaces | `structuredIO.ts:323-330,401-409` |
| elicitation completion | `elicitation_id` | `elicitation_complete` notification + system message | 不走 generic response，而是独立 completion channel | cleanup complete 未来可能更适合独立 notification signer | `print.ts:1357-1379` |
| orphaned permission reconciliation | `toolUseID` + transcript unresolved tool lookup | enqueue orphaned-permission for compensating handling | duplicate orphan reject + unresolved transcript search | orphaned cleanup receipt 未来也应尝试语义补偿，而不是直接丢弃 | `print.ts:5241-5303` |
| lifecycle observability | `uuid` | `notifyCommandLifecycle(started/completed)` | control_response 也会补 completed | cleanup receipt 未来也应有 started/completed 级 lifecycle hooks | `print.ts:2006-2008`; `print.ts:2248-2250`; `structuredIO.ts:367-373` |

## 3. 最短判断公式

判断一条 handoff 是否已经进入正式 receipt protocol，先问四句：

1. 有没有明确 matching key
2. 有没有明确 completion / error verdict
3. duplicate / orphan / late arrival 如何处理
4. 签收后会不会触发 stale weak-surface teardown

## 4. 最常见的四类误读

| 误读 | 实际问题 |
| --- | --- |
| “消息发出去了就算交接完成” | 这只证明 dispatch，不证明 receipt |
| “收到 success 就够了” | 某些流程还需要独立 completion notification |
| “账本里找不到就当垃圾” | orphan response 仍可能需要语义补偿接单 |
| “业务 promise resolve 就够了” | 没有 lifecycle receipt，控制台仍可能保持盲态 |

## 5. 一条硬结论

真正成熟的闭环不是：

`我把问题交给更强 signer。`

而是：

`更强 signer 用可匹配、可观测、可补偿的 receipt protocol 明确签收这次移交。`
