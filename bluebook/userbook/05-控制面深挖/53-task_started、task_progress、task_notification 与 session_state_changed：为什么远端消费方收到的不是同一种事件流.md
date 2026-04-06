# `task_started`、`task_progress`、`task_notification` 与 `session_state_changed`：为什么远端消费方收到的不是同一种事件流

## 用户目标

不是只知道远端或非交互消费方会收到：

- 任务开始
- 任务进度
- 任务结束
- 会话进入 idle / running / requires_action

这些系统事件，而是先分清五类不同对象：

- 哪些是在给任务建立一个开始 bookend。
- 哪些是在任务还没结束前持续补进度。
- 哪些是在任务结束时补一个 terminal bookend。
- 哪些根本不是任务事件，而是主回合的 session-level 状态广播。
- 哪些虽然都从 SDK 事件流出去，但消费方应该把它们折成不同的 UI 面，而不是一张“远端状态列表”。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“远端任务/状态通知”：

- `task_started`
- `task_progress`
- `task_notification`
- `session_state_changed`
- `runningTaskIdsRef`
- `n in background`
- idle authoritative turn-over signal

## 第一性原理

非交互 / 远端消费方看到的 system event 至少沿着四条轴线分化：

1. `Object Scope`：当前事件在说某一个 task，还是整条 foreground turn。
2. `Lifecycle Position`：当前是在宣告开始、持续中途进展，还是终结。
3. `Consumer Purpose`：当前是给 background task 面板用，还是给“当前主回合是不是还在跑”用。
4. `Delivery Timing`：当前事件是边运行边发，还是在 finally / drain 阶段专门补齐 bookend。

因此更稳的提问不是：

- “远端不是都能看到任务和状态变化了吗？”

而是：

- “这条事件在描述 task bookend、mid-task progress，还是主回合状态；消费方是该拿它算 background count，还是当 turn-over signal？”

只要这四条轴线没先拆开，正文就会把 `task_started`、`task_progress`、`task_notification` 与 `session_state_changed` 写成同一种通知。

这里也要主动卡住一个边界：

- 这页讲的是 SDK event stream 的 task / session 事件合同
- 这页不是 SDK system subtype 总表
- 不重复 04 页对 Agent / Task / Team / Cron 的高层能力组织
- 不重复 30 页对 remoteBackgroundTaskCount / ownership 的运行态面
- 不重复 51 页对 `worker_status` / `pending_action` / `task_summary` / `session_state_changed` 作为远端状态投影的分层

## 第一层：`task_started` 是 task 的开始 bookend，不是“任务正在运行”的持续状态

### 它在 task 注册时发一次，而不是每次轮询都刷新

`utils/task/framework.ts` 的 `registerTask(...)` 非常直接：

- 先把 task 注册进 `AppState`
- 只有不是 replacement 时，才发一条
  - `type: 'system'`
  - `subtype: 'task_started'`

这说明它回答的问题不是：

- “当前任务现在还在不在跑”

而是：

- “有一条新 task 生命周期开始了”

### 所以 `task_started` 不是 background count 本身

更准确的区分是：

- `task_started`：开始 bookend
- `runningTaskIdsRef` / background count：消费方基于 bookend 自己算出的派生状态

只要这一层没拆开，正文就会把：

- “收到了 started”
- “远端任务计数现在是多少”

写成同一个对象。

## 第二层：`task_progress` 讲的是中途进展，不负责关账

### 它专门承载 summary / usage / workflow_progress

`utils/task/sdkProgress.ts` 对 `emitTaskProgress(...)` 的定义很清楚：

- `task_id`
- `description`
- `usage`
- `last_tool_name`
- `summary`
- `workflow_progress`

这说明它回答的问题不是：

- 任务是不是刚刚创建
- 任务是不是已经结束

而是：

- 任务进行到哪里、消耗了多少、最近在做什么

### 所以 `task_progress` 是 mid-task signal，不是 bookend

更准确的理解应是：

- `task_started` / `task_notification`：task lifecycle 两端的 bookend
- `task_progress`：中间流动的进度帧

只要这一层没拆开，正文就会把：

- 任务开始
- 任务中途进度
- 任务结束

写成同一种任务通知。

## 第三层：`task_notification` 是终结 bookend，不是又一条进度消息

### 它承载的是 terminal status

`sdkEventQueue.ts` 明确把 `task_notification` 定义成：

- `status: completed | failed | stopped`
- `summary`
- `output_file`
- `usage`

并且注释写得很清楚：

- `registerTask()` 总是发 `task_started`
- 这个函数负责把 terminal status 作为 closing bookend 发出来

但源码里还要再补一层：

- 抑制 XML 通知的路径，会直接调用 `emitTaskTerminatedSdk(...)`
- 普通终结路径则会让 `print.ts` 解析带 `<status>` 的 `task_notification` XML，再产出同名 SDK event

因此稳定不变的不是：

- “terminal bookend 一定只走某一个实现入口”

而是：

- 无论经由 direct SDK emit 还是终结 XML 解析，消费方最终看到的都是同一种 terminal bookend 合同

这说明 `task_notification` 回答的问题不是：

- 任务现在还有没有新进度

而是：

- 这条 task 生命周期已经完成、失败或被停止了

### 所以 `task_notification` 与 `task_progress` 不是同一条“进度更新”

更准确的区分是：

- `task_progress`：中途不断追加
- `task_notification`：关账时补 terminal bookend

只要这一层没拆开，正文就会把：

- progress stream
- terminal summary

写成同一种任务更新。

## 第四层：`session_state_changed` 根本不是 task 事件，而是 foreground turn 的状态广播

### 它回答的是主回合是否 idle / running / requires_action

`sdkEventQueue.ts` 对 `session_state_changed` 的注释写得很硬：

- CCR 自己已经有另一条 state surface
- SDK consumers 仍需要它来判断主回合是否正在产出
- 尤其 `idle` 是 authoritative “turn is over” signal

这说明它回答的问题不是：

- 某个 background task 现在在哪一阶段

而是：

- 当前主 foreground turn 到底有没有结束

### 但它的 SDK 事件发射本身是受 env gate 保护的条件开放面

`sessionState.ts` 里真正把它镜像进 SDK event stream 的代码，还包了一层：

- `CLAUDE_CODE_EMIT_SESSION_STATE_EVENTS`

旁边注释解释得很直接：

- 先 opt-in
- 因为部分旧消费方还不会忽略这个 subtype
- 否则 trailing idle event 会把它们错误钉在 running

所以更准确的理解应是：

- foreground turn 的 `idle / running / requires_action` 语义本身是稳定存在的
- `session_state_changed` 这条 SDK subtype 的对外发射，则属于条件开放面

### 所以它不该和 task_started / task_notification 混成同一种 task lifecycle 事件

更准确的理解应是：

- task 事件：围绕某个 task 对象
- `session_state_changed`：围绕整条主会话回合

只要这一层没拆开，正文就会把：

- “后台任务开始/结束”
- “主回合现在 idle 了”

写成同一种通知。

## 第五层：一个典型远端消费方会把 task 事件和 session 事件折成不同结果

### `useRemoteSession` 这个例子能证明 count 看 bookend，不看 progress

`useRemoteSession.ts` 在处理远端 SDK message 时：

- `task_started` -> `runningTaskIdsRef.add(task_id)`
- `task_notification` -> `runningTaskIdsRef.delete(task_id)`
- `task_progress` -> 直接 return，不参与计数

这说明对于 remote session UI 来说：

- task_started / task_notification

主要被折成：

- “现在还有多少条 background task 在跑”

完整的远端计数投影面，见第 30 页；这页只保留一个结论：

- 消费方改变 task count 时，主要看的是 bookend，不是 progress frame

### 这再次证明 `task_progress` 不是计数事件

更准确的区分是：

- started / notification：bookend，适合维护 task count
- progress：说明 task 中途做到了哪一步，但不改变 count

只要这一层没拆开，正文就会把：

- “有新进度”
- “后台任务数变化”

写成同一种 signal。

## 第六层：作为对照，`session_state_changed` 的时机服务于回合边界，而不是 task bookend

### idle 会在 finally flush 后专门补发

`print.ts` 在 finally 阶段会：

- 先 `flushInternalEvents()`
- 再 `notifySessionStateChanged('idle')`
- 再立刻 `drainSdkEvents()`

旁边的注释写得也很清楚：

- 这样 `idle session_state_changed` 才能在输入再次空闲前真的发到输出流
- 并且与任何晚到的 `task_notification` 一起补齐

完整的 turn-state 投影面，见第 51 页；这里仅保留与 task event contract 的对照。

这说明它回答的问题不是：

- 一个普通的“状态又变了一次”

而是：

- 现在这一轮可以被下游宿主确信已经结束了

### 所以 `idle session_state_changed` 比普通进度消息更像回合边界

更准确的理解应是：

- `task_progress`：中途不断来的进度帧
- `idle session_state_changed`：回合边界信号

只要这一层没拆开，正文就会把：

- 中途噪声
- authoritative turn-over

写成同一种状态更新。

## 第七层：`task_notification` 与 `session_state_changed(idle)` 可能一起在 drain 阶段补齐，但职责仍然不同

### `print.ts` 明确要求 drain 顺序先让 progress 再到 terminal events

`print.ts` 的 do-while drain 注释写得很直接：

- 先 drain `task_started` / `task_progress`
- 这样 progress event 才会先于 `task_notification`

而 finally 又会：

- 先 flush internal events
- 再补 `session_state_changed('idle')`
- 再 drain 一轮 SDK events

这说明最终输出流里虽然可能连着看到：

- `task_notification`
- `session_state_changed`

但它们分别在回答：

- 某条 task 已终结
- 整个 foreground turn 已结束

### 所以“最后一起出来”不代表“同一种结尾事件”

更准确的区分是：

- task terminal bookend
- turn-over signal

只要这一层没拆开，正文就会把 finally drain 末尾看到的几条事件误写成一种“结束通知”。

## 第八层：稳定、条件与内部三层要分开保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `task_started` / `task_notification` 作为 task bookend、`task_progress` 作为中途进度帧 |
| 条件公开 | `session_state_changed` 的 SDK 发射、`workflow_progress`、foreground task_notification 直发路径、remote session 用 task bookend 折 background count |
| 内部/实现层 | queue 上限、drain 次序细节、XML parser 旁支、具体 flush 时机的实现胶水 |

这里尤其要避免两种写坏方式：

- 把 task 事件流和 session 状态广播写成同一条通知流
- 把 task_progress 当成 task count 或 terminal signal

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `task_started` = 任务正在运行的持续状态 | 它只是开始 bookend |
| `task_progress` = task 完成通知 | 它是中途进度帧 |
| `task_notification` = 又一条 progress 更新 | 它是 terminal bookend |
| `session_state_changed` = task lifecycle 事件 | 它是 foreground turn 状态广播 |
| 收到 progress = background count 该变了 | 计数主要看 started / notification |
| finally 里一起出来的事件 = 同一种结束通知 | task end 与 turn-over 是两层信号 |

## 六个检查问题

- 当前事件在描述 task lifecycle，还是 foreground turn state？
- 这是开始、进度，还是终结 bookend？
- 这个事件应该让消费方改 task count，还是改 turn state？
- 当前看到的是中途进度，还是终结通知？
- 当前看到的是 task 事件，还是回合状态广播？
- finally drain 末尾看到的多条事件，是不是仍然属于不同层级的结束信号？

## 源码锚点

- `claude-code-source-code/src/utils/sdkEventQueue.ts`
- `claude-code-source-code/src/utils/task/framework.ts`
- `claude-code-source-code/src/utils/task/sdkProgress.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/utils/sessionState.ts`
- `claude-code-source-code/src/cli/print.ts`
