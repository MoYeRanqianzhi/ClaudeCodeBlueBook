# Prompt宿主修复稳态纠偏再纠偏协议：message lineage restitution、protocol transcript repair、lawful forgetting reseal、continuation qualification rebinding与threshold liability reinstatement

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象让宿主、SDK、CI、评审与交接系统在 Prompt steady-state recorrection 之后消费同一个修正对象、拒收升级语义与长期 reopen 责任。
2. 哪些字段属于必须消费的 Prompt steady-state recorrection object，哪些属于 verdict 语义，哪些仍然不应被绑定成公共 ABI。
3. 为什么 Prompt 稳态再纠偏协议不应退回 correction prose、UI 历史、summary 平静感与默认继续。
4. 宿主开发者该按什么顺序消费这套 Prompt steady-state recorrection 规则面。
5. 哪些现象一旦出现应被直接升级为 `hard_reject`、`truth_recompile_required`、`protocol_repair_required`、`reentry_required` 或 `reopen_required`，而不是继续宣称 correction 已恢复。

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

- `PromptRepairSteadyStateRecorrectionContract`

的单独公共对象。

但 Prompt 宿主修复稳态再纠偏实际上已经能围绕八类正式对象稳定成立：

1. `steady_recorrection_object`
2. `message_lineage_restitution`
3. `protocol_transcript_repair`
4. `stable_prefix_reseal`
5. `lawful_forgetting_reseal`
6. `continuation_qualification_rebinding`
7. `threshold_liability_reinstatement`
8. `recorrection_verdict`

更成熟的 Prompt 稳态再纠偏方式不是：

- 只看 correction prose 是否更完整
- 只看最近是否重新平静
- 只看 later 团队是否主观觉得还能继续

而是：

- 围绕这八类对象消费 Prompt 世界怎样把 correction execution distortion 重新拉回同一个 `compiled request truth`、同一个 protocol transcript、同一个 lawful forgetting boundary、同一个 continuation qualification 与同一个 reopen threshold liability

这层真正解释的 Prompt 魔力不是：

- “提示词又被修得更像咒语”

而是：

- request truth 被归还成对象
- transcript 被修回协议真相
- forgetting 被限制成合法遗忘
- continuation 被重新绑回资格
- reopen 被保留成未来反对当前 correction 的正式机制

## 2. steady recorrection object 与 compiled request truth restitution

宿主应至少围绕下面对象消费 Prompt 再纠偏真相：

### 2.1 steady recorrection object

1. `recorrection_object_id`
2. `steady_correction_object_id`
3. `restored_request_object_id`
4. `compiled_request_hash`
5. `recorrection_generation`
6. `recorrected_at`

### 2.2 compiled request truth restitution

1. `section_registry_snapshot`
2. `truth_lineage_ref`
3. `stable_prefix_boundary`
4. `request_truth_restituted_at`
5. `shared_consumer_surface`

这些字段回答的不是：

- 当前文案看起来是不是重新讲通了

而是：

- 当前到底围绕哪个 request object、以哪个 truth lineage 把 correction execution distortion 再次压回正式对象

## 3. protocol transcript repair、stable prefix reseal 与 lawful forgetting reseal

Prompt 宿主还必须显式消费：

### 3.1 protocol transcript repair

1. `protocol_transcript_health`
2. `protocol_rewrite_version`
3. `tool_pairing_health`
4. `transcript_boundary_attested`
5. `virtual_output_demoted`

### 3.2 stable prefix reseal

1. `stable_prefix_boundary`
2. `cache_break_budget`
3. `compaction_lineage`
4. `prefix_recustody_attested`
5. `stable_prefix_resealed_at`

### 3.3 lawful forgetting reseal

1. `lawful_forgetting_boundary`
2. `preserved_segment_ref`
3. `summary_override_blocked`
4. `forgetting_resealed_at`
5. `reactivation_trigger_registered`

这说明宿主当前消费的不是：

- 一段更像样的 summary
- 一次“最近没再出事”的安静感
- 一份更会解释的 correction note

而是：

- `protocol transcript repair + stable prefix reseal + lawful forgetting reseal` 共同组成的 Prompt 稳态再纠偏证明

## 4. continuation requalification rebinding 与 threshold liability reinstatement

Prompt 稳态再纠偏还必须消费：

### 4.1 continuation requalification rebinding

1. `continue_qualification`
2. `token_budget_ready`
3. `required_preconditions`
4. `rollback_boundary`
5. `requalification_rebound_at`

### 4.2 threshold liability reinstatement

1. `truth_break_trigger`
2. `cache_break_threshold`
3. `threshold_retained_until`
4. `reentry_required_when`
5. `reopen_required_when`

这里最重要的是：

- 这些字段不是“现在能不能继续”的情绪表达，而是宿主可消费的时间合同与责任边界

它们回答的不是：

- 大家是不是现在愿意先继续

而是：

- continuation 是否已重新具备正式资格
- correction 一旦再次说谎时该按什么条件回跳
- future reopen 是否仍保留正式 threshold liability

## 5. recorrection verdict：必须共享的再纠偏语义

更成熟的 Prompt 宿主稳态再纠偏 verdict 至少应共享下面枚举：

1. `steady_state_restituted`
2. `hard_reject`
3. `truth_recompile_required`
4. `protocol_repair_required`
5. `reentry_required`
6. `reopen_required`
7. `lawful_forgetting_boundary_missing`
8. `continuation_requalification_unbound`
9. `threshold_liability_missing`

这些 verdict reason 的价值在于：

- 把“Prompt 世界已经从 correction execution distortion 重新压回正式对象”翻译成宿主、CI、评审与交接都能共享的 recorrection 语义

## 6. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. 最后一段 correction prose
2. raw UI transcript
3. raw summary 文本
4. 单次 cache miss 解释文字
5. 作者安抚式说明
6. later 团队的主观放心感
7. 单次图表平静截图
8. release 后补写的 prose handoff

它们可以是再纠偏线索，但不能是再纠偏对象。

## 7. 再纠偏消费顺序建议

更稳的顺序是：

1. 先验 `steady_recorrection_object`
2. 再验 `compiled_request_truth_restitution`
3. 再验 `protocol_transcript_repair`
4. 再验 `stable_prefix_reseal`
5. 再验 `lawful_forgetting_reseal`
6. 再验 `continuation_requalification_rebinding`
7. 最后验 `threshold_liability_reinstatement`
8. 再给 `recorrection_verdict`

不要反过来做：

1. 不要先看 correction prose 是否更正式。
2. 不要先看最近是否重新平静。
3. 不要先看 later 团队是否主观觉得还能继续。

## 8. 苏格拉底式检查清单

在你准备宣布“Prompt 已完成稳态再纠偏”前，先问自己：

1. 我救回的是同一个 `compiled request truth`，还是一份更会安抚人的 correction 说明。
2. 我现在保护的是 `protocol transcript` 与 `lawful forgetting boundary`，还是一段更耐读的 UI 历史与 summary。
3. 我现在允许的是 `continuation requalification rebinding`，还是一种“先继续再说”的惯性。
4. 我现在交接的是 recorrection object，还是 later 仍需脑补的 handoff prose。
5. `threshold liability reinstatement` 还在不在；如果不在，我是在做再纠偏，还是在删除未来反对当前 correction 的能力。

## 9. 一句话总结

Claude Code 的 Prompt 宿主修复稳态纠偏再纠偏协议，不是把 correction prose 写得更正式，而是 `compiled request truth restitution + protocol transcript repair + lawful forgetting reseal + continuation requalification rebinding + threshold liability reinstatement` 共同组成的规则面。
