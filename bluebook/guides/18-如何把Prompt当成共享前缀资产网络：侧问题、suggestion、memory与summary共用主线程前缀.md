# 如何把主线程 Lineage 写成可复用 Continuation 前缀网络

这一章回答五个问题：

1. 为什么 Claude Code 里的 prompt 不该被理解成“一次请求里的那段文本”。
2. 为什么主线程 query 不只是执行回合，还是共享前缀的生产者。
3. 为什么 `/btw`、prompt suggestion、memory、summary、dream 更像同一张 prefix network，而不是很多独立小调用。
4. 为什么没有可信 snapshot 时，宁可 suppress 或窄化 fallback，也不要让旁路循环各自重建世界模型。
5. 怎样从第一性原理迁移这套设计，让 prompt 魔力从单轮效果升级成跨循环一致性。

## 0. 代表性源码锚点

- `claude-code-source-code/src/query/stopHooks.ts:84-120`
- `claude-code-source-code/src/commands/btw/btw.tsx:183-227`
- `claude-code-source-code/src/cli/print.ts:2274-2315`
- `claude-code-source-code/src/utils/forkedAgent.ts:47-131`
- `claude-code-source-code/src/utils/sideQuestion.ts:49-95`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts:184-225`
- `claude-code-source-code/src/services/SessionMemory/sessionMemory.ts:302-324`
- `claude-code-source-code/src/services/extractMemories/extractMemories.ts:371-427`
- `claude-code-source-code/src/services/AgentSummary/agentSummary.ts:81-119`
- `claude-code-source-code/src/services/autoDream/autoDream.ts:224-249`

这些锚点共同说明：

- Claude Code 的主线程每回合结束后都会把 cache-safe 协作上下文保存下来，供侧问题、建议词、记忆提炼、总结与整理循环复用。

这一页现在不再把“共享前缀资产网络”当成 Prompt 的第二前门，而只解释：

- `Lineage -> Continuation`

## 1. 先说结论

更稳的 prompt 设计法，不是：

- 给每个旁路能力各写一段“差不多知道现场”的 prompt

而是：

1. 让主线程成为共享前缀的唯一生产者。
2. 让 `/btw`、suggestion、memory、summary、dream 尽量复用同一份 `CacheSafeParams`。
3. 让旁路循环只附加自己的窄差异，而不是重建整份世界模型。
4. 共享前缀不等于共享副作用，旁路循环应隔离自己的可变态。
5. 没有可信 snapshot 时宁可 suppress，或者承认 fallback 可能 miss cache，也不要假装“差不多一样”。

从第一性原理看，Claude Code 真正在保护的不是一段好文案，而是：

- 主线程作为 authoritative lineage source，被多个 continuation consumer 继续继承

这也是 prompt 魔力之所以能跨回合、跨循环持续显现的原因。

## 2. 第一步：把主线程看成 prefix producer，而不只是 query executor

`stopHooks.ts` 在回合结束后会把：

- `messages`
- `systemPrompt`
- `userContext`
- `systemContext`
- `toolUseContext`

一起装进 `createCacheSafeParams(...)`。

更关键的是注释里写得很明确：

1. 只有 `repl_main_thread` 和 `sdk` 主线程查询才会保存这份 snapshot。
2. subagent 不允许覆盖这份主线程前缀。
3. `/btw` 与 `side_question` 都直接依赖这份已保存参数。

这说明主线程的第二职责不是“顺手做点缓存”，而是：

- 稳定地产出后续所有旁路循环都能继承的 prefix asset

如果没有这一步，后面的 suggestion、summary、memory 只能各自：

- 重新组 system prompt
- 重新读 user/system context
- 重新承担 cache break 与世界模型漂移

再往下一层看，`forkedAgent.ts` 甚至直接把 `CacheSafeParams` 定义成共享父级 prompt cache 的正式参数 ABI，并把 cache key 组成写在类型注释里：

- system prompt
- tools
- model
- messages prefix
- thinking config

这说明 Claude Code 里的共享前缀不是一段“差不多相同”的 prompt 文本，而是一份：

- 明确知道哪些字节绝不能乱改的运行时结构件

## 3. 第二步：把侧问题当成共享前缀的岔路，而不是新会话

`/btw` 的注释几乎把设计哲学直接写出来了：

1. 首选 `getLastCacheSafeParams()`。
2. 复用它可以保证 byte-identical prefix，从而命中 prompt cache。
3. 只有在 stop hooks 尚未产生 snapshot 时，才退回从零重建。
4. 即使 fallback 可用，注释也明确承认它可能 miss cache，因为主线程还有额外组装步骤。

这说明 `/btw` 的本质不是：

- 再问一个临时问题

而是：

- 在主线程刚建立好的世界模型上，开一条共享前缀的旁路分叉

实践上：

1. 侧问题要复用同一份 `systemPrompt / userContext / systemContext`。
2. 新增的只是 fork context messages 与当前问题，不是重新声明整套运行时合同。
3. 如果你的 runtime 里侧问题每次都从零 build prompt，它大概率只是“记得一点聊天历史”，而不是“真的活在主线程同一世界里”。

## 4. 第三步：没有可信 snapshot 时，宁可 suppress，也不要自欺欺人地重建

这一点在 suggestion 路径上最明显。

`executePromptSuggestion(...)` 直接从 stop hook 上下文生成 `cacheSafeParams`；而 `print.ts` 的 SDK 路径在生成建议词前先取 `getLastCacheSafeParams()`，拿不到就记录 `sdk_no_params` 并 suppress。

这代表了一个很强的工程判断：

- 建议词不是必须随时都能吐出来

更重要的是：

- 它必须建立在可信的共享前缀上

这比“无论如何都要生成一句 suggestion”更成熟，因为盲目重建会带来三种坏事：

1. cache 命中率掉下去；
2. suggestion 与主线程世界模型轻微漂移；
3. 读起来像懂现场，实际却和主线程不共用同一份工作真相。

从第一性原理看，这里保护的是：

- 一致性优先于表面可用性

## 5. 第四步：共享前缀不等于共享副作用

这一点在 `sideQuestion.ts`、`SessionMemory.ts` 与 `forkedAgent.ts` 里非常清楚。

`runSideQuestion(...)` 明写：

1. 共享父级 prompt cache。
2. 不改 thinking override。
3. 禁工具。
4. 单回合。
5. `skipCacheWrite: true`，因为未来没有请求要共享这条 suffix。

`SessionMemory.ts` 也不是直接复用主线程可变态，而是先 `createSubagentContext(...)`，隔离文件状态，再把主线程的 `cacheSafeParams` 交给 fork，只共享前缀，不共享副作用写入面。

这说明 Claude Code 的设计不是：

- 只要共享前缀，就把整个运行时上下文都绑在一起

而是：

- 共享主干真相，隔离局部可变态

这也是为什么 `createSubagentContext(...)` 默认会克隆：

- `readFileState`
- `contentReplacementState`
- 一系列 mutation callback 或 tracking 集合

因为真正要共享的是：

- 主线程已经支付并稳定下来的前缀世界

而不是：

- 所有后续副作用都反写进同一份活状态

## 6. 第五步：让 memory、summary、dream 共享前缀，只附加自己的窄差异

`extractMemories.ts`、`autoDream.ts`、`AgentSummary.ts` 都把 `cacheSafeParams` 直接传进 `runForkedAgent(...)`。

但它们不是简单照搬主线程，而是只在最小范围内附加差异：

1. `extractMemories` 额外给 memory manifest、工具白名单、`skipTranscript` 与 `maxTurns`。
2. `autoDream` 在共享前缀上追加 consolidation prompt 与进度 watcher。
3. `AgentSummary` 只覆写 `forkContextMessages`，并故意用 deny-tools callback，而不是改工具配置。

`AgentSummary.ts` 那条注释尤其关键：

- 不要设置 `maxOutputTokens`，否则 thinking config mismatch 会打碎 cache

这说明 Claude Code 的辅助循环设计目标不是“局部最方便”，而是：

- 在共享前缀仍可信时，尽可能少改 cache key

真正被允许变化的，是每个循环自己的：

- 任务目标
- 输出窄约束
- 工具权限
- transcript 写入策略

而不该变化的，是主线程已经建立好的那份世界描述方式。

## 7. 第六步：把 prompt 系统设计成 prefix network，而不是 prompt collection

如果你要迁移这套方法，最值得复制的不是哪个 prompt 文案，而是这五条制度：

1. 主线程每回合结束后，保存可复用的 cache-safe snapshot。
2. 主线程是共享前缀的唯一写入者，旁路循环只能读取。
3. `CacheSafeParams` 这类共享前缀 ABI 要被正式建模，而不是散落在调用点里。
4. 旁路循环默认只附加窄差异，并隔离自己的副作用写入面。
5. 没有可信 snapshot 时，宁可 suppress 或承认 fallback 降级，不要伪装成等价重建。
6. cache 是否可继承，要被当成正式设计目标，而不是实现细节。

更抽象地说，Claude Code 里的 prompt 不是：

- 一组零散 prompt 文件

而是：

- 一条由主线程持续提供 lineage、由旁路循环共享消费 continuation 的 prefix contract

这就是为什么它的 prompt 魔力不只是“当前回合说得好”，而是“下一步建议、记忆提炼、总结整理都像活在同一个现场里”。

## 8. 苏格拉底式检查清单

在你准备再加一个旁路循环前，先问自己：

1. 这个循环复用的是主线程的可信前缀，还是它自己临时拼出来的半真相。
2. 这个能力真的需要改 cache key，还是只是想偷懒重建。
3. 我共享的是前缀真相，还是连副作用写入面也不加区分地绑死在一起。
4. 没有 snapshot 时，我是该 suppress，还是在用户不知情的情况下制造世界模型漂移。
5. 主线程是不是共享前缀的唯一生产者，还是任何后台循环都能反写主真相。
6. 我现在新增的是一个窄差异，还是又偷偷复制了一套 prompt runtime。

如果这些问题答不清，prompt 系统通常会从“共享资产网络”退化成“很多相似但不一致的小调用”。

## 9. 一句话总结

Claude Code 值得学的，不是几段更会写的 prompt，而是把主线程变成共享前缀生产者，让侧问题、建议词、记忆、总结与整理循环复用同一份 cache-safe 工作现场。
