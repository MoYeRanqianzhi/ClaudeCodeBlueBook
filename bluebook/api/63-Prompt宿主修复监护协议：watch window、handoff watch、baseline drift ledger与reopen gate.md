# Prompt宿主修复监护协议：watch window、handoff watch、baseline drift ledger与reopen gate

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象让宿主、SDK、CI、评审与交接系统在 Prompt 收口之后继续消费 watch、handoff 与 reopen。
2. 哪些字段属于必须消费的 Prompt post-closeout watch object，哪些属于 watch verdict 语义，哪些仍然不应被绑定成公共 ABI。
3. 为什么 Prompt 监护协议不应退回 closeout note、summary handoff 与“先观察一下”。
4. 宿主开发者该按什么顺序消费这套 Prompt watch 规则面。
5. 哪些现象一旦出现应被直接升级为 reopen required 或 handoff blocked，而不是继续围绕 closeout note 解释。

## 0. 关键源码锚点

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:343-347`
- `claude-code-source-code/src/utils/api.ts:136-150`
- `claude-code-source-code/src/utils/api.ts:321-405`
- `claude-code-source-code/src/services/api/claude.ts:1374-1485`
- `claude-code-source-code/src/services/api/claude.ts:3218-3236`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:494-698`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/services/compact/prompt.ts:293-337`
- `claude-code-source-code/src/services/compact/compact.ts:330-711`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-66`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1407-1450`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1506-1531`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1735-1747`
- `claude-code-source-code/src/query/stopHooks.ts:257-331`
- `claude-code-source-code/src/query.ts:1258-1518`

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `PromptRepairWatchContract`

的单独公共对象。

但 Prompt 宿主修复监护实际上已经能围绕五类正式对象稳定成立：

1. `watch_window`
2. `continuation_watch`
3. `baseline_drift_ledger`
4. `handoff_watch`
5. `reopen_gate`

更成熟的 Prompt 监护方式不是：

- 只看 closeout note
- 只看 handoff 包还能不能读
- 只看现在似乎还没有出事

而是：

- 围绕这五类对象消费 Prompt 世界怎样在 closeout 之后继续围绕同一个 `compiled request truth` 保持稳定

## 2. watch window：最小监护对象

宿主应至少围绕下面对象消费 Prompt 监护真相：

1. `watch_window_id`
2. `watch_started_at`
3. `watch_deadline`
4. `restored_request_object_id`
5. `compiled_request_hash`
6. `stable_prefix_boundary`
7. `monitor_only_reason`

这些字段回答的不是：

- 这次 closeout 看起来还稳不稳

而是：

- 当前到底围绕哪个 request object 边界继续观察 post-closeout drift

## 3. continuation watch 与 baseline drift ledger

Prompt 宿主还必须显式消费：

### 3.1 continuation watch

1. `required_preconditions`
2. `pending_action_ref`
3. `session_state_ready`
4. `retryable_scope`
5. `continuation_watch_status`

### 3.2 baseline drift ledger

1. `protocol_truth_witness`
2. `lawful_forgetting_witness`
3. `baseline_reset_witness`
4. `protocol_recheck_at`
5. `drift_events`

这说明宿主当前消费的不是：

- 一段 closeout 说明
- 一次 compact 之后的清爽感

而是：

- `continuation_watch + baseline_drift_ledger` 共同组成的 Prompt 监护对象

## 4. handoff watch 与 reopen gate

Prompt 监护还必须消费：

### 4.1 handoff watch

1. `handoff_package_hash`
2. `consumer_readiness_handoff`
3. `continuation_object_attested`
4. `narrative_override_blocked`
5. `handoff_watch_status`

### 4.2 reopen gate

1. `reopen_trigger`
2. `rollback_boundary`
3. `re_entry_warranty`
4. `gate_expires_at`
5. `reopen_required`

这两组对象回答的不是：

- handoff 文本是否足够完整
- later 团队现在还能不能先试试看

而是：

- 交接之后 later 到底是否仍在消费同一个 continuation object
- 当前到底在什么条件下必须正式 reopen 同一个 Prompt 世界

## 5. watch verdict：必须共享的监护语义

更成熟的 Prompt 宿主监护 verdict 至少应共享下面枚举：

1. `stable_under_watch`
2. `protocol_drift_detected`
3. `baseline_drift_detected`
4. `handoff_watch_failed`
5. `reopen_gate_expired`
6. `narrative_override_detected`
7. `handoff_blocked`
8. `reopen_required`

这些 verdict reason 的价值在于：

- 把“现在先观察”翻译成宿主、CI、评审与交接都能共享的 post-closeout 语义

## 6. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. closeout note 长文
2. handoff summary 文本
3. raw transcript line count
4. compact 后页面长度
5. 最后一条消息
6. reopen 按钮状态
7. reviewer 自由文本提醒
8. later 团队的口头补充说明

它们可以是监护线索，但不能是监护对象。

## 7. 监护顺序建议

更稳的顺序是：

1. 先验 `watch_window`
2. 再验 `continuation_watch`
3. 再验 `baseline_drift_ledger`
4. 再验 `handoff_watch`
5. 最后验 `reopen_gate`

不要反过来做：

1. 不要先看 closeout note。
2. 不要先看 summary 是否可读。
3. 不要先看“现在似乎还没有出事”。

## 8. 一句话总结

Claude Code 的 Prompt 宿主修复监护协议，不是 closeout 之后的观察建议 API，而是 `watch window + continuation watch + baseline drift ledger + handoff watch + reopen gate` 共同组成的规则面。
