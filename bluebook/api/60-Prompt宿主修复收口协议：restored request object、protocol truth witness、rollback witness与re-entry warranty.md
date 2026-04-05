# Prompt宿主修复收口协议：restored request object、protocol truth witness、rollback witness与re-entry warranty

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象让宿主、SDK、CI、评审与交接系统消费 Prompt 修复纠偏的收口结果。
2. 哪些字段属于必须消费的 Prompt closeout object，哪些属于 closeout verdict 语义，哪些仍然不应被绑定成公共 ABI。
3. 为什么 Prompt 收口协议不应退回事故说明、摘要 handoff 与“看起来又能继续了”。
4. 宿主开发者该按什么顺序消费这套 Prompt 收口规则面。
5. 哪些现象一旦出现应被直接升级为 reopen required 或 handoff blocked，而不是宣布修复完成。

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
- `claude-code-source-code/src/query.ts:1258-1340`

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `PromptRepairCloseoutContract`

的单独公共对象。

但 Prompt 宿主修复收口实际上已经能围绕五类正式对象稳定成立：

1. `restored_request_object`
2. `protocol_truth_witness`
3. `rollback_witness`
4. `re_entry_warranty`
5. `closeout_verdict`

更成熟的修复收口方式不是：

- 只看事故说明
- 只看修复卡填写完了没有
- 只看现在似乎又能继续了

而是：

- 围绕这五类对象消费 Prompt 世界怎样正式回到同一个 `compiled request truth`

## 2. restored request object：最小收口对象

宿主应至少围绕下面对象消费 Prompt 收口真相：

1. `restored_request_object_id`
2. `source_request_object_id`
3. `target_request_object_id`
4. `compiled_request_hash`
5. `section_registry_snapshot`
6. `stable_prefix_boundary`
7. `restoration_generation`

这些字段回答的不是：

- 这次修复说明写得有多完整

而是：

- 当前到底把哪个 request object 恢复成了哪个正式对象边界

## 3. protocol truth witness 与 rollback witness

Prompt 收口还必须显式消费：

### 3.1 protocol truth witness

1. `protocol_transcript_witness`
2. `protocol_rewrite_version`
3. `tool_pairing_health`
4. `truth_boundary_attested`

### 3.2 rollback witness

1. `rollback_object`
2. `rollback_boundary`
3. `lawful_forgetting_witness`
4. `baseline_reset_witness`

这说明宿主当前消费的不是：

- 日志还在
- summary 还能看懂

而是：

- `protocol truth witness + rollback witness` 共同组成的 Prompt 收口对象

## 4. re-entry warranty 与 closeout verdict

Prompt 收口还必须消费：

### 4.1 re-entry warranty

1. `re_entry_warranty`
2. `required_preconditions`
3. `pending_action_ref`
4. `session_state_ready`
5. `retryable_scope`

### 4.2 closeout verdict

1. `closeout_verdict(closed|monitor_only|reopen_required|handoff_blocked)`
2. `verdict_reason`
3. `consumer_readiness(host|ci|review|handoff)`
4. `reopen_trigger`

这两组对象回答的不是：

- 现在还能不能继续点一下
- 这次修复是不是看起来差不多结束了

而是：

- later 到底在什么条件下可以继续进入同一个 Prompt 世界
- 当前修复到底是否已经正式收口

## 5. closeout verdict：必须共享的完成语义

更成熟的 Prompt 宿主收口 verdict 至少应共享下面枚举：

1. `request_object_not_restored`
2. `protocol_witness_missing`
3. `rollback_witness_missing`
4. `summary_only_closeout`
5. `re_entry_not_warranted`
6. `baseline_reset_unproven`
7. `handoff_not_ready`
8. `reopen_required`

这些 verdict reason 的价值在于：

- 把“看起来已经修好了”的 Prompt 幻觉翻译成宿主、CI、评审与交接都能共享的收口语义

## 6. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. 事故复盘叙事
2. raw `systemPrompt` 长字符串
3. raw transcript line count
4. summary 文本
5. 最后一条消息
6. rollback 按钮状态
7. review 自由文本总结
8. 临时恢复 checklist

它们可以是收口线索，但不能是收口对象。

## 7. 收口顺序建议

更稳的顺序是：

1. 先验 `restored_request_object`
2. 再验 `protocol_truth_witness`
3. 再验 `rollback_witness`
4. 再验 `re_entry_warranty`
5. 最后验 `closeout_verdict`

不要反过来做：

1. 不要先看事故总结。
2. 不要先看 summary 可读性。
3. 不要先看“现在似乎又能继续了”。

## 8. 一句话总结

Claude Code 的 Prompt 宿主修复收口协议，不是修复完成说明 API，而是 `restored request object + protocol truth witness + rollback witness + re-entry warranty + closeout verdict` 共同组成的规则面。
