# Prompt宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修协议：authority chain、protocol truth、repair attestation 与 long-term reopen liability

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象，让宿主、CI、评审与交接在 Prompt refinement correction fixed order 已被钉死之后，继续消费同一条 Prompt repair truth，而不是退回更漂亮的 `repair card`。
2. 哪些字段属于必须共享的 repair 对象，哪些属于共同 `hard_reject / reentry / reopen` 语义，哪些仍不应被绑定成公共 ABI。
3. 为什么 Claude Code 的 Prompt 魔力来自同一条 `authority chain -> compiled request lineage -> protocol truth -> cross-consumer repair attestation -> long-horizon reopen liability`，而不是更会写的 repair prose。
4. 宿主开发者该按什么顺序消费这套 Prompt refinement correction 精修协议。
5. 哪些现象一旦出现，应被直接升级为 `hard_reject`、`protocol_truth_reseal_required`、`repair_attestation_rebuild_required`、`reentry_required` 或 `reopen_required`，而不是继续宣称 refinement correction 已经成立。

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

- `PromptRefinementCorrectionRepairProtocol`

的单独公共对象。

但 Prompt refinement correction fixed order 已经能围绕八类正式对象稳定成立：

1. `repair_session_object`
2. `repair_authority_chain`
3. `compiled_request_lineage_surface`
4. `registry_boundary_repair_surface`
5. `protocol_truth_surface`
6. `cross_consumer_repair_attestation`
7. `shared_reject_semantics_packet`
8. `long_horizon_reopen_liability`

更成熟的 Prompt refinement correction 方式不是：

- 只看 repair prose 更完整
- 只看 handoff packet 更整洁
- 只看 UI transcript 更平静

而是：

- 围绕这八类对象继续消费同一条 authority chain、同一条 compiled request lineage、同一个 runtime registry/boundary、同一条 protocol truth、同一份跨消费者 repair attestation 与同一个 long-horizon reopen liability

## 2. 第一性原理

Prompt 世界真正有魔力，不是因为 repair 说明更强，而是因为：

1. `buildEffectiveSystemPrompt()` 先把 override、coordinator、agent、custom 与 default 的主权顺序钉死。
2. `section registry` 不是静态目录，而是会被 `/clear`、`/compact` 与 late-bound attachment 重新清理、重建与续接的 runtime registry。
3. `dynamic boundary` 明确区分 stable prefix 正文与 late-bound attachment 集。
4. `coordinator synthesis custody` 明确区分主线程综合真相与 worker findings 线索。
5. `normalizeMessagesForAPI()` 与 `ensureToolResultPairing()` 证明模型实际消费的是 protocol truth，而不是显示层 transcript。
6. `lawful forgetting + continuation qualification` 决定哪些内容允许复用、哪些内容允许被遗忘、哪些继续仍然合法。
7. `promptCacheBreakDetection` 把断链原因外化为可解释对象，而不是留给后来者猜测。

所以宿主真正要消费的不是：

- 最后一版 repair prose
- raw UI transcript
- summary handoff
- 未经综合的子 Agent 自述

而是：

- 哪个 authority chain 仍然成立
- 哪条 compiled request lineage 被正式归还
- 哪个 registry/boundary 被正式重封
- 哪个 protocol truth 仍能被跨消费者共同消费
- 哪个 reopen liability 仍保留 future 反对当前继续状态的能力

## 3. repair session object 与 authority chain

Prompt 宿主应至少围绕下面对象消费 refinement correction 真相：

### 3.1 repair session object

1. `repair_session_id`
2. `reprotocol_session_id`
3. `refinement_session_id`
4. `restored_request_object_id`
5. `repair_generation`
6. `shared_consumer_surface`
7. `repair_started_at`

### 3.2 repair authority chain

1. `override_system_prompt_present`
2. `coordinator_mode_active`
3. `main_thread_agent_definition`
4. `agent_prompt_mode`
5. `append_system_prompt_present`
6. `authority_chain_attested_at`

这些字段回答的不是：

- 当前 repair card 看起来是不是更体面

而是：

- 当前究竟是谁在定义模型世界，以及 later 团队到底能否沿同一条主权链重新消费这个世界

## 4. compiled request lineage 与 protocol truth surface

Prompt 宿主还必须显式消费：

### 4.1 compiled request lineage surface

1. `restored_request_object_id`
2. `compiled_request_hash`
3. `truth_lineage_ref`
4. `compiled_request_family`
5. `shared_consumer_surface`
6. `request_truth_restituted_at`

### 4.2 registry boundary repair surface

1. `section_registry_snapshot`
2. `section_registry_generation`
3. `active_section_set`
4. `system_prompt_dynamic_boundary`
5. `late_bound_attachment_set`
6. `attachment_binding_order`
7. `registry_boundary_repair_attested`

### 4.3 protocol truth surface

1. `coordinator_synthesis_owner`
2. `worker_findings_ref`
3. `protocol_transcript_health`
4. `tool_pairing_health`
5. `transcript_boundary_attested`
6. `stable_prefix_boundary`
7. `lawful_forgetting_boundary`
8. `continue_qualification`
9. `token_budget_ready`

这里最重要的是：

- `compiled request lineage` 不是 handoff packet
- `section registry` 不是静态 TOC
- `protocol truth` 不是 UI 阅读体验
- `continue qualification` 不是“先继续再说”

## 5. cross-consumer repair attestation

Prompt 宿主、CI、评审与交接还必须共享一份可跨 compact、可跨 continuation、也可跨多 Agent 接手的 repair 对象：

1. `repair_attestation_id`
2. `protocol_version`
3. `phase`
4. `source_kind`
5. `source_ref`
6. `target_kind`
7. `target_ref`
8. `intent_delta`
9. `evidence_refs`
10. `repair_directive`
11. `verification_gate`
12. `repair_ops`
13. `synthetic`
14. `tainted`
15. `compaction_safe_summary`
16. `budget_state`
17. `authority_chain_ref`
18. `compiled_request_lineage_ref`
19. `registry_boundary_repair_ref`
20. `protocol_truth_surface_ref`
21. `synthesis_custody_attested`
22. `consumer_projection_demoted`
23. `repair_attested_at`

这里的固定序列化顺序也应固定为：

1. `envelope(source/target/phase)`
2. `intent_delta`
3. `evidence_refs`
4. `repair_directive`
5. `verification_gate`
6. `repair_ops`
7. `synthetic/tainted`
8. `compaction_safe_summary`
9. `budget_state`

四类消费者的分工应固定为：

1. 宿主看 authority chain、compiled request lineage 与 synthesis owner 是否仍唯一。
2. CI 看 registry、boundary、protocol、prefix、forgetting 与 qualification 顺序是否完整。
3. 评审看 `reject_verdict` 是否仍围绕同一个 Prompt 编译对象，而不是围绕 repair prose 与 UI 历史。
4. 交接看 later 团队能否在不继承作者记忆的前提下只凭 repair 对象继续消费同一条编译链。

## 6. shared reject semantics 与长期 reopen 责任面

Prompt 宿主还必须显式消费：

### 6.1 shared reject semantics packet

1. `hard_reject`
2. `authority_chain_unbound`
3. `compiled_request_truth_unrestituted`
4. `protocol_truth_reseal_required`
5. `registry_boundary_repair_required`
6. `synthesis_recustody_required`
7. `requalification_required`
8. `repair_attestation_rebuild_required`
9. `reentry_required`
10. `reopen_required`

### 6.2 long horizon reopen liability

1. `truth_break_trigger`
2. `threshold_liability_owner`
3. `threshold_retained_until`
4. `reentry_required_when`
5. `reopen_required_when`
6. `liability_scope`
7. `rollback_boundary`
8. `preserved_segment_ref`

这里最重要的是：

- `reopen` 保护的不是“以后再看看”
- `threshold` 也不是“当前转绿以后就可以删除”
- later 团队必须还能只凭正式对象独立推翻当前继续资格
- budget-continuation path 看不到 attachment，所以任何协议关键字段都不能只靠 attachment lane 注入，必须进 dynamic section 或 durable message lane。

## 7. 不应直接绑定成公共 ABI 的内容

宿主不应直接把下面内容绑成长期契约：

1. 最后一段 repair prose
2. raw UI transcript
3. raw summary 文本
4. 单次 cache break 解释文字
5. 未经综合的子 Agent prose
6. 作者安抚式说明
7. later 团队的主观放心感
8. 只存在于 static/global prompt prefix 的 repair delta

只允许无语义发明的 lossless repair 进入协议对象：

1. `reorder_attachments`
2. `hoist_tool_results`
3. `wrap_system_reminder`
4. `strip_orphaned_tool_result`
5. `dedupe_tool_use`
6. `sanitize_error_tool_result`

而下面这些必须被判为更高等级拒收：

1. `insert_synthetic_tool_result`
2. `source_kind` 无法区分真人输入与 `<task-notification> / <system-reminder>`
3. `target_ref` 不能解析到现存 `task_id / message.id / tool_use_id / uuid`
4. repair 对象只存在于 attachment lane，却要求在 budget continuation 或 compact 后继续生效且没有 `compaction_safe_summary`

它们可以是线索，但不能是 Prompt refinement correction 精修协议对象。

## 8. 消费顺序建议

更稳的顺序是：

1. 先验 `repair_session_object`
2. 再验 `repair_authority_chain`
3. 再验 `compiled_request_lineage_surface`
4. 再验 `registry_boundary_repair_surface`
5. 再验 `protocol_truth_surface`
6. 再验 `cross_consumer_repair_attestation`
7. 再验 `shared_reject_semantics_packet`
8. 最后验 `long_horizon_reopen_liability`

不要反过来做：

1. 不要先让 handoff 更整洁，再修 authority chain。
2. 不要先让 UI 历史更顺，再修 protocol truth。
3. 不要先让 later 团队放心，再修 repair attestation 与 liability。

## 9. 苏格拉底式检查清单

在你准备宣布“Prompt refinement correction 精修协议已经成立”前，先问自己：

1. 我恢复的是 authority chain，还是一份更会说话的 repair 文稿。
2. 我消费的是 protocol truth，还是一种更顺滑的显示层历史。
3. 我共享的是 cross-consumer repair attestation，还是四份相似的 consumer note。
4. 我保留的是 future reopen 的正式 threshold，还是一句“以后有问题再看”。
5. later 团队明天如果必须接手，依赖的是正式对象，还是 repair prose、summary 与作者记忆。
