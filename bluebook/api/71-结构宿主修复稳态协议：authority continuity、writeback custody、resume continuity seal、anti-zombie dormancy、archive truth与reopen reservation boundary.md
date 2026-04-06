# 结构宿主修复稳态协议：current-truth surface、writeback custody、lineage seal、anti-zombie dormancy 与 reopen reservation

这一章也不是新的高阶前门，而是结构主链成立之后的一条结构 steady-side 旁证线：

- 它回答的不是“源码先进性为什么成立”，而是“在 steady 阶段，结构对象怎样保持唯一写回主语，并保留 structure-local reopen reservation”

因此这页继续继承同一条结构真相梯度：

1. `contract`
2. `registry`
3. `current-truth surface`
4. `consumer subset`
5. `hotspot kernel`
6. `mirror gap discipline`

## 0. 第一性原理

结构稳态真正要宣布的不是：

- pointer 还在
- telemetry 重新转绿
- 作者说“现在应该没问题了”

而是：

- 当前结构对象已经可以停止额外盯防，但 structure-local reservation boundary 仍保留

所以这页最先要看的不是：

- `authority continuity` 或 `reopen reservation boundary` 已经出现

而是：

1. `current-truth surface` 是否仍由同一个 authority object 与 writer chokepoint 定义。
2. `writeback custody` 是否仍围绕唯一主写路径成立。
3. `lineage seal` 是否仍让 later 维护者沿同一对象链恢复。
4. `anti-zombie dormancy` 是否仍只是 structure-local freshness witness，而不是新的世界主语。
5. `archive truth / reopen reservation boundary` 是否仍只在 structure-local mirror gap 与 later reject path 层出现。

## 1. 必须消费的结构 steady-side 对象

### 1.1 `contract`

宿主至少应消费：

1. `structure_object_type`
2. `structure_object_id`
3. `contract_ref`

### 1.2 `registry`

宿主还必须消费：

1. `registry_ref`
2. `registry_generation`
3. `steady_state_evaluated_at`

### 1.3 `current-truth surface`

宿主还必须消费：

1. `authority_object_id`
2. `authoritative_path`
3. `current_write_path`
4. `writer_chokepoint`
5. `authority_continuity_attested`

### 1.4 `consumer subset`

宿主还必须消费：

1. `consumer_subset_ref`
2. `bridge_pointer_scope`
3. `projection_demoted`

### 1.5 `hotspot kernel`

宿主还必须消费：

1. `resume_lineage_ref`
2. `writeback_primary_path`
3. `anti_zombie_evidence_ref`
4. `stale_writer_blocked`
5. `writeback_custody_attested`

### 1.6 `mirror gap discipline`

最后才允许暴露：

1. `archive_truth`
2. `reopen_reservation_boundary`
3. `reservation_owner`
4. `threshold_retained_until`
5. `reopen_required`

这里最重要的是：

- `archive truth / reopen reservation boundary` 只属于结构 local 的 later reject path，不得被 Prompt 借作 `Continuation` 的阈值词，也不得被治理借作通用 liability 主语

## 2. steady-state verdict：必须共享的结构 local 语义

更成熟的结构宿主稳态 verdict 至少应共享下面枚举：

1. `steady_state`
2. `steady_state_blocked`
3. `authority_split_detected`
4. `resume_lineage_missing`
5. `side_write_risk_retained`
6. `archive_truth_missing`
7. `reopen_reservation_triggered`

更值得长期复用的结构 reject trio 仍是：

1. `layout-first drift`
2. `recovery-sovereignty leak`
3. `surface-gap blur`

## 3. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. pointer mtime
2. reconnect 按钮状态
3. telemetry 绿灯
4. PUT 次数
5. 目录美学描述
6. 单次截图
7. archive prose 摘要
8. 作者口头说明

它们可以是稳态线索，但不能是稳态对象。

## 4. 稳态消费顺序建议

更稳的顺序是：

1. 先验 `contract`
2. 再验 `registry`
3. 再验 `current-truth surface`
4. 再验 `consumer subset`
5. 再验 `hotspot kernel`
6. 最后验 `mirror gap discipline`

不要反过来做：

1. 不要先看 pointer。
2. 不要先看监控转绿。
3. 不要先看作者是否主观放心。

## 5. 苏格拉底式检查清单

在你准备宣布“结构已进入稳态”前，先问自己：

1. 我现在保护的是 current-truth surface，还是某个还没失效的入口。
2. `writeback custody` 托管的是唯一写回主路径，还是最近没有再写坏文件。
3. `archive truth` 保留下来的，是结构真相，还是一段更好看的归档说明。
4. `reopen reservation boundary` 还在不在，如果不在，我是在进入稳态，还是在删除未来推翻当前状态的能力。
5. 如果把 pointer、telemetry 与作者说明都藏起来，later 维护者是否仍知道该如何继续结构判断。

## 6. 一句话总结

Claude Code 的结构宿主修复稳态协议，不是 release 之后的归档说明 API，而是 `contract + registry + current-truth surface + consumer subset + hotspot kernel + mirror gap discipline` 在 steady 阶段的 structure-local 维持与 reservation 保留。
