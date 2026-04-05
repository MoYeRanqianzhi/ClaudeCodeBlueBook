# Prompt宿主接入审读手册：输入面、section breakdown、cache break可解释性与continue qualification排查

这一章不再解释 Prompt 宿主消费面为什么重要，而是把它压成一张可持续执行的宿主接入审读手册。

它主要回答五个问题：

1. 团队怎样知道宿主当前仍在围绕同一个 Prompt 编译对象消费，而不是退回字符串崇拜。
2. 哪些症状最能暴露 section breakdown 被误读、cache break 被黑箱化、continue qualification 被误判。
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

- 宿主当前仍在围绕同一个 compiled request truth 的正式投影消费 Prompt 世界

所以这层审读最先要看的不是：

- 页面长得像不像接好了

而是：

1. Prompt 输入面是否仍只是输入面。
2. section breakdown 是否仍被理解成运行时注册表。
3. cache break 是否仍可被正式解释。
4. continue qualification 是否仍围绕正式投影判断。

## 2. 回归症状

看到下面信号时，应提高警惕：

1. 宿主开始把 `systemPrompt` 当成唯一真相。
2. `section breakdown` 被拿来当目录展示，而不是 cache/stability 投影。
3. cache miss 发生后，只剩“最近变贵了”的说法。
4. 状态判断开始依赖最后一条消息或裸 `stop_reason`。
5. compact 之后交接只剩 summary，看不到继续资格与 boundary。

## 3. 每轮检查点

每次宿主接入变更后，至少逐项检查：

1. `input surface continuity`
   - 宿主是否仍把 `systemPrompt / appendSystemPrompt / agents / promptSuggestions` 当输入面，而不是编译真相本体。
2. `section breakdown continuity`
   - 宿主是否仍区分 stable / dynamic / uncached section，而不是退回文案目录。
3. `cache break explainability continuity`
   - cache break 是否仍能解释到具体 system/tool/model/beta/extraBody 变化。
4. `protocol truth continuity`
   - 宿主是否仍把 raw transcript 与 protocol truth 分层消费。
5. `continue qualification continuity`
   - 宿主是否仍围绕 `result + session_state_changed + summaries + Context Usage` 判断继续资格。

## 4. 直接拒收条件

出现下面情况时，应直接拒收：

1. 宿主把 `systemPrompt` 字符串当成唯一编译真相。
2. `section breakdown` 被误消费成展示目录，不再承担稳定边界语义。
3. cache break 只剩 token 变化，没有正式 break reason。
4. 宿主用最后一条消息或 `stop_reason` 充当主状态机。
5. compact / handoff 后只剩 summary，不剩继续资格与 boundary 投影。

## 5. 最小演练集

每轮至少跑下面五个宿主演练：

1. 只改 dynamic section
   - 确认宿主不会误判 stable prefix 全部失效。
2. 只改 tool schema
   - 确认宿主能把 drift 解释到 ABI 漂移，而不是归咎 prompt 文案。
3. compact 后继续
   - 确认宿主仍能正确显示 summary、boundary 与继续资格。
4. stop hook 阻断继续
   - 确认宿主不会继续把会话误标为正常运行。
5. requires_action -> idle
   - 确认宿主围绕正式 state 投影切换，而不是靠 message heuristic。

## 6. 复盘记录最少字段

每次 Prompt 宿主 drift 至少记录：

1. `request_object_id`
2. `prompt_input_surface`
3. `section_projection`
4. `cache_break_reason`
5. `continue_qualification_surface`
6. `raw_vs_protocol_gap`
7. `symptom`
8. `reject_reason`
9. `recovery_action`

## 7. 防再发动作

更稳的防再发顺序是：

1. 先把 `systemPrompt` 降回输入面。
2. 先把 section breakdown 与 stable boundary 语义补回主视图。
3. 先把 cache break reason 提升为正式字段。
4. 先把 continue qualification 从 heuristics 拉回正式状态投影。
5. 最后才补更多展示或前端润色。

## 8. 苏格拉底式检查清单

在你准备宣布“Prompt 宿主接入已经稳定”前，先问自己：

1. 宿主消费的是 compiled request truth 的投影，还是一段 prompt 字符串。
2. 当前 `section breakdown` 是运行时注册表投影，还是文案目录。
3. cache miss 是被正式解释了，还是仍然停在黑箱成本。
4. 当前继续资格是被正式判断了，还是被最后一条消息猜出来的。
5. 如果内部 compiler 重构，宿主是否仍能继续工作。

## 9. 一句话总结

真正成熟的 Prompt 宿主接入审读，不是看页面显示了多少 prompt 信息，而是持续证明宿主仍在消费同一个 compiled request truth 的正式投影。
