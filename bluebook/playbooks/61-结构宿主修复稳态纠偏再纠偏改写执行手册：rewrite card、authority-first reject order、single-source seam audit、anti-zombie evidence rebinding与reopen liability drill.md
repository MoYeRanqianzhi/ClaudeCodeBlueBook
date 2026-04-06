# 结构宿主修复稳态纠偏再纠偏改写执行手册：current-truth surface、writer chokepoint、freshness gate 与 reopen drill

这一章不再把 `rewrite card` 当成结构再纠偏改写执行的主语，而是把 Claude Code 式结构执行压成一张 builder-facing playbook。

它主要回答五个问题：

1. 为什么真正执行的不是“系统又转绿了”，而是同一个结构真相面仍被唯一写回点与 freshness gate 保护。
2. 宿主、CI、评审与交接怎样共享同一条结构执行判断链，而不是各自围绕 pointer、监控、archive prose 与作者说明工作。
3. 应该按什么固定顺序执行 `current-truth surface -> writer chokepoint -> freshness gate -> shared reject semantics -> reopen drill`。
4. 哪些 `reject verdict` 一旦出现就必须阻断 handoff、拒绝 restored 并进入 `re-entry / reopen`。
5. 怎样用苏格拉底式追问避免把这层写成“更细的系统健康页”。

## 0. 第一性原理

结构宿主修复稳态纠偏再纠偏改写真正要执行的不是：

- pointer 还在
- telemetry 又转绿了
- archive prose 更完整
- 作者说“应该没事了”

而是：

- current-truth surface、writer chokepoint、freshness gate、anti-zombie 证据与 later reject path 仍围绕同一个结构真相面成立

## 1. 固定执行顺序

### 1.1 先验 `current-truth surface`

先看当前 rewrite object 是否仍被同一个 `authority_object_id + authoritative_path + current_write_path` 支撑。

### 1.2 再验 `writer chokepoint`

再看：

1. `single_source_ref`
2. `writeback_primary_path`
3. `append_chain_ref`
4. `side_write_quarantined`
5. `metadata_bypass_blocked`

### 1.3 再验 `freshness gate`

再看：

1. `lineage_reproof_ref`
2. `generation_guard_attested`
3. `fresh_merge_contract`
4. `stale_finally_suppressed`
5. `anti_zombie_evidence_ref`

### 1.4 再验 `shared reject semantics`

再看：

1. `authority_conflict`
2. `writeback_target_ambiguous`
3. `lineage_mismatch`
4. `duplicate_or_zombie`
5. `workspace_not_clean`

### 1.5 最后验 `reopen drill`

最后才看：

1. `mirror_gap_ref`
2. `reopen_boundary`
3. `return_authority_object`
4. `return_writeback_path`
5. `reopen_required_when`

## 2. 直接阻断条件

出现下面情况时，应直接阻断当前结构 rewrite execution：

1. `pointer_is_authority`
2. `authority_surface_multi_home`
3. `single_source_missing`
4. `resume_without_lineage`
5. `green_telemetry_as_evidence`
6. `stale_generation_can_write`
7. `append_chain_unresolved`
8. `reopen_liability_missing`
9. `reopen_required_but_continue`

## 3. re-entry 与 reopen 处理顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先停止新的 reconnect、adopt 与 remote resume。
2. 先把 verdict 降级为 `hard_reject`、`reentry_required` 或 `reopen_required`。
3. 先把 pointer、telemetry、archive prose 与 UI 投影降回 breadcrumb。
4. 先回到上一个仍可验证的 current-truth surface 与 writeback path。
5. 补完 freshness gate 与 anti-zombie 证据后，才允许重新 handoff。

## 4. 最小 drill 集

每轮至少跑下面六个结构执行演练：

1. `authority_first_reject_replay`
2. `single_source_seam_audit_replay`
3. `lineage_reproof_replay`
4. `append_chain_resolution_replay`
5. `anti_zombie_replay`
6. `reopen_liability_replay`

## 5. 苏格拉底式检查清单

在你准备宣布“结构已完成再纠偏改写执行”前，先问自己：

1. 我现在修回的是唯一 current-truth surface，还是只是把入口感重新包装了一遍。
2. 我现在保住的是 `single-source + writeback seam`，还是更漂亮的目录讲法。
3. 我现在保住的是 `lineage reproof`，还是几次幸运 reconnect 的结果。
4. 我现在归还的是 anti-zombie 证据，还是一段更会解释的 archive prose。
5. later 团队明天如果必须 reopen，依赖的是正式 boundary，还是一句“以后再试一次”。

## 6. 一句话总结

真正成熟的结构宿主修复稳态纠偏再纠偏改写执行，不是把健康感运行得更像制度，而是持续证明 `current-truth surface -> writer chokepoint -> freshness gate -> shared reject semantics -> reopen drill` 仍围绕同一个结构真相面说真话。
