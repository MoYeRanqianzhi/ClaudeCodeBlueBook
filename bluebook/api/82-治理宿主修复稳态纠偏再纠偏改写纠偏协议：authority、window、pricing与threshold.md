# 治理宿主修复稳态纠偏再纠偏改写纠偏协议：governance key restitution、typed ask ledger reseal、decision window refreeze、continuation pricing rebinding、classifier pricing attestation、writeback seam reseal、capability liability recustody与threshold rebinding

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象，让宿主、SDK、CI、评审与交接系统在治理 steady-state recorrection rewrite correction 之后继续消费同一个 `rewrite correction object`、同一套拒收升级语义与长期 `reopen` 责任。
2. 哪些字段属于必须消费的治理 steady-state recorrection rewrite correction object，哪些属于 verdict 语义，哪些仍然不应被绑定成公共 ABI。
3. 为什么治理 rewrite correction 不应退回 mode 面板、usage dashboard、运营感觉与默认继续。
4. 宿主开发者该按什么顺序消费这套治理 rewrite correction 规则面。
5. 哪些现象一旦出现应被直接升级为 `hard_reject`、`liability_hold`、`writeback_reseal_required`、`reentry_required` 或 `reopen_required`，而不是继续宣布 capability 仍然安全。

## 0. 关键源码锚点

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

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `GovernanceRepairSteadyStateRecorrectionRewriteCorrectionContract`

的单独公共对象。

但治理宿主修复稳态再纠偏改写纠偏实际上已经能围绕十二类正式对象稳定成立：

1. `rewrite_correction_session_object`
2. `false_authority_demotion_set`
3. `governance_key_restitution`
4. `ledger_reseal`
5. `decision_window_refreeze`
6. `continuation_pricing_rebinding`
7. `pricing_right_restitution`
8. `classifier_pricing_attestation`
9. `writeback_seam_reseal`
10. `capability_liability_recustody`
11. `threshold_rebinding`
12. `rewrite_correction_verdict`

更成熟的治理 rewrite correction 方式不是：

- 只看 mode 还没报错
- 只看 usage 图表重新转绿
- 只看 later 团队愿意再保守一点

而是：

- 围绕这十一类对象消费统一定价控制面怎样把 rewrite correction 重新拉回同一个 `governance key`、同一条 typed ask ledger、同一个 decision window、同一个 continuation pricing covenant、同一个 classifier 定价、同一个 writeback seam、同一个 capability liability 与同一个 reopen threshold

这层真正统一的不是两套不同能力，而是同一条：

- `governance key -> typed ask ledger -> window -> pricing -> classifier cost -> writeback seam -> capability liability -> threshold`

安全设计回答：

- 什么能继续放开

省 token 设计回答：

- 什么值得继续付费

这两者只有在同一 rewrite correction object 下被共同消费，才不会重新拆回面板与图表。

## 2. 第一性原理

治理世界真正成熟，不是把“更保守一点”写得更体面，而是：

1. `authority` 决定谁有资格定义扩张。
2. `ledger` 决定哪些决策已被正式记账。
3. `window` 决定当前还能承受什么上下文与动作。
4. `pricing` 决定继续的代价是否已被显式结算。
5. `classifier` 本身也必须被纳入 continuation pricing，而不是免费旁路。
6. `writeback seam` 决定安全与成本判断是否已被写回宿主真相。
7. `capability liability` 决定继续放开的责任归谁。
8. `threshold` 决定未来何时必须回跳、重入或 reopen。

所以安全设计与省 token 设计不是两套平行主题，而是同一条拒绝免费扩张的控制链。

## 3. rewrite correction session object 与 false authority demotion set

宿主应至少围绕下面对象消费治理 rewrite correction 真相：

### 3.1 rewrite correction session object

1. `rewrite_correction_session_id`
2. `governance_object_id`
3. `rewrite_generation`
4. `rewritten_at`
5. `shared_consumer_surface`

### 3.2 false authority demotion set

1. `mode_projection_demoted`
2. `dashboard_projection_demoted`
3. `free_continuation_blocked`
4. `false_authority_frozen_at`
5. `window_projection_not_authority`

这些字段回答的不是：

- mode 现在看起来是不是又恢复正常

而是：

- 当前到底先降级了哪些假 authority 投影，才能避免 rewrite correction 还没开始就被面板与图表再次接管

## 4. authority chain restitution 与 ledger reseal

治理宿主还必须显式消费：

### 4.1 authority chain restitution

1. `authority_source_before`
2. `authority_source_after`
3. `single_truth_chain_ref`
4. `writer_chokepoint`
5. `authority_restituted_at`

### 4.2 ledger reseal

1. `typed_decision_digest`
2. `permission_ledger_state`
3. `pending_permission_requests`
4. `orphan_permission_cleared`
5. `ledger_resealed_at`

这说明宿主当前消费的不是：

- 一张 dashboard 截图
- 一次审批历史回看

而是：

- `authority chain restitution + ledger reseal` 共同组成的治理 rewrite correction 对象真相

## 5. decision window refreeze 与 continuation pricing rebinding

治理宿主还必须显式消费：

### 5.1 decision window refreeze

1. `decision_window`
2. `context_usage_snapshot`
3. `reserved_buffer`
4. `pending_action_state`
5. `window_refrozen_at`

### 5.2 continuation pricing rebinding

1. `continuation_gate`
2. `budget_policy_generation`
3. `settled_price`
4. `free_continuation_blocked`
5. `repricing_expires_at`

### 5.3 pricing right restitution

1. `pricing_authority_ref`
2. `pricing_scope`
3. `pricing_generation`
4. `repricing_delegate_ref`
5. `charged_expansion_classes`
6. `pricing_right_restituted_at`

这里最重要的是：

- `decision window` 回答的是“当前还能承受什么”
- `continuation pricing` 回答的是“这次继续到底要付什么”
- `pricing right restitution` 回答的是“谁有资格把这笔价格签下来”

它们共同定义了同一条扩张准入链，而不是两份互不相干的运营说明。

## 6. classifier pricing attestation、writeback seam reseal 与 capability liability recustody

治理宿主还必须显式消费：

### 6.1 classifier pricing attestation

1. `classifier_cost_priced`
2. `classifier_verdict_ref`
3. `classifier_budget_source`
4. `classifier_scope`
5. `priced_at`

### 6.2 writeback seam reseal

1. `requires_action_ref`
2. `pending_action_ref`
3. `session_state_changed_ref`
4. `writeback_seam_attested`
5. `late_response_quarantined`

### 6.3 capability liability recustody

1. `capability_release_scope`
2. `rollback_object`
3. `quarantine_recall_handle`
4. `custody_owner`
5. `liability_owner`
6. `recustody_rebound_at`

这里最重要的是：

- `requires_action -> pending_action -> session_state_changed` 不是 UI 小状态，而是安全与成本共用的 writeback seam
- classifier 自己也必须被纳入 continuation pricing；否则“更安全”和“更省 token”都只是把代价外包给不可见成本

## 7. threshold rebinding 与 rewrite correction verdict

治理 rewrite correction 还必须消费：

### 7.1 threshold rebinding

1. `authority_drift_trigger`
2. `threshold_retained_until`
3. `reentry_required_when`
4. `reopen_required_when`
5. `threshold_rebound_at`

### 7.2 rewrite correction verdict

1. `steady_state_restituted`
2. `hard_reject`
3. `liability_hold`
4. `writeback_reseal_required`
5. `reentry_required`
6. `reopen_required`
7. `window_truth_missing`
8. `classifier_cost_unpriced`
9. `capability_liability_unbound`
10. `pricing_authority_unbound`
11. `threshold_rebinding_missing`

这些 verdict reason 的价值在于：

- 把“治理控制面已经从 rewrite correction 层重新压回统一定价对象”翻译成宿主、CI、评审与交接都能共享的 reject / escalation 语义

## 8. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. runtime internal mode 名称
2. dashboard 颜色
3. token 百分比单值
4. approval 弹窗 UI 状态
5. later 团队的保守建议
6. 单次告警截图
7. 口头补写的稳定说明
8. “目前没报错”的值班感觉

它们可以是 rewrite correction 线索，但不能是 rewrite correction 对象。

## 9. rewrite correction 消费顺序建议

更稳的顺序是：

1. 先验 `rewrite_correction_session_object`
2. 再验 `false_authority_demotion_set`
3. 再验 `authority_chain_restitution`
4. 再验 `ledger_reseal`
5. 再验 `decision_window_refreeze`
6. 再验 `continuation_pricing_rebinding`
7. 再验 `classifier_pricing_attestation`
8. 再验 `writeback_seam_reseal`
9. 再验 `capability_liability_recustody`
10. 最后验 `threshold_rebinding`
11. 再给 `rewrite_correction_verdict`

不要反过来做：

1. 不要先看 mode 面板。
2. 不要先看 usage 图表。
3. 不要先看 later 团队是否主观放心。

## 10. 苏格拉底式检查清单

在你准备宣布“治理已完成稳态再纠偏改写纠偏协议”前，先问自己：

1. 我现在救回的是同一个治理对象，还是一套更严格的 rewrite correction 说明书。
2. 我现在重申的是 authority 真相链，还是 mode 与 dashboard 的平静感。
3. 我现在重封的是 formal ledger 与 decision window，还是只是在接受“最近没人再报错”。
4. 我现在重建的是 continuation 的正式定价，还是给默认继续换了个更体面的名字。
5. 我现在保留的是未来推翻当前状态的正式 threshold，还是一句“以后有问题再看”。

## 11. 一句话总结

Claude Code 的治理宿主修复稳态纠偏再纠偏改写纠偏协议，不是把稳定说明写得更严，而是 `authority chain restitution + ledger reseal + decision window refreeze + continuation pricing rebinding + classifier pricing attestation + writeback seam reseal + capability liability recustody + threshold rebinding` 共同组成的规则面。
