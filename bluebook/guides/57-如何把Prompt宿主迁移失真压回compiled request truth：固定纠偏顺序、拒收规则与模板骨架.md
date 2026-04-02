# 如何把Prompt宿主迁移失真压回compiled request truth：固定纠偏顺序、拒收规则与模板骨架

这一章不再解释 Prompt 宿主迁移最常怎样失真，而是把 Claude Code 式 Prompt 纠偏压成一张可执行的 builder-facing 手册。

它主要回答五个问题：

1. 为什么 Prompt 纠偏真正要救回的不是某个显示字段，而是同一个 `compiled request truth`。
2. 怎样把截图交接、黑箱灰度与继续资格幻觉压回固定纠偏顺序。
3. 哪些现象应被直接拒收，而不是继续观察。
4. 怎样把 Prompt 交接、灰度与回退重新压回模板骨架。
5. 怎样用苏格拉底式追问避免把纠偏写成“补字段清单”。

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

Prompt 纠偏真正要救回的不是：

- system prompt 截图
- 更漂亮的 handoff 摘要
- 更平滑的 cache hit 曲线

而是：

- 模型真正消费的同一个 `compiled request truth`

所以更稳的纠偏目标不是：

- 先把页面恢复正常

而是：

1. 先把输入面重新降回输入面。
2. 先把 section/boundary 恢复成正式编译对象。
3. 先把 raw/protocol 重新分层。
4. 先把 cache break reason 从黑箱成本里救出来。
5. 先把 continue qualification 从 `stop_reason` 幻觉里救出来。

## 2. 固定纠偏顺序

### 2.1 先拆掉伪交接真相

先纠的不是页面，而是交接对象：

1. 禁止把 system prompt 截图充当 Prompt 真相。
2. 禁止把 compact summary 充当 lawful forgetting 真相。
3. 禁止把 raw transcript 充当模型世界。

最小恢复对象：

1. `section_registry_snapshot`
2. `stable_boundary_snapshot`
3. `protocol_rewrite_version`
4. `compact_boundary`
5. `preserved_segment`

### 2.2 再恢复 compiled request truth ledger

第二步要把宿主重新拉回：

1. `request_object_id`
2. `cache_strategy_snapshot`
3. `cache_break_reason`
4. `tool schema / beta / extraBody` 的 drift 解释面

不要继续做的事：

1. 不要只看命中率。
2. 不要只看 token 成本。
3. 不要把“最近更贵了”当成 explainability。

### 2.3 再恢复 protocol truth

第三步要修的是：

1. `normalizeMessagesForAPI()` 的协议投影。
2. `ensureToolResultPairing()` 的 pairing 健康度。
3. raw history 与 protocol truth 的边界。

只要这一步没修好，后面的交接、灰度、回退都仍会围绕错误历史工作。

### 2.4 再恢复 lawful forgetting

第四步要把 compact 从“更短摘要”拉回：

1. `compact_boundary`
2. `preserved_segment`
3. `next_step`
4. `preserved_assets`

这一步的目标不是更容易读，而是更容易继续。

### 2.5 最后恢复 continue qualification

最后才修：

1. `continue_qualification`
2. `prevent_continuation_reason`
3. `session_state_changed + pending_action + result envelope`

不要反过来：

1. 不要先修“继续”按钮，再修 boundary。
2. 不要先修 `stop_reason` 展示，再修 continue gate。

## 3. 硬拒收规则

出现下面情况时，应直接拒收当前 Prompt 宿主实现：

1. system prompt 截图仍是交接真相。
2. compact 后仍只剩 summary，不剩 boundary 与 preserved segment。
3. raw transcript 仍被当模型真相。
4. cache hit / token 曲线仍在替代 `cache_break_reason`。
5. `stop_reason`、最后一条消息或按钮状态仍在替代 `continue_qualification`。

## 4. 模板骨架

### 4.1 交接模板骨架

1. `request_object_id`
2. `section_registry_snapshot`
3. `stable_boundary_snapshot`
4. `protocol_rewrite_version`
5. `cache_strategy_snapshot`
6. `cache_break_reason`
7. `compact_boundary`
8. `preserved_segment`
9. `next_step`
10. `continue_qualification`

### 4.2 灰度模板骨架

1. `stage`
2. `compiled_truth_delta`
3. `protocol_gap`
4. `cache_break_reason`
5. `boundary_gap`
6. `continue_gate_gap`
7. `stop_condition`

### 4.3 回退模板骨架

1. `rollback_trigger`
2. `rollback_object`
3. `compiled_truth_before`
4. `compiled_truth_after`
5. `re-entry_condition`
6. `reject_reason`

## 5. 苏格拉底式检查清单

在你准备宣布“Prompt 失真已经纠偏完成”前，先问自己：

1. 我救回的是 `compiled request truth`，还是只救回了展示。
2. 我现在交接的是 boundary 和 protocol truth，还是截图与摘要。
3. cache drift 在我的系统里是有原因的，还是仍然只有曲线。
4. 当前继续资格在我的系统里是正式 gate，还是最后一条消息。
5. later 团队是否已经不再需要作者口述来继续工作。

## 6. 一句话总结

真正成熟的 Prompt 纠偏，不是把几个字段补全，而是把截图交接、黑箱灰度与继续资格幻觉重新压回同一个 `compiled request truth`。
