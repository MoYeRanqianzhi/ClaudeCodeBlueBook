# 结构 Artifact Rule ABI：Authoritative Path、Recovery Asset、Anti-Zombie 与 Reject 语义的机器可读结构

这一章回答五个问题：

1. 结构线的 validator 规则，怎样继续压成不同消费者共享的 machine-readable rule packet。
2. 哪些字段属于 `packet header`，哪些属于 `rule body`，哪些只能停留在 rewrite hint。
3. 为什么结构 rule ABI 必须先围绕 `contract -> registry -> current-truth surface -> consumer subset -> hotspot kernel -> mirror gap discipline`，而不是围绕目录图、恢复成功率与作者说明。
4. `hard fail`、`lint warn`、`reviewer gate` 与 `handoff reject` 应怎样挂回 shared reject semantics。
5. 平台设计者该按什么顺序把结构 rule ABI 接到宿主、CI、评审与交接里。

## 0. 第一性原理

结构线真正成熟的 rule ABI，不是：

- 每个消费者各自描述“结构没问题”

而是：

- 不同消费者围绕同一组当前可公开检查的源码锚点共享同一组拒收条件

因此 packet header 的第一页，必须先固定：

1. `contract_ref`
2. `registry_ref`
3. `current_truth_surface_ref`
4. `consumer_subset_ref`
5. `hotspot_kernel_ref`
6. `mirror_gap_ref`

旧结构名词只能作为局部 rewrite hint 或 witness，不能再越位成 packet 主语。

## 1. Packet Header

更稳的结构 rule packet header 可以固定为：

```yaml
packet_header:
  rule_packet_id: structure-rule-packet
  artifact_line_scope: artifact_line_id
  structure_object_type_field: structure_object_type
  structure_object_id_field: structure_object_id
  chain_fields:
    - contract_ref
    - registry_ref
    - current_truth_surface_ref
    - consumer_subset_ref
    - hotspot_kernel_ref
    - mirror_gap_ref
  reject_fields:
    - reject_verdict
    - reject_reason
  consumer_scopes:
    - host_card
    - ci_attachment
    - review_card
    - handoff_package
  packet_version: v0
```

它的作用不是：

- 发明一套结构世界

而是：

- 让不同消费者围绕同一组可公开复核的锚点共享同一套 reject semantics

## 2. Rule Body 应检查什么

更稳的 `rule body` 不该先发明大量结构对象名，而应先检查三件事：

1. `same-current-truth`
   - 当前工件是不是仍提供了足以让外部读者复核到同一 `current-truth surface` 的公开见证。
2. `subset-not-sovereign`
   - `consumer subset`、结构图、恢复资产、镜像提示有没有越权成主语。
3. `mirror-gap-explicit`
   - 当前哪些结论只配停留在镜像缺口说明层。

因此更稳的字段是：

1. `rule_id`
2. `rule_kind`
3. `severity`
4. `consumer_scope`
5. `must_exist_fields`
6. `must_equal_fields`
7. `forbidden_proxy_patterns`
8. `reject_verdict`
9. `rewrite_target`
10. `rewrite_hint`

## 3. Shared Reject Semantics

结构 rule ABI 最值得固定的 reject trio 是：

1. `layout-first drift`
2. `recovery-sovereignty leak`
3. `surface-gap blur`

它们分别对应：

1. 目录观感越位成真相
2. 恢复资产或历史快照越权成主权
3. subset / mirror hint 越位成 current truth

不同 `rule_kind` 的价值，不在“名字更多”，而在它们都围绕这组三联工作。

## 4. 最小 Rule Packet 样例

```yaml
rules:
  - rule_id: S-HF-001
    rule_kind: hard_fail
    severity: critical
    consumer_scope: cross_artifact
    must_equal_fields:
      - structure_object_id
      - current_truth_surface_ref
      - artifact_line_id
    reject_verdict: surface-gap blur
    rewrite_target: artifact_group
    rewrite_hint: 统一 current-truth surface 后再继续

  - rule_id: S-HF-002
    rule_kind: hard_fail
    severity: critical
    consumer_scope: ci_attachment
    must_exist_fields:
      - contract_ref
      - registry_ref
      - one_writable_present_witness
    reject_verdict: recovery-sovereignty leak
    rewrite_target: ci_attachment
    rewrite_hint: 先补 current-truth 与 freshness 证据，不得只报恢复成功

  - rule_id: S-LW-001
    rule_kind: lint_warn
    severity: warning
    consumer_scope: host_card
    forbidden_proxy_patterns:
      - directory_diagram_as_current_truth
      - retained_assets_as_sovereignty
    reject_verdict: layout-first drift
    rewrite_target: host_card
    rewrite_hint: 改写为 current-truth surface + consumer subset

  - rule_id: S-HR-001
    rule_kind: handoff_reject
    severity: critical
    consumer_scope: handoff_package
    must_exist_fields:
      - mirror_gap_ref
      - later_reject_path
      - dropped_stale_writers
    reject_verdict: surface-gap blur
    rewrite_target: handoff_package
    rewrite_hint: 交接必须先给 reject path，再给作者说明
```

## 5. 为什么 reviewer gate 也要围绕这条链

结构评审真正要防的，不是“图不好看”，而是 later maintainer 被迫回到作者权威。

因此 reviewer gate 应先要求：

1. `contract_ref`
2. `registry_ref`
3. `current_truth_surface_ref`
4. `consumer_subset_ref`
5. `hotspot_kernel_ref`
6. `mirror_gap_ref`

然后才允许：

- 结构图
- 恢复成功率
- 目录体感

否则 reviewer gate 就会重新退回“先看图，再补路径”。

## 6. 最小接法

如果你要最小化接入结构 rule ABI，建议按下面顺序做：

1. 先固定 `packet_header`，让所有消费者共享同一条真相链字段。
2. 再把 `hard_fail` 接到 cross-artifact 一致性检查。
3. 再把 `lint_warn` 接到 host / CI / review 的 projection 越权检查。
4. 最后才把 `handoff_reject` 与 rewrite hints 接到交接动作。

不要反过来：

1. 先写很满的 packet 词表
2. 先定义大量结构对象
3. 再回头补 contract 与 current truth

那样会让 ABI 看起来更精确，实则更脱离源码主权。

## 7. 苏格拉底式追问

在你准备宣布“结构 rule ABI 已经稳定”前，先问自己：

1. 这份 packet 是在复述同一条源码真相链，还是在发明一条新的文档对象链。
2. 我检查的是 current truth，还是结构图投影。
3. 我命名的是镜像缺口，还是在偷偷把缺口补脑成结论。
4. later maintainer 是否能不问作者就指出 first reject path。
5. 这份规则是在保护 `one writable present`，还是只是在保护目录审美。

## 8. 一句话总结

结构 Artifact Rule ABI 真正统一的，不是不同消费者的检查话术，而是它们都围绕 `contract -> registry -> current-truth surface -> consumer subset -> hotspot kernel -> mirror gap discipline` 这条链上当前可公开复核的见证，共享同一套结构拒收语义。
