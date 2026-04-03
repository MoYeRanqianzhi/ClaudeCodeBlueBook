# 治理宿主修复稳态纠偏再纠偏改写纠偏精修协议：authority-ledger covenant、window-pricing custody、classifier-writeback attestation、cross-consumer attestation 与 reopen liability ledger

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象，让宿主、CI、评审与交接在治理 rewrite correction 固定顺序已经被钉死之后，继续消费同一个统一定价控制面，而不是退回更严格的值班说明。
2. 哪些字段属于必须共享的宿主消费对象，哪些属于 `hard_reject / reentry / reopen` 语义，哪些仍不应被绑定成公共 ABI。
3. 为什么 Claude Code 的安全设计与省 token 设计本质上是同一条 `authority -> ledger -> window -> pricing -> classifier -> writeback seam -> liability -> threshold` 控制链，而不是两套并行主题。
4. 宿主开发者该按什么顺序消费这套治理 rewrite correction 精修协议。
5. 哪些现象一旦出现，应被直接升级为 `hard_reject`、`writeback_reseal_required`、`liability_hold`、`reentry_required` 或 `reopen_required`，而不是继续宣称 capability 仍然安全。

## 0. 关键源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-619`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:337-348`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1407-1450`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1533-1541`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1735-1747`
- `claude-code-source-code/src/cli/structuredIO.ts:362-657`
- `claude-code-source-code/src/cli/print.ts:1052-1075`
- `claude-code-source-code/src/cli/print.ts:4568-4641`
- `claude-code-source-code/src/utils/permissions/permissions.ts:526-1318`
- `claude-code-source-code/src/utils/permissions/yoloClassifier.ts:1250-1312`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/utils/analyzeContext.ts:1098-1382`
- `claude-code-source-code/src/query/tokenBudget.ts:22-92`
- `claude-code-source-code/src/query.ts:1308-1518`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `GovernanceRewriteCorrectionRefinementContract`

的单独公共对象。

但治理 rewrite correction 精修协议已经能围绕十类正式对象稳定成立：

1. `rewrite_refinement_session_object`
2. `false_authority_projection_demotion_contract`
3. `authority_ledger_covenant`
4. `window_pricing_covenant`
5. `classifier_writeback_custody`
6. `capability_liability_ledger`
7. `hard_reject_semantics_abi`
8. `cross_consumer_attestation_packet`
9. `reopen_liability_ledger`
10. `rewrite_refinement_verdict`

更成熟的治理 rewrite correction 方式不是：

- 只看 mode 面板重新平静
- 只看 usage 图表重新转绿
- 只看 later 团队愿意再保守一点

而是：

- 围绕这十类对象继续消费同一个 authority、同一个 ledger、同一个 decision window、同一个 settled price、同一份 classifier 成本、同一条 writeback seam、同一个 capability liability 与同一个 threshold

## 2. 第一性原理

Claude Code 的安全设计与省 token 设计本质上是一条统一定价控制链：

1. `authority` 决定谁有资格定义扩张。
2. `ledger` 决定哪些决策已被正式记账。
3. `window` 决定当前还能承受什么上下文与动作。
4. `pricing` 决定继续到底要付什么。
5. `classifier` 决定安全判断本身的成本不能被免费旁路。
6. `writeback seam` 决定安全与成本是否已被写回宿主真相。
7. `liability` 决定继续放开的责任归谁。
8. `threshold` 决定何时必须重入、拒收或 reopen。

所以这一层真正保护的不是：

- “更谨慎一点”

而是：

- 无人继续盯防时，系统仍拒绝免费扩张

## 3. 会话、降级与 authority-ledger 契约

治理宿主至少应围绕下面对象消费 rewrite correction 精修真相：

### 3.1 rewrite refinement session object

1. `refinement_session_id`
2. `rewrite_correction_session_id`
3. `governance_object_id`
4. `rewrite_generation`
5. `shared_consumer_surface`
6. `reprotocol_started_at`

### 3.2 false authority projection demotion contract

1. `mode_projection_demoted`
2. `dashboard_projection_demoted`
3. `window_projection_not_authority`
4. `free_continuation_blocked`
5. `false_authority_frozen_at`

### 3.3 authority ledger covenant

1. `authority_source_after`
2. `single_truth_chain_ref`
3. `typed_decision_digest`
4. `permission_ledger_state`
5. `pending_permission_requests`
6. `authority_restituted_at`
7. `ledger_resealed_at`

这些对象回答的不是：

- 当前治理说明是不是更严格了

而是：

- 当前到底先降级了哪些假 authority 投影，并把哪一条正式责任账本重新交还给 later 消费者

## 4. window、pricing 与 classifier-writeback 托管

治理宿主还必须显式消费：

### 4.1 window pricing covenant

1. `decision_window`
2. `context_usage_snapshot`
3. `reserved_buffer`
4. `settled_price`
5. `budget_policy_generation`
6. `free_continuation_blocked`
7. `window_refrozen_at`

### 4.2 classifier writeback custody

1. `classifier_cost_priced`
2. `classifier_verdict_ref`
3. `classifier_budget_source`
4. `requires_action_ref`
5. `pending_action_ref`
6. `session_state_changed_ref`
7. `late_response_quarantined`
8. `writeback_seam_attested`

这里最重要的是：

- `decision window` 不是 usage 图表
- `settled price` 不是“感觉还能继续”
- `requires_action -> pending_action -> session_state_changed` 不是 UI 小状态，而是安全与成本共用的宿主真相缝

## 5. capability、reject 与 reopen 责任账本

治理宿主还必须显式消费：

### 5.1 capability liability ledger

1. `capability_release_scope`
2. `custody_owner`
3. `liability_owner`
4. `rollback_object`
5. `authority_drift_trigger`
6. `threshold_retained_until`
7. `reentry_required_when`
8. `reopen_required_when`

### 5.2 hard reject semantics abi

1. `hard_reject`
2. `liability_hold`
3. `writeback_reseal_required`
4. `reentry_required`
5. `reopen_required`
6. `authority_source_unexternalized`
7. `mode_projection_as_authority`
8. `permission_ledger_state_unsealed`
9. `decision_window_as_dashboard`
10. `settled_price_missing`
11. `classifier_cost_unpriced`
12. `writeback_seam_missing`
13. `free_continuation_detected`
14. `capability_liability_unbound`
15. `threshold_rebinding_missing`

### 5.3 cross consumer attestation packet

1. `host_consumer_ref`
2. `ci_consumer_ref`
3. `reviewer_consumer_ref`
4. `handoff_consumer_ref`
5. `shared_consumer_surface`
6. `authority_generation`
7. `ledger_generation`
8. `attested_at`

### 5.4 reopen liability ledger

1. `authority_drift_trigger`
2. `threshold_retained_until`
3. `reentry_required_when`
4. `reopen_required_when`
5. `rollback_object`
6. `liability_owner`
7. `window_floor_generation`
8. `pricing_floor_generation`

这里最重要的是：

- classifier 成本必须继续留在 pricing object 里
- `writeback seam` 不成立时，责任就无法被 later 团队复演
- `reopen liability ledger` 保护的是未来仍能正式推翻当前 capability 释放结论

## 6. rewrite refinement verdict

治理 rewrite correction 精修协议还必须消费：

1. `steady_state_chain_resealed`
2. `hard_reject`
3. `liability_hold`
4. `writeback_reseal_required`
5. `reentry_required`
6. `reopen_required`
7. `classifier_cost_unpriced`
8. `shared_consumer_surface_broken`
9. `authority_chain_missing`
10. `threshold_liability_missing`

这些 verdict reason 的价值在于：

- 把“治理控制面已经从 fixed rewrite correction order 继续压回统一定价对象”翻译成宿主、CI、评审与交接都能共享的 reject / escalation 语义

## 7. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. runtime internal mode 名称
2. dashboard 颜色
3. token 百分比单值
4. approval 弹窗 UI 状态
5. 单次告警截图
6. later 团队的口头保守建议
7. 口头补写的稳定说明
8. “目前没报错”的值班感觉

它们可以是线索，但不能是治理 rewrite correction 精修对象。

## 8. 消费顺序建议

更稳的顺序是：

1. 先验 `rewrite_refinement_session_object`
2. 再验 `false_authority_projection_demotion_contract`
3. 再验 `authority_ledger_covenant`
4. 再验 `window_pricing_covenant`
5. 再验 `classifier_writeback_custody`
6. 再验 `capability_liability_ledger`
7. 再验 `hard_reject_semantics_abi`
8. 再验 `cross_consumer_attestation_packet`
9. 最后验 `reopen_liability_ledger`
10. 再给 `rewrite_refinement_verdict`

不要反过来做：

1. 不要先看 mode 面板。
2. 不要先看 usage 图表。
3. 不要先看 later 团队是否主观放心。

## 9. 苏格拉底式检查清单

在你准备宣布“治理已完成 rewrite correction 精修协议”前，先问自己：

1. 我现在救回的是同一个治理对象，还是一套更严格的治理说明。
2. 我现在消费的是 authority 真相链，还是 mode 与 dashboard 的平静感。
3. 我现在消费的是 `decision window + settled price + classifier pricing`，还是一种“应该还能继续”的感觉。
4. 我现在保住的是 `writeback seam + liability owner`，还是几句更保守的值班备注。
5. 我现在保留的是未来推翻当前 capability 状态的正式 threshold，还是一句“以后有问题再看”。

## 10. 一句话总结

Claude Code 的治理 rewrite correction 精修协议，不是把安全说明写得更严，而是 `authority_ledger_covenant + window_pricing_covenant + classifier_writeback_custody + capability_liability_ledger + hard_reject_semantics_abi + reopen_liability_ledger` 共同组成的统一定价控制面。
