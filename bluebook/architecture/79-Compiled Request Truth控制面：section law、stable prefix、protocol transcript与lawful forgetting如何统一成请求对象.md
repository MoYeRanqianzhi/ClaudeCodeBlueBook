# Compiled Request Truth控制面：section law、stable prefix、protocol transcript与lawful forgetting如何统一成请求对象

这一章回答五个问题：

1. 为什么 Claude Code 的 Prompt 魔力最终必须回到一个正式的 `compiled request truth` 对象，而不是停在 Prompt Constitution 的方法论。
2. 为什么 section law、stable prefix、protocol transcript 与 lawful forgetting 本质上在描述同一个请求对象。
3. 为什么 suggestion、summary、resume、host evidence 与 cache observability 最终都应围绕这同一个对象工作。
4. 为什么没有这层对象，Prompt 线就会重新退回原文 prompt 崇拜和摘要崇拜。
5. 这对 Agent Runtime 设计者意味着什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/systemPromptSections.ts:1-51`
- `claude-code-source-code/src/constants/prompts.ts:491-557`
- `claude-code-source-code/src/utils/systemPrompt.ts:28-104`
- `claude-code-source-code/src/query/stopHooks.ts:84-120`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/services/compact/prompt.ts:1-260`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-520`

## 1. 先说结论

Claude Code 真正保护的 Prompt 真相，不是：

1. 某段 system prompt 原文
2. 某份 UI transcript 原样历史
3. 某个 compact 摘要文本

而是：

- 一份已经被编译完成、可被继续复用、可被遗忘约束、可被比较漂移的请求对象

这份对象至少由四层共同组成：

1. section law
2. stable prefix
3. protocol transcript
4. lawful forgetting boundary

也就是说，Prompt 魔力最后并不只是一种写法，而是一种：

- compiled request truth control plane

## 2. section law：先固定谁有资格进入请求对象

`systemPromptSections.ts` 说明：

1. section 是正式对象
2. section 有稳定缓存与 cache-break 两种命运
3. `/clear` 与 `/compact` 会清 section 状态

`prompts.ts` 与 `systemPrompt.ts` 进一步说明：

1. default prompt 不是一整段字符串，而是一组有命名的 sections
2. dynamic sections 与 dangerous uncached sections 被显式分层
3. override / coordinator / agent / custom / default / append 拥有正式主权顺序

这意味着 compiled request truth 的第一层不是：

- 内容写了什么

而是：

- 谁有资格进入请求对象，以及进入后是否会改变 cache-stable truth

## 3. stable prefix：先固定谁生产共享 truth

`stopHooks.ts` 说明：

1. 只有 `repl_main_thread` 与 `sdk` 会保存 cache-safe params
2. subagent 不允许覆盖这份共享前缀
3. suggestion、`/btw`、side question 等旁路循环都依赖这份主线程快照

这意味着 compiled request truth 的第二层不是：

- 谁都可以从当前消息大概拼一份世界

而是：

- 主线程拥有唯一 stable prefix producer

一旦没有这一层，旁路循环就会重新长出：

1. summary 自己的世界
2. suggestion 自己的世界
3. resume 自己的世界

也就是第二套 Prompt 真相。

## 4. protocol transcript：先固定模型真正消费的请求体

`messages.ts` 说明：

1. UI transcript 不会被直接送给模型
2. 模型真正消费的是经过 normalization 后的 protocol transcript
3. tool_use / tool_result pairing、attachment 迁移、消息合并与补边都发生在这里

所以 compiled request truth 的第三层不是：

- “当前聊天记录长什么样”

而是：

- “当前哪些协议消息有资格成为请求对象的一部分”

这也是为什么 discovered tools、tool result replacement、resume 之后的继续条件都会受它影响。

## 5. lawful forgetting：先固定删掉什么以后仍然是同一个对象

`services/compact/prompt.ts` 说明：

1. compact 不是任意摘要
2. compact 在规定总结结构、禁止工具调用、要求保留继续条件
3. compact prompt 本身已经在定义“什么是合法遗忘”

也就是说，compiled request truth 的第四层不是：

- 这轮还能剩多少文字

而是：

- 删掉哪些历史以后，请求对象仍然保持同一身份、同一继续语义、同一恢复边界

所以 lawful forgetting 不是 Prompt 之外的修补层，而是请求对象本身的合法命运定义。

## 6. cache observability：先固定这个对象怎样被比较与解释

`promptCacheBreakDetection.ts` 说明：

1. system、tools、cache control、betas、effort、extra body 都会被记录进同一份追踪状态
2. pre-call 阶段先记录 pending changes
3. post-call 阶段再用 cache read drop 判断这次 drift 是否真的发生

这意味着 compiled request truth 不是黑箱对象，它还是：

- 可被解释的请求对象

它能够回答：

1. 是 system 变了
2. 还是 tool schema 变了
3. 还是 cache-control 边界变了
4. 还是模型 / effort / global strategy 变了

如果没有这一层，Prompt 线就无法回答：

- 为什么这次行为变了
- 为什么这次更贵
- 为什么这次应该回退

## 7. 为什么这四层本质上是同一个对象

section law 回答：

- 什么有资格进入请求对象

stable prefix 回答：

- 谁生产这份请求对象

protocol transcript 回答：

- 模型实际消费的是这份对象的哪种协议形态

lawful forgetting 回答：

- 这份对象删减后如何保持同一身份

cache observability 回答：

- 这份对象怎样被比较、解释与调试

所以它们并不是五个平行机制，而是在共同定义同一件事：

- compiled request truth

## 8. 为什么这会改变 Prompt 的理解方式

一旦把 Prompt 理解成 compiled request truth，对 Claude Code 的很多现象就会更容易解释：

1. Prompt 魔力不再来自措辞，而来自世界被编译得更稳定。
2. suggestion / summary / memory 不再是零散辅助功能，而是请求对象的不同消费路径。
3. compact / resume 不再是摘要功能，而是对象身份延续机制。
4. cache break 不再只是性能问题，而是请求对象 drift 问题。

## 9. 一句话总结

Claude Code 的 Prompt 最终强在：它把 section law、stable prefix、protocol transcript、lawful forgetting 与 cache observability 合成了同一份 compiled request truth，而不只是写出了一段更强的 prompt。

