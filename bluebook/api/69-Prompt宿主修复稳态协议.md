# Prompt宿主修复稳态协议：authority winner、boundary bundle、protocol transcript、lineage continuity、continuation qualification 与 reopen threshold

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象，让宿主、SDK、CI、评审与交接系统在 Prompt release correction 之后消费同一个稳态世界。
2. 哪些字段属于必须消费的 Prompt steady-state object，哪些只属于 Explainability 投影。
3. 为什么 Prompt 稳态协议不应退回 summary prose、watch note 与“最近一直很稳”。
4. 宿主开发者该按什么顺序消费这套 Prompt steady-state 规则面。
5. 哪些现象一旦出现应被直接升级为 blocked、recompile、reentry 或 reopen，而不是继续宣称已经稳定。

## 0. 第一性原理

Claude Code 当前并没有公开一份名为：

- `PromptRepairSteadyStateContract`

的单独公共对象。

但 Prompt steady state 实际上已经能围绕同一条 same-world compiler 母线稳定成立：

1. `Authority`
2. `Boundary`
3. `Transcript`
4. `Lineage`
5. `Continuation`
6. `Explainability`

更成熟的 Prompt 稳态方式不是：

- 只看 released 之后最近很平静
- 只看 compact summary 还读得通
- 只看 later 团队表示“应该能继续”

而是：

- 围绕同一个 authority winner、同一个 boundary bundle、同一个 protocol transcript、同一条 lineage chain 与同一组 continuation 条件继续消费世界

## 1. 必须消费的 steady-state object

### 1.1 `Authority`

宿主至少应消费：

1. `authority_winner_ref`
2. `restored_request_object_id`
3. `compiled_request_hash`
4. `authority_attested_at`

### 1.2 `Boundary`

宿主还必须消费：

1. `section_registry_snapshot`
2. `stable_prefix_boundary`
3. `lawful_forgetting_boundary`
4. `cache_break_budget`
5. `boundary_attested_at`

### 1.3 `Transcript`

宿主还必须消费：

1. `protocol_transcript_ref`
2. `tool_pairing_health`
3. `transcript_boundary_attested`
4. `projection_demoted`

### 1.4 `Lineage`

宿主还必须消费：

1. `truth_lineage_ref`
2. `compaction_lineage_ref`
3. `resume_lineage_attested`
4. `lineage_attested_at`

### 1.5 `Continuation`

宿主还必须消费：

1. `current_work_ref`
2. `required_assets`
3. `rollback_boundary`
4. `continue_qualification`
5. `token_budget_ready`
6. `reopen_threshold`

### 1.6 `Explainability`

最后才允许暴露：

1. `steady_state_card_id`
2. `steady_verdict`
3. `verdict_reason`
4. `handoff_prose_ref`

这里最重要的是：

- `card / verdict / prose` 只配当末端解释，不配再做根对象

## 2. 不应直接绑定成公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. 最后一段 compact summary 文案
2. “最近平静时长”单值
3. handoff prose 摘要
4. compact 后页面长度
5. 最后一条消息文本
6. 人工安抚式说明
7. session 标题
8. release 后补写 note

它们可以是 Explainability 线索，但不能是 steady-state object。

## 3. 稳态消费顺序建议

更稳的顺序是：

1. 先验 `Authority`
2. 再验 `Boundary`
3. 再验 `Transcript`
4. 再验 `Lineage`
5. 再验 `Continuation`
6. 最后才给 `Explainability`

不要反过来做：

1. 不要先看 summary 还能不能读。
2. 不要先看最近是否平静。
3. 不要先看 later 团队是否主观放心。

## 4. steady-state verdict：必须共享的稳态语义

更成熟的 Prompt 宿主稳态 verdict 至少应共享下面枚举：

1. `steady_state`
2. `steady_state_blocked`
3. `truth_recompile_required`
4. `boundary_reseal_required`
5. `transcript_repair_required`
6. `lineage_reproof_required`
7. `continuation_unqualified`
8. `reopen_threshold_reached`

更值得长期复用的 reject trio 是：

1. `authority_blur`
2. `transcript_conflation`
3. `continuation_story_only`

## 5. 苏格拉底式检查清单

在你准备宣布“Prompt 已进入稳态”前，先问自己：

1. 我现在保护的是 authority winner，还是一份更耐读的 summary。
2. `Boundary` 保住的是同一前缀与合法遗忘，还是一次暂时没触发 cache break 的好运气。
3. `Transcript` 保护的是模型真实消费的历史，还是一段更顺的 UI 历史。
4. `Continuation` 证明的是继续资格，还是只是大家愿意先继续。
5. `Explainability` 还在不在末端；如果不在，我是在进入稳态，还是在让 prose 重新夺权。

## 6. 一句话总结

Claude Code 的 Prompt 宿主修复稳态协议，不是 release 之后的安静期说明 API，而是 `Authority + Boundary + Transcript + Lineage + Continuation` 共同组成的规则面，而 `Explainability` 只负责末端诚实解释。
