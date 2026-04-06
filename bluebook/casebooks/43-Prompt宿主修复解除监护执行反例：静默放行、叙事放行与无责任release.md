# Prompt宿主修复解除监护执行反例：静默放行、叙事放行与无责任 continuation release

这一章不再回答“Prompt 宿主修复解除监护执行该怎样运行”，而是回答：

- 为什么团队明明已经写了 release card、release verdict order、handoff release 与 residual reopen drill，仍会重新退回静默放行、叙事放行与无责任 release。

它主要回答五个问题：

1. 为什么 Prompt 宿主修复解除监护执行最危险的失败方式不是“没有 release card”，而是“release card 存在，却仍围绕值班叙事工作”。
2. 为什么静默放行最容易把 `message lineage` 与 `continuation object` 重新退回“最近没出事”的气氛判断。
3. 为什么叙事放行最容易把 stability witness 与 drift ledger seal 重新退回 watch note、summary 与交接文案。
4. 为什么无责任 release 最容易把 handoff release 与 residual reopen gate 重新退回 later 自觉与经验式兜底。
5. 怎样用苏格拉底式追问避免把这些反例读成“把 release card 再填细一点就好”。

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

这些锚点共同说明：

- Prompt 宿主修复解除监护执行真正最容易失真的地方，不在 `release_verdict` 有没有写出来，而在 released、handoff 与 residual reopen 是否仍围绕同一条 `message lineage`、sealed drift ledger 与 `continuation object` 运作。

## 1. 第一性原理

Prompt 宿主修复解除监护执行最危险的，不是：

- 没有 release card
- 没有 handoff release
- 没有 residual reopen drill

而是：

- 这些东西已经存在，却仍然围绕 watch note、summary handoff 与“最近没出事”运作

一旦如此，团队就会重新回到：

1. 看值班备注是不是没有新增告警
2. 看交接摘要是不是还说得通
3. 看 later 团队是不是主观觉得现在可以继续
4. 看 residual reopen 是不是“以后再说”

而不再围绕：

- 同一条 `message lineage`
- 同一个 `continuation object`

## 2. 静默放行：released by silence

### 坏解法

- 宿主、CI、评审与交接系统虽然都拿到了 `release_verdict=released`，但真正执行时只要 watch window 里一段时间没有新噪音，就默认 `stability_witness` 仍然成立，不再检查 `message_lineage_ref`、`projection_consumer_alignment` 与 `drift_free_span` 是否仍指向同一个 Prompt 世界。

### 为什么坏

- `released` 不是情绪平静，而是对象级稳定性被正式证明。
- 一旦 release 退回静默，团队就会重新容忍：
  - `stability_witness` 只是“一段时间没事”
  - `message_lineage_ref` 只是抄录值
  - `projection_consumer_alignment` 只是默认正常
- 这会让“目前没有波动”的平静感直接取代 Prompt 的正式真相面。

### Claude Code 式正解

- released verdict 应先绑定同一条 `message lineage` 与同一个稳定 witness，再宣布 release。

## 3. 叙事放行：narrative release

### 坏解法

- 团队虽然承认 release 要验证 `baseline_drift_ledger_seal`、`continuation_clearance` 与 `handoff_release_warranty`，但真正执行时只要看到 watch 总结、closeout 文案与 handoff 文本自洽，就默认 baseline 已 seal、later 已可接手。

### 为什么坏

- drift ledger 记录的是 protocol transcript 与 lawful forgetting 的对象漂移，不是解释文本是否完整。
- handoff release 保护的是 `continuation object`，而不是故事是否可读。
- 一旦 release 退回叙事，团队就会最先误以为：
  - “原因说清了，应该就可以 release”
  - “summary 很完整，later 应该能接”
- 这会让 Prompt 解除监护从对象级释放退回一份更会解释的故事。

### Claude Code 式正解

- release 应围绕 sealed ledger、clearance 与 `continuation object`，而不是让交接叙事替代它们。

## 4. 无责任 release：release without residual gate

### 坏解法

- 团队虽然写了 `reopen_residual_gate`，但真正放行时只要 handoff 放出去了、later 说能接，就默认 residual reopen 可以以后再补，不再检查 `rollback_boundary`、`reopen_liability_record` 与 `gate_retained_until` 是否仍存在。

### 为什么坏

- release 的本质是合法撤掉额外保护层，不是把 residual risk 一起遗忘。
- 一旦 residual gate 跟着 release 一起消失，Prompt 解除监护执行就会重新退回：
  - handoff without liability
  - continuation without gate
  - reopen without boundary
- 这会让 later 团队继承一条没有正式责任对象的免费时间线。

### Claude Code 式正解

- handoff release 与 residual reopen 必须同时成立；没有 residual gate，就只能 `monitor_extended` 或 `reopen_required`。

## 5. gate 装饰化：residual reopen 退回日历提醒

### 坏解法

- 团队只要在工单系统里挂一个后续检查提醒，就默认 residual reopen 已存在；即使 `gate_retained_until` 已过、`release_reason` 已变，仍不升级 verdict，不冻结 handoff，也不回到同一条 `message lineage`。

### 为什么坏

- residual gate 是未来重开责任，不是日历装饰。
- 一旦 gate 退回提醒，团队就会重新容忍：
  - 过期 gate 继续冒充有效责任
  - 过期 release 继续允许 later 继续消费
  - 过期 handoff 继续被当作正式交付
- 这会把 release 从正式时态退回任务提醒。

### Claude Code 式正解

- residual reopen gate 应是 verdict 升级器，而不是日历装饰。

## 6. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在 release 的是 `message lineage`，还是一份更顺滑的值班叙事。
2. 我现在保护的是 `stability_witness`，还是一段时间的平静感。
3. 我现在放行的是 `continuation object`，还是一段更好读的 summary。
4. 我现在保留的是 residual reopen gate，还是一条“以后再看”的提醒。
5. 我现在保护的是单一真相的继续条件，还是 released 的情绪感受。

## 7. 一句话总结

真正危险的 Prompt 宿主修复解除监护执行失败，不是没写 release card，而是写了 release card 却仍在围绕静默放行、叙事放行与无责任 continuation release 消费 Prompt 世界。
