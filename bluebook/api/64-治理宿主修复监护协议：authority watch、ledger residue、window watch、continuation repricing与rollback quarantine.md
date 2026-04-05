# 治理宿主修复监护协议：authority watch、ledger residue、window watch、continuation repricing与rollback quarantine

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象让宿主、SDK、CI、评审与交接系统在治理收口之后继续消费 authority watch、window watch 与 reopen。
2. 哪些字段属于必须消费的治理 post-closeout watch object，哪些属于 watch verdict 语义，哪些仍然不应被绑定成公共 ABI。
3. 为什么治理监护协议不应退回 mode 面板、usage dashboard 与“先保守点”。
4. 宿主开发者该按什么顺序消费这套治理 watch 规则面。
5. 哪些现象一旦出现应被直接升级为 reopen required 或 handoff blocked，而不是继续围绕面板变化解释。

## 0. 关键源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-260`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:578-619`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:337-348`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1407-1450`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1533-1541`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1735-1747`
- `claude-code-source-code/src/cli/structuredIO.ts:362-657`
- `claude-code-source-code/src/cli/print.ts:1052-1075`
- `claude-code-source-code/src/cli/print.ts:4568-4641`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:510-645`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1071-1318`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/utils/analyzeContext.ts:1098-1382`
- `claude-code-source-code/src/query/tokenBudget.ts:22-92`
- `claude-code-source-code/src/query.ts:1308-1518`

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `GovernanceRepairWatchContract`

的单独公共对象。

但治理宿主修复监护实际上已经能围绕五类正式对象稳定成立：

1. `authority_watch`
2. `ledger_residue`
3. `window_watch`
4. `continuation_repricing_watch`
5. `rollback_quarantine`

更成熟的治理监护方式不是：

- 只看 mode 还稳不稳
- 只看 usage 面板还绿不绿
- 只看 later 团队先别继续自动化

而是：

- 围绕这五类对象消费统一定价控制面怎样在 closeout 之后继续防止 authority drift、ledger 尾账、window 复活与免费继续

## 2. authority watch：最小监护对象

宿主应至少围绕下面对象消费治理监护真相：

1. `governance_watch_id`
2. `governance_object_id`
3. `authority_source_snapshot`
4. `effective_settings_projection`
5. `writer_chokepoint`
6. `settlement_generation`
7. `watch_deadline`

这些字段回答的不是：

- mode 现在是不是还安全

而是：

- 当前到底围绕哪个治理对象继续观察 authority drift

## 3. ledger residue 与 window watch

治理宿主还必须显式消费：

### 3.1 ledger residue

1. `typed_decision_digest`
2. `permission_ledger_state`
3. `pending_permission_requests`
4. `late_permission_response`
5. `residue_cleared`

### 3.2 window watch

1. `decision_window`
2. `pending_action`
3. `context_usage_snapshot`
4. `reserved_buffer`
5. `late_response_quarantined`

这说明宿主当前消费的不是：

- 一张 usage 仪表盘
- 一次审批历史回看

而是：

- `ledger residue + window watch` 共同组成的治理监护对象

## 4. continuation repricing watch 与 rollback quarantine

治理监护还必须消费：

### 4.1 continuation repricing watch

1. `continuation_gate`
2. `token_budget_result`
3. `repricing_due_at`
4. `completion_event`
5. `handoff_ready_snapshot`

### 4.2 rollback quarantine

1. `rollback_object`
2. `baseline_reset_required`
3. `quarantine_scope`
4. `quarantine_cleared`
5. `reopen_gate`

这两组对象回答的不是：

- later 团队是否只要更保守一点就行
- 文件是不是已经退回去

而是：

- continuation 是否仍在被重新定价，而不是重新免费化
- 当前 rollback 余波是否已被正式隔离，并在何种条件下必须 reopen

## 5. watch verdict：必须共享的监护语义

更成熟的治理宿主监护 verdict 至少应共享下面枚举：

1. `stable_under_watch`
2. `authority_drift_detected`
3. `ledger_residue_detected`
4. `window_drift_detected`
5. `continuation_repricing_due`
6. `rollback_quarantine_active`
7. `handoff_blocked`
8. `reopen_required`

这些 verdict reason 的价值在于：

- 把“现在先观察”翻译成宿主、CI、评审与交接都能共享的治理 post-closeout 语义

## 6. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. runtime internal mode 全集
2. dashboard 颜色
3. token 百分比单值
4. 审批弹窗 UI 状态
5. later 团队的保守模式建议
6. `allow: boolean`
7. 内部 classifier 细节
8. 口头补写的观察建议

它们可以是监护线索，但不能是监护对象。

## 7. 监护顺序建议

更稳的顺序是：

1. 先验 `authority_watch`
2. 再验 `ledger_residue`
3. 再验 `window_watch`
4. 再验 `continuation_repricing_watch`
5. 最后验 `rollback_quarantine`

不要反过来做：

1. 不要先看 mode 面板。
2. 不要先看 usage 图表。
3. 不要先看 later 团队的保守操作建议。

## 8. 一句话总结

Claude Code 的治理宿主修复监护协议，不是 closeout 之后的保守操作建议 API，而是 `authority watch + ledger residue + window watch + continuation repricing watch + rollback quarantine` 共同组成的规则面。
