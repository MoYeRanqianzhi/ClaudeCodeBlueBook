# `worker_status`、`requires_action_details`、`pending_action`、`task_summary`、`post_turn_summary` 与 `session_state_changed`：为什么远端看到的运行态不是同一张面

## 用户目标

不是只知道远端会话里“有时显示 Running、有时 Waiting for input、有时还会看到正在做什么的摘要”，而是先分清六类不同对象：

- 哪些是在给远端一个粗粒度的 `idle / running / requires_action` 相位。
- 哪些是在 `requires_action` 时补一份结构化的阻塞上下文。
- 哪些是在 `external_metadata` 里放一份前端可自由演化的 `pending_action` JSON。
- 哪些是在中途持续上报“这一轮现在在做什么”的 `task_summary`。
- 哪些是在一轮结束后给出的 `post_turn_summary`。
- 哪些只是在 SDK 事件流里广播“当前回合已经进入 idle / running / requires_action”。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“远端运行态”：

- `worker_status`
- `requires_action_details`
- `external_metadata.pending_action`
- `task_summary`
- `post_turn_summary`
- `session_state_changed`

## 第一性原理

远端看到的“现在这条会话在干什么”至少沿着四条轴线分化：

1. `Phase Surface`：当前只是在说 idle / running / requires_action 这种粗粒度相位。
2. `Block Context Surface`：当前是在解释“卡在哪里、等什么输入”。
3. `Progress Surface`：当前是在说“这一轮进行到哪里了”。
4. `Delivery Surface`：当前是通过 worker state PUT、`external_metadata`，还是 SDK 事件流发出去的。

因此更稳的提问不是：

- “远端不是已经知道现在 Running / Waiting for input 吗？”

而是：

- “我现在看到的是粗粒度相位、阻塞上下文、中途进度、回合总结，还是事件流里的状态广播；它们是不是来自同一条上报链？”

只要这四条轴线没先拆开，正文就会把 `worker_status`、`pending_action`、`task_summary`、`post_turn_summary` 与 `session_state_changed` 写成同一种运行态。

这里也要主动卡住一个边界：

- 这页讲的是远端运行态投影面
- 不重复能力地图那页对“实时账 vs 恢复账”的总览
- 不重复 30 页对连接告警、后台任务与 ownership 的运行态面
- 不重复 50 页对 CCR v2 worker init / keep_alive / self-exit 的生命周期合同

还要再补一句 signer 纪律：

- 这六类对象都只是远端运行态投影面
- 它们最多触发怀疑，不直接签 current truth、continue verdict 或 recovery authority

## 第一层：`worker_status` 只回答“当前大相位是什么”，不回答具体卡点

### `SessionState` 本身只有三态

`sessionState.ts` 把会话相位压成非常少的三种：

- `idle`
- `running`
- `requires_action`

`notifySessionStateChanged(...)` 则是这条主线的单点推进器。

`CCRClient.reportState(...)` 把它上报成：

- `worker_status`

`replBridgeTransport.ts` 的注释也写得很清楚：

- `requires_action` 的意义是告诉后端现在有 permission prompt 在等输入
- 让远端能显示 “waiting for input”

这说明 `worker_status` 回答的问题不是：

- 现在究竟在编辑哪个文件
- 阻塞问题长什么样
- 这一轮中途进度是什么

而是：

- 当前粗粒度处在 running 还是 requires_action

### 所以 `worker_status` 不是完整运行态

更准确的区分是：

- `worker_status`：粗粒度 phase
- 其他面：解释 phase 的具体上下文

所以 first reject path 也该先固定成：

1. 别把 `worker_status` 当完整运行态
2. 别把 `requires_action_details / pending_action` 当 phase signer
3. 别把 `task_summary / post_turn_summary` 当恢复主账
4. 真要判 signer，退回 current-truth / restore / writeback 层

只要这一层没拆开，正文就会把：

- “当前是 requires_action”
- “当前到底卡在哪个工具请求上”

写成同一件事。

## 第二层：`requires_action_details` 是阻塞上下文，不是自由形态的前端 JSON

### typed details 专门服务“阻塞时我该知道什么”

`sessionState.ts` 对 `RequiresActionDetails` 的注释写得非常明确：

- downstream surfaces 需要知道会话是被什么阻塞
- 而不是只知道它 blocked 了

这份对象里的核心字段是：

- `tool_name`
- `action_description`
- `tool_use_id`
- `request_id`

`CCRClient.reportState(...)` 里也会把它单独映射成：

- `requires_action_details`

这说明它回答的问题不是：

- 前端要不要自由迭代 JSON 结构

而是：

- 在 `requires_action` 这个相位下，给远端一份 typed block context

### 所以 `requires_action_details` 与 `pending_action` 不是同一条 surface

更准确的区分是：

- `requires_action_details`：typed、窄、用于表达阻塞上下文
- `pending_action`：更宽、更自由、给前端读完整 JSON

只要这一层没拆开，正文就会把：

- typed block context
- queryable JSON mirror

写成同一种载体。

## 第三层：`external_metadata.pending_action` 是可查询 JSON 镜像，不是第二份 `worker_status`

### 它的目标是给前端更自由的读取面

`sessionState.ts` 里专门解释了两条 delivery path：

- `tool_name + action_description` 走 typed `RequiresActionDetails`
- full object 走 `external_metadata.pending_action`

而且还特别写明：

- 前端会读 `pending_action.input`
- 这样就能解析问题选项、plan 内容
- 不必回头扫描整条 event stream

这说明 `pending_action` 回答的问题不是：

- 会话现在是不是 running

而是：

- 当前阻塞对象的完整 JSON 上下文，远端前端能否直接读取

### 它还会在脱离阻塞态时被显式清空

`notifySessionStateChanged(...)` 在：

- `requires_action` 且有 `details`

时写入：

- `pending_action: details`

而一旦回到非阻塞态，又会通过：

- `pending_action: null`

把它清掉。

这说明它不是：

- 与 phase 无关的长期 metadata

而是：

- 阻塞态期间的 queryable block context

## 第四层：`task_summary` 讲的是“这一轮现在在做什么”，不是“当前卡住了什么”

### 它属于 mid-turn progress，不属于 phase 主状态

`sessionState.ts` 把 `task_summary` 写得很清楚：

- 这是 forked summarizer 中途写出的 progress line
- 长任务时能提前显示“现在在做什么”
- 到 `idle` 时必须清空，避免下一轮误看见上一轮进度

这说明 `task_summary` 回答的问题不是：

- 当前是不是需要用户输入

而是：

- 当前这一轮中途进展到了哪一步

### 所以 `task_summary` 与 `pending_action` 不是同一种“当前动作”

更准确的区分是：

- `pending_action`：当前被什么阻塞、等什么输入
- `task_summary`：当前还在跑时，正在做什么

只要这一层没拆开，正文就会把：

- “正在进行中的步骤”
- “当前阻塞原因”

写成同一种状态。

## 第五层：`post_turn_summary` 是回合后观察面，不是 mid-turn progress

### 它的位置在“这一轮结束以后”

`SessionExternalMetadata` 里把：

- `post_turn_summary`

和：

- `task_summary`

并列放着，本身已经说明这两者都属于观察面，而不是 phase 主状态。

但二者时间尺度不同：

- `task_summary`：turn 内中途进度
- `post_turn_summary`：turn 结束后的总结

这也和能力地图那页的总论一致：

- `task_summary` / `post_turn_summary` 属于观察层，不是恢复主账

### 所以 `task_summary` 与 `post_turn_summary` 不能写成同一个摘要字段

更准确的理解应是：

- 一个解决 mid-turn visibility
- 一个解决 post-turn recap

只要这一层没拆开，正文就会把：

- 长任务进行中的“现在在做什么”
- 一轮结束后的“刚刚做了什么”

压成同一种 summary。

## 第六层：`session_state_changed` 事件流是给非 CCR 消费方的广播，不是再造一份 worker state

### SDK 事件流关心的是 authoritative turn-over signal

`sdkEventQueue.ts` 里对 `session_state_changed` 的注释写得很硬：

- CCR bridge 自己已经通过另一条 listener 收到这份状态
- SDK consumers 仍需要这条事件，才能知道 main turn 是 idle 还是 generating
- 尤其 `idle` 是 authoritative “turn is over” signal

`notifySessionStateChanged(...)` 也明确说明：

- 这条 SDK 事件是 opt-in 的
- 主要为了 non-CCR consumers，比如 `scmuxd`、VS Code

这说明 `session_state_changed` 回答的问题不是：

- 远端 Web / mobile 的 worker state 应该怎么存

而是：

- 非 CCR 宿主怎样在事件流上知道 turn 已结束或正在运行

### 所以它与 `worker_status` 不是冗余双写

更准确的区分是：

- `worker_status`：CCR worker state surface
- `session_state_changed`：SDK event stream broadcast

只要这一层没拆开，正文就会把：

- 远端状态存储
- 事件流广播

写成同一种 delivery channel。

## 第七层：同一个 `requires_action`，不同消费方读的不是同一份面

### `remoteBridgeCore` 会主动把某些动作推成 `requires_action`

`remoteBridgeCore.ts` 在：

- `can_use_tool` control request

时会主动：

- `transport.reportState('requires_action')`

在：

- `control_response`
- `control_cancel_request`

之后，又会主动：

- `transport.reportState('running')`

这说明至少在 remote bridge path 里，`worker_status` 有一条显式的控制合同：

- 远端权限请求期间进入 requires_action
- 本地解决后回到 running

### 但同一时刻，前端还可能读 `pending_action.input`

`RequiresActionDetails.input` 的注释已经说明：

- frontend 会直接读 `external_metadata.pending_action.input`

去解析问题选项或 plan 内容。

因此更稳的理解应是：

- 同一个阻塞瞬间
- 后端/列表页/通知面可能主要读 `worker_status` 和 typed details
- 前端细粒度交互面则会继续读 `pending_action` JSON

这正是为什么这些面不该被压成一个字段。

## 第八层：稳定、条件与内部三层要分开保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `idle / running / requires_action`、远端 waiting-for-input、mid-turn `task_summary`、post-turn summary 作为观察面 |
| 条件公开 | `requires_action_details`、`external_metadata.pending_action`、`session_state_changed` 事件、`pending_action.input` 的前端解析面 |
| 内部/实现层 | metadata listener wiring、具体事件 subtype、Datadog / proto 路径、是否发 `session_state_changed` 的 env gate |

这里尤其要避免两种写坏方式：

- 把会话真相层总览再抄成一遍“运行态大全”
- 把 phase、block context、mid-turn progress 与 event delivery 写成同一个状态字段

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `worker_status` = `pending_action` | 一个是粗粒度相位，一个是阻塞 JSON 上下文 |
| `requires_action_details` = `pending_action` | 一个 typed、一个 queryable JSON mirror |
| `task_summary` = `pending_action` | 一个讲进度，一个讲阻塞 |
| `task_summary` = `post_turn_summary` | 一个是 mid-turn progress，一个是 post-turn recap |
| `session_state_changed` = `worker_status` | 一个是 SDK 事件广播，一个是 CCR worker state surface |
| 看到 `requires_action` 就知道完整卡点 | 还需要 `requires_action_details` 或 `pending_action` |

## 六个高价值判断问题

- 我现在看到的是 phase、block context、mid-turn progress，还是 post-turn recap？
- 这是通过 worker state PUT 走的，还是通过 SDK 事件流广播的？
- 当前“等待输入”是粗粒度 requires_action，还是具体 pending_action JSON？
- 我是不是又把 `task_summary` 和阻塞原因写成了同一个“当前动作”？
- 我是不是又把 `session_state_changed` 和 `worker_status` 写成了同一种投影？
- 我是不是又把能力地图里的总览页重写成一篇控制面长文？

## 源码锚点

- `claude-code-source-code/src/utils/sessionState.ts`
- `claude-code-source-code/src/cli/transports/ccrClient.ts`
- `claude-code-source-code/src/cli/remoteIO.ts`
- `claude-code-source-code/src/utils/sdkEventQueue.ts`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts`
