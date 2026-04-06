# 治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修协议：governance key、continuation pricing、writeback seam与long-term reopen liability

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象，让宿主、CI、评审与交接在治理 refinement correction fixed order 已被钉死之后，继续消费同一个 `governance key -> typed ask ledger -> decision window -> continuation pricing` repair truth，而不是退回更保守的值班说明。
2. 哪些字段属于必须共享的 repair 对象，哪些属于共同 `hard_reject / reentry / reopen` 语义，哪些仍不应被绑定成公共 ABI。
3. 为什么 Claude Code 的安全设计与省 token 设计本质上是同一条 `governance key -> typed ask ledger -> decision window -> continuation pricing -> writeback seam -> long-horizon reopen liability` repair 协议，而不是两套并行主题。
4. 宿主开发者该按什么顺序消费这套治理 refinement correction 精修协议。
5. 哪些现象一旦出现，应被直接升级为 `hard_reject`、`pricing_reseal_required`、`writeback_reseal_required`、`repair_attestation_rebuild_required`、`reentry_required` 或 `reopen_required`，而不是继续宣称 capability 仍然安全。

## 0. 关键源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-619`
- `claude-code-source-code/src/utils/permissions/permissions.ts:526-1318`
- `claude-code-source-code/src/utils/permissions/yoloClassifier.ts:1250-1312`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/utils/analyzeContext.ts:1098-1382`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-211`

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `GovernanceRefinementCorrectionRepairProtocol`

的单独公共对象。

但治理 refinement correction fixed order 已经能围绕八类正式对象稳定成立：

1. `repair_session_object`
2. `governance_key_attestation`
3. `typed_ask_ledger_window_surface`
4. `pricing_causality_surface`
5. `classifier_writeback_attestation`
6. `ingress_restore_repair_attestation`
7. `shared_reject_semantics_packet`
8. `long_horizon_reopen_liability`

更成熟的治理 refinement correction 方式不是：

- 只看 mode 面板重新平静
- 只看 usage 图表重新转绿
- 只看 later 团队愿意再保守一点

而是：

- 围绕这八类对象继续消费同一个 governance key、同一份 typed ask ledger/window truth、同一条 continuation pricing causality、同一个 classifier/writeback attestation、同一个 ingress/restore repair attestation 与同一个 threshold liability

从宿主视角看，当前实现其实已经有一个“半成型”的 repair 对象面：

1. `control_request.can_use_tool` 暴露最小权限请求字段
2. `external_metadata.pending_action` 暴露更完整、可前端直接消费的阻塞对象
3. `get_context_usage` 暴露 window truth
4. classifier telemetry 暴露价格与拒收原因
5. `sessionIngress + WorkerStateUploader` 暴露 lineage 与 writeback seam

`api/91` 的真正增量不是再加一个零散字段，而是把这五条通道收束成单一 `repair_object`。

## 2. 第一性原理

治理世界真正成熟，不是把“更保守一点”写得更体面，而是：

1. `governance key` 决定谁有资格定义扩张。
2. `typed ask ledger + decision window` 决定哪些决策已被正式记账、当前还能承受什么上下文与动作。
3. `continuation pricing` 决定继续的代价是否已被显式结算。
4. `classifier` 本身也必须被纳入 continuation pricing，而不是免费旁路。
5. `writeback seam` 决定安全与成本判断是否已被写回宿主真相。
6. `ingress / restore lineage` 决定 later 团队回到的是不是同一条责任链。
7. `liability + threshold` 决定未来何时必须回跳、重入或 reopen。

所以安全设计与省 token 设计不是两套平行主题，而是同一条拒绝免费扩张的 repair 协议。

## 3. repair session object 与 governance key attestation

治理宿主应至少围绕下面对象消费 refinement correction 真相：

### 3.1 repair session object

1. `repair_session_id`
2. `reprotocol_session_id`
3. `refinement_session_id`
4. `governance_object_id`
5. `repair_generation`
6. `shared_consumer_surface`
7. `repair_started_at`

### 3.2 governance key attestation

1. `authority_source_before`
2. `authority_source_after`
3. `single_truth_chain_ref`
4. `permission_mode_external`
5. `mode_projection_demoted`
6. `dashboard_projection_demoted`
7. `authority_restituted_at`

这些字段回答的不是：

- 当前治理说明是不是更严格了

而是：

- 当前到底先降级了哪些假 authority 投影，并把哪一条正式责任链重新交还给 later 消费者

## 4. ledger/window truth 与 pricing causality surface

治理宿主还必须显式消费，并按固定顺序 `lineage -> permission -> classifier -> window -> pricing -> budget -> directive -> writeback` 组织 repair 对象：

### 4.1 ledger window truth surface

1. `typed_decision_digest`
2. `permission_ledger_state`
3. `pending_permission_requests`
4. `decision_window`
5. `context_usage_snapshot`
6. `reserved_buffer`
7. `api_usage_breakdown`
8. `window_truth_surface_attested`

### 4.2 pricing causality surface

1. `settled_price`
2. `budget_policy_generation`
3. `continuation_gate`
4. `free_continuation_blocked`
5. `classifier_cost_priced`
6. `classifier_budget_source`
7. `pricing_causality_surface_attested`

这里最重要的是：

- `decision window` 不是 usage 图表
- `settled price` 不是“感觉还能继续”
- classifier 也不是“免费的安全感”

## 5. classifier/writeback 与 ingress/restore repair attestation

治理宿主还必须显式消费：

### 5.1 classifier writeback attestation

1. `classifier_verdict_ref`
2. `classifier_scope`
3. `requires_action_ref`
4. `pending_action_ref`
5. `session_state_changed_ref`
6. `writeback_seam_attested`
7. `late_response_quarantined`

### 5.2 ingress restore repair attestation

1. `session_ingress_head`
2. `adopted_server_uuid`
3. `restore_epoch_attested`
4. `worker_state_upload_ref`
5. `lineage_round_trip_attested`
6. `repair_attestation_id`
7. `consumer_projection_demoted`

这里最重要的是：

- `requires_action -> pending_action -> session_state_changed` 不是 UI 小状态，而是安全与成本共用的宿主真相缝
- `ingress / restore` 也不是恢复成功率，而是 later 团队能否沿同一条责任链重新进入

更成熟的 host-facing `repair_object` 应整体挂在：

1. `external_metadata.repair_object`

并至少包含下面字段：

1. `protocol_version`
2. `repair_id`
3. `sequence_no`
4. `status`
5. `phase`
6. `fixed_order`
7. `session_id`
8. `request_id`
9. `tool_use_id`
10. `agent_id`
11. `agent_message_id`
12. `action.tool_name`
13. `action.display_name`
14. `action.title`
15. `action.description`
16. `action.input`
17. `action.blocked_path`
18. `permission.permission_mode`
19. `permission.external_permission_mode`
20. `permission.decision_source`
21. `permission.decision_reason`
22. `permission.permission_suggestions`
23. `permission.requires_user_interaction`
24. `permission.classifier_approvable`
25. `classifier.model`
26. `classifier.classifier_type`
27. `classifier.stage`
28. `classifier.should_block`
29. `classifier.reason`
30. `classifier.unavailable`
31. `classifier.transcript_too_long`
32. `classifier.prompt_lengths`
33. `classifier.duration_ms`
34. `window.runtime_model`
35. `window.total_tokens`
36. `window.max_tokens`
37. `window.raw_max_tokens`
38. `window.percentage`
39. `window.is_auto_compact_enabled`
40. `window.auto_compact_threshold`
41. `window.api_usage`
42. `window.message_breakdown`
43. `pricing.classifier_cost_usd`
44. `pricing.stage1_cost_usd`
45. `pricing.stage2_cost_usd`
46. `pricing.session_input_tokens`
47. `pricing.session_output_tokens`
48. `pricing.session_cache_read_input_tokens`
49. `pricing.session_cache_creation_input_tokens`
50. `pricing.classifier_overhead_excluded_from_session_totals`
51. `budget.budget`
52. `budget.turn_tokens`
53. `budget.pct`
54. `budget.continuation_count`
55. `budget.diminishing_returns`
56. `budget.continuation_action`
57. `lineage.source`
58. `lineage.entry_uuid`
59. `lineage.prev_uuid`
60. `lineage.event_id`
61. `lineage.created_at`
62. `lineage.after_last_compact`
63. `lineage.compaction_boundary`
64. `lineage.lineage_truncated`
65. `directive.recommended_next_action`
66. `directive.operator_message`
67. `directive.retryable`
68. `directive.manual_review_required`
69. `writeback.channel`
70. `writeback.merge_semantics`
71. `writeback.clear_with_null`
72. `writeback.replace_whole_object`

## 6. shared reject semantics 与长期 reopen 责任面

治理宿主还必须显式消费：

### 6.1 shared reject semantics packet

1. `hard_reject`
2. `authority_chain_broken`
3. `ledger_truth_unsealed`
4. `window_truth_missing`
5. `pricing_reseal_required`
6. `classifier_cost_unpriced`
7. `writeback_reseal_required`
8. `repair_attestation_rebuild_required`
9. `manual_review_required`
10. `async_prompt_unavailable`
11. `reentry_required`
12. `reopen_required`

### 6.2 long horizon reopen liability

1. `capability_release_scope`
2. `rollback_object`
3. `liability_owner`
4. `authority_drift_trigger`
5. `threshold_retained_until`
6. `reentry_required_when`
7. `reopen_required_when`
8. `reopen_liability_class`

这里最重要的是：

- `rollback_object` 必须先于 reopen 语义存在
- `threshold_retained_until` 不能在“当前转绿”时被默默删除
- `reentry_required_when` 与 `reopen_required_when` 必须被正式区分

建议至少把下面几类拒收语义显式对象化：

1. `rule_denied`
2. `safety_check_blocked`
3. `classifier_blocked`
4. `classifier_unavailable`
5. `transcript_too_long`
6. `manual_review_required`
7. `async_prompt_unavailable`
8. `aborted_or_superseded`

## 7. 不应直接绑定成公共 ABI 的内容

宿主不应直接把下面内容绑成长期契约：

1. runtime internal mode 名称
2. dashboard 颜色
3. token 百分比单值
4. approval 弹窗 UI 状态
5. 单次告警截图
6. “目前没报错”的值班感觉
7. `enqueue()` 本地成功的安慰感
8. 只有前端能看见、但 writeback 没落盘的 pending-action 平静感

它们可以是线索，但不能是治理 refinement correction 精修协议对象。

## 8. 消费顺序建议

更稳的顺序是：

1. 先验 `repair_session_object`
2. 再验 `repair_authority_chain`
3. 再验 `ledger_window_truth_surface`
4. 再验 `pricing_causality_surface`
5. 再验 `classifier_writeback_attestation`
6. 再验 `ingress_restore_repair_attestation`
7. 再验 `shared_reject_semantics_packet`
8. 最后验 `long_horizon_reopen_liability`

不要反过来做：

1. 不要先让 mode 更平静，再修 authority chain。
2. 不要先让 usage 图表更好看，再修 pricing causality。
3. 不要先让 UI 小状态消失，再修 writeback seam。
4. 不要先让 later 团队放心，再修 repair attestation 与 liability。

## 9. 苏格拉底式检查清单

在你准备宣布“治理 refinement correction 精修协议已经成立”前，先问自己：

1. 我恢复的是 authority chain，还是一种更克制的面板感觉。
2. 我消费的是正式 ledger/window truth，还是一次值班经验总结。
3. 我结算的是 continuation price，还是“这次大概还能撑住”的直觉。
4. 我共享的是 repair attestation，还是几份相似的运营备注。
5. 我保留的是 future reopen 的正式 threshold，还是一句“以后有问题再看”。
