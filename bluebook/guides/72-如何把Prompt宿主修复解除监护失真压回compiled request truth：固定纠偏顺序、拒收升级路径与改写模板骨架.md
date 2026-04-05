# 如何把Prompt宿主修复解除监护失真压回compiled request truth：固定纠偏顺序、拒收升级路径与改写模板骨架

这一章不再解释 Prompt 宿主修复解除监护执行最常怎样失真，而是把 Claude Code 式 Prompt release correction 压成一张可执行的 builder-facing 手册。

它主要回答五个问题：

1. 为什么 Prompt release correction 真正要救回的不是一套更严谨的 release 流程，而是同一个 `compiled request truth` 在 released 之后仍可无监护继续成立。
2. 怎样把静默放行、叙事放行与无责任 release 压回固定纠偏顺序。
3. 哪些现象应被直接升级为硬拒收，而不是继续补 release 文案。
4. 怎样把 release card、handoff release 与 residual reopen 重新压回对象级骨架。
5. 怎样用苏格拉底式追问避免把纠偏写成“补一份更好的 release note”。

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
- `claude-code-source-code/src/query/stopHooks.ts:257-331`
- `claude-code-source-code/src/query.ts:1258-1518`

## 1. 第一性原理

Prompt release correction 真正要救回的不是：

- 一张更完整的 `release card`
- 一份更谨慎的 `handoff release note`
- 一套更像治理的 release 审批流程

而是：

- 同一个 `compiled request truth` 在失去额外 watch 之后，仍能被 later 团队继续消费、继续判断、继续行动，而不重新退回作者解释、watch note 或 closeout 叙事

所以更稳的纠偏目标不是：

- 先把 release 叙事说圆

而是：

1. 先把 `release_verdict` 从静默放行与“最近没出事”里救出来。
2. 先把 `watch_release_object` 与 `stability_witness` 从值班气氛里救出来。
3. 先把 `baseline_drift_ledger_seal` 从 summary 与 handoff prose 里救出来。
4. 先把 `continuation_clearance` 与 `handoff_release_warranty` 从经验式接手里救出来。
5. 先把 `reopen_residual_gate` 从提醒语气与以后再说里救出来。

## 2. 固定纠偏顺序

### 2.1 先冻结假 released

第一步不是润色 release note，而是冻结假释放信号：

1. 禁止 `release_verdict=released` 在对象复核之前生效。
2. 禁止 `stable_under_watch` 冒充 `released`。
3. 禁止 handoff 已放行但 `continuation_clearance` 仍未成立。

最小恢复对象：

1. `watch_release_object`
2. `restored_request_object_id`
3. `compiled_request_hash`
4. `watch_window_id`
5. `release_verdict`

### 2.2 再恢复稳定 witness 与 sealed ledger

第二步要救回：

1. `stability_witness`
2. `baseline_drift_ledger_seal`
3. `protocol_truth_witness`
4. `lawful_forgetting_witness`
5. `baseline_reset_witness`

不要继续做的事：

1. 不要先看 watch 期很平静。
2. 不要先看 note 写得很完整。
3. 不要先看 later 团队表示“已经懂了”。

### 2.3 再恢复 continuation clearance

第三步要把“可以继续”从叙事与经验里救回：

1. `continuation_clearance`
2. `required_preconditions`
3. `pending_action_ref`
4. `session_state_ready`
5. `retryable_scope`

这一步不恢复，release 之后的 continuation 仍只是“大家觉得差不多可以继续”。

### 2.4 再恢复 handoff release

第四步要把交接从 release 文本拉回正式对象：

1. `handoff_release_warranty`
2. `consumer_readiness_handoff`
3. `continuation_object_attested`
4. `release_handoff_package`
5. `narrative_override_blocked`

这一步的目标不是更好交接，而是让交接不再依赖额外监护。

### 2.5 最后恢复 residual reopen gate

最后才修 residual risk：

1. `reopen_residual_gate`
2. `rollback_boundary`
3. `gate_expires_at`
4. `residual_trigger`
5. `release_reason`

不要反过来：

1. 不要先补 reopen 说明，再修 release object。
2. 不要先让 release 更顺滑，再修 residual gate。
3. 不要先让 handoff 文本更完整，再修 clearance。

## 3. 硬拒收规则

出现下面情况时，应直接升级为硬拒收：

1. `release_object_missing`
2. `stability_witness_missing`
3. `baseline_ledger_unsealed`
4. `continuation_not_cleared`
5. `handoff_release_blocked`
6. `residual_gate_missing`
7. `narrative_release_detected`
8. `reopen_required`

## 4. 模板骨架

### 4.1 release card 骨架

1. `release_card_id`
2. `watch_release_object`
3. `restored_request_object_id`
4. `compiled_request_hash`
5. `stability_witness`
6. `baseline_drift_ledger_seal`
7. `continuation_clearance`
8. `handoff_release_warranty`
9. `reopen_residual_gate`
10. `release_verdict`

### 4.2 handoff release block 骨架

1. `handoff_release_reason`
2. `object_gap`
3. `witness_gap`
4. `ledger_gap`
5. `clearance_gap`
6. `residual_gate_gap`
7. `fallback_verdict`

### 4.3 residual reopen ticket 骨架

1. `reopen_residual_gate`
2. `residual_trigger`
3. `rollback_boundary`
4. `gate_expires_at`
5. `re_entry_warranty`
6. `residual_risk_scope`

## 5. 苏格拉底式检查清单

在你准备宣布“Prompt release distortion 已纠偏完成”前，先问自己：

1. 我救回的是 `compiled request truth`，还是一份更像正式文件的 release note。
2. 我现在保护的是 stability witness，还是一段时间的平静感。
3. 我现在放行的是 continuation object，还是一段更好读的 summary。
4. handoff release 释放的是对象，还是故事。
5. residual reopen gate 还在不在，如果不在，我是在 release，还是在删风险痕迹。

## 6. 一句话总结

真正成熟的 Prompt 宿主修复解除监护纠偏，不是把 release 做得更严谨，而是把静默放行、叙事放行与无责任 release 重新压回同一个 `compiled request truth`。
