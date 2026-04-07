# Prompt宿主修复稳态纠偏协议：Authority、Boundary、Transcript、Lineage、Continuation 与 threshold reinstatement

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象，让宿主、SDK、CI、评审与交接系统在 Prompt steady-state correction 之后消费同一个修正世界。
2. 哪些字段属于必须消费的 Prompt steady-state correction object，哪些只属于 carrier 或 Explainability 投影。
3. 为什么 Prompt 稳态纠偏协议不应退回 steady note、summary prose、平静感与默认继续。
4. 宿主开发者该按什么顺序消费这套 Prompt steady-state correction 规则面。
5. 哪些现象一旦出现应被直接升级为 `hard_reject`、`truth_recompile_required`、`reentry_required` 或 `reopen_required`，而不是继续宣称 steady 已恢复。

## 0. 第一性原理

这一页不是一个新的 Prompt 对象库存，而是 `66 -> 69 -> 72 -> 78` 这条 same-world compiler 尾段责任线中的“稳态纠偏”一格。

因此它必须继续围绕：

1. `Authority`
2. `Boundary`
3. `Transcript`
4. `Lineage`
5. `Continuation`
6. `Explainability`

只要 `steady note / summary prose / handoff continuity repair` 这些末端词重新站到页首，later maintainer 就会重新先学叙事，再学 compiler。

## 1. 必须消费的 correction object

### 1.1 `Authority`

宿主至少应消费：

1. `authority_winner_ref`
2. `restored_request_object_id`
3. `compiled_request_hash`
4. `correction_generation`
5. `corrected_at`

### 1.2 `Boundary`

宿主还必须消费：

1. `section_registry_snapshot`
2. `stable_prefix_boundary`
3. `lawful_forgetting_boundary`
4. `baseline_dormancy_reseal`
5. `cache_break_budget`

### 1.3 `Transcript`

宿主还必须消费：

1. `protocol_truth_witness`
2. `protocol_transcript_ref`
3. `transcript_boundary_attested`
4. `projection_demoted`

### 1.4 `Lineage`

宿主还必须消费：

1. `truth_lineage_ref`
2. `compaction_lineage_ref`
3. `resume_lineage_attested`
4. `lineage_reproof_at`

### 1.5 `Continuation`

宿主还必须消费：

1. `continuation_requalification`
2. `required_preconditions`
3. `rollback_boundary`
4. `reopen_threshold`
5. `threshold_reinstatement`

### 1.6 `Explainability`

最后才允许暴露：

1. `steady_correction_object_id`
2. `correction_verdict`
3. `verdict_reason`
4. `steady_note_ref`
5. `handoff_prose_ref`

这里最重要的是：

- `steady correction object / verdict / prose` 只配当末端解释，不配再做根对象

## 2. 不应直接绑定为公共 ABI 的对象

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

## 3. 纠偏消费顺序建议

更稳的顺序是：

1. 先验 `Authority`
2. 再验 `Boundary`
3. 再验 `Transcript`
4. 再验 `Lineage`
5. 再验 `Continuation`
6. 最后才给 `Explainability`

不要反过来做：

1. 不要先看 steady note 是否更正式。
2. 不要先看最近是否重新平静。
3. 不要先看 later 团队是否主观觉得还能继续。

## 4. correction verdict：必须共享的纠偏语义

更成熟的 Prompt 宿主稳态纠偏 verdict 至少应共享下面枚举：

1. `steady_state_restored`
2. `hard_reject`
3. `truth_recompile_required`
4. `boundary_reseal_required`
5. `transcript_repair_required`
6. `lineage_reproof_required`
7. `continuation_requalification_failed`
8. `threshold_reinstatement_missing`
9. `reentry_required`
10. `reopen_required`

更值得长期复用的 reject trio 仍是：

1. `authority_blur`
2. `transcript_conflation`
3. `continuation_story_only`

## 5. 苏格拉底式检查清单

在你准备宣布“Prompt 已完成稳态纠偏”前，先问自己：

1. 我救回的是 authority winner，还是一份更会安抚人的 steady 说明。
2. 我现在保护的是 stable prefix 与 lawful forgetting，还是一次暂时没触发 cache break 的好运气。
3. 我现在允许的是 continuation requalification，还是一种“先继续再说”的惯性。
4. 我现在交接的是 same-world compiler 后段对象，还是 later 仍需脑补的摘要故事。
5. `threshold reinstatement` 还在不在；如果不在，我是在做稳态纠偏，还是在删除未来反对当前 steady 的能力。

## 6. 一句话总结

Claude Code 的 Prompt 宿主修复稳态纠偏协议，不是把 steady note 写得更正式，而是 `Authority + Boundary + Transcript + Lineage + Continuation` 共同把世界重新拉回同一条链，而 `Explainability` 只负责末端解释。
