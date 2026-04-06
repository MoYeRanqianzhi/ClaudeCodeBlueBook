# 安全回执与完成分层速查表：surface、what it can sign、what it cannot sign、required stronger signal与future cleanup implication

## 1. 这一页服务于什么

这一页服务于 [148-安全回执与完成分层：为什么receipt signer不能越级冒充completion signer](../148-%E5%AE%89%E5%85%A8%E5%9B%9E%E6%89%A7%E4%B8%8E%E5%AE%8C%E6%88%90%E5%88%86%E5%B1%82%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88receipt%20signer%E4%B8%8D%E8%83%BD%E8%B6%8A%E7%BA%A7%E5%86%92%E5%85%85completion%20signer.md)。

如果 `148` 的长文解释的是：

`为什么 receipt、lifecycle close 与 semantic completion 必须分层签字，`

那么这一页只做一件事：

`把不同 surface 到底配签什么、不配签什么、缺哪条更强 signal 才能再上升一级，压成一张矩阵。`

## 2. 分层签字矩阵

| surface | what it can sign | what it cannot sign | required stronger signal | future cleanup implication | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| `control_response` receipt | request 被合法接单并 resolve/reject | full semantic completion | 独立 completion channel 或更强 semantic signer | cleanup future design 至少要把 `cleanup_receipted` 独立出来 | `structuredIO.ts:362-429` |
| lifecycle completed | command / operation 已退出在途状态 | 更大语义流程已结束 | semantic completion notification 或 authoritative reconciler | cleanup future design 还应区分 `cleanup_lifecycle_closed` | `structuredIO.ts:367-373`; `print.ts:1998-2012,2244-2250` |
| `elicitation_complete` notification | elicitation 流程 semantic completion | orphan/duplicate 语义世界天然已收净 | orphan reconciliation 或更高 audit finalization | cleanup future design 可能需要独立 `cleanup_completed` channel | `print.ts:1357-1379` |
| orphan reconciler | late/orphan signal 被补偿性接回语义路径 | original receipt signer 已签 full completion | stronger current-world signer 的最终 verdict | cleanup future design 可能还要单列 `cleanup_reconciled` | `structuredIO.ts:374-399`; `print.ts:5238-5305` |
| stale prompt teardown | 弱表面撤场 | 语义流程本身已完成 | 更强 signer 的 receipt / completion | cleanup signer 成立后应同步撤 stale weak surfaces，但这仍不等于 full complete | `structuredIO.ts:323-330,401-409` |

## 3. 最短判断公式

判断某条“完成”说法有没有越级，先问三句：

1. 当前 surface 签的是 receipt、lifecycle 还是 semantic completion
2. 它还缺哪条 stronger signal
3. 它现在说的话有没有超过自己的 ceiling

## 4. 最常见的四类误读

| 误读 | 实际问题 |
| --- | --- |
| “收到 success 就是完成” | 这只证明 receipt，不证明 semantic completion |
| “lifecycle completed 就是世界收口” | lifecycle close 不等于 full semantic close |
| “有 completion notification 就等于所有 orphan 都处理完了” | completion 与 reconciliation 仍可能分层 |
| “弱表面消失了，所以流程完成了” | stale teardown 只是后果写回，不是高层完成签字 |

## 5. 一条硬结论

真正成熟的 completion grammar 不是：

`一个完成词。`

而是：

`多层 signer 各自只说自己配说到的完成上限。`
