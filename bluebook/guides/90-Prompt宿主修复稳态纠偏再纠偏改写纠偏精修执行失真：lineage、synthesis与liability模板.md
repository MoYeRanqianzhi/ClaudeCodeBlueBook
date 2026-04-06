# 如何把 Prompt 宿主修复稳态纠偏再纠偏改写纠偏精修执行失真压回 message lineage：固定 refinement 顺序、lineage、synthesis 与 liability 模板骨架

Prompt refinement execution distortion 真正要救回的，不是更完整的 `host consumption card`，而是同一条 `message lineage` 在 refinement 之后仍围绕同一套编译约束成立：

1. `message lineage`
2. `projection consumer`
3. `section registry + dynamic boundary`
4. `coordinator synthesis custody`
5. `protocol-prefix custody`
6. `continuation object`
7. `continuation qualification`
8. `reopen liability`

`compiled request truth`、`host consumption card` 与 `reopen liability ledger` 都只能保留为旧总称或修复工件，不能继续当一级主语。

## 0. 代表性源码锚点

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

## 1. 第一性原理

Prompt refinement execution distortion 真正要拒绝的，不是研究材料不够多，而是主线程综合责任被研究 prose 与展示工件替身化：

- `host consumption card` 冒充主对象
- packet / handoff / UI transcript 冒充 `message lineage`
- 静态目录或 attachment prose 冒充 `section registry + dynamic boundary`
- 子 Agent 研究结论冒充 `coordinator synthesis custody`
- 顺滑交接感冒充 `protocol-prefix custody`
- 礼貌继续冒充 `continuation qualification`
- 口头 reopen 提醒冒充 liability

所以更稳的纠偏目标不是把 refinement execution 叙事说圆，而是：

1. 先把假 `host consumption card` 降回结果信号。
2. 先把 `message lineage` 从 packet、UI transcript 与 summary handoff 里救出来。
3. 先把运行时 `section registry + dynamic boundary` 从静态目录与 attachment prose 里救出来。
4. 先把 `coordinator synthesis custody` 从研究 prose 里救出来。
5. 先把 `protocol-prefix custody` 与 `continuation object` 从“看起来还能继续”的氛围里救出来。
6. 最后才把 reopen liability 从礼貌说明里救出来。

## 2. 固定 refinement 顺序

### 2.1 先冻结假 `host consumption card`

第一步不是润色卡片，而是冻结假修复信号：

1. 禁止 `reject_verdict=steady_state_chain_resealed` 在对象复核之前生效。
2. 禁止 handoff prose、summary packet 与 UI transcript 重新充当 Prompt truth proof。
3. 禁止把子 Agent 研究总结直接升级成主线程真相。
4. 禁止把 late-bound attachment 升格成 stable prefix 正文。

最小冻结对象：

1. `host_consumption_card_id`
2. `refinement_session_id`
3. `truth_lineage_ref`
4. `section_registry_generation`
5. `compiled_request_hash_legacy`
6. `reject_verdict`
7. `verdict_reason`

### 2.2 再恢复 `message lineage`

第二步要救回：

1. `truth_lineage_ref`
2. `lineage_kernel_integrity`
3. `restored_request_object_id`
4. `compiled_request_family_legacy`
5. `shared_consumer_surface`
6. `request_truth_restituted_at`

不要继续做的事：

1. 不要先看 packet 是否更整洁。
2. 不要先看 later 团队是否主观觉得“现在我懂了”。
3. 不要先看 token 似乎还够用。

### 2.3 再恢复 `section registry + dynamic boundary`

第三步要把 Prompt Constitution 的运行时法律地位救回：

1. `section_registry_snapshot`
2. `section_registry_generation`
3. `system_prompt_dynamic_boundary`
4. `late_bound_attachment_set`
5. `attachment_binding_order`
6. `boundary_rebound_at`

没有这一步，refinement execution 仍会把 runtime registry 写成静态 TOC、把 boundary 写成 attachment 使用说明。

### 2.4 再恢复 `coordinator synthesis custody`

第四步要把主线程综合责任从研究 prose 里救回：

1. `coordinator_synthesis_owner`
2. `worker_findings_ref`
3. `synthesis_required_before_rebind`
4. `uncompiled_subagent_output_blocked`
5. `constitution_lifecycle_reset_attested`

没有这一步，refinement execution 仍会让研究摘要越权充当主线 truth。

### 2.5 再恢复 `protocol-prefix custody`

第五步要把协议真相与共享前缀从显示层里救回：

1. `projection_consumer_alignment`
2. `protocol_transcript_health`
3. `tool_pairing_health`
4. `transcript_boundary_attested`
5. `stable_prefix_boundary`
6. `cache_break_budget`
7. `cache_break_threshold`

只要这一步没修好，refinement execution 仍然只是“交接看起来更顺滑”。

### 2.6 再恢复 `continuation object` 与 `qualification`

第六步要把继续资格从礼貌继续里救回：

1. `lawful_forgetting_boundary`
2. `preserved_segment_ref`
3. `compaction_lineage`
4. `continuation_object_ref`
5. `continuation_qualification`
6. `token_budget_ready`
7. `rollback_boundary`

没有这一步，continuation 仍只是“先继续再说”。

### 2.7 最后恢复 `reopen liability`

最后才修未来反对当前 refinement execution 的能力：

1. `truth_break_trigger`
2. `threshold_retained_until`
3. `reentry_required_when`
4. `reopen_required_when`
5. `liability_scope`
6. `reopen_liability_attested_at`

不要反过来：

1. 不要先补 reopen 提醒，再修 lineage object。
2. 不要先让 handoff 更顺滑，再修 boundary / synthesis。
3. 不要先让 `host consumption card` 更正式，再修 liability。

## 3. 硬拒收规则

出现下面情况时，应直接升级为硬拒收：

1. `refinement_session_missing`
2. `truth_lineage_ref_missing`
3. `lineage_kernel_integrity_failed`
4. `section_registry_staticized`
5. `dynamic_boundary_unattested`
6. `late_bound_attachment_promoted`
7. `coordinator_synthesis_owner_missing`
8. `research_prose_as_truth`
9. `projection_consumer_split_detected`
10. `protocol_transcript_health_failed`
11. `stable_prefix_boundary_missing`
12. `lawful_forgetting_boundary_missing`
13. `continuation_qualification_unbound`
14. `threshold_liability_missing`
15. `reopen_required_but_card_still_green`

## 4. 模板骨架

### 4.1 `host consumption card` 骨架

1. `host_consumption_card_id`
2. `refinement_session_id`
3. `truth_lineage_ref`
4. `lineage_kernel_integrity`
5. `section_registry_generation`
6. `system_prompt_dynamic_boundary`
7. `coordinator_synthesis_owner`
8. `projection_consumer_alignment`
9. `protocol_transcript_health`
10. `stable_prefix_boundary`
11. `lawful_forgetting_boundary`
12. `continuation_object_ref`
13. `continuation_qualification`
14. `threshold_retained_until`
15. `reject_verdict`

### 4.2 `lineage boundary rewrite block` 骨架

1. `lineage_boundary_rewrite_block_id`
2. `lineage_gap`
3. `registry_gap`
4. `boundary_gap`
5. `synthesis_gap`
6. `projection_gap`
7. `protocol_gap`
8. `prefix_gap`
9. `forgetting_gap`
10. `fallback_verdict`

### 4.3 `reopen liability ticket` 骨架

1. `reopen_liability_id`
2. `truth_break_trigger`
3. `threshold_retained_until`
4. `reentry_required_when`
5. `reopen_required_when`
6. `rollback_boundary`
7. `liability_scope`
8. `liability_owner`

## 5. 苏格拉底式检查清单

在你准备宣布“Prompt refinement execution distortion 已纠偏完成”前，先问自己：

1. 我救回的是同一条 `message lineage`，还是一份更正式的 handoff packet。
2. 我重封的是 runtime `section registry`，还是一张更好看的目录表。
3. 我现在保护的是 `coordinator_synthesis_owner`，还是一份更完整的研究结论。
4. 我现在恢复的是 `continuation qualification`，还是一种“先继续再说”的默认冲动。
5. 我现在保留的是 future reopen 的正式条件，还是一句“以后有问题再看”。

## 6. 一句话总结

真正成熟的 Prompt refinement execution 纠偏，不是把宿主消费卡写得更完整，而是把 `message lineage + registry-boundary rewrite + coordinator synthesis custody + protocol-prefix custody + continuation object + reopen liability` 继续拉回同一个 Prompt 编译对象。
