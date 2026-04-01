# 语义压缩器：Claude Code如何把工作现场压成可继续行动的最小语义体

这一章回答五个问题：

1. 为什么 Claude Code 的 prompt 设计不只是“把世界编成语法”，还在持续把工作现场压成可行动的最小语义体。
2. 为什么 session memory、prompt suggestion、stop hooks、tool result replacement 应该放在同一张图里看。
3. 为什么它追求的不是“保留更多原文”，而是“保留更多可继续工作的语义”。
4. 为什么这套设计会让 prompt 看起来有魔力。
5. 这条线对 agent runtime 构建者意味着什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/services/SessionMemory/sessionMemory.ts:303-345`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts:184-240`
- `claude-code-source-code/src/query/stopHooks.ts:84-120`
- `claude-code-source-code/src/utils/toolResultStorage.ts:367-430`
- `claude-code-source-code/src/utils/analyzeContext.ts:1340-1385`
- `claude-code-source-code/src/utils/contextSuggestions.ts:30-110`

## 1. 先说结论

Claude Code 在 prompt 上做的，不只是：

- 把世界写成稳定语法

它还反复做另一件事：

- 把工作现场压成可继续行动的最小语义体

这和“文本更短”不是一回事。

它真正保留的是：

1. 当前任务意图。
2. 下一步可行动作。
3. 仍然有效的状态约束。
4. 对未来回合仍有价值的工作线索。

换句话说，Claude Code 在做的不是：

- 原文压缩

而是：

- 行动语义压缩

## 2. session memory 说明它想保住的是“未来还会用到的语义”

`sessionMemory.ts` 的关键点不只是它会抽取记忆。

更关键的是：

- 它用 isolated context 读当前状态
- 构造 update prompt
- 再用 `runForkedAgent(...)` 在 cache-safe params 上做抽取

这说明 session memory 的目标不是：

- 事后再总结一下聊过什么

而是：

- 从当前工作现场里抽出未来仍有行动价值的语义核

所以它优先保住的是：

- 以后继续做事时还会需要什么

而不是：

- 今天所有原文都原样留下来

## 3. prompt suggestion 说明 Claude Code 在压缩“下一步最可能动作”

`executePromptSuggestion(...)` 的重要意义，不是一个补全功能。

它实际上在做一种：

- 对用户下一步意图的行动语义压缩

这里它会：

- 复用 `cacheSafeParams`
- 从当前 messages 和 app state 里生成 suggestion
- 在 speculation 打开时继续旁路推演

这意味着 suggestion 不是随机猜一句用户要说的话。

它是在把：

- 用户接下来最可能的动作语义

抽成一个更短、更可执行的表面。

所以 prompt suggestion 不是 UI 小功能，而是整套语义压缩系统的一支。

## 4. stop hooks 说明“本轮工作语义”要被及时快照

`stopHooks.ts` 在主线程 query 结束时主动：

- 构造完整 REPLHookContext
- 生成 `cacheSafeParams`
- 保存给后续 side loops 使用

这一步非常关键。

因为 Claude Code 显然知道：

- 一轮主查询结束后，真正值钱的不是整段原始历史

而是：

- 那个仍然能让 side loops 继续工作的语义快照

也就是说，stop hook 保存的不是“聊天材料”，而是：

- 可继续工作的语义压缩包

这就是为什么 `/btw`、suggestion、session memory 这些旁路循环还能显得聪明。

它们不是各自重看整个世界，而是在消费已经被压过一次的语义体。

## 5. tool result replacement 说明 Claude Code 连“结果命运”都要被冻结

`toolResultStorage.ts` 最成熟的地方之一，是 replacement state 会记录：

- 哪些 result 已经见过
- 哪些被替换成 preview
- preview 具体长什么样

一旦 fate 被决定，后续就不再反复计算。

这说明 Claude Code 不只是担心：

- token 太多

它更担心：

- 同一个工具结果在不同轮里被压成不同语义形状

那样不仅 cache 会碎，模型对同一现场的理解也会漂。

所以它要冻结的其实不是字节本身，而是：

- 该结果在语义压缩体系里的命运

## 6. analyzeContext 与 suggestions 说明“注意力预算”也被语义化了

`analyzeContext.ts` 并不满足于告诉你：

- 现在多少 token

它还告诉你：

- memory files 在占什么
- tool results 在占什么
- deferred tools 在占什么
- systemPromptSections 在占什么
- message breakdown 长成什么样

`contextSuggestions.ts` 更进一步，把这些对象翻译成：

- near capacity
- large tool result bloat
- read result bloat
- memory bloat

这说明 Claude Code 在观测的不是抽象 token，而是：

- 哪些对象正在吞掉模型和用户的注意力

因此这条线最深的理解其实是：

- 语义压缩不仅在压模型上下文，也在压人类认知负担

## 7. 为什么这条线解释了 prompt 的“魔力”

Claude Code 的 prompt 之所以看起来有魔力，是因为它每一轮都在做三步：

1. 把工作世界编成稳定语法。
2. 把当前现场压成最小可行动语义体。
3. 把这个语义体复用给旁路循环和后续回合。

所以它不是：

- 每次都带着全部原始世界重新思考

而是：

- 每次都带着被 runtime 过滤和压缩后的行动语义继续工作

这比“文案更强”更接近本体。

## 8. 一句话总结

Claude Code 的 prompt 魔力更深的一层，不在于它把世界写成了更漂亮的 prompt，而在于它持续把工作现场压成可继续行动的最小语义体，并让主线程和旁路循环共享这份压缩后的行动语义。
