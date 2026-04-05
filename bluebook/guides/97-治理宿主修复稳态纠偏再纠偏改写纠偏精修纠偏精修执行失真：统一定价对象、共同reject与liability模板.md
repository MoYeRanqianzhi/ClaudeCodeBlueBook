# 如何把治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行失真压回统一定价控制面：固定refinement correction refinement顺序、统一定价对象、共同reject与liability改写模板骨架

这一章不再解释治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行最常怎样失真，而是把 Claude Code 式治理 refinement correction refinement execution distortion 压成一张可执行的 builder-facing 手册。

它主要回答五个问题：

1. 为什么治理 refinement correction refinement execution distortion 真正要救回的不是一张更严的 cross-consumer `repair card`，而是同一个统一定价控制面。
2. 怎样把假 `repair card`、假共同 `reject` 语义与假 `reopen liability` 压回固定 `refinement correction refinement order`。
3. 哪些现象应被直接升级为共同硬拒收，而不是继续补 calmer dashboard、approval calmness 与默认继续说明。
4. 怎样把 `repair card`、`shared reject rebind block` 与 `long-horizon reopen liability ticket` 重新压回对象级骨架。
5. 怎样用苏格拉底式追问避免把改写写成“把治理值班卡再做严一点”。

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

- 治理 refinement correction refinement execution 真正最容易失真的地方，不在 cross-consumer `repair card` 有没有写出来，而在 authority、ledger、window、pricing、classifier、writeback seam、ingress lineage、threshold 与 liability 是否仍围绕同一个治理对象继续统一定价一切扩张。

## 1. 第一性原理

治理 refinement correction refinement execution distortion 真正要救回的不是：

- 一张更完整的 `repair card`
- 一套更谨慎的共同 reject 口号
- 一份更礼貌的 reopen 备注

而是：

- `authority chain -> ledger truth surface -> window truth surface -> pricing causality surface -> classifier pricing attestation -> writeback seam contract -> ingress_restore_lineage_contract -> shared reject semantics -> long-horizon reopen liability` 仍围绕同一个治理对象正式拒绝未定价扩张

安全设计回答：

- 什么能继续放开

省 token 设计回答：

- 什么值得继续付费

在 Claude Code 里，这两者不是两套系统，而是同一个治理对象的两种投影。

## 2. 固定 refinement correction refinement 顺序

### 2.1 先冻结假 `repair card`

第一步不是润色 repair 文案，而是冻结假修复信号：

1. 把 mode 名字、usage 图表、approval calmness 与 `pending_action` 平静感降回 authority 的投影。
2. 禁止 `reject_verdict=steady_state_chain_resealed` 在对象复核之前生效。
3. 禁止“当前没报错”与“当前没超预算”继续充当治理对象的替身。

最小冻结对象：

1. `repair_card_id`
2. `repair_session_id`
3. `governance_object_id`
4. `authority_source_after`
5. `permission_ledger_state`
6. `decision_window`
7. `settled_price`
8. `reject_verdict`
9. `verdict_reason`

### 2.2 再恢复 `authority chain`

第二步要把主语救回：

1. `governance_object_id`
2. `authority_source_before`
3. `authority_source_after`
4. `single_truth_chain_ref`
5. `authority_chain_attested`

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
4. `api_usage_breakdown`
5. `window_truth_surface_attested`

usage 回落不是 window truth；它只是 window truth 的投影。

### 2.5 再恢复 `pricing causality surface`

第五步要把继续资格从惯性与乐观情绪里救回：

1. `settled_price`
2. `budget_policy_generation`
3. `continuation_gate`
4. `free_continuation_blocked`
5. `pricing_causality_surface_attested`

没有这一步，纠偏仍会把“似乎还能继续”误写成已经定价完成。

### 2.6 再恢复 `classifier pricing attestation`

第六步要把安全系统本身重新拉回被定价对象：

1. `classifier_cost_priced`
2. `classifier_verdict_ref`
3. `classifier_budget_source`
4. `classifier_scope`
5. `classifier_pricing_attested`

classifier 本身也必须被纳入价格对象；否则治理控制面会在自我保护时自我膨胀。

### 2.7 再恢复 `writeback + ingress lineage`

第七步要把正式宿主真相与责任连续性从 UI 状态与感觉里救回：

1. `requires_action_ref`
2. `pending_action_ref`
3. `session_state_changed_ref`
4. `writeback_seam_attested`
5. `session_ingress_head`
6. `adopted_server_uuid`
7. `lineage_round_trip_attested`

没有这一步，安全与成本共用的宿主真相仍会退回 UI calmness。

### 2.8 再恢复 `shared reject semantics`

第八步要把四类消费者的拒收语言重新绑回同一个统一定价对象：

1. `shared_reject_semantics_packet`
2. `consumer_projection_demoted`
3. `host_reject_condition`
4. `ci_reject_condition`
5. `review_reject_condition`
6. `handoff_reject_condition`
7. `shared_reject_semantics_attested`

这一步先回答：

- 宿主、CI、评审与交接到底是不是在围绕同一个 pricing causality 说同一种 reject 语言

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

1. 不要先补 reopen 备注，再修 settled price。
2. 不要先让 dashboard 转绿，再修 decision window 与 classifier。
3. 不要先让 capability 继续放行，再修 writeback seam 与 ingress lineage。

## 3. 共同硬拒收规则

出现下面情况时，应直接升级为共同硬拒收：

1. `repair_session_missing`
2. `authority_chain_unbound`
3. `permission_ledger_state_unsealed`
4. `pending_permission_requests_nonzero`
5. `decision_window_projection_only`
6. `settled_price_missing`
7. `free_continuation_detected`
8. `classifier_cost_unpriced`
9. `writeback_seam_missing`
10. `ingress_restore_lineage_broken`
11. `shared_reject_semantics_split`
12. `threshold_retained_until_missing`

这些现象一旦出现，不要继续：

1. 补 calmer dashboard 注释
2. 补 approval 说明
3. 补“当前看起来还可继续”的建议
4. 补“later 团队可以再保守一点”的备注

## 4. Builder-Facing 改写模板骨架

### 4.1 `governance_repair_card_rebind_block`

```md
- repair_session_id:
- governance_object_id:
- authority_source_after:
- permission_ledger_state:
- decision_window:
- settled_price:
- classifier_cost_priced:
- writeback_seam_attested:
- session_ingress_head:
- threshold_retained_until:
- current_verdict:
- verdict_reason:
```

### 4.2 `governance_shared_reject_rebind_block`

```md
- host_reject_condition:
- ci_reject_condition:
- review_reject_condition:
- handoff_reject_condition:
- consumer_projection_demoted:
- must_block_when:
- may_continue_only_when:
```

### 4.3 `governance_long_horizon_reopen_liability_ticket`

```md
- liability_owner:
- capability_release_scope:
- authority_drift_trigger:
- classifier_cost_priced:
- reentry_required_when:
- reopen_required_when:
- threshold_retained_until:
```

## 5. 苏格拉底式自检

在你准备宣布“治理精修执行失真已经被纠偏”前，先问自己：

1. 我压回的是同一个统一定价对象，还是一份更保守的运营说明。
2. 我修回的是共同 `reject` 语言，还是四类角色终于都“看起来比较谨慎”的共识。
3. 我保留的是 formal reopen 能力，还是默认继续之后的补救愿望。
4. later 团队是否能只凭这些块复算 authority、pricing、writeback 与 threshold。
5. 我现在保护的是 Claude Code 的安全设计与省 token 设计，还是只是在模仿它们更保守的外观。
