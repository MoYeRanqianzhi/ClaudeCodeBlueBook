# 结构 Artifact Rule Sample Kit：Authoritative Path、Recovery Asset、Anti-Zombie 与 Reject 最小规则样例

这一章不再解释结构 rule ABI 为什么需要，而是直接给出最小规则样例、失败样例、rewrite 样例与 evaluator 接口。

它主要回答五个问题：

1. 结构 rule packet 真正跑起来时长什么样。
2. `hard fail / lint warn / reviewer gate / handoff reject / anti-zombie gate` 怎样共享同一 `structure object` 拒收语义。
3. 怎样避免样例重新退回目录图、恢复成功率、规则说明与作者讲解。
4. evaluator 最小接口该怎样描述，才能让不同消费者复用同一拒收语义。
5. 怎样用苏格拉底式追问避免把样例层退回“结构规则清单”。

## 0. 第一性原理

结构规则样例层真正要展示的，不是：

- 五条会跑的结构 gate

而是：

- 同一份 `authoritative path + recovery asset + anti-zombie + rollback object` 被五种动作样式反复验证

所以这组样例都遵守同一个原则：

- 先共享拒收语义，再分化消费者动作

## 1. Shared Packet Header 最小样例

```yaml
packet_header:
  rule_packet_id: structure-artifact-rule-packet
  artifact_line_scope: artifact_line_id
  structure_object_type: structure_object
  structure_object_id_field: structure_object_id
  shared_contract_fields:
    - structure_object_id
    - authoritative_path
    - current_read_path
    - current_write_path
    - recovery_asset_ledger
    - anti_zombie_evidence
    - retained_assets
    - danger_paths
    - rollback_object
    - dropped_stale_writers
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
  rule_id: S-HF-001
  level: hard_fail
  applies_to: cross_artifact
  reads:
    - structure_object_id
    - authoritative_path
  predicate: all_equal
  reject_reason: structure_split_brain
  evidence_emit:
    - structure_object_id
    - authoritative_path
  rewrite_target: artifact_group
```

```yaml
test_fail:
  host_card.authoritative_path: bridge_pointer -> session_ingress
  review_card.authoritative_path: directory_diagram_only
  expected:
    decision: reject
    matched_rule: S-HF-001
    reject_reason: structure_split_brain
```

## 3. Lint Warn 最小样例

```yaml
rule:
  rule_id: S-LW-001
  level: lint_warn
  applies_to: host_card
  reads:
    - authoritative_path
    - directory_diagram
  predicate: forbid_only(directory_diagram_as_authority)
  reject_reason: authority_substituted_by_diagram
  evidence_emit:
    - authoritative_path
  rewrite_target: host_card
```

```yaml
test_warn:
  host_card:
    authoritative_path: bridge_pointer -> session_ingress
    directory_diagram: primary
  expected:
    decision: warn
    matched_rule: S-LW-001
```

## 4. Reviewer Gate 最小样例

```yaml
rule:
  rule_id: S-RG-001
  level: reviewer_gate
  applies_to: review_card
  reads:
    - authoritative_path
    - current_read_path
    - current_write_path
    - rollback_object
  predicate: requires_live_path_anchor
  reject_reason: review_without_live_path_anchor
  evidence_emit:
    - current_read_path
    - current_write_path
  rewrite_target: review_card
```

```yaml
test_gate:
  review_card:
    review_judgement: structure_is_clearer
    current_read_path: null
    current_write_path: null
  expected:
    decision: review_required
    matched_rule: S-RG-001
```

## 5. Handoff Reject 最小样例

```yaml
rule:
  rule_id: S-HR-001
  level: handoff_reject
  applies_to: handoff_package
  reads:
    - danger_paths
    - rollback_object
    - dropped_stale_writers
  predicate: continuation_ready
  reject_reason: oral_handoff_without_structured_object
  evidence_emit:
    - danger_paths
    - rollback_object
  rewrite_target: handoff_package
```

```yaml
test_reject:
  handoff_package:
    handoff_notes: ask_author_if_needed
    danger_paths: []
    rollback_object: null
  expected:
    decision: reject
    matched_rule: S-HR-001
```

## 6. Anti-Zombie Gate 最小样例

```yaml
rule:
  rule_id: S-AZ-001
  level: anti_zombie_gate
  applies_to: ci_attachment
  reads:
    - anti_zombie_evidence
    - dropped_stale_writers
  predicate: stale_writer_proof_required
  reject_reason: anti_zombie_without_stale_drop_evidence
  rewrite_target: ci_attachment
  rewrite_hint:
    - 补 dropped_stale_writers
    - 补 stale basis
    - 补 generation / epoch 证据
```

## 7. Evaluator Interface 最小样例

```yaml
evaluator_run:
  packet_ref: abi://structure-artifact-rule-packet/v0
  artifact_group_ref: artifact://structure/STR-ART-003
  mode: ci|review|handoff
  outputs:
    decision: pass|warn|review_required|reject
    matched_rules: [rule_id]
    reject_reasons: [string]
    rewrite_targets: [string]
    evidence_refs: [string]
```

接口目标不是：

- 替代结构判断

而是：

- 让不同消费者围绕同一 `structure object` 输出同一 split-brain / anti-zombie 拒收语义

## 8. 三个最容易写坏的地方

1. 把 `hard fail` 写成字段齐全检查，而不是 authoritative path 一致性检查。
2. 把 `lint warn` 写成目录展示建议，而不是目录图替代权威路径的告警。
3. 把 `anti-zombie gate` 写成“有规则就行”，而不是要求 stale writer 清退证据。

## 9. 苏格拉底式追问

在你准备照抄这组样例前，先问自己：

1. 我抄到的是同一 `structure object` 的拒收语义，还是只抄到几条结构规则。
2. 如果删掉目录图、恢复成功率和作者说明，这组样例还会命中吗。
3. evaluator 输出的 `reject_reason` 是否真的能被宿主、CI、review 与 handoff 共享。
4. 我是在证明源码先进性可验证，还是在给源码先进性补配置注释。
