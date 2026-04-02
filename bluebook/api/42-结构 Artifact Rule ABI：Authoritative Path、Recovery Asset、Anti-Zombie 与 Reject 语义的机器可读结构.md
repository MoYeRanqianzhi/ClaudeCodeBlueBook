# 结构 Artifact Rule ABI：Authoritative Path、Recovery Asset、Anti-Zombie 与 Reject 语义的机器可读结构

这一章回答五个问题：

1. 结构线的 validator 规则，怎样继续压成不同消费者共享的 `rule packet`。
2. 哪些字段属于 `packet header`，哪些属于 `rule body`，哪些属于 `rewrite hint`。
3. `hard fail`、`lint warn`、`reviewer gate`、`handoff reject` 与 `anti-zombie gate` 应怎样分层。
4. 为什么结构 rule ABI 必须继续围绕 `authoritative path`、`recovery asset ledger`、`anti-zombie evidence` 与 `rollback object`，而不是围绕目录图、恢复成功率与作者说明。
5. 平台设计者该按什么顺序把结构 rule ABI 接到宿主、CI、评审与交接里。

## 0. 关键源码锚点

- `claude-code-source-code/scripts/prepare-src.mjs:3-64`
- `claude-code-source-code/scripts/stub-modules.mjs:2-42`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts:13-116`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-167`
- `claude-code-source-code/src/services/api/sessionIngress.ts:60-120`
- `claude-code-source-code/src/utils/cleanupRegistry.ts:1-21`
- `claude-code-source-code/src/utils/QueryGuard.ts:69-106`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

## 1. 先说结论

结构线真正成熟的 rule ABI，不是：

- 每个消费者各自描述“结构没问题”

而是：

- 宿主卡、CI 附件、评审卡与 handoff package 共享同一份 `Structure rule packet`

这份 packet 至少要统一五件事：

1. 当前共享的 `structure object` 是谁。
2. 当前唯一 `authoritative path` 是什么。
3. 恢复到底依赖哪些 `recovery assets`。
4. 哪些 `stale writers` 已被正式清退。
5. 没有这些前提时，系统怎样正式拒绝继续。

## 2. Rule Packet 的两层结构

### 2.1 Packet Header

这些字段定义“这包规则在保护哪条结构真相”：

1. `rule_packet_id`
2. `artifact_line_scope`
3. `structure_object_type`
4. `structure_object_id_field`
5. `shared_contract_fields`
6. `packet_version`
7. `consumer_scopes`

更稳的结构 packet header 可以固定为：

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

### 2.2 Rule Body

这些字段定义“具体怎样拒绝结构漂移”：

1. `rule_id`
2. `rule_kind`
3. `severity`
4. `consumer_scope`
5. `must_exist_fields`
6. `must_equal_fields`
7. `forbidden_proxy_patterns`
8. `stale_writer_test`
9. `reject_reason`
10. `rewrite_target`
11. `rewrite_hint`

其中：

- `rule_kind` 只允许：
  - `hard_fail`
  - `lint_warn`
  - `reviewer_gate`
  - `handoff_reject`
  - `anti_zombie_gate`

## 3. 结构 Rule ABI 的五层语义

### 3.1 Hard Fail

直接阻止继续消费同一工件组：

1. `structure_object_id` 缺失。
2. `authoritative_path` 缺失。
3. `recovery_asset_ledger` 缺失。
4. `structure_object_id` 或 `authoritative_path` 跨工件不一致。
5. `rollback_object` 缺失，却仍试图继续恢复或交接。

### 3.2 Lint Warn

允许继续，但明确提示结构真相正在被展示面替代：

1. 宿主卡只有目录图，没有当前读写路径。
2. 恢复附件只有成功率，没有资产账本。
3. 评审卡结构夸奖多于路径判断。
4. 交接包作者说明多于 `danger_paths`。

### 3.3 Reviewer Gate

规定评审顺序，不允许图解先于对象：

1. `structure_object_id`
2. `authoritative_path`
3. `current_read_path`
4. `current_write_path`
5. `recovery_asset_ledger`
6. `anti_zombie_evidence`
7. `rollback_object`
8. `review_judgement`

### 3.4 Handoff Reject

交接时一票否决：

1. 没有 `danger_paths`。
2. 没有 `rollback_object`。
3. 没有 `dropped_stale_writers`。
4. 不问作者就无法继续恢复、回退或避险。

### 3.5 Anti-Zombie Gate

不是有规则就算有证据：

1. `anti_zombie_evidence` 缺失时，不允许宣称 stale writer 已退场。
2. 写了 stale-drop，却没有 `dropped_stale_writers` 时，不允许过 gate。
3. 旧 projection 仍可回写时，不允许继续宣称单一权威路径已成立。

## 4. 最小结构 Rule Packet 样例

```yaml
rules:
  - rule_id: S-HF-001
    rule_kind: hard_fail
    severity: critical
    consumer_scope: cross_artifact
    must_equal_fields:
      - structure_object_id
      - authoritative_path
      - artifact_line_id
    reject_reason: structure_split_brain
    rewrite_target: artifact_group
    rewrite_hint: 统一对象与权威路径后再继续

  - rule_id: S-HF-002
    rule_kind: hard_fail
    severity: critical
    consumer_scope: ci_attachment
    must_exist_fields:
      - recovery_asset_ledger
      - anti_zombie_evidence
    reject_reason: missing_recovery_or_anti_zombie_evidence
    rewrite_target: ci_attachment
    rewrite_hint: 补资产账本与 stale-writer 证据，不得只报喜

  - rule_id: S-LW-001
    rule_kind: lint_warn
    severity: warning
    consumer_scope: host_card
    forbidden_proxy_patterns:
      - directory_diagram_as_authority
      - module_map_as_current_object
    reject_reason: authority_substituted_by_diagram
    rewrite_target: host_card
    rewrite_hint: 改写为 authoritative_path + current_read_path + current_write_path

  - rule_id: S-RG-001
    rule_kind: reviewer_gate
    severity: high
    consumer_scope: review_card
    must_exist_fields:
      - authoritative_path
      - current_read_path
      - current_write_path
    reject_reason: review_without_live_path_anchor
    rewrite_target: review_card
    rewrite_hint: 图解之前先写 live path 与 rollback object

  - rule_id: S-HR-001
    rule_kind: handoff_reject
    severity: critical
    consumer_scope: handoff_package
    must_exist_fields:
      - danger_paths
      - rollback_object
      - dropped_stale_writers
    reject_reason: oral_handoff_without_structured_object
    rewrite_target: handoff_package
    rewrite_hint: 交接必须先给结构化对象包，再给作者说明
```

## 5. 为什么结构 Rule ABI 必须继续围绕 shared reject semantics

因为源码先进性最容易被误写成：

- 结构更清晰

但更接近 Claude Code 真相的写法是：

- 不同消费者能围绕同一 `structure object` 共享同一套拒收条件

如果这套 rule ABI 围绕的不是 shared reject semantics：

1. authoritative path 会退回目录图。
2. recovery asset 会退回成功率。
3. anti-zombie 会退回象征性规则。
4. handoff 会退回作者权威。

## 6. 最小接法

如果你要最小化接入结构 rule ABI，建议按下面顺序做：

1. 先固定 `packet_header`。
2. 再把 `hard_fail` 接到跨工件一致性检查。
3. 再把 `lint_warn` 接到宿主、CI、评审各自 projection。
4. 再把 `reviewer_gate` 接到评审顺序控制。
5. 最后把 `anti_zombie_gate` 与 `handoff_reject` 接到恢复与交接动作。

## 7. 一句话总结

结构 Artifact Rule ABI 真正统一的，不是不同消费者的检查话术，而是它们依赖的同一套 `authoritative path + recovery asset + anti-zombie + rollback object` 拒收语义。
