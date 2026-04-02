# Prompt宿主修复稳态纠偏再纠偏改写协议：compiled request truth restitution、protocol transcript repair、stable prefix reseal、lawful forgetting reseal、continuation requalification与threshold liability reinstatement

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象让宿主、SDK、CI、评审与交接系统在 Prompt steady-state recorrection rewrite 之后消费同一个修正对象、拒收升级语义与长期 reopen 责任。
2. 哪些字段属于必须消费的 Prompt steady-state recorrection rewrite object，哪些属于 verdict 语义，哪些仍然不应被绑定成公共 ABI。
3. 为什么 Prompt 稳态再纠偏改写协议不应退回 summary 礼貌感、UI transcript 可读性、handoff prose 与默认继续。
4. 宿主开发者该按什么顺序消费这套 Prompt steady-state recorrection rewrite 规则面。
5. 哪些现象一旦出现应被直接升级为 `hard_reject`、`truth_recompile_required`、`protocol_repair_required`、`reentry_required` 或 `reopen_required`，而不是继续宣称 rewrite 已恢复。

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

- `PromptRepairSteadyStateRecorrectionRewriteContract`

的单独公共对象。

但 Prompt 宿主修复稳态再纠偏改写实际上已经能围绕九类正式对象稳定成立：

1. `rewrite_session_object`
2. `false_recorrection_demotion_set`
3. `compiled_request_truth_restitution`
4. `protocol_transcript_repair`
5. `stable_prefix_reseal`
6. `lawful_forgetting_reseal`
7. `continuation_requalification`
8. `threshold_liability_reinstatement`
9. `rewrite_verdict`

更成熟的 Prompt 稳态再纠偏改写方式不是：

- 只看 `recorrection card` 是否更完整
- 只看 summary 是否更礼貌
- 只看 transcript 是否更顺
- 只看 later 团队是否主观觉得还能继续

而是：

- 围绕这九类对象消费 Prompt 世界怎样把 recorrection execution distortion 重新拉回同一个 `compiled request truth`、同一个 `protocol transcript`、同一个 `stable prefix`、同一个 `lawful forgetting boundary`、同一个 `continuation qualification` 与同一个 `threshold liability`

这层真正解释的 Prompt 魔力不是：

- “提示词又被修得更像咒语”

而是：

- 世界先被编译成同一个 request object
- 解释文本被降级成末端投影
- 边界、顺序与拒收优先于文案顺滑
- 继续资格与阈值责任仍保留正式反证能力

## 2. 第一性原理

Prompt 世界真正有魔力，不是因为 prose 更强，而是因为：

1. `system -> developer -> user -> tool` 的顺序先被编译成同一个 request truth。
2. `protocol transcript` 证明的是过程真相，不是阅读体验。
3. `stable prefix` 证明的是共享前缀资产仍然成立，不是“最近 cache 没炸”。
4. `lawful forgetting` 证明的是哪些内容被合法遗忘、哪些内容必须保留，不是 summary 更像总结。
5. `continuation qualification` 与 `threshold liability` 证明的是未来继续与未来反对当前状态的正式条件，不是继续冲动的体面包装。

所以宿主当前真正要消费的不是：

- rewrite prose
- 安静的 UI 历史
- 解释性 handoff

而是：

- 哪个 truth object 被正式归还
- 哪个 transcript 被正式修复
- 哪条 prefix / forgetting 边界被正式重封
- 哪个继续资格与反证阈值被正式保留

## 3. rewrite session object 与 false recorrection demotion set

宿主应至少围绕下面对象消费 Prompt rewrite 真相：

### 3.1 rewrite session object

1. `rewrite_session_id`
2. `recorrection_object_id`
3. `restored_request_object_id`
4. `compiled_request_hash`
5. `rewrite_generation`
6. `rewritten_at`

### 3.2 false recorrection demotion set

1. `demoted_recorrection_refs`
2. `summary_override_blocked`
3. `virtual_output_demoted`
4. `false_recorrection_frozen_at`
5. `requalification_gate_closed_before_truth`

这些字段回答的不是：

- 当前文案是不是重新讲通了

而是：

- 当前到底先降级了哪些假恢复信号，才能避免 rewrite 还没开始就被 prose 再次接管

## 4. compiled request truth restitution 与 protocol transcript repair

Prompt 宿主还必须显式消费：

### 4.1 compiled request truth restitution

1. `section_registry_snapshot`
2. `truth_lineage_ref`
3. `compiled_request_hash`
4. `request_truth_restituted_at`
5. `shared_consumer_surface`

### 4.2 protocol transcript repair

1. `protocol_transcript_health`
2. `protocol_rewrite_version`
3. `tool_pairing_health`
4. `transcript_boundary_attested`
5. `protocol_truth_witness`

这说明宿主当前消费的不是：

- 一段更顺滑的 handoff 历史
- 一份更耐读的 transcript

而是：

- `compiled request truth restitution + protocol transcript repair` 共同组成的 Prompt rewrite 对象真相

## 5. stable prefix reseal、lawful forgetting reseal 与 continuation requalification

Prompt 宿主还必须显式消费：

### 5.1 stable prefix reseal

1. `stable_prefix_boundary`
2. `prefix_reseal_witness`
3. `cache_break_budget`
4. `cache_break_threshold`
5. `stable_prefix_resealed_at`

### 5.2 lawful forgetting reseal

1. `lawful_forgetting_boundary`
2. `preserved_segment_ref`
3. `compaction_lineage`
4. `summary_override_blocked`
5. `forgetting_resealed_at`

### 5.3 continuation requalification

1. `continue_qualification`
2. `token_budget_ready`
3. `required_preconditions`
4. `rollback_boundary`
5. `requalification_rebound_at`

这里最重要的是：

- `stable prefix`、`lawful forgetting` 与 `continuation qualification` 不是三个分散技巧，而是同一条 Prompt 编译链在重写后仍可持续工作的共同边界

## 6. threshold liability reinstatement 与 rewrite verdict

Prompt 稳态再纠偏改写还必须消费：

### 6.1 threshold liability reinstatement

1. `truth_break_trigger`
2. `cache_break_threshold`
3. `threshold_retained_until`
4. `reentry_required_when`
5. `reopen_required_when`

### 6.2 rewrite verdict

1. `steady_state_restituted`
2. `hard_reject`
3. `truth_recompile_required`
4. `protocol_repair_required`
5. `reentry_required`
6. `reopen_required`
7. `lawful_forgetting_boundary_missing`
8. `continue_qualification_unbound`
9. `threshold_liability_missing`

这些 verdict reason 的价值在于：

- 把“Prompt 世界已经从 rewrite 层重新压回正式对象”翻译成宿主、CI、评审与交接都能共享的 reject / escalation 语义

## 7. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. 最后一段 rewrite prose
2. raw UI transcript
3. raw summary 文本
4. 单次 cache miss 解释文字
5. 作者安抚式说明
6. later 团队的主观放心感
7. 单次图表平静截图
8. release 后补写的 prose handoff

它们可以是 rewrite 线索，但不能是 rewrite 对象。

## 8. rewrite 消费顺序建议

更稳的顺序是：

1. 先验 `rewrite_session_object`
2. 再验 `false_recorrection_demotion_set`
3. 再验 `compiled_request_truth_restitution`
4. 再验 `protocol_transcript_repair`
5. 再验 `stable_prefix_reseal`
6. 再验 `lawful_forgetting_reseal`
7. 再验 `continuation_requalification`
8. 最后验 `threshold_liability_reinstatement`
9. 再给 `rewrite_verdict`

不要反过来做：

1. 不要先看 rewrite prose 是否更正式。
2. 不要先看最近是否重新平静。
3. 不要先看 later 团队是否主观觉得还能继续。

## 9. 苏格拉底式检查清单

在你准备宣布“Prompt 已完成稳态再纠偏改写协议”前，先问自己：

1. 我救回的是同一个 `compiled request truth`，还是一份更会安抚人的 rewrite 说明。
2. 我现在保护的是 `protocol transcript`，还是一段更顺滑的 UI 历史。
3. 我现在保护的是 `stable prefix` 与 `lawful forgetting boundary`，还是一份更体面的 summary。
4. 我现在允许的是 `continuation requalification`，还是一种“先继续再说”的默认冲动。
5. `threshold liability` 还在不在；如果不在，我是在做 rewrite，还是在删除未来反对当前状态的能力。

## 10. 一句话总结

Claude Code 的 Prompt 宿主修复稳态纠偏再纠偏改写协议，不是把 rewrite prose 写得更正式，而是 `compiled request truth restitution + protocol transcript repair + stable prefix reseal + lawful forgetting reseal + continuation requalification + threshold liability reinstatement` 共同组成的规则面。
