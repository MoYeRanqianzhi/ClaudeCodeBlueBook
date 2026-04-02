# 治理宿主修复稳态协议：authority continuity、ledger dormancy seal、window dormancy、continuation pricing covenant、capability custody与reopen threshold

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象让宿主、SDK、CI、评审与交接系统在治理 release correction 之后消费无人盯防延续、继续定价与 residual reopen threshold。
2. 哪些字段属于必须消费的治理 steady-state object，哪些属于 verdict 语义，哪些仍然不应被绑定成公共 ABI。
3. 为什么治理稳态协议不应退回 mode 面板、usage dashboard 与“先保守一点”的经验判断。
4. 宿主开发者该按什么顺序消费这套治理 steady-state 规则面。
5. 哪些现象一旦出现应被直接升级为 steady-state blocked、authority drift detected 或 reopen threshold reached，而不是继续宣布 capability 还算安全。

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

- `GovernanceRepairSteadyStateContract`

的单独公共对象。

但治理宿主修复稳态实际上已经能围绕六类正式对象稳定成立：

1. `authority_continuity`
2. `ledger_dormancy_seal`
3. `window_dormancy`
4. `continuation_pricing_covenant`
5. `capability_custody`
6. `reopen_threshold`

更成熟的治理稳态方式不是：

- 只看 mode 还没报错
- 只看 usage 图表重新转绿
- 只看 later 团队愿意保守一点

而是：

- 围绕这六类对象消费统一定价控制面怎样在停止额外盯防之后，仍继续约束 authority、定价、能力暴露与 residual reopen 责任

## 2. authority continuity：最小稳态对象

宿主应至少围绕下面对象消费治理稳态真相：

1. `governance_object_id`
2. `authority_source`
3. `mode_projection_demoted`
4. `settings_projection_hash`
5. `continuity_attested`
6. `steady_state_evaluated_at`

这些字段回答的不是：

- mode 现在看起来是不是还比较安全

而是：

- 当前到底围绕哪个治理对象、以哪个 authority 边界进入了无人盯防稳态

## 3. ledger dormancy seal 与 window dormancy

治理宿主还必须显式消费：

### 3.1 ledger dormancy seal

1. `permission_ledger_state`
2. `pending_permission_requests`
3. `late_permission_response_blocked`
4. `dormancy_started_at`
5. `ledger_dormancy_sealed`

### 3.2 window dormancy

1. `decision_window`
2. `context_usage_snapshot`
3. `reserved_buffer`
4. `window_refresh_threshold`
5. `window_dormancy_attested`

这说明宿主当前消费的不是：

- 一张面板截图
- 一次审批历史回看

而是：

- `ledger dormancy seal + window dormancy` 共同组成的治理稳态证明

## 4. continuation pricing covenant、capability custody 与 reopen threshold

治理稳态还必须消费：

### 4.1 continuation pricing covenant

1. `continuation_gate`
2. `budget_policy_generation`
3. `settled_price`
4. `free_continuation_blocked`
5. `covenant_expires_at`

### 4.2 capability custody

1. `capability_release_scope`
2. `quarantine_recall_handle`
3. `rollback_object`
4. `custody_owner`
5. `capability_custody_attested`

### 4.3 reopen threshold

1. `authority_drift_trigger`
2. `liability_owner`
3. `threshold_retained_until`
4. `residual_risk_digest`
5. `reopen_required`

这三组对象回答的不是：

- 现在是不是终于不用再看 dashboard
- 能力是不是大概可以继续放着不管

而是：

- continuation 是否仍回到正式定价，而不是重新免费化
- capability 是否仍被正式托管，而不是只是在 UI 上继续显示
- steady state 一旦失效，系统是否仍保留 authority drift 与 reopen 的正式阈值

## 5. steady-state verdict：必须共享的稳态语义

更成熟的治理宿主稳态 verdict 至少应共享下面枚举：

1. `steady_state`
2. `steady_state_blocked`
3. `authority_drift_detected`
4. `free_continuation_rejected`
5. `capability_custody_missing`
6. `dashboard_based_steady_state_rejected`
7. `reopen_threshold_reached`

这些 verdict reason 的价值在于：

- 把“released 之后治理仍继续成立”翻译成宿主、CI、评审与交接都能共享的治理 post-watch 语义

## 6. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. runtime internal mode 名称
2. dashboard 颜色
3. token 百分比单值
4. 审批弹窗 UI 状态
5. 原始 classifier 细节
6. later 团队的保守建议
7. 单次 approval 记录
8. 口头补写的观察说明

它们可以是稳态线索，但不能是稳态对象。

## 7. 稳态消费顺序建议

更稳的顺序是：

1. 先验 `authority_continuity`
2. 再验 `ledger_dormancy_seal`
3. 再验 `window_dormancy`
4. 再验 `continuation_pricing_covenant`
5. 再验 `capability_custody`
6. 最后验 `reopen_threshold`

不要反过来做：

1. 不要先看 mode 面板。
2. 不要先看 usage 图表。
3. 不要先看大家现在主观上是否放心。

## 8. 苏格拉底式检查清单

在你准备宣布“治理已进入稳态”前，先问自己：

1. 我现在保护的是 authority continuity，还是一段更舒服的 mode 体验。
2. `ledger dormancy seal` 真的封住了尾账，还是只是最近没人再点开审批记录。
3. `continuation pricing covenant` 保护的是继续定价，还是一次暂时没超预算的好运气。
4. capability custody 托管的是能力边界，还是一个继续显示在界面上的开关。
5. `reopen threshold` 还在不在，如果不在，我是在进入稳态，还是在删除未来追责与回滚的能力。

## 9. 一句话总结

Claude Code 的治理宿主修复稳态协议，不是 release 之后的保守建议 API，而是 `authority continuity + ledger dormancy seal + window dormancy + continuation pricing covenant + capability custody + reopen threshold` 共同组成的规则面。
