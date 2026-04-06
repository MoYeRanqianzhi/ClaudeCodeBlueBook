# 请求装配流水线：message lineage、protocol transcript、lawful forgetting与cache-safe forks

这一章回答五个问题：

1. 为什么 Claude Code 的 Prompt 魔力更接近请求编译，而不是文案修辞。
2. 为什么 `message lineage` 必须被压实成可恢复、可继续、可配对的三键内核。
3. 为什么 `display transcript`、`protocol transcript`、SDK/control projection 与 `continuation object` 不能混写。
4. 为什么 `lawful forgetting`、`/btw`、prompt suggestion、session memory 与子 Agent 摘要都要围绕同一条 cache-safe 前缀复用。
5. 这对 Agent runtime 设计者意味着什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/systemPromptSections.ts:16-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:491-576`
- `claude-code-source-code/src/utils/systemPrompt.ts:28-123`
- `claude-code-source-code/src/utils/api.ts:321-405`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/utils/sessionStorage.ts:1025-1034`
- `claude-code-source-code/src/utils/sessionStorage.ts:1408-1467`
- `claude-code-source-code/src/utils/sessionStorage.ts:1823-1863`
- `claude-code-source-code/src/utils/sessionStorage.ts:2069-2128`
- `claude-code-source-code/src/services/compact/prompt.ts:19-143`
- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:188-327`
- `claude-code-source-code/src/query/stopHooks.ts:84-214`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/tools/AgentTool/resumeAgent.ts:70-130`
- `claude-code-source-code/src/utils/forkedAgent.ts:46-126`
- `claude-code-source-code/src/tools/AgentTool/forkSubagent.ts:45-140`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:224-560`

这些锚点共同说明：

- Claude Code 的 Prompt 魔力，本质上来自一条正式的请求装配流水线。系统先编译“当前世界应该如何进入模型”，再让模型开始发言。

如果把这条流水线再压成目录前门已经稳定的 nouns，它们只该对应成：

1. `Authority`
   - `world-defining winner`
2. `Boundary`
   - `section registry + dynamic boundary`
3. `Transcript`
   - `protocol transcript`
4. `Lineage`
   - `message lineage`
5. `Continuation`
   - lawful forgetting、continuation qualification 与 cache-safe forks
6. `Explainability`
   - cache-break reason 与 continue 失效的对象级解释

## 1. 先说结论

Claude Code 真正保护的不是：

- 一段更强的 system prompt

而是同一条可被继续重建的 `message lineage` 及其六个制度护栏：

1. `world-defining winner` 先固定谁有权定义当前世界。
2. `section registry` 先固定哪些制度字节属于正式 Prompt 宪法。
3. `dynamic boundary` 先把晚绑定状态赶出稳定前缀。
4. `protocol transcript` 先把显示历史重编成模型可执行历史。
5. `lawful forgetting` 先定义删掉什么之后系统仍能合法继续。
6. `cache-safe forks` 先定义旁路循环怎样复用同一个世界，而不是重造平行世界。

这里真正持续存活的一号对象，不是单次 request 壳，而是三键协同的 lineage kernel：

1. `parentUuid / logicalParentUuid`
   - 管消息拓扑
2. `message.id`
   - 管 assistant 片段归并
3. `tool_use_id / sourceToolAssistantUUID`
   - 管工具配对与 tool-result 回链

这也是为什么 Claude Code 的 Prompt 看起来像“有魔力”：

- 它不是在说服模型，而是在控制世界进入模型的方式。

## 2. 第一性原理：先固定谁能定义世界，再决定怎样描述世界

Claude Code 的请求装配首先解决的不是：

- 怎么把提示词写得更强

而是：

- 谁能宣布当前世界是什么

从源码锚点可以压出一条清楚的世界定义顺序：

1. `override`
2. `coordinator`
3. `agent`
4. `custom`
5. `default`
6. `append`

这条顺序的价值不是样式统一，而是：

- 防止 system、worker、宿主、用户补丁、追加说明互相争主语

一旦世界定义顺序漂移，系统就会重新退回：

- 多段看起来都像真相的文本并列存在

Prompt 魔力也会退回：

- 谁写得更像作者，谁暂时赢

## 3. Section Registry 不是目录，而是 Prompt 宪法的生命周期

`systemPromptSections.ts`、`prompts.ts` 与 `systemPrompt.ts` 共同说明，Claude Code 的 Prompt 从来不是一个 blob。

它更接近：

1. 一组命名 section
2. 一组 section 级缓存规则
3. 一组 `/clear`、`/compact`、继续与恢复时的重置语义

所以 `section registry` 保护的不是：

- 目录看起来更规整

而是：

- Prompt Constitution 自己拥有正式生命周期

这会直接改变 Prompt 的设计目标：

- 不再追求“所有东西都写进开头”
- 而是追求“真正稳定的 law 留在 stable prefix，易变部分被晚绑定重注入”

## 4. Projection Consumer Matrix：同一条 lineage，四类正式读法

Claude Code 值得学的一点，是它不让 UI 历史直接越权进入模型路径。

更准确地说，它同时维护四类互相关联但不能混写的 projection consumer：

1. `display transcript`
   - 给人类看见、搜索、复制、导航的历史；它是 lineage 的 human-readable projection
2. `protocol transcript`
   - 给模型消费的、已经过合法化与 tool pairing 修复的历史；它是 lineage 的 model-facing projection
3. `SDK / control projection`
   - 给宿主、控制面、tool progress、state writeback 与 host truth 消费的协议化投影
4. `continuation object`
   - 在 compact、resume、handoff 之后仍能继续工作的最小行动语义体；它是 lineage 的 handoff projection

这也是 `messages.ts`、`sessionStorage.ts` 与 `sessionMemoryCompact.ts` 特别重要的原因：

- 前两者在 API 边界前后维持 lineage、pairing 与消息合法性
- 后者在压缩后保留仍可继续工作的对象边界

所以 Claude Code 真正保护的不是：

- 历史更完整

而是：

- 历史在不同消费者前都保持各自合法，而且始终不脱离同一条 `message lineage`

## 5. Lawful Forgetting 不是摘要技巧，而是身份保全

如果 compact 只是在“保留聊过什么”，那它本质上还是长对话优化。

Claude Code 更深的一层是：

- 它把遗忘本身写成正式制度

也就是说，系统先回答：

1. 哪些叙事冗余可以删
2. 哪些对象位点必须保留
3. 删掉之后怎样证明 identity 还在

因此 `lawful forgetting` 真正保护的不是：

- 更多历史字数

而是：

- 当前意图、当前约束、下一步资格仍然围绕同一对象继续成立

更稳的说法是，compact 之后系统至少还得保住一份最小 `continuation object`：

1. `current work`
2. `next-step guard`
3. `required assets`
4. `rollback boundary`
5. `continuation qualification`
6. `threshold liability`

如果 compact 之后只剩“更短的故事”，这就不是 lawful forgetting，而是对象蒸发。

## 6. Cache-Safe Forks：旁路循环不是第二主线程

`stopHooks.ts`、`forkedAgent.ts`、`forkSubagent.ts`、prompt suggestion、memory extraction 与 `/btw` 这类机制揭示了同一条更深的设计律：

- 旁路循环默认复用父前缀，而不是各自重写世界

这意味着：

1. 主线程是稳定前缀生产者
2. 旁路线程只拿 narrow delta
3. 输出结果再回到主线程综合

它真正反对的是：

- 每个 side loop 都重新造一份“差不多知道现场”的 prompt

一旦允许那样做，系统马上会出现：

- path parity split
- cache 断裂
- handoff 多真相

所以 cache-safe forks 保护的不是：

- 性能技巧

而是：

- 多线程协作仍围绕同一世界对象成立

## 7. 为什么这就是 Prompt 魔力的更深解释

Claude Code 的 Prompt 会显得 unusually coherent，不是因为它：

- 更会写 instruction

而是因为它先解决了七件更硬的事：

1. 谁能定义世界
2. 哪些 section 属于正式法律
3. `message lineage` 怎样持续可恢复
4. 哪条历史才配进入模型
5. 哪些 consumer 只能消费投影
6. 忘掉什么后系统仍然合法
7. 旁路循环怎样不重造平行世界

这会让 Prompt 从：

- 文案对象

变成：

- 请求编译流水线

## 8. 对 Agent Runtime 设计者的直接启发

如果你想复制 Claude Code 的 Prompt 强度，优先复制的不是具体措辞，而是：

1. 明确的 world-defining winner
2. section 宪法
3. `message lineage` 三键内核
4. projection consumer 分层
5. stable prefix / dynamic boundary 分层
6. lawful forgetting 规则
7. cache-safe fork reuse

如果这七件事没有先成立，再长的 Prompt 也只是在堆说明书。

## 9. 苏格拉底式追问

在你准备宣布“我已经理解了 Claude Code 的 Prompt 魔力”前，先问自己：

1. 我解释的是文案更强，还是请求被怎样编译。
2. 当前到底是谁在定义世界；如果主语冲突，谁赢。
3. 这条 `message lineage` 的三键内核是否仍完整。
4. 我区分了 display、protocol、SDK/control 与 handoff 这四类 consumer 吗。
5. compact 后留下的是摘要，还是仍可继续行动的对象。
6. 子 Agent、摘要、建议与 stop hook 是在复用前缀，还是各自重建平行世界。

## 10. 一句话总结

Claude Code 的 Prompt 魔力，首先不是文案魔力，而是请求装配魔力：它把世界定义顺序、lineage 内核、协议转写、合法遗忘与旁路复用一起写成了一条正式的 runtime pipeline。
