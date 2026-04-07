# callMCPToolWithUrlElicitationRetry、callMCPTool与tool_result映射的强请求清理完成治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `308` 时，
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

把 retry loop、`could not complete`、`status: 'completed'`、`completed successfully`、abort-not-complete 与 explicit success `tool_result` 并排，
逼出一句更硬的结论：

`Claude Code 已经在 interrupted MCP tool path 上明确展示：old blocked request 的 continuation grammar 可以合法地终止于 non-completion；真正的 completion 要等到底层 tool call 成功或失败、结果被 normalize，并被映射成 completion-grade result block 之后才成立。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 continuation，没有 completion。`

而是：

`Claude Code 已经把 continuation 与 completion 明确拆成不同 ceiling：前者处理 retry permission、accept/decline、budget 与 could-not-complete；后者处理 completed progress、result.isError / abort discipline、normalized result shape 与 explicit success tool_result。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| continuation loop with non-completion exits | `src/services/mcp/client.ts:2813-3025` | 为什么 old request continuation 可以合法地停在 `could not complete` |
| outer completion progress | `src/services/mcp/client.ts:1848-1895` | 为什么 `status: 'completed'` 只在 `mcpResult` 返回后才发 |
| settled tool-call result | `src/services/mcp/client.ts:3029-3238` | 为什么真正 completion 要等到底层 `callTool` success / error / abort 决出结果 |
| result normalization | `src/services/mcp/client.ts:2662-2728` | 为什么 completion 关心的是 result settlement 与 result shape，而不是 retry permission |
| representative success tool_result | `src/tools/FileWriteTool/FileWriteTool.ts:418-430`; `src/tools/TaskCreateTool/TaskCreateTool.ts:130-135` | 为什么 completion-grade output 会直接对结果负责，而不是只说“可以继续试” |
| protocol wrapper / empty-result fallback | `src/tools/MCPTool/MCPTool.ts:70-75`; `src/services/tools/toolExecution.ts:1717-1723`; `src/utils/toolResultStorage.ts:280-294` | 为什么 completion 还要治理 success/error bit 与空结果命名，而不只是治理“有无返回值” |

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

`client.ts:1848-1895`
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

`client.ts:2662-2728`
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

`FileWriteTool.ts:418-430`
与
`TaskCreateTool.ts:130-135`
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

`src/tools/MCPTool/MCPTool.ts:70-75`
很有价值。

MCP 成功结果映射成 `tool_result` 时，
repo 给出的只是：

`{ type: 'tool_result', tool_use_id, content }`

也就是：

success 在协议层往往是隐式的。

反过来，
`src/services/tools/toolExecution.ts:1717-1723`
在错误 path 上才显式补：

`is_error: true`

这说明 completion grammar 在这里并不是对称的 bool，
而是一套：

1. 默认 success
2. 显式 error
3. 继续向 rendering/storage 层传播的协议

更进一步，
`src/utils/toolResultStorage.ts:280-294`
还会把空 `tool_result` 内容统一改写成：

`(<toolName> completed with no output)`

这条证据尤其值钱。

因为它说明：

1. 空结果本身也要被 completion layer 正式命名
2. storage/rendering 需要防止 empty result 破坏后续模型回合
3. “completed” 这类友好词法有时只是兼容性 settlement copy，不自动等于更强的业务成功证明

换句话说，
completion 不只是在治理：

`结果有没有回来`

也在治理：

`结果回来以后，该被怎样命名、怎样包装、怎样避免空结算误伤后续世界`

## 9. 为什么这层不等于 `158` 的 continuation 剖面

这里必须单独讲清楚，
否则容易把 `159` 误读成 `158` 的尾注。

`158` 问的是：

`old blocked stronger cleanup request 是否仍应被视为同一请求继续。`

`159` 问的是：

`这条 old blocked stronger cleanup request 继续之后，是否已经真的完成。`

所以：

1. `158` 的典型形态是 retry loop、accept/decline/cancel、retry budget、future readiness ceiling
2. `159` 的典型形态是 could-not-complete、completed progress、completed successfully、normalized result、success tool_result 与 abort-not-complete discipline

前者 guarding causal continuation，
后者 guarding result completion。

两者都很重要，
但不是同一个 signer。

## 10. 从技术先进性看：Claude Code 不只把“能否续打”做成控制语法，还把“结果何时算完成”做成结果语法

从技术角度看，
Claude Code 在这里最先进的地方，不是它“会 retry”，
而是它拒绝把：

`retry permission`

偷写成：

`result settlement`

这套设计至少体现了六个成熟点：

1. `non-completion is a first-class outcome`
2. `progress and settlement are layered`
3. `raw return is not enough`
4. `shape validation is part of completion honesty`
5. `explicit success copy has an owner`
6. `abort does not impersonate completion`
7. `friendly completion copy itself is governed`

它的哲学本质是：

`安全不只问“还能不能接着做”，还问“这次做完之后到底算不算已经完成”。`

## 11. 苏格拉底式自我反思：如果我把这一篇写得更强，我会在哪些地方越级

可以先问五个问题：

1. 如果 `accept` 已经等于 completion，为什么 `callMCPToolWithUrlElicitationRetry()` 还会在非 `accept` 时明确返回 `could not complete`？
2. 如果 continuation 本身已经带完成 verdict，为什么 `status: 'completed'` 还要等到 `mcpResult` 返回后才发？
3. 如果底层调用只要有返回就够，为什么 `transformMCPResult()` 还要继续追问 result shape？
4. 如果 aborted execution 也能算完成，为什么 `AbortError` 只允许留下 `undefined content`？
5. 如果 result ownership 已经属于 continuation signer，为什么工具层还要单独产出 explicit success `tool_result`，甚至在空结果时还要补 `completed with no output` 这类 settlement copy？

这些反问共同逼出同一个结论：

`Claude Code 不只在治理 old request 能不能继续，也在治理 old request 继续之后究竟有没有真正被结算。`

## 12. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 线只要补出 continuation grammar，就已经足够成熟。`

而是：

Claude Code 已经在 `callMCPToolWithUrlElicitationRetry()` 的 `could not complete` 分流、outer MCP tool path 的 `status: 'completed'` progress、`callMCPTool()` 的 `completed successfully` 与 abort-not-complete discipline、`transformMCPResult()` / `processMCPResult()` 的 normalized result path，以及 `FileWriteTool` / `TaskCreateTool` 的 explicit success `tool_result` 上，明确展示了 stronger-request completion governance 的独立存在；因此 `artifact-family cleanup stronger-request continuation-governor signer` 仍不能越级冒充 `artifact-family cleanup stronger-request completion-governor signer`。

如果 cleanup 线未来真要补 completion grammar，
它至少还要正式回答：

1. `could not complete` 与 `completed` 的边界由谁签字
2. completed progress 在哪一层发出
3. result settlement 由谁负责
4. abort / undefined content 怎样避免伪装 completion
5. 哪一类 explicit success result 才配宣布“这次 continued stronger cleanup request 真的完成了”
