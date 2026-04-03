# 结构宿主修复稳态纠偏再纠偏改写纠偏协议：authority surface restitution、single-source writeback seam、lineage reproof、fresh merge contract、anti-zombie evidence restitution、transport boundary attestation与reopen liability rebinding

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象，让宿主、SDK、CI、评审与交接系统在结构 steady-state recorrection rewrite correction 之后继续消费同一个 `rewrite correction object`、同一套拒收升级语义与长期 `reopen` 责任。
2. 哪些字段属于必须消费的结构 steady-state recorrection rewrite correction object，哪些属于 verdict 语义，哪些仍然不应被绑定成公共 ABI。
3. 为什么结构 rewrite correction 不应退回 pointer 健康感、telemetry 转绿、archive prose 与作者说明。
4. 宿主开发者该按什么顺序消费这套结构 rewrite correction 规则面。
5. 哪些现象一旦出现应被直接升级为 `hard_reject`、`merge_reproof_required`、`transport_reseal_required`、`reentry_required` 或 `reopen_required`，而不是继续宣布结构已经重新稳定。

## 0. 关键源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/handlePromptSubmit.ts:430-517`
- `claude-code-source-code/src/utils/task/framework.ts:77-248`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:533-570`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/utils/sessionState.ts:1-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:50-92`
- `claude-code-source-code/src/cli/structuredIO.ts:362-657`
- `claude-code-source-code/src/cli/print.ts:5048-5072`

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `StructureRepairSteadyStateRecorrectionRewriteCorrectionContract`

的单独公共对象。

但结构宿主修复稳态再纠偏改写纠偏实际上已经能围绕十一类正式对象稳定成立：

1. `rewrite_correction_session_object`
2. `false_surface_demotion_set`
3. `authority_surface_restitution`
4. `single_source_writeback_seam`
5. `lineage_reproof`
6. `fresh_merge_contract`
7. `anti_zombie_evidence_restitution`
8. `transport_boundary_attestation`
9. `dirty_git_fail_closed_attestation`
10. `reopen_liability_rebinding`
11. `rewrite_correction_verdict`

更成熟的结构 rewrite correction 方式不是：

- 只看 pointer 还在
- 只看 telemetry 重新转绿
- 只看 archive prose 更完整
- 只看作者说“现在应该没问题了”

而是：

- 围绕这十一类对象消费结构真相面怎样把 rewrite correction 重新拉回同一个 authority object、同一个 authoritative path、同一个 writer chokepoint、同一条 lineage chain、同一份 fresh merge 契约、同一套 anti-zombie 证据、同一条 transport boundary 与同一个 reopen boundary

这一层真正保护的不是：

- “系统感觉又健康了”

而是：

- 作者退场后，later 维护者仍能仅凭正式对象重建同一结构判断

## 2. 第一性原理

结构世界真正先进，不是目录更整洁，而是：

1. `authority surface` 继续只有一个主语。
2. `single-source` 必须覆盖读侧与写侧，不能只做成只读单源。
3. `writeback seam` 必须把唯一主路径与旁路写隔离开。
4. `lineage reproof` 证明的是身份连续性，不是一次幸运 reconnect。
5. `fresh merge contract` 证明的不是 last-write-wins，而是 stale finally、删除语义与冲突收口仍然受控。
6. `anti-zombie evidence` 证明的是旧 generation、旧 writer、旧 snapshot 已无法回写，不是“现在看起来很安静”。
7. `transport boundary` 与 `fail-closed worktree` 本身属于结构真相面，不是外围运维细节。
8. `reopen liability` 保留的是未来推翻当前结构结论的正式边界，而不是一句“以后再试一次”。

所以结构 rewrite correction 真正要被宿主消费的不是恢复叙事，而是 authority、writeback、lineage、merge、anti-zombie、transport 与 reopen 边界继续可验证地成立。

## 3. rewrite correction session object 与 false surface demotion set

宿主应至少围绕下面对象消费结构 rewrite correction 真相：

### 3.1 rewrite correction session object

1. `rewrite_correction_session_id`
2. `authority_object_id`
3. `rewrite_generation`
4. `rewritten_at`
5. `shared_consumer_surface`

### 3.2 false surface demotion set

1. `demoted_surface_refs`
2. `pointer_not_authority`
3. `telemetry_not_evidence`
4. `archive_prose_not_truth`
5. `false_surface_frozen_at`

这些字段回答的不是：

- 当前哪个入口看起来还最新

而是：

- 当前到底先降级了哪些假 surface，才能避免 rewrite correction 还没开始就被 pointer、telemetry 与 archive prose 再次接管

## 4. authority surface restitution 与 single-source writeback seam

结构宿主还必须显式消费：

### 4.1 authority surface restitution

1. `authority_object_id`
2. `authoritative_path`
3. `externally_verifiable_head`
4. `writer_chokepoint`
5. `authority_restituted_at`

### 4.2 single-source writeback seam

1. `single_source_ref`
2. `writeback_primary_path`
3. `append_chain_ref`
4. `side_write_quarantined`
5. `metadata_bypass_blocked`

这说明宿主当前消费的不是：

- 哪个 pointer 看起来还活着
- 哪张 telemetry 面板刚好转绿

而是：

- `authority surface restitution + single-source writeback seam` 共同组成的结构 rewrite correction 对象真相

这里最重要的是：

- authority surface 首先信外部可验证的头部状态，而不是对象自述

## 5. lineage reproof 与 fresh merge contract

结构宿主还必须显式消费：

### 5.1 lineage reproof

1. `session_id_ref`
2. `transcript_path_ref`
3. `worktree_session_ref`
4. `generation_ref`
5. `lineage_reproof_ref`

### 5.2 fresh merge contract

1. `fresh_merge_contract`
2. `deletion_semantics_attested`
3. `stale_finally_suppressed`
4. `append_conflict_resolution_ref`
5. `merge_contract_attested`

这里最重要的是：

- `fresh merge` 不是 last-write-wins
- 它证明的是“旧 finally、旧 append、旧 snapshot 即使在迟到后也不能继续篡位”

## 6. anti-zombie evidence restitution、transport boundary attestation 与 reopen liability rebinding

结构宿主还必须显式消费：

### 6.1 anti-zombie evidence restitution

1. `anti_zombie_evidence_ref`
2. `stale_generation_blocked`
3. `orphan_writer_resolved`
4. `stale_finally_suppressed`
5. `anti_zombie_restituted_at`

### 6.2 transport boundary attestation

1. `transport_boundary_attested`
2. `bridge_transport_ref`
3. `writeback_transport_ref`
4. `remote_boundary_generation`
5. `transport_resealed_at`

### 6.3 reopen liability rebinding

1. `dirty_git_fail_closed_attested`
2. `reopen_boundary`
3. `return_authority_object`
4. `threshold_retained_until`
5. `reopen_required_when`

这里最重要的是：

- `fail-closed worktree` 与统一 `transport boundary` 都属于源码先进性的正式部分
- later 团队能否独立恢复结构真相，不只取决于目录，还取决于“脏状态时是否拒绝继续写、远端与本地边界是否仍被正式证明”

## 7. rewrite correction verdict

结构 rewrite correction 还必须消费：

1. `steady_state_restituted`
2. `hard_reject`
3. `merge_reproof_required`
4. `transport_reseal_required`
5. `reentry_required`
6. `reopen_required`
7. `authority_surface_self_report_only`
8. `single_source_read_only`
9. `fresh_merge_contract_missing`
10. `dirty_git_fail_open`
11. `reopen_liability_missing`

这些 verdict reason 的价值在于：

- 把“结构真相面已经从 rewrite correction 层重新压回正式对象”翻译成宿主、CI、评审与交接都能共享的 reject / escalation 语义

## 8. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. pointer mtime
2. reconnect 按钮状态
3. telemetry 绿灯
4. 单次截图
5. archive prose 摘要
6. 作者口头说明
7. “最近没再出事”的健康感
8. 临时 sidecar 的存在感

它们可以是 rewrite correction 线索，但不能是 rewrite correction 对象。

## 9. rewrite correction 消费顺序建议

更稳的顺序是：

1. 先验 `rewrite_correction_session_object`
2. 再验 `false_surface_demotion_set`
3. 再验 `authority_surface_restitution`
4. 再验 `single_source_writeback_seam`
5. 再验 `lineage_reproof`
6. 再验 `fresh_merge_contract`
7. 再验 `anti_zombie_evidence_restitution`
8. 再验 `transport_boundary_attestation`
9. 最后验 `reopen_liability_rebinding`
10. 再给 `rewrite_correction_verdict`

不要反过来做：

1. 不要先看 pointer。
2. 不要先看监控转绿。
3. 不要先看作者是否主观放心。

## 10. 苏格拉底式检查清单

在你准备宣布“结构已完成稳态再纠偏改写纠偏协议”前，先问自己：

1. 我现在修回的是同一个 authority object，还是只是把入口感重新包装了一遍。
2. 我现在保住的是 `single-source + writeback seam`，还是几次幸运 reconnect 的结果。
3. 我现在证明的是 lineage 与 fresh merge contract，还是只是在享受一张安静的 telemetry 面板。
4. 我现在归档的是 anti-zombie 证据与 transport boundary，还是一段更会解释的 archive 文本。
5. later 团队明天如果必须 reopen，依赖的是正式 reopen liability，还是一句“以后再试一次”。

## 11. 一句话总结

Claude Code 的结构宿主修复稳态纠偏再纠偏改写纠偏协议，不是把健康感写成更正式的流程，而是 `authority surface restitution + single-source writeback seam + lineage reproof + fresh merge contract + anti-zombie evidence restitution + transport boundary attestation + reopen liability rebinding` 共同组成的规则面。
