# callMCPToolWithUrlElicitationRetry、callMCPTool与tool_result映射的强请求清理完成治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `340` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 线未来谁来决定 old blocked stronger cleanup request 还能不能继续，`

而是：

`stronger-request cleanup 线如果未来已经允许 old blocked stronger cleanup request 继续，谁来决定这条 request 现在究竟是否已经完成。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`continuation governor 不等于 completion governor。`

这句话还不够硬。
所以这里单开一篇，
只盯住：

- `src/services/mcp/client.ts`
- `src/tools/FileWriteTool/FileWriteTool.ts`
- `src/tools/TaskCreateTool/TaskCreateTool.ts`
- `src/tools/MCPTool/MCPTool.ts`
- `src/services/tools/toolExecution.ts`
- `src/utils/toolResultStorage.ts`

把 retry loop、`could not complete`、`status: 'completed'`、`completed successfully`、abort-not-complete、explicit success `tool_result` 与空结果命名治理并排，
逼出一句更硬的结论：

`Claude Code 已经在 interrupted MCP tool path 上明确展示：old blocked request 的 continuation grammar 可以合法地终止于 non-completion；真正的 completion 要等到底层 tool call 成功或失败、结果被 normalize，并被映射成 completion-grade result block 之后才成立。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 continuation，没有 completion。`

而是：

`Claude Code 已经把 continuation 与 completion 明确拆成不同 ceiling：前者处理 retry permission、accept/decline、budget 与 could-not-complete；后者处理 completed progress、result.isError / abort discipline、normalized result shape、explicit success tool_result 与空结果命名诚实性。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| continuation loop with non-completion exits | `src/services/mcp/client.ts:2813-3020` | 为什么 old request continuation 可以合法地停在 `could not complete` |
| outer completion progress | `src/services/mcp/client.ts:1851,1889` | 为什么 `status: 'completed'` 只在 `mcpResult` 返回后才发 |
| settled tool-call result | `src/services/mcp/client.ts:3029-3238` | 为什么真正 completion 要等到底层 `callTool` success / error / abort 决出结果 |
| result normalization | `src/services/mcp/client.ts:2662,2720,2725` | 为什么 completion 关心的是 result settlement 与 result shape，而不是 retry permission |
| representative success tool_result | `src/tools/FileWriteTool/FileWriteTool.ts:424,430`; `src/tools/TaskCreateTool/TaskCreateTool.ts:135` | 为什么 completion-grade output 会直接对结果负责，而不是只说“可以继续试” |
| protocol wrapper / empty-result fallback | `src/tools/MCPTool/MCPTool.ts:73`; `src/services/tools/toolExecution.ts:1720-1722`; `src/utils/toolResultStorage.ts:293` | 为什么 completion 还要治理 success/error bit 与空结果命名，而不只是治理“有无返回值” |

## 4. `callMCPToolWithUrlElicitationRetry()` 先证明：同一请求续打和同一请求完成在源码里就不是同一个 ceiling

`client.ts:2813-3020`
很值钱。

这段代码最硬的地方不只是 `retrying tool call`，
而是它同时保留了 continuation 和 non-completion 的明文分流：

1. hook 若不是 `accept`，直接返回
   `The tool "<tool>" could not complete ...`
2. user / result hook 若不是 `accept`，同样返回
   `The tool "<tool>" could not complete ...`
3. 只有 `accept` 成立时，才 loop back 到下一轮 `callToolFn`
4. loop 还被 `MAX_URL_ELICITATION_RETRIES = 3` 明确限额
5. queue path 还把 consent 和 `Retry now` waiting dismiss 拆成两阶段

这条证据非常关键。

因为它公开说明：

`same-request continuation`

即便已经成立，
仍然可以合法地落在：

`same-request non-completion`

而不是自动升格成：

`same-request completion`

这意味着 continuation signer 的权力上限非常清楚：

它能说：

`继续`

却不能说：

`已经完成`

## 5. outer progress path 再证明：`status: 'completed'` 只在 continuation 之后、结果返回之后才成立

`client.ts:1851,1889`
很硬。

outer MCP tool path 先发：

`status: 'started'`

随后进入：

`callMCPToolWithUrlElicitationRetry()`

只有拿到 `mcpResult` 之后，
才发：

`status: 'completed'`

这条证据非常值钱。

因为它说明：

1. continuation path 可以跑很久
2. 其中可能经历多次 retry
3. 但 completed progress 不是 retry grammar 的天然属性
4. completed progress 要等结果真正回来之后才配发

这正是 completion signer 的本体：

`结果返回`

而不是：

`继续动作已经许可`

同时这里还必须保持一个更精细的警觉：

`status: 'completed'`

在这条路径里表达的是：

`这次 MCP call chain 已经 resolved`

而不天然等于：

`外部读者现在可以把这件事理解成语义上完全成功`

因为 `mcpResult`
本身仍可能是：

`could not complete`

式的 non-completion content。

这恰好反过来证明：

`completed progress`

本身也属于 completion grammar 的一部分，
而不是 success proof 的唯一同义词。

## 6. `callMCPTool()` 与 `processMCPResult()` 再证明：真正的 completion layer 负责 result settlement、shape honesty 与 abort honesty

`client.ts:3029-3238`
更硬。

`callMCPTool()` 的逻辑非常干净：

1. `client.callTool()` 真正执行底层调用
2. 若 `result.isError`，就提取错误并抛出 `McpToolCallError`
3. 真正成功后才记录
   `Tool '<tool>' completed successfully`
4. 接着调用 `processMCPResult()` 处理结果
5. 最后才返回 `{ content, _meta, structuredContent }`
6. 若是 `AbortError`，就只返回 `{ content: undefined }`

这条证据说明：

`completion`

在这里不是一种“继续执行的姿态”，
而是一种“结果已经被结算并可返回”的状态。

同时，
abort path 也非常值钱。

因为它说明 repo 宁可留下：

`undefined content`

也不愿意让被中断执行伪装成 completion。

`client.ts:2662,2720,2725`
再给出第二组强证据。

`transformMCPResult()` 与后续 normalization path 只关心：

1. `toolResult`
2. `structuredContent`
3. `contentArray`
4. unexpected response format 是否应直接报错

也就是：

`完成后的结果究竟长什么样`

这和 continuation layer 关心的：

`为什么能继续`

是完全不同的问题。

所以 repo 在代码职责上已经公开做出切分：

1. continuation grammar 负责 retry control
2. completion grammar 负责 result settlement / normalization / shape honesty

## 7. `FileWriteTool` 与 `TaskCreateTool` 再证明：真正的 completion signer 会直接产出 completion-grade output

`FileWriteTool.ts:424,430`
与
`TaskCreateTool.ts:135`
是很好的正对照。

它们在成功时分别返回：

1. `File created successfully at: <path>`
2. `The file <path> has been updated successfully.`
3. `Task #<id> created successfully: <subject>`

这类 `tool_result` block 的关键不在于它们都是 success string，
而在于：

它们已经在以结果所有者的身份说话。

它们不再说：

`你可以继续`

而是在说：

`请求已经完成，而这就是完成后的结果`

这正是 continuation signer 无法越级冒充的地方。

## 8. `MCPTool` 与 `toolResultStorage` 再证明：completion 还要治理 success/error bit 与空结果命名

`MCPTool.ts:73`
再补一层 bare success wrapper。

成功时，
它只构造：

`type: 'tool_result', content`

而没有额外的 error bit。

与之对照，
`toolExecution.ts:1720-1722`
在 error 路径上则继续显式写：

`is_error: true`

这说明 completion grammar
还在 protocol 层治理：

`success / error`

应该怎样被标记。

`toolResultStorage.ts:293`
最后再补上一个极其值钱的细节：

`(${toolName} completed with no output)`

repo 宁可主动给空结果补一个 completion naming marker，
也不愿意让空 payload 破坏 renderer / model 对 completion 的诚实理解。

这条证据很关键，
因为它说明 completion 不只关心
“有没有结果”，
还关心：

`结果在协议和阅读层里应当怎样被命名，才不至于把 silence、empty、abort 和 success 混成一团。`

## 9. 用苏格拉底式反问压缩这篇源码剖面的核心

可以得到五个自检问题：

1. 如果 `retrying tool call` 已经等于 completion，为什么同一函数还会返回 `could not complete`？
2. 如果 `status: 'completed'` 已经天然等于语义成功，为什么它还要等到 `mcpResult` 返回之后才发？
3. 如果 bare `tool_result` 已经足以表达所有 completion honesty，为什么 repo 还要单独写 `is_error: true` 和 `completed with no output`？
4. 如果 continuation signer 已经替结果签字，为什么 `processMCPResult()` 还要单独治理 result shape？
5. 如果 completion 已经回答了一切，为什么下一层还必须继续追问 finality？

这些反问共同逼出同一个结论：

`Claude Code 不只在治理一条被打断的请求还能不能继续，也在治理它继续以后何时才配被当成真的已经完成。`
