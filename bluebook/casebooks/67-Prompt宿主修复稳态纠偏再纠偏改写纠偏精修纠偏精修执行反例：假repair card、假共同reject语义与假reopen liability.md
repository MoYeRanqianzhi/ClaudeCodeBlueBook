# Prompt宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行反例：假repair card、假共同reject语义与假reopen liability

这一章不再回答“Prompt refinement correction refinement execution 该怎样运行”，而是回答：

- 为什么团队明明已经写了共同 `repair card`、共同 `reject order` 与 `reopen drill`，仍会重新退回假 `repair card`、假共同 `reject` 语义与假 `reopen liability`。

它主要回答五个问题：

1. 为什么 Prompt refinement correction refinement execution 最危险的失败方式不是“没有共同 `repair card`”，而是“card 存在，却仍围绕 smooth transcript、handoff prose、worker 研究 prose 与 prompt wording 崇拜工作”。
2. 为什么假 `repair card` 最容易把 `authority chain`、`compiled request lineage`、`section registry generation` 与 `repair attestation` 重新退回更顺的说明稿。
3. 为什么假共同 `reject` 语义最容易把宿主、CI、评审与交接重新拆成四套对 Prompt 魔力的不同理解。
4. 为什么假 `reopen liability` 最容易把 lawful forgetting、continuation qualification、cache break 与 future reopen 的正式能力重新退回作者记忆与 compact 乐观主义。
5. 怎样用苏格拉底式追问避免把这些反例读成“把 Prompt 值班卡再写严一点就好”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/systemPrompt.ts:28-123`
- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:491-576`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/coordinator/coordinatorMode.ts:207-257`
- `claude-code-source-code/src/tools/AgentTool/prompt.ts:101-112`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-66`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:483-698`

这些锚点共同说明：

- Prompt refinement correction refinement execution 真正最容易失真的地方，不在 `repair card` 有没有写出来，而在 authority、registry、protocol truth、tool pairing、lawful forgetting、continuation qualification 与 reopen threshold 是否仍围绕同一个 Prompt 编译对象被共同消费。

## 1. 第一性原理

Prompt refinement correction refinement execution 最危险的，不是：

- 没有 `repair card`
- 没有共同 `reject order`
- 没有 `reopen drill`

而是：

- 这些东西已经存在，却仍然围绕更顺的 UI transcript、更完整的 handoff、更像研究的 worker prose 与更有气势的 Prompt wording 运作

一旦如此，团队就会重新回到：

1. 看 transcript 顺不顺。
2. 看 section 名字还在不在。
3. 看 handoff 写得是不是更完整。
4. 看子 Agent 研究是不是已经很多。
5. 看 token 似乎还够不够。

而不再围绕：

- 同一个 `authority_chain_ref + restored_request_object_id + compiled_request_hash + section_registry_generation + protocol_transcript_health + tool_pairing_health + lawful_forgetting_boundary + continue_qualification + repair_attestation_id + threshold_retained_until`

## 2. 假repair card：card by smooth transcript and polished handoff

### 坏解法

- 宿主、CI、评审与交接系统虽然都拿到了 `repair_card_id` 与 `reject_verdict=steady_state_chain_resealed`，但真正执行时只要 transcript 更顺、handoff 更完整、worker 分析更多、section 名字没丢，就默认 `authority_chain_ref`、`compiled_request_hash`、`section_registry_generation` 与 `repair_attestation_id` 仍围绕同一个 Prompt 编译对象成立。

### 为什么坏

- Prompt `repair card` 保护的不是“现在更像一张正式卡”，而是 later 消费者仍在消费同一个模型世界。
- `buildEffectiveSystemPrompt()` 证明 Prompt 世界先是 authority chain，不是文案审美。
- `normalizeMessagesForAPI()` 证明模型消费的是 protocol truth，不是显示层 transcript。
- `ensureToolResultPairing()` 证明 tool chain 一旦断裂，要么修补并显式标记，要么在 strict mode 直接停机。
- 一旦修正卡退回 smooth transcript 与 polished handoff，团队就会重新容忍：
  - `authority chain` 只是更像制度的 wording
  - `compiled request lineage` 只是 handoff 的摘要版
  - `section registry` 只是目录还在
  - `repair attestation` 只是“大家都看过了”

### Claude Code 式正解

- `reject verdict` 应先绑定同一个 `authority_chain_ref + restored_request_object_id + compiled_request_hash + section_registry_generation + repair_attestation_id`，再宣布 `steady_state_chain_resealed`。


## 3. 假共同reject语义：reject by consumer divergence

### 坏解法

- 宿主认为“UI transcript 已经顺了，所以可以继续”。
- CI 认为“section registry 还在，所以不用 reject”。
- 评审认为“handoff 已经解释圆了，所以 verdict 可以先过”。
- 交接认为“子 Agent 已经研究过了，所以 later 团队可以直接接手”。

表面上四方都在复述同一张 `repair card`，实际上他们消费的是四个不同对象：

1. transcript projection
2. section projection
3. prose projection
4. worker research projection

### 为什么坏

- 共同 `reject order` 保护的不是“大家都说了 reject 这个词”，而是四类消费者必须围绕同一个编译对象、同一条拒收链说话。
- Prompt 魔力真正强的地方，不是任何单个消费者都觉得它“解释得通”，而是它能让不同消费者围绕同一条 authority -> lineage -> boundary -> protocol truth -> lawful forgetting 说同一种语言。
- 一旦共同 `reject` 退回消费者分裂，团队就会最先误以为：
  - “宿主已经能继续，所以系统整体也能继续”
  - “CI 没报错，所以 protocol truth 没问题”
  - “评审已认可，所以 tool pairing 也没问题”
  - “交接能读懂，所以 reopen liability 也保住了”

### Claude Code 式正解

- 共同 `reject order` 必须先证明 `authority_chain_ref + compiled_request_hash + section_registry_generation + protocol_transcript_health + tool_pairing_health + lawful_forgetting_boundary + continue_qualification` 仍围绕同一个 Prompt 对象，再决定 `steady_state_chain_resealed`、`protocol_truth_reseal_required`、`repair_attestation_rebuild_required` 或 `reopen_required`。


## 4. 假reopen liability：liability by author memory and compact optimism

### 坏解法

- 团队虽然写了 `reopen drill`，但真正保留责任时只是在卡片里写“compact 后仍可继续”“如果后面有问题再重开”“当前作者知道该从哪里接”，却没有正式绑定 `lawful_forgetting_boundary`、`continue_qualification`、`cache_break_reason`、`threshold_retained_until` 与 `reopen_required_when`。

### 为什么坏

- `lawful forgetting` 保护的不是“压缩后还看得懂”，而是忘掉什么仍合法。
- `continue qualification` 保护的不是“token 还没爆”，而是继续资格仍成立。
- `promptCacheBreakDetection` 保护的不是“缓存偶尔断了也没关系”，而是 later 团队知道当前边界为何断裂。
- 一旦 `reopen liability` 退回作者记忆与 compact 乐观主义，团队就会重新退回：
  - summary optimism
  - attachment optimism
  - budget optimism
  - author-dependent reopen

### Claude Code 式正解

- `reopen liability` 必须显式绑定 `lawful_forgetting_boundary + continue_qualification + cache_break_reason + threshold_retained_until + reopen_required_when`，并把 later 团队可回到的 Prompt 对象写清楚。


## 5. 从更多角度看它为什么迷惑

这类假象之所以迷惑，至少有五个原因：

1. 它借用了 Claude Code 真正强的外观：section、handoff、worker、summary、budget 都看起来像在认真工作。
2. 它满足了四类消费者各自最容易满足的心理需求：宿主要顺，CI 要静，评审要能解释，交接要能读懂。
3. 它把“模型实际消费什么”偷换成了“人类现在最容易读什么”。
4. 它把“later 团队可独立复证什么”偷换成了“当前作者还能补充什么”。
5. 它把 Prompt 魔力从可缓存、可转写、可继续的编译链偷换成了更像真相的语言材料。

## 6. 苏格拉底式自检

在你准备宣布“Prompt 精修执行没有漂移”前，先问自己：

1. 我现在共享的是同一个编译对象，还是四份彼此相像的解释材料。
2. 我现在共享的是同一条 `reject` 语义链，还是四个角色各自的继续理由。
3. 我现在保留的是 formal reopen 能力，还是作者记得怎么救场。
4. later 团队如果拿不到当前作者，是否仍能只凭 card 复原 authority、boundary、protocol truth 与 threshold。
5. 我现在保护的是 Claude Code 的 Prompt 魔力，还是只是在模仿它的外观。
