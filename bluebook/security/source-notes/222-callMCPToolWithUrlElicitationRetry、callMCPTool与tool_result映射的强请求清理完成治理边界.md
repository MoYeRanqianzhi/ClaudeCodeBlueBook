# callMCPToolWithUrlElicitationRetry、callMCPTool与tool_result映射的强请求清理完成治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `371` 时，
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
| continuation loop with non-completion exits | `src/services/mcp/client.ts:2813-3025` | 为什么 old request continuation 可以合法地停在 `could not complete` |
| outer completion progress | `src/services/mcp/client.ts:1845-1895` | 为什么 `status: 'completed'` 只在 `mcpResult` 返回后才发 |
| settled tool-call result | `src/services/mcp/client.ts:3029-3238` | 为什么真正 completion 要等到底层 `callTool` success / error / abort 决出结果 |
| result normalization | `src/services/mcp/client.ts:2662-2798` | 为什么 completion 关心的是 result settlement 与 result shape，而不是 retry permission |
| representative success tool_result | `src/tools/FileWriteTool/FileWriteTool.ts:418-430`; `src/tools/TaskCreateTool/TaskCreateTool.ts:130-136` | 为什么 completion-grade output 会直接对结果负责，而不是只说“可以继续试” |
| protocol wrapper / empty-result fallback | `src/tools/MCPTool/MCPTool.ts:70-75`; `src/services/tools/toolExecution.ts:1715-1724`; `src/utils/toolResultStorage.ts:286-294` | 为什么 completion 还要治理 success/error bit 与空结果命名，而不只是治理“有无返回值” |

## 4. `callMCPToolWithUrlElicitationRetry()` 先证明：同一请求续打和同一请求完成在源码里就不是同一个 ceiling

`client.ts:2813-3025`
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

`client.ts:1845-1895`
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

`client.ts:2662-2798`
再给出第二组强证据。

`transformMCPResult()` 与后续 normalization path 只关心：

1. `toolResult`
2. `structuredContent`
3. `contentArray`
4. unexpected response format 是否应直接报错
5. large output 该 truncate、persist 还是保留原内容

也就是：

`完成后的结果究竟长什么样`

这和 continuation layer 关心的：

`为什么能继续`

是完全不同的问题。

所以 repo 在代码职责上已经公开做出切分：

1. continuation grammar 负责 retry control
2. completion grammar 负责 result settlement / normalization / shape honesty

## 7. `FileWriteTool`、`TaskCreateTool`、`MCPTool` 与 `toolResultStorage` 再证明：completion 还要治理 success/error bit 与空结果命名

`FileWriteTool.ts:418-430`
与
`TaskCreateTool.ts:130-136`
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

`MCPTool.ts:70-75`
再补一层 bare success wrapper。

成功时，
它只构造：

`type: 'tool_result', content`

而没有额外的 error bit。

与之对照，
`toolExecution.ts:1715-1724`
在 error 路径上则继续显式写：

`is_error: true`

这说明 completion grammar
还在协议层治理：

1. 哪些结果是 success-by-default
2. 哪些结果必须显式宣告 error
3. 谁来承担这个 protocol-level honesty

`toolResultStorage.ts:286-294`
最后再补一层空结果命名治理。

repo 宁可主动注入：

`(<toolName> completed with no output)`

也不愿意让模型和渲染层面对空内容失语。

这说明 completion 不只治理“有没有执行过”，
还治理：

`结果在结果层应该被怎样诚实名字化`

## 8. 更深一层的技术先进性：Claude Code 把“继续资格”与“完成资格”拆成不同所有权层

这组源码给出的技术启示至少有五条：

1. continuation is allowed to fail honestly
2. completion belongs to settlement and naming layers, not to retry layers
3. result normalization is part of security, not just formatting
4. protocol-level success/error bits carry governance meaning
5. empty-output markers prevent silent overclaim and preserve downstream interpretability

从源码设计思路看，
Claude Code 的先进性不在于“权限和续打恢复后它会替你自动宣布完成”，
而在于：

`它知道什么时候只能说“旧动作现在可以回到执行里”，却不能越级说“这条旧动作我已经替你结案了”。`

## 9. 用苏格拉底式反问压缩这篇源码剖面的核心

可以得到五个自检问题：

1. 如果 continuation 已经足够，为什么 `callMCPToolWithUrlElicitationRetry()` 还要保留 `could not complete`？
2. 如果 `status: 'completed'` 已经天然等于语义成功，为什么它还要等到 `mcpResult` 返回之后才发？
3. 如果 resumed request 一进入底层执行就等于完成，为什么 `callMCPTool()` 还要继续区分 `result.isError` 与 `AbortError`？
4. 如果任何返回值都能算 settled result，为什么 `transformMCPResult()` / `processMCPResult()` 还要单独管结果 shape？
5. 如果 completion 只是“执行过”，为什么 `toolResultStorage.ts` 还要显式补 `completed with no output`？

这些反问共同逼出同一个结论：

`Claude Code 不只在治理旧动作能不能继续，也在治理旧动作继续之后到底有没有被合法结案。`

## 10. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 只要补出 continuation governance，就已经足够成熟。`

而是：

`Claude Code 在 could-not-complete exits、completed progress、result settlement、result normalization、explicit success tool_result 与 empty-output honesty 上已经明确展示了 completion governance 的存在；因此 artifact-family cleanup stronger-request continuation-governor signer 仍不能越级冒充artifact-family cleanup stronger-request completion-governor signer。`

再压成一句：

`cleanup 线真正缺的不是“它还能不能继续”，而是“它现在究竟有没有被正式结案”。`
