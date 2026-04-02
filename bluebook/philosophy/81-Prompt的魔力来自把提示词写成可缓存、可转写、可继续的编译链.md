# Prompt的魔力来自把提示词写成可缓存、可转写、可继续的编译链

这一章回答五个问题：

1. 为什么 Claude Code 的 Prompt 看起来有魔力，但答案并不在文案修辞。
2. 为什么 section registry、dynamic boundary 与 stable prefix 会决定 Prompt 的真实上限。
3. 为什么 protocol rewrite 与 tool pairing 不是消息层细节，而是 Prompt 魔力的一部分。
4. 为什么 lawful forgetting、compact 与 continue 链条属于同一条 Prompt 编译链。
5. 这对 agent runtime 设计者意味着什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/utils/api.ts:321-405`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5460`
- `claude-code-source-code/src/services/compact/prompt.ts:61-143`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:247-430`
- `claude-code-source-code/src/query.ts:1065-1340`

这些锚点共同说明：

- Prompt 的魔力不在“更会写”，而在“更会把世界编译成可缓存、可转写、可继续的工作对象”。

## 1. 先说结论

Prompt 真正的魔力，不是：

- 让模型当前这一轮更像懂你

而是：

1. 先把 system prompt 写成可分段、可缓存、可审计的 section registry。
2. 先把动态变化赶到 stable boundary 之后，保住共享前缀资产。
3. 先把 transcript 重写成合法协议对象，再让模型消费。
4. 先规定删掉什么后系统还能继续，而不是一味保留更多历史。
5. 先让 cache break、continue 资格与失稳原因都能被解释。

从第一性原理看，Claude Code 的 Prompt 魔力真正像的是：

- 一条编译链

而不是：

- 一段咒语

## 2. 第一层：可缓存前缀优于更长文案

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

## 3. 第二层：协议转写优于原文历史

很多系统以为 Prompt 负责 instruction，messages 只是上下文容器。

Claude Code 更接近的真相是：

- 模型真正消费的是 `prompt + normalized transcript + paired tool protocol`

这意味着 Prompt 魔力不只来自 system prompt 本身，还来自：

1. UI 历史不会直接越权进入模型路径。
2. tool_use / tool_result pairing 会先被修正。
3. 非法消息形态不会混入继续链。

所以它真正保护的不是：

- 文案纯度

而是：

- 世界进入模型前的协议纯度

## 4. 第三层：合法遗忘优于无限记忆

如果一个 Prompt 只能靠“尽量别忘”维持强度，它就永远只是短任务技巧。

Claude Code 更高级的地方在于，它同样认真规定：

- 忘掉什么之后，下一轮仍能合法继续

这会把 compact 从“压缩历史”改写成：

- 续写对象重建

真正保住 Prompt 魔力的不是：

- 还留了多少上下文

而是：

- 继续工作的判断条件有没有留下来

## 5. 第四层：继续资格也是 Prompt 设计的一部分

很多系统把 continue 视为运行时补丁。

Claude Code 更接近的真相是：

- stop hooks、cache break explainability、budget continuation 与 prompt-too-long recovery 共同决定 Prompt 还有没有资格继续

这说明 Prompt 魔力从来不是静态的。

它会继续追问：

1. 当前世界还能否被合法继承。
2. 当前 break 能否被正式解释。
3. 当前 side path 是否仍与主线程共享前缀。

也就是说，Prompt 的魔力不只是：

- 会开场

而且还会：

- 审查自己是否还配继续

## 6. 第五层：可解释失稳优于神秘成功

如果一个 Prompt 只能成功、不能解释自己为什么成功，它仍然只是幸运。

Claude Code 值得学的地方正在于：

- 它把 prompt cache break、stable bytes、continue qualification 都做成了可追责对象

这意味着 Prompt 魔力真正成熟的标志不是：

- 大家都觉得它很灵

而是：

- 它失灵时团队能正式解释为什么

## 7. 苏格拉底式追问

### 7.1 为什么 Prompt 魔力不是文案技巧

因为真正稀缺的不是好句子，而是：

- 世界进入模型前的编译秩序

### 7.2 为什么合法遗忘也属于 Prompt 设计

因为真正强的 Prompt 不只规定现在怎么看世界，还规定：

- 删掉什么以后系统仍知道怎样继续

### 7.3 为什么协议转写不是另一个系统的问题

因为如果 transcript ABI 不合法，再强的 prompt 也只是在污染历史上工作。

## 8. 对 Agent 设计者的启发

如果想学 Claude Code，最该抄走的不是：

- 某一段 system prompt 文案

而是：

1. 把 Prompt 写成 section registry，而不是长文本。
2. 把动态变化赶到 stable boundary 后面。
3. 让模型永远消费协议真相，而不是显示层历史。
4. 把 lawful forgetting 设计成 continuation object 重建。
5. 让 prompt 失稳原因可以被正式解释，而不是继续神秘化。
