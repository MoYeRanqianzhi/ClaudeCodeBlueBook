# Prompt宿主修复稳态纠偏再纠偏执行反例：假recorrection card、假protocol repair与假threshold liability

这一章不再回答“Prompt 宿主修复稳态纠偏再纠偏执行该怎样运行”，而是回答：

- 为什么团队明明已经写了 `recorrection card`、`reject verdict order`、`protocol repair drill` 与 `threshold liability drill`，仍会重新退回假 `recorrection card`、假 `protocol repair`、假 `lawful forgetting reseal` 与假 `threshold liability`。

它主要回答五个问题：

1. 为什么 Prompt 宿主修复稳态纠偏再纠偏执行最危险的失败方式不是“没有 recorrection card”，而是“recorrection card 存在，却仍围绕 prompt 文案、UI 历史与 summary 平静感工作”。
2. 为什么假 `recorrection card` 最容易把 `recorrection_object_id`、`restored_request_object_id` 与 `compiled_request_hash` 重新退回完工票据。
3. 为什么假 `protocol repair` 最容易把 `protocol transcript health` 重新退回 UI transcript 清理与解释得通就算修好。
4. 为什么假 `lawful forgetting reseal` 与假 `threshold liability` 最容易把合法遗忘、继续资格与 future reopen 的正式能力重新退回可读性、默认继续与提醒文字。
5. 怎样用苏格拉底式追问避免把这些反例读成“把 recorrection card 再填细一点就好”。

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

- Prompt 宿主修复稳态纠偏再纠偏执行真正最容易失真的地方，不在 `recorrection card` 有没有写出来，而在 `compiled request truth`、`protocol transcript`、`lawful forgetting`、`continue qualification` 与 `threshold liability` 是否仍围绕同一个 Prompt 编译对象运作。

## 1. 第一性原理

Prompt 宿主修复稳态纠偏再纠偏执行最危险的，不是：

- 没有 `recorrection card`
- 没有 `protocol repair drill`
- 没有 `threshold liability drill`

而是：

- 这些东西已经存在，却仍然围绕 prompt 文案、UI transcript、summary prose 与“先继续再说”运作

一旦如此，团队就会重新回到：

1. 看 `recorrection card` 是否填写完整
2. 看 UI 历史是否重新连贯
3. 看 compact 之后摘要还读不读得通
4. 看 later 团队是否主观觉得现在可以继续

而不再围绕：

- 同一个 `compiled request truth`

## 2. 假 recorrection card：recorrection by paperwork

### 坏解法

- 宿主、CI、评审与交接系统虽然都拿到了 `recorrection_card_id` 与 `reject_verdict=steady_state_restituted`，但真正执行时只要 `recorrection card` 已存在、字段看起来都填了，就默认 `recorrection_object_id`、`restored_request_object_id` 与 `compiled_request_hash` 已经围绕同一个 request object family 成立。

### 为什么坏

- `recorrection card` 保护的不是“现在像一张正式卡”，而是再纠偏对象仍指向同一个 truth object。
- 一旦再纠偏卡退回完工票据，团队就会重新容忍：
  - `recorrection_object_id` 只是流水号
  - `compiled_request_hash` 只是抄录值
  - `reject_verdict` 先于对象复核生效
- 这会让完工感直接取代 Prompt 的正式再纠偏对象。

### Claude Code 式正解

- `reject verdict` 应先绑定同一个 recorrection object 与同一个 truth lineage，再宣布 `steady_state_restituted`。


## 3. 假 protocol repair：repair by readable transcript

### 坏解法

- 团队虽然承认 recorrection 要验证 `protocol_transcript_health`，但真正执行时只要 UI transcript 被整理得更像样、tool use 读起来没那么乱、later 团队表示“现在我能看懂了”，就默认 protocol 已修好，不再检查 `tool_pairing_health`、`transcript_boundary_attested` 与 `protocol_rewrite_version` 是否仍正式存在。

### 为什么坏

- protocol repair 保护的是模型真正消费的协议真相，不是“我们又把历史整理顺了”。
- 一旦 protocol repair 退回可读性，团队就会最先误以为：
  - “UI 历史连贯就说明 transcript 修好了”
  - “later 读懂了就可以继续”
- 这会让 Prompt 的魔力从编译对象退回叙事文本。

### Claude Code 式正解

- protocol repair 必须围绕 protocol transcript、tool pairing 与 boundary 证明，而不是围绕 UI transcript 与 prose handoff。


## 4. 假 lawful forgetting reseal：forgetting by summary override

### 坏解法

- 团队虽然写了 `lawful forgetting reseal`，但真正 compact 后只要摘要还能读、later 觉得关键信息大致还在，就默认合法遗忘边界已经重新封住，不再检查 `lawful_forgetting_boundary`、`preserved_segment_ref` 与 `summary_override_blocked` 是否仍正式存在。

### 为什么坏

- lawful forgetting 保护的是删掉什么以后仍能继续，不是“摘要是否还算完整”。
- 一旦遗忘重封退回可读性，团队就会重新容忍：
  - summary override 偷走 preserved segment
  - compact prose 冒充正式边界
  - later 靠作者补充说明来补回被忘掉的部分
- 这会让 Prompt 的长期可继续性从合同退回记忆运气。

### Claude Code 式正解

- lawful forgetting 必须围绕 boundary、preserved segment 与 override block，而不是围绕 summary readability。


## 5. 假 threshold liability：liability by polite note

### 坏解法

- 团队虽然写了 `continue qualification` 与 `threshold liability reinstatement`，但真正值班时只要没有硬错误、token 似乎还够、later 也没提出异议，就默认现在还能继续；阈值只在交接单里写成“以后有问题再 reopen”。

### 为什么坏

- continue qualification 本质上是在持续判断“现在还配不配继续”，不是给“先继续一下”找借口。
- threshold liability 本质上是在恢复 future reopen 的正式反对能力，不是补一条更礼貌的提醒。
- 一旦 threshold 退回装饰，Prompt recorrection execution 就会重新退回：
  - continuation without gate
  - handoff without threshold
  - reopen without boundary
- 这会让 later 团队继承一条没有正式阈值对象的免费时间线。

### Claude Code 式正解

- continuation 与 threshold liability 必须同时成立；没有 threshold，就只能 `hard_reject`、`truth_recompile_required`、`protocol_repair_required`、`reentry_required` 或 `reopen_required`。


## 6. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在修回的是同一个 `compiled request truth`，还是一张更正式的再纠偏卡。
2. 我现在修回的是 `protocol transcript`，还是一段更容易阅读的 UI 历史。
3. 我现在保护的是 `lawful forgetting boundary`，还是一份更顺手的 summary。
4. 我现在恢复的是 `continue qualification`，还是一种“先继续再说”的默认冲动。
5. `threshold liability` 还在不在；如果不在，我是在完成再纠偏，还是在删除未来反对当前状态的能力。

## 7. 一句话总结

真正危险的 Prompt 宿主修复稳态纠偏再纠偏执行失败，不是没跑 `recorrection card`，而是跑了 `recorrection card` 却仍在围绕假 `recorrection card`、假 `protocol repair`、假 `lawful forgetting reseal` 与假 `threshold liability` 消费 Prompt 世界。
