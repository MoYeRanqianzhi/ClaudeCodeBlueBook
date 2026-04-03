# 治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏执行手册：repair card、reject order与reopen drill

这一章不再解释治理 refinement correction protocol 该共享哪些字段，而是把 Claude Code 式治理 refinement correction protocol 压成一张可持续执行的 `repair card`。

它主要回答五个问题：

1. 为什么安全设计与省 token 设计在精修纠偏执行里运行的不是“两套系统互相权衡”，而是同一个治理控制面持续拒绝免费扩张。
2. 宿主、CI、评审与交接怎样共享同一张治理 `repair card`，而不是各自宣布不同版本的“现在可以继续”。
3. 应该按什么固定顺序执行 `reprotocol session`、`authority chain`、`ledger truth`、`window truth`、`pricing causality`、`classifier pricing`、`writeback seam`、`ingress/restore lineage`、`reject semantics` 与 `reopen liability`，才能不让免费继续、免费扩窗与免费放权重新进场。
4. 哪些 `reject order` 一旦出现就必须冻结 capability expansion、拒绝 handoff 并进入 `liability / re-entry / reopen` drill。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的治理值班表”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-619`
- `claude-code-source-code/src/utils/permissions/permissions.ts:526-1318`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/utils/analyzeContext.ts:1098-1382`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-211`

## 1. 第一性原理

治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏真正要执行的不是：

- mode 名字恢复正常
- usage 面板重新转绿
- later 团队愿意先保守一点

而是：

- authority、ledger、window、pricing、classifier、writeback seam、ingress/restore lineage、capability liability 与 threshold 仍围绕同一个治理对象正式宣布：现在什么能继续、什么值得继续、什么必须被拒绝继续

安全设计反对的是：

- 未定价的危险扩张

省 token 设计反对的是：

- 未定价的低收益扩张

这两者在 Claude Code 里实际上是同一条控制面。

## 2. 共享 repair card 最小字段

每次治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏巡检，宿主、CI、评审与交接系统至少应共享：

1. `repair_card_id`
2. `reprotocol_session_id`
3. `governance_object_id`
4. `authority_source_after`
5. `permission_mode_external`
6. `permission_ledger_state`
7. `pending_permission_requests`
8. `decision_window`
9. `context_usage_snapshot`
10. `reserved_buffer`
11. `settled_price`
12. `classifier_cost_priced`
13. `writeback_seam_attested`
14. `capability_release_scope`
15. `liability_owner`
16. `threshold_retained_until`
17. `reject_verdict`
18. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看 authority source、ledger truth 与 capability scope 是否仍唯一。
2. CI 看 window、pricing、classifier、writeback、liability 与 threshold 顺序是否完整。
3. 评审看 `reject_verdict` 是否仍围绕同一个治理对象，而不是围绕 mode 与图表投影。
4. 交接看 later 团队能否只凭 `repair card` 重建同一判定与责任边界。

## 3. 固定 reject order

### 3.1 先验 `reprotocol_session_object`

先看当前准备宣布 refinement correction 完成的，到底是不是同一个 `governance_object_id`，而不是一张更正式的稳定说明。

### 3.2 再验 `authority_chain_attestation`

再看：

1. `authority_source_before`
2. `authority_source_after`
3. `single_truth_chain_ref`
4. `mode_projection_demoted`
5. `dashboard_projection_demoted`

这一步先回答：

- authority 现在究竟归谁

### 3.3 再验 `ledger_truth_surface`

再看：

1. `typed_decision_digest`
2. `permission_ledger_state`
3. `pending_permission_requests`
4. `orphan_permission_cleared`
5. `late_response_quarantined`

这一步先回答：

- 现在有没有还没正式清账的尾账

### 3.4 再验 `window_truth_surface`

再看：

1. `decision_window`
2. `context_usage_snapshot`
3. `reserved_buffer`
4. `api_usage_breakdown`
5. `pending_action_state`

这一步先回答：

- 当前窗口是正式对象，还是 dashboard 投影

### 3.5 再验 `pricing_causality_surface`

再看：

1. `settled_price`
2. `budget_policy_generation`
3. `continuation_gate`
4. `free_continuation_blocked`
5. `cache_break_reason`

这一步先回答：

- 继续到底有没有被正式定价

### 3.6 再验 `classifier_pricing_attestation`

再看：

1. `classifier_cost_priced`
2. `classifier_verdict_ref`
3. `classifier_budget_source`
4. `classifier_scope`

这一步先回答：

- classifier 是正式成本，还是免费安全感

### 3.7 再验 `writeback_seam_contract`

再看：

1. `requires_action_ref`
2. `pending_action_ref`
3. `session_state_changed_ref`
4. `writeback_seam_attested`
5. `host_ack_ref`

这一步先回答：

- 宿主真相缝有没有真的 round-trip 完成

### 3.8 再验 `ingress_restore_lineage_contract`

再看：

1. `session_ingress_head`
2. `adopted_server_uuid`
3. `ingress_conflict_policy`
4. `resume_session_id`
5. `restore_lineage_attested`

这一步先回答：

- later 团队回到的是不是同一条责任链

### 3.9 再验 `reject_semantics_packet`

再看：

1. `hard_reject`
2. `ledger_reseal_required`
3. `writeback_reseal_required`
4. `reentry_required`
5. `reopen_required`

### 3.10 最后验 `long_horizon_reopen_liability`

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
4. `writeback_reseal_required`
5. `reentry_required`
6. `reopen_required`

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前治理 refinement correction execution：

1. `reprotocol_session_missing`
2. `authority_chain_broken`
3. `authority_source_unexternalized`
4. `pending_permission_requests_nonzero`
5. `pending_action_residue_unresolved`
6. `window_truth_missing`
7. `pricing_cause_unexplained`
8. `classifier_cost_unpriced`
9. `writeback_seam_missing`
10. `ingress_conflict_unresolved`
11. `capability_liability_unbound`
12. `threshold_rebinding_missing`
13. `reopen_required`

## 5. liability 与 reopen 处理顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先冻结新的 capability expansion，直到 `repair card` 补全。
2. 先把 verdict 降为 `hard_reject`、`ledger_reseal_required`、`writeback_reseal_required`、`reentry_required` 或 `reopen_required`。
3. 先把 mode、usage dashboard 与“当前还挺省”的感觉降回投影，不再让它们充当治理真相。
4. 先按固定顺序重验 authority、ledger、window、pricing、classifier、writeback 与 ingress/restore lineage，不允许跳过 `window truth + pricing causality`。
5. 只按 `capability_release_scope` 分层恢复 capability，不做一次性全放开。
6. 交接前必须把 `liability_owner` 与 `threshold_retained_until` 写成 later 团队可消费的对象，而不是一句“有问题再 reopen”。

## 6. 最小 drill 集

每轮至少跑下面八个治理宿主稳态纠偏再纠偏改写纠偏精修纠偏执行演练：

1. `authority_chain_replay`
2. `ledger_truth_replay`
3. `window_truth_reconsume`
4. `pricing_causality_replay`
5. `classifier_pricing_replay`
6. `writeback_seam_replay`
7. `ingress_restore_lineage_replay`
8. `reopen_liability_replay`

## 7. 复盘记录最少字段

每次治理宿主稳态纠偏再纠偏改写纠偏精修纠偏失败、再入场或 reopen，至少记录：

1. `repair_card_id`
2. `reprotocol_session_id`
3. `governance_object_id`
4. `authority_source_after`
5. `permission_ledger_state`
6. `pending_permission_requests`
7. `decision_window`
8. `context_usage_snapshot`
9. `settled_price`
10. `classifier_cost_priced`
11. `writeback_seam_attested`
12. `capability_release_scope`
13. `liability_owner`
14. `threshold_retained_until`
15. `reject_verdict`
16. `verdict_reason`

## 8. 苏格拉底式检查清单

在你准备宣布“治理已完成稳态纠偏再纠偏改写纠偏精修纠偏执行”前，先问自己：

1. 我现在救回的是同一个治理对象，还是一套更严格的 refinement 说明书。
2. 我现在重申的是 authority 真相链，还是 mode 与 dashboard 的平静感。
3. 我现在冻结的是 formal `decision window + settled price + classifier pricing`，还是只是在看 token 百分比是否回落。
4. 我现在恢复的是 `writeback seam + ingress lineage`，还是给默认继续换了个更体面的名字。
5. 我现在保留的是未来推翻当前 steady 的正式 threshold，还是一句“以后有问题再看”。

## 9. 一句话总结

真正成熟的治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏执行，不是把治理面板运行得更熟练，而是持续证明 authority、ledger、window、pricing、classifier、writeback seam、ingress lineage、capability liability 与 threshold 仍在共同拒绝免费扩张。
