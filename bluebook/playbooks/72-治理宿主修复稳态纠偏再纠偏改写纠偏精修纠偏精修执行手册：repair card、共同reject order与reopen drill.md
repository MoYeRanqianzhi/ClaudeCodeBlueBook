# 治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行手册：externalized truth repair card、shared reject order、durable assets与reopen drill

这一章不再解释治理 refinement correction repair protocol 该共享哪些字段，而是把 Claude Code 式治理 refinement correction repair protocol 压成一张可持续执行的 cross-consumer `repair card`。

它主要回答五个问题：

1. 为什么安全设计与省 token 设计在精修纠偏精修执行里运行的不是“两套系统互相权衡”，而是同一个治理控制面持续拒绝未定价扩张。
2. 宿主、CI、评审与交接怎样共享同一张治理 `repair card`，而不是各自宣布不同版本的“现在可以继续”。
3. 应该按什么固定顺序执行 `governance key`、`externalized truth chain`、`window/pricing/classifier evidence`、`writeback round-trip`、`durable-vs-transient cleanup`、`shared reject semantics` 与 `reopen liability`，才能不让免费继续、免费扩窗与免费放权重新进场。
4. 哪些 `shared reject order` 一旦出现就必须冻结 capability expansion、拒绝 handoff 并进入 `liability / re-entry / reopen` drill。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成更细的治理执行流程表。

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

- `governance key` 是否仍在支配 settings、decision、window、writeback 与 restore。
- `externalized truth chain` 是否仍让宿主只消费 runtime 已外化的 authority/status，而不是自己回放事件去猜当前状态。
- `decision window`、`settled price` 与 `classifier cost` 是否仍属于同一张扩张账本。
- `writeback round-trip` 是否真的把治理真相写回宿主。
- `durable assets` 与 `transient authority` 是否仍被清楚区分，恢复的是资产，不是旧主权的免费续租。

这一层不再把治理真相写成“五条平权通道”。更准确的说法是：

- `control_request`
- `pending_action`
- `Context Usage`
- classifier verdict
- ingress / worker-state round-trip

都只是同一个 `governance key` 的外化证据链，而不是五个并列 sovereign tier。

## 2. 共享 repair card 最小字段

每次治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修巡检，宿主、CI、评审与交接系统至少应共享：

1. `repair_card_id`
2. `repair_attestation_id`
3. `reprotocol_session_id`
4. `governance_object_id`
5. `governance_key`
6. `externalized_truth_chain_ref`
7. `decision_window`
8. `context_usage_snapshot`
9. `reserved_buffer`
10. `settled_price`
11. `classifier_cost_priced`
12. `writeback_seam_attested`
13. `lineage_round_trip_attested`
14. `durable_assets_after`
15. `transient_authority_cleared`
16. `capability_release_scope`
17. `liability_owner`
18. `reject_verdict`
19. `threshold_retained_until`
20. `reopen_required_when`
21. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看 `governance key`、`externalized_truth_chain_ref` 与 `capability_release_scope` 是否仍唯一。
2. CI 看 `window -> pricing -> classifier -> writeback -> durable-vs-transient cleanup` 顺序是否完整。
3. 评审看 `reject_verdict` 是否仍围绕同一个治理对象，而不是围绕 mode 面板与 usage dashboard 投影。
4. 交接看 later 团队能否只凭 `repair card` 重建同一判定与责任边界。

## 3. 固定 shared reject order

### 3.1 先验 `repair_session_object`

先看当前准备宣布 refinement correction repair protocol 可执行的，到底是不是同一个 `governance_object_id`，而不是一张更正式的稳定说明。

### 3.2 再验 `governance_key_and_externalized_truth_chain`

再看：

1. `governance_key`
2. `authority_source_after`
3. `externalized_truth_chain_ref`
4. `mode_projection_demoted`
5. `dashboard_projection_demoted`

这一步先回答：

- authority 现在究竟归谁
- 宿主消费的是不是已经外化的真相，而不是自己回放事件流拼 current state

### 3.3 再验 `window_pricing_and_classifier_evidence`

再看：

1. `decision_window`
2. `context_usage_snapshot`
3. `reserved_buffer`
4. `settled_price`
5. `classifier_cost_priced`
6. `free_continuation_blocked`

这一步先回答：

- 继续到底有没有被正式定价
- classifier 是不是正式成本，而不是免费安全感

### 3.4 再验 `writeback_roundtrip_and_durable_transient_cleanup`

再看：

1. `writeback_seam_attested`
2. `lineage_round_trip_attested`
3. `durable_assets_after`
4. `transient_authority_cleared`
5. `capability_release_scope`
6. `rollback_object`

这一步先回答：

- 治理真相有没有 round-trip 回宿主
- 恢复的是 durable assets，还是在偷偷续租旧的 transient authority

### 3.5 再验 `shared_reject_semantics_packet`

再看：

1. `hard_reject`
2. `externalized_truth_chain_missing`
3. `window_truth_reseal_required`
4. `pricing_reseal_required`
5. `writeback_roundtrip_rebuild_required`
6. `transient_authority_cleanup_required`
7. `reentry_required`
8. `reopen_required`

这一步先回答：

- 现在到底应继续、补账、重入，还是正式 reopen

### 3.6 最后验 `long_horizon_reopen_liability`

最后才看：

1. `authority_drift_trigger`
2. `liability_owner`
3. `threshold_retained_until`
4. `reentry_required_when`
5. `reopen_required_when`

更稳的最终 verdict 只应落在：

1. `steady_state_chain_resealed`
2. `hard_reject`
3. `window_truth_reseal_required`
4. `pricing_reseal_required`
5. `writeback_roundtrip_rebuild_required`
6. `transient_authority_cleanup_required`
7. `reentry_required`
8. `reopen_required`

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前治理 refinement correction repair execution：

1. `repair_session_missing`
2. `governance_key_missing`
3. `externalized_truth_chain_missing`
4. `host_replayed_events_to_infer_present`
5. `window_truth_missing`
6. `pricing_cause_unexplained`
7. `classifier_cost_unpriced`
8. `writeback_roundtrip_missing`
9. `durable_assets_after_missing`
10. `transient_authority_not_cleared`
11. `threshold_liability_missing`
12. `reopen_required`

## 5. liability 与 reopen 处理顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先冻结新的 capability expansion、continue 与 handoff，直到 `repair card` 补全。
2. 先把 verdict 降为 `hard_reject`、`window_truth_reseal_required`、`pricing_reseal_required`、`writeback_roundtrip_rebuild_required`、`transient_authority_cleanup_required`、`reentry_required` 或 `reopen_required`。
3. 先把 mode 面板、usage dashboard 与“当前还挺省”的感觉降回投影，不再让它们充当治理真相。
4. 先重建 `governance key + externalized truth chain`，再重建 `window/pricing/classifier evidence`，最后才重建 `writeback round-trip + durable-vs-transient cleanup`。
5. 只按 `capability_release_scope` 分层恢复 capability，不做一次性全放开。

## 6. 最小 drill 集

每轮至少跑下面八个治理宿主稳态纠偏再纠偏改写纠偏精修纠偏精修执行演练：

1. `governance_key_replay`
2. `externalized_truth_reconsume`
3. `window_pricing_replay`
4. `classifier_cost_replay`
5. `writeback_roundtrip_replay`
6. `durable_transient_cleanup_replay`
7. `shared_reject_alignment_replay`
8. `reopen_liability_replay`

## 7. 复盘记录最少字段

每次治理宿主稳态纠偏再纠偏改写纠偏精修纠偏精修失败、再入场或 reopen，至少记录：

1. `repair_card_id`
2. `repair_attestation_id`
3. `governance_object_id`
4. `governance_key`
5. `externalized_truth_chain_ref`
6. `decision_window`
7. `settled_price`
8. `classifier_cost_priced`
9. `durable_assets_after`
10. `transient_authority_cleared`
11. `reject_verdict`
12. `reopen_required_when`

## 8. 苏格拉底式自检

在你准备宣布“治理 refinement correction repair protocol 已经进入 steady execution”前，先问自己：

1. 我现在让四类消费者共享的是同一个治理对象，还是四份长得相似的状态投影。
2. 我现在共享的是同一条 `shared reject order`，还是不同消费者各自的风险感觉。
3. 我现在保留的是 formal reopen liability，还是一句“以后有问题再看”。
4. later 团队接手时依赖的是 `governance key`、`externalized truth chain` 与 durable-vs-transient 分界，还是仍要回到 mode、usage 与运营经验。
5. 当前执行保护的是未定价扩张不再偷偷入场，还是只是在把治理协议写成更体面的流程页。

## 9. 一句话总结

真正成熟的治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行，不是让治理说明更像制度，而是持续证明 `governance key`、`externalized truth chain`、window、pricing、classifier、`durable assets / transient authority` 与 threshold 仍在共同拒绝免费扩张。
