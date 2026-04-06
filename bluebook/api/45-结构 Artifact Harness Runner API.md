# 结构 Artifact Harness Runner API：Authoritative Replay Queue、Anti-Zombie Assertion、Drift Ledger 与 Recovery Adoption 协议

这一章回答五个问题：

1. 结构线的 replay harness，怎样继续压成可持续执行的 runner 协议。
2. 哪些字段属于 `authoritative replay queue`，哪些属于 `anti-zombie assertion`，哪些属于 `drift ledger entry`，哪些属于 `recovery adoption`。
3. 为什么结构 runner 必须继续围绕 `authoritative_path`、`recovery_asset_ledger`、`dropped_stale_writers` 与 `rollback_object`，而不是围绕目录图与恢复成功率。
4. 为什么 replay lab 的输出必须继续写进 structure ledger，而不能停在一次性 anti-zombie replay。
5. 平台设计者该按什么顺序把结构 runner 接进宿主、CI、评审与交接。

## 0. 关键源码锚点

- `claude-code-source-code/src/services/api/sessionIngress.ts:57-186`
- `claude-code-source-code/src/utils/task/framework.ts:160-269`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:824-880`
- `claude-code-source-code/src/utils/sessionState.ts:92-133`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`

## 1. 先说结论

结构线真正成熟的 harness runner，不是：

- 周期性重跑一组 anti-zombie case

而是：

- 让 `authoritative replay queue`、`anti-zombie assertion`、`drift ledger` 与 `recovery adoption` 围绕同一 `structure_object_id` 连续运行

这份协议至少要统一五件事：

1. 当前保护的 `structure_object_id` 与 `authoritative_path` 是谁。
2. 当前 replay 复用的 `recovery_asset_ledger` 与 `rollback_object` 是什么。
3. 当前跨消费者对齐依赖哪些 anti-zombie 字段。
4. 当前 drift 被记成什么 structure ledger 条目。
5. 当前恢复动作采纳后如何回写下一次 replay 输入。

## 2. Authoritative Replay Queue

```yaml
authoritative_replay_queue_item:
  queue_item_id: structure-runner-001
  runner_id: structure-artifact-harness-runner
  packet_ref: abi://structure-artifact-rule-packet/v0
  replay_case_ref: replay://structure/structure-replay-003
  structure_object_id: structure-object-17
  authority_refs:
    authoritative_path: src/runtime/query.ts
    recovery_asset_ledger: ledger://structure/recovery/session-17
    anti_zombie_evidence: evidence://structure/gen-16
    rollback_object: rollback://bridge/session-17
    danger_paths:
      - src/runtime/query.ts
      - src/bridge/session.ts
  consumer_order:
    - host
    - ci
    - review
    - handoff
  status: queued|running|aligned|recovery_required|completed|failed
```

这里最重要的不是：

- 再展示一次目录结构

而是：

- 把“谁是权威对象、谁已被 stale writer 清退”写成正式可持续对象

## 3. Anti-Zombie Assertion

```yaml
anti_zombie_assertion:
  assertion_id: structure-alignment-001
  queue_item_ref: runner://structure/structure-runner-001
  alignment_key:
    - structure_object_id
    - authoritative_path
    - recovery_asset_ledger
    - anti_zombie_evidence
    - rollback_object
  expected_shared_reason:
    - structure_split_brain
    - missing_recovery_or_anti_zombie_evidence
    - oral_handoff_without_structured_object
  expected_consumers:
    host: pass|warn|reject
    ci: pass|warn|reject
    review: pass|review_required|reject
    handoff: pass|reject
```

这里最重要的不是 verdict 完全相同，而是：

- 不同消费者都围绕同一 `structure_split_brain` 或 `anti-zombie` 语义

## 4. Structure Drift Ledger

```yaml
drift_ledger_entry:
  ledger_entry_id: structure-drift-001
  queue_item_ref: runner://structure/structure-runner-001
  structure_object_id: structure-object-17
  detected_drift:
    kind: authority_drift|recovery_drift|handoff_drift
    source_consumer: host|ci|review|handoff
    reason: missing_recovery_or_anti_zombie_evidence
  evidence_refs:
    - ledger://structure/recovery/session-17
    - evidence://structure/gen-16
  replay_verdict: aligned|split_brain|recovery_required
  next_action:
    type: rewrite|recovery|rollback
    target: ci_attachment
```

结构 drift ledger 记录的重点应该是：

1. 是 authority 漂移还是 stale-writer 清退失败。
2. 哪个恢复资产仍然可信。
3. 下一次 replay 是继续恢复、回退还是拒收。

## 5. Recovery Adoption

```yaml
recovery_adoption:
  adoption_id: structure-recovery-001
  ledger_entry_ref: ledger://structure/structure-drift-001
  adoption_target: anti_zombie_evidence
  before:
    anti_zombie_evidence: generation_guard_only
    dropped_stale_writers: []
  after:
    anti_zombie_evidence: generation_guard_plus_drop_log
    dropped_stale_writers:
      - stale_bridge_writer@gen-16
  expected_post_replay:
    ci: pass
    review: pass
  adoption_result: adopted|rejected|needs_review
```

真正成熟的 recovery adoption，不是：

- 把恢复成功率写得更漂亮

而是：

- 改写后所有消费者重新围绕同一 `authoritative_path` 与 `dropped_stale_writers` 做判断

## 6. Runner Output

```yaml
runner_execution:
  queue_item_ref: runner://structure/structure-runner-001
  consumer_decisions:
    host: pass|warn|reject
    ci: pass|warn|reject
    review: pass|review_required|reject
    handoff: pass|reject
  alignment_result: aligned|split_brain
  ledger_entry_ref: ledger://structure/structure-drift-001
  recovery_adoption_ref: adopt://structure/structure-recovery-001|null
  execution_verdict: completed|recovery_required|failed
```

## 7. 最小接法

如果你要最小化接入结构 harness runner，建议按下面顺序做：

1. 先固定 `authoritative_replay_queue_item`，把 `authoritative_path` 与 `rollback_object` 写成正式对象。
2. 再固定 `anti_zombie_assertion`，确保 host、CI、review 与 handoff 共用同一 authority / recovery 语义。
3. 再把 replay 结果写进 `drift_ledger_entry`，不要只保留目录图与成功率。
4. 最后再引入 `recovery_adoption`，把恢复后的 replay 接回队列。

## 8. 一句话总结

结构 Artifact Harness Runner API 真正统一的，不是更多 anti-zombie case，而是 `authoritative object` 从 replay、对齐、drift 到 recovery adoption 的持续执行协议。
