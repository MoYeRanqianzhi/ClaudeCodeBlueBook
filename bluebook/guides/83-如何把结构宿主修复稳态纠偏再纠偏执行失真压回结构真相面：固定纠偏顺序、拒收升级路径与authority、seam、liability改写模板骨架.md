# 如何把结构宿主修复稳态纠偏再纠偏执行失真压回结构真相面：固定纠偏顺序、拒收升级路径与authority、seam、liability改写模板骨架

这一章不再解释结构宿主修复稳态纠偏再纠偏执行最常怎样失真，而是把 Claude Code 式结构再纠偏改写压成一张可执行的 builder-facing 手册。

它主要回答五个问题：

1. 为什么结构再纠偏改写真正要救回的不是“系统重新恢复秩序感”，而是同一个结构真相面。
2. 怎样把假 `authority surface`、伪 `single-source`、假 `lineage reproof`、伪 `anti-zombie evidence` 与假 `reopen liability` 压回固定纠偏顺序。
3. 哪些现象应被直接升级为硬拒收，而不是继续补 recorrection、archive 与责任文案。
4. 怎样把 `recorrection card`、`authority seam block`、`lineage reproof block`、`anti-zombie evidence block` 与 `reopen liability ticket` 重新压回结构对象骨架。
5. 怎样用苏格拉底式追问避免把纠偏写成“把系统再纠偏流程再做细一点”。

## 0. 代表性源码锚点

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

## 1. 第一性原理

结构再纠偏改写真正要救回的不是：

- 更像样的 recorrection 流程
- 更完整的 archive 清单
- 更谨慎的 reopen 提示

而是：

- 同一个 `authority object` 在同一个 `authoritative path / writer chokepoint / lineage chain / anti-zombie evidence / reopen boundary` 上持续成立

结构真相面首先不是“恢复叙事”，而是“唯一 authority”。所以更稳的判断顺序不是：

- 先看 pointer 有没有恢复
- 先看 telemetry 有没有转绿
- 先看 archive prose 有没有解释通

而是：

1. `authority surface` 只能有一个主语。
2. `single-source` 必须同时覆盖读侧与写侧，不能只做到只读单源。
3. `lineage reproof` 证明的是身份连续性，而不是一次幸运 reconnect。
4. `anti-zombie evidence` 证明的是旧 generation、旧 writer、旧 snapshot 已无法再污染当前状态，而不是“现在看起来很安静”。
5. `reopen liability` 保留的是未来推翻当前结构结论的正式边界，而不是一句“以后再看”。

## 2. 固定纠偏顺序

### 2.1 先冻结假 surface

第一步不是补 recorrection note，而是先把所有会冒充 authority 的表层信号降级：

1. demote pointer、sidecar、telemetry、archive prose 与“标题恢复了”的秩序感。
2. 冻结任何“已经恢复”的先验 verdict。
3. 把 `authority_candidate_scope` 收窄到真正需要复证的对象。

最小冻结对象：

1. `demoted_surface_refs`
2. `frozen_false_verdict`
3. `authority_candidate_scope`

### 2.2 再恢复 `authority surface`

第二步要救回：

1. `authority_object_id`
2. `authoritative_path`
3. `writer_chokepoint`
4. `correction_generation`
5. `authority_surface_restored_at`

只要 authority 还靠 pointer、缓存文件与作者说明维持，就不能算 restored。

### 2.3 再封口 `single-source` 与 `writeback seam`

第三步要修的是：

1. `single_source_ref`
2. `writeback_primary_path`
3. `append_chain_ref`
4. `side_write_quarantined`
5. `metadata_bypass_blocked`

结构线里，`single-source` 之后必须立刻跟 `writeback seam`，因为只读单源而写侧双源，仍然是假单源。

### 2.4 再恢复 `lineage reproof`

第四步要把恢复顺序从好运气拉回正式对象：

1. `session_id_ref`
2. `transcript_path_ref`
3. `worktree_session_ref`
4. `generation_ref`
5. `file_history_ref`
6. `content_replacement_ref`
7. `lineage_break_detected`

能 resume、能 reconnect、能看到旧消息，都不等于 lineage 已被复证。

### 2.5 再恢复 `anti-zombie evidence`

第五步要把 zombie 清退从 archive prose 拉回正式证据：

1. `stale_generation_blocked`
2. `stale_finally_suppressed`
3. `fresh_state_merge_ref`
4. `orphan_writer_resolved`
5. `append_conflict_resolution_ref`
6. `anti_zombie_evidence_ref`

只要这一步没修好，later 团队继承的就仍是一条假连续时间线。

### 2.6 最后恢复 `reopen liability`

最后才修未来重新推翻当前 recorrection 的合法回跳边界：

1. `reopen_boundary`
2. `reservation_owner`
3. `return_authority_object`
4. `return_writeback_path`
5. `threshold_retained_until`
6. `reopen_required_when`

不要反过来：

1. 不要先删临时痕迹，再修 authority。
2. 不要先写“以后再 reconnect”，再修 liability。
3. 不要先交付 archive 文本，再修 anti-zombie 证据。

### 2.7 最后输出改写工件

下面这些工件只能是前六步的末端产物，不能反过来充当 authority：

1. `structural_recorrection_card`
2. `authority_seam_block`
3. `lineage_reproof_block`
4. `anti_zombie_evidence_block`
5. `reopen_liability_ticket`

## 3. 硬拒收规则

出现下面情况时，应直接升级为硬拒收：

1. `pointer_is_authority`
2. `authority_surface_multi_home`
3. `single_source_read_only`
4. `resume_without_lineage`
5. `green_telemetry_as_evidence`
6. `stale_generation_can_write`
7. `append_chain_unresolved`
8. `archive_prose_substitutes_proof`
9. `reopen_liability_missing`
10. `reopen_required_but_continue`

## 4. 模板骨架

### 4.1 structural recorrection card 骨架

1. `structural_recorrection_card_id`
2. `authority_object_id`
3. `authoritative_path`
4. `writer_chokepoint`
5. `single_source_ref`
6. `lineage_reproof_ref`
7. `anti_zombie_evidence_ref`
8. `reopen_liability_ref`
9. `reject_verdict`
10. `verdict_reason`

### 4.2 authority seam block 骨架

1. `authority_seam_block_id`
2. `authority_object_id`
3. `authoritative_path`
4. `writer_chokepoint`
5. `writeback_primary_path`
6. `append_chain_ref`
7. `side_write_quarantined`
8. `metadata_bypass_blocked`

### 4.3 lineage reproof block 骨架

1. `lineage_reproof_block_id`
2. `session_id_ref`
3. `transcript_path_ref`
4. `worktree_session_ref`
5. `generation_ref`
6. `file_history_ref`
7. `content_replacement_ref`
8. `lineage_break_detected`

### 4.4 anti-zombie evidence block 骨架

1. `anti_zombie_evidence_block_id`
2. `stale_generation_blocked`
3. `stale_finally_suppressed`
4. `fresh_state_merge_ref`
5. `orphan_writer_resolved`
6. `append_conflict_resolution_ref`
7. `anti_zombie_evidence_ref`

### 4.5 reopen liability ticket 骨架

1. `reopen_liability_id`
2. `reopen_boundary`
3. `reservation_owner`
4. `return_authority_object`
5. `return_writeback_path`
6. `threshold_retained_until`
7. `reopen_required_when`

## 5. 苏格拉底式检查清单

在你准备宣布“结构 steady-state correction-of-correction execution distortion 已纠偏完成”前，先问自己：

1. 我现在保护的是 authority object，还是恢复成功的感觉。
2. 我现在封住的是单一真源，还是只让界面看起来更整洁。
3. 我现在证明的是 lineage，还是只是一次幸运 reconnect。
4. 我现在阻止的是 zombie writer 回写，还是只是换来一张安静的 telemetry 面板。
5. 如果明天必须 reopen，我保留下来的到底是可反证的 boundary，还是一句“以后再试一次”。

## 6. 一句话总结

真正成熟的结构宿主修复稳态纠偏再纠偏改写，不是把 recorrection、archive 与责任流程写得更像制度，而是先 `authority surface -> single-source/writeback seam -> lineage reproof -> anti-zombie evidence -> reopen liability`，最后才允许 artifacts 出场。
