# Prompt的魔力来自把 message lineage 编译成可缓存、可转写、可继续的工作对象

这一章回答五个问题：

1. 为什么 Claude Code 的 Prompt 看起来有魔力，但答案并不在文案修辞。
2. 为什么主权顺序、section registry、dynamic boundary 与 stable prefix 会决定 Prompt 的真实上限。
3. 为什么 `message lineage` 的三键内核与 projection consumer 分层不是消息层细节，而是 Prompt 魔力的一部分。
4. 为什么 lawful forgetting、compact、continue 与 threshold liability 属于同一条 Prompt 编译链。
5. 这对 agent runtime 设计者意味着什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:491-560`
- `claude-code-source-code/src/utils/queryContext.ts:30-58`
- `claude-code-source-code/src/context.ts:155-184`
- `claude-code-source-code/src/utils/api.ts:321-405`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5460`
- `claude-code-source-code/src/utils/sessionStorage.ts:1025-1034`
- `claude-code-source-code/src/utils/sessionStorage.ts:2069-2128`
- `claude-code-source-code/src/services/compact/prompt.ts:61-143`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:247-430`
- `claude-code-source-code/src/query.ts:1065-1340`

这些锚点共同说明：

- Prompt 的魔力不在“更会写”，而在“更会把世界编译成可缓存、可转写、可继续的工作对象”。

如果要消费目录前门已经固定下来的六个 nouns，owner page 统一是 `philosophy/84`；本页只在机制层展开它们各自对应的运行时对象：

1. `Authority`
   - 主权顺序先固定谁能定义世界。
2. `Boundary`
   - `section registry + dynamic boundary` 先固定哪些字节配进入 stable prefix。
3. `Transcript`
   - 模型真正消费的是哪条合法协议历史。
4. `Lineage`
   - `parentUuid / message.id / tool_use_id` 三键怎样持续保住同一身份。
5. `Continuation`
   - lawful forgetting、continue qualification 与 cache-safe fork reuse 怎样让世界继续。
6. `Explainability`
   - cache break、继续失效与世界断裂的原因能否被对象级点名。

这六个 nouns 是目录前门的压缩路由，不是把 `message lineage` 升格成唯一对象；真正的 canonical witness 仍是 `message_lineage_ref -> section_registry_ref -> stable_prefix_ref -> protocol_transcript_ref -> continuation_object_ref -> continue_qualification_verdict`。

## 1. 先说结论

Prompt 真正的魔力，不是：

- 让模型当前这一轮更像懂你

而是：

1. 先把 system prompt 写成可分段、可缓存、可审计的 section registry。
2. 先把主权顺序压成同一条 request assembly order，而不是让多份并列文本互相争主语。
3. 先把 `message lineage` 写成可恢复的三键内核，而不是顺手拼出的聊天历史。
4. 先把 transcript 重写成合法协议对象，再让模型消费。
5. 先把动态变化赶到 stable boundary 之后，保住共享前缀资产。
6. 先规定删掉什么后系统还能继续，而不是一味保留更多历史。
7. 先让 cache break、continue 资格与失稳原因都能被正式解释。

从第一性原理看，Claude Code 的 Prompt 魔力真正像的是：

- 一条编译链

而不是：

- 一段咒语

## 2. 第一性原理：先固定谁能定义世界，再决定怎样描述世界

Claude Code 的 Prompt 有一个常被忽略的前提：

- 它不是简单的 `system + user`

而更接近：

- `systemPrompt + userContext + systemContext + protocol transcript`

这件事的重要性在于：

1. Prompt 的主权顺序先被固定。
2. 风格、流程、边界与工具法律被编译进 system 主链。
3. 人类 later 接手者消费的也不是裸原文，而是同一条被治理过的 request assembly result。

所以 Prompt 魔力首先不是：

- 写得更强势
- 写得更像专家

而是：

- 谁能定义当前世界、谁只能提供补充上下文，这条秩序先被钉死

## 3. 第二层：lineage kernel 优于“历史还在”

很多系统默认“只要历史没丢，继续就还能成立”。

Claude Code 更接近的真相是：

- 真正该被保住的不是一条更长的 transcript，而是 `message lineage` 的三键内核

也就是：

1. `parentUuid / logicalParentUuid`
   - 接回当前历史骨架
2. `message.id`
   - 让 assistant 片段仍被认成同一条消息
3. `tool_use_id / sourceToolAssistantUUID`
   - 让 tool use / tool result 与 findings 回到同一个行动主语

这意味着 Prompt 魔力不只是“记得说过什么”，而是：

- 还知道现在这句话属于哪个世界、哪个动作、哪个继续主语

## 4. 第三层：协议转写优于显示历史

很多系统以为 Prompt 负责 instruction，messages 只是上下文容器。

Claude Code 更接近的真相是：

- 模型真正消费的是 `prompt + normalized transcript + paired tool protocol`

这意味着 Prompt 魔力不只来自 system prompt 本身，还来自：

1. UI 历史不会直接越权进入模型路径。
2. `tool_use / tool_result` pairing 会先被修正。
3. 非法消息形态不会混入继续链。
4. 用户可见 transcript 与模型可执行 transcript 被明确分层。

所以它真正保护的不是：

- 文案纯度

而是：

- 世界进入模型前的协议纯度

## 5. 第四层：projection consumer 分层优于“所有历史都一样”

真正难的不是“有几份 transcript”，而是不同消费者是否仍在消费同一条 lineage。

Claude Code 至少稳定区分了四类 projection consumer：

1. display consumer
   - 关心人类可读历史
2. model API consumer
   - 关心 `protocol transcript` 与合法消息 ABI
3. SDK / control consumer
   - 关心宿主协议、tool progress 与状态投影
4. handoff / compact / resume consumer
   - 关心 `continuation object` 是否仍可行动

所以它真正保护的不是：

- 让所有观察面看起来都差不多

而是：

- 让不同 consumer 的差异只停留在读法，不升级成真相分叉

## 6. 第五层：可缓存前缀优于更长文案

如果 Prompt 只是长文案，那么每一次变化都会重新把世界整体打散。

Claude Code 更成熟的地方在于，它先问：

- 哪些字节必须稳定到足以成为共享前缀资产

这会改变 Prompt 设计的目标函数：

- 不再追求“尽量写全”
- 而是追求“真正稳定的部分尽量不被重编”

所以它的魔力不是：

- 每次都重新讲清世界

而是：

- 尽量不重复讲已经成立的世界

也正因为如此，`SYSTEM_PROMPT_DYNAMIC_BOUNDARY`、section registry 与 stable prefix 不只是性能技巧，而是 Prompt stable-prefix order 的一部分。

更进一步，section registry 也不是一份静态目录，而是会在 `/compact` 之后被重新整理、重置与续接的运行时对象。这意味着 Prompt stable-prefix order 不是“永远附着在顶部的一段总纲”，而是有自己生命周期的正式运行时资产。

Anthropic 官方文档又把这件事往外表钉死了一层：

1. nested `CLAUDE.md`、path-scoped rules、skills 与 MCP 定义都属于按需加载对象；
2. startup context、on-demand expansion 与 `/compact` 后 reload 被公开写成不同 load fate；
3. `InstructionsLoaded / PreCompact / PostCompact` 这种 hook 生命周期进一步说明，Boundary 不只是在管 stable bytes，还在管 `eager load / lazy load / compact reload` 的正式装配法。

## 7. 第六层：工具 ABI 与写作法同属 Prompt runtime order

Claude Code 的 Prompt 高密度，不只因为 instruction 多，还因为：

1. 工具命名、专用工具优先级、并行策略与替代禁令被直接写进 Prompt。
2. 长度、格式、文件引用、列表层级与 channels 分工也被直接写进 Prompt。
3. 显示层会继续把 thinking 与 tool 噪音蒸馏掉，保证用户消费的是 Prompt 指定的结果形态。

这意味着 Prompt 魔力的一大部分，其实来自两层协同：

- Prompt frontdoor 固定行为与写法要求
- Runtime 明确规定哪些内容能被用户看见

所以它强的地方不是：

- 模型临场发挥得更好

而是：

- 模型能发挥的空间本身已经被编排成高行动语义密度的受治理世界

## 8. 第七层：合法遗忘优于无限记忆

如果一个 Prompt 只能靠“尽量别忘”维持强度，它就永远只是短任务技巧。

Claude Code 更高级的地方在于，它同样认真规定：

- 忘掉什么之后，下一轮仍能合法继续

这会把 compact 从“压缩历史”改写成：

- 续写对象重建

真正保住 Prompt 魔力的不是：

- 还留了多少上下文

而是：

- 继续工作的判断条件有没有留下来

这也会把 summary 从“更好读”改写成：

- `lawful forgetting boundary` 是否仍然成立

如果继续把这组对象再压成 `lawful forgetting witness ABI`，更稳的最小分层也只该剩：

1. `required`
   - `current work / next-step guard / required assets / rollback boundary / continue qualification / threshold liability`
2. `derivable`
   - 可以从同一 lineage 与同一 object graph 稳定重建，但不该单独担任 witness。
3. `narrative-only`
   - 只负责帮助人类快速理解，不负责改判 continue / reject。
4. `forbidden-as-sole-witness`
   - 只剩 prose、结论或情绪，而没有 object / guard / liability 绑定时，直接拒绝当作 lawful forgetting 成立证据。

更硬一点说，compact / resume / handoff 共用的不是“摘要格式”，而是这组 witness ABI 能否仍被 parse 并复现同一条 continuation verdict。
这组 witness ABI 也应被继续读成 versioned object：字段可以扩展，但 `required` 与 `forbidden-as-sole-witness` 这两层不能在没有明确 rebinding 的情况下被静默改写。

更准确地说，compact 之后系统至少还得保住一份最小 `continuation object`：

1. `current work`
2. `next-step guard`
3. `required assets`
4. `rollback boundary`
5. `continue qualification`
6. `threshold liability`

如果 compact 之后只剩“更短的故事”，Prompt 就只剩叙事压缩，不再是合法继续。

## 9. 第八层：继续资格也是 Prompt 设计的一部分

很多系统把 continue 视为运行时补丁。

Claude Code 更接近的真相是：

- stop hooks、cache break explainability、budget continuation 与 prompt-too-long recovery 共同暴露 continue qualification 是否仍成立

这说明 Prompt 魔力从来不是静态的。

它会继续追问：

1. 当前世界还能否被合法继承。
2. 当前 break 能否被正式解释。
3. 当前 side path 是否仍与主线程共享前缀。
4. 当前是否还配继续、继续多久、何时必须 re-entry、何时必须 reopen。

也就是说，Prompt 的魔力不只是：

- 会开场

而且还会：

- 暴露自己是否还配继续

多 Agent 场景更能说明这一点。真正强的地方不是“会给 worker 写指令”，而是 coordinator 必须先理解 findings，再生成自包含、不可把理解外包给 worker 的 prompt。这里的 Prompt 魔力首先是一种组织设计，而不是更会写 worker 文案。

## 10. 第九层：可解释失稳优于神秘成功

如果一个 Prompt 只能成功、不能解释自己为什么成功，它仍然只是幸运。

Claude Code 值得学的地方正在于：

- 它把 prompt cache break、stable bytes、continue qualification 都做成了可追责对象

这意味着 Prompt 魔力真正成熟的标志不是：

- 大家都觉得它很灵

而是：

- 它失灵时团队能正式解释为什么

## 11. 苏格拉底式追问

### 11.1 为什么 Prompt 魔力不是文案技巧

因为真正稀缺的不是好句子，而是：

- 世界进入模型前的编译秩序

### 11.2 为什么 `message lineage` 不是单纯聊天历史

因为真正该被保住的不是顺序文本，而是三键内核是否仍能接住当前世界。

### 11.3 为什么 projection consumer 分层也属于 Prompt 设计

因为如果 display、protocol、SDK/control 与 handoff 继续被混写，再强的 prompt 也会在消费者边界处重新说谎。

### 11.4 为什么合法遗忘也属于 Prompt 设计

因为真正强的 Prompt 不只规定现在怎么看世界，还规定：

- 删掉什么以后系统仍知道怎样继续

### 11.5 为什么 Prompt 魔力最终仍是工程能力

因为它保护的不是“这一轮说得好”，而是：

- 可缓存
- 可转写
- 可继续
- 可解释失稳

## 12. 对 Agent 设计者的启发

如果想学 Claude Code，最该抄走的不是：

- 某一段 system prompt 文案

而是：

1. 把 Prompt 写成 section registry，而不是长文本。
2. 把 `message lineage` 写成可恢复的三键内核，而不是一条更长的聊天链。
3. 把不同 projection consumer 的职责分开，而不是让 UI 历史兼任模型历史。
4. 把动态变化赶到 stable boundary 后面。
5. 把 lawful forgetting 设计成 continuation object 重建。
6. 让 prompt 失稳原因可以被正式解释，而不是继续神秘化。
