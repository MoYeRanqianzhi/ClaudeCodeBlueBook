# 结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行手册：per-host authority width card、shared reject order、freshness gate与reopen drill

这一章不再解释结构 refinement correction repair protocol 该共享哪些字段，而是把 Claude Code 式结构 refinement correction repair protocol 压成一张可持续执行的 cross-consumer `repair card`。

它主要回答五个问题：

1. 为什么结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修真正执行的不是“系统又转绿了”，而是 `authority object -> per-host authority width -> event stream / state writeback split -> freshness gate -> stale worldview -> ghost capability -> fail-closed reopen liability` 的正式顺序。
2. 宿主、CI、评审与交接怎样共享同一张结构 `repair card`，而不是各自围绕 pointer、telemetry、archive prose 与临时说明工作。
3. 应该按什么固定顺序执行 `repair session`、`authority width`、`event-stream/state-writeback split`、`freshness-gated lineage`、`stale-worldview/ghost-capability eviction`、`transport/fail-closed`、`shared reject semantics` 与 `reopen liability`，才能不让 split-brain、side write 与 zombie 风险重新复辟。
4. 哪些 `shared reject order` 一旦出现就必须阻断 handoff、拒绝 restored 并进入 `re-entry / reopen` drill。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成更细的系统健康页。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:186-400`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/utils/worktree.ts:1046-1172`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-211`
- `claude-code-source-code/src/cli/transports/SSETransport.ts:149-457`

## 1. 第一性原理

结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修真正要执行的不是：

- pointer 还在
- telemetry 又转绿了
- archive prose 更完整
- 当前看起来已经很稳定

而是：

- 四类消费者共享的是不是同一个 `authority object`，而不是四份相似的结构说明。
- 每个 host 消费的是不是同一 authority object 的合法 `per-host authority width`，而不是自己额外宣布一份 present truth。
- `event stream` 是否仍只保存时间线，`state writeback` 是否仍独占 present truth。
- `freshness gate` 是否仍先于 continuity 生效，`stale worldview` 与 `ghost capability` 是否仍在写回前就被驱逐。

Claude Code 的源码先进性之所以成立，不在目录更整洁，而在它把：

1. 当前真相只能由一个正式写入面宣布
2. 过去对象不得写坏现在
3. 每个 host 只消费自己的 authority width
4. fail-closed 是结构对象本身

提前编码进 authority、writeback、lineage、freshness 与 eviction 纪律。

## 2. 共享 repair card 最小字段

每次结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修巡检，宿主、CI、评审与交接系统至少应共享：

1. `repair_card_id`
2. `repair_attestation_id`
3. `reprotocol_session_id`
4. `authority_object_id`
5. `authoritative_path`
6. `externally_verifiable_head`
7. `per_host_authority_width`
8. `writeback_primary_path`
9. `event_stream_writeback_split`
10. `freshness_gate_attested`
11. `lineage_reproof_ref`
12. `stale_worldview_evidence`
13. `ghost_capability_eviction_state`
14. `anti_zombie_evidence_ref`
15. `transport_boundary_attested`
16. `dirty_git_fail_closed_attested`
17. `worktree_change_guard`
18. `unpushed_commit_guard`
19. `shared_reject_verdict`
20. `threshold_retained_until`
21. `reopen_required_when`
22. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看 `authority object`、`per_host_authority_width` 与 `writeback_primary_path` 是否仍唯一。
2. CI 看 `event stream / state writeback`、`freshness gate`、`stale worldview`、`ghost capability`、transport 与 fail-closed 顺序是否完整。
3. 评审看 pointer、telemetry 与 archive prose 是否仍被清楚降为投影。
4. 交接看 later 团队能否只凭 `repair card` 与正式对象 reopen 当前结论。

## 3. 固定 shared reject order

### 3.1 先验 `repair_session_object`

先看当前准备宣布 refinement correction repair protocol 可执行的，到底是不是同一个 `authority_object_id`，而不是一份更正式的结构说明。

### 3.2 再验 `authority_object_and_width_surface`

再看：

1. `authority_object_id`
2. `authoritative_path`
3. `externally_verifiable_head`
4. `per_host_authority_width`
5. `writer_chokepoint`

这一步先回答：

- 当前真相主语到底是谁
- 不同 host 消费的是不是同一个 authority object 的合法 width

### 3.3 再验 `event_stream_writeback_split_and_freshness_gate`

再看：

1. `writeback_primary_path`
2. `event_stream_writeback_split`
3. `freshness_gate_attested`
4. `lineage_reproof_ref`
5. `generation_guard_attested`
6. `stale_finally_suppressed`

这一步先回答：

- `event stream` 有没有在偷做 `state writeback`
- 旧 finally、旧 append 与旧 snapshot 是否在写回前就已被 freshness gate 剥夺 authority

### 3.4 再验 `stale_worldview_and_ghost_capability_eviction`

再看：

1. `stale_worldview_evidence`
2. `ghost_capability_eviction_state`
3. `anti_zombie_evidence_ref`
4. `stale_writer_evidence`
5. `orphan_duplicate_quarantined`

这一步先回答：

- 当前判断站在的是 fresh worldview，还是 stale worldview
- dead capability token、旧 pin、旧 authority width 与 orphan state 是否仍被正式驱逐

### 3.5 再验 `transport_fail_closed_and_shared_reject`

再看：

1. `transport_boundary_attested`
2. `single_message_semantics_attested`
3. `dirty_git_fail_closed_attested`
4. `worktree_change_guard`
5. `unpushed_commit_guard`
6. `shared_reject_verdict`

这一步先回答：

- transport 还只允许一种消息语义吗
- 当前写回边界还是 fail-closed 吗
- 共同 reject 是否已经覆盖 `event_stream_usurped_present`、`stale_worldview_unchecked`、`ghost_capability_not_evicted` 与 `per_host_projection_claimed_authority`

### 3.6 最后验 `long_horizon_reopen_liability`

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
3. `event_stream_usurped_present`
4. `freshness_gate_reseal_required`
5. `stale_worldview_reproof_required`
6. `ghost_capability_eviction_required`
7. `transport_reseal_required`
8. `fail_closed_reseal_required`
9. `reentry_required`
10. `reopen_required`

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前结构 refinement correction repair execution：

1. `repair_session_missing`
2. `authority_surface_self_report_only`
3. `per_host_projection_claimed_authority`
4. `event_stream_usurped_present`
5. `freshness_gate_missing`
6. `stale_worldview_unchecked`
7. `ghost_capability_not_evicted`
8. `anti_zombie_evidence_missing`
9. `transport_second_semantics_detected`
10. `dirty_git_fail_open`
11. `repair_attestation_cross_consumer_mismatch`
12. `reopen_required`

## 5. re-entry 与 reopen 处理顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先停止新的 reconnect、adopt、remote resume 与写回，不再让旧资产继续回写。
2. 先把 verdict 降级为 `hard_reject`、`event_stream_usurped_present`、`freshness_gate_reseal_required`、`stale_worldview_reproof_required`、`ghost_capability_eviction_required`、`transport_reseal_required`、`fail_closed_reseal_required`、`reentry_required` 或 `reopen_required`。
3. 先把 pointer、telemetry、archive prose 与 UI 投影降回 breadcrumb，不再让它们充当 authority。
4. 先重建 `authority object + per-host authority width`，再重建 `event stream / state writeback split + freshness gate`，最后才重建 `stale worldview / ghost capability` 的驱逐状态。
5. 只有当 `return_authority_object + return_writeback_path + return_generation_floor` 被重新验证后，才允许重新 handoff。

## 6. 最小 drill 集

每轮至少跑下面八个结构宿主稳态纠偏再纠偏改写纠偏精修纠偏精修执行演练：

1. `authority_width_replay`
2. `event_stream_writeback_replay`
3. `freshness_gate_replay`
4. `stale_worldview_replay`
5. `ghost_capability_eviction_replay`
6. `anti_zombie_replay`
7. `transport_fail_closed_replay`
8. `reopen_liability_replay`

## 7. 复盘记录最少字段

每次结构宿主稳态纠偏再纠偏改写纠偏精修纠偏精修失败、再入场或 reopen，至少记录：

1. `repair_card_id`
2. `repair_attestation_id`
3. `authority_object_id`
4. `per_host_authority_width`
5. `writeback_primary_path`
6. `event_stream_writeback_split`
7. `freshness_gate_attested`
8. `stale_worldview_evidence`
9. `ghost_capability_eviction_state`
10. `anti_zombie_evidence_ref`
11. `shared_reject_verdict`
12. `reopen_required_when`

## 8. 苏格拉底式自检

在你准备宣布“结构 refinement correction repair protocol 已经进入 steady execution”前，先问自己：

1. 我现在让四类消费者共享的是同一个结构对象，还是四份看起来相似的恢复说明。
2. 我现在共享的是同一条 `shared reject order`，还是不同消费者各自的健康标准。
3. 我现在保留的是 formal reopen boundary，还是一句“以后有问题再看”。
4. later 团队接手时依赖的是 authority、width、writeback、freshness 与 eviction 对象，还是仍要回到 pointer、telemetry 与目录图。
5. 当前执行保护的是 one writable present，还是只是在把 repair protocol 写成更体面的系统健康页。

## 9. 一句话总结

真正成熟的结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行，不是让健康说明更像制度，而是持续证明 `authority object`、`per-host authority width`、`event stream / state writeback`、`freshness gate`、`stale worldview`、`ghost capability` 与 `reopen liability` 仍在共同保护同一个 present truth。
