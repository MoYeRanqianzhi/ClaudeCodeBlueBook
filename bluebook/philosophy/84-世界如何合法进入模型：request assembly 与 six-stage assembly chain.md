# 谁有权把当前世界合法编译进模型

这一章回答五个问题：

1. 为什么 Claude Code 首先在分配“谁有权把当前世界合法编译进模型”。
2. 为什么 same-world failure test 的上限不取决于文案强度，而取决于世界主语与继续资格是否仍然单源。
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

- 只有 later consumer 在 `verify / delegate / tool choice / resume / handoff` 时都不用再重述现场、重划边界、重接消息血缘、重判继续资格，当前世界才算真的被合法编译进模型。

如果把 Prompt why 压成入口第一句，也只剩三问：

1. 现在到底谁在定义世界。
2. 边界内哪些动作和工具仍合法。
3. `resume / handoff / compaction` 之后，哪些 transcript / lineage 仍绑定继续资格。

这三问里只要有一问需要 later consumer 重答，same-world test 就已经失败；此时不该先补摘要、补说明或补第二张检查表，而该先停止继续。

如果 same-world failure 已经成立，才值得继续诊断断点；那些熟悉的机制名词此时只配当兼容标签，不配反过来抢 why 页主句。

所谓合法复数，也只允许这样一种复数：多个 surface 仍不逼 later consumer 重谈同一世界。只要接手者必须重新确认谁在定义世界、哪条历史还算数、继续资格是否仍成立，这个复数就已经不合法。

更硬一点说，Prompt 真正先保护的也不是“同一段 prompt 还能继续被用”，而是同一份 `world-entry object` 必须能被不同 consumer class 继承而不重新夺回世界主语：模型、接手者、子代理与宿主侧消费者都只能消费同一份已裁定世界，而不能各自靠摘要、局部投影或补写 prompt 重新发明自己的主权版本。

这里还要再多记一句：

- 解释层只配命名哪一环断了，不能反向改写世界准入判决。

## 2. 第一性原理：世界准入首先是一条合法编译顺序

如果输入装配只负责：

- 告诉模型应该怎么做

那么它仍然停留在 instruction 层。

Claude Code 更深的一层是：

- authority order 先排清什么配被模型看见、谁配被模型相信、哪些历史配被模型继承

这会把输入装配从“说服工具”改写成“准入顺序”。
更硬一点说，被编译进模型的从来不只是单段 system prompt，而是由 `system sections / tool descriptions / agent prompts / attachment deltas` 共同组成的 `world-entry object`；这些 surface 只有共享同一 authority order 与 continuation qualification，才配被 later consumer 体验成“Prompt 很强”。

也就是说，这条世界准入能力首先不是表达能力，而是 later consumer 围绕同一现场继续工作的能力。被外化的也不是“一段更完整的提示词文本”，而是足以让接手者不用重谈世界就能继续动作的最小依据；否则 surface 再多，也只是在不同 consumer 之间重复协商同一现场。

late binding 因此也只能发生在不触发重协商的前提下。更硬一点说：凡是会逼 later consumer 重新定义世界、重画边界、重接历史或重判继续资格的补写，都不再是 continue，而是 renegotiation。

再往前追一层，这也解释了为什么 `CLAUDE.md / commands / hooks / skills / subagents` 不是 Prompt 外挂，而是世界准入顺序在不同生命周期里的局部承接：它们只能在各自组件边界内提供背景、约束、证据或动作入口，却不能重写 `world-definition source`。
公开 docs 也把这层边界钉得更清楚：`CLAUDE.md` / memory 文件是自动加载、分层叠加的 foundation，真正的强制边界仍要靠 settings、permissions、sandboxing 与 hook veto 这类执行侧机制来成立。把 `CLAUDE.md` 自己误写成 enforcement surface，本身就是把 foundation 冒充成治理主权。
同样更硬的边界还在于：任何 `world-definition / continue qualification` 都不能依赖按需加载的子目录 `CLAUDE.md`。这类记忆层只配提供局部背景，不配承担世界准入主签名；否则 same-world 会被“这次读到了哪些目录文件”随机化，later consumer 也就不可能稳定继承同一份世界准入证据。
同理，`auto memory` 这类机器本地、不可跨环境继承的记忆层，也只配当 foundation/context，不配当 `world-definition / continue qualification` 的 witness。若一次继续只有靠这台机器的本地记忆才成立，它就还没有被写成 later consumer 能稳定继承的 same-world evidence。
更硬一点说，这种跨组件承接还必须满足一条 `主权单调律`：越靠近执行面，组件越只配收紧、阻断、要求证明；越靠近文本与偏好面，组件越只配提供背景与偏好，不能自立为新的判决面。任何需要靠组件重新重述现场才能继续的补写，都不是 continuation，而是 renegotiation；一旦某个组件级 prompt、hook 或 delegated context 可以各自改判世界主语，系统就不再是在做 lawful continuation，而是在做分布式重协商。

### 更硬一点的源码证据

真正值钱的，不是“有一份 system prompt”，而是 later consumer 选下一步动作所需的最小依据，已经被正式承接到足以维持同一 `reject / continue verdict` 的程度；具体 invariant 与对象链统一留给 `82` 与源码锚点，why 页不再展开第二层清单。

## 3. 最容易被误写成什么

这一层最容易被误写成五种坏解法：

1. 更长的 system prompt
   - 以为信息更全就更强。
2. UI transcript 直接就是模型 transcript
   - 以为看见什么，模型就该直接消费什么。
3. summary 就等于 lawful forgetting
   - 以为会总结就等于还能继续。
4. 每条 side loop 都可以各自重述现场
   - 以为并行只是多开几个 agent。
5. 工具 ABI 在 Prompt 外面，不算 Prompt 本体
   - 以为工具 schema、cache 断点、continue 资格只是外围实现细节。

这些误写的共同问题在于：

- 它们都把世界编译重新退回世界描述。

## 4. 为什么这类误写会直接削弱世界准入能力

一旦系统退回上述坏解法，马上会发生三类失真：

1. 主语漂移
   - 多份文本开始争“谁先定义世界”。
2. 历史漂移
   - `display transcript / protocol transcript / continuation artifact` 不再围绕同一条 lineage。
3. 连续性漂移
   - compact 之后留下的是叙事，不是仍可继续行动的依据。

所以这条世界准入能力真正保护的不是：

- 当前这轮回答更顺

而是：

- 当前、下一步、接手后都还活在同一个现场

### 三种最常见的 counterfeit

1. UI transcript 越权成 protocol transcript
2. delegated context 自己长成第二个 `world-definition source`
3. compaction 只留下 summary，却丢了 continuation 资格所需的最小事实

第一条可逆修法也因此固定：

- 先把越位内容降回非主权层
- 再停在 same-world failure verdict

### first reject signal 比成功表述更值钱

这条世界准入能力最先失稳时，第一条信号通常不是回答质量下降，而是世界定义权、展示边界与继续资格开始彼此脱钩。若这些失稳还不能在回答变差前被点名，那失去的也不是回答质感，而是这条世界准入顺序的先验反对权；这时更该先停在 same-world test 失败，而不是急着补更多 checklist。

## 5. 苏格拉底式追问

本页只保留三条 acid test：

1. 现在到底是谁在定义世界，是否仍然单源。
2. 当前被消费的是哪条 authoritative transcript / projection，展示层有没有越权成改判层。
3. 经历 `handoff / compaction / resume` 之后，continuation qualification 是否仍成立，而不是靠重述现场续命。

如果这三条已经答不清，就先按 same-world test 失败处理；更细 checklist 只有在这三条都站住之后才有意义。

## 6. 对 Agent Runtime 设计者的直接启发

如果你想复制 Claude Code 的这条世界准入能力，先复制“替 later consumer 预付冷启动协商成本”的制度结果，而不是先复制某段著名措辞。

更具体地说，你要先保证：

- 接手者拿到的是 same-world verdict，而不是另一轮世界协商
- delegated context 只能给线索，不能给世界主语
- compaction 保留的是继续依据，不只是阅读友好的摘要

对象链、字段名与实现对象统一留给 `82` 与源码锚点；why 页不再重发 inventory。

## 7. 一句话总结

Prompt 首先是替 later consumer 预付冷启动协商成本的世界准入顺序；如果接手者还要先重谈世界、再决定动作，Prompt 就已经失败。
