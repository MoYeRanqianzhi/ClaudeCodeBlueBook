# 如何把 Prompt 宿主迁移失真压回 message lineage：固定纠偏顺序、拒收规则与模板骨架

Prompt 宿主迁移纠偏真正要救回的，不是更漂亮的截图、摘要与继续按钮，而是同一条可继续、可交接、可复核的对象链：

1. `message lineage`
2. `projection consumer`
3. `protocol transcript`
4. `stable prefix boundary`
5. `continuation object`
6. `continuation qualification`

`compiled request truth` 在这里最多只保留为旧总称，不再充当纠偏主语。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:343-347`
- `claude-code-source-code/src/constants/prompts.ts:560-576`
- `claude-code-source-code/src/utils/api.ts:321-405`
- `claude-code-source-code/src/services/api/claude.ts:1374-1485`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:247-666`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/services/compact/compact.ts:330-711`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1506-1531`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1735-1746`
- `claude-code-source-code/src/query/stopHooks.ts:257-331`
- `claude-code-source-code/src/query.ts:1223-1340`

## 1. 第一性原理

Prompt 迁移纠偏真正要拒绝的，不是页面偶尔不顺，而是展示替身重新篡位：

- system prompt 截图冒充 Prompt 真相
- compact summary 冒充 `lawful forgetting`
- raw transcript 冒充 `protocol transcript`
- cache hit 曲线冒充 drift explainability
- `stop_reason` 与最后一条消息冒充 `continuation qualification`

所以更稳的纠偏目标不是先把页面恢复正常，而是：

1. 先把输入面重新降回输入面。
2. 先把 section / boundary 恢复成正式编译对象。
3. 先把 raw / protocol 重新分层。
4. 先把 cache break reason 从黑箱成本里救出来。
5. 先把 `continuation qualification` 从 `stop_reason` 幻觉里救出来。

## 2. 固定纠偏顺序

### 2.1 先拆掉伪交接真相

先纠的不是页面，而是交接对象：

1. 禁止把 system prompt 截图充当 Prompt 真相。
2. 禁止把 compact summary 充当 lawful forgetting 真相。
3. 禁止把 raw transcript 充当模型世界。

最小恢复对象：

1. `truth_lineage_ref`
2. `section_registry_snapshot`
3. `stable_boundary_snapshot`
4. `protocol_rewrite_version`
5. `compact_boundary`
6. `preserved_segment`

### 2.2 再恢复 `message lineage`

第二步要把宿主重新拉回：

1. `truth_lineage_ref`
2. `lineage_kernel_integrity`
3. `request_object_id_legacy`
4. `shared_consumer_surface`
5. `lineage_restituted_at`

不要继续做的事：

1. 不要只看命中率。
2. 不要只看 token 成本。
3. 不要把“最近更贵了”当 explainability。

### 2.3 再恢复 `projection consumer` 与 `protocol transcript`

第三步要修的是：

1. display / protocol / SDK-control / handoff 是否仍只是同一条 lineage 的不同 consumer。
2. `normalizeMessagesForAPI()` 的协议投影。
3. `ensureToolResultPairing()` 的 pairing 健康度。
4. raw history 与 `protocol transcript` 的边界。

只要这一步没修好，后面的交接、灰度、回退都仍会围绕错误历史工作。

### 2.4 再恢复 `stable prefix boundary`

第四步要把共享前缀从安静曲线里救回：

1. `stable_prefix_boundary`
2. `section_registry_generation`
3. `cache_strategy_snapshot`
4. `cache_break_reason`
5. `cache_break_threshold`

这一步的目标不是更省 token，而是更可解释、更可复用。

### 2.5 最后恢复 `continuation object` 与 `qualification`

最后才修：

1. `lawful_forgetting_boundary`
2. `continuation_object_ref`
3. `preserved_segment`
4. `next_step`
5. `continuation_qualification`
6. `prevent_continuation_reason`

不要反过来：

1. 不要先修“继续”按钮，再修 boundary。
2. 不要先修 `stop_reason` 展示，再修 qualification。

## 3. 硬拒收规则

出现下面情况时，应直接拒收当前 Prompt 宿主实现：

1. `screenshot_as_truth`
2. `summary_as_boundary`
3. `raw_transcript_as_model_truth`
4. `lineage_kernel_shadowed`
5. `projection_consumer_split_detected`
6. `protocol_transcript_conflated_with_display`
7. `cache_break_reason_missing`
8. `continuation_qualification_missing`
9. `last_message_as_gate`

## 4. 模板骨架

### 4.1 交接模板骨架

1. `truth_lineage_ref`
2. `lineage_kernel_integrity`
3. `section_registry_snapshot`
4. `stable_boundary_snapshot`
5. `protocol_rewrite_version`
6. `cache_strategy_snapshot`
7. `cache_break_reason`
8. `compact_boundary`
9. `continuation_object_ref`
10. `continuation_qualification`

### 4.2 灰度模板骨架

1. `stage`
2. `lineage_delta`
3. `projection_gap`
4. `protocol_gap`
5. `cache_break_reason`
6. `boundary_gap`
7. `qualification_gap`
8. `stop_condition`

### 4.3 回退模板骨架

1. `rollback_trigger`
2. `rollback_object`
3. `lineage_before`
4. `lineage_after`
5. `re_entry_condition`
6. `reject_reason`

## 5. 苏格拉底式检查清单

在你准备宣布“Prompt 失真已经纠偏完成”前，先问自己：

1. 我救回的是 `message lineage`，还是只救回了展示。
2. 我现在交接的是 boundary 和 `protocol transcript`，还是截图与摘要。
3. cache drift 在我的系统里是有原因的，还是仍然只有曲线。
4. 当前继续资格在我的系统里是正式 gate，还是最后一条消息。
5. later 团队是否已经不再需要作者口述来继续工作。

## 6. 一句话总结

真正成熟的 Prompt 纠偏，不是把几个字段补全，而是把截图交接、黑箱灰度与继续资格幻觉重新压回同一条 `message lineage`。
