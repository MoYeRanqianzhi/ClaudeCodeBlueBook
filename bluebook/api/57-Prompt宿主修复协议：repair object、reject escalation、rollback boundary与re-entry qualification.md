# Prompt宿主修复协议：repair object、reject escalation、rollback boundary与re-entry qualification

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象让宿主、SDK、CI、评审与交接系统消费 Prompt 执行纠偏。
2. 哪些字段属于必须消费的 Prompt repair object，哪些属于 reject escalation 语义，哪些仍然不应被绑定成公共 ABI。
3. 为什么 Prompt 修复协议不应退回 reviewer 心法、补字段说明与旧 prompt 文案回退。
4. 宿主开发者该按什么顺序消费这套 Prompt 修复规则面。
5. 哪些现象一旦出现应被直接升级为 hard reject 或 rollback required，而不是继续灰度。

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

- `PromptRepairContract`

的单独公共对象。

但 Prompt 宿主修复实际上已经能围绕四类正式对象稳定成立：

1. `repair_object`
2. `reject_escalation`
3. `rollback_boundary`
4. `re_entry_qualification`

更成熟的修复方式不是：

- 只看 reviewer 说法
- 只看补字段清单
- 只看旧 prompt 文案

而是：

- 围绕这四类对象消费 Prompt 世界怎样恢复成同一个 `compiled request truth`

## 2. repair object：最小修复对象

宿主应至少围绕下面对象消费 Prompt 修复真相：

1. `repair_object_id`
2. `source_request_object_id`
3. `target_request_object_id`
4. `distortion_class(form_green|late_reject|pseudo_rollback|protocol_shadow|summary_shadow)`
5. `section_registry_snapshot`
6. `stable_prefix_boundary`
7. `protocol_transcript_health`
8. `lawful_forgetting_object`
9. `continue_qualification`

这些字段回答的不是：

- 这次补了哪些字段

而是：

- 当前到底在把哪个失真对象修回哪个正式对象边界

## 3. reject escalation：不能退回 reviewer 情绪

Prompt 修复还必须显式消费：

1. `escalation_level(lint_warn|reviewer_gate|hard_reject|rollback_required)`
2. `reject_reason`
3. `rejected_object`
4. `rejected_boundary`
5. `override_allowed`
6. `override_reason`

这说明宿主当前消费的不是：

- reviewer 觉得这轮不太稳

而是：

- `reject_reason + escalation_level` 共同组成的修复升级对象

## 4. rollback boundary：不能退回旧文案与旧摘要

Prompt 修复必须独立消费：

1. `rollback_object`
2. `rollback_boundary`
3. `preserved_segment`
4. `compact_boundary`
5. `protocol_rewrite_version`
6. `baseline_reset_required`

原因不是：

- rollback 字段更完整

而是：

- 当前回退必须仍围绕同一个 request object、lawful forgetting boundary 与 protocol truth 发生

## 5. re-entry qualification：不能退回“再试一下”

Prompt 修复还必须消费：

1. `re_entry_qualification`
2. `continue_decision`
3. `session_state_changed`
4. `pending_action_ref`
5. `retryable`
6. `required_preconditions`

这组对象回答的不是：

- 现在还能不能继续点一下

而是：

- 修复之后 later 到底在什么条件下可以重新进入同一个 Prompt 世界

## 6. reject escalation：必须共享的升级语义

更成熟的 Prompt 宿主修复 escalation 至少应共享下面枚举：

1. `form_only_green`
2. `protocol_truth_shadowed`
3. `late_reason_invention`
4. `rollback_boundary_missing`
5. `summary_reentry_only`
6. `continue_gate_overridden`
7. `baseline_reset_missing`
8. `repair_object_unbound`

这些 escalation reason 的价值在于：

- 把“看起来已经修了”的 Prompt 幻觉翻译成宿主、CI、评审与交接都能共享的升级语义

## 7. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. reviewer 自由文本评论
2. raw `systemPrompt` 长字符串
3. raw transcript line count
4. cache token drop 单值
5. summary text
6. 最后一条消息
7. rollback 按钮状态
8. 临时 patch checklist

它们可以是修复线索，但不能是修复对象。

## 8. 修复顺序建议

更稳的顺序是：

1. 先验 `repair_object`
2. 再验 `reject_escalation`
3. 再验 `rollback_boundary`
4. 最后验 `re_entry_qualification`

不要反过来做：

1. 不要先看 reviewer 总结。
2. 不要先看旧 prompt 文案。
3. 不要先看“现在似乎又能继续了”。

## 9. 一句话总结

Claude Code 的 Prompt 宿主修复协议，不是补字段 API，而是 `repair object + reject escalation + rollback boundary + re-entry qualification` 共同组成的规则面。
