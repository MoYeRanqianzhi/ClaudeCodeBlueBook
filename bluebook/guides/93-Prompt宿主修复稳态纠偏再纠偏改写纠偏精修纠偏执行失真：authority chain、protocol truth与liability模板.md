# 如何把Prompt宿主修复稳态纠偏再纠偏改写纠偏精修纠偏执行失真压回编译对象：固定refinement correction顺序、authority chain、protocol truth与liability改写模板骨架

这一章不再解释 Prompt 宿主修复稳态纠偏再纠偏改写纠偏精修纠偏执行最常怎样失真，而是把 Claude Code 式 Prompt refinement correction execution distortion 压成一张可执行的 builder-facing 手册。

它主要回答五个问题：

1. 为什么 Prompt refinement correction execution distortion 真正要救回的不是一张更严的 `repair card`，而是同一条 Prompt 编译对象链。
2. 怎样把假 `repair card`、假 `protocol truth` 与假 `reopen liability` 压回固定 `refinement correction order`。
3. 哪些现象应被直接升级为硬拒收，而不是继续补 repair prose、handoff packet 与 protocol 解释稿。
4. 怎样把 `repair card`、`protocol truth rebind block` 与 `long-horizon reopen liability ticket` 重新压回对象级骨架。
5. 怎样用苏格拉底式追问避免把改写写成“把 Prompt repair card 再填细一点就好”。

## 0. 代表性源码锚点

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

这些锚点共同说明：

- Prompt refinement correction execution 真正最容易失真的地方，不在 `repair card` 有没有写出来，而在 authority、compiled request lineage、registry-boundary、synthesis、protocol transcript、stable prefix、lawful forgetting、continuation qualification 与 reopen liability 是否仍围绕同一个 Prompt 编译对象继续说真话。

## 1. 第一性原理

Prompt refinement correction execution distortion 真正要救回的不是：

- 一张更完整的 `repair card`
- 一份更会解释当前状态的 handoff note
- 一组更谨慎的 reopen 提醒

而是：

- 同一个 `authority chain -> compiled request lineage -> registry-boundary custody -> synthesis custody -> protocol-prefix custody -> forgetting-continuation covenant -> long-horizon reopen liability` 仍围绕同一个 Prompt 编译对象继续被共同消费

所以更稳的纠偏目标不是：

- 先把 repair 叙事说圆

而是：

1. 先把假 `repair card` 降回结果信号，而不是让它充当主对象。
2. 先把 authority chain 与 compiled request lineage 从 packet、UI transcript 与研究 prose 里救出来。
3. 先把 registry、boundary、synthesis 与 protocol truth 从目录说明、worker 总结与显示层历史里救出来。
4. 先把 stable prefix、lawful forgetting 与 continuation qualification 从“现在看起来还能继续”的感觉里救出来。
5. 最后才把 `long-horizon reopen liability` 从礼貌说明里救出来。

## 2. 固定 refinement correction 顺序

### 2.1 先冻结假 `repair card`

第一步不是润色 `repair card`，而是冻结假修复信号：

1. 禁止 `reject_verdict=steady_state_chain_resealed` 在对象复核之前生效。
2. 禁止 repair prose、summary handoff 与 UI transcript 重新充当 Prompt truth proof。
3. 禁止把未综合的子 Agent 研究总结升级成主线程真相。
4. 禁止把 late-bound attachment 升格成 stable prefix 正文。

最小冻结对象：

1. `repair_card_id`
2. `repair_session_id`
3. `restored_request_object_id`
4. `compiled_request_hash`
5. `truth_lineage_ref`
6. `section_registry_generation`
7. `reject_verdict`
8. `verdict_reason`

### 2.2 再恢复 `authority chain`

第二步要先回答“谁在定义模型世界”：

1. `override_system_prompt_present`
2. `append_system_prompt_present`
3. `coordinator_mode_active`
4. `main_thread_agent_definition`
5. `agent_prompt_mode`
6. `authority_chain_attested`

没有这一步，后续任何 lineage、boundary 与 liability 都可能绑在错误主语上。

### 2.3 再恢复 `compiled request lineage`

第三步要把同一条请求真相救回：

1. `restored_request_object_id`
2. `compiled_request_hash`
3. `truth_lineage_ref`
4. `compiled_request_family`
5. `shared_consumer_surface`
6. `compiled_request_lineage_attested`

不要继续做的事：

1. 不要先看 packet 是否更整洁。
2. 不要先看 later 团队是否主观觉得“现在我懂了”。
3. 不要先看 token 似乎还够用。

### 2.4 再恢复 `registry-boundary custody`

第四步要把 Prompt Constitution 的运行时法律地位救回：

1. `section_registry_snapshot`
2. `section_registry_generation`
3. `active_section_set`
4. `system_prompt_dynamic_boundary`
5. `late_bound_attachment_set`
6. `attachment_binding_order`
7. `registry_boundary_custody_attested`

没有这一步，refinement correction 仍会把 runtime registry 写成静态 TOC、把 boundary 写成 attachment 使用说明。

### 2.5 再恢复 `synthesis custody`

第五步要把主线程综合责任从研究 prose 里救回：

1. `coordinator_synthesis_owner`
2. `worker_findings_ref`
3. `synthesis_required_before_reseal`
4. `uncompiled_subagent_output_blocked`
5. `synthesis_custody_attested`

没有这一步，repair card 只会把 worker 研究结果重新包装成更正式的 handoff。

### 2.6 再恢复 `protocol-prefix custody`

第六步要把协议真相与共享前缀从显示层里救回：

1. `protocol_transcript_health`
2. `tool_pairing_health`
3. `transcript_boundary_attested`
4. `stable_prefix_boundary`
5. `cache_break_budget`
6. `cache_break_threshold`
7. `protocol_prefix_custody_attested`

只要这一步没修好，refinement correction 仍然只是“交接看起来更顺滑”。

### 2.7 再恢复 `forgetting-continuation covenant`

第七步要把继续资格从礼貌继续里救回：

1. `lawful_forgetting_boundary`
2. `preserved_segment_ref`
3. `compaction_lineage`
4. `continue_qualification`
5. `token_budget_ready`
6. `rollback_boundary`
7. `forgetting_continuation_covenant_attested`

没有这一步，continuation 仍只是“先继续再说”。

### 2.8 最后恢复 `long-horizon reopen liability`

最后才把 future reopen 的正式能力救回：

1. `truth_break_trigger`
2. `threshold_retained_until`
3. `reentry_required_when`
4. `reopen_required_when`
5. `liability_owner`
6. `liability_scope`
7. `long_horizon_reopen_liability_attested`

不要反过来：

1. 不要先补 reopen 提醒，再修 authority / lineage object。
2. 不要先让 handoff 更顺滑，再修 registry / boundary / synthesis。
3. 不要先让 `repair card` 更正式，再修 future reopen 的正式反对能力。

## 3. 硬拒收规则

出现下面情况时，应直接升级为硬拒收：

1. `repair_session_missing`
2. `repair_card_as_packet`
3. `authority_chain_unbound`
4. `compiled_request_truth_unrestituted`
5. `truth_lineage_ref_missing`
6. `section_registry_staticized`
7. `dynamic_boundary_unattested`
8. `late_bound_attachment_promoted`
9. `coordinator_synthesis_owner_missing`
10. `worker_prose_as_truth`
11. `protocol_transcript_health_failed`
12. `stable_prefix_boundary_missing`
13. `lawful_forgetting_boundary_missing`
14. `continue_qualification_unbound`
15. `token_budget_not_ready_but_continue_allowed`
16. `long_horizon_reopen_liability_missing`
17. `reopen_required_but_card_still_green`

## 4. 模板骨架

### 4.1 repair card 骨架

1. `repair_card_id`
2. `repair_session_id`
3. `restored_request_object_id`
4. `compiled_request_hash`
5. `truth_lineage_ref`
6. `authority_chain_ref`
7. `section_registry_generation`
8. `system_prompt_dynamic_boundary`
9. `coordinator_synthesis_owner`
10. `protocol_transcript_health`
11. `stable_prefix_boundary`
12. `lawful_forgetting_boundary`
13. `continue_qualification`
14. `threshold_retained_until`
15. `reject_verdict`
16. `verdict_reason`

### 4.2 protocol truth rebind block 骨架

1. `protocol_truth_rebind_block_id`
2. `authority_gap`
3. `lineage_gap`
4. `registry_gap`
5. `boundary_gap`
6. `synthesis_gap`
7. `protocol_gap`
8. `prefix_gap`
9. `forgetting_gap`
10. `liability_gap`
11. `fallback_verdict`

### 4.3 long-horizon reopen liability ticket 骨架

1. `long_horizon_reopen_liability_id`
2. `truth_break_trigger`
3. `threshold_retained_until`
4. `reentry_required_when`
5. `reopen_required_when`
6. `rollback_boundary`
7. `liability_scope`
8. `liability_owner`

## 5. 为什么这会重新杀死 Prompt 魔力

- Claude Code 的 Prompt 魔力从来不是 `repair card` 写得多漂亮，而是 authority、lineage、boundary、synthesis、protocol、prefix、forgetting 与 continuation 仍被编译成同一条可缓存、可转写、可继续的请求链。
- 它真正固定的是“谁能定义世界、什么能进入稳定前缀、什么必须晚绑定”的编译秩序，而不是一段更会说话的系统提示词。
- 假 `repair card` 会把编译对象退回交接对象。
- 假 `protocol truth` 会把 runtime 主线程退回 UI 历史、目录说明与研究 prose。
- 假 `reopen liability` 会把 future reopen 的正式能力退回一句礼貌说明。

一旦这几件事同时发生，Prompt 世界剩下的就不再是 Claude Code 式编译链，而只是：

1. 更会解释的 repair prose。
2. 更平静的 UI 历史。
3. 更难被 later 团队质疑的默认继续。

## 6. 与 `casebooks/64` 的边界

`casebooks/64` 回答的是：

- 为什么 Prompt refinement correction execution 明明已经存在，仍会重新退回假 `repair card`、假 `protocol truth` 与假 `reopen liability`

这一章回答的是：

- 当这些假对象已经被辨认出来之后，具体该按什么固定 `refinement correction order` 把它们压回同一个 Prompt 编译对象

也就是说，`casebooks/64` 负责：

- 识别 Prompt refinement correction execution 怎样被更体面的 repair 工件替代

而这一章负责：

- 把这些替代信号按 authority、lineage、boundary、synthesis、protocol、continuation 与 liability 的对象顺序拆掉

## 7. 苏格拉底式检查清单

在你准备宣布“Prompt refinement correction execution distortion 已纠偏完成”前，先问自己：

1. 我救回的是同一个 `compiled request truth`，还是一张更正式的 repair card。
2. 我现在保护的是 runtime `section registry`，还是一张更好看的目录表。
3. 我现在保护的是 `coordinator_synthesis_owner`，还是一份更完整的研究结论。
4. 我现在恢复的是 `continue qualification`，还是一种“先继续再说”的默认冲动。
5. 我现在保留的是 future reopen 的正式条件，还是一句“以后有问题再看”。

## 8. 一句话总结

真正成熟的 Prompt refinement correction execution 纠偏，不是把 repair card 写得更严，而是把 `authority chain + compiled request lineage + registry-boundary custody + synthesis custody + protocol-prefix custody + forgetting-continuation covenant + long-horizon reopen liability` 继续拉回同一个 Prompt 编译对象。
