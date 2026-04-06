# Prompt宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行手册：continuation object card、shared reject order、cache-safe fork与reopen drill

这一章不再解释 Prompt refinement correction refinement protocol 该共享哪些字段，而是把 Claude Code 式 Prompt refinement correction refinement protocol 压成一张可持续执行的 cross-consumer `continuation object card`。

它主要回答五个问题：

1. 为什么 Prompt 魔力在这一层运行的不是“Prompt 写得更好”，而是同一条 `authority chain -> message lineage -> section registry -> dynamic boundary -> protocol transcript -> projection consumer alignment -> continuation object -> continuation qualification -> cache-safe fork reuse -> reopen liability` 继续被共同执行。
2. 宿主、CI、评审与交接怎样共享同一张 Prompt `continuation object card`，而不是各自围绕 transcript、handoff、repair prose 与 worker prose 工作。
3. 应该按什么固定顺序执行 `authority chain`、`message lineage`、`registry/protocol reseal`、`continuation object`、`continuation qualification`、`cache-safe fork reuse`、`shared reject` 与 `reopen drill`，才能不让 refinement correction refinement protocol 再次退回解释稿。
4. 哪些 `shared reject order` 一旦出现就必须冻结 continuation、阻断 handoff 并进入 `re-entry / reopen`。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成又一张 Prompt 执行流程表。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/systemPrompt.ts:28-123`
- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:491-576`
- `claude-code-source-code/src/utils/api.ts:119-405`
- `claude-code-source-code/src/utils/messages.ts:1481-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/coordinator/coordinatorMode.ts:207-257`
- `claude-code-source-code/src/tools/AgentTool/prompt.ts:101-112`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-66`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:483-698`

## 1. 第一性原理

Prompt 宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修真正要执行的不是：

- transcript 又更顺了
- handoff 又更完整了
- prompt wording 又更像制度了

而是：

- 同一条 `message lineage` 是否仍承载当前请求对象。
- `section registry + dynamic boundary` 是否仍决定什么能进入 stable prefix，什么必须晚绑定。
- `protocol transcript` 是否仍是模型真正消费的历史，projection consumer 是否仍只消费自己的合法投影。
- `continuation object` 与 `continuation qualification` 是否仍沿同一条 lawful forgetting 链生效。
- summary、worker、memory 与 suggestion 是否仍复用同一 stable prefix，而不是长出平行世界。

Claude Code 的 Prompt 魔力之所以成立，不是因为它把 tool contract、cache break 或 wording 单独做得更强，而是因为它把这些证据面都压回了同一条 continuation object 链。

## 2. 共享 continuation object card 最小字段

每次 Prompt 宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修巡检，宿主、CI、评审与交接系统至少应共享：

1. `continuation_object_card_id`
2. `reprotocol_session_id`
3. `restored_request_object_id`
4. `compiled_request_hash`
5. `message_lineage_ref`
6. `projection_consumer_alignment`
7. `section_registry_generation`
8. `active_section_set`
9. `system_prompt_dynamic_boundary`
10. `stable_prefix_boundary`
11. `lawful_forgetting_boundary`
12. `protocol_transcript_health`
13. `tools_hash_evidence`
14. `worker_findings_refs`
15. `continuation_object_ref`
16. `continuation_qualification`
17. `cache_safe_fork_reuse_state`
18. `cache_break_reason`
19. `shared_reject_verdict`
20. `threshold_retained_until`
21. `reopen_required_when`
22. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看 `authority chain`、`message lineage` 与 `continuation_object_ref` 是否仍唯一。
2. CI 看 `section registry`、`protocol transcript`、`continuation qualification` 与 `cache-safe fork reuse` 顺序是否完整。
3. 评审看 `shared_reject_verdict` 是否仍围绕同一个 continuation object ABI，而不是围绕 transcript 与 handoff prose。
4. 交接看 later 团队能否只凭 card 继续消费同一个 Prompt 世界。

## 3. 固定 shared reject order

### 3.1 先验 `repair_session_object`

先看当前准备宣布 protocol 可执行的，到底是不是同一个 `reprotocol_session_id` 与 `restored_request_object_id`，而不是一张更体面的说明卡。

### 3.2 再验 `authority_chain_and_message_lineage`

再看：

1. `effective_authority_chain_hash`
2. `restored_request_object_id`
3. `compiled_request_hash`
4. `message_lineage_ref`
5. `projection_consumer_alignment`

这一步先回答：

- 当前究竟是谁在定义模型世界
- 四类消费者共享的是不是同一条 lineage

### 3.3 再验 `section_registry_boundary_and_protocol_transcript`

再看：

1. `section_registry_snapshot`
2. `section_registry_generation`
3. `active_section_set`
4. `system_prompt_dynamic_boundary`
5. `protocol_transcript_health`
6. `tools_hash_evidence`

这一步先回答：

- Prompt 还是 section-based object 吗
- dynamic boundary 还在吗
- tool contract 还是不是同一份合同

### 3.4 再验 `continuation_object_qualification_and_cache_safe_fork`

再看：

1. `stable_prefix_boundary`
2. `lawful_forgetting_boundary`
3. `continuation_object_ref`
4. `continuation_qualification`
5. `cache_safe_fork_reuse_state`
6. `cache_break_reason`
7. `worker_findings_refs`

这一步先回答：

- 当前还能不能合法继续
- cache break 是不是已被正式重定价
- summary、worker、memory 与 suggestion 是不是仍在复用同一 stable prefix

### 3.5 再验 `shared_reject_semantics_packet`

再看：

1. `hard_reject`
2. `authority_chain_broken`
3. `message_lineage_ref_missing`
4. `projection_consumer_split_detected`
5. `section_registry_unbound`
6. `protocol_transcript_reseal_required`
7. `continuation_object_missing`
8. `continuation_qualification_failed`
9. `cache_safe_fork_rebuild_required`
10. `cache_break_reprice_required`
11. `reentry_required`
12. `reopen_required`

这一步先回答：

- 现在到底应继续、重封、重建 continuation object，还是正式 reopen

### 3.6 最后验 `long_horizon_reopen_liability`

最后才看：

1. `truth_break_trigger`
2. `threshold_liability_owner`
3. `threshold_retained_until`
4. `reentry_required_when`
5. `reopen_required_when`
6. `rollback_boundary`

更稳的最终 verdict 只应落在：

1. `steady_state_chain_resealed`
2. `hard_reject`
3. `section_registry_unbound`
4. `protocol_transcript_reseal_required`
5. `continuation_object_missing`
6. `continuation_qualification_failed`
7. `cache_safe_fork_rebuild_required`
8. `cache_break_reprice_required`
9. `reentry_required`
10. `reopen_required`

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前 Prompt 执行并冻结 continuation：

1. `authority_chain_broken`
2. `message_lineage_ref_missing`
3. `projection_consumer_split_detected`
4. `section_registry_generation_missing`
5. `system_prompt_dynamic_boundary_missing`
6. `protocol_transcript_unattested`
7. `stable_prefix_boundary_missing`
8. `lawful_forgetting_boundary_missing`
9. `continuation_object_missing`
10. `continuation_qualification_failed`
11. `cache_safe_fork_unproved`
12. `cache_break_reprice_required`
13. `reopen_required`

## 5. reopen drill 最小顺序

一旦 verdict 升级为 `reentry_required` 或 `reopen_required`，最低顺序应固定为：

1. 冻结当前 `continuation_object_card`，禁止把 transcript 平静感继续当真。
2. 保存 `effective_authority_chain_hash`、`compiled_request_hash`、`message_lineage_ref`、`stable_prefix_boundary`、`cache_break_reason` 与 `worker_findings_refs`。
3. 先重建 `authority chain + message lineage`，再重建 `section registry + protocol transcript`，最后才考虑重新生成 `continuation object`。
4. 明确 `threshold_liability_owner` 与 `reopen_required_when`，禁止把 reopen 写成值班备注。

## 6. 苏格拉底式自检

在你准备宣布“Prompt protocol 已经执行完毕”前，先问自己：

1. 我运行的是同一个 continuation object ABI，还是四份相似解释稿。
2. 我共享的是同一条 `shared reject order`，还是不同消费者各自的 calmness 标准。
3. 我保留的是合法 continue 的资格，还是一句“先继续再说”。
4. later 团队接手时依赖的是 `message lineage`、`continuation object` 与 cache-safe fork reuse，还是仍要回到 transcript、handoff 与 worker prose。
5. 我现在保护的是 Claude Code 的 Prompt 魔力，还是只是在把它写成更像制度的 prose。

## 7. 一句话总结

真正成熟的 Prompt 宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行，不是把 Prompt 写得更像制度，而是持续证明同一条 `message lineage -> protocol transcript -> continuation object -> continuation qualification -> cache-safe fork reuse` 仍被四类消费者共同承认。
