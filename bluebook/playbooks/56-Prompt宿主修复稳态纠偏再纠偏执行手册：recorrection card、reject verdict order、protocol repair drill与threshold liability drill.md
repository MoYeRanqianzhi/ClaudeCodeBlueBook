# Prompt宿主修复稳态纠偏再纠偏执行手册：recorrection card、reject verdict order、protocol repair drill与threshold liability drill

这一章不再解释 Prompt 宿主修复稳态纠偏再纠偏协议该消费哪些字段，而是把 Claude Code 式 Prompt steady-state correction-of-correction protocol 压成一张可持续执行的 `recorrection card`。

它主要回答五个问题：

1. 为什么 Prompt 的魔力在再纠偏执行里运行的不是“system prompt 更完整”，而是同一个 `compiled request truth` 被再次证明仍可继续、可交接、可重开。
2. 宿主、CI、评审与交接怎样共享同一张 Prompt `recorrection card`，而不是各自围绕 correction prose、UI 历史与 summary 平静感工作。
3. 应该按什么固定顺序执行 `compiled request truth restitution`、`protocol transcript repair`、`stable prefix reseal`、`lawful forgetting reseal`、`continuation requalification rebinding` 与 `threshold liability reinstatement`，才能不让假再纠偏重新复活。
4. 哪些 `reject verdict` 一旦出现就必须冻结 continuation、阻断 handoff 并进入 `re-entry / reopen` drill。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“第二套 Prompt 值班表”。

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
- `claude-code-source-code/src/query/tokenBudget.ts:22-92`
- `claude-code-source-code/src/query.ts:1308-1518`

## 1. 第一性原理

Prompt 宿主修复稳态纠偏再纠偏真正要执行的不是：

- system prompt 又写得更像咒语
- UI 历史重新看起来很顺
- summary 又能把当前状态解释圆

而是：

- 同一个 `compiled request truth`、同一个 `stable prefix`、同一个 `protocol transcript`、同一个 `lawful forgetting boundary` 与同一个 `continue qualification` 仍被再次证明可继续、可交接、可反对

所以这层 playbook 最先要看的不是：

- `recorrection card` 已经填完了

而是：

1. 当前 recorrection object 是否仍围绕同一个 `restored_request_object_id + compiled_request_hash`。
2. 当前 `protocol transcript repair` 是否真的把 Prompt 真相从 UI 历史与 prose 解释里救回来。
3. 当前 `stable prefix reseal` 与 `lawful forgetting reseal` 是否真的让 shared prefix 与合法遗忘重新回到正式对象。
4. 当前 `continuation requalification rebinding` 是否真的让 later 团队不再依赖作者补充说明。
5. 当前 `threshold liability reinstatement` 是否仍保留 future reopen 的正式能力。

## 2. 共享 recorrection card 最小字段

每次 Prompt 宿主修复稳态纠偏再纠偏巡检，宿主、CI、评审与交接系统至少应共享：

1. `recorrection_card_id`
2. `steady_correction_object_id`
3. `recorrection_object_id`
4. `restored_request_object_id`
5. `compiled_request_hash`
6. `section_registry_snapshot`
7. `protocol_transcript_health`
8. `stable_prefix_boundary`
9. `lawful_forgetting_boundary`
10. `continue_qualification`
11. `threshold_liability_reinstatement`
12. `reject_verdict`
13. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看 recorrection object 是否仍围绕同一个 `compiled request truth`。
2. CI 看 transcript、prefix、forgetting、qualification 与 threshold 顺序是否完整。
3. 评审看 `reject_verdict` 与对象边界是否仍自洽。
4. 交接看 later 团队能否在不继承作者记忆的前提下继续消费同一 recorrection object。

## 3. 固定 reject verdict 顺序

### 3.1 先验 `recorrection_object`

先看当前准备宣布再纠偏完成的，到底是不是同一个 `recorrection_object_id`，而不是一份更正式的 correction prose。

只要 recorrection object 不清楚，就不能进入 restored。

### 3.2 再验 `compiled request truth restitution`

再看当前 truth 是否真的回到同一个 `restored_request_object_id + compiled_request_hash`，而不是只证明“当前解释讲得更顺了”。

### 3.3 再验 `protocol transcript repair`

再看：

1. `protocol_transcript_health` 是否仍成立。
2. `tool_pairing_health` 是否仍防止 UI transcript 冒充协议真相。
3. `transcript_boundary_attested` 是否仍保证模型消费的是被修复后的 protocol object。

### 3.4 再验 `stable prefix reseal`

再看：

1. `stable_prefix_boundary` 是否仍成立。
2. `cache_break_budget` 与 `compaction_lineage` 是否仍证明 shared prefix 没被重新打碎。
3. 当前 recorrection 是否仍围绕同一份可复用的 prefix asset，而不是围绕一次幸运 cache hit。

### 3.5 再验 `lawful forgetting reseal`

再看：

1. `lawful_forgetting_boundary` 是否仍明确。
2. `preserved_segment_ref` 是否仍让 compact 后的继续链合法。
3. `summary_override_blocked` 是否仍阻止 prose 解释再次偷换对象。

### 3.6 再验 `continuation requalification rebinding`

再看：

1. `continue_qualification` 是否仍然成立。
2. `token_budget_ready` 是否仍支持继续。
3. `required_preconditions` 是否仍让 later 团队可在不脑补的前提下接手。

### 3.7 最后验 `threshold liability reinstatement` 与 `reject_verdict`

最后才看：

1. `truth_break_trigger` 与 `cache_break_threshold` 是否仍正式保留。
2. `reentry_required_when` 与 `reopen_required_when` 是否仍明确。
3. `reject_verdict` 是否与前六步对象完全一致。

更稳的最终 verdict 只应落在：

1. `steady_state_restituted`
2. `hard_reject`
3. `truth_recompile_required`
4. `protocol_repair_required`
5. `reentry_required`
6. `reopen_required`

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前 Prompt recorrection execution：

1. `recorrection_object_missing`
2. `compiled_request_truth_unrestituted`
3. `protocol_transcript_repair_failed`
4. `stable_prefix_reseal_missing`
5. `lawful_forgetting_boundary_missing`
6. `continuation_requalification_unbound`
7. `threshold_liability_missing`
8. `reopen_required`

## 5. re-entry 与 reopen 处理顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先冻结新的 continuation 与 handoff，不再让 later 团队继续消费当前 `recorrection card`。
2. 先把 verdict 降级为 `hard_reject`、`truth_recompile_required`、`protocol_repair_required`、`reentry_required` 或 `reopen_required`。
3. 先把 UI transcript、summary prose 与作者解释降回线索，不再让它们充当 truth object。
4. 先回到上一个仍可验证的 `restored_request_object_id` 或 `stable_prefix_boundary`，补新的 transcript repair、forgetting reseal 与 qualification rebinding。
5. 如果根因落在 recorrection protocol 本身，就回跳 `../api/75` 做对象级修正。

## 6. 最小 drill 集

每轮至少跑下面六个 Prompt 宿主稳态纠偏再纠偏执行演练：

1. `compiled_request_truth_restitution_replay`
2. `protocol_transcript_repair_replay`
3. `stable_prefix_reseal_recheck`
4. `lawful_forgetting_reseal_replay`
5. `continuation_requalification_rebind_replay`
6. `threshold_liability_replay`

## 7. 复盘记录最少字段

每次 Prompt 宿主稳态纠偏再纠偏失败、再入场或 reopen，至少记录：

1. `recorrection_card_id`
2. `recorrection_object_id`
3. `restored_request_object_id`
4. `compiled_request_hash`
5. `protocol_transcript_health`
6. `stable_prefix_boundary`
7. `lawful_forgetting_boundary`
8. `continue_qualification`
9. `threshold_liability_reinstatement`
10. `reject_verdict`
11. `verdict_reason`

## 8. 苏格拉底式检查清单

在你准备宣布“Prompt 已完成稳态纠偏再纠偏执行”前，先问自己：

1. 我救回的是同一个 `compiled request truth`，还是一份更正式的 correction 说明。
2. 我现在保护的是 `protocol transcript`，还是一段看起来更连贯的 UI 历史。
3. 我现在保护的是 `stable prefix` 与 `lawful forgetting`，还是一次暂时没出错的好运气。
4. 我现在恢复的是 `continue qualification`，还是一种“先继续再说”的默认冲动。
5. `threshold liability` 还在不在；如果不在，我是在完成再纠偏，还是在删除未来反对当前状态的能力。

## 9. 一句话总结

真正成熟的 Prompt 宿主修复稳态纠偏再纠偏执行，不是把 Prompt prose 运行得更熟练，而是持续证明同一个 `compiled request truth`、`protocol transcript`、`stable prefix`、`lawful forgetting` 与 `continue qualification` 仍被同一张 `recorrection card` 正式约束。
