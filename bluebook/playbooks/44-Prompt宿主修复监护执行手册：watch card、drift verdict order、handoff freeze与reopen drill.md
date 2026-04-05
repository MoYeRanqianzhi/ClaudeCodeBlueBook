# Prompt宿主修复监护执行手册：watch card、drift verdict order、handoff freeze与reopen drill

这一章不再解释 Prompt 宿主修复监护协议该消费哪些字段，而是把 Claude Code 式 Prompt 监护压成一张可持续执行的监护手册。

它主要回答五个问题：

1. 宿主、CI、评审与交接怎样共享同一张 Prompt watch card，而不是各自围绕 closeout note、summary handoff 与‘先观察一下’工作。
2. 应该按什么固定顺序执行 Prompt 监护，才能真正围绕同一个 `compiled request truth` 观察漂移、冻结 handoff 与决定 reopen。
3. 哪些 drift reason 一旦出现就必须立即阻断 handoff、拒绝继续 watch 并进入 reopen drill。
4. 哪些 reopen 演练最能暴露 Prompt closeout 之后又重新退回叙事接手、summary 覆写与默认继续。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的 watch checklist”。

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

## 1. 第一性原理

Prompt 宿主修复监护真正要执行的不是：

- closeout 之后再看一眼 note
- handoff 包还能不能读
- 目前似乎还没有出事

而是：

- 宿主、CI、评审与交接仍围绕同一个 `compiled request truth` 在观察 drift、冻结 handoff 与决定 reopen

所以这层 playbook 最先要看的不是：

- watch card 已经填完了

而是：

1. 当前 watch 对象是否仍是同一个 `restored_request_object`。
2. `baseline_drift_ledger` 是否仍在围绕 protocol truth 与 lawful forgetting 记账，而不是围绕 closeout 文案记账。
3. handoff 是否仍围绕 continuation object，而不是围绕 summary 故事。
4. reopen 是否仍由 `reopen_gate` 裁定，而不是由按钮、情绪与‘先试试看’裁定。

## 2. 共享监护卡最小字段

每次 Prompt 宿主修复监护，宿主、CI、评审与交接系统至少应共享：

1. `watch_card_id`
2. `watch_window_id`
3. `restored_request_object_id`
4. `compiled_request_hash`
5. `baseline_drift_ledger`
6. `continuation_watch`
7. `handoff_watch`
8. `reopen_gate`
9. `watch_verdict`
10. `drift_reason`
11. `handoff_status`
12. `watch_deadline`

四类消费者的分工应固定为：

1. 宿主看 live request object 是否仍是同一个 `compiled request truth`。
2. CI 看 drift ledger 与 reopen gate 顺序是否完整。
3. 评审看 `drift_reason` 与对象边界是否自洽。
4. 交接看 handoff freeze 与 reopen trigger 是否足以让 later 团队安全接手。

## 3. 固定漂移判定顺序

### 3.1 先验 watch window

先看：

1. 当前监护是否仍围绕同一个 `restored_request_object`。
2. `compiled_request_hash`、`section registry` 与 `stable prefix boundary` 是否仍可复查。
3. `monitor_only_reason` 是否仍解释了为什么当前对象需要 watch。

### 3.2 再验 continuation watch

再看：

1. `required_preconditions` 是否仍成立。
2. `pending_action_ref` 与 `session_state_ready` 是否仍能支撑 later continuation。
3. 当前 watch 是否仍在围绕 continuation object，而不是围绕 summary 与最后一条消息。

### 3.3 再验 baseline drift ledger

再看：

1. `protocol_truth_witness` 是否仍能证明模型看到的是 rewrite 后 transcript。
2. `lawful_forgetting_witness` 与 `baseline_reset_witness` 是否仍成立。
3. drift event 是否仍是对象级记账，而不是 closeout 说明补丁。

### 3.4 再验 handoff watch

再看：

1. 交接对象是否仍是 continuation object，而不是 summary。
2. `consumer_readiness_handoff` 是否真的建立在 `required_preconditions` 上。
3. 是否仍不存在 narrative override。

### 3.5 最后验 reopen gate 与 watch verdict

最后才看：

1. `reopen_trigger` 是否明确指出何时必须重新开闸。
2. `watch_verdict` 是否与前四步对象一致。
3. reopen 是否仍回到同一个 `compiled request truth` 边界，而不是回到某段 summary 或旧消息。

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前 Prompt watch：

1. `protocol_drift_detected`
2. `baseline_drift_detected`
3. `handoff_watch_failed`
4. `reopen_gate_expired`
5. `narrative_override_detected`
6. `handoff_blocked`
7. `reopen_required`
8. `watch_window_expired`

## 5. handoff freeze 与 reopen 顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先冻结 handoff，不再让 later 消费当前 watch 工件。
2. 先把当前 verdict 降级为 `handoff_blocked` 或 `reopen_required`。
3. 先回到上一个仍可验证的 request object 或 lawful forgetting boundary。
4. 先补新的 witness，再允许重新发放 handoff watch。
5. 如果根因落在监护制度本身，就回跳 `../guides/66` 做制度纠偏。

## 6. 最小 reopen 演练集

每轮至少跑下面六个 Prompt 宿主监护执行演练：

1. `protocol_watch_recheck`
2. `baseline_drift_replay`
3. `handoff_reconsume`
4. `reopen_gate_expiry_replay`
5. `narrative_override_block`
6. `continuation_watch_replay`

## 7. 复盘记录最少字段

每次 Prompt 宿主监护失败或 reopen，至少记录：

1. `watch_card_id`
2. `watch_window_id`
3. `restored_request_object_id`
4. `baseline_drift_ledger`
5. `handoff_watch`
6. `watch_verdict`
7. `drift_reason`
8. `reopen_trigger`
9. `handoff_status`
10. `watch_deadline`

## 8. 苏格拉底式检查清单

在你准备宣布“Prompt 宿主修复已经 stable under watch”前，先问自己：

1. 我现在监护的是 request object，还是 closeout note。
2. 我现在看到的是 drift ledger，还是一段更会解释的观察文本。
3. handoff freeze 冻结的是 continuation object，还是只冻结了一段摘要。
4. reopen 回到的是对象边界，还是 closeout 故事。
5. 如果 later 团队不读源码，只看我的 watch card，能不能重建同一判断。

## 9. 一句话总结

真正成熟的 Prompt 宿主修复监护执行，不是让团队‘多观察一下’，而是持续证明宿主、CI、评审与交接仍围绕同一个 `compiled request truth` 观察漂移、冻结交接并在必要时重开。
