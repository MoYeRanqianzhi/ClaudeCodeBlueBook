# 如何把Prompt宿主修复监护失真压回message lineage、continuation object与reopen gate：固定纠偏顺序、拒收升级路径与改写模板骨架

这一章不再解释 Prompt 宿主修复监护执行最常怎样失真，而是把 Claude Code 式 Prompt 监护纠偏压成一张可执行的 builder-facing 手册。

它主要回答五个问题：

1. 为什么 Prompt 监护纠偏真正要救回的不是更漂亮的 watch note，而是同一条 `message lineage`、同一个 `continuation object` 与同一条 `reopen gate`。
2. 怎样把假观察、假冻结与假 reopen 压回固定纠偏顺序。
3. 哪些现象应被直接升级为硬拒收，而不是继续观察。
4. 怎样把 watch card、handoff freeze 与 reopen ticket 重新压回对象级骨架。
5. 怎样用苏格拉底式追问避免把纠偏写成“补一份更好的观察总结”。

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

## 1. 第一性原理

Prompt 监护纠偏真正要救回的不是：

- 一份更严谨的 watch note
- 一张更完整的监护卡
- 一条更顺手的 reopen 路径

而是：

- 模型与 later 接手者真正继续消费的同一条 `message lineage`
- display / protocol / handoff 仍围绕这条 lineage 对齐的同一组 projection consumer
- compact、冻结与重开之后仍被共同承认的同一个 `continuation object`

所以更稳的纠偏目标不是：

- 先把 watch 叙事说圆

而是：

1. 先把 `watch_window` 从 closeout note 与观察说明里救出来。
2. 先把 `projection_consumer_alignment` 从 reviewer 注释与 narrative monitoring 里救出来。
3. 先把 `handoff_freeze` 从摘要暂停与提醒语气里救出来。
4. 先把 `reopen_gate` 从按钮状态与旧消息里救出来。
5. 先把 `watch_verdict` 降回结果信号，而不是让它充当主对象。

## 2. 固定纠偏顺序

### 2.1 先冻结假观察

第一步不是改写 watch note，而是冻结假观察信号：

1. 禁止 `watch_verdict=stable_under_watch` 在 `message_lineage_ref` 复核之前生效。
2. 禁止 narrative monitoring 继续替代 `protocol_drift_ledger`。
3. 禁止 closeout note 与 summary handoff 充当 `watch_window` 主对象。

最小恢复对象：

1. `watch_window_id`
2. `message_lineage_ref`
3. `restored_request_object_id`
4. `stable_prefix_boundary`
5. `monitor_only_reason`

### 2.2 再恢复 projection consumer 与 drift ledger

第二步要救回：

1. `projection_consumer_alignment`
2. `protocol_transcript_witness`
3. `lawful_forgetting_witness`
4. `baseline_reset_witness`
5. `drift_events`

不要继续做的事：

1. 不要先看观察说明是不是说得通。
2. 不要先看 compact 后是不是更清爽。
3. 不要先看 reviewer 注释是不是很谨慎。

### 2.3 再恢复 handoff freeze

第三步要把冻结从故事拉回对象：

1. `handoff_watch`
2. `handoff_status`
3. `consumer_readiness_handoff`
4. `required_preconditions`
5. `continuation_object_ref`

这一步的目标不是更容易读，而是更容易阻断错误交接。

### 2.4 再恢复 reopen gate

第四步要把重开从默认行为拉回：

1. `reopen_trigger`
2. `rollback_boundary`
3. `re_entry_warranty`
4. `pending_action_ref`
5. `gate_expires_at`

只要这一步没修好，later 团队就仍会继承一条假连续时间线。

### 2.5 最后恢复 watch 模板

最后才修：

1. `watch_verdict`
2. `drift_reason`
3. `handoff_block_template`
4. `reopen_ticket`

不要反过来：

1. 不要先润色 drift reason，再修 `message_lineage_ref`。
2. 不要先恢复旧 summary，再修 projection consumer 对齐。
3. 不要先让 reopen 可点，再修 `reopen_gate`。

## 3. 硬拒收规则

出现下面情况时，应直接升级为硬拒收：

1. `watch_window` 缺席，或仍主要绑定 closeout note 与 summary。
2. `message_lineage_ref` 缺席，或仍被局部解释字段替代。
3. `projection_consumer_alignment` 缺席，或 display / protocol / handoff 已经分家。
4. `protocol_transcript_witness`、`lawful_forgetting_witness` 与 `baseline_reset_witness` 不再进入正式 drift ledger。
5. `handoff_freeze` 缺席，或 later 仍可继续消费旧摘要而不是 `continuation_object_ref`。
6. `reopen_gate` 缺席，而重开仍由按钮状态、最后一条消息与“现在没报错”决定。
7. `watch_verdict` 先于对象复核生效。
8. `watch_window_expired` 后仍以“先盯着”替代正式 reopen 判定。

## 4. 模板骨架

### 4.1 监护卡骨架

1. `watch_card_id`
2. `watch_window_id`
3. `message_lineage_ref`
4. `projection_consumer_alignment`
5. `protocol_drift_ledger`
6. `handoff_watch`
7. `handoff_status`
8. `continuation_object_ref`
9. `reopen_gate`
10. `watch_deadline`

### 4.2 冻结阻断模板骨架

1. `handoff_freeze_reason`
2. `lineage_gap`
3. `projection_gap`
4. `protocol_gap`
5. `boundary_gap`
6. `reopen_condition`
7. `required_preconditions`

### 4.3 重开工单模板骨架

1. `reopen_trigger`
2. `rollback_boundary`
3. `message_lineage_ref`
4. `re_entry_warranty`
5. `continuation_object_ref`
6. `gate_expires_at`

## 5. 苏格拉底式检查清单

在你准备宣布“Prompt 监护失真已经纠偏完成”前，先问自己：

1. 我救回的是 `message lineage`，还是一份更像正式文件的 watch note。
2. 我现在保护的是 projection consumer 对齐，还是一套更会解释的观察文本。
3. 我现在冻结的是 `continuation object`，还是一段摘要。
4. 我现在重开的是同一真相，还是默认继续。
5. 我现在保护的是 lawful forgetting boundary，还是 compact 之后的舒适感。

## 6. 一句话总结

真正成熟的 Prompt 监护纠偏，不是把 watch card 写得更像运维文档，而是把假观察、假冻结与假 reopen 重新压回同一条 `message lineage`、同一个 `continuation object` 与同一条正式 `reopen gate`。
