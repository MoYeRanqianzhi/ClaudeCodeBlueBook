# Prompt宿主修复收口执行反例：假完成、假交接与假reopen

这一章不再回答“Prompt 宿主修复收口执行该怎样运行”，而是回答：

- 为什么团队明明已经写了 closeout card、completion verdict order、handoff warranty 与 reopen drill，仍会重新退回假完成、假交接与假 reopen。

它主要回答五个问题：

1. 为什么 Prompt 宿主修复收口执行最危险的失败方式不是“没有收口卡”，而是“收口卡存在，却仍围绕解释文本工作”。
2. 为什么假完成最容易把 `compiled request truth` 重新退回 closeout verdict、事故总结与 summary-only closeout。
3. 为什么 protocol truth 与 lawful forgetting 最容易在交接阶段重新退回摘要 handoff。
4. 为什么假 reopen 最容易把对象级重开重新退回最后一条消息、旧 summary 与按钮状态。
5. 怎样用苏格拉底式追问避免把这些反例读成“把 closeout card 再填细一点就好”。

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

这些锚点共同说明：

- Prompt 宿主修复收口执行真正最容易失真的地方，不在 closeout verdict 有没有写出来，而在完成、交接与 reopen 是否仍围绕同一个 `compiled request truth`、`protocol transcript`、lawful forgetting boundary 与 `re_entry_warranty` 运作。

## 1. 第一性原理

Prompt 宿主修复收口执行最危险的，不是：

- 没有 closeout card
- 没有 handoff warranty
- 没有 reopen drill

而是：

- 这些东西已经存在，却仍然围绕 closeout 说明、摘要交接与“似乎还能继续”运作

一旦如此，团队就会重新回到：

1. 看 closeout verdict 是不是填成 `closed`
2. 看修复总结是不是说得通
3. 看 handoff 包是不是可读
4. 看 reopen 按钮是不是还能点

而不再围绕：

- 同一个 `compiled request truth`

## 2. 假完成：closeout verdict 盖住 request object 漂移

### 坏解法

- 宿主、CI、评审与交接系统虽然都拿到了 `closeout_verdict=closed`，但没有继续核对 `restored_request_object_id`、`compiled_request_hash`、`section_registry_snapshot` 与 `stable_prefix_boundary` 是否仍在描述同一个请求对象。

### 为什么坏

- Claude Code 的 Prompt 魔力不在“closeout 文案更完整”，而在 repair closeout 仍绑定同一个已编译请求对象。
- 一旦 `closeout_verdict` 先于 request object 校验上位，就会重新容忍：
  - `restored_request_object` 只是票据关系
  - `compiled_request_hash` 只是抄录值
  - `section registry` 与 stable prefix boundary 退回作者脑内边界
- 这会让“已经关闭”的完成感直接取代 Prompt 的正式真相面。

### Claude Code 式正解

- 完成 verdict 应先证明同一个 request object 仍成立，再宣布 closeout。

### 改写路径

1. 把 `closed` 降为结果信号。
2. 把 `restored_request_object_id + compiled_request_hash + section_registry_snapshot` 提升为完成前提。
3. 任何先看 verdict、后看对象的 Prompt closeout 都判为 drift。

## 3. protocol witness 漂白：解释文本冒充协议真相

### 坏解法

- 团队虽然承认 closeout 要验证 `protocol_truth_witness`，但真正执行时只要看到修复总结、复盘结论与 review comment 自洽，就默认 protocol world 已经恢复。

### 为什么坏

- Claude Code 真正面向模型的是 rewrite 后的 protocol transcript，而不是 UI 历史或事故总结。
- 一旦解释文本替代 protocol witness，团队就会最先误以为：
  - “原因说清了，应该就收口了”
  - “summary 很完整，later 应该能接”
- 这会让 Prompt 收口从对象级 witness 退回一份更会解释的文本。

### Claude Code 式正解

- closeout 应持续验证 protocol truth，而不是让修复说明替代它。

### 改写路径

1. 把 closeout 解释降为评审材料。
2. 把 `protocol_transcript_witness + tool_pairing_health + truth_boundary_attested` 提升为正式对象。
3. 任何“解释成立即视为 protocol 收口完成”的 Prompt closeout 都判为 drift。

## 4. 假交接：handoff warranty 退回 summary handoff

### 坏解法

- 交接系统虽然写了 `handoff_warranty`，但真正发放交接时只要看到一份可读的 summary、next step 与 closeout note，就默认 later 团队已经可以继续，不再检查 continuation object 是否仍保留对象边界。

### 为什么坏

- Claude Code 的 handoff 保护的是“later 还能继续行动的对象”，不是“later 还能看懂发生过什么”。
- 一旦 handoff 退回 summary，Prompt 收口执行就会重新退回：
  - continuation without boundary
  - lawful forgetting without object
  - narrative handoff without protocol truth
- 这会让交接成为“故事传递”，而不是对象交付。

### Claude Code 式正解

- handoff warranty 应围绕 continuation object，而不是围绕事故故事的可读性。

### 改写路径

1. 把 summary 降为 handoff 注释。
2. 把 `lawful_forgetting_witness + required_preconditions + consumer_readiness.handoff` 提升为交接硬条件。
3. 任何只看摘要可读性的 Prompt handoff 都判为 drift。

## 5. baseline reset 假证明：compact 看起来干净，却没有边界证明

### 坏解法

- 团队只要看到 compact 跑过、上下文变短、closeout note 更简洁，就默认 `baseline_reset_witness` 已成立，不再检查 lawful forgetting boundary 与 preserved segment 是否仍能重建同一判断。

### 为什么坏

- baseline reset 保护的是“later 仍围绕同一个边界继续”，不是“现在看起来更清爽”。
- 一旦 baseline reset 退回轻量感，团队就无法分清：
  - 是 lawful forgetting 真成立了
  - 还是只是旧上下文被压缩得更好看
- 这会把 Prompt 收口重新退回视觉与文案舒适度。

### Claude Code 式正解

- baseline reset 应先验证 boundary，再接受 compact 后的简洁感。

### 改写路径

1. 把 compact 后的清爽感降为次级信号。
2. 把 `baseline_reset_witness + lawful_forgetting_witness + preserved_segment` 提升为正式对象。
3. 任何只看 compact 结果不看边界证明的 Prompt closeout 都判为 drift。

## 6. 假 reopen：re-entry 被按钮状态与旧消息篡位

### 坏解法

- 团队虽然写了 `reopen_trigger` 与 `re_entry_warranty`，但真正重开时仍只看“按钮可点”“现在没报错”“最后一条消息像是还能接”，不再回到同一个 request object boundary。

### 为什么坏

- Claude Code 的 reopen 不是礼貌性 retry，而是围绕 `re_entry_warranty`、`pending_action_ref` 与 `required_preconditions` 的正式重开。
- 一旦 reopen 退回按钮状态，团队会同时做坏：
  - 把 request object 降为 UI 入口
  - 把 re-entry ticket 降为“再来一次”
  - 把 later 接手降为从旧 summary 接故事
- 这正是 Prompt 收口执行重新制造假连续性的地方。

### Claude Code 式正解

- reopen 应围绕对象边界、precondition 与 continuation object，而不是围绕“现在没被阻止”。

### 改写路径

1. 禁止按钮可点充当 reopen 资格。
2. 把 `reopen_trigger + re_entry_warranty + pending_action_ref + required_preconditions` 提升为正式对象。
3. 任何默认从旧消息与旧 summary 重开的 Prompt closeout 都判为 drift。

## 7. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在宣布完成的是 request object，还是 closeout 说明。
2. 我现在保护的是 protocol truth，还是一套更会解释的文本。
3. 我现在交接的是 continuation object，还是一段更精致的故事。
4. 我现在重开的是同一真相，还是默认继续。
5. 我现在保护的是 lawful forgetting boundary，还是 compact 之后的舒适感。

## 8. 一句话总结

真正危险的 Prompt 宿主修复收口执行失败，不是没写 closeout card，而是写了 closeout card 却仍在围绕假完成、假交接与假 reopen 消费 Prompt 世界。
