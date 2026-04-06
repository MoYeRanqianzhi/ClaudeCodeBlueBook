# 治理宿主验收协议：governance key、externalized truth chain、typed ask、decision window、continuation pricing 与 durable-transient cleanup

Claude Code 当前没有公开一份单独名为 `GovernanceAcceptanceContract` 的对象，但宿主、SDK、CI 与交接系统已经可以围绕一条更稳的 acceptance chain 验收统一定价控制面：

1. `governance key`
2. `externalized truth chain`
3. `typed ask`
4. `decision window`
5. `continuation pricing`
6. `durable-transient cleanup`

旧桥接词在这条链中的位置必须固定：

1. `authority source`
   - 只是 `governance key` 的 source slot。
2. `permission ledger`
   - 只是 `typed ask` 的 transaction evidence。
3. `continuation gate`
   - 只是 `continuation pricing` 的 verdict。
4. `rollback object`
   - 只是 `durable-transient cleanup` 的 carrier。

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

## 1. 第一性原理

治理宿主验收真正要证明的，不是：

- mode 面板还能显示
- 弹窗还能出现
- token 图表还能刷新

而是下面这件事仍然成立：

- 同一个治理对象仍在给边界、当前窗口、继续资格与 cleanup 责任定价

这也是为什么 Claude Code 的安全设计与省 token 设计不能拆开看。只要 `decision window` 与 `continuation pricing` 被拆散，团队就会一边把安全退回审批体验，一边把 token 退回成本仪表盘，最后一起滑向免费继续。

## 2. 必须消费的 contract 对象

### 2.1 `governance key`

宿主至少应显式消费：

1. `permission_mode`
2. `settings.sources`
3. `settings.effective`
4. `settings.applied`
5. `externalized_mode`

这些字段回答的不是“UI 现在显示哪个模式”，而是：

- 谁改了边界
- 当前真正生效的边界是什么
- 当前对外投影是否仍忠于同一治理主键

### 2.2 `externalized truth chain`

宿主还必须显式消费：

1. `settings.sources / effective / applied`
2. `session_state_changed`
3. `status`
4. `pending_action`
5. `ContextData.categories`
6. `reserved_buffer / apiUsage / autoCompactThreshold`

这条链共同说明：

- 当前世界边界怎样被外化
- 当前阻塞点、上下文占位与继续压力怎样被同一条真相链解释

### 2.3 `typed ask`

治理验收必须独立消费：

1. `decision`
2. `reason`
3. `request_id`
4. `tool_use_id`
5. `pending_permission_requests`
6. `cancelled`
7. `duplicate_or_orphan_state`

这里最重要的不是“是否出现 ask”，而是：

- 当前 ask 是否仍是正式事务
- `permission ledger` 是否仍只是该事务的证据面

### 2.4 `decision window`

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

### 2.5 `continuation pricing`

治理验收还必须消费：

1. `action(continue|stop)`
2. `continuationCount`
3. `pct`
4. `turnTokens`
5. `completionEvent`
6. `diminishing_return_reason`

这里最关键的判断是：

- 继续不是默认行为，而是正式收费 verdict
- `continuation gate` 不再独立成根对象；它只是 `continuation pricing` 的一个结果字段

### 2.6 `durable-transient cleanup`

最后还必须消费：

1. `cleanup_carrier`
2. `rewind_files`
3. `re_entry_condition`
4. `rollback_reason`
5. `durable_assets_after`
6. `transient_authority_cleared`

这回答的不是“文件有没有回退”，而是：

- cleanup 是否仍围绕同一个治理对象
- cleanup 之后哪些资产保留，哪些权威必须清掉

## 3. 验收顺序与拒收顺序

更稳的验收顺序是：

1. 先验 `governance key`
2. 再验 `externalized truth chain`
3. 再验 `typed ask`
4. 再验 `decision window`
5. 再验 `continuation pricing`
6. 最后验 `durable-transient cleanup`

更稳的拒收顺序是：

1. 先拒收 `projection_usurpation`
   - mode、弹窗或仪表盘开始替代治理对象。
2. 再拒收 `decision_window_collapse`
   - `pending_action`、状态与 `Context Usage` 不再属于同一窗口。
3. 再拒收 `free_expansion_relapse`
   - continuation 退回“没被阻止就继续”。

不要反过来：

1. 先看 mode 面板。
2. 先看 token 图表。
3. 先看文件回退结果。

## 4. 必须共享的 reject verdict

更成熟的治理宿主 reject verdict 至少应共享下面枚举：

1. `mode_only_authority`
2. `externalized_truth_chain_missing`
3. `typed_ask_collapsed_to_modal`
4. `permission_ledger_missing`
5. `decision_window_unbound`
6. `context_usage_isolated`
7. `continuation_pricing_defaulted`
8. `transient_authority_resumed`
9. `cleanup_not_object`
10. `baseline_reset_missing`

这些 reject verdict 的价值在于：

- 把“看起来已经接好了”的治理幻觉压成宿主、CI、评审与交接都能共享的拒收语义

## 5. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. runtime internal mode 全集
2. classifier 内部分支
3. prompt 弹窗 UI 状态
4. token 百分比单值
5. 只读 mode 截图
6. `allow: boolean` 单布尔
7. append / cancel 的内部重试细节

它们可以是实现细节，但不能是验收对象。

## 6. 苏格拉底式检查清单

在你准备宣布“治理宿主验收已经稳定”前，先问自己：

1. 我保护的是治理对象，还是 mode / modal / dashboard 三件套。
2. `permission ledger` 在这里还是事务证据，还是已经被误读成治理主语。
3. `pending_action` 现在是在解释同一 decision window，还是只剩一句“卡住了”。
4. continuation 是正式 pricing，还是默认继续。
5. cleanup 恢复的是对象边界，还是文件动作。
6. 如果把 modal 和 dashboard 藏起来，团队是否仍知道该如何判断 stop / continue / cleanup。

## 7. 一句话总结

Claude Code 的治理宿主验收协议，不是 mode 与弹窗 API，而是 `governance key + externalized truth chain + typed ask + decision window + continuation pricing + durable-transient cleanup` 共同组成的统一定价规则面。
