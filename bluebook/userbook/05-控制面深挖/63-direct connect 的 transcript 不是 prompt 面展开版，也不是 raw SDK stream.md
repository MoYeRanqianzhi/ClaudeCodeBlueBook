# `Ctrl+O transcript`、`verbose`、`showAllInTranscript` 与 `tool_result`：为什么 direct connect 的 transcript 不是 prompt 面展开版，也不是 raw SDK stream

## 用户目标

不是只知道：

- 平时 prompt 面看到一部分消息
- `Ctrl+O` transcript 会看到更多
- 但它仍然看不到所有远端事件

而是先拆开六类不同对象：

- 哪些是在说 REPL 普通 prompt 面默认怎么显示消息。
- 哪些是在说 transcript 模式为什么会强制 `verbose=true`。
- 哪些是在说 transcript 仍然只是“已落盘的 UI 消息全集”，不是 raw SDK wire。
- 哪些是在说 `showAllInTranscript` 只影响截断，不影响上游过滤。
- 哪些是在说普通 `user` echo 为什么默认不显示，而 `tool_result` 会被特别保留。
- 哪些是在说 info 级 system message 在 prompt 面和 transcript 面为什么不是同一层可见性。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“transcript”：

- prompt 面消息
- `Ctrl+O` transcript
- `showAllInTranscript`
- `verbose=true`
- `tool_result`
- raw SDK message stream

## 第一性原理

direct connect 的“我在不同视图里到底能看到什么”至少沿着五条轴线分化：

1. `Upstream Filter`：manager 和 adapter 已经先决定了哪些远端消息还能活下来。
2. `UI Visibility`：活下来的消息在 prompt 面是否还会因为 `verbose` 被继续隐藏。
3. `Transcript Mode`：`Ctrl+O` 是不是只把同一批消息换一种显示方式。
4. `Transcript Cap`：`showAllInTranscript` 改的是数量上限，还是上游选择规则。
5. `Local-vs-Remote Provenance`：当前消息是本地先写入的，还是远端特判回写的。

因此更稳的提问不是：

- “transcript 不就是把所有消息全展开吗？”

而是：

- “当前这条消息是在上游就被吞了，还是在 prompt 面被 `verbose=false` 暂时隐藏；它是本地先写入、远端特判回写，还是根本没进 UI 消息集合？”

只要这五条轴线没先拆开，正文就会把 transcript 写成 raw SDK stream 的别名。

这里也要主动卡住几个边界：

- 这页讲的是 prompt 面、transcript 模式与 raw SDK 流之间的可见性差异。
- 不重复 61 页对 direct connect message filtering / ignore/convert 主干的总说明。
- 不重复 62 页对可见状态面的来源拆分。
- 不重复 60 页对 permission overlay / interrupt / shutdown 的收口语义。

## 第一层：`Ctrl+O transcript` 比 prompt 面更宽，但它接收到的已经不是 raw SDK 流

### transcript 入口直接把 `Messages` 组件切到 `verbose=true`

`REPL.tsx` 在 transcript 分支里会创建：

- `<Messages ... verbose={true} screen={screen} showAllInTranscript={...} />`

而普通 scrollable prompt 面走的是：

- `<Messages ... verbose={verbose} screen={screen} ... />`

这说明 transcript 模式回答的问题不是：

- “raw SDK 流是否无损保真”

而是：

- “已经进入 UI 消息集合的内容，要不要用更少隐藏规则显示出来”

### 所以 transcript 比 prompt 更宽，不代表它比 wire 更宽

更准确的理解应是：

- wire → 先经过 manager / adapter 过滤
- UI message set → transcript 比 prompt 更少隐藏

只要这一层没拆开，正文就会把 `verbose=true` 误写成“显示原始远端流”。

## 第二层：prompt 面会隐藏一批 info 级系统消息，transcript 面则更倾向于放出来

### `SystemTextMessage` 在 `!verbose && level === info` 时直接返回 null

`SystemTextMessage.tsx` 里有一条非常硬的规则：

- 非 `stop_hook_summary`
- 且 `!verbose`
- 且 `message.level === 'info'`
- 直接 `return null`

这说明 prompt 面回答的问题不是：

- “这条系统消息存在不存在”

而是：

- “默认交互面需不需要为了降噪而先不显示这条 info 级系统消息”

### transcript 模式天然放宽这层隐藏

因为 transcript 分支强制：

- `verbose=true`

所以像下面这些更容易被 transcript 放出来：

- `Remote session initialized ...`
- `Status: ...`
- `Tool X running ...`

只要这一层没拆开，正文就会把：

- prompt 面看不到
- transcript 面能看到

误写成“消息是 transcript 才生成的”。

## 第三层：`showAllInTranscript` 只改截断，不改上游过滤

### `Messages.tsx` 的 transcript cap 是后置裁剪

`Messages.tsx` 里：

- `isTranscriptMode = screen === 'transcript'`
- `shouldTruncate = isTranscriptMode && !showAllInTranscript && !virtualScrollRuntimeGate`
- `messagesToShow = shouldTruncate ? ...slice(-MAX...) : ...`

这说明 `showAllInTranscript` 回答的问题不是：

- “原本被 manager / adapter 吞掉的消息要不要救回来”

而是：

- “已经进入 UI 消息集合的历史记录，这次要不要继续套 30 条截断”

### 所以 `Ctrl+E show all` 不是“显示所有远端事件”

更准确的理解应是：

- `showAllInTranscript` 只放开 UI cap
- 放不开上游已经被忽略或过滤掉的家族

只要这一层没拆开，正文就会把 transcript 的“show all”误写成 wire-level 的“show everything”。

## 第四层：普通 `user` echo 默认不回到 transcript，但 `tool_result` 是特判保留对象

### 本地用户消息在发送前就先写进 `messages`

`REPL.tsx` 里，走 remote send 前会先：

- `createUserMessage(...)`
- `setMessages(prev => [...prev, userMessage])`

这说明普通 prompt 文本回答的问题不是：

- “远端回显后再显示”

而是：

- “本地交互先写一条用户消息，再把同一内容送到远端”

### adapter 对 `user` family 的默认态度是忽略普通 echo，只救 `tool_result`

`sdkMessageAdapter.ts` 里：

- 检测 `content.some(b => b.type === 'tool_result')`
- 若 `convertToolResults` 打开，则转成 `UserMessage`
- 否则普通 `user` 直接 `ignored`

这说明 transcript 回答的问题不是：

- “所有远端 `user` 消息都要回写一遍”

而是：

- “已经由本地显示过的普通 prompt 不重复显示；但远端工具结果需要额外落回 UI”

只要这一层没拆开，正文就会把 direct connect transcript 错写成“用户原话和远端回话的双向镜像”。

## 第五层：transcript 仍然比 raw SDK 流更窄，因为很多消息压根进不了 `Messages`

### 有些消息在 manager 层就被挡掉

例如：

- `control_response`
- `keep_alive`
- `control_cancel_request`
- `streamlined_*`
- `post_turn_summary`

### 另一些消息在 adapter 层被压成 `ignored`

例如：

- success `result`
- `auth_status`
- `tool_use_summary`
- `rate_limit_event`
- unknown type

这说明 transcript 模式再宽，也只是在“已进 UI 的消息集合”上做展开。

只要这一层没拆开，正文就会把：

- transcript 显示不出

误写成：

- 远端根本没发

## 第六层：`isVisibleInTranscriptOnly` 与 transcript 屏是另一道显示闸门

### `shouldShowUserMessage(...)` 会按 `isTranscriptMode` 决定是否放行 transcript-only 消息

`utils/messages.ts` 里：

- `if (message.isVisibleInTranscriptOnly && !isTranscriptMode) return false`

这说明有些消息回答的问题不是：

- “这条消息值不值得存在”

而是：

- “它值不值得只在 transcript 屏出现，而不污染日常 prompt 面”

### 所以 transcript 还有一层“UI only expansion”

更准确的理解应是：

- raw SDK 流不是 transcript
- transcript 也不是 prompt 面的纯复制
- transcript 会额外显示一部分 transcript-only UI 消息

只要这一层没拆开，正文就会把 transcript 误写成“只是 prompt 面滚动更多”。

## 第七层：stable、conditional 与 internal 三层要分开保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `Ctrl+O` transcript 比 prompt 面更宽，但仍然不是 raw SDK stream；普通 `user` echo 默认不重复显示，`tool_result` 会特判保留；`showAllInTranscript` 只改数量截断 |
| 条件公开 | info 级 system message 的可见性取决于 `verbose` 与当前 screen； transcript 模式强制 `verbose=true`； transcript-only 消息只在 transcript 屏出现 |
| 内部/实现层 | 30 条 transcript cap、virtual scroll gate、`post_turn_summary` / `streamlined_*` 的具体过滤细节、why `parent_tool_use_id` not reliable |

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `Ctrl+O transcript` = raw SDK 消息流 | 它只是更宽的 UI 视图，上游过滤仍然成立 |
| prompt 面看不到某条 info system message = 这条消息不存在 | 很可能只是 `verbose=false` 把它隐藏了 |
| `showAllInTranscript` = 显示所有远端事件 | 它只放开 UI 截断 |
| direct connect 里的 `user` 气泡主要靠远端回显 | 普通用户消息是本地先写入，远端默认不重复回显 |
| `tool_result` 也只是普通 user echo | 它是 adapter 的特判保留对象 |
| transcript 只是 prompt 面的展开版 | 它更宽于 prompt，也更窄于 raw wire |

## 七个检查问题

- 当前说的是 prompt 面、transcript 屏，还是 raw SDK wire？
- 这条消息是上游被吞了，还是只是 prompt 面因为 `verbose=false` 没显示？
- `showAllInTranscript` 改的是上游过滤，还是 UI cap？
- 当前 `user` family 是本地先写入的 prompt，还是远端回来的 `tool_result`？
- 这条消息是不是 `isVisibleInTranscriptOnly`，所以只该在 transcript 屏出现？
- 我是不是又把 transcript 写成了原始远端流？
- 我是不是又把 prompt 面和 transcript 面写成完全同一批消息了？

## 源码锚点

- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/components/Messages.tsx`
- `claude-code-source-code/src/components/messages/SystemTextMessage.tsx`
- `claude-code-source-code/src/utils/messages.ts`
- `claude-code-source-code/src/remote/sdkMessageAdapter.ts`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
