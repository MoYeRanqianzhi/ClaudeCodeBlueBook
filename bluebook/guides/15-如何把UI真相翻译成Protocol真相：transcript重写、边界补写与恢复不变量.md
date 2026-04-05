# 如何把UI真相翻译成Protocol真相：transcript重写、边界补写与恢复不变量

这一章回答五个问题：

1. 为什么 Claude Code 里的 UI transcript 不能直接等同于模型真正消费的 protocol transcript。
2. 怎样理解 virtual message、system/progress message、tool_reference、synthetic error 在 API 边界前会被怎样改写。
3. 为什么纠偏时应补新边界，而不是重讲整段历史。
4. 为什么 compact / session memory 之后仍要主动补回协议不变量。
5. 怎样用苏格拉底式追问避免把“显示层真相”误当“执行层真相”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/messages.ts:1989-2165`
- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:232-397`
- `claude-code-source-code/src/query/stopHooks.ts:84-120`

这些锚点共同说明：

- Claude Code 不会把前台原样历史直接喂给模型，而是会在 API 边界前主动重写 transcript，并在压缩后补回可继续推理所需的不变量。

## 1. 先说结论

更稳的 transcript 使用法，不是：

- 看到什么就默认模型也看到了什么

而是：

1. 先区分 UI 真相和 protocol 真相。
2. 再只补当前回合真正缺失的边界。
3. 再确保压缩与恢复后协议不变量仍然站得住。

所以真正要维护的，不只是聊天可读性，而是：

- 可继续工作的协议真相

## 2. 第一步：先接受 UI transcript 和 protocol transcript 不是同一物

`normalizeMessagesForAPI(...)` 在进入 API 之前会先做几类处理：

1. 先重排 attachment。
2. 剥掉 virtual message。
3. 过滤 progress、普通 system message、synthetic API error。
4. 把 `local_command` system message 改写成 user message。
5. 合并连续 user message。

这说明前台看到的历史和模型真正消费的历史之间，本来就隔着一层：

- 协议编译

实践上：

1. 不要把“界面上刚出现的每一条消息”都当成模型下一轮的直接输入。
2. 不要把 transcript search 的结果机械理解成协议顺序。
3. 当你在调 prompt 时，先问自己现在调的是前台显示，还是 API 前的协议真相。

## 3. 第二步：遇到问题时补新边界，不要重讲整段历史

`messages.ts` 里还有几类更细的协议修正：

1. 工具不可用时，会剥掉失效的 `tool_reference`。
2. 图片、PDF 太大时，会反向定位前一条 meta user message 并去掉对应 block，防止下一轮继续重发。
3. 某些 `tool_reference` 还会在 API 准备阶段补 sibling text，以避免 server 采样到错误的 stop sequence。

这说明 protocol transcript 的目标不是忠实重放，而是：

- 让下一轮仍然能安全继续

实践上：

1. 模型走偏时，先补一句“只改 X / 不要动 Y / 先给计划再执行”。
2. 不要默认“把刚才所有上下文重讲一遍”就是最稳的纠偏法。
3. 当前真正缺失的，通常是一个新的边界，而不是一份更长的历史复述。

## 4. 第三步：compact 后保留的不是原文，而是协议可继续性

`adjustIndexToPreserveAPIInvariants(...)` 和 `calculateMessagesToKeepIndex(...)` 做了两件很关键的事：

1. 如果 kept range 里出现 `tool_result`，就倒着把匹配的 `tool_use` 一起补回来。
2. 如果 assistant message 共享同一个 `message.id`，就继续向前扩，确保 thinking block 仍能被后续合并。

也就是说，compact 时真正不能断开的，不只是文本上下文，而是：

- tool_use/tool_result 配对
- thinking / assistant message 的协议归属

实践上：

1. 长任务切分后，不要只看“摘要够不够短”，还要看“执行链是不是仍完整”。
2. 如果你在做自己的 runtime，compact 最先保护的应该是协议不变量，而不是摘要字数。
3. “保留最近几条消息”不是目的，保留可继续执行的协议链才是目的。

## 5. 第四步：把 stop hook 后的上下文当成正式资产

`stopHooks.ts` 会在主线程回合结束后，把：

- messages
- systemPrompt
- userContext
- systemContext
- toolUseContext

一起封进 cache-safe params 保存下来。

这说明 Claude Code 真正保存的不是一段“聊天结果”，而是：

- 下一条旁路问题、下一次 suggestion、下一次 memory 更新仍可复用的协议前缀资产

实践上：

1. 如果你在设计自己的 side question / btw / prompt suggestion，不要只存字符串，要存协作上下文。
2. 如果你在纠偏时只盯当前输入框，而不看 stop hook 后留下来的上下文资产，就会低估 Claude Code 的连续性设计。
3. 让不同旁路能力共享同一前缀，比让每个能力各自重组上下文更稳。

## 6. 第五步：把 preserved tail 当成“接手链”，不是“剩余文本”

`sessionMemoryCompact.ts` 在满足最小 token / text-block message 的同时，还会：

1. 以 compact boundary 为地板向前扩。
2. 在命中上限或下限后再调整 tool / thinking 不变量。

这说明 preserved tail 的职责不是“尽量多留一些最近消息”，而是：

- 给压缩后的世界保留一条仍能继续接手的协议链

实践上：

1. 长任务压缩后，不要只验证摘要可读，还要验证新的 kept range 是否还能承接下一轮工具调用。
2. 如果你在设计 memory + compact 机制，先定义“什么叫继续工作不坏”，再定义“什么叫摘要够短”。
3. preserved tail 应优先服务接手连续性，而不是服务历史完整感。

## 7. 苏格拉底式检查清单

在你准备继续补 prompt 或继续压缩历史前，先问自己：

1. 我现在看到的是 UI 真相，还是 protocol 真相。
2. 我现在要补的是更多原文，还是一个新的边界。
3. 这段 compact / summary 会不会切断 tool_use/tool_result 或 thinking 不变量。
4. 我保存下来的，到底是聊天文本，还是下一轮可复用的协作前缀。
5. 我现在要维护的是历史完整感，还是可继续工作的协议链。

如果这五问没答清，长会话通常会越写越乱，而不是越写越稳。

## 8. 一句话总结

Claude Code 里真正重要的 transcript，不是前台看到的原样历史，而是那条经过重写、补边界、保不变量之后，仍能继续行动的 protocol transcript。
