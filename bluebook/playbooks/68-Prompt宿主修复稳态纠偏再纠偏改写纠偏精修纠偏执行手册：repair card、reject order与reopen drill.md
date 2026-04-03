# Prompt宿主修复稳态纠偏再纠偏改写纠偏精修纠偏执行手册：repair card、reject order与reopen drill

这一章不再解释 Prompt refinement correction protocol 该共享哪些字段，而是把 Claude Code 式 Prompt refinement correction protocol 压成一张可持续执行的 `repair card`。

它主要回答五个问题：

1. 为什么 Prompt 魔力在精修纠偏执行里运行的不是“Prompt 说明更完整”，而是同一条 `authority chain -> compiled request lineage -> registry-boundary custody -> synthesis custody -> protocol-prefix custody -> lawful forgetting -> continuation qualification -> threshold liability` 继续被共同消费。
2. 宿主、CI、评审与交接怎样共享同一张 Prompt `repair card`，而不是各自围绕 rewrite prose、summary handoff、UI transcript 与子 Agent prose 工作。
3. 应该按什么固定顺序执行 `reprotocol session`、`authority chain`、`compiled request lineage`、`registry-boundary custody`、`synthesis custody`、`protocol-prefix custody`、`forgetting-continuation covenant`、`reject semantics` 与 `reopen liability`，才能不让 refinement correction 再次退回解释稿。
4. 哪些 `reject order` 一旦出现就必须冻结 continuation、阻断 handoff 并进入 `re-entry / reopen` drill。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“第六套 Prompt 值班表”。

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

## 1. 第一性原理

Prompt 宿主修复稳态纠偏再纠偏改写纠偏精修纠偏真正要执行的不是：

- rewrite correction prose 又写得更像制度
- UI 历史重新看起来更顺
- summary handoff 又能把当前状态解释圆

而是：

- 同一个 authority chain、同一条 compiled request lineage、同一个 runtime registry、同一条 dynamic boundary、同一个 synthesis owner、同一条 protocol transcript、同一份 stable prefix、同一条 lawful forgetting boundary 与同一个 continuation qualification 仍被再次证明可继续、可交接、可反对

所以这层 playbook 最先要看的不是：

- `repair card` 已经填完了

而是：

1. 当前 refinement correction object 是否仍围绕同一个 `restored_request_object_id + compiled_request_hash + truth_lineage_ref`。
2. 当前 `registry-boundary custody` 是否真的把 Prompt 真相从静态目录说明里救回来。
3. 当前 `synthesis custody` 是否真的把未综合的 worker prose 重新压回线索层。
4. 当前 `protocol-prefix custody` 是否仍把 `tool pairing`、`stable prefix` 与 `cache break threshold` 绑在同一条合法编译链上。
5. 当前 `long-horizon reopen liability` 是否仍保留 future reopen 的正式能力。

## 2. 共享 repair card 最小字段

每次 Prompt 宿主修复稳态纠偏再纠偏改写纠偏精修纠偏巡检，宿主、CI、评审与交接系统至少应共享：

1. `repair_card_id`
2. `reprotocol_session_id`
3. `refinement_session_id`
4. `restored_request_object_id`
5. `compiled_request_hash`
6. `truth_lineage_ref`
7. `section_registry_generation`
8. `active_section_set`
9. `system_prompt_dynamic_boundary`
10. `late_bound_attachment_set`
11. `coordinator_synthesis_owner`
12. `protocol_transcript_health`
13. `tool_pairing_health`
14. `stable_prefix_boundary`
15. `lawful_forgetting_boundary`
16. `continue_qualification`
17. `threshold_retained_until`
18. `shared_consumer_surface`
19. `reject_verdict`
20. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看 authority chain、compiled request lineage 与 synthesis owner 是否仍唯一。
2. CI 看 registry、boundary、protocol、prefix、forgetting、qualification 与 threshold 顺序是否完整。
3. 评审看 `reject_verdict` 是否仍围绕同一个 Prompt 编译对象，而不是围绕解释文与 UI 历史。
4. 交接看 later 团队能否在不继承作者记忆的前提下只凭 `repair card` 继续消费同一条编译链。

## 3. 固定 reject order

### 3.1 先验 `reprotocol_session_object`

先看当前准备宣布 refinement correction 完成的，到底是不是同一个 `reprotocol_session_id`，而不是一份更正式的说明稿。

### 3.2 再验 `prompt_authority_chain`

再看：

1. `override_system_prompt_present`
2. `coordinator_mode_active`
3. `main_thread_agent_definition`
4. `agent_prompt_mode`
5. `append_system_prompt_present`

这一步先回答：

- 当前究竟是谁在定义模型世界

### 3.3 再验 `compiled_request_lineage_contract`

再看：

1. `restored_request_object_id`
2. `compiled_request_hash`
3. `truth_lineage_ref`
4. `compiled_request_family`

这一步先回答：

- later 团队接手时继承的是不是同一个 request truth

### 3.4 再验 `section_registry_custody` 与 `registry_boundary_custody`

再看：

1. `section_registry_snapshot + section_registry_generation`
2. `active_section_set`
3. `system_prompt_dynamic_boundary`
4. `late_bound_attachment_set`
5. `attachment_binding_order`

这一步先回答：

- runtime registry 还活着吗
- late-bound attachment 有没有偷渡进 stable prefix

### 3.5 再验 `synthesis_custody`

再看：

1. `coordinator_synthesis_owner`
2. `worker_findings_ref`
3. `uncompiled_subagent_output_blocked`
4. `synthesis_required_before_rebind`

这一步先回答：

- 当前主线程真的理解了吗

### 3.6 再验 `protocol_prefix_custody`

再看：

1. `protocol_transcript_health`
2. `tool_pairing_health`
3. `transcript_boundary_attested`
4. `stable_prefix_boundary`
5. `cache_break_budget`
6. `cache_break_threshold`
7. `cache_break_reason`

这一步先回答：

- 模型消费的是 protocol truth，还是显示层 transcript

### 3.7 再验 `forgetting_continuation_covenant`

再看：

1. `lawful_forgetting_boundary`
2. `preserved_segment_ref`
3. `compaction_lineage`
4. `continue_qualification`
5. `token_budget_ready`
6. `rollback_boundary`

这一步先回答：

- 当前继续资格到底来自正式对象，还是来自“先继续再说”

### 3.8 再验 `reject_semantics_packet`

再看：

1. `hard_reject`
2. `truth_recompile_required`
3. `registry_reseal_required`
4. `boundary_rebind_required`
5. `protocol_repair_required`
6. `requalification_required`
7. `reentry_required`
8. `reopen_required`

这一步先回答：

- 现在到底应该继续、重编译、回跳，还是正式 reopen

### 3.9 最后验 `long_horizon_reopen_liability`

最后才看：

1. `truth_break_trigger`
2. `threshold_liability_owner`
3. `threshold_retained_until`
4. `reentry_required_when`
5. `reopen_required_when`
6. `liability_scope`

更稳的最终 verdict 只应落在：

1. `steady_state_chain_resealed`
2. `hard_reject`
3. `truth_recompile_required`
4. `registry_reseal_required`
5. `boundary_rebind_required`
6. `protocol_repair_required`
7. `requalification_required`
8. `reentry_required`
9. `reopen_required`

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前 Prompt refinement correction execution：

1. `reprotocol_session_missing`
2. `authority_chain_unbound`
3. `compiled_request_truth_unrestituted`
4. `section_registry_staticized`
5. `late_bound_attachment_promoted`
6. `synthesis_custody_missing`
7. `tool_pairing_unlawful`
8. `stable_prefix_unsealed`
9. `lawful_forgetting_unsealed`
10. `continuation_unqualified`
11. `threshold_liability_missing`
12. `reopen_required`

## 5. re-entry 与 reopen 处理顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先冻结新的 continuation 与 handoff，不再让 later 团队继续消费当前 `repair card`。
2. 先把 verdict 降级为 `hard_reject`、`truth_recompile_required`、`registry_reseal_required`、`boundary_rebind_required`、`protocol_repair_required`、`reentry_required` 或 `reopen_required`。
3. 先把 rewrite prose、summary handoff、UI transcript 与未综合的 worker prose 降回线索，不再让它们充当 truth object。
4. 先回到上一个仍可验证的 `restored_request_object_id`、`section_registry_snapshot` 或 `stable_prefix_boundary`，补新的 lineage attestation、registry reseal、boundary rebinding、synthesis recustody、protocol repair 与 continuation qualification。
5. 如果根因落在 refinement correction protocol 本身，就回跳 `../api/87` 做对象级修正。

## 6. 最小 drill 集

每轮至少跑下面八个 Prompt 宿主稳态纠偏再纠偏改写纠偏精修纠偏执行演练：

1. `authority_chain_replay`
2. `compiled_request_lineage_replay`
3. `registry_boundary_rebind_replay`
4. `synthesis_custody_replay`
5. `protocol_prefix_repair_replay`
6. `forgetting_continuation_replay`
7. `reject_escalation_replay`
8. `reopen_liability_replay`

## 7. 复盘记录最少字段

每次 Prompt 宿主稳态纠偏再纠偏改写纠偏精修纠偏失败、再入场或 reopen，至少记录：

1. `repair_card_id`
2. `reprotocol_session_id`
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
14. `shared_consumer_surface`
15. `reject_verdict`
16. `verdict_reason`

## 8. 苏格拉底式检查清单

在你准备宣布“Prompt 已完成稳态纠偏再纠偏改写纠偏精修纠偏执行”前，先问自己：

1. 我救回的是同一个 `compiled request truth`，还是一份更正式的 refinement 说明。
2. 我重封的是 runtime `section registry`，还是一张更好看的目录表。
3. 我重新绑定的是 `dynamic boundary`，还是在偷把 late-bound attachment 塞回 stable prefix 正文。
4. 我现在保护的是 `coordinator synthesis owner + protocol transcript`，还是一段更顺滑的 UI 历史。
5. 我现在保留的是未来继续与未来反对当前状态的正式条件，还是一种“先继续再说”的体面包装。

## 9. 一句话总结

真正成熟的 Prompt 宿主修复稳态纠偏再纠偏改写纠偏精修纠偏执行，不是把 repair prose 运行得更熟练，而是持续证明 authority、lineage、registry-boundary、synthesis、protocol、prefix、forgetting、continuation 与 reopen liability 仍被同一张 `repair card` 正式约束。
