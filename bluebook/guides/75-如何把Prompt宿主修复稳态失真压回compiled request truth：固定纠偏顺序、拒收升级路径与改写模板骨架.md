# 如何把Prompt宿主修复稳态失真压回compiled request truth：固定纠偏顺序、拒收升级路径与改写模板骨架

这一章不再解释 Prompt 宿主修复稳态执行最常怎样失真，而是把 Claude Code 式 Prompt steady-state correction 压成一张可执行的 builder-facing 手册。

它主要回答五个问题：

1. 为什么 Prompt steady-state correction 真正要救回的不是一套更严谨的 steady-state 流程，而是同一个 `compiled request truth` 在无人继续盯防时仍可继续成立。
2. 怎样把假稳态、前缀托管表演与无阈值继续压回固定纠偏顺序。
3. 哪些现象应被直接升级为硬拒收，而不是继续补 steady-state 文案。
4. 怎样把 steady-state card、handoff continuity 与 reopen threshold 重新压回对象级骨架。
5. 怎样用苏格拉底式追问避免把纠偏写成“补一份更好的 steady-state note”。

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

Prompt steady-state correction 真正要救回的不是：

- 一张更完整的 `steady-state card`
- 一份更像制度的 `handoff continuity note`
- 一套更谨慎的 `re-entry` 话术

而是：

- 同一个 `compiled request truth` 在无人继续盯防时，仍能被模型继续消费、被 later 团队继续接手、被系统继续合法重开，而不重新退回作者解释、summary 平静感与默认 continuation

所以更稳的纠偏目标不是：

- 先把 steady-state 叙事说圆

而是：

1. 先把 `steady_verdict` 从“最近没出事”里救出来。
2. 先把 `truth_continuity` 从 summary 与平静感里救出来。
3. 先把 `stable_prefix_custody` 与 `baseline_dormancy_seal` 从好运气、临时 cache 平静与 prose handoff 里救出来。
4. 先把 `continuation_eligibility` 与 `handoff_continuity_warranty` 从经验式继续里救出来。
5. 先把 `reopen_threshold` 从提醒语气与以后再说里救出来。

Prompt 的魔力之所以显得像“咒语”，恰恰是因为它先把世界编译成同一个 request object、同一个 prefix asset 与同一个 continuation object；一旦 steady-state 退回 calmness，魔力就会从编译链退回叙事链。

## 2. 固定纠偏顺序

### 2.1 先冻结假 steady

第一步不是润色 steady-state card，而是冻结假稳态信号：

1. 禁止 `steady_verdict=steady_state` 在对象复核之前生效。
2. 禁止“最近没新异常”冒充 `truth_continuity`。
3. 禁止 compact summary 可读、handoff prose 自洽冒充 prefix continuity。

最小恢复对象：

1. `steady_state_object_id`
2. `restored_request_object_id`
3. `compiled_request_hash`
4. `steady_verdict`
5. `verdict_reason`

### 2.2 再恢复 `truth_continuity`

第二步要救回：

1. `truth_continuity`
2. `restored_request_object_id`
3. `compiled_request_hash`
4. `protocol_truth_witness`
5. `truth_break_trigger`

不要继续做的事：

1. 不要先看 steady 一段时间没有新噪音。
2. 不要先看最后一次 summary 写得是否完整。
3. 不要先看 later 团队是否主观觉得“现在应该还能继续”。

### 2.3 再恢复 `stable_prefix_custody` 与 `baseline_dormancy_seal`

第三步要把前缀资产与稳态静默从好运气里救回：

1. `stable_prefix_custody`
2. `stable_prefix_boundary`
3. `compaction_lineage`
4. `baseline_dormancy_seal`
5. `dormancy_started_at`

只要这一步没修好，steady 仍然只是“暂时没炸”。

### 2.4 再恢复 `continuation_eligibility`

第四步要把继续资格从情绪与惯性里救回：

1. `continuation_eligibility`
2. `continue_qualification`
3. `token_budget_ready`
4. `rollback_boundary`
5. `required_preconditions`

没有这一步，continuation 仍只是“先继续再说”。

### 2.5 再恢复 `handoff_continuity_warranty`

第五步要把交接从作者记忆与 prose 拉回正式对象：

1. `handoff_continuity_warranty`
2. `resume_lineage_attested`
3. `summary_carry_forward_attested`
4. `author_memory_not_required`
5. `continuation_object_attested`

这一步的目标不是让交接更好读，而是让 later 团队不需要额外脑补。

### 2.6 最后恢复 `reopen_threshold`

最后才修未来反对当前 steady 的能力：

1. `reopen_threshold`
2. `truth_break_trigger`
3. `cache_break_threshold`
4. `threshold_retained_until`
5. `reentry_required_when`

不要反过来：

1. 不要先补 reopen 提醒，再修 truth object。
2. 不要先让 handoff 更顺滑，再修 continuation 资格。
3. 不要先让 steady-state card 更正式，再修 threshold。

## 3. 硬拒收规则

出现下面情况时，应直接升级为硬拒收：

1. `truth_continuity_missing`
2. `stable_prefix_custody_missing`
3. `baseline_dormancy_unsealed`
4. `continuation_eligibility_expired`
5. `handoff_continuity_blocked`
6. `reopen_threshold_missing`
7. `steady_verdict_early_promoted`
8. `truth_recompile_required_or_reopen_required_ignored`

## 4. 模板骨架

### 4.1 steady-state card 骨架

1. `steady_state_card_id`
2. `steady_state_object_id`
3. `restored_request_object_id`
4. `compiled_request_hash`
5. `truth_continuity`
6. `stable_prefix_custody`
7. `baseline_dormancy_seal`
8. `continuation_eligibility`
9. `handoff_continuity_warranty`
10. `reopen_threshold`
11. `steady_verdict`
12. `verdict_reason`

### 4.2 handoff continuity block 骨架

1. `handoff_continuity_block_reason`
2. `truth_gap`
3. `prefix_gap`
4. `dormancy_gap`
5. `eligibility_gap`
6. `lineage_gap`
7. `threshold_gap`
8. `fallback_verdict`

### 4.3 reopen threshold ticket 骨架

1. `reopen_threshold_id`
2. `truth_break_trigger`
3. `cache_break_threshold`
4. `rollback_boundary`
5. `threshold_retained_until`
6. `reentry_required_when`
7. `residual_risk_scope`

## 5. 苏格拉底式检查清单

在你准备宣布“Prompt steady-state distortion 已纠偏完成”前，先问自己：

1. 我救回的是同一个 `compiled request truth`，还是一份更会安抚人的 steady 说明。
2. 我现在保护的是 `stable_prefix_custody`，还是一次暂时没触发 cache break 的好运气。
3. 我现在允许的是 `continuation_eligibility`，还是一种“先继续再说”的默认冲动。
4. 我现在交接的是 continuity object，还是一段 later 仍需脑补的 summary。
5. `reopen_threshold` 还在不在；如果不在，我是在恢复稳态，还是在删除未来反对当前状态的能力。

## 6. 一句话总结

真正成熟的 Prompt 宿主修复稳态纠偏，不是把 steady-state 文案写得更严谨，而是把假稳态、前缀托管表演与无阈值继续重新压回同一个 `compiled request truth`。
