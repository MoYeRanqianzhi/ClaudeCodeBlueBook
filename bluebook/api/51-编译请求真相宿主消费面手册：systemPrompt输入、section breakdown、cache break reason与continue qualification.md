# 编译请求真相宿主消费面手册：systemPrompt输入、section breakdown、cache break reason与continue qualification

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式支持面让宿主消费 Prompt 编译链。
2. 哪些属于宿主可写输入面，哪些属于宿主可读投影，哪些仍然是 internal-only 编译细节。
3. 为什么宿主不该把 Prompt 理解成一个 `systemPrompt` 字符串，而该理解成“输入面 + 观测面 + 继续资格投影”的分层支持面。
4. 为什么 section breakdown、message breakdown、auto compact 阈值与 continue qualification 也属于编译请求真相支持面。
5. 宿主开发者该按什么顺序接入这套 Prompt 支持面。

## 0. 关键源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-72`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:205-306`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1548-1561`
- `claude-code-source-code/src/utils/sessionState.ts:32-44`
- `claude-code-source-code/src/utils/api.ts:321-405`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:247-430`
- `claude-code-source-code/src/query.ts:1065-1340`

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `compiled_request_truth`

的单独公共对象。

但编译请求真相已经通过三层支持面被宿主稳定消费：

1. `prompt inputs`
   - 宿主能写什么输入给编译链。
2. `compiled truth projections`
   - 宿主能看到当前 Prompt 世界的哪些正式投影。
3. `internal compiler machinery`
   - 真正负责 section 组装、协议转写、cache break 诊断与继续资格判断的内部机制。

更成熟的接入方式不是：

- 只盯 `systemPrompt`

而是：

- 明确知道自己当前是在写 Prompt 输入、读编译结果投影，还是只消费内部机制的外化效果

## 2. prompt inputs：宿主可写输入面

当前最稳定的 Prompt 输入面主要包括：

1. `initialize.systemPrompt`
2. `initialize.appendSystemPrompt`
3. `initialize.agents`
4. `initialize.promptSuggestions`

这说明 Claude Code 对 Prompt 的公开支持方式更接近：

- 输入面

而不是：

- 直接开放内部编译对象

正确理解是：

1. 宿主可以声明或追加 Prompt 输入。
2. 宿主可以决定是否启用部分 Prompt 相关功能。
3. 宿主不能直接宣布“最终编译后的请求真相是什么”。

## 3. compiled truth projections：宿主可读投影

宿主当前最该消费的 Prompt 编译投影主要有：

1. `get_context_usage.systemPromptSections`
2. `get_context_usage.messageBreakdown`
3. `get_context_usage.autoCompactThreshold`
4. `get_context_usage.apiUsage`
5. `post_turn_summary`
6. `task_summary`

这些投影回答的不是：

- Prompt 原文是什么

而是：

1. 当前哪些 section 正在占席位。
2. 当前哪些 message / tool / attachment 正在吃上下文。
3. 当前 auto compact 边界落在哪里。
4. 当前继续条件是否已被压缩、总结与上下文成本影响。

要特别注意：

- `systemPromptSections` 之类 breakdown 仍然带有 consumer subset / 环境门控语义，不应被理解成“所有宿主永远都能看到的完整内部 trace”。

## 4. continue qualification 的宿主投影

`continue qualification` 虽然没有单独公共对象，但宿主已经能通过多个投影间接消费它：

1. `post_turn_summary`
2. `task_summary`
3. `get_context_usage.autoCompactThreshold`
4. `get_context_usage.apiUsage`
5. 相关 state / worker status 变化

更成熟的理解不是：

- 继续只是 query 内部逻辑

而是：

- 继续资格已经通过多个 Prompt 投影被外化，只是还没有被压成单一公共对象

## 5. internal compiler machinery：不应直接当公共 ABI 依赖

真正把 Prompt 变成编译请求真相的关键机制仍在内部：

1. `splitSysPromptPrefix()`
2. section registry 的内部重置与编排
3. `promptCacheBreakDetection`
4. `normalizeMessagesForAPI()`
5. `ensureToolResultPairing()`
6. stop hooks 保存的 cache-safe params

对宿主开发者来说，正确做法不是：

- 直接依赖这些内部结构与 trace

而是：

- 消费已经外化出来的 inputs / projections / summaries

## 6. 三层支持矩阵

更稳的接入矩阵可以写成：

### 6.1 宿主可写

1. `systemPrompt`
2. `appendSystemPrompt`
3. `agents`
4. `promptSuggestions`

### 6.2 宿主可读

1. `systemPromptSections`
2. `messageBreakdown`
3. `autoCompactThreshold`
4. `apiUsage`
5. `post_turn_summary`
6. `task_summary`

### 6.3 不应直接依赖为公共 ABI

1. section registry 内部状态
2. compiled request trace 的完整内部形态
3. cache break 诊断器内部 diff 结构
4. normalize / pairing 的内部重写实现
5. continue qualification 的全部内部计数器

## 7. 接入顺序建议

更稳的顺序是：

1. 先接 Prompt 输入面。
2. 再接 `get_context_usage` 的 Prompt 相关投影。
3. 再接 `post_turn_summary / task_summary` 的继续资格投影。
4. 最后才把内部编译机制当作调试参考，而不是公共 ABI。

不要做的事：

1. 不要把 `systemPrompt` 当成全部 Prompt 世界。
2. 不要把 Context Usage breakdown 当成完整内部编译 trace。
3. 不要把 cache break 诊断器内部结构绑定进宿主逻辑。
4. 不要让宿主自己从原文 prompt 推断 compiled request truth。

## 8. 一句话总结

Claude Code 的编译请求真相支持面，不是一个 prompt 字符串 API，而是“Prompt 输入面 + 编译结果投影 + 继续资格摘要”共同组成的分层宿主消费面。
