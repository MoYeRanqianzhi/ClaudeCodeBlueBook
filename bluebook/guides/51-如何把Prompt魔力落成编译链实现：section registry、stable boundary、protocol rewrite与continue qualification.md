# 如何把Prompt魔力落成编译链实现：section registry、stable boundary、protocol rewrite与continue qualification

这一章不再解释 Prompt 为什么有魔力，而是把 Claude Code 式 Prompt 编译链压成一张可实现的 builder-facing 手册。

它主要回答五个问题：

1. 为什么真正强的 Prompt 不是文案，而是一条可缓存、可转写、可继续的编译链。
2. 怎样把 section registry、stable boundary、tool ABI、protocol rewrite 与 lawful forgetting 写成同一条实现顺序。
3. 为什么 side loop、compact、resume、handoff 与 continue qualification 不能各自长出半真相世界。
4. 怎样用苏格拉底式追问避免把 Prompt 实现重新退回字符串工程。
5. 怎样把 Claude Code 的 Prompt 魔力迁移到自己的 Agent Runtime，而不误抄某段 system prompt 文案。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:343-347`
- `claude-code-source-code/src/constants/prompts.ts:560-576`
- `claude-code-source-code/src/utils/api.ts:119-150`
- `claude-code-source-code/src/utils/api.ts:321-405`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5460`
- `claude-code-source-code/src/services/compact/prompt.ts:61-143`
- `claude-code-source-code/src/services/compact/compact.ts:330-366`
- `claude-code-source-code/src/services/compact/compact.ts:596-711`
- `claude-code-source-code/src/query/stopHooks.ts:175-331`
- `claude-code-source-code/src/query.ts:1065-1340`

这些锚点共同说明：

- Claude Code 的 Prompt 魔力，不在“更会写”，而在“更会把世界编译成可缓存、可转写、可继续的请求对象”。

## 1. 第一性原理

更成熟的 Prompt 实现，不是：

- 先写一段更长的 system prompt

而是：

1. 先决定哪些 section 属于稳定法典。
2. 先决定哪些动态变化必须被赶到 stable boundary 之后。
3. 先决定哪些 tool schema 与 header 属于请求 ABI。
4. 先决定模型消费的是哪一版 protocol transcript。
5. 先决定删掉什么以后系统仍然能合法继续。

所以 Prompt 的真实实现单位不是：

- 字符串

而是：

- 编译链

## 2. 第一步：先固定 section registry 与 stable boundary

Claude Code 真正先固定的不是措辞，而是 Prompt 资产的组织法：

1. 哪些 section 可以 memoize。
2. 哪些 section 必须显式 cache break。
3. 哪些 session-variant guidance 必须放到 `SYSTEM_PROMPT_DYNAMIC_BOUNDARY` 之后。

构建动作：

1. 先把 Prompt section 写成 registry，而不是拼接脚本。
2. 先给每个 section 标清 stable / dynamic / uncached 身份。
3. 先把高波动信息从 stable prefix 里赶出去。

不要做的事：

1. 不要把 late delta 混进 stable prefix。
2. 不要让多个入口同时改写 section 主权。
3. 不要把 `/clear`、`/compact`、resume 等重置点写成隐式副作用。

## 3. 第二步：只允许一个 compiled request truth 生产者

Claude Code 真正复用的不是聊天历史，而是主线程留下的 cache-safe 请求对象。

这意味着：

1. 主线程负责生产 stable prefix。
2. side question / fork / compact / resume 优先继承它。
3. tool schema、beta headers、extra body params 也属于同一个请求对象。

构建动作：

1. 先定义唯一 compiled request truth producer。
2. 先把 tool schema 当作 Prompt ABI，而不是外围细节。
3. 先定义谁可以补边，谁只能继承。

不要做的事：

1. 不要让 side path 自己再拼一份“差不多的世界”。
2. 不要把 tool description 漂移当成非 Prompt 问题。
3. 不要把 shared prefix 理解成“复用上一轮摘要”。

## 4. 第三步：把 transcript 编译成 protocol truth

Claude Code 保护的从来不是 UI 原样历史，而是模型真正消费的合法协议面。

更稳的顺序是：

1. 先做 `normalizeMessagesForAPI()`。
2. 再做 `ensureToolResultPairing()`。
3. 再决定哪些 display-only / invalid / orphan 内容必须被剥离或拒收。
4. 最后才考虑显示层怎样保留可读性。

构建动作：

1. 先写 protocol transcript law。
2. 先定义 tool_use / tool_result pairing 不变量。
3. 先把 UI transcript 与 API transcript 分层。

不要做的事：

1. 不要把前台历史直接送给模型。
2. 不要把 tool pairing 问题当成容错补丁。
3. 不要让 compact 之后的 transcript 继续携带非法配对。

## 5. 第四步：把 lawful forgetting 写成 continuation object

Claude Code 的 compact 真正保护的不是：

- 更短的总结

而是：

1. 当前对象还是什么。
2. 当前下一步是什么。
3. 哪些 boundary 与 attachment 仍必须被保留。
4. compact 之后还要重放哪些 delta 才能恢复继续条件。

构建动作：

1. 先定义 compact 后必须存活的 continuation object。
2. 先定义 `preservedSegment`、attachments、hookResults、metadata 的 relink 顺序。
3. 先定义 post-compact re-announce 机制。

不要做的事：

1. 不要把 lawful forgetting 写成摘要风格优化。
2. 不要让 compact 删除 next step、rollback boundary 或 handoff guard。
3. 不要把“还能继续”理解成“还有一段摘要可读”。

## 6. 第五步：把 continue qualification 写成正式仲裁

很多系统把 continue 理解成 stop reason 的附庸。

Claude Code 更接近的真相是：

1. stop hooks 会仲裁是否允许继续。
2. prompt-too-long 有自己的恢复路径。
3. max-output、budget continuation 与 reactive compact 也有各自资格条件。
4. side path 是否还能共享前缀，同样会影响继续资格。

构建动作：

1. 先定义 continue qualification state machine。
2. 先定义 stop hooks 可以阻断哪些继续。
3. 先定义哪些错误是 recoverable，哪些必须终止。

不要做的事：

1. 不要把 continue 写成“再发一轮相同请求”。
2. 不要把 stop hooks 当纯观测插件。
3. 不要在 cache break 或 protocol drift 未解释前默认继续。

## 7. 六步最小实现顺序

如果要把上面的原则压成一张实现卡，顺序可以固定成：

1. `section registry`
   - 谁能定义 Prompt section，哪些 section 稳定
2. `stable boundary`
   - 哪些变化必须被赶到 stable prefix 之后
3. `compiled request ABI`
   - tool schema、headers、body params 如何进入请求对象
4. `protocol rewrite`
   - UI history 怎样转成 API truth
5. `lawful forgetting object`
   - compact 后怎样仍保住继续条件
6. `continue qualification`
   - 哪些路径配继续，哪些路径应拒收

## 8. 苏格拉底式检查清单

在你准备继续优化 Prompt 之前，先问自己：

1. 我固定的是 section law，还是只固定了措辞。
2. 当前是否只有一个 compiled request truth producer。
3. 模型消费的是 protocol truth，还是 UI transcript 替身。
4. compact 后留下的是 continuation object，还是一段更短的故事。
5. 我是否知道当前这轮为什么还能继续。

## 9. 一句话总结

真正有魔力的 Prompt，实现上不是更会写，而是把 section registry、stable boundary、protocol rewrite、lawful forgetting 与 continue qualification 编译成同一条请求真相生产链。
