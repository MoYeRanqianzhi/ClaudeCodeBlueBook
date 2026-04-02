# 治理宿主修复解除监护协议：authority release、ledger residue clearance、window exit、continuation settlement、quarantine release与reopen liability

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象让宿主、SDK、CI、评审与交接系统在治理 watch correction 之后消费解除监护、解除隔离与 residual reopen liability。
2. 哪些字段属于必须消费的治理 watch release object，哪些属于 release verdict 语义，哪些仍然不应被绑定成公共 ABI。
3. 为什么治理解除监护协议不应退回 mode 面板、usage dashboard 与“最近先保守点”。
4. 宿主开发者该按什么顺序消费这套治理 watch release 规则面。
5. 哪些现象一旦出现应被直接升级为 release blocked、monitor extended 或 reopen required，而不是宣布“观察结束”。

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

- `GovernanceRepairWatchReleaseContract`

的单独公共对象。

但治理宿主修复解除监护实际上已经能围绕六类正式对象稳定成立：

1. `authority_release`
2. `ledger_residue_clearance`
3. `window_exit_certificate`
4. `continuation_settlement`
5. `quarantine_release`
6. `reopen_liability_record`

更成熟的治理解除监护方式不是：

- 只看 mode 仍然安全
- 只看 usage 面板重新转绿
- 只看 later 团队愿意保守一点

而是：

- 围绕这六类对象消费统一定价控制面怎样在停止额外监护之后，仍继续防止 authority 漂移、尾账复活、免费继续与责任失忆

## 2. authority release：最小解除监护对象

宿主应至少围绕下面对象消费治理解除监护真相：

1. `governance_object_id`
2. `authority_source_before_release`
3. `authority_source_after_release`
4. `effective_settings_projection`
5. `writer_chokepoint`
6. `release_generation`
7. `release_evaluated_at`

这些字段回答的不是：

- mode 现在是不是看着很稳

而是：

- 当前到底围绕哪个治理对象、以哪个 authority 边界合法解除额外监护

## 3. ledger residue clearance 与 window exit certificate

治理宿主还必须显式消费：

### 3.1 ledger residue clearance

1. `typed_decision_digest`
2. `permission_ledger_state`
3. `pending_permission_requests`
4. `late_permission_response`
5. `residue_cleared`

### 3.2 window exit certificate

1. `decision_window`
2. `pending_action_cleared`
3. `context_usage_snapshot`
4. `reserved_buffer`
5. `window_exit_attested`

这说明宿主当前消费的不是：

- 一张仪表盘截图
- 一次审批历史回看

而是：

- `ledger_residue_clearance + window_exit_certificate` 共同组成的治理解除监护证明

## 4. continuation settlement、quarantine release 与 reopen liability record

治理解除监护还必须消费：

### 4.1 continuation settlement

1. `continuation_gate`
2. `token_budget_result`
3. `settled_price`
4. `next_action_allowed`
5. `settlement_expires_at`

### 4.2 quarantine release

1. `rollback_object`
2. `quarantine_scope`
3. `baseline_reset_required`
4. `quarantine_cleared`
5. `capability_release_attested`

### 4.3 reopen liability record

1. `reopen_trigger`
2. `liability_owner`
3. `gate_retained_until`
4. `residual_risk_digest`
5. `reopen_required`

这三组对象回答的不是：

- 安全现在是不是终于恢复正常
- token 现在是不是终于降下来了

而是：

- continuation 是否已经重新回到正式定价，而不是重新免费化
- quarantine 是否已经合法释放，而不是只在面板上消失
- residual reopen 责任是否被保留下来，而不是随着解除监护一起失踪

## 5. release verdict：必须共享的解除监护语义

更成熟的治理宿主解除监护 verdict 至少应共享下面枚举：

1. `released`
2. `release_blocked`
3. `monitor_extended`
4. `free_continuation_rejected`
5. `quarantine_not_released`
6. `dashboard_release_rejected`
7. `reopen_liability_retained`
8. `reopen_required`

这些 verdict reason 的价值在于：

- 把“现在可以不再额外看护”翻译成宿主、CI、评审与交接都能共享的治理 post-watch 语义

## 6. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. runtime internal mode 全集
2. dashboard 颜色
3. token 百分比单值
4. 审批弹窗 UI 状态
5. `allow: boolean`
6. later 团队的保守建议
7. 内部 classifier 细节
8. 口头补写的观察说明

它们可以是解除监护线索，但不能是解除监护对象。

## 7. 解除监护顺序建议

更稳的顺序是：

1. 先验 `authority_release`
2. 再验 `ledger_residue_clearance`
3. 再验 `window_exit_certificate`
4. 再验 `continuation_settlement`
5. 再验 `quarantine_release`
6. 最后验 `reopen_liability_record`

不要反过来做：

1. 不要先看 mode 面板。
2. 不要先看 usage 图表。
3. 不要先看 later 团队是否主观放心。

## 8. 一句话总结

Claude Code 的治理宿主修复解除监护协议，不是观察期结束审批 API，而是 `authority release + ledger residue clearance + window exit certificate + continuation settlement + quarantine release + reopen liability record` 共同组成的规则面。
