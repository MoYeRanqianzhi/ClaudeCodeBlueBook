# 治理宿主验收协议：authority source、permission ledger、decision window、continuation gate与rollback object

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象让宿主、SDK、CI 与交接系统验收统一定价控制面。
2. 哪些字段属于必须消费的治理对象，哪些属于 reject 语义，哪些仍然不应被绑定成公共 ABI。
3. 为什么治理验收不应退回 mode 面板、弹窗截图与 token 仪表盘。
4. 宿主开发者该按什么顺序验收这套治理规则面。
5. 哪些现象一旦出现应被直接拒收，而不是继续灰度。

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

- `GovernanceAcceptanceContract`

的单独公共对象。

但治理宿主验收实际上已经能围绕五类正式对象稳定成立：

1. `authority_source`
2. `typed_decision`
3. `pending_permission_ledger`
4. `decision_window`
5. `continuation_gate + rollback_object`

更成熟的验收方式不是：

- 只看当前 mode
- 只看弹窗出现过没有
- 只看 token 百分比

而是：

- 围绕这五类对象消费统一定价控制面是否仍然成立

## 2. authority source：最小验收对象

宿主应至少围绕下面对象验收治理真相：

1. `permission_mode`
2. `settings.sources`
3. `settings.effective`
4. `settings.applied`
5. `externalized_mode`

这些字段回答的不是：

- 当前 UI 显示哪个模式

而是：

- 谁改了边界、当前真正生效的边界是什么、宿主对外应该看到哪个子集

## 3. typed decision 与 permission ledger

治理宿主还必须显式消费：

### 3.1 typed decision

1. `decision`
2. `reason`
3. `request_id`
4. `tool_use_id`

### 3.2 pending permission ledger

1. `pending_permission_requests`
2. `request_id`
3. `tool_use_id`
4. `cancelled`
5. `duplicate_or_orphan_state`

这说明宿主当前消费的不是：

- 一次审批弹窗

而是：

- `typed decision + permission ledger` 共同组成的治理对象

## 4. decision window：不能退回 token 仪表盘

治理验收必须独立消费：

1. `session_state_changed`
2. `status`
3. `pending_action`
4. `ContextData.categories`
5. `deferred`
6. `reserved_buffer`
7. `apiUsage`
8. `autoCompactThreshold`

原因不是：

- 这些图表更好看

而是：

- 当前该不该继续、该不该 compact、该不该升级对象，必须围绕同一窗口判断

## 5. continuation gate 与 rollback object

治理验收还必须消费：

### 5.1 continuation gate

1. `action(continue|stop)`
2. `continuationCount`
3. `pct`
4. `turnTokens`
5. `completionEvent`

### 5.2 rollback object

1. `rollback_object`
2. `rewind_files`
3. `re-entry_condition`
4. `rollback_reason`

这两组对象回答的不是：

- 现在还能不能跑
- 文件有没有回退

而是：

- 时间和输出扩张是否仍被正式 gate 定价
- 当前回退是否仍围绕同一个治理对象

## 6. reject reason：必须共享的拒收语义

更成熟的治理宿主 reject reason 至少应共享下面枚举：

1. `mode_only_authority`
2. `missing_permission_ledger`
3. `duplicate_or_orphan_response`
4. `context_usage_not_shared`
5. `window_not_authoritative`
6. `continuation_gate_defaulted`
7. `rollback_object_missing`
8. `internal_mode_leaked`

这些 reject reason 的价值在于：

- 把“看起来已经接好了”的治理幻觉压成宿主、CI、评审与交接都能共享的拒收语义

## 7. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. runtime internal mode 全集
2. classifier 内部分支
3. prompt 弹窗 UI 状态
4. token 百分比单值
5. 只读 mode 截图
6. `allow: boolean` 单布尔
7. append / cancel 的内部重试细节

它们可以是实现细节，但不能是验收对象。

## 8. 验收顺序建议

更稳的顺序是：

1. 先验 `authority_source`
2. 再验 `typed_decision + permission_ledger`
3. 再验 `decision_window`
4. 再验 `continuation_gate`
5. 最后验 `rollback_object`

不要反过来做：

1. 不要先看 mode 面板。
2. 不要先看 token 图表。
3. 不要先看文件回退结果。

## 9. 一句话总结

Claude Code 的治理宿主验收协议，不是 mode 与弹窗 API，而是 `authority source + permission ledger + decision window + continuation gate + rollback object` 共同组成的规则面。
