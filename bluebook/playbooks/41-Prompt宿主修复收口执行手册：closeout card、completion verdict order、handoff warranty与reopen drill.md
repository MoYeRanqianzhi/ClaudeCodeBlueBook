# Prompt宿主修复收口执行手册：closeout card、completion verdict order、handoff warranty与reopen drill

这一章不再解释 Prompt 宿主修复收口协议该消费哪些字段，而是把 Claude Code 式 Prompt 收口压成一张可持续执行的收口手册。

它主要回答五个问题：

1. 宿主、CI、评审与交接怎样共享同一张 Prompt closeout card，而不是各自宣布不同版本的“已经修好”。
2. 应该按什么固定顺序执行 Prompt 收口，才能真正宣布同一个 `compiled request truth` 已经恢复、可交接并可继续。
3. 哪些 verdict reason 一旦出现就必须立即阻断 handoff、拒绝 closeout 并进入 reopen drill。
4. 哪些 reopen 演练最能暴露 Prompt 修复又重新退回事故叙事、summary handoff 与默认继续。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的 closeout 表单”。

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

Prompt 宿主修复收口真正要执行的不是：

- 事故说明已经写完了
- closeout verdict 已经填成 `closed`

而是：

- 宿主、CI、评审与交接仍围绕同一个 `compiled request truth` 在宣布恢复、交接与继续

所以这层 playbook 最先要看的不是：

- 收口卡已经填完了

而是：

1. 当前判断对象是否仍是 `restored request object`。
2. `protocol truth witness` 是否仍是正式权威证据，而不是修复解释摘要。
3. rollback 是否仍围绕同一个 boundary 与 lawful forgetting witness。
4. handoff 是否仍围绕 continuation object，而不是围绕 summary 故事。
5. reopen 是否仍由 `re_entry warranty` 与 reopen trigger 裁定，而不是由按钮、情绪与“现在似乎又能继续”裁定。

## 2. 共享收口卡最小字段

每次 Prompt 宿主修复收口，宿主、CI、评审与交接系统至少应共享：

1. `closeout_card_id`
2. `restored_request_object_id`
3. `compiled_request_hash`
4. `section_registry_snapshot`
5. `protocol_truth_witness`
6. `rollback_witness`
7. `lawful_forgetting_witness`
8. `re_entry_warranty`
9. `handoff_warranty`
10. `closeout_verdict`
11. `verdict_reason`
12. `consumer_readiness`

四类消费者的分工应固定为：

1. 宿主看 live request object 是否仍是同一个 `compiled request truth`。
2. CI 看 witness 与 verdict 顺序是否完整。
3. 评审看 `verdict_reason` 与对象边界是否自洽。
4. 交接看 handoff warranty 与 reopen trigger 是否足以让 later 团队安全接手。

## 3. 固定完成判定顺序

### 3.1 先验 restored request object

先看：

1. 当前 closeout 对象是否仍是 `restored_request_object`。
2. `compiled_request_hash`、`section registry` 与 `stable prefix boundary` 是否仍可复查。
3. source/target request object 是否仍解释了修复从哪里回到哪里。

只要这一步不成立，就不应继续看 handoff 或 reopen。

### 3.2 再验 protocol truth witness

再看：

1. 当前 `protocol_truth_witness` 是否仍能证明模型看到的是 rewrite 后 transcript。
2. tool/result pairing 是否仍健康。
3. CI 与评审是否仍围绕 protocol witness，而不是围绕事故说明判断。

### 3.3 再验 rollback witness

再看：

1. `rollback_boundary` 是否仍可复查。
2. lawful forgetting witness 是否仍证明 compact 后边界没有失守。
3. `baseline_reset_witness` 是否仍成立，而不是只剩状态看起来清爽。

### 3.4 再验 handoff warranty

再看：

1. 交接对象是否仍是 continuation object，而不是 summary。
2. `consumer_readiness.handoff` 是否真的建立在 `required_preconditions` 上。
3. 当前交接是否仍足以让 later 团队重建同一判断。

### 3.5 最后验 closeout verdict 与 reopen drill

最后才看：

1. `closeout_verdict` 是否与前四步的 witness 一致。
2. `reopen_trigger` 是否明确指出何时必须重新开闸。
3. reopen 是否仍回到同一个 `compiled request truth` 边界，而不是回到某段 summary 或旧消息。

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前 Prompt closeout：

1. `request_object_not_restored`
2. `protocol_witness_missing`
3. `rollback_witness_missing`
4. `summary_only_closeout`
5. `re_entry_not_warranted`
6. `baseline_reset_unproven`
7. `handoff_not_ready`
8. `reopen_required`

## 5. 交接与 reopen 顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先冻结 handoff，不再让 later 消费当前 closeout 工件。
2. 先把当前 verdict 降级为 `monitor_only` 或 `reopen_required`，不允许继续冒充 `closed`。
3. 先回到上一个仍可验证的 request object 或 lawful forgetting boundary。
4. 先补新的 witness，再允许重新发放 handoff warranty。
5. 如果根因落在修复制度本身，就回跳 `../guides/63` 做纠偏改写。

## 6. 最小 reopen 演练集

每轮至少跑下面六个 Prompt 宿主收口执行演练：

1. `protocol_witness_recheck`
2. `summary_handoff_block`
3. `rollback_boundary_reopen`
4. `re_entry_warranty_recheck`
5. `baseline_reset_recheck`
6. `handoff_ready_replay`

## 7. 复盘记录最少字段

每次 Prompt 宿主收口失败或 reopen，至少记录：

1. `closeout_card_id`
2. `restored_request_object_id`
3. `protocol_truth_witness`
4. `rollback_boundary`
5. `handoff_warranty`
6. `closeout_verdict`
7. `verdict_reason`
8. `reopen_trigger`
9. `rollback_action`
10. `consumer_readiness`

## 8. 苏格拉底式检查清单

在你准备宣布“Prompt 宿主修复已经正式收口”前，先问自己：

1. 我宣布收口的是 request object，还是事故说明。
2. 我现在看到的是 protocol witness，还是一段更会解释的修复文本。
3. handoff 交的是 continuation object，还是一段可读故事。
4. reopen 回到的是对象边界，还是 summary 与最后一条消息。
5. 如果接手人不读源码，只看我的收口卡，能不能重建同一判断。

## 9. 一句话总结

真正成熟的 Prompt 宿主修复收口执行，不是把 closeout verdict 写进表单，而是持续证明宿主、CI、评审与交接仍围绕同一个 `compiled request truth` 宣布结束、交接与重开。
