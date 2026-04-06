# Prompt宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行手册：projection consumer repair card、shared reject order、continuation object与reopen drill

这一章不再解释 Prompt refinement correction repair protocol 该共享哪些字段，而是把 Claude Code 式 Prompt refinement correction repair protocol 压成一张可持续执行的 cross-consumer `repair card`。

它主要回答五个问题：

1. 为什么 Prompt 魔力在精修纠偏精修执行里运行的不是“repair 对象说明更完整”，而是同一条 `message lineage -> projection consumer alignment -> registry boundary -> protocol transcript -> continuation object -> continuation qualification -> cache-safe fork reuse -> reopen liability` 继续被共同消费。
2. 宿主、CI、评审与交接怎样共享同一张 Prompt `repair card`，而不是各自围绕 transcript、handoff、repair prose 与 worker prose 工作。
3. 应该按什么固定顺序执行 `repair session`、`message lineage`、`projection consumer demotion`、`registry/protocol reseal`、`continuation object requalification`、`cache-safe fork reuse`、`shared reject semantics` 与 `reopen liability`，才能不让 refinement correction repair protocol 再次退回解释稿。
4. 哪些 `shared reject order` 一旦出现就必须冻结 continuation、阻断 handoff 并进入 `re-entry / reopen` drill。
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

Prompt 宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修真正要执行的不是：

- `repair object` 说明又写得更像制度
- transcript 又更顺了
- handoff packet 又能把当前状态解释圆

而是：

- 四类消费者是不是仍围绕同一条 `message lineage` 工作，而不是各自维护一份“差不多的 Prompt 世界”。
- `protocol transcript` 是否仍是模型真正消费的历史，display transcript 与 handoff object 是否只是它的合法投影。
- `continuation object` 是否仍挂在同一条 lawful forgetting 链上，`continuation qualification` 是否仍明确说明为什么当前能继续。
- summary、worker、memory 与 suggestion 是否仍复用同一 stable prefix，而不是长出平行世界。

Claude Code 的 Prompt 魔力之所以看起来像“有魔力”，不是因为它更会写，而是因为它把四类消费者统一压回：

1. 同一条 `message lineage`
2. 同一组 projection consumer 边界
3. 同一条 protocol transcript
4. 同一个 continuation object
5. 同一套 cache-safe fork reuse 纪律

## 2. 共享 repair card 最小字段

每次 Prompt 宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修巡检，宿主、CI、评审与交接系统至少应共享：

1. `repair_card_id`
2. `repair_attestation_id`
3. `reprotocol_session_id`
4. `restored_request_object_id`
5. `compiled_request_hash`
6. `message_lineage_ref`
7. `projection_consumer_alignment`
8. `section_registry_generation`
9. `active_section_set`
10. `system_prompt_dynamic_boundary`
11. `protocol_transcript_health`
12. `stable_prefix_boundary`
13. `lawful_forgetting_boundary`
14. `continuation_object_ref`
15. `continuation_qualification`
16. `cache_safe_fork_reuse_state`
17. `compaction_safe_summary`
18. `reject_verdict`
19. `threshold_retained_until`
20. `reopen_required_when`
21. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看 `message_lineage_ref`、`projection_consumer_alignment` 与 `continuation_object_ref` 是否仍唯一。
2. CI 看 `registry boundary -> protocol transcript -> continuation qualification -> cache-safe fork reuse` 顺序是否完整。
3. 评审看 `reject_verdict` 是否仍围绕同一个 Prompt 编译对象，而不是围绕 repair prose。
4. 交接看 later 团队能否只凭 `repair card` 延续同一条 lineage，而不需要额外口头补充。

## 3. 固定 shared reject order

### 3.1 先验 `repair_session_object`

先看当前准备宣布 refinement correction repair protocol 可执行的，到底是不是同一个 `reprotocol_session_id`，而不是一张更体面的解释卡。

### 3.2 再验 `message_lineage_and_projection_consumer`

再看：

1. `restored_request_object_id`
2. `compiled_request_hash`
3. `message_lineage_ref`
4. `projection_consumer_alignment`
5. `consumer_projection_demoted`

这一步先回答：

- 当前四类消费者拿到的是不是同一个对象，而不是四份相似解释稿

### 3.3 再验 `registry_boundary_and_protocol_transcript`

再看：

1. `section_registry_snapshot`
2. `section_registry_generation`
3. `active_section_set`
4. `system_prompt_dynamic_boundary`
5. `protocol_transcript_health`
6. `tool_pairing_health`

这一步先回答：

- runtime registry 还活着吗
- 模型消费的是 protocol transcript，还是显示层 transcript

### 3.4 再验 `continuation_object_and_cache_safe_fork`

再看：

1. `stable_prefix_boundary`
2. `lawful_forgetting_boundary`
3. `continuation_object_ref`
4. `continuation_qualification`
5. `cache_safe_fork_reuse_state`
6. `compaction_safe_summary`

这一步先回答：

- compact、resume、handoff 后保住的是不是同一个 continuation object
- summary、worker、memory 与 suggestion 是否仍在复用同一 stable prefix

### 3.5 再验 `shared_reject_semantics_packet`

再看：

1. `hard_reject`
2. `message_lineage_ref_missing`
3. `projection_consumer_split_detected`
4. `registry_reseal_required`
5. `protocol_transcript_reseal_required`
6. `continuation_object_rebuild_required`
7. `continuation_requalification_required`
8. `cache_safe_fork_rebuild_required`
9. `reentry_required`
10. `reopen_required`

这一步先回答：

- 现在到底应该继续、回跳、重建 continuation object，还是正式 reopen

### 3.6 最后验 `long_horizon_reopen_liability`

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
3. `registry_reseal_required`
4. `protocol_transcript_reseal_required`
5. `continuation_object_rebuild_required`
6. `continuation_requalification_required`
7. `cache_safe_fork_rebuild_required`
8. `reentry_required`
9. `reopen_required`

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前 Prompt refinement correction repair execution：

1. `repair_session_missing`
2. `message_lineage_ref_missing`
3. `projection_consumer_split_detected`
4. `registry_boundary_unsealed`
5. `protocol_transcript_unattested`
6. `tool_pairing_unlawful`
7. `stable_prefix_boundary_missing`
8. `lawful_forgetting_boundary_missing`
9. `continuation_object_missing`
10. `continuation_qualification_failed`
11. `cache_safe_fork_unproved`
12. `compaction_summary_claimed_as_truth`
13. `threshold_liability_missing`
14. `reopen_required`

## 5. re-entry 与 reopen 处理顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先冻结新的 continuation、compact export 与 handoff，不再让 later 团队继续消费当前 `repair card`。
2. 先把 verdict 降级为 `hard_reject`、`registry_reseal_required`、`protocol_transcript_reseal_required`、`continuation_object_rebuild_required`、`continuation_requalification_required`、`cache_safe_fork_rebuild_required`、`reentry_required` 或 `reopen_required`。
3. 先把 repair prose、display transcript、handoff prose 与未综合的 worker prose 降回线索，不再让它们充当 truth object。
4. 先重建 `message lineage + projection consumer alignment`，再重建 `registry boundary + protocol transcript`，最后才重建 `continuation object + cache-safe fork reuse`。
5. 只有当 `continuation_object_ref + continuation_qualification + threshold liability` 被重新绑定后，才允许重新 continuation。

## 6. 最小 drill 集

每轮至少跑下面八个 Prompt 宿主稳态纠偏再纠偏改写纠偏精修纠偏精修执行演练：

1. `message_lineage_reconsume`
2. `projection_consumer_alignment_replay`
3. `registry_boundary_reseal_replay`
4. `protocol_transcript_reseal_replay`
5. `lawful_forgetting_replay`
6. `continuation_object_replay`
7. `cache_safe_fork_replay`
8. `reopen_liability_replay`

## 7. 复盘记录最少字段

每次 Prompt 宿主稳态纠偏再纠偏改写纠偏精修纠偏精修失败、再入场或 reopen，至少记录：

1. `repair_card_id`
2. `repair_attestation_id`
3. `restored_request_object_id`
4. `compiled_request_hash`
5. `message_lineage_ref`
6. `projection_consumer_alignment`
7. `protocol_transcript_health`
8. `continuation_object_ref`
9. `continuation_qualification`
10. `cache_safe_fork_reuse_state`
11. `reject_verdict`
12. `reopen_required_when`

## 8. 苏格拉底式自检

在你准备宣布“Prompt refinement correction repair protocol 已经进入 steady execution”前，先问自己：

1. 我现在让四类消费者共享的是同一个编译对象，还是四份长得相似的解释稿。
2. 我现在共享的是同一条 `shared reject order`，还是不同消费者各自的 calmness 标准。
3. 我现在保留的是 formal continuation object，还是一句“先继续再说”。
4. later 团队接手时依赖的是 `message lineage`、projection consumer 与 threshold liability，还是仍要回到 transcript、handoff 与 worker prose。
5. 当前执行保护的是 Prompt 真相的正式延续，还是只是在把 repair protocol 写成更体面的流程页。

## 9. 一句话总结

真正成熟的 Prompt 宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行，不是让 repair prose 更像制度，而是持续证明 `message lineage`、projection consumer、`protocol transcript`、`continuation object`、`continuation qualification` 与 `cache-safe fork reuse` 仍被同一张 `repair card` 正式约束。
