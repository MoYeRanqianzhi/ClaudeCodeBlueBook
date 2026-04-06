# Prompt宿主修复稳态纠偏再纠偏改写纠偏协议：message lineage restitution、section registry reseal、dynamic boundary rebinding、protocol transcript repair、stable prefix reseal、lawful forgetting reseal、continuation qualification与threshold liability reinstatement

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象，让宿主、SDK、CI、评审与交接系统在 Prompt steady-state recorrection rewrite correction 之后继续消费同一个 `rewrite correction object`、同一套拒收升级语义与长期 `reopen` 责任。
2. 哪些字段属于必须消费的 Prompt steady-state recorrection rewrite correction object，哪些属于 verdict 语义，哪些仍然不应被绑定成公共 ABI。
3. 为什么 Prompt rewrite correction 不应退回 rewrite prose、summary handoff、UI transcript 可读性与默认继续。
4. 宿主开发者该按什么顺序消费这套 Prompt rewrite correction 规则面。
5. 哪些现象一旦出现应被直接升级为 `hard_reject`、`truth_recompile_required`、`boundary_rebind_required`、`reentry_required` 或 `reopen_required`，而不是继续宣称 rewrite correction 已经成立。

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

- `PromptRepairSteadyStateRecorrectionRewriteCorrectionContract`

的单独公共对象。

但 Prompt 宿主修复稳态再纠偏改写纠偏实际上已经能围绕十一类正式对象稳定成立：

1. `rewrite_correction_session_object`
2. `false_rewrite_correction_demotion_set`
3. `message_lineage_restitution`
4. `section_registry_reseal`
5. `dynamic_boundary_rebinding`
6. `protocol_transcript_repair`
7. `stable_prefix_reseal`
8. `lawful_forgetting_reseal`
9. `continuation_qualification`
10. `threshold_liability_reinstatement`
11. `rewrite_correction_verdict`

上面这十一类对象只是 `message lineage -> section registry / stable boundary -> protocol transcript -> continuation object -> continuation qualification` 的展开层；`compiled request truth / stable prefix / lawful forgetting / threshold liability` 只应继续作为这些 canonical node 的 witness、packet 或 verdict，不再自立成第二条 Prompt frontdoor chain。

更成熟的 Prompt rewrite correction 方式不是：

- 只看 rewrite prose 更不像事故说明
- 只看 summary 更礼貌
- 只看 UI transcript 更顺
- 只看默认继续没有再次出事

而是：

- 围绕这十一类对象消费 Prompt 世界怎样把 rewrite correction 继续拉回同一条 `message lineage`、同一个 `section registry`、同一个 `dynamic boundary`、同一个 `protocol transcript`、同一个 `stable prefix`、同一个 `lawful forgetting boundary`、同一个 `continuation qualification` 与同一个 `threshold liability`

这层真正解释的 Prompt 魔力不是：

- “提示词又被修得更像咒语”

而是：

- `section registry` 本身有 runtime 生命周期
- `late-bound attachment` 被明确排除在稳定前缀正文之外
- `protocol transcript` 继续作为过程真相而不是显示真相被消费
- 多 Agent prompt 的强度来自 coordinator 持有 synthesis ownership，而不是子 Agent prose 自动升级成主线真相

## 2. 第一性原理

Prompt 世界真正有魔力，不是因为 rewrite correction prose 更强，而是因为：

1. `system -> developer -> user -> tool` 的顺序先被编译成同一个 request truth。
2. `section registry` 不是静态目录，而是会被 `/compact`、attachment 绑定与角色切换重新清理、重建与续接的 runtime registry。
3. `dynamic boundary` 明确区分了 stable prefix 正文与 late-bound attachment 集。
4. `protocol transcript` 证明的是过程真相，不是阅读体验。
5. `lawful forgetting` 证明的是哪些内容被合法遗忘、哪些内容必须保留，不是 summary 更像总结。
6. `continuation qualification` 与 `threshold liability` 共同保留未来继续与未来反对当前状态的正式条件。

所以宿主当前真正要消费的不是：

- rewrite prose
- raw UI transcript
- summary handoff
- 子 Agent 自述

而是：

- 哪个 request truth 被正式归还
- 哪个 registry 被正式重封
- 哪条 boundary 被正式重绑
- 哪个 transcript / prefix / forgetting / continuation / threshold 仍然可被未来共同消费

## 3. rewrite correction session object 与 false rewrite correction demotion set

宿主应至少围绕下面对象消费 Prompt rewrite correction 真相：

### 3.1 rewrite correction session object

1. `rewrite_correction_session_id`
2. `rewrite_generation`
3. `restored_request_object_id`
4. `registry_generation`
5. `boundary_generation`
6. `rewritten_at`

### 3.2 false rewrite correction demotion set

1. `rewrite_prose_demoted`
2. `ui_transcript_not_truth`
3. `summary_override_blocked`
4. `attachment_premature_binding_blocked`
5. `false_rewrite_correction_frozen_at`

这些字段回答的不是：

- 当前解释稿是不是更完整了

而是：

- 当前到底先降级了哪些假修复投影，才能避免 rewrite correction 还没开始就再次被 prose、UI 与 summary 接管

## 4. compiled request truth restitution 与 section registry reseal

Prompt 宿主还必须显式消费：

### 4.1 compiled request truth restitution

1. `compiled_request_hash`
2. `truth_lineage_ref`
3. `section_registry_snapshot`
4. `request_truth_restituted_at`
5. `shared_consumer_surface`

### 4.2 section registry reseal

1. `section_registry_generation`
2. `active_section_set`
3. `registry_drift_cleared`
4. `coordinator_synthesis_owner`
5. `registry_resealed_at`

这说明宿主当前消费的不是：

- 一段更像正式文档的目录解释

而是：

- `compiled request truth restitution + section registry reseal` 共同组成的 Prompt rewrite correction 对象真相

这里最关键的是：

- `section registry` 不是静态 TOC，而是要继续证明“当前主线程到底由谁综合、哪些 section 仍在、哪些 section 已被合法重编译”的 runtime 对象

## 5. dynamic boundary rebinding 与 protocol transcript repair

Prompt 宿主还必须显式消费：

### 5.1 dynamic boundary rebinding

1. `system_prompt_dynamic_boundary`
2. `late_bound_attachment_set`
3. `attachment_law_demarcated`
4. `attachment_binding_order`
5. `boundary_rebound_at`

### 5.2 protocol transcript repair

1. `protocol_transcript_health`
2. `protocol_rewrite_version`
3. `tool_pairing_health`
4. `transcript_boundary_attested`
5. `protocol_truth_witness`

这里最重要的是：

- `late-bound attachment` 不是 stable prefix 正文
- `protocol transcript` 不是 UI 历史的直接重放
- 子 Agent 产物只有在 `coordinator_synthesis_owner` 之下被重新编译后，才有资格进入主线对象

## 6. stable prefix reseal、lawful forgetting reseal 与 continuation requalification

Prompt 宿主还必须显式消费：

### 6.1 stable prefix reseal

1. `stable_prefix_boundary`
2. `prefix_reseal_witness`
3. `cache_break_budget`
4. `cache_break_threshold`
5. `stable_prefix_resealed_at`

### 6.2 lawful forgetting reseal

1. `lawful_forgetting_boundary`
2. `preserved_segment_ref`
3. `compaction_lineage`
4. `summary_override_blocked`
5. `forgetting_resealed_at`

### 6.3 continuation requalification

1. `continue_qualification`
2. `token_budget_ready`
3. `required_preconditions`
4. `rollback_boundary`
5. `requalification_rebound_at`

这里最重要的是：

- `stable prefix`、`lawful forgetting` 与 `continuation qualification` 不是三种小技巧，而是同一条 Prompt 编译链在 rewrite correction 后仍然能继续工作的共同边界

## 7. threshold liability reinstatement 与 rewrite correction verdict

Prompt rewrite correction 还必须显式消费：

### 7.1 threshold liability reinstatement

1. `truth_break_trigger`
2. `threshold_liability_owner`
3. `threshold_retained_until`
4. `reentry_required_when`
5. `reopen_required_when`

### 7.2 rewrite correction verdict

1. `steady_state_restituted`
2. `hard_reject`
3. `truth_recompile_required`
4. `boundary_rebind_required`
5. `protocol_repair_required`
6. `reentry_required`
7. `reopen_required`
8. `section_registry_unbound`
9. `late_bound_attachment_misplaced`
10. `threshold_liability_missing`

这些 verdict reason 的价值在于：

- 把“Prompt 世界已经从 rewrite correction 层重新压回正式对象”翻译成宿主、CI、评审与交接都能共享的 reject / escalation 语义

## 8. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. 最后一段 rewrite prose
2. raw UI transcript
3. raw summary 文本
4. 单次 cache miss 解释文字
5. attachment 渲染顺序说明
6. 子 Agent 未经 coordinator 综合的 prose
7. 作者安抚式说明
8. later 团队的主观放心感

它们可以是 rewrite correction 线索，但不能是 rewrite correction 对象。

## 9. rewrite correction 消费顺序建议

更稳的顺序是：

1. 先验 `rewrite_correction_session_object`
2. 再验 `false_rewrite_correction_demotion_set`
3. 再验 `compiled_request_truth_restitution`
4. 再验 `section_registry_reseal`
5. 再验 `dynamic_boundary_rebinding`
6. 再验 `protocol_transcript_repair`
7. 再验 `stable_prefix_reseal`
8. 再验 `lawful_forgetting_reseal`
9. 再验 `continuation_requalification`
10. 最后验 `threshold_liability_reinstatement`
11. 再给 `rewrite_correction_verdict`

不要反过来做：

1. 不要先看 rewrite prose 是否更正式。
2. 不要先看 summary 是否更完整。
3. 不要先看 UI transcript 是否更安静。

## 10. 苏格拉底式检查清单

在你准备宣布“Prompt 已完成稳态再纠偏改写纠偏协议”前，先问自己：

1. 我救回的是同一个 `compiled request truth`，还是一份更会解释的 rewrite correction 说明。
2. 我重封的是 runtime `section registry`，还是一张更好看的目录表。
3. 我重新绑定的是 `dynamic boundary`，还是在偷把 late-bound attachment 塞回 stable prefix 正文。
4. 我现在保护的是 `protocol transcript`，还是一段更顺滑的 UI 历史。
5. 我现在保留的是未来继续与未来反对当前状态的正式条件，还是一种“先继续再说”的体面包装。

## 11. 一句话总结

Claude Code 的 Prompt 宿主修复稳态纠偏再纠偏改写纠偏协议，不是把 rewrite correction prose 写得更正式，而是 `compiled request truth restitution + section registry reseal + dynamic boundary rebinding + protocol transcript repair + stable prefix reseal + lawful forgetting reseal + continuation requalification + threshold liability reinstatement` 共同组成的规则面。
