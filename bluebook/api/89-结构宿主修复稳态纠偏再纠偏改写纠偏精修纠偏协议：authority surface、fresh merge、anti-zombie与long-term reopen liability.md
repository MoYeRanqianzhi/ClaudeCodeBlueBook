# 结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏协议：authority surface、single-source writeback、fresh merge、anti-zombie 与 long-term reopen liability

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象，让宿主、CI、评审与交接在结构 refinement correction 已被固定之后，继续消费同一个结构真相面，而不是退回更工整的架构说明。
2. 哪些字段属于必须共享的修正对象，哪些属于 `hard_reject / reentry / reopen` 语义，哪些仍不应被绑定成公共 ABI。
3. 为什么 Claude Code 的源码先进性来自 authority、single-source writeback、lineage、fresh merge、anti-zombie、transport boundary 与 dirty git fail-closed 这些正式结构对象，而不是“架构整洁度”。
4. 宿主开发者该按什么顺序消费这套结构 refinement correction 协议。
5. 哪些现象一旦出现，应被直接升级为 `hard_reject`、`merge_reproof_required`、`transport_reseal_required`、`fail_closed_reseal_required` 或 `reopen_required`，而不是继续宣称结构已经重新稳定。

## 0. 关键源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:186-230`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/utils/worktree.ts:1046-1172`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-211`

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `StructureRefinementCorrectionContract`

的单独公共对象。

但结构 refinement correction 已经能围绕十类正式对象稳定成立：

1. `reprotocol_session_object`
2. `authority_surface_contract`
3. `single_source_writeback_contract`
4. `lineage_resume_contract`
5. `fresh_merge_contract`
6. `anti_zombie_restitution_packet`
7. `transport_boundary_contract`
8. `fail_closed_worktree_contract`
9. `reject_semantics_packet`
10. `long_horizon_reopen_liability`

更成熟的结构 refinement correction 方式不是：

- 只看 pointer 还在
- 只看 telemetry 重新转绿
- 只看 archive prose 更完整

而是：

- 围绕这十类对象继续消费同一个 authority surface、同一条 single-source writeback、同一条 lineage、同一份 fresh merge 契约、同一套 anti-zombie 证据、同一条 transport boundary、同一个 dirty git fail-closed 约束与同一个 reopen liability

## 2. 第一性原理

结构世界真正先进，不是目录更整洁，而是：

1. `authority surface` 继续只有一个主语。
2. `single-source writeback` 必须覆盖读侧与写侧，不能只做成只读单源。
3. `lineage` 证明恢复的是不是同一个对象。
4. `fresh merge` 证明 stale finally、删除语义与冲突收口仍然受控。
5. `anti-zombie` 证明旧 generation、旧 writer、旧 snapshot 已无法回写。
6. `transport boundary` 证明远端、本地与 projection 只允许一种消息语义。
7. `dirty git fail-closed` 证明系统在脏状态下拒绝继续制造第二真相。
8. `reopen liability` 证明 later 团队仍能沿同一 authority/writeback/boundary 链正式反驳当前结构结论。

所以结构 refinement correction 真正要被宿主消费的不是恢复叙事，而是 authority、writeback、lineage、merge、anti-zombie、transport 与 reopen 边界继续可验证地成立。

## 3. 会话、authority 与 single-source 托管

结构宿主应至少围绕下面对象消费 refinement correction 真相：

### 3.1 reprotocol session object

1. `reprotocol_session_id`
2. `refinement_session_id`
3. `authority_object_id`
4. `reprotocol_generation`
5. `shared_consumer_surface`
6. `reprotocol_started_at`

### 3.2 authority surface contract

1. `authority_object_id`
2. `authoritative_path`
3. `externally_verifiable_head`
4. `writer_chokepoint`
5. `authority_restituted_at`

### 3.3 single source writeback contract

1. `single_source_ref`
2. `writeback_primary_path`
3. `append_chain_ref`
4. `side_write_quarantined`
5. `writeback_contract_attested`

这些字段回答的不是：

- 当前哪个入口看起来更像真相

而是：

- 当前到底把哪个 authority surface 正式交还给 later 维护者，以及旁路写回是否真的已经失去资格

## 4. lineage、fresh merge 与 anti-zombie 托管

结构宿主还必须显式消费：

### 4.1 lineage resume contract

1. `session_id_ref`
2. `transcript_path_ref`
3. `worktree_session_ref`
4. `resume_lineage_ref`
5. `generation_ref`
6. `restore_lineage_attested`

### 4.2 fresh merge contract

1. `last_uuid_ref`
2. `append_conflict_resolution_ref`
3. `stale_finally_suppressed`
4. `deletion_semantics_attested`
5. `fresh_merge_contract_attested`

### 4.3 anti zombie restitution packet

1. `anti_zombie_evidence_ref`
2. `unresolved_tool_use_filtered`
3. `orphan_thinking_filtered`
4. `assistant_sentinel_attested`
5. `duplicate_control_response_ignored`

这里最重要的是：

- `lineage` 不是一次幸运 reconnect
- `fresh merge` 不是 last-write-wins
- `anti-zombie` 不是“现在很安静”，而是旧 writer 与旧 generation 真的已经失去回写资格

## 5. transport、fail-closed 与长期 reopen 责任面

结构宿主还必须显式消费：

### 5.1 transport boundary contract

1. `transport_boundary_attested`
2. `bridge_transport_ref`
3. `accepted_event_type`
4. `single_message_semantics_attested`
5. `payload_unwrap_ref`

### 5.2 fail closed worktree contract

1. `dirty_git_fail_closed_attested`
2. `worktree_change_guard`
3. `unpushed_commit_guard`
4. `cleanup_skip_contract_attested`
5. `worktree_prune_attested`

### 5.3 long horizon reopen liability

1. `reopen_boundary`
2. `return_authority_object`
3. `return_writeback_path`
4. `return_generation_floor`
5. `threshold_retained_until`
6. `reservation_owner`
7. `reentry_required_when`
8. `reopen_required_when`

这里最重要的是：

- pointer 只是 breadcrumb，不是 authority surface
- `dirty git fail-closed` 不是团队礼仪，而是正式结构对象
- `reopen` 保护的是未来仍能沿同一 authority/writeback/boundary 链推翻当前结构状态

## 6. reject 语义

结构宿主还必须显式消费：

1. `hard_reject`
2. `merge_reproof_required`
3. `transport_reseal_required`
4. `fail_closed_reseal_required`
5. `reentry_required`
6. `reopen_required`
7. `pointer_as_authority`
8. `authority_surface_self_report_only`
9. `single_source_missing`
10. `append_chain_unproven`
11. `fresh_merge_contract_missing`
12. `stale_generation_can_write`
13. `anti_zombie_evidence_missing`
14. `transport_second_semantics_detected`
15. `dirty_git_fail_open`
16. `reopen_liability_missing`

这些 reject 语义的价值在于：

- 把“结构真相面已经不能继续被共同消费”翻译成 later 维护者也能直接执行的拒收语言

## 7. 不应直接绑定成公共 ABI 的内容

宿主不应直接把下面内容绑成长期契约：

1. pointer mtime
2. reconnect 按钮状态
3. telemetry 绿灯
4. archive prose 摘要
5. 单次截图
6. 作者口头说明
7. “最近没再出事”的健康感

它们可以是线索，但不能是结构 refinement correction 协议对象。

## 8. 消费顺序建议

更稳的顺序是：

1. 先验 `reprotocol_session_object`
2. 再验 `authority_surface_contract`
3. 再验 `single_source_writeback_contract`
4. 再验 `lineage_resume_contract`
5. 再验 `fresh_merge_contract`
6. 再验 `anti_zombie_restitution_packet`
7. 再验 `transport_boundary_contract`
8. 再验 `fail_closed_worktree_contract`
9. 再验 `reject_semantics_packet`
10. 最后验 `long_horizon_reopen_liability`

不要反过来做：

1. 不要先看 pointer 还在不在，再修 authority surface。
2. 不要先看 telemetry 转绿，再修 single-source writeback。
3. 不要先看“恢复成功率”，再修 lineage 与 fresh merge。
4. 不要先看目录说明更清楚，再修 anti-zombie 与 reopen liability。

## 9. 苏格拉底式检查清单

在你准备宣布“结构 refinement correction 已经成立”前，先问自己：

1. 我保住的是 authority surface，还是一个看起来仍然能工作的入口。
2. 我证明的是 single-source writeback，还是一次幸运的恢复结果。
3. 我消灭的是 stale writer，还是只是暂时没再观察到它写回来。
4. 我保护的是 fail-closed 边界，还是一套默认大家会小心的团队礼仪。
5. 我留住的是 future reopen 的正式能力，还是一句“以后再试一次”。
