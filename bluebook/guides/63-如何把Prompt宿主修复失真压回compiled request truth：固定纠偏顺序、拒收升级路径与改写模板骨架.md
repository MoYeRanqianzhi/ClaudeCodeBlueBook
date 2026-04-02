# 如何把Prompt宿主修复失真压回compiled request truth：固定纠偏顺序、拒收升级路径与改写模板骨架

这一章不再解释 Prompt 宿主修复演练最常怎样失真，而是把 Claude Code 式 Prompt 修复纠偏压成一张可执行的 builder-facing 手册。

它主要回答五个问题：

1. 为什么 Prompt 修复纠偏真正要救回的不是更完整的事故说明，而是同一个 `compiled request truth`。
2. 怎样把 repair object 伪绑定、摘要回滚与假重入压回固定纠偏顺序。
3. 哪些现象应被直接升级为硬拒收，而不是继续观察。
4. 怎样把 repair card、rollback 模板与 re-entry ticket 重新压回对象级骨架。
5. 怎样用苏格拉底式追问避免把纠偏写成“补一份更好的事故报告”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:343-347`
- `claude-code-source-code/src/utils/api.ts:136-405`
- `claude-code-source-code/src/services/api/claude.ts:1374-1485`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:494-698`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/services/compact/prompt.ts:293-337`
- `claude-code-source-code/src/services/compact/compact.ts:330-711`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-66`
- `claude-code-source-code/src/query/stopHooks.ts:257-331`
- `claude-code-source-code/src/query.ts:1258-1518`
- `claude-code-source-code/src/utils/sessionState.ts:92-146`

## 1. 第一性原理

Prompt 修复纠偏真正要救回的不是：

- 一份更严谨的事故说明
- 一张更完整的 repair card
- 一条更顺手的继续路径

而是：

- 模型与 later 接手者真正继续消费的同一个 `compiled request truth`

所以更稳的纠偏目标不是：

- 先把修复叙事说圆

而是：

1. 先把 repair object 从事故说明、review 结论与摘要故事里救出来。
2. 先把 `compiled request truth`、`section registry` 与 `stable prefix boundary` 救回正式对象。
3. 先把 `protocol transcript` 从 UI 历史与修复解释里救出来。
4. 先把 lawful forgetting object 从 summary shadow 里救出来。
5. 先把 `continue qualification` 从按钮状态、`stop_reason` 与默认继续里救出来。

## 2. 固定纠偏顺序

### 2.1 先降级事故叙事

第一步不是补 repair 说明，而是降级假修复信号：

1. 禁止事故说明充当 `repair_object_id`。
2. 禁止 review 结论替代 source/target request object。
3. 禁止 summary 可读性替代 rollback 前提。

最小恢复对象：

1. `repair_object_id`
2. `source_request_object_id`
3. `target_request_object_id`
4. `compiled_request_hash`
5. `section_registry_snapshot`

### 2.2 再恢复 protocol truth 与 rollback boundary

第二步要救回：

1. `protocol_transcript_boundary`
2. `rollback_object`
3. `rollback_boundary`
4. `rejected_boundary`

不要继续做的事：

1. 不要先看旧 summary 是不是像上一版。
2. 不要先回到最后一条消息。
3. 不要先看 cache 似乎又命中了没有。

### 2.3 再恢复 lawful forgetting

第三步要把 compact handoff 从事故故事拉回：

1. `lawful_forgetting_object`
2. `preserved_segment`
3. `compact_boundary`
4. `required_preconditions`

这一步的目标不是更容易读，而是更容易继续。

### 2.4 再恢复 re-entry gate

第四步要把继续从默认行为拉回：

1. `re_entry_qualification`
2. `session_state_changed`
3. `pending_action_ref`
4. `retryable`

只要这一步没修好，later 团队就仍会继承一条假连续时间线。

### 2.5 最后恢复 repair card 模板

最后才修：

1. `consumer_verdicts`
2. `reject_escalation`
3. `rollback_action`
4. `re_entry_ticket`

不要反过来：

1. 不要先补卡片字段，再修 request object。
2. 不要先恢复旧摘要，再修 lawful forgetting boundary。
3. 不要先让按钮可点，再修 `continue qualification`。

## 3. 硬拒收规则

出现下面情况时，应直接升级为硬拒收：

1. `repair_object_id` 仍主要绑定事故说明、patch 讨论或 summary。
2. `protocol transcript boundary` 缺席，或仍被 UI history 替代。
3. rollback 仍回到旧 summary、旧消息与 cache 通过感，而不是 `rollback_boundary`。
4. compact handoff 仍只剩故事，不剩 lawful forgetting object。
5. `re_entry_qualification` 仍由按钮状态、`stop_reason` 或最后一条消息替代。
6. later 补写 reject reason 仍在替代现场判定。

## 4. 模板骨架

### 4.1 修复卡骨架

1. `repair_object_id`
2. `source_request_object_id`
3. `target_request_object_id`
4. `compiled_request_hash`
5. `section_registry_snapshot`
6. `protocol_transcript_boundary`
7. `lawful_forgetting_object`
8. `rollback_boundary`
9. `re_entry_qualification`
10. `consumer_verdicts`

### 4.2 拒收升级模板骨架

1. `reject_stage`
2. `reject_reason_code`
3. `repair_binding_gap`
4. `protocol_gap`
5. `rollback_gap`
6. `re_entry_gap`
7. `escalation_action`

### 4.3 回滚与重入模板骨架

1. `rollback_trigger`
2. `rollback_object`
3. `rollback_boundary`
4. `lawful_forgetting_before`
5. `re_entry_ticket`
6. `required_preconditions`

## 5. 苏格拉底式检查清单

在你准备宣布“Prompt 修复失真已经纠偏完成”前，先问自己：

1. 我救回的是 `compiled request truth`，还是一份更像正式文件的事故说明。
2. 我现在保护的是 protocol truth，还是修复解释文本。
3. 我现在回退的是对象边界，还是 summary 与最后一条消息。
4. 我现在重入的是同一真相，还是默认继续。
5. 我现在交接的是 continuation object，还是一段更精致的故事。

## 6. 一句话总结

真正成熟的 Prompt 修复纠偏，不是把 repair card 写得更像流程文档，而是把 repair object 伪绑定、摘要回滚与假重入重新压回同一个 `compiled request truth`。
