# 治理 Artifact Harness Runner API：Decision Window Replay Queue、Arbitration Assertion、Drift Ledger 与 Upgrade Adoption 协议

这一章回答五个问题：

1. 治理线的 replay harness，怎样继续压成可持续执行的 runner 协议。
2. 哪些字段属于 `decision replay queue`，哪些属于 `arbitration assertion`，哪些属于 `drift ledger entry`，哪些属于 `upgrade adoption`。
3. 为什么治理 runner 必须继续围绕 `decision_window`、`failure_semantics`、`rollback_object` 与 `next_action`，而不是围绕状态色、计数与通过率。
4. 为什么 replay lab 的输出必须继续写进 governance ledger，而不能停在一次性 `upgrade_required`。
5. 平台设计者该按什么顺序把治理 runner 接进宿主、CI、评审与交接。

## 0. 关键源码锚点

- `claude-code-source-code/src/query/tokenBudget.ts:1-92`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-760`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1169-1280`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts:138-330`
- `claude-code-source-code/src/services/mcp/channelPermissions.ts:1-240`
- `claude-code-source-code/src/utils/sessionState.ts:92-133`

## 1. 先说结论

治理线真正成熟的 harness runner，不是：

- 把同一组门禁继续重跑

而是：

- 让 `decision replay queue`、`arbitration assertion`、`drift ledger` 与 `upgrade adoption` 围绕同一 `decision_window` 连续运行

这份协议至少要统一五件事：

1. 当前保护的 `governance_object_id` 与 `decision_window` 是谁。
2. 当前 replay 复用的 `control_arbitration_truth` 与 `rollback_object` 是什么。
3. 当前跨消费者对齐依赖哪些仲裁字段。
4. 当前 drift 被记成什么 governance ledger 条目。
5. 当前 object upgrade / stop / rollback 怎样回写下一次继续判断。

## 2. Decision Replay Queue

```yaml
decision_replay_queue_item:
  queue_item_id: governance-runner-001
  runner_id: governance-artifact-harness-runner
  packet_ref: abi://governance-artifact-rule-packet/v0
  replay_case_ref: replay://governance/governance-replay-002
  governance_object_id: governance-object-88
  decision_window:
    started_at_turn: 204
    last_gain_turn: 206
    continuation_count: 3
  arbitration_refs:
    control_arbitration_truth: artifact://governance/GOV-ART-002/ci
    rollback_object: rollback://task/compact
    next_action: action://compact
  consumer_order:
    - host
    - ci
    - review
    - handoff
  status: queued|running|aligned|upgrade_required|completed|failed
```

这里最重要的不是：

- 再给一次 `upgrade_required`

而是：

- 把“是否还值得继续花 token”写成正式可重放对象

## 3. Arbitration Assertion

```yaml
arbitration_assertion:
  assertion_id: governance-alignment-001
  queue_item_ref: runner://governance/governance-runner-001
  alignment_key:
    - governance_object_id
    - decision_window
    - control_arbitration_truth
    - rollback_object
    - next_action
  expected_shared_reason:
    - continued_spend_without_decision_gain
    - missing_arbitration_truth
    - no_rollback_or_next_action
  expected_consumers:
    host: pass|warn|upgrade_required
    ci: pass|warn|upgrade_required|reject
    review: pass|review_required|upgrade_required
    handoff: pass|reject|upgrade_required
```

这里最重要的不是动作完全一致，而是：

- 不同动作仍然围绕同一 `continued_spend_without_decision_gain`

## 4. Governance Drift Ledger

```yaml
drift_ledger_entry:
  ledger_entry_id: governance-drift-001
  queue_item_ref: runner://governance/governance-runner-001
  governance_object_id: governance-object-88
  detected_drift:
    kind: decision_window_drift|arbitration_drift|handoff_drift
    source_consumer: host|ci|review|handoff
    reason: missing_arbitration_truth
  evidence_refs:
    - artifact://governance/GOV-ART-002/ci
    - rollback://task/compact
  replay_verdict: aligned|split_brain|upgrade_required
  next_action:
    type: upgrade_object|rewrite|rollback|stop
    target: ci_attachment
```

治理 drift ledger 记录的重点应该是：

1. 当前失真的不是哪张 dashboard，而是哪一个 decision window。
2. 谁先暴露了仲裁语义缺失。
3. 这次继续应该升级对象、回退还是停止。

## 5. Upgrade Adoption

```yaml
upgrade_adoption:
  adoption_id: governance-upgrade-001
  ledger_entry_ref: ledger://governance/governance-drift-001
  adoption_target: object_upgrade_rule
  before:
    object_upgrade_rule: null
    rollback_object: rollback://session/current
  after:
    object_upgrade_rule: if no_gain_after_2_waits -> compact_or_task
    rollback_object: rollback://task/compact
  expected_post_replay:
    ci: pass
    review: pass
  adoption_result: adopted|rejected|needs_review
```

真正成熟的 governance adoption，不是：

- 稍微再省一点 token

而是：

- 改写后所有消费者重新围绕同一 `decision_window` 与 `rollback_object` 做判断

## 6. Runner Output

```yaml
runner_execution:
  queue_item_ref: runner://governance/governance-runner-001
  consumer_decisions:
    host: pass|warn|upgrade_required|reject
    ci: pass|warn|upgrade_required|reject
    review: pass|review_required|upgrade_required|reject
    handoff: pass|upgrade_required|reject
  alignment_result: aligned|split_brain
  ledger_entry_ref: ledger://governance/governance-drift-001
  upgrade_adoption_ref: adopt://governance/governance-upgrade-001|null
  execution_verdict: completed|upgrade_required|failed
```

## 7. 最小接法

如果你要最小化接入治理 harness runner，建议按下面顺序做：

1. 先固定 `decision_replay_queue_item`，把 `decision_window` 与 `rollback_object` 写成正式对象。
2. 再固定 `arbitration_assertion`，确保本地 UI、bridge、channel 与 review 共用同一仲裁语义。
3. 再把 replay 结果写进 `drift_ledger_entry`，不要只保存通过率与阈值图。
4. 最后再引入 `upgrade_adoption`，把对象升级后的 replay 接回队列。

## 8. 一句话总结

治理 Artifact Harness Runner API 真正统一的，不是更多 gate，而是 `decision_window` 从 replay、仲裁、drift 到 object upgrade 的持续执行协议。
