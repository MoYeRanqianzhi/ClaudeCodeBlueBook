# 结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行手册：authority stream card、freshness gate与reopen drill

这一章不再解释结构 refinement correction refinement protocol 该共享哪些字段，而是把 Claude Code 式结构 refinement correction refinement protocol 压成一张可持续执行的 cross-consumer `authority stream card`。

它主要回答五个问题：

1. 为什么结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修真正执行的不是“系统又转绿了”，而是 authority、single-source、lineage、event stream / state writeback、freshness gate、stale worldview、anti-zombie、transport、dirty git fail-closed 与 reopen liability 的正式顺序。
2. 宿主、CI、评审与交接怎样共享同一张结构 `authority stream card`，而不是各自围绕 pointer、telemetry、archive prose 与作者说明工作。
3. 应该按什么固定顺序执行 `authority stream`、`single-source writeback`、`lineage/fresh merge`、`anti-zombie restitution`、`transport/fail-closed`、`cross-consumer attestation`、`shared reject` 与 `reopen drill`，才能不让 split-brain、side write 与 zombie 风险重新复辟。
4. 哪些 `shared reject order` 一旦出现就必须阻断 handoff、拒绝 restored 并进入 `re-entry / reopen`。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的系统健康页”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:186-400`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-211`
- `claude-code-source-code/src/utils/worktree.ts:1046-1172`
- `claude-code-source-code/src/cli/transports/SSETransport.ts:149-457`

## 1. 第一性原理

结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修真正要执行的不是：

- pointer 还在
- telemetry 又转绿了
- archive prose 更完整
- 作者说“应该没事了”

而是：

- authority stream、single-source writeback、resume lineage、event stream / state writeback、freshness gate、stale worldview、ghost capability、anti-zombie evidence、transport boundary、dirty git fail-closed 与 reopen boundary 仍围绕同一个结构真相面正式宣布：现在可以继续，也仍保留 later 团队合法 `re-entry / reopen` 的能力

Claude Code 的源码先进性之所以成立，不在目录更整洁，而在它把：

1. truth 先于 projection
2. 时间一致性先于静态分层
3. future maintainer 作为正式消费者
4. fail-closed 作为结构对象本身

提前编码进 authority、lineage、writeback、boundary 与 guard。

## 2. 共享 authority stream card 最小字段

每次结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修巡检，宿主、CI、评审与交接系统至少应共享：

1. `authority_stream_card_id`
2. `repair_attestation_id`
3. `reprotocol_session_id`
4. `authority_object_id`
5. `authoritative_path`
6. `externally_verifiable_head`
7. `writer_chokepoint`
8. `single_source_ref`
9. `writeback_primary_path`
10. `resume_lineage_ref`
11. `lineage_reproof_ref`
12. `fresh_merge_contract`
13. `generation_guard_attested`
14. `event_stream_writeback_split`
15. `freshness_gate_attested`
16. `stale_worldview_evidence`
17. `ghost_capability_eviction_state`
18. `anti_zombie_evidence_ref`
19. `transport_boundary_attested`
20. `dirty_git_fail_closed_attested`
21. `worktree_change_guard`
22. `unpushed_commit_guard`
23. `shared_reject_verdict`
24. `threshold_retained_until`
25. `reopen_required_when`
26. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看 authority object 与 writeback 主路径是否仍唯一。
2. CI 看 lineage、event-stream-vs-state-writeback、freshness gate、stale worldview、anti-zombie、transport 与 fail-closed 顺序是否完整。
3. 评审看 pointer、telemetry 与 archive prose 是否仍被清楚降为投影。
4. 交接看 later 团队能否只凭 card 安全接手与 reopen。

## 3. 固定 shared reject order

### 3.1 先验 `repair_session_object`

先看当前准备宣布 protocol 可执行的，到底是不是同一个 `authority_object_id`，而不是一份更正式的结构说明。

### 3.2 再验 `authority_stream_surface`

再看：

1. `authority_object_id`
2. `authoritative_path`
3. `externally_verifiable_head`
4. `writer_chokepoint`
5. `per_host_authority_width`

这一步先回答：

- 当前真相主语到底是谁

### 3.3 再验 `single_source_writeback_surface`

再看：

1. `single_source_ref`
2. `writeback_primary_path`
3. `append_chain_ref`
4. `side_write_quarantined`
5. `single_source_writeback_attested`
6. `event_stream_writeback_split`

这一步先回答：

- 现在有没有旁路写还能回魂

### 3.4 再验 `lineage_fresh_merge_surface`

再看：

1. `resume_lineage_ref`
2. `lineage_reproof_ref`
3. `generation_guard_attested`
4. `fresh_merge_contract`
5. `stale_finally_suppressed`
6. `delete_semantics_retained`
7. `freshness_gate_attested`

这一步先回答：

- later 团队恢复的是不是同一个对象链
- 旧 finally 与旧 append 现在还有没有篡位资格

### 3.5 再验 `anti_zombie_restitution_surface`

再看：

1. `anti_zombie_evidence_ref`
2. `stale_writer_evidence`
3. `orphan_duplicate_quarantined`
4. `stale_worldview_evidence`
5. `ghost_capability_eviction_state`
6. `archive_truth_ref`
7. `anti_zombie_restitution_attested`

这一步先回答：

- 旧 generation、旧 writer 与 orphan state 现在还有没有机会回魂

### 3.6 再验 `transport_fail_closed_surface`

再看：

1. `transport_boundary_attested`
2. `bridge_transport_ref`
3. `writeback_transport_ref`
4. `single_message_semantics_attested`
5. `dirty_git_fail_closed_attested`
6. `worktree_change_guard`
7. `unpushed_commit_guard`
8. `transport_only_projection`

这一步先回答：

- 当前 transport 还只允许一种消息语义吗
- 当前写回边界还是 fail-closed 吗

### 3.7 再验 `cross_consumer_repair_attestation`

再看：

1. `authority_surface_ref`
2. `single_source_writeback_ref`
3. `lineage_fresh_merge_ref`
4. `anti_zombie_surface_ref`
5. `transport_fail_closed_surface_ref`
6. `consumer_projection_demoted`

这一步先回答：

- 四类消费者消费的是不是同一个结构对象，而不是四份相似解释

### 3.8 再验 `shared_reject_semantics_packet`

再看：

1. `hard_reject`
2. `pointer_as_authority`
3. `single_source_missing`
4. `lineage_reproof_missing`
5. `merge_reproof_required`
6. `anti_zombie_evidence_missing`
7. `transport_reseal_required`
8. `fail_closed_reseal_required`
9. `repair_attestation_rebuild_required`
10. `event_stream_usurped_present`
11. `stale_worldview_unchecked`
12. `ghost_capability_not_evicted`
13. `reentry_required`
14. `reopen_required`

这一步先回答：

- 现在到底应继续、回跳、重封，还是正式 reopen

### 3.9 最后验 `long_horizon_reopen_liability`

最后才看：

1. `reopen_boundary`
2. `return_authority_object`
3. `return_writeback_path`
4. `return_generation_floor`
5. `threshold_retained_until`
6. `reentry_required_when`
7. `reopen_required_when`

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前结构执行并拒绝 handoff：

1. `authority_stream_broken`
2. `single_source_writeback_missing`
3. `lineage_fresh_merge_missing`
4. `anti_zombie_evidence_missing`
5. `transport_boundary_missing`
6. `dirty_git_fail_closed_false`
7. `worktree_change_guard_failed`
8. `unpushed_commit_guard_failed`
9. `repair_attestation_rebuild_required`

## 5. reopen drill 最小顺序

一旦 verdict 升级为 `reentry_required` 或 `reopen_required`，最低顺序应固定为：

1. 冻结当前 `authority stream card`，禁止把 pointer 健康感与 telemetry 转绿继续当真。
2. 保存 `authority_object_id`、`externally_verifiable_head`、`single_source_ref`、`resume_lineage_ref`、`event_stream_writeback_split`、`stale_worldview_evidence`、`anti_zombie_evidence_ref` 与 `dirty_git_fail_closed_attested`。
3. 先重建 authority 与 single-source，再重建 lineage/fresh merge 与 freshness gate，最后才考虑重新写回。
4. 明确 `return_authority_object`、`return_writeback_path` 与 `reopen_required_when`，禁止把 reopen 写成“之后再看”。

## 6. 苏格拉底式自检

在你准备宣布“结构 protocol 已经执行完毕”前，先问自己：

1. 我共享的是同一个结构真相面，还是四份彼此相像的健康说明。
2. 我共享的是同一条 shared reject order，还是不同消费者各自的健康标准。
3. 我保留的是 future reopen 的正式能力，还是一句“以后有问题再看”。
4. later 团队接手时依赖的是对象、边界与责任，还是仍要回到 pointer、telemetry、reconnect 提示与作者记忆。
5. `event stream` 与 `state writeback` 有没有被重新混写。
6. validator、adapter 与 host consumer 现在看到的是 fresh worldview，还是 stale worldview。
7. 我现在保护的是 Claude Code 的结构先进性，还是只是在把它写成更像先进系统的 prose。
