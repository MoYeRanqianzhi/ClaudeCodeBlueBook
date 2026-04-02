# 如何把Prompt宿主修复稳态纠偏再纠偏执行失真压回compiled request truth：固定纠偏顺序、拒收升级路径与protocol、forgetting、threshold改写模板骨架

这一章不再解释 Prompt 宿主修复稳态纠偏再纠偏执行最常怎样失真，而是把 Claude Code 式 Prompt 再纠偏改写压成一张可执行的 builder-facing 手册。

它主要回答五个问题：

1. 为什么 Prompt 再纠偏改写真正要救回的不是一张更严谨的 `recorrection card`，而是同一个 `compiled request truth`。
2. 怎样把假 `recorrection card`、假 `protocol repair`、假 `lawful forgetting reseal`、前缀平静表演与假 `threshold liability` 压回固定纠偏顺序。
3. 哪些现象应被直接升级为硬拒收，而不是继续补 transcript、summary 与 handoff prose。
4. 怎样把 `recorrection card`、`protocol repair block` 与 `threshold liability ticket` 重新压回对象级骨架。
5. 怎样用苏格拉底式追问避免把纠偏写成“把再纠偏卡写得更像再纠偏卡”。

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

Prompt 再纠偏改写真正要救回的不是：

- 一张更完整的 `recorrection card`
- 一份更像制度的 `protocol repair note`
- 一套更谨慎的 `re-entry / reopen` 话术

而是：

- 同一个 `compiled request truth` 在 recorrection 执行已经说过一次谎之后，仍能被模型继续消费、被 later 团队继续接手、被系统继续合法重开，而不重新退回 transcript 可读性、summary 礼貌感与默认 continuation

Prompt 的魔力显得像“咒语”，恰恰是因为它先把世界编译成同一个 request object、同一个 protocol transcript、同一个 stable prefix、同一个 lawful forgetting boundary 与同一个 continuation qualification；一旦 recorrection 退回 prose，魔力就会从编译链退回安抚链。

所以更稳的纠偏目标不是：

- 先把 recorrection 叙事说圆

而是：

1. 先把假 `recorrection card` 降回结果信号，而不是让它充当主对象。
2. 先把 `compiled request truth` 从 UI 历史与整理过的对话里救出来。
3. 先把 `protocol transcript` 从可读 handoff 与解释性 prose 里救出来。
4. 先把 `stable prefix` 从安静 cache 曲线与好运气里救出来。
5. 先把 `lawful forgetting boundary` 从礼貌 summary 里救出来。
6. 先把 `continue qualification` 从惯性继续里救出来。
7. 最后才把 `threshold liability` 从经验式 reopen 提醒里救出来。

## 2. 固定纠偏顺序

### 2.1 先冻结假 `recorrection card`

第一步不是润色 `recorrection card`，而是冻结假恢复信号：

1. 禁止 `reject_verdict=steady_state_restituted` 在对象复核之前生效。
2. 禁止“UI transcript 重新连贯”冒充 `protocol transcript repair`。
3. 禁止 compact summary 可读、handoff prose 自洽冒充 `lawful forgetting reseal`。
4. 禁止“最近没炸”冒充 `stable prefix reseal`。

最小冻结对象：

1. `recorrection_object_id`
2. `restored_request_object_id`
3. `compiled_request_hash`
4. `false_recorrection_refs_frozen`
5. `reject_verdict`
6. `verdict_reason`

### 2.2 再恢复 `compiled request truth restitution`

第二步要救回：

1. `truth_continuity_attested`
2. `restored_request_object_id`
3. `compiled_request_hash`
4. `truth_lineage_ref`
5. `protocol_truth_witness`
6. `shared_consumer_surface`

不要继续做的事：

1. 不要先看最终解释是否更顺。
2. 不要先看 later 团队是否主观觉得“现在我懂了”。
3. 不要先看 steady 一段时间没有新噪音。

### 2.3 再恢复 `protocol transcript repair`

第三步要把协议真相从 UI 历史与 prose handoff 里救回：

1. `protocol_transcript_health`
2. `tool_pairing_health`
3. `transcript_boundary_attested`
4. `protocol_rewrite_version`
5. `virtual_output_demoted`

只要这一步没修好，recorrection 仍然只是“历史被整理得更可读”。

### 2.4 再恢复 `stable prefix reseal`

第四步要把共享前缀资产从安静曲线与好运气里救回：

1. `stable_prefix_boundary`
2. `prefix_reseal_witness`
3. `cache_break_budget`
4. `cache_break_threshold`
5. `reactivation_trigger_registered`

没有这一步，Prompt 世界仍会退回“目前还能读”的安静叙事。

### 2.5 再恢复 `lawful forgetting reseal`

第五步要把合法遗忘边界从 compact prose 与 summary 礼貌感里救回：

1. `lawful_forgetting_boundary`
2. `preserved_segment_ref`
3. `compaction_lineage`
4. `summary_override_blocked`
5. `forgetting_reseal_attested`

没有这一步，later 团队继承的仍不是同一个可消费 request truth。

### 2.6 再恢复 `continuation requalification`

第六步要把继续资格从情绪与惯性里救回：

1. `continue_qualification`
2. `token_budget_ready`
3. `required_preconditions`
4. `rollback_boundary`
5. `requalification_rebound_at`

没有这一步，continuation 仍只是“先继续再说”。

### 2.7 最后恢复 `threshold liability reinstatement`

最后才修未来反对当前 recorrection 的能力：

1. `truth_break_trigger`
2. `cache_break_threshold`
3. `threshold_retained_until`
4. `reentry_required_when`
5. `reopen_required_when`
6. `threshold_liability_reinstated_at`

不要反过来：

1. 不要先补 reopen 提醒，再修 truth object。
2. 不要先让 handoff 更顺滑，再修 protocol transcript。
3. 不要先让 `recorrection card` 更正式，再修 `threshold liability`。

## 3. 硬拒收规则

出现下面情况时，应直接升级为硬拒收：

1. `recorrection_object_missing`
2. `compiled_request_truth_unrestituted`
3. `truth_lineage_ref_missing`
4. `protocol_transcript_health_failed`
5. `tool_pairing_health_failed`
6. `transcript_boundary_unattested`
7. `stable_prefix_boundary_missing`
8. `lawful_forgetting_boundary_missing`
9. `summary_override_detected`
10. `continue_qualification_unbound`
11. `token_budget_not_ready_but_continue_allowed`
12. `threshold_liability_missing`
13. `truth_break_trigger_missing`
14. `reopen_required_but_demotion_not_triggered`

## 4. 模板骨架

### 4.1 recorrection card 骨架

1. `recorrection_card_id`
2. `recorrection_object_id`
3. `restored_request_object_id`
4. `compiled_request_hash`
5. `truth_lineage_ref`
6. `truth_continuity_restitution_ref`
7. `protocol_transcript_repair_ref`
8. `stable_prefix_reseal_ref`
9. `lawful_forgetting_reseal_ref`
10. `continue_qualification_ref`
11. `threshold_liability_ref`
12. `reject_verdict`
13. `verdict_reason`

### 4.2 protocol repair block 骨架

1. `protocol_repair_block_id`
2. `truth_gap`
3. `truth_lineage_ref`
4. `protocol_gap`
5. `tool_pairing_gap`
6. `transcript_boundary_attested`
7. `prefix_gap`
8. `forgetting_gap`
9. `summary_override_blocked`
10. `fallback_verdict`

### 4.3 threshold liability ticket 骨架

1. `threshold_liability_id`
2. `truth_break_trigger`
3. `cache_break_threshold`
4. `rollback_boundary`
5. `threshold_retained_until`
6. `reentry_required_when`
7. `reopen_required_when`
8. `liability_scope`

## 5. 苏格拉底式检查清单

在你准备宣布“Prompt steady-state correction-of-correction execution distortion 已纠偏完成”前，先问自己：

1. 我救回的是同一个 `compiled request truth`，还是一份更会安抚人的 recorrection 说明。
2. 我现在保护的是 `protocol transcript`，还是一段更顺滑的 UI 历史。
3. 我现在保护的是 `stable prefix` 与 `lawful forgetting boundary`，还是一份更体面的 summary。
4. 我现在允许的是 `continue qualification`，还是一种“先继续再说”的默认冲动。
5. `threshold liability` 还在不在；如果不在，我是在恢复 recorrection，还是在删除未来反对当前状态的能力。

## 6. 一句话总结

真正成熟的 Prompt 宿主修复稳态纠偏再纠偏改写，不是把 transcript 与 summary 写得更顺，而是把假 `recorrection card`、假 `protocol repair`、假 `lawful forgetting reseal` 与假 `threshold liability` 重新压回同一个 `compiled request truth`。
