# 结构宿主修复稳态纠偏再纠偏改写纠偏精修执行手册：event stream / state writeback card、freshness gate、hard reject order与reopen drill

这一章不再解释结构 refinement protocol 该消费哪些字段，而是把 Claude Code 式结构 rewrite correction refinement protocol 压成一张可持续执行的 `host consumption card`。

它主要回答五个问题：

1. 为什么结构宿主修复稳态纠偏再纠偏改写纠偏精修真正执行的不是“系统又转绿了”，而是同一个 `authority object -> per-host authority width -> event stream / state writeback split -> freshness gate -> stale worldview eviction -> ghost capability eviction -> fail-closed reopen liability` 继续被共同消费。
2. 宿主、CI、评审与交接怎样共享同一张结构 `host consumption card`，而不是各自围绕 pointer、telemetry、archive prose 与临时口头补充工作。
3. 应该按什么固定顺序执行 `authority surface`、`single-source writeback`、`freshness-gated lineage`、`stale-worldview/ghost-capability eviction`、`transport fail-closed`、`hard reject semantics` 与 `reopen liability`，才能不让 split-brain、side write 与 zombie 风险重新复辟。
4. 哪些 `hard reject` 一旦出现就必须阻断 handoff、拒绝 restored 并进入 `re-entry / reopen` drill。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的系统健康页”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/handlePromptSubmit.ts:430-517`
- `claude-code-source-code/src/utils/task/framework.ts:77-248`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:186-400`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-211`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/utils/worktree.ts:1046-1172`
- `claude-code-source-code/src/cli/transports/SSETransport.ts:149-457`

## 1. 第一性原理

结构宿主修复稳态纠偏再纠偏改写纠偏精修真正要执行的不是：

- pointer 还在
- telemetry 又转绿了
- archive prose 更完整
- 当前没有再报错

而是：

- 同一个 `authority object` 是否仍只通过一个正式 `state writeback` 面宣布当前真相。
- `event stream` 是否仍只保存时间线，而没有临时重建 present truth。
- `freshness gate` 是否仍先于 continuity 生效，先剥夺旧 head、旧 generation 与旧 writer 的 authority，再谈恢复与继续。
- `stale worldview` 是否仍不能继续签发允许，`ghost capability` 是否仍会被正式驱逐。
- `dirty git fail-closed`、`worktree change guard` 与 `unpushed commit guard` 是否仍把“过去写坏现在”挡在写回前面。

所以这层 playbook 最先要看的不是：

- `host consumption card` 已经填完了

而是：

1. 当前 refinement session 是否仍围绕同一个 `authority_object_id + externally_verifiable_head`。
2. 当前 `event_stream_writeback_split` 是否仍把时间线和 present truth 严格分层。
3. 当前 `freshness_gate_attested` 是否仍阻止 stale finally、旧 append 与旧 snapshot 迟到篡位。
4. 当前 `stale_worldview_evidence` 与 `ghost_capability_eviction_state` 是否仍让旧判断与旧能力失去发令资格。
5. 当前 `reopen liability` 是否仍让 later 团队只凭正式对象而不是额外口头补充就能 reopen 当前结论。

## 2. 共享 host consumption card 最小字段

每次结构宿主修复稳态纠偏再纠偏改写纠偏精修巡检，宿主、CI、评审与交接系统至少应共享：

1. `host_consumption_card_id`
2. `refinement_session_id`
3. `rewrite_correction_session_id`
4. `authority_object_id`
5. `authoritative_path`
6. `externally_verifiable_head`
7. `per_host_authority_width`
8. `single_source_ref`
9. `writeback_primary_path`
10. `event_stream_writeback_split`
11. `freshness_gate_attested`
12. `resume_lineage_ref`
13. `lineage_reproof_ref`
14. `generation_guard_attested`
15. `stale_worldview_evidence`
16. `ghost_capability_eviction_state`
17. `anti_zombie_evidence_ref`
18. `transport_boundary_attested`
19. `dirty_git_fail_closed_attested`
20. `worktree_change_guard`
21. `unpushed_commit_guard`
22. `reopen_boundary`
23. `threshold_retained_until`
24. `shared_consumer_surface`
25. `reject_verdict`
26. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看 `authority object`、`per_host_authority_width` 与 `writeback_primary_path` 是否仍唯一。
2. CI 看 `event stream / state writeback`、`freshness gate`、`stale worldview`、`ghost capability`、`transport` 与 `fail-closed` 顺序是否完整。
3. 评审看 pointer、telemetry 与 archive prose 是否仍被清楚降为投影。
4. 交接看 later 团队能否只凭 `host consumption card` 重建同一 reject 与 reopen 判断。

## 3. 固定 hard reject 顺序

### 3.1 先验 `rewrite_refinement_session_object`

先看当前准备宣布 refinement 成立的，到底是不是同一个 `authority_object_id`，而不是一份更正式的结构说明。

### 3.2 再验 `authority_surface_and_width_covenant`

再看：

1. `authority_object_id`
2. `authoritative_path`
3. `externally_verifiable_head`
4. `per_host_authority_width`
5. `writer_chokepoint`

这一步先回答：

- 当前真相主语到底是谁
- 每个 host 消费的是不是同一 authority object 的合法 width，而不是自己额外宣布一份 present truth

### 3.3 再验 `single_source_writeback_seam`

再看：

1. `single_source_ref`
2. `writeback_primary_path`
3. `event_stream_writeback_split`
4. `side_write_quarantined`
5. `single_source_writeback_attested`

这一步先回答：

- 现在有没有旁路写还能回魂
- `event stream` 有没有在偷做 `state writeback` 的工作

### 3.4 再验 `freshness_gated_lineage_reproof`

再看：

1. `resume_lineage_ref`
2. `lineage_reproof_ref`
3. `generation_guard_attested`
4. `fresh_merge_contract`
5. `freshness_gate_attested`
6. `stale_finally_suppressed`

这一步先回答：

- later 团队恢复的是不是同一个对象链
- 旧 finally、旧 append 与旧 snapshot 是否在写入前就已经被 freshness gate 剥夺 authority

### 3.5 再验 `stale_worldview_and_ghost_capability_eviction`

再看：

1. `stale_worldview_evidence`
2. `ghost_capability_eviction_state`
3. `anti_zombie_evidence_ref`
4. `orphan_duplicate_quarantined`
5. `assistant_sentinel_attested`

这一步先回答：

- 当前判断是不是仍站在 fresh worldview 上
- dead capability token、旧 pin、旧 authority width 与 orphan state 是否仍不能回魂

### 3.6 再验 `transport_fail_closed_custody`

再看：

1. `transport_boundary_attested`
2. `single_message_semantics_attested`
3. `dirty_git_fail_closed_attested`
4. `worktree_change_guard`
5. `unpushed_commit_guard`

这一步先回答：

- transport 还只允许一种消息语义吗
- 写回边界还是 fail-closed 吗

### 3.7 再验 `hard_reject_semantics_abi` 与 `cross_consumer_attestation_packet`

再看：

1. `hard_reject`
2. `merge_reproof_required`
3. `freshness_gate_reseal_required`
4. `stale_worldview_reproof_required`
5. `ghost_capability_eviction_required`
6. `transport_reseal_required`
7. `fail_closed_reseal_required`
8. `reentry_required`
9. `reopen_required`

这一步先回答：

- 现在到底应继续、回跳、重封，还是正式 reopen

### 3.8 最后验 `reopen_liability_ledger` 与 `reject_verdict`

最后才看：

1. `reopen_boundary`
2. `return_authority_object`
3. `return_writeback_path`
4. `return_generation_floor`
5. `threshold_retained_until`
6. `reentry_required_when`
7. `reopen_required_when`

更稳的最终 verdict 只应落在：

1. `steady_state_chain_resealed`
2. `hard_reject`
3. `merge_reproof_required`
4. `freshness_gate_reseal_required`
5. `stale_worldview_reproof_required`
6. `ghost_capability_eviction_required`
7. `transport_reseal_required`
8. `fail_closed_reseal_required`
9. `reentry_required`
10. `reopen_required`

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前结构 refinement execution：

1. `refinement_session_missing`
2. `authority_surface_self_report_only`
3. `per_host_projection_claimed_authority`
4. `single_source_missing`
5. `event_stream_usurped_present`
6. `freshness_gate_missing`
7. `stale_worldview_unchecked`
8. `ghost_capability_not_evicted`
9. `anti_zombie_evidence_missing`
10. `transport_second_semantics_detected`
11. `dirty_git_fail_open`
12. `worktree_change_guard_failed`
13. `unpushed_commit_guard_failed`
14. `reopen_required_but_continue`

## 5. re-entry 与 reopen 处理顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先停止新的 reconnect、adopt 与 remote resume，不再让旧资产继续写回。
2. 先把 verdict 降级为 `hard_reject`、`merge_reproof_required`、`freshness_gate_reseal_required`、`stale_worldview_reproof_required`、`ghost_capability_eviction_required`、`transport_reseal_required`、`fail_closed_reseal_required`、`reentry_required` 或 `reopen_required`。
3. 先把 pointer、telemetry、archive prose 与 UI 投影降回 breadcrumb，不再让它们充当 authority。
4. 先回到上一个仍可验证的 `authority_object_id` 与 `writeback_primary_path`，补完 `event_stream_writeback_split`、`freshness_gate_attested`、`lineage_reproof_ref`、`stale_worldview_evidence`、`ghost_capability_eviction_state` 与 fail-closed guard。
5. 只有当 `return_authority_object + return_writeback_path + return_generation_floor` 被重新验证后，才允许重新 handoff。

## 6. 最小 drill 集

每轮至少跑下面八个结构宿主稳态纠偏再纠偏改写纠偏精修执行演练：

1. `authority_width_replay`
2. `event_stream_writeback_replay`
3. `freshness_gate_replay`
4. `stale_worldview_replay`
5. `ghost_capability_eviction_replay`
6. `anti_zombie_replay`
7. `transport_fail_closed_replay`
8. `reopen_liability_replay`

## 7. 复盘记录最少字段

每次结构宿主稳态纠偏再纠偏改写纠偏精修失败、再入场或 reopen，至少记录：

1. `host_consumption_card_id`
2. `refinement_session_id`
3. `authority_object_id`
4. `authoritative_path`
5. `per_host_authority_width`
6. `writeback_primary_path`
7. `event_stream_writeback_split`
8. `freshness_gate_attested`
9. `stale_worldview_evidence`
10. `ghost_capability_eviction_state`
11. `anti_zombie_evidence_ref`
12. `dirty_git_fail_closed_attested`
13. `reject_verdict`
14. `verdict_reason`

## 8. 苏格拉底式检查清单

在你准备宣布“结构已完成稳态纠偏再纠偏改写纠偏精修执行”前，先问自己：

1. 我现在修回的是唯一 `authority object`，还是只是把入口感重新包装了一遍。
2. 我现在保住的是 `event stream / state writeback` 的正式分层，还是几次幸运 reconnect 的结果。
3. 我现在保住的是 `freshness gate`，还是只是在等旧对象不要刚好迟到。
4. 我现在驱逐的是 `stale worldview` 与 `ghost capability`，还是只是在看一张安静的 telemetry 面板。
5. later 团队如果必须 reopen，依赖的是正式 `reopen liability`，还是仍要补额外口头解释。

## 9. 一句话总结

真正成熟的结构宿主修复稳态纠偏再纠偏改写纠偏精修执行，不是把健康感运行得更像制度，而是持续证明 `authority object`、`per-host authority width`、`event stream / state writeback`、`freshness gate`、`stale worldview`、`ghost capability` 与 `reopen liability` 仍围绕同一个结构真相面说真话。
