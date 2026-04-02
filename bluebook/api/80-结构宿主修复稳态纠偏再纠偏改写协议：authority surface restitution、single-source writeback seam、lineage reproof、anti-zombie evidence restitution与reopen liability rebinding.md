# 结构宿主修复稳态纠偏再纠偏改写协议：authority surface restitution、single-source writeback seam、lineage reproof、anti-zombie evidence restitution与reopen liability rebinding

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象让宿主、SDK、CI、评审与交接系统在结构 steady-state recorrection rewrite 之后消费同一个修正对象、拒收升级语义与长期 reopen 责任。
2. 哪些字段属于必须消费的结构 steady-state recorrection rewrite object，哪些属于 verdict 语义，哪些仍然不应被绑定成公共 ABI。
3. 为什么结构稳态再纠偏改写协议不应退回 pointer 健康感、telemetry 转绿、archive prose 与作者说明。
4. 宿主开发者该按什么顺序消费这套结构 steady-state recorrection rewrite 规则面。
5. 哪些现象一旦出现应被直接升级为 `hard_reject`、`reentry_required` 或 `reopen_required`，而不是继续宣布结构已经重新稳定。

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

- `StructureRepairSteadyStateRecorrectionRewriteContract`

的单独公共对象。

但结构宿主修复稳态再纠偏改写实际上已经能围绕九类正式对象稳定成立：

1. `rewrite_session_object`
2. `false_surface_demotion_set`
3. `authority_surface_restitution`
4. `single_source_writeback_seam`
5. `lineage_reproof`
6. `anti_zombie_evidence_restitution`
7. `reopen_liability_rebinding`
8. `structural_artifact_projection`
9. `rewrite_verdict`

更成熟的结构稳态再纠偏改写方式不是：

- 只看 pointer 还在
- 只看 telemetry 重新转绿
- 只看 archive prose 更完整
- 只看作者说“现在应该没问题了”

而是：

- 围绕这九类对象消费结构真相面怎样把 recorrection execution distortion 重新拉回同一个 authority object、同一个 authoritative path、同一个 writer chokepoint、同一条 lineage chain、同一套 anti-zombie 证据与同一个 reopen boundary

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
5. `anti-zombie evidence` 证明的是旧 generation、旧 writer、旧 snapshot 已无法回写，不是“现在看起来很安静”。
6. `reopen liability` 保留的是未来推翻当前结构结论的正式边界，而不是一句“以后再试一次”。

所以结构 rewrite 真正要被宿主消费的不是恢复叙事，而是 authority、writeback、lineage、anti-zombie 与 reopen 边界继续可验证地成立。

## 3. rewrite session object 与 false surface demotion set

宿主应至少围绕下面对象消费结构 rewrite 真相：

### 3.1 rewrite session object

1. `rewrite_session_id`
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

- 当前到底先降级了哪些假 surface，才能避免 rewrite 还没开始就被 pointer、telemetry 与 archive prose 再次接管

## 4. authority surface restitution 与 single-source writeback seam

结构宿主还必须显式消费：

### 4.1 authority surface restitution

1. `authority_object_id`
2. `authoritative_path`
3. `writer_chokepoint`
4. `correction_generation`
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

- `authority surface restitution + single-source writeback seam` 共同组成的结构 rewrite 对象真相

## 5. lineage reproof、anti-zombie evidence restitution 与 reopen liability rebinding

结构宿主还必须显式消费：

### 5.1 lineage reproof

1. `session_id_ref`
2. `transcript_path_ref`
3. `worktree_session_ref`
4. `generation_ref`
5. `file_history_ref`
6. `content_replacement_ref`
7. `lineage_break_detected`

### 5.2 anti-zombie evidence restitution

1. `stale_generation_blocked`
2. `stale_finally_suppressed`
3. `fresh_state_merge_ref`
4. `orphan_writer_resolved`
5. `append_conflict_resolution_ref`
6. `anti_zombie_evidence_ref`

### 5.3 reopen liability rebinding

1. `reopen_boundary`
2. `reservation_owner`
3. `return_authority_object`
4. `return_writeback_path`
5. `threshold_retained_until`
6. `reopen_required_when`

这里最重要的是：

- `lineage`、`anti-zombie` 与 `reopen liability` 不是后台清扫动作，而是 later 团队是否还能独立恢复结构真相的正式前提

## 6. structural artifact projection 与 rewrite verdict

结构稳态再纠偏改写还必须消费：

### 6.1 structural artifact projection

1. `structural_recorrection_card`
2. `authority_seam_block`
3. `lineage_reproof_block`
4. `anti_zombie_evidence_block`
5. `reopen_liability_ticket`

### 6.2 rewrite verdict

1. `steady_state_restituted`
2. `hard_reject`
3. `reentry_required`
4. `reopen_required`
5. `authority_surface_multi_home`
6. `single_source_read_only`
7. `resume_without_lineage`
8. `append_chain_unresolved`
9. `reopen_liability_missing`

这些 verdict reason 的价值在于：

- 把“结构真相面已经从 rewrite 层重新压回正式对象”翻译成宿主、CI、评审与交接都能共享的 reject / escalation 语义

## 7. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. pointer mtime
2. reconnect 按钮状态
3. telemetry 绿灯
4. 单次截图
5. archive prose 摘要
6. 作者口头说明
7. “最近没再出事”的健康感
8. 临时 sidecar 的存在感

它们可以是 rewrite 线索，但不能是 rewrite 对象。

## 8. rewrite 消费顺序建议

更稳的顺序是：

1. 先验 `rewrite_session_object`
2. 再验 `false_surface_demotion_set`
3. 再验 `authority_surface_restitution`
4. 再验 `single_source_writeback_seam`
5. 再验 `lineage_reproof`
6. 再验 `anti_zombie_evidence_restitution`
7. 最后验 `reopen_liability_rebinding`
8. 再看 `structural_artifact_projection`
9. 再给 `rewrite_verdict`

不要反过来做：

1. 不要先看 pointer。
2. 不要先看监控转绿。
3. 不要先看作者是否主观放心。

## 9. 苏格拉底式检查清单

在你准备宣布“结构已完成稳态再纠偏改写协议”前，先问自己：

1. 我现在修回的是同一个 authority object，还是只是把入口感重新包装了一遍。
2. 我现在保住的是 `single-source + writeback seam`，还是几次幸运 reconnect 的结果。
3. 我现在证明的是 lineage，还是只是在享受一张安静的 telemetry 面板。
4. 我现在归档的是 anti-zombie 证据，还是一段更会解释的 archive 文本。
5. later 团队明天如果必须 reopen，依赖的是正式 reopen liability，还是一句“以后再试一次”。

## 10. 一句话总结

Claude Code 的结构宿主修复稳态纠偏再纠偏改写协议，不是把健康感写成更正式的流程，而是 `authority surface restitution + single-source writeback seam + lineage reproof + anti-zombie evidence restitution + reopen liability rebinding` 共同组成的规则面。
