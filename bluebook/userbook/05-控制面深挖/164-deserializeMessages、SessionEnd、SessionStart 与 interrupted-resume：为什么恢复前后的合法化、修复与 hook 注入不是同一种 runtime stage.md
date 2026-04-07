# `deserializeMessagesWithInterruptDetection`、`executeSessionEndHooks`、`processSessionStartHooks` 与 `interrupted-resume`：为什么恢复前后的 transcript 合法化、interrupt 修复与 hook 注入不是同一种 runtime stage

## 用户目标

163 已经把 `print.ts` 里的：

- 标识符解析
- remote hydrate
- formal restore
- empty-session fallback
- message-level rewind

拆成了五段不同前置阶段。

但如果正文停在这里，读者还是很容易把恢复边界附近真正发生的运行时动作压成一句：

- “resume 的时候顺手把 transcript 修一下、hooks 跑一下而已。”

这句还不稳。

从当前源码看，至少还有三种不同 runtime stage：

1. transcript 合法化
2. interrupt 修复
3. hook 边界注入

它们都围着恢复边界发生，但不是同一种动作。

## 第一性原理

比起直接问：

- “恢复前后到底发生了哪些系统动作？”

更稳的问法是先拆五个更底层的问题：

1. 当前动作是在修旧 transcript 的结构合法性，还是在把“中断状态”改写成可继续的会话形状？
2. 当前动作是在旧 transcript 内部变形，还是在恢复边界额外注入新的 hook 产物？
3. 当前动作依赖的是旧 transcript 内容本身，还是依赖当前 runtime 的当前 session / target session？
4. 当前动作是 restore 前就要完成，还是在 restore 边界前后按不同宿主顺序发生？
5. 如果三者的输入、输出和 consumer 完全不同，为什么还要把它们写成“同一种恢复步骤”？

这五问不先拆开，resume runtime 很容易被误写成：

- “旧消息清洗 + hooks” 的一个笼统阶段

而当前源码更接近：

- legalize transcript
- repair interruption
- cross hook boundary

## 第一层：`deserializeMessagesWithInterruptDetection()` 里的前半段只做 transcript 合法化

`conversationRecovery.ts` 里 `deserializeMessagesWithInterruptDetection()` 的前半段主语非常明确：

- legacy attachment migration
- invalid `permissionMode` strip
- unresolved tool uses filter
- orphaned thinking filter
- whitespace-only assistant filter

这些动作回答的问题是：

- “这条 transcript 现在还能不能成为 API-valid、runtime-safe 的消息链”

它们不回答：

- “这条会话是不是中断了”
- “要不要补一条 continuation prompt”
- “resume 边界要不要跑 hooks”

所以这层应被写成：

- transcript legalization stage

不是：

- interrupt repair

更不是：

- hook injection

## 第二层：interrupt 修复是在合法化之后，主语已经变成“如何让中断会话可继续”

同一个函数的后半段又跨过了另一条边界。

这里系统会：

- `detectTurnInterruption(filteredMessages)`
- 对 `interrupted_turn` 追加 synthetic meta user message
  `Continue from where you left off.`
- 把中断态统一成 `interrupted_prompt`
- 再在最后一个 user 消息后插入 synthetic assistant sentinel

这层回答的问题不再是：

- “这条 transcript 合不合法”

而是：

- “这条会话如果中断了，应该被 runtime 看成什么继续形状”

所以 interrupt 修复的主语是：

- interruption normalization / repair stage

它依赖合法化之后的消息链，

但它本身不是合法化。

## 第三层：assistant sentinel 不是清洗动作，而是为后续 consumer 预留的 runtime splice 点

很多读者会把 assistant sentinel 也写进“清洗”。

这也不稳。

源码注释写得很直接：

- sentinel 是为了让 conversation 在“不做 resume 行动”时仍是 API-valid
- 同时又保证后续 consumer 可以用 `splice(idx, 2)` 正确移除成对的 interrupted user + assistant sentinel

这意味着 sentinel 的职责不是：

- 删除脏数据

而是：

- 为后续 runtime consumer 预留一个可逆的 repair 结构

尤其在 `print.ts` 里，后续的：

- `removeInterruptedMessage(...)`
- `enqueue({ mode: "prompt", value: ... })`

正是建立在这层 repair 结构之上。

所以 sentinel 更像：

- repair artifact

而不是：

- sanitation artifact

## 第四层：interactive REPL 的 hook 边界是 “旧会话 SessionEnd -> 新会话 SessionStart”

`REPL.resume()` 在真正 `switchSession(...)` 前，还会先做：

- `executeSessionEndHooks("resume", ...)`

然后再对 target session 做：

- `processSessionStartHooks("resume", { sessionId, agentType, model })`

并把返回的 hook messages 追加进恢复后的消息链。

这层回答的问题是：

- “当前 live REPL 怎么从旧会话安全越过边界，再把新会话启动上下文接上去”

所以这里的 hook 主语是：

- runtime boundary crossing

不是：

- transcript legalization

也不是：

- interruption repair

它甚至依赖一个 interactive 特有前提：

- 当前已经有一个活着的旧会话要先收尾

## 第五层：`print.ts` 没有前置 SessionEnd，但它会在 repair 之后延迟消费 interrupted prompt

headless `print.ts` 这边的顺序又不一样。

这里没有一个 live REPL 要先 `SessionEnd`，

所以没有 interactive 路径那条：

- 旧会话 end -> 新会话 start

但它仍会经历：

- `loadConversationForResume()` 内部的 deserialization + repair
- `processSessionStartHooks('resume')`
- `takeInitialUserMessage()` 单独 prepend 到 `StructuredIO`

然后更后面，如果环境变量允许自动恢复中断 turn，

它还会：

- `removeInterruptedMessage(mutableMessages, turnInterruptionState.message)`
- 把 repaired interrupted prompt 重新 `enqueue(...)`

也就是说在 headless 路径里：

- hook 注入
- interrupted prompt 重投

是两个不同阶段，

而且二者都在 repair 之后。

所以 `print` 路径最容易被误写成：

- “repair 完就直接继续跑”

实际上中间还隔着：

- SessionStart hook 注入
- initialUserMessage prepend
- optional interrupted prompt requeue

## 第六层：`SessionStart` hooks 自身也不是普通 transcript replay

`sessionStart.ts` 和 `types/hooks.ts` 进一步说明，SessionStart hook 的产物本来就不是单一种类：

- `message`
- `additionalContext`
- `initialUserMessage`
- `watchPaths`

`processSessionStartHooks()` 会把它们分别处理成：

- hook messages
- 一个聚合的 `hook_additional_context` attachment
- module-level side channel `pendingInitialUserMessage`
- watch path 更新

这说明 hook 注入这层本身就是：

- runtime-generated side effects bundle

不是：

- 从旧 transcript 原样 replay 出来的内容

所以把它写成“恢复时附带几条 message”同样不稳。

## 第七层：因此恢复边界附近至少要拆成“三段式”

把前面几层合起来，更稳的三段写法应该是：

1. transcript legalization
   把旧 transcript 修成 API-valid、runtime-safe
2. interruption repair
   把“中断”改造成一个可继续、可逆移除的会话形状
3. hook boundary injection
   在 resume 边界前后按宿主规则注入 SessionEnd / SessionStart 相关运行时产物

interactive 和 print 的差别不在于这三层有没有，

而在于：

- interactive 有前置 SessionEnd
- print 没有前置 SessionEnd，但可能晚一点 requeue interrupted prompt

所以更准确的结论不是：

- 恢复前后就是“修 transcript + 跑 hooks”

而是：

- 合法化、修复、边界注入是三种不同 runtime stage

## 苏格拉底式自审

### 问：为什么这页不是 160 的附录？

答：因为 160 讲的是 payload taxonomy。

164 讲的是 runtime staging order。

### 问：为什么这页不是 163 的附录？

答：因为 163 讲的是 print host 内部的 pre-restore chain；
164 讲的是恢复边界附近发生的 shared runtime stages。

### 问：为什么一定要把 assistant sentinel 单独点出来？

答：因为它最容易被误写成“清洗残留物”，但它其实是为后续 requeue / splice 准备的 repair artifact。

### 问：为什么一定要写 `takeInitialUserMessage()`？

答：因为它能证明 headless 路径里的 SessionStart 产物并不会自动等于 transcript replay，它们会进入不同 consumer。

## 边界收束

这页只回答：

- 为什么恢复前后的 transcript 合法化、interrupt 修复与 hook 注入不是同一种 runtime stage

它不重复：

- 160 的 payload taxonomy
- 161 的 interactive entry hosts
- 162 的 host family split
- 163 的 print pre-stage taxonomy

更稳的连续写法应该是：

- restore 包里不止一种 payload
- resume 宿主不止一种 family
- print 前置链不止一种 pre-stage
- 恢复边界附近也不止一种 runtime stage
