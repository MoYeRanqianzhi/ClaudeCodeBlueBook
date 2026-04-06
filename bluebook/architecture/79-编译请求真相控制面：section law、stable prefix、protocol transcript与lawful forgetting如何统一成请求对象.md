# 请求对象控制面：message lineage、projection consumer、protocol transcript 与 lawful forgetting 如何统一成 continuation object

Claude Code 的 Prompt 真相，不是一个名叫 `compiled request truth` 的单层大对象，而是一条能被重建、转写、继续与交接的 `message lineage`。更稳的对象链是：

1. `message lineage`
2. `projection consumer`
3. `protocol transcript`
4. `stable prefix boundary`
5. `continuation object`
6. `continuation qualification`

`compiled request truth` 最多只适合作为这条链的旧总称，不再适合作为一级主语。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/systemPromptSections.ts:1-51`
- `claude-code-source-code/src/constants/prompts.ts:491-557`
- `claude-code-source-code/src/utils/systemPrompt.ts:28-104`
- `claude-code-source-code/src/query/stopHooks.ts:84-120`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/sessionStorage.ts:1025-1034`
- `claude-code-source-code/src/utils/sessionStorage.ts:1408-1467`
- `claude-code-source-code/src/utils/sessionStorage.ts:2069-2128`
- `claude-code-source-code/src/services/compact/prompt.ts:1-260`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-520`

## 1. 第一性原理：先固定谁能写 lineage，再决定谁来消费它

`systemPromptSections.ts`、`prompts.ts` 与 `systemPrompt.ts` 说明，Claude Code 先解决的不是“Prompt 怎样写得更强”，而是：

1. 哪些制度字节有资格进入当前世界。
2. 哪些字节属于稳定前缀，哪些必须晚绑定。
3. 谁配生产这条共享前缀。

这意味着 `section law` 与 `stable prefix boundary` 都不是 root object；它们只是 `message lineage` 的准入律。

更准确地说：

1. `override -> coordinator -> agent -> custom -> default -> append` 这条顺序，先固定谁能定义当前世界。
2. section registry 先固定哪些制度字节属于正式 Prompt 宪法。
3. dynamic boundary 再把易漂移状态赶到稳定前缀之后。
4. `stopHooks.ts` 再把共享前缀生产权收在主线程，而不是交给 suggestion、summary 或 resume 旁路去各自重造世界。

所以 Prompt 线真正先保护的不是“一份完整请求对象”，而是“同一条 lineage 的写入资格与稳定字节边界”。

## 2. `message lineage` 才是一号对象

`message lineage` 之所以比 `compiled request truth` 更稳，是因为它能直接回钉到持续工作的三键内核：

1. `parentUuid / logicalParentUuid`
   - 保护当前历史骨架。
2. `message.id`
   - 保护 assistant 片段归并。
3. `tool_use_id / sourceToolAssistantUUID`
   - 保护 tool use / tool result pairing 与行动主语回链。

这条三键内核先回答：

- 现在这句话属于哪条世界线。
- 这个 tool result 应该回到哪个行动主语。
- compact、resume、handoff 之后系统还在不在同一条继续链上。

一旦把 root object 写成抽象的 `compiled request truth`，这些最硬的连续性约束就会重新被藏回“请求看起来还是同一个”这种宽泛说法里。

## 3. `projection consumer` 决定谁能以哪种读法消费同一条 lineage

Claude Code 的另一个关键设计，不是只维护“一份 transcript”，而是明确维护同一条 lineage 在不同 consumer 前的不同合法读法：

1. `display consumer`
   - 人类可读历史、搜索、复制与导航用的投影。
2. `model API consumer`
   - 模型真正消费的 `protocol transcript`。
3. `SDK / control consumer`
   - 宿主、控制面、tool progress 与状态回写消费的协议投影。
4. `handoff / compact / resume consumer`
   - 交接、压缩与恢复时消费的 `continuation object`。

这四类 consumer 可以共用同一条 lineage，但不能混写成同一种真相：

- display transcript 不能直接越权成模型输入。
- SDK/control projection 不能被误当成 handoff object。
- compact 后保住的不是“更短的显示历史”，而是仍可行动的 continuation object。

所以 Prompt 魔力不是“历史更完整”，而是“同一条 lineage 在不同 consumer 前各自合法，而且始终不分叉”。

## 4. `protocol transcript` 是 model-facing projection，不是 UI 历史副本

`messages.ts` 说明，模型真正消费的不是 UI 原样历史，而是经过 normalization 之后的 `protocol transcript`。其中至少包含：

1. `tool_use / tool_result` 配对修复。
2. attachment 迁移与补边。
3. 消息合并、合法化与协议补齐。

因此 Prompt 线真正该验证的是：

- 哪条 projection 才配进入模型。

而不是：

- 眼前聊天记录看起来是不是还完整。

这也解释了为什么 `protocol transcript` 应该位于 root chain 的第三环：

1. 先有 `message lineage`，保证世界线和行动主语不丢。
2. 再有 `projection consumer`，保证不同消费面不互相越权。
3. 最后才在 model-facing consumer 上产出 `protocol transcript`。

一旦顺序反过来，系统就会重新退回“谁都能从当前聊天记录大概拼一份请求”的平行世界写法。

## 5. `lawful forgetting` 产出 `continuation object`，并绑定 `continuation qualification`

`services/compact/prompt.ts` 说明，compact 不是任意摘要，而是在规定删掉什么之后，系统仍能围绕同一条 lineage 合法继续。

因此 `lawful forgetting` 的产物不是“更短的故事”，而是最小 `continuation object`。更稳的最小清单至少包括：

1. `current work`
2. `next-step guard`
3. `required assets`
4. `rollback boundary`
5. `continuation qualification`
6. `threshold liability`

这里的关键区分是：

- `continuation object`
  - 交接后仍要带着走的最小行动语义体。
- `continuation qualification`
  - 当前对象在当前阈值、当前边界、当前成本前提下是否仍配继续。

所以 `lawful forgetting` 也不该再被写成与 lineage 并列的第四层 root term；它只是同一条 lineage 在 compact / resume / handoff 消费面上的保全规则。

## 6. `cache-safe fork reuse` 与可解释 drift 都是这条链的下游证据面

`stopHooks.ts` 与 `promptCacheBreakDetection.ts` 共同说明：

1. 旁路循环默认应复用父前缀，而不是各自重造一份差不多知道现场的世界。
2. drift 也不该被写成黑箱现象，而应该能回到 system、tools、cache control、betas、effort 与 extra body 的变化上被解释。

这意味着：

- `cache-safe fork reuse` 保护的是同一条 lineage 在并行旁路中的复用纪律。
- cache observability 保护的是同一条 lineage 为什么发生 drift 的解释能力。

它们都重要，但都不该反过来占据 taxonomy root。更稳的写法是：

1. root chain 先固定 `message lineage -> projection consumer -> protocol transcript -> continuation object -> continuation qualification`
2. `cache-safe fork reuse` 作为并行复用纪律
3. cache observability 作为 drift 证据面

## 7. 为什么这比“编译请求真相”更精确

当 root object 改回 `message lineage` 之后，很多现象会得到更硬的解释：

1. Prompt 魔力不再来自措辞，而来自 lineage 的写入秩序、消费者分层与继续资格。
2. suggestion、summary、resume、host evidence 不再是并列的世界生成器，而是不同 projection consumer 或证据面。
3. compact、handoff、resume 不再是摘要技巧，而是 continuation object 的对象保全。
4. cache break 不再只是性能问题，而是 lineage drift 的可解释变化。

## 8. 一句话总结

Claude Code 的 Prompt 真正强在：它先把 `message lineage` 压成可重建的三键内核，再把 display、model API、SDK/control 与 handoff/resume 分成不同 `projection consumer`，然后用 `protocol transcript`、`lawful forgetting`、`continuation object` 与 `continuation qualification` 保住同一条继续链。
