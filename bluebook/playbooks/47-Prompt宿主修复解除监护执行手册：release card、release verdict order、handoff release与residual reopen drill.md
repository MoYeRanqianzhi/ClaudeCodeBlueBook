# Prompt宿主修复解除监护执行手册：release card、release verdict order、handoff release与residual reopen drill

这一章不再解释 Prompt 宿主修复解除监护协议该消费哪些字段，而是把 Claude Code 式 Prompt 出监压成一张可持续执行的解除监护手册。

它主要回答五个问题：

1. 宿主、CI、评审与交接怎样共享同一张 Prompt release card，而不是各自围绕 watch note、handoff 文案与“最近没出事”工作。
2. 应该按什么固定顺序执行 Prompt 解除监护，才能真正围绕同一个 `compiled request truth` 宣布 released、阻断 handoff 或保留 residual reopen。
3. 哪些 release reason 一旦出现就必须立即阻断 handoff、拒绝 release 并进入 residual reopen drill。
4. 哪些演练最能暴露 Prompt watch release 又重新退回静默放行、叙事放行与无责任 release。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的结束观察清单”。

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

Prompt 宿主修复解除监护真正要执行的不是：

- watch window 里最近没有告警
- watch note 已经写完整了
- handoff 包似乎还能继续读

而是：

- 宿主、CI、评审与交接仍围绕同一个 `compiled request truth` 正式宣布现在可以停止额外监护，同时保留 residual reopen 责任

所以这层 playbook 最先要看的不是：

- release card 已经填完了

而是：

1. 当前 release 对象是否仍是同一个 `restored_request_object`。
2. `stability_witness` 是否证明对象稳定，而不是证明最近安静。
3. `baseline_drift_ledger_seal` 是否真的证明 drift 已被 seal，而不是只是不再被提起。
4. handoff 是否仍围绕同一个 continuation object，而不是围绕 summary 故事。
5. residual reopen 是否仍由正式 gate 负责，而不是由 later 团队的经验与情绪负责。

## 2. 共享 release card 最小字段

每次 Prompt 宿主修复解除监护，宿主、CI、评审与交接系统至少应共享：

1. `release_card_id`
2. `watch_window_id`
3. `watch_release_object`
4. `restored_request_object_id`
5. `compiled_request_hash`
6. `stability_witness`
7. `baseline_drift_ledger_seal`
8. `continuation_clearance`
9. `handoff_release_warranty`
10. `reopen_residual_gate`
11. `release_verdict`
12. `release_reason`

四类消费者的分工应固定为：

1. 宿主看是否仍围绕同一个 `compiled request truth`。
2. CI 看 witness、seal、clearance 与 residual gate 顺序是否完整。
3. 评审看 `release_reason` 与对象边界是否自洽。
4. 交接看 later 团队能否在不继承值班者记忆的前提下继续消费同一 continuation object。

## 3. 固定 release verdict 顺序

### 3.1 先验 `watch_release_object`

先看当前准备解除监护的，到底是不是同一个 `restored_request_object`，而不是某份 closeout note、handoff summary 或 watch 备注。

只要对象不清楚，就不能进入 release。

### 3.2 再验 `stability_witness`

再看 `stability_witness` 是否真的证明对象在 watch window 内持续稳定，而不是只证明最近没有新噪音。

Prompt 世界真正要释放的不是紧张感，而是对象级稳定性。

### 3.3 再验 `baseline_drift_ledger_seal`

再看 `protocol_truth_witness`、`lawful_forgetting_witness` 与 `baseline_reset_witness` 是否已进入 sealed ledger。

这一步不成立，说明 drift 只是暂时沉默，不是正式关闭。

### 3.4 再验 `continuation_clearance`

再看 later 团队是否真的获得继续资格，而不是仍靠值班者额外解释。

`continuation_clearance` 保护的是“可以继续消费同一对象”，不是“应该差不多可以继续”。

### 3.5 最后验 `handoff_release_warranty` 与 `reopen_residual_gate`

最后才看：

1. 交接是否已摆脱作者记忆。
2. residual reopen 风险是否仍保留正式 gate。
3. `release_verdict` 是否与前四步对象一致。

如果 residual gate 消失，`released` 就只是把风险一起遗忘。

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前 Prompt release：

1. `release_object_missing`
2. `stability_witness_missing`
3. `baseline_ledger_unsealed`
4. `continuation_not_cleared`
5. `handoff_release_blocked`
6. `residual_gate_missing`
7. `narrative_release_detected`
8. `reopen_required`

## 5. handoff release 与 residual reopen 顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先冻结 handoff，不再让 later 消费当前 release 工件。
2. 先把当前 verdict 降级为 `monitor_extended` 或 `reopen_required`，不允许继续冒充 `released`。
3. 先回到上一个仍可验证的 request object 或 sealed drift ledger。
4. 先补新的 witness 与 clearance，再允许重新发放 handoff release warranty。
5. 如果根因落在 release 制度本身，就回跳 `../guides/69` 做制度纠偏。

## 6. 最小 residual reopen 演练集

每轮至少跑下面六个 Prompt 宿主解除监护执行演练：

1. `release_handoff_reconsume`
2. `stability_witness_replay`
3. `baseline_ledger_seal_recheck`
4. `continuation_clearance_replay`
5. `residual_reopen_gate_replay`
6. `release_block_fallback`

## 7. 复盘记录最少字段

每次 Prompt 宿主解除监护失败或 reopen，至少记录：

1. `release_card_id`
2. `watch_window_id`
3. `watch_release_object`
4. `stability_witness`
5. `baseline_drift_ledger_seal`
6. `continuation_clearance`
7. `handoff_release_warranty`
8. `release_verdict`
9. `release_reason`
10. `reopen_residual_gate`

## 8. 苏格拉底式检查清单

在你准备宣布“Prompt 宿主修复已经 released”前，先问自己：

1. 我现在 release 的是对象，还是一段更顺滑的值班叙事。
2. `stability_witness` 证明的是稳定，还是只是平静。
3. `baseline_drift_ledger_seal` 真的 seal 了 drift，还是只是暂时没人再看。
4. handoff release 释放的是 continuation object，还是一段摘要故事。
5. residual reopen gate 还在不在，如果不在，我是在 release，还是在删风险痕迹。

## 9. 一句话总结

真正成熟的 Prompt 宿主修复解除监护执行，不是宣布“现在终于没事了”，而是持续证明同一个 `compiled request truth` 已经可以在不依赖额外监护的前提下继续、交接，并在必要时仍能沿正式 residual gate 重开。
