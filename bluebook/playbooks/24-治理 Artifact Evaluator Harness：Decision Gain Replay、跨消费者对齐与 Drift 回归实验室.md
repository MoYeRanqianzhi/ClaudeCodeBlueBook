# 治理 Artifact Evaluator Harness：Decision Gain Replay、跨消费者对齐与 Drift 回归实验室

这一章不再解释治理 rule sample kit 为什么需要，而是把它接成可重放验证、跨消费者对齐与 drift 回归实验室。

它主要回答五个问题：

1. 治理 evaluator harness 真正跑起来时长什么样。
2. 怎样让宿主、CI、评审与交接围绕同一 `decision gain` 做同一轮 replay。
3. 怎样把最小样例、失败样例、rewrite 样例接成 drift regression lab。
4. evaluator harness 的最小输入输出该怎样定义，才能证明共享的是同一 rollback / reject 语义。
5. 怎样用苏格拉底式追问避免把这层写成“治理测试脚本集合”。

## 0. 第一性原理

治理 replay 层真正要验证的，不是：

- gate 会不会返回 `upgrade_required`

而是：

- 同一 `decision_window` 一旦失去决策增益，宿主、CI、评审与交接会不会在同一回放里重复给出同一拒收或升级语义

所以这组 harness 都遵守同一个原则：

- 先共享 decision gain，再对齐消费者 verdict

## 1. Harness 输入骨架

```yaml
replay_case:
  replay_case_id: governance-replay-002
  packet_ref: abi://governance-artifact-rule-packet/v0
  artifact_group_ref: artifact://governance/GOV-ART-002
  replay_inputs:
    host_card_ref: artifact://governance/GOV-ART-002/host
    ci_attachment_ref: artifact://governance/GOV-ART-002/ci
    review_card_ref: artifact://governance/GOV-ART-002/review
    handoff_package_ref: artifact://governance/GOV-ART-002/handoff
  replay_modes:
    - host
    - ci
    - review
    - handoff
  alignment_key:
    - governance_object_id
    - decision_window
    - rollback_object
```

## 2. Cross-Consumer Alignment 最小样例

```yaml
alignment_assertion:
  assertion_id: governance-shared-decision-gain
  expected_shared_reason:
    reject_reason: continued_spend_without_decision_gain
  consumers:
    host: upgrade_required
    ci: upgrade_required
    review: review_required
    handoff: reject
  proof_fields:
    - decision_window
    - rollback_object
```

这里允许消费者动作不同，但 reject semantics 必须同源。

## 3. Drift Regression Cases

### 3.1 状态色夺权回归

```yaml
drift_regression:
  case_id: governance-regression-status-color
  mutation:
    host_card.status_color: green_primary
    host_card.decision_window: null
  expected:
    host: warn
    ci: pass
    review: review_required
    handoff: pass
    shared_warning: dashboard_substituted_decision_window
```

### 3.2 计数夺权回归

```yaml
drift_regression:
  case_id: governance-regression-metrics-only
  mutation:
    ci_attachment.control_arbitration_truth: null
    ci_attachment.metric_panel: token_latency_count_only
  expected:
    host: pass
    ci: reject
    review: review_required
    handoff: pass
    shared_reason: missing_arbitration_truth
```

### 3.3 状态摘要交接回归

```yaml
drift_regression:
  case_id: governance-regression-summary-handoff
  mutation:
    handoff_package.rollback_object: null
    handoff_package.next_action: null
  expected:
    host: pass
    ci: pass
    review: review_required
    handoff: reject
    shared_reason: no_rollback_or_next_action
```

## 4. Rewrite Replay 最小样例

```yaml
rewrite_replay:
  case_id: governance-rewrite-upgrade-rule
  before:
    ci_attachment.object_upgrade_rule: null
  rewrite_hint:
    - 补 object_upgrade_rule
    - 明确 no_decision_gain_no_more_spend
    - 保留 rollback_object
  after:
    ci_attachment.object_upgrade_rule: if no_gain_after_2_waits -> compact_or_task
  expected_after:
    ci: pass
    review: pass
```

## 5. Evaluator Harness Interface

```yaml
harness_run:
  replay_case_ref: replay://governance/governance-replay-002
  mode: single_consumer|cross_consumer|drift_regression|rewrite_replay
  outputs:
    consumer_decisions:
      host: pass|warn|review_required|reject|upgrade_required
      ci: pass|warn|review_required|reject|upgrade_required
      review: pass|warn|review_required|reject|upgrade_required
      handoff: pass|warn|review_required|reject|upgrade_required
    alignment_result: aligned|split_brain
    matched_rules: [rule_id]
    reject_reasons: [string]
    rewrite_targets: [string]
    replay_verdict: pass|fail
```

## 6. 三个最容易写坏的地方

1. 把 replay 写成各消费者各自的通过率统计，而不是 decision gain 对齐。
2. 把 regression case 写成成本波动集合，而不是 rollback / reject 断裂样本。
3. 把 rewrite replay 写成“更省一点 token”，而不是恢复统一拒收语义。

## 7. 苏格拉底式追问

在你准备把这套 harness 当成“治理已可验证”前，先问自己：

1. 我重放的是同一 decision gain 消失，还是四个局部 UI 症状。
2. 如果删掉状态色、计数和 verdict，这套 harness 还能命中吗。
3. 宿主、CI、review 与 handoff 是否真的共享同一 rollback / reject 语义。
4. 我是在证明安全与省 token 一体化，还是只是在并排重放两套规则。
