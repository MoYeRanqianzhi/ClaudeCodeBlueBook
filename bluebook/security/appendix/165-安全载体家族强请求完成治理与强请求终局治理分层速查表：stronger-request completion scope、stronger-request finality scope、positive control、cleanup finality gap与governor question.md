# 安全载体家族强请求完成治理与强请求终局治理分层速查表：stronger-request completion scope、stronger-request finality scope、positive control、cleanup finality gap与governor question

## 1. 这一页服务于什么

这一页服务于 [181-安全载体家族强请求完成治理与强请求终局治理分层：为什么artifact-family cleanup stronger-request completion-governor signer不能越级冒充artifact-family cleanup stronger-request finality-governor signer](../181-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E5%BC%BA%E8%AF%B7%E6%B1%82%E5%AE%8C%E6%88%90%E6%B2%BB%E7%90%86%E4%B8%8E%E5%BC%BA%E8%AF%B7%E6%B1%82%E7%BB%88%E5%B1%80%E6%B2%BB%E7%90%86%E5%88%86%E5%B1%82%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88artifact-family%20cleanup%20stronger-request%20completion-governor%20signer%E4%B8%8D%E8%83%BD%E8%B6%8A%E7%BA%A7%E5%86%92%E5%85%85artifact-family%20cleanup%20stronger-request%20finality-governor%20signer.md)。

如果 `181` 的长文解释的是：

`为什么 resumed stronger request 的 current completion 仍不等于它的 future-readable finality，`

那么这一页只做一件事：

`把 repo 里现成的 stronger-request completion scope / stronger-request finality scope 正例，与 cleanup 线当前仍缺的 finality grammar，压成一张矩阵。`

## 2. 强请求完成治理与强请求终局治理分层矩阵

| line | stronger-request completion scope | stronger-request finality scope | positive control | cleanup finality gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| message-level tool result | decide the resumed stronger request has produced a current result in the active message stream | does not yet decide transcript/effect persistence or future readability | `addToolResult()` -> `createUserMessage(...)` | cleanup line has no explicit split between current resumed-request result and stronger future-readable truth | who decides whether a resumed stronger cleanup request is merely complete in the current message stream, or actually final for future readers | `toolExecution.ts:1403-1475` |
| effect persistence | current completion already exists before this layer runs | decide whether the relevant effects are persisted and emit `files_persisted` | `system/files_persisted` | cleanup line has no explicit effect-persistence signer after resumed stronger-request completion | who decides whether resumed stronger cleanup effects are durably persisted rather than merely reported complete | `print.ts:2238-2275`; `coreSchemas.ts:1671-1689` |
| authoritative turn-over | current result is already known | decide whether the turn is authoritatively over after internal-event flush | `flushInternalEvents()` -> `session_state_changed(idle)` | cleanup line has no explicit authoritative turn-over signal for resumed stronger cleanup work | who decides when resumed stronger cleanup completion has crossed the turn-over boundary | `print.ts:2455-2468`; `coreSchemas.ts:1739-1748`; `sdkEventQueue.ts:60-90` |
| transport drain | current completion may already have been emitted | explicitly refuse to equate queue drain with settled server truth | `flush()` disclaimer | cleanup line has no explicit guard against delivery confirmation impersonating finality | who decides whether resumed stronger cleanup truth is merely delivered, or actually settled | `ccrClient.ts:826-838` |
| future-readable restoration | current completion and transport delivery have already happened | decide whether the truth can later be read back as restored state | `state_restored` after readback | cleanup line has no explicit future-readable readback signer for resumed stronger cleanup completion | who decides whether a completed stronger cleanup request is still true when a future reader comes back | `ccrClient.ts:514-523` |

## 3. 三个最重要的判断问题

判断一句“resumed stronger request 已经完成，所以等于已经终局了”有没有越级，先问三句：

1. 这里回答的只是 current result closure，还是已经回答 transcript/effect/readback finality
2. 这里出现的是 `tool_result` / `completed` 这类 current completion signal，还是 `files_persisted` / `idle` / `state_restored` 这类更强终局信号
3. 这里是不是把 `flush()` 一类 delivery confirmation 偷写成 settled truth

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “tool_result 已经出来了，所以一切都 final 了” | current completion != finality |
| “completed progress 已经发了，所以以后回来仍然成立” | completed now != future-readable truth |
| “队列已经 flush，所以状态就稳了” | delivery confirmation != settled state |
| “这轮 run 已经 idle，所以副作用一定都落地了” | authoritative turn-over != effect persistence |
| “当前完成一次，就等于未来永远可读回” | completion once != durable finality |

## 5. 一条硬结论

真正成熟的 stronger-request finality grammar 不是：

`resumed stronger request has a completion-grade result -> therefore treat it as final`

而是：

`resumed stronger request has a completion-grade result -> persist internal/effect truth -> emit authoritative turn-over -> refuse delivery illusion -> require future-readable readback evidence -> only then treat it as final`

只有中间这些层被补上，
cleanup stronger-request completion governance 才不会继续停留在：

`它能决定 resumed stronger request 当前已经完成，却没人正式决定这份完成以后回来时是否仍然成立。`
