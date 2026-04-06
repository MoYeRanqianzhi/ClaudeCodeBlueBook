# 治理宿主修复稳态纠偏协议：authority reassertion、ledger reseal、window refreeze、continuation repricing、capability recustody与reopen threshold rebinding

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象让宿主、SDK、CI、评审与交接系统在治理 steady-state correction 之后消费同一个修正对象、拒收升级语义与长期 reopen 责任。
2. 哪些字段属于必须消费的治理 steady-state correction object，哪些属于 verdict 语义，哪些仍然不应被绑定成公共 ABI。
3. 为什么治理稳态纠偏协议不应退回 mode 面板、usage dashboard、保守建议与默认继续。
4. 宿主开发者该按什么顺序消费这套治理 steady-state correction 规则面。
5. 哪些现象一旦出现应被直接升级为 `hard_reject`、`reentry_required`、`liability_hold` 或 `reopen_required`，而不是继续宣布 capability 仍然安全。

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

- `GovernanceRepairSteadyStateCorrectionContract`

的单独公共对象。

但治理宿主修复稳态纠偏实际上已经能围绕八类正式对象稳定成立：

1. `steady_correction_object`
2. `authority_reassertion`
3. `ledger_reseal`
4. `window_refreeze`
5. `continuation_repricing`
6. `capability_recustody`
7. `threshold_rebinding`
8. `correction_verdict`

更成熟的治理稳态纠偏方式不是：

- 只看 mode 还没报错
- 只看 usage 图表重新转绿
- 只看 later 团队愿意再保守一点

而是：

- 围绕这八类对象消费统一定价控制面怎样把假稳态重新拉回同一个 authority、同一个 ledger、同一个 decision window、同一个 continuation pricing covenant 与同一个 reopen liability

这层真正统一的不是两套不同能力，而是同一条：

- `authority -> ledger -> window -> pricing -> custody -> threshold`

安全设计回答：

- 什么能继续放开

省 token 设计回答：

- 什么值得继续付费

这两者只有在同一 correction object 下被共同消费，才不会重新拆回面板与图表。

## 2. steady correction object 与 authority reassertion

宿主应至少围绕下面对象消费治理纠偏真相：

### 2.1 steady correction object

1. `correction_object_id`
2. `governance_object_id`
3. `correction_generation`
4. `corrected_at`
5. `shared_consumer_surface`

### 2.2 authority reassertion

1. `authority_source_before`
2. `authority_source_after`
3. `writer_chokepoint`
4. `mode_projection_demoted`
5. `continuity_restored`

这些字段回答的不是：

- mode 现在看起来是不是又恢复正常

而是：

- 当前到底围绕哪个治理对象、以哪个 authority 边界完成了稳态纠偏

## 3. ledger reseal 与 window refreeze

治理宿主还必须显式消费：

### 3.1 ledger reseal

1. `typed_decision_digest`
2. `permission_ledger_state`
3. `pending_permission_requests`
4. `late_or_orphan_cleared`
5. `ledger_resealed_at`

### 3.2 window refreeze

1. `decision_window`
2. `pending_action_state`
3. `context_usage_snapshot`
4. `reserved_buffer`
5. `window_dormancy_restored`

这说明宿主当前消费的不是：

- 一张 dashboard 截图
- 一次审批历史回看

而是：

- `ledger reseal + window refreeze` 共同组成的治理稳态纠偏证明

## 4. continuation repricing、capability recustody 与 threshold rebinding

治理稳态纠偏还必须消费：

### 4.1 continuation repricing

1. `continuation_gate`
2. `budget_policy_generation`
3. `settled_price`
4. `free_continuation_blocked`
5. `covenant_expires_at`

### 4.2 capability recustody

1. `capability_release_scope`
2. `rollback_object`
3. `quarantine_recall_handle`
4. `custody_owner`
5. `custody_rebound`

### 4.3 threshold rebinding

1. `authority_drift_trigger`
2. `liability_owner`
3. `residual_risk_digest`
4. `threshold_retained_until`
5. `reopen_required_when`

这里最重要的是：

- 这些字段不是“大家先保守一点”的态度表达，而是宿主可消费的时间合同与责任链

它们回答的不是：

- capability 现在是不是终于可以先放着不管

而是：

- continuation 是否已经重新付费
- capability 是否已经重新回到正式托管
- future reopen 是否仍保留可追责的 threshold

## 5. correction verdict：必须共享的纠偏语义

更成熟的治理宿主稳态纠偏 verdict 至少应共享下面枚举：

1. `steady_state_restored`
2. `hard_reject`
3. `reentry_required`
4. `liability_hold`
5. `reopen_required`
6. `ledger_reseal_required`
7. `free_continuation_detected`
8. `threshold_rebinding_missing`

这些 verdict reason 的价值在于：

- 把“治理控制面已经从假稳态纠偏回统一定价对象”翻译成宿主、CI、评审与交接都能共享的 correction 语义

## 6. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. runtime internal mode 名称
2. dashboard 颜色
3. token 百分比单值
4. approval 弹窗 UI 状态
5. later 团队的保守建议
6. 单次告警截图
7. 口头补写的稳定说明
8. “目前没报错”的值班感觉

它们可以是纠偏线索，但不能是纠偏对象。

## 7. 纠偏消费顺序建议

更稳的顺序是：

1. 先验 `steady_correction_object`
2. 再验 `authority_reassertion`
3. 再验 `ledger_reseal`
4. 再验 `window_refreeze`
5. 再验 `continuation_repricing`
6. 再验 `capability_recustody`
7. 最后验 `threshold_rebinding`
8. 再给 `correction_verdict`

不要反过来做：

1. 不要先看 mode 面板。
2. 不要先看 usage 图表。
3. 不要先看 later 团队是否主观放心。

## 8. 苏格拉底式检查清单

在你准备宣布“治理已完成稳态纠偏”前，先问自己：

1. 我现在救回的是同一个治理对象，还是一套更严格的稳态说明书。
2. 我现在重申的是 authority，还是 mode 和 dashboard 的平静感。
3. 我现在封住的是 formal ledger 尾账，还是只是在接受“最近没人再报错”。
4. 我现在恢复的是 continuation 的正式定价，还是给默认继续换了个更体面的名字。
5. 我现在保留的是未来推翻当前 steady 的正式阈值，还是一句“后面有问题再看”。

## 9. 一句话总结

Claude Code 的治理宿主修复稳态纠偏协议，不是把稳态看板写得更严，而是 `authority reassertion + ledger reseal + window refreeze + continuation repricing + capability recustody + reopen threshold rebinding` 共同组成的规则面。
