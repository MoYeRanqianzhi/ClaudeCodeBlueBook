# 真正有效的 Prompt，会先把输入装配顺序排清

这一章回答五个问题：

1. 为什么 Claude Code 的 Prompt 效力首先不是文案强，而是输入装配顺序强。
2. 为什么 `section registry / dynamic boundary`、`message lineage`、`projection consumer`、`protocol transcript` 与 `continuation qualification` 共同决定 Prompt 上限。
3. 为什么很多团队模仿 Prompt 时，最容易复制到外观，复制不到这种效力。
4. 怎样用苏格拉底式追问审一个新 runtime 是否真的具备这种 Prompt 效力。
5. 这对 Agent runtime 设计者意味着什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/systemPromptSections.ts:16-65`
- `claude-code-source-code/src/constants/prompts.ts:491-576`
- `claude-code-source-code/src/utils/systemPrompt.ts:28-123`
- `claude-code-source-code/src/utils/attachments.ts:1490-1862`
- `claude-code-source-code/src/tools/AgentTool/prompt.ts:49-286`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:437-697`
- `claude-code-source-code/src/utils/api.ts:321-405`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:188-327`
- `claude-code-source-code/src/query/stopHooks.ts:84-214`
- `claude-code-source-code/src/utils/forkedAgent.ts:46-126`
- `bluebook/architecture/82-请求装配流水线：authority chain、section registry、protocol transcript、lawful forgetting与cache-safe forks.md`

## 1. 先说结论

`84` 在蓝皮书里只承担一件额外职责：

- 它是 Prompt 线顶层说明的 canonical source；`README / 06 / 81` 负责引用、回绑或展开机制，不再并列重写 Prompt 顶层公式。

真正有效的 Prompt，不是：

- 更长
- 文风更顺滑
- 更会模仿专家文风

而是：

- authority order 先把输入进入模型的可采顺序排清

这里的“世界”不是抽象比喻，而是四件制度事实：

1. 哪一层有资格定义当前世界
2. 哪些字节属于 stable prefix，哪些事实只能晚绑定
3. `display transcript`、`protocol transcript` 与 `continuation object` 是否仍沿同一条 `message lineage` 投影
4. `compact / fork / handoff` 之后谁仍有资格继续

Prompt 的效力，首先来自：

- 世界先被编译

更准确地说，被编译的不是单一 system prompt，而是至少四类 prompt surface：

1. `system sections`
2. `tool descriptions`
3. `agent prompts`
4. `attachment deltas`

### 合法复数不是平行世界

这四类 surface 可以并存，但它们之所以仍算同一个 Prompt 世界，不是因为最后会被拼成一段更长文本，而是因为它们同时满足四个条件：

1. `same lineage`
   - 都在同一条 `message lineage` 上取位。
2. `named consumer`
   - 每一层都只对自己的 projection consumer 负责，不偷渡给相邻 consumer 改判。
3. `question-scoped source`
   - 每个问题都仍能指出唯一 `world-definition source`，而不是四层并列争主语。
4. `mandatory downgrade path`
   - 任一 surface 若丢失 admissibility，就必须降格成 display / evidence / hint，不能硬升格成 protocol 或 continuation truth。

更硬一点说，Prompt 的合法复数是 surface pluralism，而不是 adjudication pluralism；复数成立，裁决权仍然单源。

Anthropic 官方文档把这条 force ladder 说得更硬了一层：

- `CLAUDE.md / auto memory` 属于 advisory context；
- subagent 可以拥有 own context window、custom system prompt 与独立 capability boundary；
- 但这些复数 surface 仍必须回到同一个 `world-definition source` 下决定谁在改判。

所以 Prompt 的合法复数不是“所有 surface 同权并列”，而是 compiled order、advisory memory 与 delegated context 在同一条 authority order 下按 force class 并存。

而 `compact / resume` 则决定这些 surface 在遗忘、重链与继续后还能否保持同一条 continuation contract。

这也意味着，`Continuation` 不是 Prompt 外另起的一段功能说明，而是 same-world test 落到时间轴之后的 continue verdict。

更硬一点说，合法遗忘真正保护的也不是记忆密度，而是：

- `reject / continue verdict` 在 compact 前后不改判

如果继续把 lawful forgetting 再压成最短的制度句，它真正保留的也只该是：

- 足以复现同一 `world-entry / reject-continue verdict` 的最小 witness set

能被忘掉的是叙事密度，不能被忘掉的是裁决依据。

这也是为什么很多团队模仿 Prompt 时，最容易复制到外观，复制不到这种效力：他们抄到了说明文本，却没有抄到世界准入、投影分层与继续资格的制度体。真正稀缺的不是文风，而是不同 consumer 不必重新协商同一现场。
更硬一点说，Prompt 的魔力不是“多给指导”，而是取消“当前世界”在多轮、多 consumer 与多次接手之间的重复协商成本；一旦任何路径需要重述现场，same-world magic 就已经失效。

如果把这章继续压成最短公式，只剩三行：

1. `frontdoor order = Authority -> Boundary -> Transcript -> Lineage -> Continuation -> Explainability`
2. `canonical Prompt ABI = message_lineage_ref -> section_registry_ref -> stable_prefix_ref -> protocol_transcript_ref -> continuation_object_ref -> continue_qualification_verdict`
3. `compile -> protocolize -> preserve -> continue -> explain`

如果这三行还需要靠“连续性系统”这样的第四对象补完，通常也说明这里仍在把时间轴误写成独立 Prompt 平面。

这里也要先卡死三层关系：

- 第一行给 later maintainer 的 `first-reject path`
- 第二行才是唯一 object-level same-world witness；frontdoor、自校、host audit 与 userbook 都只配消费这张 ABI，不该各自重造一条 Prompt 解释链
- 第三行只是动作链，不替代前两行

更稳的 Prompt reject trio 也只认三条：

1. `authority_blur`
2. `transcript_conflation`
3. `continuation_story_only`

如果一套 Prompt 解释还没压到这两行，它就还停在机制总结，不算最硬的第一性原理。

这里还要再多记一句：

- `Explainability` 不能越位成新的 Prompt 主语；它只能解释 `world-definition source / boundary / qualification` 在哪里断，不能反向改写世界准入判决。

## 2. 第一性原理：Prompt 首先是一条世界准入顺序

如果 Prompt 只负责：

- 告诉模型应该怎么做

那么它仍然停留在 instruction 层。

Claude Code 更深的一层是：

- authority order 先排清什么配被模型看见、谁配被模型相信、哪些历史配被模型继承

这会把 Prompt 从：

- 说服工具

改写成：

- 准入顺序

也就是说，Prompt 真正的效力首先不是“表达能力”，而是：

- 世界准入能力，以及让不同 projection consumer 继续围绕同一条 `message lineage` 工作的能力

### 更硬一点的源码证据

真正值钱的，不是“有一份 system prompt”，而是这份 prompt 已经被写成受约束的编译秩序：

1. `systemPromptSection()` 与 `DANGEROUS_uncachedSystemPromptSection()` 把 section 区分成可缓存稳定前缀和必须说明理由的晚绑定事实。
2. `SYSTEM_PROMPT_DYNAMIC_BOUNDARY` 把静态前缀与动态 section 明确切开，说明“哪些东西配被长期继承、哪些东西只配当前回合进入”。
3. `buildEffectiveSystemPrompt()` 继续把 override / coordinator / agent / custom / default 的优先级写成正式组合规则，而不是让不同调用点各自拼 prompt blob。
4. proactive 模式下 agent prompt 选择 append 而不是 replace，说明“领域补充”必须活在同一条默认前缀顺序之内，而不是另起一套世界。
5. `attachments.ts` 把 `agent_listing_delta`、`mcp_instructions_delta`、nested rules 与 relevant memory prefetch 做成 late-bound injection，说明知识进入模型本来就是按需装配，而不是一次性塞满。
6. `promptCacheBreakDetection.ts` 继续把 `systemPromptChanged / toolSchemasChanged / betasChanged / cachedMCChanged` 写成对象级 cache-break 原因，说明 prompt 稳定性首先是字节边界稳定性。

所以这里真正起作用的不是：

- prompt 文案更顺滑

而是：

- section registry、late binding、projection discipline 与 continuation path 都已经被编译成正式制度对象

## 3. 最容易被误写成什么

这一层最容易被误写成五种坏解法：

1. 更长的 system prompt
   - 以为信息更全就更强
2. UI transcript 直接就是模型 transcript
   - 以为看见什么，模型就该直接消费什么
3. summary 就等于 lawful forgetting
   - 以为会总结就等于还能继续
4. 每条 side loop 都可以各自重述现场
   - 以为并行只是多开几个 agent
5. 工具 ABI 在 Prompt 外面，不算 Prompt 本体
   - 以为工具 schema、cache 断点、continue 资格只是外围实现细节

这些误写的共同问题在于：

- 它们都把世界编译重新退回世界描述

## 4. 为什么这类误写会直接削弱 Prompt 效力

一旦系统退回上述坏解法，马上会发生三类失真：

1. 主语漂移
   - 多份文本争首答来源
2. 历史漂移
   - `display transcript / protocol transcript / continuation object` 不再围绕同一条 lineage
3. 连续性漂移
   - compact 之后留下的是叙事，不是仍可继续行动的 continuation object

所以 Prompt 效力真正保护的不是：

- 当前这轮回答更顺

而是：

- 当前、下一步、接手后都还活在同一个现场

### 反证法：拿掉哪一层，效力会最先失效

最先塌掉的通常不是措辞，而是下面三层：

1. 没有 section registry 和 boundary
   - 结果不是 prompt 变短，而是系统再也说不清“什么是宪法、什么只是本回合事实”。
2. 没有 protocol transcript 编译
   - 结果不是展示层更自由，而是 UI transcript、summary 与模型 transcript 开始争改判权。
3. 没有 continuation qualification
   - 结果不是 compact 更省，而是留下来的只是一段可读摘要，不再是仍可行动的继续对象。

### first reject signal 比成功表述更值钱

Prompt 效力最先失稳时，第一条信号通常不是回答质量下降，而是 `same-world test` 已经先失败：

1. `world-definition source` 不清，多个 prompt surface 开始争主语。
2. `display transcript` 试图冒充 `protocol transcript`。
3. compact 后留下的是故事，不是 `continuation qualification`。
4. side loop / worker prompt 开始自己重造现场，而不是消费同一条 lineage。
5. cache break 已经发生，但团队说不清 break 的对象级原因。

如果这五条信号还不能在回答变差前被点名，那失去的也不是回答质感，而是 Prompt 这条世界准入顺序的先验反对权。

如果继续把它压成可复用的 reject order，也只该先拒四步：

1. `world-definition source` 不清
2. stable boundary 被污染
3. `transcript conflation`
4. `continuation_story_only`

前两步还没站住前，不该先去争论 summary 写得顺不顺。

## 5. 苏格拉底式追问

如果要审一个新 runtime 是否真的具备这种 Prompt 效力，先问：

1. 现在是谁在定义世界；如果多份文本冲突，谁是 `world-definition source`，哪条 `message lineage` 继续有效。
2. Prompt 是 blob，还是有正式 section 宪法。
3. display transcript、protocol transcript 与 continuation object 是不是围绕同一条 lineage 投影出来的。
4. compact 后保住的是行动语义与 continuation qualification，还是只是更好读的摘要。
5. side loop、suggestion、memory extraction 与 worker summary 是否只是同一 `protocol transcript` 的不同 consumer。
6. 工具 ABI、continue 资格与 cache break 原因，是否已进入 Prompt 真相本体。
7. 第一条 reject signal 会在什么地方出现；团队能不能在回答变差之前，就先指出 same-world test 哪一环已经断了。
8. 如果去掉“文风更顺滑”的外观优势，这套系统还能不能让不同 consumer 继续活在同一个现场。

## 6. 对 Agent Runtime 设计者的直接启发

如果你想复制 Claude Code 的 Prompt 效力，先复制：

1. 明确的 `world-definition source`
2. `message lineage` 内核
3. section registry
4. protocol transcript 编译
5. lawful forgetting 与 continuation qualification
6. cache-safe fork reuse

而不是先复制：

- 某段著名措辞

## 7. 一句话总结

真正有效的 Prompt，会先把输入装配顺序排清；如果这一步没有先成立，后面的 Prompt 再华丽，也只是更高明的文案。
