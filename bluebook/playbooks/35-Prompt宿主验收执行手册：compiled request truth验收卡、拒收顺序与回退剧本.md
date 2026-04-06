# Prompt宿主验收执行手册：message lineage验收卡、拒收顺序与回退剧本

这一章不再解释 Prompt 宿主验收协议该消费哪些字段，而是把 Claude Code 式 Prompt 验收压成一张可持续执行的验收手册。

它主要回答五个问题：

1. 宿主、CI、评审与交接怎样共享同一张 Prompt 验收卡，而不是各自消费不同真相。
2. 应该按什么固定顺序执行 Prompt 宿主验收，才能真正验到同一条 `message lineage` 上的 `compiled request truth`。
3. 哪些 reject reason 一旦出现就必须立即停止继续、拒绝交接并进入回退。
4. 哪些回退演练最能暴露 Prompt 宿主实现又重新退回截图、摘要与 last-message heuristic。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的 prompt 表单”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:343-347`
- `claude-code-source-code/src/utils/api.ts:136-405`
- `claude-code-source-code/src/services/api/claude.ts:1374-1485`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:494-698`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/services/compact/prompt.ts:293-337`
- `claude-code-source-code/src/services/compact/compact.ts:330-711`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-66`
- `claude-code-source-code/src/query/stopHooks.ts:257-331`
- `claude-code-source-code/src/query.ts:1258-1518`
- `claude-code-source-code/src/utils/sessionState.ts:92-146`

## 1. 第一性原理

Prompt 宿主验收真正要执行的不是：

- prompt 文案看起来更强了
- 页面上有一张验收卡了

而是：

- 宿主、CI、评审与交接仍围绕同一条 `message lineage` 上的 `compiled request truth` 在判断

所以这层 playbook 最先要看的不是：

- 验收卡已经填完了

而是：

1. 当前判断对象是否仍是 `compiled request truth`。
2. `message lineage` 与 projection consumer 是否仍指向同一条 truth。
3. `section registry` 与 `stable prefix boundary` 是否仍是正式权威边界。
4. 模型消费的是否仍是 `protocol transcript`，而不是 UI 历史。
5. compact 之后留下的是 `lawful forgetting object`，而不是摘要替身。
6. 继续资格是否仍由 `continue qualification` 裁定，而不是由按钮、`stop_reason` 与最后一条消息裁定。

## 2. 共享验收卡最小字段

每次 Prompt 宿主验收，宿主、CI、评审与交接系统至少应共享：

1. `request_object_id`
2. `compiled_request_hash`
3. `message_lineage_ref`
4. `projection_consumer_alignment`
5. `section_registry_snapshot`
6. `stable_prefix_boundary`
7. `tool_schema_hash`
8. `protocol_transcript_health`
9. `cache_break_reason`
10. `lawful_forgetting_object`
11. `continue_qualification`
12. `reject_reason`
13. `rollback_object`
14. `consumer_verdict`

四类消费者的分工应固定为：

1. 宿主看 live object 是否仍成立。
2. CI 看字段与执行顺序是否完整。
3. 评审看 reject reason 与解释链是否自洽。
4. 交接看 lawful forgetting object、projection consumer 与 continue qualification 是否足以让后来者继续。

## 3. 固定执行顺序

### 3.1 先验 compiled request authority 与 lineage continuity

先看：

1. 当前交接对象是否仍是 `compiled request truth`
2. `message lineage` 是否仍唯一、可点名
3. `section registry` 是否存在
4. `stable prefix boundary` 是否仍可被复查

只要这一步不成立，就不应继续看 cache、摘要或 continue。

### 3.2 再验 protocol transcript health

再看：

1. raw history 与 protocol transcript 是否仍分层
2. tool/result pairing 是否仍健康
3. display transcript、protocol transcript 与 handoff object 是否仍围绕同一条 lineage
4. 交接系统是否仍围绕 rewrite 后 transcript 工作

如果这一步不成立，就说明团队正在围绕错误历史做继续判断。

### 3.3 再验 cache explainability

再看：

1. 当前 cache break 是否仍有对象级 reason
2. tool schema / beta / extra body drift 是否仍能解释到字段级
3. cache 指标是否仍是解释结果，而不是替代真相

### 3.4 再验 lawful forgetting object

再看：

1. compact 后是否仍留下 boundary、preserved segment 与 next step
2. summary 是否仍只是辅助资产，而不是主真相
3. continuation object 是否仍能挂回同一 lineage
4. 交接对象是否仍能支撑 later continuation

### 3.5 最后验 continue qualification

最后才看：

1. `continue_qualification` 是否与 `session_state`、`result_subtype` 一致
2. stop hook / token budget / pending action 是否仍纳入同一 gate
3. projection consumer 是否仍不会把 display truth 误当继续资格
4. 是否仍能清楚区分 continue、compact、升级对象与停止

## 4. 直接拒收条件

出现下面情况时，应直接拒收当前 Prompt 宿主实现：

1. `raw_sysprompt_authority`
2. `missing_section_registry`
3. `boundary_missing_or_reordered`
4. `compiled_request_drift_unexplained`
5. `transcript_repair_required`
6. `summary_only_handoff`
7. `projection_consumer_split_detected`
8. `continue_state_inconsistent`
9. `post_compact_baseline_not_reset`

## 5. 拒收升级与回退顺序

看到 reject reason 之后，更稳的处理顺序是：

1. 先停止继续与交接，不再让 later 消费当前 Prompt 工件。
2. 先冻结当前灰度，不允许 cache、compact 或 continue 再覆盖现场。
3. 先回到上一个仍可验证的 `request_object` 或 lawful forgetting boundary。
4. 先补新的 `compiled request truth` 验收卡，再允许重新开闸。
5. 如果根因落在 section law、tool schema 或 protocol rewrite，就回跳 `../guides/57` 做制度纠偏。

## 6. 回退演练集

每轮至少跑下面六个 Prompt 宿主验收演练：

1. `dynamic section only`
2. `tool schema drift`
3. `raw/protocol mismatch`
4. `cache explainability loss`
5. `compact handoff`
6. `stop hook blocking`

## 7. 复盘记录最少字段

每次 Prompt 宿主验收失败或回退，至少记录：

1. `request_object_id`
2. `stage`
3. `message_lineage_ref`
4. `reject_reason`
5. `compiled_truth_gap`
6. `protocol_gap`
7. `projection_gap`
8. `cache_break_reason`
9. `handoff_gap`
10. `continue_gate_gap`
11. `rollback_action`
12. `re_entry_condition`

## 8. 苏格拉底式检查清单

在你准备宣布“Prompt 宿主验收已经稳定运行”前，先问自己：

1. 我消费的是编译后的请求对象，还是一段 Prompt 文本。
2. 当前 `message lineage` 有没有在宿主、CI、评审与交接之间保持唯一。
3. 我现在看到的是 `stable prefix boundary`，还是作者脑内边界。
4. cache drift 时，我能指出是哪类字段漂了，还是只能说命中率掉了。
5. 模型看到的是 rewrite 后 transcript，还是我看到的 UI 历史。
6. compact 后我交的是 continuation object，还是一段摘要。
7. continue/stop 是看 result、state 与 gate，还是看最后一条消息。
8. 如果今天回退，我回退的是哪一层对象，而不是哪段文案。
9. 如果接手人不读源码，只看我的验收卡，能不能重建同一判断。

## 9. 一句话总结

真正成熟的 Prompt 宿主验收执行，不是把 contract 字段抄进表单，而是持续证明宿主、CI、评审与交接仍围绕同一条 `message lineage` 上的 `compiled request truth` 执行、拒收与回退。
