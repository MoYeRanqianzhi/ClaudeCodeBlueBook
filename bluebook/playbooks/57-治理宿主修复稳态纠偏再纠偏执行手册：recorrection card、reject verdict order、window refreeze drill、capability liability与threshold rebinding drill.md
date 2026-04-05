# 治理宿主修复稳态纠偏再纠偏执行手册：recorrection card、reject verdict order、window refreeze drill、capability liability与threshold rebinding drill

这一章不再解释治理宿主修复稳态纠偏再纠偏协议该消费哪些字段，而是把 Claude Code 式治理 steady-state correction-of-correction protocol 压成一张可持续执行的 `recorrection card`。

它主要回答五个问题：

1. 为什么安全设计与省 token 设计在再纠偏执行里运行的不是“两套系统互相权衡”，而是同一个治理控制面持续拒绝免费扩张。
2. 宿主、CI、评审与交接怎样共享同一张治理 `recorrection card`，而不是各自宣布不同版本的“现在可以继续”。
3. 应该按什么固定顺序执行 `authority source restitution`、`ledger reseal`、`decision window refreeze`、`continuation pricing rebinding`、`capability liability recustody` 与 `threshold rebinding`，才能不让免费继续、免费扩窗与免费放权重新进场。
4. 哪些 `reject verdict` 一旦出现就必须冻结 capability expansion、拒绝 handoff 并进入 `liability / re-entry / reopen` drill。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的治理看板”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-619`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:337-348`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1407-1450`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1533-1541`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1735-1747`
- `claude-code-source-code/src/cli/structuredIO.ts:362-657`
- `claude-code-source-code/src/cli/print.ts:1052-1075`
- `claude-code-source-code/src/cli/print.ts:4568-4641`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:84-645`
- `claude-code-source-code/src/utils/permissions/permissions.ts:929-1318`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/utils/analyzeContext.ts:1098-1382`
- `claude-code-source-code/src/query/tokenBudget.ts:22-92`
- `claude-code-source-code/src/query.ts:1308-1518`

## 1. 第一性原理

治理宿主修复稳态纠偏再纠偏真正要执行的不是：

- mode 名字恢复正常
- usage 面板重新转绿
- later 团队愿意先保守一点

而是：

- authority、ledger、window、continuation、capability liability 与 threshold 仍围绕同一个治理对象正式宣布：现在什么能继续、什么值得继续、什么必须被拒绝继续

安全设计反对的是：

- 未定价的危险扩张

省 token 设计反对的是：

- 未定价的低收益扩张

这两者在 Claude Code 里实际上是同一条控制面。

所以这层 playbook 最先要看的不是：

- `recorrection card` 已经填完了

而是：

1. 当前 recorrection object 是否仍围绕同一个 governance object。
2. 当前 `authority source restitution` 是否真的把 authority 从 mode 与 dashboard 投影里救出来。
3. 当前 `decision window refreeze` 是否真的把 `Context Usage`、`reserved buffer` 与继续资格放回同一窗口对象。
4. 当前 `continuation pricing rebinding` 是否真的重新给未来继续定价，而不是给默认继续换个更体面的名字。
5. 当前 `capability liability recustody` 与 `threshold rebinding` 是否仍围绕同一个 liability owner 与 rollback boundary。

## 2. 共享 recorrection card 最小字段

每次治理宿主修复稳态纠偏再纠偏巡检，宿主、CI、评审与交接系统至少应共享：

1. `recorrection_card_id`
2. `governance_object_id`
3. `authority_source_after`
4. `typed_decision_digest`
5. `permission_ledger_state`
6. `decision_window`
7. `context_usage_snapshot`
8. `reserved_buffer`
9. `continuation_gate`
10. `settled_price`
11. `capability_release_scope`
12. `liability_owner`
13. `threshold_retained_until`
14. `reject_verdict`
15. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看 authority source、writer chokepoint 与 capability scope 是否仍唯一。
2. CI 看 ledger、window、pricing、liability 与 threshold 顺序是否完整。
3. 评审看 `reject_verdict` 是否仍围绕同一个治理对象，而不是围绕 mode 与图表投影。
4. 交接看 later 团队能否只凭 `recorrection card` 重建同一判定与责任边界。

## 3. 固定 reject verdict 顺序

### 3.1 先验 `recorrection_object`

先看当前准备宣布再纠偏完成的，到底是不是同一个 `governance_object_id`，而不是一张更正式的稳定说明。

### 3.2 再验 `authority source restitution`

再看：

1. `authority_source_before` 与 `authority_source_after` 是否已明确重绑。
2. `mode_projection_demoted` 是否仍保证 mode 只是 authority 投影。
3. capability custody 是否仍由唯一 writer chokepoint 发放，而不是由面板恢复感发放。

### 3.3 再验 `ledger reseal`

再看：

1. `permission_ledger_state` 是否仍自洽。
2. `pending_permission_requests`、late response 与 orphan state 是否已正式清账。
3. 当前 capability liability 是否仍不会继承旧尾账。

### 3.4 再验 `decision window refreeze`

再看：

1. `decision_window`、`context_usage_snapshot` 与 `reserved_buffer` 是否仍属于同一窗口。
2. `deferred categories`、tool/result breakdown 与 API usage 是否仍被正式写回窗口对象，而不是留在 dashboard。
3. 当前 recorrection 是否仍阻止旧窗口与旧上下文投影复活。

### 3.5 再验 `continuation pricing rebinding`

再看：

1. `continuation_gate` 是否已被重新裁定。
2. `budget_policy_generation` 与 `settled_price` 是否仍把未来继续重新定价。
3. 当前控制面是否仍阻止“没报错就继续”的免费扩张。

### 3.6 再验 `capability liability recustody`

再看：

1. `capability_release_scope` 是否仍围绕同一个 rollback / expansion object。
2. `custody_owner`、`liability_owner` 与 `quarantine_recall_handle` 是否仍明确。
3. capability 是否按 scope 被分层托管，而不是一次性全放开。

### 3.7 最后验 `threshold rebinding` 与 `reject_verdict`

最后才看：

1. `authority_drift_trigger`、`threshold_retained_until` 与 `reopen_required_when` 是否仍明确记录。
2. `reject_verdict` 是否与前六步对象完全一致。
3. 交接是否足以让 later 团队在无需补猜的前提下接手与降级。

更稳的最终 verdict 只应落在：

1. `steady_state_restituted`
2. `hard_reject`
3. `liability_hold`
4. `reentry_required`
5. `reopen_required`

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前治理 recorrection execution：

1. `recorrection_object_missing`
2. `authority_source_missing`
3. `ledger_reseal_required`
4. `window_truth_missing`
5. `free_continuation_detected`
6. `capability_liability_unbound`
7. `threshold_rebinding_missing`
8. `reopen_required`

## 5. capability liability 与 threshold rebinding 处理顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先冻结新的 capability expansion，直到 `recorrection card` 补全。
2. 先把 verdict 降为 `hard_reject`、`liability_hold`、`reentry_required` 或 `reopen_required`。
3. 先把 mode、usage dashboard 与“当前还挺省”的感觉降回投影，不再让它们充当治理真相。
4. 先按固定顺序重验 authority、ledger、window、pricing 与 liability，不允许跳过 `decision window refreeze`。
5. 只按 `capability_release_scope` 分层恢复 capability，不做一次性全放开。
6. 交接前必须把 `liability_owner` 与 `threshold rebinding` 写成 later 团队可消费的对象，而不是一句“有问题再 reopen”。

## 6. 最小 drill 集

每轮至少跑下面六个治理宿主稳态纠偏再纠偏执行演练：

1. `authority_source_restitution_recheck`
2. `ledger_reseal_replay`
3. `decision_window_refreeze_replay`
4. `context_usage_window_reconsume`
5. `continuation_pricing_rebind_replay`
6. `capability_liability_threshold_replay`

## 7. 复盘记录最少字段

每次治理宿主稳态纠偏再纠偏失败、再入场或 reopen，至少记录：

1. `recorrection_card_id`
2. `governance_object_id`
3. `authority_source_after`
4. `permission_ledger_state`
5. `decision_window`
6. `context_usage_snapshot`
7. `settled_price`
8. `capability_release_scope`
9. `liability_owner`
10. `threshold_retained_until`
11. `reject_verdict`
12. `verdict_reason`

## 8. 苏格拉底式检查清单

在你准备宣布“治理已完成稳态纠偏再纠偏执行”前，先问自己：

1. 我现在救回的是同一个治理对象，还是一套更严格的稳定说明书。
2. 我现在重申的是 authority，还是 mode 与 dashboard 的平静感。
3. 我现在冻结的是 formal `decision window`，还是只是在看 token 百分比是否回落。
4. 我现在恢复的是 continuation 的正式定价，还是给默认继续换了个更体面的名字。
5. 我现在保留的是未来推翻当前 steady 的正式 threshold，还是一句“以后有问题再看”。

## 9. 一句话总结

真正成熟的治理宿主修复稳态纠偏再纠偏执行，不是把治理面板运行得更熟练，而是持续证明 authority、ledger、window、pricing、capability liability 与 threshold 仍在共同拒绝免费扩张。
