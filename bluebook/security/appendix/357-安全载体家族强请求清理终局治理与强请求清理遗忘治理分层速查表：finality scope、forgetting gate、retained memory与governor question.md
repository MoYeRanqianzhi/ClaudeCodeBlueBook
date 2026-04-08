# 安全载体家族强请求清理终局治理与强请求清理遗忘治理分层速查表：finality scope、forgetting gate、retained memory与governor question

## 1. 这一页服务于什么

这一页服务于
[373-安全载体家族强请求清理终局治理与强请求清理遗忘治理分层](../373-安全载体家族强请求清理终局治理与强请求清理遗忘治理分层.md)。

如果 `373` 的长文解释的是：

`为什么 continued stronger cleanup request 的 stronger finality 仍不等于 related old-request identity 现在已经可以安全遗忘，`

那么这一页只做一件事：

`把 repo 里现成的 stronger-request finality scope / stronger-request forgetting gate 正例，与 stronger-request cleanup 线当前仍缺的 forgetting grammar，压成一张矩阵。`

## 2. 强请求清理终局治理与强请求清理遗忘治理分层矩阵

| line | stronger-request finality scope | stronger-request forgetting gate | positive control | cleanup forgetting gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| resolved tool-use retention | finality may already have been reached, but duplicate echoes can still arrive | retain handled `tool_use_id` so duplicates are ignored rather than reprocessed | `resolvedToolUseIds` | stronger-request cleanup line has no explicit retained identity memory after stronger-request finality | who decides when a final stronger cleanup request is still too risky to forget because duplicate echoes may arrive | `structuredIO.ts:149-186` |
| pending-ledger close vs retained dedupe memory | request can leave the live pending ledger | still track resolved ID before deleting pending request or rejecting abort path | `trackResolvedToolUseId()` before delete/reject | stronger-request cleanup line has no explicit split between closing the live ledger and authorizing forgetting | who decides when closing the live stronger cleanup request ledger is still not enough to forget the request identity | `structuredIO.ts:283-289,374-400,497-501` |
| bounded eviction | finality alone does not trigger instant oblivion | forgetting happens only through bounded oldest-entry eviction | `MAX_RESOLVED_TOOL_USE_IDS` + oldest eviction | stronger-request cleanup line has no explicit bounded-memory eviction policy for final stronger cleanup requests | who decides how long final stronger cleanup request identities must be remembered before safe eviction | `structuredIO.ts:130-133,176-183` |
| orphaned permission dedupe | final request truth may already be settled in transcript | handled orphaned IDs are retained to block duplicate replay into current world | `handledOrphanedToolUseIds` | stronger-request cleanup line has no explicit duplicate-orphan suppression memory after finality | who decides whether an orphaned echo after final stronger cleanup still needs anti-replay memory instead of immediate forgetting | `print.ts:2764-2778,5241-5301` |
| transcript-resolved guard | finality already exists in a stronger reader surface | forgetting is still denied if the transcript says the tool_use was already resolved | `already resolved in transcript` | stronger-request cleanup line has no explicit “final elsewhere, still not safe to forget here” rule | who decides when final truth in one reader surface still requires retained guards in another surface | `print.ts:5279-5283` |
| stronger-request cleanup current gap | future-readable truth question is now visible | no explicit cleanup forgetting grammar yet | old path / promise / receipt world still lack formal retained-memory owner, eviction law, and anti-replay forgetting threshold | current line still cannot formally answer when final stronger cleanup truth is also safe enough to evict | who decides whether a final stronger cleanup request is only trustworthy later, or also harmless enough to forget now | current cleanup line evidence set |

## 3. 五个最重要的判断问题

判断一句
“continued stronger cleanup request 已经 final 了，所以等于已经可以忘掉”
有没有越级，
先问五句：

1. 这里回答的是 future-readable truth，还是 safe-to-evict old-request memory
2. duplicate / orphan / replay 风险是否已经单独被降到足够低
3. 当前系统有没有明写 retained identity memory 与 bounded eviction policy，而不是把 forgetting 偷写成 finality 的自动副作用
4. transcript 已 resolved 时，当前 surface 是否仍需保留 anti-replay guard
5. 这里关闭的是 live ledger，还是 retained dedupe memory

## 4. 最常见的六类误读

| 误读 | 实际问题 |
| --- | --- |
| “已经 final 了，所以相关 request ID 就该立刻删掉” | finality != forgetting |
| “pending request 都删掉了，所以系统已经不必再记住它” | ledger close != safe forgetting |
| “future-readable 了，所以 duplicate echo 已经不危险” | readable truth != replay-risk elimination |
| “bounded retention 只是实现细节，不是治理层” | eviction policy is part of forgetting governance |
| “orphaned response 只是异常路径，不影响主边界” | orphan suppression proves old-world echoes still matter after finality |
| “已经处理过一次，所以以后不再需要 retained guard” | handled once != safe to forget forever |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup forgetting grammar 不是：

`continued stronger cleanup request is final -> therefore forget related request identity immediately`

而是：

`continued stronger cleanup request is final -> keep retained anti-duplicate memory -> split live-ledger close from memory close -> block duplicate/orphan replay -> evict only under a bounded forgetting policy -> only then allow forgetting`

只有中间这些层被补上，
stronger-request cleanup finality governance 才不会继续停留在：

`它能决定 continued stronger cleanup request 以后回来时仍然成立，却没人正式决定与它相关的 old request identity 什么时候已经安全到可以忘掉。`
