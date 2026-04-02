# Prompt Host Implementation反例：只看卡片存在、只看CI通过与只交接摘要包

这一章不再收集“Prompt evidence envelope 被拆散”的反例，而是收集 Prompt host implementation 已经存在之后最常见的实施级失真样本。

它主要回答五个问题：

1. 为什么 Prompt implementation 明明已经有 card、gate、review order 与 handoff package，团队仍然会退回文案崇拜与总结崇拜。
2. 为什么 Prompt 的 host implementation 最容易被退化成“卡片存在”“CI 通过”“顺序照抄”“摘要导出”四种形式化合规。
3. 哪些坏解法最容易让 compiled request truth、stable bytes 与 lawful forgetting ABI 再次失去权威。
4. 怎样把这些坏解法改写回 Claude Code 式共享 implementation 判断。
5. 怎样用苏格拉底式追问避免把这一章读成“执行同学没照手册做”。

## 0. 第一性原理

Prompt implementation 层最危险的，不是：

- 没有检查点

而是：

- 检查点已经存在，却被消费成几张看起来都很完整、实际上互不约束的卡片

这样一来，系统虽然已经能要求：

- authority source
- assembly path
- compiled request diff
- stable bytes ledger
- lawful forgetting ABI
- handoff package

团队却依旧回到：

- 卡片在不在
- CI 绿不绿
- 摘要写没写

## 1. 只看卡片存在 vs authority source / assembly path

### 坏解法

- 宿主只要展示了一张 Prompt 卡片，评审就默认 Prompt implementation 已经成立，不再追问卡片到底从哪条 authority source 与 assembly path 生成。

### 为什么坏

- 卡片存在只说明“有人填过”，不说明它仍然是当前 compiled request truth 的权威投影。
- 如果 authority source 与 assembly path 没被点名，卡片很容易变成原文 prompt、作者总结或某次临时截图的替身。
- Prompt 魔力会重新退回“解释得像真的”。

### Claude Code 式正解

- 先证明卡片来自当前 authority source 与 assembly path，再讨论卡片内容。
- 卡片是 envelope 的宿主投影，不是新的真相来源。

### 改写路径

1. 所有 Prompt implementation 卡片都强制附 authority source。
2. 宿主默认展示 assembly path，而不是只展示卡片正文。
3. 评审先验卡片 provenance，再看是否易读。

## 2. 只看 CI 通过 vs stable bytes drift explanation

### 坏解法

- CI 只要检查字段齐全、脚本通过、门禁转绿，就默认 Prompt implementation 没问题，不再解释 stable bytes 为什么变化、cache break 为什么发生。

### 为什么坏

- “通过”只是结果，不是根因。
- 如果没有 stable bytes drift explanation，CI 绿灯只能证明规则存在，不能证明 Prompt 仍然可重放、可归因、可回退。
- 团队会重新退回“这次只是缓存波动”“模型偶发不稳”的表面解释。

### Claude Code 式正解

- 让 CI 同时消费 pass/fail 与 drift explanation。
- 绿灯必须绑定 compiled request diff、stable bytes ledger 与 break summary。

### 改写路径

1. Prompt CI 报告固定包含 drift summary。
2. cache break 结论必须连回 stable bytes 资产。
3. 任何“通过但说不清为什么漂移”的情况，都视为 implementation 失真。

## 3. 只看评审顺序 vs compiled request truth

### 坏解法

- 评审者照着手册顺序逐项打勾，却不真正回到 compiled request diff、stable/dynamic boundary 与 lawful forgetting ABI，只验证“流程顺序是否被走完”。

### 为什么坏

- 手册顺序如果脱离权威对象，就会退回流程戏剧。
- 看似每一步都做了，实际上没人再确认真正送进模型的请求真相是否仍成立。
- 这会把 Prompt review 重新退回“顺序正确但判断失真”。

### Claude Code 式正解

- 评审顺序必须服务 compiled request truth，而不是替代它。
- 顺序的意义在于先锁 authority，再锁 boundary，再锁 diff，而不是完成流程动作。

### 改写路径

1. 每个评审步骤都绑定对应权威字段。
2. 任何无法回到 compiled request diff 的 checklist 项都要删掉或降级。
3. 评审结论必须回答“当前真相是什么”，不只回答“我按顺序看过了”。

## 4. 只交接摘要包 vs lawful forgetting ABI / next-step guard

### 坏解法

- 交接时只导出一份摘要包，默认“包已经导出”就等于 Prompt 线能被后来者接住，不再检查 lawful forgetting 之后保留了哪些 ABI、next-step guard 是否齐全。

### 为什么坏

- 摘要包存在，不代表接手者能继续工作。
- 如果 current object、pending action、task summary、next-step guard 与 lawful forgetting ABI 没有一起保留，交接仍然是在把后来者推回 transcript 考古。
- 交接会从结构化状态再次退回故事摘要。

### Claude Code 式正解

- 交接先验 ABI 是否完整，再看摘要是否清晰。
- handoff package 的价值在于保存可继续行动的最小语义体，而不是导出一段“背景介绍”。

### 改写路径

1. Handoff package 固定列出 current object、pending action、next-step guard。
2. lawful forgetting 之后保留下来的最小 ABI 单独成栏。
3. 任何“摘要写得很好，但接手仍要通读历史”的情况，都视为 implementation 失败。

## 5. 分角色各自达标 vs shared Prompt implementation object

### 坏解法

- 宿主卡片完整、CI 门禁通过、评审顺序正确、交接包可导出，团队就默认四类角色已经共享同一套 Prompt implementation。

### 为什么坏

- 这四项都可能局部正确，却仍然没有共享同一对象真相。
- 宿主可能显示旧卡片，CI 可能校验字段存在，评审可能执行顺序，交接可能导出摘要，但没有一个角色真正回到同一 compiled request object。
- 最终大家都像在执行制度，Prompt 魔力却已经悄悄退回普通文案流程。

### Claude Code 式正解

- 所有角色先共享同一 Prompt implementation object：
  - authority source
  - assembly path
  - compiled request diff
  - stable bytes ledger
  - lawful forgetting ABI
  - handoff guard

### 改写路径

1. 为 Prompt implementation 固定 shared header。
2. 宿主、CI、评审、交接都先从同一 header 起手。
3. 任何 role-specific 视图都不得替代 shared header。

## 6. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在消费的是 Prompt implementation object，还是只是在看卡片有没有出现。
2. 当前绿灯是否真的解释了 stable bytes 为什么变化。
3. 评审顺序是否仍然服务 compiled request truth，而不是只服务流程完成。
4. 交接者接手时，看到的是 lawful forgetting 之后的最小 ABI，还是一份更短的故事摘要。
5. 我是在共享同一套 Prompt implementation 真相，还是在共享几份互相点头的合规材料。
