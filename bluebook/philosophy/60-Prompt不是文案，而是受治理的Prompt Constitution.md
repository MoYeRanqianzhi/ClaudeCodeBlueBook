# Prompt不是文案，而是受治理的Prompt Constitution

这一章回答五个问题：

1. 为什么 Claude Code 的 prompt 不该再被理解成“一段更会写的 system prompt”。
2. 为什么 section 宪法、角色优先级链、合法遗忘和 transport 不变语义应该放在一起看。
3. 为什么 prompt 的“魔力”部分来自它如何被改、如何被删、如何被恢复，而不只是它如何被写。
4. 为什么 prompt 必须像协议一样可 diff、可观测、可解释。
5. 这对 agent runtime 设计者意味着什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/prompts.ts:105-560`
- `claude-code-source-code/src/constants/systemPromptSections.ts:17-43`
- `claude-code-source-code/src/utils/systemPrompt.ts:28-104`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/conversationRecovery.ts:226-297`
- `claude-code-source-code/src/services/compact/prompt.ts:12-206`
- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:188-397`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:28-520`
- `claude-code-source-code/src/utils/analyzeContext.ts:204-281`

这些锚点共同说明：

- Claude Code 的 prompt 早已不是一段文案，而是一份受 section 宪法、角色优先级、删除策略、恢复策略和观测策略共同治理的制度体。

## 1. 先说结论

更成熟的 prompt 设计，不是：

- 把 system prompt 写得更聪明

而是：

1. 先规定 prompt 由哪些 section 构成。
2. 先规定哪些 section 可以动态变化、哪些变化会打碎 cache。
3. 先规定不同角色 prompt 的优先级与叠加关系。
4. 先规定哪些消息根本不配进入 prompt 真相。
5. 先规定删掉什么之后系统仍然能继续工作。
6. 先规定 prompt 本身如何被 diff、被解释、被诊断。

也就是说，Claude Code 的 prompt 真正像一部：

- Prompt Constitution

它回答的不是“说什么更有效”，而是“什么构成 prompt 真相，谁有权改它，删到什么程度还合法，以及一旦变了如何被解释”。

## 2. 第一层：section 宪法优于整段文案

`prompts.ts` 并不是简单拼接长字符串，而是显式维护：

1. 静态可缓存块；
2. 动态注册块；
3. `SYSTEM_PROMPT_DYNAMIC_BOUNDARY`；
4. `systemPromptSection(...)` 与 `DANGEROUS_uncachedSystemPromptSection(...)` 两种不同地位的 section。

这说明 Claude Code 真正在治理的不是“system prompt 内容”，而是：

- 哪些内容属于稳定宪法；
- 哪些内容属于动态修正案；
- 哪些修正案一旦变化必须被视作危险 cache break。

从第一性原理看，prompt 的“魔力”首先不是生成效果，而是：

- 变更控制

如果连 prompt 的组成单元都没有被制度化，那么任何新能力进入系统时都只能靠：

- 把更多话堆进同一段文案

这会同时破坏：

- cache 稳定性
- 阅读可解释性
- 后续 diff 能力

## 3. 第二层：角色优先级链优于人格设定

`buildEffectiveSystemPrompt()` 展现的不是“给模型一个身份”，而是：

- override
- coordinator
- agent
- custom
- default
- append

这一整条角色优先级链。

所以 Claude Code 的 prompt 从来不是：

- “你是一个怎样的助手”

而是：

- 在这一轮里，谁有权定义当前运行身份

这也是为什么 Claude Code 的 prompt 魔力不该被写成“人格更稳定”，而应被写成：

- 角色权威顺序更稳定

因为真正决定行为上限的，不是哪句自我描述更漂亮，而是：

1. 当前是 coordinator 还是 agent；
2. 用户 override 是否盖过默认体系；
3. 某些模式下 agent prompt 是替换还是追加；
4. 不同 transport 是否仍服从同一角色合同。

## 4. 第三层：合法遗忘优于无限保留

Claude Code 的 prompt 设计最容易被忽略的一点是：

- 它同样认真设计了“怎样删”

`services/compact/prompt.ts`、`sessionMemoryCompact.ts`、`conversationRecovery.ts` 都说明：

1. compact 不是随便总结，而是保留 `user intent / current work / next step / direct quote` 这些正式槽位；
2. compact 不能切断 `tool_use / tool_result`、thinking block 或共享 `message.id` 的归属链；
3. 恢复时还会主动补 synthetic assistant sentinel，确保恢复后的 prompt 仍然 API-valid。

这说明 prompt Constitution 的另一半不是“写什么”，而是：

- 删掉什么以后仍然合法

也就是说，Claude Code 的 prompt 魔力部分来自：

- 合法遗忘

如果一个系统只会不断向 prompt 注入内容，却没有正式的删除宪法，它最终会得到：

- 更多文本
- 更少真相
- 更差 cache
- 更差恢复

## 5. 第四层：transport 不变语义优于载体差异

Claude Code 在不同 transport 上不断做一件事：

- 保住 prompt 真义，而不是保住每条原始消息

`normalizeMessagesForAPI(...)` 会剥掉 progress、virtual、synthetic error 等展示噪音；`conversationRecovery.ts` 会在坏掉的历史上补边；远程适配层也会过滤 echo、状态事件和不属于 prompt 真相的 display-only 消息。

这说明 Claude Code 不在保护：

- 载体一致

而在保护：

- 语义一致

从第一性原理看，这代表一个更高级的 prompt 观：

- prompt 不等于 transport payload；
- prompt 是多种 transport 之上的不变语义层。

这也是为什么 Claude Code 可以在 REPL、SDK、Bridge、remote viewer 之间切换，而 prompt 系统不会立刻散架。

## 6. 第五层：可观测 diff 优于神秘魔力

如果 prompt 真的是“写得有感觉”，就没必要做这些：

1. `promptCacheBreakDetection.ts` 对 system prompt、tool schema、cache control、betas、effort、extra body 做 hash 和 diff；
2. `analyzeContext.ts` 对 prompt sections 做 token breakdown；
3. 系统显式输出 cache break 解释，而不是只让用户感受“这轮怎么突然变贵了”。

Claude Code 之所以值得学，不是因为它把 prompt 维持成神秘资产，而是因为它在持续做：

- prompt observability

这意味着 prompt 在这里已经被提升成：

- 正式基础设施

它可以像协议、状态机和性能关键路径一样被：

- 检查
- 归因
- 解释
- 对比

真正成熟的 prompt 系统，不该只会产生效果，还必须会解释：

- 为什么这次效果稳定
- 为什么这次效果失稳
- 究竟是哪个 section、哪个 schema、哪个 header 让系统偏移了

## 7. 苏格拉底式追问

### 7.1 如果 prompt 只是一段文案，为什么它需要 section 宪法

因为真正难的不是写出一段看似聪明的话，而是：

- 在系统持续增长时，知道新增哪一段会破坏哪一种稳定性。

### 7.2 如果 prompt 只是模型输入，为什么还要设计合法遗忘

因为长期运行的 agent 不是在求一次最强输入，而是在求：

- 多次删改后仍能继续工作的最小合法真相。

### 7.3 如果 prompt 魔力只是措辞，为什么还要给它做 diff 和 break detection

因为 Claude Code 并不把 prompt 当咒语，而把它当：

- 可被治理、可被诊断的运行时资产。

## 8. 对 Agent 设计者的启发

如果想学 Claude Code，最该抄的不是：

- 某一段 system prompt 文案

而是：

1. 把 prompt 拆成 section 宪法，而不是维护一团长字符串。
2. 给角色 prompt 建立显式优先级链。
3. 给 compact、recovery 和 memory 设计正式的合法遗忘策略。
4. 把 transport 适配写成语义保持层，而不是载体直通层。
5. 给 prompt 做 diff、token breakdown 和 cache break 诊断。

## 9. 一句话总结

Claude Code 的 prompt 之所以有魔力，不是因为它更会写，而是因为它被做成了一份受 section 宪法、角色权威、合法遗忘和可观测 diff 共同治理的 Prompt Constitution。
