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

> Evidence mode
> - 当前 worktree 若仍缺 `claude-code-source-code/` 镜像，上面这些源码路径只按 archival anchors 读取；对象 certainty 仍先经过 `guides/102` 的 claim-state / promotion gate，本页只消费 why 与机制层解释，不借源码锚点偷升 object-level certainty。

## 1. 先说结论

`84` 在蓝皮书里只固定一条因果律：

- 只有 later consumer 在 `verify / delegate / tool choice / resume / handoff` 时都不用再重述现场、重划边界、重接消息血缘、重判继续资格，当前世界才算真的被合法编译进模型。

如果把 Prompt why 压成入口第一句，也只剩三问：

1. 现在到底谁在定义世界。
2. 边界内哪些动作和工具仍合法。
3. `resume / handoff / compaction` 之后，哪些 transcript / lineage 仍绑定继续资格。

这三问里只要有一问需要 later consumer 重答，same-world test 就已经失败；此时不该先补摘要、补说明或补第二张检查表，而该先停止继续。

更短地说，`84` 固定的是三条 Prompt owner law：`lawful inheritance` 规定 later consumer 继承的仍是同一工作对象；`search-pruning` 规定已排除分支继续保持被排除；`decision-retirement` 规定没有新增 `decision delta` 的旧判断继续退役，不得被 summary / delegated context / replay 静默带回候选集。

如果 same-world failure 已经成立，才值得继续诊断断点；那些熟悉的机制名词此时只配当兼容标签，不配反过来抢 why 页主句。

如果要把这条 why 再压成 later maintainer 可直接复查的最小 verdict box，也只剩三种输出：

| verdict | 最小条件 |
|---|---|
| `pass` | later consumer 仍能继承同一 `work object + excluded branches + continue/reject verdict`，不必重谈世界、边界、lineage 与继续资格 |
| `provisional` | 当前只看到了 summary / sticky prompt / handoff prose / session memory 这类 carrier，尚未回绑 witness chain |
| `reject` | carrier 被迫单独代签继续资格，或已退役判断在无新增 `decision delta` 时回流 candidate set |

遇到 `provisional / reject`，第一动作不是补 prose，而是回 `message lineage -> section registry -> stable prefix -> protocol transcript -> continuation object -> continue qualification verdict` 这条 witness ABI 补断点。
更短一点说，`carrier-only` 只配停在 `provisional`，`witness-rebind` 才配升回 `pass`；若 carrier 被迫单独代签 continue 资格，直接落到 `reject`。若你已经开始追这些 case 在字段级到底长什么样，下一跳不是补更多 why，而是直接去 `81` 看 builder-facing worked example；`84` 只固定 owner law 与 verdict box，不重发 mechanism inventory。
若 `30` 的 builder-facing gate 给出 `unknown`，在 owner law 层也不保留第四种 verdict：只是 witness 尚未回绑、但尚未观察到越权或已退役判断回流时，折叠进 `provisional`；一旦 `unknown` 已意味着 verdict owner 不明、carrier 可能越权，或已退役判断可能重新回到 candidate set，就直接按 `reject` 停在 same-world failure。
更硬一点说，Prompt 线的标准 handoff 只认 speaking right 的切分：why 与 verdict box 停在 `84`，builder-facing object chain 停在 `81`；入口页最多转述这条切分，不把它写成新的必经路线。若一页同时想把这两份 speaking right 都留下来，它就会重新长成第二前门。

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
所以 `continuation qualification` 真正裁定的不是“是否还能接着生成”，而是 later consumer 是否仍在消费同一份 `world-entry object`；只要继续前还要重谈世界主语、边界或 lineage，这里的资格就已经失效。

late binding 因此也只能发生在不触发重协商的前提下。更硬一点说：凡是会逼 later consumer 重新定义世界、重画边界、重接历史或重判继续资格的补写，都不再是 continue，而是 renegotiation。

再往前追一层，这也解释了为什么 `CLAUDE.md / commands / hooks / skills / subagents / auto memory` 这些 artifact 不能被读成第二套 Prompt 主权：它们只是在不同生命周期里局部承接背景、约束、证据或动作入口，却都不配重写 `world-definition source`。
公开 docs 继续支持的也只是同一条 why，而不是另一套 component inventory：越靠近文本、偏好与按需加载的 surface，越只配补 context；越靠近显式 veto、权限与执行边界的 surface，越只配收紧、阻断、要求证明。共享 scope 词、共享加载入口或共享配置名，并不自动生成共享 signer 语义。
更硬一点说，本页在这些 artifact 上真正只想保住一句 `主权单调律`：不能独立 veto 世界定义、权限边界与继续资格的 surface，一律只配补 context，不配代签 verdict；一旦 `display transcript / delegated context / summary` 或某类 component-level prompt 越级，第一动作不是补更多 why，而是先把它降回 `projection`。若你已经开始追具体组件的加载、合并、遮蔽或 effect-ceiling 细则，下一跳应回 `81` 或对应 owner page；`84` 不再把 why owner 重新长成 mechanism frontdoor。

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
- 以及 later consumer 不必重新枚举候选动作，才能把下一步压回少数合法分支

### 三种最常见的 counterfeit

1. UI transcript 越权成 protocol transcript
2. delegated context 自己长成第二个 `world-definition source`
3. compaction 只留下 summary，却丢了 continuation 资格所需的最小事实

第一条可逆修法也因此固定：

- 先把越位内容降回非主权层
- 再停在 same-world failure verdict

对 `handoff / compaction / resume` 而言，第一条 same-world 反证也不是摘要变短，而是 `summary / delegated context / display transcript` 开始越权代签 `continuation qualification`。一旦发生，先把越权 surface 降回 `projection`，再停在 `same-world failure verdict`；否则这就不是 continue，而是 renegotiation。

### first reject signal 比成功表述更值钱

这条世界准入能力最先失稳时，第一条信号通常不是回答质量下降，而是世界定义权、展示边界与继续资格开始彼此脱钩。若这些失稳还不能在回答变差前被点名，那失去的也不是回答质感，而是这条世界准入顺序的先验反对权；这时更该先停在 same-world test 失败，而不是急着补更多 checklist。
同样常见的第一反证也不是世界定义句突然消失，而是 `next-step choice` 又从“少数合法分支中的选择”退回“全量动作中的搜索”；一旦 later consumer 必须重新排除旧工具、旧摘要路线或旧 delegated path，甚至重新证明这些分支为何仍该被排除，same-world failure 就已先于回答质量下降成立。

## 5. 苏格拉底式追问

本页只保留四条 acid test：

1. 现在到底是谁在定义世界，是否仍然单源。
2. 当前被消费的是哪条 authoritative transcript / projection，展示层有没有越权成改判层。
3. 经历 `handoff / compaction / resume` 之后，continuation qualification 是否仍成立，而不是靠重述现场续命。
4. later consumer 在 `tool choice / delegate / verify` 前，是否仍要先把“还能做什么”从头搜一遍；若下一步没有先被收敛到少数已授权动作，same-world 即使文面仍顺也已开始失效。

如果这四条已经答不清，就先按 same-world test 失败处理；更细 checklist 只有在这四条都站住之后才有意义。

## 6. 对 Agent Runtime 设计者的直接启发

如果你想复制 Claude Code 的这条世界准入能力，先复制“替 later consumer 预付对已排除分支的冷启动动作搜索成本”的制度结果，而不是先复制某段著名措辞。
它显得聪明，也不是因为主循环更会猜，而是 request assembly 先替 later consumer 付掉了被排除分支的搜索成本，`lawful forgetting` 又保住了让这些分支继续被排除的 witness；一旦 witness 丢失，runtime 就会重新变回“边读边猜世界”。

更具体地说，你要先保证：

- 接手者拿到的是 same-world verdict，而不是另一轮世界协商
- delegated context 只能给线索，不能给世界主语
- compaction 保留的是继续依据，不只是阅读友好的摘要
- 下一步只剩少数已授权分支，而不是再把原本已排除的路径拉回候选集重判

对象链、字段名与实现对象统一留给 `82` 与源码锚点；why 页不再重发 inventory。

## 7. 一句话总结

Prompt 首先是把 `lawful inheritance / search-pruning / decision-retirement` 一起写成世界准入顺序；如果接手者还要先重谈世界、重搜动作空间，或把已退役判断重新拉回候选集，Prompt 就已经失败。
