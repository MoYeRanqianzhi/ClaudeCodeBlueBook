# `ccrMirrorEnabled`、`outboundOnly`、`system/init`、`replBridgeConnected` 与 `sessionUrl/connectUrl`：为什么同属 v2 的 bridge 也不是同一种活跃 front-state surface

## 用户目标

134 已经把 bridge 内部先拆成：

- v1：本地 surface 还在，但 worker-side chain 很薄
- v2：本地 surface + worker-side authoritative chain

但如果继续往下不补这一页，读者还是很容易把 v2 又重新压平：

- “只要走到了 CCR v2 / env-less bridge，前台状态面就已经是同一套，只是开关不同。”

这句还是不稳。

从当前源码看，哪怕同属 v2，

至少也有两种很不一样的活跃 front-state surface：

1. full env-less v2：可见、可交互、可回写的多 surface bridge
2. mirror / outboundOnly：保留 worker-side write chain，但前台可见面被主动压成近乎隐身

所以这页要补的不是：

- “mirror 只是 full bridge 少几个 UI”

而是：

- “为什么同属 v2 的 bridge 也不是同一种活跃 front-state surface”

## 第一性原理

更稳的提问不是：

- “mirror 为什么没有 dialog / transcript status？”

而是先问五个更底层的问题：

1. `outboundOnly` 改变的到底是“有没有 bridge”，还是“哪半条链还活着”？
2. 当前被保留下来的，是 write-side worker chain，还是 read-side / control-side / surface-side chain？
3. 当前 `ready` 和 `connected` 在 env-less v2 下到底点亮了哪些 surface，哪些还没点亮？
4. 当前 `replBridgeConnected`、`replBridgeSessionActive`、`sessionUrl`、`connectUrl` 是不是一起变化？
5. 当前 footer / dialog / transcript 看不见，到底是桥没连上，还是 UI 被显式门控压掉了？

只要这五轴先拆开，`mirror/outboundOnly` 就不会再被写成：

- “full v2 去掉一点 UI”

## 第一层：`mirror` 不是另一套协议，而是启动时就写进 `AppState` 的 outbound-only 拓扑

`main.tsx` 对这层边界写得很清楚：

- `fullRemoteControl` 和 `ccrMirrorEnabled` 是分开的启动意图
- `ccrMirrorEnabled` 只会在不走 full Remote Control 时生效

真正写进 `AppState` 的组合是：

- `replBridgeEnabled = fullRemoteControl || ccrMirrorEnabled`
- `replBridgeExplicit = remoteControl`
- `replBridgeOutboundOnly = ccrMirrorEnabled`

也就是说，mirror 从启动第一刻开始就不是：

- “显式打开的一套前台 Remote Control”

而是：

- “默认打开、implicit、outbound-only 的桥接拓扑”

`bridgeEnabled.ts` 里的注释也直接写明：

- `CCR mirror mode` 是 `outbound-only Remote Control session`

所以 mirror 不是另一条 bridge 产品线，

而是：

- 同一条 bridge hook 下的一种更薄拓扑

## 第二层：`outboundOnly` 当前真正消费的，是 env-less core，而不是整个 bridge 家族的统一合同

`initReplBridge.ts` 这里很关键。

它先区分：

- env-less bridge path
- env-based v1 path

在 env-less path 下，它会把：

- `outboundOnly`

显式传进：

- `initEnvLessBridgeCore(...)`

但落回 env-based v1 path 时，

当前这条 delegate 并没有同样的 `outboundOnly` 参数面。

所以更稳的表述不是：

- “outboundOnly 是整个 bridge 的统一稳定合同”

而是：

- 从当前 wiring 看，outboundOnly 的真实消费中心在 env-less v2 core

这一步很重要，因为它提醒我们：

- “同属 v2”本身已经是条件判断
- “mirror 启动意图”也不等于“任何拓扑都同样兑现 outboundOnly 语义”

## 第三层：`createV2ReplTransport()` 在 outboundOnly 下砍掉的是 read-side，不是 worker-side write chain

`replBridgeTransport.ts` 对 outboundOnly 的说明非常直接：

- skip opening the SSE read stream
- only the CCRClient write path is activated

更具体地说，outboundOnly 下：

- `sse.connect()` 被跳过
- `ccr.initialize(...)` 仍然执行
- heartbeat 仍然存在
- `reportState/reportMetadata/reportDelivery/flush` 这套 v2 写侧能力仍然保留

所以 outboundOnly 改变的不是：

- “桥还在不在”

而是：

- read-side / inbound-side 关掉
- write-side / worker-side 继续活着

这一步如果写错，后面的结论就全会歪。

因为 mirror 不是：

- 没有 worker-side chain

而是：

- 有 worker-side chain，但没有完整前台消费面

## 第四层：`remoteBridgeCore` 继续维持 write-side state chain，但 inbound control / read-side signal被切掉

`remoteBridgeCore.ts` 在 v2 env-less path 创建 transport 之后，仍然会：

- `onStateChange('ready')`
- 在 flush / user batch 时 `reportState('running')`
- 在 `can_use_tool` 请求时 `reportState('requires_action')`
- 在 result / teardown 时 `reportState('idle')`
- `archiveSession(...)`
- 发 mirror 专属 telemetry

换句话说，mirror / outboundOnly 并没有丢掉：

- worker registration
- heartbeat
- running / requires_action / idle 的写回
- result / teardown 的 worker-side收口

但 read-side 和 control-side 这半条链被明显压薄了：

- transport 不开 SSE read stream
- `handleIngressMessage(...)` 虽然还在 wiring，但没有 read-side 就没有正常 inbound data 流入
- `bridgeMessaging.ts` 会把非 `initialize` 的 inbound `control_request` 直接回 error

所以更准确的说法必须是：

- mirror 保住了 write-side worker chain
- mirror 切掉了 read-side / interactive control chain

## 第五层：`useReplBridge()` 会把 outboundOnly 的 `AppState` surface 主动压成极薄一层

这一步最能说明“同属 v2 也不是同一种活跃 front-state surface”。

`useReplBridge.tsx` 的 `handleStateChange(...)` 在 outboundOnly 分支上只做了两件事：

- `failed` -> `replBridgeConnected = false`
- `ready` / `connected` -> `replBridgeConnected = true`

也就是说，它不会像 full 模式那样维护：

- `replBridgeSessionActive`
- `replBridgeReconnecting`
- `replBridgeConnectUrl`
- `replBridgeSessionUrl`
- `replBridgeEnvironmentId`
- `replBridgeError`

初始化成功后的专门分支也再次证明这点：

- outboundOnly 只写 `replBridgeConnected`
- 写 `replBridgeSessionId`
- 主动把 `replBridgeSessionUrl` / `replBridgeConnectUrl` 置空

所以 mirror 当前前台面更接近：

- 一个近乎隐身的 connected bit

而不是：

- 一整套 Ready / Connected / Reconnecting / Error / URL surface

## 第六层：permission callbacks、`system/init`、transcript `bridge_status` 都只在非-outboundOnly 路径成立

很多人会误以为：

- mirror 只是把 bridge dialog 隐藏了

但 `useReplBridge.tsx` 继续往下看会发现，被切掉的不只是 dialog。

非-outboundOnly 才会注册：

- `replBridgePermissionCallbacks`

非-outboundOnly 才会：

- 给远端发 `system/init`
- 追加 transcript `createBridgeStatusMessage(url, ...)`

因此 mirror / outboundOnly 当前缺的不是一个“显示壳”，

而是：

- permission 协同链
- transcript status chain
- remote client init metadata chain

也就是说它当前不是：

- full bridge with hidden chrome

而是：

- write-side alive, front-side mostly muted

## 第七层：footer 和 dialog 的“缺席”很多时候不是没连上，而是被隐式门控压掉

再往前台组件看，这一步更清楚。

`PromptInputFooter.tsx` 明确写了：

- implicit bridge 只有 `reconnecting` 时才显示 footer pill

`PromptInput.tsx` 的 footer navigation 也遵守同一门控：

- `replBridgeConnected && (replBridgeExplicit || replBridgeReconnecting)`

而 mirror 启动时的组合恰好是：

- `replBridgeExplicit = false`
- outboundOnly 分支几乎不把 `replBridgeReconnecting` 写成 true
- 只保留 `replBridgeConnected`

于是就出现了一个很容易被误判的现象：

- 桥是连着的
- 但 footer pill 仍然近乎永远看不见

这不是“没连上”，

而是：

- implicit + hidden gate 的结果

## 第八层：env-less full v2 自己也不是一张统一前台面，`ready` 与 `connected` 之间就已经分叉

这一步最容易被漏掉，因为很多人会把 full env-less v2 也写成一体。

但 `useReplBridge.tsx` + `BridgeDialog.tsx` 连起来看，会发现 env-less full 模式在 `ready` 和 `connected` 之间已经有一个 display gap：

- env-less 用 `environmentId === ''` 表示无 env
- 非-outboundOnly 初始化成功时，`sessionUrl` 已经能拿到
- 但 `connectUrl` 只有有 env 才会存在
- `BridgeDialog` 用的是 `sessionActive ? sessionUrl : connectUrl`

于是 env-less full 模式在 `ready` 阶段就会出现：

- transcript status 已经可以写出 `sessionUrl`
- 但 dialog / QR 还拿不到 `displayUrl`

直到进入：

- `connected`

并把：

- `replBridgeSessionActive = true`

之后，dialog / QR 才真正点亮。

所以 even in full env-less v2，

也不能写成：

- “一进入 ready，所有 front-state surface 同时点亮”

## 第九层：`/remote-control` 在 mirror 运行时的行为，也证明 mirror 不是 full bridge 的一个可见子集

`commands/bridge/bridge.tsx` 这里还有一个非常实用的边界信号。

命令逻辑是：

- 如果当前 `(replBridgeConnected || replBridgeEnabled) && !replBridgeOutboundOnly`
- 才弹 disconnect dialog

这意味着 mirror 已经运行时，再执行 `/remote-control`，

当前并不是：

- 查看或管理现有 mirror surface

而更接近：

- 把当前 mirror 升级成 full Remote Control 拓扑

这再次说明：

- mirror 不是 full bridge 的可见子集
- mirror 和 full bridge 是两种不同的 front-state topology

## 第十层：所以同属 v2，也不等于同一种活跃 front-state surface

把前面几层压成一句，更稳的一句是：

- same v2 transport generation, different active front-state surface

也就是说：

### full env-less v2 当前更像

- write-side worker chain
- read-side SSE chain
- permission callback chain
- transcript status / `system/init`
- session URL / connect URL / sessionActive / reconnecting / error surface

### mirror / outboundOnly 当前更像

- write-side worker chain
- `replBridgeConnected` 级别的薄联通态
- 被隐藏的 implicit bridge
- 没有 transcript status / permission callback / dialog URL surface

所以 mirror 不是：

- “full v2 去掉一点 UI”

而是：

- “保留 worker-side生命体征，但主动压薄 front-state consumer 的 v2 子拓扑”

## 第十一层：为什么它不是 134、135 的重复页

### 它不是 134

134 讲的是：

- bridge v1 vs v2

136 讲的是：

- 即使只看 v2，full env-less 和 mirror / outboundOnly 也不是同一种 front-state surface

一个讲：

- version split

一个讲：

- v2 topology split

### 它不是 135

135 讲的是：

- direct connect 为什么更像 foreground runtime，而不是 remote presence store

136 讲的是：

- bridge v2 内部自己的不同拓扑，为什么也会产生厚薄完全不同的前台消费面

一个讲：

- direct connect boundary

一个讲：

- bridge-v2 internal surface split

## 第十二层：最常见的四个假等式

### 误判一：mirror 就是 full v2 去掉一点 UI

错在漏掉：

- 被切掉的是整条 read/control/front-state chain，不只是 UI chrome

### 误判二：只要同属 env-less / CCR v2，前台状态面厚度就一样

错在漏掉：

- full env-less 在 `ready` / `connected` 之间自己就已经分叉
- mirror / outboundOnly 更是另一种薄 topology

### 误判三：outboundOnly 意味着没有 worker-side chain

错在漏掉：

- `/worker` 注册、heartbeat、`reportState(...)`、result / teardown 仍然都在

### 误判四：footer / dialog 没显示，说明桥没有 ready / connected

错在漏掉：

- implicit hidden gate
- `sessionActive ? sessionUrl : connectUrl` 的 display gap

## 第十三层：stable / conditional / internal

### 稳定可见

- mirror 启动时当前就是 `replBridgeEnabled=true`、`replBridgeExplicit=false`、`replBridgeOutboundOnly=true`
- outboundOnly 下 `useReplBridge()` 当前只维护极薄的 `replBridgeConnected`
- outboundOnly 不注册 permission callbacks，不写 transcript `bridge_status`，也不发 `system/init`
- outboundOnly 下 v2 transport 仍会 `ccr.initialize()`，worker-side write chain 仍成立

### 条件公开

- env-less full 模式在 `ready` 与 `connected` 之间存在 display gap：transcript URL 可能先亮，dialog / QR 还没亮
- footer pill 还受 implicit / reconnecting 门控，不是“桥一连上就可见”
- `/remote-control` 在 mirror 运行时更像拓扑升级入口，而不是 mirror 管理面

### 内部 / 灰度层

- `outboundOnly` 当前主要由 env-less v2 core 消费，落回 env-based path 时的一致性保护并不明显
- transport-v2 虽然保留 `reportMetadata()` 能力，但当前 mirror / outboundOnly 并没有对应 metadata-backed front-state producer
- mirror rollout 的 env / feature gate 与实际拓扑兑现之间，仍有实现层灰度

这些更适合作为：

- 当前实现证据

而不是：

- 永不变化的产品承诺

## 第十四层：苏格拉底式自审

### 问：我是不是把 v2 这个标签直接偷换成了“前台状态面已经统一”？

答：如果是，就把 transport generation 和 surface topology 混了。

### 问：我是不是把 outboundOnly 写成“没有 worker-side chain”？

答：如果是，就漏掉了 `ccr.initialize()`、heartbeat 和 `reportState(...)` 写回。

### 问：我是不是把 footer / dialog 的缺席误读成“桥没连上”？

答：如果是，就漏掉了 implicit hidden gate 和 `displayUrl` 的条件逻辑。

### 问：我是不是又把 134 的 v1 / v2 分叉拿来重写，而没有真正进入 v2 内部 topology split？

答：如果是，就还没真正进入 136。

### 问：我是不是把 mirror 当成 full bridge 的一个只读皮肤？

答：如果是，就把 read/control/front-state chain 的压缩写漏了。

## 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts`
- `claude-code-source-code/src/bridge/initReplBridge.ts`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooter.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInput.tsx`
- `claude-code-source-code/src/components/BridgeDialog.tsx`
- `claude-code-source-code/src/commands/bridge/bridge.tsx`
