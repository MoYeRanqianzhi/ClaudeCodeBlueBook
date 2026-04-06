# Prompt不是一次请求而是可复用前缀资产

这一章回答四个问题：

1. 为什么 Claude Code 的 prompt 不应被理解成“一次请求里的那段文本”。
2. 为什么真正难抄走的不是 system prompt，而是 prefix asset。
3. `/btw`、suggestion、memory、summary、dream 共用前缀说明了什么。
4. 这对 agent 平台设计者有什么第一性原理启发。

## 0. 代表性源码锚点

- `claude-code-source-code/src/query/stopHooks.ts:92-99`
- `claude-code-source-code/src/commands/btw/btw.tsx:183-227`
- `claude-code-source-code/src/cli/print.ts:2274-2298`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts:184-221`
- `claude-code-source-code/src/services/SessionMemory/sessionMemory.ts:315-325`
- `claude-code-source-code/src/services/extractMemories/extractMemories.ts:371-427`
- `claude-code-source-code/src/services/autoDream/autoDream.ts:224-233`
- `claude-code-source-code/src/services/AgentSummary/agentSummary.ts:81-109`
- `claude-code-source-code/src/utils/forkedAgent.ts:70-141`

## 1. 先说结论

这一页现在不再把“可复用前缀资产”写成 Prompt 的第二前门，而只解释六个 nouns 里的两段：

- `Boundary -> Continuation`

Claude Code 最值得迁移的，不是一段特别会写的 system prompt，而是：

- 它把同一世界的 boundary 沉淀成可复用 prefix asset

这意味着 prompt 的本体不是：

- 当前请求里那段文字

而是：

- 哪些前缀字节必须保持稳定
- 哪些状态只能晚绑定进入当前 transcript
- 哪些 fork 还能继续吃主线程 cache
- 哪些 side loops 必须沿同一 continuation object 前进

## 2. 为什么 prefix asset 首先属于 Boundary

如果 prompt 只是单轮文本，那么 `/btw`、prompt suggestion、memory extraction、summary、dream 都会像独立的小系统。

Claude Code 显然不是这样写的。

它更接近：

1. 主线程先生产 cache-safe boundary。
2. 旁路循环再在这份 boundary 上分叉。
3. 动态现场继续通过 attachments、memory、summary 等对象晚绑定。

所以“前缀资产”首先说明的不是“Prompt 会复用”，而是：

- 同一世界先被 boundary 固定住了

也因此，真正该守的不是“多一个共享前缀优化”，而是：

- stable prefix 不被高波动状态打碎
- tool ABI 不把 built-in 与 late MCP 混写进同一段前缀
- forked agent 只在 cache-safe contract 上继续，而不是临时重讲一遍世界

## 3. 为什么 side loops 首先属于 Continuation

`/btw`、suggestion、memory、summary、dream 之所以能共用前缀，不是因为它们“都像 Prompt 工具”，而是因为它们都在回答同一个 continuation 问题：

- 当前工作对象接下来怎样继续同一世界

这些路径之间共享的真正资产不是文案，而是：

1. 当前工作主语仍是谁。
2. 哪些 guard 仍然有效。
3. 哪些资产必须继续保留。
4. 哪些对象必须在新的 continuation 里重新确认。

所以这页真正想说明的是：

- prefix asset 不是独立哲学，而是 continuation object 的物质条件

如果 shared prefix 被写成单独神技，later maintainer 很容易又把 `/btw`、summary、memory 写成几条“像主线程”的旁路故事。

## 4. 苏格拉底式追问

### 4.1 如果主线程已经很强，为什么还要在意旁路循环

因为现代 agent 系统真正值钱的能力，越来越多发生在主线程之外：

- 建议下一步
- 提炼 memory
- 总结 transcript
- 做长期 consolidation

如果这些循环不能共享同一 prefix contract，它们迟早会和主线程长成多个世界模型。

### 4.2 为什么这比“prompt 写得更好”更值得学

因为更好的文案只能提升单次效果；可复用 prefix asset 能提升整台 runtime 的长期一致性、成本结构与 continuation 质量。

### 4.3 这一页最容易重新失真成什么

最容易退回两种坏写法：

1. 把 prefix asset 写成新的 Prompt frontdoor。
2. 把 shared prefix 写成“接着聊”的故事感，而不是 continuation object。

对应的 first reject signal 仍然是：

- `continuation_story_only`

## 5. 一句话总结

Claude Code 的 prompt 之所以强，不只是因为它会装配合同，而是因为它把 `Boundary -> Continuation` 这两段写成了可被 `/btw`、suggestion、memory、summary、dream 共用的 prefix asset。
