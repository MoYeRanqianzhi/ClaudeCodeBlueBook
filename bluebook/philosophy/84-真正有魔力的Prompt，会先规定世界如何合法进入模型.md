# 真正有魔力的Prompt，会先规定世界如何合法进入模型

这一章回答五个问题：

1. 为什么 Claude Code 的 Prompt 魔力首先不是文案强，而是世界编译强。
2. 为什么 `authority chain`、`section registry`、`protocol transcript` 与 `lawful forgetting` 共同决定 Prompt 上限。
3. 为什么很多团队模仿 Prompt 时，最容易复制到外观，复制不到魔力。
4. 怎样用苏格拉底式追问审一个新 runtime 是否真的拥有这种 Prompt 能力。
5. 这对 Agent runtime 设计者意味着什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/systemPromptSections.ts:16-65`
- `claude-code-source-code/src/constants/prompts.ts:491-576`
- `claude-code-source-code/src/utils/systemPrompt.ts:28-123`
- `claude-code-source-code/src/utils/api.ts:321-405`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:188-327`
- `claude-code-source-code/src/query/stopHooks.ts:84-214`
- `claude-code-source-code/src/utils/forkedAgent.ts:46-126`
- `bluebook/architecture/82-请求装配流水线：authority chain、section registry、protocol transcript、lawful forgetting与cache-safe forks.md`

## 1. 先说结论

真正有魔力的 Prompt，不是：

- 更长
- 更聪明
- 更会模仿专家说话

而是：

- 它先规定世界如何合法进入模型

这里的“世界”不是抽象比喻，而是：

1. 谁能宣布当前真相
2. 哪些 section 构成正式 Prompt 宪法
3. 哪条 transcript 配进入模型
4. 哪些动态事实必须晚绑定
5. 忘掉什么之后系统仍然合法继续
6. 旁路循环如何复用同一个世界，而不是重造平行世界

Prompt 的魔力，首先来自：

- 世界先被编译

## 2. 第一性原理：Prompt 首先是一道世界准入法律

如果 Prompt 只负责：

- 告诉模型应该怎么做

那么它仍然停留在 instruction 层。

Claude Code 更深的一层是：

- 它先决定什么配被模型看见、谁配被模型相信、哪些历史配被模型继承

这会把 Prompt 从：

- 说服工具

改写成：

- 准入工具

也就是说，Prompt 真正的魔力首先不是“表达能力”，而是：

- 世界准入能力

## 3. 最容易被误写成什么

这一层最容易被误写成五种坏解法：

1. 更长的 system prompt
   - 以为信息更全就更强
2. UI transcript 直接就是模型 transcript
   - 以为看见什么，模型就该直接消费什么
3. summary 就等于 lawful forgetting
   - 以为会总结就等于还能继续
4. 每条 side loop 都可以各自重述现场
   - 以为并行只是多开几个 agent
5. 工具 ABI 在 Prompt 外面，不算 Prompt 本体
   - 以为工具 schema、cache 断点、continue 资格只是外围实现细节

这些误写的共同问题在于：

- 它们都把世界编译重新退回世界描述

## 4. 为什么这类误写会直接杀死 Prompt 魔力

一旦系统退回上述坏解法，马上会发生三类失真：

1. 主语漂移
   - 多份文本争主权
2. 历史漂移
   - display truth 与 protocol truth 混写
3. 连续性漂移
   - compact 之后留下的是叙事，不是仍可继续行动的对象

所以 Prompt 魔力真正保护的不是：

- 当前这轮回答更顺

而是：

- 当前、下一步、接手后都还活在同一个现场

## 5. 苏格拉底式追问

如果要审一个新 runtime 是否真的拥有这种 Prompt 能力，先问：

1. 现在是谁在定义世界；如果多份文本冲突，谁赢。
2. Prompt 是 blob，还是有正式 section 宪法。
3. 模型看到的 transcript 与人类看到的 transcript 是不是同一回事。
4. compact 后保住的是行动语义，还是只是更好读的摘要。
5. side loop、suggestion、memory extraction 与 worker summary 是否围绕同一 stable prefix 复用。
6. 工具 ABI、continue 资格与 cache break 原因，是否已进入 Prompt 真相本体。
7. 如果去掉“写得像专家”的文案风格，这套系统还能不能继续活在同一个现场。

## 6. 对 Agent Runtime 设计者的直接启发

如果你想复制 Claude Code 的 Prompt 强度，先复制：

1. 单一主权链
2. section registry
3. protocol transcript 编译
4. lawful forgetting
5. cache-safe fork reuse

而不是先复制：

- 某段著名措辞

## 7. 一句话总结

真正有魔力的 Prompt，会先规定世界如何合法进入模型；如果这一步没有先成立，后面的 Prompt 再华丽，也只是更高明的文案。
