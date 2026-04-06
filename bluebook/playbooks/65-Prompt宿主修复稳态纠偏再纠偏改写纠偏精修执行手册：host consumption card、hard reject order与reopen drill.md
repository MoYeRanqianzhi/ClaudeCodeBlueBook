# Prompt宿主修复稳态纠偏再纠偏改写纠偏精修执行手册：message lineage card、shared reject order与reopen drill

这一章不再解释 Prompt refinement protocol 该消费哪些字段，而是把 Claude Code 式 Prompt rewrite correction refinement protocol 压成一张可持续执行的 `host consumption card`。

它主要回答五个问题：

1. 为什么 Prompt 魔力在精修执行里运行的不是“Prompt 说明更完整”，而是同一条 `message lineage -> compiled request truth -> section registry -> dynamic boundary -> protocol transcript -> stable prefix -> lawful forgetting -> continuation object -> continuation qualification -> threshold liability` 继续被共同消费。
2. 宿主、CI、评审与交接怎样共享同一张 Prompt `host consumption card`，而不是各自围绕 rewrite prose、summary handoff、UI transcript 与子 Agent prose 工作。
3. 应该按什么固定顺序执行 `refinement session`、`false projection demotion`、`compiled request lineage`、`registry-boundary rewrite`、`coordinator synthesis custody`、`protocol-prefix custody`、`forgetting-continuation covenant`、`hard reject semantics`、`cross-consumer attestation` 与 `reopen liability ledger`，才能不让 refinement protocol 重新退回解释稿。
4. 哪些 `hard reject` 一旦出现就必须冻结 continuation、阻断 handoff 并进入 `re-entry / reopen` drill。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“第五套 Prompt 值班表”。

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

Prompt 宿主修复稳态纠偏再纠偏改写纠偏精修真正要执行的不是：

- refinement note 写得更像制度
- summary handoff 更完整
- UI transcript 更安静

而是：

- 同一条 `message lineage` 上的 `compiled request truth`、`section registry`、`dynamic boundary`、`protocol transcript`、`stable prefix`、`lawful forgetting boundary`、`continuation object`、`continuation qualification` 与 `threshold liability` 仍被宿主、CI、评审与交接共同消费

所以这层 playbook 最先要看的不是：

- `host consumption card` 已经填完了

而是：

1. 当前 refinement session 是否仍围绕同一个 `restored_request_object_id + compiled_request_hash + truth_lineage_ref`。
2. 当前 `registry-boundary rewrite` 是否真的把 runtime `section registry` 与 `dynamic boundary` 从 prose、目录表与 attachment 说明里救出来。
3. 当前 `coordinator_synthesis_owner` 是否仍阻止未综合的子 Agent prose 篡位成主线 truth。
4. 当前 projection consumer 是否仍围绕同一条 lineage 消费 truth，而不是各自消费不同投影。
5. 当前 `protocol-prefix custody` 是否仍把 `tool pairing`、`stable prefix` 与 `cache break threshold` 放在同一条合法编译链上。
6. 当前 `reopen liability ledger` 是否仍保留未来反对当前状态的正式能力。

## 2. 共享 host consumption card 最小字段

每次 Prompt 宿主修复稳态纠偏再纠偏改写纠偏精修巡检，宿主、CI、评审与交接系统至少应共享：

1. `host_consumption_card_id`
2. `refinement_session_id`
3. `rewrite_correction_session_id`
4. `restored_request_object_id`
5. `compiled_request_hash`
6. `truth_lineage_ref`
7. `projection_consumer_alignment`
8. `section_registry_snapshot`
9. `section_registry_generation`
10. `system_prompt_dynamic_boundary`
11. `late_bound_attachment_set`
12. `coordinator_synthesis_owner`
13. `protocol_transcript_health`
14. `stable_prefix_boundary`
15. `lawful_forgetting_boundary`
16. `continuation_object_ref`
17. `continue_qualification`
18. `threshold_retained_until`
19. `shared_consumer_surface`
20. `cross_consumer_attested`
21. `reject_verdict`
22. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看 `compiled request lineage`、`registry generation`、`projection_consumer_alignment` 与 `coordinator_synthesis_owner` 是否仍唯一。
2. CI 看 `registry-boundary`、`protocol-prefix`、`forgetting-continuation` 与 `hard reject` 顺序是否完整。
3. 评审看 `reject_verdict` 是否仍围绕同一个 Prompt 编译对象，而不是围绕说明文与 UI 历史。
4. 交接看 later 团队能否只凭 `host consumption card` 重建同一继续、拒收与 reopen 判断，而不把 display truth 误当 protocol truth。

## 3. 固定 hard reject 顺序

### 3.1 先验 `rewrite_refinement_session_object`

先看当前准备宣布 refinement 成立的，到底是不是同一个 `refinement_session_id`，而不是一份更会解释的 Prompt 补充文稿。

### 3.2 再验 `false_projection_demotion_contract`

再看：

1. `rewrite_prose_demoted` 是否仍成立。
2. `ui_transcript_not_truth` 是否仍成立。
3. `summary_override_blocked` 与 `attachment_premature_binding_blocked` 是否仍阻止显示层历史冒充编译真相。

### 3.3 再验 `compiled_request_lineage_covenant`

再看：

1. `restored_request_object_id + compiled_request_hash + truth_lineage_ref` 是否仍指向同一条 request lineage。
2. `compiled_request_family` 是否仍让 later 消费者继承的是同一个 request family，而不是一份更体面的解释稿。
3. `projection_consumer_alignment` 是否仍保证 display / protocol / handoff 消费的是同一条 lineage。

### 3.4 再验 `registry_boundary_rewrite_packet`

再看：

1. `section_registry_snapshot` 与 `section_registry_generation` 是否仍自洽。
2. `system_prompt_dynamic_boundary` 与 `late_bound_attachment_set` 是否仍清楚分层。
3. `attachment_binding_order` 是否仍保证 attachment 只在合法位置晚绑定。

### 3.5 再验 `coordinator_synthesis_custody`

再看：

1. `coordinator_synthesis_owner` 是否仍唯一。
2. `synthesis_required_before_rebind` 是否仍阻止未综合的子 Agent prose 越权。
3. `worker_findings_ref` 是否仍只作为线索，而不是直接充当主线真相。

### 3.6 再验 `protocol_prefix_custody`

再看：

1. `protocol_transcript_health` 是否仍成立。
2. `tool_pairing_health` 是否仍防止 UI transcript 冒充协议真相。
3. `stable_prefix_boundary`、`cache_break_budget` 与 `cache_break_threshold` 是否仍围绕同一 prefix asset。

### 3.7 再验 `forgetting_continuation_covenant`

再看：

1. `lawful_forgetting_boundary` 与 `preserved_segment_ref` 是否仍成立。
2. `compaction_lineage` 是否仍让 compact 后的继续链合法。
3. `continuation_object_ref` 是否仍让 compact / handoff 后的继续对象挂回同一条 lineage。
4. `continue_qualification` 与 `token_budget_ready` 是否仍让继续资格回到正式对象。

### 3.8 再验 `hard_reject_semantics_abi` 与 `cross_consumer_attestation_packet`

再看：

1. `hard_reject`、`truth_recompile_required`、`registry_reseal_required`、`boundary_rebind_required`、`protocol_repair_required` 是否仍围绕对象链触发。
2. `shared_consumer_surface` 是否仍让宿主、CI、评审与交接消费同一组 verdict。

### 3.9 最后验 `reopen_liability_ledger` 与 `reject_verdict`

最后才看：

1. `truth_break_trigger`、`reentry_required_when` 与 `reopen_required_when` 是否仍正式保留。
2. `threshold_retained_until` 是否仍让 future reopen 不是一句礼貌备注。
3. `reject_verdict` 是否与前八步对象完全一致。

更稳的最终 verdict 只应落在：

1. `steady_state_chain_resealed`
2. `hard_reject`
3. `truth_recompile_required`
4. `registry_reseal_required`
5. `boundary_rebind_required`
6. `protocol_repair_required`
7. `continuation_requalification_required`
8. `reentry_required`
9. `reopen_required`

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前 Prompt refinement execution：

1. `refinement_session_missing`
2. `compiled_request_truth_unrestituted`
3. `truth_lineage_ref_missing`
4. `section_registry_staticized`
5. `dynamic_boundary_unattested`
6. `late_bound_attachment_promoted`
7. `coordinator_synthesis_owner_missing`
8. `tool_pairing_health_failed`
9. `stable_prefix_boundary_missing`
10. `lawful_forgetting_boundary_missing`
11. `continue_qualification_unbound`
12. `threshold_liability_missing`
13. `reopen_required`
14. `projection_consumer_split_detected`
15. `continuation_object_missing`

## 5. re-entry 与 reopen 处理顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先冻结新的 continuation 与 handoff，不再让 later 团队继续消费当前 `host consumption card`。
2. 先把 verdict 降级为 `hard_reject`、`truth_recompile_required`、`registry_reseal_required`、`boundary_rebind_required`、`protocol_repair_required`、`reentry_required` 或 `reopen_required`。
3. 先把 rewrite prose、summary handoff、UI transcript 与子 Agent 未综合 prose 降回线索，不再让它们充当 truth object。
4. 先回到上一个仍可验证的 `restored_request_object_id`、`section_registry_snapshot` 或 `stable_prefix_boundary`，补新的 lineage attestation、registry-boundary reseal、synthesis custody、protocol-prefix repair 与 continuation qualification。
5. 如果根因落在 refinement protocol 本身，就回跳 `../api/84` 做对象级修正。

## 6. 最小 drill 集

每轮至少跑下面八个 Prompt 宿主稳态纠偏再纠偏改写纠偏精修执行演练：

1. `refinement_session_replay`
2. `compiled_request_lineage_replay`
3. `registry_boundary_rewrite_replay`
4. `coordinator_synthesis_custody_replay`
5. `protocol_prefix_custody_replay`
6. `forgetting_continuation_replay`
7. `hard_reject_escalation_replay`
8. `reopen_liability_replay`

## 7. 复盘记录最少字段

每次 Prompt 宿主稳态纠偏再纠偏改写纠偏精修失败、再入场或 reopen，至少记录：

1. `host_consumption_card_id`
2. `refinement_session_id`
3. `rewrite_correction_session_id`
4. `restored_request_object_id`
5. `compiled_request_hash`
6. `truth_lineage_ref`
7. `projection_consumer_alignment`
8. `section_registry_generation`
9. `system_prompt_dynamic_boundary`
10. `coordinator_synthesis_owner`
11. `protocol_transcript_health`
12. `stable_prefix_boundary`
13. `lawful_forgetting_boundary`
14. `continuation_object_ref`
15. `continue_qualification`
16. `threshold_retained_until`
17. `shared_consumer_surface`
18. `cross_consumer_attested`
19. `reject_verdict`
20. `verdict_reason`

## 8. 苏格拉底式检查清单

在你准备宣布“Prompt 已完成稳态纠偏再纠偏改写纠偏精修执行”前，先问自己：

1. 我救回的是同一条 `message lineage` 上的 `compiled request truth`，还是一份更正式的 refinement 说明。
2. 我重封的是 runtime `section registry`，还是一张更好看的目录表。
3. 我重新绑定的是 `dynamic boundary`，还是在偷把 late-bound attachment 塞回 stable prefix 正文。
4. 我现在让 display / protocol / handoff 消费的是同一条 lineage，还是三套互相漂移的投影。
5. 我现在保护的是 `coordinator_synthesis_owner + protocol transcript`，还是一组更顺滑的显示层历史。
6. 我现在保留的是未来继续与未来反对当前状态的正式条件，还是一种“先继续再说”的体面包装。

## 9. 一句话总结

真正成熟的 Prompt 宿主修复稳态纠偏再纠偏改写纠偏精修执行，不是把 refinement note 运行得更熟练，而是持续证明同一条 `message lineage -> compiled request truth -> registry -> boundary -> synthesis -> protocol -> prefix -> forgetting -> continuation object -> continuation qualification -> threshold` 编译链仍被同一张 `host consumption card` 正式约束。
