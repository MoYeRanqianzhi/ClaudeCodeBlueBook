# Protocol真相控制面：为什么UI历史必须在API边界前被重新编译

这一章回答五个问题：

1. 为什么 Claude Code 不把前台 UI 历史原样送给模型。
2. 为什么 transcript normalization 不是小修小补，而是正式控制面。
3. 为什么 compact / session memory 之后仍要主动补回 API 不变量。
4. 为什么 stop hook 后保存的不是“聊天结果”，而是可复用的协议前缀资产。
5. 这对 agent runtime 设计者意味着什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/messages.ts:1989-2165`
- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:232-397`
- `claude-code-source-code/src/query/stopHooks.ts:84-120`

## 1. 先说结论

Claude Code 的 transcript 体系里，真正权威的不是：

- 人类在前台看到的原样历史

而是：

- 经过协议重写、边界补写和不变量修复后，仍能继续工作的 protocol 真相

也就是说，前台历史和模型输入之间存在一层正式控制面：

- transcript recompile layer

## 2. `normalizeMessagesForAPI()` 不是 helper，而是协议编译器

`normalizeMessagesForAPI(...)` 的第一步就已经说明它不是简单过滤器。

它会先：

1. 重排 attachments。
2. 剥掉 virtual messages。
3. 过滤 progress、普通 system message 与 synthetic API error。

这意味着系统首先承认：

- 前台显示对象和 API 消费对象不是同一种消息类型

如果没有这一步，REPL 内部工具调用、展示用状态消息、前台补偿消息都会污染模型输入。

所以这一步不是显示优化，而是：

- 把 UI truth 编译成 protocol truth

## 3. 协议重写的目标不是忠实重放，而是让下一轮还能继续

进入 `user` 分支之后，`messages.ts` 又连续做了几件更硬的事：

1. 不可用的 `tool_reference` 会被剥掉。
2. 图片、PDF、request-too-large 相关 block 会被回溯定位并移除，避免下一轮继续重发。
3. 某些 `tool_reference` 还会补 sibling text，防止 server 把错误位置采样成 stop sequence。

这里的设计取向很明确：

- transcript 的职责不是忠实重放前台，而是维护下一轮可继续执行的协议条件

这也解释了为什么 Claude Code 偏爱：

- 补新边界
- 删掉已知坏块
- 在 API 前做结构性修正

而不是执着于“历史一字不动”。

## 4. `local_command -> user message` 说明系统在主动统一模型可引用真相

`system` 分支里，local command 输出会被改写成 user message，并在必要时和上一条 user turn 合并。

这说明 Claude Code 并不接受“命令输出只是前台可见日志”这种模型。

它更在意的是：

- 哪些历史应该成为后续回合可引用的协作事实

也就是说，一旦某段前台动作需要被模型继续引用，它就会被翻译成：

- 协议层可消费的 user turn

这让 Claude Code 避免了另一类常见分裂：

- 人类以为系统已经看见命令结果
- 模型其实只看见了一个显示层事件

## 5. compact 后真正被保护的是协议不变量，不是历史完整感

`adjustIndexToPreserveAPIInvariants(...)` 与 `calculateMessagesToKeepIndex(...)` 明确写出了 compact 的真正保护对象：

1. kept range 中若有 `tool_result`，必须倒着补回对应 `tool_use`。
2. 若 kept range 中的 assistant message 与更早消息共享同一个 `message.id`，还要继续向前扩，以便 thinking block 能被正确合并。
3. preserved tail 还要以 compact boundary 为地板，避免越过磁盘不连续点把内部 preserved messages 剪断。

这说明 compact 的第一性原理不是：

- 摘要足够短

而是：

- 压缩之后协议链不能断

换句话说，Claude Code 在压缩历史时优先保护的是：

- tool_use / tool_result 配对
- thinking / assistant 的归属关系
- preserved segment 的连续性

## 6. stop hook 保存的是“协议前缀资产”，不是“回合纪要”

`stopHooks.ts` 在回合结束后会把：

- messages
- systemPrompt
- userContext
- systemContext
- toolUseContext

一起封进 `CacheSafeParams`，并保存给主线程或 SDK 路径使用。

这意味着 Claude Code 认为真正值得保留下来的，不只是：

- 回答了什么

更是：

- 下一条旁路问题、下一次 suggestion、下一次 memory 抽取仍可复用的前缀资产

这也是为什么 side question、prompt suggestion、session memory 这些旁路能力能共享主线程成果，而不是各自重新拼装一份上下文。

## 7. 为什么这是一块正式控制面，而不是 prompt 附属层

如果把 transcript normalization 看成 prompt 附属实现，就会低估它。

更准确的理解应该是：

1. 前台层负责用户可见真相。
2. 协议重写层负责模型可执行真相。
3. compact / memory 层负责压缩后不变量仍成立。
4. stop hook 层负责把这条协议真相保存成可复用资产。

这四步共同构成了：

- protocol truth control plane

它不是“某个函数做得细”，而是 Claude Code 整个 runtime 为了保证长任务可继续而设下的中枢结构。

## 8. 一句话总结

Claude Code 不把 UI 历史直接交给模型，而是先把它重新编译成 protocol 真相，再围绕这条真相去做 compact、memory 和旁路复用，这就是它长任务仍能持续工作的关键底盘之一。
