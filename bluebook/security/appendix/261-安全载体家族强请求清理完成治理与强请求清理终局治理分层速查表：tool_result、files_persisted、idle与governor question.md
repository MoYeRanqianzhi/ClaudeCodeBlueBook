# 安全载体家族强请求清理完成治理与强请求清理终局治理分层速查表：tool_result、files_persisted、idle与governor question

## 1. 这一页服务于什么

这一页服务于 [277-安全载体家族强请求清理完成治理与强请求清理终局治理分层：为什么artifact-family cleanup stronger-request completion-governor signer不能越级冒充artifact-family cleanup stronger-request finality-governor signer](../277-安全载体家族强请求清理完成治理与强请求清理终局治理分层.md)。

如果 `277` 的长文解释的是：

`为什么“continued stronger cleanup request 当前已经完成”仍不等于“这份完成以后回来时仍然成立”，`

那么这一页只做一件事：

`把 repo 里现成的 current completion / stronger finality 正例，与 stronger-request cleanup 线当前仍缺的 finality grammar，压成一张矩阵。`

## 2. 强请求清理完成治理与终局治理分层矩阵

| line | stronger-request completion decision | stronger-request finality decision | positive control | cleanup finality gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| current message result | decide the continued request has produced a result in the current message flow | do not yet decide transcript/effect persistence or future readability | `addToolResult()` | stronger-request cleanup line has no explicit boundary between current completion and future-readable truth | who decides whether a completed stronger cleanup result is merely present now, or durable for later readers | `toolExecution.ts:1403-1475` |
| effect persistence | decide some completion has already happened and side effects now need a separate persistence receipt | decide which files persisted and which failed | `files_persisted` event | stronger-request cleanup line has no explicit persistence receipt beyond current completion | who decides whether a completed stronger cleanup request has crossed from current result to persisted effect | `print.ts:2252-2272`; `coreSchemas.ts:1672-1690` |
| authoritative turn-over | decide current run has completed enough to enter final flush choreography | decide the turn is authoritatively over only after held-back/internal events flush | `session_state_changed('idle')` | stronger-request cleanup line has no explicit authoritative turn-over signal after completion | who decides when completed stronger cleanup work is truly over for downstream readers | `print.ts:2455-2468`; `coreSchemas.ts:1735-1746`; `sdkEventQueue.ts:60-90` |
| delivery drain | decide pending client events should be flushed | explicitly refuse to equate delivery confirmation with server-state finality | `CCRClient.flush()` disclaimer | stronger-request cleanup line has no explicit guard against mistaking transport drain for finality | who decides whether “delivered” is still weaker than “settled” for completed stronger cleanup work | `ccrClient.ts:826-838` |
| future-readable restoration | current completion has already happened earlier | decide whether later readback can restore the same truth after writeback | `state_restored` after concurrent GET | stronger-request cleanup line has no explicit future-readback evidence for completed stronger cleanup requests | who decides whether a completed stronger cleanup request is still true when revisited later | `ccrClient.ts:514-523` |

## 3. 四个最重要的判断问题

判断一句“continued stronger cleanup request 既然已经 completed，所以也就 final 了”有没有越级，先问四句：

1. 这里回答的是 current-run completion，还是已经回答 future-readable settled truth
2. 这里说的是 `tool_result` / `completed`，还是 `files_persisted` / `idle` / readback evidence
3. 这里有没有明确拒绝把 delivery confirmation 冒充成 state finality
4. 这里有没有 future reader 回来后仍可复验的更强证据

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “消息里已有 tool_result，所以以后回来也一定还能当真” | current completion != future-readable finality |
| “completed progress 已经发了，所以 persistence / turn-over 都自动成立” | completed != persisted and handed over |
| “flush 完了，所以世界状态已经 final” | delivery confirmation != state finality |
| “这轮 run 结束了，所以以后读回不会再变” | current-run done != future-readable settled truth |
| “一次完成就自动获得未来仍真地位” | completion != finality |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup finality grammar 不是：

`continued stronger cleanup request completed -> therefore treat it as future-readable settled truth`

而是：

`continued stronger cleanup request completed -> persist effects separately -> flush held-back/internal events -> emit authoritative turn-over -> refuse delivery illusions -> verify future-readable restoration`

只有中间这些层被补上，
stronger-request cleanup completion governance 才不会继续停留在：

`它能决定 continued stronger cleanup request 当前已经完成，却没人正式决定这份完成以后回来时是否仍配被当成 settled truth。`
