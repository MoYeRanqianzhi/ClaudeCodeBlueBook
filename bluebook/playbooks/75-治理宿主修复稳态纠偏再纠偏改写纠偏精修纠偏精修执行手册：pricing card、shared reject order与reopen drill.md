# 治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行手册：externalized truth pricing card、shared reject order、durable assets与reopen drill

这一章不再解释治理 refinement correction refinement protocol 该共享哪些字段，而是把 Claude Code 式治理 refinement correction refinement protocol 压成一张可持续执行的 cross-consumer `pricing card`。

它主要回答五个问题：

1. 为什么安全设计与省 token 设计在这一层运行的不是“两套系统互相权衡”，而是同一个治理控制面持续拒绝未定价扩张。
2. 宿主、CI、评审与交接怎样共享同一张治理 `pricing card`，而不是各自宣布不同版本的“现在可以继续”。
3. 应该按什么固定顺序执行 `governance key`、`externalized truth chain`、`typed ask / visible capability`、`window / continuation pricing`、`classifier cost`、`durable-vs-transient cleanup`、`shared reject` 与 `reopen drill`，才能不让免费继续、免费扩窗与免费放权重新进场。
4. 哪些 `shared reject order` 一旦出现就必须冻结 capability expansion、拒绝 handoff 并进入 `liability / re-entry / reopen`。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成更细的治理执行流程表。

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

- `governance key` 是否仍在支配动作、能力、上下文与时间四种扩张。
- `externalized truth chain` 是否仍让宿主只消费 runtime 已外化的 authority/status，而不是自己回放事件流拼 current state。
- `typed ask` 与 `visible capability set` 是否仍说明当前被定价的到底是什么动作、什么可见面。
- `decision window`、`settled price`、`continuation gate` 与 `classifier cost` 是否仍属于同一张扩张账本。
- `durable assets` 与 `transient authority` 是否仍被清楚区分，恢复的是资产，不是旧主权的免费续租。

Claude Code 当前看起来像多条 surface 的对象，其实都只是同一个 `governance key` 的外化证据链：

1. `typed ask`
2. `visible capability set`
3. `decision window`
4. `continuation gate`
5. `classifier cost`
6. `writeback round-trip`
7. `durable-vs-transient cleanup`

## 2. 共享 pricing card 最小字段

每次治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修巡检，宿主、CI、评审与交接系统至少应共享：

1. `pricing_card_id`
2. `repair_attestation_id`
3. `reprotocol_session_id`
4. `governance_object_id`
5. `governance_key`
6. `externalized_truth_chain_ref`
7. `typed_ask_ref`
8. `visible_capability_set`
9. `decision_window`
10. `settled_price`
11. `continuation_gate`
12. `classifier_cost_priced`
13. `writeback_roundtrip_attested`
14. `durable_assets_after`
15. `transient_authority_cleared`
16. `capability_release_scope`
17. `liability_owner`
18. `shared_reject_verdict`
19. `threshold_retained_until`
20. `reopen_required_when`
21. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看 `governance key`、`externalized_truth_chain_ref`、`typed_ask_ref` 与 `visible_capability_set` 是否仍唯一。
2. CI 看 `window -> continuation pricing -> classifier cost -> writeback round-trip -> durable-vs-transient cleanup` 顺序是否完整。
3. 评审看 `shared_reject_verdict` 是否仍围绕同一个统一定价对象，而不是围绕 mode 面板与 usage dashboard 投影。
4. 交接看 later 团队能否只凭 `pricing card` 重建同一判定与责任边界。

## 3. 固定 shared reject order

### 3.1 先验 `repair_session_object`

先看当前准备宣布 protocol 可执行的，到底是不是同一个 `governance_object_id`，而不是一张更正式的稳定说明。

### 3.2 再验 `governance_key_and_externalized_truth_chain`

再看：

1. `governance_key`
2. `externalized_truth_chain_ref`
3. `authority_source_after`
4. `mode_projection_demoted`
5. `dashboard_projection_demoted`

这一步先回答：

- 当前究竟谁在为扩权背书
- 宿主消费的是不是已经外化的真相，而不是自己回放事件流拼当前状态

### 3.3 再验 `typed_ask_and_visible_capability_surface`

再看：

1. `typed_ask_ref`
2. `action_candidate_ref`
3. `visible_capability_set`
4. `blocked_projection_demoted`
5. `action_description`

这一步先回答：

- 当前被定价的到底是什么动作
- 当前可见集是不是同一个治理主键的受价结果

### 3.4 再验 `window_continuation_and_classifier_pricing`

再看：

1. `decision_window`
2. `settled_price`
3. `continuation_gate`
4. `free_continuation_blocked`
5. `classifier_cost_priced`
6. `classifier_reason`

这一步先回答：

- 当前继续到底有没有被正式定价
- 安全判断本身有没有被记入同一张治理账本

### 3.5 再验 `writeback_roundtrip_and_durable_transient_cleanup`

再看：

1. `writeback_roundtrip_attested`
2. `pending_action_ref`
3. `session_state_changed_ref`
4. `durable_assets_after`
5. `transient_authority_cleared`
6. `capability_release_scope`

这一步先回答：

- 治理真相有没有 round-trip 回宿主
- 恢复的是 durable assets，还是在偷偷续租旧的 transient authority

### 3.6 再验 `shared_reject_semantics_packet`

再看：

1. `hard_reject`
2. `externalized_truth_chain_missing`
3. `typed_ask_collapsed_to_modal`
4. `visible_capability_unpriced`
5. `window_truth_unattested`
6. `continuation_gate_failed`
7. `classifier_cost_unpriced`
8. `writeback_roundtrip_rebuild_required`
9. `transient_authority_cleanup_required`
10. `reentry_required`
11. `reopen_required`

这一步先回答：

- 现在到底应继续、补账、重入，还是正式 reopen

### 3.7 最后验 `long_horizon_reopen_liability`

最后才看：

1. `capability_release_scope`
2. `rollback_object`
3. `liability_owner`
4. `threshold_retained_until`
5. `reentry_required_when`
6. `reopen_required_when`

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前治理执行并冻结 capability expansion：

1. `governance_key_missing`
2. `externalized_truth_chain_missing`
3. `typed_ask_collapsed_to_modal`
4. `visible_capability_unpriced`
5. `window_truth_unattested`
6. `continuation_gate_failed`
7. `classifier_cost_unpriced`
8. `writeback_roundtrip_missing`
9. `transient_authority_not_cleared`
10. `reopen_required`

## 5. reopen drill 最小顺序

一旦 verdict 升级为 `reentry_required` 或 `reopen_required`，最低顺序应固定为：

1. 冻结当前 `pricing card`，禁止把 mode 面板与 usage dashboard 当成真相。
2. 保存 `governance_key`、`externalized_truth_chain_ref`、`typed_ask_ref`、`visible_capability_set`、`decision_window`、`continuation_gate`、`classifier_cost_priced` 与 `durable_assets_after`。
3. 先重建 `governance key + externalized truth chain`，再重建 `typed ask + visible capability`，最后才考虑重新 continuation 或放权。
4. 明确 `liability_owner` 与 `reopen_required_when`，禁止把 reopen 写成流程备注。

## 6. 苏格拉底式自检

在你准备宣布“治理 protocol 已经执行完毕”前，先问自己：

1. 我共享的是同一个统一定价对象，还是四份彼此相像的治理说明。
2. 我共享的是同一条 `shared reject order`，还是不同消费者各自的继续阈值。
3. 我保留的是 future reopen 的正式能力，还是一句“以后再看”。
4. later 团队接手时依赖的是 `governance key`、`externalized truth` 与 durable-vs-transient 分界，还是仍要回到 dashboard、approval calmness 与口头经验。
5. 我恢复的是 durable assets，还是把 transient authority 也偷偷续租了。
6. 我现在保护的是 Claude Code 的安全设计与省 token 设计，还是只是在把它们写成更像制度的文稿。

## 7. 一句话总结

真正成熟的治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行，不是把治理写得更像制度，而是持续证明 `governance key`、`externalized truth chain`、`typed ask`、`visible capability`、`continuation gate`、`classifier cost` 与 `durable assets / transient authority` 仍在共同拒绝免费扩张。
