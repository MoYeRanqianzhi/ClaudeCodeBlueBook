# 请求装配控制面验证手册：message lineage、projection consumer、continuation qualification 与 cache-safe fork 回归

请求装配控制面验证真正要验证的，不是 Prompt 看起来更完整，而是下面这条对象链仍围绕同一条当前世界成立：

1. `message lineage`
2. `projection consumer`
3. `section registry`
4. `protocol transcript`
5. `continuation object`
6. `continuation qualification`
7. `cache-safe fork reuse`

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/systemPromptSections.ts:16-65`
- `claude-code-source-code/src/utils/systemPrompt.ts:28-123`
- `claude-code-source-code/src/utils/api.ts:321-405`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/utils/sessionStorage.ts:1025-1034`
- `claude-code-source-code/src/utils/sessionStorage.ts:2069-2128`
- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:188-327`
- `claude-code-source-code/src/query/stopHooks.ts:84-214`
- `claude-code-source-code/src/utils/forkedAgent.ts:46-126`

## 1. 第一性原理

对请求装配控制面来说，真正重要的不是：

- 当前 Prompt 看起来更完整

而是：

- `message lineage`、`projection consumer`、`section registry`、`protocol transcript`、`continuation object` 与 `continuation qualification` 仍围绕同一条当前世界成立

所以这层验证最先要看的不是文案，而是：

1. `lineage kernel continuity`
2. `projection consumer continuity`
3. `section registry continuity`
4. `protocol transcript continuity`
5. `continuation object continuity`
6. `continuation qualification continuity`
7. `cache-safe fork continuity`

## 2. 回归症状

看到下面信号时，应提高警惕：

1. 多份提示文本开始并行争主语。
2. display transcript 被直接当成模型真相。
3. compact 之后只剩摘要，没有继续对象。
4. side loop、worker、suggestion 各自重建“差不多的世界”。
5. display truth / protocol truth / SDK-control truth / handoff truth 不再围绕同一条 lineage。
6. cache break 只能被说成“模型突然变笨”，无法归因到 section、boundary 或 history。
7. `continuation qualification` 重新退回按钮状态与最后一条消息。

## 3. 每轮检查点

每次变更后，至少逐项检查：

1. `lineage kernel continuity`
   - `parentUuid / logicalParentUuid`、`message.id`、`tool_use_id / sourceToolAssistantUUID` 是否仍挂在同一条 lineage 上。
2. `projection consumer continuity`
   - display / protocol / SDK-control / handoff 是否仍只是同一条 lineage 的不同消费者。
3. `section registry continuity`
   - constitutional section、stable prefix 与动态边界是否仍清楚。
4. `protocol transcript continuity`
   - display transcript 与 protocol transcript 是否仍然分层，tool pairing 是否仍受正式保护。
5. `continuation object continuity`
   - compact、summary、resume 之后是否仍保住同一个继续对象。
6. `continuation qualification continuity`
   - 继续资格是否仍由同一条对象链裁定，而不是由展示替身裁定。
7. `cache-safe fork continuity`
   - side loop、worker、suggestion 与 stop hook 是否仍围绕同一 stable prefix 复用。

## 4. 直接拒收条件

出现下面情况时，应直接拒收：

1. `lineage_kernel_shadowed`
2. `projection_consumer_split_detected`
3. `section_registry_drifted`
4. `dynamic_boundary_leaked`
5. `protocol_transcript_conflated_with_display`
6. `tool_pairing_unattested`
7. `continuation_story_only`
8. `continuation_qualification_unbound`
9. `parallel_world_fork_detected`
10. `cache_break_unexplainable`

## 5. 复盘记录最少字段

每次 drift 至少记录：

1. `message_lineage_ref`
2. `lineage_kernel_integrity`
3. `projection_consumer_alignment`
4. `section_registry_generation`
5. `protocol_transcript_health`
6. `continuation_object_ref`
7. `continuation_qualification_ref`
8. `cache_safe_fork_reuse_state`
9. `symptom`
10. `reject_reason`
11. `rollback_object`

## 6. 防再发动作

更稳的防再发顺序是：

1. 先补 lineage kernel 与 projection consumer 的单一入口。
2. 先补 section / boundary 的法律地位。
3. 先补 `protocol transcript` 与 tool pairing 拒收。
4. 先补 `continuation object` 的 identity 与 `continuation qualification` 保全。
5. 最后才补文案润色或摘要说明。

## 7. 苏格拉底式检查清单

在你准备宣布“Prompt 控制面仍然健康”前，先问自己：

1. 当前世界到底由哪条 `message lineage` 在承载。
2. 模型此刻消费的是哪条 `protocol transcript`，哪个 consumer 只配看投影。
3. compact 之后我保住的是 `continuation object` 与 `continuation qualification`，还是叙事。
4. 旁路循环是在复用 stable prefix，还是在制造第二世界。
5. 这次 drift 我能否点名是 lineage、consumer、section、history、forgetting 还是 qualification 先失守。

## 8. 一句话总结

真正成熟的 Prompt 验证，不是看 system prompt 还在不在，而是持续证明 `message lineage`、`projection consumer`、`protocol transcript`、`continuation object`、`continuation qualification` 与 `cache-safe fork` 仍然围绕同一个当前世界成立。
