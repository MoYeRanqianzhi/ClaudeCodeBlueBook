# Prompt宿主迁移演练手册：compiled request truth交接包、灰度记录与回退演练

这一章不再解释 Prompt 宿主迁移工单该怎样编排，而是把 Claude Code 式 Prompt 迁移压成一张可持续执行的交接、灰度与回退演练手册。

它主要回答五个问题：

1. 团队怎样知道 Prompt 宿主迁移真的围绕同一个 `compiled request truth` 在运行，而不是只完成了字段接线。
2. 哪些交接字段最能保护 `section registry`、`protocol rewrite`、`cache explainability`、`lawful forgetting` 与 `continue qualification` 不被重新打散。
3. 灰度应该按什么顺序开放，才能避免先学会继续、后学会解释。
4. 哪些回退演练最能暴露宿主又重新退回字符串、raw transcript 与摘要交接。
5. 怎样用苏格拉底式追问避免把这层写成“Prompt 迁移日报”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:560-576`
- `claude-code-source-code/src/utils/api.ts:321-405`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/services/api/claude.ts:1374-1485`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:247-666`
- `claude-code-source-code/src/services/compact/compact.ts:330-711`
- `claude-code-source-code/src/query/stopHooks.ts:257-331`
- `claude-code-source-code/src/query.ts:1223-1340`
- `claude-code-source-code/src/utils/sessionState.ts:92-134`

## 1. 第一性原理

Prompt 宿主迁移真正要守住的不是：

- 我们已经把 prompt 展示出来了
- compact 之后还有摘要可读

而是：

- 交接、灰度与回退仍围绕同一个 `compiled request truth` 成立

所以这层 playbook 最先要看的不是：

- 页面已经长得像迁完了

而是：

1. 输入面是否仍只是输入面。
2. protocol truth 是否仍是正式消费面。
3. cache break 是否仍可被解释。
4. lawful forgetting 是否仍留下 continuation object。
5. continue qualification 是否仍是正式 gate。

## 2. 交接包最小样例

每次 Prompt 宿主迁移交接，至少应留下：

1. `request_object_id`
2. `prompt_input_surface`
3. `section_registry_snapshot`
4. `stable_boundary_snapshot`
5. `cache_strategy_snapshot`
6. `protocol_rewrite_version`
7. `cache_break_reason`
8. `compact_boundary`
9. `preserved_segment`
10. `next_step`
11. `continue_qualification`
12. `reject_reason`

如果交接只剩这些内容以外的东西：

- system prompt 截图
- token 曲线
- 一段“这轮大概在做什么”的摘要

就说明团队还没有真正完成迁移。

## 3. 灰度发布顺序

更稳的 Prompt 灰度顺序是：

1. `section projection shadow`
   - 先只读暴露输入面、section law 与 stable boundary。
2. `protocol rewrite shadow`
   - 再让宿主同时看见 raw/protocol 差异，但不切主路径。
3. `cache explainability shadow`
   - 再把 break reason 提升为正式灰度观测项。
4. `lawful forgetting handoff`
   - 再灰度 compact boundary、preserved assets 与 next step。
5. `continue qualification gate`
   - 最后才让宿主围绕正式资格决定继续、compact 或升级对象。

每个阶段至少观测：

1. 当前正式对象是什么。
2. 这一阶段新增了什么投影。
3. 哪些旧 heuristic 已被禁止。
4. 哪个信号一旦缺失必须立刻停止灰度。

## 4. 回退演练集

每轮至少跑下面五个 Prompt 迁移演练：

1. `dynamic section only`
   - 确认宿主不会把 stable prefix 全体判死。
2. `tool schema drift`
   - 确认宿主能把 break 解释到 ABI 漂移，而不是 prompt 文案变化。
3. `raw/protocol mismatch`
   - 确认宿主不会重新把 raw transcript 当正式真相。
4. `compact handoff`
   - 确认 compact 后仍留下 boundary、assets 与 next step。
5. `stop hook blocking`
   - 确认 continue qualification 被正式拒收，而不是被界面按钮绕过。

## 5. 直接终止条件

出现下面情况时，应直接停止灰度并回退：

1. 宿主重新把 `systemPrompt` 字符串当唯一真相。
2. 宿主重新把 raw transcript 当模型输入或交接真相。
3. cache break 重新只剩 token 变化，没有 reason。
4. compact 后只剩 summary，不剩 boundary 与 preserved segment。
5. continue 重新主要靠 `stop_reason` 或最后一条消息判断。

## 6. 复盘记录最少字段

每次 Prompt 迁移回退或停止灰度，至少记录：

1. `request_object_id`
2. `stage`
3. `protocol_gap`
4. `cache_break_reason`
5. `handoff_gap`
6. `continue_gate_gap`
7. `symptom`
8. `rollback_action`
9. `re-entry_condition`

## 7. 苏格拉底式检查清单

在你准备宣布“Prompt 宿主迁移已经稳定运行”前，先问自己：

1. 交接包里留下的是 `compiled request truth`，还是只剩 prompt 摘要。
2. 灰度里被观察的是 protocol truth，还是显示层替身。
3. cache 失稳时，我的团队能否解释到对象级原因。
4. compact 后还能继续，是因为 continuation object 还在，还是因为大家还记得前文。
5. 当前继续资格是正式 gate，还是团队默契。

## 8. 一句话总结

真正成熟的 Prompt 宿主迁移演练，不是让 Prompt 看起来接好了，而是持续证明交接、灰度与回退仍围绕同一个 `compiled request truth`。
