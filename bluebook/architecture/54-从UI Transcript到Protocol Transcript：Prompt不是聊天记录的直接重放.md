# 从UI Transcript到Protocol Transcript：Prompt不是聊天记录的直接重放

这一章回答五个问题：

1. 为什么 Claude Code 不把 UI transcript 直接喂给模型，而要在发请求前重新编译消息。
2. 为什么 `normalizeMessagesForAPI()` 更像 protocol compiler，而不是普通消息工具函数。
3. 为什么 attachment、tool_reference、tool_result、virtual message 都要在 API 边界前被重新整理。
4. 为什么“模型看到的世界”必须比“界面展示的世界”更严格。
5. 这条链为什么是 prompt 魔力与稳定性的底层组成部分。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/messages.ts:460-482`
- `claude-code-source-code/src/utils/messages.ts:1760-1858`
- `claude-code-source-code/src/utils/messages.ts:1989-2045`
- `claude-code-source-code/src/utils/messages.ts:2130-2195`
- `claude-code-source-code/src/utils/messages.ts:2440-2485`
- `claude-code-source-code/src/utils/messages.ts:4178-4216`
- `claude-code-source-code/src/utils/messages.ts:5200-5225`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts:77-77`
- `claude-code-source-code/src/utils/sessionStorage.ts:4384-4384`
- `claude-code-source-code/src/utils/toolSearch.ts:540-560`
- `claude-code-source-code/src/services/api/claude.ts:1145-1175`
- `claude-code-source-code/src/services/compact/compact.ts:603-603`

## 1. 先说结论

Claude Code 有一个很深的设计选择：

- 界面上的 transcript 不等于模型侧协议 transcript

也就是说，它不相信：

- “用户界面看到了什么，就直接把这堆消息原样发给模型”

相反，它在 API 边界前再做一轮正式编译：

- attachment 重排
- virtual message 剥离
- tool_result hoist
- tool_reference turn boundary 插入
- orphan / duplicate tool_use 清理
- adjacent user message 合并

所以更准确的说法不是：

- Claude Code 记录了一串聊天记录，然后把它交给模型

而是：

- Claude Code 把 UI transcript 编译成 protocol transcript，再把后者交给模型

## 2. `normalizeMessagesForAPI()` 是协议编译器，不是普通工具函数

`normalizeMessagesForAPI()` 之所以重要，不在于它处理的 case 多，而在于：

- 所有准备进入 API 的消息，都必须在这条边界上变成“协议合法形态”

它首先做的就不是渲染，而是协议层的再组织：

1. 先 `reorderAttachmentsForAPI(...)`
2. 再剥离 virtual messages
3. 再做 targeted strip
4. 再注入或搬移 tool_reference turn boundary
5. 再 merge 相邻 user messages
6. 再 hoist `tool_result` 到 user content 前缀

这说明 Claude Code 并不把 transcript 理解成：

- 原始历史

而是：

- 一种需要满足 API 契约的中间表示

## 3. 为什么 attachment-origin 内容必须被系统提醒包装

`ensureSystemReminderWrap(...)` 与 `smooshSystemReminderSiblings(...)` 透露出一个很关键的思想：

- attachment-origin 的内容要以可识别、可后处理的协议形态进入模型

这里不是为了 UI 好看，而是为了让后续 pass 可以稳定识别：

- 哪些 text 实际上是 system-reminder 风格的补充上下文
- 哪些 text 是真实用户输入

而一旦这些 text 被识别出来，Claude Code 又会进一步：

- 把它们尽量 smoosh 进同一 user message 的最后一个 `tool_result`

这说明 runtime 在主动减少：

- 会污染人类/模型轮次边界的孤立 sibling text

## 4. 为什么 `tool_reference` 不只是工具发现功能，而是 transcript 协议问题

`contentHasToolReference(...)` 和后续的 `TOOL_REFERENCE_TURN_BOUNDARY` 注入，说明 Claude Code 已经把一个经验写进协议层：

- server-side 的 tool_reference 展开如果直接落在 prompt tail，某些模型会把它误采样成 stop sequence

所以 Claude Code 选择：

- 在 API-prep 边界注入一个明确的 text sibling 作为 turn boundary

而不是把这个修复交给：

- UI 层
- tool search 调用点
- 模型自己领会

这再次说明 `messages.ts` 负责的是：

- 模型侧协议合法化

不是消息美化。

## 5. 为什么 `tool_result` 必须被 hoist 到前面

`hoistToolResults(...)` 这类处理非常能说明 Claude Code 的协议意识。

源码直接写出原因：

- `tool_result` blocks must come first
- 否则会触发 “tool result must follow tool use” API errors

这意味着 UI transcript 的自然排列顺序，未必就是 API 的合法顺序。

所以 Claude Code 宁可在边界前重排，也不把：

- 用户界面里的自然书写顺序

误当成：

- 模型侧协议顺序

这种做法看起来“多此一举”，但其实是在保护一个更高层的不变量：

- 协议 transcript 必须始终合法

## 6. 为什么相邻 user messages 要被合并，虚拟消息要被剥离

`mergeAdjacentUserMessages(...)` 与 virtual message strip 其实说明了同一件事：

- UI 层允许更多展示/交互语义
- 模型侧协议层则要求更紧、更规整、更少歧义的表示

例如：

- REPL 里的 inner tool calls 可以是 display-only
- 但模型请求不能被这些 UI-only artifacts 污染

所以 Claude Code 的做法不是：

- 让 UI 与协议共用一份原始消息对象

而是：

- 允许 UI transcript 更丰富
- 但在协议边界把它压回严格形态

更进一步看，消息对象本身就已经不是“纯模型载荷”。

`createUserMessage()` 会带上：

- `isVirtual`
- `isVisibleInTranscriptOnly`
- `mcpMeta`

其中有些字段天生就服务于：

- UI 展示
- transcript 语义
- bridge / 存储层

而不是直接服务模型。

这再次说明 Claude Code 的消息对象天然是多面体：

- 同一对象服务多个消费者
- 发送给模型前必须重新裁剪

甚至 `sessionStorage` 还会在外部 transcript 持久化时把 virtual 升格为 real，以保证恢复语义成立。

这恰好证明：

- UI
- 存储
- 协议

三者不是同一层真相。

## 7. 为什么 discovered tools 也依赖 protocol transcript

`toolSearch.ts` 里 `extractDiscoveredToolNames(messages)` 说明：

- deferred tools 的暴露，并不是独立状态表单独保存的
- 它直接从 message history 里的 `tool_reference` blocks 和 compact boundary 携带状态中恢复

这意味着 protocol transcript 不只是“重放历史”。

它还承担：

- capability exposure memory

也就是说，Claude Code 的消息历史本身会继续影响：

- 下一轮哪些 deferred tools 能被真正放进工具池

所以 transcript 在这里是：

- prompt contract 的一部分
- 能力暴露闭环的一部分

不是单纯聊天记录。

更重要的是，`compact.ts` 还会把这类 discovered tools 的快照写进 compact boundary。

这说明 compact boundary 承载的也不只是“这里压缩过了”。

它还在承担：

- capability state handoff

这已经是典型的 runtime state continuation，而不再是单纯文本摘要。

## 8. 为什么“模型看到的世界”必须比“界面看到的世界”更严格

Claude Code 在这条链上反复表达同一原则：

- 模型侧世界必须更严格、更协议化、更少歧义

因为 UI 可以容忍：

- 展示性消息
- 虚拟层
- 辅助 chrome
- 来源混合

但模型侧一旦容忍这些东西，代价会直接落在：

- API reject
- prompt drift
- cache break
- tool exposure 错位

所以 Claude Code 不是在追求“UI 和协议完全一致”，而是在追求：

- 两者各自服从自己的真相

其中模型侧的真相必须更严格。

## 9. 一句话总结

Claude Code 的 prompt 之所以稳定，不只是因为 system prompt 写得好，还因为它在 API 边界前把 UI transcript 再编译成一份更严格的 protocol transcript，让模型始终活在一个经过整理、合法化、可持续复用的世界里。
