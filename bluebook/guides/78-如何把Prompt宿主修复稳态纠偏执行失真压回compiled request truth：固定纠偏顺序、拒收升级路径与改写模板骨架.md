# 如何把Prompt宿主修复稳态纠偏执行失真压回compiled request truth：固定纠偏顺序、拒收升级路径与改写模板骨架

这一章不再解释 Prompt 宿主修复稳态纠偏执行最常怎样失真，而是把 Claude Code 式 Prompt correction-of-correction 压成一张可执行的 builder-facing 手册。

它主要回答五个问题：

1. 为什么 Prompt correction-of-correction 真正要救回的不是一张更严谨的 correction card，而是同一个 `compiled request truth`。
2. 怎样把假修正卡、口头真相恢复、前缀复托管表演与阈值装饰化压回固定纠偏顺序。
3. 哪些现象应被直接升级为硬拒收，而不是继续补 correction prose。
4. 怎样把 correction card、handoff repair block 与 threshold reinstatement ticket 重新压回对象级骨架。
5. 怎样用苏格拉底式追问避免把纠偏写成“把修正卡写得更像修正卡”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:343-347`
- `claude-code-source-code/src/utils/api.ts:136-405`
- `claude-code-source-code/src/services/api/claude.ts:1374-1485`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:494-698`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/services/compact/prompt.ts:293-337`
- `claude-code-source-code/src/services/compact/compact.ts:330-711`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-66`
- `claude-code-source-code/src/query/tokenBudget.ts:22-92`
- `claude-code-source-code/src/query.ts:1308-1518`

## 1. 第一性原理

Prompt correction-of-correction 真正要救回的不是：

- 一张更完整的 `correction card`
- 一份更像制度的 `handoff repair note`
- 一套更谨慎的 `re-entry` 话术

而是：

- 同一个 `compiled request truth` 在 correction 执行已经说过一次谎之后，仍能被模型继续消费、被 later 团队继续接手、被系统继续合法重开，而不重新退回作者解释、summary 平静感与默认 continuation

所以更稳的纠偏目标不是：

- 先把 correction 叙事说圆

而是：

1. 先把假 `correction_verdict` 降回结果信号，而不是让它充当主对象。
2. 先把 `steady_correction_object` 与 `truth_continuity_recovery` 从口头恢复里救出来。
3. 先把 `stable_prefix_recustody` 与 `baseline_dormancy_reseal` 从好运气、暂时没触发 cache break 与 prose handoff 里救出来。
4. 先把 `protocol transcript` 与 `lawful forgetting boundary` 从 UI 历史、compact prose 与作者解释里救出来。
5. 先把 `continuation_requalification` 与 `handoff_continuity_repair` 从经验式继续里救出来。
6. 先把 `threshold_reinstatement` 从提醒语气与以后再说里救出来。

Prompt 的魔力之所以显得像“咒语”，恰恰是因为它先把世界编译成同一个 request object、同一个 stable prefix asset 与同一个 continue qualification；一旦 correction 退回 prose，魔力就会从编译链退回安抚链。

## 2. 固定纠偏顺序

### 2.1 先冻结假 correction

第一步不是润色 correction card，而是冻结假修正信号：

1. 禁止 `correction_verdict=restored` 在对象复核之前生效。
2. 禁止“最近已经重新平静”冒充 `truth_continuity_recovery`。
3. 禁止 compact summary 可读、handoff prose 自洽冒充 prefix continuity。

最小恢复对象：

1. `steady_correction_object_id`
2. `restored_request_object_id`
3. `compiled_request_hash`
4. `correction_generation`
5. `correction_verdict`
6. `verdict_reason`

### 2.2 再恢复 `truth_continuity_recovery`

第二步要救回：

1. `truth_continuity_attested`
2. `restored_request_object_id`
3. `compiled_request_hash`
4. `protocol_truth_witness`
5. `protocol_transcript_health`
6. `truth_break_trigger_registered`

不要继续做的事：

1. 不要先看 steady 一段时间没有新噪音。
2. 不要先看最后一次 correction prose 写得是否完整。
3. 不要先看 later 团队是否主观觉得“现在应该还能继续”。

### 2.3 再恢复 `stable_prefix_recustody` 与 `baseline_dormancy_reseal`

第三步要把前缀资产与稳态静默从好运气里救回：

1. `stable_prefix_boundary`
2. `prefix_recustody_attested`
3. `compaction_lineage`
4. `lawful_forgetting_boundary`
5. `baseline_drift_ledger_id`
6. `sealed_generation`
7. `dormancy_resealed_at`

只要这一步没修好，correction 仍然只是“暂时没炸”。

### 2.4 再恢复 `continuation_requalification`

第四步要把继续资格从情绪与惯性里救回：

1. `continue_qualification`
2. `token_budget_ready`
3. `required_preconditions`
4. `rollback_boundary`
5. `requalification_expires_at`

没有这一步，continuation 仍只是“先继续再说”。

### 2.5 再恢复 `handoff_continuity_repair`

第五步要把交接从作者记忆与 prose 拉回正式对象：

1. `resume_lineage_attested`
2. `author_memory_not_required`
3. `continuity_warranty_status`
4. `consumer_readiness_attested`
5. `handoff_continuity_repaired_at`

这一步的目标不是让交接更好读，而是让 later 团队不需要额外脑补。

### 2.6 最后恢复 `threshold_reinstatement`

最后才修未来反对当前 correction 的能力：

1. `truth_break_trigger`
2. `cache_break_threshold`
3. `threshold_retained_until`
4. `reentry_required_when`
5. `reopen_required_when`

不要反过来：

1. 不要先补 reopen 提醒，再修 truth object。
2. 不要先让 handoff 更顺滑，再修 continuation 资格。
3. 不要先让 correction card 更正式，再修 threshold。

## 3. 硬拒收规则

出现下面情况时，应直接升级为硬拒收：

1. `steady_correction_object_missing`
2. `truth_continuity_recovery_failed`
3. `stable_prefix_recustody_missing`
4. `baseline_dormancy_reseal_failed`
5. `continuation_requalification_failed`
6. `handoff_continuity_repair_blocked`
7. `threshold_reinstatement_missing`
8. `truth_recompile_required_or_reopen_required_ignored`

## 4. 模板骨架

### 4.1 correction card 骨架

1. `correction_card_id`
2. `steady_correction_object_id`
3. `restored_request_object_id`
4. `compiled_request_hash`
5. `truth_continuity_recovery_ref`
6. `protocol_transcript_health_ref`
7. `stable_prefix_recustody_ref`
8. `baseline_dormancy_reseal_ref`
9. `lawful_forgetting_boundary`
10. `continuation_requalification_ref`
11. `handoff_continuity_repair_ref`
12. `threshold_reinstatement_ref`
13. `correction_verdict`
14. `verdict_reason`

### 4.2 handoff continuity repair block 骨架

1. `handoff_repair_block_reason`
2. `truth_gap`
3. `protocol_gap`
4. `prefix_gap`
5. `dormancy_gap`
6. `qualification_gap`
7. `lineage_gap`
8. `threshold_gap`
9. `fallback_verdict`

### 4.3 threshold reinstatement ticket 骨架

1. `threshold_reinstatement_id`
2. `truth_break_trigger`
3. `cache_break_threshold`
4. `rollback_boundary`
5. `threshold_retained_until`
6. `reentry_required_when`
7. `reopen_required_when`
8. `residual_risk_scope`

## 5. 苏格拉底式检查清单

在你准备宣布“Prompt steady-state correction execution distortion 已纠偏完成”前，先问自己：

1. 我救回的是同一个 `compiled request truth`，还是一份更会安抚人的 correction 说明。
2. 我现在保护的是 `stable_prefix_recustody`，还是一次暂时没触发 cache break 的好运气。
3. 我现在允许的是 `continuation_requalification`，还是一种“先继续再说”的默认冲动。
4. 我现在交接的是 continuity object，还是一段 later 仍需脑补的 summary。
5. `threshold_reinstatement` 还在不在；如果不在，我是在恢复 correction，还是在删除未来反对当前状态的能力。

## 6. 一句话总结

真正成熟的 Prompt 宿主修复稳态纠偏再纠偏，不是把 correction prose 写得更严谨，而是把假修正卡、口头真相恢复、前缀复托管表演与阈值装饰化重新压回同一个 `compiled request truth`。
