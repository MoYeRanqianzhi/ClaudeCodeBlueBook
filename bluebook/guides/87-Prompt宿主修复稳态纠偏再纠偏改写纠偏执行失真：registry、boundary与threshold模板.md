# 如何把Prompt宿主修复稳态纠偏再纠偏改写纠偏执行失真压回compiled request truth：固定rewrite correction顺序、section registry、dynamic boundary与threshold改写模板骨架

这一章不再解释 Prompt 宿主修复稳态纠偏再纠偏改写纠偏执行最常怎样失真，而是把 Claude Code 式 Prompt rewrite-correction execution distortion 压成一张可执行的 builder-facing 手册。

它主要回答五个问题：

1. 为什么 Prompt rewrite correction execution distortion 真正要救回的不是一张更漂亮的 `rewrite correction card`，而是同一个 `compiled request truth`。
2. 怎样把假 `rewrite correction card`、假 `section registry`、假 `dynamic boundary` 与假 `threshold liability` 压回固定 `rewrite correction order`。
3. 哪些现象应被直接升级为硬拒收，而不是继续补 rewrite correction prose、目录说明与 handoff note。
4. 怎样把 `rewrite correction card`、`registry boundary rewrite block` 与 `threshold liability ticket` 重新压回对象级骨架。
5. 怎样用苏格拉底式追问避免把改写写成“把 rewrite correction 说明再写得更像 rewrite correction”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/systemPrompt.ts:28-93`
- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:491-560`
- `claude-code-source-code/src/utils/queryContext.ts:30-58`
- `claude-code-source-code/src/services/api/claude.ts:1374-1485`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:494-698`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/services/compact/prompt.ts:293-337`
- `claude-code-source-code/src/services/compact/compact.ts:330-711`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-66`
- `claude-code-source-code/src/coordinator/coordinatorMode.ts:251-257`
- `claude-code-source-code/src/tools/AgentTool/prompt.ts:101-112`
- `claude-code-source-code/src/query/tokenBudget.ts:22-92`
- `claude-code-source-code/src/query.ts:1308-1518`

## 1. 第一性原理

Prompt rewrite correction execution distortion 真正要救回的不是：

- 一张更完整的 `rewrite correction card`
- 一份更像制度的 `rewrite correction note`
- 一套更礼貌的 `re-entry / reopen` 话术

而是：

- 同一个 `compiled request truth` 在 rewrite correction 执行已经说过一次谎之后，仍能被模型继续消费、被 later 团队继续接手、被系统继续合法重开，而不重新退回 rewrite prose、静态目录、attachment 说明与默认 continuation

所以更稳的纠偏目标不是：

- 先把 rewrite correction 叙事说圆

而是：

1. 先把假 `rewrite correction card` 降回结果信号，而不是让它充当主对象。
2. 先把 `compiled request truth` 从 rewrite correction prose、UI transcript 与 summary handoff 里救出来。
3. 先把 `section registry + dynamic boundary` 从静态目录、正文幻觉与 attachment prose 里救出来。
4. 先把 `protocol transcript` 从可读 handoff 与解释性 prose 里救出来。
5. 先把 `stable prefix` 与 late-bound attachment 的法律边界从“安静的 cache 曲线”里救出来。
6. 先把 `lawful forgetting boundary` 从礼貌 summary 里救出来。
7. 先把 `continue qualification` 从惯性继续里救出来。
8. 最后才把 `threshold liability` 从经验式 reopen 提醒里救出来。

## 2. 固定 rewrite correction 顺序

### 2.1 先冻结假 `rewrite correction card`

第一步不是润色 `rewrite correction card`，而是冻结假修复信号：

1. 禁止 `reject_verdict=steady_state_restituted` 在对象复核之前生效。
2. 禁止 rewrite correction prose、summary handoff 与 UI transcript 重新充当 truth proof。
3. 禁止把 late-bound attachment 升格成 stable prefix 正文。
4. 禁止把静态目录说明冒充 runtime `section registry`。

最小冻结对象：

1. `rewrite_correction_card_id`
2. `rewrite_correction_session_id`
3. `restored_request_object_id`
4. `compiled_request_hash`
5. `section_registry_snapshot`
6. `dynamic_boundary_attested`
7. `reject_verdict`
8. `verdict_reason`

### 2.2 再恢复 `compiled request truth restitution`

第二步要救回：

1. `truth_continuity_attested`
2. `restored_request_object_id`
3. `compiled_request_hash`
4. `truth_lineage_ref`
5. `compiled_request_family`
6. `shared_consumer_surface`

不要继续做的事：

1. 不要先看 rewrite correction 说明是否更顺。
2. 不要先看 later 团队是否主观觉得“现在我懂了”。
3. 不要先看 steady 一段时间没有新噪音。

### 2.3 再恢复 `section registry reseal`

第三步要把 Prompt Constitution 的运行时法律地位救回：

1. `section_registry_snapshot`
2. `section_registry_generation`
3. `registry_drift_cleared`
4. `active_section_set`
5. `coordinator_synthesis_owner`
6. `constitution_lifecycle_reset_attested`

没有这一步，rewrite correction 仍会把 runtime registry 写成静态 TOC。

### 2.4 再恢复 `dynamic boundary rebinding`

第四步要把 stable prefix 正文与 late-bound attachment 的法律边界救回：

1. `system_prompt_dynamic_boundary`
2. `late_bound_attachment_set`
3. `attachment_law_demarcated`
4. `attachment_binding_order`
5. `dynamic_boundary_attested`
6. `late_bound_attachment_excluded_from_prefix`

没有这一步，rewrite correction 仍会把临场修正误写成长期正文。

### 2.5 再恢复 `protocol transcript repair`

第五步要把协议真相从 UI 历史与 prose handoff 里救回：

1. `protocol_transcript_health`
2. `tool_pairing_health`
3. `transcript_boundary_attested`
4. `protocol_rewrite_version`
5. `virtual_output_demoted`

只要这一步没修好，rewrite correction 仍然只是“历史被整理得更可读”。

### 2.6 再恢复 `stable prefix reseal` 与 `lawful forgetting reseal`

第六步要把共享前缀资产与合法遗忘边界从安静曲线与好运气里救回：

1. `stable_prefix_boundary`
2. `prefix_reseal_witness`
3. `cache_break_budget`
4. `cache_break_threshold`
5. `lawful_forgetting_boundary`
6. `preserved_segment_ref`
7. `compaction_lineage`
8. `forgetting_reseal_attested`

没有这一步，later 团队继承的仍不是同一个可消费 request truth。

### 2.7 再恢复 `continuation requalification`

第七步要把继续资格从情绪与惯性里救回：

1. `continue_qualification`
2. `token_budget_ready`
3. `required_preconditions`
4. `rollback_boundary`
5. `synthesis_ownership_restored`

没有这一步，continuation 仍只是“先继续再说”。

### 2.8 最后恢复 `threshold liability reinstatement`

最后才修未来反对当前 rewrite correction 的能力：

1. `truth_break_trigger`
2. `cache_break_threshold`
3. `threshold_retained_until`
4. `reentry_required_when`
5. `reopen_required_when`
6. `threshold_liability_reinstated_at`

不要反过来：

1. 不要先补 reopen 提醒，再修 truth object。
2. 不要先让 handoff 更顺滑，再修 registry / boundary。
3. 不要先让 `rewrite correction card` 更正式，再修 `threshold liability`。

## 3. 硬拒收规则

出现下面情况时，应直接升级为硬拒收：

1. `rewrite_correction_session_missing`
2. `compiled_request_truth_unrestituted`
3. `truth_lineage_ref_missing`
4. `section_registry_lifecycle_unbound`
5. `section_registry_staticized`
6. `dynamic_boundary_missing`
7. `attachment_promoted_into_prefix`
8. `coordinator_synthesis_owner_missing`
9. `protocol_transcript_health_failed`
10. `stable_prefix_boundary_missing`
11. `lawful_forgetting_boundary_missing`
12. `summary_override_detected`
13. `continue_qualification_unbound`
14. `token_budget_not_ready_but_continue_allowed`
15. `threshold_liability_missing`
16. `reopen_required_but_demotion_not_triggered`

## 4. 模板骨架

### 4.1 rewrite correction card 骨架

1. `rewrite_correction_card_id`
2. `rewrite_correction_session_id`
3. `restored_request_object_id`
4. `compiled_request_hash`
5. `truth_lineage_ref`
6. `section_registry_snapshot`
7. `section_registry_generation`
8. `dynamic_boundary_ref`
9. `protocol_rewrite_ref`
10. `prefix_reseal_ref`
11. `forgetting_reseal_ref`
12. `continue_qualification_ref`
13. `threshold_liability_ref`
14. `reject_verdict`
15. `verdict_reason`

### 4.2 registry boundary rewrite block 骨架

1. `registry_boundary_rewrite_block_id`
2. `truth_gap`
3. `registry_gap`
4. `registry_lifecycle_gap`
5. `dynamic_boundary_gap`
6. `attachment_law_gap`
7. `protocol_gap`
8. `prefix_gap`
9. `forgetting_gap`
10. `fallback_verdict`

### 4.3 threshold liability ticket 骨架

1. `threshold_liability_id`
2. `truth_break_trigger`
3. `cache_break_threshold`
4. `rollback_boundary`
5. `threshold_retained_until`
6. `reentry_required_when`
7. `reopen_required_when`
8. `liability_scope`

## 5. 与 `casebooks/58` 的边界

`casebooks/58` 回答的是：

- 为什么 Prompt rewrite correction execution 明明已经存在，仍会重新退回假 `rewrite correction card`

这一章回答的是：

- 当这些假对象已经被辨认出来之后，具体该按什么固定 `rewrite correction order` 把它们压回同一个 Prompt 编译对象

也就是说，`casebooks/58` 负责：

- 识别 Prompt 编译链怎样被更体面的 rewrite correction 工件替代

而这一章负责：

- 把这些替代信号按 truth、registry、boundary、protocol、prefix、forgetting、qualification 与 liability 的对象顺序拆掉

## 6. 苏格拉底式检查清单

在你准备宣布“Prompt steady-state correction-of-correction rewrite correction execution distortion 已纠偏完成”前，先问自己：

1. 我救回的是同一个 `compiled request truth`，还是一份更正式的 rewrite correction 说明。
2. 我现在保护的是 runtime `section registry`，还是一张更好看的目录表。
3. 我现在保护的是 `dynamic boundary`，还是一份更清楚的 attachment 说明。
4. 我现在恢复的是 `continue qualification`，还是一种“先继续再说”的默认冲动。
5. `threshold liability` 还在不在；如果不在，我是在完成 rewrite correction，还是在删除未来反对当前状态的能力。

## 7. 一句话总结

真正成熟的 Prompt 宿主修复稳态纠偏再纠偏改写纠偏，不是把 rewrite correction prose、目录说明与 handoff 写得更稳，而是把假 `rewrite correction card`、假 `section registry`、假 `dynamic boundary` 与假 `threshold liability` 重新压回同一个 Prompt 编译对象。
