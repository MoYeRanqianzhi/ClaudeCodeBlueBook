# `initialize`、`can_use_tool`、`control_response`、`control_cancel_request` 与 `result`：为什么 remote bridge 的握手、提问、作答、撤销与回合收口不是同一种状态交接

## 用户目标

不是只知道 remote bridge / remote session 里“会收到权限提问、能回 allow/deny、偶尔还会 cancel，最后还有 result”，而是先分清六类不同控制动作：

- 哪些是在刚接上 session 时必须先完成的初始化握手。
- 哪些是在把单次工具权限问题正式抛给远端。
- 哪些是在对那次问题给出真实 verdict。
- 哪些不是 verdict，而是在另一条路径已经赢了以后把悬挂 prompt 收口。
- 哪些是在一轮结束时把整条会话从 `running` / `requires_action` 正式落回 `idle`。
- 哪些在某些上下文里必须回错，不能假装成功。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“远端控制动作”：

- `initialize`
- `can_use_tool`
- `control_response`
- `control_cancel_request`
- `result`
- `requires_action / running / idle`

## 第一性原理

remote bridge 里的控制动作至少沿着五条轴线分化：

1. `Lifecycle Position`：当前是在 session 握手、单次提问、单次作答、撤销旧 prompt，还是回合收口。
2. `Decision Object`：当前在处理的是一次工具权限、一次会话级控制、还是一轮执行的最终收口。
3. `Phase Effect`：当前动作会把远端推进到 `requires_action`、拉回 `running`，还是落到 `idle`。
4. `Truthfulness`：当前上下文里应该回 `success`，还是必须明确回 `error`，避免假成功。
5. `Recovery Window`：当前动作是在稳定链路上生效，还是正处于 auth recovery 窗口里，宁可丢弃也不能半应用。

因此更稳的提问不是：

- “这不都是 control message 吗？”

而是：

- “当前动作是在完成握手、发起提问、返回答案、撤销旧 prompt，还是结束整轮；它会把远端 phase 推到哪里，又该不该在当前上下文里真实失败？”

只要这五条轴线没先拆开，正文就会把 `initialize`、`can_use_tool`、`control_response`、`control_cancel_request` 与 `result` 写成同一种远端控制。

这里也要主动卡住一个边界：

- 这页讲的是这组 control / result 动作对 phase handoff 的推动合同
- 不重复 29 页对 control object 分类与 safe commands 的总览
- 不重复 40 页对审批竞态、hook/classifier 与 `control_cancel_request` 竞态来源的拆分
- 不重复 51 页对 `worker_status`、`pending_action`、`session_state_changed` 等运行态投影面的说明
- 不重复 54 页对 auth recovery、transport rebuild 与 flush 边界的主线

## 第一层：`initialize` 是 session 握手，不是一次权限答案

### 它解决的是“这条控制链能否先站住”，不是“某个工具能否执行”

`bridgeMessaging.ts` 对 `handleServerControlRequest(...)` 的注释写得很硬：

- 服务器会发 session lifecycle 的 `control_request`
- 如果不及时响应，服务器会一直等，最后 kill WS

而 `initialize` 分支回的内容也很窄：

- `commands: []`
- `output_style`
- `models: []`
- `account: {}`
- `pid`

这说明它回答的问题不是：

- 这次工具调用允许还是拒绝

而是：

- 这条 bridge 控制链是否已经完成最小握手，可以继续活下去

### 所以 `initialize` 不应和 allow/deny 写成同一种“远端回复”

更准确的理解应是：

- `initialize`：session lifecycle handshake
- `control_response` for permission：单次问题 verdict

只要这一层没拆开，正文就会把：

- 握手成功
- 工具批准成功

写成同一个动作。

## 第二层：`can_use_tool` 是真实 pending ask，会把远端状态推进到 `requires_action`

### 它不是被动通知，而是“我现在真的在等远端回答”

`remoteBridgeCore.ts` 在发送 `control_request` 时有一条很关键的分支：

- 若 `request.request.subtype === 'can_use_tool'`
- 先 `transport.reportState('requires_action')`
- 再把 request 发出去

这说明它回答的问题不是：

- “远端现在大概知道本地在等输入”

而是：

- “这条 session 现在被一个未决权限问题阻塞了”

### 远端消费方也把它当成 pending request，而不是普通消息

`RemoteSessionManager.ts` 收到 `control_request` 后会：

- 若 subtype 是 `can_use_tool`
- 放进 `pendingPermissionRequests`
- 调 `onPermissionRequest(...)`

这说明在消费方那里，它也不是：

- 普通 transcript event

而是：

- 一条需要明确回答的 pending ask

### 所以 ask 的第一性原理是“推进到 requires_action 并等待 verdict”

更准确的理解应是：

- `can_use_tool`：pending ask
- `requires_action`：这个 ask 对远端 phase 的投影

只要这一层没拆开，正文就会把：

- “远端看到一个权限提示”
- “远端进入 waiting for input”

写成两件互不关联的事。

## 第三层：`control_response` 是对 ask 的真实作答，不是 prompt 收口，更不是回合结束

### 它回答的是“这个问题现在怎么判”，不是“这个 prompt 该不该从界面消失”

`RemoteSessionManager.respondToPermissionRequest(...)` 会把本地决定编码成：

- `type: 'control_response'`
- `subtype: 'success'`
- `response.behavior = allow | deny`

而 bridge 侧 `handleServerControlRequest(...)` 也在 session-level request 上坚持：

- 能做就回 `success`
- 做不到就回 `error`

这说明 `control_response` 的第一性原理是：

- 对当前 request 给出 truthful verdict

而不是：

- 把所有界面状态一并收干净

### 在 bridge state handoff 里，它还负责把 phase 拉回 `running`

`remoteBridgeCore.ts` 的 `sendControlResponse(...)` 会：

- 先 `transport.reportState('running')`
- 再写出 `control_response`

这说明它回答的问题还包括：

- “远端不再卡在 waiting for input，可以恢复运行”

### 所以 `control_response` 不是 cancel，也不是 result

更准确的区分是：

- `control_response`：回答 ask，并恢复 `running`
- `control_cancel_request`：收掉 stale prompt
- `result`：把整轮正式收口到 `idle`

只要这一层没拆开，正文就会把：

- 回答问题
- 清理旧 prompt
- 结束整轮

写成同一个“远端回复”。

## 第四层：`control_cancel_request` 是 stale prompt teardown，不是 deny

### 它解决的是“这边已经有结果了，另一边别再等了”

`remoteBridgeCore.ts` 的 `sendControlCancelRequest(...)` 注释写得很清楚：

- 某些本地路径只会 `cancelRequest`
- 不会再 `sendResponse`
- 如果不显式 cancel，服务端会一直停在 `requires_action`

而 `StructuredIO.injectControlResponse(...)` 也说明：

- bridge 把来自 claude.ai 的答案注进 SDK permission flow 时
- 还会额外写一个 `control_cancel_request`
- 否则 SDK consumer 那侧的 `canUseTool` callback 会一直挂着

这说明它回答的问题不是：

- 用户刚刚拒绝了这个权限请求

而是：

- 这条未决 prompt 现在已经失效，输掉竞态的一侧该闭嘴了

### 它同样会把 phase 拉回 `running`

`remoteBridgeCore.ts` 在发送 `control_cancel_request` 前也会：

- `transport.reportState('running')`

所以它和 `control_response` 的共同点是：

- 都能结束 `requires_action`

但它们结束 `requires_action` 的原因并不一样：

- 一个是给出 verdict
- 一个是撤销 stale prompt

只要这一层没拆开，正文就会把 `cancel` 写成另一种 `deny`。

## 第五层：`result` 是回合收口 bookend，不是另一种 `control_response`

### 它回答的是“这整轮现在真的结束了”

`bridgeMessaging.ts` 的 `makeResultMessage(...)` 明确把 `result` 作为：

- minimal `SDKResultSuccess`
- 用于 session archival

而 `remoteBridgeCore.ts` 的 `sendResult()` 也会：

- 先 `transport.reportState('idle')`
- 再写出 `result`

这说明它回答的问题不是：

- 某个 pending ask 现在怎样判

而是：

- 这一轮执行是否已经正式收口，可以落回 `idle`

### `print.ts` 也把 control messages 与最终 result 分开看待

`print.ts` 在维护最后结果面时明确排除了：

- `control_request`
- `control_response`
- `control_cancel_request`

这说明在主回合收口语义上：

- control trio 不是最终 result

更准确的理解应是：

- ask / answer / cancel：控制面中途动作
- `result`：回合 bookend

只要这一层没拆开，正文就会把“批准收口”和“回合收口”写成同一种结束。

## 第六层：truthful error 比假成功更重要，尤其在 outbound-only 与不支持的上下文里

### mutable request 在 outbound-only 里必须回错，不能装作成功

`handleServerControlRequest(...)` 对 outbound-only 的分支写得很清楚：

- `initialize` 仍要成功
- 其他 mutable request 一律回 `error`
- 否则 claude.ai 会看到 false success

这说明它回答的问题不是：

- “先回 success，后面再说”

而是：

- 当前上下文根本不具备控制权时，协议必须诚实失败

### remote-session client 也只把 `can_use_tool` 当成一等公民

`RemoteSessionManager.handleControlRequest(...)` 里：

- `can_use_tool` 会进入 pending permission flow
- 其他 subtype 会直接发 `error`
- 目的是别让 server 永远等不到回复

所以更准确的理解应是：

- truthful error 也是控制合同的一部分
- 不是所有收到的 `control_request` 都该被假装处理成功

只要这一层没拆开，正文就会把：

- 支持这个动作
- 不支持但也回了个 success

写成同一种“远端可以控制”。

## 第七层：auth recovery 窗口里，这组动作会被故意丢弃，而不是半应用

### 恢复期间宁可短暂不可控，也不沿旧链路半提交

`remoteBridgeCore.ts` 在 `authRecoveryInFlight` 期间会直接 drop：

- `control_request`
- `control_response`
- `control_cancel_request`
- `result`

这说明它回答的问题不是：

- 所有控制动作都该排队补发

而是：

- 控制面与回合收口动作如果沿旧链路半应用，代价比短暂不可用更大

### 所以这是 control-plane 的条件开放面，不是 transport continuity 主线

更准确的理解应是：

- 稳定链路上：这组动作推动 state handoff
- recovery 窗口里：这组动作临时不可用，避免语义污染

只要这一层没拆开，正文就会把控制动作 availability 与 transport rebuild 主线写成同一件事。

## 第八层：stable、conditional 与 internal 三层要分开保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `can_use_tool` 会把远端推进到 `requires_action`；`control_response` 与 `control_cancel_request` 会把它带回 `running`；`result` 会把整轮落到 `idle` |
| 条件公开 | `initialize` 是必须及时回的握手；outbound-only 与 unsupported subtype 会回 `error` 而不是假成功；auth recovery 期间这组 control / result 动作会被故意 drop |
| 内部/实现层 | server kill WS 的具体超时、callback wiring、raw control message normalization、`pendingRequests` 的具体存储实现 |

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `initialize` = 一次权限批准 | 一个是握手，一个是单次 verdict |
| `can_use_tool` = 被动通知 | 它是真 pending ask，会推进到 `requires_action` |
| `control_response` = prompt 已经清干净 | 它首先是作答，不等于 stale prompt teardown |
| `control_cancel_request` = deny | 它是撤销 stale prompt，不是 verdict |
| `result` = 另一种 `control_response` | 它是回合收口 bookend |
| unsupported / outbound-only 也可以回 success | 这会制造 false success，协议要求真实回错 |

## 七个检查问题

- 当前动作是在握手、提问、作答、撤销 stale prompt，还是结束整轮？
- 这个动作会把远端 phase 推到 `requires_action`、`running`，还是 `idle`？
- 这里返回的是 verdict，还是只是 prompt teardown？
- 当前上下文真的支持这个控制动作吗，还是必须诚实回错？
- 当前讲的是控制面 state handoff，还是第 51 页的运行态投影？
- 当前讲的是稳定链路上的控制动作，还是第 54 页 recovery 窗口里的临时不可用？
- 我是不是又把 ask / answer / cancel / result 压成同一种远端回复了？

## 源码锚点

- `claude-code-source-code/src/bridge/bridgeMessaging.ts`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/cli/structuredIO.ts`
- `claude-code-source-code/src/cli/print.ts`
