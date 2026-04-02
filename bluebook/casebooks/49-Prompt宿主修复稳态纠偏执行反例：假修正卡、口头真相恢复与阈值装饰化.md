# Prompt宿主修复稳态纠偏执行反例：假修正卡、口头真相恢复与阈值装饰化

这一章不再回答“Prompt 宿主修复稳态纠偏执行该怎样运行”，而是回答：

- 为什么团队明明已经写了 correction card、recovery verdict order、requalification drill 与 threshold reinstatement drill，仍会重新退回假修正卡、口头真相恢复、前缀复托管表演与阈值装饰化。

它主要回答五个问题：

1. 为什么 Prompt 宿主修复稳态纠偏执行最危险的失败方式不是“没有 correction card”，而是“correction card 存在，却仍围绕 steady note 与 summary 工作”。
2. 为什么假修正卡最容易把 `steady_correction_object_id`、`restored_request_object_id` 与 `compiled_request_hash` 重新退回完工票据。
3. 为什么口头真相恢复最容易把 `truth_continuity_recovery` 重新退回解释得通就算恢复。
4. 为什么前缀复托管表演与阈值装饰化最容易把 `stable_prefix_recustody`、`continuation_requalification` 与 `threshold_reinstatement` 重新退回好运气、默认继续与提醒文字。
5. 怎样用苏格拉底式追问避免把这些反例读成“把 correction card 再填细一点就好”。

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

- Prompt 宿主修复稳态纠偏执行真正最容易失真的地方，不在 correction card 有没有写出来，而在 truth、prefix、continuation 与 threshold 是否仍围绕同一个 `compiled request truth` 运作。

## 1. 第一性原理

Prompt 宿主修复稳态纠偏执行最危险的，不是：

- 没有 correction card
- 没有 recovery verdict order
- 没有 re-entry / reopen drill

而是：

- 这些东西已经存在，却仍然围绕 steady note、summary、平静感与“先继续再说”运作

一旦如此，团队就会重新回到：

1. 看 correction card 是否填写完整
2. 看 summary 是否重新讲通
3. 看 compact 之后摘要还读不读得通
4. 看 later 团队是否主观觉得现在可以继续

而不再围绕：

- 同一个 `compiled request truth`

## 2. 假修正卡：correction by paperwork

### 坏解法

- 宿主、CI、评审与交接系统虽然都拿到了 `correction_card_id` 与 `correction_verdict=steady_state_restored`，但真正执行时只要 correction card 已存在、字段看起来都填了，就默认 `steady_correction_object_id`、`restored_request_object_id` 与 `compiled_request_hash` 已经围绕同一个 request object family 成立。

### 为什么坏

- correction card 保护的不是“现在像一张正式卡”，而是 correction object 仍指向同一个 truth object。
- 一旦修正卡退回完工票据，团队就会重新容忍：
  - `steady_correction_object_id` 只是流水号
  - `compiled_request_hash` 只是抄录值
  - `correction_verdict` 先于对象复核生效
- 这会让完工感直接取代 Prompt 的正式修正对象。

### Claude Code 式正解

- correction verdict 应先绑定同一个 correction object 与同一个 truth lineage，再宣布 restored。

### 改写路径

1. 把“卡已存在”降为次级信号。
2. 把 `steady_correction_object_id + restored_request_object_id + compiled_request_hash` 提升为恢复前提。
3. 任何先看票据、后看对象的 Prompt correction 都判为 drift。

## 3. 口头真相恢复：truth recovery by prose

### 坏解法

- 团队虽然承认 correction 要验证 `truth_continuity_recovery`，但真正执行时只要作者写了一段更完整的说明、summary prose 自洽、later 团队表示“现在我理解了”，就默认 truth 已恢复，不再检查 `truth_lineage_ref`、`protocol_truth_witness` 与 `truth_break_trigger_registered` 是否仍正式存在。

### 为什么坏

- truth recovery 保护的是同一个 `compiled request truth`，不是“我们又把它说明白了”。
- 一旦真相恢复退回 prose，团队就会最先误以为：
  - “解释成立就说明 truth 回来了”
  - “later 读懂了就可以继续”
- 这会让 Prompt 的魔力从编译对象退回叙事文本。

### Claude Code 式正解

- truth recovery 必须围绕 truth lineage 与 protocol witness，而不是围绕 prose handoff 与作者语气。

### 改写路径

1. 把 steady note 与 summary prose 降为评审材料。
2. 把 `truth_continuity_recovery + truth_lineage_ref + protocol_truth_witness` 提升为正式对象。
3. 任何“解释成立即视为 truth 已恢复”的 Prompt correction 都判为 drift。

## 4. 前缀复托管表演：recustody by lucky readability

### 坏解法

- 团队虽然承认 correction 要验证 `stable_prefix_recustody` 与 `baseline_dormancy_reseal`，但真正执行时只要 compact 之后摘要还能读、最近没触发明显 cache break，就默认前缀资产与封存静默已经被正式复托管。

### 为什么坏

- prefix recustody 保护的是可缓存、可转写、可继续的前缀资产，不是“看起来还读得通”。
- dormancy reseal 保护的是 drift 正式被重新封存，不是“最近没再提起”。
- 一旦复托管退回好运气，团队就会最先误以为：
  - “摘要还能读，应该就还是同一前缀”
  - “最近没再炸，应该就已经 reseal”
- 这会把 correction 执行从对象级托管退回偶然平静。

### Claude Code 式正解

- correction 应围绕 stable prefix boundary、compaction lineage 与 dormancy reseal object，而不是让 readability 冒充托管。

### 改写路径

1. 把 compact 可读性与平静感降为观察材料。
2. 把 `stable_prefix_recustody + baseline_dormancy_reseal + compaction_lineage` 提升为正式对象。
3. 任何“还能读就算复托管”的 Prompt correction 都判为 drift。

## 5. 阈值装饰化：threshold by polite reminder

### 坏解法

- 团队虽然写了 `continuation_requalification` 与 `threshold_reinstatement`，但真正值班时只要没有硬错误、token 似乎还够、later 也没提出异议，就默认现在还能继续；阈值只在交接单里写成“以后有问题再 reopen”。

### 为什么坏

- continuation requalification 本质上是在持续判断“现在还配不配继续”，不是给“先继续一下”找借口。
- threshold reinstatement 本质上是在恢复 future reopen 的正式能力，不是补一条更礼貌的提醒。
- 一旦 threshold 退回装饰，Prompt correction execution 就会重新退回：
  - continuation without gate
  - handoff without threshold
  - reopen without boundary
- 这会让 later 团队继承一条没有正式阈值对象的免费时间线。

### Claude Code 式正解

- continuation 与 threshold 必须同时成立；没有 threshold，就只能 `hard_reject`、`reentry_required` 或 `reopen_required`。

### 改写路径

1. 禁止“还没报错”充当 continuation 资格。
2. 把 `continuation_requalification + threshold_reinstatement + truth_break_trigger + rollback_boundary` 提升为硬条件。
3. 任何 threshold 已失忆却仍继续放行的 Prompt correction 都判为 drift。

## 6. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在修回的是同一个 `compiled request truth`，还是一份更正式的修正卡。
2. 我现在保护的是 `stable_prefix_recustody`，还是一次暂时没触发 cache break 的好运气。
3. 我现在恢复的是 `continuation_requalification`，还是一种“先继续再说”的默认冲动。
4. 我现在交接的是 continuity object，还是 later 仍需脑补的 summary prose。
5. `threshold_reinstatement` 还在不在；如果不在，我是在完成纠偏，还是在删除未来反对当前状态的能力。

## 7. 一句话总结

真正危险的 Prompt 宿主修复稳态纠偏执行失败，不是没跑 correction card，而是跑了 correction card 却仍在围绕假修正卡、口头真相恢复、前缀复托管表演与阈值装饰化消费 Prompt 世界。
