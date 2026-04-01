# 稳定前缀、动态尾部与旁路Fork：Claude Code的Cache-Aware Prompt Assembly

这一章回答五个问题：

1. 为什么 Claude Code 的 prompt 组装不该被理解成“拼一段 system prompt”，而该被理解成 cache-aware assembly pipeline。
2. 为什么稳定前缀、动态尾部与 side-loop fork 共同构成 prompt 魔力的底盘。
3. 为什么高波动信息会被后移、附件化、delta 化，而不是直接污染主前缀。
4. 为什么 deferred tool 暴露、tool schema 稳定与 protocol transcript 整形，都属于 prompt 架构的一部分。
5. 这条链为什么比“再写几句更强的 prompt”更难抄。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/prompts.ts:104-114`
- `claude-code-source-code/src/constants/prompts.ts:343-355`
- `claude-code-source-code/src/constants/prompts.ts:492-510`
- `claude-code-source-code/src/constants/prompts.ts:560-578`
- `claude-code-source-code/src/constants/systemPromptSections.ts:17-50`
- `claude-code-source-code/src/utils/systemPrompt.ts:25-56`
- `claude-code-source-code/src/constants/common.ts:17-24`
- `claude-code-source-code/src/context.ts:116-165`
- `claude-code-source-code/src/utils/api.ts:300-340`
- `claude-code-source-code/src/tools.ts:345-364`
- `claude-code-source-code/src/utils/toolSchemaCache.ts:1-20`
- `claude-code-source-code/src/utils/attachments.ts:1448-1495`
- `claude-code-source-code/src/utils/mcpInstructionsDelta.ts:20-52`
- `claude-code-source-code/src/utils/toolSearch.ts:385-430`
- `claude-code-source-code/src/utils/toolSearch.ts:540-560`
- `claude-code-source-code/src/query.ts:1001-1001`
- `claude-code-source-code/src/query/stopHooks.ts:92-99`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts:184-220`
- `claude-code-source-code/src/services/PromptSuggestion/speculation.ts:402-420`
- `claude-code-source-code/src/services/PromptSuggestion/speculation.ts:740-759`
- `claude-code-source-code/src/services/SessionMemory/sessionMemory.ts:303-325`
- `claude-code-source-code/src/utils/messages.ts:1989-2045`

## 1. 先说结论

Claude Code 的 prompt 底盘，最值得升级的一层理解不是：

- 它有一段很强的 system prompt

而是：

- 它有一条 cache-aware prompt assembly pipeline

这条 pipeline 持续维持三个不变量：

1. 必须稳定的前缀尽量冻结。
2. 高波动内容尽量后移到动态尾部或 delta attachments。
3. 辅助智能尽量旁路 fork，并复用主线程已有前缀资产。

所以 Claude Code 的 prompt 魔力，不是“更聪明的措辞”先发生，而是：

- 更稳定的协议拓扑先发生

## 2. 第一层：系统 prompt 先被切成稳定前缀和动态尾部

`prompts.ts` 里最重要的符号之一是：

- `SYSTEM_PROMPT_DYNAMIC_BOUNDARY`

这不是注释性质的标记，而是 prompt 架构的正式边界。

它明确规定：

- 边界之前的内容可以尽量走跨组织缓存
- 边界之后的内容承认自己是 session/user-specific

`systemPromptSection(...)` 与 `DANGEROUS_uncachedSystemPromptSection(...)` 进一步把 dynamic 区再细分为：

- 默认可 memoize 的 section
- 明知会破 cache 的危险 section

这意味着 Claude Code 在 prompt 层做的第一件事不是：

- 再塞更多信息

而是：

- 先决定什么必须稳定

只有这件事先做对，后面的：

- cache scope
- section cache
- side loops

才有共同基础。

## 3. 第二层：会话级上下文本身也被稳定化

`getSessionStartDate()` 明确选择：

- 会话开始日期一旦确定，就不要在午夜自动刷新

`getSystemContext()` 与 `getUserContext()` 也都被 memoize 成：

- 按会话缓存

这说明 Claude Code 在 prompt 组装上有个非常成熟的倾向：

- 不是所有“更实时”的信息都值得立刻进入前缀

因为一旦它们高频变动，代价不只是：

- 多几行新文本

而是：

- 整段前缀 cache 被重置
- 后续所有 side loops 共享资产被击穿

所以这里的设计哲学其实是：

- 上下文先做稳定化，再谈丰富化

## 4. 第三层：工具暴露本身也是 prompt 组装问题

很多系统会把“prompt”和“tools”当成两块。

Claude Code 更像在说：

- 工具暴露就是 prompt 组装的一部分

### 4.1 built-in tools 必须形成稳定前缀

`tools.ts` 明确保持：

- built-ins 连续前缀
- MCP tools 作为后续分区

这不是 UI 偏好，而是为了保护：

- 服务端工具 schema 的缓存拓扑

### 4.2 tool schema 被 session-stable 化

`toolSchemaCache.ts` 直接写明：

- tool schema 位于请求前缀高位
- 任意字节变化都会击穿下游大块缓存

所以 Claude Code 宁可：

- 把 schema 锁成 session-stable

也不接受 mid-session 因 GrowthBook、MCP 连接或动态 prompt 导致 schema 抖动。

### 4.3 deferred tools 通过闭环逐步暴露

`toolSearch.ts` 说明 deferred tools 不是一开始全量暴露，而是：

1. 先暴露 ToolSearch。
2. 模型通过 `tool_reference` 发现某些 deferred tools。
3. runtime 把 discovered set 记入消息历史或 compact boundary。
4. 下一轮只回填已经被发现的 deferred tools。

这说明 Claude Code 并不想让模型一开始看见全部工具宇宙。

它更偏爱：

- 逐步暴露
- 闭环回填

## 5. 第四层：高波动信息被迁出主前缀，改成 delta attachments

`attachments.ts`、`mcpInstructionsDelta.ts` 说明 Claude Code 在反复做同一种迁移：

- 把会导致大块 cache bust 的信息，从主 prompt/tool description 迁到 persisted delta attachments

这里至少包括：

- deferred tools delta
- agent listing delta
- MCP instructions delta

这件事非常关键，因为它说明 Claude Code 的真正优化不是：

- 少说一点

而是：

- 把变化搬到尾部

这和“稳定前缀 + 动态尾部”是同一原则。

如果高波动信息留在主前缀里，系统每次 late connect、reload、permission-mode change 都会把整段 prompt 重新打碎。

把它们迁到 delta attachments 后，变化被局部化了。

## 6. 第五层：辅助智能被旁路化，而不是主循环膨胀

Claude Code 的另一个成熟点是：

- 它不把一切智能都塞回主线程 prompt

而是大量使用：

- forked side loops

`query/stopHooks.ts` 会保存：

- `CacheSafeParams`

随后这些旁路循环会直接复用这份前缀资产：

- prompt suggestion
- speculation
- session memory

它们的共同点不是“又写一版 prompt”，而是：

- 在共享主线程前缀的前提下，旁路做自己的工作

这说明 Claude Code 真正在维护的是：

- prefix asset network

不是：

- 一条越来越肥的主 prompt

## 7. 第六层：模型看到的是 protocol transcript，不是 UI transcript

`normalizeMessagesForAPI()` 进一步说明：

- 真正送给模型的 transcript，会被 runtime 再整形一次

这里会处理：

- attachment reorder
- virtual message 剥离
- synthetic error strip
- orphan / duplicate tool_use 清理

也就是说，Claude Code 的 prompt assembly 最后一步不是“把 UI 上看到的消息直接交给模型”，而是：

- 把 UI transcript 再编译成 protocol transcript

这能解释为什么它的 prompt 表现往往比“照着聊天记录重放”更稳。

因为它根本就没有把聊天记录当最终协议。

## 8. 为什么这条架构比 prompt 文案更难抄

因为它要求你同时拥有：

1. static/dynamic boundary
2. section cache
3. tool schema stability
4. deferred exposure feedback loop
5. delta attachments
6. cache-safe fork
7. protocol transcript normalization

少任意一层，你都很难同时得到：

- 稳定性
- 解释性
- 低 cache churn
- 多 side loop 复用

所以 Claude Code 难抄的部分不是一句 prompt，而是：

- 这整条 assembly pipeline

## 9. 一句话总结

Claude Code 的 prompt 魔力，本质上来自一条“稳定前缀 + 动态尾部 + 旁路 fork + 协议化 transcript”的 cache-aware 组装链，而不是来自单段 system prompt 的神奇措辞。
