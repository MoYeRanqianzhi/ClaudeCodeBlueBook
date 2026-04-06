# `slash_commands`、`stream_event`、`task_started` 与 `status=compacting`：为什么 remote session 的命令集、流式正文、后台计数与 timeout 策略不是同一种消费者

## 用户目标

不是只知道 remote session 会同时发生：

- `init` 里带 `slash_commands`
- `stream_event` 持续推进正文
- `task_started/task_notification` 改变后台任务数
- `status=compacting` 影响超时与显示

而是先拆开四类不同消费者：

- 哪些是在喂本地命令集。
- 哪些是在喂流式正文。
- 哪些是在喂后台任务计数。
- 哪些是在喂 timeout / compaction 控制。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“远端更新”：

- `slash_commands`
- `stream_event`
- `task_started`
- `task_notification`
- `status=compacting`
- `compact_boundary`

## 第一性原理

同一条 remote session 连接里的更新至少沿着五条轴线分化：

1. `Target Consumer`：当前更新真正服务哪个本地控制器。
2. `Projection Shape`：它喂的是命令集合、流式正文、计数器，还是 timeout policy。
3. `Persistence`：消费后是改一次本地配置，还是持续推动当前回合。
4. `Visibility`：它会直接进正文，还是只在行为层生效。
5. `Failure Cost`：如果把它喂错消费者，会造成命令错露、正文错漏、任务数漂移，还是误判 unresponsive。

因此更稳的提问不是：

- “remote session 又收到一条系统事件了，然后呢？”

而是：

- “这条更新到底是在改本地命令集、推进正文流、维护后台任务计数，还是调 timeout/compaction 控制；如果我把它写成统一状态更新，会丢掉哪一层语义？”

只要这五条轴线没先拆开，正文就会把 remote session 的 event consumption 写成一锅。

这里也要主动卡住几个边界：

- 这页讲的是 remote session 内部四类消费者的分工。
- 不重复 51 页对 remote runtime event family 的拆分。
- 不重复 66 页对“同一事件在不同消费者里的投影厚度”总论。
- 不重复 64/65 页的跨模式对照。

## 第一层：`init.slash_commands` 喂的是本地命令集，不是正文

### `useRemoteSession` 在 `system.init` 时先调用 `onInit(slash_commands)`

`useRemoteSession.ts` 明确在：

- `sdkMessage.type === 'system'`
- `sdkMessage.subtype === 'init'`

时调用：

- `onInit(sdkMessage.slash_commands)`

### `REPL.tsx` 的 `handleRemoteInit` 会据此裁剪本地命令集

`REPL.tsx` 里：

- `remoteSlashCommands` -> `remoteCommandSet`
- 只保留远端列出的命令，或者本地 `REMOTE_SAFE_COMMANDS`

这说明 `slash_commands` 回答的问题不是：

- “正文该显示哪条系统消息”

而是：

- “这条 remote session 当前允许哪些 slash command 出现在本地命令面里”

只要这一层没拆开，正文就会把 `init` 误写成只服务 transcript 的初始化消息。

## 第二层：`stream_event` 喂的是流式正文消费者，不是计数器或 warning

### `useRemoteSession` 对 `stream_event` 直接走 `handleMessageFromStream(...)`

当 `converted.type === 'stream_event'` 时，它会把事件继续送入：

- `handleMessageFromStream(...)`

并把生成的 message/streaming state 接回：

- `setMessages(...)`
- `setStreamMode(...)`
- `setStreamingToolUses(...)`

这说明 `stream_event` 回答的问题不是：

- “后台任务是不是还在跑”
- “连接 warning 要不要变化”

而是：

- “正文和流式工具/思考 UI 该怎样持续推进”

只要这一层没拆开，正文就会把 `stream_event` 写成普通系统事件变种。

## 第三层：`task_started/task_notification` 喂的是后台任务计数器，不是正文

### 这两类事件首先被拿去维护 `runningTaskIdsRef`

`useRemoteSession.ts` 对：

- `task_started`
- `task_notification`

的处理都是：

- 更新 `runningTaskIdsRef`
- `writeTaskCount()`
- `return`

### 它们的主要产物是 `remoteBackgroundTaskCount`

`writeTaskCount()` 最终写回：

- `AppState.remoteBackgroundTaskCount`

然后被：

- `BriefIdleStatus`

折叠成：

- `${n} in background`

这说明 task 事件回答的问题不是：

- “正文里要多显示几条后台任务系统消息”

而是：

- “本地应不应该持续记住远端后台还有几个活”

只要这一层没拆开，正文就会把 task 事件写成 transcript 事件，而不是持续计数链。

## 第四层：`status=compacting` 同时喂 transcript 与 timeout policy，但不是同一厚度

### 一层投影进正文

`sdkMessageAdapter.ts` 会把：

- `system.status`

转成：

- `Status: ...`
- `Compacting conversation…`

### 另一层只喂内部控制

`useRemoteSession.ts` 又会：

- 用 `isCompactingRef` 记录当前是否 compacting
- 重复 compacting 时不重复追加消息
- `compact_boundary` / `session end` 时清掉 compacting 状态

更关键的是，`sendMessage(...)` 开 timeout 时会看：

- `isCompactingRef.current`

从而在：

- `RESPONSE_TIMEOUT_MS`
- `COMPACTION_TIMEOUT_MS`

之间切换。

这说明 `status=compacting` 回答的问题不是单一的：

- 一部分是“给用户看一条状态消息”
- 一部分是“别太早把这条 remote session 误判成 unresponsive”

只要这一层没拆开，正文就会把 `Status: compacting` 当成完整 compaction 语义。

## 第五层：这四类消费者的错误后果完全不同

### 如果把 `slash_commands` 喂错，会错露/错藏命令

命令面会不可信。

### 如果把 `stream_event` 喂错，会让正文流式推进断裂

用户会看到“远端在跑，但正文不动”。

### 如果把 `task_*` 喂错，会让后台任务计数漂移

`n in background` 会长期高估或低估。

### 如果把 `compacting` timeout 策略喂错，会误报 unresponsive

本地会过早：

- 加 warning message
- 主动 reconnect

只要这一层没拆开，正文就会把这些都说成“状态不同而已”，低估其合同差异。

## 第六层：所以 remote session 不是“统一状态更新器”，而是“四类更新分发器”

更准确的理解应是：

- `slash_commands` -> command set gate
- `stream_event` -> streaming transcript
- `task_*` -> background count
- `status=compacting` -> transcript hint + timeout policy

这也是为什么“同样都是 remote 事件”，却不该用同一套路解释。

## 第七层：stable、conditional 与 internal 三层要分开保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | remote session 会把不同事件分别喂给命令集、流式正文、后台计数和 timeout/compaction 控制；它们不是同一种消费者 |
| 条件公开 | `slash_commands` 依赖 init； `stream_event` 依赖 streaming callbacks； task 计数依赖 task 事件流； compaction timeout 依赖 `isCompactingRef` 与 boundary/reset 语义 |
| 内部/实现层 | `runningTaskIdsRef` 的维护、`BoundedUUIDSet` 回声过滤、重复 compacting suppress、具体 timeout 常量与 reconnect 行为 |

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `init` 只是正文里的初始化提示 | 其中的 `slash_commands` 还会裁剪本地命令集 |
| `stream_event` 只是系统消息的另一种写法 | 它主要服务流式正文消费者 |
| `task_started/task_notification` 只是后台提示消息 | 它们主要服务后台任务计数链 |
| `Status: compacting` 就是完整 compaction 状态 | 它同时还在影响 timeout policy |
| 所有 remote 事件都只是“给用户看” | 有些主要是喂本地控制器，不是正文 |
| 这些差异只是实现细节 | 它们直接决定命令露出、正文推进、计数可信度和超时误判 |

## 七个检查问题

- 当前这条更新真正服务哪个消费者？
- 它喂的是命令集、正文流、计数器，还是 timeout policy？
- 它会直接进 transcript，还是只在行为层生效？
- 这条事件如果漏了，坏的是正文、命令面、计数，还是 timeout？
- 我是不是又把 `slash_commands` 写成纯正文事件了？
- 我是不是又把 `task_*` 写成 transcript message 了？
- 我是不是又把 `compacting` 的双重消费写成一层了？

## 源码锚点

- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/remote/sdkMessageAdapter.ts`
- `claude-code-source-code/src/components/Spinner.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
