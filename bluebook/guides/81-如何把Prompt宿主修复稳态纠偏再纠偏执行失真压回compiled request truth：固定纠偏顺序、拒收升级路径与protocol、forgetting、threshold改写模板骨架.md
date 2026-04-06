# 如何把 Prompt 宿主修复稳态纠偏再纠偏执行失真压回 message lineage：固定纠偏顺序、拒收升级路径与 protocol / forgetting / threshold 模板骨架

Prompt 再纠偏执行真正要救回的，不是一张更正式的 `recorrection card`，而是同一条 `message lineage` 重新回到可消费、可交接、可继续的对象链：

1. `message lineage`
2. `projection consumer`
3. `protocol transcript`
4. `stable prefix boundary`
5. `continuation object`
6. `continuation qualification`
7. `threshold liability`

`compiled request truth` 在这里最多只保留为旧总称；`recorrection card`、`protocol repair block` 与 `threshold liability ticket` 都只是修复工件，不再是一级主语。

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

Prompt 再纠偏执行真正要拒绝的，不是卡片写得不够正式，而是展示替身重新篡位：

- `recorrection card` 冒充主对象
- UI transcript 冒充 `protocol transcript`
- summary 礼貌感冒充 `lawful forgetting`
- 安静曲线冒充 `stable prefix`
- 默认继续冒充 `continuation qualification`
- 口头 reopen 提醒冒充 `threshold liability`

所以更稳的纠偏目标不是先把叙事说圆，而是：

1. 先冻结假修复信号。
2. 先把 `message lineage` 从 UI 历史、handoff prose 与摘要替身里救出来。
3. 先把 `projection consumer` 的分层重新钉回 display、model API、SDK/control 与 handoff/resume。
4. 先把 `protocol transcript` 从可读历史里救出来。
5. 先把 `lawful forgetting` 从礼貌 summary 里救出来。
6. 先把 `continuation qualification` 与 `threshold liability` 从惯性继续里救出来。

## 2. 固定纠偏顺序

### 2.1 先冻结假 `recorrection card`

第一步不是润色卡片，而是冻结假修复信号：

1. 禁止 `reject_verdict=steady_state_restituted` 在对象复核之前生效。
2. 禁止 UI transcript、summary prose 与 handoff packet 重新充当 Prompt truth proof。
3. 禁止“最近没炸”冒充 `stable prefix reseal`。
4. 禁止“还能继续”冒充 `continuation qualification`。

最小冻结对象：

1. `recorrection_object_id`
2. `truth_lineage_ref`
3. `projection_consumer_surface`
4. `compiled_request_hash_legacy`
5. `false_recorrection_refs_frozen`
6. `reject_verdict`
7. `verdict_reason`

### 2.2 再恢复 `message lineage`

第二步要救回：

1. `truth_lineage_ref`
2. `lineage_kernel_integrity`
3. `restored_request_object_id`
4. `shared_consumer_surface`
5. `truth_continuity_attested`

不要继续做的事：

1. 不要先看 later 团队是否主观觉得“现在我懂了”。
2. 不要先看 steady 一段时间没有新噪音。
3. 不要先看 packet 是否更整洁。

### 2.3 再恢复 `projection consumer` 对齐

第三步要把不同 consumer 的读法重新钉回同一条 lineage：

1. `display_consumer_ref`
2. `model_api_consumer_ref`
3. `sdk_control_consumer_ref`
4. `handoff_resume_consumer_ref`
5. `projection_alignment_attested`

没有这一步，宿主、CI、评审与交接仍会围绕不同真相判断。

### 2.4 再恢复 `protocol transcript`

第四步要把协议真相从 UI 历史与 prose handoff 里救回：

1. `protocol_transcript_health`
2. `tool_pairing_health`
3. `transcript_boundary_attested`
4. `protocol_rewrite_version`
5. `virtual_output_demoted`

只要这一步没修好，再纠偏仍然只是“历史被整理得更可读”。

### 2.5 再恢复 `stable prefix boundary`

第五步要把共享前缀资产从安静曲线与好运气里救回：

1. `stable_prefix_boundary`
2. `prefix_reseal_witness`
3. `cache_break_budget`
4. `cache_break_threshold`
5. `reactivation_trigger_registered`

没有这一步，Prompt 世界仍会退回“目前还能读”的安静叙事。

### 2.6 再恢复 `continuation object` 与 `lawful forgetting`

第六步要把合法遗忘边界从 compact prose 与 summary 礼貌感里救回：

1. `lawful_forgetting_boundary`
2. `preserved_segment_ref`
3. `compaction_lineage`
4. `summary_override_blocked`
5. `continuation_object_ref`
6. `forgetting_reseal_attested`

没有这一步，later 团队继承的仍不是同一个可继续对象。

### 2.7 最后恢复 `continuation qualification` 与 `threshold liability`

最后才修未来反对当前状态的能力：

1. `continuation_qualification`
2. `token_budget_ready`
3. `required_preconditions`
4. `rollback_boundary`
5. `truth_break_trigger`
6. `threshold_retained_until`
7. `reentry_required_when`
8. `reopen_required_when`

不要反过来：

1. 不要先补 reopen 提醒，再修 lineage object。
2. 不要先让 handoff 更顺滑，再修 `protocol transcript`。
3. 不要先让 `recorrection card` 更正式，再修 `threshold liability`。

## 3. 硬拒收规则

出现下面情况时，应直接升级为硬拒收：

1. `recorrection_object_missing`
2. `truth_lineage_ref_missing`
3. `lineage_kernel_integrity_failed`
4. `projection_consumer_split_detected`
5. `protocol_transcript_health_failed`
6. `tool_pairing_health_failed`
7. `stable_prefix_boundary_missing`
8. `lawful_forgetting_boundary_missing`
9. `summary_override_detected`
10. `continuation_qualification_unbound`
11. `token_budget_not_ready_but_continue_allowed`
12. `threshold_liability_missing`
13. `truth_break_trigger_missing`
14. `reopen_required_but_demotion_not_triggered`

## 4. 模板骨架

### 4.1 `recorrection card` 骨架

1. `recorrection_card_id`
2. `recorrection_object_id`
3. `truth_lineage_ref`
4. `lineage_kernel_integrity`
5. `projection_consumer_alignment`
6. `protocol_transcript_repair_ref`
7. `stable_prefix_reseal_ref`
8. `lawful_forgetting_reseal_ref`
9. `continuation_object_ref`
10. `continuation_qualification_ref`
11. `threshold_liability_ref`
12. `reject_verdict`
13. `verdict_reason`

### 4.2 `protocol repair block` 骨架

1. `protocol_repair_block_id`
2. `lineage_gap`
3. `projection_gap`
4. `protocol_gap`
5. `tool_pairing_gap`
6. `prefix_gap`
7. `forgetting_gap`
8. `qualification_gap`
9. `fallback_verdict`

### 4.3 `threshold liability ticket` 骨架

1. `threshold_liability_id`
2. `truth_break_trigger`
3. `cache_break_threshold`
4. `rollback_boundary`
5. `threshold_retained_until`
6. `reentry_required_when`
7. `reopen_required_when`
8. `liability_scope`

## 5. 苏格拉底式检查清单

在你准备宣布“Prompt 再纠偏执行失真已纠偏完成”前，先问自己：

1. 我救回的是同一条 `message lineage`，还是一份更会安抚人的 recorrection 说明。
2. 我现在保护的是 `protocol transcript`，还是一段更顺滑的 UI 历史。
3. 我现在保护的是 `stable prefix boundary` 与 `lawful forgetting boundary`，还是一份更体面的 summary。
4. 我现在允许的是 `continuation qualification`，还是一种“先继续再说”的默认冲动。
5. `threshold liability` 还在不在；如果不在，我是在恢复对象，还是在删除未来反对当前状态的能力。

## 6. 一句话总结

真正成熟的 Prompt 宿主修复稳态纠偏再纠偏执行改写，不是把 transcript 与 summary 写得更顺，而是把假 `recorrection card`、假 `protocol repair`、假 `lawful forgetting reseal` 与假 `threshold liability` 重新压回同一条 `message lineage`。
