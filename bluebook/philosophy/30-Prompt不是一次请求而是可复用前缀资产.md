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

Claude Code 的 prompt 最值得迁移的，不是一段特别会写的 system prompt，而是：

- 它把 prompt 做成了可复用前缀资产

这意味着 prompt 的真正本体不是：

- 当前请求里那段文字

而是：

- 哪些字节级前缀可以被后续辅助循环复用
- 哪些状态允许附加，哪些状态必须保持一致
- 哪些 fork 可以继续吃主线程 cache，哪些 fork 不该打碎它

## 2. 为什么“前缀资产”比“单轮文本”更本质

如果 prompt 只是单轮文本，那么：

- `/btw` 是新问题
- prompt suggestion 是旁路生成
- memory extraction 是另一个后台任务
- summary 是额外后处理

这些路径之间不会共享什么真正重要的东西。

但 Claude Code 明显不是这样写的。

它更接近：

- 主线程不断生产 cache-safe prefix
- 辅助循环在这份 prefix 上分叉

这说明 prompt 在这里不是一次性话术，而是一种 runtime asset。

## 3. 为什么这条原则这么强

因为它同时解决了三类长期问题：

1. 成本：
   - 不必为每个辅助循环从零重建世界模型。
2. 一致性：
   - suggestion / memory / summary 与主线程共享同一合同，不易漂移。
3. 演化：
   - 只要主线程 prefix 结构稳定，旁路能力可以持续叠加，而不必各自发明 prompt 体系。

所以 Claude Code 的 prompt 魔力，很大一部分其实来自：

- 它允许魔力在不同循环之间继承

## 4. 苏格拉底式追问

### 问：如果主线程已经很强，为什么还要在意旁路循环

答：因为现代 agent 系统真正有价值的能力，越来越多发生在主线程之外：

- 建议下一步
- 提炼 memory
- 总结 transcript
- 做长期 consolidation

如果这些循环不能共享主线程前缀，它们迟早会和主线程分裂成多个世界模型。

### 问：为什么这比“prompt 写得更好”更值得学

答：因为更好的文案只能提升单次效果；可复用前缀资产则能提升整台 runtime 的长期一致性与成本结构。

## 5. 一句话总结

Claude Code 的 prompt 之所以强，不只是因为它会装配合同，而是因为它把这些合同沉淀成了可被 `/btw`、suggestion、memory、summary、dream 共用的前缀资产。
