# Prompt message lineage 失真反例：原文 prompt、作者总结与只读历史如何拆散 protocol truth

这一章不再收集“Prompt 自身写错”的反例，而是收集 `message lineage / protocol transcript / continuation object` 明明已经存在，却被不同消费者拆成不同替身之后最常见的失真样本。

它主要回答五个问题：

1. 为什么 Prompt 运行时对象已经存在时，团队仍然会重新退回文案崇拜。
2. 为什么 Prompt 的 shared protocol-truth chain 最容易被拆成“原文 prompt”“cache 指标”“作者总结”“聊天历史”四份材料。
3. 为什么这些坏解法最容易偷走 Claude Code prompt 的真正魔力。
4. 怎样把这些坏解法改写回 Claude Code 式共享证据消费。
5. 怎样用苏格拉底式追问避免把这一章读成“多补一点 prompt 说明书就行”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/utils/api.ts:136-405`
- `claude-code-source-code/src/services/api/claude.ts:1374-1485`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/services/compact/prompt.ts:293-337`
- `claude-code-source-code/src/services/compact/compact.ts:330-711`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-66`
- `claude-code-source-code/src/query.ts:1308-1518`

这些锚点共同说明：

- Prompt 线真正值钱的不是某几句 system prompt，而是同一条 `message lineage` 怎样同时被 display、protocol、handoff 与 continuation 这些 projection consumer 共同承认。
- Claude Code 的 prompt 魔力之所以难抄走，不在“写得更像咒语”，而在它把 `protocol transcript`、`stable prefix boundary`、`lawful forgetting boundary` 与 `continuation object` 运行成同一套对象纪律。
- `message lineage` 在源码里更接近三键内核：`parentUuid / logicalParentUuid` 负责接回历史骨架，`message.id` 负责声明当前消息身份，`tool_use_id / sourceToolAssistantUUID` 负责把 assistant 与 tool 回链锁回同一条继续主语。

## 1. 第一性原理

Prompt 线最危险的，不是：

- 没有任何证据

而是：

- 证据已经存在，却被不同消费者拆开，各自只消费自己那一小份

这样一来，系统明明已经能描述：

- `message lineage`
- projection consumer alignment
- `protocol transcript`
- `stable prefix boundary`
- `lawful forgetting boundary`
- `continuation object`

团队却仍然会回到：

- 这段 prompt 看起来写得好不好

## 2. 原文崇拜 vs message lineage

### 坏解法

- 宿主和评审只看 system prompt 原文、prompt 文件 diff 或 section 文案，默认把它当成 Prompt 升级的全部证据。

### 为什么坏

- Claude Code 真正送进模型的，不是孤立原文，而是经过消息归一化、tool pairing、attachment 注入、header / effort / betas 处理之后的 lineage continuation。
- 同一条 Prompt 世界必须同时支撑 UI 可见文本、协议层 transcript、compact 后的 carry-forward 以及后续 continuation；只看原文，等于只看其中一个投影。
- 这会把 prompt 魔力重新退回措辞崇拜，而不是运行时对象纪律。

### Claude Code 式正解

- 原文 prompt 只配当输入材料，不配充当根对象。
- Prompt 升级证据应先绑定同一条 `message lineage`，再解释原文片段怎样参与了这条 lineage 的装配。
- 更稳的写法不是“history 里有前文”，而是明确这条 lineage 至少保住了 `parentUuid / logicalParentUuid`、`message.id` 与 `tool_use_id / sourceToolAssistantUUID` 这三类回链锚点。

## 3. Cache 指标崇拜 vs stable prefix boundary / cache-safe fork reuse

### 坏解法

- CI 只看 cache hit、cache break 次数或 token 曲线，把 Prompt 证据消费成一张成本图。

### 为什么坏

- cache 指标只是在报告某种投影结果，不在解释到底是哪段前缀仍被共同托管、哪段 fork 仍然 cache-safe。
- Claude Code 的 prompt 之所以稳，不是因为“缓存运气好”，而是因为 stable prefix、dynamic boundary、compact lineage 与 fork reuse 共同维持了前缀资产的合法连续性。
- 只看指标，团队会重新退回“这次模型不稳定 / 网络波动 / 提示词长了”的表面解释。

### Claude Code 式正解

- cache 指标必须和 `stable prefix boundary`、`compaction lineage` 与 `cache-safe fork reuse` 一起消费。
- token 曲线只能是 projection，不能替代前缀资产本身。

## 4. 汇总崇拜 vs protocol transcript / continuation object

### 坏解法

- 评审只读一份作者总结：这次 prompt 改了哪些 section、为什么更强、目前表现如何。

### 为什么坏

- 总结最容易把 section 顺序、tool-use 配对、协议 transcript 与 continue precondition 压扁成“作者认为如此”。
- 一旦 `protocol transcript` 与 `continuation object` 不再被共同点名，later consumer 就只会继承一段更会解释的 prose。
- 团队会重新退回“谁写得更会解释，谁就更像对的”。

### Claude Code 式正解

- 总结只能服从 `protocol transcript`、`continuation object` 与 stable/dynamic boundary 这些正式字段。
- 评审应先确认 transcript witness 与 continuation qualification，再决定要不要接受解释文本。

## 5. 只读历史交接 vs lawful forgetting boundary

### 坏解法

- 交接者只看 transcript 或 handoff 摘要，默认“历史够长就能理解当前真相”。

### 为什么坏

- Prompt 线真正需要被继承的，不是完整叙事，而是 lawful forgetting 之后仍被正式保留的边界、carry-forward object 与 next-step precondition。
- 只读历史会忽略 `pending_action`、current object、carry-forward segment 与 reopen trigger 这些 continuation 所需结构化状态。
- 系统会重新退回聊天记录考古，而不是对象接手。

### Claude Code 式正解

- 交接首先消费 `lawful forgetting boundary` 与当前 `continuation object`，再去读 transcript。
- transcript 是辅证，不是当前真相本体。

## 6. 分路消费 vs projection consumer alignment

### 坏解法

- 宿主看 prompt 原文，CI 看 cache graph，评审看总结，交接看 transcript，默认这些材料拼起来就等于同一份 Prompt 证据。

### 为什么坏

- 它们确实都在描述同一个 Prompt 世界，但如果没有 shared `message lineage`，就只是在制造四份彼此相关、互不约束的半真相。
- Claude Code prompt 的魔力并不来自“材料更多”，而来自不同 consumer 仍在消费同一个对象，只是消费深度不同。
- 一旦 projection consumer alignment 消失，就会出现“宿主说 prompt 没问题，CI 说 cache 坏了，评审说逻辑合理，交接说完全接不上”的分裂。

### Claude Code 式正解

- 所有消费者都应先共享同一条 `message lineage`，再按角色读取不同 projection。
- 差异应体现在消费粒度，而不是体现在真相来源。
- 最值得显式点名的 consumer 至少有四类：display transcript、`protocol transcript`、handoff carry-forward 与 `cache-safe fork reuse`；四者共享同一 lineage，只是消费面不同。

## 7. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在消费的是同一条 `message lineage`，还是只是在看原文 prompt。
2. 我保住的是 `stable prefix boundary` 与 `cache-safe fork reuse`，还是只保住了一张 token 图。
3. 当前 `protocol transcript` 与 `continuation object` 是否已经被共同点名。
4. 交接者接手时，看到的是 `lawful forgetting boundary` 之后仍有效的对象，还是一整段历史。
5. 我是在共享同一套 projection consumer 骨架，还是在共享几份彼此相关但互不约束的材料。
