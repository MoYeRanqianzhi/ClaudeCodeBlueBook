# Prompt宿主修复稳态纠偏再纠偏改写纠偏精修纠偏执行手册：message lineage repair card、projection consumer、continuation qualification与reject order

这一章不再解释 Prompt refinement correction protocol 该共享哪些字段，而是把 Claude Code 式 Prompt refinement correction protocol 压成一张可持续执行的 `repair card`。

它主要回答五个问题：

1. 为什么 Prompt 魔力在精修纠偏执行里运行的不是“Prompt 说明更完整”，而是同一条 `message lineage -> projection consumer -> registry boundary -> protocol transcript -> stable prefix -> lawful forgetting -> continuation object -> continuation qualification -> threshold liability` 继续被共同消费。
2. 宿主、CI、评审与交接怎样共享同一张 Prompt `repair card`，而不是各自围绕 rewrite prose、summary handoff、UI transcript 与子 Agent prose 工作。
3. 应该按什么固定顺序执行 `message lineage`、`projection consumer demotion`、`registry boundary rebind`、`synthesis/protocol custody`、`forgetting/continuation covenant`、`reject semantics` 与 `reopen liability`，才能不让 refinement correction 再次退回解释稿。
4. 哪些 `reject order` 一旦出现就必须冻结 continuation、阻断 handoff 并进入 `re-entry / reopen` drill。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成又一张 Prompt 执行流程表。

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

- `display / protocol / handoff` 这些 projection consumer 是否仍围绕同一条 `message lineage` 消费真相。
- `section registry` 与 `dynamic boundary` 是否仍只决定编译方式，而不是被显示层历史反向篡位。
- `stable prefix` 与 `lawful forgetting` 是否仍把贵而稳定的前缀和可合法丢弃的历史分层。
- `continuation object` 与 `continuation qualification` 是否仍让继续资格回到正式对象，而不是“先继续再说”。

Claude Code 的 Prompt 魔力之所以看起来像“有魔力”，不是因为它更会写，而是因为它让同一条 `message lineage` 同时约束：

1. 模型世界由谁定义。
2. 哪些 consumer 只配看投影。
3. 哪些历史能进入 stable prefix。
4. compact 之后什么对象还能合法继续。

所以这层 playbook 最先要看的不是：

- `repair card` 已经填完了

而是：

1. 当前 correction object 是否仍围绕同一个 `restored_request_object_id + compiled_request_hash + message_lineage_ref`。
2. 当前 projection consumer 是否仍共同消费同一条 lineage，而不是各自维护一份“差不多的 Prompt 世界”。
3. 当前 `registry boundary` 是否真的把 runtime truth 从 UI transcript 与 attachment lane 里救回来。
4. 当前 `continuation object` 与 `continuation qualification` 是否仍被同一条 lawful forgetting 链保护。
5. 当前 `reopen liability` 是否仍保留 future reopen 的正式能力。

## 2. 共享 repair card 最小字段

每次 Prompt 宿主修复稳态纠偏再纠偏改写纠偏精修纠偏巡检，宿主、CI、评审与交接系统至少应共享：

1. `repair_card_id`
2. `reprotocol_session_id`
3. `refinement_session_id`
4. `restored_request_object_id`
5. `compiled_request_hash`
6. `message_lineage_ref`
7. `projection_consumer_alignment`
8. `section_registry_generation`
9. `active_section_set`
10. `system_prompt_dynamic_boundary`
11. `late_bound_attachment_set`
12. `coordinator_synthesis_owner`
13. `protocol_transcript_health`
14. `tool_pairing_health`
15. `stable_prefix_boundary`
16. `lawful_forgetting_boundary`
17. `continuation_object_ref`
18. `continuation_qualification`
19. `token_budget_ready`
20. `threshold_retained_until`
21. `shared_consumer_surface`
22. `reject_verdict`
23. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看 `message_lineage_ref`、`projection_consumer_alignment` 与 `coordinator_synthesis_owner` 是否仍唯一。
2. CI 看 `registry boundary`、`protocol transcript`、`stable prefix`、`lawful forgetting` 与 `continuation qualification` 顺序是否完整。
3. 评审看 `reject_verdict` 是否仍围绕同一个 Prompt 编译对象，而不是围绕说明文与 UI 历史。
4. 交接看 later 团队能否只凭 `repair card` 重建同一继续、拒收与 reopen 判断，而不把 display truth 误当 protocol truth。

## 3. 固定 reject order

### 3.1 先验 `reprotocol_session_object`

先看当前准备宣布 refinement correction 完成的，到底是不是同一个 `reprotocol_session_id`，而不是一份更体面的说明稿。

### 3.2 再验 `message_lineage_covenant`

再看：

1. `restored_request_object_id`
2. `compiled_request_hash`
3. `message_lineage_ref`
4. `compiled_request_family`

这一步先回答：

- later 团队接手时继承的是不是同一个 request lineage

### 3.3 再验 `projection_consumer_demotion_contract`

再看：

1. `projection_consumer_alignment`
2. `display_projection_demoted`
3. `protocol_projection_primary`
4. `handoff_projection_secondary`
5. `ui_transcript_not_truth`

这一步先回答：

- display / protocol / handoff 消费的是不是同一条 lineage
- UI transcript 有没有在偷当真相主语

### 3.4 再验 `registry_boundary_rebind_surface`

再看：

1. `section_registry_snapshot`
2. `section_registry_generation`
3. `active_section_set`
4. `system_prompt_dynamic_boundary`
5. `late_bound_attachment_set`
6. `attachment_binding_order`

这一步先回答：

- runtime registry 还活着吗
- attachment 有没有偷渡进 stable prefix 正文

### 3.5 再验 `synthesis_protocol_prefix_custody`

再看：

1. `coordinator_synthesis_owner`
2. `worker_findings_ref`
3. `protocol_transcript_health`
4. `tool_pairing_health`
5. `stable_prefix_boundary`
6. `cache_break_reason`

这一步先回答：

- 当前主线程真的理解了吗
- 模型消费的是 protocol truth，还是显示层 transcript

### 3.6 再验 `forgetting_continuation_covenant`

再看：

1. `lawful_forgetting_boundary`
2. `preserved_segment_ref`
3. `continuation_object_ref`
4. `continuation_qualification`
5. `token_budget_ready`

这一步先回答：

- 当前继续资格到底来自正式对象，还是来自“先继续再说”

### 3.7 再验 `reject_semantics_packet`

再看：

1. `hard_reject`
2. `lineage_recompile_required`
3. `projection_consumer_split_detected`
4. `registry_reseal_required`
5. `protocol_repair_required`
6. `continuation_requalification_required`
7. `reentry_required`
8. `reopen_required`

这一步先回答：

- 现在到底应该继续、重编译、回跳，还是正式 reopen

### 3.8 最后验 `long_horizon_reopen_liability`

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
3. `lineage_recompile_required`
4. `projection_consumer_split_detected`
5. `registry_reseal_required`
6. `protocol_repair_required`
7. `continuation_requalification_required`
8. `reentry_required`
9. `reopen_required`

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前 Prompt refinement correction execution：

1. `reprotocol_session_missing`
2. `message_lineage_ref_missing`
3. `projection_consumer_split_detected`
4. `section_registry_staticized`
5. `late_bound_attachment_promoted`
6. `synthesis_custody_missing`
7. `tool_pairing_unlawful`
8. `stable_prefix_unsealed`
9. `lawful_forgetting_unsealed`
10. `continuation_object_missing`
11. `continuation_qualification_unbound`
12. `threshold_liability_missing`
13. `reopen_required_but_continue`

## 5. re-entry 与 reopen 处理顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先冻结新的 continuation 与 handoff，不再让 later 团队继续消费当前 `repair card`。
2. 先把 verdict 降级为 `hard_reject`、`lineage_recompile_required`、`registry_reseal_required`、`protocol_repair_required`、`continuation_requalification_required`、`reentry_required` 或 `reopen_required`。
3. 先把 rewrite prose、summary handoff、UI transcript 与未综合的 worker prose 降回线索，不再让它们充当 truth object。
4. 先回到上一个仍可验证的 `message_lineage_ref`、`section_registry_snapshot` 或 `stable_prefix_boundary`，补新的 projection consumer 对齐、registry reseal、protocol repair 与 continuation qualification。
5. 只有当 `continuation_object_ref + continuation_qualification + threshold liability` 被重新绑定后，才允许重新进入 continuation。

## 6. 最小 drill 集

每轮至少跑下面八个 Prompt 宿主稳态纠偏再纠偏改写纠偏精修纠偏执行演练：

1. `message_lineage_replay`
2. `projection_consumer_alignment_replay`
3. `registry_boundary_rebind_replay`
4. `synthesis_custody_replay`
5. `protocol_prefix_repair_replay`
6. `lawful_forgetting_replay`
7. `continuation_qualification_replay`
8. `reopen_liability_replay`

## 7. 复盘记录最少字段

每次 Prompt 宿主稳态纠偏再纠偏改写纠偏精修纠偏失败、再入场或 reopen，至少记录：

1. `repair_card_id`
2. `reprotocol_session_id`
3. `restored_request_object_id`
4. `compiled_request_hash`
5. `message_lineage_ref`
6. `projection_consumer_alignment`
7. `section_registry_generation`
8. `protocol_transcript_health`
9. `continuation_object_ref`
10. `continuation_qualification`
11. `threshold_retained_until`
12. `reject_verdict`
13. `verdict_reason`

## 8. 苏格拉底式检查清单

在你准备宣布“Prompt 已完成稳态纠偏再纠偏改写纠偏精修纠偏执行”前，先问自己：

1. 我救回的是同一条 `message lineage`，还是一份更正式的 refinement 说明。
2. 我重封的是 projection consumer 的边界，还是一张更好看的 UI 历史。
3. 我重新绑定的是 `dynamic boundary`，还是在偷把 late-bound attachment 塞回 stable prefix 正文。
4. 我现在保护的是 `continuation object + continuation qualification`，还是一种“先继续再说”的体面包装。
5. later 团队接手时依赖的是正式对象，还是仍要回到 transcript、handoff 与额外口头补充。

## 9. 一句话总结

真正成熟的 Prompt 宿主修复稳态纠偏再纠偏改写纠偏精修纠偏执行，不是把 repair prose 运行得更熟练，而是持续证明 `message lineage`、projection consumer、`registry boundary`、`stable prefix`、`lawful forgetting`、`continuation object`、`continuation qualification` 与 `reopen liability` 仍被同一张 `repair card` 正式约束。
