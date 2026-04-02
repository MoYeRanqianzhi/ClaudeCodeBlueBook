# 治理宿主修复解除监护执行手册：release card、release verdict order、capability release与reopen liability drill

这一章不再解释治理宿主修复解除监护协议该消费哪些字段，而是把 Claude Code 式治理出监压成一张可持续执行的解除监护手册。

它主要回答五个问题：

1. 为什么安全设计与省 token 设计的解除监护真正执行的是同一个治理对象，而不是 mode、usage 面板与保守建议。
2. 宿主、CI、评审与交接怎样共享同一张治理 release card，而不是各自宣布不同版本的“现在可以放行”。
3. 应该按什么固定顺序执行 authority release、ledger clearance、window exit、continuation settlement、quarantine release 与 reopen liability，才能不让免费继续重新进场。
4. 哪些 release reason 一旦出现就必须冻结 capability release、拒绝 handoff 并进入 reopen liability drill。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的放行看板”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-619`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1407-1450`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1506-1531`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1735-1747`
- `claude-code-source-code/src/cli/structuredIO.ts:362-657`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:84-645`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:1035-1134`
- `claude-code-source-code/src/utils/permissions/permissions.ts:929-1318`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/utils/analyzeContext.ts:1098-1382`
- `claude-code-source-code/src/query/tokenBudget.ts:22-92`
- `claude-code-source-code/src/query.ts:1308-1518`

## 1. 第一性原理

治理宿主修复解除监护真正要执行的不是：

- mode 名字恢复正常
- usage 面板重新转绿
- later 团队愿意先保守一点

而是：

- authority、ledger、window、continuation、quarantine 与 reopen liability 仍围绕同一个治理对象正式宣布 capability 可以恢复放行

所以这层 playbook 最先要看的不是：

- release card 已经填完了

而是：

1. 当前 authority 是否仍围绕正式 authority source release。
2. 当前 ledger 是否真的已经 formal clearance，而不是只剩审批历史。
3. 当前 decision window 是否真的 exit，而不是只剩 usage 图表恢复。
4. 当前 continuation 是否真的重新 settlement，而不是默认继续被美化。
5. 当前 quarantine release 与 reopen liability 是否仍围绕同一个 rollback / expansion object。

## 2. 共享 release card 最小字段

每次治理宿主修复解除监护，宿主、CI、评审与交接系统至少应共享：

1. `release_card_id`
2. `governance_release_id`
3. `authority_release`
4. `ledger_clearance`
5. `window_exit`
6. `continuation_settlement`
7. `quarantine_release`
8. `reopen_liability`
9. `capability_release_verdict`
10. `handoff_status`
11. `release_deadline`
12. `release_trigger`

四类消费者的分工应固定为：

1. 宿主看 authority source、writer chokepoint 与 capability release scope 是否仍唯一。
2. CI 看 ledger、window、continuation、quarantine 与 liability 顺序是否完整。
3. 评审看 release verdict 是否仍围绕同一个治理对象，而不是围绕 mode 与图表投影。
4. 交接看 later 团队能否只凭 release card 重建同一出监判断与重开边界。

## 3. 固定 release verdict 顺序

### 3.1 先验 `authority_release`

先看：

1. 当前 release 是否仍围绕同一个 `authority_source`。
2. `effective_settings_projection` 是否只是 authority 投影，而不是反过来充当真相。
3. 当前 capability release 是否由唯一 writer chokepoint 发放，而不是由 mode 恢复感发放。

authority 没有 release，后面所有 release 都只是投影放行。

### 3.2 再验 `ledger_clearance`

再看：

1. `typed_decision_digest` 与 `permission_ledger_state` 是否仍自洽。
2. `pending_permission_requests`、duplicate response 与 orphan state 是否已正式清账。
3. 当前 capability release 是否仍会继承旧尾账。

ledger 不清，release 就只是把旧账转交 later。

### 3.3 再验 `window_exit`

再看：

1. `decision_window`、`pending_action` 与 `context_usage_snapshot` 是否仍属于同一退出窗口。
2. `late_response_quarantined` 是否已阻止旧窗口复活。
3. `reserved_buffer` 与 compact 投影是否只作为窗口证据，而不是直接充当 exit verdict。

window 没有 exit，usage 下降也不代表可以 release。

### 3.4 再验 `continuation_settlement`

再看：

1. `continuation_gate` 是否已被重新裁定。
2. `token_budget_result` 与 `completion_event` 是否已经把未来继续重新定价。
3. 当前 capability release 是否阻止“没报错就继续”的免费扩张。

continuation 没有 settlement，出监就会把 token 与时间重新免费化。

### 3.5 再验 `quarantine_release`

再看：

1. `quarantine_scope` 是否仍围绕原 rollback / expansion object。
2. 当前 release 是否真的解除对象级冻结，而不是只解除一条值班备注。
3. capability release 是否按 scope 逐层恢复，而不是一次性全放开。

### 3.6 最后验 `reopen_liability` 与 `capability_release_verdict`

最后才看：

1. `reopen_liability` 是否明确记录了触发条件、回退边界与责任归属。
2. `capability_release_verdict` 是否与前五步对象完全一致。
3. `handoff_status` 是否足以让 later 团队在无需补猜的前提下接手。

更稳的最终 verdict 只应落在：

1. `capability_released`
2. `released_with_liability`
3. `handoff_blocked`
4. `reopen_required`

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前治理 release：

1. `authority_release_missing`
2. `ledger_clearance_failed`
3. `window_exit_unproven`
4. `continuation_settlement_missing`
5. `quarantine_not_released`
6. `capability_release_blocked`
7. `reopen_liability_missing`
8. `reopen_required`

## 5. capability release 与 reopen liability 顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先冻结新的 capability expansion，直到 release card 补全。
2. 先按固定顺序重验六类对象，不允许跳过 `continuation_settlement`。
3. 先把 verdict 降为 `handoff_blocked` 或 `released_with_liability`，再决定是否真正 capability release。
4. 先做一次 late response、orphan request 与 repricing due 的 replay，确认旧窗口与旧尾账不会复活。
5. 只按 `quarantine_scope` 分层恢复 capability，不做一次性全放开。
6. 交接前必须把 `reopen_liability` 写成 later 团队可消费的对象，而不是一句“有问题再 reopen”。

## 6. 最小 reopen liability 演练集

每轮至少跑下面六个治理宿主解除监护执行演练：

1. `authority_release_recheck`
2. `ledger_clearance_replay`
3. `window_exit_replay`
4. `continuation_settlement_reprice`
5. `quarantine_release_recheck`
6. `reopen_liability_replay`

## 7. 复盘记录最少字段

每次治理宿主解除监护失败或 reopen，至少记录：

1. `release_card_id`
2. `governance_release_id`
3. `authority_release`
4. `ledger_clearance`
5. `window_exit`
6. `continuation_settlement`
7. `quarantine_release`
8. `reopen_liability`
9. `capability_release_verdict`
10. `release_trigger`

## 8. 苏格拉底式检查清单

在你准备宣布“治理宿主修复已经 capability released”前，先问自己：

1. 我现在释放的是治理对象，还是释放值班焦虑。
2. 我现在清掉的是 formal ledger，还是接受尾账噪音常态化。
3. 我现在退出的是同一个 decision window，还是一张恢复正常的 usage 图。
4. 我现在结算的是 continuation，还是给默认继续找了个更体面的名字。
5. 我现在解除的是 quarantine，还是把硬边界降成 later 建议。

## 9. 一句话总结

真正成熟的治理宿主修复解除监护执行，不是宣布“现在可以放行了”，而是持续证明 authority、ledger、window、continuation、quarantine 与 reopen liability 仍在共同约束同一个治理对象。
