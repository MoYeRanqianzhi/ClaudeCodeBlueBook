# Prompt 宿主验收协议：message lineage、projection consumer、protocol transcript 与 continuation qualification

Claude Code 当前没有公开一份单独名为 `PromptAcceptanceContract` 的对象，但宿主、SDK、CI 与交接系统已经可以围绕一条更稳的 contract chain 验收 Prompt 世界：

1. `message lineage`
2. `projection consumer`
3. `section registry + stable prefix boundary`
4. `protocol transcript`
5. `continuation object`
6. `continuation qualification`

`compiled request truth` 在这里最多只保留为旧总称；它不再适合作为一级 contract 主语。

更准确地说，宿主验收的不是 `systemPrompt` 输入，而是 request compiler 交出的 rule surface。

## 0. 关键源码锚点

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:343-347`
- `claude-code-source-code/src/constants/prompts.ts:560-576`
- `claude-code-source-code/src/utils/api.ts:136-150`
- `claude-code-source-code/src/utils/api.ts:321-405`
- `claude-code-source-code/src/services/api/claude.ts:1374-1485`
- `claude-code-source-code/src/services/api/claude.ts:3218-3236`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:494-698`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/services/compact/compact.ts:330-711`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1407-1450`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1506-1531`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1735-1747`
- `claude-code-source-code/src/query/stopHooks.ts:257-331`
- `claude-code-source-code/src/query.ts:1258-1340`

## 1. 必须消费的 contract 对象

### 1.0 最短 host contract 对照

| canonical node | host 应直接消费 | 禁止替身 |
|---|---|---|
| `message lineage` | lineage ref / shared consumer surface | prompt 原文相似度 |
| `projection consumer` | display / model / SDK-control / handoff 的分层投影 | “统一 transcript” |
| `section registry + stable prefix boundary` | boundary 策略、prefix/dynamic hash、cache break | 文案目录感 |
| `protocol transcript` | normalized / repair / violation / orphan/duplicate counters | UI transcript 或原始消息数 |
| `continuation object + qualification` | compact object、baseline reset、qualification gate | 最后一条消息、`stop_reason`、summary |

### 1.1 `message lineage`

宿主至少应显式消费：

1. `message_lineage_ref`
2. `lineage_kernel_integrity`
3. `request_object_id_legacy`
4. `shared_consumer_surface`

这些字段回答的不是：

- prompt 长得像不像以前

而是：

- 当前到底是哪一条世界线在被宿主、CI、评审与交接共同消费

### 1.2 `projection consumer`

Prompt 验收还必须显式消费：

1. `display_consumer_ref`
2. `model_api_consumer_ref`
3. `sdk_control_consumer_ref`
4. `handoff_resume_consumer_ref`
5. `projection_consumer_alignment`

这说明宿主当前消费的不是一份模糊 transcript，而是：

- 同一条 lineage 在不同 consumer 前的合法读法

### 1.3 `section registry + stable prefix boundary`

Prompt 验收还必须显式消费：

1. `section_name`
2. `cache_break`
3. `zone(static|dynamic)`
4. `content_hash`
5. `reset_scope(clear|compact|worktree-switch)`
6. `boundary_present`
7. `static_prefix_hash`
8. `dynamic_suffix_hash`
9. `prefix_block_count`
10. `boundary_strategy`

这说明宿主当前消费的不是：

- 一串 prompt 文案

而是：

- `section registry + stable prefix boundary` 共同组成的规则面

### 1.4 `protocol transcript`

Prompt 验收必须独立消费：

1. `normalized_message_count`
2. `virtual_filtered_count`
3. `repair_required`
4. `strict_violation`
5. `orphan_tool_result_count`
6. `duplicate_tool_use_count`
7. `empty_assistant_placeholder_count`

原因不是 transcript 字段更多，而是：

- 模型真正消费的是 rewrite 后的协议 transcript，而不是 raw transcript

### 1.5 `continuation object` 与 `qualification`

Prompt 验收还必须消费：

1. `compact_trigger`
2. `pre_tokens`
3. `preserved_segment`
4. `baseline_reset_applied`
5. `post_compact_cleanup_applied`
6. `continuation_object_ref`
7. `continuation_qualification`
8. `pending_action_ref`

这回答的不是：

- compact 有没有发生
- 这轮有没有停下来

而是：

- compact 之后系统是否仍可继续
- 当前继续资格是否仍由正式 gate 决定

## 2. reject verdict：必须共享的拒收语义

更成熟的 Prompt 宿主 reject verdict 至少应共享下面枚举：

1. `lineage_kernel_shadowed`
2. `projection_consumer_split_detected`
3. `missing_section_registry`
4. `boundary_missing_or_reordered`
5. `protocol_transcript_conflated_with_display`
6. `summary_only_handoff`
7. `continuation_object_missing`
8. `continuation_qualification_missing`
9. `post_compact_baseline_not_reset`

这些 reject verdict 的价值在于：

- 把“像成功”的替身翻译成宿主、CI、评审与交接都能共享的拒收语义

## 3. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. raw `systemPrompt` 长字符串
2. `last message`
3. raw transcript line count
4. cache token drop
5. summary text
6. spinner / working UI
7. rewrite 实现细节
8. stop hook 内部计数器

它们可以是观察信号，但不能是验收对象。

## 4. 验收顺序建议

更稳的顺序是：

1. 先验 `message lineage`
2. 再验 `projection consumer`
3. 再验 `section registry + stable prefix boundary`
4. 再验 `protocol transcript`
5. 再验 `continuation object`
6. 最后验 `continuation qualification`

不要反过来做：

1. 不要先看 token 曲线。
2. 不要先看 summary。
3. 不要先看 `stop_reason`。

## 5. 一句话总结

Claude Code 的 Prompt 宿主验收协议，不是 system prompt 字符串 API，而是 `message lineage + projection consumer + section registry + protocol transcript + continuation object + continuation qualification` 共同组成的规则面。
