# Prompt宿主修复稳态纠偏再纠偏改写纠偏精修纠偏协议：authority chain、compiled request lineage、registry-boundary custody、synthesis custody 与 long-term reopen liability

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象，让宿主、CI、评审与交接在 Prompt refinement correction 已被固定之后，继续消费同一条 Prompt 编译链，而不是退回更漂亮的 `host consumption card`。
2. 哪些字段属于必须共享的修正对象，哪些属于 `hard_reject / reentry / reopen` 语义，哪些仍不应被绑定成公共 ABI。
3. 为什么 Claude Code 的 Prompt 魔力来自同一条 `authority chain -> compiled request lineage -> section registry -> dynamic boundary -> synthesis custody -> protocol transcript -> stable prefix -> lawful forgetting -> continuation qualification -> threshold liability`，而不是更会写的 Prompt prose。
4. 宿主开发者该按什么顺序消费这套 Prompt refinement correction 协议。
5. 哪些现象一旦出现，应被直接升级为 `hard_reject`、`truth_recompile_required`、`registry_reseal_required`、`requalification_required` 或 `reopen_required`，而不是继续宣称 refinement correction 已经成立。

## 0. 关键源码锚点

- `claude-code-source-code/src/utils/systemPrompt.ts:28-123`
- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:491-576`
- `claude-code-source-code/src/utils/api.ts:321-405`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/coordinator/coordinatorMode.ts:207-257`
- `claude-code-source-code/src/tools/AgentTool/prompt.ts:101-112`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-66`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:483-698`

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `PromptRefinementCorrectionContract`

的单独公共对象。

但 Prompt refinement correction 已经能围绕十类正式对象稳定成立：

1. `reprotocol_session_object`
2. `prompt_authority_chain`
3. `compiled_request_lineage_contract`
4. `section_registry_custody`
5. `registry_boundary_custody`
6. `synthesis_custody`
7. `protocol_prefix_custody`
8. `forgetting_continuation_covenant`
9. `reject_semantics_packet`
10. `long_horizon_reopen_liability`

更成熟的 Prompt refinement correction 方式不是：

- 只看 rewrite prose 更像制度
- 只看 summary handoff 更完整
- 只看 UI transcript 更安静

而是：

- 围绕这十类对象继续消费同一个 authority chain、同一条 compiled request lineage、同一个 runtime section registry、同一条 dynamic boundary、同一个 synthesis owner、同一条 protocol transcript、同一段 stable prefix、同一个 lawful forgetting boundary、同一个 continuation qualification 与同一个 threshold liability

## 2. 第一性原理

Prompt 世界真正有魔力，不是因为 rewrite correction prose 更强，而是因为：

1. `buildEffectiveSystemPrompt()` 先把 override、coordinator、agent、custom 与 default 的主权顺序钉死。
2. `section registry` 不是静态目录，而是会被 `/clear`、`/compact` 与 late-bound attachment 重新清理、重建与续接的 runtime registry。
3. `dynamic boundary` 明确区分了 stable prefix 正文与 late-bound attachment 集。
4. `coordinator synthesis custody` 明确区分了主线程综合真相与 worker findings 线索。
5. `normalizeMessagesForAPI()` 与 `ensureToolResultPairing()` 证明模型实际消费的是 protocol truth，而不是显示层 transcript。
6. `lawful forgetting + continuation qualification` 决定哪些内容允许复用、哪些内容允许被遗忘、哪些继续仍然合法。
7. `threshold liability` 保留未来反对当前继续状态的正式能力。

所以宿主真正要消费的不是：

- card prose
- raw transcript
- summary handoff
- 未经综合的子 Agent 自述

而是：

- 哪个 authority chain 仍然成立
- 哪条 compiled request lineage 被正式归还
- 哪个 registry/boundary 被正式重封
- 哪个 synthesis/protocol/prefix/forgetting/continuation/liability 仍然能被未来共同消费

## 3. reprotocol session object 与 authority chain

宿主应至少围绕下面对象消费 Prompt refinement correction 真相：

### 3.1 reprotocol session object

1. `reprotocol_session_id`
2. `refinement_session_id`
3. `restored_request_object_id`
4. `reprotocol_generation`
5. `shared_consumer_surface`
6. `reprotocol_started_at`

### 3.2 prompt authority chain

1. `override_system_prompt_present`
2. `coordinator_mode_active`
3. `main_thread_agent_definition`
4. `agent_prompt_mode`
5. `append_system_prompt_present`
6. `authority_chain_attested_at`

这些字段回答的不是：

- 当前 Prompt 说明稿是不是更体面

而是：

- 当前究竟是谁在定义模型世界，以及 later 团队到底能否沿同一条主权链重新消费这个世界

## 4. compiled request lineage 与 registry-boundary 托管

Prompt 宿主还必须显式消费：

### 4.1 compiled request lineage contract

1. `restored_request_object_id`
2. `compiled_request_hash`
3. `truth_lineage_ref`
4. `compiled_request_family`
5. `shared_consumer_surface`
6. `request_truth_restituted_at`

### 4.2 section registry custody

1. `section_registry_snapshot`
2. `section_registry_generation`
3. `active_section_set`
4. `registry_drift_cleared`
5. `constitution_lifecycle_reset_attested`

### 4.3 registry boundary custody

1. `system_prompt_dynamic_boundary`
2. `late_bound_attachment_set`
3. `attachment_binding_order`
4. `late_bound_attachment_excluded_from_prefix`
5. `boundary_rebound_at`

这里最重要的是：

- `compiled request lineage` 不是 handoff packet
- `section registry` 不是静态 TOC
- `dynamic boundary` 不是 attachment 使用说明

## 5. synthesis、protocol 与 prefix 托管

Prompt 宿主还必须显式消费：

### 5.1 synthesis custody

1. `coordinator_synthesis_owner`
2. `worker_findings_ref`
3. `uncompiled_subagent_output_blocked`
4. `self_contained_agent_prompt_attested`
5. `synthesis_required_before_rebind`

### 5.2 protocol prefix custody

1. `protocol_transcript_health`
2. `tool_pairing_health`
3. `transcript_boundary_attested`
4. `stable_prefix_boundary`
5. `prefix_reseal_witness`
6. `cache_break_budget`
7. `cache_break_threshold`
8. `cache_break_reason`

这里最重要的是：

- worker findings 只有在 coordinator 重新综合后，才有资格进入主线 truth
- protocol transcript 证明的是过程真相，不是阅读体验
- stable prefix 是共享前缀资产，不是性能副作用

## 6. lawful forgetting、continuation 与 reject 语义

Prompt 宿主还必须显式消费：

### 6.1 forgetting continuation covenant

1. `lawful_forgetting_boundary`
2. `preserved_segment_ref`
3. `compaction_lineage`
4. `continue_qualification`
5. `token_budget_ready`
6. `rollback_boundary`
7. `diminishing_returns_gate`

### 6.2 reject semantics packet

1. `hard_reject`
2. `truth_recompile_required`
3. `registry_reseal_required`
4. `boundary_rebind_required`
5. `protocol_repair_required`
6. `requalification_required`
7. `reentry_required`
8. `reopen_required`
9. `authority_chain_unbound`
10. `compiled_request_truth_unrestituted`
11. `section_registry_staticized`
12. `late_bound_attachment_promoted`
13. `synthesis_custody_missing`
14. `tool_pairing_unlawful`
15. `stable_prefix_unsealed`
16. `lawful_forgetting_unsealed`
17. `threshold_liability_missing`

这些 reject 语义的价值在于：

- 把“Prompt 编译链已经不能继续被共同消费”翻译成宿主、CI、评审与交接都能共享的拒收语言

## 7. 长期 reopen 责任面

Prompt 宿主还必须长期保留：

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

- `reopen` 保护的不是“以后再看看”
- `threshold` 也不是“当前转绿以后就可以删除”
- later 团队必须还能只凭正式对象独立推翻当前继续资格

## 8. 不应直接绑定成公共 ABI 的内容

宿主不应直接把下面内容绑成长期契约：

1. 最后一段 rewrite prose
2. raw UI transcript
3. raw summary 文本
4. 单次 cache break 解释文字
5. 未经综合的子 Agent prose
6. 作者安抚式说明
7. later 团队的主观放心感

它们可以是线索，但不能是 Prompt refinement correction 协议对象。

## 9. 消费顺序建议

更稳的顺序是：

1. 先验 `reprotocol_session_object`
2. 再验 `prompt_authority_chain`
3. 再验 `compiled_request_lineage_contract`
4. 再验 `section_registry_custody`
5. 再验 `registry_boundary_custody`
6. 再验 `synthesis_custody`
7. 再验 `protocol_prefix_custody`
8. 再验 `forgetting_continuation_covenant`
9. 再验 `reject_semantics_packet`
10. 最后验 `long_horizon_reopen_liability`

不要反过来做：

1. 不要先补 card 再修 authority chain。
2. 不要先让 handoff 更顺，再修 registry/boundary。
3. 不要先让 summary 更完整，再修 synthesis ownership。
4. 不要先让继续更自然，再修 continuation qualification。

## 10. 苏格拉底式检查清单

在你准备宣布“Prompt refinement correction 已经成立”前，先问自己：

1. 我保住的是同一个 authority chain，还是一份更正式的 Prompt 文案。
2. 我恢复的是同一条 compiled request lineage，还是一份更顺手的 handoff。
3. 我保护的是 synthesis ownership，还是把理解再次外包给了 worker prose。
4. 我保留的是 lawful forgetting 与 continuation 资格，还是一种“先继续再说”的默认冲动。
5. 我留住的是 future reopen 的正式能力，还是一句“以后有问题再看”。
