# compact 算法与上下文管理细拆

这一章不再讲 `query.ts` 里的宏观恢复链，而是继续下钻 `services/compact/*`，回答三个更具体的问题：

1. Claude Code 具体用什么阈值、缓冲区和状态来决定何时压缩。
2. microcompact、传统 compact、session memory compact、API-native context management 各自解决什么问题。
3. 为什么这套设计体现的是“工作集管理”，而不是“做一次摘要就结束”。

## 1. 先说结论

`services/compact/*` 并不是一个单算法目录，而是一个四层体系：

1. `autoCompact.ts` 是阈值控制器，负责是否触发、何时停止重试。
2. `microCompact.ts` 是轻量回收器，优先清理高噪音 tool result。
3. `compact.ts` 是重压缩器，负责真正生成 summary 并重建 post-compact context。
4. `sessionMemoryCompact.ts` 与 `apiMicrocompact.ts` 是两条替代路径：前者偏本地持久记忆，后者偏 API 原生上下文编辑。

关键证据：

- `claude-code-source-code/src/services/compact/autoCompact.ts:28-70`
- `claude-code-source-code/src/services/compact/microCompact.ts:40-135`
- `claude-code-source-code/src/services/compact/compact.ts:122-200`
- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:44-130`
- `claude-code-source-code/src/services/compact/apiMicrocompact.ts:34-153`

## 2. 控制器层：autocompact 不是“到点就压缩”

### 2.1 它先算一个“有效窗口”，而不是直接拿模型窗口

`getEffectiveContextWindowSize()` 会先从模型上下文窗口里预留 compact summary 的输出空间，默认最多保留 `20_000` token 给摘要输出。

证据：

- `claude-code-source-code/src/services/compact/autoCompact.ts:28-49`

这说明 autocompact 的阈值不是“快占满窗口时再说”，而是从一开始就把“压缩本身也要吃 token”算进预算。

### 2.2 它同时维护 warning / error / auto-compact / blocking 四个阈值

`autoCompact.ts` 明确区分：

- `AUTOCOMPACT_BUFFER_TOKENS = 13_000`
- `WARNING_THRESHOLD_BUFFER_TOKENS = 20_000`
- `ERROR_THRESHOLD_BUFFER_TOKENS = 20_000`
- `MANUAL_COMPACT_BUFFER_TOKENS = 3_000`

`calculateTokenWarningState()` 会给出：

- `percentLeft`
- `isAboveWarningThreshold`
- `isAboveErrorThreshold`
- `isAboveAutoCompactThreshold`
- `isAtBlockingLimit`

证据：

- `claude-code-source-code/src/services/compact/autoCompact.ts:62-145`

这意味着 Claude Code 不是单阈值控制，而是把“提示用户”“触发自动压缩”“彻底阻塞”拆成不同状态。

### 2.3 它有一套非常明确的触发抑制规则

`shouldAutoCompact()` 直接禁止或抑制若干场景：

- `querySource === 'session_memory'` 或 `querySource === 'compact'`，防止 forked agent 递归死锁。
- `marble_origami` 在 context collapse 场景下不应触发 autocompact。
- `DISABLE_COMPACT`、`DISABLE_AUTO_COMPACT`、用户设置都能关掉自动压缩。
- reactive-only 模式开启时，压制 proactive autocompact，让 413 恢复链接管。
- context collapse 已接管上下文管理时，主动压制 autocompact，避免“抢跑”并破坏更细粒度的 collapse。

证据：

- `claude-code-source-code/src/services/compact/autoCompact.ts:147-239`

这段注释非常重要。源码作者不是在调一个数字，而是在协调多个上下文管理子系统的主导权。

### 2.4 它有 circuit breaker，避免把失败当重试循环

`MAX_CONSECUTIVE_AUTOCOMPACT_FAILURES = 3`。  
`autoCompactIfNeeded()` 在连续失败次数达到上限后直接停止尝试，避免上下文已不可恢复时继续浪费 API 调用。

同时，自动压缩会先试 `trySessionMemoryCompaction()`，失败后才进入 `compactConversation()`。

证据：

- `claude-code-source-code/src/services/compact/autoCompact.ts:67-70`
- `claude-code-source-code/src/services/compact/autoCompact.ts:241-342`

从第一性原理看，这里解决的是“恢复机制本身也可能成为故障放大器”的问题。

## 3. 轻量层：microcompact 的目标是删噪音，不是写摘要

### 3.1 只有部分工具结果会被视为 compactable

`COMPACTABLE_TOOLS` 明确只包含：

- 文件读写
- shell
- `Grep`
- `Glob`
- `WebSearch`
- `WebFetch`

证据：

- `claude-code-source-code/src/services/compact/microCompact.ts:38-50`

这说明 microcompact 的主要对象不是“所有历史”，而是高体积、高重复、可被再生的工作痕迹。

### 3.2 它维护一份独立的 cached microcompact 状态

`microCompact.ts` 内部维护：

- `cachedMCModule`
- `cachedMCState`
- `pendingCacheEdits`
- `pinnedEdits`

并提供：

- `consumePendingCacheEdits()`
- `getPinnedCacheEdits()`
- `pinCacheEdits()`
- `markToolsSentToAPIState()`
- `resetMicrocompactState()`

证据：

- `claude-code-source-code/src/services/compact/microCompact.ts:52-135`

这意味着 cached microcompact 不是一次性变换，而是一个跨 turn 的小型状态机。

### 3.3 cached microcompact 的关键点是“消息不变，API 层编辑”

当 `feature('CACHED_MICROCOMPACT')` 可用且模型支持时，`cachedMicrocompactPath()`：

1. 扫描 compactable tool_use / tool_result。
2. 记录哪些结果已注册，按 user message 分组。
3. 计算 `toolsToDelete`。
4. 生成 `cache_edits`，写入 `pendingCacheEdits`。
5. 返回原始 `messages`，不直接改本地 transcript。

证据：

- `claude-code-source-code/src/services/compact/microCompact.ts:253-399`

这是一种很强的设计信号：Claude Code 希望优先利用服务端缓存编辑，在不改本地消息历史的前提下降低后续请求输入。

### 3.4 time-based microcompact 走另一条路径：直接清空旧 tool result 内容

如果 assistant 上次响应距离现在已超过设定 gap，说明缓存大概率已冷。  
这时 `maybeTimeBasedMicrocompact()` 会：

- 保留最近 `N` 个 compactable tool result
- 把更早的结果内容替换为 `[Old tool result content cleared]`
- 记录 `tokensSaved`
- 重置 cached MC state
- 通知 cache break detector 这是“合法下降”

证据：

- `claude-code-source-code/src/services/compact/microCompact.ts:401-520`

因此 microcompact 并不是单算法：

1. 热缓存时，优先做 cache editing。
2. 冷缓存时，优先做本地内容清空。

### 3.5 它严格限制主线程范围

`isMainThreadSource()` 与 `microcompactMessages()` 的逻辑刻意避免 forked agents 把自己的 tool result 注册进共享 cachedMCState。

证据：

- `claude-code-source-code/src/services/compact/microCompact.ts:243-293`

这说明作者很清楚：跨 agent 共享“压缩状态”会直接破坏一致性。

## 4. 重压缩层：`compactConversation()` 真正负责重建上下文

### 4.1 在进入 summarizer 前，先做输入瘦身

`compact.ts` 在发送 compact 请求前会：

- `stripImagesFromMessages()`，把图片和文档替换为 `[image]` / `[document]`
- `stripReinjectedAttachments()`，剔除那些稍后本来就会重注入的 attachment

证据：

- `claude-code-source-code/src/services/compact/compact.ts:133-223`

这背后的逻辑不是“删除信息”，而是“把不必占用 summarizer token 的内容用更便宜的标记表示”。

### 4.2 compact request 自己也可能 prompt-too-long，所以还有 PTL retry

如果 compact 的摘要请求本身触发 `PROMPT_TOO_LONG_ERROR_MESSAGE`，  
`truncateHeadForPTLRetry()` 会按 API round 分组，从最旧的头部裁掉若干组；如果无法解析 token gap，就退化为删掉约 `20%` 组。

证据：

- `claude-code-source-code/src/services/compact/compact.ts:225-291`
- `claude-code-source-code/src/services/compact/compact.ts:445-491`

这是一个非常务实的兜底：即使“压缩器也被上下文压爆”，系统仍然尽量把用户从死局里救出来。

### 4.3 summary 生成优先复用主线程 prompt cache

`streamCompactSummary()` 会先尝试 `runForkedAgent()`：

- 复用主线程 cache-safe params
- 共享主会话 prompt cache
- 避免 `maxOutputTokens` 造成 thinking config mismatch

只有失败时，才退回常规 `queryModelWithStreaming()` 路径。

证据：

- `claude-code-source-code/src/services/compact/compact.ts:1136-1250`

这说明 compact 不是旁路请求，而是深度依赖主循环缓存策略的正式子流程。

### 4.4 fallback streaming 不是盲流式摘要，而是带工具/权限语义的精简调用

常规 streaming fallback 会：

- 仅保留 boundary 后消息与当前 summaryRequest
- 继续走 `normalizeMessagesForAPI(...)`
- 仅带 `FileReadTool`，必要时带 `ToolSearchTool` 和 MCP tools
- 显式关闭 thinking
- 对 compact 自己设置 `maxOutputTokensOverride`

证据：

- `claude-code-source-code/src/services/compact/compact.ts:1250-1395`

这里的设计重点是：compact 虽然是特殊请求，但仍然复用统一 API 语义，而不是另写一套私有 summarizer 协议。

### 4.5 post-compact context 会被重新“搭骨架”

`compactConversation()` 在拿到 summary 后不会只留下“一条摘要”，而是重建：

- compact boundary
- compact summary user message
- 最近文件附件
- async agent 附件
- plan attachment
- plan mode attachment
- invoked skills attachment
- deferred tools delta
- agent listing delta
- MCP instructions delta
- session start hook messages

证据：

- `claude-code-source-code/src/services/compact/compact.ts:531-585`
- `claude-code-source-code/src/services/compact/compact.ts:596-748`
- `claude-code-source-code/src/services/compact/compact.ts:1415-1515`

这很关键：Claude Code 压缩的不是“能力环境”，而是“冗余对话历史”。  
能力环境会被重新宣布，避免模型在压缩后失去工具、计划、技能、MCP 等工作语境。

## 5. Session memory compaction 是保尾巴、不重写全部历史

### 5.1 它受独立 gate 和独立配置控制

session memory compact 默认配置：

- `minTokens = 10_000`
- `minTextBlockMessages = 5`
- `maxTokens = 40_000`

同时依赖：

- `tengu_session_memory`
- `tengu_sm_compact`

还支持环境变量强制开关。

证据：

- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:44-130`
- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:399-432`

### 5.2 它最在意 API invariant，而不是简单切片

`adjustIndexToPreserveAPIInvariants()` 会主动往前扩展保留区间，避免两类破坏：

1. tool_use / tool_result 被拆断，导致 orphan tool_result。
2. 同一 `message.id` 的 thinking / tool_use 分块被截断，导致 `normalizeMessagesForAPI()` 后信息丢失。

证据：

- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:188-314`

`calculateMessagesToKeepIndex()` 则在 `minTokens`、`minTextBlockMessages`、`maxTokens` 之间找平衡，并且不会跨过最近的 compact boundary。

证据：

- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:316-397`

这说明 session memory compact 的目标不是“最短摘要”，而是“保留一个对 API 仍然合法、对当前工作仍然有用的 tail working set”。

### 5.3 它把 session memory 当 summary，把 recent tail 当 preserved segment

`createCompactionResultFromSessionMemory()` 会：

- 用 session memory 内容生成 compact summary
- 必要时附上完整 memory 文件路径
- 继续创建 boundary marker
- 用 `annotateBoundaryWithPreservedSegment()` 记录 preserved tail 的 relink 信息

证据：

- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:434-503`

与传统 compact 相比，这更像“把旧历史沉淀到 durable memory，再保留近期工作尾部”。

## 6. API-native context management：把一部分压缩责任交回 API

`apiMicrocompact.ts` 定义了两类原生编辑策略：

1. `clear_tool_uses_20250919`
2. `clear_thinking_20251015`

它会根据：

- `hasThinking`
- `isRedactThinkingActive`
- `clearAllThinking`
- `USE_API_CLEAR_TOOL_RESULTS`
- `USE_API_CLEAR_TOOL_USES`
- `API_MAX_INPUT_TOKENS`
- `API_TARGET_INPUT_TOKENS`

来决定是否返回 `ContextManagementConfig`。

证据：

- `claude-code-source-code/src/services/compact/apiMicrocompact.ts:34-153`

这里最值得注意的点有两个：

1. thinking 清理与 tool 清理已经被统一建模为 API edits。
2. tool clearing 仍然是 `ant` 用户专属路径，说明这不是普适公共承诺。

## 7. 从第一性原理看，这套算法在优化什么

如果从“让 agent 长时间继续工作”出发，Claude Code 的 compact 体系优化的是四个目标：

1. 尽量先删可再生噪音，再删真正的语义上下文。
2. 尽量保留当前 working set，而不是把所有历史压平。
3. 尽量让压缩与缓存协同，而不是每次压缩都重建全部成本。
4. 尽量维护 API invariant，让恢复链不引入新的协议错误。

所以它不是“摘要算法合集”，而是一套上下文生命周期管理系统。

## 8. 事实与推论边界

直接事实：

- autocompact 有独立阈值、抑制条件和 circuit breaker。
- microcompact 至少有 cached path 和 time-based path。
- 传统 compact 会做图像剥离、PTL retry、post-compact attachment 重建。
- session memory compact 明确维护 tool pair 与 thinking merge invariant。
- API-native context management 已有 thinking/tool clearing schema。

较强推论：

- Claude Code 在压缩策略上遵循“最小破坏优先”原则。
- cached microcompact 的设计目标之一是把上下文回收和 prompt cache 命中绑定起来。
- session memory compact 代表团队在探索“摘要从对话历史迁移到 durable memory”的方向。

这些推论都能从注释和控制流得到强支持，但仍应和“当前 build 是否公开启用”分开理解。

## 9. 和其他章节怎么配合读

- 想看宏观恢复链，回到 [上下文压缩与恢复链](06-%E4%B8%8A%E4%B8%8B%E6%96%87%E5%8E%8B%E7%BC%A9%E4%B8%8E%E6%81%A2%E5%A4%8D%E9%93%BE.md)
- 想看主线结论，回到 [功能全景与 API 支持](../bluebook/05-%E5%8A%9F%E8%83%BD%E5%85%A8%E6%99%AF%E4%B8%8EAPI%E6%94%AF%E6%8C%81.md)
- 想看第一性原理，回到 [第一性原理与苏格拉底反思](../bluebook/06-%E7%AC%AC%E4%B8%80%E6%80%A7%E5%8E%9F%E7%90%86%E4%B8%8E%E8%8B%8F%E6%A0%BC%E6%8B%89%E5%BA%95%E5%8F%8D%E6%80%9D.md)
