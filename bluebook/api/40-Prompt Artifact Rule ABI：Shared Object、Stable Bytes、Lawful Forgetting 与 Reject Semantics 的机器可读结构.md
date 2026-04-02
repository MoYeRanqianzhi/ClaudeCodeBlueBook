# Prompt Artifact Rule ABI：Shared Object、Stable Bytes、Lawful Forgetting 与 Reject Semantics 的机器可读结构

这一章回答五个问题：

1. Prompt 线的 validator 规则，怎样继续压成不同消费者共享的 `rule packet`。
2. 哪些字段属于 `packet header`，哪些属于 `rule body`，哪些属于 `rewrite hint`。
3. `hard fail`、`lint warn`、`reviewer gate`、`handoff reject` 与 `rewrite hint` 应怎样分层。
4. 为什么 Prompt 的规则 ABI 必须继续围绕 `compiled request object continuity`、`stable bytes` 与 `lawful forgetting ABI`，而不是围绕原文 prompt、绿灯与摘要。
5. 平台设计者该按什么顺序把 Prompt rule ABI 接到宿主、CI、评审与交接里。

## 0. 关键源码锚点

- `claude-code-source-code/src/constants/prompts.ts:491-557`
- `claude-code-source-code/src/constants/systemPromptSections.ts:17-43`
- `claude-code-source-code/src/utils/systemPrompt.ts:28-104`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-520`
- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:232-437`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-62`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/utils/sessionState.ts:92-146`

## 1. 先说结论

Prompt 线真正成熟的 rule ABI，不是：

- 每个消费者自己抄一套校验规则

而是：

- 宿主卡、CI 附件、评审卡与 handoff package 共享同一份 `Prompt rule packet`

这份 packet 至少要统一五件事：

1. 保护的 shared object 是谁。
2. 何时直接 `hard fail`。
3. 何时只报 `lint warn`。
4. reviewer 必须按什么顺序判断。
5. handoff 在什么条件下必须直接拒收。

## 2. Rule Packet 的两层结构

### 2.1 Packet Header

这些字段定义“这包规则在保护谁”：

1. `rule_packet_id`
2. `artifact_line_scope`
3. `prompt_object_type`
4. `prompt_object_id_field`
5. `shared_contract_fields`
6. `packet_version`
7. `consumer_scopes`

更稳的 Prompt packet header 可以固定为：

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

### 2.2 Rule Body

这些字段定义“具体怎样拒绝漂移”：

1. `rule_id`
2. `rule_kind`
3. `severity`
4. `consumer_scope`
5. `must_exist_fields`
6. `must_equal_fields`
7. `forbidden_proxy_patterns`
8. `evidence_refs`
9. `reject_reason`
10. `rewrite_target`
11. `rewrite_hint`

其中：

- `rule_kind` 只允许：
  - `hard_fail`
  - `lint_warn`
  - `reviewer_gate`
  - `handoff_reject`
  - `rewrite_hint`

## 3. Prompt Rule ABI 的五层语义

### 3.1 Hard Fail

直接阻止继续消费同一工件组：

1. `prompt_object_id` 缺失。
2. `prompt_object_id` 跨工件不一致。
3. `compiled_request_diff_ref` 缺失。
4. `lawful_forgetting_abi_ref` 缺失。
5. handoff 缺 `next_step_guard`。

### 3.2 Lint Warn

允许继续，但明确提示 drift 正在发生：

1. 宿主卡正文被原文 prompt 大段文本占满。
2. CI 附件只有 `pass/fail` 或 token 图。
3. 评审卡结论句多于对象锚点。
4. 交接包摘要多于 `current_object`。

### 3.3 Reviewer Gate

规定评审顺序，不允许结论先于对象：

1. `authority_source`
2. `assembly_path`
3. `compiled_request_diff_ref`
4. `stable_bytes_ledger_ref`
5. `lawful_forgetting_abi_ref`
6. `next_step_guard`
7. `review_judgement`

### 3.4 Handoff Reject

交接时一票否决：

1. 只有 transcript / summary，没有 `current_object`。
2. 没有 `lawful_forgetting_abi_ref`。
3. 没有 `next_step_guard`。
4. 需要通读全文才能继续。

### 3.5 Rewrite Hint

不只是报错，还要明确改哪里：

1. `rewrite_target: host_card`
   `rewrite_hint: 用 current_object 替代原文 prompt 主段`
2. `rewrite_target: ci_attachment`
   `rewrite_hint: 补 compiled_request_diff_ref 与 stable_bytes_ledger_ref`
3. `rewrite_target: review_card`
   `rewrite_hint: judgement 必须回链到 authority_source 与 assembly_path`
4. `rewrite_target: handoff_package`
   `rewrite_hint: 摘要前置必须让位于 lawful_forgetting_abi_ref 与 next_step_guard`

## 4. 最小 Prompt Rule Packet 样例

```yaml
rules:
  - rule_id: P-HF-001
    rule_kind: hard_fail
    severity: critical
    consumer_scope: cross_artifact
    must_equal_fields:
      - prompt_object_id
      - artifact_line_id
    reject_reason: shared_object_mismatch
    rewrite_target: artifact_group
    rewrite_hint: 统一四类工件的 prompt_object_id，再继续评审

  - rule_id: P-HF-002
    rule_kind: hard_fail
    severity: critical
    consumer_scope: ci_attachment
    must_exist_fields:
      - compiled_request_diff_ref
      - stable_bytes_ledger_ref
    reject_reason: missing_compiled_request_evidence
    rewrite_target: ci_attachment
    rewrite_hint: 补充 diff 与 stable bytes 证据，不得只给绿灯

  - rule_id: P-LW-001
    rule_kind: lint_warn
    severity: warning
    consumer_scope: host_card
    forbidden_proxy_patterns:
      - raw_prompt_primary_body
      - summary_as_current_object
    reject_reason: host_card_reverted_to_raw_prompt
    rewrite_target: host_card
    rewrite_hint: 改写为 current_object + authority_source + next_step_guard

  - rule_id: P-RG-001
    rule_kind: reviewer_gate
    severity: high
    consumer_scope: review_card
    must_exist_fields:
      - authority_source
      - assembly_path
      - compiled_request_diff_ref
    reject_reason: review_without_object_anchor
    rewrite_target: review_card
    rewrite_hint: judgment 之前先写对象锚点

  - rule_id: P-HR-001
    rule_kind: handoff_reject
    severity: critical
    consumer_scope: handoff_package
    must_exist_fields:
      - lawful_forgetting_abi_ref
      - current_object
      - next_step_guard
    reject_reason: summary_only_handoff
    rewrite_target: handoff_package
    rewrite_hint: 交接必须先交 ABI，再交摘要
```

## 5. 为什么 Prompt Rule ABI 必须继续围绕 shared object continuity

因为 Prompt 真正有魔力的地方，不是：

- system prompt 文案更玄

而是：

- 不同消费者能持续判断自己还在围绕同一 `compiled request object` 工作

如果这套规则 ABI 围绕的不是 shared object continuity：

1. 宿主卡会重新退回原文崇拜。
2. CI 附件会重新退回通过结果。
3. 评审卡会重新退回总结判断。
4. handoff package 会重新退回 transcript archaeology。

## 6. 最小接法

如果你要最小化接入 Prompt rule ABI，建议按下面顺序做：

1. 先固定 `packet_header`。
2. 再把 `hard_fail` 接到跨工件一致性检查。
3. 再把 `lint_warn` 接到宿主、CI、评审各自 projection。
4. 再把 `reviewer_gate` 接到评审顺序控制。
5. 最后把 `handoff_reject` 与 `rewrite_hint` 接到交接与修复动作。

## 7. 一句话总结

Prompt Artifact Rule ABI 真正统一的，不是不同消费者的校验风格，而是它们依赖的同一套 shared object continuity 与同一套拒收语义。
