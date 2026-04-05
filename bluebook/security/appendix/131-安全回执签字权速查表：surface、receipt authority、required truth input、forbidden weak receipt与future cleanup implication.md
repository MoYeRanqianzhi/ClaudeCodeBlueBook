# 安全回执签字权速查表：surface、receipt authority、required truth input、forbidden weak receipt与future cleanup implication

## 1. 这一页服务于什么

这一页服务于 [147-安全回执签字权：为什么receipt只能由持有pending ledger、schema context与lifecycle closure的signer签发](../147-安全回执签字权：为什么receipt只能由持有pending%20ledger、schema%20context与lifecycle%20closure的signer签发.md)。

如果 `147` 的长文解释的是：

`为什么不是任何看到 response 的层都配宣布 receipt 成立，`

那么这一页只做一件事：

`把 surface、receipt authority、required truth input、forbidden weak receipt 与 future cleanup implication 压成一张矩阵。`

## 2. 回执签字矩阵

| surface | receipt authority | required truth input | forbidden weak receipt | future cleanup implication | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| `StructuredIO.pendingRequests` owner | live request existence signer | `request_id` live-ness、abort state、pending ledger | 只看到 response arrival 就宣布签收 | cleanup signer 未来必须拥有 pending cleanup ledger，而不是只监听 event stream | `structuredIO.ts:135-158,510-529` |
| `control_response` handler | admissibility signer | `request_id` match、`success/error` subtype、optional `schema.parse()` | 只靠 matching key，不做 grammar acceptance | cleanup receipt 未来也应绑定 subtype schema 与 parse boundary | `structuredIO.ts:362-429` |
| lifecycle closer | closure-effect signer | command `uuid`、pending deletion、resolve/reject result | resolve promise 了却不关闭 lifecycle | cleanup receipt 未来也应显式区分 receipt 与 lifecycle close | `structuredIO.ts:362-429`; `structuredIO.ts:367-373` |
| stale prompt teardown callback | stale-world withdrawal signer | resolved `request_id`、can-use-tool subtype、bridge stale prompt context | 弱 UI 自己擦 prompt，冒充 stronger signer 已签收 | cleanup signer 一旦 receipt 成立，也应同步撤掉 stale weak surfaces | `structuredIO.ts:323-330,401-409` |
| completion notification channel | completion signer | `elicitation_id`、server completion notification、system event emit | 把 response 误当整个流程已完成 | cleanup future design 可能需要独立 `*_complete` 通道，而不只是一条同步 response | `print.ts:1357-1379` |
| orphan reconciler | compensating handoff signer，不是 original receipt signer | `toolUseID`、transcript unresolved lookup、duplicate guard | orphan observer 直接伪造正式 signed receipt | orphaned cleanup receipt 未来也应走 compensating path，而不是弱层直接改口 | `structuredIO.ts:374-399`; `print.ts:5238-5305` |

## 3. 最短判断公式

判断某层是不是合法 receipt signer，先问四句：

1. 它有没有 live pending truth
2. 它有没有 subtype / schema admissibility truth
3. 它有没有 lifecycle close power
4. 它有没有 stale-world teardown power

只要缺其中任意一项，  
它就最多只是：

`receipt observer`

而不是：

`receipt signer`

## 4. 最常见的四类误读

| 误读 | 实际问题 |
| --- | --- |
| “我先看到了 response，所以我配宣布签收” | arrival 不等于 live request truth |
| “request_id 对上了就算签收” | matching 不等于 schema admissibility |
| “promise resolve 就够了” | 没有 lifecycle close 与 stale teardown 仍是假闭环 |
| “orphan 被重新看见了，就算正式回执补齐” | orphan reconciliation 是补偿性路径，不是原始 receipt sovereignty |

## 5. 一条硬结论

真正的 receipt sovereignty 不是：

`谁先看到回执。`

而是：

`谁同时掌握活单、语法与闭环后果。`
