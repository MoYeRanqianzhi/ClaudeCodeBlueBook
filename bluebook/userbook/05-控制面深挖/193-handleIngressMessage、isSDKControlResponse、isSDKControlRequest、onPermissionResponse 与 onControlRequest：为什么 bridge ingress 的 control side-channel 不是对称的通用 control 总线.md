# `handleIngressMessage`、`isSDKControlResponse`、`isSDKControlRequest`、`onPermissionResponse` 与 `onControlRequest`：为什么 bridge ingress 的 control side-channel 不是对称的通用 control 总线

## 用户目标

29 已经把远端控制面拆成：

- 权限提示响应回路
- 会话级控制请求
- bridge-safe command 白名单

191 又把 `handleIngressMessage(...)` 继续拆成：

- control bypass
- echo drop
- replay guard
- non-user ignore

但如果正文停在这里，读者还是很容易把 ingress 上的 control side-channel 再写平：

- 既然 `control_response` 和 `control_request` 都在同一条 ingress socket 上，不就是一对对称的 control bus 吗？
- `onPermissionResponse` 和 `onControlRequest` 不也都是“收到控制帧后回调一下”？
- env-based 和 env-less 都把这两类帧喂进同一个 `handleIngressMessage(...)`，那它们的 control 语义不就相同？
- `control_response` 既然名字叫 response，为什么不能把它当成 generic reply 面？

这句还不稳。

从当前源码看，至少还要继续拆开两条天然不对称的 callback leg：

1. `control_response -> onPermissionResponse`
2. `control_request -> onControlRequest -> handleServerControlRequest(...)`

而且这页之后还会继续长出一个更窄的后继问题：

- `193` 先回答 control side-channel 为什么不对称
- `206` 再回答同样会出现 `can_use_tool`，为什么 bridge 仍只发布裸 blocked bit，而不自动携带完整 `pending_action`

如果这两腿不先拆开，后面就会把：

- `control_response`
- `control_request`
- `onPermissionResponse`
- `onControlRequest`
- `handleServerControlRequest(...)`

重新压成一句模糊的“bridge 的 control 总线”。

## 第一性原理

更稳的提问不是：

- “为什么 ingress 上的 control 帧不是统一总线？”

而是先问六个更底层的问题：

1. 当前这条 control 帧是在把某个远端 verdict 送回本地，还是在要求本地立刻执行一个会话级动作？
2. 当前 callback 消费的是“已经挂起的 request_id”，还是“按 subtype 分发的新请求”？
3. 当前回调的第一性原理是恢复某个 pending permission race，还是修改当前 session 的运行状态？
4. 当前 control 帧若没有消费者，会导致 verdict 丢失，还是会导致 server-side request 超时？
5. env-less 在这条腿上额外补的是状态修复，还是新的 control taxonomy？
6. 我现在分析的是 29 的 control 对象家族，还是 ingress demux 之后 callback 为什么已经不对称？

只要这六轴不先拆开，后面就会把：

- permission verdict
- session control
- callback ownership

混成一张“control 表”。

## 第一层：`control_response` 在 ingress 上先不是 generic reply，而是 permission verdict 返回腿

`bridgeMessaging.ts` 的 `handleIngressMessage(...)` 一进来就先检查：

- `isSDKControlResponse(parsed)`

命中后立刻：

- `onPermissionResponse?.(parsed)`
- `return`

这一步没有：

- subtype 分发
- generic control router
- `handleServerControlRequest(...)`

它先回答的问题是：

- 这是不是某个已经挂起的 permission 请求的返回 verdict

而不是：

- 这是不是一条通用 control reply，可以继续进入统一 control 总线

更关键的是，hook 侧的 `handlePermissionResponse(...)` 也把这层语义写死了：

- 先从 `msg.response.request_id` 找 `pendingPermissionHandlers`
- 找不到 handler 就直接记日志并返回
- 只接受 `inner.subtype === 'success'`
- 只在 `inner.response` 通过 `isBridgePermissionResponse(...)` 时才真正回调

这说明 `onPermissionResponse` 的真实身份不是：

- “所有 `control_response` 的通用消费者”

而是：

- “pending permission request_id` 对应的 verdict dispatcher”

所以更准确的理解不是：

- ingress 上存在一条对称的 `control_response` 总线

而是：

- ingress 上的 `control_response` 被硬编码成 permission verdict 返回腿

## 第二层：`control_request` 才是 session-control 请求腿，而且它必须尽快回包

同一个 `handleIngressMessage(...)` 在 `control_response` 之后再检查：

- `isSDKControlRequest(parsed)`

命中后做的是：

- `onControlRequest?.(parsed)`
- `return`

这里的注释也写得很硬：

- `initialize`
- `set_model`
- `can_use_tool`
- 必须尽快响应，否则 server 会在约 10-14 秒后杀掉 WebSocket

这说明 `control_request` 回答的问题是：

- server 现在要求本地立刻处理某个新的 control action

而不是：

- 某个旧请求的 verdict 正在返回

`replBridge.ts` 里这条腿又继续被收窄成：

- `onServerControlRequest = request => handleServerControlRequest(request, ...)`

`remoteBridgeCore.ts` 也一样，只是多了：

- `outboundOnly`
- env-less transport/context

所以更准确的理解不是：

- `control_request` 和 `control_response` 只是名字不同、消费方式相同

而是：

- `control_request` 是通用 session-control 请求腿
- `control_response` 不是

## 第三层：`handleServerControlRequest(...)` 证明真正通用的 control bus 只存在于 request 腿

`bridgeMessaging.ts` 的 `handleServerControlRequest(...)` 里真正分发的是：

- `initialize`
- `set_model`
- `set_max_thinking_tokens`
- `set_permission_mode`
- `interrupt`
- default error

而且无论成功还是失败，最终都会生成：

- `control_response`

写回 transport。

这一步才是通用 control executor。

它负责把：

- inbound `control_request`

翻译成：

- 本地会话状态变化
- 或带 `request_id` 的 error/success 回包

所以系统里的“通用 control bus”并不在：

- `control_response -> onPermissionResponse`

而在：

- `control_request -> onControlRequest -> handleServerControlRequest(...)`

这也是为什么：

- `set_model`
- `set_permission_mode`
- `interrupt`

都挂在 request 腿上，

而不是：

- 让 `onPermissionResponse` 再统一解释一遍 `control_response`

## 第四层：hook 侧也把两腿消费成不同对象，根本不是统一 callback 面

`useReplBridge.tsx` 里 permission callbacks 的组装已经把两腿分成不同对象：

- `sendRequest(...)` 会发出 `control_request`，其中 `subtype = 'can_use_tool'`
- `sendResponse(...)` 会把 bridge permission decision 包进 `control_response`

这说明 permission 回路的第一性原理是：

- 以 `request_id` 为键的竞态裁决

不是：

- 统一 session-control 调度

同一个 hook 里，真正作用于 session state 的却是另一套 callback：

- `onInterrupt`
- `onSetModel`
- `onSetMaxThinkingTokens`
- `onSetPermissionMode`

这些 callback 最后都只通过：

- `handleServerControlRequest(...)`

那条 request 腿进入。

所以更准确的理解不是：

- hook 把所有 control 帧都交给一套统一处理器

而是：

- hook 把 permission verdict 和 session-control request 分别交给两套完全不同的消费者

## 第五层：env-less 没有把两腿重新对称化，它只给 permission leg 套了一层状态修复壳

`remoteBridgeCore.ts` 的 ingress wiring 看上去和 v1 很像：

- 仍然把 `control_response` 交给 `onPermissionResponse`
- 仍然把 `control_request` 交给 `handleServerControlRequest(...)`

但它在 permission leg 上又额外做了一层包装：

- `transport.reportState('running')`
- 然后才 `onPermissionResponse(res)`

注释也写明原因：

- remote client 回答权限提示后，turn 要恢复 running
- 否则 server 会一直停在 `requires_action`

这说明 env-less 加的不是：

- 新的 control taxonomy

而是：

- permission verdict 返回腿的状态修复壳

它没有把两腿重新变成一条对称总线，

反而进一步证明：

- permission leg 的职责是恢复 pending permission turn
- request leg 的职责是处理通用 session control

## 第六层：这页不是 29，也不是 142，更不是 191

这页最容易和三篇旧文混写。

先和 29 划清：

- 29 讲的是 control object family：权限提示、会话控制、命令白名单不是同一对象
- 193 讲的是 ingress demux 之后，这些 control frame 落到哪条 callback 腿上

29 的主语是：

- control 对象类型

193 的主语是：

- callback ownership

再和 142 划清：

- 142 讲的是 `outboundOnly` 有没有一路传到底层 wiring
- 193 讲的是一旦 wiring 已经成立，ingress control frame 自身怎么分成两条不对称 callback leg

142 的主语是：

- gray runtime topology

193 的主语是：

- control side-channel callback asymmetry

最后和 191 划清：

- 191 停在 `control bypass` 这一层，说明 control payload 不进入 SDK message consumer
- 193 从 bypass 之后继续问：为什么 bypass 不是统一 control bus，而是直接裂成 permission verdict leg 与 session-control leg

191 的主语是：

- control 为什么先绕开 message consumer

193 的主语是：

- 绕开之后两腿为什么不对称

如果把这三层重新压平，就会把：

- control taxonomy
- control wiring
- control callback ownership

又写成一句模糊的“bridge 的 control 面”。

## 第七层：稳定 / 条件 / 灰度保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `control_response` = permission-verdict 返回腿；`control_request` = session-control 请求腿；它们共用 ingress socket，不等于共用同一条 control 总线 |
| 条件公开 | permission leg 只有在本地还挂着 pending verdict 时才真正被消费；env-less 额外那层 `reportState('running')` 只是特定宿主上的状态修复壳；server-side control 请求还受 subtype 与当前会话状态约束 |
| 内部/灰度层 | `pendingPermissionHandlers`、`request_id` 查找顺序、env-less 的 repair wrapper、具体 callback wiring 与日志分支都只是证明 callback asymmetry 的证据，不是稳定公共合同 |

## 结论

更稳的一句应该是：

- bridge ingress 的 `control_response` 从来不是和 `control_request` 对称的通用 reply 总线
- 它被硬编码成 `request_id -> pendingPermissionHandlers` 的 permission verdict 返回腿
- 真正通用的 session-control bus 只存在于 `control_request -> onControlRequest -> handleServerControlRequest(...)` 这条腿
- env-less 只是再给前者套了一层 `running` 状态修复壳

一旦这句成立，就不会再把：

- `onPermissionResponse`
- `onControlRequest`
- `handleServerControlRequest(...)`

写成同一种 callback。
