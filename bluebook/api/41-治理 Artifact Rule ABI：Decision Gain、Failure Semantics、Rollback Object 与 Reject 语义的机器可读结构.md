# 治理 Artifact Rule ABI：Decision Gain、Failure Semantics、Rollback Object 与 Reject 语义的机器可读结构

这一章回答五个问题：

1. 治理线的 validator 规则，怎样继续压成不同消费者共享的 `rule packet`。
2. 哪些字段属于 `packet header`，哪些属于 `rule body`，哪些属于 `rewrite hint`。
3. `hard fail`、`lint warn`、`reviewer gate`、`handoff reject` 与 `object-upgrade gate` 应怎样分层。
4. 为什么治理 rule ABI 必须继续围绕 `decision gain`、`failure semantics` 与 `rollback object`，而不是围绕状态色、计数与 verdict。
5. 平台设计者该按什么顺序把治理 rule ABI 接到宿主、CI、评审与交接里。

## 0. 关键源码锚点

- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:235-1283`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts:244-300`
- `claude-code-source-code/src/query/tokenBudget.ts:1-82`
- `claude-code-source-code/src/utils/toolResultStorage.ts:367-860`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/utils/sessionState.ts:92-146`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

## 1. 先说结论

治理线真正成熟的 rule ABI，不是：

- 每个消费者各写一套 dashboard 规则

而是：

- 宿主卡、CI 附件、评审卡与 handoff package 共享同一份 `Governance rule packet`

这份 packet 至少要统一五件事：

1. 当前共享的 `governance object` 是谁。
2. 当前这轮判断还有没有 `decision gain`。
3. 失败时到底采用哪种 `failure semantics`。
4. 回退时到底退到哪个 `rollback object`。
5. 没有这些前提时，系统怎样正式拒绝继续。

## 2. Rule Packet 的两层结构

### 2.1 Packet Header

这些字段定义“这包规则在保护哪条治理判断链”：

1. `rule_packet_id`
2. `artifact_line_scope`
3. `governance_object_type`
4. `governance_object_id_field`
5. `shared_contract_fields`
6. `packet_version`
7. `consumer_scopes`

更稳的治理 packet header 可以固定为：

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

### 2.2 Rule Body

这些字段定义“具体怎样拒绝无效治理”：

1. `rule_id`
2. `rule_kind`
3. `severity`
4. `consumer_scope`
5. `must_exist_fields`
6. `must_equal_fields`
7. `forbidden_proxy_patterns`
8. `decision_gain_test`
9. `reject_reason`
10. `rewrite_target`
11. `rewrite_hint`

其中：

- `rule_kind` 只允许：
  - `hard_fail`
  - `lint_warn`
  - `reviewer_gate`
  - `handoff_reject`
  - `object_upgrade_gate`

## 3. 治理 Rule ABI 的五层语义

### 3.1 Hard Fail

直接阻止继续消费同一工件组：

1. `governance_object_id` 缺失。
2. `decision_window` 缺失。
3. `rollback_object` 缺失。
4. `governance_object_id` 或 `decision_window` 跨工件不一致。
5. `failure_semantics` 缺失，却仍试图继续行动。

### 3.2 Lint Warn

允许继续，但明确提示治理真相正在被结果面替代：

1. 宿主卡只有状态色，没有对象与窗口。
2. 仲裁附件只有 token / latency / ask 次数。
3. 评审卡 verdict 多于 failure semantics。
4. 交接包状态摘要多于 `rollback_object` 与 `next_action`。

### 3.3 Reviewer Gate

规定评审顺序，不允许 verdict 先于判断链：

1. `governance_object_id`
2. `decision_window`
3. `winner_source`
4. `control_arbitration_truth`
5. `failure_semantics`
6. `rollback_object`
7. `next_action`
8. `review_judgement`

### 3.4 Handoff Reject

交接时一票否决：

1. 没有 `rollback_object`。
2. 没有 `next_action`。
3. 只写“现在卡住了”，却没有 re-entry 条件。
4. 需要读历史与问作者，才能知道该停、该退、该升级对象。

### 3.5 Object-Upgrade Gate

不是所有继续都值得继续：

1. 没有 `decision gain` 时，应直接触发 `upgrade_or_stop`。
2. `object_upgrade_rule` 缺失时，不允许继续消耗 token。
3. `failure_semantics` 与 `rollback_object` 未写清时，不允许自动放行。

## 4. 最小治理 Rule Packet 样例

```yaml
rules:
  - rule_id: G-HF-001
    rule_kind: hard_fail
    severity: critical
    consumer_scope: cross_artifact
    must_equal_fields:
      - governance_object_id
      - decision_window
      - artifact_line_id
    reject_reason: governance_split_brain
    rewrite_target: artifact_group
    rewrite_hint: 统一对象与窗口后再继续

  - rule_id: G-HF-002
    rule_kind: hard_fail
    severity: critical
    consumer_scope: handoff_package
    must_exist_fields:
      - rollback_object
      - next_action
    reject_reason: no_rollback_or_next_action
    rewrite_target: handoff_package
    rewrite_hint: 交接必须先写回退与下一动作，再写状态摘要

  - rule_id: G-LW-001
    rule_kind: lint_warn
    severity: warning
    consumer_scope: host_card
    forbidden_proxy_patterns:
      - status_color_as_primary_truth
      - allow_deny_without_window
    reject_reason: dashboard_substituted_decision_window
    rewrite_target: host_card
    rewrite_hint: 改写为 object + window + rollback_object

  - rule_id: G-RG-001
    rule_kind: reviewer_gate
    severity: high
    consumer_scope: review_card
    must_exist_fields:
      - decision_window
      - failure_semantics
      - rollback_object
    reject_reason: review_without_decision_chain
    rewrite_target: review_card
    rewrite_hint: verdict 之前先写 decision chain

  - rule_id: G-OG-001
    rule_kind: object_upgrade_gate
    severity: high
    consumer_scope: ci_attachment
    decision_gain_test: no_decision_gain_no_more_spend
    must_exist_fields:
      - object_upgrade_rule
      - control_arbitration_truth
    reject_reason: continued_spend_without_decision_gain
    rewrite_target: ci_attachment
    rewrite_hint: 改写为 stop / compact / task / worktree 升级建议
```

## 5. 为什么治理 Rule ABI 必须继续围绕 shared reject semantics

因为安全最容易被误写成：

- 能不能拦住

省 token 最容易被误写成：

- 能不能少花

但更接近 Claude Code 真相的写法是：

- 两者都在回答：当前这轮继续是否仍有决策增益

如果这套 rule ABI 围绕的不是 shared reject semantics：

1. 安全会退回状态色与按钮结果。
2. 省 token 会退回局部成本图。
3. rollback 会退回拍脑袋判断。
4. handoff 会退回状态转述。

## 6. 最小接法

如果你要最小化接入治理 rule ABI，建议按下面顺序做：

1. 先固定 `packet_header`。
2. 再把 `hard_fail` 接到跨工件一致性检查。
3. 再把 `lint_warn` 接到宿主、CI、评审各自 projection。
4. 再把 `reviewer_gate` 接到 verdict 顺序控制。
5. 最后把 `object_upgrade_gate` 与 `handoff_reject` 接到停止、升级与交接动作。

## 7. 一句话总结

治理 Artifact Rule ABI 真正统一的，不是不同消费者的规则数量，而是它们依赖的同一套 `decision gain + failure semantics + rollback object` 拒收语义。
