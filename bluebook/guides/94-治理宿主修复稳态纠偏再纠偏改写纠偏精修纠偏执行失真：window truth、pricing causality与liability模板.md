# 如何把治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏执行失真压回统一定价控制面：固定refinement correction顺序、window truth、pricing causality与liability改写模板骨架

这一章不再解释治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏执行最常怎样失真，而是把 Claude Code 式治理 refinement correction execution distortion 压成一张可执行的 builder-facing 手册。

它主要回答五个问题：

1. 为什么治理 refinement correction execution distortion 真正要救回的不是一张更严的 `repair card`，而是同一个统一定价控制面。
2. 怎样把假 `repair card`、假 `pricing causality` 与假 `reopen liability` 压回固定 `refinement correction order`。
3. 哪些现象应被直接升级为硬拒收，而不是继续补 dashboard 注释、pending-action 平静感与保守建议。
4. 怎样把 `repair card`、`pricing truth rebind block` 与 `long-horizon reopen liability ticket` 重新压回对象级骨架。
5. 怎样用苏格拉底式追问避免把改写写成“把治理 repair card 再做严一点”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-619`
- `claude-code-source-code/src/utils/permissions/permissions.ts:526-1318`
- `claude-code-source-code/src/utils/permissions/yoloClassifier.ts:1250-1312`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/utils/analyzeContext.ts:1098-1382`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-211`

这些锚点共同说明：

- 治理 refinement correction execution 真正最容易失真的地方，不在 `repair card` 有没有写出来，而在 authority、ledger、window、pricing、classifier 成本、writeback seam、ingress/restore lineage、capability liability 与 threshold 是否仍围绕同一个治理对象继续统一定价一切扩张。

## 1. 第一性原理

治理 refinement correction execution distortion 真正要救回的不是：

- 一张更完整的 `repair card`
- 一套更谨慎的值班顺序
- 一份更礼貌的 reopen 备注

而是：

- `authority chain -> ledger truth surface -> window truth surface -> pricing causality surface -> classifier pricing attestation -> writeback seam contract -> ingress_restore_lineage_contract -> long-horizon reopen liability` 仍围绕同一个治理对象正式拒绝免费扩张

安全设计回答：

- 什么能继续放开

省 token 设计回答：

- 什么值得继续付费

在 Claude Code 里，这两者不是两套系统，而是同一个治理对象的两种投影。

## 2. 固定 refinement correction 顺序

### 2.1 先冻结假 `repair card`

第一步不是润色 repair 文案，而是冻结假修复信号：

1. 把 mode 名字、usage 图表与 pending-action 平静感降回 authority 的投影。
2. 禁止 `reject_verdict=steady_state_chain_resealed` 在对象复核之前生效。
3. 禁止“当前没报错”继续充当治理对象的替身。

最小冻结对象：

1. `repair_card_id`
2. `repair_session_id`
3. `governance_object_id`
4. `authority_source_after`
5. `permission_ledger_state`
6. `decision_window`
7. `reject_verdict`
8. `verdict_reason`

### 2.2 再恢复 `authority chain`

第二步要把主语救回：

1. `governance_object_id`
2. `authority_source_before`
3. `authority_source_after`
4. `single_truth_chain_ref`
5. `writer_chokepoint`
6. `authority_chain_attested`

authority 不稳时，任何后续清账都可能清在错误对象上。

### 2.3 再恢复 `ledger truth surface`

第三步要修的是正式账本真相：

1. `typed_decision_digest`
2. `permission_ledger_state`
3. `pending_permission_requests`
4. `ledger_residue_quarantined`
5. `session_state_writeback_ref`
6. `ledger_truth_surface_attested`

不要把“最近没人再点审批”当成 `ledger reseal`。

### 2.4 再恢复 `window truth surface`

第四步要把决策窗口从图表与安静感拉回正式对象：

1. `decision_window`
2. `context_usage_snapshot`
3. `reserved_buffer`
4. `deferred_visibility`
5. `api_usage_breakdown`
6. `window_truth_surface_attested`

usage 回落不是 window truth；它只是 window truth 的投影。

### 2.5 再恢复 `pricing causality surface`

第五步要把继续资格从惯性与乐观情绪里救回：

1. `settled_price`
2. `budget_policy_generation`
3. `continuation_gate`
4. `free_continuation_blocked`
5. `pricing_causality_surface_attested`

没有这一步，refinement correction 仍会把“似乎还能继续”误写成已经定价完成。

### 2.6 再恢复 `classifier pricing attestation`

第六步要把安全系统本身重新拉回被定价对象：

1. `classifier_cost_priced`
2. `classifier_verdict_ref`
3. `classifier_budget_source`
4. `classifier_scope`
5. `classifier_pricing_attested`

classifier 本身也必须被纳入价格对象；否则治理控制面会在自我保护时自我膨胀。

### 2.7 再恢复 `writeback seam contract`

第七步要把正式宿主真相从 UI 状态与感觉里救回：

1. `requires_action_ref`
2. `pending_action_ref`
3. `session_state_changed_ref`
4. `writeback_seam_attested`
5. `late_response_quarantined`

没有这一步，安全与成本共用的宿主真相仍会退回 UI 平静感。

### 2.8 再恢复 `ingress_restore_lineage_contract`

第八步要把 ingress 与 restore 的连续性重新接回治理对象：

1. `ingress_restore_lineage_ref`
2. `adopted_server_uuid`
3. `restore_epoch_attested`
4. `worker_state_upload_ref`
5. `lineage_round_trip_attested`

没有这一步，system 只是在本地看起来安静，而没有恢复同一条 host-facing 责任链。

### 2.9 最后恢复 `long-horizon reopen liability`

最后才把 future reopen 的正式能力救回：

1. `capability_release_scope`
2. `liability_owner`
3. `authority_drift_trigger`
4. `threshold_retained_until`
5. `reentry_required_when`
6. `reopen_required_when`
7. `long_horizon_reopen_liability_attested`

不要反过来：

1. 不要先补 reopen 提醒，再修 authority object。
2. 不要先让 dashboard 转绿，再修 decision window 与 settled price。
3. 不要先让 capability 继续放行，再修 classifier 与 writeback seam。

## 3. 硬拒收规则

出现下面情况时，应直接升级为硬拒收：

1. `repair_session_missing`
2. `mode_projection_as_authority`
3. `authority_chain_unbound`
4. `permission_ledger_state_unsealed`
5. `pending_permission_requests_nonzero`
6. `decision_window_as_dashboard`
7. `reserved_buffer_unattested`
8. `settled_price_missing`
9. `free_continuation_detected`
10. `classifier_cost_unpriced`
11. `writeback_seam_missing`
12. `session_state_writeback_missing`
13. `ingress_restore_lineage_broken`
14. `adopted_server_uuid_unbound`
15. `capability_liability_unbound`
16. `long_horizon_reopen_liability_missing`
17. `reopen_required_but_card_still_green`

## 4. 模板骨架

### 4.1 repair card 骨架

1. `repair_card_id`
2. `repair_session_id`
3. `governance_object_id`
4. `authority_source_after`
5. `single_truth_chain_ref`
6. `typed_decision_digest`
7. `permission_ledger_state`
8. `decision_window`
9. `settled_price`
10. `classifier_cost_priced`
11. `writeback_seam_attested`
12. `ingress_restore_lineage_ref`
13. `capability_release_scope`
14. `liability_owner`
15. `threshold_retained_until`
16. `reject_verdict`
17. `verdict_reason`

### 4.2 pricing truth rebind block 骨架

1. `pricing_truth_rebind_block_id`
2. `authority_gap`
3. `ledger_gap`
4. `window_gap`
5. `pricing_gap`
6. `classifier_gap`
7. `writeback_gap`
8. `ingress_gap`
9. `liability_gap`
10. `fallback_verdict`

### 4.3 long-horizon reopen liability ticket 骨架

1. `long_horizon_reopen_liability_id`
2. `capability_release_scope`
3. `liability_owner`
4. `authority_drift_trigger`
5. `threshold_retained_until`
6. `reentry_required_when`
7. `reopen_required_when`
8. `rollback_object`

## 5. 为什么这会同时毁掉安全设计与省 token 设计

- Claude Code 的安全设计反对的是未定价的危险扩张。
- Claude Code 的省 token 设计反对的是未定价的低收益扩张。
- `writeback seam + ingress lineage + pricing causality` 同时决定“当前为什么被拦”“当前是否还能继续”与“当前什么时候算真正 turn-over”；一旦这条链丢失，安全与成本就会一起退回猜测状态。

这两者在 refinement correction execution 层会一起失效，因为假 `repair card`、假 `pricing causality` 与假 `reopen liability` 会共同把统一定价控制面退回：

1. mode 是否看起来正常。
2. usage 是否看起来下降。
3. UI 是否看起来平静。
4. later 团队是否愿意先保守一点。

如果一个“可以继续”的判断不能同时写进 `permission ledger`、`decision window` 与 `writeback seam`，那它就只是面板感觉，不是治理对象。

## 6. 与 `casebooks/65` 的边界

`casebooks/65` 回答的是：

- 为什么治理 refinement correction execution 明明已经存在，仍会重新退回假 `repair card`、假 `pricing causality` 与假 `reopen liability`

这一章回答的是：

- 当这些假对象已经被辨认出来之后，具体该按什么固定 `refinement correction order` 把它们压回同一个统一定价控制面

也就是说，`casebooks/65` 负责：

- 识别治理控制面怎样被更体面的 repair 工件替代

而这一章负责：

- 把这些替代信号按 authority、ledger、window、pricing、classifier、writeback、ingress 与 liability 的对象顺序拆掉

## 7. 苏格拉底式检查清单

在你准备宣布“治理 refinement correction execution distortion 已纠偏完成”前，先问自己：

1. 我救回的是同一个治理对象，还是一张更漂亮的 repair card。
2. 我现在消费的是 formal `decision window + settled price`，还是一张 usage dashboard。
3. 我现在恢复的是 `writeback seam + ingress lineage`，还是一种“应该已经写回去了”的感觉。
4. 我现在保留的是 future reopen 的正式 threshold，还是一句“以后有问题再看”。
5. 我现在保护的是统一定价控制面，还是一套更制度化的默认继续。

## 8. 一句话总结

真正成熟的治理 refinement correction execution 纠偏，不是把 repair card 写得更严，而是把 `authority chain + ledger truth surface + window truth surface + pricing causality surface + classifier pricing attestation + writeback seam contract + ingress_restore_lineage_contract + long-horizon reopen liability` 继续拉回同一个统一定价控制面。
