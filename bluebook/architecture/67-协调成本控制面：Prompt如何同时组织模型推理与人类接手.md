# 协调成本控制面：Prompt如何同时组织模型推理与人类接手

这一章回答五个问题：

1. 为什么 Claude Code 的 prompt 不只在组织模型，也在组织人类后续怎么接手。
2. 为什么 sticky prompt、prompt suggestion、session memory、protocol transcript 应该放在同一张图里。
3. 为什么 Claude Code 真正在压缩的，还包括人类和模型之间的协调成本。
4. 为什么这条线比“更好的 UI”或“更好的 prompt”都更接近本体。
5. 这对 agent runtime 设计者意味着什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/screens/REPL.tsx:1188-1249`
- `claude-code-source-code/src/state/AppStateStore.ts:540-558`
- `claude-code-source-code/src/hooks/usePromptSuggestion.ts:1-140`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts:184-240`
- `claude-code-source-code/src/services/SessionMemory/sessionMemory.ts:303-345`
- `claude-code-source-code/src/utils/messages.ts:1989-2045`
- `claude-code-source-code/src/hooks/useBackgroundTaskNavigation.ts:24-220`

## 1. 先说结论

Claude Code 的 prompt 架构，真正高级的一层不只在：

- 模型这次看见什么

还在：

- 人类下一步怎样低成本接手

也就是说，它在同时组织两种后续行动：

1. 模型的下一步推理。
2. 人类的下一步接管、修正、确认、切换与导航。

这意味着 Claude Code 真正在优化的，不只是模型上下文质量，还包括：

- 人类-模型协调成本

## 2. sticky prompt 说明前台也在维护行动连续性

`REPL.tsx` 对 sticky prompt 的处理很能说明问题。

源码注释直接写明：

- divider / stickyPrompt 迁到 `FullscreenLayout`
- 目的是让滚动不反复重渲染 REPL
- 同时保持 placeholder 与输入锚点一致

这表明 sticky prompt 的作用不是视觉修饰，而是：

- 让人类在长历史、多异步事件、多后台任务里，始终知道“下一步从哪里继续”

也就是说，前台本身就在维护一种：

- 行动锚点连续性

## 3. prompt suggestion 说明系统在提前压缩“用户接下来最可能要做什么”

`AppStateStore` 把 `promptSuggestion` 做成正式状态对象，`usePromptSuggestion.ts` 进一步跟踪：

- shownAt
- acceptedAt
- generationRequestId
- focus 状态
- 首次击键时间

这说明 suggestion 不是“随手给个补全”。

它更像在做：

- 对人类下一步动作的低成本预组织

而 `executePromptSuggestion(...)` 又会复用 `cacheSafeParams` 和当前消息现场，所以 suggestion 实际上是：

- 建立在主线程已有语义压缩结果之上的下一步协作提示

因此这条线不是“模型帮助用户输入”，而是：

- runtime 减少人类和模型重新对齐现场的成本

## 4. session memory 说明系统在替未来的接手者保留最小必要语义

`sessionMemory.ts` 用隔离上下文和 forked agent 抽取会话记忆，不把抽取过程反向污染主线程。

这意味着 session memory 的价值不只是给模型看。

它其实也在为：

- 未来的自己
- 未来的人类接手者
- 未来的旁路循环

保留一份：

- 最小但足够继续工作的语义快照

这和 suggestion、sticky prompt 一起看，就会发现 Claude Code 在做同一件事：

- 减少重新理解现场的成本

## 5. protocol transcript 说明“给模型看的真相”和“给人看的真相”都在被组织

`normalizeMessagesForAPI()` 说明模型看到的不是 UI transcript 原样，而是被再编译后的 protocol transcript。

这看起来是在优化模型输入，实际上也在优化人与模型的协调。

因为只有当：

- 模型消费的协议真相足够稳定
- 人类消费的前台真相足够清晰

两者之间的协作成本才不会持续上升。

否则就会出现：

- 人类以为系统看见了 A
- 模型其实看见了 B
- 每一轮都要重新对齐现场

Claude Code 明显在主动避免这种分裂。

## 6. 后台导航与 teammate view 说明“人类接手路径”被做成正式运行时

`useBackgroundTaskNavigation.ts` 不是简单键盘快捷键。

它实际上在管理：

- leader / teammate 的切换
- viewing / selecting 的模式
- transcript 进入与退出
- 选中对象变化时的稳定导航

这说明 Claude Code 并不把“人类何时切去看别的执行链”当作外部偶发行为。

它把这种接手路径做成了正式控制面。

所以 prompt 架构的效果，不只体现在“模型能继续”，还体现在：

- 人类能在正确时间，以更低认知成本切回正确执行链

## 7. 为什么这条线比“更好的 UI”更接近本体

如果只把这些东西写成 UI 优化，你会低估它们的共同目标。

更准确的解释是：

1. sticky prompt 保住行动锚点。
2. suggestion 压缩下一步用户动作。
3. session memory 保住未来接手所需语义。
4. protocol transcript 维持人与模型真相分工。
5. teammate navigation 保持跨执行链接手路径低成本。

所以 Claude Code 的 prompt 真正不只在组织模型思考，也在组织：

- 人类怎样高效接手

## 8. 一句话总结

Claude Code 的 prompt 架构之所以强，不只因为它让模型更会思考，还因为它把人类-模型之间的接手路径做成了正式运行时，从而持续压低协调成本。
