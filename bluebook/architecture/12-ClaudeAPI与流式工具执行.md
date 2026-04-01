# Claude API 与流式工具执行

这一章回答五个问题：

1. `query.ts` 与 `services/api/claude.ts` 如何共同组成 Claude Code 的 API 执行链。
2. 为什么 Claude Code 的流式输出不是“边吐文本边显示”这么简单。
3. tool_use / tool_result、fallback、reactive compact、max output recovery 如何在流式链里协同。
4. 为什么 streaming fallback、orphan tool result、message mutation 这些细节会直接影响恢复与缓存。
5. 这条链路体现了怎样的设计内涵。

## 1. 先说结论

Claude Code 的 Claude API 执行链至少分成六段：

1. query loop 准备：拼 `messagesForQuery`、system/user context、tools、permission context。
2. API 入参规范化：`Message -> MessageParam`、tool/result pairing repair、media/tool-search/advisor strip。
3. 流式解析：`message_start -> content_block_* -> message_delta -> message_stop`。
4. 流式工具执行：边收到 `tool_use` 边交给 `StreamingToolExecutor`。
5. 恢复与重试：streaming fallback、fallback model、reactive compact、max output recovery、abort handling。
6. 递归续跑：tool results、attachments、prefetch、refreshTools、next turn。

这条链不只是“调用模型”，而是一个带事件流、工具执行、恢复和缓存约束的 runtime harness。

关键证据：

- `claude-code-source-code/src/query.ts:123-179`
- `claude-code-source-code/src/query.ts:650-930`
- `claude-code-source-code/src/query.ts:980-1265`
- `claude-code-source-code/src/query.ts:1368-1728`
- `claude-code-source-code/src/services/api/claude.ts:588-673`
- `claude-code-source-code/src/services/api/claude.ts:709-760`
- `claude-code-source-code/src/services/api/claude.ts:1270-1335`
- `claude-code-source-code/src/services/api/claude.ts:1979-2365`
- `claude-code-source-code/src/services/api/claude.ts:2366-2475`
- `claude-code-source-code/src/services/api/claude.ts:2560-2825`
- `claude-code-source-code/src/services/api/claude.ts:2924-3025`

## 2. query loop 先定义的是“执行上下文”，不是 API 请求

`query.ts` 在真正调模型前，已经准备了很多运行时信息：

- `prependUserContext(messagesForQuery, userContext)`
- `fullSystemPrompt`
- `thinkingConfig`
- `toolUseContext.options.tools`
- `getToolPermissionContext()`
- `allowedAgentTypes`
- `hasPendingMcpServers`
- `taskBudget`

证据：

- `claude-code-source-code/src/query.ts:659-707`

因此从第一性原理看，Claude Code 调用模型时传入的不是“消息数组”，而是“一个已经被 runtime 装配过的工作集”。

## 3. API 入参规范化：不是简单序列化消息

### 3.1 User / assistant 会被转成 `MessageParam`

`claude.ts` 分别提供：

- `userMessageToMessageParam(...)`
- `assistantMessageToMessageParam(...)`

并且还处理：

- prompt caching 的 `cache_control`
- 数组内容克隆，避免后续 splice 污染原消息
- assistant block 上的 cache_control 约束

证据：

- `claude-code-source-code/src/services/api/claude.ts:588-673`

### 3.2 发送前还有一轮“修复语义”

在真正发 API 前，还会做：

- 关闭 tool search 时 strip `tool_reference` / `caller`
- `ensureToolResultPairing(...)` 修复 orphaned tool_use / tool_result
- strip advisor blocks
- strip excess media items

证据：

- `claude-code-source-code/src/services/api/claude.ts:1270-1335`

这一步很关键，因为它说明 Claude Code 不把“当前 transcript 内容”直接当作“可发送给 API 的有效消息”。

## 4. 流式解析的真正状态机

### 4.1 `message_start`

流式开始时：

- 初始化 `partialMessage`
- 记录 `ttftMs`
- 更新 usage
- 捕捉 internal-only `research`

证据：

- `claude-code-source-code/src/services/api/claude.ts:1979-1994`

### 4.2 `content_block_start`

会按 block type 初始化不同容器：

- `tool_use` 初始化 `input: ''`
- `server_tool_use` 初始化对象型 `input`
- `text` 初始化 `text: ''`
- `thinking` 初始化 `thinking: ''` 与 `signature: ''`

证据：

- `claude-code-source-code/src/services/api/claude.ts:1995-2052`

### 4.3 `content_block_delta`

这一步做真正增量拼接：

- `input_json_delta` 追加 tool input JSON 片段
- `text_delta` 追加 text
- `thinking_delta` / `signature_delta` 追加 thinking 与签名

同时带有大量类型不匹配保护和 streaming error logging。

证据：

- `claude-code-source-code/src/services/api/claude.ts:2053-2170`

### 4.4 `content_block_stop`

到 block 结束时，Claude Code 才构造真正的 `AssistantMessage`：

- 通过 `normalizeContentFromAPI(...)` 规范化内容块
- 注入 `requestId`
- 注入 `uuid`
- 必要时带 `research` / `advisorModel`

证据：

- `claude-code-source-code/src/services/api/claude.ts:2171-2212`

### 4.5 `message_delta`

这是整条链里最容易被忽视的关键点：

- usage 和 `stop_reason` 的最终值要在这里回写到“已经 yield 过”的最后一条 assistant message 上。
- 这里必须用“直接属性 mutation”，不能对象替换，否则 transcript queue 会抓到旧引用。

证据：

- `claude-code-source-code/src/services/api/claude.ts:2213-2294`

这说明 Claude Code 的流式链不是单纯 append model deltas，而是一个需要维护引用一致性的写回系统。

## 5. 每个原始 stream part 还会再被转成 `stream_event`

无论前面 block / message 如何处理，最终还会额外 yield：

- `type: 'stream_event'`
- `event: part`
- 对 `message_start` 额外附 `ttftMs`

证据：

- `claude-code-source-code/src/services/api/claude.ts:2299-2303`

这也是为什么 SDK 宿主看到的是事件流，而不仅是 assistant 文本。

## 6. streaming fallback 与 orphan 修复

### 6.1 streaming fallback 不是透明切换

`query.ts` 会在 `onStreamingFallback` 触发后：

- tombstone 掉已生成的 orphaned assistant messages
- 清空 `assistantMessages`、`toolResults`、`toolUseBlocks`
- discard 当前 `StreamingToolExecutor`
- 创建 fresh executor

证据：

- `claude-code-source-code/src/query.ts:678-740`

原因非常明确：

- 如果不这样做，会出现旧 tool_use id 残留、orphan tool_results 泄漏、prompt cache 失真。

### 6.2 `yieldMissingToolResultBlocks(...)`

这段逻辑专门用于在中断或异常时补 synthetic error tool_results，避免 assistant 的 tool_use 找不到配对结果。

证据：

- `claude-code-source-code/src/query.ts:123-149`

这表明 Claude Code 维护的并不是“文本完整性”，而是“tool trajectory 完整性”。

## 7. 恢复逻辑：prompt too long、media error、max output tokens

### 7.1 recoverable errors 会先被 withheld

`query.ts` 在流式循环中会先把这些消息 withheld：

- prompt-too-long
- reactive compact prompt-too-long
- media size error
- `max_output_tokens`

证据：

- `claude-code-source-code/src/query.ts:788-823`

原因不是不想让用户看到错误，而是：

- 这些错误可能可以被同一轮 recovery 继续修复。
- 过早向 SDK 暴露中间错误，会让上层宿主误判会话已经失败。

### 7.2 prompt-too-long / media error 先走 collapse / reactive compact

恢复顺序大致是：

1. 先尝试 context collapse drain。
2. 再尝试 reactive compact。
3. 若仍失败，再把 withheld error 真正 surface。

证据：

- `claude-code-source-code/src/query.ts:1065-1183`

### 7.3 max output tokens 还有单独恢复链

当命中 `max_output_tokens` 时：

- 先尝试从 capped default 升到更高 token 上限。
- 再用 meta recovery message 让模型“直接续写，不要 recap”。
- 最多恢复若干轮，耗尽后才真正 surface 错误。

证据：

- `claude-code-source-code/src/query.ts:1185-1256`

这说明 Claude Code 对“输出被截断”有专门的 continuation protocol，而不是只报错。

## 8. abort handling 与用户中断

若流式阶段被 abort：

- 若有 `StreamingToolExecutor`，会先消费剩余 synthetic tool results。
- 否则补 `yieldMissingToolResultBlocks(...)`
- 再决定是否发 `createUserInterruptionMessage(...)`

证据：

- `claude-code-source-code/src/query.ts:1011-1052`
- `claude-code-source-code/src/query.ts:1484-1516`

这说明“用户中断”也被建模成状态一致性的恢复问题，而不是简单停掉 for-await。

## 9. 非流式 fallback 与 404 stream creation fallback

`claude.ts` 里还存在另一层 fallback：

- stream creation 404 时回退到 non-streaming request
- 非用户 abort 的 streaming timeout 会转成更明确的 timeout error
- fallback 结果仍被正规化成 assistant message

证据：

- `claude-code-source-code/src/services/api/claude.ts:2434-2475`
- `claude-code-source-code/src/services/api/claude.ts:2560-2749`

所以 Claude Code 的 streaming / non-streaming 不是互斥模式，而是同一条执行链里的两种弹性实现。

## 10. tool 执行阶段：流式与非流式统一收口

在模型返回 tool_use 后：

- 若启用 `StreamingToolExecutor`，则持续消费 `getRemainingResults()`
- 否则走 `runTools(...)`
- 所有结果都继续转换成 API 可接受的 `user`-side tool results

证据：

- `claude-code-source-code/src/query.ts:1368-1408`

然后又会继续：

- 生成 `tool_use_summary`
- 处理 attachments / queued commands / memory prefetch / skill discovery
- 刷新 tools，使新连上的 MCP tools 能进入下一轮
- 构造下一轮递归 state

证据：

- `claude-code-source-code/src/query.ts:1411-1728`

## 11. usage 合并逻辑也是一层专门算法

`updateUsage(...)` 与 `accumulateUsage(...)` 的设计说明：

- `message_start` 提供的某些 usage 字段应被 sticky 保留。
- `message_delta` 的零值不能覆盖真实值。
- `server_tool_use`、cache creation / read、iterations、speed 都要做细粒度合并。

证据：

- `claude-code-source-code/src/services/api/claude.ts:2924-3025`

这说明 Claude Code 的成本与 usage 统计不是“最后拿一份 usage 对象”，而是对 stream lifecycle 的逐步归并。

## 12. 从第一性原理看：为什么这条链这么复杂

如果 Claude Code 只是聊天客户端，这条链完全没必要这么厚。

它之所以复杂，是因为它同时在满足：

1. 事件流可见性
2. 工具执行一致性
3. transcript / replay 可恢复性
4. prompt cache 稳定性
5. recoverable error 的继续执行
6. 流式与非流式的弹性切换

所以这条链的设计内涵可以概括成一句话：

Claude Code 调用模型时，真正维护的不是“回答文本”，而是“一个可恢复、可继续、可计费、可编排的执行轨迹”。

## 13. 相关章节

- 消息变体：`../api/11-SDKMessageSchema与事件流手册.md`
- 工具协议：`../api/08-工具协议与ToolUseContext.md`
- MCP 状态机：`../api/12-MCP配置与连接状态机.md`
- 上下文压缩恢复：`08-compact算法与上下文管理细拆.md`
