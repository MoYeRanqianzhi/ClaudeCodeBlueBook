# `outboundOnly`、`useReplBridge`、`initBridgeCore`、`handleServerControlRequest`、`handleIngressMessage` 与 `createV2ReplTransport`：为什么 hook 已经在 mirror，本体运行时却仍可能落成 gray runtime

## 用户目标

139 已经把 mirror 这条线拆成：

- startup intent
- implementation routing
- runtime topology

并说明这三层不是同一层合同。

但如果继续往下不补这一页，读者还是很容易把结论停在一半：

- “mirror gate 和 env-less gate 不是同一层，所以有灰度。”

这句话方向对，

但还不够具体。

因为它还没有回答最关键的下一问：

- 当本地 hook 已经按 mirror 语义在跑时，底层 runtime 到底会在哪一层开始分叉？

从当前源码看，至少存在一种很具体的 gray runtime：

- hook 侧已经按 `outboundOnly` 压薄本地 surface
- 但 env-based core 仍然保留 inbound message / control / permission 相关双向 wiring

所以这页要补的不是：

- “mirror 有灰度”

而是：

- “为什么 hook 已经在 mirror，本体运行时却仍可能落成 gray runtime”

## 第一性原理

更稳的提问不是：

- “mirror 现在到底算不算生效？”

而是先问五个更底层的问题：

1. 本地 hook 现在在依据什么做 mirror 分支，是 startup intent，还是 runtime topology？
2. 哪些本地 surface 会因为 `outboundOnly` 被主动压薄？
3. 底层 core 是否也拿到了 `outboundOnly`，并据此关闭双向 ingress / control？
4. 如果 core 没拿到这个参数，仍然保留了哪些双向 wiring？
5. 因此出现的“gray runtime”到底是 UI 误差，还是一条真实的语义分叉？

只要这五轴先拆开，这一页就不会再停在一句泛泛的：

- “mirror 有灰度”

## 第一层：`useReplBridge()` 在本地先按 `outboundOnly` 压薄 surface，这一步并不等 core 已兑现 mirror topology

`useReplBridge.tsx` 里，`handleStateChange(...)` 一旦发现：

- `outboundOnly`

就会进入单独分支。

这个分支当前只做非常薄的一层本地语义：

- `failed` -> `replBridgeConnected = false`
- `ready/connected` -> `replBridgeConnected = true`

不会继续维护：

- `replBridgeSessionActive`
- `replBridgeReconnecting`
- `replBridgeSessionUrl`
- `replBridgeConnectUrl`
- `replBridgeEnvironmentId`

初始化成功后的分支也延续了同一种压薄：

- 只写 `replBridgeConnected`
- 写 `replBridgeSessionId`
- 主动清空 `replBridgeSessionUrl` / `replBridgeConnectUrl`

所以从 hook / AppState / UI 这一层看，

mirror 已经开始生效。

但这一步回答的只是：

- local surface semantics

不是：

- 底层 runtime topology 一定已经同层兑现

## 第二层：本地 hook 还会因为 `outboundOnly` 主动切掉 permission callbacks 与 transcript status

`useReplBridge.tsx` 继续往下看，

这种本地 mirror 语义压缩不只发生在 connected bit。

非-outboundOnly 分支才会：

- 建 `replBridgePermissionCallbacks`
- 写 `replBridgeSessionUrl`
- 追加 transcript `createBridgeStatusMessage(...)`

也就是说，一旦 hook 进入 outboundOnly 语义，

本地前台已经开始表现为：

- 没有 permission callback chain
- 没有 transcript bridge status
- 没有 URL / QR 那套 surface

这会让读者很容易自然推断：

- “底层现在肯定也是一个纯 outbound-only runtime”

但这一步还只是 hook side 的推断，

并不是 core side 的证明。

## 第三层：真正的 outboundOnly runtime 兑现点，在 `bridgeMessaging.ts` 和 transport 层，不在 hook 层

要让系统真正落成 pure outbound-only runtime，

至少要满足两件事：

### control-side 要被收窄

`bridgeMessaging.ts` 里只有拿到：

- `outboundOnly`

时，才会对非 `initialize` 的 `control_request` 直接回 error。

### read-side 要被切掉

`createV2ReplTransport(...)` 里只有拿到：

- `outboundOnly`

时，才会：

- skip `sse.connect()`

也就是切掉 read-side SSE stream。

所以真正的 mirror runtime 不是：

- hook 把 UI 压薄就算数

而是：

- core / transport 也必须真的消费 `outboundOnly`

## 第四层：问题就出在 env-based core 当前没有吃到这层 `outboundOnly`

`initReplBridge.ts` 这里是这页的核心证据。

### env-less branch

它会把：

- `outboundOnly`

传给：

- `initEnvLessBridgeCore(...)`

所以 env-less 路径里，

hook 语义和 core 语义有机会对齐。

### env-based branch

它最终调用的是：

- `initBridgeCore({...})`

当前这个 delegate 参数面里并没有：

- `outboundOnly`

这就意味着一旦 mirror startup intent 回落到 env-based core，

本地 hook 的 outboundOnly 语义和底层 core 的入参已经分叉。

## 第五层：env-based core 仍然 wiring `handleServerControlRequest`，这与 pure outboundOnly runtime 不同

`replBridge.ts` 的 env-based core 当前仍然会：

- 构造 `onServerControlRequest`
- 把它接进 `handleServerControlRequest(...)`

而且在这次 wiring 里并没有传：

- `outboundOnly`

这意味着 env-based core 并没有自动继承：

- outbound-only error response 语义

所以只要请求能走到这里，

系统仍然保留的是：

- 双向 control contract

而不是：

- mirror-only control contract

## 第六层：env-based core 也仍然 wiring `handleIngressMessage(...)`，这与 read-side 被切掉也不是一回事

同一个 `replBridge.ts` 里，

env-based core 还会继续：

- `newTransport.setOnData(...)`
- 在里面调用 `handleIngressMessage(...)`
- 并把 `onInboundMessage`
- `onPermissionResponse`
- `onServerControlRequest`

都接进去。

这说明 env-based core 当前仍然保留：

- inbound message 链
- permission response 链
- server control request 链

而这正是 pure outboundOnly runtime 本来想砍掉的一整半。

所以 gray runtime 不是想象出来的，

而是源码 wiring 层就已经存在的一种分叉：

- hook side muted
- core side still bidirectional

## 第七层：如果 env-based core 又恰好继续选了 `createV2ReplTransport(...)`，灰度会更隐蔽

这一步也是最容易被漏掉的。

因为很多人会把灰度态写成：

- “本地像 mirror，底层像 v1。”

但 `replBridge.ts` 当前在 env-based orchestration 下仍可能判断：

- `useCcrV2`

然后继续走：

- `createV2ReplTransport(...)`

而这次调用又没有 `outboundOnly` 参数。

于是就会出现一种更隐蔽的情况：

- transport generation 看起来还是 v2
- 但 runtime semantics 却不是 env-less mirror 那套 outboundOnly topology

这也是为什么 139 里必须把：

- transport version

和：

- runtime topology

拆成两层。

## 第八层：所以 gray runtime 的本质不是“实现还没做完”，而是“本地语义与底层语义不同步”

把前面几层压成一句，更稳的一句是：

- gray runtime = local mirror semantics without guaranteed mirror core semantics

也就是说：

### 本地 hook 现在已经在做的

- 压薄 AppState surface
- 切掉 permission callbacks
- 切掉 transcript bridge status
- 把自己表现成 mirror

### 底层 core 在 env-based fallback 下仍可能做的

- 接收 inbound data
- 处理 permission response
- 处理 server control request
- 甚至继续使用 v2 transport generation

所以这里的 gray 不是：

- “UI 还没做完”

而是：

- “本地语义和底层语义没有同层锁定”

## 第九层：为什么这页不是 139 的重复

139 讲的是：

- startup intent
- implementation routing
- runtime topology

不是同一层合同。

142 讲的是：

- 一旦真的发生了 “hook intent 已 mirror，core 仍 env-based” 这种组合
- gray runtime 在哪几条 wiring 上具体表现出来

一个讲：

- layers are different

一个讲：

- mismatch manifests here

所以 142 不是重写 139，

而是把 139 的抽象结论压成可定位的运行时分叉面。

## 第十层：最常见的四个假等式

### 误判一：只要 UI / AppState 已经像 mirror，底层 runtime 也一定是 pure outbound-only

错在漏掉：

- hook side 和 core side 不是同一条参数面

### 误判二：env-based fallback 最多只是 transport 版本差异，不会影响 control / ingress 语义

错在漏掉：

- env-based core 仍明确 wiring `handleServerControlRequest` / `handleIngressMessage`

### 误判三：gray runtime 只是理论担心，没有实际源码锚点

错在漏掉：

- `useReplBridge` 的 outboundOnly 本地分支
- 与 `replBridge.ts` 的双向 wiring

就在同一仓里并存

### 误判四：只要 transport 最终还是 v2，就等于 mirror 语义也还在

错在漏掉：

- transport generation 和 outboundOnly runtime semantics 不是同一层

## 第十一层：stable / conditional / internal

### 稳定可见

- `useReplBridge()` 当前会因为 `outboundOnly` 主动压薄本地 surface
- env-less branch 当前会真正把 `outboundOnly` 往 core / transport 里传
- env-based core 当前仍保留 `handleServerControlRequest` / `handleIngressMessage` 的双向 wiring

### 条件公开

- gray runtime 最容易出现在 mirror startup intent 已成立、但实现回落到 env-based core 的条件下
- env-based core 下 transport 仍可能是 v2，因此 gray runtime 不必然长得像 “local mirror + old transport”
- 如果将来 env-based delegate 也开始显式接 `outboundOnly`，这层 gray runtime 边界才可能消失

### 内部 / 灰度层

- 当前仓内没有硬约束确保 hook 的 outboundOnly 语义和 core wiring 必然同步
- 是否真的会在所有这些条件下稳定复现 gray runtime，还取决于 rollout / routing 条件
- 这类 mismatch 本身就是一种内部演化带信号，而不是当前公开承诺

## 第十二层：苏格拉底式自审

### 问：我现在写的是本地 UI 语义，还是底层 core 语义？

答：如果答不出来，就会把 gray runtime 写成一句空话。

### 问：我是不是把 env-based fallback 写成了“只是 transport 版本不同”？

答：如果是，就漏掉了双向 ingress / control wiring。

### 问：我是不是因为 hook 已经压薄 surface，就默认底层一定也断开 read-side？

答：如果是，就把 local semantics 和 transport semantics 混了。

### 问：我是不是又回到 139 的 gate/routing 层，而没有真正指出 gray runtime 具体出现在哪？

答：如果是，就还没真正进入 142。

### 问：我是不是把 gray runtime 写成“未来可能会有的 bug”，而没有把它写成当前源码已存在的分叉结构？

答：如果是，就没有把源码证据压实。

## 源码锚点

- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/bridge/initReplBridge.ts`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts`
- `claude-code-source-code/src/bridge/replBridge.ts`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts`
