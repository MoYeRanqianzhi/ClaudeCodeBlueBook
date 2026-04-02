# 治理宿主修复稳态执行手册：steady-state card、pricing verdict order、capability custody与liability drill

这一章不再解释治理宿主修复稳态协议该消费哪些字段，而是把 Claude Code 式治理 steady state 压成一张可持续执行的稳态手册。

它主要回答五个问题：

1. 为什么安全设计与省 token 设计在稳态里执行的不是“现在看起来安全”，而是同一个治理对象仍在持续定价一切扩张。
2. 宿主、CI、评审与交接怎样共享同一张治理 steady-state card，而不是各自宣布不同版本的“现在可以继续放行”。
3. 应该按什么固定顺序执行 `authority continuity`、`ledger dormancy seal`、`window dormancy`、`continuation pricing covenant`、`capability custody` 与 `reopen threshold`，才能不让免费继续重新进场。
4. 哪些 steady verdict 一旦出现就必须冻结 capability expansion、拒绝 handoff 并进入 liability / reopen drill。
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

治理宿主修复稳态真正要执行的不是：

- mode 名字恢复正常
- usage 面板重新转绿
- later 团队愿意先保守一点

而是：

- authority、ledger、window、continuation、capability 与 reopen threshold 仍围绕同一个治理对象正式宣布 capability 可以继续被定价、被托管、被必要时回收

所以这层 playbook 最先要看的不是：

- steady-state card 已经填完了

而是：

1. 当前 authority 是否仍围绕唯一 authority source。
2. 当前 ledger 是否真的进入 dormancy seal，而不是只剩审批历史。
3. 当前 decision window 是否真的进入 dormancy，而不是只剩 usage 图表恢复。
4. 当前 continuation 是否真的被重新定价，而不是默认继续被美化。
5. 当前 capability custody 与 reopen threshold 是否仍围绕同一个 rollback / expansion object。

## 2. 共享 steady-state card 最小字段

每次治理宿主修复稳态巡检，宿主、CI、评审与交接系统至少应共享：

1. `steady_state_card_id`
2. `governance_object_id`
3. `authority_continuity`
4. `ledger_dormancy_seal`
5. `window_dormancy`
6. `continuation_pricing_covenant`
7. `capability_custody`
8. `reopen_threshold`
9. `steady_verdict`
10. `verdict_reason`
11. `liability_owner`
12. `evaluated_at`

四类消费者的分工应固定为：

1. 宿主看 authority source、writer chokepoint 与 capability scope 是否仍唯一。
2. CI 看 ledger、window、pricing、custody 与 threshold 顺序是否完整。
3. 评审看 steady verdict 是否仍围绕同一个治理对象，而不是围绕 mode 与图表投影。
4. 交接看 later 团队能否只凭 steady-state card 重建同一判定与责任边界。

## 3. 固定 steady verdict 顺序

### 3.1 先验 `authority continuity`

先看：

1. 当前 steady 是否仍围绕同一个 `authority_source`。
2. `effective_settings_projection` 是否只是 authority 投影，而不是反过来充当真相。
3. capability custody 是否由唯一 writer chokepoint 发放，而不是由 mode 恢复感发放。

authority 一旦漂移，后面所有 steady 都只是投影稳态。

### 3.2 再验 `ledger dormancy seal`

再看：

1. `permission_ledger_state` 是否仍自洽。
2. `pending_permission_requests`、late response 与 orphan state 是否已正式清账。
3. 当前 capability custody 是否仍会继承旧尾账。

ledger 不稳，steady 就只是把旧账转交 later。

### 3.3 再验 `window dormancy`

再看：

1. `decision_window`、`context_usage_snapshot` 与 `reserved_buffer` 是否仍属于同一窗口。
2. `window_refresh_threshold` 是否仍防止旧窗口复活。
3. compact 或 usage 下降是否只作为窗口证据，而不是直接充当 verdict。

window 没有 dormancy，usage 回落也不代表可以 steady。

### 3.4 再验 `continuation pricing covenant`

再看：

1. `continuation_gate` 是否已被重新裁定。
2. `budget_policy_generation` 与 `settled_price` 是否仍把未来继续重新定价。
3. 当前 capability custody 是否阻止“没报错就继续”的免费扩张。

continuation 没有 covenant，稳态就会把 token 与时间重新免费化。

### 3.5 再验 `capability custody`

再看：

1. `capability_release_scope` 是否仍围绕原 rollback / expansion object。
2. 当前 steady 是否真的托管对象级 capability，而不是只托管一条值班备注。
3. capability 是否按 scope 被分层托管，而不是一次性全放开。

### 3.6 最后验 `reopen threshold` 与 `steady_verdict`

最后才看：

1. `authority_drift_trigger`、`liability_owner` 与 `residual_risk_digest` 是否仍明确记录。
2. `steady_verdict` 是否与前五步对象完全一致。
3. 交接是否足以让 later 团队在无需补猜的前提下接手与降级。

更稳的最终 verdict 只应落在：

1. `steady_state`
2. `steady_state_blocked`
3. `liability_hold`
4. `reentry_required`
5. `reopen_required`

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前治理 steady state：

1. `authority_continuity_missing`
2. `ledger_dormancy_unsealed`
3. `window_dormancy_broken`
4. `free_continuation_detected`
5. `capability_custody_missing`
6. `reopen_threshold_missing`
7. `authority_drift_detected`
8. `reopen_required`

## 5. capability custody 与 liability 顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先冻结新的 capability expansion，直到 steady-state card 补全。
2. 先把 verdict 降为 `steady_state_blocked`、`liability_hold` 或 `reentry_required`。
3. 先按固定顺序重验 authority、ledger、window、pricing 与 custody，不允许跳过 `continuation_pricing_covenant`。
4. 先做一次 late response、orphan request 与 repricing due replay，确认旧窗口与旧尾账不会复活。
5. 只按 `capability_release_scope` 分层恢复 capability，不做一次性全放开。
6. 交接前必须把 `liability_owner` 与 `reopen_threshold` 写成 later 团队可消费的对象，而不是一句“有问题再 reopen”。

## 6. 最小 liability 演练集

每轮至少跑下面七个治理宿主稳态执行演练：

1. `authority_continuity_recheck`
2. `ledger_dormancy_replay`
3. `window_dormancy_replay`
4. `continuation_pricing_reprice`
5. `capability_custody_recheck`
6. `reopen_liability_replay`
7. `free_continuation_fallback`

## 7. 复盘记录最少字段

每次治理宿主稳态失败、再入场或 reopen，至少记录：

1. `steady_state_card_id`
2. `governance_object_id`
3. `authority_continuity`
4. `ledger_dormancy_seal`
5. `window_dormancy`
6. `continuation_pricing_covenant`
7. `capability_custody`
8. `reopen_threshold`
9. `steady_verdict`
10. `verdict_reason`

## 8. 苏格拉底式检查清单

在你准备宣布“治理已经 steady”前，先问自己：

1. 我现在保护的是治理对象，还是一段更舒服的 mode 体验。
2. `ledger dormancy seal` 真的封住了尾账，还是最近没人再点开审批记录。
3. `continuation pricing covenant` 保护的是继续定价，还是一次暂时没超预算的好运气。
4. capability custody 托管的是能力边界，还是一个继续显示在界面上的开关。
5. `reopen threshold` 还在不在，如果不在，我是在进入稳态，还是在删除未来追责与回滚的能力。

## 9. 一句话总结

真正成熟的治理宿主修复稳态执行，不是宣布“现在看起来安全”，而是持续证明 authority、ledger、window、continuation、capability 与 reopen threshold 仍在共同约束同一个治理对象。
