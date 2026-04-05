# 治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行手册：pricing card、shared reject order 与 reopen drill

这一章不再解释治理 refinement correction refinement protocol 该共享哪些字段，而是把 Claude Code 式治理 refinement correction refinement protocol 压成一张可持续执行的 cross-consumer `pricing card`。

它主要回答五个问题：

1. 为什么安全设计与省 token 设计在这一层运行的不是“两套系统互相权衡”，而是同一个治理控制面持续拒绝未定价扩张。
2. 宿主、CI、评审与交接怎样共享同一张治理 `pricing card`，而不是各自宣布不同版本的“现在可以继续”。
3. 应该按什么固定顺序执行 `authority mode`、`action candidate`、`window truth`、`continuation gate`、`classifier pricing`、`denial threshold`、`writeback attestation`、`ingress lineage`、`shared reject` 与 `reopen drill`，才能不让免费继续、免费扩窗与免费放权重新进场。
4. 哪些 `shared reject order` 一旦出现就必须冻结 capability expansion、拒绝 handoff 并进入 `liability / re-entry / reopen`。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的治理值班表”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/Tool.ts:123-176`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-619`
- `claude-code-source-code/src/utils/permissions/PermissionMode.ts:111-181`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-1318`
- `claude-code-source-code/src/utils/permissions/yoloClassifier.ts:1175-1312`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/utils/analyzeContext.ts:918-1382`
- `claude-code-source-code/src/utils/sessionState.ts:15-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:4-112`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-211`

## 1. 第一性原理

治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修真正要执行的不是：

- mode 名字恢复正常
- usage 面板重新转绿
- later 团队愿意先保守一点

而是：

- authority、action、window、continuation、classifier、reject、writeback、ingress 与 liability 仍围绕同一个治理对象正式宣布：现在什么能继续、什么值得继续、什么必须被拒绝继续

Claude Code 当前已经把治理 truth 拆在九类对象上：

1. `authority_mode_surface`
2. `action_candidate_surface`
3. `blocked_action_surface`
4. `window_truth_surface`
5. `continuation_gate_surface`
6. `classifier_pricing_surface`
7. `denial_threshold_surface`
8. `writeback_attestation_surface`
9. `ingress_lineage_surface`

这一层 playbook 的任务不是再发明第十条“感觉”，而是把这九条对象链压成同一个可执行 card。

## 2. 共享 pricing card 最小字段

每次治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修巡检，宿主、CI、评审与交接系统至少应共享：

1. `pricing_card_id`
2. `repair_attestation_id`
3. `reprotocol_session_id`
4. `governance_object_id`
5. `permission_mode_external`
6. `is_ultraplan_mode`
7. `action_candidate_ref`
8. `pending_action_ref`
9. `window_total_tokens`
10. `window_max_tokens`
11. `window_pct`
12. `reserved_tokens`
13. `continuation_action`
14. `continuation_count`
15. `classifier_cost_usd`
16. `classifier_should_block`
17. `classifier_reason`
18. `consecutive_denials`
19. `pending_permission_requests_count`
20. `writeback_attested`
21. `ingress_head_uuid`
22. `shared_reject_verdict`
23. `threshold_retained_until`
24. `reopen_required_when`
25. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看 authority mode、action candidate 与 blocking projection 是否仍唯一。
2. CI 看 window、continuation、classifier、denial threshold、writeback 与 ingress 顺序是否完整。
3. 评审看 `shared_reject_verdict` 是否仍围绕同一个统一定价对象，而不是围绕 mode 面板与 usage dashboard 投影。
4. 交接看 later 团队能否只凭 `pricing card` 重建同一判定与责任边界。

## 3. 固定 shared reject order

### 3.1 先验 `repair_session_object`

先看当前准备宣布 protocol 可执行的，到底是不是同一个 `governance_object_id`，而不是一张更正式的稳定说明。

### 3.2 再验 `authority_mode_surface`

再看：

1. `permission_mode`
2. `is_ultraplan_mode`
3. `is_auto_mode_available`
4. `should_avoid_permission_prompts`
5. `await_automated_checks_before_dialog`

这一步先回答：

- 当前究竟谁在为扩权背书

### 3.3 再验 `action_candidate_and_blocking_projection`

再看：

1. `tool_name`
2. `input`
3. `permission_suggestions`
4. `blocked_path`
5. `decision_reason`
6. `tool_use_id`
7. `request_id`
8. `action_description`

这一步先回答：

- 当前被定价的到底是什么动作
- 当前真正被什么卡住

### 3.4 再验 `window_truth_surface`

再看：

1. `window_total_tokens`
2. `window_max_tokens`
3. `window_pct`
4. `reserved_tokens`
5. `auto_compact_threshold`
6. `api_usage_breakdown`
7. `message_breakdown`

这一步先回答：

- `Context Usage` 现在是不是 window truth，而不是仪表盘装饰

### 3.5 再验 `continuation_gate_surface`

再看：

1. `continuation_action`
2. `continuation_count`
3. `budget_pct`
4. `turn_tokens`
5. `budget_tokens`
6. `diminishing_returns`
7. `completion_duration_ms`

这一步先回答：

- 当前继续到底有没有被正式定价

### 3.6 再验 `classifier_pricing_surface`

再看：

1. `classifier_should_block`
2. `classifier_reason`
3. `classifier_model`
4. `classifier_input_tokens`
5. `classifier_output_tokens`
6. `classifier_cost_usd`
7. `classifier_duration_ms`
8. `classifier_to_mainloop_ratio`

这一步先回答：

- 安全判断本身有没有被记入治理账本

### 3.7 再验 `denial_threshold_surface`

再看：

1. `consecutive_denials`
2. `total_denials`
3. `denial_limit_exceeded`
4. `headless_abort_required`

这一步先回答：

- 当前是该 prompting、回退还是直接拒绝继续

### 3.8 再验 `writeback_and_ingress_attestation`

再看：

1. `worker_status`
2. `requires_action_details_ref`
3. `pending_action_writeback_ref`
4. `metadata_merge_strategy`
5. `ingress_head_uuid`
6. `adopted_server_uuid`
7. `sequential_append`
8. `ingress_retry_state`

这一步先回答：

- later 团队回到的是不是同一条责任链

### 3.9 再验 `shared_reject_semantics_packet`

再看：

1. `hard_reject`
2. `authority_chain_broken`
3. `action_candidate_missing`
4. `window_truth_unattested`
5. `continuation_gate_failed`
6. `classifier_pricing_unattested`
7. `denial_limit_exceeded`
8. `writeback_reseal_required`
9. `ingress_lineage_broken`
10. `reentry_required`
11. `reopen_required`

这一步先回答：

- 现在到底应继续、补账、重入，还是正式 reopen

### 3.10 最后验 `long_horizon_reopen_liability`

最后才看：

1. `capability_release_scope`
2. `rollback_object`
3. `custody_owner`
4. `liability_owner`
5. `threshold_retained_until`
6. `reentry_required_when`
7. `reopen_required_when`

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前治理执行并冻结 capability expansion：

1. `permission_mode_external_missing`
2. `action_candidate_missing`
3. `window_truth_unattested`
4. `continuation_gate_failed`
5. `classifier_cost_unpriced`
6. `denial_limit_exceeded`
7. `pending_permission_requests_count_nonzero_and_owner_missing`
8. `writeback_reseal_required`
9. `ingress_lineage_broken`

## 5. reopen drill 最小顺序

一旦 verdict 升级为 `reentry_required` 或 `reopen_required`，最低顺序应固定为：

1. 冻结当前 `pricing card`，禁止把 mode 面板与 usage dashboard 当成真相。
2. 保存 `permission_mode_external`、`action_candidate_ref`、`window_total_tokens`、`continuation_action`、`classifier_cost_usd` 与 `ingress_head_uuid`。
3. 先重建 authority 与 action candidate，再重建 window 与 continuation gate，最后才考虑重新放权。
4. 明确 `liability_owner` 与 `reopen_required_when`，禁止把 reopen 写成流程备注。

## 6. 苏格拉底式自检

在你准备宣布“治理 protocol 已经执行完毕”前，先问自己：

1. 我共享的是同一个统一定价对象，还是四份彼此相像的治理说明。
2. 我共享的是同一条 shared reject order，还是不同消费者各自的继续阈值。
3. 我保留的是 future reopen 的正式能力，还是一句“以后再看”。
4. later 团队接手时依赖的是对象、价格与责任，还是仍要回到 dashboard、approval calmness 与作者记忆。
5. 我现在保护的是 Claude Code 的安全设计与省 token 设计，还是只是在把它们写成更像制度的文稿。
