# 谁有权把当前世界合法编译进模型

这一章回答五个问题：

1. 为什么 Claude Code 首先在分配“谁有权把当前世界合法编译进模型”。
2. 为什么 single-source world definition、projection discipline 与 continuation qualification 共同决定这条世界准入链的上限。
3. 为什么很多团队模仿 Prompt 时，最容易复制到外观，复制不到这条合法世界准入链。
4. 怎样用苏格拉底式追问审一个新 runtime 是否真的具备这种世界准入能力。
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

`84` 在蓝皮书里只固定一条因果律：

- 只有当 `stable prefix / visibility pruning / delegated-context downgrade / continuation qualification` 被同一条 authority order 编译成 `compiled world verdict`，当前世界才算被合法编译进模型。

真正成立的世界准入，是 runtime 先把 `compiled world verdict` 编译成一个可被多 consumer 复用的合法输入秩序；后来的 `verify / delegate / tool choice / resume / handoff` 因此不必重谈“现在是什么世界”。
这种强感首先来自当前 turn 已继承同一份 `compiled world verdict`，模型不必先重建世界，只需在已裁定边界内选择动作。更直白地说，它预先付掉了后续 consumer 的世界协商成本。

Prompt potency 真正值钱的地方，也不是 prompt prose 更强，而是四个制度动作同时成立：

1. `stable prefix custody`
   - later consumer 继承的是已编译前缀，而不是自己补一套世界定义。
2. `visibility pruning`
   - 先裁可见面，再给行动权；模型不会先看见未定价、未定界的世界。
3. `delegated-context downgrade`
   - delegated context 只能当 advisory surface，不能长成第二个 `world-definition source`。
4. `lawful continuation`
   - `compact / fork / handoff / resume` 之后仍保住同一 `reject / continue verdict`，而不是靠重述现场续命。

这里的“世界”不是抽象比喻，而是四件制度事实：

1. 哪一层有资格定义当前世界
2. 哪些字节属于 stable prefix，哪些事实只能晚绑定
3. `display transcript`、`protocol transcript` 与 `continuation object` 是否仍沿同一条 `message lineage` 投影
4. `compact / fork / handoff` 之后谁仍有资格继续

这条世界准入能力，首先来自：

- 世界先被编译

更准确地说，被编译的不是单一 system prompt，而是一条多 surface 的输入秩序；surface 可以复数，但世界定义权不能复数。
更硬一点说，晚绑定只有在填充预授权槽位、而不改写 `Authority / Boundary / Transcript / Lineage / Continuation` 时才合法；后来的 consumer 只要改写了其中任何一项，下一步动作就得先重算边界、重判工具资格，动作选择成本立刻回到冷启动。
所谓 `pre-authorized slot`，只允许在既定 `Authority / Boundary / Transcript / Lineage / Continuation` 内填值；一旦需要改写其中任一项，就是 renegotiation，不再是 late binding。

| surface mutation | 是否允许 | 破坏了哪一环 | 降格去向 | 观察者证据 |
|---|---|---|---|---|
| 填充预授权 late-bound slot | 允许 | 无 | 保持原位 | 同一 `Authority / Boundary / Transcript / Lineage / Continuation` 仍成立 |
| 改写 authority source | 不允许 | `Authority` | reject / downgrade | 出现第二个 world-definition source |
| 改写 boundary 或 transcript truth | 不允许 | `Boundary / Transcript` | downgrade | display/UI 开始争改判权 |
| 改写 lineage | 不允许 | `Lineage` | reject | consumer 不再共享同一消息血缘 |
| 改写 continuation qualification | 不允许 | `Continuation` | reject / downgrade | compact / handoff 后只能重述现场，不能继续行动 |

### 合法复数不是平行世界

复数 surface 可以并存，但它们之所以仍算同一个 Prompt 世界，不是因为最后会被拼成一段更长文本，而是因为它们同时满足四个条件：

1. `same lineage`
   - 都在同一条 `message lineage` 上取位。
2. `isolated delegation`
   - child 只继承同一份 `compiled world verdict`，但上下文与工作现场仍保持隔离；它可以生产线索，不能自立世界。
3. `single-source adjudication`
   - 每个问题都仍能指出唯一 `world-definition source`，而不是四层并列争主语。
4. `mandatory downgrade path`
   - 任一 surface 若丢失 admissibility，就必须降格成 display / evidence / hint，不能硬升格成 protocol 或 continuation truth。

更硬一点说，这里的合法复数是 surface pluralism，而不是 adjudication pluralism；复数成立，裁决权仍然单源。

所以这里的合法复数不是“所有 surface 同权并列”，而是 compiled order、advisory memory 与 delegated context 在同一条 authority order 下按 force class 并存。

而 `compact / resume` 则决定这些 surface 在遗忘、重链与继续后还能否保持同一条 continuation contract。

这也意味着，`Continuation` 不是外另起的一段功能说明，而是 same-world test 落到时间轴之后的 continue verdict。

更硬一点说，合法遗忘真正保护的也不是记忆密度，而是：

- `reject / continue verdict` 在 compact 前后不改判

如果继续把 lawful forgetting 再压成最短的制度句，它真正保留的也只该是：

- compact 之后仍足以维持同一 `reject / continue verdict` 的最小事实

能被忘掉的是叙事密度，不能被忘掉的是世界定义、边界与继续资格的裁决依据。

这也是为什么很多团队模仿 Prompt 时，最容易复制到外观，复制不到这种世界准入能力：他们抄到了说明文本，却没有抄到“世界已被编译、consumer 无需重谈”的制度体。
更硬一点说，later consumer 仍可继承同一份已编译世界判决，不是因为某句 prompt 更会说服模型，而是因为世界定义权、消费边界与继续资格被同一条证据链持续见证；一旦任何路径需要重新定义“现在是什么世界”，下一步动作选择就会退回冷启动。真正该被复用的 therefore，不是某句著名措辞，而是上面四个制度动作能否同时成立。

如果把这章继续压成最短公式，只保留一句：

- 只有同一条 `Authority -> Boundary -> Transcript -> Lineage -> Continuation` 仍能单源裁决谁在定义世界、谁在消费这份定义、谁在继续时重获资格，当前世界才算被合法编译进模型。

这里的 `Authority / Boundary / Transcript / Lineage / Continuation` 也不是另一张 inventory；它们只是同一份 `continue-or-reject` 判决的五个裁定轴。

若要继续核对更细的 same-world evidence，也只做一件事：沿 `82` 与本页锚点检查 `stable prefix / visibility pruning / advisory downgrade / continuation object` 是否仍共同指向同一份 verdict。

这里还要再多记一句：

- 解释层只配命名哪一环断了，不能反向改写世界准入判决。

## 2. 第一性原理：世界准入首先是一条合法编译顺序

如果这条输入装配只负责：

- 告诉模型应该怎么做

那么它仍然停留在 instruction 层。

Claude Code 更深的一层是：

- authority order 先排清什么配被模型看见、谁配被模型相信、哪些历史配被模型继承

这会把输入装配从：

- 说服工具

改写成：

- 准入顺序

也就是说，这条世界准入能力首先不是“表达能力”，而是：

- 世界准入能力，以及让不同 projection consumer 继续围绕同一条 `message lineage` 工作的能力

编译链首先外化的也不是“更完整的提示词文本”，而是裁决权本身：哪些世界法必须先被宿主对象持有、记录并可复核，而不是留给模型临场记住。否则 surface 再多，也只是在不同 consumer 之间重复协商同一现场。

### 更硬一点的源码证据

真正值钱的，不是“有一份 system prompt”，而是 later consumer 选下一步动作所需的世界定义、边界与继续资格，已经被写成一条受约束的编译秩序：

1. stable prefix 与 late-bound facts 被正式区分，而不是由不同调用点临场拼接。
2. delegated / consumer-local context 必须活在同一条默认前缀顺序内，而不是另起一套世界。
3. cache break 与 continuation 资格都有正式对象承接，prompt 稳定性因此先是字节边界稳定性，再是文案感受。

具体对象名继续留在本页锚点与 `82`，这里不把 invariant 再退回 inventory。

所以这里真正起作用的，不是 prompt 文案更顺滑，而是 section registry、late binding、projection discipline 与 continuation path 都已经被编译成正式制度对象；正确下一步之所以更便宜，不是因为模型突然更聪明，而是因为 later consumer 不必重谈当前世界。

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

## 4. 为什么这类误写会直接削弱世界准入能力

一旦系统退回上述坏解法，马上会发生三类失真：

1. 主语漂移
   - 多份文本争首答来源
2. 历史漂移
   - `display transcript / protocol transcript / continuation object` 不再围绕同一条 lineage
3. 连续性漂移
   - compact 之后留下的是叙事，不是仍可继续行动的 continuation object

所以这条世界准入能力真正保护的不是：

- 当前这轮回答更顺

而是：

- 当前、下一步、接手后都还活在同一个现场

### 反证法：拿掉哪一层，世界准入能力会最先失效

最先塌掉的通常不是措辞，而是下面三层：

1. 没有 section registry 和 boundary
   - 结果不是 prompt 变短，而是系统再也说不清“什么是宪法、什么只是本回合事实”。
2. 没有 protocol transcript 编译
   - 结果不是展示层更自由，而是 UI transcript、summary 与模型 transcript 开始争改判权。
3. 没有 continuation qualification
   - 结果不是 compact 更省，而是留下来的只是一段可读摘要，不再是仍可行动的继续对象。

对应的三种 counterfeit 也最常见：

1. UI transcript 越权成 protocol transcript
2. delegated context 自己长成第二个 world-definition source
3. compaction 只留下 summary，却丢了 continuation object

如果把这些 counterfeit 继续压成成本句，也只剩三句：

1. UI transcript 越权，会让 `tool choice / verify` 先重判主语。
2. delegated context 升格，会让 `handoff / delegate` 先重新清权属。
3. summary 冒充 continuation，会让 `resume` 先重建现场。

第一条可逆修法也因此固定：

- 把 UI transcript 降回 display layer
- 把 delegated context 降回 advisory slot
- 把 summary 降回非 continuation object

### first reject signal 比成功表述更值钱

这条世界准入能力最先失稳时，第一条信号通常不是回答质量下降，而是世界定义权、展示边界与继续资格开始彼此脱钩。若这些失稳还不能在回答变差前被点名，那失去的也不是回答质感，而是这条世界准入顺序的先验反对权；这时更该先停在 same-world test 失败，而不是急着补更多 checklist。

## 5. 苏格拉底式追问

本页只保留三条 acid test：

1. 现在到底是谁在定义世界，是否仍然单源。
2. 当前被消费的是哪条 authoritative transcript / projection，展示层有没有越权成改判层。
3. 经历 `handoff / compaction / resume` 之后，continuation qualification 是否仍成立，而不是靠重述现场续命。

如果这三条已经答不清，就先按 same-world test 失败处理；更细 checklist 只有在这三条都站住之后才有意义。

## 6. 对 Agent Runtime 设计者的直接启发

如果你想复制 Claude Code 的这条世界准入能力，先复制：

1. 明确的 `world-definition source`
2. `message lineage` 内核
3. section registry
4. protocol transcript 编译
5. lawful forgetting 与 continuation qualification
6. cache-safe fork reuse

而不是先复制：

- 某段著名措辞

## 7. 一句话总结

Prompt 首先是替 later consumer 预付世界协商与边界重算成本的世界准入顺序；如果这一步没有先成立，后面的 Prompt 再完整，也只会把下一步动作留在冷启动里。
