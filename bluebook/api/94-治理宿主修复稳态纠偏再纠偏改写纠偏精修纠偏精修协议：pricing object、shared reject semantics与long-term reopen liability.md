# 治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修协议：pricing object、shared reject semantics 与 long-term reopen liability

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象，让宿主、CI、评审与交接在治理 refinement correction refinement fixed order 已被钉死之后，继续消费同一个统一定价 repair truth，而不是退回更保守的 dashboard、审批 calmness 与继续惯性。
2. 哪些字段属于必须共享的 protocol object，哪些属于共同 `hard_reject / reentry / reopen` 语义，哪些仍不应被绑定成公共 ABI。
3. 为什么 Claude Code 的安全设计与省 token 设计本质上是同一条 `authority chain -> ledger/window truth -> pricing object -> classifier/writeback / ingress lineage -> shared reject semantics -> long-horizon reopen liability` 协议，而不是两套并行主题。
4. 宿主开发者该按什么顺序消费这套治理 refinement correction refinement 精修协议。
5. 哪些现象一旦出现，应被直接升级为 `hard_reject`、`pricing_reseal_required`、`shared_reject_rebind_required`、`reentry_required` 或 `reopen_required`，而不是继续宣称 capability 仍然安全。

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

- `GovernanceRefinementCorrectionRefinementProtocol`

的单独公共对象。

但治理 refinement correction refinement fixed order 已经能围绕八类正式对象稳定成立：

1. `repair_session_object`
2. `repair_authority_chain`
3. `ledger_window_truth_surface`
4. `pricing_object_surface`
5. `classifier_writeback_ingress_surface`
6. `shared_reject_semantics_packet`
7. `cross_consumer_repair_attestation`
8. `long_horizon_reopen_liability`

更成熟的治理 refinement correction refinement 方式不是：

- 只看 mode 面板重新平静
- 只看 usage 图表重新转绿
- 只看 later 团队愿意再保守一点

而是：

- 围绕这八类对象继续消费同一个 authority、同一个 ledger/window truth、同一个 pricing object、同一条 classifier/writeback/ingress 责任链、同一条 shared reject semantics 与同一个 threshold liability

## 2. 第一性原理

治理世界真正成熟，不是把“更保守一点”写得更体面，而是：

1. `authority` 决定谁有资格定义扩张。
2. `ledger + window` 决定哪些决策已被正式记账、当前还能承受什么上下文与动作。
3. `pricing object` 决定继续的代价与收益是否已被显式结算。
4. `classifier` 本身也必须被纳入定价对象，而不是免费旁路。
5. `writeback / ingress lineage` 决定安全与成本判断是否已被写回宿主真相，并沿同一条责任链恢复。
6. `shared reject semantics` 决定四类消费者是否真的在围绕同一个治理对象说同一种阻断语言。
7. `liability + threshold` 决定未来何时必须回跳、重入或 reopen。

所以安全设计与省 token 设计不是两套平行主题，而是同一条拒绝未定价扩张的 protocol object chain。

## 3. repair session object 与 authority chain

治理宿主应至少围绕下面对象消费 refinement correction refinement 真相：

### 3.1 repair session object

1. `repair_session_id`
2. `reprotocol_session_id`
3. `refinement_session_id`
4. `governance_object_id`
5. `repair_generation`
6. `shared_consumer_surface`
7. `repair_started_at`

### 3.2 repair authority chain

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

## 4. ledger/window truth 与 pricing object surface

治理宿主还必须显式消费：

### 4.1 ledger window truth surface

1. `typed_decision_digest`
2. `permission_ledger_state`
3. `pending_permission_requests`
4. `decision_window`
5. `context_usage_snapshot`
6. `reserved_buffer`
7. `api_usage_breakdown`
8. `window_truth_surface_attested`

### 4.2 pricing object surface

1. `settled_price`
2. `budget_policy_generation`
3. `continuation_gate`
4. `free_continuation_blocked`
5. `classifier_cost_priced`
6. `classifier_budget_source`
7. `pricing_object_surface_attested`

这里最重要的是：

- `decision window` 不是 usage 图表
- `settled price` 不是“感觉还能继续”
- classifier 也不是“免费的安全感”

## 5. classifier/writeback/ingress 与 shared reject semantics

治理宿主还必须显式消费：

### 5.1 classifier writeback ingress surface

1. `classifier_verdict_ref`
2. `classifier_scope`
3. `requires_action_ref`
4. `pending_action_ref`
5. `session_state_changed_ref`
6. `writeback_seam_attested`
7. `session_ingress_head`
8. `adopted_server_uuid`
9. `lineage_round_trip_attested`

### 5.2 shared reject semantics packet

1. `hard_reject`
2. `pricing_reseal_required`
3. `writeback_reseal_required`
4. `shared_reject_rebind_required`
5. `reentry_required`
6. `reopen_required`
7. `consumer_projection_demoted`

这里最重要的是：

- `requires_action -> pending_action -> session_state_changed` 不是 UI 小状态，而是安全与成本共用的宿主真相缝
- `ingress / restore` 也不是恢复成功率，而是 later 团队能否沿同一条责任链重新进入
- `shared reject semantics` 不是四类角色各自的继续标准

## 6. cross-consumer repair attestation 与 long-horizon reopen liability

治理宿主还必须显式消费：

### 6.1 cross consumer repair attestation

1. `repair_attestation_id`
2. `authority_chain_ref`
3. `ledger_window_truth_ref`
4. `pricing_object_ref`
5. `classifier_writeback_ingress_ref`
6. `shared_reject_semantics_ref`
7. `repair_attested_at`

### 6.2 long horizon reopen liability

1. `capability_release_scope`
2. `liability_owner`
3. `authority_drift_trigger`
4. `threshold_retained_until`
5. `reentry_required_when`
6. `reopen_required_when`
7. `rollback_object`
8. `long_horizon_reopen_liability_attested`

这里最重要的是：

- `repair attestation` 不是“大家都同意了”
- `reopen liability` 不是“以后再保守一点”
- later 团队必须能只凭对象、价格与责任链复算当前结论

## 7. 宿主消费顺序

更稳的宿主消费顺序应固定为：

1. `repair_session_object`
2. `repair_authority_chain`
3. `ledger_window_truth_surface`
4. `pricing_object_surface`
5. `classifier_writeback_ingress_surface`
6. `shared_reject_semantics_packet`
7. `cross_consumer_repair_attestation`
8. `long_horizon_reopen_liability`

不要反过来：

1. 不要先看 dashboard 是否平静，再看 authority。
2. 不要先看 pending_action 是否消失，再看 pricing object。
3. 不要先看预算似乎还够，再看 classifier 是否已经入账。
4. 不要先写 reopen 备注，再看 liability owner 与 threshold。

## 8. 共同 reject / escalation 语义

出现下面情况时，应直接升级为共同 reject 或 escalation：

1. `repair_session_missing`
2. `authority_chain_broken`
3. `ledger_window_truth_missing`
4. `pricing_object_missing`
5. `classifier_cost_unpriced`
6. `writeback_seam_unattested`
7. `ingress_lineage_unattested`
8. `shared_reject_semantics_missing`
9. `threshold_retained_until_missing`

## 9. 苏格拉底式自检

在你准备宣布“治理精修精修协议已经对象化”前，先问自己：

1. 我共享的是同一个统一定价对象，还是四份彼此相像的治理说明。
2. 我共享的是同一条 reject 语义链，还是不同消费者各自的继续阈值。
3. 我保留的是 future reopen 的正式能力，还是一句“以后再看”。
4. later 团队接手时依赖的是对象、价格与责任，还是仍要回到 dashboard、approval calmness 与作者记忆。
5. 我现在保护的是 Claude Code 的安全设计与省 token 设计，还是只是在把它们写成更像制度的文稿。
