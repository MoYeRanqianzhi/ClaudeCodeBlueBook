# 治理宿主修复协议：authority repair、ledger rebuild、decision window reset、continuation repricing与rollback object

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象让宿主、SDK、CI、评审与交接系统消费治理执行纠偏。
2. 哪些字段属于必须消费的治理 repair object，哪些属于 reject escalation 语义，哪些仍然不应被绑定成公共 ABI。
3. 为什么治理修复协议不应退回 mode 调参、审批补救与仪表盘修饰。
4. 宿主开发者该按什么顺序消费这套治理修复规则面。
5. 哪些现象一旦出现应被直接升级为 hard reject 或 rollback required，而不是继续灰度。

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

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `GovernanceRepairContract`

的单独公共对象。

但治理宿主修复实际上已经能围绕五类正式对象稳定成立：

1. `authority_repair`
2. `ledger_rebuild`
3. `decision_window_reset`
4. `continuation_repricing`
5. `rollback_object`

更成熟的修复方式不是：

- 只切 mode
- 只补审批
- 只调 token 面板

而是：

- 围绕这五类对象消费统一定价控制面怎样恢复成同一个治理对象

## 2. authority repair：最小修复对象

宿主应至少围绕下面对象消费治理修复真相：

1. `repair_object_id`
2. `authority_source_before`
3. `authority_source_after`
4. `effective_settings_projection`
5. `externalized_mode`
6. `writer_chokepoint`

这些字段回答的不是：

- mode 现在调到了哪里

而是：

- 当前到底把哪个 authority 漂移修回了哪个正式治理边界

## 3. ledger rebuild 与 decision window reset

治理宿主还必须显式消费：

### 3.1 ledger rebuild

1. `typed_decision`
2. `permission_ledger`
3. `pending_permission_requests`
4. `request_id`
5. `tool_use_id`
6. `duplicate_or_orphan_state`

### 3.2 decision window reset

1. `decision_window`
2. `pending_action`
3. `ContextData.categories`
4. `reserved_buffer`
5. `apiUsage`
6. `autoCompactThreshold`

这说明宿主当前消费的不是：

- 一次审批补救或一张 usage 仪表盘

而是：

- `ledger_rebuild + decision_window_reset` 共同组成的治理修复对象

## 4. continuation repricing 与 rollback object

治理修复还必须消费：

### 4.1 continuation repricing

1. `continuation_gate`
2. `continuationCount`
3. `pct`
4. `turnTokens`
5. `completionEvent`
6. `diminishing_return_reason`

### 4.2 rollback object

1. `rollback_object`
2. `rewind_files`
3. `baseline_reset_required`
4. `rollback_reason`
5. `re_entry_condition`

这两组对象回答的不是：

- 现在还能不能再跑
- 文件有没有退回去

而是：

- 时间和输出扩张是否已被重新定价
- 当前回退是否仍围绕同一个治理对象发生

## 5. reject escalation：必须共享的升级语义

更成熟的治理宿主修复 escalation 至少应共享下面枚举：

1. `mode_only_authority`
2. `ledger_missing_or_stale`
3. `window_not_authoritative`
4. `context_usage_not_shared`
5. `continuation_gate_defaulted`
6. `rollback_object_missing`
7. `internal_mode_leaked`
8. `baseline_reset_skipped`

这些 escalation reason 的价值在于：

- 把“看起来已经修好了”的治理幻觉压成宿主、CI、评审与交接都能共享的升级语义

## 6. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. runtime internal mode 全集
2. classifier 内部分支
3. 审批弹窗 UI 状态
4. token 百分比单值
5. mode 截图
6. `allow: boolean`
7. append / cancel 的内部重试细节
8. later 补写的 reject 说明

它们可以是修复线索，但不能是修复对象。

## 7. 修复顺序建议

更稳的顺序是：

1. 先验 `authority_repair`
2. 再验 `ledger_rebuild`
3. 再验 `decision_window_reset`
4. 再验 `continuation_repricing`
5. 最后验 `rollback_object`

不要反过来做：

1. 不要先看 mode 面板。
2. 不要先看 token 图表。
3. 不要先看文件回退结果。

## 8. 一句话总结

Claude Code 的治理宿主修复协议，不是 mode 与审批补救 API，而是 `authority repair + ledger rebuild + decision window reset + continuation repricing + rollback object` 共同组成的规则面。
