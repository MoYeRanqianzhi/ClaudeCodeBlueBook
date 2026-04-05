# Prompt宿主修复稳态纠偏再纠偏改写纠偏执行反例：假rewrite correction card、假section registry与假threshold liability

这一章不再回答“Prompt 宿主修复稳态纠偏再纠偏改写纠偏执行该怎样运行”，而是回答：

- 为什么团队明明已经写了 `rewrite correction card`、`section registry reseal`、`dynamic boundary rebinding` 与 `threshold liability drill`，仍会重新退回假 `rewrite correction card`、假 `section registry`、假 `dynamic boundary` 与假 `threshold liability`。

它主要回答五个问题：

1. 为什么 Prompt 宿主修复稳态纠偏再纠偏改写纠偏执行最危险的失败方式不是“没有 rewrite correction card”，而是“rewrite correction card 存在，却仍围绕 rewrite prose、UI 历史、summary handoff 与子 Agent prose 工作”。
2. 为什么假 `rewrite correction card` 最容易把 `restored_request_object_id`、`compiled_request_hash`、`section_registry_snapshot` 与 `dynamic_boundary_attested` 重新退回更体面的票据。
3. 为什么假 `section registry` 与假 `dynamic boundary` 最容易把 `compiled request truth`、`coordinator_synthesis_owner`、late-bound attachment 与 stable prefix 重新退回静态目录、正文幻觉与更顺滑的 handoff。
4. 为什么假 `threshold liability` 最容易把 `continue qualification` 与 future reopen 的正式能力重新退回“先继续再说”和礼貌说明。
5. 怎样用苏格拉底式追问避免把这些反例读成“把 rewrite correction card 再填细一点就好”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/systemPrompt.ts:28-93`
- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:491-560`
- `claude-code-source-code/src/utils/queryContext.ts:30-58`
- `claude-code-source-code/src/services/api/claude.ts:1374-1485`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:494-698`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/services/compact/prompt.ts:293-337`
- `claude-code-source-code/src/services/compact/compact.ts:330-711`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-66`
- `claude-code-source-code/src/coordinator/coordinatorMode.ts:251-257`
- `claude-code-source-code/src/tools/AgentTool/prompt.ts:101-112`
- `claude-code-source-code/src/query/tokenBudget.ts:22-92`
- `claude-code-source-code/src/query.ts:1308-1518`

这些锚点共同说明：

- Prompt 宿主修复稳态纠偏再纠偏改写纠偏执行真正最容易失真的地方，不在 `rewrite correction card` 有没有写出来，而在 `compiled request truth`、`section registry`、`dynamic boundary`、`protocol transcript`、`stable prefix`、`lawful forgetting` 与 `threshold liability` 是否仍围绕同一个 Prompt 编译对象继续说真话。

## 1. 第一性原理

Prompt 宿主修复稳态纠偏再纠偏改写纠偏执行最危险的，不是：

- 没有 `rewrite correction card`
- 没有 `section registry reseal`
- 没有 `dynamic boundary rebinding`
- 没有 `threshold liability drill`

而是：

- 这些东西已经存在，却仍然围绕 rewrite prose、UI transcript、summary handoff、静态目录与“现在应该可以继续了”运作

一旦如此，团队就会重新回到：

1. 看 rewrite correction prose 是否更完整。
2. 看目录与 section 说明是否更清楚。
3. 看 attachment 是否都被列出来了。
4. 看 later 团队是否主观觉得现在可以继续。

而不再围绕：

- 同一个 `compiled request truth + section registry + dynamic boundary + protocol transcript + stable prefix + lawful forgetting boundary + continue qualification`

## 2. 假rewrite correction card：rewrite by polished constitution prose

### 坏解法

- 宿主、CI、评审与交接系统虽然都拿到了 `rewrite_correction_card_id` 与 `reject_verdict=steady_state_restituted`，但真正执行时只要 rewrite correction 说明更完整、handoff 更整洁、字段都填了，就默认 `restored_request_object_id`、`compiled_request_hash`、`section_registry_snapshot` 与 `dynamic_boundary_attested` 仍围绕同一个 request object family 成立。

### 为什么坏

- `rewrite correction card` 保护的不是“现在更像一张正式卡”，而是改写后的恢复对象仍指向同一个 Prompt 编译对象。
- 一旦 rewrite correction card 退回完工票据，团队就会重新容忍：
  - `compiled_request_hash` 只是抄录值
  - `section_registry_snapshot` 只是附件
  - `dynamic_boundary_attested` 只是填写项
  - `reject_verdict` 先于对象复核生效
- 这会让 rewrite correction prose 直接取代 Prompt 的正式改写对象。

### Claude Code 式正解

- `reject verdict` 应先绑定同一个 `restored_request_object_id + compiled_request_hash + section_registry_snapshot + dynamic_boundary_attested`，并先完成 `rewrite_prose_demoted`、`ui_transcript_not_truth` 与 `summary_override_blocked` 的降级，再宣布 `steady_state_restituted`。


## 3. 假section registry 与假dynamic boundary：registry by static TOC, boundary by attachment prose

### 坏解法

- 团队虽然承认 rewrite correction 要验证 `section_registry_generation`、`coordinator_synthesis_owner`、`late_bound_attachment_set` 与 `attachment_binding_order`，但真正执行时只要目录看起来更整齐、section 名字更清楚、attachment 都被写进说明，就提前落下 `steady_state_restituted`，不再按固定顺序检查 `section_registry_generation`、`registry_drift_cleared`、`coordinator_synthesis_owner`、`late_bound_attachment_set` 与 `dynamic_boundary_attested`。

### 为什么坏

- `section registry` 保护的是 runtime 生命周期，不是静态 TOC。
- `dynamic boundary` 保护的是 stable prefix 正文与 late-bound attachment 的分层，不是“附件已经被写明”。
- 一旦 registry 与 boundary 退回静态说明，团队就会最先误以为：
  - “section 名字都在就说明 registry 还活着”
  - “attachment 写清楚了就说明 boundary 已经 seal”
  - “子 Agent 已经总结过了就说明主线程已经综合”
- 这会把 Prompt 的魔力从可缓存、可转写、可继续的编译链退回“更像宪法文本的说明文”。

### Claude Code 式正解

- `reject verdict order` 必须先证明 `section registry` 仍是 runtime registry、`coordinator_synthesis_owner` 仍成立、late-bound attachment 没有偷渡进 stable prefix 正文，再决定 `steady_state_restituted`、`boundary_rebind_required` 或 `reopen_required`。


## 4. 假threshold liability：liability by polite continuation note

### 坏解法

- 团队虽然写了 `continue qualification` 与 `threshold liability reinstatement`，但真正值班时只要没有硬错误、token 看起来还够、later 也没立刻反对，就默认当前 rewrite correction 已经可以继续；阈值只在交接单里写成“以后有问题再 reopen”。

### 为什么坏

- `continue qualification` 本质上是在持续判断“现在还配不配继续”，不是给“先继续一下”找借口。
- `threshold liability` 本质上是在保留 future reopen 的正式反对能力，不是补一条更礼貌的提醒。
- 一旦 liability 退回装饰，Prompt rewrite correction execution 就会重新退回：
  - continuation without gate
  - handoff without threshold
  - reopen without boundary
- 这会让 later 团队继承一条没有正式阈值对象的 rewrite correction 时间线。

### Claude Code 式正解

- continuation 与 threshold liability 必须同时成立；没有 threshold，就只能 `hard_reject`、`truth_recompile_required`、`boundary_rebind_required`、`protocol_repair_required`、`reentry_required` 或 `reopen_required`。


## 5. 为什么这会直接杀死 Prompt 的魔力

- Claude Code 的 Prompt 魔力从来不是 rewrite correction prose 写得多漂亮，而是 `systemPrompt + userContext + systemContext + protocol transcript` 仍被编译成同一条可缓存、可转写、可继续的请求链。
- 假 `rewrite correction card` 会把编译对象退回说明对象。
- 假 `section registry` 会把 runtime 主线程退回静态目录。
- 假 `dynamic boundary` 会把 late-bound attachment 偷写回宪法正文。
- 假 `threshold liability` 会把 future reopen 的正式能力退回一句礼貌说明。

一旦这几件事同时发生，Prompt 世界剩下的就不再是 Claude Code 式编译链，而只是：

1. 更会解释的 rewrite correction prose。
2. 更平静的 UI 历史。
3. 更难被 later 团队质疑的默认继续。

## 6. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在修回的是同一个 `compiled request truth`，还是一张更正式的 rewrite correction 卡。
2. 我现在保护的是 runtime `section registry`，还是一张更好看的目录表。
3. 我现在保护的是 `dynamic boundary`，还是一份更清楚的 attachment 说明。
4. 我现在恢复的是 `continue qualification`，还是一种“先继续再说”的默认冲动。
5. `threshold liability` 还在不在；如果不在，我是在完成 rewrite correction，还是在删除未来反对当前状态的能力。

## 7. 一句话总结

真正危险的 Prompt 宿主修复稳态纠偏再纠偏改写纠偏执行失败，不是没跑 `rewrite correction card`，而是跑了 `rewrite correction card` 却仍在围绕假 `rewrite correction card`、假 `section registry`、假 `dynamic boundary` 与假 `threshold liability` 消费 Prompt 世界。
