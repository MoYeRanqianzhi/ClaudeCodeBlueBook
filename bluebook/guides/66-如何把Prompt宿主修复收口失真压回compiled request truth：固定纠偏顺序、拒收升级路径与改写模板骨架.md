# 如何把Prompt宿主修复收口失真压回compiled request truth：固定纠偏顺序、拒收升级路径与改写模板骨架

这一章不再解释 Prompt 宿主修复收口执行最常怎样失真，而是把 Claude Code 式 Prompt 收口纠偏压成一张可执行的 builder-facing 手册。

它主要回答五个问题：

1. 为什么 Prompt 收口纠偏真正要救回的不是更漂亮的 closeout note，而是同一个 `compiled request truth` 与 continuation object。
2. 怎样把假完成、假交接与假 reopen 压回固定纠偏顺序。
3. 哪些现象应被直接升级为硬拒收，而不是继续观察。
4. 怎样把 closeout card、handoff block 与 reopen ticket 重新压回对象级骨架。
5. 怎样用苏格拉底式追问避免把纠偏写成“补一份更好的收口总结”。

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

Prompt 收口纠偏真正要救回的不是：

- 一份更严谨的 closeout 说明
- 一张更完整的收口卡
- 一条更顺手的 reopen 路径

而是：

- 模型与 later 接手者真正继续消费的同一个 `compiled request truth`

所以更稳的纠偏目标不是：

- 先把 closeout 叙事说圆

而是：

1. 先把 `restored_request_object` 从 verdict 与 closeout 文案里救出来。
2. 先把 `protocol_truth_witness` 与 baseline reset 从解释文本里救出来。
3. 先把 `handoff_warranty` 从 summary handoff 里救出来。
4. 先把 `reopen_trigger` 与 `re_entry_warranty` 从按钮状态与旧消息里救出来。
5. 先把 `closeout_verdict` 降回结果信号，而不是让它充当主对象。

## 2. 固定纠偏顺序

### 2.1 先冻结假完成

第一步不是改写 closeout note，而是冻结假完成信号：

1. 禁止 `closeout_verdict=closed` 在 request object 复核之前生效。
2. 禁止 summary-only closeout 继续发放 handoff。
3. 禁止 review 结论替代 source/target request object。

最小恢复对象：

1. `restored_request_object_id`
2. `source_request_object_id`
3. `target_request_object_id`
4. `compiled_request_hash`
5. `section_registry_snapshot`

### 2.2 再恢复 protocol truth 与 baseline reset

第二步要救回：

1. `protocol_transcript_witness`
2. `tool_pairing_health`
3. `rollback_boundary`
4. `lawful_forgetting_witness`
5. `baseline_reset_witness`

不要继续做的事：

1. 不要先看 closeout 解释是不是说得通。
2. 不要先看 compact 后是不是更清爽。
3. 不要先看 cache 似乎又稳定了没有。

### 2.3 再恢复 handoff warranty

第三步要把交接从故事拉回对象：

1. `handoff_warranty`
2. `consumer_readiness.handoff`
3. `required_preconditions`
4. `preserved_segment`

这一步的目标不是更容易读，而是更容易继续。

### 2.4 再恢复 reopen gate

第四步要把重开从默认行为拉回：

1. `reopen_trigger`
2. `re_entry_warranty`
3. `pending_action_ref`
4. `session_state_ready`
5. `retryable_scope`

只要这一步没修好，later 团队就仍会继承一条假连续时间线。

### 2.5 最后恢复 closeout 模板

最后才修：

1. `closeout_verdict`
2. `verdict_reason`
3. `handoff_block_template`
4. `reopen_ticket`

不要反过来：

1. 不要先润色 verdict reason，再修 request object。
2. 不要先恢复旧 summary，再修 lawful forgetting boundary。
3. 不要先让 reopen 可点，再修 `re_entry_warranty`。

## 3. 硬拒收规则

出现下面情况时，应直接升级为硬拒收：

1. `restored_request_object` 缺席，或仍主要绑定 closeout 说明与 summary。
2. `protocol_truth_witness` 缺席，或仍被解释文本替代。
3. `rollback_witness` 缺席，或 rollback 仍回到旧 summary、旧消息与 cache 通过感。
4. `baseline_reset_witness` 缺席，而 compact 后的轻量感仍在充当边界证明。
5. `handoff_warranty` 缺席，或 later 仍只能消费故事、不能消费 continuation object。
6. `re_entry_warranty` 缺席，而 reopen 仍由按钮状态、最后一条消息与“现在没报错”决定。
7. `closeout_verdict` 先于对象复核生效。
8. `summary_only_closeout`、`handoff_not_ready`、`reopen_required` 任一命中后仍继续发放 handoff。

## 4. 模板骨架

### 4.1 收口卡骨架

1. `closeout_card_id`
2. `restored_request_object_id`
3. `compiled_request_hash`
4. `protocol_truth_witness`
5. `rollback_boundary`
6. `lawful_forgetting_witness`
7. `baseline_reset_witness`
8. `handoff_warranty`
9. `re_entry_warranty`
10. `closeout_verdict`

### 4.2 交接阻断模板骨架

1. `handoff_block_reason`
2. `object_gap`
3. `protocol_gap`
4. `rollback_gap`
5. `baseline_gap`
6. `reopen_condition`
7. `required_preconditions`

### 4.3 重开工单模板骨架

1. `reopen_trigger`
2. `rollback_object`
3. `rollback_boundary`
4. `restored_request_object_id`
5. `re_entry_warranty`
6. `pending_action_ref`

## 5. 苏格拉底式检查清单

在你准备宣布“Prompt 收口失真已经纠偏完成”前，先问自己：

1. 我救回的是 `compiled request truth`，还是一份更像正式文件的 closeout note。
2. 我现在保护的是 protocol truth，还是一套更会解释的文本。
3. 我现在交接的是 continuation object，还是一段更精致的故事。
4. 我现在重开的是同一真相，还是默认继续。
5. 我现在保护的是 lawful forgetting boundary，还是 compact 之后的舒适感。

## 6. 一句话总结

真正成熟的 Prompt 收口纠偏，不是把 closeout card 写得更像流程文档，而是把假完成、假交接与假 reopen 重新压回同一个 `compiled request truth`。
