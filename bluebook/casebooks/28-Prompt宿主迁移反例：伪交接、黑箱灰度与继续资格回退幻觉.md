# Prompt宿主迁移反例：伪交接、黑箱灰度与继续资格回退幻觉

这一章不再回答“Prompt 宿主迁移演练该怎样执行”，而是回答：

- 为什么团队明明已经写了 `compiled request truth` 交接包、灰度记录与回退演练，仍会重新退回 system prompt 截图、摘要 handoff、黑箱 cache hit 与 `stop_reason` 继续判断。

它主要回答五个问题：

1. 为什么 Prompt 宿主迁移最危险的失败方式不是“没做演练”，而是“做了演练却仍围绕替身交接与判断”。
2. 为什么把交接包写成 prompt 摘要、截图与 token 曲线，会重新打碎 `compiled request truth`。
3. 为什么把灰度记录写成命中率、通过率与成本曲线，会重新把 cache explainability 黑箱化。
4. 为什么把回退判断写成最后一条消息、`stop_reason` 与是否还能继续，会重新把 continue qualification 默认化。
5. 怎样用苏格拉底式追问避免把这些反例读成“再把模板填细一点就好”。

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

这些锚点共同说明：

- Prompt 宿主迁移真正最容易失真的地方，不在工单是否存在，而在交接、灰度与回退是否仍围绕同一个 `compiled request truth` 消费 Prompt 世界。

## 1. 第一性原理

Prompt 宿主迁移最危险的，不是：

- 没有交接模板
- 没有灰度记录
- 没有回退 drill

而是：

- 这些东西已经存在，却仍然围绕 prompt 字符串、黑箱成本与 `stop_reason` 幻觉运作

一旦如此，团队就会重新回到：

1. 看 system prompt 截图
2. 看命中率与 token 曲线
3. 看最后一条消息
4. 看一段 compact 摘要

而不再围绕：

- 同一个 `compiled request truth`

## 2. 伪交接：交接包退回 prompt 摘要与截图

### 坏解法

- 交接包里只有 system prompt 截图、一段“这轮在做什么”的摘要和几条 token 指标。

### 为什么坏

- 真正的 Prompt 交接对象还包括 `section registry`、`stable boundary`、`protocol rewrite version`、`cache strategy snapshot` 与 `continue qualification`。
- 一旦交接退回截图与摘要，later 维护者就不知道这轮到底是 section law 变了、tool schema 变了，还是 compact boundary 变了。
- 这会把交接重新退回作者记忆，而不是继续围绕对象级真相。

### Claude Code 式正解

- 交接包应围绕 `compiled request truth` 的正式对象，而不是围绕 prompt 展示效果。


## 3. 假灰度：命中率、通过率与成本曲线冒充 explainability

### 坏解法

- 灰度记录只写 cache hit、token 成本、通过率变化，不写 `cache_break_reason` 与 protocol health。

### 为什么坏

- 这样会把 `promptCacheBreakDetection` 的 explainability 白白丢掉。
- 团队看得到“命中率掉了”，却看不到是 `systemPromptChanged`、`toolSchemasChanged`、`betasChanged`，还是合法 compaction baseline reset。
- 最后灰度面板会变成一组漂亮的黑箱曲线，而不是正式对象的 drift ledger。

### Claude Code 式正解

- 灰度记录必须围绕 break reason、protocol gap、boundary drift 与 continuation signal 记录，而不是只围绕结果指标。


## 4. 回退幻觉：`stop_reason`、最后一条消息与“还能继续”

### 坏解法

- 团队只看最后一条消息、`stop_reason` 或按钮状态，就判断当前是否应继续、应回退、应升级对象。

### 为什么坏

- continue qualification 还取决于 stop hooks、token budget、max-output continuation、`session_state_changed` 与 `pending_action`。
- 一旦回退判断只剩 `stop_reason` 或“看起来还能继续”，时间边界就会重新免费化。
- 这会让回退 drill 看起来都通过了，实际却把最危险的误继续藏起来。

### Claude Code 式正解

- 回退判断必须围绕 `continue_qualification + session_state_changed + pending_action + result envelope`。


## 5. 把 compact 交接重新退回摘要 handoff

### 坏解法

- 团队把 compact 视为“更短摘要”，交接时只保存 summary，不保存 `compact_boundary` 与 `preserved_segment`。

### 为什么坏

- compact 真正保护的是 lawful forgetting 之后还能继续工作的对象，而不只是更短的叙述。
- 一旦 `compact_boundary` 与 `preserved_segment` 缺席，later resume mismatch 时就无法分清是 forgetting 出错还是交接消费错了。

### Claude Code 式正解

- compact handoff 应围绕 boundary、preserved segment、next step 与 preserved assets。


## 6. protocol rewrite 健康度缺席

### 坏解法

- 交接和灰度默认把 raw transcript 当成模型真相，不记录 rewrite 之后的协议健康度。

### 为什么坏

- 模型真正消费的是 `normalizeMessagesForAPI()` 与 `ensureToolResultPairing()` 之后的协议面。
- 如果团队只保留 raw transcript，later 漂移时最像对的地方反而最危险，因为大家会误以为“日志都在，应该没问题”。

### Claude Code 式正解

- prompt 交接、灰度与回退都应明确区分 raw transcript 与 protocol truth。


## 7. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在交接的是 `compiled request truth`，还是 prompt 摘要与截图。
2. 我现在灰度的是对象级 explainability，还是黑箱曲线。
3. 我现在回退的是 continue qualification，还是 `stop_reason` 幻觉。
4. 我现在保护的是 lawful forgetting 对象，还是更短的故事。
5. 我现在消费的是 protocol truth，还是 raw transcript 替身。

## 8. 一句话总结

真正危险的 Prompt 宿主迁移失败，不是没做交接和灰度，而是做了这些动作却仍在围绕截图、摘要、黑箱指标与 `stop_reason` 幻觉消费 Prompt 世界。
