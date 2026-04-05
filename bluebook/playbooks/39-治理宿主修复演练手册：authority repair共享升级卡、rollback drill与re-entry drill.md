# 治理宿主修复演练手册：authority repair共享升级卡、rollback drill与re-entry drill

这一章不再解释治理宿主修复协议该消费哪些字段，而是把 Claude Code 式治理修复压成一张可长期重放、拒收、回滚与重入验证的演练手册。

它主要回答五个问题：

1. 为什么安全设计与省 token 设计本质上共享同一个治理对象，修复演练也必须继续围绕同一对象发生。
2. 宿主、CI、评审与交接怎样共享同一张治理修复升级卡，而不是各自维护 mode、审批与 token 图表的局部真相。
3. 应该按什么固定顺序执行 authority repair、ledger rebuild、decision window reset、continuation repricing 与 rollback/re-entry drill。
4. 哪些停止条件一旦出现就必须冻结当前治理修复，不允许 later 团队站在假窗口和免费继续上工作。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的治理审批单”。

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
- `claude-code-source-code/src/utils/QueryGuard.ts:29-121`
- `claude-code-source-code/src/query.ts:1308-1518`
- `claude-code-source-code/src/services/compact/autoCompact.ts:72-182`

## 1. 第一性原理

治理宿主修复演练真正要证明的不是：

- mode 现在看起来更安全了
- token 面板现在看起来更省了

而是：

- action、capability 与 time 仍被同一个治理对象统一定价

所以这层 playbook 最先要看的不是：

- 审批页面是不是更复杂了

而是：

1. 当前 authority 是否仍有唯一来源与唯一写点。
2. 当前 permission ledger 是否仍在解释“为什么允许/拒绝”，而不是只记录“点了什么按钮”。
3. 当前 decision window 是否仍能阻止晚到响应、重复响应与过期决定复活。
4. 当前 continuation 是否仍由正式 gate 定价，而不是被阈值、情绪或默认值放行。
5. compact 是否仍是重写上下文对象边界的治理动作，而不是一段附属摘要流程。

## 2. 共享升级卡最小字段

每次治理宿主修复演练，宿主、CI、评审与交接系统至少应共享：

1. `governance_object_id`
2. `authority_source`
3. `typed_decision`
4. `permission_ledger`
5. `decision_window`
6. `context_usage_snapshot`
7. `continuation_gate`
8. `completion_event`
9. `rollback_object`
10. `re_entry_condition`
11. `token_budget_result`
12. `escalation_level`
13. `reject_reason`

四类消费者的分工应固定为：

1. 宿主看 authority source 与 writer chokepoint 是否仍唯一。
2. CI 看 ledger、window、continuation 与 baseline reset 是否完整。
3. 评审看 typed decision、升级语义与 rollback object 是否自洽。
4. 交接看 later 团队能否围绕同一 authority source 与 `re_entry_condition` 继续判断。

## 3. 固定演练顺序

### 3.1 先验 authority repair

先看：

1. 当前 authority source 是否从漂移状态回到正式来源。
2. repair before/after 差异是否明确指出哪个治理边界被修回来了。
3. 是否仍不存在 mode 投影冒充权威对象的旁路。

### 3.2 再验 ledger rebuild

再看：

1. `typed_decision` 是否仍留下 formal reason，而不是口头解释。
2. `permission_ledger` 是否仍能覆盖 pending request、duplicate response 与 orphan state。
3. headless、async 与 later 补写场景是否仍不会偷偷退回隐形 prompt 路径。

### 3.3 再验 decision window reset

再看：

1. 当前 `decision_window`、`pending_action` 与 request generation 是否仍属于同一窗口。
2. late response 是否仍不会复活过期决定。
3. compact、取消与恢复之后，window 是否真的重新建立，而不是只刷新了视图。

### 3.4 再验 continuation repricing

再看：

1. `continuation_gate` 是否仍与 `token_budget_result` 一起解释继续成本。
2. 当前 continuation 是否仍围绕 gain 判断，而不是默认继续。
3. baseline 变化是否仍触发重新定价，而不是把省 token 设计降格成阈值技巧。

### 3.5 最后跑 rollback 与 re-entry drill

最后才看：

1. rollback 是否仍恢复治理对象，而不是只切回某个 mode。
2. `re_entry_condition` 是否仍要求 authority、ledger 与 window 一起恢复。
3. later 团队是否能在不依赖作者说明的前提下重新进入同一治理判断链。

## 4. 直接停止条件

出现下面情况时，应直接停止当前治理修复演练并拒收：

1. `mode_only_authority`
2. `ledger_missing_or_stale`
3. `window_not_authoritative`
4. `context_usage_not_shared`
5. `continuation_gate_defaulted`
6. `baseline_reset_skipped`
7. `rollback_object_missing`
8. `duplicate_or_orphan_response`

## 5. 最小演练集

每轮至少跑下面六个治理宿主修复演练：

1. `authority_repair_rebind`
2. `permission_race_replay`
3. `headless_deny_path`
4. `decision_window_reset`
5. `token_pressure_continuation`
6. `rollback_reentry_after_compact`

## 6. 复盘记录最少字段

每次治理宿主修复演练失败或回退，至少记录：

1. `governance_object_id`
2. `authority_source`
3. `typed_decision`
4. `decision_window`
5. `context_usage_snapshot`
6. `continuation_gate`
7. `token_budget_result`
8. `rollback_object`
9. `re_entry_condition`
10. `reject_reason`

## 7. 苏格拉底式检查清单

在你准备宣布“治理宿主修复演练已经稳定运行”前，先问自己：

1. 我现在修的是同一个治理对象，还是三个彼此脱钩的页面问题。
2. 安全设计与省 token 设计是否仍由同一个定价面裁定。
3. 当前 permission ledger 记录的是 formal decision，还是用户点击历史。
4. 当前 decision window 是否真的能抵御晚到响应与重复响应。
5. continuation 被放行时，我能说清它为什么值得继续，还是只知道它还能继续。
6. compact 发生时，我是在重写治理对象边界，还是只是在缩短文本。
7. later 团队如果只看升级卡，能否重建同一治理判断。
8. 如果隐藏 modal、dashboard 与 token 曲线，这套修复演练是否仍成立。

## 8. 一句话总结

真正成熟的治理宿主修复演练，不是把安全与省 token 的补救写成更复杂的审批页，而是持续证明 authority、ledger、window、continuation 与 rollback 仍是同一个治理对象的不同面。
