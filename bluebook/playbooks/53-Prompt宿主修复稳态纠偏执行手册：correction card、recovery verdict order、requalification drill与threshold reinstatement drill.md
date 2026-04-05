# Prompt宿主修复稳态纠偏执行手册：correction card、recovery verdict order、requalification drill与threshold reinstatement drill

这一章不再解释 Prompt 宿主修复稳态纠偏协议该消费哪些字段，而是把 Claude Code 式 Prompt steady-state correction 压成一张可持续执行的纠偏手册。

它主要回答五个问题：

1. 为什么 Prompt 的魔力在纠偏执行里运行的不是“steady note 更正式”，而是同一个 `compiled request truth` 被重新证明仍可继续、可交接、可重开。
2. 宿主、CI、评审与交接怎样共享同一张 Prompt correction card，而不是各自围绕 summary、steady note 与 handoff prose 工作。
3. 应该按什么固定顺序执行 `truth continuity recovery`、`stable prefix recustody`、`baseline dormancy reseal`、`continuation requalification`、`handoff continuity repair` 与 `threshold reinstatement`，才能不让假稳态重新复活。
4. 哪些 correction verdict 一旦出现就必须冻结 continuation、阻断 handoff 并进入 re-entry / reopen drill。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的 steady-state 售后表”。

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

Prompt 宿主修复稳态纠偏真正要执行的不是：

- steady note 更完整
- 最近重新平静
- later 团队愿意先继续

而是：

- 宿主、CI、评审与交接仍围绕同一个 `compiled request truth` 持续证明：当前 correction object 仍成立、前缀资产已重新托管、continuation 已重新资格化、threshold 已重新恢复

所以这层 playbook 最先要看的不是：

- correction card 已经填完了

而是：

1. 当前 correction object 是否仍围绕同一个 `restored_request_object_id + compiled_request_hash`。
2. 当前 `truth continuity recovery` 是否真的把 steady 从 summary 叙事里救出来。
3. 当前 `stable prefix recustody` 与 `baseline dormancy reseal` 是否真的让前缀与静默重新回到正式对象。
4. 当前 `continuation requalification` 与 `handoff continuity repair` 是否真的让 later 团队不再依赖作者补充说明。
5. 当前 `threshold reinstatement` 是否仍保留 future reopen 的正式能力。

## 2. 共享 correction card 最小字段

每次 Prompt 宿主修复稳态纠偏巡检，宿主、CI、评审与交接系统至少应共享：

1. `correction_card_id`
2. `steady_correction_object_id`
3. `restored_request_object_id`
4. `compiled_request_hash`
5. `truth_continuity_recovery`
6. `stable_prefix_recustody`
7. `baseline_dormancy_reseal`
8. `continuation_requalification`
9. `handoff_continuity_repair`
10. `threshold_reinstatement`
11. `correction_verdict`
12. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看 correction object 是否仍围绕同一个 `compiled request truth`。
2. CI 看 recovery、recustody、requalification 与 threshold 顺序是否完整。
3. 评审看 `correction_verdict` 与对象边界是否仍自洽。
4. 交接看 later 团队能否在不继承作者记忆的前提下继续消费同一 correction object。

## 3. 固定 correction verdict 顺序

### 3.1 先验 `steady_correction_object`

先看当前准备宣布纠偏完成的，到底是不是同一个 `steady_correction_object_id`，而不是一份更正式的 steady 说明。

只要 correction object 不清楚，就不能进入 restored。

### 3.2 再验 `truth_continuity_recovery`

再看当前 truth 是否真的回到同一个 `restored_request_object_id + compiled_request_hash`，而不是只证明“当前文案讲得更顺了”。

### 3.3 再验 `stable_prefix_recustody`

再看 `stable_prefix_boundary`、`cache_break_budget` 与 `compaction_lineage` 是否仍证明 Prompt 世界可缓存、可转写，而不是只证明“最近没断”。

### 3.4 再验 `baseline_dormancy_reseal`

再看 `baseline_drift_ledger_id`、`sealed_generation` 与 `dormancy_resealed_at` 是否真的让 drift 进入重新封存，而不是 drift 暂时没人再提。

### 3.5 再验 `continuation_requalification`

再看：

1. `continue_qualification` 是否仍然成立。
2. `token_budget_ready` 是否仍支持继续。
3. `required_preconditions` 是否仍让 later 团队可恢复接手。

### 3.6 再验 `handoff_continuity_repair`

再看 handoff 是否仍围绕同一个 continuity object，而不是围绕一段更好读的 summary prose。

如果 handoff 仍需要作者临场解释，纠偏就还没有完成。

### 3.7 最后验 `threshold_reinstatement` 与 `correction_verdict`

最后才看：

1. `truth_break_trigger` 与 `cache_break_threshold` 是否仍正式保留。
2. `reentry_required_when` 与 `reopen_required_when` 是否仍明确。
3. `correction_verdict` 是否与前六步对象完全一致。

如果 threshold 消失，纠偏只是把未来反对当前状态的能力一起删除。

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前 Prompt correction execution：

1. `steady_correction_object_missing`
2. `truth_continuity_recovery_failed`
3. `stable_prefix_recustody_missing`
4. `baseline_dormancy_reseal_failed`
5. `continuation_requalification_failed`
6. `handoff_continuity_repair_blocked`
7. `threshold_reinstatement_missing`
8. `truth_recompile_required_or_reopen_required`

## 5. re-entry 与 reopen 处理顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先冻结新的 continuation 与 handoff，不再让 later 团队继续消费当前 correction card。
2. 先把 verdict 降级为 `hard_reject`、`reentry_required` 或 `reopen_required`。
3. 先回到上一个仍可验证的 `restored_request_object_id` 或 stable prefix boundary。
4. 先补新的 recustody、reseal 与 requalification，再允许重新发放 handoff continuity repair。
5. 如果根因落在 correction protocol 本身，就回跳 `../api/72` 做对象级修正。

## 6. 最小 drill 集

每轮至少跑下面五个 Prompt 宿主稳态纠偏执行演练：

1. `truth_continuity_recovery_replay`
2. `stable_prefix_recustody_recheck`
3. `continuation_requalification_replay`
4. `handoff_continuity_reconsume`
5. `threshold_reinstatement_replay`

## 7. 复盘记录最少字段

每次 Prompt 宿主稳态纠偏失败、再入场或 reopen，至少记录：

1. `correction_card_id`
2. `steady_correction_object_id`
3. `restored_request_object_id`
4. `compiled_request_hash`
5. `truth_continuity_recovery`
6. `stable_prefix_recustody`
7. `continuation_requalification`
8. `threshold_reinstatement`
9. `correction_verdict`
10. `verdict_reason`

## 8. 苏格拉底式检查清单

在你准备宣布“Prompt 已完成稳态纠偏执行”前，先问自己：

1. 我救回的是同一个 `compiled request truth`，还是一份更正式的 steady-state 说明。
2. 我现在保护的是 `stable_prefix_recustody`，还是一次暂时没触发 cache break 的好运气。
3. 我现在恢复的是 `continuation_requalification`，还是一种“先继续再说”的默认冲动。
4. 我现在交接的是 continuity object，还是 later 仍需脑补的 summary prose。
5. `threshold_reinstatement` 还在不在；如果不在，我是在完成纠偏，还是在删除未来反对当前 steady 的能力。

## 9. 一句话总结

真正成熟的 Prompt 宿主修复稳态纠偏执行，不是把 steady note 运行得更熟练，而是持续证明同一个 `compiled request truth` 已被修回、可继续、可交接，并在必要时仍能沿正式 threshold 进入 re-entry 或 reopen。
