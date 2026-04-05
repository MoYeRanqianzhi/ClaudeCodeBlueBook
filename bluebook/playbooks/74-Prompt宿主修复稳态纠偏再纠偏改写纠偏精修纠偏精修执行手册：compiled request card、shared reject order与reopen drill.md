# Prompt宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行手册：compiled request card、shared reject order 与 reopen drill

这一章不再解释 Prompt refinement correction refinement protocol 该共享哪些字段，而是把 Claude Code 式 Prompt refinement correction refinement protocol 压成一张可持续执行的 cross-consumer `compiled request card`。

它主要回答五个问题：

1. 为什么 Prompt 魔力在这一层运行的不是“Prompt 写得更好”，而是同一条 `authority chain -> section registry -> tool contract -> compiled request truth -> protocol truth -> synthesis ownership -> continuation qualification -> cache break truth -> shared reject semantics -> reopen liability` 继续被共同执行。
2. 宿主、CI、评审与交接怎样共享同一张 Prompt `compiled request card`，而不是各自围绕 transcript、handoff、repair prose 与 worker prose 工作。
3. 应该按什么固定顺序执行 `effective authority`、`registry boundary`、`tool contract`、`compiled request truth`、`protocol truth`、`synthesis ownership`、`continuation gate`、`shared reject` 与 `reopen drill`，才能不让 refinement correction refinement protocol 再次退回解释稿。
4. 哪些 `shared reject order` 一旦出现就必须冻结 continuation、阻断 handoff 并进入 `re-entry / reopen`。
5. 怎样用第一性原理与苏格拉底式追问，避免把这层写成“第八套 Prompt 值班表”。

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

- 同一个 authority、同一个 section registry、同一个 tool contract、同一个 compiled request truth、同一条 protocol truth、同一个 synthesis owner、同一条 continuation covenant、同一个 cache break truth 与同一个 reopen liability 仍被再次证明可继续、可交接、也可反对

Claude Code 的 Prompt 魔力之所以看起来像“有魔力”，不是因为它更会写，而是因为它把：

1. `buildEffectiveSystemPrompt()` 的主权顺序
2. `SystemPromptSection` 的注册与动态边界
3. `toolToAPISchema()` 与 tools hash 的合同面
4. `normalizeMessagesForAPI()` 的请求真相
5. `ensureToolResultPairing()` 的 fail-closed protocol truth
6. `coordinator` 对 worker findings 的综合责任
7. `checkTokenBudget()` 的继续资格
8. `promptCacheBreakDetection` 的 drift 真相

压成了同一条可执行对象链。

## 2. 共享 compiled request card 最小字段

每次 Prompt 宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修巡检，宿主、CI、评审与交接系统至少应共享：

1. `compiled_request_card_id`
2. `repair_attestation_id`
3. `reprotocol_session_id`
4. `restored_request_object_id`
5. `effective_authority_chain_hash`
6. `section_registry_generation`
7. `active_section_set`
8. `system_prompt_dynamic_boundary`
9. `tools_hash`
10. `normalized_request_hash`
11. `tool_pairing_health`
12. `synthesis_owner`
13. `worker_findings_refs`
14. `continue_qualification`
15. `continuation_count`
16. `budget_state`
17. `cache_break_reason`
18. `cache_break_reprice_required`
19. `shared_reject_verdict`
20. `threshold_retained_until`
21. `reopen_required_when`
22. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看 authority、section registry、tool contract 与 synthesis owner 是否仍唯一。
2. CI 看 compiled request、protocol truth、continue qualification 与 cache break 顺序是否完整。
3. 评审看 `shared_reject_verdict` 是否仍围绕同一个 compiled request ABI，而不是围绕 transcript 与 handoff prose。
4. 交接看 later 团队能否不依赖作者记忆，只凭 card 继续消费同一个 Prompt 世界。

## 3. 固定 shared reject order

### 3.1 先验 `repair_session_object`

先看当前准备宣布 protocol 可执行的，到底是不是同一个 `reprotocol_session_id` 与 `restored_request_object_id`，而不是一张更体面的说明卡。

### 3.2 再验 `effective_authority_chain`

再看：

1. `override_system_prompt_present`
2. `coordinator_mode_active`
3. `main_thread_agent_definition`
4. `agent_prompt_mode`
5. `append_system_prompt_present`

这一步先回答：

- 当前究竟是谁在定义模型世界

### 3.3 再验 `section_registry_boundary_surface`

再看：

1. `section_registry_snapshot`
2. `section_registry_generation`
3. `active_section_set`
4. `system_prompt_dynamic_boundary`
5. `volatile_section_names`
6. `late_bound_attachment_set`

这一步先回答：

- Prompt 还是 section-based object 吗
- dynamic boundary 还在吗

### 3.4 再验 `tool_contract_surface`

再看：

1. `tools_hash`
2. `per_tool_hashes`
3. `available_tool_names`
4. `strict_tools_enabled`
5. `deferred_tool_names`

这一步先回答：

- 当前模型看到的能力合同，还是不是同一份合同

### 3.5 再验 `compiled_request_truth_surface`

再看：

1. `normalized_request_hash`
2. `virtual_message_count_stripped`
3. `attachment_reorder_applied`
4. `tool_reference_filter_mode`
5. `compiled_request_lineage_ref`

这一步先回答：

- 当前模型消费的是不是同一个请求对象，而不是 UI transcript 的投影

### 3.6 再验 `protocol_truth_and_synthesis_surface`

再看：

1. `tool_pairing_health`
2. `protocol_truth_surface_attested`
3. `synthesis_owner`
4. `worker_findings_refs`
5. `delegated_understanding_forbidden`

这一步先回答：

- 当前 truth 是不是已经被综合，而不是仍是零散 findings

### 3.7 再验 `continuation_and_cache_break_surface`

再看：

1. `continue_qualification`
2. `continuation_count`
3. `budget_pct`
4. `diminishing_returns`
5. `cache_break_reason`
6. `changed_tool_schemas`
7. `system_char_delta`

这一步先回答：

- 当前还能不能合法继续
- cache break 是不是已被正式重定价

### 3.8 再验 `shared_reject_semantics_packet`

再看：

1. `hard_reject`
2. `authority_chain_drifted`
3. `section_registry_unbound`
4. `tool_contract_drifted`
5. `compiled_request_truth_missing`
6. `protocol_pairing_failed`
7. `continue_qualification_failed`
8. `cache_break_reprice_required`
9. `truth_reseal_required`
10. `reentry_required`
11. `reopen_required`

这一步先回答：

- 现在到底应继续、重封、重编译，还是正式 reopen

### 3.9 最后验 `long_horizon_reopen_liability`

最后才看：

1. `truth_break_trigger`
2. `threshold_liability_owner`
3. `threshold_retained_until`
4. `reentry_required_when`
5. `reopen_required_when`
6. `rollback_boundary`

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前 Prompt 执行并冻结 continuation：

1. `authority_chain_broken`
2. `section_registry_generation_missing`
3. `system_prompt_dynamic_boundary_missing`
4. `tool_contract_drifted`
5. `compiled_request_truth_missing`
6. `tool_pairing_unattested`
7. `synthesis_owner_missing`
8. `continue_qualification_failed`
9. `cache_break_reprice_required`

## 5. reopen drill 最小顺序

一旦 verdict 升级为 `reentry_required` 或 `reopen_required`，最低顺序应固定为：

1. 冻结当前 `compiled_request_card`，禁止把 transcript 平静感继续当真。
2. 保存 `effective_authority_chain_hash`、`normalized_request_hash`、`tools_hash`、`cache_break_reason` 与 `worker_findings_refs`。
3. 先重建 `section registry + tool contract`，再重建 `compiled request truth`，最后才考虑重新继续。
4. 明确 `threshold_liability_owner` 与 `reopen_required_when`，禁止把 reopen 写成值班备注。

## 6. 苏格拉底式自检

在你准备宣布“Prompt protocol 已经执行完毕”前，先问自己：

1. 我运行的是同一个 compiled request ABI，还是四份相似解释稿。
2. 我共享的是同一条 shared reject order，还是不同消费者各自的 calmness 标准。
3. 我保留的是合法 continue 的资格，还是一句“先继续再说”。
4. later 团队接手时依赖的是对象、边界与责任，还是仍要回到 transcript、handoff、worker prose 与作者记忆。
5. 我现在保护的是 Claude Code 的 Prompt 魔力，还是只是在把它写成更像制度的 prose。
