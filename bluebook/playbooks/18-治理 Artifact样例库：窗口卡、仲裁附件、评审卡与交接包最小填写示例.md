# 治理 Artifact样例库：窗口卡、仲裁附件、评审卡与交接包最小填写示例

这一章不再解释治理 artifact contract 为什么需要，而是直接给出四类工件的最小填写样例。

它主要回答四个问题：

1. 治理 artifact contract 真正填出来时长什么样。
2. 宿主卡、CI附件、评审卡与交接包怎样共享同一 governance object header。
3. 怎样避免样例重新退回绿色仪表盘、审批统计、阈值图与状态摘要。
4. 怎样让后来者直接照着填，而不是继续从空白表格起步。

## 0. 第一性原理

治理样例层真正要展示的，不是：

- 四张都在谈治理的图表

而是：

- 同一份 governance object contract 被四类工件按不同粒度投影出来的最小形式

所以这组样例都遵守同一个原则：

- 先共享判断链，再分化角色

## 1. Shared Header 最小样例

```text
artifact_header:
- artifact_line_id: GOV-ART-002
- governance_object_type: approval_cycle
- governance_object_id: approval:tool-use-88
- current_state: requires_action
- authority_source: permission_runtime@turn-204
- observed_window: current_turn_until_user_reply
- decision_window: human_feedback_can_change_verdict
- control_arbitration_truth: local_ui_wins_current_race
- failure_semantics: human_fallback
- rollback_object: approval:tool-use-88
- object_upgrade_rule: if no_gain_after_2_waits -> compact_or_task
- next_action: wait_for_user_feedback
```

这组字段是四类工件都要继承的最小前缀。

## 2. 宿主卡最小填写示例

```text
host_card:
- artifact_line_id: GOV-ART-002
- governance_object_id: approval:tool-use-88
- current_state: requires_action
- decision_window: human_feedback_can_change_verdict
- blocked_state: waiting_user_approval
- pending_action: approve_or_reject_edit
- rollback_object: approval:tool-use-88
- next_action: wait_for_user_feedback
```

宿主卡的目标不是：

- 显示绿色或红色

而是：

- 让当前对象、当前窗口与当前回退边界在前台可见

## 3. CI 附件最小填写示例

```text
ci_attachment:
- artifact_line_id: GOV-ART-002
- control_arbitration_truth: local_ui_wins_current_race
- winner_source: local_ui
- context_usage_breakdown: message=41%, tool=37%, memory=22%
- failure_semantics: human_fallback
- object_upgrade_rule: if no_gain_after_2_waits -> compact_or_task
- upgrade_gate_result: not_triggered
- hard_fail_result: none
```

CI 附件的目标不是：

- 宣布通过

而是：

- 解释为什么当前治理对象仍然值得继续等待、升级或回退

## 4. 评审卡最小填写示例

```text
review_card:
- artifact_line_id: GOV-ART-002
- authority_source: permission_runtime@turn-204
- decision_window: human_feedback_can_change_verdict
- winner_source: local_ui
- failure_semantics: human_fallback
- rollback_object: approval:tool-use-88
- window_judgement: 当前仍有决策增益，不应默认继续消耗 token
- rollback_judgement: 若超时，回退到 approval object 而不是继续烧长回合
```

评审卡的目标不是：

- 统计 ask 次数

而是：

- 沿 shared header 对当前 governance object 给出 judgement

## 5. 交接包最小填写示例

```text
handoff_package:
- artifact_line_id: GOV-ART-002
- governance_object_id: approval:tool-use-88
- current_state: requires_action
- decision_window: human_feedback_can_change_verdict
- rollback_object: approval:tool-use-88
- next_action: wait_for_user_feedback
- retained_assets: approval_trace, permission_context, rollback_pointer
- handoff_notes: 后来者无需读完整审批历史，只需沿当前 window 与 rollback object 继续判断
```

交接包的目标不是：

- 解释“现在比较严/比较贵”

而是：

- 交出当前对象、当前窗口与下一步动作

## 6. 三个最容易抄坏的地方

1. 把宿主卡退回 allow/deny 结果，而不是 decision window 的当前投影。
2. 把 CI 附件退回 token / latency 阈值，而不是 arbitration truth + failure semantics。
3. 把交接包退回“现在卡住了”的状态摘要，而不是 rollback object + next_action。

## 7. 苏格拉底式追问

在你准备照抄这组样例前，先问自己：

1. 我抄到的是 shared header，还是只抄到一种治理展示样式。
2. 这四类工件是否都仍然围绕同一个 governance object。
3. 如果删掉颜色和统计，后来者还能否继续。
4. 我是在压缩治理判断链，还是在删掉治理判断链本身。
