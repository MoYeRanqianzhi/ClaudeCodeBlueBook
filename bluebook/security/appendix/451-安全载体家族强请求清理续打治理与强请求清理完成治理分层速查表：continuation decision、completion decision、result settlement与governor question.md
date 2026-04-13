# 安全载体家族强请求清理续打治理与强请求清理完成治理分层速查表：continuation decision、completion decision、result settlement与governor question

## 1. 这一页服务于什么

这一页服务于 [467-安全载体家族强请求清理续打治理与强请求清理完成治理分层](../467-安全载体家族强请求清理续打治理与强请求清理完成治理分层.md)。

如果 `467` 的长文解释的是：

`为什么旧 stronger cleanup request 即便已经被允许继续，也还不能自动回答它现在是否已经完成，`

那么这一页只做一件事：

`把 continuation decision、completion decision、result settlement 与 stronger-request cleanup current gap 压成一张矩阵。`

## 2. 强请求清理续打治理与强请求清理完成治理分层矩阵

| positive control / cleanup current gap | continuation decision | completion decision | result-settlement mechanism | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| URL elicitation retry loop | decide old blocked request may retry as the same call | decide decline/cancel may still end in non-completion rather than completion | `retrying tool call` vs `could not complete` split | who decides when same-request continuation still has not become request completion | `src/services/mcp/client.ts:2813-3025` |
| outer MCP execution path | decide the resumed call may keep running | decide `status: completed` is emitted only after `mcpResult` returns | started/completed progress split | who decides when resumed cleanup execution has actually crossed the completion boundary | `src/services/mcp/client.ts:1845-1895` |
| low-level tool call | decide the call continues into another attempt | decide success/error only after `client.callTool()` settles and result is processed | `completed successfully` + `processMCPResult()` | who decides when a resumed stronger cleanup request has a settled result rather than just another attempt | `src/services/mcp/client.ts:3029-3175` |
| result normalization | decide retry permission is already in place | decide what output shape now counts as settled completion-grade content | `transformMCPResult()` / `processMCPResult()` | who decides the shape of completion truth after the resumed call returns | `src/services/mcp/client.ts:2662-2725` |
| representative tool success block | decide the request no longer needs another retry | decide a concrete result owner may now speak success in a `tool_result` block | `FileWriteTool` / `TaskCreateTool` success mapping | who decides when the resumed request has become explicit success output rather than mere retry eligibility | `src/tools/FileWriteTool/FileWriteTool.ts:418-430`; `src/tools/TaskCreateTool/TaskCreateTool.ts:130-135` |
| stronger-request cleanup current gap | same-request continuation question is now visible | no explicit completion grammar yet | old path / promise / receipt world still lack formal completed-progress, settled-result and completion-result-signing governance | who decides when a resumed stronger cleanup request is truly complete rather than merely allowed to continue | current cleanup line evidence set |

## 3. 三个最重要的判断问题

判断一句

`既然旧 stronger cleanup request 现在已经继续了，所以它现在就算完成了`

有没有越级，先问三句：

1. 这里回答的是 retry permission，还是已经回答 result 是否真正返回并结算
2. 当前看到的是 `retrying tool call`，还是 `completed successfully` 与具体 result block
3. continuation path 里如果仍可能落到 `could not complete`，谁又有权宣布它已经完成

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| `既然已经 retry 了，所以请求已经完成` | retried != completed |
| `elicitation 完成就说明 tool call 完成` | elicitation completion != tool completion |
| `accept` 就代表旧请求已经结案 | accept != settled result |
| `connected / available` 就说明 resumed request done` | availability != result settlement |
| `有 success string 就等于 finality` | completion != finality |

## 5. 一条硬结论

真正成熟的 stronger-request completion grammar 不是：

`the blocked request may continue -> therefore it is complete`

而是：

`the blocked request may continue -> run the resumed call -> settle success/error/non-completion -> normalize result -> emit completion-grade progress/output`

只有中间这些层被补上，
stronger-request cleanup continuation governance 才不会继续停留在：

`它能决定这条旧请求还该不该再试，却没人正式决定这条继续后的请求现在究竟有没有完成。`
