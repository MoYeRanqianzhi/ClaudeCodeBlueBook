# 辅助循环、侧问题与后回合Fork共享前缀

这一章回答五个问题：

1. 为什么 Claude Code 的 prompt 魔力并不只存在于主线程 query。
2. `/btw`、prompt suggestion、session memory、extract memories、auto-dream、agent summary 为什么能共享主线程前缀。
3. 为什么这些辅助循环不该被理解成“再开一个小模型调用”。
4. cache-safe fork 说明了什么样的 prompt 结构才真正可迁移。
5. 这对 agent runtime 的长期设计意味着什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/query/stopHooks.ts:92-99`
- `claude-code-source-code/src/commands/btw/btw.tsx:183-227`
- `claude-code-source-code/src/cli/print.ts:2274-2298`
- `claude-code-source-code/src/utils/forkedAgent.ts:70-141`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts:184-221`
- `claude-code-source-code/src/services/SessionMemory/sessionMemory.ts:315-325`
- `claude-code-source-code/src/services/extractMemories/extractMemories.ts:371-427`
- `claude-code-source-code/src/services/autoDream/autoDream.ts:224-233`
- `claude-code-source-code/src/services/AgentSummary/agentSummary.ts:81-109`
- `claude-code-source-code/src/tools/AgentTool/runAgent.ts:721-729`

## 1. 先说结论

Claude Code 的 prompt 魔力，真正厉害的地方不只是主线程强，而是：

- 它把主线程 prompt 变成了可被辅助循环复用的前缀资产

这些辅助循环包括：

1. `/btw` 侧问题
2. prompt suggestion
3. session memory 更新
4. extract memories
5. auto-dream
6. agent summary / post-turn summary

所以 Claude Code 并不是：

- 主线程一套 prompt，旁边很多各写各的副本

而是：

- 主线程产出稳定前缀
- 辅助循环在不打碎前缀的前提下，借用同一份 runtime contract

## 2. 主线程不是唯一消费者，它还是 prefix 生产者

`stopHooks.ts` 在每轮结束后保存 `CacheSafeParams`，并明确写出两点：

1. 只给 `repl_main_thread` 或 `sdk` 主线程查询保存
2. `/btw` 与 side question 会直接读取这个 snapshot

这说明主线程不只是：

- 当前轮的执行者

它还是：

- 后续辅助循环的 prefix 生产者

一旦没有这层设计，所有 post-turn fork 都只能：

- 从零重建 system prompt
- 从零重建 user/system context
- 从零承担 cache break 风险

## 3. `/btw`：侧问题不是新会话，而是共享前缀的岔路

`/btw` 的注释写得非常直白：

- preferred source is `getLastCacheSafeParams`
- reusing them guarantees a byte-identical prefix and thus a prompt cache hit

这说明 `/btw` 的哲学不是：

- 随手起一个临时问答

而是：

- 在当前主线程世界模型上开一个共享前缀的侧枝

所以 `/btw` 强，不只是因为它“知道刚才聊了什么”，而是因为它尽量继承了：

- 同一 system prompt
- 同一 user/system context
- 同一 toolUseContext 结构
- 同一 compact boundary 之后的会话切片

## 4. prompt suggestion：建议词生成也吃主线程 prefix

`executePromptSuggestion(...)` 会直接从 `REPLHookContext` 构建 `CacheSafeParams`。

`print.ts` 的 SDK 路径则更进一步：

- 先取 `getLastCacheSafeParams()`
- 没有 snapshot 时宁可 suppress，也不盲目重建

这说明 prompt suggestion 的目标不是：

- 不惜一切代价生成一句建议词

而是：

- 在主线程 prompt contract 仍然可复用时，再生成建议词

所以建议词之所以看起来“懂现场”，不是因为旁路模型特别聪明，而是因为：

- 它正在共享主线程刚刚使用过的前缀资产

## 5. memory / extract / dream：这些后台循环也在借同一前缀

`SessionMemory`、`extractMemories`、`autoDream` 都走了同一个模式：

1. 先在主线程 stop hook 上下文里构建 `CacheSafeParams`
2. 再把它传给 `runForkedAgent(...)`
3. 用工具白名单、`skipTranscript`、`maxTurns` 等参数限制 fork 行为

这说明这些后台循环真正共享的，不只是“上一轮消息”。

它们共享的是：

- 主线程刚刚确认过的 prompt contract

这非常重要，因为如果没有这层共享，这些后台循环会出现两种坏事：

1. 每个循环都得重建自己的世界模型，成本迅速膨胀。
2. 每个循环都可能拿到与主线程略有偏差的前缀，导致总结、记忆、建议词彼此失真。

## 6. agent summary：连总结都不愿为了方便打碎 cache key

`AgentSummary.ts` 有一句特别有价值的注释：

- do not set `maxOutputTokens` here
- otherwise thinking config mismatch invalidates the cache

作者甚至愿意为了保住 cache sharing：

- 不去改一个看似无害的输出上限参数

这说明 Claude Code 对辅助循环的要求不是：

- 局部最方便

而是：

- 尽量沿主线程已经建立好的 cache-safe contract 运行

这也是为什么连 agent summary 这样的“看似很边缘的后处理”，都被纳入同一 prompt 设计哲学。

## 7. 为什么这些循环不能被理解成“再开一个小模型调用”

如果只是“再开一个调用”，Claude Code 不需要：

- `CacheSafeParams`
- stop hooks snapshot
- fork label
- cache sharing 约束
- 明确警告哪些参数会 bust cache

这些设计共同说明，Claude Code 在处理的是另一类问题：

- 如何让主线程之外的辅助循环，也继续活在同一份 prompt 经济体系中

所以更准确的说法是：

- Claude Code 的 prompt 魔力不是单点能力，而是一张以主线程为中心、向辅助循环辐射的 prefix network

## 8. 苏格拉底式追问

### 8.1 如果主线程已经很强，为什么还要让辅助循环共享前缀

因为很多高价值能力并不发生在主线程里。

比如：

- 建议下一步
- 抽取 memory
- 汇总 agent transcript
- 做 auto-dream consolidation

这些如果不能共享主线程前缀，就会变成昂贵而脆弱的平行系统。

### 8.2 为什么有时宁可 suppress，也不重建

因为在 Claude Code 里，盲目重建不只是“多花一点 token”，还意味着：

- 缓存命中率掉下去
- 世界模型轻微漂移
- 辅助循环输出和主线程判断不一致

### 8.3 对 agent runtime 设计者最直接的启发是什么

如果你想做真正长期可用的 prompt 系统，不要只想：

- 当前这一轮怎么拼 prompt

还要想：

- 哪些后处理、旁路、建议、总结、记忆循环能共享主线程的 prefix asset

## 9. 一句话总结

Claude Code 的 prompt 魔力不是只属于主线程 query，它还来自一张共享 `CacheSafeParams` 的辅助循环网络：主线程生产前缀，侧问题、建议词、记忆与总结循环复用这份前缀资产。
