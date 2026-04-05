# Prompt Evidence Envelope反例：原文崇拜、汇总崇拜与只读历史交接

这一章不再收集“Prompt 自身写错”的反例，而是收集 Prompt 证据被不同消费者拆散之后最常见的失真样本。

它主要回答五个问题：

1. 为什么 Prompt 证据已经存在时，团队仍然会重新退回文案崇拜。
2. 为什么 Prompt 的 shared evidence envelope 最容易被拆成“原文 prompt”“cache 指标”“人工总结”“聊天历史”四份材料。
3. 哪些坏解法最容易让 Prompt Constitution 退回普通提示词。
4. 怎样把这些坏解法改写回 Claude Code 式共享证据消费。
5. 怎样用苏格拉底式追问避免把这一章读成“作者在抱怨团队不会看文档”。

## 0. 第一性原理

Prompt 线最危险的，不是：

- 没有任何证据

而是：

- 证据已经存在，却被不同消费者拆开，各自只消费自己那一小份

这样一来，系统明明已经能描述：

- 编译后 request truth
- stable bytes
- assembly path
- lawful forgetting

团队却仍然会回到：

- 这段 prompt 看起来写得好不好

## 1. 原文崇拜 vs 编译后 request truth

### 坏解法

- 宿主和评审只看 system prompt 原文或 prompt 文件 diff，默认把它当成 Prompt 升级的全部证据。

### 为什么坏

- Claude Code 真正送进模型的是编译后的 request truth，而不是原文片段本身。
- `normalizeMessagesForAPI(...)`、tool pairing、tool-search 裁剪、header / effort / betas 等变化都可能影响真实 prompt ABI。
- 只看原文，会把 prompt 魔力退回成措辞崇拜。

### Claude Code 式正解

- 把 Prompt 升级证据建立在 compiled request truth 上，而不是只建立在原文文本上。
- 原文 prompt 可以作为输入材料，但不能替代 assembly 之后的真实请求证据。


## 2. Cache 指标崇拜 vs stable bytes diff

### 坏解法

- CI 只看 cache hit、cache break 次数或 token 曲线，把 Prompt 证据消费成一张成本图。

### 为什么坏

- 这样只能看到“变贵了”或“变稳了”，看不到到底是哪类 stable bytes 漂移。
- cache 指标是结果，不是根因。
- 团队会重新退回“这次模型不稳定/网络波动/提示词长了”的表面解释。

### Claude Code 式正解

- 把 cache 指标和 stable bytes diff 一起消费。
- 让 `PromptStateSnapshot`、assembly 变化、tool schema 变化、betas / effort 变化进入同一 evidence envelope。


## 3. 汇总崇拜 vs authority source / assembly path

### 坏解法

- 评审只读一份作者总结：这次 prompt 改了哪些 section、为什么更强、目前表现如何。

### 为什么坏

- 一旦没有 `authority source` 与 `assembly path`，总结很容易掩盖真正的 Prompt 真相来源。
- 主语链、section 顺序、shared prefix producer、边界编译方式都会被压扁成“作者认为如此”。
- 团队重新退回“谁写得更会解释，谁就更像对的”。

### Claude Code 式正解

- 让总结服从证据字段，而不是让证据字段服从总结。
- 评审先看 authority source、assembly path、stable/dynamic boundary，再看解释。


## 4. 只读历史交接 vs lawful forgetting + externalized state

### 坏解法

- 交接者只看 transcript 或交接摘要，默认“历史够长就能理解当前真相”。

### 为什么坏

- Prompt 线真正需要被继承的是 lawful forgetting 之后保留下来的 ABI，而不是完整叙事。
- 只读历史会忽略 `pending_action`、`task_summary`、current object、next-step guard 这些结构化状态。
- 系统重新退回聊天记录考古，而不是状态接手。

### Claude Code 式正解

- 交接首先消费 externalized state 与 lawful forgetting ABI，再去读历史。
- transcript 是辅证，不是当前真相。


## 5. 分路消费 vs shared prefix producer

### 坏解法

- 宿主看 prompt 原文，CI 看 cache break，评审看总结，交接看 transcript，默认这些材料拼起来就等于同一份 Prompt 证据。

### 为什么坏

- 它们描述的是同一条主线的不同投影，却没有共享同一 prefix producer 和同一 authority source。
- 看似信息更多，实际上在制造四份半真相。
- 最终又会出现“宿主说 prompt 没问题，CI 说 cache 坏了，评审说逻辑合理，交接说完全接不上”的分裂。

### Claude Code 式正解

- 所有消费者先共享同一份 compiled request truth 骨架，再按角色取不同粒度。
- 差异应体现在消费深度，而不是体现在真相来源。


## 6. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在消费的是编译后 request truth，还是只是在看原文 prompt。
2. 我保住的是 stable bytes diff，还是只保住了一张 token 图。
3. 当前 authority source 和 assembly path 是否已经点名。
4. 交接者接手时，看到的是 lawful forgetting 之后的 ABI，还是一整段历史。
5. 我是在共享同一套 Prompt 证据骨架，还是只是共享几份相关材料。
