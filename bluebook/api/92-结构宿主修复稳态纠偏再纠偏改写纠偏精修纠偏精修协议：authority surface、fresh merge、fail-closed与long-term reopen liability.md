# 结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修协议：packet fields、shared reject semantics、fail-closed 与 long-horizon reopen

这一章回答五个问题：

1. 若要让宿主、CI、评审与交接在结构 refinement correction 精修层继续消费同一个结构真相，packet 至少该携带哪些 fields。
2. 哪些字段属于必须共享的 packet field，哪些只属于 mirror gap、rewrite hint 或本地诊断。
3. 为什么源码先进性来自 writer chokepoint、freshness gate、fail-closed 与 later rejectability，而不是“架构整洁度”。
4. 宿主开发者该按什么顺序消费这套结构 refinement packet。
5. 哪些现象一旦出现，应被直接升级为 reject、reentry 或 reopen，而不是继续宣称结构已经重新稳定。

## 0. 第一性原理

这一页不是新的 `ordered repair stream` 主权页，而是 [83](83-结构宿主修复稳态纠偏再纠偏改写纠偏协议：authority、lineage、transport与reopen%20liability.md) 在精修层的 packet 化延伸。
在当前 `mirror absent / public-evidence only` worktree 里，`src/...` 只算 archival anchors；因此本页默认写的是 bluebook review schema，而不是当前产品已公开签出的 live packet ABI。

因此它必须继续继承：

1. `contract`
2. `registry`
3. `current-truth surface`
4. `consumer subset`
5. `hotspot kernel`
6. `mirror gap discipline`

`cross_consumer_attestation`、`repair stream`、`field bag` 都不该再越位成第一页主语。

## 1. 哪些内容只配做 packet field

下面这些内容可以保留，但只能留在 packet field 层：

1. `repair_session_id`
2. `authority_object_id`
3. `writer_chokepoint`
4. `current_write_path`
5. `generation_guard`
6. `merge_contract_ref`
7. `transport_boundary_ref`
8. `reject_verdict`
9. `reject_reason`
10. `next_action`

它们的职责不是定义一条新结构链，而是：

- 把同一条结构真相链做成可共享、可拒收、可交接的 packet

## 2. 哪些内容必须降回 mirror gap 或 rewrite hint

下面这些内容不应继续升格成公共 ABI：

### 2.1 mirror gap / later reject path

1. `workspace.original_cwd`
2. `workspace.clean`
3. `workspace.unpushed_commits`
4. `transport.close_code`
5. `dirty_git_fail_closed_attested`
6. `long_horizon_reopen_liability`

### 2.2 rewrite hint / local diagnostics

1. `phase_index`
2. `payload.data`
3. `diagnostics.message`
4. `consumer_projection_demoted`
5. 顺序性提醒话术

这些内容可以帮助 later maintainer 判断，但不应再长成新的 sovereign surface。

## 3. packet 应检查什么

更稳的 refinement packet，不该先列一长串 field bag，而应先检查：

1. `current-truth bound`
   - packet 是否仍锚定同一 `current-truth surface`。
2. `writer-chokepoint bound`
   - 所有写回是否仍经过同一 `writer_chokepoint`。
3. `freshness bound`
   - stale writer、stale finally、duplicate response 是否仍被 fail-closed 地压住。
4. `later-reject path present`
   - later maintainer 是否能不问作者就独立拒收。

## 4. shared reject semantics

这一页真正要共享的，不是另一套 verdict family，而是精修层也继续沿用共享拒收语义：

1. `authority_conflict`
2. `writeback_target_ambiguous`
3. `lineage_mismatch`
4. `duplicate_or_zombie`
5. `workspace_not_clean`
6. `merge_ambiguous`
7. `reopen_boundary_invalid`
8. `permanent_transport_failure`

向上仍要回到结构线稳定的 reject trio：

1. `layout-first drift`
2. `recovery-sovereignty leak`
3. `surface-gap blur`

## 5. refinement 消费顺序建议

更稳的顺序是：

1. 先验 `packet_header`
2. 再验 `current_truth_surface_ref`
3. 再验 `writer_chokepoint + current_write_path`
4. 再验 `fresh_merge_contract + anti_zombie_evidence`
5. 再验 `transport_boundary_ref + fail_closed_witness`
6. 最后才给 `later_reject_path + reopen_boundary`

不要反过来做：

1. 不要先看 pointer 还在不在，再修 authority surface。
2. 不要先看 telemetry 转绿，再修 single-source writeback。
3. 不要先看“恢复成功率”，再修 freshness gate。
4. 不要先看目录说明更清楚，再修 later reject path。

## 6. 苏格拉底式检查清单

在你准备宣布“结构 refinement packet 已经成立”前，先问自己：

1. 我保住的是 current-truth surface，还是一个看起来仍能工作的入口。
2. 我证明的是 writer chokepoint，还是一次幸运的恢复结果。
3. 我消灭的是 stale writer，还是只是暂时没再观察到它写回来。
4. 我保护的是 fail-closed 边界，还是一套默认大家会小心的团队礼仪。
5. later maintainer 真要 reopen 时，依赖的是正式 packet fields 与 later reject path，还是作者补充的口头背景。

## 7. 一句话总结

结构 refinement correction 精修协议真正值钱的，不是再列一包更大的字段，而是把 packet field、shared reject semantics、fail-closed 与 long-horizon reopen 继续挂回同一条 `one writable present` 真相链。
