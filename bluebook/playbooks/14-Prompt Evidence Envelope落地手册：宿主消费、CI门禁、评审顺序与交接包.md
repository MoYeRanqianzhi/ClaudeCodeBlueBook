# Prompt Evidence Envelope落地手册：message lineage、protocol transcript、lawful forgetting与handoff包

这一章不再解释 Prompt evidence envelope 应该长什么样，而是把它压成宿主、CI、评审与交接都能直接执行的一套落地手册。

它主要回答五个问题：

1. Prompt 线真正的 host implementation playbook 到底该检查什么。
2. 宿主、CI、评审与交接分别必须消费哪些信号，哪些属于硬门禁，哪些属于软检查点。
3. 怎样避免 Prompt 再次退回成“原文 prompt + token 指标 + 作者总结”的拼贴。
4. 怎样把 `message lineage`、`protocol transcript`、`lawful forgetting boundary` 与 `continuation object` 接成同一流程。
5. 怎样用苏格拉底式追问避免把这章写成纯 checklist。

## 0. 改写前状态

没有 Prompt host implementation playbook 的团队，最常见状态是：

1. 宿主只显示 prompt 原文或最终输出。
2. CI 只看 cache hit / token 曲线。
3. 评审只读作者总结和部分 diff。
4. 交接依赖 transcript 和口头说明。
5. 一旦 Prompt 失稳，团队重新退回文案崇拜。

## 1. 目标状态

迁移后的目标不是：

- 给 Prompt 再补一层看板

而是：

1. 宿主消费同一条 `message lineage` 的 host-facing projection。
2. CI 消费 `protocol transcript`、stable prefix 与 cache break explainability。
3. 评审先看 lineage kernel、projection consumer 与 boundary，再看解释。
4. 交接先看 `lawful forgetting boundary` 与 `continuation object`，再看历史。
5. 四类角色围绕同一套 Prompt envelope 骨架判断。

## 2. 最小落地 diff

### 改写前

```text
宿主:
- 展示 prompt 原文

CI:
- 看 token / cache 指标

评审:
- 读作者总结

交接:
- 读 transcript
```

### 改写后

```text
宿主:
- 展示 message lineage / pending action / current work / next-step guard

CI:
- 检查 protocol transcript / stable prefix boundary / cache-break reason

评审:
- 先看 lineage kernel / projection consumer / dynamic boundary

交接:
- 先看 lawful forgetting boundary / continuation object / rollback boundary
```

### 这段 diff 的意义

真正的变化不是：

- 多了几个字段

而是：

- Prompt 证据终于从“材料集合”变成“角色化消费顺序”

## 3. 角色检查点

### 3.1 宿主最小检查点

宿主至少必须消费：

1. `message_lineage_ref`
2. 当前 `pending_action`
3. `current_work`
4. `next_step_guard`
5. `continuation_qualification`
6. `rollback_boundary`

硬要求：

- 不能只显示 prompt 原文或 assistant 输出。

### 3.2 CI 最小检查点

CI 至少必须检查：

1. `protocol_transcript_health`
2. `stable_prefix_boundary`
3. `cache_break_reason`
4. `tool_pairing_health`
5. `lawful_forgetting_boundary`

硬门禁：

1. `message_lineage_ref_missing`
2. `protocol_transcript_conflated_with_display`
3. `stable_prefix_boundary_missing`
4. `cache_break_unexplainable`
5. `lawful_forgetting_boundary_missing`

### 3.3 评审最小检查点

评审至少必须先看：

1. `lineage_kernel_integrity`
2. `projection_consumer_alignment`
3. `section_registry_snapshot`
4. `dynamic_boundary`
5. `lawful_forgetting_boundary`

软检查点：

- 总结是否准确解释这些字段
- 原文 prompt 改动是否与 `protocol transcript` 漂移一致

禁止事项：

- 只读作者总结就做 Prompt 结论。

### 3.4 交接最小检查点

交接至少必须交付：

1. `current_work`
2. `pending_action`
3. `next_step_guard`
4. `required_assets`
5. `rollback_boundary`
6. `continuation_qualification`
7. `lawful_forgetting_boundary`

硬要求：

- 交接不能只给 transcript 链接或 summary prose。

## 4. 统一检查顺序

Prompt 线四类角色更稳的统一顺序是：

1. `message lineage`
2. `projection consumer`
3. `protocol transcript`
4. `stable prefix boundary`
5. `cache break explainability`
6. `lawful forgetting boundary`
7. `continuation object`

## 5. Prompt 线硬门禁

下面这些最适合写成硬门禁：

1. `lineage_kernel_shadowed`
2. `projection_consumer_split_detected`
3. `protocol_transcript_conflated_with_display`
4. `tool_pairing_unattested`
5. `cache_break_unexplainable`
6. `continuation_story_only`
7. `continuation_qualification_missing`

## 6. 回退与交接包

当 Prompt 线需要回退时，至少保留：

1. `message_lineage_ref`
2. `protocol_transcript_health`
3. `stable_prefix_boundary`
4. `cache_break_reason`
5. `continuation_object_ref`
6. `rollback_boundary`

回退优先级：

1. 先回退 lineage / consumer / boundary。
2. 再回退 protocol transcript 与 tool pairing。
3. 最后才考虑整份原文 prompt。

## 7. 苏格拉底式追问

在你准备宣布 Prompt host implementation 已落地前，先问自己：

1. 宿主、CI、评审与交接是不是都先围绕同一条 `message lineage` 判断。
2. 我保住的是 `protocol transcript` 与 `lawful forgetting boundary`，还是只保住了 prompt 原文。
3. 任何一个角色现在还能不能只靠原文 prompt 就继续下结论。
4. 如果今天交接，这套包能否在不读全文的前提下继续工作。
