# 如何把Prompt宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行失真压回编译对象：固定refinement correction refinement顺序、compiled request truth、共同reject与liability改写模板骨架

这一章不再解释 Prompt 宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行最常怎样失真，而是把 Claude Code 式 Prompt refinement correction refinement execution distortion 压成一张可执行的 builder-facing 手册。

它主要回答五个问题：

1. 为什么 Prompt refinement correction refinement execution distortion 真正要救回的不是一张更严的 cross-consumer `repair card`，而是同一条 Prompt 编译对象链。
2. 怎样把假 `repair card`、假共同 `reject` 语义与假 `reopen liability` 压回固定 `refinement correction refinement order`。
3. 哪些现象应被直接升级为共同硬拒收，而不是继续补 polished transcript、summary handoff 与 worker prose。
4. 怎样把 `repair card`、`shared reject rebind block` 与 `long-horizon reopen liability ticket` 重新压回对象级骨架。
5. 怎样用苏格拉底式追问避免把改写写成“把 Prompt repair card 再做严一点”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/systemPrompt.ts:28-123`
- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:491-576`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/coordinator/coordinatorMode.ts:207-257`
- `claude-code-source-code/src/tools/AgentTool/prompt.ts:101-112`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-66`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:483-698`

这些锚点共同说明：

- Prompt refinement correction refinement execution 真正最容易失真的地方，不在 cross-consumer `repair card` 有没有写出来，而在 authority、compiled request lineage、registry-boundary、protocol truth、tool pairing、lawful forgetting、continuation qualification 与 reopen threshold 是否仍围绕同一个 Prompt 编译对象继续说真话。

## 1. 第一性原理

Prompt refinement correction refinement execution distortion 真正要救回的不是：

- 一张更完整的 `repair card`
- 一份更会解释当前状态的 handoff note
- 一组更谨慎的共同 reject 口号

而是：

- 同一个 `authority chain -> compiled request lineage -> registry-boundary custody -> protocol truth surface -> shared reject semantics -> forgetting-continuation covenant -> long-horizon reopen liability` 仍围绕同一个 Prompt 编译对象继续被共同消费

所以更稳的纠偏目标不是：

- 先把 repair 叙事说圆

而是：

1. 先把假 `repair card` 降回结果信号，而不是让它充当主对象。
2. 先把 authority chain 与 compiled request lineage 从 transcript、handoff 与 worker prose 里救出来。
3. 先把 registry、boundary、protocol truth 与 tool pairing 从显示层历史里救出来。
4. 先把共同 `reject` 语义从四类消费者各自的 calmness 里救出来。
5. 最后才把 lawful forgetting、continuation qualification 与 reopen threshold 从 compact 乐观主义里救出来。

## 2. 固定 refinement correction refinement 顺序

### 2.1 先冻结假 `repair card`

第一步不是润色 `repair card`，而是冻结假修复信号：

1. 禁止 `reject_verdict=steady_state_chain_resealed` 在对象复核之前生效。
2. 禁止 polished transcript、summary handoff 与 worker prose 重新充当 Prompt truth proof。
3. 禁止把 section 名字仍在、tool use 看起来配对、token 看起来还够当成继续资格。
4. 禁止把 late-bound attachment 与 compact summary 升格成 stable prefix 正文。

最小冻结对象：

1. `repair_card_id`
2. `repair_session_id`
3. `restored_request_object_id`
4. `compiled_request_hash`
5. `truth_lineage_ref`
6. `section_registry_generation`
7. `repair_attestation_id`
8. `reject_verdict`
9. `verdict_reason`

### 2.2 再恢复 `authority chain`

第二步要先回答“谁在定义模型世界”：

1. `override_system_prompt_present`
2. `coordinator_mode_active`
3. `main_thread_agent_definition`
4. `agent_prompt_mode`
5. `append_system_prompt_present`
6. `authority_chain_attested`

没有这一步，后续任何 lineage、boundary、reject 与 liability 都可能绑在错误主语上。

### 2.3 再恢复 `compiled request truth`

第三步要把同一条请求真相救回：

1. `restored_request_object_id`
2. `compiled_request_hash`
3. `truth_lineage_ref`
4. `compiled_request_family`
5. `compiled_request_lineage_attested`

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

没有这一步，精修纠偏仍会把 runtime registry 写成静态 TOC、把 boundary 写成 attachment 使用说明。

### 2.5 再恢复 `protocol truth surface`

第五步要把协议真相与配对关系从显示层里救回：

1. `coordinator_synthesis_owner`
2. `worker_findings_ref`
3. `protocol_transcript_health`
4. `tool_pairing_health`
5. `transcript_boundary_attested`
6. `stable_prefix_boundary`
7. `protocol_truth_surface_attested`

这里最关键的是：

- `normalizeMessagesForAPI()` 证明模型消费的是协议真相，不是 UI 历史。
- `ensureToolResultPairing()` 证明工具配对要么被真实修复，要么应直接 fail-closed。

### 2.6 再恢复 `shared reject semantics`

第六步要把四类消费者的拒收语言重新绑回同一个 Prompt 对象：

1. `shared_reject_semantics_packet`
2. `consumer_projection_demoted`
3. `host_reject_condition`
4. `ci_reject_condition`
5. `review_reject_condition`
6. `handoff_reject_condition`
7. `shared_reject_semantics_attested`

这一步先回答：

- 宿主、CI、评审与交接到底是不是在围绕同一个 Prompt 编译对象说同一种 reject 语言

### 2.7 再恢复 `forgetting-continuation covenant`

第七步要把继续资格从礼貌继续里救回：

1. `lawful_forgetting_boundary`
2. `compaction_lineage`
3. `continue_qualification`
4. `token_budget_ready`
5. `diminishing_return_guard`
6. `cache_break_reason`
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

1. 不要先补 reopen 提醒，再修 authority object。
2. 不要先让 handoff 更顺，再修 protocol truth。
3. 不要先让 compact 结果可读，再修 continue qualification。

## 3. 共同硬拒收规则

出现下面情况时，应直接升级为共同硬拒收：

1. `repair_session_missing`
2. `authority_chain_unbound`
3. `compiled_request_hash_drifted`
4. `registry_generation_missing`
5. `late_bound_attachment_prefix_leak`
6. `worker_findings_unsynthesized`
7. `protocol_truth_unattested`
8. `tool_pairing_strict_violation`
9. `shared_reject_semantics_split`
10. `lawful_forgetting_boundary_missing`
11. `continue_qualification_failed`
12. `threshold_retained_until_missing`

这些现象一旦出现，不要继续：

1. 补 explanation prose
2. 补 handoff 说明
3. 补 worker 研究链接
4. 补“目前看起来可继续”的备注

## 4. Builder-Facing 改写模板骨架

### 4.1 `prompt_repair_card_rebind_block`

```md
- repair_session_id:
- restored_request_object_id:
- compiled_request_hash:
- truth_lineage_ref:
- authority_chain_ref:
- section_registry_generation:
- protocol_truth_surface_ref:
- shared_reject_semantics_ref:
- threshold_retained_until:
- current_verdict:
- verdict_reason:
```

### 4.2 `prompt_shared_reject_rebind_block`

```md
- host_reject_condition:
- ci_reject_condition:
- review_reject_condition:
- handoff_reject_condition:
- consumer_projection_demoted:
- must_block_when:
- may_continue_only_when:
```

### 4.3 `prompt_long_horizon_reopen_liability_ticket`

```md
- liability_owner:
- truth_break_trigger:
- cache_break_reason:
- continue_qualification:
- reentry_required_when:
- reopen_required_when:
- threshold_retained_until:
```

## 5. 苏格拉底式自检

在你准备宣布“Prompt 精修执行失真已经被纠偏”前，先问自己：

1. 我压回的是同一个 Prompt 编译对象，还是一份更好读的解释包。
2. 我修回的是共同 `reject` 语言，还是四类角色终于都“感觉差不多可以了”。
3. 我保留的是 formal reopen 能力，还是作者记得怎么救场。
4. later 团队是否能只凭这些块重建 authority、truth、reject 与 threshold。
5. 我现在保护的是 Claude Code 的 Prompt 魔力，还是只是在模仿它的外观。
