# 如何把Prompt宿主验收执行失真压回compiled request truth：固定纠偏顺序、拒收升级路径与改写模板骨架

这一章不再解释 Prompt 宿主验收执行最常怎样失真，而是把 Claude Code 式 Prompt 执行纠偏压成一张可执行的 builder-facing 手册。

它主要回答五个问题：

1. 为什么 Prompt 执行纠偏真正要救回的不是一张更严格的验收表，而是同一个 `compiled request truth`。
2. 怎样把表单化绿灯、假 reject 与伪 rollback 压回固定纠偏顺序。
3. 哪些现象应被直接升级为硬拒收，而不是继续观察。
4. 怎样把 Prompt 执行卡、reject 升级路径与 rollback 模板重新压回对象级骨架。
5. 怎样用苏格拉底式追问避免把纠偏写成“补几个表单字段”。

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

Prompt 执行纠偏真正要救回的不是：

- 一张更完整的执行卡
- 一套更强硬的 reviewer 话术
- 一份更好读的 rollback 记录

而是：

- 模型与 later 接手者真正继续消费的同一个 `compiled request truth`

所以更稳的纠偏目标不是：

- 先把绿灯做得更可信

而是：

1. 先把表单存在性降回存在性。
2. 先把 `compiled request truth`、`section registry` 与 `stable boundary` 救回正式对象。
3. 先把 `protocol transcript` 从 CI 绿灯与 raw transcript 幻觉里救出来。
4. 先把 lawful forgetting object 从 summary handoff 里救出来。
5. 先把 `continue qualification` 从 reviewer 情绪、`stop_reason` 与最后一条消息里救出来。

## 2. 固定纠偏顺序

### 2.1 先拆掉表单化绿灯

第一步不是改表单，而是降级假通过信号：

1. 禁止“卡片存在”充当通过条件。
2. 禁止“字段齐全”替代对象成立。
3. 禁止“CI 绿灯”替代 protocol truth。

最小恢复对象：

1. `request_object_id`
2. `section_registry_snapshot`
3. `stable_prefix_boundary`
4. `protocol_transcript_health`
5. `lawful_forgetting_object`

### 2.2 再恢复对象级 reject 顺序

第二步要把 reject 从情绪与补写说明拉回：

1. `raw_sysprompt_authority`
2. `missing_section_registry`
3. `boundary_missing_or_reordered`
4. `transcript_repair_required`
5. `summary_only_handoff`
6. `continue_state_inconsistent`

不要继续做的事：

1. 不要先看 token 变贵了没有。
2. 不要先看 reviewer 是否“感觉不稳”。
3. 不要 later 再补写一条 reject reason 冒充现场判定。

### 2.3 再恢复 protocol truth

第三步要修的是：

1. raw history 与 protocol truth 的边界。
2. rewrite 后 transcript 的正式健康度。
3. tool/result pairing 的合法性。

只要这一步没修好，后面的 handoff、continue 与 rollback 都仍会围绕错误历史工作。

### 2.4 再恢复 lawful forgetting

第四步要把 compact handoff 从“可读摘要”拉回：

1. `compact_boundary`
2. `preserved_segment`
3. `next_step`
4. `preserved_assets`

这一步的目标不是更容易读，而是更容易继续。

### 2.5 最后恢复 continue qualification 与 rollback object

最后才修：

1. `continue_qualification`
2. `session_state_changed + pending_action + result envelope`
3. `rollback_object`
4. `re_entry_condition`

不要反过来：

1. 不要先修“继续”按钮，再修 boundary。
2. 不要先回退旧 prompt 文案，再修 request object。
3. 不要先恢复旧摘要，再修 lawful forgetting boundary。

## 3. 硬拒收规则

出现下面情况时，应直接升级为硬拒收：

1. 执行层仍把表单存在性当通过条件。
2. `protocol_transcript_health` 缺席或只剩 raw transcript。
3. compact handoff 仍只剩 summary，不剩 boundary 与 preserved segment。
4. `continue_qualification` 仍由 `stop_reason`、最后一条消息或 reviewer 判断替代。
5. rollback 仍回退到旧 prompt 文案、旧摘要与最后一条消息，而不是对象边界。

## 4. 模板骨架

### 4.1 执行卡骨架

1. `request_object_id`
2. `compiled_request_hash`
3. `section_registry_snapshot`
4. `stable_prefix_boundary`
5. `protocol_transcript_health`
6. `cache_break_reason`
7. `lawful_forgetting_object`
8. `continue_qualification`
9. `reject_reason_code`
10. `consumer_verdict`

### 4.2 拒收升级模板骨架

1. `reject_stage`
2. `reject_reason_code`
3. `authority_gap`
4. `protocol_gap`
5. `handoff_gap`
6. `continue_gap`
7. `escalation_action`

### 4.3 回退模板骨架

1. `rollback_trigger`
2. `rollback_object`
3. `compiled_truth_before`
4. `compiled_truth_after`
5. `lawful_forgetting_before`
6. `re_entry_condition`

## 5. 苏格拉底式检查清单

在你准备宣布“Prompt 执行失真已经纠偏完成”前，先问自己：

1. 我救回的是 `compiled request truth`，还是一张更严的表单。
2. 我现在拒收的是对象边界漂移，还是 reviewer 情绪与 later 补写说明。
3. 我现在消费的是 protocol truth，还是 raw transcript 与 CI 绿灯。
4. 我现在交接的是 lawful forgetting object，还是一段可读故事。
5. 我现在回退的是对象级边界，还是旧 prompt 文案、旧摘要与最后一条消息。

## 6. 一句话总结

真正成熟的 Prompt 执行纠偏，不是把执行卡做得更复杂，而是把表单化绿灯、假 reject 与伪 rollback 重新压回同一个 `compiled request truth`。
