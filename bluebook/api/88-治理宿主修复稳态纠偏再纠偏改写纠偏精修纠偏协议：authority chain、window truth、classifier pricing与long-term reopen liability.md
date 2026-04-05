# 治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏协议：authority chain、window truth、classifier pricing、writeback seam 与 long-term reopen liability

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象，让宿主、CI、评审与交接在治理 refinement correction 已被固定之后，继续消费同一个统一定价控制面，而不是退回更保守的值班说明。
2. 哪些字段属于必须共享的修正对象，哪些属于 `hard_reject / reentry / reopen` 语义，哪些仍不应被绑定成公共 ABI。
3. 为什么 Claude Code 的安全设计与省 token 设计本质上是同一条 `authority -> ledger -> window -> pricing -> classifier -> writeback seam -> liability -> threshold` 控制链，而不是两套并行主题。
4. 宿主开发者该按什么顺序消费这套治理 refinement correction 协议。
5. 哪些现象一旦出现，应被直接升级为 `hard_reject`、`ledger_reseal_required`、`writeback_reseal_required`、`reentry_required` 或 `reopen_required`，而不是继续宣称 capability 仍然安全。

## 0. 关键源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-619`
- `claude-code-source-code/src/utils/permissions/permissions.ts:526-1318`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/utils/analyzeContext.ts:1098-1382`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-211`

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `GovernanceRefinementCorrectionContract`

的单独公共对象。

但治理 refinement correction 已经能围绕十类正式对象稳定成立：

1. `reprotocol_session_object`
2. `authority_chain_attestation`
3. `ledger_truth_surface`
4. `window_truth_surface`
5. `pricing_causality_surface`
6. `classifier_pricing_attestation`
7. `writeback_seam_contract`
8. `ingress_restore_lineage_contract`
9. `reject_semantics_packet`
10. `long_horizon_reopen_liability`

更成熟的治理 refinement correction 方式不是：

- 只看 mode 面板重新平静
- 只看 usage 图表重新转绿
- 只看 later 团队愿意再保守一点

而是：

- 围绕这十类对象继续消费同一个 authority、同一个 ledger、同一个 window truth、同一条 pricing causality、同一个 classifier 成本、同一条 writeback seam、同一个 ingress/restore lineage 与同一个 threshold liability

## 2. 第一性原理

治理世界真正成熟，不是把“更保守一点”写得更体面，而是：

1. `authority` 决定谁有资格定义扩张。
2. `ledger` 决定哪些决策已被正式记账。
3. `window` 决定当前还能承受什么上下文与动作。
4. `pricing` 决定继续的代价是否已被显式结算。
5. `classifier` 本身也必须被纳入 continuation pricing，而不是免费旁路。
6. `writeback seam` 决定安全与成本判断是否已被写回宿主真相。
7. `ingress / restore lineage` 决定 later 团队回到的是不是同一条责任链。
8. `liability + threshold` 决定未来何时必须回跳、重入或 reopen。

所以安全设计与省 token 设计不是两套平行主题，而是同一条拒绝免费扩张的控制链。

## 3. 会话、authority 与 ledger 真相

治理宿主应至少围绕下面对象消费 refinement correction 真相：

### 3.1 reprotocol session object

1. `reprotocol_session_id`
2. `refinement_session_id`
3. `governance_object_id`
4. `reprotocol_generation`
5. `shared_consumer_surface`
6. `reprotocol_started_at`

### 3.2 authority chain attestation

1. `authority_source_before`
2. `authority_source_after`
3. `single_truth_chain_ref`
4. `mode_projection_demoted`
5. `dashboard_projection_demoted`
6. `permission_mode_external`
7. `authority_restituted_at`

### 3.3 ledger truth surface

1. `typed_decision_digest`
2. `permission_ledger_state`
3. `pending_permission_requests`
4. `orphan_permission_cleared`
5. `late_response_quarantined`
6. `ledger_resealed_at`

这些字段回答的不是：

- 当前治理说明是不是更严格了

而是：

- 当前到底先降级了哪些假 authority 投影，并把哪一条正式责任账本重新交还给 later 消费者

## 4. window、pricing 与 classifier 成本托管

治理宿主还必须显式消费：

### 4.1 window truth surface

1. `decision_window`
2. `context_usage_snapshot`
3. `reserved_buffer`
4. `api_usage_breakdown`
5. `pending_action_state`
6. `deferred_visibility`
7. `window_refrozen_at`

### 4.2 pricing causality surface

1. `settled_price`
2. `budget_policy_generation`
3. `continuation_gate`
4. `free_continuation_blocked`
5. `cache_break_reason`
6. `cache_read_delta`
7. `compaction_baseline_reset`

### 4.3 classifier pricing attestation

1. `classifier_cost_priced`
2. `classifier_verdict_ref`
3. `classifier_budget_source`
4. `classifier_scope`
5. `classifier_input_tokens`
6. `classifier_cost_usd`
7. `priced_at`

这里最重要的是：

- `decision window` 不是 usage 图表
- `settled price` 不是“感觉还能继续”
- classifier 也不是“免费的安全感”

## 5. writeback seam 与 ingress/restore lineage

治理宿主还必须显式消费：

### 5.1 writeback seam contract

1. `requires_action_ref`
2. `pending_action_ref`
3. `session_state_changed_ref`
4. `writeback_seam_attested`
5. `host_ack_ref`
6. `worker_patch_generation`
7. `late_response_quarantined`

### 5.2 ingress restore lineage contract

1. `session_ingress_head`
2. `adopted_server_uuid`
3. `ingress_conflict_policy`
4. `resume_session_id`
5. `content_replacement_seeded`
6. `context_collapse_restored`
7. `restore_lineage_attested`

这里最重要的是：

- `requires_action -> pending_action -> session_state_changed` 不是 UI 小状态，而是安全与成本共用的宿主真相缝
- `ingress / restore` 也不是恢复成功率，而是 later 团队能否沿同一条责任链重新进入

## 6. reject 语义与长期 reopen 责任面

治理宿主还必须显式消费：

### 6.1 reject semantics packet

1. `hard_reject`
2. `ledger_reseal_required`
3. `writeback_reseal_required`
4. `reentry_required`
5. `reopen_required`
6. `authority_chain_broken`
7. `authority_source_unexternalized`
8. `pending_permission_requests_nonzero`
9. `pending_action_residue_unresolved`
10. `window_truth_missing`
11. `pricing_cause_unexplained`
12. `classifier_cost_unpriced`
13. `writeback_seam_missing`
14. `ingress_conflict_unresolved`
15. `capability_liability_unbound`
16. `threshold_rebinding_missing`

### 6.2 long horizon reopen liability

1. `capability_release_scope`
2. `rollback_object`
3. `custody_owner`
4. `liability_owner`
5. `authority_drift_trigger`
6. `threshold_retained_until`
7. `reentry_required_when`
8. `reopen_required_when`
9. `reopen_liability_class`

这里最重要的是：

- `rollback_object` 必须先于 reopen 语义存在
- `threshold_retained_until` 不能在“当前转绿”时被默默删除
- `reentry_required_when` 与 `reopen_required_when` 必须被正式区分

## 7. 不应直接绑定成公共 ABI 的内容

宿主不应直接把下面内容绑成长期契约：

1. runtime internal mode 名称
2. dashboard 颜色
3. token 百分比单值
4. approval 弹窗 UI 状态
5. 单次告警截图
6. “目前没报错”的值班感觉
7. `enqueue()` 本地成功的安慰感

它们可以是线索，但不能是治理 refinement correction 协议对象。

## 8. 消费顺序建议

更稳的顺序是：

1. 先验 `reprotocol_session_object`
2. 再验 `authority_chain_attestation`
3. 再验 `ledger_truth_surface`
4. 再验 `window_truth_surface`
5. 再验 `pricing_causality_surface`
6. 再验 `classifier_pricing_attestation`
7. 再验 `writeback_seam_contract`
8. 再验 `ingress_restore_lineage_contract`
9. 再验 `reject_semantics_packet`
10. 最后验 `long_horizon_reopen_liability`

不要反过来做：

1. 不要先让 mode 更平静，再修 authority chain。
2. 不要先让 usage 图表更好看，再修 pricing causality。
3. 不要先让 UI 小状态消失，再修 writeback seam。
4. 不要先让 later 团队放心，再修 liability 与 threshold。

## 9. 苏格拉底式检查清单

在你准备宣布“治理 refinement correction 已经成立”前，先问自己：

1. 我恢复的是 authority chain，还是一种更克制的面板感觉。
2. 我消费的是正式 ledger，还是一次值班经验总结。
3. 我结算的是 continuation price，还是“这次大概还能撑住”的直觉。
4. 我写回的是宿主真相缝，还是让 UI 假装已经 round-trip 完成。
5. 我保留的是 future reopen 的正式条件，还是一句“以后有问题再看”。
