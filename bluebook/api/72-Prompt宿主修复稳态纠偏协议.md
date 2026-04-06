# Prompt宿主修复稳态纠偏协议：truth continuity recovery、stable prefix recustody、baseline dormancy reseal、continuation requalification、handoff continuity repair与reopen threshold reinstatement

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象让宿主、SDK、CI、评审与交接系统在 Prompt steady-state correction 之后消费同一个修正对象、拒收升级语义与长期 reopen 责任。
2. 哪些字段属于必须消费的 Prompt steady-state correction object，哪些属于 verdict 语义，哪些仍然不应被绑定成公共 ABI。
3. 为什么 Prompt 稳态纠偏协议不应退回 steady note、summary prose、平静感与默认继续。
4. 宿主开发者该按什么顺序消费这套 Prompt steady-state correction 规则面。
5. 哪些现象一旦出现应被直接升级为 `hard_reject`、`truth_recompile_required`、`reentry_required` 或 `reopen_required`，而不是继续宣称 steady 已恢复。

## 0. 关键源码锚点

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

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `PromptRepairSteadyStateCorrectionContract`

的单独公共对象。

但 Prompt 宿主修复稳态纠偏实际上已经能围绕八类正式对象稳定成立：

1. `steady_correction_object`
2. `truth_continuity_recovery`
3. `stable_prefix_recustody`
4. `baseline_dormancy_reseal`
5. `continuation_requalification`
6. `handoff_continuity_repair`
7. `threshold_reinstatement`
8. `correction_verdict`

更成熟的 Prompt 稳态纠偏方式不是：

- 只看 steady note 是否更完整
- 只看最近是否重新平静
- 只看 later 团队是否主观觉得还能继续

而是：

- 围绕这八类对象消费 Prompt 世界怎样把假稳态重新拉回同一个 `compiled request truth`、同一个 stable prefix asset、同一个 continuation object 与同一个 reopen threshold

这层真正解释的 Prompt 魔力不是：

- “提示词写得很像咒语”

而是：

- prompt 被编译成对象
- 前缀被托管成资产
- continuation 被压成资格
- reopen 被保留成未来反对当前 steady 的正式机制

## 2. steady correction object 与 truth continuity recovery

宿主应至少围绕下面对象消费 Prompt 纠偏真相：

### 2.1 steady correction object

1. `steady_correction_object_id`
2. `restored_request_object_id`
3. `compiled_request_hash`
4. `correction_generation`
5. `corrected_at`

### 2.2 truth continuity recovery

1. `truth_continuity_attested`
2. `protocol_truth_witness`
3. `truth_lineage_ref`
4. `truth_break_trigger_registered`
5. `truth_recompile_required_when`

这些字段回答的不是：

- 当前文案看起来是不是重新讲通了

而是：

- 当前到底围绕哪个 request object、以哪个 truth lineage 完成了稳态纠偏

## 3. stable prefix recustody 与 baseline dormancy reseal

Prompt 宿主还必须显式消费：

### 3.1 stable prefix recustody

1. `stable_prefix_boundary`
2. `cache_break_budget`
3. `compaction_lineage`
4. `prefix_recustody_attested`
5. `summary_override_blocked`

### 3.2 baseline dormancy reseal

1. `baseline_drift_ledger_id`
2. `sealed_generation`
3. `dormancy_started_at`
4. `dormancy_resealed_at`
5. `reactivation_trigger_registered`

这说明宿主当前消费的不是：

- 一段更像样的 summary
- 一次“最近没再出事”的安静感

而是：

- `stable prefix recustody + baseline dormancy reseal` 共同组成的 Prompt 稳态纠偏证明

## 4. continuation requalification、handoff continuity repair 与 threshold reinstatement

Prompt 稳态纠偏还必须消费：

### 4.1 continuation requalification

1. `continue_qualification`
2. `token_budget_ready`
3. `required_preconditions`
4. `rollback_boundary`
5. `requalification_expires_at`

### 4.2 handoff continuity repair

1. `resume_lineage_attested`
2. `author_memory_not_required`
3. `continuity_warranty_status`
4. `handoff_continuity_repaired_at`
5. `consumer_readiness_attested`

### 4.3 threshold reinstatement

1. `truth_break_trigger`
2. `cache_break_threshold`
3. `threshold_retained_until`
4. `reentry_required_when`
5. `reopen_required_when`

这里最重要的是：

- 这些字段不是“现在能不能继续”的情绪表达，而是宿主可消费的时间合同

它们回答的不是：

- 大家是不是现在愿意先继续

而是：

- continuation 是否已重新具备正式资格
- handoff 是否不再依赖作者临场解释
- future reopen 是否仍保留正式 threshold

## 5. correction verdict：必须共享的纠偏语义

更成熟的 Prompt 宿主稳态纠偏 verdict 至少应共享下面枚举：

1. `steady_state_restored`
2. `hard_reject`
3. `truth_recompile_required`
4. `reentry_required`
5. `reopen_required`
6. `prefix_recustody_missing`
7. `continuation_requalification_failed`
8. `threshold_reinstatement_missing`

这些 verdict reason 的价值在于：

- 把“Prompt 世界已经从假稳态纠偏回正式对象”翻译成宿主、CI、评审与交接都能共享的 correction 语义

## 6. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. 最后一段 steady note prose
2. “最近平静时长”单值
3. compact summary 文案
4. 作者安抚式说明
5. later 团队的主观放心感
6. 单次 cache break 说明文字
7. release 后补写的 prose handoff
8. UI 上的平静感投影

它们可以是纠偏线索，但不能是纠偏对象。

## 7. 纠偏消费顺序建议

更稳的顺序是：

1. 先验 `steady_correction_object`
2. 再验 `truth_continuity_recovery`
3. 再验 `stable_prefix_recustody`
4. 再验 `baseline_dormancy_reseal`
5. 再验 `continuation_requalification`
6. 再验 `handoff_continuity_repair`
7. 最后验 `threshold_reinstatement`
8. 再给 `correction_verdict`

不要反过来做：

1. 不要先看 steady note 是否更正式。
2. 不要先看最近是否重新平静。
3. 不要先看 later 团队是否主观觉得还能继续。

## 8. 苏格拉底式检查清单

在你准备宣布“Prompt 已完成稳态纠偏”前，先问自己：

1. 我救回的是同一个 `compiled request truth`，还是一份更会安抚人的 steady 说明。
2. 我现在保护的是 `stable_prefix_recustody`，还是一次暂时没触发 cache break 的好运气。
3. 我现在允许的是 `continuation_requalification`，还是一种“先继续再说”的惯性。
4. 我现在交接的是 continuity object，还是 later 仍需脑补的 summary 故事。
5. `threshold_reinstatement` 还在不在；如果不在，我是在做稳态纠偏，还是在删除未来反对当前 steady 的能力。

## 9. 一句话总结

Claude Code 的 Prompt 宿主修复稳态纠偏协议，不是把 steady note 写得更正式，而是 `truth continuity recovery + stable prefix recustody + baseline dormancy reseal + continuation requalification + handoff continuity repair + reopen threshold reinstatement` 共同组成的规则面。
