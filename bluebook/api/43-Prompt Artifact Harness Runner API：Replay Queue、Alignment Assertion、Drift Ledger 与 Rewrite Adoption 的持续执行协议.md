# Prompt Artifact Harness Runner API：Replay Queue、Alignment Assertion、Drift Ledger 与 Rewrite Adoption 的持续执行协议

这一章回答五个问题：

1. Prompt 线的 replay harness，怎样继续压成可持续执行的 runner 协议。
2. 哪些字段属于 `replay queue item`，哪些属于 `alignment assertion`，哪些属于 `drift ledger entry`，哪些属于 `rewrite adoption`。
3. 为什么 Prompt runner 必须继续围绕 `compiled request continuity`、`stable bytes` 与 `lawful forgetting`，而不是围绕通过率与总结。
4. 为什么 replay lab 的输出必须继续写进 drift ledger，而不能停在一次性 verdict。
5. 平台设计者该按什么顺序把 Prompt runner 接进宿主、CI、评审与交接。

## 0. 关键源码锚点

- `claude-code-source-code/src/query/stopHooks.ts:84-132`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-380`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/toolResultStorage.ts:739-880`
- `claude-code-source-code/src/utils/sessionState.ts:92-133`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`

## 1. 先说结论

Prompt 线真正成熟的 harness runner，不是：

- 按天重新执行 `replay case`

而是：

- 让 `replay queue`、`alignment assertion`、`drift ledger` 与 `rewrite adoption` 围绕同一 `compiled request object` 连续运行

这份协议至少要统一五件事：

1. 当前保护的 `prompt_object_id` 是谁。
2. 当前 replay 复用的 `compiled_request_diff_ref` 与 `stable_bytes_ledger_ref` 是什么。
3. 当前跨消费者对齐依赖哪些 `alignment_key`。
4. 当前 drift 被记成什么正式 ledger 条目。
5. 当前 rewrite 被采纳后如何回写下一次 replay 的输入。

## 2. Replay Queue Item

这些字段定义“这次 runner 要继续执行哪一个 Prompt 对象”：

```yaml
replay_queue_item:
  queue_item_id: prompt-runner-001
  runner_id: prompt-artifact-harness-runner
  packet_ref: abi://prompt-artifact-rule-packet/v0
  replay_case_ref: replay://prompt/prompt-replay-001
  prompt_object_id: prompt-object-204
  artifact_group_ref: artifact://prompt/PRM-ART-001
  continuation_refs:
    compiled_request_diff_ref: diff://prompt/turn-204
    stable_bytes_ledger_ref: ledger://prompt/stable-bytes/turn-204
    lawful_forgetting_abi_ref: abi://prompt/lawful-forgetting/v2
    next_step_guard: guard://prompt/turn-205
  consumer_order:
    - host
    - ci
    - review
    - handoff
  status: queued|running|aligned|rewrite_required|completed|failed
```

这里最重要的不是队列本身，而是：

- `continuation_refs` 继续指向编译后请求对象，而不是退回 raw prompt

## 3. Alignment Assertion

这些字段定义“这次 runner 要证明谁在围绕同一 continuation”：

```yaml
alignment_assertion:
  assertion_id: prompt-alignment-001
  queue_item_ref: runner://prompt/prompt-runner-001
  alignment_key:
    - prompt_object_id
    - compiled_request_diff_ref
    - stable_bytes_ledger_ref
    - lawful_forgetting_abi_ref
  expected_consumers:
    host: reject|warn|pass
    ci: reject|warn|pass
    review: reject|review_required|pass
    handoff: reject|pass
  expected_shared_reason:
    - shared_object_mismatch
    - missing_compiled_request_evidence
    - summary_only_handoff
```

这里最重要的不是：

- 每个消费者都得到同一个 verdict

而是：

- 不同 verdict 仍然围绕同一 `expected_shared_reason`

## 4. Drift Ledger Entry

这些字段定义“这次 replay 为下一次继续执行留下什么”：

```yaml
drift_ledger_entry:
  ledger_entry_id: prompt-drift-001
  queue_item_ref: runner://prompt/prompt-runner-001
  prompt_object_id: prompt-object-204
  detected_drift:
    kind: shared_object_drift|projection_drift|handoff_drift
    source_consumer: host|ci|review|handoff
    reason: missing_compiled_request_evidence
  evidence_refs:
    - diff://prompt/turn-204
    - ledger://prompt/stable-bytes/turn-204
  replay_verdict: aligned|split_brain|rewrite_required
  next_action:
    type: rewrite|rollback|reject
    target: ci_attachment
```

更稳的 Prompt drift ledger 必须记录：

1. 哪个 shared object 漂移。
2. 漂移是 projection drift 还是 object drift。
3. 哪个 consumer 先暴露漂移。
4. 下一次 replay 应该从哪里继续。

## 5. Rewrite Adoption

这些字段定义“这次改写是否真的恢复了 continuation”：

```yaml
rewrite_adoption:
  adoption_id: prompt-rewrite-001
  ledger_entry_ref: ledger://prompt/prompt-drift-001
  rewrite_target: ci_attachment
  before_refs:
    compiled_request_diff_ref: null
    stable_bytes_ledger_ref: null
  after_refs:
    compiled_request_diff_ref: diff://prompt/turn-204
    stable_bytes_ledger_ref: ledger://prompt/stable-bytes/turn-204
  expected_post_replay:
    ci: pass
    review: pass
  adoption_result: adopted|rejected|needs_review
```

真正成熟的 rewrite adoption，不是：

- 文案补齐

而是：

- 改写后同一 `prompt_object_id` 能再次通过 alignment assertion

## 6. Runner Output

```yaml
runner_execution:
  queue_item_ref: runner://prompt/prompt-runner-001
  consumer_decisions:
    host: pass|warn|reject
    ci: pass|warn|reject
    review: pass|review_required|reject
    handoff: pass|reject
  alignment_result: aligned|split_brain
  ledger_entry_ref: ledger://prompt/prompt-drift-001
  rewrite_adoption_ref: adopt://prompt/prompt-rewrite-001|null
  execution_verdict: completed|rewrite_required|failed
```

## 7. 最小接法

如果你要最小化接入 Prompt harness runner，建议按下面顺序做：

1. 先固定 `replay_queue_item`，确保 replay 输入仍围绕 `compiled request object`。
2. 再固定 `alignment_assertion`，确保 host、CI、review 与 handoff 共用同一 `alignment_key`。
3. 再把 replay 结果写进 `drift_ledger_entry`，不要只保留一次性 verdict。
4. 最后再引入 `rewrite_adoption`，把修复后的 replay 重新接回队列。

## 8. 一句话总结

Prompt Artifact Harness Runner API 真正统一的，不是实验室命令，而是 `compiled request continuity` 从 replay、对齐、漂移到改写采纳的持续执行协议。
