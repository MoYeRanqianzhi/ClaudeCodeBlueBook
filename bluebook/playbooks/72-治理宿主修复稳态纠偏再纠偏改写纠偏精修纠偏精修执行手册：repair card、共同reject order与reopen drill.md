# 治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行手册：repair card、共同 reject order 与 reopen drill

这一章不再解释治理 refinement correction repair protocol 该共享哪些字段，而是把 Claude Code 式治理 refinement correction repair protocol 压成一张可持续执行的 cross-consumer `repair card`。

它主要回答五个问题：

1. 为什么安全设计与省 token 设计在精修纠偏精修执行里运行的不是“两套系统互相权衡”，而是同一个治理控制面持续拒绝未定价扩张。
2. 宿主、CI、评审与交接怎样共享同一张治理 `repair card`，而不是各自宣布不同版本的“现在可以继续”。
3. 应该按什么固定顺序执行 `repair session`、`authority chain`、`ledger/window truth`、`pricing causality`、`classifier/writeback attestation`、`ingress/restore lineage`、`shared reject semantics` 与 `reopen liability`，才能不让免费继续、免费扩窗与免费放权重新进场。
4. 哪些 `reject order` 一旦出现就必须冻结 capability expansion、拒绝 handoff 并进入 `liability / re-entry / reopen` drill。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的治理值班表”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-619`
- `claude-code-source-code/src/utils/permissions/permissions.ts:526-1318`
- `claude-code-source-code/src/utils/permissions/yoloClassifier.ts:1250-1312`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/utils/analyzeContext.ts:1098-1382`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-211`

## 1. 第一性原理

治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修真正要执行的不是：

- mode 名字恢复正常
- usage 面板重新转绿
- later 团队愿意先保守一点

而是：

- authority、ledger、window、pricing、classifier、writeback seam、ingress/restore lineage、capability liability 与 threshold 仍围绕同一个治理对象正式宣布：现在什么能继续、什么值得继续、什么必须被拒绝继续

Claude Code 当前已经把治理 truth 拆在五条通道上：

1. `control_request.can_use_tool`
2. `external_metadata.pending_action`
3. `get_context_usage`
4. classifier telemetry
5. `sessionIngress + WorkerStateUploader`

这一层 playbook 的任务不是再发明第六条“感觉”，而是把这五条通道压成同一个可执行 card。

所以这层最先要看的不是：

- `repair card` 已经填完了

而是：

1. 当前 card 是否仍围绕同一个 `governance_object_id + single_truth_chain_ref`。
2. 当前 `window truth`、`pricing causality` 与 `classifier cost` 是否真的围绕同一条继续资格链。
3. 当前 `writeback seam + ingress lineage` 是否真的把安全与成本真相 round-trip 回宿主。
4. 当前 `shared reject semantics` 是否真的让宿主、CI、评审与交接继续说同一套拒收语言。
5. 当前 `reopen liability` 是否仍保留 future 反对当前继续状态的能力。

## 2. 共享 repair card 最小字段

每次治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修巡检，宿主、CI、评审与交接系统至少应共享：

1. `repair_card_id`
2. `repair_attestation_id`
3. `reprotocol_session_id`
4. `governance_object_id`
5. `authority_source_after`
6. `single_truth_chain_ref`
7. `permission_mode_external`
8. `permission_ledger_state`
9. `pending_permission_requests`
10. `decision_window`
11. `context_usage_snapshot`
12. `reserved_buffer`
13. `settled_price`
14. `classifier_cost_priced`
15. `free_continuation_blocked`
16. `pending_action_ref`
17. `writeback_seam_attested`
18. `lineage_round_trip_attested`
19. `capability_release_scope`
20. `liability_owner`
21. `threshold_retained_until`
22. `reject_verdict`
23. `reopen_required_when`
24. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看 authority source、ledger truth 与 capability scope 是否仍唯一。
2. CI 看 window、pricing、classifier、writeback、liability 与 threshold 顺序是否完整。
3. 评审看 `reject_verdict` 是否仍围绕同一个治理对象，而不是围绕 mode 面板与 usage dashboard 投影。
4. 交接看 later 团队能否只凭 `repair card` 重建同一判定与责任边界。

## 3. 固定共同 reject order

### 3.1 先验 `repair_session_object`

先看当前准备宣布 refinement correction repair protocol 可执行的，到底是不是同一个 `governance_object_id`，而不是一张更正式的稳定说明。

### 3.2 再验 `authority_chain_attestation`

再看：

1. `authority_source_before`
2. `authority_source_after`
3. `single_truth_chain_ref`
4. `mode_projection_demoted`
5. `dashboard_projection_demoted`

这一步先回答：

- authority 现在究竟归谁

### 3.3 再验 `ledger_window_truth_surface`

再看：

1. `typed_decision_digest`
2. `permission_ledger_state`
3. `pending_permission_requests`
4. `decision_window`
5. `context_usage_snapshot`
6. `reserved_buffer`
7. `pending_action_state`

这一步先回答：

- 现在有没有还没正式清账的尾账
- 当前窗口是真实对象，还是 dashboard 投影

### 3.4 再验 `pricing_causality_surface`

再看：

1. `settled_price`
2. `budget_policy_generation`
3. `continuation_gate`
4. `free_continuation_blocked`
5. `classifier_cost_priced`
6. `classifier_budget_source`

这一步先回答：

- 继续到底有没有被正式定价

### 3.5 再验 `classifier_writeback_attestation`

再看：

1. `classifier_verdict_ref`
2. `requires_action_ref`
3. `pending_action_ref`
4. `session_state_changed_ref`
5. `writeback_seam_attested`
6. `late_response_quarantined`

这一步先回答：

- classifier 是正式成本与正式阻断，还是免费安全感

### 3.6 再验 `ingress_restore_repair_attestation`

再看：

1. `session_ingress_head`
2. `adopted_server_uuid`
3. `restore_epoch_attested`
4. `worker_state_upload_ref`
5. `lineage_round_trip_attested`
6. `consumer_projection_demoted`

这一步先回答：

- later 团队回到的是不是同一条责任链

### 3.7 再验 `shared_reject_semantics_packet`

再看：

1. `hard_reject`
2. `authority_chain_broken`
3. `ledger_reseal_required`
4. `window_truth_reseal_required`
5. `pricing_reseal_required`
6. `writeback_reseal_required`
7. `repair_attestation_rebuild_required`
8. `reentry_required`
9. `reopen_required`

这一步先回答：

- 现在到底应继续、补账、重入，还是正式 reopen

### 3.8 最后验 `long_horizon_reopen_liability`

最后才看：

1. `capability_release_scope`
2. `rollback_object`
3. `custody_owner`
4. `liability_owner`
5. `authority_drift_trigger`
6. `threshold_retained_until`
7. `reentry_required_when`
8. `reopen_required_when`

更稳的最终 verdict 只应落在：

1. `steady_state_chain_resealed`
2. `hard_reject`
3. `ledger_reseal_required`
4. `window_truth_reseal_required`
5. `pricing_reseal_required`
6. `writeback_reseal_required`
7. `repair_attestation_rebuild_required`
8. `reentry_required`
9. `reopen_required`

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前治理 refinement correction refinement execution：

1. `repair_session_missing`
2. `authority_source_unexternalized`
3. `authority_chain_broken`
4. `pending_permission_requests_nonzero`
5. `pending_action_residue_unresolved`
6. `window_truth_missing`
7. `pricing_cause_unexplained`
8. `classifier_cost_unpriced`
9. `free_continuation_unblocked`
10. `writeback_seam_missing`
11. `ingress_restore_lineage_unproved`
12. `liability_owner_missing`
13. `threshold_rebinding_missing`
14. `reopen_required`

## 5. liability 与 reopen 处理顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先冻结新的 capability expansion、continue 与 handoff，直到 `repair card` 补全。
2. 先把 verdict 降为 `hard_reject`、`ledger_reseal_required`、`window_truth_reseal_required`、`pricing_reseal_required`、`writeback_reseal_required`、`repair_attestation_rebuild_required`、`reentry_required` 或 `reopen_required`。
3. 先把 mode 面板、usage dashboard 与“当前还挺省”的感觉降回投影，不再让它们充当治理真相。
4. 先按固定顺序重验 authority、ledger、window、pricing、classifier、writeback 与 ingress/restore lineage，不允许跳过 `window truth + pricing causality`。
5. 只按 `capability_release_scope` 分层恢复 capability，不做一次性全放开。
6. 如果根因落在 refinement correction repair protocol 本身，就回跳 `../api/91` 做对象级修正。

## 6. 最小 drill 集

每轮至少跑下面八个治理宿主稳态纠偏再纠偏改写纠偏精修纠偏精修执行演练：

1. `authority_chain_replay`
2. `ledger_truth_replay`
3. `window_truth_reconsume`
4. `pricing_causality_replay`
5. `classifier_writeback_replay`
6. `ingress_restore_lineage_replay`
7. `shared_reject_alignment_replay`
8. `reopen_liability_replay`

## 7. 复盘记录最少字段

每次治理宿主稳态纠偏再纠偏改写纠偏精修纠偏精修失败、再入场或 reopen，至少记录：

1. `repair_card_id`
2. `repair_attestation_id`
3. `governance_object_id`
4. `authority_source_after`
5. `decision_window`
6. `settled_price`
7. `classifier_cost_priced`
8. `writeback_seam_attested`
9. `reject_verdict`
10. `recovery_action_ref`
11. `threshold_retained_until`
12. `reopen_required_when`

## 8. 苏格拉底式自检

在你准备宣布“治理 refinement correction repair protocol 已经进入 steady execution”前，先问自己：

1. 我现在让四类消费者共享的是同一个治理对象，还是四份长得相似的状态投影。
2. 我现在执行的是共同 `reject order`，还是宿主、CI、评审与交接各自的风险感觉。
3. 我现在保留的是 formal reopen liability，还是一句“以后有问题再看”。
4. later 团队接手时依赖的是 `repair card`、定价链与责任边界，还是仍要回到 mode、usage 与运营经验。
5. 当前执行保护的是未定价扩张不再偷偷入场，还是只是在把治理协议写成更体面的值班 SOP。
