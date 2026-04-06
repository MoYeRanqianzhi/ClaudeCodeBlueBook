# 治理宿主验收协议：governance key、externalized truth chain、typed ask、decision window 与 continuation pricing

Claude Code 当前没有公开一份单独名为 `GovernanceAcceptanceContract` 的对象，但宿主、SDK、CI 与交接系统已经可以围绕一条更稳的 contract chain 验收统一定价控制面：

1. `governance key`
2. `externalized truth chain`
3. `typed ask`
4. `decision window`
5. `continuation pricing`
6. `rollback / durable-transient cleanup`

旧词在这条链中的位置应固定为：

- `authority source`
  - `governance key` 的 source slot
- `permission ledger`
  - `typed ask` 的事务证据面
- `continuation gate`
  - `continuation pricing` 的 verdict 字段
- `rollback object`
  - cleanup / handoff 的 carrier

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

## 1. 必须消费的 contract 对象

### 1.1 `governance key`

宿主至少应显式消费：

1. `permission_mode`
2. `settings.sources`
3. `settings.effective`
4. `settings.applied`
5. `externalized_mode`

这些字段回答的不是“UI 现在显示哪个模式”，而是：

- 谁改了边界
- 当前真正生效的边界是什么
- 宿主对外应该看到哪个治理投影

### 1.2 `externalized truth chain`

宿主还必须显式消费：

1. `settings.sources / effective / applied`
2. `session_state_changed`
3. `status`
4. `pending_action`
5. `ContextData.categories`
6. `reserved_buffer / apiUsage / autoCompactThreshold`

这些字段共同说明：

- 当前世界边界怎样被外化
- 当前阻塞点、上下文占位与继续压力怎样被同一条链解释

### 1.3 `typed ask`

治理验收必须独立消费：

1. `decision`
2. `reason`
3. `request_id`
4. `tool_use_id`
5. `pending_permission_requests`
6. `cancelled`
7. `duplicate_or_orphan_state`

这说明宿主当前消费的不是“一次审批弹窗”，而是：

- `typed ask + transaction evidence`

### 1.4 `decision window`

治理验收必须把下列字段并排看作同一窗口：

1. `session_state_changed`
2. `status`
3. `pending_action`
4. `ContextData.categories`
5. `deferred`
6. `reserved_buffer`
7. `apiUsage`
8. `autoCompactThreshold`

原因不是这些图表更好看，而是：

- 当前该不该继续、该不该 compact、该不该升级对象，必须围绕同一窗口判断

### 1.5 `continuation pricing`

治理验收还必须消费：

1. `action(continue|stop)`
2. `continuationCount`
3. `pct`
4. `turnTokens`
5. `completionEvent`
6. `diminishing_return_reason`

这里最重要的判断是：

- `continuation gate` 不再独立成根对象；它只是 `continuation pricing` 的一个 verdict。

### 1.6 `rollback / durable-transient cleanup`

最后还必须消费：

1. `rollback_object`
2. `rewind_files`
3. `re_entry_condition`
4. `rollback_reason`
5. `durable_assets_after`
6. `transient_authority_cleared`

这回答的不是“文件有没有回退”，而是：

- 当前回退是否仍围绕同一个治理对象
- 回退之后哪些资产还在，哪些权威必须清掉

## 2. 必须共享的 reject verdict

更成熟的治理宿主 reject verdict 至少应共享下面枚举：

1. `mode_only_authority`
2. `externalized_truth_chain_missing`
3. `typed_ask_collapsed_to_modal`
4. `permission_ledger_missing`
5. `decision_window_unbound`
6. `context_usage_isolated`
7. `continuation_pricing_defaulted`
8. `transient_authority_resumed`
9. `rollback_not_object`
10. `baseline_reset_missing`

这些 reject verdict 的价值在于：

- 把“看起来已经接好了”的治理幻觉压成宿主、CI、评审与交接都能共享的拒收语义

## 3. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. runtime internal mode 全集
2. classifier 内部分支
3. prompt 弹窗 UI 状态
4. token 百分比单值
5. 只读 mode 截图
6. `allow: boolean` 单布尔
7. append / cancel 的内部重试细节

它们可以是实现细节，但不能是验收对象。

## 4. 验收顺序建议

更稳的顺序是：

1. 先验 `governance key`
2. 再验 `externalized truth chain`
3. 再验 `typed ask`
4. 再验 `decision window`
5. 再验 `continuation pricing`
6. 最后验 `rollback / durable-transient cleanup`

不要反过来做：

1. 不要先看 mode 面板。
2. 不要先看 token 图表。
3. 不要先看文件回退结果。

## 5. 一句话总结

Claude Code 的治理宿主验收协议，不是 mode 与弹窗 API，而是 `governance key + externalized truth chain + typed ask + decision window + continuation pricing + rollback / durable-transient cleanup` 共同组成的规则面。
