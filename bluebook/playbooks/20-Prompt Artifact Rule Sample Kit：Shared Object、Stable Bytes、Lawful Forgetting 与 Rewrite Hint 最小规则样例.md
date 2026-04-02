# Prompt Artifact Rule Sample Kit：Shared Object、Stable Bytes、Lawful Forgetting 与 Rewrite Hint 最小规则样例

这一章不再解释 Prompt rule ABI 为什么需要，而是直接给出最小规则样例、失败样例、rewrite 样例与 evaluator 接口。

它主要回答五个问题：

1. Prompt rule packet 真正跑起来时长什么样。
2. `hard fail / lint warn / reviewer gate / handoff reject / rewrite hint` 怎样共享同一 `compiled request object`。
3. 怎样避免样例重新退回原文 prompt、CI 绿灯、评审总结与摘要交接。
4. evaluator 最小接口该怎样描述，才能让不同消费者复用同一拒收语义。
5. 怎样用苏格拉底式追问避免把样例层退回“配置文件集合”。

## 0. 第一性原理

Prompt 规则样例层真正要展示的，不是：

- 五条会跑的规则

而是：

- 同一份 `compiled request continuity` 被五种动作样式反复验证

所以这组样例都遵守同一个原则：

- 先共享拒收语义，再分化消费者动作

## 1. Shared Packet Header 最小样例

```yaml
packet_header:
  rule_packet_id: prompt-artifact-rule-packet
  artifact_line_scope: artifact_line_id
  prompt_object_type: compiled_request
  prompt_object_id_field: prompt_object_id
  shared_contract_fields:
    - prompt_object_id
    - authority_source
    - assembly_path
    - compiled_request_diff_ref
    - stable_bytes_ledger_ref
    - lawful_forgetting_abi_ref
    - current_object
    - next_step_guard
  consumer_scopes:
    - host_card
    - ci_attachment
    - review_card
    - handoff_package
  packet_version: v0
```

这组字段是五类规则都要继承的最小前缀。

## 2. Hard Fail 最小样例

```yaml
rule:
  rule_id: P-HF-001
  level: hard_fail
  applies_to: cross_artifact
  reads:
    - artifact_line_id
    - prompt_object_id
  predicate: all_equal
  reject_reason: shared_object_mismatch
  evidence_emit:
    - prompt_object_id
    - artifact_line_id
  rewrite_target: artifact_group
```

```yaml
test_fail:
  host_card.prompt_object_id: session:turn-204
  ci_attachment.prompt_object_id: session:turn-205
  expected:
    decision: reject
    matched_rule: P-HF-001
    reject_reason: shared_object_mismatch
```

## 3. Lint Warn 最小样例

```yaml
rule:
  rule_id: P-LW-001
  level: lint_warn
  applies_to: host_card
  reads:
    - current_object
    - authority_source
    - raw_prompt_body
  predicate: forbid_only(raw_prompt_primary_body)
  reject_reason: host_card_reverted_to_raw_prompt
  evidence_emit:
    - current_object
    - authority_source
  rewrite_target: host_card
```

```yaml
test_warn:
  host_card:
    current_object: session:turn-204
    authority_source: rendered_prompt@turn-204
    raw_prompt_body: large_primary_block
  expected:
    decision: warn
    matched_rule: P-LW-001
    rewrite_target: host_card
```

## 4. Reviewer Gate 最小样例

```yaml
rule:
  rule_id: P-RG-001
  level: reviewer_gate
  applies_to: review_card
  reads:
    - authority_source
    - assembly_path
    - compiled_request_diff_ref
    - stable_bytes_ledger_ref
  predicate: requires_explanation_on_boundary_change
  reject_reason: review_without_object_anchor
  evidence_emit:
    - compiled_request_diff_ref
    - stable_bytes_ledger_ref
  rewrite_target: review_card
```

```yaml
test_gate:
  review_card:
    authority_source: null
    review_judgement: pass
  expected:
    decision: review_required
    matched_rule: P-RG-001
    reject_reason: review_without_object_anchor
```

## 5. Handoff Reject 最小样例

```yaml
rule:
  rule_id: P-HR-001
  level: handoff_reject
  applies_to: handoff_package
  reads:
    - lawful_forgetting_abi_ref
    - current_object
    - next_step_guard
  predicate: continuation_ready
  reject_reason: summary_only_handoff
  evidence_emit:
    - current_object
    - next_step_guard
  rewrite_target: handoff_package
```

```yaml
test_reject:
  handoff_package:
    summary: short_summary_only
    current_object: null
    next_step_guard: null
  expected:
    decision: reject
    matched_rule: P-HR-001
    reject_reason: summary_only_handoff
```

## 6. Rewrite Hint 最小样例

```yaml
rule:
  rule_id: P-RW-001
  level: rewrite_hint
  applies_to: ci_attachment
  reads:
    - compiled_request_diff_ref
    - stable_bytes_ledger_ref
  predicate: required
  reject_reason: missing_compiled_request_evidence
  rewrite_target: ci_attachment
  rewrite_hint:
    - 补 compiled_request_diff_ref
    - 补 stable_bytes_ledger_ref
    - 用 drift explanation 替代单纯绿灯
```

## 7. Evaluator Interface 最小样例

```yaml
evaluator_run:
  packet_ref: abi://prompt-artifact-rule-packet/v0
  artifact_group_ref: artifact://prompt/PRM-ART-001
  mode: ci|review|handoff
  outputs:
    decision: pass|warn|review_required|reject
    matched_rules: [rule_id]
    reject_reasons: [string]
    rewrite_targets: [string]
    evidence_refs: [string]
```

接口目标不是：

- 替代 reviewer

而是：

- 让 reviewer、CI 与 handoff 共享同一条拒收语义

## 8. 三个最容易写坏的地方

1. 把 `hard fail` 写成字段齐全检查，而不是 shared object continuity 检查。
2. 把 `lint warn` 写成文案风格告警，而不是原文崇拜告警。
3. 把 `handoff reject` 写成摘要质量建议，而不是 continuation readiness 拒收。

## 9. 苏格拉底式追问

在你准备照抄这组样例前，先问自己：

1. 我抄到的是同一 `compiled request object` 的拒收语义，还是只抄到几条规则名字。
2. 如果删掉原文 prompt 和摘要，这组样例还会命中吗。
3. evaluator 输出的 `reject_reason` 是否真的能被 reviewer、CI、handoff 共享。
4. 我是在证明 Prompt 魔力可验证，还是在给 Prompt 魔力写配置外壳。
