# Prompt Artifact Evaluator Harness：Continuation Replay、跨消费者对齐与 Drift 回归实验室

这一章不再解释 Prompt rule sample kit 为什么需要，而是把它接成可重放验证、跨消费者对齐与 drift 回归实验室。

它主要回答五个问题：

1. Prompt evaluator harness 真正跑起来时长什么样。
2. 怎样让宿主、CI、评审与交接围绕同一 `compiled request continuity` 做同一轮 replay。
3. 怎样把最小样例、失败样例、rewrite 样例接成 drift regression lab。
4. evaluator harness 的最小输入输出该怎样定义，才能证明共享的是同一 continuation 语义。
5. 怎样用苏格拉底式追问避免把这层写成“Prompt 测试脚本集合”。

## 0. 第一性原理

Prompt replay 层真正要验证的，不是：

- 脚本会不会返回 `reject`

而是：

- 同一 `prompt_object_id` 一旦断裂，宿主、CI、评审与交接会不会在同一回放里重复说出同一拒收语义

所以这组 harness 都遵守同一个原则：

- 先共享 continuation，再对齐消费者 verdict

## 1. Harness 输入骨架

```yaml
replay_case:
  replay_case_id: prompt-replay-001
  packet_ref: abi://prompt-artifact-rule-packet/v0
  artifact_group_ref: artifact://prompt/PRM-ART-001
  replay_inputs:
    host_card_ref: artifact://prompt/PRM-ART-001/host
    ci_attachment_ref: artifact://prompt/PRM-ART-001/ci
    review_card_ref: artifact://prompt/PRM-ART-001/review
    handoff_package_ref: artifact://prompt/PRM-ART-001/handoff
  replay_modes:
    - host
    - ci
    - review
    - handoff
  alignment_key:
    - prompt_object_id
    - compiled_request_diff_ref
    - lawful_forgetting_abi_ref
```

## 2. Cross-Consumer Alignment 最小样例

```yaml
alignment_assertion:
  assertion_id: prompt-shared-continuation
  expected_shared_reason:
    reject_reason: shared_object_mismatch
  consumers:
    host: reject
    ci: reject
    review: reject
    handoff: reject
  proof_fields:
    - prompt_object_id
    - compiled_request_diff_ref
```

## 3. Drift Regression Cases

### 3.1 原文崇拜回归

```yaml
drift_regression:
  case_id: prompt-regression-raw-prompt
  mutation:
    host_card.raw_prompt_body: primary
  expected:
    host: warn
    ci: pass
    review: review_required
    handoff: pass
    shared_warning: host_card_reverted_to_raw_prompt
```

### 3.2 绿灯崇拜回归

```yaml
drift_regression:
  case_id: prompt-regression-green-light
  mutation:
    ci_attachment.compiled_request_diff_ref: null
    ci_attachment.hard_fail_result: none
  expected:
    host: pass
    ci: reject
    review: review_required
    handoff: pass
    shared_reason: missing_compiled_request_evidence
```

### 3.3 摘要崇拜回归

```yaml
drift_regression:
  case_id: prompt-regression-summary-only-handoff
  mutation:
    handoff_package.current_object: null
    handoff_package.next_step_guard: null
  expected:
    host: pass
    ci: pass
    review: review_required
    handoff: reject
    shared_reason: summary_only_handoff
```

## 4. Rewrite Replay 最小样例

```yaml
rewrite_replay:
  case_id: prompt-rewrite-ci-evidence
  before:
    ci_attachment.compiled_request_diff_ref: null
    ci_attachment.stable_bytes_ledger_ref: null
  rewrite_hint:
    - 补 compiled_request_diff_ref
    - 补 stable_bytes_ledger_ref
  after:
    ci_attachment.compiled_request_diff_ref: diff://prompt/turn-204
    ci_attachment.stable_bytes_ledger_ref: ledger://prompt/stable-bytes/turn-204
  expected_after:
    ci: pass
    review: pass
```

## 5. Evaluator Harness Interface

```yaml
harness_run:
  replay_case_ref: replay://prompt/prompt-replay-001
  mode: single_consumer|cross_consumer|drift_regression|rewrite_replay
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

1. 把 replay 写成四个消费者各自单跑，而不是 cross-consumer alignment。
2. 把 regression case 写成字段缺失集合，而不是 continuation 断裂样本。
3. 把 rewrite replay 写成文案修补，而不是 shared object 恢复验证。

## 7. 苏格拉底式追问

在你准备把这套 harness 当成“Prompt 已可验证”前，先问自己：

1. 我重放的是同一 continuation 断裂，还是四个局部错误。
2. 如果删掉原文 prompt 和摘要，这套 harness 还能命中吗。
3. CI、review 与 handoff 是否真的共享同一 reject reason。
4. 我是在证明 Prompt 魔力可重放，还是只是在证明规则文件可执行。
