# Prompt宿主验收协议：compiled request truth、section registry、protocol transcript health与continue qualification

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象让宿主、SDK、CI 与交接系统验收 Prompt 世界。
2. 哪些字段属于必须消费的 `compiled request truth`，哪些属于 reject 语义，哪些仍然不应被绑定成公共 ABI。
3. 为什么 Prompt 验收不应退回 `systemPrompt` 字符串、cache hit 曲线与 `stop_reason`。
4. 宿主开发者该按什么顺序验收这套 Prompt 规则面。
5. 哪些现象一旦出现应被直接拒收，而不是继续灰度。

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

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `PromptAcceptanceContract`

的单独公共对象。

但 Prompt 宿主验收实际上已经能围绕四类正式对象稳定成立：

1. `compiled_request_truth`
2. `section_registry_snapshot`
3. `protocol_transcript_health`
4. `continue_qualification`

更成熟的验收方式不是：

- 只看 system prompt 截图
- 只看 token 或 cache hit 曲线
- 只看最后一条消息

而是：

- 围绕这四类对象消费 Prompt 世界是否仍然成立

## 2. compiled request truth：最小验收对象

宿主应至少围绕下面对象验收 Prompt 真相：

1. `request_object_id`
2. `system_blocks_hash`
3. `tool_schemas_hash`
4. `model`
5. `betas`
6. `query_source`
7. `global_cache_strategy`
8. `extra_body_hash`

这些字段回答的不是：

- prompt 长得像不像以前

而是：

- 模型这次真正被编译进去了什么世界

## 3. section registry 与 stable prefix 边界

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

## 4. protocol transcript health：不能退回 raw transcript

Prompt 验收必须独立消费：

1. `normalized_message_count`
2. `virtual_filtered_count`
3. `repair_required`
4. `strict_violation`
5. `orphan_tool_result_count`
6. `duplicate_tool_use_count`
7. `empty_assistant_placeholder_count`

原因不是：

- transcript 字段更多更完整

而是：

- 模型真正消费的是 rewrite 后的协议 transcript，而不是 raw transcript

## 5. lawful forgetting 与 continue qualification

Prompt 验收还必须消费：

### 5.1 lawful forgetting object

1. `compact_trigger`
2. `pre_tokens`
3. `preserved_segment`
4. `baseline_reset_applied`
5. `post_compact_cleanup_applied`
6. `handoff_ready`

### 5.2 continue qualification

1. `decision(continue|stop|requires_action)`
2. `reason`
3. `source(api_error|stop_hook|token_budget|max_output_recovery|compact_recovery)`
4. `retryable`
5. `pending_action_ref`

这两组对象回答的不是：

- compact 有没有发生
- 这轮有没有停下来

而是：

- lawful forgetting 之后系统是否仍可继续
- 当前继续资格是否仍由正式 gate 决定

## 6. reject reason：必须共享的拒收语义

更成熟的 Prompt 宿主 reject reason 至少应共享下面枚举：

1. `raw_sysprompt_authority`
2. `missing_section_registry`
3. `boundary_missing_or_reordered`
4. `compiled_request_drift_unexplained`
5. `transcript_repair_required`
6. `summary_only_handoff`
7. `continue_state_inconsistent`
8. `post_compact_baseline_not_reset`

这些 reject reason 的价值在于：

- 把“像成功”的替身翻译成宿主、CI、评审与交接都能共享的拒收语义

## 7. 不应直接绑定为公共 ABI 的对象

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

## 8. 验收顺序建议

更稳的顺序是：

1. 先验 `compiled_request_truth`
2. 再验 `section_registry_snapshot`
3. 再验 `protocol_transcript_health`
4. 再验 `lawful_forgetting_object`
5. 最后验 `continue_qualification`

不要反过来做：

1. 不要先看 token 曲线。
2. 不要先看 summary。
3. 不要先看 `stop_reason`。

## 9. 一句话总结

Claude Code 的 Prompt 宿主验收协议，不是 system prompt 字符串 API，而是 `compiled request truth + section registry + protocol transcript health + continue qualification` 共同组成的规则面。
