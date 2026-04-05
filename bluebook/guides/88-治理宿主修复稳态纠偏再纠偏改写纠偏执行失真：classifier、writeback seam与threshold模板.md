# 如何把治理宿主修复稳态纠偏再纠偏改写纠偏执行失真压回统一定价控制面：固定rewrite correction顺序、classifier、writeback seam与threshold改写模板骨架

这一章不再解释治理宿主修复稳态纠偏再纠偏改写纠偏执行最常怎样失真，而是把 Claude Code 式治理 rewrite-correction execution distortion 压成一张可执行的 builder-facing 手册。

它主要回答五个问题：

1. 为什么治理 rewrite correction execution distortion 真正要救回的不是一套更谨慎的治理流程，而是同一个统一定价控制面。
2. 怎样把假 authority chain、假 classifier pricing、假 writeback seam、免费继续回魂与假 `threshold rebinding` 压回固定 `rewrite correction order`。
3. 哪些现象应被直接升级为硬拒收，而不是继续补 dashboard 注释、运维备注与保守建议。
4. 怎样把 `rewrite correction card`、`classifier pricing block`、`writeback seam block` 与 `liability threshold ticket` 重新压回对象级骨架。
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
- `claude-code-source-code/src/utils/permissions/permissions.ts:526-725`
- `claude-code-source-code/src/utils/permissions/yoloClassifier.ts:1250-1312`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/utils/analyzeContext.ts:1098-1382`
- `claude-code-source-code/src/query/tokenBudget.ts:22-92`
- `claude-code-source-code/src/query.ts:1308-1518`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`

## 1. 第一性原理

治理 rewrite correction execution distortion 真正要救回的不是：

- 更保守的 rewrite correction checklist
- 更细的 capability 托管说明
- 更谨慎的 later 注意事项

而是：

- 无人继续盯防时，同一个治理对象仍在统一定价一切扩张

安全设计回答：

- 什么能继续放开

省 token 设计回答：

- 什么值得继续付费

在 Claude Code 里，这两者不是两套系统，而是同一条：

- `authority -> ledger -> decision window -> pricing -> classifier pricing -> writeback seam -> capability liability -> threshold`

一旦 rewrite correction 退回 mode、dashboard、值班备注与“大家先保守一点”，统一定价控制面就会重新退回交互感受、背景告警与默认继续。

## 2. 固定 rewrite correction 顺序

### 2.1 先冻结假 restored verdict

第一步不是补 rewrite correction 文案，而是：

1. 把 mode、status、dashboard 降回 authority 的投影。
2. 禁止 `reject_verdict=steady_state_restituted` 在对象复核之前生效。
3. 禁止“目前没报错”继续充当 `governance_object` 的替身。

### 2.2 再恢复 `authority chain`

第二步要救回：

1. `authority_source_before`
2. `authority_source_after`
3. `single_truth_chain_ref`
4. `writer_chokepoint`
5. `mode_projection_demoted`
6. `authority_restituted_at`

authority 不稳时，任何后续清账都可能清在错误对象上，只会制造假完成。

### 2.3 再恢复 `ledger reseal`

第三步要修的是：

1. `typed_decision_digest`
2. `permission_ledger_state`
3. `pending_permission_requests`
4. duplicate / orphan / late residue 的正式清账
5. `ledger_resealed_at`
6. `session_state_writeback_ref`

不要把“最近没人再点审批”当成 `ledger reseal`。

### 2.4 再恢复 `decision window`

第四步要把决策窗口从图表与安静感拉回正式对象：

1. `decision_window`
2. `context_usage_snapshot`
3. `reserved_buffer`
4. `deferred_visibility`
5. `api_usage_breakdown`
6. `window_refrozen_at`

usage 回落不是 window truth；它只是 window truth 的投影。

### 2.5 再恢复 `continuation pricing rebinding`

第五步要把继续资格从惯性与乐观情绪里救回：

1. `continuation_gate`
2. `settled_price`
3. `budget_policy_generation`
4. `pricing_rebound_at`
5. `free_continuation_blocked`

### 2.6 再恢复 `classifier pricing attestation`

第六步要把安全系统本身重新拉回被定价对象：

1. `classifier_cost_priced`
2. `classifier_verdict_ref`
3. `classifier_budget_source`
4. `classifier_scope`
5. `classifier_pricing_attested_at`

classifier 本身也必须被纳入价格对象；否则治理控制面会在自我保护时自我膨胀。

### 2.7 再恢复 `writeback seam reseal`

第七步要把正式宿主真相从 UI 状态与感觉里救回：

1. `requires_action_ref`
2. `pending_action_ref`
3. `session_state_changed_ref`
4. `writeback_seam_attested`
5. `late_response_quarantined`

没有这一步，安全与成本共用的宿主真相仍会退回 UI 平静感。

### 2.8 再恢复 `capability liability recustody`

第八步要把责任从运维备注里救回：

1. `capability_release_scope`
2. `custody_owner`
3. `liability_owner`
4. `rollback_object`
5. `recustody_rebound_at`

没有这一步，所谓“更保守”只是一种没有 owner 的运营感觉。

### 2.9 最后恢复 `threshold rebinding`

最后才把 future reopen 的正式能力救回：

1. `authority_drift_trigger`
2. `threshold_retained_until`
3. `reentry_required_when`
4. `reopen_required_when`
5. `threshold_rebound_at`
6. `session_state_changed_attested`

不要反过来：

1. 不要先补 reopen 提醒，再修 authority object。
2. 不要先让 dashboard 转绿，再修 decision window。
3. 不要先让 capability 继续放行，再修 classifier 与 settled price。

## 3. 硬拒收规则

出现下面情况时，应直接升级为硬拒收：

1. `rewrite_correction_session_missing`
2. `authority_source_unexternalized`
3. `mode_projection_as_authority`
4. `permission_ledger_state_unsealed`
5. `pending_action_residue_unresolved`
6. `decision_window_as_dashboard`
7. `context_usage_not_written_back_to_window`
8. `reserved_buffer_unattested`
9. `settled_price_missing`
10. `classifier_cost_unpriced`
11. `writeback_seam_missing`
12. `free_continuation_detected`
13. `capability_liability_unbound`
14. `rollback_object_missing`
15. `threshold_rebinding_missing`
16. `session_state_writeback_missing`

## 4. 模板骨架

### 4.1 rewrite correction card 骨架

1. `rewrite_correction_card_id`
2. `rewrite_correction_session_id`
3. `governance_object_id`
4. `authority_source_after`
5. `single_truth_chain_ref`
6. `typed_decision_digest`
7. `permission_ledger_state`
8. `decision_window`
9. `context_usage_snapshot`
10. `settled_price`
11. `classifier_cost_priced`
12. `writeback_seam_attested`
13. `capability_release_scope`
14. `liability_owner`
15. `threshold_retained_until`
16. `reject_verdict`
17. `verdict_reason`

### 4.2 classifier writeback block 骨架

1. `classifier_writeback_block_id`
2. `authority_gap`
3. `ledger_gap`
4. `window_gap`
5. `pricing_gap`
6. `classifier_gap`
7. `writeback_gap`
8. `liability_gap`
9. `fallback_verdict`

### 4.3 liability threshold ticket 骨架

1. `liability_threshold_id`
2. `capability_release_scope`
3. `rollback_object`
4. `liability_owner`
5. `authority_drift_trigger`
6. `threshold_retained_until`
7. `reentry_required_when`
8. `reopen_required_when`

## 5. 与 `casebooks/59` 的边界

`casebooks/59` 回答的是：

- 为什么治理 rewrite correction execution 明明已经存在，仍会重新退回假 authority chain、假 classifier pricing、假 writeback seam 与假 `threshold rebinding`

这一章回答的是：

- 当这些假对象已经被辨认出来之后，具体该按什么固定 `rewrite correction order` 把它们压回同一个统一定价控制面

也就是说，`casebooks/59` 负责：

- 识别治理控制面怎样被更体面的 rewrite correction 工件替代

而这一章负责：

- 把这些替代信号按 authority、ledger、window、pricing、classifier、writeback、liability 与 threshold 的对象顺序拆掉

## 6. 苏格拉底式检查清单

在你准备宣布“治理 steady-state correction-of-correction rewrite correction execution distortion 已纠偏完成”前，先问自己：

1. 我救回的是同一个治理对象，还是一份更漂亮的治理 rewrite correction 说明。
2. 我现在消费的是 `authority chain`，还是 mode 与 dashboard 的平静感。
3. 我现在消费的是 `decision window + settled price + classifier pricing`，还是一种“应该还能继续”的感觉。
4. 我现在保留的是 `writeback seam + liability + threshold`，还是一句“后面再看”。
5. 一旦 later 团队接手，依赖的是 formal host truth，还是还要继续猜当前状态。

## 7. 一句话总结

真正成熟的治理宿主修复稳态纠偏再纠偏改写纠偏，不是把 mode、dashboard 与说明文案做得更严谨，而是把假 authority chain、假 classifier pricing、假 writeback seam、免费继续回魂与假 `threshold rebinding` 重新压回同一个统一定价控制面。
