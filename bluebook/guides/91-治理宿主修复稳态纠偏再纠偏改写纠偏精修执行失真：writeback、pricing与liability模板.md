# 如何把治理宿主修复稳态纠偏再纠偏改写纠偏精修执行失真压回统一定价控制面：固定refinement顺序、writeback、pricing与liability改写模板骨架

这一章不再解释治理宿主修复稳态纠偏再纠偏改写纠偏精修执行最常怎样失真，而是把 Claude Code 式治理 refinement execution distortion 压成一张可执行的 builder-facing 手册。

它主要回答五个问题：

1. 为什么治理 refinement execution distortion 真正要救回的不是一张更完整的 `host consumption card`，而是同一个统一定价控制面。
2. 怎样把假 `host consumption card`、假 `authority-ledger covenant`、假 `writeback seam round-trip`、免费继续回魂与假 `reopen liability ledger` 压回固定 `refinement order`。
3. 哪些现象应被直接升级为硬拒收，而不是继续补 mode 注释、usage 截图与审批平静感。
4. 怎样把 `host consumption card`、`writeback repricing block` 与 `reopen liability ticket` 重新压回对象级骨架。
5. 怎样用苏格拉底式追问避免把改写写成“把治理看板再做严格一点”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-619`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:337-348`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1407-1450`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1533-1541`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1735-1747`
- `claude-code-source-code/src/cli/structuredIO.ts:362-657`
- `claude-code-source-code/src/cli/print.ts:1052-1075`
- `claude-code-source-code/src/cli/print.ts:4568-4641`
- `claude-code-source-code/src/utils/permissions/permissions.ts:526-1318`
- `claude-code-source-code/src/utils/permissions/yoloClassifier.ts:1250-1312`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/utils/analyzeContext.ts:1098-1382`
- `claude-code-source-code/src/query/tokenBudget.ts:22-92`
- `claude-code-source-code/src/query.ts:1308-1518`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`

## 1. 第一性原理

治理 refinement execution distortion 真正要救回的不是：

- 一张更严的宿主消费卡
- 一套更谨慎的值班顺序
- 一份更完整的 reopen 备注

而是：

- authority、ledger、window、pricing、classifier、writeback seam、capability liability 与 threshold 仍围绕同一个治理对象正式拒绝免费扩张

所以更稳的纠偏目标不是：

- 先把治理 refinement 叙事说圆

而是：

1. 先把假 `host consumption card` 降回投影，而不是让 mode 与 dashboard 充当主对象。
2. 先把 `authority-ledger covenant` 从 calmer dashboard 与审批平静感里救出来。
3. 先把 `writeback seam round-trip` 从 UI calmness 与本地成功提示里救出来。
4. 先把 `window-pricing covenant + classifier cost` 从“似乎还能继续”的感觉里救出来。
5. 最后才把 `reopen liability ledger` 从默认继续与礼貌说明里救出来。

## 2. 固定 refinement 顺序

### 2.1 先冻结假 `host consumption card`

第一步不是润色消费卡，而是冻结假修复信号：

1. 禁止 `reject_verdict=steady_state_chain_resealed` 在对象复核之前生效。
2. 禁止 mode 名字、usage 图表与 pending-action 平静感重新充当治理真相。
3. 禁止本地 enqueue 成功冒充 writeback round-trip。
4. 禁止“现在还没报错”冒充定价与 liability 仍成立。

最小冻结对象：

1. `host_consumption_card_id`
2. `refinement_session_id`
3. `governance_object_id`
4. `authority_source_after`
5. `permission_ledger_state`
6. `decision_window`
7. `reject_verdict`
8. `verdict_reason`

### 2.2 再恢复 `authority-ledger covenant`

第二步要救回：

1. `governance_object_id`
2. `authority_source_after`
3. `single_truth_chain_ref`
4. `typed_decision_digest`
5. `permission_ledger_state`
6. `pending_permission_requests`
7. `authority_restituted_at`

不要继续做的事：

1. 不要先看 dashboard 是否更平静。
2. 不要先看审批 UI 是否看起来已经结束。
3. 不要先看 later 团队是否主观觉得“现在应该没事”。

### 2.3 再恢复 `window-pricing covenant`

第三步要把治理窗口从图表与感觉拉回正式对象：

1. `decision_window`
2. `context_usage_snapshot`
3. `reserved_buffer`
4. `settled_price`
5. `budget_policy_generation`
6. `free_continuation_blocked`

没有这一步，refinement execution 仍会把窗口与定价写成 usage 截图与经验判断。

### 2.4 再恢复 `classifier-writeback custody`

第四步要把安全判断与宿主写回从 UI 里救回：

1. `classifier_cost_priced`
2. `classifier_verdict_ref`
3. `classifier_budget_source`
4. `requires_action_ref`
5. `pending_action_ref`
6. `session_state_changed_ref`
7. `writeback_seam_attested`
8. `late_response_quarantined`

没有这一步，refinement execution 仍会让 “pending action 消失” 与 “本地成功提示” 冒充宿主真相。

### 2.5 再恢复 `capability liability ledger`

第五步要把责任从运营备注里救回：

1. `capability_release_scope`
2. `liability_owner`
3. `rollback_object`
4. `authority_drift_trigger`
5. `threshold_retained_until`
6. `reentry_required_when`
7. `reopen_required_when`

没有这一步，所谓“更保守”只是一种没有 owner 的运营感觉。

### 2.6 最后恢复 `reopen liability ledger`

最后才把 future reopen 的正式能力救回：

1. `authority_drift_trigger`
2. `threshold_retained_until`
3. `reentry_required_when`
4. `reopen_required_when`
5. `liability_owner`
6. `liability_scope`
7. `reopen_liability_attested_at`

不要反过来：

1. 不要先补 reopen 说明，再修 authority object。
2. 不要先让 dashboard 转绿，再修 writeback round-trip。
3. 不要先让 capability 继续放行，再修 classifier 与 settled price。

## 3. 硬拒收规则

出现下面情况时，应直接升级为硬拒收：

1. `refinement_session_missing`
2. `authority_source_unexternalized`
3. `mode_projection_as_authority`
4. `permission_ledger_state_unsealed`
5. `pending_permission_requests_nonzero`
6. `decision_window_as_dashboard`
7. `settled_price_missing`
8. `classifier_cost_unpriced`
9. `writeback_seam_round_trip_missing`
10. `pending_action_ui_calm_but_state_unwritten`
11. `free_continuation_detected`
12. `capability_liability_unbound`
13. `threshold_rebinding_missing`
14. `reopen_required_but_card_still_green`

## 4. 模板骨架

### 4.1 host consumption card 骨架

1. `host_consumption_card_id`
2. `refinement_session_id`
3. `governance_object_id`
4. `authority_source_after`
5. `permission_mode_external`
6. `permission_ledger_state`
7. `pending_permission_requests`
8. `decision_window`
9. `settled_price`
10. `classifier_cost_priced`
11. `writeback_seam_attested`
12. `capability_release_scope`
13. `liability_owner`
14. `threshold_retained_until`
15. `reject_verdict`
16. `verdict_reason`

### 4.2 writeback repricing block 骨架

1. `writeback_repricing_block_id`
2. `authority_gap`
3. `ledger_gap`
4. `window_gap`
5. `pricing_gap`
6. `classifier_gap`
7. `writeback_gap`
8. `liability_gap`
9. `fallback_verdict`

### 4.3 reopen liability ticket 骨架

1. `reopen_liability_id`
2. `capability_release_scope`
3. `liability_owner`
4. `authority_drift_trigger`
5. `threshold_retained_until`
6. `reentry_required_when`
7. `reopen_required_when`
8. `rollback_object`

## 5. 与 `casebooks/62` 的边界

`casebooks/62` 回答的是：

- 为什么治理 refinement execution 明明已经存在，仍会重新退回假 `host consumption card`、假 `writeback seam round-trip` 与假 `reopen liability`

这一章回答的是：

- 当这些假对象已经被辨认出来之后，具体该按什么固定 `refinement order` 把它们压回同一个统一定价控制面

也就是说，`casebooks/62` 负责：

- 识别治理 refinement execution 怎样被 calmer dashboard、UI calmness 与默认继续取代

而这一章负责：

- 把这些替代信号按 authority、ledger、window、pricing、classifier、writeback、liability 与 threshold 的对象顺序拆掉

## 6. 苏格拉底式检查清单

在你准备宣布“治理 refinement execution distortion 已纠偏完成”前，先问自己：

1. 我救回的是同一个治理对象，还是一张更严的宿主消费卡。
2. 我现在消费的是 authority 真相链，还是 mode 与 dashboard 的平静感。
3. 我现在冻结的是 formal `window + settled price + classifier cost`，还是一张 usage 图表。
4. 我现在恢复的是 `writeback seam round-trip`，还是一种“应该已经写回去了”的感觉。
5. 我现在保留的是 future reopen 的正式 threshold，还是一句“以后有问题再看”。

## 7. 一句话总结

真正成熟的治理 refinement execution 纠偏，不是把宿主消费卡写得更严，而是把 `authority-ledger covenant + window-pricing covenant + classifier-writeback custody + capability liability ledger + reopen liability ledger` 继续拉回同一个统一定价控制面。
