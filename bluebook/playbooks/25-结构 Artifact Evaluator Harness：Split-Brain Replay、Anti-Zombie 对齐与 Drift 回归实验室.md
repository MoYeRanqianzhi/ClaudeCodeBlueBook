# 结构 Artifact Evaluator Harness：Split-Brain Replay、Anti-Zombie 对齐与 Drift 回归实验室

这一章不再解释结构 rule sample kit 为什么需要，而是把它接成可重放验证、跨消费者对齐与 drift 回归实验室。

它主要回答五个问题：

1. 结构 evaluator harness 真正跑起来时长什么样。
2. 怎样让宿主、CI、评审与交接围绕同一 `structure object` 做同一轮 replay。
3. 怎样把最小样例、失败样例、rewrite 样例接成 split-brain / anti-zombie regression lab。
4. evaluator harness 的最小输入输出该怎样定义，才能证明共享的是同一对象级拒收语义。
5. 怎样用苏格拉底式追问避免把这层写成“结构测试脚本集合”。

## 0. 第一性原理

结构 replay 层真正要验证的，不是：

- gate 会不会返回 `reject`

而是：

- 同一 `structure_object_id` 一旦发生 split-brain 或 stale-writer 风险，宿主、CI、评审与交接会不会在同一回放里重复给出同一拒收语义

所以这组 harness 都遵守同一个原则：

- 先共享 authoritative object，再对齐消费者 verdict

## 1. Harness 输入骨架

```yaml
replay_case:
  replay_case_id: structure-replay-003
  packet_ref: abi://structure-artifact-rule-packet/v0
  artifact_group_ref: artifact://structure/STR-ART-003
  replay_inputs:
    host_card_ref: artifact://structure/STR-ART-003/host
    ci_attachment_ref: artifact://structure/STR-ART-003/ci
    review_card_ref: artifact://structure/STR-ART-003/review
    handoff_package_ref: artifact://structure/STR-ART-003/handoff
  replay_modes:
    - host
    - ci
    - review
    - handoff
  alignment_key:
    - structure_object_id
    - authoritative_path
    - rollback_object
```

## 2. Cross-Consumer Alignment 最小样例

```yaml
alignment_assertion:
  assertion_id: structure-shared-authority
  expected_shared_reason:
    reject_reason: structure_split_brain
  consumers:
    host: reject
    ci: reject
    review: reject
    handoff: reject
  proof_fields:
    - structure_object_id
    - authoritative_path
```

## 3. Drift Regression Cases

### 3.1 目录图夺权回归

```yaml
drift_regression:
  case_id: structure-regression-directory-diagram
  mutation:
    host_card.authoritative_path: null
    host_card.directory_diagram: primary
  expected:
    host: warn
    ci: pass
    review: review_required
    handoff: pass
    shared_warning: authority_substituted_by_diagram
```

### 3.2 恢复报喜回归

```yaml
drift_regression:
  case_id: structure-regression-success-rate
  mutation:
    ci_attachment.recovery_asset_ledger: null
    ci_attachment.recovery_result: pass
  expected:
    host: pass
    ci: reject
    review: review_required
    handoff: pass
    shared_reason: missing_recovery_or_anti_zombie_evidence
```

### 3.3 作者说明交接回归

```yaml
drift_regression:
  case_id: structure-regression-oral-handoff
  mutation:
    handoff_package.rollback_object: null
    handoff_package.danger_paths: []
  expected:
    host: pass
    ci: pass
    review: review_required
    handoff: reject
    shared_reason: oral_handoff_without_structured_object
```

## 4. Anti-Zombie Replay 最小样例

```yaml
anti_zombie_replay:
  case_id: structure-anti-zombie-replay
  before:
    ci_attachment.anti_zombie_evidence: generation_guard_only
    ci_attachment.dropped_stale_writers: []
  expected_before:
    ci: reject
    reason: anti_zombie_without_stale_drop_evidence
  after:
    ci_attachment.dropped_stale_writers:
      - stale_bridge_writer@gen-16
  expected_after:
    ci: pass
    review: pass
```

## 5. Evaluator Harness Interface

```yaml
harness_run:
  replay_case_ref: replay://structure/structure-replay-003
  mode: single_consumer|cross_consumer|drift_regression|rewrite_replay|anti_zombie_replay
  outputs:
    consumer_decisions:
      host: pass|warn|review_required|reject
      ci: pass|warn|review_required|reject
      review: pass|warn|review_required|reject
      handoff: pass|warn|review_required|reject
    alignment_result: aligned|split_brain
    matched_rules: [rule_id]
    reject_reasons: [string]
    rewrite_targets: [string]
    replay_verdict: pass|fail
```

## 6. 三个最容易写坏的地方

1. 把 replay 写成各消费者各自的通过率统计，而不是 authoritative path 对齐。
2. 把 regression case 写成结构展示样本，而不是 split-brain / anti-zombie 断裂样本。
3. 把 anti-zombie replay 写成规则存在性检查，而不是 stale-writer 清退证明。

## 7. 苏格拉底式追问

在你准备把这套 harness 当成“结构已可验证”前，先问自己：

1. 我重放的是同一 structure object 断裂，还是四个局部展示问题。
2. 如果删掉目录图、恢复成功率和作者说明，这套 harness 还能命中吗。
3. 宿主、CI、review 与 handoff 是否真的共享同一 split-brain / anti-zombie 拒收语义。
4. 我是在证明源码先进性可重放，还是只是在重放几条结构规则。
