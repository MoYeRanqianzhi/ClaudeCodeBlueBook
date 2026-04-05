# Prompt 不是文本技巧而是契约分层

这一章回答四个问题：

1. 为什么 Claude Code 的 prompt 强，不应被理解成“文案更聪明”。
2. 什么叫 prompt contract 的分层。
3. 为什么这比“写一段神 prompt”更接近第一性原理。
4. 蓝皮书接下来该如何避免再次写成 prompt 玄学。

## 1. 先说结论

Claude Code 的 prompt 本质上是一套分层契约：

1. 静态法：
   - 角色基本法、做任务原则、工具使用原则
2. 动态法：
   - language、output style、memory、scratchpad、token budget、MCP instructions
3. 角色法：
   - coordinator、worker、custom agent、proactive agent
4. 现场法：
   - attachments、nested memory、mailbox、plan/auto mode

也就是说，prompt 并不是一段文本，而是一组约束在不同稳定度上的投影。

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

Claude Code 的 prompt 之所以有力量，不是因为它更像咒语，而是因为它被组织成了一套分层契约。
