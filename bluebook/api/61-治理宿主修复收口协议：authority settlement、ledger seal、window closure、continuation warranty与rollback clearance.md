# 治理宿主修复收口协议：authority settlement、ledger seal、window closure、continuation warranty与rollback clearance

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象让宿主、SDK、CI、评审与交接系统消费治理修复纠偏的收口结果。
2. 哪些字段属于必须消费的治理 closeout object，哪些属于 closeout verdict 语义，哪些仍然不应被绑定成公共 ABI。
3. 为什么治理收口协议不应退回 mode 恢复、审批完成感与 token 图表转绿。
4. 宿主开发者该按什么顺序消费这套治理收口规则面。
5. 哪些现象一旦出现应被直接升级为 reopen required 或 handoff blocked，而不是宣布修复完成。

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

- `GovernanceRepairCloseoutContract`

的单独公共对象。

但治理宿主修复收口实际上已经能围绕五类正式对象稳定成立：

1. `authority_settlement`
2. `ledger_seal`
3. `window_closure`
4. `continuation_warranty`
5. `rollback_clearance`

更成熟的修复收口方式不是：

- 只看 mode 恢复
- 只看审批都点完了
- 只看 token 百分比降下来了

而是：

- 围绕这五类对象消费统一定价控制面怎样正式回到同一个治理对象

## 2. authority settlement：最小收口对象

宿主应至少围绕下面对象消费治理收口真相：

1. `governance_object_id`
2. `authority_source_before`
3. `authority_source_after`
4. `effective_settings_projection`
5. `writer_chokepoint`
6. `settlement_generation`

这些字段回答的不是：

- mode 现在调到了哪里

而是：

- 当前到底把哪个 authority 漂移收口成了哪个正式治理边界

## 3. ledger seal 与 window closure

治理宿主还必须显式消费：

### 3.1 ledger seal

1. `typed_decision`
2. `permission_ledger`
3. `pending_permission_requests`
4. `request_id`
5. `tool_use_id`
6. `duplicate_or_orphan_state_resolved`

### 3.2 window closure

1. `decision_window`
2. `pending_action`
3. `context_usage_snapshot`
4. `reserved_buffer`
5. `window_closed_at`
6. `late_response_quarantined`

这说明宿主当前消费的不是：

- 一次审批补救
- 一张 usage 仪表盘

而是：

- `ledger seal + window closure` 共同组成的治理收口对象

## 4. continuation warranty 与 rollback clearance

治理收口还必须消费：

### 4.1 continuation warranty

1. `continuation_warranty`
2. `continuation_gate`
3. `token_budget_result`
4. `completion_event`
5. `re_entry_condition`

### 4.2 rollback clearance

1. `rollback_object`
2. `baseline_reset_required`
3. `rollback_cleared`
4. `handoff_ready`

这两组对象回答的不是：

- 现在还能不能再跑
- 文件有没有退回去

而是：

- 时间和输出扩张是否已被重新定价并获得正式进入保证
- 当前回退是否已经被正式清算并允许 later 安全接手

## 5. closeout verdict：必须共享的完成语义

更成熟的治理宿主收口 verdict 至少应共享下面枚举：

1. `authority_not_settled`
2. `ledger_not_sealed`
3. `window_not_closed`
4. `continuation_not_warranted`
5. `rollback_not_cleared`
6. `baseline_reset_unproven`
7. `handoff_not_ready`
8. `reopen_required`

这些 verdict reason 的价值在于：

- 把“看起来已经修好了”的治理幻觉压成宿主、CI、评审与交接都能共享的收口语义

## 6. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. runtime internal mode 全集
2. classifier 内部分支
3. 审批弹窗 UI 状态
4. token 百分比单值
5. mode 截图
6. `allow: boolean`
7. append / cancel 的内部重试细节
8. later 补写的完成说明

它们可以是收口线索，但不能是收口对象。

## 7. 收口顺序建议

更稳的顺序是：

1. 先验 `authority_settlement`
2. 再验 `ledger_seal`
3. 再验 `window_closure`
4. 再验 `continuation_warranty`
5. 最后验 `rollback_clearance`

不要反过来做：

1. 不要先看 mode 面板。
2. 不要先看 token 图表。
3. 不要先看文件回退结果。

## 8. 一句话总结

Claude Code 的治理宿主修复收口协议，不是 mode 与审批完成 API，而是 `authority settlement + ledger seal + window closure + continuation warranty + rollback clearance` 共同组成的规则面。
