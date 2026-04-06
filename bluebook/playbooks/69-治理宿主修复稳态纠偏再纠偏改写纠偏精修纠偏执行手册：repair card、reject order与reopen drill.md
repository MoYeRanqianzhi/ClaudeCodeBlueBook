# 治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏执行手册：governance key repair card、externalized truth chain、reject order与reopen drill

这一章不再解释治理 refinement correction protocol 该共享哪些字段，而是把 Claude Code 式治理 refinement correction protocol 压成一张可持续执行的 `repair card`。

它主要回答五个问题：

1. 为什么安全设计与省 token 设计在精修纠偏执行里运行的不是“两套系统互相权衡”，而是同一个治理控制面持续拒绝未定价扩张。
2. 宿主、CI、评审与交接怎样共享同一张治理 `repair card`，而不是各自宣布不同版本的“现在可以继续”。
3. 应该按什么固定顺序执行 `governance key`、`externalized truth chain`、`ledger/window truth`、`pricing causality`、`classifier/writeback round-trip`、`durable-vs-transient cleanup`、`reject semantics` 与 `reopen liability`，才能不让免费继续、免费扩窗与免费放权重新进场。
4. 哪些 `reject order` 一旦出现就必须冻结 capability expansion、拒绝 handoff 并进入 `liability / re-entry / reopen` drill。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成更细的治理执行流程表。

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

- `governance key` 是否仍围绕 `sources -> effective -> applied -> externalized` 这一条对象链宣布当前治理真相。
- 宿主是否仍只消费 `externalized truth chain`，而不是自己回放事件去猜现在该怎么做。
- `decision window`、`settled price`、`classifier cost` 与 `continuation gate` 是否仍属于同一张扩张账本。
- `durable_assets_after` 与 `transient_authority_cleared` 是否仍清楚区分“可恢复资产”和“必须失效的旧主权”。

安全设计反对的是：

- 未定价的危险扩张

省 token 设计反对的是：

- 未定价的低收益扩张

这两者在 Claude Code 里实际上是同一条治理控制面。

## 2. 共享 repair card 最小字段

每次治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏巡检，宿主、CI、评审与交接系统至少应共享：

1. `repair_card_id`
2. `reprotocol_session_id`
3. `governance_object_id`
4. `governance_key`
5. `authority_source_after`
6. `single_truth_chain_ref`
7. `externalized_truth_chain_ref`
8. `permission_mode_projection`
9. `permission_ledger_state`
10. `pending_permission_requests`
11. `decision_window`
12. `context_usage_snapshot`
13. `reserved_buffer`
14. `settled_price`
15. `classifier_cost_priced`
16. `free_continuation_blocked`
17. `writeback_seam_attested`
18. `durable_assets_after`
19. `transient_authority_cleared`
20. `capability_release_scope`
21. `liability_owner`
22. `threshold_retained_until`
23. `reject_verdict`
24. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看 `governance key`、`externalized_truth_chain_ref` 与 `capability_release_scope` 是否仍唯一，并且只消费 externalized truth。
2. CI 看 ledger、window、pricing、classifier、writeback、liability 与 threshold 顺序是否完整。
3. 评审看 `reject_verdict` 是否仍围绕同一个治理对象，而不是围绕 mode 与图表投影。
4. 交接看 later 团队能否只凭 `repair card` 重建同一判定与责任边界。

## 3. 固定 reject order

### 3.1 先验 `reprotocol_session_object`

先看当前准备宣布 refinement correction 完成的，到底是不是同一个 `governance_object_id`，而不是一张更正式的稳定说明。

### 3.2 再验 `governance_key_and_externalized_truth_chain`

再看：

1. `governance_key`
2. `authority_source_after`
3. `single_truth_chain_ref`
4. `externalized_truth_chain_ref`
5. `permission_mode_projection`

这一步先回答：

- authority 现在究竟归谁
- 宿主消费的是不是 runtime 已经外化的真相，而不是自己回放 mode、pending action 与 tool pool

### 3.3 再验 `ledger_window_truth_surface`

再看：

1. `permission_ledger_state`
2. `pending_permission_requests`
3. `decision_window`
4. `context_usage_snapshot`
5. `reserved_buffer`
6. `pending_action_state`

这一步先回答：

- 现在有没有还没正式清账的尾账
- 当前窗口是真实对象，还是 dashboard 投影

### 3.4 再验 `pricing_causality_surface`

再看：

1. `settled_price`
2. `budget_policy_generation`
3. `continuation_gate`
4. `free_continuation_blocked`
5. `cache_break_reason`

这一步先回答：

- 继续到底有没有被正式定价

### 3.5 再验 `classifier_writeback_roundtrip`

再看：

1. `classifier_cost_priced`
2. `classifier_budget_source`
3. `requires_action_ref`
4. `pending_action_ref`
5. `session_state_changed_ref`
6. `writeback_seam_attested`

这一步先回答：

- classifier 是正式成本与正式阻断，还是免费安全感
- 安全与成本真相有没有 round-trip 回宿主

### 3.6 再验 `durable_vs_transient_cleanup`

再看：

1. `durable_assets_after`
2. `transient_authority_cleared`
3. `capability_release_scope`
4. `rollback_object`
5. `liability_owner`

这一步先回答：

- 现在恢复的是哪些 durable assets
- 哪些 transient authority 已被正式清退，不会免费续租

### 3.7 再验 `reject_semantics_packet`

再看：

1. `hard_reject`
2. `ledger_reseal_required`
3. `window_truth_reseal_required`
4. `pricing_reseal_required`
5. `writeback_reseal_required`
6. `transient_authority_cleanup_required`
7. `reentry_required`
8. `reopen_required`

这一步先回答：

- 现在到底应继续、补账、重入，还是正式 reopen

### 3.8 最后验 `long_horizon_reopen_liability`

最后才看：

1. `authority_drift_trigger`
2. `threshold_retained_until`
3. `reentry_required_when`
4. `reopen_required_when`
5. `liability_scope`

更稳的最终 verdict 只应落在：

1. `steady_state_chain_resealed`
2. `hard_reject`
3. `ledger_reseal_required`
4. `window_truth_reseal_required`
5. `pricing_reseal_required`
6. `writeback_reseal_required`
7. `transient_authority_cleanup_required`
8. `reentry_required`
9. `reopen_required`

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前治理 refinement correction execution：

1. `reprotocol_session_missing`
2. `governance_key_missing`
3. `authority_source_unexternalized`
4. `pending_permission_requests_nonzero`
5. `window_truth_missing`
6. `pricing_cause_unexplained`
7. `classifier_cost_unpriced`
8. `free_continuation_unblocked`
9. `writeback_seam_missing`
10. `durable_assets_after_missing`
11. `transient_authority_not_cleared`
12. `threshold_liability_missing`
13. `reopen_required_but_continue`

## 5. liability 与 reopen 处理顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先冻结新的 capability expansion、continue 与 handoff，直到 `repair card` 补全。
2. 先把 verdict 降为 `hard_reject`、`ledger_reseal_required`、`window_truth_reseal_required`、`pricing_reseal_required`、`writeback_reseal_required`、`transient_authority_cleanup_required`、`reentry_required` 或 `reopen_required`。
3. 先把 mode、usage dashboard 与“当前还挺省”的感觉降回投影，不再让它们充当治理真相。
4. 先按固定顺序重验 `governance key`、`externalized truth`、ledger、window、pricing、classifier、writeback 与 durable-vs-transient 清理，不允许跳过 `window truth + pricing causality`。
5. 只按 `capability_release_scope` 分层恢复 capability，不做一次性全放开。
6. 交接前必须把 `liability_owner` 与 `threshold_retained_until` 写成 later 团队可消费的对象，而不是一句“有问题再 reopen”。

## 6. 最小 drill 集

每轮至少跑下面八个治理宿主稳态纠偏再纠偏改写纠偏精修纠偏执行演练：

1. `governance_key_replay`
2. `externalized_truth_reconsume`
3. `ledger_window_replay`
4. `pricing_causality_replay`
5. `classifier_writeback_replay`
6. `durable_transient_cleanup_replay`
7. `reject_escalation_replay`
8. `reopen_liability_replay`

## 7. 复盘记录最少字段

每次治理宿主稳态纠偏再纠偏改写纠偏精修纠偏失败、再入场或 reopen，至少记录：

1. `repair_card_id`
2. `reprotocol_session_id`
3. `governance_object_id`
4. `governance_key`
5. `externalized_truth_chain_ref`
6. `decision_window`
7. `settled_price`
8. `classifier_cost_priced`
9. `durable_assets_after`
10. `transient_authority_cleared`
11. `reject_verdict`
12. `verdict_reason`

## 8. 苏格拉底式检查清单

在你准备宣布“治理已完成稳态纠偏再纠偏改写纠偏精修纠偏执行”前，先问自己：

1. 我现在救回的是同一个治理对象，还是一套更严格的 refinement 说明书。
2. 我现在重申的是 `governance key + externalized truth chain`，还是 mode 与 dashboard 的平静感。
3. 我现在冻结的是 formal `decision window + settled price + classifier pricing`，还是只是在看 token 百分比是否回落。
4. 我现在恢复的是 `durable assets`，还是在偷偷续租旧的 transient authority。
5. 我现在保留的是未来推翻当前 steady 的正式 threshold，还是一句“以后有问题再看”。

## 9. 一句话总结

真正成熟的治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏执行，不是把治理面板运行得更熟练，而是持续证明 `governance key`、`externalized truth chain`、ledger、window、pricing、classifier、`durable assets / transient authority` 与 threshold 仍在共同拒绝免费扩张。
