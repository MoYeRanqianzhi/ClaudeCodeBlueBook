# 如何把Prompt宿主修复稳态纠偏再纠偏改写纠偏精修执行失真压回编译对象：固定refinement顺序、lineage、synthesis与liability改写模板骨架

这一章不再解释 Prompt 宿主修复稳态纠偏再纠偏改写纠偏精修执行最常怎样失真，而是把 Claude Code 式 Prompt refinement execution distortion 压成一张可执行的 builder-facing 手册。

它主要回答五个问题：

1. 为什么 Prompt refinement execution distortion 真正要救回的不是一张更漂亮的 `host consumption card`，而是同一条 `compiled request truth` 编译链。
2. 怎样把假 `host consumption card`、假 `compiled request lineage`、假 `registry-boundary rewrite`、假 `coordinator synthesis custody` 与假 `reopen liability ledger` 压回固定 `refinement order`。
3. 哪些现象应被直接升级为硬拒收，而不是继续补 handoff packet、研究摘要与说明 prose。
4. 怎样把 `host consumption card`、`lineage-boundary rewrite block` 与 `reopen liability ticket` 重新压回对象级骨架。
5. 怎样用苏格拉底式追问避免把改写写成“把 Prompt 宿主消费卡再写得更正式”。

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

Prompt refinement execution distortion 真正要救回的不是：

- 一张更完整的 `host consumption card`
- 一份更像制度的 handoff packet
- 一组更全面的子 Agent 研究摘要

而是：

- 同一个 `compiled request truth` 在 refinement execution 已经说过一次谎之后，仍能被模型继续消费、被 later 团队继续接手、被系统继续合法重开，而不重新退回 packet、handoff、UI transcript 与研究 prose

所以更稳的纠偏目标不是：

- 先把 refinement execution 叙事说圆

而是：

1. 先把假 `host consumption card` 降回结果信号，而不是让它充当主对象。
2. 先把 `compiled request lineage` 从 packet、UI transcript 与 summary handoff 里救出来。
3. 先把 `section registry + dynamic boundary` 从静态目录、正文幻觉与 attachment prose 里救出来。
4. 先把 `coordinator synthesis custody` 从研究总结与子 Agent prose 里救出来。
5. 先把 `protocol-prefix custody` 与 `forgetting-continuation covenant` 从“看起来还能继续”的氛围里救出来。
6. 最后才把 `reopen liability ledger` 从礼貌说明里救出来。

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
3. `restored_request_object_id`
4. `compiled_request_hash`
5. `truth_lineage_ref`
6. `section_registry_generation`
7. `reject_verdict`
8. `verdict_reason`

### 2.2 再恢复 `compiled request lineage`

第二步要救回：

1. `restored_request_object_id`
2. `compiled_request_hash`
3. `truth_lineage_ref`
4. `compiled_request_family`
5. `shared_consumer_surface`
6. `request_truth_restituted_at`

不要继续做的事：

1. 不要先看 packet 是否更整洁。
2. 不要先看 later 团队是否主观觉得“现在我懂了”。
3. 不要先看 token 似乎还够用。

### 2.3 再恢复 `registry-boundary rewrite`

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

1. `protocol_transcript_health`
2. `tool_pairing_health`
3. `transcript_boundary_attested`
4. `stable_prefix_boundary`
5. `cache_break_budget`
6. `cache_break_threshold`

只要这一步没修好，refinement execution 仍然只是“交接看起来更顺滑”。

### 2.6 再恢复 `forgetting-continuation covenant`

第六步要把继续资格从礼貌继续里救回：

1. `lawful_forgetting_boundary`
2. `preserved_segment_ref`
3. `compaction_lineage`
4. `continue_qualification`
5. `token_budget_ready`
6. `rollback_boundary`

没有这一步，continuation 仍只是“先继续再说”。

### 2.7 最后恢复 `reopen liability ledger`

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
3. 不要先让 `host consumption card` 更正式，再修 liability ledger。

## 3. 硬拒收规则

出现下面情况时，应直接升级为硬拒收：

1. `refinement_session_missing`
2. `compiled_request_truth_unrestituted`
3. `truth_lineage_ref_missing`
4. `section_registry_staticized`
5. `dynamic_boundary_unattested`
6. `late_bound_attachment_promoted`
7. `coordinator_synthesis_owner_missing`
8. `research_prose_as_truth`
9. `protocol_transcript_health_failed`
10. `stable_prefix_boundary_missing`
11. `lawful_forgetting_boundary_missing`
12. `continue_qualification_unbound`
13. `threshold_liability_missing`
14. `reopen_required_but_card_still_green`

## 4. 模板骨架

### 4.1 host consumption card 骨架

1. `host_consumption_card_id`
2. `refinement_session_id`
3. `restored_request_object_id`
4. `compiled_request_hash`
5. `truth_lineage_ref`
6. `section_registry_generation`
7. `system_prompt_dynamic_boundary`
8. `coordinator_synthesis_owner`
9. `protocol_transcript_health`
10. `stable_prefix_boundary`
11. `lawful_forgetting_boundary`
12. `continue_qualification`
13. `threshold_retained_until`
14. `reject_verdict`
15. `verdict_reason`

### 4.2 lineage boundary rewrite block 骨架

1. `lineage_boundary_rewrite_block_id`
2. `lineage_gap`
3. `registry_gap`
4. `boundary_gap`
5. `synthesis_gap`
6. `protocol_gap`
7. `prefix_gap`
8. `forgetting_gap`
9. `fallback_verdict`

### 4.3 reopen liability ticket 骨架

1. `reopen_liability_id`
2. `truth_break_trigger`
3. `threshold_retained_until`
4. `reentry_required_when`
5. `reopen_required_when`
6. `rollback_boundary`
7. `liability_scope`
8. `liability_owner`

## 5. 与 `casebooks/61` 的边界

`casebooks/61` 回答的是：

- 为什么 Prompt refinement execution 明明已经存在，仍会重新退回假 `host consumption card`、假 `synthesis custody` 与假 `reopen liability`

这一章回答的是：

- 当这些假对象已经被辨认出来之后，具体该按什么固定 `refinement order` 把它们压回同一个 Prompt 编译对象

也就是说，`casebooks/61` 负责：

- 识别 Prompt refinement execution 怎样被更体面的 packet、handoff 与研究 prose 取代

而这一章负责：

- 把这些替代信号按 lineage、boundary、synthesis、protocol、continuation 与 liability 的对象顺序拆掉

## 6. 苏格拉底式检查清单

在你准备宣布“Prompt refinement execution distortion 已纠偏完成”前，先问自己：

1. 我救回的是同一个 `compiled request truth`，还是一份更正式的 handoff packet。
2. 我重封的是 runtime `section registry`，还是一张更好看的目录表。
3. 我现在保护的是 `coordinator_synthesis_owner`，还是一份更完整的研究结论。
4. 我现在恢复的是 `continue qualification`，还是一种“先继续再说”的默认冲动。
5. 我现在保留的是 future reopen 的正式条件，还是一句“以后有问题再看”。

## 7. 一句话总结

真正成熟的 Prompt refinement execution 纠偏，不是把宿主消费卡写得更完整，而是把 `compiled request lineage + registry-boundary rewrite + coordinator synthesis custody + protocol-prefix custody + forgetting-continuation covenant + reopen liability ledger` 继续拉回同一个 Prompt 编译对象。
