# Prompt宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行手册：repair card、共同 reject order 与 reopen drill

这一章不再解释 Prompt refinement correction repair protocol 该共享哪些字段，而是把 Claude Code 式 Prompt refinement correction repair protocol 压成一张可持续执行的 cross-consumer `repair card`。

它主要回答五个问题：

1. 为什么 Prompt 魔力在精修纠偏精修执行里运行的不是“repair 对象说明更完整”，而是同一条 `authority chain -> compiled request lineage -> registry boundary -> protocol truth -> repair attestation -> shared reject semantics -> long-horizon reopen liability` 继续被共同消费。
2. 宿主、CI、评审与交接怎样共享同一张 Prompt `repair card`，而不是各自围绕 UI transcript、summary handoff、repair prose 与子 Agent prose 工作。
3. 应该按什么固定顺序执行 `repair session`、`authority chain`、`compiled request lineage`、`registry boundary repair`、`protocol truth surface`、`cross-consumer repair attestation`、`shared reject semantics` 与 `reopen liability`，才能不让 refinement correction repair protocol 再次退回解释稿。
4. 哪些 `reject order` 一旦出现就必须冻结 continuation、阻断 handoff 并进入 `re-entry / reopen` drill。
5. 怎样用第一性原理与苏格拉底式追问，避免把这层写成“第七套 Prompt 值班表”。

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

Prompt 宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修真正要执行的不是：

- `repair object` 说明又写得更像制度
- UI 历史重新看起来更顺
- handoff packet 又能把当前状态解释圆

而是：

- 同一个 authority chain、同一条 compiled request lineage、同一个 runtime registry、同一条 protocol truth、同一份 repair attestation、同一条 shared reject semantics 与同一个 long-horizon reopen liability 仍被再次证明可继续、可交接、也可反对

Prompt 魔力之所以看起来像“有魔力”，不是因为它更会写，而是因为它把：

1. `buildEffectiveSystemPrompt()` 的主权顺序
2. `section registry` 的动态边界
3. `normalizeMessagesForAPI()` 的协议真相
4. `coordinator` 对 worker findings 的综合监护
5. `lawful forgetting + continuation qualification` 的合法继续资格

压成了同一个可执行对象链。

所以这层 playbook 最先要看的不是：

- `repair card` 已经填完了

而是：

1. 当前 repair card 是否仍围绕同一个 `restored_request_object_id + compiled_request_hash + truth_lineage_ref`。
2. 当前 `registry boundary repair` 是否真的把 protocol truth 从 UI transcript 与 attachment lane 里救回来。
3. 当前 `repair attestation` 是否真的 compact-safe、continuation-safe、cross-consumer-safe。
4. 当前 `shared reject semantics` 是否真的让四类消费者继续说同一种拒收语言。
5. 当前 `reopen liability` 是否仍保留 future reopen 的正式能力。

## 2. 共享 repair card 最小字段

每次 Prompt 宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修巡检，宿主、CI、评审与交接系统至少应共享：

1. `repair_card_id`
2. `repair_attestation_id`
3. `reprotocol_session_id`
4. `refinement_session_id`
5. `restored_request_object_id`
6. `compiled_request_hash`
7. `truth_lineage_ref`
8. `authority_chain_ref`
9. `section_registry_generation`
10. `active_section_set`
11. `system_prompt_dynamic_boundary`
12. `late_bound_attachment_set`
13. `coordinator_synthesis_owner`
14. `protocol_transcript_health`
15. `tool_pairing_health`
16. `stable_prefix_boundary`
17. `lawful_forgetting_boundary`
18. `continue_qualification`
19. `compaction_safe_summary`
20. `budget_state`
21. `reject_verdict`
22. `threshold_retained_until`
23. `reopen_required_when`
24. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看 authority chain、compiled request lineage 与 synthesis owner 是否仍唯一。
2. CI 看 registry、boundary、protocol、prefix、forgetting、budget 与 qualification 顺序是否完整。
3. 评审看 `reject_verdict` 是否仍围绕同一个 Prompt 编译对象，而不是围绕 UI transcript 与 repair prose。
4. 交接看 later 团队能否在不继承作者记忆的前提下只凭 `repair card` 继续消费同一条编译链。

## 3. 固定共同 reject order

### 3.1 先验 `repair_session_object`

先看当前准备宣布 refinement correction repair protocol 可执行的，到底是不是同一个 `reprotocol_session_id`，而不是一张更体面的解释卡。

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

### 3.4 再验 `registry_boundary_repair_surface`

再看：

1. `section_registry_snapshot`
2. `section_registry_generation`
3. `active_section_set`
4. `system_prompt_dynamic_boundary`
5. `late_bound_attachment_set`
6. `attachment_binding_order`

这一步先回答：

- runtime registry 还活着吗
- attachment 有没有偷渡成唯一真相

### 3.5 再验 `protocol_truth_surface`

再看：

1. `coordinator_synthesis_owner`
2. `worker_findings_ref`
3. `protocol_transcript_health`
4. `tool_pairing_health`
5. `stable_prefix_boundary`
6. `lawful_forgetting_boundary`
7. `continue_qualification`
8. `token_budget_ready`

这一步先回答：

- 模型消费的是 protocol truth，还是显示层 transcript

### 3.6 再验 `cross_consumer_repair_attestation`

再看：

1. `repair_attestation_id`
2. `intent_delta`
3. `evidence_refs`
4. `repair_directive`
5. `verification_gate`
6. `repair_ops`
7. `synthetic`
8. `tainted`
9. `compaction_safe_summary`
10. `consumer_projection_demoted`

这一步先回答：

- 四类消费者拿到的是不是同一个 repair object，而不是四个导出投影

### 3.7 再验 `shared_reject_semantics_packet`

再看：

1. `hard_reject`
2. `authority_chain_unbound`
3. `compiled_request_truth_unrestituted`
4. `protocol_truth_reseal_required`
5. `registry_boundary_repair_required`
6. `repair_attestation_rebuild_required`
7. `requalification_required`
8. `reentry_required`
9. `reopen_required`

这一步先回答：

- 现在到底应该继续、回跳、重编译，还是正式 reopen

### 3.8 最后验 `long_horizon_reopen_liability`

最后才看：

1. `truth_break_trigger`
2. `threshold_liability_owner`
3. `threshold_retained_until`
4. `reentry_required_when`
5. `reopen_required_when`
6. `liability_scope`
7. `rollback_boundary`
8. `preserved_segment_ref`

更稳的最终 verdict 只应落在：

1. `steady_state_chain_resealed`
2. `hard_reject`
3. `protocol_truth_reseal_required`
4. `registry_boundary_repair_required`
5. `repair_attestation_rebuild_required`
6. `requalification_required`
7. `reentry_required`
8. `reopen_required`

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前 Prompt refinement correction refinement execution：

1. `repair_session_missing`
2. `authority_chain_unbound`
3. `compiled_request_truth_unrestituted`
4. `registry_boundary_unsealed`
5. `attachment_only_truth`
6. `synthesis_custody_missing`
7. `tool_pairing_unlawful`
8. `stable_prefix_unsealed`
9. `lawful_forgetting_unsealed`
10. `continuation_unqualified`
11. `budget_path_attachment_only`
12. `repair_attestation_cross_consumer_mismatch`
13. `threshold_liability_missing`
14. `reopen_required`

## 5. re-entry 与 reopen 处理顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先冻结新的 continuation、compact export 与 handoff，不再让 later 团队继续消费当前 `repair card`。
2. 先把 verdict 降级为 `hard_reject`、`protocol_truth_reseal_required`、`registry_boundary_repair_required`、`repair_attestation_rebuild_required`、`requalification_required`、`reentry_required` 或 `reopen_required`。
3. 先把 repair prose、UI transcript、summary handoff 与未综合的 worker prose 降回线索，不再让它们充当 truth object。
4. 先回到上一个仍可验证的 `restored_request_object_id`、`section_registry_snapshot` 或 `stable_prefix_boundary`，补新的 lineage attestation、registry reseal、protocol truth reseal 与 attestation rebuild。
5. 只有当 `continue_qualification + budget_state + threshold liability` 被重新绑定后，才允许重新进入 continuation。
6. 如果根因落在 refinement correction repair protocol 本身，就回跳 `../api/90` 做对象级修正。

## 6. 最小 drill 集

每轮至少跑下面八个 Prompt 宿主稳态纠偏再纠偏改写纠偏精修纠偏精修执行演练：

1. `authority_chain_reconsume`
2. `compiled_request_lineage_reconsume`
3. `registry_boundary_reseal_replay`
4. `protocol_truth_reseal_replay`
5. `compact_safe_attestation_replay`
6. `shared_reject_alignment_replay`
7. `continuation_qualification_replay`
8. `reopen_liability_replay`

## 7. 复盘记录最少字段

每次 Prompt 宿主稳态纠偏再纠偏改写纠偏精修纠偏精修失败、再入场或 reopen，至少记录：

1. `repair_card_id`
2. `repair_attestation_id`
3. `restored_request_object_id`
4. `compiled_request_hash`
5. `authority_chain_ref`
6. `protocol_transcript_health`
7. `continue_qualification`
8. `reject_verdict`
9. `recovery_action_ref`
10. `threshold_retained_until`
11. `cross_consumer_projection_diff_ref`
12. `reopen_required_when`

## 8. 苏格拉底式自检

在你准备宣布“Prompt refinement correction repair protocol 已经进入 steady execution”前，先问自己：

1. 我现在让四类消费者共享的是同一个编译对象，还是四份长得相似的解释稿。
2. 我现在执行的是共同 `reject order`，还是宿主、CI、评审与交接各自的流程感觉。
3. 我现在保留的是 formal reopen power，还是一句“以后有问题再看”。
4. later 团队接手时依赖的是 `repair card`、顺序与 liability，还是仍要回到 UI transcript、worker prose 与作者记忆。
5. 当前执行保护的是作者退场后的 Prompt 真相延续，还是只是在把 repair protocol 写成更体面的值班 SOP。
