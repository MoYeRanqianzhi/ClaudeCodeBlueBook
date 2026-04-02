# 共享前缀快照策略模板：何时保存、何时复用、何时suppress

这一章回答五个问题：

1. 如果你在做自己的 agent runtime，什么时候该把主线程上下文冻结成共享前缀快照。
2. 共享前缀里哪些字段必须 byte-stable，哪些变化应该被隔离到旁路 suffix。
3. 为什么没有可信 snapshot 时，宁可 suppress，也不要让旁路循环各自重建世界模型。
4. 为什么共享前缀不等于共享副作用。
5. 怎样把这套策略写成一张真正可执行的设计模板。

## 0. 代表性源码锚点

- `claude-code-source-code/src/query/stopHooks.ts:84-120`
- `claude-code-source-code/src/utils/forkedAgent.ts:47-131`
- `claude-code-source-code/src/commands/btw/btw.tsx:183-227`
- `claude-code-source-code/src/utils/sideQuestion.ts:49-95`
- `claude-code-source-code/src/cli/print.ts:2274-2315`
- `claude-code-source-code/src/services/SessionMemory/sessionMemory.ts:302-324`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts:184-225`
- `claude-code-source-code/src/services/AgentSummary/agentSummary.ts:81-119`
- `claude-code-source-code/src/services/extractMemories/extractMemories.ts:371-427`
- `claude-code-source-code/src/utils/forkedAgent.ts:307-390`

这些锚点共同说明：

- Claude Code 并不是“碰到需要旁路循环时再临时拼 prompt”，而是先由主线程生产 cache-safe snapshot，再让 `/btw`、side question、suggestion、session memory、summary、extract、dream 去复用它。

## 1. 先说结论

更成熟的共享前缀策略，不是：

- 给每个旁路能力各写一段能凑合工作的 prompt

而是：

1. 主线程每轮结束后，明确决定是否产出共享快照。
2. 共享快照只收那些必须 byte-stable 的前缀字段。
3. 旁路循环只附加窄差异，不在共享前缀上偷偷改 cache key。
4. 共享前缀只共享主干真相，不共享副作用写入面。
5. 没有可信 snapshot 时，宁可 suppress 或显式降级，也不要伪装成等价重建。

从第一性原理看，你要保护的不是“缓存命中率”本身，而是：

- 多个辅助循环能否继续活在同一份工作真相里

## 2. 共享前缀快照模板

可以直接把这张模板拿去设计自己的 runtime。

### 2.1 发行点

只在主线程回合结束后发行，不在子代理、后台循环或半完成状态里发行。

Claude Code 的做法：

1. `stopHooks.ts` 在回合结束后构造 `REPLHookContext`。
2. 只有 `repl_main_thread` 与 `sdk` 允许 `saveCacheSafeParams(...)`。
3. 子代理不得覆写主线程快照。

设计原则：

- 共享前缀必须只有一个发行源头

### 2.2 最小 ABI

`forkedAgent.ts` 已经把 `CacheSafeParams` 这份 ABI 写得很清楚：

1. `systemPrompt`
2. `userContext`
3. `systemContext`
4. `toolUseContext`
5. `forkContextMessages`

模板要求：

1. 只把 cache key 真正依赖的字段放进 ABI。
2. 这些字段必须被当成正式 contract，而不是随手拼的临时对象。
3. ABI 注释里要写清哪些字段一旦变化就会打碎共享前缀。

### 2.3 默认复用者

优先复用的应是：

1. 侧问题
2. suggestion
3. session memory / extract memories
4. post-turn summary / dream

这些能力都在做一件事：

- 使用同一世界模型，生成不同后置认知或轻量旁路结果

### 2.4 默认禁止项

如果共享前缀仍是目标，就不要在 fork 里随便改：

1. thinking config
2. tools 集合
3. model
4. system prompt 结构
5. 会影响 `budget_tokens` 的 output 限制

Claude Code 里：

- `AgentSummary` 明确不设 `maxOutputTokens`
- `sideQuestion` 明确不改 thinking
- `extractMemories` 用 `canUseTool` 裁剪，而不是删工具集合

设计原则：

- 限权优先走运行时裁剪，不优先走改共享前缀 ABI

### 2.5 隔离面

共享前缀不等于共享副作用。

默认应隔离：

1. 文件状态
2. 写入 callback
3. transcript 写入
4. replacement state 的变体
5. 权限提示路径

Claude Code 通过 `createSubagentContext(...)` 默认克隆或 no-op 这些可变态，说明它真正想共享的是：

- 前缀真相

而不是：

- 整个运行时的可变写入面

## 3. 何时保存

更稳的保存条件可以压成三条：

1. 主线程已经完成一次正式回合。
2. 前缀字段已经稳定，不再包含半完成 assistant message 或临时组装态。
3. 未来确实存在旁路消费者需要继承这份前缀。

从源码看，Claude Code 会在 stop hooks 里统一保存，而不是让每个消费者自己决定保存时机。这是因为：

- 保存策略本身就是主线程 contract 的一部分

如果保存点散落在调用点里，旁路能力迟早会各自对“什么算可信前缀”产生分歧。

## 4. 何时复用

满足下面三条时优先复用：

1. 你想要的是同一世界模型上的轻量分叉，而不是新的主线程。
2. 你要生成的是认知侧产物，不是新的长链副作用流程。
3. 你愿意遵守主线程前缀 ABI，不随便改 key。

这正是 `/btw`、`sideQuestion`、suggestion、summary、session memory 这些路径的共同点。

可以把它压成一句模板判断：

- 同主语、同世界、窄目标、短后缀，就复用主线程共享前缀

## 5. 何时 suppress

满足下面任一条时，宁可 suppress 或显式降级：

1. 当前没有可信 snapshot。
2. 你无法保证 prefix ABI 等价。
3. 这个 fork 的收益不值得为之制造世界模型漂移。
4. 你只能靠“差不多一样”的重建来继续功能。

Claude Code 的 SDK suggestion 路径就是典型例子：拿不到 `getLastCacheSafeParams()` 时直接 suppress，而不是假装还能无损继承现场。

更深一层的设计理由是：

- 错误地共享前缀，比暂时没有旁路能力更危险

因为前者会让用户看到一条“像懂现场、实际已漂移”的产物。

## 6. 共享前缀策略卡

可以直接抄下面这张策略卡：

```text
共享前缀发行点：
- 只在主线程正式回合结束后保存

共享前缀 ABI：
- systemPrompt
- userContext
- systemContext
- tool/model/thinking 所在的 toolUseContext
- 可继续工作的消息前缀

允许变化：
- 当前 fork 的用户问题
- 当前 fork 的窄目标 prompt
- canUseTool 裁剪
- transcript 写入策略
- 局部观察/流式 UI 回调

默认隔离：
- 文件写入态
- setAppState 这类 mutation callback
- 替换状态与局部追踪集合
- 不该回灌主线程的 suffix cache write

遇到以下情况时 suppress：
- 没有可信 snapshot
- 需要改 ABI 才能工作
- 只能靠模糊重建前缀继续
- 旁路收益低于世界模型漂移风险
```

## 7. 苏格拉底式检查清单

在你新增一个旁路循环前，先问自己：

1. 这个能力是在共享主线程世界，还是在悄悄复制一个平行世界。
2. 共享前缀 ABI 我是否已经正式写出来，而不是散在调用点里。
3. 我现在想限制 fork，是该改共享前缀，还是该裁剪运行时行为。
4. 共享前缀是否正在错误地共享副作用写入面。
5. 没有可信 snapshot 时，我是否有勇气 suppress，而不是假装“差不多等价”。

如果这些问题答不清，所谓“共享前缀”通常只是缓存技巧，而不是稳定的认知网络。

## 8. 一句话总结

Claude Code 值得抄走的不是 `/btw` 或 suggestion 本身，而是那套共享前缀快照策略：主线程统一发行 ABI，旁路循环复用主干真相、隔离局部副作用、拿不到可信 snapshot 时宁可 suppress。
