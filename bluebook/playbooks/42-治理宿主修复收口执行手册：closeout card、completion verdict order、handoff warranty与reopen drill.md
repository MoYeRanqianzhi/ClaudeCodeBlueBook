# 治理宿主修复收口执行手册：closeout card、completion verdict order、handoff warranty与reopen drill

这一章不再解释治理宿主修复收口协议该消费哪些字段，而是把 Claude Code 式治理收口压成一张可持续执行的收口手册。

它主要回答五个问题：

1. 为什么安全设计与省 token 设计的收口真正执行的是同一个治理对象，而不是 mode、审批与 token 图表。
2. 宿主、CI、评审与交接怎样共享同一张治理 closeout card，而不是各自宣布不同版本的“已经恢复正常”。
3. 应该按什么固定顺序执行治理 closeout，才能不让过期 authority、未决 ledger、未闭窗口与免费继续重新进场。
4. 哪些 verdict reason 一旦出现就必须阻断 handoff、拒绝 closeout 并进入 reopen drill。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的审批完成页”。

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
- `claude-code-source-code/src/services/compact/autoCompact.ts:72-182`

## 1. 第一性原理

治理宿主修复收口真正要执行的不是：

- mode 看起来又安全了
- 审批看起来都结束了
- token 面板看起来又健康了

而是：

- authority、ledger、window、continuation 与 rollback 仍围绕同一个治理对象在宣布完成、交接与 reopen

所以这层 playbook 最先要看的不是：

- closeout card 已经填完了

而是：

1. 当前 authority 是否仍围绕正式 authority source 收口。
2. 当前 ledger 是否已正式 seal，而不是只剩审批历史。
3. 当前 decision window 是否真的关闭，而不是只刷新了仪表盘。
4. 当前 continuation 是否真的拿到 warranty，而不是默认继续。
5. 当前 rollback 是否真的 cleared，而不是 mode/file 动作暂时停住了扩张。

## 2. 共享收口卡最小字段

每次治理宿主修复收口，宿主、CI、评审与交接系统至少应共享：

1. `closeout_card_id`
2. `governance_object_id`
3. `authority_source`
4. `typed_decision`
5. `permission_ledger_state`
6. `pending_permission_requests`
7. `decision_window`
8. `context_usage_snapshot`
9. `continuation_warranty`
10. `rollback_clearance`
11. `closeout_verdict`
12. `handoff_warranty`

四类消费者的分工应固定为：

1. 宿主看 authority source 与 writer chokepoint 是否仍唯一。
2. CI 看 ledger、window、continuation 与 rollback 清算是否完整。
3. 评审看 verdict 与治理对象是否自洽。
4. 交接看 later 团队能否围绕同一 authority source 与 reopen 条件继续判断。

## 3. 固定完成判定顺序

### 3.1 先验 authority settlement

先看：

1. 当前 `authority_source_before/after` 是否仍指向同一治理主权。
2. mode 是否仍被降格成 authority 的投影。
3. 是否仍不存在 internal mode 泄漏为 closeout 真相的旁路。

### 3.2 再验 ledger seal

再看：

1. `permission_ledger` 是否已经 seal，而不是仍有 stale pending request。
2. `typed_decision` 是否仍留下 formal reason，而不是只剩审批完成感。
3. duplicate / orphan / cancel 是否仍已被正式收口。

### 3.3 再验 window closure

再看：

1. 当前 `decision_window`、`pending_action` 与 `context_usage_snapshot` 是否仍属于同一关闭窗口。
2. late response 是否仍不会复活已关闭窗口。
3. compact 是否仍是窗口重写动作，而不是一段辅助摘要流程。

### 3.4 再验 continuation warranty 与 rollback clearance

再看：

1. `continuation_warranty` 是否仍围绕 gain 判断与 token budget result。
2. `rollback_clearance` 是否仍证明 rollback object 已经被正式清算。
3. handoff 前是否仍没有免费继续与未决扩张残留。

### 3.5 最后验 closeout verdict 与 reopen drill

最后才看：

1. `closeout_verdict` 是否与前四步对象一致。
2. `handoff_warranty` 是否足以让 later 团队围绕同一治理对象接手。
3. reopen 是否仍回到同一个 governance object，而不是回到某个更保守的 mode。

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前治理 closeout：

1. `authority_not_settled`
2. `ledger_not_sealed`
3. `window_not_closed`
4. `continuation_not_warranted`
5. `rollback_not_cleared`
6. `baseline_reset_unproven`
7. `handoff_not_ready`
8. `reopen_required`

## 5. 交接与 reopen 顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先冻结新的 capability expansion，不再让 automation 或 later 继续扩张。
2. 先把 closeout verdict 降级为 `monitor_only` 或 `reopen_required`。
3. 先关闭当前 window 并隔离 outstanding request。
4. 先重建 authority、ledger 与 budget verdict，再允许 handoff warranty 重新发放。
5. 如果根因落在治理制度本身，就回跳 `../guides/64` 做制度纠偏。

## 6. 最小 reopen 演练集

每轮至少跑下面六个治理宿主收口执行演练：

1. `authority_settlement_recheck`
2. `ledger_drain_recheck`
3. `late_response_reopen`
4. `continuation_warranty_recheck`
5. `compact_governance_recheck`
6. `handoff_ready_replay`

## 7. 复盘记录最少字段

每次治理宿主收口失败或 reopen，至少记录：

1. `closeout_card_id`
2. `governance_object_id`
3. `authority_source`
4. `permission_ledger_state`
5. `decision_window`
6. `continuation_warranty`
7. `rollback_clearance`
8. `closeout_verdict`
9. `handoff_warranty`
10. `reopen_trigger`

## 8. 苏格拉底式检查清单

在你准备宣布“治理宿主修复已经正式收口”前，先问自己：

1. 我宣布关闭的是治理对象，还是一组 mode 和图表。
2. 我现在看到的是正式 ledger，还是审批历史。
3. window 真正被关闭了，还是只刷新了 usage 仪表盘。
4. 现在的继续是 warranty，还是默认继续。
5. later 团队如果只看我的收口卡，能不能重建同一治理判断。

## 9. 一句话总结

真正成熟的治理宿主修复收口执行，不是把 mode、审批与 token 图表拼成更复杂的完成页，而是持续证明 authority、ledger、window、continuation 与 rollback 仍是同一个治理对象的完成链。
