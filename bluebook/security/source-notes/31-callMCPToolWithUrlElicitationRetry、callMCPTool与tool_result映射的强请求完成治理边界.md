# callMCPToolWithUrlElicitationRetry、callMCPTool 与 tool_result 映射的强请求完成治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `180` 时，
真正需要被单独钉住的已经不是：

`cleanup 线未来谁来决定旧 stronger request 还能不能继续，`

而是：

`cleanup 线如果未来已经允许旧 stronger request 继续，谁来决定这条 request 现在究竟是否已经完成。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`continuation governor 不等于 completion governor。`

这句话还不够硬。
所以这里单开一篇，只盯住：

- `src/services/mcp/client.ts`
- `src/tools/FileWriteTool/FileWriteTool.ts`
- `src/tools/TaskCreateTool/TaskCreateTool.ts`

把 retry loop、`could not complete`、`status: 'completed'`、`completed successfully` 与 explicit success `tool_result` 并排，
逼出一句更硬的结论：

`Claude Code 已经在 interrupted MCP tool path 上明确展示：old blocked request 的 continuation grammar 可以合法地终止于 non-completion；真正的 completion 要等到底层 tool call 成功、结果被 normalize，并被映射成 completion-grade result block 之后才成立。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 continuation，没有 completion。`

而是：

`Claude Code 已经把 continuation 与 completion 明确拆成不同 ceiling：前者处理 retry permission、accept/decline、budget 与 could-not-complete，后者处理 completed progress、normalized result 与 explicit success tool_result。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| continuation loop with non-completion exits | `src/services/mcp/client.ts:2813-3024` | 为什么 old request continuation 可以合法地停在 `could not complete` |
| outer completion progress | `src/services/mcp/client.ts:1838-1895` | 为什么 `status: 'completed'` 只在 `mcpResult` 返回后才发 |
| settled tool-call result | `src/services/mcp/client.ts:3029-3238` | 为什么真正 completion 要等到底层 callTool success / error 决出结果 |
| result normalization | `src/services/mcp/client.ts:2628-2718` | 为什么 completion 关心的是 result settlement，而不是 retry permission |
| representative success tool_result | `src/tools/FileWriteTool/FileWriteTool.ts:424-430`; `src/tools/TaskCreateTool/TaskCreateTool.ts:130-138` | 为什么 completion-grade output 会直接对结果负责，而不是只说“可以继续试” |

## 4. `callMCPToolWithUrlElicitationRetry()` 先证明：同一请求续打和同一请求完成在源码里就不是同一个 ceiling

`client.ts:2813-3024` 很值钱。

这段代码最硬的地方不只是 `retrying tool call`，
而是它同时保留了 continuation 和 non-completion 的明文分流：

1. hook 若不是 `accept`，直接返回  
   `The tool "<tool>" could not complete ...`
2. user / result hook 若不是 `accept`，同样返回  
   `The tool "<tool>" could not complete ...`
3. 只有 `accept` 成立时，才 loop back 到下一轮 `callToolFn`

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

`client.ts:1838-1895` 很硬。

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
3. 但 completed progress 不是 retry grammar 的内建属性
4. completed progress 要等结果真正回来之后才配发

这正是 completion signer 的本体：

`结果返回`

而不是：

`继续动作已经许可`

## 6. `callMCPTool()` 与 `transformMCPResult()` 再证明：真正的 completion layer 负责 result settlement 与 result shape

`client.ts:3029-3238` 更硬。

`callMCPTool()` 的逻辑非常干净：

1. `client.callTool()` 若报 `isError`，就 throw
2. 真正成功后才记录  
   `Tool '<tool>' completed successfully`
3. 接着调用 `processMCPResult()` 处理结果
4. 最后返回 `{ content, _meta, structuredContent }`

这条证据说明：

`completion`

在这里不是一种“继续执行的姿态”，
而是一种“结果已经被结算并可返回”的状态。

`transformMCPResult()` 再给出第二组强证据。

它只关心：

1. `toolResult`
2. `structuredContent`
3. `contentArray`

也就是：

`完成后的结果究竟长什么样`

这和 continuation layer 关心的：

`为什么能继续`

是完全不同的问题。

所以 repo 在代码职责上已经公开做出切分：

1. continuation grammar 负责 retry control
2. completion grammar 负责 result settlement / normalization

## 7. `FileWriteTool` 与 `TaskCreateTool` 再证明：真正的 completion signer 会直接产出 completion-grade output

`FileWriteTool.ts:424-430` 与 `TaskCreateTool.ts:130-138` 是很好的正对照。

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

## 8. 为什么这层不等于 `179` 的 continuation gate

这里必须单独讲清楚，
否则容易把 `180` 误读成 `179` 的尾注。

`179` 问的是：

`old blocked stronger request 是否仍应被视为同一请求继续。`

`180` 问的是：

`这条 old blocked stronger request 继续之后，是否已经真的完成。`

所以：

1. `179` 的典型形态是 retry loop、accept/decline/cancel、retry budget、future readiness ceiling
2. `180` 的典型形态是 could-not-complete、completed progress、completed successfully、normalized result、success tool_result

前者 guarding causal continuation，
后者 guarding result completion。

两者都很重要，
但不是同一个 signer。

## 9. 这篇源码剖面给主线带来的四条技术启示

### 启示一

repo 已经明确展示：

`continuation can end in non-completion`

### 启示二

repo 已经明确展示：

`completed progress is a higher ceiling than retry permission`

### 启示三

repo 已经明确展示：

`completion is about result settlement and result shape, not retry control`

### 启示四

repo 已经明确展示：

`explicit success tool_result is a completion surface, not a continuation surface`

这四句合起来，
正好说明为什么 cleanup 线未来不能把 resumed stronger request 直接偷写成 completed stronger request。

## 10. 一条硬结论

这组源码真正说明的不是：

`只要补出旧 stronger request 的 continuation grammar，cleanup 线就已经拥有了完整 completion semantics。`

而是：

`repo 已经在 callMCPToolWithUrlElicitationRetry() 的 could-not-complete / retrying-tool-call 分流、outer MCP path 的 completed progress、callMCPTool() 的 completed-successfully + normalized result，以及 FileWriteTool / TaskCreateTool 的 explicit success tool_result 上，清楚展示了 stronger-request completion governance 的独立存在；因此 artifact-family cleanup stronger-request continuation-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request completion-governor signer。`

因此：

`cleanup 线真正缺的，不只是“谁来允许旧 stronger request 继续”，还包括“谁来把这条 resumed stronger request 正式推进到 completed result，或者明确签成 still-not-complete”。`
