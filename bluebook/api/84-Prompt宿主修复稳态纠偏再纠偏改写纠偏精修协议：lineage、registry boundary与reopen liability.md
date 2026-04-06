# Prompt宿主修复稳态纠偏再纠偏改写纠偏精修协议：message lineage witness、registry-boundary covenant、protocol-prefix custody、shared-consumer attestation 与 reopen liability ledger

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象，让宿主、CI、评审与交接在 Prompt rewrite correction 固定顺序已经被钉死之后，继续消费同一条 Prompt 编译链，而不是退回 builder-facing 手册。
2. 哪些字段属于必须共享的宿主消费对象，哪些属于 `hard_reject / reentry / reopen` 语义，哪些仍不应被绑定成公共 ABI。
3. 为什么 Claude Code 的 Prompt 魔力来自同一条 `message lineage -> section registry / stable boundary -> protocol transcript -> continuation object -> continuation qualification` witness order，而不是更会写的 Prompt 文案。
4. 宿主开发者该按什么顺序消费这套 Prompt rewrite correction 精修协议。
5. 哪些现象一旦出现，应被直接升级为 `hard_reject`、`truth_recompile_required`、`registry_reseal_required`、`reentry_required` 或 `reopen_required`，而不是继续宣称 rewrite correction 已经成立。

## 0. 关键源码锚点

- `claude-code-source-code/src/utils/systemPrompt.ts:28-93`
- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:491-560`
- `claude-code-source-code/src/utils/api.ts:321-405`
- `claude-code-source-code/src/services/api/claude.ts:1374-1485`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:483-698`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-66`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/query.ts:1065-1518`
- `claude-code-source-code/src/coordinator/coordinatorMode.ts:207-257`
- `claude-code-source-code/src/tools/AgentTool/prompt.ts:101-112`

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `PromptRewriteCorrectionRefinementContract`

的单独公共对象。

但 Prompt rewrite correction 精修协议已经能围绕十一类正式对象稳定成立：

1. `rewrite_refinement_session_object`
2. `false_projection_demotion_contract`
3. `compiled_request_lineage_covenant`
4. `registry_boundary_rewrite_packet`
5. `coordinator_synthesis_custody`
6. `protocol_prefix_custody`
7. `forgetting_continuation_covenant`
8. `hard_reject_semantics_abi`
9. `shared_consumer_surface_attestation_packet`
10. `reopen_liability_ledger`
11. `rewrite_refinement_verdict`

更成熟的 Prompt rewrite correction 方式不是：

- 只看 rewrite prose 更像制度
- 只看 summary handoff 更完整
- 只看 UI transcript 更安静

本页的 `compiled request lineage / registry-boundary / protocol-prefix / reopen liability` 只是 packet layer，不是新的 Prompt frontdoor chain；真正的前门仍只认 `message lineage -> section registry / stable boundary -> protocol transcript -> continuation object -> continuation qualification`。

而是：

- 围绕这十一类对象继续消费同一个 `compiled request truth`、同一个 `section registry`、同一条 `dynamic boundary`、同一个 `protocol transcript`、同一个 `stable prefix`、同一条 `lawful forgetting boundary`、同一个 `continuation qualification` 与同一个 `threshold liability`

## 2. 第一性原理

Claude Code 的 Prompt 魔力不在文案，而在同一个编译链持续成立：

1. `message lineage` 先定义“later consumer 继承的是不是同一条 request 身份链”。
2. `section registry / stable boundary` 再定义“同一个主线程当前拥有哪些运行时 section，以及哪些 bytes 配进入 stable prefix”。
3. `protocol transcript` 再定义“过程真相如何进入可继续消费的消息链”。
4. `continuation object` 再定义“compact / handoff 之后继续对象究竟挂回哪一条 witness chain”。
5. `continuation qualification` 再定义“什么能继续、什么能反对当前继续”。
6. `compiled request truth / stable prefix / lawful forgetting / threshold liability` 只继续作为这五个 canonical node 的 witness、packet 或 verdict，不重新升格成另一条 frontdoor chain。

所以 Prompt rewrite correction 精修协议真正要保护的不是：

- 一份更会解释的 rewrite correction note

而是：

- 作者退场之后，later 团队仍能围绕同一条 Prompt 编译链恢复、继续、拒收与 reopen

## 3. 会话、降级与 lineage 契约

Prompt 宿主至少应围绕下面对象消费 rewrite correction 精修真相：

### 3.1 rewrite refinement session object

1. `refinement_session_id`
2. `rewrite_correction_session_id`
3. `protocol_generation`
4. `restored_request_object_id`
5. `compiled_request_hash`
6. `truth_lineage_ref`

### 3.2 false projection demotion contract

1. `rewrite_prose_demoted`
2. `ui_transcript_not_truth`
3. `summary_override_blocked`
4. `attachment_premature_binding_blocked`
5. `ungrounded_subagent_output_demoted`

### 3.3 compiled request lineage covenant

1. `restored_request_object_id`
2. `compiled_request_hash`
3. `truth_lineage_ref`
4. `compiled_request_family`
5. `shared_consumer_surface`
6. `request_truth_restituted_at`

这三类对象回答的不是：

- 当前解释稿是不是更完整了

而是：

- 当前到底先降级了哪些假投影，并把哪一条 Prompt truth lineage 重新交还给 later 消费者

## 4. registry、boundary 与 synthesis 托管

Prompt 宿主还必须显式消费：

### 4.1 registry boundary rewrite packet

1. `section_registry_snapshot`
2. `section_registry_generation`
3. `active_section_set`
4. `system_prompt_dynamic_boundary`
5. `late_bound_attachment_set`
6. `attachment_binding_order`
7. `boundary_rebound_at`

### 4.2 coordinator synthesis custody

1. `coordinator_synthesis_owner`
2. `worker_findings_ref`
3. `synthesis_required_before_rebind`
4. `uncompiled_subagent_output_blocked`
5. `constitution_lifecycle_reset_attested`

这里最重要的是：

- `section registry` 不是静态目录
- `dynamic boundary` 不是 attachment 使用说明
- 子 Agent prose 只有在 `coordinator_synthesis_owner` 重新综合后，才有资格进入主线 truth

## 5. protocol、prefix、forgetting 与 continuation 托管

Prompt 宿主还必须显式消费：

### 5.1 protocol prefix custody

1. `protocol_transcript_health`
2. `tool_pairing_health`
3. `transcript_boundary_attested`
4. `stable_prefix_boundary`
5. `prefix_reseal_witness`
6. `cache_break_budget`
7. `cache_break_threshold`

### 5.2 forgetting continuation covenant

1. `lawful_forgetting_boundary`
2. `preserved_segment_ref`
3. `compaction_lineage`
4. `continue_qualification`
5. `token_budget_ready`
6. `rollback_boundary`

这里最重要的是：

- `protocol transcript` 是过程真相，不是阅读体验
- `stable prefix` 与 `lawful forgetting` 不是性能技巧，而是同一条编译链的法律边界
- `continuation qualification` 不成立时，继续只是在消费惯性

## 6. hard reject 语义、跨消费者证明与 reopen 责任账本

Prompt 宿主还必须显式消费：

### 6.1 hard reject semantics abi

1. `hard_reject`
2. `truth_recompile_required`
3. `registry_reseal_required`
4. `boundary_rebind_required`
5. `protocol_repair_required`
6. `prefix_forgetting_reseal_required`
7. `continuation_requalification_required`
8. `reentry_required`
9. `reopen_required`
10. `compiled_request_truth_unrestituted`
11. `section_registry_staticized`
12. `coordinator_synthesis_owner_missing`
13. `late_bound_attachment_misplaced`
14. `tool_pairing_health_failed`
15. `threshold_liability_missing`

### 6.2 shared consumer surface attestation packet

1. `host_consumer_ref`
2. `ci_consumer_ref`
3. `reviewer_consumer_ref`
4. `handoff_consumer_ref`
5. `shared_consumer_surface`
6. `lineage_generation`
7. `boundary_generation`
8. `attested_at`

### 6.3 reopen liability ledger

1. `truth_break_trigger`
2. `threshold_liability_owner`
3. `threshold_retained_until`
4. `reentry_required_when`
5. `reopen_required_when`
6. `liability_scope`
7. `registry_generation_floor`
8. `boundary_generation_floor`
9. `rollback_boundary`
10. `preserved_segment_ref`

这里最重要的是：

- `hard_reject` 保护的是“现在不能继续假装同一条 Prompt truth 仍然成立”
- `shared-consumer attestation` 保护的是“宿主、CI、评审与交接在消费同一条 witness order 的同一组对象”
- `reopen liability ledger` 保护的是“未来仍能正式反对当前 rewrite correction 状态”

## 7. rewrite refinement verdict

Prompt rewrite correction 精修协议还必须消费：

1. `steady_state_chain_resealed`
2. `hard_reject`
3. `reentry_required`
4. `reopen_required`
5. `late_bound_attachment_promoted`
6. `coordinator_synthesis_missing`
7. `threshold_liability_missing`
8. `shared_consumer_surface_broken`
9. `truth_lineage_ref_missing`
10. `protocol_prefix_custody_broken`

这些 verdict reason 的价值在于：

- 把“Prompt 编译链已经从 fixed rewrite correction order 继续压回正式共享对象”翻译成宿主、CI、评审与交接都能共同消费的 reject / escalation 语义

## 8. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. 最后一段 rewrite prose
2. raw UI transcript
3. raw summary 文本
4. 单次 cache break 解释文字
5. attachment 渲染说明
6. 未经 coordinator 综合的子 Agent prose
7. 作者安抚式说明
8. later 团队的主观放心感

它们可以是线索，但不能是 Prompt rewrite correction 精修对象。

## 9. 消费顺序建议

更稳的顺序是：

1. 先验 `rewrite_refinement_session_object`
2. 再验 `false_projection_demotion_contract`
3. 再验 `compiled_request_lineage_covenant`
4. 再验 `registry_boundary_rewrite_packet`
5. 再验 `coordinator_synthesis_custody`
6. 再验 `protocol_prefix_custody`
7. 再验 `forgetting_continuation_covenant`
8. 再验 `hard_reject_semantics_abi`
9. 再验 `shared_consumer_surface_attestation_packet`
10. 最后验 `reopen_liability_ledger`
11. 再给 `rewrite_refinement_verdict`

不要反过来做：

1. 不要先看 rewrite prose 是否更正式。
2. 不要先看 summary 是否更完整。
3. 不要先看 UI transcript 是否更安静。

## 10. 苏格拉底式检查清单

在你准备宣布“Prompt 已完成 rewrite correction 精修协议”前，先问自己：

1. 我现在保住的是同一条 `compiled request truth`，还是一份更会解释的 correction 说明。
2. 我现在保住的是 runtime `section registry`，还是一张更好看的目录表。
3. 我现在保住的是 `dynamic boundary`，还是在偷偷把 late-bound attachment 塞回 stable prefix。
4. 我现在保住的是 `coordinator_synthesis_owner`，还是让子 Agent prose 越权充当主线真相。
5. 我现在保留的是未来继续与未来反对当前状态的正式条件，还是一种“先继续再说”的体面包装。

## 11. 一句话总结

Claude Code 的 Prompt rewrite correction 精修协议，不是把 Prompt 文案写得更像宪法，而是 `compiled_request_lineage_covenant + registry_boundary_rewrite_packet + coordinator_synthesis_custody + protocol_prefix_custody + forgetting_continuation_covenant + hard_reject_semantics_abi + reopen_liability_ledger` 共同组成的共享消费面。
