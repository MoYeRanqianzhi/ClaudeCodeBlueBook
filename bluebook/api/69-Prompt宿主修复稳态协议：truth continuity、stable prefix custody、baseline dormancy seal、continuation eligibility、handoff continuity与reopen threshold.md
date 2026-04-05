# Prompt宿主修复稳态协议：truth continuity、stable prefix custody、baseline dormancy seal、continuation eligibility、handoff continuity与reopen threshold

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象让宿主、SDK、CI、评审与交接系统在 Prompt release correction 之后消费无人盯防延续、交接连续性与 residual reopen threshold。
2. 哪些字段属于必须消费的 Prompt steady-state object，哪些属于 verdict 语义，哪些仍然不应被绑定成公共 ABI。
3. 为什么 Prompt 稳态协议不应退回 summary prose、watch note 与“最近一直很稳”。
4. 宿主开发者该按什么顺序消费这套 Prompt steady-state 规则面。
5. 哪些现象一旦出现应被直接升级为 steady-state blocked、truth recompile required 或 reopen threshold reached，而不是继续宣称已经稳定。

## 0. 关键源码锚点

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
- `claude-code-source-code/src/query.ts:1308-1518`

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `PromptRepairSteadyStateContract`

的单独公共对象。

但 Prompt 宿主修复稳态实际上已经能围绕六类正式对象稳定成立：

1. `truth_continuity`
2. `stable_prefix_custody`
3. `baseline_dormancy_seal`
4. `continuation_eligibility`
5. `handoff_continuity_warranty`
6. `reopen_threshold`

更成熟的 Prompt 稳态方式不是：

- 只看 released 之后最近很平静
- 只看 compact summary 还读得通
- 只看 later 团队表示“应该能继续”

而是：

- 围绕这六类对象消费 Prompt 世界怎样在停止额外监护之后，仍继续围绕同一个 `compiled request truth` 可缓存、可转写、可继续、可重开

## 2. truth continuity：最小稳态对象

宿主应至少围绕下面对象消费 Prompt 稳态真相：

1. `steady_state_object_id`
2. `restored_request_object_id`
3. `compiled_request_hash`
4. `truth_continuity_attested`
5. `steady_state_since_turn`
6. `steady_state_evaluated_at`

这些字段回答的不是：

- 现在看起来还像不像同一轮对话

而是：

- 当前到底围绕哪个 request object、以哪个 truth lineage 进入了无人盯防稳态

## 3. stable prefix custody 与 baseline dormancy seal

Prompt 宿主还必须显式消费：

### 3.1 stable prefix custody

1. `stable_prefix_boundary`
2. `cache_break_budget`
3. `summary_rewrite_consistency`
4. `compaction_lineage`
5. `prefix_custody_attested`

### 3.2 baseline dormancy seal

1. `baseline_drift_ledger_id`
2. `dormancy_started_at`
3. `sealed_generation`
4. `narrative_override_blocked`
5. `reactivation_trigger_registered`

这说明宿主当前消费的不是：

- 一段更像样的 summary
- 一次“最近没再出事”的观察感受

而是：

- `stable prefix custody + baseline dormancy seal` 共同组成的 Prompt 稳态证明

## 4. continuation eligibility、handoff continuity warranty 与 reopen threshold

Prompt 稳态还必须消费：

### 4.1 continuation eligibility

1. `continue_qualification`
2. `token_budget_ready`
3. `tool_use_summary_ready`
4. `session_resume_ready`
5. `eligibility_expires_at`

### 4.2 handoff continuity warranty

1. `handoff_package_hash`
2. `resume_lineage_attested`
3. `summary_carry_forward_attested`
4. `author_memory_not_required`
5. `continuity_warranty_status`

### 4.3 reopen threshold

1. `truth_break_trigger`
2. `cache_break_threshold`
3. `rollback_boundary`
4. `threshold_retained_until`
5. `reopen_required`

这三组对象回答的不是：

- later 团队现在主观上能不能接着做
- 断了之后大家能不能临时再补一句说明

而是：

- continuation 是否仍围绕同一个 truth object 合法继续
- handoff 是否不再依赖作者临场解释
- steady state 一旦破坏，系统是否仍保留正式 reopen threshold

## 5. steady-state verdict：必须共享的稳态语义

更成熟的 Prompt 宿主稳态 verdict 至少应共享下面枚举：

1. `steady_state`
2. `steady_state_blocked`
3. `truth_recompile_required`
4. `prefix_custody_missing`
5. `continuation_expired`
6. `handoff_continuity_blocked`
7. `reopen_threshold_reached`

这些 verdict reason 的价值在于：

- 把“released 之后仍继续说真话”翻译成宿主、CI、评审与交接都能共享的 Prompt post-watch 语义

## 6. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. 最后一段 compact summary 文案
2. “最近平静时长”单值
3. handoff prose 摘要
4. compact 后页面长度
5. 最后一条消息文本
6. 人工安抚式说明
7. session 标题
8. release 后补写 note

它们可以是稳态线索，但不能是稳态对象。

## 7. 稳态消费顺序建议

更稳的顺序是：

1. 先验 `truth_continuity`
2. 再验 `stable_prefix_custody`
3. 再验 `baseline_dormancy_seal`
4. 再验 `continuation_eligibility`
5. 再验 `handoff_continuity_warranty`
6. 最后验 `reopen_threshold`

不要反过来做：

1. 不要先看 summary 还能不能读。
2. 不要先看最近是否平静。
3. 不要先看 later 团队是否主观放心。

## 8. 苏格拉底式检查清单

在你准备宣布“Prompt 已进入稳态”前，先问自己：

1. 我现在保护的是 `compiled request truth`，还是一份更耐读的 summary。
2. `stable prefix custody` 保住的是同一前缀资产，还是一次暂时没触发 cache break 的好运气。
3. `continuation eligibility` 证明的是继续资格，还是只是大家愿意先继续。
4. handoff continuity 释放的是对象，还是故事。
5. `reopen threshold` 还在不在，如果不在，我是在进入稳态，还是在删除未来反对当前状态的能力。

## 9. 一句话总结

Claude Code 的 Prompt 宿主修复稳态协议，不是 release 之后的安静期说明 API，而是 `truth continuity + stable prefix custody + baseline dormancy seal + continuation eligibility + handoff continuity warranty + reopen threshold` 共同组成的规则面。
