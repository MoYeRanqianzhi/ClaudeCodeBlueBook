# 如何把结构宿主修复稳态纠偏再纠偏改写纠偏精修执行失真压回结构真相面：packet field、fail-closed 与 liability 模板

这一章不再解释结构 refinement execution distortion 最常怎样失真，而是把 Claude Code 式结构精修执行压成一张 builder-facing packet 模板。

它主要回答五个问题：

1. 为什么结构 refinement execution 真正要救回的不是更漂亮的 `host consumption card`，而是同一个 packet 所锚定的 `one writable present`。
2. 怎样把假 card、假 fresh merge、假 fail-closed 与假 reopen liability 压回 packet field、shared reject semantics 与 later reject path。
3. 哪些字段必须留在 packet field，哪些只配降到 mirror gap 或 local diagnostics。
4. 哪些现象应直接升级为 reject、reentry 或 reopen。
5. 怎样用苏格拉底式追问避免把精修模板写成“更细的系统健康页”。

## 0. 第一性原理

结构 refinement execution 真正要救回的不是：

- 一张更完整的宿主消费卡
- 一份更整洁的 archive prose
- 一组更平静的 pointer / telemetry 信号

而是：

- later 维护者在作者缺席时，仍能围绕同一个 `current-truth surface + writer chokepoint + freshness gate + fail-closed boundary + later reject path` 说真话

## 1. 哪些字段只配留在 packet field

更稳的 packet field 只应留下：

1. `session_id`
2. `authority_object_id`
3. `current_truth_surface_ref`
4. `writer_chokepoint`
5. `current_write_path`
6. `generation_guard`
7. `merge_contract_ref`
8. `anti_zombie_evidence_ref`
9. `transport_boundary_ref`
10. `reject_verdict`
11. `reject_reason`
12. `next_action`

## 2. 哪些内容必须降回 mirror gap 或 diagnostics

### 2.1 `mirror gap`

1. `workspace.original_cwd`
2. `workspace.clean`
3. `workspace.unpushed_commits`
4. `dirty_git_fail_closed_attested`
5. `reopen_boundary`

### 2.2 `local diagnostics`

1. `payload.data`
2. `diagnostics.message`
3. `phase_index`
4. `consumer_projection_demoted`

这些内容可以帮助 later maintainer 判断，但不能继续长成公共 ABI。

## 3. 固定精修顺序

### 3.1 先验 `current-truth packet`

先确认 packet 仍锚定同一 `current_truth_surface_ref`。

### 3.2 再验 `writer chokepoint`

先确认所有写回仍经过同一 `writer_chokepoint + current_write_path`。

### 3.3 再验 `freshness gate`

先确认：

1. `generation_guard`
2. `fresh_merge_contract`
3. `anti_zombie_evidence_ref`
4. `duplicate_or_zombie_blocked`

### 3.4 再验 `fail-closed boundary`

先确认：

1. `transport_boundary_ref`
2. `dirty_git_fail_closed_attested`
3. `worktree_change_guard`
4. `unpushed_commit_guard`

### 3.5 最后才验 `later reject path`

先确认：

1. `mirror_gap_ref`
2. `later_reject_path`
3. `reopen_required_when`

## 4. shared reject semantics

这一页最值得固定的 reject 语义是：

1. `authority_conflict`
2. `writeback_target_ambiguous`
3. `lineage_mismatch`
4. `duplicate_or_zombie`
5. `workspace_not_clean`
6. `merge_ambiguous`
7. `reopen_boundary_invalid`
8. `permanent_transport_failure`

## 5. 不应继续升格的流程壳

下面这些内容不应再升格成独立对象：

1. `host consumption card`
2. `cross-consumer attestation`
3. `repair stream`
4. `liability ledger`

它们都只配做：

- carrier
- packet field 容器
- mirror gap 注释
- later reject path 辅助说明

## 6. 苏格拉底式检查清单

在你准备宣布“结构精修模板已经成立”前，先问自己：

1. 我保住的是 current-truth surface，还是一个看起来仍能工作的入口。
2. 我证明的是 writer chokepoint，还是一次幸运的恢复结果。
3. 我消灭的是 stale writer，还是只是暂时没再观察到它写回来。
4. 我保护的是 fail-closed 边界，还是一套默认大家会小心的团队礼仪。
5. later maintainer 真要 reopen 时，依赖的是正式 packet fields 与 later reject path，还是作者补充的口头背景。

## 7. 一句话总结

真正成熟的结构 refinement 执行模板，不是再列一包更大的字段，而是把 packet field、shared reject semantics、fail-closed 与 later reject path 持续挂回同一条 `one writable present` 真相链。
