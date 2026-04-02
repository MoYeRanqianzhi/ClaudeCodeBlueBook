# Prompt宿主修复稳态执行手册：steady-state card、continuity verdict order、re-entry threshold与residual reopen drill

这一章不再解释 Prompt 宿主修复稳态协议该消费哪些字段，而是把 Claude Code 式 Prompt steady state 压成一张可持续执行的稳态手册。

它主要回答五个问题：

1. 为什么 Prompt 的魔力在稳态里执行的不是“最近一直很稳”，而是同一个 `compiled request truth` 在无人继续盯防时仍配继续。
2. 宿主、CI、评审与交接怎样共享同一张 Prompt steady-state card，而不是各自围绕 summary、watch note 与 handoff prose 工作。
3. 应该按什么固定顺序执行 `truth continuity`、`stable prefix custody`、`baseline dormancy seal`、`continuation eligibility`、`handoff continuity` 与 `reopen threshold`，才能不让 released 重新退回安静叙事。
4. 哪些 steady verdict 一旦出现就必须冻结 continuation、阻断 handoff 并进入 re-entry / residual reopen drill。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的 release 后观察表”。

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
- `claude-code-source-code/src/query/tokenBudget.ts:22-92`
- `claude-code-source-code/src/query.ts:1308-1518`

## 1. 第一性原理

Prompt 宿主修复稳态真正要执行的不是：

- release 之后最近很平静
- compact summary 现在还读得通
- later 团队主观上觉得应该能继续

而是：

- 宿主、CI、评审与交接仍围绕同一个 `compiled request truth` 持续证明现在还配继续、还配交接、还配保留 residual reopen threshold

所以这层 playbook 最先要看的不是：

- steady-state card 已经填完了

而是：

1. 当前 truth continuity 是否仍围绕同一个 `restored_request_object`。
2. 当前 stable prefix 是否仍被 custody，而不是只靠一段未失效的摘要前缀侥幸维持。
3. 当前 baseline dormancy 是否真的 seal，而不是 drift 暂时没人再提。
4. 当前 continuation eligibility 是否真的证明“仍配继续”，而不是“先继续也行”。
5. 当前 handoff continuity 与 reopen threshold 是否仍保留 later 团队反对当前状态的能力。

## 2. 共享 steady-state card 最小字段

每次 Prompt 宿主修复稳态巡检，宿主、CI、评审与交接系统至少应共享：

1. `steady_state_card_id`
2. `steady_state_object_id`
3. `restored_request_object_id`
4. `compiled_request_hash`
5. `truth_continuity`
6. `stable_prefix_custody`
7. `baseline_dormancy_seal`
8. `continuation_eligibility`
9. `handoff_continuity_warranty`
10. `reopen_threshold`
11. `steady_verdict`
12. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看是否仍围绕同一个 `compiled request truth`。
2. CI 看 continuity、custody、eligibility 与 threshold 顺序是否完整。
3. 评审看 `steady_verdict` 与对象边界是否仍自洽。
4. 交接看 later 团队能否在不继承作者记忆的前提下继续消费同一 truth object。

## 3. 固定 steady verdict 顺序

### 3.1 先验 `truth continuity`

先看当前准备宣布 steady 的，到底是不是同一个 `restored_request_object`，而不是某份 summary、handoff prose 或最近一次无异常记录。

只要 truth 不清楚，就不能进入 steady state。

### 3.2 再验 `stable prefix custody`

再看 `stable_prefix_boundary`、`cache_break_budget` 与 `compaction_lineage` 是否仍证明 Prompt 世界可缓存、可转写，而不是只证明“最近没有触发明显断裂”。

Prompt 的魔力保护的不是平静感，而是前缀资产仍在。

### 3.3 再验 `baseline dormancy seal`

再看 `baseline_drift_ledger` 是否真的已进入 dormancy seal，而不是 drift 只是暂时沉默。

这一步不成立，说明 released 之后的平静仍可能只是叙事静音。

### 3.4 再验 `continuation eligibility`

再看：

1. `continue_qualification` 是否仍然成立。
2. `token_budget_ready` 是否仍支持继续。
3. `session_resume_ready` 是否仍让 later 团队可恢复接手。

这一步不成立，steady 只是“先继续看看”。

### 3.5 再验 `handoff continuity warranty`

再看 handoff 是否仍围绕同一个 continuity object，而不是围绕一段更好读的 summary。

如果 handoff 仍需要作者临场解释，steady 就还没有成立。

### 3.6 最后验 `reopen threshold` 与 `steady_verdict`

最后才看：

1. `truth_break_trigger` 与 `cache_break_threshold` 是否仍正式保留。
2. `rollback_boundary` 是否仍明确。
3. `steady_verdict` 是否与前五步对象完全一致。

如果 threshold 消失，steady 就只是把未来反对当前状态的能力一起删除。

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前 Prompt steady state：

1. `truth_continuity_missing`
2. `prefix_custody_missing`
3. `baseline_dormancy_unsealed`
4. `continuation_expired`
5. `handoff_continuity_blocked`
6. `reopen_threshold_missing`
7. `truth_recompile_required`
8. `reopen_required`

## 5. continuation patrol 与 re-entry 顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先冻结新的 continuation 与 handoff，不再让 later 团队消费当前 steady-state 工件。
2. 先把 verdict 降级为 `steady_state_blocked` 或 `reentry_required`，不允许继续冒充 steady。
3. 先回到上一个仍可验证的 `restored_request_object` 或 stable prefix boundary。
4. 先补新的 custody、dormancy seal 与 eligibility，再允许重新发放 handoff continuity warranty。
5. 如果根因落在 release correction 制度本身，就回跳 `../guides/72` 做对象级纠偏。

## 6. 最小 residual reopen 演练集

每轮至少跑下面七个 Prompt 宿主稳态执行演练：

1. `truth_continuity_recheck`
2. `stable_prefix_custody_replay`
3. `baseline_dormancy_reseal`
4. `continuation_eligibility_recheck`
5. `handoff_continuity_reconsume`
6. `reopen_threshold_replay`
7. `truth_recompile_fallback`

## 7. 复盘记录最少字段

每次 Prompt 宿主稳态失败、再入场或 reopen，至少记录：

1. `steady_state_card_id`
2. `steady_state_object_id`
3. `truth_continuity`
4. `stable_prefix_custody`
5. `baseline_dormancy_seal`
6. `continuation_eligibility`
7. `handoff_continuity_warranty`
8. `reopen_threshold`
9. `steady_verdict`
10. `verdict_reason`

## 8. 苏格拉底式检查清单

在你准备宣布“Prompt 已经 steady”前，先问自己：

1. 我现在保护的是 `compiled request truth`，还是一份更耐读的 summary。
2. `stable prefix custody` 保住的是前缀资产，还是一次暂时没触发 cache break 的好运气。
3. `continuation eligibility` 证明的是继续资格，还是只是大家愿意先继续。
4. handoff continuity 释放的是对象，还是故事。
5. `reopen threshold` 还在不在，如果不在，我是在进入稳态，还是在删掉未来反对当前状态的能力。

## 9. 一句话总结

真正成熟的 Prompt 宿主修复稳态执行，不是宣布“released 之后一直很稳”，而是持续证明同一个 `compiled request truth` 仍配继续、仍配交接，并在必要时仍能沿正式 threshold 重新进入 re-entry 或 reopen。
