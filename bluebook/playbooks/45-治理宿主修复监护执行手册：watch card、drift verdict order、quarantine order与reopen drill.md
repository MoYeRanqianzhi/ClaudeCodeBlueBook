# 治理宿主修复监护执行手册：watch card、drift verdict order、quarantine order与reopen drill

这一章不再解释治理宿主修复监护协议该消费哪些字段，而是把 Claude Code 式治理监护压成一张可持续执行的监护手册。

它主要回答五个问题：

1. 为什么安全设计与省 token 设计的监护真正执行的是同一个治理对象，而不是 mode、usage 面板与保守建议。
2. 宿主、CI、评审与交接怎样共享同一张治理 watch card，而不是各自宣布不同版本的‘先观察’。
3. 应该按什么固定顺序执行治理监护，才能不让 authority drift、ledger residue、window reopening 与免费继续重新进场。
4. 哪些 drift reason 一旦出现就必须冻结 capability expansion、拒绝继续 watch 并进入 reopen drill。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的运维观察页”。

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

治理宿主修复监护真正要执行的不是：

- mode 看起来还正常
- usage 面板看起来还健康
- later 团队先保守一点

而是：

- authority、ledger、window、continuation 与 rollback 仍围绕同一个治理对象在观察 drift、冻结扩张与决定 reopen

所以这层 playbook 最先要看的不是：

- watch card 已经填完了

而是：

1. 当前 authority 是否仍围绕正式 authority source 监护。
2. 当前 ledger 是否仍在正式记录残留，而不是只剩审批历史。
3. 当前 decision window 是否真的仍被观察，而不是只剩仪表盘刷新。
4. 当前 continuation 是否仍在被重新定价，而不是默认继续。
5. 当前 quarantine 是否真的仍围绕 rollback object，而不是只剩操作建议。

## 2. 共享监护卡最小字段

每次治理宿主修复监护，宿主、CI、评审与交接系统至少应共享：

1. `watch_card_id`
2. `governance_watch_id`
3. `authority_watch`
4. `ledger_residue`
5. `window_watch`
6. `continuation_repricing_watch`
7. `rollback_quarantine`
8. `watch_verdict`
9. `drift_reason`
10. `handoff_status`
11. `watch_deadline`
12. `reopen_trigger`

四类消费者的分工应固定为：

1. 宿主看 authority source 与 writer chokepoint 是否仍唯一。
2. CI 看 ledger、window、continuation 与 quarantine 顺序是否完整。
3. 评审看 drift reason 与治理对象是否自洽。
4. 交接看 later 团队能否围绕同一治理对象继续观察或安全 reopen。

## 3. 固定漂移判定顺序

### 3.1 先验 authority watch

先看：

1. 当前 `authority_source_snapshot` 是否仍指向同一治理主权。
2. mode 是否仍被降格成 authority 的投影。
3. 是否仍不存在 internal mode 泄漏为监护真相的旁路。

### 3.2 再验 ledger residue

再看：

1. `permission_ledger_state` 是否仍有 formal reason，而不是只剩审批历史。
2. `pending_permission_requests`、late response 与 orphan state 是否仍被正式记账。
3. residue 是否仍可被清空，而不是口头说明“应该没事了”。

### 3.3 再验 window watch

再看：

1. 当前 `decision_window`、`pending_action` 与 `context_usage_snapshot` 是否仍属于同一观察窗口。
2. late response 是否仍不会复活已关闭窗口。
3. compact 是否仍是窗口重写动作，而不是一段辅助摘要流程。

### 3.4 再验 continuation repricing watch

再看：

1. `continuation_gate` 是否仍围绕 gain 判断与 token budget result。
2. `repricing_due_at` 是否仍有效。
3. 当前 watch 是否仍阻止免费继续与过期决定继续生效。

### 3.5 最后验 rollback quarantine 与 watch verdict

最后才看：

1. `rollback_quarantine` 是否仍隔离了余波扩张。
2. `watch_verdict` 是否与前四步对象一致。
3. reopen 是否仍回到同一个 governance object，而不是回到某个更保守的 mode。

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前治理 watch：

1. `authority_drift_detected`
2. `ledger_residue_detected`
3. `window_drift_detected`
4. `continuation_repricing_due`
5. `rollback_quarantine_active`
6. `handoff_blocked`
7. `reopen_required`
8. `watch_window_expired`

## 5. quarantine 与 reopen 顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先冻结新的 capability expansion，不再让 automation 或 later 继续扩张。
2. 先把 watch verdict 降级为 `handoff_blocked` 或 `reopen_required`。
3. 先排空 ledger residue 并隔离 outstanding request。
4. 先重建 authority、window 与 repricing watch，再允许 handoff 恢复。
5. 如果根因落在监护制度本身，就回跳 `../guides/67` 做制度纠偏。

## 6. 最小 reopen 演练集

每轮至少跑下面六个治理宿主监护执行演练：

1. `authority_watch_recheck`
2. `ledger_residue_drain`
3. `late_response_quarantine_replay`
4. `repricing_due_replay`
5. `rollback_quarantine_recheck`
6. `handoff_watch_replay`

## 7. 复盘记录最少字段

每次治理宿主监护失败或 reopen，至少记录：

1. `watch_card_id`
2. `governance_watch_id`
3. `authority_watch`
4. `ledger_residue`
5. `window_watch`
6. `continuation_repricing_watch`
7. `rollback_quarantine`
8. `watch_verdict`
9. `drift_reason`
10. `reopen_trigger`

## 8. 苏格拉底式检查清单

在你准备宣布“治理宿主修复已经 stable under watch”前，先问自己：

1. 我现在监护的是治理对象，还是一组 mode 和图表。
2. 我现在看到的是正式 ledger，还是审批历史。
3. window 真正被观察着，还是只刷新了 usage 仪表盘。
4. 现在的继续是 repricing，还是默认继续。
5. later 团队如果只看我的 watch card，能不能重建同一治理判断。

## 9. 一句话总结

真正成熟的治理宿主修复监护执行，不是让团队‘先保守点’，而是持续证明 authority、ledger、window、continuation 与 rollback 仍在共同监护同一个治理对象。
