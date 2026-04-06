# 结构宿主修复稳态纠偏再纠偏改写纠偏精修执行手册：packet field、fail-closed、hard reject 与 reopen drill

这一章不再把 `host consumption card` 当成结构 refinement execution 的主语，而是把 Claude Code 式结构精修执行压成一张 packet-first playbook。

它主要回答五个问题：

1. 为什么真正执行的不是“系统又转绿了”，而是同一个 `current-truth surface + writer chokepoint + fail-closed boundary` 继续被共同消费。
2. 宿主、CI、评审与交接怎样共享同一组 packet fields，而不是各自围绕 pointer、telemetry、archive prose 与临时口头补充工作。
3. 应该按什么固定顺序执行 `packet field -> freshness gate -> fail-closed -> hard reject semantics -> reopen drill`。
4. 哪些 `hard reject` 一旦出现就必须阻断 handoff、拒绝 restored 并进入 `re-entry / reopen`。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的系统健康页”。

## 0. 第一性原理

结构宿主修复稳态纠偏再纠偏改写纠偏精修真正要执行的不是：

- pointer 还在
- telemetry 又转绿了
- archive prose 更完整
- 当前没有再报错

而是：

- packet fields 仍锚定同一个 current-truth surface，freshness gate 仍先于 continuity 生效，fail-closed 边界仍在 later 维护者面前保持可拒收

## 1. 固定 hard reject 顺序

### 1.1 先验 `packet field`

先看当前 refinement session 是否仍围绕同一个：

1. `authority_object_id`
2. `current_truth_surface_ref`
3. `writer_chokepoint`
4. `current_write_path`

### 1.2 再验 `freshness gate`

再看：

1. `resume_lineage_ref`
2. `lineage_reproof_ref`
3. `generation_guard_attested`
4. `fresh_merge_contract`
5. `stale_finally_suppressed`
6. `anti_zombie_evidence_ref`

### 1.3 再验 `fail-closed boundary`

再看：

1. `transport_boundary_attested`
2. `dirty_git_fail_closed_attested`
3. `worktree_change_guard`
4. `unpushed_commit_guard`

### 1.4 再验 `hard reject semantics`

再看：

1. `authority_conflict`
2. `writeback_target_ambiguous`
3. `lineage_mismatch`
4. `duplicate_or_zombie`
5. `workspace_not_clean`
6. `permanent_transport_failure`

### 1.5 最后验 `reopen drill`

最后才看：

1. `mirror_gap_ref`
2. `later_reject_path`
3. `reopen_boundary`
4. `reentry_required_when`
5. `reopen_required_when`

## 2. 直接阻断条件

出现下面情况时，应直接阻断当前结构 refinement execution：

1. `refinement_session_missing`
2. `authority_surface_self_report_only`
3. `single_source_missing`
4. `event_stream_usurped_present`
5. `freshness_gate_missing`
6. `stale_worldview_unchecked`
7. `ghost_capability_not_evicted`
8. `transport_second_semantics_detected`
9. `dirty_git_fail_open`
10. `reopen_required_but_continue`

## 3. re-entry 与 reopen 处理顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先停止新的 reconnect、adopt 与 remote resume。
2. 先把 verdict 降级为 `hard_reject`、`reentry_required` 或 `reopen_required`。
3. 先把 pointer、telemetry、archive prose 与 UI 投影降回 breadcrumb。
4. 先回到上一个仍可验证的 packet field 与 current-truth surface。
5. 只有在 `return_authority_object + return_writeback_path + return_generation_floor` 被重新验证后，才允许重新 handoff。

## 4. 最小 drill 集

每轮至少跑下面八个结构 refinement 执行演练：

1. `authority_width_replay`
2. `event_stream_writeback_replay`
3. `freshness_gate_replay`
4. `stale_worldview_replay`
5. `ghost_capability_eviction_replay`
6. `anti_zombie_replay`
7. `transport_fail_closed_replay`
8. `reopen_liability_replay`

## 5. 苏格拉底式检查清单

在你准备宣布“结构 refinement execution 已纠偏完成”前，先问自己：

1. 我救回的是唯一 authority object，还是一张更正式的宿主消费卡。
2. 我现在保住的是 `single-source + fresh merge`，还是更漂亮的目录与几次幸运 reconnect。
3. 我现在保住的是 `dirty_git_fail_closed`，还是一种“当前没报错就先过”的冲动。
4. 我现在保留的是 future reopen 的正式 liability，还是一句“以后再试一次”。
5. later 团队明天如果必须 reopen，依赖的是正式 packet field 与 later reject path，还是作者口述、旧入口与 retry 循环。

## 6. 一句话总结

真正成熟的结构 refinement execution 精修，不是把宿主消费卡写得更严，而是把 `packet field -> freshness gate -> fail-closed -> hard reject semantics -> reopen drill` 持续挂回同一个 `one writable present` 真相链。
