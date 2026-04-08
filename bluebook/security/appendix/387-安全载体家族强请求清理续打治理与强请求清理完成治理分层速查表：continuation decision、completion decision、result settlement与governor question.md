# 安全载体家族强请求清理续打治理与强请求清理完成治理分层速查表：continuation decision、completion decision、result settlement与governor question

## 1. 这一页服务于什么

这一页服务于 [403-安全载体家族强请求清理续打治理与强请求清理完成治理分层](../403-安全载体家族强请求清理续打治理与强请求清理完成治理分层.md)。

如果 `403` 的长文解释的是：

`为什么“旧 stronger cleanup request 现在仍配继续尝试”仍不等于“这条 stronger cleanup request 现在已经完成”，`

那么这一页只做一件事：

`把 repo 里现成的 continuation decision / completion decision 正例，与 stronger-request cleanup 线当前仍缺的 completion grammar，压成一张矩阵。`

## 2. 强请求清理续打治理与强请求清理完成治理分层矩阵

| line | stronger-request continuation decision | stronger-request completion decision | positive control | cleanup completion gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| URL elicitation retry loop | decide whether the same blocked tool call may loop back and try again | decide whether the flow ends as `could not complete` instead of a settled result | `retrying tool call` vs `could not complete` | stronger-request cleanup line has no explicit distinction between “may continue” and “request still not complete” for stronger cleanup actions | who decides whether a resumed stronger cleanup request has only re-entered execution, or has actually completed | `services/mcp/client.ts:2813-3024` |
| outer MCP progress path | decide to keep the same request alive across retry attempts | emit `status: 'completed'` only after `mcpResult` returns | started/completed progress split | stronger-request cleanup line has no explicit completion-grade progress signal after continuation | who decides when a resumed stronger cleanup request graduates from in-flight retry to completed request | `services/mcp/client.ts:1851-1889` |
| low-level MCP tool call | decide nothing about retry permission itself; it just receives the next attempt | settle the request as success/error and return normalized `content` only on success | `callMCPTool()` + `completed successfully` | stronger-request cleanup line has no explicit result-settlement owner after continuation succeeds | who decides when a continued stronger cleanup request has actually produced a completion-grade result | `services/mcp/client.ts:3029-3238` |
| result normalization | continuation grammar has already finished its job before this layer | decide how the successful result becomes `toolResult` / `structuredContent` / `contentArray` | `transformMCPResult()` | stronger-request cleanup line has no explicit normalized-result layer for stronger cleanup completion | who decides what the settled output of a completed stronger cleanup request looks like | `services/mcp/client.ts:2662-2690,2725` |
| representative tool result blocks | retry wording is absent because the request is no longer merely continuing | explicit success result blocks sign completion of the current request | `File created successfully` / `Task #... created successfully` | stronger-request cleanup line has no explicit success result signer for continued stronger cleanup requests | who decides when continued stronger cleanup work may speak in completion-grade language instead of retry-grade language | `tools/FileWriteTool/FileWriteTool.ts:424-430`; `tools/TaskCreateTool/TaskCreateTool.ts:135` |

## 3. 三个最重要的判断问题

判断一句“旧 stronger cleanup request 已经继续了，所以等于已经完成了”有没有越级，先问三句：

1. 这里回答的只是 retry permission，还是已经回答 result settlement
2. 这里说的是 `retrying tool call`、`may retry` 这种 continuation wording，还是 `completed` / `created successfully` 这种 completion wording
3. 这里有没有真正返回 completion-grade result，而不是仅仅解除阻塞并进入下一轮尝试

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “已经 retry 了，所以请求算做完了” | continuation != completion |
| “elicitation completed 了，所以 tool 也 completed 了” | intermediary completion != request completion |
| “用户已经 accept 继续，所以结果自然就落地了” | consent to continue != settled result |
| “工具重新开始跑了，所以成功已成定局” | resumed execution != completion |
| “工具重新 available 了，所以旧 stronger cleanup request 等于已经完成” | availability != request completion |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup completion grammar 不是：

`old stronger cleanup request may continue -> therefore treat the request as complete`

而是：

`old stronger cleanup request may continue -> continue execution -> observe success / error / could-not-complete -> emit completed progress or explicit result block -> only then treat the request as complete`

只有中间这些层被补上，
stronger-request cleanup continuation governance 才不会继续停留在：

`它能决定旧 stronger cleanup request 还能不能继续，却没人正式决定这条 stronger cleanup request 现在究竟已经完成，还是仍未完成。`
