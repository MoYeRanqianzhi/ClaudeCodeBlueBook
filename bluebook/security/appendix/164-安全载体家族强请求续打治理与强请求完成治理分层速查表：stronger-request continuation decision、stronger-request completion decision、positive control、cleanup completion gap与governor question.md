# 安全载体家族强请求续打治理与强请求完成治理分层速查表：stronger-request continuation decision、stronger-request completion decision、positive control、cleanup completion gap与governor question

## 1. 这一页服务于什么

这一页服务于 [180-安全载体家族强请求续打治理与强请求完成治理分层：为什么artifact-family cleanup stronger-request continuation-governor signer不能越级冒充artifact-family cleanup stronger-request completion-governor signer](../180-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E5%BC%BA%E8%AF%B7%E6%B1%82%E7%BB%AD%E6%89%93%E6%B2%BB%E7%90%86%E4%B8%8E%E5%BC%BA%E8%AF%B7%E6%B1%82%E5%AE%8C%E6%88%90%E6%B2%BB%E7%90%86%E5%88%86%E5%B1%82%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88artifact-family%20cleanup%20stronger-request%20continuation-governor%20signer%E4%B8%8D%E8%83%BD%E8%B6%8A%E7%BA%A7%E5%86%92%E5%85%85artifact-family%20cleanup%20stronger-request%20completion-governor%20signer.md)。

如果 `180` 的长文解释的是：

`为什么“旧 stronger request 现在仍配继续尝试”仍不等于“这条 stronger request 现在已经完成”，`

那么这一页只做一件事：

`把 repo 里现成的 continuation decision / completion decision 正例，与 cleanup 线当前仍缺的 completion grammar，压成一张矩阵。`

## 2. 强请求续打治理与强请求完成治理分层矩阵

| line | stronger-request continuation decision | stronger-request completion decision | positive control | cleanup completion gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| URL elicitation retry loop | decide whether the same blocked tool call may loop back and try again | decide whether the flow ends as `could not complete` instead of a settled result | `retrying tool call` vs `could not complete` | cleanup line has no explicit distinction between “may continue” and “request still not complete” for stronger cleanup actions | who decides whether a resumed stronger cleanup request has only re-entered execution, or has actually completed | `client.ts:2813-3024` |
| outer MCP progress path | decide to keep the same request alive across retry attempts | emit `status: 'completed'` only after `mcpResult` returns | started/completed progress split | cleanup line has no explicit completion-grade progress signal after stronger-request continuation | who decides when a resumed stronger cleanup request graduates from in-flight retry to completed request | `client.ts:1838-1895` |
| low-level MCP tool call | decide nothing about retry permission itself; it just receives the next attempt | settle the request as success/error and return normalized `content` only on success | `callMCPTool()` + `completed successfully` | cleanup line has no explicit result-settlement owner after continuation succeeds | who decides when a continued stronger cleanup request has actually produced a completion-grade result | `client.ts:3029-3238` |
| result normalization | continuation grammar has already finished its job before this layer | decide how the successful result becomes `toolResult` / `structuredContent` / `contentArray` | `transformMCPResult()` | cleanup line has no explicit normalized-result layer for stronger cleanup completion | who decides what the settled output of a completed stronger cleanup request looks like | `client.ts:2628-2718` |
| representative tool result blocks | retry wording is absent because the request is no longer merely continuing | explicit success result blocks sign completion of the current request | `File created successfully` / `Task #... created successfully` | cleanup line has no explicit success result signer for resumed stronger cleanup requests | who decides when resumed stronger cleanup work may speak in completion-grade language instead of retry-grade language | `FileWriteTool.ts:424-430`; `TaskCreateTool.ts:130-138` |

## 3. 三个最重要的判断问题

判断一句“旧 stronger request 已经继续了，所以等于已经完成了”有没有越级，先问三句：

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
| “工具重新 available 了，所以旧 stronger request 等于已经完成” | availability != request completion |

## 5. 一条硬结论

真正成熟的 stronger-request completion grammar 不是：

`old stronger request may continue -> therefore treat the request as complete`

而是：

`old stronger request may continue -> continue execution -> observe success / error / could-not-complete -> emit completed progress or explicit result block -> only then treat the request as complete`

只有中间这些层被补上，
cleanup stronger-request continuation governance 才不会继续停留在：

`它能决定旧 stronger request 还能不能继续，却没人正式决定这条 stronger request 现在究竟已经完成，还是仍未完成。`
