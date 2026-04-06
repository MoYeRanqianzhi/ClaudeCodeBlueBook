# Prompt宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修协议：message lineage、shared reject semantics、continuation qualification与long-term reopen liability

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象，让宿主、CI、评审与交接在 Prompt refinement correction refinement fixed order 已被钉死之后，继续消费同一个 `message lineage -> protocol transcript -> shared reject semantics -> continuation qualification` repair truth，而不是退回更顺的 transcript、handoff prose 与 worker 研究总结。
2. 哪些字段属于必须共享的 protocol object，哪些属于共同 `hard_reject / reentry / reopen` 语义，哪些仍不应被绑定成公共 ABI。
3. 为什么 Claude Code 的 Prompt 魔力本质上来自同一条 `message lineage -> role-contract custody -> protocol transcript -> shared reject semantics -> lawful forgetting / continuation qualification -> long-horizon reopen liability` 协议，而不是更会写的 repair prose。
4. 宿主开发者该按什么顺序消费这套 Prompt refinement correction refinement 精修协议。
5. 哪些现象一旦出现，应被直接升级为 `hard_reject`、`protocol_truth_reseal_required`、`shared_reject_rebind_required`、`reentry_required` 或 `reopen_required`，而不是继续宣称 Prompt 魔力仍然成立。

## 0. 关键源码锚点

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

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `PromptRefinementCorrectionRefinementProtocol`

的单独公共对象。

但 Prompt refinement correction refinement fixed order 已经能围绕八类正式对象稳定成立：

1. `repair_session_object`
2. `role_contract_custody`
3. `message_lineage_surface`
4. `protocol_transcript_surface`
5. `shared_reject_semantics_packet`
6. `forgetting_continuation_covenant`
7. `cross_consumer_repair_attestation`
8. `long_horizon_reopen_liability`

更成熟的 Prompt refinement correction refinement 方式不是：

- 只看 transcript 是否更顺
- 只看 handoff 是否更完整
- 只看 worker 研究是否更多

而是：

- 围绕这八类对象继续消费同一份 role contract、同一条 message lineage、同一条 protocol transcript、同一条 shared reject semantics、同一个 lawful forgetting / continuation covenant、同一份 repair attestation 与同一个 threshold liability

## 2. 第一性原理

Prompt 世界真正成熟，不是把“解释更完整”写得更体面，而是：

1. `role contract` 决定谁有资格定义模型世界。
2. `message lineage` 决定 later 团队继承的是不是同一个 request 对象。
3. `protocol transcript` 决定模型实际消费的是不是同一条运行时真相链，而不是显示层历史。
4. `shared reject semantics` 决定宿主、CI、评审与交接是否真的在围绕同一个编译对象说同一种拒收语言。
5. `lawful forgetting / continuation qualification` 决定 compact 与 continue 是不是仍然合法，而不是只是看起来还能继续。
6. `liability + threshold` 决定未来何时必须重入或 reopen。

所以 Prompt 魔力不是两三个“写得好的提示词技巧”，而是同一条协议对象链在跨消费者、跨 compact、跨 handoff 之后仍然成立。

## 3. repair session object 与 role-contract custody

Prompt 宿主应至少围绕下面对象消费 refinement correction refinement 真相：

### 3.1 repair session object

1. `repair_session_id`
2. `reprotocol_session_id`
3. `refinement_session_id`
4. `restored_request_object_id`
5. `repair_generation`
6. `shared_consumer_surface`
7. `repair_started_at`

### 3.2 role-contract custody

1. `override_system_prompt_present`
2. `coordinator_mode_active`
3. `main_thread_agent_definition`
4. `agent_prompt_mode`
5. `append_system_prompt_present`
6. `authority_chain_attested_at`

这些字段回答的不是：

- 当前 repair card 看起来是不是更体面

而是：

- 当前究竟是谁在定义模型世界，以及 later 团队到底能否沿同一条主权链重新消费这个世界

## 4. compiled request truth 与 registry/protocol truth surface

Prompt 宿主还必须显式消费：

### 4.1 compiled request truth surface

1. `restored_request_object_id`
2. `compiled_request_hash`
3. `truth_lineage_ref`
4. `compiled_request_family`
5. `shared_consumer_surface`
6. `request_truth_restituted_at`

### 4.2 registry protocol truth surface

1. `section_registry_snapshot`
2. `section_registry_generation`
3. `active_section_set`
4. `system_prompt_dynamic_boundary`
5. `late_bound_attachment_set`
6. `attachment_binding_order`
7. `coordinator_synthesis_owner`
8. `worker_findings_ref`
9. `protocol_transcript_health`
10. `tool_pairing_health`
11. `transcript_boundary_attested`
12. `stable_prefix_boundary`
13. `registry_protocol_truth_attested`

这里最重要的是：

- `compiled request truth` 不是 handoff packet
- `section registry` 不是静态 TOC
- `protocol truth` 不是 UI 阅读体验
- `tool pairing health` 不是“看起来应该配对”

## 5. shared reject semantics 与 forgetting / continuation covenant

Prompt 宿主、CI、评审与交接还必须共享：

### 5.1 shared reject semantics packet

1. `hard_reject`
2. `protocol_truth_reseal_required`
3. `shared_reject_rebind_required`
4. `repair_attestation_rebuild_required`
5. `reentry_required`
6. `reopen_required`
7. `consumer_projection_demoted`

### 5.2 forgetting continuation covenant

1. `lawful_forgetting_boundary`
2. `preserved_segment_ref`
3. `compaction_lineage`
4. `continue_qualification`
5. `token_budget_ready`
6. `cache_break_reason`
7. `continuation_covenant_attested`

这里最重要的是：

- `shared reject semantics` 不是四类消费者各自的意见表
- `lawful forgetting` 不是“摘要还能看懂”
- `continue qualification` 不是“token 似乎还够”

## 6. cross-consumer repair attestation 与 long-horizon reopen liability

Prompt 宿主还必须显式消费：

### 6.1 cross consumer repair attestation

1. `repair_attestation_id`
2. `authority_chain_ref`
3. `compiled_request_truth_ref`
4. `registry_protocol_truth_ref`
5. `shared_reject_semantics_ref`
6. `consumer_projection_demoted`
7. `repair_attested_at`

### 6.2 long horizon reopen liability

1. `return_request_object`
2. `return_registry_generation`
3. `return_protocol_truth_ref`
4. `threshold_retained_until`
5. `reentry_required_when`
6. `reopen_required_when`
7. `liability_owner`
8. `long_horizon_reopen_liability_attested`

这里最重要的是：

- `repair attestation` 不是“大家都看过”
- `reopen liability` 不是“以后再看”
- Prompt 魔力真正需要 later 团队独立复证，而不是依赖当前作者继续解释

## 7. 宿主消费顺序

更稳的宿主消费顺序应固定为：

1. `repair_session_object`
2. `repair_authority_chain`
3. `compiled_request_truth_surface`
4. `registry_protocol_truth_surface`
5. `shared_reject_semantics_packet`
6. `forgetting_continuation_covenant`
7. `cross_consumer_repair_attestation`
8. `long_horizon_reopen_liability`

不要反过来：

1. 不要先看 transcript 是否顺，再看 authority。
2. 不要先看 handoff 是否完整，再看 compiled request truth。
3. 不要先看 token 是否够，再看 continue qualification。
4. 不要先写 reopen 备注，再看 threshold 与 liability owner。

## 8. 共同 reject / escalation 语义

出现下面情况时，应直接升级为共同 reject 或 escalation：

1. `repair_session_missing`
2. `authority_chain_broken`
3. `compiled_request_truth_missing`
4. `registry_generation_missing`
5. `protocol_truth_unattested`
6. `tool_pairing_unattested`
7. `shared_reject_semantics_missing`
8. `lawful_forgetting_boundary_missing`
9. `continue_qualification_missing`
10. `threshold_retained_until_missing`

## 9. 苏格拉底式自检

在你准备宣布“Prompt 精修精修协议已经对象化”前，先问自己：

1. 我共享的是同一个 Prompt 编译对象，还是四份彼此相像的说明稿。
2. 我共享的是同一条 reject 语义链，还是四类消费者各自的 calmness 标准。
3. 我保留的是合法 continue 的资格，还是一句“先继续再说”。
4. later 团队接手时依赖的是对象、边界与责任，还是仍要回到 transcript、handoff、worker prose 与作者记忆。
5. 我现在保护的是 Claude Code 的 Prompt 魔力，还是只是在把它写成更像制度的 prose。
