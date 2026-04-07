# 治理宿主修复稳态纠偏再纠偏改写纠偏精修执行手册：host consumption card、hard reject order与reopen drill

这一章不再解释治理 refinement protocol 该消费哪些字段，而是把 Claude Code 式治理 rewrite correction refinement protocol 压成一张可持续执行的治理执行卡。

它主要回答五个问题：

1. 为什么安全设计与省 token 设计在精修执行里运行的不是“两套系统互相权衡”，而是同一个治理控制面持续拒绝免费扩张。
2. 宿主、CI、评审与交接怎样共享同一张治理执行卡，而不是各自宣布不同版本的“现在可以继续”。
3. 应该按什么固定顺序执行 `refinement session`、`false authority projection demotion`、`authority-ledger covenant`、`window-pricing covenant`、`classifier-writeback custody`、`capability liability ledger`、`hard reject semantics`、`truth-surface attestation` 与 `reopen liability ledger`，才能不让免费继续、免费扩窗与免费放权重新进场。
4. 哪些 `hard reject` 一旦出现就必须冻结 capability expansion、拒绝 handoff 并进入 `liability / re-entry / reopen` drill。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的治理值班表”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-619`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1407-1450`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1533-1541`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1735-1747`
- `claude-code-source-code/src/cli/structuredIO.ts:362-657`
- `claude-code-source-code/src/cli/print.ts:1052-1075`
- `claude-code-source-code/src/utils/permissions/permissions.ts:526-1318`
- `claude-code-source-code/src/utils/permissions/yoloClassifier.ts:1250-1312`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/utils/analyzeContext.ts:1098-1382`
- `claude-code-source-code/src/query/tokenBudget.ts:22-92`
- `claude-code-source-code/src/query.ts:1308-1518`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`

## 1. 第一性原理

治理宿主修复稳态纠偏再纠偏改写纠偏精修真正要执行的不是：

- mode 名字恢复正常
- usage 面板重新转绿
- later 团队愿意先保守一点

而是：

- authority、ledger、window、pricing、classifier、writeback seam、capability liability 与 threshold 仍围绕同一个治理对象正式宣布：现在什么能继续、什么值得继续、什么必须被拒绝继续

安全设计反对的是：

- 未定价的危险扩张

省 token 设计反对的是：

- 未定价的低收益扩张

这两者在 Claude Code 里实际上是同一条控制面。

所以这层 playbook 最先要看的不是：

- `host consumption card` 已经填完了

而是：

1. 当前 refinement session 是否仍围绕同一个 `governance_object_id + authority_source_after + single_truth_chain_ref`。
2. 当前 `authority-ledger covenant` 是否真的把 authority 从 mode 与 dashboard 投影里救出来，并恢复 `sources -> effective -> applied -> externalized` 这条治理主键。
3. 当前 `window-pricing covenant` 是否真的把 `Context Usage`、`reserved buffer` 与 `settled price` 放回同一窗口对象。
4. 当前 `classifier-writeback custody` 是否真的让安全系统也接受被定价、被写回。
5. 当前 `reopen liability ledger` 是否仍保留 future reopen 的正式能力，并区分 durable assets 与 transient authority。

## 2. 共享 host consumption card 最小字段

治理执行卡在治理线里也只配做 carrier，不是新的控制面主语；更稳的执行主语应继续写成 `pricing-right rebinding -> truth-surface attestation -> asset-rollback ABI -> shared reject / reopen drill`，这张卡只是把这条执行链写成宿主、CI、评审与交接共同回读的容器。

每次治理宿主修复稳态纠偏再纠偏改写纠偏精修巡检，宿主、CI、评审与交接系统至少应共享：

1. `host_consumption_card_id`
2. `refinement_session_id`
3. `rewrite_correction_session_id`
4. `governance_object_id`
5. `authority_source_after`
6. `single_truth_chain_ref`
7. `externalized_truth_chain_ref`
8. `permission_mode_external`
9. `permission_ledger_state`
10. `pending_permission_requests`
11. `decision_window`
12. `context_usage_snapshot`
13. `reserved_buffer`
14. `settled_price`
15. `classifier_cost_priced`
16. `writeback_seam_attested`
17. `durable_assets_after`
18. `transient_authority_cleared`
19. `capability_release_scope`
20. `liability_owner`
21. `threshold_retained_until`
22. `shared_consumer_surface`
23. `reject_verdict`
24. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看 governance key、writer chokepoint 与 capability scope 是否仍唯一，并且只消费 externalized truth。
2. CI 看 ledger、window、pricing、classifier、writeback、liability 与 threshold 顺序是否完整。
3. 评审看 `reject_verdict` 是否仍围绕同一个治理对象，而不是围绕 mode 与图表投影。
4. 交接看 later 团队能否只凭 `host consumption card` 重建同一判定与责任边界。

## 3. 固定 hard reject 顺序

### 3.1 先验 `rewrite_refinement_session_object`

先看当前准备宣布 refinement 成立的，到底是不是同一个 `governance_object_id`，而不是一张更正式的稳定说明。

### 3.2 再验 `false_authority_projection_demotion_contract`

再看：

1. `mode_projection_demoted` 是否成立。
2. `dashboard_projection_demoted` 是否成立。
3. `free_continuation_blocked` 是否先于 restored verdict 生效。

### 3.3 再验 `authority_ledger_covenant`

再看：

1. `authority_source_after` 与 `single_truth_chain_ref` 是否仍唯一。
2. `typed_decision_digest` 与 `permission_ledger_state` 是否仍明确重绑。
3. capability custody 是否仍由唯一 writer chokepoint 发放，而不是由面板恢复感发放。
4. `externalized_truth_chain_ref` 是否仍是宿主、CI、评审与交接共同消费的当前真相。

### 3.4 再验 `window_pricing_covenant`

再看：

1. `decision_window`、`context_usage_snapshot` 与 `reserved_buffer` 是否仍属于同一窗口。
2. `settled_price`、`budget_policy_generation` 与 `free_continuation_blocked` 是否仍把 `continuation pricing` 写成正式 runtime witness，而不是只阻止“没报错就继续”的免费扩张。
3. 当前 refinement 是否仍阻止旧窗口、旧定价与旧 usage 投影复活。

### 3.5 再验 `classifier_writeback_custody`

再看：

1. `classifier_cost_priced` 是否仍明确 classifier 不在价格对象外。
2. `classifier_budget_source` 是否仍正式可追。
3. `requires_action_ref -> pending_action_ref -> session_state_changed_ref` 是否仍围绕同一条 writeback seam。

### 3.6 再验 `capability_liability_ledger`

再看：

1. `capability_release_scope`、`custody_owner` 与 `liability_owner` 是否仍明确。
2. capability 是否按 scope 被分层托管，而不是一次性全放开。
3. `rollback_object` 是否仍让 later 团队可以正式回跳。
4. `durable_assets_after / transient_authority_cleared` 是否仍明确区分“可恢复资产”和“必须失效的旧主权”。

### 3.7 再验 `hard_reject_semantics_abi` 与 `truth_surface_attestation_packet`

再看：

1. `hard_reject`、`liability_hold`、`writeback_reseal_required`、`reentry_required`、`reopen_required` 是否仍围绕对象链触发。
2. `shared_consumer_surface` 这个字段是否仍让宿主、CI、评审与交接以不同宽度只读消费同一个 verdict object，而不是各自抄一段“差不多的结论”。

### 3.8 最后验 `reopen_liability_ledger` 与 `reject_verdict`

最后才看：

1. `authority_drift_trigger`、`reentry_required_when` 与 `reopen_required_when` 是否仍正式保留。
2. `threshold_retained_until` 是否仍让 future reopen 不是一句礼貌备注。
3. `reject_verdict` 是否与前七步对象完全一致。

更稳的最终 verdict 只应落在：

1. `steady_state_chain_resealed`
2. `hard_reject`
3. `liability_hold`
4. `writeback_reseal_required`
5. `reentry_required`
6. `reopen_required`

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前治理 refinement execution：

1. `refinement_session_missing`
2. `authority_source_unexternalized`
3. `mode_projection_as_authority`
4. `permission_ledger_state_unsealed`
5. `pending_action_residue_unresolved`
6. `pending_permission_requests_nonzero`
7. `decision_window_as_dashboard`
8. `settled_price_missing`
9. `classifier_cost_unpriced`
10. `writeback_seam_missing`
11. `free_continuation_detected`
12. `capability_liability_unbound`
13. `threshold_rebinding_missing`
14. `reopen_required`

## 5. liability 与 reopen 处理顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先冻结新的 capability expansion，直到 `host consumption card` 补全。
2. 先把 verdict 降为 `hard_reject`、`liability_hold`、`writeback_reseal_required`、`reentry_required` 或 `reopen_required`。
3. 先把 mode、usage dashboard 与“当前还挺省”的感觉降回可见读面；若它们继续冒充治理真相，直接按 `mode_projection_as_authority / decision_window_as_dashboard` 拒收。
4. 先按固定顺序重验 authority、ledger、window、pricing、classifier、writeback 与 liability，不允许跳过 `window-pricing covenant`，也不允许宿主改从事件流猜当前真相。
5. 只按 `capability_release_scope` 分层恢复 capability，不做一次性全放开。
6. 交接前必须把 `liability_owner` 与 `reopen liability ledger` 写成 later 团队可消费的对象，而不是一句“有问题再 reopen”。

## 6. 最小 drill 集

每轮至少跑下面八个治理宿主稳态纠偏再纠偏改写纠偏精修执行演练：

1. `refinement_session_replay`
2. `authority_ledger_replay`
3. `window_pricing_replay`
4. `context_usage_window_reconsume`
5. `classifier_writeback_replay`
6. `capability_liability_replay`
7. `hard_reject_escalation_replay`
8. `reopen_liability_replay`

## 7. 复盘记录最少字段

每次治理宿主稳态纠偏再纠偏改写纠偏精修失败、再入场或 reopen，至少记录：

1. `host_consumption_card_id`
2. `refinement_session_id`
3. `rewrite_correction_session_id`
4. `governance_object_id`
5. `authority_source_after`
6. `permission_ledger_state`
7. `decision_window`
8. `context_usage_snapshot`
9. `settled_price`
10. `classifier_cost_priced`
11. `writeback_seam_attested`
12. `durable_assets_after`
13. `transient_authority_cleared`
14. `capability_release_scope`
15. `liability_owner`
16. `threshold_retained_until`
17. `pending_permission_requests`
18. `shared_consumer_surface`
19. `reject_verdict`
20. `verdict_reason`

## 8. 苏格拉底式检查清单

在你准备宣布“治理已完成稳态纠偏再纠偏改写纠偏精修执行”前，先问自己：

1. 我现在救回的是同一个治理对象，还是一套更严格的 refinement 说明书。
2. 我现在重申的是 authority 真相链，还是 mode 与 dashboard 的平静感。
3. 我现在冻结的是 formal `decision window + settled price + classifier pricing`，还是只是在看 token 百分比是否回落。
4. 我现在恢复的是 `writeback seam + liability owner`，还是给默认继续换了个更体面的名字。
5. 我现在保留的是未来推翻当前 steady 的正式 threshold，还是一句“以后有问题再看”。

## 9. 一句话总结

真正成熟的治理宿主修复稳态纠偏再纠偏改写纠偏精修执行，不是把治理面板运行得更熟练，而是持续证明 authority、ledger、window、pricing、classifier、writeback seam、capability liability 与 threshold 仍在共同拒绝免费扩张。
