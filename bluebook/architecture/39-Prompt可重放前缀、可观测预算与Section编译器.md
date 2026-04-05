# Prompt可重放前缀、可观测预算与Section编译器

这一章回答五个问题：

1. 为什么 Claude Code 的 prompt 不该被理解成一次性请求文本。
2. `CacheSafeParams`、stop hooks 与 post-turn forks 说明了什么。
3. 为什么 `get_context_usage` 让 prompt 结构变成了可观测预算对象。
4. memory / memdir / section cache 为什么意味着 prompt 在被“编译”。
5. 为什么“模型可见真相”和“用户可见真相”必须继续分层。

## 0. 代表性源码锚点

- `claude-code-source-code/src/query/stopHooks.ts:84-99`
- `claude-code-source-code/src/commands/btw/btw.tsx:183-227`
- `claude-code-source-code/src/utils/forkedAgent.ts:70-141`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:220-305`
- `claude-code-source-code/src/components/ContextVisualization.tsx:110-149`
- `claude-code-source-code/src/memdir/memdir.ts:121-128`
- `claude-code-source-code/src/memdir/memdir.ts:187-205`
- `claude-code-source-code/src/bootstrap/state.ts:1641-1653`
- `claude-code-source-code/src/utils/toolPool.ts:43-79`
- `claude-code-source-code/src/components/messages/nullRenderingAttachments.ts:4-69`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:332-427`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:432-460`

## 1. 先说结论

Claude Code 的 prompt 还可以再往下一层概括成四个词：

1. 可重放
2. 可观测
3. 可编译
4. 可分层

这四点合在一起，才更接近它的真实魔力来源。

也就是说，Claude Code 的 prompt 不是：

- 一段越写越长的请求文本

而是：

- 一组能被复用、诊断、编译和分层消费的 runtime contract

## 2. Prompt 首先是可重放前缀，不是单次请求

`stopHooks.ts` 在每轮结束后，会把主线程本轮真正发给模型的安全前缀保存成 `CacheSafeParams`。

这里保存的不是模糊的“上下文感觉”，而是会影响 cache 的关键字段：

- `systemPrompt`
- `userContext`
- `systemContext`
- `toolUseContext`
- 当前轮消息边界

更关键的是，这个快照不是只给主线程自己用。

`/btw` 明确优先复用 `getLastCacheSafeParams()`，以保证 side question fork 拿到与主线程字节级一致的前缀；`forkedAgent.ts` 也把 `CacheSafeParams` 定义成正式结构，并直接说明它的价值是 prompt cache sharing。

这意味着 Claude Code 真正在做的是：

- 把 prompt 当作可重放前缀，而不是每次临时重建的新文本

所以 prompt 魔力的一部分，根本不在“当前这一轮写得好不好”，而在：

- 下一条辅助查询、下一次 post-turn fork、下一次 side question 能否复用同一前缀

## 3. Prompt 还是可观测预算对象，不是黑箱

`get_context_usage` 暴露的远不只是 token 总数。

它还显式给出：

- `systemPromptSections`
- `systemTools`
- `deferredBuiltinTools`
- `mcpTools`
- `skills`
- `slashCommands`
- `messageBreakdown`
- `attachmentsByType`

`ContextVisualization.tsx` 进一步说明这些字段不是摆设，而是前台实际会消费的可视化结构。

这点非常关键，因为它意味着 Claude Code 的 prompt 哲学不是：

- 相信一段神秘提示词会一直有效

而是：

- 把 prompt 结构本身做成可诊断、可度量、可解释的预算对象

这就把所谓“prompt 魔力”从玄学拉回了工程：

1. 你能看到系统提示词各 section 花了多少 token。
2. 你能看到工具、技能、附件分别占了多少预算。
3. 你能看到哪些部分因为 deferred 策略被外移了。

所以 Claude Code 的 prompt 更强，不只是因为它写得更好，而是因为：

- 它连自己为什么会失效、会膨胀、会打爆预算都能被观测

## 4. Prompt 还是 section 级编译产物，不是手写长文

`memdir.ts` 里有一句特别重要的注释：

- memory 目录初始化会从 `loadMemoryPrompt` 调用，而后者是 once per session via systemPromptSection cache

再看 `buildMemoryLines(...)` 和 `bootstrap/state.ts` 里的 `systemPromptSectionCache`，就能看清作者的工程选择：

1. 先把某个系统 section 编译成稳定片段。
2. 再把它缓存到 section 级 cache 里。
3. 需要时按 section 注入，而不是每轮重建整段系统提示词。

这意味着 Claude Code 在做的不是：

- 每次从零写一段新的 memory prompt

而是：

- 把 prompt 拆成若干可缓存、可复用、可独立失效的 section

如果说“五层合同”解释了 prompt 的层次，那么这里解释的是：

- 这些层并不是纯文本，而是可以像编译产物一样被缓存和复用

## 5. Tool ABI 稳定性也是 prompt substrate

很多系统会把工具池当作 prompt 之外的小问题。

Claude Code 不是。

`toolPool.ts` 的 `mergeAndFilterTools(...)` 明确强调：

- built-ins 必须保持成连续前缀
- MCP tools 必须分区排序
- headless 与 REPL 应共享同一过滤逻辑

换句话说，工具 ABI 不是“模型看到的一份清单”而已，它还是：

- prompt cache 是否稳定的一部分底层基材

只要工具顺序、过滤逻辑或角色子集分叉，prompt cache 和角色语义都会一起失真。

所以 prompt 的真正稳定性，至少由两类东西共同构成：

1. 系统提示词和附件 section 的稳定性
2. 当前可见工具 ABI 的稳定性

## 6. 模型可见真相与用户可见真相必须分层

`nullRenderingAttachments.ts` 明确列出一大批 attachment 会进入 runtime 语义，却不会进入前台渲染。

比如：

- `command_permissions`
- `team_context`
- `deferred_tools_delta`
- `mcp_instructions_delta`
- `date_change`
- `current_session_memory`

这说明 Claude Code 做得特别清楚的一件事是：

- 模型应该看到的东西，不等于用户应该看到的东西

这不是 UI 细节，而是 prompt 设计哲学本身。

如果系统不做这层分离，就会出现两类坏事：

1. 应该给模型的 runtime 信号没法被低噪音注入。
2. 不该给用户看的协议性结构污染前台真相和 render budget。

所以 Claude Code 的 prompt 更强，恰恰因为它并没有把“多喂一点上下文”等同于“都显示给用户”。

## 7. cache break 检测已经升级为 prompt 失真解释器

`promptCacheBreakDetection.ts` 不只记录“缓存断了”。

它还显式解释：

- system prompt 是否变化
- tools hash 是否变化
- model / fast mode / betas 是否变化
- cache control / global cache strategy 是否变化
- effort / extra body params 是否变化
- 哪些工具被新增、删除或 schema 改写

这意味着 Claude Code 的 prompt 哲学不是：

- 追求一种不可解释的神秘稳定

而是：

- 让不稳定也变得可解释

这是一种更成熟的工程姿态：

- 魔力不是不能拆解，而是被拆解后依然成立

## 8. 苏格拉底式追问

### 8.1 如果 prompt 只是文本，为什么还要保存 `CacheSafeParams`

因为 Claude Code 真正在意的不是“文本像不像”，而是：

- 下一次请求能不能共享同一前缀

### 8.2 如果 prompt 已经很强，为什么还要把它做成可观测预算

因为不可观测的 prompt 只能被崇拜，不能被治理。

而 Claude Code 显然想要的是：

- 能调、能量、能解释的 prompt

### 8.3 如果 memory 已经能注入，为什么还要 section cache

因为稳定 section 与高波动 section 不该共享同一失效边界。

### 8.4 为什么 attachment 要故意有一批“不渲染”

因为系统必须继续区分：

- 模型需要的真相
- 用户需要的真相

两者一旦混写，prompt 与前台都会一起失真。

## 9. 一句话总结

Claude Code 的 prompt 魔力，不只是五层合同，而是把 prompt 做成了可重放前缀、可观测预算、section 级编译产物，并严格区分模型真相与用户真相。
