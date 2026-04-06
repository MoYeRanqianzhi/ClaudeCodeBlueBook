# 结构 Host Implementation反例：只看门禁存在、只看恢复通过与危险路径口头化

这一章不再收集“结构 evidence envelope 被拆散”的反例，而是收集结构 host implementation 已经存在之后最常见的实施级失真样本。

它主要回答五个问题：

1. 为什么结构 implementation 明明已经有 `current-truth surface`、recovery asset、anti-zombie gate、handoff boundary 与 retained assets，团队仍然会退回存在性合规与作者记忆。
2. 为什么结构的 host implementation 最容易被退化成“门禁存在”“恢复通过”“规则已写”“危险路径口头说明”四种形式化合规。
3. 哪些坏解法最容易让源码先进性再次退回目录审美、文件回退与作者权威。
4. 怎样把这些坏解法改写回 Claude Code 式共享 implementation 判断。
5. 怎样用苏格拉底式追问避免把这一章读成“团队结构纪律不够好”。

## 0. 第一性原理

结构 implementation 层最危险的，不是：

- 没有 gate

而是：

- gate 已经存在，却只剩“规则写了”“恢复过了”“作者知道危险路径”，没人再围绕同一 `current-truth surface`、同一 recovery asset 与同一 handoff carrier 判断

这样一来，系统虽然已经能要求：

- authoritative surface
- projection set
- recovery asset ledger
- anti-zombie gate
- retained assets
- rollback boundary

团队却依旧回到：

- 门禁在不在
- 恢复过没过
- 作者知不知道哪里危险

## 1. 只看门禁存在 vs current-truth surface

### 坏解法

- 宿主或评审只要看到 current-truth surface 已被点名、规则写在文档里，就默认结构 implementation 成立，不再追问当前读写路径是否真的只剩这一条权威路径。

### 为什么坏

- `current-truth surface` 被点名，不等于 split-brain 已经消失。
- 如果旧 writer、旁路入口、阴影投影仍可写入，结构真相仍然在说谎。
- 结构 implementation 会重新退回“命名了就算治理”。

### Claude Code 式正解

- 先验证当前 authoritative path 是否真的唯一，再讨论规则是否存在。
- `current-truth surface` 是活的运行时事实，不是静态命名标签。


## 2. 只看恢复通过 vs recovery asset ledger

### 坏解法

- CI 或宿主只要看到恢复演练通过、resume/reconnect 成功，就默认结构 implementation 正常，不再追问是靠哪些 recovery asset 恢复的。

### 为什么坏

- “恢复通过”只是结果，不说明恢复资产是否成账、替换日志是否连续、stale state 是否已清退。
- 如果没有 recovery asset ledger，恢复成功率只是一张幸运截图。
- 结构先进性会重新退回黑盒恢复。

### Claude Code 式正解

- 让恢复结果和 recovery asset ledger 一起消费。
- 恢复判断必须同时回答：靠什么恢复、保留了什么、丢弃了什么。


## 3. 只看 anti-zombie gate 存在 vs stale writer 已被清退

### 坏解法

- 评审或交接看到 anti-zombie gate 已存在，就默认旧 writer、旧 projection、旧 shadow entry 已经被清退，不再验证 stale writer 是否仍可复活。

### 为什么坏

- 规则存在不等于 stale writer 消失。
- 如果 dropped stale writers、danger paths 与再进入条件没有被记录，anti-zombie gate 只是在象征性存在。
- 团队会把结构治理误读成“有原则”，而不是“旧路径真的死了”。

### Claude Code 式正解

- 让 anti-zombie gate 和 stale writer 清退证据一起消费。
- 结构门禁必须回答哪些旧路径已死、哪些仍在观察、哪些触发立即回退。


## 4. 只交接危险路径口头说明 vs handoff carrier / retained assets

### 坏解法

- 交接时作者口头说明几条 danger paths，团队就默认结构 implementation 可以接手，不再核验 handoff carrier、retained assets 与 projection set 是否结构化交付。

### 为什么坏

- 口头说明会把 shared implementation 再次退回作者记忆。
- 如果 handoff carrier 与 retained assets 不在包里，后来者仍然不知道真正该回退什么、该保留什么。
- 结构交接会从对象级真相再次退回经验传授。

### Claude Code 式正解

- 先交付 handoff carrier、retained assets、projection set，再补作者解释。
- danger paths 的价值在于约束未来回退，不在于展示作者经验。


## 5. 分角色各自通过 vs shared structure implementation object

### 坏解法

- 宿主卡片完整、CI 恢复通过、评审确认 gate 存在、交接拿到 danger path，团队就默认四类角色已经共享同一套结构 implementation。

### 为什么坏

- 这四项都可能局部正确，却仍然没有共享同一 current truth / recovery / handoff carrier。
- 每个角色都像在执行结构治理，但整个系统已经退回存在性合规与作者兜底。
- 源码先进性会再次从可恢复结构退回目录图与经验法。

### Claude Code 式正解

- 所有角色先共享同一结构 implementation object：
  - authoritative path
  - projection set
  - recovery asset ledger
  - anti-zombie evidence
  - retained assets
  - handoff carrier


## 6. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在消费的是结构 implementation object，还是只是在看门禁是否存在。
2. 当前恢复成功是否真的绑定 recovery asset ledger。
3. anti-zombie gate 现在约束的是旧路径死亡，还是只是一条写在文档里的原则。
4. handoff carrier 与 retained assets 是否已经比作者口头说明更先被交付。
5. 我是在共享同一套结构 implementation 真相，还是在共享几份都像有帮助的存在性材料。
