# 结构 Artifact反例：权威路径卡退回目录图、恢复附件只剩成功率与交接包回到作者说明

这一章不再收集“结构 contract 本身设计错”的反例，而是收集结构 artifact 已经存在之后最常见的工件级失真样本。

它主要回答五个问题：

1. 为什么结构 artifact 明明已经有权威路径卡、恢复附件、评审卡与交接包，团队仍然会退回目录图、恢复成功率、结构评语与作者说明四套局部真相。
2. 为什么结构 artifact 最容易被退化成“看起来都很完整，但对象级真相已经丢失”。
3. 哪些坏解法最容易让 authoritative path、recovery asset ledger、anti-zombie evidence 与 rollback object 失去权威。
4. 怎样把这些坏解法改写回 Claude Code 式共享 artifact 消费。
5. 怎样用苏格拉底式追问避免把这一章读成“有人没按模板填交接包”。

## 0. 第一性原理

结构 artifact 层最危险的，不是：

- 没有工件

而是：

- 工件已经存在，却只剩目录图、恢复结果和作者补充，没有人再围绕同一个 structure object 继续判断

这样一来，系统虽然已经能要求：

1. `structure_object_id`
2. `authoritative_path`
3. `recovery_asset_ledger`
4. `anti_zombie_evidence`
5. `retained_assets`
6. `rollback_object`

团队却依旧回到：

- 看目录图
- 看恢复成功率
- 看结构评语
- 听作者说明

## 1. 权威路径卡退回目录图 vs authoritative path

### 坏解法

- 宿主卡虽然存在，但主要展示结构图、模块关系或目录树，不再展示 `authoritative_path` 与 `rollback_object`。

### 为什么坏

- 目录图只能说明结构外观，不能说明当前哪条路径才是唯一权威路径。
- 一旦宿主卡不再锁 `authoritative_path`，结构对象就会退回图示层。
- 后来者会误把“看起来更整洁”当成“只有一条真相路径”。

### Claude Code 式正解

- 宿主卡必须先锁 `structure_object_id`、`authoritative_path`、`rollback_object` 与 `danger_paths`。
- 结构图最多作为 projection，不得替代对象真相。

### 改写路径

1. 把目录图降为辅助视图。
2. 把 `authoritative_path` 提到宿主卡第一行。
3. 强制宿主卡回答“坏了回退哪个对象”。

## 2. 恢复附件只剩成功率 vs recovery asset ledger

### 坏解法

- CI 附件虽然存在，但主要只给 reconnect 成功率、resume 成功率和是否通过，不再给 `recovery_asset_ledger` 与 `anti_zombie_evidence`。

### 为什么坏

- 成功率只能说明结果，不说明恢复靠哪些资产成立。
- 没有 recovery asset ledger，CI 附件会退回运气统计。
- 没有 anti-zombie evidence，CI 会重新退回“规则应该是对的”。

### Claude Code 式正解

- CI 附件必须同时给出 `recovery_asset_ledger`、`anti_zombie_evidence`、`retained_assets` 与 `dropped_stale_writers`。
- 恢复结果只是结论，不是工件本体。

### 改写路径

1. 把 `recovery_asset_ledger` 固定为 CI 附件前段字段。
2. 把 `anti_zombie_evidence` 从日志里提升为正式列。
3. 任何只有成功率没有资产账本的附件都判为 drift。

## 3. 评审卡退回结构评语 vs read/write path

### 坏解法

- 评审卡虽然存在，但 reviewer 主要写“结构更清晰了”“边界更好了”，不再点名 `current_read_path`、`current_write_path` 与 `projection_set`。

### 为什么坏

- 结构评语是感受，不是对象级 judgement。
- 一旦评审卡不再锁当前读写路径，它就会退回图表审美卡。
- 后来者会得到对结构的赞美，却得不到结构真相。

### Claude Code 式正解

- 评审卡必须先回答 `authoritative_path`、`current_read_path`、`current_write_path` 与 `projection_set`。
- 评语只能是这些字段的投影。

### 改写路径

1. 把 `current_read_path` 和 `current_write_path` 固定为评审卡第一段。
2. 让 judgement 必须引用 `projection_set`。
3. 把“结构更好看”降到对象 judgement 之后。

## 4. 交接包回到作者说明 vs retained assets / rollback object

### 坏解法

- 交接包虽然存在，但主要只写 danger paths 的作者说明，不再给 `retained_assets`、`rollback_object` 与 `dropped_stale_writers`。

### 为什么坏

- 这会让交接重新退回作者权威。
- 没有 retained assets，后来者不知道哪些资产必须保留。
- 没有 rollback object，后来者不知道失败时退到哪一层对象。

### Claude Code 式正解

- 交接包必须先交 `structure_object_id`、`retained_assets`、`rollback_object`、`dropped_stale_writers`。
- 作者说明只能补充，不得替代这些对象字段。

### 改写路径

1. 把 `retained_assets` 提到交接包第一段。
2. 把 `rollback_object` 写成正式字段而不是备注。
3. 任何缺 `dropped_stale_writers` 的交接包都判为 drift。

## 5. 四件套同时存在却仍然失真

### 坏解法

- 权威路径卡、恢复附件、评审卡、交接包四件套都存在，但它们分别围绕目录图、成功率、结构评语与作者说明，不再共享同一个 structure object。

### 为什么坏

- 这会制造四份彼此相关却互不约束的结构真相。
- 工件存在性会掩盖对象级结构真相的死亡。
- 团队会误以为 contract 已落地，实际上 shared structure object 已经丢失。

### Claude Code 式正解

- 四件套必须先共享同一个 `artifact_line_id + structure_object_id + authoritative_path + rollback_object`。
- 差异只允许出现在 projection，不允许出现在 shared header。

### 改写路径

1. 把 shared header 单独抽出来比对。
2. 检查四件套是否围绕同一个 authoritative path。
3. 任何 rollback object 不一致的工件组都判为 drift。

## 6. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在消费的是同一 structure object，还是目录图、成功率、评语与作者说明四种替身。
2. 这些工件共享的是同一对象级真相，还是只是看起来都像结构材料。
3. 如果恢复失败，后来者能否仅靠工件知道该退回哪个对象。
4. 我是在修工件，还是在重新修回 shared structure object。
