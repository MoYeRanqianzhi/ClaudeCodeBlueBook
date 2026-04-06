# `stream_event`、`task_started`、`task_notification` 与 `transcript/overlay/stderr`：为什么 remote session 是持续事件流消费者，而 direct connect 只是离散交互投影

## 用户目标

不是只知道：

- remote session 会持续更新输出、后台任务和连接态
- direct connect 也能显示消息、弹权限、报断线

而是先拆开六类不同对象：

- 哪些是在说 remote session 持续消费一条远端事件流。
- 哪些是在说 direct connect 主要只把少数离散结果投影进 UI。
- 哪些是在说 `stream_event`、`task_started`、`task_notification` 会驱动持续变化。
- 哪些是在说 direct connect 更常见的是 transcript message、approval overlay、fatal stderr 三种离散面。
- 哪些是在说 remote session 会在事件流中持续修正本地状态。
- 哪些是在说 direct connect 并不试图维持一条持续状态/输出消费管线。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“远端消息消费”：

- `stream_event`
- `task_started`
- `task_notification`
- `status=compacting`
- `remoteConnectionStatus`
- `toolPermissionOverlay`
- `Remote session initialized`
- `Server disconnected.`

## 第一性原理

这两条远端链的“本地到底怎样消费远端信息”至少沿着五条轴线分化：

1. `Event Continuity`：当前是持续事件流，还是离散事件投影。
2. `State Coupling`：消费事件后会不会持续回写共享状态。
3. `UISink`：事件最终进入 transcript、streaming 管线、overlay，还是 stderr。
4. `Loss Model`：断线后是继续留在可观察态，还是直接终止消费。
5. `Reader Contract`：用户期待的是“会持续变化的远端会话”，还是“当前这一轮交互的本地投影”。

因此更稳的提问不是：

- “它们不都是在消费远端发来的消息吗？”

而是：

- “当前这条链是在持续吃一条远端事件流并更新共享状态，还是只把少数高价值结果投影到当前 UI；断线后这条消费链会继续留痕，还是立刻收口？”

只要这五条轴线没先拆开，正文就会把 remote session 和 direct connect 写成同一种远端消费者。

这里也要主动卡住几个边界：

- 这页讲的是“持续事件流消费者”与“离散交互投影”的差别。
- 不重复 64 页对 durable status authority 的拆分。
- 不重复 61/63 页对 direct connect transcript surface / transcript mode 的拆分。
- 不重复 60/62 页对 direct connect control subset / visible status surface 的拆分。
- 不重复 51 页对 remote runtime event family 的总拆分。

## 第一层：remote session 真正在持续消费远端事件流

### `useRemoteSession` 会持续接收并处理多类事件

`useRemoteSession.ts` 在 `onMessage` 里会持续处理：

- 普通 `message`
- `stream_event`
- `task_started`
- `task_notification`
- `status`
- `compact_boundary`

这说明它回答的问题不是：

- “当前有没有一条值得显示的离散消息”

而是：

- “远端会话的事件流每推进一步，本地该怎样继续修正输出流、后台任务数和连接态”

### 它对某些事件的处理甚至会直接 `return`，因为这些事件本来就是状态驱动信号

例如：

- `task_started`
- `task_notification`
- `task_progress`

在很多情况下都先用来修正状态，再决定根本不渲染正文。

只要这一层没拆开，正文就会把 remote session 写成“只是多几条 system message”。

## 第二层：`stream_event` 让 remote session 成为持续输出消费者，而 direct connect 没走这条线

### remote session 会把 `stream_event` 继续送进流式 UI 管线

`useRemoteSession.ts` 对：

- `converted.type === 'stream_event'`

会继续调用：

- `handleMessageFromStream(...)`

这说明 remote session 回答的问题不是：

- “最终只保留离散完成消息即可”

而是：

- “远端输出还在流动时，本地也要持续消费并更新显示”

### direct connect 目前不消费这条持续流式分支

direct connect 那条线虽然上游 adapter 能认 `stream_event`，但当前 hook 只接：

- `converted.type === 'message'`

因此 direct connect 更像：

- 把离散结果投影到 UI

而不是：

- 持续渲染一条远端流式会话

只要这一层没拆开，正文就会把两条线都写成“只是不同 transport”。

## 第三层：remote session 会把 task 事件持续折算成共享状态，而 direct connect 没有这条计数链

### `task_started/task_notification` 在 remote session 里会维护后台任务计数

`useRemoteSession.ts` 对：

- `task_started` -> add task id
- `task_notification` -> remove task id

随后：

- `writeTaskCount()` -> `remoteBackgroundTaskCount`

这说明 remote session 消费这些事件的目的不是：

- “立刻显示一条新 transcript 消息”

而是：

- “把远端后台任务的持续变化折算成本地可复用状态”

### direct connect 则没有对应的“远端后台任务持续计数”合同

direct connect 当前更常见的是：

- 一轮消息显示
- 一次权限审批
- 一次 fatal 断线退出

没有远端 `task_started/task_notification` -> 共享计数 的长期链路。

只要这一层没拆开，正文就会把 `n in background` 误写成所有远端模式都自然具备的状态。

## 第四层：remote session 还能在事件流中持续校正连接态与流式上下文

### `onReconnecting/onDisconnected` 会留下可继续观察的状态

`useRemoteSession.ts` 在：

- `onReconnecting`
- `onDisconnected`

里不仅会改连接态，还会：

- 清理后台任务计数
- 清理 stale 的 tool-use in-progress 状态

这说明 remote session 回答的问题不是：

- “连接一断就结束本地消费链”

而是：

- “连接变化本身也是一类要持续投影给 UI 的远端事件”

### 这和 direct connect 的 fatal stderr 收口完全不同

direct connect 断线时更像：

- 打一条 stderr
- `gracefulShutdown(1)`

而不是留下一个还可继续观察和恢复的状态面。

只要这一层没拆开，正文就会把两条线的断线后果写成同一种消费合同。

## 第五层：direct connect 更像“离散交互投影器”

### 它的高价值 UI sink 主要是三类

对 direct connect 来说，更稳定的消费面是：

- transcript 里的离散 message
- `PermissionRequest` overlay
- fatal stderr disconnect

这说明它回答的问题不是：

- “远端会话正在持续输出什么结构化事件流”

而是：

- “当前这轮交互里，有哪些值得本地用户立刻看到或决定的结果”

### 所以 direct connect 的 reader contract 更接近“当前轮次交互”

而 remote session 的 reader contract 更接近：

- “我正在附着一条持续运行的远端会话”

只要这一层没拆开，正文就会把两者都写成一条统一的 remote runtime consumer。

## 第六层：这不是 transport 差异，而是消费合同差异

### 远端来源相似，不代表本地消费方式相似

两边都可能来自远端，但：

- remote session 更偏“持续事件流 + 持续状态修正”
- direct connect 更偏“离散投影 + 当前交互决定”

所以更准确的理解应是：

- 差别不只是 WebSocket vs 别的 transport
- 而是本地把远端信息当成什么来消费

只要这一层没拆开，正文就会把它退化成一句“一个更复杂，一个更简单”。

## 第七层：stable、conditional 与 internal 三层要分开保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | remote session 是持续事件流消费者；direct connect 主要是离散交互投影器；两者不是同一种消费合同 |
| 条件公开 | remote session 的 `stream_event`、后台任务计数与重连状态依赖远端事件流；direct connect 的 overlay / stderr 依赖当前审批与断线时机 |
| 内部/实现层 | `handleMessageFromStream(...)` 的细部、`runningTaskIdsRef` 的维护方式、tool-use stale cleanup、具体 echo filter / ring buffer 机制 |

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| remote session 和 direct connect 都只是“显示远端消息” | 一个持续消费事件流，一个主要投影离散结果 |
| `stream_event` 只是可有可无的消息类型 | 对 remote session 它是持续输出链的一部分 |
| `task_started/task_notification` 只是 system message 变种 | 对 remote session 它们主要驱动共享状态，而不是正文 |
| direct connect 也天然拥有 `n in background` 这类持续状态 | 它没有同级的远端事件计数链 |
| 两边断线后都只是不同文案 | remote session 会留下可观察状态；direct connect 通常直接 fatal 收口 |
| 这只是 transport 差异 | 更根本的是消费合同差异 |

## 七个检查问题

- 当前这条链是在持续消费远端事件流，还是只在投影少数离散结果？
- 这条事件会持续修正共享状态，还是只会落成一条 message / overlay / stderr？
- 它会不会在没有新 prompt 的情况下继续影响 UI？
- 当前断线后，这条消费链会留在 UI 里，还是直接终止？
- 这条差异说的是 transport，还是 reader contract？
- 我是不是又把 task / stream 事件写成普通 transcript 消息了？
- 我是不是又把 direct connect 写成持续事件流消费者了？

## 源码锚点

- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/components/Spinner.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/remote/sdkMessageAdapter.ts`
