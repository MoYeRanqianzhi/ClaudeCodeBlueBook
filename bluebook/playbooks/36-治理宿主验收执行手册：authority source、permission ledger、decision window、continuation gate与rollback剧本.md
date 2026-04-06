# 治理宿主验收执行手册：authority source、permission ledger、decision window、continuation gate与rollback剧本

这一章不再解释治理宿主验收协议该消费哪些字段，而是把 Claude Code 式治理验收压成一张可持续执行的验收手册。

它主要回答五个问题：

1. 为什么安全与省 token 的宿主验收，真正执行的是统一定价控制面，而不是 mode、弹窗与 token 图表。
2. 宿主、CI、评审与交接怎样共享同一张治理验收卡，而不是各自维护一套判断。
3. 应该按什么固定顺序执行治理宿主验收，才能不让过期决定、晚到响应与免费继续重新进场。
4. 哪些 reject reason 一旦出现就必须停止继续、冻结自动化并进入回退。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的审批流”。

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

## 1. 第一性原理

治理宿主验收真正要执行的不是：

- mode 还能切
- 审批弹窗还能弹
- token 面板还能显示

而是：

- 当前 governance key、permission ledger、decision window、continuation gate 与 rollback object 仍在围绕同一个治理对象成立

所以这层 playbook 最先要看的不是表象，而是：

1. 当前判断主体是否仍围绕正式 governance key 工作。
2. 当前权限扩张是否仍留下 typed decision 与 permission ledger。
3. 当前决定是否仍落在同一个 decision window，而不是过期决定继续生效。
4. 当前 continuation 是否仍由统一 gate 裁定，而不是由阈值幻觉裁定。
5. 当前 rollback 是否仍恢复对象边界，而不是只恢复 mode 或页面状态。

## 2. 共享验收卡最小字段

每次治理宿主验收，宿主、CI、评审与交接系统至少应共享：

1. `request_id`
2. `governance_key`
3. `settings_sources`
4. `effective_settings`
5. `applied_settings`
6. `externalized_truth_chain`
7. `typed_decision`
8. `permission_ledger`
9. `pending_permission_requests`
10. `decision_window`
11. `context_usage_snapshot`
12. `continuation_gate`
13. `rollback_object`
14. `idempotency_key`
15. `reject_reason`
16. `consumer_verdict`

四类消费者的分工应固定为：

1. 宿主看当前治理对象是否仍有唯一写点。
2. CI 看协议字段、去重语义与 baseline reset 是否完整。
3. 评审看 typed decision、拒收理由与回退对象是否自洽。
4. 交接看 later 接手者能否围绕同一 governance key 与 externalized truth chain 继续判断。

## 3. 固定执行顺序

### 3.1 先验 governance key

先看：

1. 当前 mode、policy、settings 与状态写回是否仍指向同一个 `sources -> effective -> applied -> externalized` 对象链
2. 是否仍有唯一 writer / choke point
3. 是否仍能明确指出谁有权宣布 allow、deny、ask 或 stop

### 3.2 再验 permission ledger

再看：

1. 当前 capability expansion 是否仍留下 typed decision reason
2. `pending_permission_requests` 是否仍是正式对象
3. headless / async 场景是否仍不会偷偷退回隐形 prompt 路径

### 3.3 再验 decision window

再看：

1. 当前 `request_id`、generation、pending action 与取消语义是否仍属于同一窗口
2. duplicate / orphan response 是否仍被正式处理
3. late response 是否仍不会复活过期决定
4. 宿主是否仍从 externalized object 读取当前阻塞点，而不是靠事件流猜

### 3.4 再验 continuation gate

再看：

1. 当前 `Context Usage`、token budget 与 pending action 是否仍被并排解释
2. continuation 是否仍由 typed decision、gain 判断与同一 externalized truth chain 驱动
3. compact / cache deletion 后 baseline 是否仍会重置

### 3.5 最后验 rollback object

最后才看：

1. 回退是否仍恢复对象，而不是只恢复 mode
2. permission、cache、context 三条基线是否仍一起回到合法状态
3. durable assets 与 transient authority 是否仍被明确区分
4. 交接系统能否明确指出 rollback 后的 re-entry condition

## 4. 直接拒收条件

出现下面情况时，应直接拒收当前治理宿主实现：

1. `mode_only_authority`
2. `missing_permission_ledger`
3. `decision_window_unbound`
4. `context_usage_isolated`
5. `continuation_threshold_only`
6. `rollback_not_object`
7. `duplicate_orphan_silent`
8. `baseline_reset_missing`
9. `externalized_truth_chain_missing`

## 5. 拒收升级与回退顺序

看到 reject reason 之后，更稳的处理顺序是：

1. 先冻结新的 capability expansion，不再允许继续提权或自动化扩张。
2. 先关闭当前 decision window，取消或隔离所有 outstanding request。
3. 先把 automation 降回人工或更窄模式，再恢复 rollback object。
4. 先重建 governance key、permission ledger 与 baseline，再允许重开 continuation。
5. 如果根因是治理制度本身漂移，就回跳 `../guides/58` 做制度纠偏。

## 6. 回退演练集

每轮至少跑下面六个治理宿主验收演练：

1. `permission race`
2. `headless deny path`
3. `duplicate/orphan response`
4. `token pressure continuation`
5. `mode switch after pending request`
6. `compact baseline reset`

## 7. 复盘记录最少字段

每次治理宿主验收失败或回退，至少记录：

1. `governance_object_id`
2. `governance_key`
3. `typed_decision`
4. `decision_window`
5. `pending_action`
6. `continuation_gate`
7. `rollback_object`
8. `reject_reason`
9. `rollback_action`
10. `re_entry_condition`

## 8. 苏格拉底式检查清单

在你准备宣布“治理宿主验收已经稳定运行”前，先问自己：

1. 我暴露的是状态投影，还是权威对象本身。
2. 当前所有决定是否仍围绕同一个 governance key。
3. 当前 permission ledger 记录的是“用户点了允许”，还是“系统为何允许/拒绝”。
4. continuation 是正式 gate，还是默认继续。
5. baseline 下降时，我能否区分合法压缩与异常碎裂。
6. 如果晚到响应、重复响应与并发切 mode 同时发生，这套实现是否仍成立。
7. 当前 rollback 恢复的是对象边界，还是页面状态。
8. 如果把 modal 和 dashboard 藏起来，团队是否仍知道该如何判断。

## 9. 一句话总结

真正成熟的治理宿主验收执行，不是把 mode、弹窗与 token 曲线拼成更复杂的审批页，而是持续证明 governance key、permission ledger、decision window、continuation gate 与 rollback object 仍是同一个治理判断链。
