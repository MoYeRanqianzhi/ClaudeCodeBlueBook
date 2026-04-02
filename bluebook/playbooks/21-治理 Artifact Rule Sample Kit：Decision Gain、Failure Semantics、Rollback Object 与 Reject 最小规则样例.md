# 治理 Artifact Rule Sample Kit：Decision Gain、Failure Semantics、Rollback Object 与 Reject 最小规则样例

这一章不再解释治理 rule ABI 为什么需要，而是直接给出最小规则样例、失败样例、rewrite 样例与 evaluator 接口。

它主要回答五个问题：

1. 治理 rule packet 真正跑起来时长什么样。
2. `hard fail / lint warn / reviewer gate / handoff reject / object-upgrade gate` 怎样共享同一 `decision gain`。
3. 怎样避免样例重新退回状态色、计数、verdict 与状态摘要。
4. evaluator 最小接口该怎样描述，才能让不同消费者复用同一拒收语义。
5. 怎样用苏格拉底式追问避免把样例层退回“治理规则清单”。

## 0. 第一性原理

治理规则样例层真正要展示的，不是：

- 五条会跑的治理 gate

而是：

- 同一份 `decision gain + rollback object + failure semantics` 被五种动作样式反复验证

所以这组样例都遵守同一个原则：

- 先共享拒收语义，再分化消费者动作

## 1. Shared Packet Header 最小样例

```yaml
packet_header:
  rule_packet_id: governance-artifact-rule-packet
  artifact_line_scope: artifact_line_id
  governance_object_type: governance_object
  governance_object_id_field: governance_object_id
  shared_contract_fields:
    - governance_object_id
    - authority_source
    - decision_window
    - winner_source
    - control_arbitration_truth
    - failure_semantics
    - rollback_object
    - object_upgrade_rule
    - next_action
  consumer_scopes:
    - host_card
    - ci_attachment
    - review_card
    - handoff_package
  packet_version: v0
```

## 2. Hard Fail 最小样例

```yaml
rule:
  rule_id: G-HF-001
  level: hard_fail
  applies_to: cross_artifact
  reads:
    - governance_object_id
    - decision_window
  predicate: all_equal
  reject_reason: governance_split_brain
  evidence_emit:
    - governance_object_id
    - decision_window
  rewrite_target: artifact_group
```

```yaml
test_fail:
  host_card.decision_window: human_feedback_can_change_verdict
  handoff_package.decision_window: status_wait_only
  expected:
    decision: reject
    matched_rule: G-HF-001
    reject_reason: governance_split_brain
```

## 3. Lint Warn 最小样例

```yaml
rule:
  rule_id: G-LW-001
  level: lint_warn
  applies_to: host_card
  reads:
    - current_state
    - decision_window
    - status_color
  predicate: forbid_only(status_color_primary_truth)
  reject_reason: dashboard_substituted_decision_window
  evidence_emit:
    - current_state
    - decision_window
  rewrite_target: host_card
```

```yaml
test_warn:
  host_card:
    current_state: requires_action
    decision_window: human_feedback_can_change_verdict
    status_color: green_primary
  expected:
    decision: warn
    matched_rule: G-LW-001
```

## 4. Reviewer Gate 最小样例

```yaml
rule:
  rule_id: G-RG-001
  level: reviewer_gate
  applies_to: review_card
  reads:
    - decision_window
    - failure_semantics
    - rollback_object
  predicate: requires_explanation_on_verdict
  reject_reason: review_without_decision_chain
  evidence_emit:
    - failure_semantics
    - rollback_object
  rewrite_target: review_card
```

```yaml
test_gate:
  review_card:
    review_judgement: allow
    decision_window: null
  expected:
    decision: review_required
    matched_rule: G-RG-001
```

## 5. Handoff Reject 最小样例

```yaml
rule:
  rule_id: G-HR-001
  level: handoff_reject
  applies_to: handoff_package
  reads:
    - rollback_object
    - next_action
  predicate: continuation_ready
  reject_reason: no_rollback_or_next_action
  evidence_emit:
    - rollback_object
    - next_action
  rewrite_target: handoff_package
```

```yaml
test_reject:
  handoff_package:
    current_state: requires_action
    next_action: null
    rollback_object: null
  expected:
    decision: reject
    matched_rule: G-HR-001
```

## 6. Object-Upgrade Gate 最小样例

```yaml
rule:
  rule_id: G-OG-001
  level: object_upgrade_gate
  applies_to: ci_attachment
  reads:
    - decision_window
    - object_upgrade_rule
    - context_usage_breakdown
  predicate: no_decision_gain_no_more_spend
  reject_reason: continued_spend_without_decision_gain
  rewrite_target: ci_attachment
  rewrite_hint:
    - 停止继续等待
    - 升级到 compact_or_task
    - 保留 rollback_object
```

## 7. Evaluator Interface 最小样例

```yaml
evaluator_run:
  packet_ref: abi://governance-artifact-rule-packet/v0
  artifact_group_ref: artifact://governance/GOV-ART-002
  mode: ci|review|handoff
  outputs:
    decision: pass|warn|review_required|reject|upgrade_required
    matched_rules: [rule_id]
    reject_reasons: [string]
    rewrite_targets: [string]
    evidence_refs: [string]
```

接口目标不是：

- 替代治理判断

而是：

- 让不同消费者围绕同一 `decision gain` 输出同一拒收语义

## 8. 三个最容易写坏的地方

1. 把 `hard fail` 写成字段齐全检查，而不是 decision window 一致性检查。
2. 把 `lint warn` 写成 UI 配色建议，而不是状态色替代判断链的告警。
3. 把 `object-upgrade gate` 写成成本优化建议，而不是“没有决策增益就不该继续”的正式判定。

## 9. 苏格拉底式追问

在你准备照抄这组样例前，先问自己：

1. 我抄到的是同一 `decision gain` 的拒收语义，还是只抄到几条治理规则。
2. 如果删掉状态色、计数和 verdict，这组样例还会命中吗。
3. evaluator 输出的 `reject_reason` 是否真的能被宿主、CI、review 与 handoff 共享。
4. 我是在证明安全与省 token 一体化，还是在把两套规则并排摆出来。
