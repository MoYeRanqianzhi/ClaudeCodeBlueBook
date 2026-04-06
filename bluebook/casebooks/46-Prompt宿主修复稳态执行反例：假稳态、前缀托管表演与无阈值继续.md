# Prompt宿主修复稳态执行反例：lineage 假稳态、前缀托管表演与无阈值继续

这一章不再回答“Prompt 宿主修复稳态执行该怎样运行”，而是回答：

- 为什么团队明明已经写了 steady-state card、continuity verdict order、re-entry threshold 与 residual reopen drill，仍会重新退回假稳态、前缀托管表演与无阈值继续。

它主要回答五个问题：

1. 为什么 Prompt 宿主修复稳态执行最危险的失败方式不是“没有 steady-state card”，而是“steady-state card 存在，却仍围绕 summary 平静感工作”。
2. 为什么假稳态最容易把 `message lineage` 与 `protocol transcript` 重新退回“最近一直很稳”的气氛判断。
3. 为什么前缀托管表演最容易把 `stable prefix boundary`、`compaction lineage` 与 `cache-safe fork reuse` 重新退回摘要好运气与交接叙事。
4. 为什么无阈值继续最容易把 `continuation object`、`continuation qualification` 与 `reopen threshold` 重新退回默认继续与以后再说。
5. 怎样用苏格拉底式追问避免把这些反例读成“把 steady-state card 再填细一点就好”。

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

这些锚点共同说明：

- Prompt 宿主修复稳态执行真正最容易失真的地方，不在 `steady_verdict` 有没有写出来，而在 `message lineage`、projection consumer alignment、`protocol transcript`、`stable prefix boundary`、`continuation object` 与 `continuation qualification` 是否仍在围绕同一套对象工作。

## 1. 第一性原理

Prompt 宿主修复稳态执行最危险的，不是：

- 没有 steady-state card
- 没有 handoff continuity
- 没有 reopen threshold drill

而是：

- 这些东西已经存在，却仍然围绕 summary、平静感与“应该还能继续”运作

一旦如此，团队就会重新回到：

1. 看最近有没有新的异常文本
2. 看 compact 之后摘要还说不说得通
3. 看 later 团队是否主观觉得现在可以继续
4. 看 residual reopen 是不是以后再说

而不再围绕：

- 同一条 `message lineage -> protocol transcript -> stable prefix boundary -> continuation object -> continuation qualification`

## 2. 假稳态：steady by calmness

### 坏解法

- 宿主、CI、评审与交接系统虽然都拿到了 `steady_verdict=steady_state`，但真正执行时只要 release 之后一段时间没有新噪音，就默认 `truth_continuity` 与 `baseline_dormancy_seal` 仍然成立，不再检查 `message_lineage_ref`、`protocol_transcript_ref` 与 `dormancy_started_at` 是否仍指向同一个 continuation family。

### 为什么坏

- steady 不是情绪平静，而是对象级连续性被正式证明。
- 一旦稳态退回平静感，团队就会重新容忍：
  - `truth_continuity` 只是收尾名词
  - `baseline_dormancy_seal` 只是“最近没事”
  - `message_lineage_ref` 与 `protocol transcript` 只是抄录值
- 这会让“目前没有波动”的平静感直接取代 Prompt 的正式真相面。

### Claude Code 式正解

- steady verdict 应先绑定同一条 `message lineage` 与同一个 `protocol transcript`，再宣布 steady。

## 3. 前缀托管表演：custody by lucky summary

### 坏解法

- 团队虽然承认 steady 要验证 `stable_prefix_custody`、`compaction_lineage` 与 `handoff_continuity_warranty`，但真正执行时只要看到 compact summary 还能读、handoff prose 自洽，就默认前缀资产与交接连续性仍被正式托管。

### 为什么坏

- prefix custody 保护的是可缓存、可转写、可继续的前缀资产，不是解释文本是否完整。
- handoff continuity 保护的是 `continuation object`，而不是故事是否可读。
- `cache-safe fork reuse` 保护的是 later extension 仍来自同一前缀家族，而不是“这次 compact 后看起来还通顺”。
- 一旦 steady 退回托管表演，团队就会最先误以为：
  - “summary 很完整，应该就还是同一前缀”
  - “交接很清楚，later 应该能接”
- 这会让 Prompt 的魔力从对象级前缀资产退回一份更会解释的故事。

### Claude Code 式正解

- steady 应围绕 `stable prefix boundary`、`compaction lineage`、`cache-safe fork reuse` 与 `handoff continuity object`，而不是让 summary prose 替代它们。

## 4. 无阈值继续：continuation without threshold

### 坏解法

- 团队虽然写了 `reopen_threshold`，但真正值班时只要没有硬错误、token 似乎还够、later 也没提出异议，就默认 `continuation_eligibility` 仍成立，不再检查 `continuation_object_ref`、`continue_qualification`、`token_budget_ready`、`rollback_boundary` 与 `truth_break_trigger` 是否仍存在。

### 为什么坏

- continuation eligibility 本质上是在持续判断“现在还配不配继续”，不是给“再试一下”找借口。
- `continuation object` 在源码里虽然命名不硬，但行为上至少已经绑定了 current work、next-step guard、required assets、rollback boundary、continue qualification 与 threshold liability。
- 一旦 threshold 跟着 steady 一起消失，Prompt 稳态执行就会重新退回：
  - continuation without gate
  - handoff without threshold
  - reopen without boundary
- 这会让 later 团队继承一条没有正式阈值对象的免费时间线。

### Claude Code 式正解

- `continuation object`、`continuation qualification` 与 `reopen threshold` 必须同时成立；没有 threshold，就只能 `steady_state_blocked`、`reentry_required` 或 `reopen_required`。
- 更稳的稳态交接不是一句“后面继续就行”，而是 later 团队能直接接手同一个 current work、同一组 required assets 与同一个 rollback boundary。

## 5. handoff 连续性口头化：continuity 退回作者语气

### 坏解法

- 团队虽然写了 `handoff_continuity_warranty`，但真正交接时只要作者补一句“后面照着这个方向继续就行”，later 也表示理解，就默认 continuity 已转交，不再检查 `resume_lineage_attested`、`summary_carry_forward_attested`、`lawful_forgetting_boundary_attested` 与 `author_memory_not_required` 是否仍成立。

### 为什么坏

- continuity 保护的是 later 团队无须继承作者记忆，也能围绕同一条 lineage 与同一个 continuation object 继续。
- 一旦 continuity 退回口头化，steady 就会重新容忍：
  - 作者记忆继续充当主对象
  - later 团队靠情境理解补齐边界
  - summary 被误当正式 lineage

### Claude Code 式正解

- handoff continuity 必须围绕 `resume lineage`、`carry-forward object` 与 `lawful forgetting boundary`，而不是围绕作者语气与说明文字。

## 6. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在 steady 的是 `message lineage` 与 `protocol transcript`，还是一段更顺滑的稳态叙事。
2. 我现在保护的是 `stable prefix boundary` 与 `cache-safe fork reuse`，还是一次暂时没出 cache break 的好运气。
3. 我现在放行的是 `continuation object`，还是一种“先继续再说”的情绪。
4. 我现在保留的是 `continuation qualification` 与 `reopen threshold`，还是一句“以后有问题再看”。
5. 我现在保护的是单一真相的继续条件，还是 steady 的感觉本身。

## 7. 一句话总结

真正危险的 Prompt 宿主修复稳态执行失败，不是没写 steady-state card，而是写了 steady-state card 却仍在围绕 lineage 假稳态、前缀托管表演与无阈值继续消费 Prompt 世界。
