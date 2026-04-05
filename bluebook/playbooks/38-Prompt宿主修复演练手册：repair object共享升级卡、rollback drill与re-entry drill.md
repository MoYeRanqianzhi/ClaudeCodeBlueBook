# Prompt宿主修复演练手册：repair object共享升级卡、rollback drill与re-entry drill

这一章不再解释 Prompt 宿主修复协议该消费哪些字段，而是把 Claude Code 式 Prompt 修复压成一张可长期重放、拒收、回滚与重入验证的演练手册。

它主要回答五个问题：

1. 为什么 Prompt 的“魔力”不在措辞，而在把意图编译成同一个 `compiled request truth`，并让修复动作也继续围绕这个对象发生。
2. 宿主、CI、评审与交接怎样共享同一张 Prompt 修复升级卡，而不是各自记录不同版本的修复真相。
3. 应该按什么固定顺序执行 Prompt rollback drill 与 re-entry drill，才能不让旧摘要、旧 transcript 与按钮状态篡位。
4. 哪些停止条件一旦出现就必须拒收当前修复，不允许 later 团队继续站在假真相上工作。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的 Prompt 故障单”。

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

Prompt 宿主修复演练真正要证明的不是：

- prompt 似乎又变稳了
- reviewer 觉得现在可以继续了

而是：

- repair、rollback 与 re-entry 仍围绕同一个 `compiled request truth` 工作

所以这层 playbook 最先要看的不是：

- 修复说明写得是否完整

而是：

1. 当前 `repair_object` 是否仍绑定同一个 `compiled request truth`。
2. `section registry` 与 `stable prefix boundary` 是否仍在保护稳定前缀资产，而不是只剩一段长文案。
3. `protocol transcript` 是否仍优先于 UI transcript，而不是让旧历史与 summary 篡位。
4. lawful forgetting 之后留下的是否仍是 continuation object，而不是交接故事。
5. re-entry 是否仍由预算、hook 与 `continue qualification` 共治，而不是由按钮、`stop_reason` 与最后一条消息裁定。

## 2. 共享升级卡最小字段

每次 Prompt 宿主修复演练，宿主、CI、评审与交接系统至少应共享：

1. `repair_object_id`
2. `source_request_object_id`
3. `target_request_object_id`
4. `compiled_request_hash`
5. `distortion_class`
6. `reject_escalation`
7. `rejected_boundary`
8. `lawful_forgetting_object`
9. `rollback_object`
10. `rollback_boundary`
11. `re_entry_qualification`
12. `required_preconditions`
13. `consumer_verdicts`

四类消费者的分工应固定为：

1. 宿主看 live request object 是否仍绑定到同一个 `compiled request truth`。
2. CI 看 escalation、rollback 与 re-entry 字段是否完整且顺序正确。
3. 评审看 `distortion_class`、`reject_escalation` 与对象边界是否自洽。
4. 交接看 lawful forgetting object 与 `required_preconditions` 是否足以让 later 团队重建同一判断。

## 3. 固定演练顺序

### 3.1 先验 repair object binding

先看：

1. 当前 `repair_object_id` 是否仍指向同一个 request family。
2. `source_request_object_id` 与 `target_request_object_id` 是否解释了修复从哪里回到哪里。
3. `compiled_request_hash`、`section registry` 与 `stable prefix boundary` 是否仍可被复查。

如果这一步不成立，就不应继续看 rollback 或 re-entry。

### 3.2 再验 reject escalation 是否仍围绕对象

再看：

1. `reject_escalation` 是否仍是共享语义，而不是 reviewer 临场结论。
2. `rejected_boundary` 是否能明确指出哪一层 prompt truth 已失守。
3. 是否仍不存在 later 补写 reject reason 或“先继续再补解释”的倒置顺序。

### 3.3 再跑 rollback drill

再看：

1. rollback 是否真的回到同一个 `compiled request truth`。
2. `protocol transcript boundary` 是否仍可重建，而不是退回 UI 历史。
3. `lawful forgetting boundary` 是否仍可复查，而不是让 summary 篡位成主真相。
4. compact 之后 `baseline_reset_required` 是否真的执行，而不是只把状态看起来清爽了。

### 3.4 最后跑 re-entry drill

最后才看：

1. `re_entry_qualification` 是否仍与 `continue qualification` 对齐。
2. `session_state_changed`、`pending_action_ref` 与 `retryable` 是否仍在同一个 gate 里解释。
3. `required_preconditions` 是否足以让 later 团队在不读作者脑内说明的前提下继续。

## 4. 直接停止条件

出现下面情况时，应直接停止当前 Prompt 修复演练并拒收：

1. `repair_object_unbound`
2. `protocol_truth_shadowed`
3. `summary_reentry_only`
4. `rollback_boundary_missing`
5. `continue_gate_overridden`
6. `baseline_reset_missing`
7. `late_reason_invention`
8. `compiled_request_drift_unexplained`

## 5. 最小演练集

每轮至少跑下面六个 Prompt 宿主修复演练：

1. `repair_object_rebinding`
2. `protocol_truth_rollback`
3. `lawful_forgetting_rollback`
4. `summary_shadow_reentry`
5. `continue_gate_replay`
6. `compact_baseline_reset`

## 6. 复盘记录最少字段

每次 Prompt 宿主修复演练失败或回退，至少记录：

1. `repair_object_id`
2. `distortion_class`
3. `reject_escalation`
4. `rejected_boundary`
5. `rollback_boundary`
6. `lawful_forgetting_object`
7. `re_entry_qualification`
8. `required_preconditions`
9. `rollback_action`
10. `consumer_verdicts`

## 7. 苏格拉底式检查清单

在你准备宣布“Prompt 宿主修复演练已经稳定运行”前，先问自己：

1. 我修复的是一个 request object，还是一组解释文本。
2. 我现在回到的是 `compiled request truth`，还是某段更像正确答案的摘要。
3. 当前 rollback 回的是协议边界，还是回到看起来比较熟悉的聊天记录。
4. 当前 re-entry 证明的是同一真相可继续，还是只是系统勉强又能响应。
5. cache、compact 与 continue 是否仍共同服务于单一请求对象，而不是各自生成局部真相。
6. later 团队如果只看升级卡，能否重放同一判断。
7. 我说的 Prompt 魔力，是否仍落在“可编译、可缓存、可转写、可继续”的对象链上，而不是落在措辞崇拜上。
8. 如果今天再次失败，我能指出是哪一层边界坏了，还是只能说‘感觉不稳’。

## 8. 一句话总结

真正成熟的 Prompt 宿主修复演练，不是证明系统又能继续，而是持续证明 repair、rollback 与 re-entry 始终围绕同一个 `compiled request truth` 发生。
