# 请求装配流水线：authority chain、section registry、protocol transcript、lawful forgetting与cache-safe forks

这一章回答五个问题：

1. 为什么 Claude Code 的 Prompt 魔力更接近请求编译，而不是文案修辞。
2. 为什么 `authority chain`、`section registry`、`dynamic boundary` 与 `protocol transcript` 必须被放在同一张图里。
3. 为什么 `display transcript`、模型真正消费的 `protocol transcript` 与继续工作的 `continuation object` 不能混写。
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
- `claude-code-source-code/src/services/compact/prompt.ts:19-143`
- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:188-327`
- `claude-code-source-code/src/query/stopHooks.ts:84-214`
- `claude-code-source-code/src/utils/forkedAgent.ts:46-126`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:224-560`

这些锚点共同说明：

- Claude Code 的 Prompt 魔力，本质上来自一条正式的请求装配流水线。系统先编译“当前世界应该如何进入模型”，再让模型开始发言。

## 1. 先说结论

Claude Code 真正保护的不是：

- 一段更强的 system prompt

而是同一条 `compiled request truth`：

1. `authority chain` 先固定谁有权定义当前世界。
2. `section registry` 先固定哪些制度字节属于正式 Prompt 宪法。
3. `dynamic boundary` 先把晚绑定状态赶出稳定前缀。
4. `protocol transcript` 先把显示历史重编成模型可执行历史。
5. `lawful forgetting` 先定义删掉什么之后系统仍能合法继续。
6. `cache-safe forks` 先定义旁路循环怎样复用同一个世界，而不是重造平行世界。

这也是为什么 Claude Code 的 Prompt 看起来像“有魔力”：

- 它不是在说服模型，而是在控制世界进入模型的方式。

## 2. 第一性原理：先固定谁能定义世界，再决定怎样描述世界

Claude Code 的请求装配首先解决的不是：

- 怎么把提示词写得更强

而是：

- 谁能宣布当前世界是什么

从源码锚点可以压出一条清楚的主权顺序：

1. `override`
2. `coordinator`
3. `agent`
4. `custom`
5. `default`
6. `append`

这条顺序的价值不是样式统一，而是：

- 防止 system、worker、宿主、用户补丁、追加说明互相争主语

一旦主权顺序漂移，系统就会重新退回：

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

## 4. Display Transcript、Protocol Transcript 与 Continuation Object 是三层不同真相

Claude Code 值得学的一点，是它不让 UI 历史直接越权进入模型路径。

更准确地说，它同时维护三层互相关联但不能混写的真相：

1. `display transcript`
   - 给人类看见、搜索、复制、导航的历史
2. `protocol transcript`
   - 给模型消费的、已经过合法化与 tool pairing 修复的历史
3. `continuation object`
   - 在 compact、resume、handoff 之后仍能继续工作的最小行动语义体

这也是 `messages.ts` 与 `sessionMemoryCompact.ts` 特别重要的原因：

- 前者在 API 边界前重新编译模型侧协议真相
- 后者在压缩后保留仍可继续工作的对象边界

所以 Claude Code 真正保护的不是：

- 历史更完整

而是：

- 历史在不同消费者前都保持各自合法

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

这也是为什么它会显得“长会话还像在同一个现场里”。

## 6. Cache-Safe Forks：旁路循环不是第二主线程

`stopHooks.ts`、`forkedAgent.ts`、prompt suggestion、memory extraction 与 `/btw` 这类机制揭示了同一条更深的设计律：

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

而是因为它先解决了六件更硬的事：

1. 谁能定义世界
2. 哪些 section 属于正式法律
3. 什么必须晚绑定
4. 哪条历史才配进入模型
5. 忘掉什么后系统仍然合法
6. 旁路循环怎样不重造平行世界

这会让 Prompt 从：

- 文案对象

变成：

- 请求编译流水线

## 8. 对 Agent Runtime 设计者的直接启发

如果你想复制 Claude Code 的 Prompt 强度，优先复制的不是具体措辞，而是：

1. 单一主权链
2. section 宪法
3. stable prefix / dynamic boundary 分层
4. UI 历史与 protocol 历史分离
5. lawful forgetting 规则
6. cache-safe fork reuse

如果这六件事没有先成立，再长的 Prompt 也只是在堆说明书。

## 9. 苏格拉底式追问

在你准备宣布“我已经理解了 Claude Code 的 Prompt 魔力”前，先问自己：

1. 我解释的是文案更强，还是请求被怎样编译。
2. 当前到底是谁在定义世界；如果主语冲突，谁赢。
3. 哪些字节属于 stable prefix，哪些字节根本不配进入长期正文。
4. 我区分了 display transcript、protocol transcript 与 continuation object 吗。
5. compact 后留下的是摘要，还是仍可继续行动的对象。
6. 子 Agent、摘要、建议与 stop hook 是在复用前缀，还是各自重建平行世界。

## 10. 一句话总结

Claude Code 的 Prompt 魔力，首先不是文案魔力，而是请求装配魔力：它把主权顺序、section 法律、历史编译、合法遗忘与旁路复用一起写成了一条正式的 runtime pipeline。
