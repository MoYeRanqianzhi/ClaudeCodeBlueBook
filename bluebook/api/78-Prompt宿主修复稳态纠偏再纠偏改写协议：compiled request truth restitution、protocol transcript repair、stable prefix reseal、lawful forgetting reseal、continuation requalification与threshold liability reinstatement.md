# Prompt宿主修复稳态纠偏再纠偏改写协议：authority restitution、protocol transcript repair、stable prefix reseal、lawful forgetting reseal、continuation requalification 与 threshold liability

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象，让宿主、SDK、CI、评审与交接系统在 Prompt steady-state recorrection rewrite 之后消费同一个修正世界。
2. 哪些字段属于必须消费的 Prompt rewrite object，哪些只属于 carrier、verdict 或 Explainability 投影。
3. 为什么 Prompt 再纠偏改写协议不应退回 summary 礼貌感、UI transcript 可读性、handoff prose 与默认继续。
4. 宿主开发者该按什么顺序消费这套 Prompt rewrite 规则面。
5. 哪些现象一旦出现应被直接升级为 hard reject、recompile、reentry 或 reopen，而不是继续宣称 rewrite 已恢复。

## 0. 第一性原理

Claude Code 当前并没有公开一份名为：

- `PromptRepairSteadyStateRecorrectionRewriteContract`

的单独公共对象。

但 Prompt 宿主修复稳态再纠偏改写，仍应围绕同一条 same-world compiler 母线成立：

1. `Authority`
2. `Boundary`
3. `Transcript`
4. `Lineage`
5. `Continuation`
6. `Explainability`

`rewrite session`、`correction card`、`demotion set`、`rewrite verdict` 都只配当过程壳或末端投影，不能替代这条链。

## 1. Rewrite 先验：哪些内容只配做 carrier

下面这些内容仍可保留，但必须降回 carrier 或 Explainability：

1. `rewrite_session_id`
2. `correction_card_id`
3. `demotion_set_ref`
4. `rewrite_verdict`
5. `handoff prose`
6. `summary prose`

它们的职责不是定义世界，而是说明：

- 这次 rewrite 是怎样被记录、解释和交接的

## 2. 必须消费的 rewrite object

### 2.1 `Authority`

宿主至少应消费：

1. `authority_winner_ref`
2. `restored_request_object_id`
3. `compiled_request_hash`
4. `authority_restituted_at`

### 2.2 `Boundary`

宿主还必须消费：

1. `section_registry_snapshot`
2. `stable_prefix_boundary`
3. `lawful_forgetting_boundary`
4. `cache_break_budget`
5. `boundary_resealed_at`

### 2.3 `Transcript`

宿主还必须消费：

1. `protocol_transcript_ref`
2. `protocol_truth_witness`
3. `tool_pairing_health`
4. `transcript_repaired_at`

### 2.4 `Lineage`

宿主还必须消费：

1. `truth_lineage_ref`
2. `compaction_lineage_ref`
3. `resume_lineage_attested`
4. `lineage_reproof_at`

### 2.5 `Continuation`

宿主还必须消费：

1. `current_work_ref`
2. `required_assets`
3. `rollback_boundary`
4. `continue_qualification`
5. `threshold_liability`
6. `reopen_required_when`

### 2.6 `Explainability`

最后才允许暴露：

1. `rewrite_session_id`
2. `rewrite_verdict`
3. `verdict_reason`
4. `handoff_prose_ref`

## 3. 为什么 `lawful forgetting` 与 `stable prefix` 必须一起被重封

Prompt 世界真正被修回的，不是：

- 一份更会安抚人的 rewrite 说明

而是：

- 哪些字节仍配作为同一世界的前缀
- 哪些内容被合法遗忘而不丢失继续资格

因此 `stable prefix reseal` 与 `lawful forgetting reseal` 不能再被拆成：

- 一份更像样的 summary
- 一次最近没出 cache break 的好运气

它们必须一起证明：

- 世界仍由同一 boundary bundle 约束

## 4. rewrite 消费顺序建议

更稳的顺序是：

1. 先验 `Authority`
2. 再验 `Boundary`
3. 再验 `Transcript`
4. 再验 `Lineage`
5. 再验 `Continuation`
6. 最后才给 `Explainability`

不要反过来做：

1. 不要先看 rewrite prose 是否更正式。
2. 不要先看 transcript 是否更顺。
3. 不要先看 later 团队是否主观觉得还能继续。

## 5. rewrite verdict：必须共享的 reject / escalation 语义

Prompt rewrite 还必须共享下面枚举：

1. `steady_state_restituted`
2. `hard_reject`
3. `truth_recompile_required`
4. `protocol_repair_required`
5. `boundary_reseal_required`
6. `lineage_reproof_required`
7. `reentry_required`
8. `reopen_required`
9. `threshold_liability_missing`

更值得长期复用的 reject trio 仍是：

1. `authority_blur`
2. `transcript_conflation`
3. `continuation_story_only`

## 6. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. 最后一段 rewrite prose
2. raw UI transcript
3. raw summary 文本
4. 单次 cache miss 解释文字
5. 作者安抚式说明
6. later 团队主观放心感
7. 单次图表平静截图
8. release 后补写 prose handoff

它们可以是 Explainability 线索，但不能是 rewrite object。

## 7. 苏格拉底式检查清单

在你准备宣布“Prompt 已完成稳态再纠偏改写协议”前，先问自己：

1. 我救回的是 authority winner，还是一份更会安抚人的 rewrite 说明。
2. 我现在保护的是 protocol transcript，还是一段更顺滑的 UI 历史。
3. 我现在保护的是 stable prefix 与 lawful forgetting boundary，还是一份更体面的 summary。
4. 我现在允许的是 continuation qualification，还是一种“先继续再说”的默认冲动。
5. `threshold liability` 还在不在；如果不在，我是在做 rewrite，还是在删除未来反对当前状态的能力。

## 8. 一句话总结

Claude Code 的 Prompt 宿主修复稳态纠偏再纠偏改写协议，不是把 rewrite prose 写得更正式，而是 `Authority + Boundary + Transcript + Lineage + Continuation` 共同把世界重新编回同一条链，而 `Explainability` 只负责末端解释。
