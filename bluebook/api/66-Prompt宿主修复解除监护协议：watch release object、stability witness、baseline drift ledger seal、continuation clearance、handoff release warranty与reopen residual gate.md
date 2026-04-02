# Prompt宿主修复解除监护协议：watch release object、stability witness、baseline drift ledger seal、continuation clearance、handoff release warranty与reopen residual gate

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象让宿主、SDK、CI、评审与交接系统在 Prompt watch correction 之后消费解除监护、稳定释压与 residual reopen。
2. 哪些字段属于必须消费的 Prompt watch release object，哪些属于 release verdict 语义，哪些仍然不应被绑定成公共 ABI。
3. 为什么 Prompt 解除监护协议不应退回 watch note、handoff 文案与“最近没出事”。
4. 宿主开发者该按什么顺序消费这套 Prompt watch release 规则面。
5. 哪些现象一旦出现应被直接升级为 release blocked、monitor extended 或 reopen required，而不是宣布“观察结束”。

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

- `PromptRepairWatchReleaseContract`

的单独公共对象。

但 Prompt 宿主修复解除监护实际上已经能围绕六类正式对象稳定成立：

1. `watch_release_object`
2. `stability_witness`
3. `baseline_drift_ledger_seal`
4. `continuation_clearance`
5. `handoff_release_warranty`
6. `reopen_residual_gate`

更成熟的 Prompt 解除监护方式不是：

- 只看最近没有告警
- 只看 watch note 写得更完整
- 只看 handoff 包似乎还能读

而是：

- 围绕这六类对象消费 Prompt 世界怎样在停止额外监护之后，仍继续围绕同一个 `compiled request truth` 成立

## 2. watch release object：最小解除监护对象

宿主应至少围绕下面对象消费 Prompt 解除监护真相：

1. `release_object_id`
2. `source_watch_window_id`
3. `restored_request_object_id`
4. `compiled_request_hash`
5. `stable_prefix_boundary`
6. `release_scope`
7. `release_evaluated_at`

这些字段回答的不是：

- 最近这一段时间看起来安不安静

而是：

- 当前到底围绕哪个 request object、从哪个 watch window 合法解除额外监护

## 3. stability witness 与 baseline drift ledger seal

Prompt 宿主还必须显式消费：

### 3.1 stability witness

1. `protocol_truth_witness`
2. `lawful_forgetting_witness`
3. `continuation_consistency`
4. `drift_free_span`
5. `stability_attested`

### 3.2 baseline drift ledger seal

1. `baseline_drift_ledger_id`
2. `unresolved_drift_count`
3. `drift_ledger_closed_at`
4. `seal_generation`
5. `narrative_override_blocked`

这说明宿主当前消费的不是：

- 一段更像样的 watch 总结
- 一次“最近没新问题”的运营判断

而是：

- `stability_witness + baseline_drift_ledger_seal` 共同组成的 Prompt 解除监护证明

## 4. continuation clearance、handoff release warranty 与 reopen residual gate

Prompt 解除监护还必须消费：

### 4.1 continuation clearance

1. `required_preconditions`
2. `pending_action_cleared`
3. `continuation_qualification`
4. `session_state_ready`
5. `clearance_expires_at`

### 4.2 handoff release warranty

1. `handoff_package_hash`
2. `consumer_readiness_attested`
3. `continuation_object_attested`
4. `release_without_author_ok`
5. `handoff_release_status`

### 4.3 reopen residual gate

1. `residual_trigger_set`
2. `rollback_boundary`
3. `reopen_liability_record`
4. `gate_retained_until`
5. `reopen_required`

这三组对象回答的不是：

- later 团队是不是现在大概能继续
- 解除监护之后还能不能先试试看

而是：

- continuation 是否已经从“被监护资格”升级成“可继续资格”
- 交接是否已经摆脱原作者记忆
- residual reopen 条件是否仍被正式保留，而不是跟着监护一起遗忘

## 5. release verdict：必须共享的解除监护语义

更成熟的 Prompt 宿主解除监护 verdict 至少应共享下面枚举：

1. `released`
2. `release_blocked`
3. `monitor_extended`
4. `stability_witness_missing`
5. `narrative_release_rejected`
6. `handoff_release_blocked`
7. `residual_gate_retained`
8. `reopen_required`

这些 verdict reason 的价值在于：

- 把“现在可以不盯了”翻译成宿主、CI、评审与交接都能共享的 Prompt post-watch 语义

## 6. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. watch note 长文
2. “无告警时长”单值
3. handoff prose 摘要
4. raw transcript line count
5. compact 后页面长度
6. 最后一条消息文本
7. release 按钮状态
8. reviewer 自由文本安抚

它们可以是解除监护线索，但不能是解除监护对象。

## 7. 解除监护顺序建议

更稳的顺序是：

1. 先验 `watch_release_object`
2. 再验 `stability_witness`
3. 再验 `baseline_drift_ledger_seal`
4. 再验 `continuation_clearance`
5. 再验 `handoff_release_warranty`
6. 最后验 `reopen_residual_gate`

不要反过来做：

1. 不要先看最近是否无事发生。
2. 不要先看 watch note 是否完整。
3. 不要先看 later 团队是否主观放心。

## 8. 一句话总结

Claude Code 的 Prompt 宿主修复解除监护协议，不是观察期结束说明 API，而是 `watch release object + stability witness + baseline drift ledger seal + continuation clearance + handoff release warranty + reopen residual gate` 共同组成的规则面。
