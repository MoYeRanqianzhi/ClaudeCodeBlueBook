# 请求装配控制面验证手册：authority chain、protocol transcript、continuation object与cache-safe fork回归

这一章不再解释 Prompt 魔力为什么成立，而是把 `architecture/82`、`philosophy/84` 与 `guides/99` 继续压成一张长期运行里的验证手册。

它主要回答五个问题：

1. 团队怎样知道当前仍在围绕同一条 `compiled request truth` 工作。
2. 哪些症状最能暴露请求装配控制面已经退回文案工程、摘要工程或平行世界工程。
3. 哪些检查点最适合作为持续回归门禁。
4. 哪些 drift 必须直接拒收，而不是继续补更长的解释材料。
5. 怎样用苏格拉底式追问避免把这层写成“Prompt 验证清单”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/systemPromptSections.ts:16-65`
- `claude-code-source-code/src/utils/systemPrompt.ts:28-123`
- `claude-code-source-code/src/utils/api.ts:321-405`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:188-327`
- `claude-code-source-code/src/query/stopHooks.ts:84-214`
- `claude-code-source-code/src/utils/forkedAgent.ts:46-126`

## 1. 第一性原理

对请求装配控制面来说，真正重要的不是：

- 当前 Prompt 看起来更完整

而是：

- authority、lineage、section、history、forgetting 与 continue 仍围绕同一个请求对象成立

所以这层验证最先要看的不是文案，而是：

1. authority chain continuity
2. message lineage continuity
3. section registry continuity
4. transcript legality continuity
5. continuation object continuity
6. cache-safe fork continuity

## 2. 回归症状

看到下面信号时，应提高警惕：

1. 多份提示文本开始并行争主语。
2. UI transcript 被直接当成模型真相。
3. compact 之后只剩摘要，没有继续对象。
4. side loop、worker、suggestion 各自重建“差不多的世界”。
5. display truth / protocol truth / handoff truth 不再围绕同一条 lineage。
6. cache break 只能被说成“模型突然变笨”，无法归因到 section、boundary 或 history。

## 3. 每轮检查点

每次变更后，至少逐项检查：

1. `authority chain continuity`
   - 当前世界是否仍由单一主权链宣布。
2. `message lineage continuity`
   - 当前 `compiled request truth`、projection consumer 与 continuation qualification 是否仍挂在同一条 lineage 上。
3. `section registry continuity`
   - constitutional section、stable prefix 与动态边界是否仍清楚。
4. `protocol transcript continuity`
   - display transcript 与 protocol transcript 是否仍然分层，tool pairing 是否仍受正式保护。
5. `continuation object continuity`
   - compact、summary、resume 之后是否仍保住同一个继续对象。
6. `cache-safe fork continuity`
   - side loop、worker、suggestion 与 stop hook 是否仍围绕同一 stable prefix 复用。

## 4. 直接拒收条件

出现下面情况时，应直接拒收：

1. `authority_chain_unbound`
2. `section_registry_drifted`
3. `dynamic_boundary_leaked`
4. `protocol_transcript_conflated_with_display`
5. `tool_pairing_unattested`
6. `continuation_object_missing`
7. `projection_consumer_split_detected`
8. `parallel_world_fork_detected`
9. `cache_break_unexplainable`

## 5. 复盘记录最少字段

每次 drift 至少记录：

1. `compiled_request_truth_id`
2. `message_lineage_ref`
3. `authority_chain`
4. `section_registry_generation`
5. `protocol_transcript_health`
6. `projection_consumer_alignment`
7. `continuation_object_ref`
8. `fork_reuse_status`
9. `symptom`
10. `reject_reason`
11. `rollback_object`

## 6. 防再发动作

更稳的防再发顺序是：

1. 先补 authority chain 与 message lineage 的单一入口。
2. 先补 section / boundary 的法律地位。
3. 先补 transcript compiler、projection consumer 与 tool pairing 拒收。
4. 先补 continuation object 的 identity 与 qualification 保全。
5. 最后才补文案润色或摘要说明。

## 7. 苏格拉底式检查清单

在你准备宣布“Prompt 控制面仍然健康”前，先问自己：

1. 当前世界到底是谁在定义，哪条 `message lineage` 在承载它。
2. 模型此刻消费的是哪条 transcript，哪个 consumer 只配看投影。
3. compact 之后我保住的是对象与继续资格，还是叙事。
4. 旁路循环是在复用世界，还是在制造第二世界。
5. 这次 drift 我能否点名是 authority、lineage、section、history、forgetting 还是 continue 先失守。

## 8. 一句话总结

真正成熟的 Prompt 验证，不是看 system prompt 还在不在，而是持续证明 authority chain、message lineage、protocol transcript、continuation object 与 cache-safe fork 仍然围绕同一个 `compiled request truth` 成立。
