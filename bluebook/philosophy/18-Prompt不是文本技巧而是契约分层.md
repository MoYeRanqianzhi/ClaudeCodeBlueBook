# Prompt 不是文本技巧而是契约分层

这一章回答四个问题：

1. 为什么 Claude Code 的 prompt 强，不应被理解成“文案更聪明”。
2. 什么叫 prompt contract 的分层。
3. 为什么这比“写一段神 prompt”更接近第一性原理。
4. 蓝皮书接下来该如何避免再次写成 prompt 玄学。

## 1. 先说结论

Claude Code 的 prompt 本质上，不是把规则拆成四层而已，而是把 later consumer 原本要重做的世界重判、动作搜索与排除理由重写分配到不同稳定度的契约层里：

1. 静态法：
   - 角色基本法、做任务原则、工具使用原则；它定义不可重写约束与上层已排除分支
2. 动态法：
   - language、output style、memory、scratchpad、token budget、MCP instructions；它只实例化环境，不改写静态法已封口的边界，也不把 belonging-only 的 memory / style / scratchpad 升格成可改判的 witness
3. 角色法：
   - coordinator、worker、custom agent、proactive agent；它只能缩窄或显式委派，不凭空重开动作空间
4. 现场法：
   - attachments、nested memory、mailbox、plan/auto mode；它只能绑定当前对象与时点，不能复活上层已排除分支，也不能把 summary / session memory / handoff card 这类 belonging-only carrier 自升为 witness

静态法、动态法、角色法与现场法之所以值钱，不是因为“分层”这个动作本身，而是因为它们共同服务同一套 `decision-retirement system`：稳定 law 不乱抖、动态事实晚绑定、角色边界不越权、现场对象可合法继承。
更硬一点说，分层不是分桶，而是继承法：上层负责立法与排除，下层负责实例化、缩窄、委派与绑定对象，但不配把已退休的判断重新拉回候选集。
再补一条更硬的 admissibility 纪律：下层 carrier 只有在显式回绑 witness chain 后，才可能获得继续资格；晚绑定不等于自带签字权，现场对象也不配因为“更接近当前”就自动升级成 witness。
再压一层，这四层真正共同保住的也只剩三条 Prompt owner law：`lawful inheritance` 让不同 consumer 继承同一工作对象，`search-pruning` 让上层已排除分支继续保持被排除，`decision-retirement` 让没有新增 `decision delta` 的旧判断继续退役。
也就是说，prompt 并不是一段文本，而是一组约束在不同稳定度上的分层投影。

代表性证据：

- `claude-code-source-code/src/constants/prompts.ts:444-576`
- `claude-code-source-code/src/utils/systemPrompt.ts:28-122`
- `claude-code-source-code/src/utils/attachments.ts:817-913`
- `claude-code-source-code/src/coordinator/coordinatorMode.ts:120-280`

## 2. 从第一性原理看，agent 必须被告知五件事

一个长期工作的 coding agent，至少要知道：

1. 你是谁
2. 你能做什么
3. 你不能做什么
4. 你该如何协作
5. 你如何在有限成本下继续工作

如果把这五件事都挤进一段单文本 prompt，会立刻遇到两个问题：

1. 动态信息污染稳定前缀
2. 不同角色需要的约束完全不同

Claude Code 的做法更成熟：

- 让稳定规则稳定
- 让动态规则动态
- 让角色合同按角色拆开
- 让高波动信息通过附件晚绑定
- 让每一层都继承上层 exclusion discipline，而不是把分层写成四份彼此独立的提示词；若下层只能提供 carrier 而不能提供 witness，就不配改写继续资格

## 3. “提示词魔力”真正来自哪里

表面上，Claude Code 看起来像“prompt 很厉害”。  
但继续追问，就会发现真正厉害的是：

1. 它把 cache 稳定性写进了 prompt 结构。
2. 它把角色差异写进了 prompt 优先级。
3. 它把附件与状态提醒写进了 turn runtime。
4. 它把 worker 自包含、coordinator 先综合这些规则写成了系统法律。

这就是为什么 Claude Code 的 prompt 会显得：

- 更稳
- 更像在理解任务
- 更少出现“看似会了，下一轮又忘了”的漂移

更准确地说，它真正减少的不是“忘词”，而是 later consumer 再次重开世界协商、再次重搜动作空间，以及再次把旧判断从退役态拖回候选集的次数。

## 4. 为什么这比“更长的 prompt”更强

更长的 prompt 只能增加文字，不一定增加结构。  
Claude Code 则在增加结构：

1. `SYSTEM_PROMPT_DYNAMIC_BOUNDARY` 区分稳定前缀与动态尾部。
2. `systemPromptSection()` 区分 cache-safe section 与 cache-breaking section。
3. attachment pipeline 区分预装知识与晚绑定状态。
4. coordinator / worker prompt 区分综合职责与执行职责。

所以它强，不是因为：

- 说得更多

而是因为：

- 约束的分布更正确

## 5. 苏格拉底式追问：如果把 Claude Code 的 prompt 全文抄走，会得到什么

表面答案似乎是：

- 也许能得到相似效果

但继续追问：

1. 你有同样的动态 section registry 吗。
2. 你有同样的 attachment late binding 吗。
3. 你有同样的 task / mailbox / team context 协作协议吗。
4. 你有同样的 cache 稳定性约束吗。

如果没有，那么你抄走的大多只是：

- 合同文字

而不是：

- 合同真正依附的 runtime

## 6. 蓝皮书怎样才不会再次写成 prompt 玄学

至少要坚持三条：

1. 讲 prompt 时必须同时讲角色、attachments、cache、tools。
2. 看到效果时必须追问是哪个 runtime plane 在起作用。
3. 看到一段漂亮文本时必须追问：
   - 它依附的对象是谁。
   - 它何时被注入。
   - 它何时会失效或被替换。

## 7. 一句话总结

Claude Code 的 prompt 之所以有力量，不是因为它被分成几层，而是因为这些层一起保住 `lawful inheritance / search-pruning / decision-retirement` 与 later-consumer rights，从而让世界重判不必在每轮重做。
