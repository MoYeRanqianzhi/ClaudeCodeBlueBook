# 真正有魔力的Prompt，首先会约束自己如何继续

这一章回答五个问题：

1. 为什么真正强的 Prompt 不该再被理解成“一轮里说得更好”。
2. 为什么主语、共享前缀、合法遗忘与接手连续性必须一起看。
3. 为什么 Prompt 的深层魔力来自它如何继续，而不是它如何开场。
4. 为什么一个不能自我约束继续方式的 Prompt Constitution 最终会退回文案堆。
5. 这对 agent runtime 设计者意味着什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/systemPrompt.ts:28-127`
- `claude-code-source-code/src/query/stopHooks.ts:84-120`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts:184-270`
- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:188-397`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:28-520`

这些锚点共同说明：

- Claude Code 的 Prompt 魔力，不在于它一次说服了模型，而在于它约束了当前、下一步与接手后如何继续服从同一套工作主语。

## 1. 先说结论

真正有魔力的 Prompt，不是：

- 让模型当前这一轮更像懂你

而是：

1. 先固定谁代表谁发言。
2. 先固定哪些字节属于共享前缀资产。
3. 先固定哪些事实该进入边界内，哪些应留在边界外。
4. 先固定删掉什么以后系统仍然能继续。
5. 先固定后来者怎样接手，而不必重新读完全部历史。

从第一性原理看，Prompt 的更深魔力不是：

- 让模型更会回答

而是：

- 让系统更会继续

## 2. 第一层：主语稳定优于文案强势

一个长任务真正最容易失去的，不是某段 instruction，而是：

- 当前到底是谁在说话

如果主语在不同入口、不同宿主、不同回合之间漂移，Prompt 再强也只是在局部碰巧生效。

这就是为什么 Claude Code 会把角色主权链、coordinator / agent 区分、sticky prompt 与 side-loop 共享前缀都写进同一套制度里。

因为真正决定“还能不能继续像同一个系统”的，不是措辞，而是：

- 当前主语是否稳定

## 3. 第二层：共享前缀优于重复讲背景

很多系统以为要保住 Prompt 魔力，就该：

- 每次把背景讲得更全

Claude Code 相反。

它更像在问：

- 谁是唯一合法的共享前缀生产者

只要主线程已经生产出 cache-safe prefix，旁路循环就应该复用，而不是各自再造一套“差不多的世界”。

所以它的魔力不是：

- 背景更多

而是：

- 背景生产权更集中

## 4. 第三层：合法遗忘优于无限保留

如果一个 Prompt 只能靠“尽量别忘”维持强度，它迟早会在长任务里崩掉。

Claude Code 更成熟的地方在于，它同样认真设计：

- 忘掉什么后系统仍然合法

这意味着 Prompt 魔力并不只是来自注入更多信息，还来自：

- 删除策略
- 压缩策略
- 恢复补边策略

也就是说，一个真正强的 Prompt Constitution 必须同时规定：

- 怎样记
- 怎样忘
- 忘完后怎样继续

## 5. 第四层：接手连续性优于单轮表现

Prompt 若只让模型此刻更顺，却让人类和后续系统更难接手，那种“强”没有长期价值。

Claude Code 的高阶之处在于：

- suggestion 组织下一步
- session memory 组织 handoff
- transcript repair 组织恢复后的继续

所以它的 Prompt 魔力不只是：

- 让这一轮回答更好

而是：

- 让接下来的继续成本更低

## 6. 第五层：可解释失效优于神秘成功

如果一个 Prompt 只能产生效果，却不能解释：

- 为什么这次稳定
- 为什么这次失稳

那么它仍更接近咒语，而不是制度资产。

Claude Code 值得学的地方正在于：

- 它给 Prompt 做 break detection
- 做 token breakdown
- 做 invalidation
- 做恢复与补边

这说明它追求的不是：

- 神秘成功

而是：

- 可解释继续

## 7. 苏格拉底式追问

### 7.1 如果 Prompt 真正强只是因为文案更好，为什么它还要规定谁有权继续说下去

因为长期运行的系统里，真正稀缺的不是好句子，而是：

- 继续工作的主语秩序

### 7.2 如果 Prompt 魔力来自更多上下文，为什么 Claude Code 还要认真设计遗忘与压缩

因为长任务里真正要保住的从来不是更多文本，而是：

- 继续行动所需的最小合法真相

### 7.3 如果 Prompt 的强只是当前回合表现，为什么 suggestion、memory 与 handoff 也必须被一并治理

因为一个真正强的 Prompt，不只组织当前输出，还组织：

- 下一步输入
- 未来接手
- 恢复后的继续

## 8. 对 Agent 设计者的启发

如果想学 Claude Code，最该抄走的不是：

- 某一段 system prompt 文案

而是：

1. 先固定主语，而不是先追求措辞。
2. 先固定共享前缀生产权，而不是允许多路重复造世界。
3. 先设计合法遗忘，而不是只设计注入。
4. 先设计接手连续性，而不是只设计单轮表现。
5. 先让 Prompt 的失效可解释，而不是让它继续神秘地“看起来很强”。
