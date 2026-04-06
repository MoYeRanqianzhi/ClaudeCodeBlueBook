# 安全载体家族强请求终局治理与强请求遗忘治理分层速查表：stronger-request finality scope、stronger-request forgetting gate、positive control、cleanup forgetting gap与governor question

## 1. 这一页服务于什么

这一页服务于 [182-安全载体家族强请求终局治理与强请求遗忘治理分层：为什么artifact-family cleanup stronger-request finality-governor signer不能越级冒充artifact-family cleanup stronger-request forgetting-governor signer](../182-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E5%BC%BA%E8%AF%B7%E6%B1%82%E7%BB%88%E5%B1%80%E6%B2%BB%E7%90%86%E4%B8%8E%E5%BC%BA%E8%AF%B7%E6%B1%82%E9%81%97%E5%BF%98%E6%B2%BB%E7%90%86%E5%88%86%E5%B1%82%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88artifact-family%20cleanup%20stronger-request%20finality-governor%20signer%E4%B8%8D%E8%83%BD%E8%B6%8A%E7%BA%A7%E5%86%92%E5%85%85artifact-family%20cleanup%20stronger-request%20forgetting-governor%20signer.md)。

如果 `182` 的长文解释的是：

`为什么 resumed stronger request 的 stronger finality 仍不等于 related old-request identity 现在已经可以安全遗忘，`

那么这一页只做一件事：

`把 repo 里现成的 stronger-request finality scope / stronger-request forgetting gate 正例，与 cleanup 线当前仍缺的 forgetting grammar，压成一张矩阵。`

## 2. 强请求终局治理与强请求遗忘治理分层矩阵

| line | stronger-request finality scope | stronger-request forgetting gate | positive control | cleanup forgetting gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| resolved tool-use retention | finality may already have been reached, but duplicate echoes can still arrive | retain handled `tool_use_id` so duplicates are ignored rather than reprocessed | `resolvedToolUseIds` | cleanup line has no explicit retained identity memory after stronger-request finality | who decides when a final stronger cleanup request is still too risky to forget because duplicate echoes may arrive | `structuredIO.ts:145-183` |
| pending-ledger close vs retained dedupe memory | request can leave the live pending ledger | still track resolved ID before deleting pending request or rejecting abort path | `trackResolvedToolUseId()` before delete/reject | cleanup line has no explicit split between closing the live ledger and authorizing forgetting | who decides when closing the live stronger cleanup request ledger is still not enough to forget the request identity | `structuredIO.ts:286-289,374-401,497-501` |
| bounded eviction | finality alone does not trigger instant oblivion | forgetting happens only through bounded oldest-entry eviction | `MAX_RESOLVED_TOOL_USE_IDS` + oldest eviction | cleanup line has no explicit bounded-memory eviction policy for final stronger cleanup requests | who decides how long final stronger cleanup request identities must be remembered before safe eviction | `structuredIO.ts:133-183` |
| orphaned permission dedupe | final request truth may already be settled in transcript | handled orphaned IDs are retained to block duplicate replay into current world | `handledToolUseIds` | cleanup line has no explicit duplicate-orphan suppression memory after finality | who decides whether an orphaned echo after final stronger cleanup still needs anti-replay memory instead of immediate forgetting | `print.ts:5238-5305` |
| transcript-resolved guard | finality already exists in a stronger reader surface | forgetting is still denied if the transcript says the tool_use was already resolved | `already resolved in transcript` | cleanup line has no explicit “final elsewhere, still not safe to forget here” rule | who decides when final truth in one reader surface still requires retained guards in another surface | `print.ts:5278-5283` |

## 3. 三个最重要的判断问题

判断一句“resumed stronger request 已经 final 了，所以等于已经可以忘掉”有没有越级，先问三句：

1. 这里回答的是 future-readable truth，还是 safe-to-evict old-request memory
2. duplicate / orphan / replay 风险是否已经单独被降到足够低
3. 当前系统有没有明写 retained identity memory 与 bounded eviction policy，而不是把 forgetting 偷写成 finality 的自动副作用

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “已经 final 了，所以相关 request ID 就该立刻删掉” | finality != forgetting |
| “pending request 都删掉了，所以系统已经不必再记住它” | ledger close != safe forgetting |
| “future-readable 了，所以 duplicate echo 已经不危险” | readable truth != replay-risk elimination |
| “bounded retention 只是实现细节，不是治理层” | eviction policy is part of forgetting governance |
| “orphaned response 只是异常路径，不影响主边界” | orphan suppression proves old-world echoes still matter after finality |

## 5. 一条硬结论

真正成熟的 stronger-request forgetting grammar 不是：

`resumed stronger request is final -> therefore forget related request identity immediately`

而是：

`resumed stronger request is final -> keep retained anti-duplicate memory -> block duplicate/orphan replay -> evict only under a bounded forgetting policy -> only then allow forgetting`

只有中间这些层被补上，
cleanup stronger-request finality governance 才不会继续停留在：

`它能决定 resumed stronger request 以后回来时仍然成立，却没人正式决定与它相关的 old request identity 什么时候已经安全到可以忘掉。`
