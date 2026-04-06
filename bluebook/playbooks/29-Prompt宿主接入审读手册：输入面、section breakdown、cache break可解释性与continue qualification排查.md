# Prompt宿主接入审读手册：message lineage、projection consumer、protocol transcript与continuation qualification排查

这一章不再解释 Prompt 宿主消费面为什么重要，而是把它压成一张可持续执行的宿主接入审读手册。

它主要回答五个问题：

1. 团队怎样知道宿主当前仍在围绕同一条 `message lineage` 的正式投影消费 Prompt 世界，而不是退回字符串崇拜。
2. 哪些症状最能暴露 projection consumer 被误写、cache break 被黑箱化、`continuation qualification` 被误判。
3. 哪些检查点最适合作为宿主接入门禁，而不是靠资深 reviewer 心法。
4. 哪些宿主消费方式必须直接拒收，而不是留给后续前端修补。
5. 怎样用苏格拉底式追问避免把这层写成“再做一次前端联调”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:343-347`
- `claude-code-source-code/src/constants/prompts.ts:560-576`
- `claude-code-source-code/src/utils/api.ts:119-150`
- `claude-code-source-code/src/utils/api.ts:321-405`
- `claude-code-source-code/src/services/api/claude.ts:1374-1485`
- `claude-code-source-code/src/services/api/claude.ts:3213-3236`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:470-698`
- `claude-code-source-code/src/query/stopHooks.ts:257-331`
- `claude-code-source-code/src/query.ts:1258-1340`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1407-1419`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1735-1746`

## 1. 第一性原理

对 Prompt 宿主接入来说，真正重要的不是：

- 宿主已经拿到了 `systemPrompt`
- 页面上已经显示了一些 token 数

而是：

- 宿主当前仍在围绕同一条 `message lineage` 的正式 projection 消费 Prompt 世界

所以这层审读最先要看的不是：

- 页面长得像不像接好了

而是：

1. Prompt 输入面是否仍只是输入面。
2. `message lineage` 是否仍是唯一主语。
3. projection consumer 是否仍分层。
4. cache break 是否仍可被正式解释。
5. `continuation qualification` 是否仍围绕正式状态投影判断。

## 2. 回归症状

看到下面信号时，应提高警惕：

1. 宿主开始把 `systemPrompt` 当成唯一真相。
2. `section breakdown` 被拿来当目录展示，而不是 boundary projection。
3. cache miss 发生后，只剩“最近变贵了”的说法。
4. 状态判断开始依赖最后一条消息或裸 `stop_reason`。
5. compact 之后交接只剩 summary，看不到继续资格与 boundary。

## 3. 每轮检查点

每次宿主接入变更后，至少逐项检查：

1. `message lineage continuity`
   - 宿主是否仍把 `systemPrompt / appendSystemPrompt / agents / promptSuggestions` 当输入面，而不是把它们当主对象。
2. `projection consumer continuity`
   - 宿主是否仍区分 display、protocol、SDK/control 与 handoff 这四类 consumer，而不是把它们混成一条历史。
3. `section boundary continuity`
   - 宿主是否仍把 stable / dynamic boundary 当成运行时边界，而不是退回文案目录。
4. `cache break explainability continuity`
   - cache break 是否仍能解释到具体 system / tool / model / beta / extraBody 变化。
5. `continuation qualification continuity`
   - 宿主是否仍围绕 `result + session_state_changed + summaries + Context Usage` 判断继续资格。

## 4. 直接拒收条件

出现下面情况时，应直接拒收：

1. 宿主把 `systemPrompt` 字符串当成唯一编译真相。
2. `message_lineage_ref` 缺失或被宿主自行拼接。
3. projection consumer 被混写成“统一 transcript”。
4. cache break 只剩 token 变化，没有正式 break reason。
5. 宿主用最后一条消息或 `stop_reason` 充当主状态机。
6. compact / handoff 后只剩 summary，不剩继续资格与 boundary 投影。

## 5. 最小演练集

每轮至少跑下面五个宿主演练：

1. 只改 dynamic section
   - 确认宿主不会误判 stable prefix 全部失效。
2. 只改 tool schema
   - 确认宿主能把 drift 解释到 ABI 漂移，而不是归咎 prompt 文案。
3. compact 后继续
   - 确认宿主仍能正确显示 summary、boundary 与 `continuation qualification`。
4. stop hook 阻断继续
   - 确认宿主不会继续把会话误标为正常运行。
5. requires_action -> idle
   - 确认宿主围绕正式 state projection 切换，而不是靠 message heuristic。

## 6. 复盘记录最少字段

每次 Prompt 宿主 drift 至少记录：

1. `message_lineage_ref`
2. `projection_consumer_alignment`
3. `section_boundary_projection`
4. `cache_break_reason`
5. `continuation_qualification_surface`
6. `raw_vs_protocol_gap`
7. `symptom`
8. `reject_reason`
9. `recovery_action`

## 7. 防再发动作

更稳的防再发顺序是：

1. 先把 `systemPrompt` 降回输入面。
2. 先把 `message lineage` 与 consumer 分层补回主视图。
3. 先把 section / boundary 的运行时语义补回主视图。
4. 先把 cache break reason 提升为正式字段。
5. 先把 `continuation qualification` 从 heuristics 拉回正式状态投影。
6. 最后才补更多展示或前端润色。

## 8. 苏格拉底式检查清单

在你准备宣布“Prompt 宿主接入已经稳定”前，先问自己：

1. 宿主消费的是同一条 `message lineage` 的投影，还是一段 prompt 字符串。
2. 当前 projection consumer 是运行时分层，还是展示分层。
3. cache miss 是被正式解释了，还是仍然停在黑箱成本。
4. 当前继续资格是被正式判断了，还是被最后一条消息猜出来的。
5. 如果内部 compiler 重构，宿主是否仍能继续工作。

## 9. 一句话总结

真正成熟的 Prompt 宿主接入审读，不是看页面显示了多少 prompt 信息，而是持续证明宿主仍在消费同一条 `message lineage` 的正式 projection。
