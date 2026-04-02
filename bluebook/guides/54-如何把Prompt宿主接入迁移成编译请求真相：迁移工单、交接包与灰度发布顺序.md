# 如何把Prompt宿主接入迁移成编译请求真相：迁移工单、交接包与灰度发布顺序

这一章不再解释 Prompt 宿主接入该怎样审读，而是把 Claude Code 式 Prompt 迁移压成一张可执行的宿主迁移工单。

它主要回答五个问题：

1. 为什么 Prompt 迁移真正要迁的不是一段 prompt 文案，而是 `compiled request truth`。
2. 怎样把 `section registry`、`protocol rewrite`、`cache explainability`、`lawful forgetting` 与 `continue qualification` 写成固定实施顺序。
3. 怎样把交接从“这轮大概在做什么”升级成正式交接包。
4. 怎样安排灰度发布，避免宿主先学会继续，却还没学会解释为什么能继续。
5. 怎样用苏格拉底式追问避免把迁移写成“照抄 system prompt”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:560-576`
- `claude-code-source-code/src/utils/api.ts:119-150`
- `claude-code-source-code/src/utils/api.ts:321-405`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/services/api/claude.ts:1374-1485`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:247-666`
- `claude-code-source-code/src/services/compact/prompt.ts:293-374`
- `claude-code-source-code/src/services/compact/compact.ts:330-711`
- `claude-code-source-code/src/query/stopHooks.ts:84-98`
- `claude-code-source-code/src/query/stopHooks.ts:257-331`
- `claude-code-source-code/src/query.ts:1065-1340`
- `claude-code-source-code/src/utils/sessionState.ts:92-134`

## 1. 第一性原理

Prompt 宿主迁移真正要迁的不是：

- `systemPrompt` 文本
- token 数字
- compact 摘要

而是：

- 模型真正消费的同一个 `compiled request truth`

所以更稳的迁移目标不是：

- 让宿主“也能看到一些 prompt 信息”

而是：

1. 宿主知道哪些对象只是输入面。
2. 宿主知道哪些对象属于协议真相。
3. 宿主知道 cache break 为什么发生。
4. 宿主知道 compact 后什么仍然必须活着。
5. 宿主知道当前为什么还能继续，什么时候必须停。

## 2. 先识别旧宿主还在消费什么

在开始迁移前，先判断旧宿主是否仍在消费这些假信号：

1. `systemPrompt` 被当成唯一真相。
2. raw transcript 被直接送进模型或直接被当成交接真相。
3. cache miss 只剩“这轮更贵了”，没有正式 break reason。
4. compact 之后只剩 summary，看不到 boundary、attachments 与 next step。
5. continue 仍主要靠 `stop_reason`、最后一条消息或人工猜测。

如果这些症状还在，迁移顺序就不能从“展示层升级”开始，而应先从真相对象收口开始。

## 3. 迁移工单顺序

### 3.1 先冻结输入面与 section 投影

第一张工单要做的不是搬 prompt 文案，而是明确：

1. `systemPrompt / appendSystemPrompt / agents / promptSuggestions` 只是输入面。
2. `section registry + stable boundary` 才是 Prompt 编译链的制度边界。
3. 宿主必须有一处只读投影能看见 stable / dynamic / uncached section。

最小交付物：

1. 输入面清单。
2. section projection 视图。
3. 唯一 compiled request truth producer 的归属说明。

### 3.2 再补 protocol rewrite gate

第二张工单要补的不是更多消息展示，而是：

1. 宿主明确区分 UI transcript 与 API transcript。
2. `normalizeMessagesForAPI()` 和 `ensureToolResultPairing()` 的结果成为正式消费面。
3. raw transcript 与 protocol transcript 的 diff 至少能被 shadow 观测。

最小交付物：

1. raw/protocol 对照视图。
2. orphan / duplicate / invalid pairing 的拒收说明。
3. 交接与 CI 默认消费 protocol truth，而不是显示层历史。

### 3.3 再补 stable prefix ledger 与 cache explainability

第三张工单要补的不是 token 图表，而是：

1. `tool schema / beta headers / body params / section drift` 的正式 break reason。
2. stable prefix 是否仍连续成立。
3. 哪一次变更打碎了缓存边界。

最小交付物：

1. `cache_break_reason`
2. `stable_boundary_snapshot`
3. `request_object_id`

### 3.4 再补 lawful forgetting 交接对象

第四张工单要补的不是“更短摘要”，而是：

1. compact boundary
2. preserved segment
3. attachments / metadata relink
4. next step 与 current work

最小交付物：

1. compact 交接包模板。
2. compact 后仍可见的 boundary 与 next step。
3. compact / handoff / resume 共用的 continuation object。

### 3.5 最后才放开 continue qualification

第五张工单要补的是：

1. stop hook blocking
2. prompt-too-long recovery
3. max-output continuation
4. `session_state_changed + pending_action + Context Usage` 的继续资格投影

最小交付物：

1. `continue_qualification`
2. `prevent_continuation_reason`
3. `object_upgrade_recommendation`

不要反过来做：

1. 不要先放开“继续”按钮，再补 continue reason。
2. 不要先让 compact 上线，再补 lawful forgetting 对象。
3. 不要先让 token 仪表盘上线，再补 cache break explainability。

## 4. 交接包最小字段

Prompt 宿主迁移后的交接包至少要有：

1. `request_object_id`
2. `prompt_input_surface`
3. `section_registry_snapshot`
4. `stable_boundary_snapshot`
5. `protocol_rewrite_version`
6. `cache_break_reason`
7. `compact_boundary`
8. `preserved_assets`
9. `next_step`
10. `continue_qualification`
11. `reject_reason`

少了这些字段，交接就仍会退回：

- 一段摘要
- 一句“这轮看起来还能继续”

## 5. 灰度发布顺序

更稳的 Prompt 灰度顺序是：

1. `read-only input + section projection`
   - 先让宿主看见输入面与 section law，但不授予控制权。
2. `protocol rewrite shadow`
   - 先 shadow 观测 raw/protocol 差异，不立刻切主路径。
3. `cache explainability shadow`
   - 先让宿主解释 break reason，再让它依赖缓存指标做判断。
4. `lawful forgetting handoff`
   - 先灰度 compact 交接包与 boundary 投影。
5. `continue qualification gate`
   - 最后才让宿主围绕正式 continue qualification 控制继续与升级对象。

最危险的错误顺序是：

1. 先做摘要交接。
2. 先做继续按钮。
3. 最后才补协议真相与 cache break explainability。

这会直接制造：

- 黑箱继续
- 黑箱缓存
- 黑箱交接

## 6. 直接拒收条件

出现下面情况时，应直接拒收迁移版本：

1. 宿主仍把 `systemPrompt` 字符串当唯一真相。
2. raw transcript 仍直接充当模型输入或交接真相。
3. cache miss 没有正式 break reason。
4. compact 后只剩 summary，不剩 boundary、assets 与 next step。
5. continue 仍主要靠 `stop_reason` 或最后一条消息判断。

## 7. 苏格拉底式检查清单

在你准备宣布“Prompt 宿主迁移已经完成”前，先问自己：

1. 我迁移的是 compiled request truth，还是一段 prompt 文案。
2. 宿主消费的是 protocol truth，还是显示层历史。
3. cache 失稳时，我能否解释到具体对象，而不是只会说“更贵了”。
4. compact 后留下的是 continuation object，还是一段更短的故事。
5. 当前继续资格在我的系统里是正式对象，还是一个默认动作。

## 8. 一句话总结

真正成熟的 Prompt 宿主迁移，不是把 prompt 搬进宿主，而是把输入面、协议真相、缓存解释、合法遗忘与继续资格一起迁成同一个 `compiled request truth` 消费链。
