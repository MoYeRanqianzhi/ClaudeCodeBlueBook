# 苏格拉底审读导航：Prompt魔力、安全定价与源码先进性

这篇只做一件事：把苏格拉底审读压成失稳前问题，而不是故障后诊断。

- 核心问题不是“事后怎么解释”，而是“在再次出问题前，怎样反问这套制度是否已经埋下断裂点”。

## 1. Prompt 魔力的苏格拉底审读

关键追问：

- 为什么这套 prompt 在当前、下一步、接手后都像活在同一个现场里。
- 为什么一段 prompt 看起来更长，却未必更强。
- 为什么一个 Prompt Constitution 如果不能被失稳前审读，最终会退回神秘文案。

最短反查链：

1. `../philosophy/84`
2. `../architecture/82`
3. `../guides/99`
4. `../guides/30`

这条线的核心不是：

- 如何再多写几条 instruction

而是：

- 如何确认 `message lineage`、`section registry / dynamic boundary`、`protocol transcript`、`continuation qualification` 与接手连续性都还成立

## 2. 安全与省 token 的苏格拉底审读

关键追问：

- 为什么系统越“聪明”越需要限制免费扩张。
- 为什么安全与成本的深层共同点不是预算器名字，而是拒绝未定价输入。
- 为什么没有决策增益的检查，本身就是风险和浪费。

最短反查链：

1. `../philosophy/85`
2. `../architecture/83`
3. `../guides/100`
4. `../guides/31`

这条线的核心不是：

- 怎样把规则叠得更多

而是：

- 如何确认 `governance key`、`decision window`、`continuation pricing` 与 `durable-vs-transient cleanup` 都没有在免费扩张

## 3. 源码先进性的苏格拉底审读

关键追问：

- 为什么有些仓库看起来更整齐，却更不适合长期演化。
- 为什么“源码先进性”最终一定要落实到权威面、合同、恢复资产与反 zombie 协议。
- 为什么未来维护者如果没有被当成正式消费者，先进性只会停留在作者视角。

最短反查链：

1. `../philosophy/76`
2. `../guides/102`
3. `../philosophy/86`
4. `../architecture/84`
5. `../guides/101`
6. `../guides/32`

这条线的核心不是：

- 代码是不是更像教科书

而是：

- 结构里是否已经提前编码了 `current-truth surface / freshness gate / stale worldview / ghost capability` 这条 present-truth 纪律，以及证据梯度、批评路径、修改路径与退出路径

## 4. 一句话用法

`14` 回答“出问题后怎样从现场观察回到制度根因”；`15` 回答“在再次出问题前，怎样反问自己的设计是否早就埋下制度断裂点”。

## 5. 苏格拉底式自检

在你准备继续新增一篇“为什么它很强”的分析前，先问自己：

1. 我写下的是结论，还是问题梯子。
2. 这些问题是否真的能帮助设计者在失稳前改设计，而不是只帮助读者点头。
3. 我是在解释 Claude Code 为什么强，还是在帮助团队避免用错它的思想。
4. 如果今天把这些问题拿去审一个新 Agent runtime，它们是否足够具体到能改设计。
