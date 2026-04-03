# 结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修协议：authority surface、fresh merge、fail-closed 与 long-term reopen liability

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象，让宿主、CI、评审与交接在结构 refinement correction fixed order 已被钉死之后，继续消费同一个结构 repair truth，而不是退回更工整的架构说明。
2. 哪些字段属于必须共享的 repair 对象，哪些属于共同 `hard_reject / reentry / reopen` 语义，哪些仍不应被绑定成公共 ABI。
3. 为什么 Claude Code 的源码先进性来自 authority、single-source writeback、lineage、fresh merge、anti-zombie、transport boundary 与 dirty git fail-closed 这些正式 repair 对象，而不是“架构整洁度”。
4. 宿主开发者该按什么顺序消费这套结构 refinement correction 精修协议。
5. 哪些现象一旦出现，应被直接升级为 `hard_reject`、`merge_reproof_required`、`fail_closed_reseal_required`、`repair_attestation_rebuild_required`、`reentry_required` 或 `reopen_required`，而不是继续宣称结构已经重新稳定。

## 0. 关键源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:186-230`
- `claude-code-source-code/src/utils/conversationRecovery.ts:375-400`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/utils/worktree.ts:1046-1172`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-211`
- `claude-code-source-code/src/cli/transports/SSETransport.ts:149-457`

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `StructureRefinementCorrectionRepairProtocol`

的单独公共对象。

但结构 refinement correction fixed order 已经能围绕九类正式对象稳定成立：

1. `repair_session_object`
2. `repair_authority_surface`
3. `single_source_writeback_surface`
4. `lineage_fresh_merge_surface`
5. `anti_zombie_restitution_surface`
6. `transport_fail_closed_surface`
7. `cross_consumer_repair_attestation`
8. `shared_reject_semantics_packet`
9. `long_horizon_reopen_liability`

更成熟的结构 refinement correction 方式不是：

- 只看 pointer 还在
- 只看 telemetry 重新转绿
- 只看 archive prose 更完整

而是：

- 围绕这九类对象继续消费同一个 authority surface、同一条 single-source writeback、同一条 lineage/fresh merge、同一套 anti-zombie/transport/fail-closed 证据、同一份 cross-consumer repair attestation 与同一个 long-horizon reopen liability

这套对象面应被理解成一个 ordered repair stream，而不是若干孤立诊断值：

1. 先决 authority
2. 再决 lineage
3. 再决 merge
4. 再决 writeback
5. 最后才决 reopen

## 2. 第一性原理

结构世界真正先进，不是目录更整洁，而是：

1. `authority surface` 继续只有一个主语。
2. `single-source writeback` 必须覆盖读侧与写侧，不能只做成只读单源。
3. `lineage + fresh merge` 证明恢复的是不是同一个对象，而不是一次 last-write-wins 的幸运结果。
4. `anti-zombie` 证明旧 generation、旧 writer、旧 snapshot 已无法回写。
5. `transport boundary + fail-closed worktree` 证明系统在脏状态与漂移状态下拒绝继续制造第二真相。
6. `reopen liability` 证明 later 团队仍能沿同一 authority/writeback/boundary 链正式反驳当前结构结论。

所以结构 refinement correction 真正要被宿主消费的不是恢复叙事，而是 authority、writeback、lineage、merge、anti-zombie、transport、fail-closed 与 reopen 边界继续可验证地成立。

## 3. repair session object 与 authority surface

结构宿主应至少围绕下面对象消费 refinement correction 真相：

### 3.1 repair session object

1. `repair_session_id`
2. `reprotocol_session_id`
3. `refinement_session_id`
4. `authority_object_id`
5. `repair_generation`
6. `shared_consumer_surface`
7. `repair_started_at`

### 3.2 repair authority surface

1. `authority_object_id`
2. `authoritative_path`
3. `externally_verifiable_head`
4. `writer_chokepoint`
5. `authority_surface_attested`

这些字段回答的不是：

- 当前哪个入口看起来更像真相

而是：

- 当前到底把哪个 authority surface 正式交还给 later 维护者

## 4. single-source、lineage 与 fresh merge surface

结构宿主还必须显式消费：

### 4.1 single source writeback surface

1. `single_source_ref`
2. `writeback_primary_path`
3. `append_chain_ref`
4. `side_write_quarantined`
5. `single_source_writeback_attested`

### 4.2 lineage fresh merge surface

1. `resume_lineage_ref`
2. `lineage_reproof_ref`
3. `generation_guard_attested`
4. `fresh_merge_contract`
5. `stale_finally_suppressed`
6. `delete_semantics_retained`
7. `fresh_merge_surface_attested`

这里最重要的是：

- `lineage` 不是一次幸运 reconnect
- `fresh merge` 不是 last-write-wins
- `single-source` 不是目录审美

## 5. anti-zombie、transport/fail-closed 与 repair attestation

结构宿主还必须显式消费：

### 5.1 anti zombie restitution surface

1. `anti_zombie_evidence_ref`
2. `stale_writer_evidence`
3. `orphan_duplicate_quarantined`
4. `archive_truth_ref`
5. `anti_zombie_restitution_attested`

### 5.2 transport fail closed surface

1. `transport_boundary_attested`
2. `bridge_transport_ref`
3. `writeback_transport_ref`
4. `single_message_semantics_attested`
5. `dirty_git_fail_closed_attested`
6. `worktree_change_guard`
7. `unpushed_commit_guard`
8. `transport_fail_closed_surface_attested`

### 5.3 cross consumer repair attestation

1. `repair_attestation_id`
2. `authority_surface_ref`
3. `single_source_writeback_ref`
4. `lineage_fresh_merge_ref`
5. `anti_zombie_surface_ref`
6. `transport_fail_closed_surface_ref`
7. `consumer_projection_demoted`
8. `repair_attested_at`

这里最重要的是：

- pointer 只是 breadcrumb，不是 authority surface
- transport 只接受单一消息语义，不是 projection 的自由发挥空间
- `dirty git fail-closed` 不是团队礼仪，而是正式结构对象

更成熟的结构 repair 对象还应显式带出下面字段：

1. `kind`
2. `repair_id`
3. `phase_index`
4. `phase`
5. `host_action`
6. `authority.kind`
7. `authority.value`
8. `authority.source`
9. `authority.observed_at`
10. `writeback.mode`
11. `writeback.target_session_id`
12. `writeback.target_transcript_path`
13. `writeback.owns_worktree`
14. `lineage.tip_uuid`
15. `lineage.expected_prev_uuid`
16. `lineage.last_sequence_num`
17. `lineage.last_event_id`
18. `lineage.environment_id`
19. `merge.strategy`
20. `merge.scope`
21. `merge.patch`
22. `merge.delete_keys`
23. `anti_zombie.generation`
24. `anti_zombie.dedupe_key`
25. `anti_zombie.ttl_ms`
26. `anti_zombie.age_ms`
27. `transport.channel`
28. `transport.retry_class`
29. `transport.close_code`
30. `transport.liveness_timeout_ms`
31. `workspace.worktree_path`
32. `workspace.original_cwd`
33. `workspace.git_probe_ok`
34. `workspace.clean`
35. `workspace.unpushed_commits`
36. `reopen.mode`
37. `reopen.interruption_kind`
38. `reopen.synthetic_continue`
39. `reopen.sentinel_inserted`
40. `payload.type`
41. `payload.data`
42. `diagnostics.reason_code`
43. `diagnostics.message`

## 6. shared reject semantics 与长期 reopen 责任面

结构宿主还必须显式消费：

### 6.1 shared reject semantics packet

1. `hard_reject`
2. `pointer_as_authority`
3. `single_source_missing`
4. `lineage_reproof_missing`
5. `merge_reproof_required`
6. `anti_zombie_evidence_missing`
7. `transport_reseal_required`
8. `fail_closed_reseal_required`
9. `repair_attestation_rebuild_required`
10. `reentry_required`
11. `reopen_required`

### 6.2 long horizon reopen liability

1. `reopen_boundary`
2. `return_authority_object`
3. `return_writeback_path`
4. `return_generation_floor`
5. `threshold_retained_until`
6. `reservation_owner`
7. `reentry_required_when`
8. `reopen_required_when`

这里最重要的是：

- `reopen` 保护的是未来仍能沿同一 authority/writeback/boundary 链推翻当前结构状态
- `threshold` 不能在“当前看起来稳定”时被默默删除
- later 团队必须还能只凭正式对象独立推翻当前结构结论

建议至少把下面几类拒收语义显式对象化：

1. `phase_order_invalid`
2. `authority_conflict`
3. `writeback_target_ambiguous`
4. `lineage_mismatch`
5. `sequence_regression`
6. `duplicate_or_zombie`
7. `payload_untyped`
8. `stale_pointer_or_cursor`
9. `workspace_not_clean`
10. `merge_ambiguous`
11. `reopen_boundary_invalid`
12. `permanent_transport_failure`

## 7. 不应直接绑定成公共 ABI 的内容

宿主不应直接把下面内容绑成长期契约：

1. pointer mtime
2. reconnect 按钮状态
3. telemetry 绿灯
4. archive prose 摘要
5. 单次截图
6. 作者口头说明
7. “最近没再出事”的健康感

它们可以是线索，但不能是结构 refinement correction 精修协议对象。

## 8. 消费顺序建议

更稳的顺序是：

1. 先验 `repair_session_object`
2. 再验 `repair_authority_surface`
3. 再验 `single_source_writeback_surface`
4. 再验 `lineage_fresh_merge_surface`
5. 再验 `anti_zombie_restitution_surface`
6. 再验 `transport_fail_closed_surface`
7. 再验 `cross_consumer_repair_attestation`
8. 再验 `shared_reject_semantics_packet`
9. 最后验 `long_horizon_reopen_liability`

不要反过来做：

1. 不要先看 pointer 还在不在，再修 authority surface。
2. 不要先看 telemetry 转绿，再修 single-source writeback。
3. 不要先看“恢复成功率”，再修 lineage 与 fresh merge。
4. 不要先看目录说明更清楚，再修 anti-zombie、transport 与 fail-closed。

## 9. 苏格拉底式检查清单

在你准备宣布“结构 refinement correction 精修协议已经成立”前，先问自己：

1. 我保住的是 authority surface，还是一个看起来仍然能工作的入口。
2. 我证明的是 single-source writeback，还是一次幸运的恢复结果。
3. 我消灭的是 stale writer，还是只是暂时没再观察到它写回来。
4. 我保护的是 fail-closed 边界，还是一套默认大家会小心的团队礼仪。
5. 我留住的是 future reopen 的正式能力，还是一句“以后再试一次”。
