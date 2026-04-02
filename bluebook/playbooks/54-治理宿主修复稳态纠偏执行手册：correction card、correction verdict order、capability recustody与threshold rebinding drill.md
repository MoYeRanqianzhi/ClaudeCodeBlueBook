# 治理宿主修复稳态纠偏执行手册：correction card、correction verdict order、capability recustody与threshold rebinding drill

这一章不再解释治理宿主修复稳态纠偏协议该消费哪些字段，而是把 Claude Code 式治理 steady-state correction 压成一张可持续执行的纠偏手册。

它主要回答五个问题：

1. 为什么安全设计与省 token 设计在纠偏执行里运行的不是“现在看起来安全”，而是同一个治理对象仍在重新约束 authority、窗口、定价、能力与责任。
2. 宿主、CI、评审与交接怎样共享同一张治理 correction card，而不是各自宣布不同版本的“现在可以继续放行”。
3. 应该按什么固定顺序执行 `authority reassertion`、`ledger reseal`、`window refreeze`、`continuation repricing`、`capability recustody` 与 `threshold rebinding`，才能不让免费继续重新进场。
4. 哪些 correction verdict 一旦出现就必须冻结 capability expansion、拒绝 handoff 并进入 liability / re-entry / reopen drill。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的稳态看板”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-619`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1407-1450`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1533-1541`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1735-1747`
- `claude-code-source-code/src/cli/structuredIO.ts:362-657`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:84-645`
- `claude-code-source-code/src/utils/permissions/permissions.ts:929-1318`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/utils/analyzeContext.ts:1098-1382`
- `claude-code-source-code/src/query/tokenBudget.ts:22-92`
- `claude-code-source-code/src/query.ts:1308-1518`

## 1. 第一性原理

治理宿主修复稳态纠偏真正要执行的不是：

- mode 名字恢复正常
- usage 面板重新转绿
- later 团队愿意先保守一点

而是：

- authority、ledger、window、continuation、capability 与 threshold 仍围绕同一个治理对象正式宣布：现在可以继续定价、继续托管，并在必要时继续追责与回收

所以这层 playbook 最先要看的不是：

- correction card 已经填完了

而是：

1. 当前 correction object 是否仍围绕同一个 governance object。
2. 当前 `authority reassertion` 是否真的把 authority 从 mode / dashboard 投影里救出来。
3. 当前 `ledger reseal` 与 `window refreeze` 是否真的封住旧尾账与旧窗口，而不是只剩安静感。
4. 当前 `continuation repricing` 是否真的重新给未来继续定价，而不是给默认继续换个更体面的名字。
5. 当前 `capability recustody` 与 `threshold rebinding` 是否仍围绕同一个 liability owner 与 rollback object。

## 2. 共享 correction card 最小字段

每次治理宿主修复稳态纠偏巡检，宿主、CI、评审与交接系统至少应共享：

1. `correction_card_id`
2. `governance_object_id`
3. `steady_correction_object`
4. `authority_reassertion`
5. `ledger_reseal`
6. `window_refreeze`
7. `continuation_repricing`
8. `capability_recustody`
9. `threshold_rebinding`
10. `correction_verdict`
11. `verdict_reason`
12. `liability_owner`
13. `corrected_at`

四类消费者的分工应固定为：

1. 宿主看 authority source、writer chokepoint 与 capability scope 是否仍唯一。
2. CI 看 ledger、window、pricing、custody 与 threshold 顺序是否完整。
3. 评审看 correction verdict 是否仍围绕同一个治理对象，而不是围绕 mode 与图表投影。
4. 交接看 later 团队能否只凭 correction card 重建同一判定与责任边界。

## 3. 固定 correction verdict 顺序

### 3.1 先验 `steady_correction_object`

先看当前准备宣布纠偏完成的，到底是不是同一个 `governance_object_id`，而不是一张更正式的稳定说明。

### 3.2 再验 `authority_reassertion`

再看：

1. `authority_source_before` 与 `authority_source_after` 是否已明确重绑。
2. `mode_projection_demoted` 是否仍保证 mode 只是 authority 投影。
3. capability custody 是否仍由唯一 writer chokepoint 发放，而不是由面板恢复感发放。

### 3.3 再验 `ledger_reseal`

再看：

1. `permission_ledger_state` 是否仍自洽。
2. `pending_permission_requests`、late response 与 orphan state 是否已正式清账。
3. 当前 capability custody 是否仍不会继承旧尾账。

### 3.4 再验 `window_refreeze`

再看：

1. `decision_window`、`context_usage_snapshot` 与 `reserved_buffer` 是否仍属于同一窗口。
2. `window_dormancy_restored` 是否仍防止旧窗口复活。
3. usage 回落是否只是窗口证据，而不是 verdict 本身。

### 3.5 再验 `continuation_repricing`

再看：

1. `continuation_gate` 是否已被重新裁定。
2. `budget_policy_generation` 与 `settled_price` 是否仍把未来继续重新定价。
3. 当前 capability custody 是否阻止“没报错就继续”的免费扩张。

### 3.6 再验 `capability_recustody`

再看：

1. `capability_release_scope` 是否仍围绕同一个 rollback / expansion object。
2. `custody_owner` 与 `quarantine_recall_handle` 是否仍明确。
3. capability 是否按 scope 被分层托管，而不是一次性全放开。

### 3.7 最后验 `threshold_rebinding` 与 `correction_verdict`

最后才看：

1. `authority_drift_trigger`、`liability_owner` 与 `threshold_retained_until` 是否仍明确记录。
2. `correction_verdict` 是否与前六步对象完全一致。
3. 交接是否足以让 later 团队在无需补猜的前提下接手与降级。

更稳的最终 verdict 只应落在：

1. `steady_state_restored`
2. `hard_reject`
3. `liability_hold`
4. `reentry_required`
5. `reopen_required`

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前治理 correction execution：

1. `steady_correction_object_missing`
2. `authority_reassertion_failed`
3. `ledger_reseal_required`
4. `window_refreeze_required`
5. `free_continuation_detected`
6. `capability_recustody_missing`
7. `threshold_rebinding_required`
8. `reopen_required`

## 5. capability recustody 与 threshold rebinding 顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先冻结新的 capability expansion，直到 correction card 补全。
2. 先把 verdict 降为 `hard_reject`、`liability_hold` 或 `reentry_required`。
3. 先按固定顺序重验 authority、ledger、window、pricing 与 custody，不允许跳过 `continuation_repricing`。
4. 先做一次 late response、orphan request 与 repricing due replay，确认旧窗口与旧尾账不会复活。
5. 只按 `capability_release_scope` 分层恢复 capability，不做一次性全放开。
6. 交接前必须把 `liability_owner` 与 `threshold_rebinding` 写成 later 团队可消费的对象，而不是一句“有问题再 reopen”。

## 6. 最小 drill 集

每轮至少跑下面五个治理宿主稳态纠偏执行演练：

1. `authority_reassertion_recheck`
2. `ledger_reseal_replay`
3. `window_refreeze_replay`
4. `continuation_repricing_reprice`
5. `capability_recustody_threshold_replay`

## 7. 复盘记录最少字段

每次治理宿主稳态纠偏失败、再入场或 reopen，至少记录：

1. `correction_card_id`
2. `governance_object_id`
3. `authority_reassertion`
4. `ledger_reseal`
5. `window_refreeze`
6. `continuation_repricing`
7. `capability_recustody`
8. `threshold_rebinding`
9. `correction_verdict`
10. `verdict_reason`

## 8. 苏格拉底式检查清单

在你准备宣布“治理已完成稳态纠偏执行”前，先问自己：

1. 我现在救回的是同一个治理对象，还是一套更严格的稳态说明书。
2. 我现在重申的是 authority，还是 mode 与 dashboard 的平静感。
3. 我现在重封的是 formal ledger 与 window，还是只是在接受“最近没人再报错”。
4. 我现在重建的是 continuation 的正式定价，还是给默认继续换了个更体面的名字。
5. 我现在保留的是未来推翻当前 steady 的正式 threshold，还是一句“以后有问题再看”。

## 9. 一句话总结

真正成熟的治理宿主修复稳态纠偏执行，不是把稳态看板运行得更熟练，而是持续证明 authority、ledger、window、pricing、capability 与 threshold 仍在共同约束同一个治理对象。
