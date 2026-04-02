# 如何把治理宿主修复稳态纠偏再纠偏执行失真压回统一定价控制面：固定纠偏顺序、拒收升级路径与authority、window、liability改写模板骨架

这一章不再解释治理宿主修复稳态纠偏再纠偏执行最常怎样失真，而是把 Claude Code 式治理 recorrection-of-correction 压成一张可执行的 builder-facing 手册。

它主要回答五个问题：

1. 为什么治理再纠偏执行失真真正要救回的不是一套更谨慎的治理流程，而是同一个统一定价控制面。
2. 怎样把假 `authority source`、假 `decision window`、免费继续回魂、假 `capability liability` 与假 `threshold rebinding` 压回固定纠偏顺序。
3. 哪些现象应被直接升级为硬拒收，而不是继续补 dashboard 注释、运维备注与保守建议。
4. 怎样把 `recorrection card`、`decision window rewrite block`、`repricing rewrite block` 与 `liability threshold ticket` 重新压回对象级骨架。
5. 怎样用苏格拉底式追问避免把改写写成“把治理看板再做严格一点”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-619`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:337-348`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1407-1450`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1533-1541`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1735-1747`
- `claude-code-source-code/src/cli/structuredIO.ts:362-657`
- `claude-code-source-code/src/cli/print.ts:1052-1075`
- `claude-code-source-code/src/cli/print.ts:4568-4641`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:84-645`
- `claude-code-source-code/src/utils/permissions/permissions.ts:929-1318`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/utils/analyzeContext.ts:1098-1382`
- `claude-code-source-code/src/query/tokenBudget.ts:22-92`
- `claude-code-source-code/src/query.ts:1308-1518`

## 1. 第一性原理

治理再纠偏执行失真真正要救回的不是：

- 更保守的 recorrection checklist
- 更细的 capability 托管说明
- 更谨慎的 later 注意事项

而是：

- 无人继续盯防时，同一个治理对象仍在统一定价一切扩张

安全设计回答：

- 什么能继续放开

省 token 设计回答：

- 什么值得继续付费

在 Claude Code 里，这两者不是两套系统，而是同一条：

- `authority -> ledger -> decision window -> pricing -> capability liability -> threshold`

一旦 recorrection 退回 mode、dashboard、值班备注与“大家先保守一点”，统一定价控制面就会重新退回交互感受、背景告警与默认继续。

## 2. 固定纠偏顺序

### 2.1 先冻结假 restored verdict

第一步不是补 recorrection 文案，而是：

1. 把 mode、status、dashboard 降回 authority 的投影。
2. 禁止 `reject_verdict=steady_state_restituted` 在对象复核之前生效。
3. 禁止“目前没报错”继续充当 `governance_object` 的替身。

### 2.2 再恢复 `authority source`

第二步要救回：

1. `authority_source_before`
2. `authority_source_after`
3. `writer_chokepoint`
4. `mode_projection_demoted`
5. `authority_restituted_at`

authority 不稳时，任何后续清账都可能清在错误对象上，只会制造假完成。

### 2.3 再恢复 `ledger reseal`

第三步要修的是：

1. `typed_decision_digest`
2. `permission_ledger_state`
3. `pending_permission_requests`
4. duplicate / orphan / late residue 的正式清账
5. `ledger_resealed_at`

不要把“最近没人再点审批”当成 `ledger reseal`。

### 2.4 再恢复 `decision window`

第四步要把决策窗口从图表与安静感拉回正式对象：

1. `decision_window`
2. `context_usage_snapshot`
3. `reserved_buffer`
4. `deferred_visibility`
5. `late_response_quarantined`
6. `window_refrozen_at`

usage 回落、compact 执行或图表转绿都不能替代 `decision window refreeze`。

### 2.5 再恢复 `continuation pricing`

第五步要把继续从默认行为拉回正式定价：

1. `continuation_gate`
2. `budget_policy_generation`
3. `settled_price`
4. `repricing_expires_at`
5. `free_continuation_blocked`

没有这一步，继续就会重新免费。

### 2.6 再恢复 `capability liability`

第六步要把 capability 从运维备注拉回正式责任托管：

1. `capability_release_scope`
2. `rollback_object`
3. `custody_owner`
4. `liability_owner`
5. `quarantine_recall_handle`

这一步的目标不是更保守，而是让 later 团队继承的不是一条免责时间线。

### 2.7 最后恢复 `threshold rebinding`

最后才修未来重新反对当前 recorrection 的责任：

1. `authority_drift_trigger`
2. `threshold_retained_until`
3. `reentry_required_when`
4. `reopen_required_when`
5. `residual_risk_digest`

不要反过来：

1. 不要先放 capability，再补 threshold。
2. 不要先让 usage 图更平，再修 authority。
3. 不要先把 `recorrection card` 写完整，再修 pricing covenant。

## 3. 硬拒收规则

出现下面情况时，应直接升级为硬拒收：

1. `recorrection_object_missing`
2. `authority_source_missing_or_projected_by_mode`
3. `ledger_reseal_required`
4. `window_truth_missing`
5. `context_usage_not_written_back_to_window`
6. `free_continuation_detected`
7. `capability_liability_unbound`
8. `threshold_rebinding_missing`
9. `liability_owner_missing`

## 4. 模板骨架

### 4.1 recorrection card 骨架

1. `recorrection_card_id`
2. `governance_object_id`
3. `authority_source_ref`
4. `ledger_reseal_ref`
5. `decision_window_refreeze_ref`
6. `continuation_pricing_ref`
7. `capability_liability_ref`
8. `threshold_rebinding_ref`
9. `reject_verdict`
10. `verdict_reason`
11. `evaluated_at`

### 4.2 decision window rewrite block 骨架

1. `window_rewrite_block_id`
2. `decision_window`
3. `context_usage_snapshot`
4. `reserved_buffer`
5. `deferred_visibility`
6. `late_response_quarantined`
7. `fallback_verdict`

### 4.3 repricing rewrite block 骨架

1. `repricing_block_id`
2. `continuation_gate`
3. `budget_policy_generation`
4. `settled_price`
5. `free_continuation_blocked`
6. `repricing_expires_at`
7. `repricing_action`

### 4.4 liability threshold ticket 骨架

1. `liability_threshold_id`
2. `capability_release_scope`
3. `rollback_object`
4. `custody_owner`
5. `liability_owner`
6. `authority_drift_trigger`
7. `residual_risk_digest`
8. `threshold_retained_until`
9. `reentry_required_when`
10. `reopen_required_when`

## 5. 苏格拉底式检查清单

在你准备宣布“治理宿主修复稳态纠偏再纠偏执行失真已改写完成”前，先问自己：

1. 我现在救回的是治理对象，还是更严格的 recorrection 流程。
2. 我现在消费的是 `authority source`，还是 mode 面板给我的安全感。
3. 我现在冻结的是 formal `decision window`，还是一张 usage dashboard。
4. 我现在重新定价的是未来继续，还是把默认继续换了个更体面的名字。
5. 我现在保留的是 `capability liability + threshold rebinding`，还是把责任礼貌地外包给 later。

## 6. 一句话总结

真正成熟的治理宿主修复稳态纠偏再纠偏改写，不是把 recorrection 看板写得更严谨，而是把假 `authority source`、假 `decision window`、免费继续回魂、假 `capability liability` 与假 `threshold rebinding` 重新压回同一个统一定价控制面。
