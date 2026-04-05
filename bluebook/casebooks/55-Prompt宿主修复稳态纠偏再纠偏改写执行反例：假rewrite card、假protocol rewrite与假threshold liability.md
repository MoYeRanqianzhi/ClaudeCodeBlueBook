# Prompt宿主修复稳态纠偏再纠偏改写执行反例：假rewrite card、假protocol rewrite与假threshold liability

这一章不再回答“Prompt 宿主修复稳态纠偏再纠偏改写执行该怎样运行”，而是回答：

- 为什么团队明明已经写了 `rewrite card`、`reject verdict order`、`protocol rewrite drill` 与 `threshold liability drill`，仍会重新退回假 `rewrite card`、假 `protocol rewrite`、假 `reject verdict order` 与假 `threshold liability`。

它主要回答五个问题：

1. 为什么 Prompt 宿主修复稳态纠偏再纠偏改写执行最危险的失败方式不是“没有 rewrite card”，而是“rewrite card 存在，却仍围绕 rewrite prose、UI 历史与 summary 平静感工作”。
2. 为什么假 `rewrite card` 最容易把 `rewrite_session_id`、`restored_request_object_id`、`compiled_request_hash` 与 `section_registry_snapshot` 重新退回更体面的票据。
3. 为什么假 `protocol rewrite` 与假 `reject verdict order` 最容易把 `compiled request truth`、`protocol transcript`、`stable prefix` 与 `lawful forgetting boundary` 重新退回可读性与好运气。
4. 为什么假 `threshold liability` 最容易把 `continue qualification` 与 future reopen 的正式能力重新退回“先继续再说”和礼貌说明。
5. 怎样用苏格拉底式追问避免把这些反例读成“把 rewrite card 再填细一点就好”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:491-560`
- `claude-code-source-code/src/utils/queryContext.ts:30-58`
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

- Prompt 宿主修复稳态纠偏再纠偏改写执行真正最容易失真的地方，不在 `rewrite card` 有没有写出来，而在 rewrite 是否仍围绕同一个 `compiled request truth` 编译链，而不是围绕对这条编译链更体面的解释。

## 1. 第一性原理

Prompt 宿主修复稳态纠偏再纠偏改写执行最危险的，不是：

- 没有 `rewrite card`
- 没有 `protocol rewrite drill`
- 没有 `threshold liability drill`

而是：

- 这些东西已经存在，却仍然围绕 rewrite prose、UI transcript、summary handoff 与“现在应该可以继续了”运作

一旦如此，团队就会重新回到：

1. 看 `rewrite card` 是否填写完整。
2. 看改写后的说明是否更清楚。
3. 看 compact 之后摘要是否更顺。
4. 看 later 团队是否主观觉得现在可以继续。

而不再围绕：

- 同一个 `compiled request truth + protocol transcript + stable prefix + lawful forgetting boundary + continue qualification`

## 2. 假rewrite card：rewrite by polished prose

### 坏解法

- 宿主、CI、评审与交接系统虽然都拿到了 `rewrite_card_id` 与 `reject_verdict=steady_state_restituted`，但真正执行时只要 rewrite 说明更完整、handoff 更整洁、字段都填了，就默认 `rewrite_session_id`、`restored_request_object_id`、`compiled_request_hash` 与 `section_registry_snapshot` 仍围绕同一个 request object family 成立。

### 为什么坏

- `rewrite card` 保护的不是“现在更像一张正式卡”，而是改写后的恢复对象仍指向同一个 Prompt 编译对象。
- 一旦 rewrite card 退回完工票据，团队就会重新容忍：
  - `rewrite_session_id` 只是流程流水号
  - `compiled_request_hash` 只是抄录值
  - `section_registry_snapshot` 只是附件
  - `reject_verdict` 先于对象复核生效
- 这会让 rewrite prose 直接取代 Prompt 的正式改写对象。

### Claude Code 式正解

- `reject verdict` 应先绑定同一个 `restored_request_object_id + compiled_request_hash + section_registry_snapshot`，并先完成 `demoted_recorrection_refs` 的降级，再宣布 `steady_state_restituted`。


## 3. 假protocol rewrite 与假reject顺序：reject by readability before truth

### 坏解法

- 团队虽然承认 rewrite 要验证 `compiled request truth restitution`、`protocol transcript repair`、`stable prefix reseal` 与 `lawful forgetting reseal`，但真正执行时只要 UI transcript 被整理得更像样、summary 更会解释、later 团队表示“现在我能看懂了”，就提前落下 `steady_state_restituted`，不再按固定顺序检查 `protocol_transcript_health`、`tool_pairing_health`、`stable_prefix_boundary`、`lawful_forgetting_boundary` 与 `summary_override_blocked`。

### 为什么坏

- Prompt rewrite 的 `reject verdict order` 保护的是编译链对象，而不是“我们终于解释圆了”。
- 一旦 reject 顺序退回可读性优先，团队就会最先误以为：
  - “UI 历史连贯就说明 protocol rewrite 修好了”
  - “cache 暂时没爆就说明 stable prefix 已经 seal”
  - “summary 还能读就说明 lawful forgetting 合法”
- 这会让 Prompt 的魔力从可缓存、可转写、可继续的编译链退回可读性工程。

### Claude Code 式正解

- `reject verdict order` 必须先证明 truth、transcript、prefix 与 forgetting 仍围绕同一个编译对象，再决定 `steady_state_restituted`、`truth_recompile_required`、`protocol_repair_required`、`reentry_required` 或 `reopen_required`。


## 4. 假threshold liability：liability by polite note

### 坏解法

- 团队虽然写了 `continue qualification` 与 `threshold liability reinstatement`，但真正值班时只要没有硬错误、token 看起来还够、later 也没立刻反对，就默认当前 rewrite 已经可以继续；阈值只在交接单里写成“以后有问题再 reopen”。

### 为什么坏

- `continue qualification` 本质上是在持续判断“现在还配不配继续”，不是给“先继续一下”找借口。
- `threshold liability` 本质上是在保留 future reopen 的正式反对能力，不是补一条更礼貌的提醒。
- 一旦 liability 退回装饰，Prompt rewrite execution 就会重新退回：
  - continuation without gate
  - handoff without threshold
  - reopen without boundary
- 这会让 later 团队继承一条没有正式阈值对象的 rewrite 时间线。

### Claude Code 式正解

- continuation 与 threshold liability 必须同时成立；没有 threshold，就只能 `hard_reject`、`truth_recompile_required`、`protocol_repair_required`、`reentry_required` 或 `reopen_required`。


## 5. 为什么这会直接杀死 Prompt 的魔力

- Claude Code 的 Prompt 魔力从来不是 rewrite prose 写得多漂亮，而是 `systemPrompt + userContext + systemContext + protocol transcript` 仍被编译成同一条可缓存、可转写、可继续的请求链。
- 假 `rewrite card` 会把编译对象退回说明对象。
- 假 `protocol rewrite` 会把协议真相退回可读性工程。
- 假 `threshold liability` 会把 future reopen 的正式能力退回一句礼貌说明。
- `agent_listing_delta`、`mcp_instructions_delta`、`skill_discovery` 这类 late-bound attachment 本来就是防止高波动信息污染 stable prefix 的临场阀门；如果把它们误当长期正文，rewrite execution 就会把临场修正误写成宪法正文。

一旦这三件事同时发生，Prompt 世界剩下的就不再是 Claude Code 式编译链，而只是：

1. 更会解释的 rewrite prose。
2. 更平静的 UI 历史。
3. 更难被 later 团队质疑的默认继续。

## 6. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在修回的是同一个 `compiled request truth`，还是一张更正式的 rewrite 卡。
2. 我现在保护的是 `protocol transcript`，还是一段更容易阅读的 UI 历史。
3. 我现在保护的是 `stable prefix` 与 `lawful forgetting boundary`，还是一次暂时没爆的运气。
4. 我现在恢复的是 `continue qualification`，还是一种“先继续再说”的默认冲动。
5. `threshold liability` 还在不在；如果不在，我是在完成 rewrite，还是在删除未来反对当前状态的能力。

## 7. 一句话总结

真正危险的 Prompt 宿主修复稳态纠偏再纠偏改写执行失败，不是没跑 `rewrite card`，而是跑了 `rewrite card` 却仍在围绕假 `rewrite card`、假 `protocol rewrite`、假 `reject verdict order` 与假 `threshold liability` 消费 Prompt 世界。
