# Prompt宿主修复稳态纠偏再纠偏改写纠偏精修纠偏执行反例：假repair card、假protocol truth与假reopen liability

这一章不再回答“Prompt refinement correction execution 该怎样运行”，而是回答：

- 为什么团队明明已经写了 `repair card`、固定 `reject order` 与 `reopen drill`，仍会重新退回假 `repair card`、假 `protocol truth` 与假 `reopen liability`。

它主要回答五个问题：

1. 为什么 Prompt refinement correction execution 最危险的失败方式不是“没有 repair card”，而是“card 存在，却仍围绕 rewrite prose、summary handoff、UI transcript 与未综合的子 Agent prose 工作”。
2. 为什么假 `repair card` 最容易把 `restored_request_object_id`、`compiled_request_hash`、`truth_lineage_ref` 与 `section_registry_generation` 重新退回更体面的票据。
3. 为什么假 `protocol truth` 最容易把 `registry-boundary custody`、`coordinator synthesis custody`、`tool pairing` 与 `stable prefix` 重新退回 UI 历史、目录表与研究 prose。
4. 为什么假 `reopen liability` 最容易把 `continue qualification` 与 future reopen 的正式能力重新退回“先继续再说”和礼貌说明。
5. 怎样用苏格拉底式追问避免把这些反例读成“把 repair card 再填细一点就好”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/systemPrompt.ts:28-123`
- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:491-576`
- `claude-code-source-code/src/utils/api.ts:321-405`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/coordinator/coordinatorMode.ts:207-257`
- `claude-code-source-code/src/tools/AgentTool/prompt.ts:101-112`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-66`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:483-698`

这些锚点共同说明：

- Prompt refinement correction execution 真正最容易失真的地方，不在 `repair card` 有没有写出来，而在 authority、compiled request lineage、registry-boundary、synthesis、protocol transcript、stable prefix、lawful forgetting、continuation qualification 与 reopen liability 是否仍围绕同一个 Prompt 编译对象继续说真话。

## 1. 第一性原理

Prompt refinement correction execution 最危险的，不是：

- 没有 `repair card`
- 没有 `reject order`
- 没有 `reopen drill`

而是：

- 这些东西已经存在，却仍然围绕 rewrite prose、UI transcript、summary handoff、静态目录与研究 prose 运作

一旦如此，团队就会重新回到：

1. 看 repair card 字段是不是都填了。
2. 看 handoff 看起来是不是更清楚。
3. 看 UI transcript 是否更顺。
4. 看子 Agent 研究总结是否更充分。
5. 看 token 还够不够就默认还能继续。

而不再围绕：

- 同一个 `restored_request_object_id + compiled_request_hash + truth_lineage_ref + section_registry_generation + dynamic_boundary + coordinator_synthesis_owner + stable_prefix_boundary + lawful_forgetting_boundary + continue_qualification + threshold`

## 2. 假repair card：card by polished packet

### 坏解法

- 宿主、CI、评审与交接系统虽然都拿到了 `repair_card_id` 与 `reject_verdict=steady_state_chain_resealed`，但真正执行时只要交接更整洁、字段都填了、UI transcript 更顺，就默认 `restored_request_object_id`、`compiled_request_hash`、`truth_lineage_ref` 与 `section_registry_generation` 仍围绕同一个 Prompt 编译链成立。

### 为什么坏

- `repair card` 保护的不是“现在更像一张正式修正卡”，而是 later 消费者仍在消费同一条 Prompt 编译链。
- 一旦修正卡退回 polished packet，团队就会重新容忍：
  - `compiled_request_hash` 只是抄录值
  - `truth_lineage_ref` 只是备注
  - `section_registry_generation` 只是填写项
  - `reject_verdict` 先于对象复核生效
- 这会让 handoff prose 直接取代 Prompt 的正式对象链。

### Claude Code 式正解

- `reject verdict` 应先绑定同一个 `restored_request_object_id + compiled_request_hash + truth_lineage_ref + section_registry_generation`，并先完成 `rewrite_prose_demoted`、`ui_transcript_not_truth` 与 `summary_override_blocked` 的降级，再宣布 `steady_state_chain_resealed`。


## 3. 假protocol truth：truth by UI and prose

### 坏解法

- 团队虽然承认 refinement correction execution 要验证 `section_registry_generation`、`system_prompt_dynamic_boundary`、`late_bound_attachment_set`、`coordinator_synthesis_owner`、`tool_pairing_health` 与 `stable_prefix_boundary`，但真正执行时只要 UI transcript 看起来没断、目录更整齐、worker 研究已经总结完，就提前落下 `steady_state_chain_resealed`，不再按固定顺序检查 runtime registry、boundary、synthesis 与 protocol truth。

### 为什么坏

- `section registry` 保护的是 runtime 生命周期，不是静态 TOC。
- `dynamic boundary` 保护的是 stable prefix 正文与 late-bound attachment 的分层，不是“附件已经被写清楚”。
- `coordinator_synthesis_owner` 保护的是主线程综合责任，不是“研究已经做过了”。
- `tool pairing + protocol transcript` 保护的是模型实际消费的消息链，不是显示层历史。
- 一旦 protocol truth 退回 prose，团队就会最先误以为：
  - “section 名字都在就说明 registry 还活着”
  - “attachment 写清楚了就说明 boundary 已经 seal”
  - “子 Agent 已经研究过了就说明主线程已经综合”
  - “UI transcript 看起来顺就说明 protocol truth 也顺”
- 这会把 Prompt 的魔力从可缓存、可转写、可继续的编译链退回更像宪法文本的说明文。

### Claude Code 式正解

- `reject order` 必须先证明 `section_registry_generation + system_prompt_dynamic_boundary + late_bound_attachment_set + coordinator_synthesis_owner + protocol_transcript_health + tool_pairing_health + stable_prefix_boundary` 仍围绕同一个 Prompt 编译对象，再决定 `steady_state_chain_resealed`、`boundary_rebind_required` 或 `reopen_required`。


## 4. 假reopen liability：liability by polite continue note

### 坏解法

- 团队虽然写了 `continue qualification`、`truth_break_trigger` 与 `reopen_required_when`，但真正值班时只要没有硬错误、token 看起来还够、later 也没立刻反对，就默认当前 refinement correction execution 已经可以继续；阈值只在交接单里写成“以后有问题再 reopen”。

### 为什么坏

- `continue qualification` 本质上是在持续判断“现在还配不配继续”，不是给“先继续一下”找借口。
- `reopen liability ledger` 本质上是在保留 future reopen 的正式反对能力，不是补一条更礼貌的提醒。
- 一旦 liability 退回装饰，Prompt refinement correction execution 就会重新退回：
  - continuation without gate
  - handoff without threshold
  - reopen without boundary
- 这会让 later 团队继承一条没有正式阈值对象的 refinement 时间线。

### Claude Code 式正解

- continuation 与 reopen liability 必须同时成立；没有 threshold，就只能 `hard_reject`、`truth_recompile_required`、`registry_reseal_required`、`boundary_rebind_required`、`reentry_required` 或 `reopen_required`。


## 5. 为什么这会直接杀死 Prompt 的魔力

- Claude Code 的 Prompt 魔力从来不是卡片写得多漂亮，而是 authority、registry、boundary、synthesis、protocol、prefix、forgetting 与 continuation 仍被编译成同一条可缓存、可转写、可继续的请求链。
- 假 `repair card` 会把编译对象退回交接对象。
- 假 `protocol truth` 会把 runtime 主线程退回 UI 历史、目录说明与研究 prose。
- 假 `reopen liability` 会把 future reopen 的正式能力退回一句礼貌说明。

一旦这几件事同时发生，Prompt 世界剩下的就不再是 Claude Code 式编译链，而只是：

1. 更会解释的 refinement prose。
2. 更平静的 UI 历史。
3. 更难被 later 团队质疑的默认继续。

## 6. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在修回的是同一个 `compiled request truth`，还是一张更正式的修正卡。
2. 我现在保护的是 runtime `section registry`，还是一张更好看的目录表。
3. 我现在保护的是 `dynamic boundary`，还是一份更清楚的 attachment 说明。
4. 我现在保护的是 `protocol truth + synthesis custody`，还是更顺滑的 UI 历史与更完整的研究总结。
5. `reopen liability` 还在不在；如果不在，我是在完成 refinement correction execution，还是在删除未来反对当前状态的能力。

## 7. 一句话总结

真正危险的 Prompt 宿主修复稳态纠偏再纠偏改写纠偏精修纠偏执行失败，不是没跑 `repair card`，而是跑了 `repair card` 却仍在围绕假 `repair card`、假 `protocol truth` 与假 `reopen liability` 消费 Prompt 世界。
