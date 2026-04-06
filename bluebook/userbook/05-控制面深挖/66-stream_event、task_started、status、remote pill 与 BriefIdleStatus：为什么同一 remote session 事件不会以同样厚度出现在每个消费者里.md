# `stream_event`、`task_started`、`status`、`remote pill` 与 `BriefIdleStatus`：为什么同一 remote session 事件不会以同样厚度出现在每个消费者里

## 用户目标

不是只知道 remote session 里会同时出现：

- transcript 正文
- streaming 输出
- `remote` pill
- `Reconnecting...`
- `n in background`

而是先拆开六类不同消费者：

- 哪些是在消费持续流式输出。
- 哪些是在消费后台任务与连接态的持续状态。
- 哪些只消费“当前是 remote 模式”的模式标记。
- 哪些会把同一事件直接吞掉，因为它只服务另一个消费者。
- 哪些事件会进入 transcript，哪些只进入 spinner/footer。
- 哪些看上去都像“远端状态”，但其实是不同厚度的投影。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“远端状态显示”：

- `stream_event`
- `task_started`
- `task_notification`
- `status=compacting`
- `remote` pill
- `Reconnecting...`
- `n in background`
- transcript 里的 `Status: ...`

## 第一性原理

同一条 remote session 事件在本地至少沿着五条轴线分化：

1. `Consumer Type`：当前消费者吃的是流式内容、持续状态，还是模式标记。
2. `Projection Thickness`：当前消费者拿到的是原始连续变化、折叠后的计数，还是只读标记。
3. `Visibility`：事件会进入 transcript、spinner/footer，还是根本不显示。
4. `State Coupling`：当前消费者依赖 `AppState`，还是直接依赖消息流回调。
5. `Reader Goal`：它服务的是“读到内容”“知道还在连着”“知道后台还有活”，还是“知道我正在 remote 模式”。

因此更稳的提问不是：

- “远端发来的事件，为什么这里没看到？”

而是：

- “这条远端事件本来是服务哪个消费者的；它应该进入 streaming transcript、后台计数、连接状态、模式标记，还是根本不在当前消费者的合同里？”

只要这五条轴线没先拆开，正文就会把所有 remote session 事件写成一张统一状态面。

这里也要主动卡住几个边界：

- 这页讲的是 remote session 内部不同消费者的厚度差。
- 不重复 51 页对 remote runtime event family 的拆分。
- 不重复 64 页对 remote durable status authority 与 direct local interaction 的跨模式对照。
- 不重复 65 页对 remote continuous flow vs direct discrete projection 的跨模式消费合同。

## 第一层：`stream_event` 主要服务流式内容消费者，不服务 footer / idle status

### `useRemoteSession` 会把 `stream_event` 送进 `handleMessageFromStream(...)`

`useRemoteSession.ts` 在：

- `converted.type === 'stream_event'`

时会继续调用：

- `handleMessageFromStream(...)`

而不是直接写 `AppState`。

这说明 `stream_event` 回答的问题不是：

- “后台任务还有多少”
- “当前连接是不是 reconnecting”

而是：

- “当前远端输出还在持续流动，本地该怎样继续更新正文/streaming UI”

### 所以 `stream_event` 不出现在 `BriefIdleStatus` 是设计，不是丢消息

只要这一层没拆开，正文就会把“footer 看不到流式变化”误写成“footer 少订阅了事件”。

## 第二层：`task_started/task_notification` 主要服务后台任务计数消费者，不服务正文

### `useRemoteSession` 对这两类事件会直接 return

`useRemoteSession.ts` 中：

- `task_started` -> add id -> `writeTaskCount()` -> `return`
- `task_notification` -> remove id -> `writeTaskCount()` -> `return`

这说明它们回答的问题不是：

- “当前正文要不要追加一条新的系统消息”

而是：

- “后台任务计数应不应该更新”

### 所以 `n in background` 是 task 事件被折叠后的投影，不是事件原文

更准确的理解应是：

- 原事件：`task_started/task_notification`
- 本地投影：`remoteBackgroundTaskCount`
- UI 表现：`${n} in background`

只要这一层没拆开，正文就会把任务计数写成“某条系统消息换了种文案”。

## 第三层：`status=compacting` 会同时影响多个消费者，但厚度不同

### 在消息消费层，它可能变成 transcript 里的 `Status: compacting`

`sdkMessageAdapter.ts` 会把：

- `system.status`

转成：

- `Status: ...`
- 或 `Compacting conversation…`

### 在状态管理层，它还会改写 `isCompactingRef`

`useRemoteSession.ts` 又会对：

- `sdkMessage.subtype === 'status'`

维护：

- `isCompactingRef`

并且重复 `compacting` 时直接 `return`，不重复追加消息。

这说明同一个远端 `status` 事件回答的问题不是单一的：

- 一部分进入正文
- 一部分只用于控制后续行为和超时语义

只要这一层没拆开，正文就会把 `Status: compacting` 当成完整的 compaction 状态对象。

## 第四层：`remoteConnectionStatus` 主要服务连接告警消费者，而不是正文消费者

### 连接态通过 `setConnStatus(...)` 写进 `AppState`

`useRemoteSession.ts` 会在：

- `onConnected`
- `onReconnecting`
- `onDisconnected`

里更新：

- `remoteConnectionStatus`

### `BriefIdleStatus` 直接消费这条持续状态

`Spinner.tsx` 的 `BriefIdleStatus` 会直接读：

- `remoteConnectionStatus`

然后显示：

- `Reconnecting...`
- `Disconnected`

这说明连接态回答的问题不是：

- “正文要不要多一条 message”

而是：

- “当前连接 warning 要不要在 idle/status 视图里持续可见”

只要这一层没拆开，正文就会把连接 warning 写成普通 transcript 消息。

## 第五层：`remoteSessionUrl` / `remote` pill 只服务模式标记消费者

### 它来自 initial state，不靠事件流持续更新

`remoteSessionUrl` 在 `main.tsx` 建好初始 state 后就存在。

`PromptInputFooterLeftSide.tsx` 只把它读出来，渲染：

- `remote` pill / link

这说明它回答的问题不是：

- “当前连接是不是健康”
- “当前后台任务还有几个”

而是：

- “当前这整个会话是不是 remote session 模式”

### 所以 `remote` pill 和 `Reconnecting...` 也不是同一种状态

更准确的理解应是：

- `remote` pill：模式标记
- `Reconnecting...`：连接 warning

只要这一层没拆开，正文就会把 pill、warning、任务计数写成同一类远端状态显示。

## 第六层：同一事件不会以同样厚度出现在每个消费者里

### 事件被投影，是因为每个消费者服务的读者问题不同

例如：

- `stream_event` 服务“正文流式阅读”
- `task_started/task_notification` 服务“后台任务是否仍在跑”
- `remoteConnectionStatus` 服务“连接 warning 是否该持续可见”
- `remoteSessionUrl` 服务“当前是否处于 remote 模式”

因此消费者之间不共享“同厚度原文”，而只共享：

- 对当前目标足够的投影

### 这也解释了为什么很多事件在某些面上根本不可见

不是漏了，而是它们本来就不属于那个消费者的合同。

只要这一层没拆开，正文就会反复写出：

- “为什么这里没显示那条远端事件？”

而没有先问：

- “它本来该服务谁？”

## 第七层：stable、conditional 与 internal 三层要分开保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | remote session 的不同 UI 消费者吃的是不同厚度的投影；`stream_event`、任务事件、连接 warning、remote pill 不属于同一种可见层 |
| 条件公开 | `stream_event` 依赖 streaming callbacks；任务计数依赖 task 事件流； `Reconnecting...` / `Disconnected` 依赖连接回调； `remote` pill 依赖 initial `remoteSessionUrl` |
| 内部/实现层 | `isCompactingRef`、重复 `compacting` status 的 suppress、stale tool-use 清理、具体 `handleMessageFromStream(...)` 细节 |

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 同一 remote 事件应该在每个 UI 面都能看到 | 不同消费者只吃自己需要的投影厚度 |
| `stream_event` 也应该出现在 footer / brief idle | 它主要服务流式正文消费者 |
| `task_started/task_notification` 是正文 system message | 它们主要服务后台任务计数 |
| `Status: compacting` 就是完整 compaction 状态 | 还有一层只服务内部行为控制的 `isCompactingRef` |
| `remote` pill = 连接态 warning | 它只是模式标记 |
| 某个面没显示一条远端事件 = 事件没到本地 | 更常见的是它被投给了别的消费者，或根本不属于当前消费者合同 |

## 七个检查问题

- 当前这个事件本来服务哪个消费者？
- 它进入的是 streaming transcript、后台计数、连接 warning，还是模式标记？
- 它会写进 `AppState`，还是只通过消息回调消耗？
- 这条事件是不是只被折叠成计数或 warning，而不是保留原文？
- 当前不可见，是被漏掉了，还是本来就不属于这个消费者？
- 我是不是又把不同消费者的投影厚度写成同一层了？
- 我是不是又把 remote pill、Reconnecting、task count、streaming output 写成一张统一状态面了？

## 源码锚点

- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/components/Spinner.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/remote/sdkMessageAdapter.ts`
