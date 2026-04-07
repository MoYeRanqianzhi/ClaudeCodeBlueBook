# `ccrMirrorEnabled`、`isEnvLessBridgeEnabled`、`initReplBridge`、`outboundOnly`、`replBridge` 与 `createV2ReplTransport`：为什么启动意图、实现选路与实际 runtime topology 不是同一层 mirror 合同

## 用户目标

136 已经把 bridge v2 内部先拆成：

- full env-less v2
- mirror / outboundOnly

并说明它们不是同一种 active front-state surface。

但如果继续往下不补这一页，读者还是很容易再把 mirror 写成一句过于顺滑的话：

- “只要 mirror gate 打开，系统就会稳定落成 outboundOnly bridge。”

这句不稳。

从当前源码看，至少还要再拆三层：

1. 启动意图是不是 mirror
2. `initReplBridge` 最终选了哪条实现路径
3. 实际 runtime topology 到底是不是 outboundOnly

只要这三层不拆开，

- `CLAUDE_CODE_CCR_MIRROR`
- `tengu_ccr_mirror`
- `replBridgeOutboundOnly=true`

就会被误写成：

- “mirror 合同已经被稳定兑现”

## 第一性原理

更稳的提问不是：

- “mirror 到底开没开？”

而是先问五个更底层的问题：

1. 当前打开的是 mirror 启动意图，还是 mirror 实现路径？
2. `env-less` gate 决定的是 bridge 能不能用，还是决定用哪种实现？
3. env-less path 没命中时，系统是完全回到 v1，还是只是回到 env-based orchestration？
4. hook 层的 `outboundOnly` 分支，是否一定意味着底层 core 也实现了 outboundOnly topology？
5. 版本门槛不满足时，系统会 fallback，还是直接失败？

只要这五轴先拆开，mirror 就不会再被写成：

- “一个单层稳定开关”

## 第一层：`ccrMirrorEnabled` 和 `isEnvLessBridgeEnabled()` 是两条独立 gate，不对称，也不等价

`bridgeEnabled.ts` 已经把这两条 gate 的主语写得很清楚：

### mirror gate

- `isCcrMirrorEnabled()`
- 由 `CLAUDE_CODE_CCR_MIRROR` 或 `tengu_ccr_mirror` 控制

### env-less gate

- `isEnvLessBridgeEnabled()`
- 只决定 REPL bridge 用哪种实现
- 不决定 bridge 是否可用

也就是说：

- mirror gate 决定“我想不想以 mirror 形态启动”
- env-less gate 决定“`initReplBridge` 最终走 env-less 还是 env-based”

这两者不是一回事。

如果把它们压成一句：

- “mirror 开了 = outboundOnly bridge 已落地”

就会把启动意图和实现选路写成同一层。

## 第二层：`main.tsx` 会把 mirror 启动意图写进状态，但这还不是 topology 兑现

`main.tsx` 在启动时做了两步关键判断：

- `fullRemoteControl` 与 `ccrMirrorEnabled` 互斥
- mirror 只会在 `!fullRemoteControl` 时计算

然后它把结果写进初始状态：

- `replBridgeEnabled = fullRemoteControl || ccrMirrorEnabled`
- `replBridgeExplicit = remoteControl`
- `replBridgeOutboundOnly = ccrMirrorEnabled`

所以从 `AppState` 视角看，

mirror 的确已经被写成：

- enabled
- implicit
- outboundOnly

但这一步回答的只是：

- local startup intent

不是：

- 底层 core 已经真的落成 outboundOnly runtime topology

## 第三层：`useReplBridge()` 会把 `outboundOnly` 当作启动意图往下传，但这不自动保证实现层同样承诺

`useReplBridge.tsx` 会把：

- `outboundOnly`
- `tags: ['ccr-mirror']`

一起传给：

- `initReplBridge(...)`

这里非常容易让人误判成：

- 既然 hook 已经传了 `outboundOnly`，底层一定也在同一种语义里运行

但这只说明：

- hook 把 mirror 当作启动意图往下传

还没有说明：

- 所有实现分支都真正消费了这个语义

## 第四层：真正消费 `outboundOnly` 的，是 env-less 分支；env-based delegate 当前并没有同样的参数面

`initReplBridge.ts` 这里是整页的分水岭。

它先判断：

- `isEnvLessBridgeEnabled() && !perpetual`

如果命中，才会走：

- `initEnvLessBridgeCore(...)`

并把：

- `outboundOnly`
- `tags`

真正传下去。

而一旦没命中 env-less 分支，

代码就会进入：

- env-based v1 path

然后调用：

- `initBridgeCore({...})`

这个 delegate 当前没有：

- `outboundOnly`
- `tags`

这就意味着更稳的表述必须是：

- `outboundOnly` 当前的真实实现承诺，主要存在于 env-less branch

而不是：

- 整个 bridge 家族都稳定承诺 mirror topology

## 第五层：env-less path 没命中，不等于完全回到 v1 transport；它更像“回到 env-based orchestration”

这一步尤其容易被写错。

很多人看到 `env-less` 没命中，就会直接写成：

- “那就完全回 v1 了。”

但 `replBridge.ts` 的 env-based core 里又明确保留了一层独立判断：

- `useCcrV2 = serverUseCcrV2 || CLAUDE_BRIDGE_USE_CCR_V2`

然后在 `useCcrV2` 分支里，

- 仍然会走 `createV2ReplTransport(...)`

所以 env-less miss 的更准确含义不是：

- transport 一定退回 v1

而是：

- orchestration 退回 env-based
- transport 仍然可能是 CCR v2

也就是说，系统完全可能出现一种灰色状态：

- 底层 transport 偏 v2
- 但 runtime topology 已经不再是 env-less mirror / outboundOnly 那种语义

## 第六层：env-based core 当前仍然保留 inbound message / server control wiring，这和 outboundOnly topology 不是一回事

再往 `replBridge.ts` 里看，

env-based core 还在显式 wiring：

- `onServerControlRequest`
- `handleIngressMessage(...)`

这意味着它仍然保留：

- inbound message 链
- server control request 链
- permission response 相关双向流

而这和 outboundOnly 想表达的：

- read-side 被切掉
- control-side被压成错误响应

并不是同一种 topology。

所以如果 mirror 启动意图最终回落到 env-based core，

就会出现一类非常关键的灰度边界：

- hook 以为自己在 mirror
- 但底层 runtime 可能仍然是双向 bridge

## 第七层：这就是“启动意图”和“实际 runtime topology”分叉的地方

把前面几层压成一句，更稳的一句是：

- mirror intent can precede mirror topology

也就是说：

### 本地启动层可能已经成立的

- `replBridgeOutboundOnly=true`
- hook 走 outboundOnly 的本地分支
- local UI / local shadow 倾向于 mirror 语义

### 但底层真正兑现的还要看

- env-less gate 是否命中
- env-less min version 是否满足
- 是否回落到 env-based orchestration
- env-based core 是否仍保留双向 ingress / control / permission wiring

所以 mirror 当前更像：

- a startup intent that still needs implementation-route confirmation

而不是：

- 一个无条件兑现的单层合同

## 第八层：版本门槛失败时，系统当前不是 fallback，而是直接 fail

这里还要再拆一层常见误写。

很多人会直觉地以为：

- “先试 env-less，不行就回 env-based”

但 `initReplBridge.ts` 当前并不是这么做的。

在 env-less branch 里：

- `checkEnvLessBridgeMinVersion()` 失败
- 会直接 `return null`
- 并把状态打成 `failed`

它不会再继续 fallback 到 env-based path。

而 env-based path 自己又有一套独立的：

- `checkBridgeMinVersion()`

所以当前更准确的说法是：

- 两条实现各自有独立版本门槛
- 不是“先试 v2，不行再回 v1”的线性降级链

## 第九层：mirror tag / telemetry 也不是“启动意图已兑现”的普适证明

这一点也很容易被写过头。

mirror 相关的：

- `tags: ['ccr-mirror']`
- `tengu_ccr_mirror_started`

当前都更接近：

- env-less core 真正吃到 `outboundOnly` 之后的运行时证据

它们不能反推：

- 所有 mirror 启动意图都已经被底层实现兑现

所以更稳的写法应该是：

- telemetry/tag 能证明 mirror runtime 已落地
- 不能单独证明 mirror startup intent 必然落地

## 第十层：为什么它不是 136 的重复页

136 讲的是：

- full env-less v2
- mirror / outboundOnly

在 active front-state surface 上的差异。

139 讲的是：

- mirror startup intent
- env-less / env-based implementation routing
- actual runtime topology

这三层为什么不是同一层合同。

一个讲：

- active surface split

一个讲：

- gate / routing / topology split

所以 139 不是重写 136，

而是把主语从：

- “看见了什么 surface”

进一步压到：

- “为什么会落成这种 topology”

## 第十一层：最常见的四个假等式

### 误判一：`CLAUDE_CODE_CCR_MIRROR` 或 `tengu_ccr_mirror` 开了，就等于 outboundOnly topology 已稳定兑现

错在漏掉：

- 这只证明 mirror startup intent
- 不证明 env-less branch 一定命中

### 误判二：env-less 没命中，就等于完全回到 v1 transport

错在漏掉：

- env-based orchestration 下仍可能选 CCR v2 transport

### 误判三：hook 里继续按 `outboundOnly` 做分支，说明底层 runtime 一定也是 mirror

错在漏掉：

- hook intent 和 core implementation 可能已经分叉

### 误判四：env-less min version 不满足时，系统会优雅退回 env-based

错在漏掉：

- 当前实现是直接 fail，不是自动 fallback

## 第十二层：stable / conditional / internal

### 稳定可见

- mirror gate 与 env-less gate 当前是两条独立开关
- `main.tsx` 当前会把 mirror startup intent 写进 `replBridgeOutboundOnly`
- `useReplBridge()` 当前会把 `outboundOnly` / `tags` 往下传
- `initReplBridge()` 只有 env-less branch 真正消费 `outboundOnly`
- env-based core 当前仍保留 inbound / control wiring

### 条件公开

- env-based orchestration 下仍可能选 CCR v2 transport，所以 fallback 只说明 orchestration 不同，不说明 transport 版本相同
- mirror startup intent 可以先于 env-less rollout 命中，因此“本地 mirror”与“底层 mirror topology”之间有条件边界
- telemetry / tag 只能证明部分 runtime 落地，不是所有 startup intent 的总证明

### 内部 / 灰度层

- hook 侧继续按 outboundOnly 做本地分支，而底层若回到 env-based core，实际 runtime 可能仍是双向 bridge
- 当前仓内没有一条显式断言把“mirror 必须依赖 env-less”写成硬约束
- 未来会不会把 intent / routing / topology 三层重新收拢成单层合同，当前没有稳定承诺

## 第十三层：苏格拉底式自审

### 问：我现在写的是 startup intent，还是 runtime topology？

答：如果答不出来，就把 mirror gate 写过头了。

### 问：我是不是把 env-less gate 偷换成了“bridge 是否可用”的总开关？

答：如果是，就没尊重 `isEnvLessBridgeEnabled()` 的真实注释。

### 问：我是不是把 env-based fallback 写成了 transport 版本回退？

答：如果是，就漏掉了 env-based core 仍可能选 `createV2ReplTransport(...)`。

### 问：我是不是把 hook 的 outboundOnly 本地分支当成了底层实现已兑现的证据？

答：如果是，就把 UI 语义和 core topology 混了。

### 问：我是不是又回到 136 的 active surface 差异，而没有真正进入 gate / routing / topology 这一层？

答：如果是，就还没真正进入 139。

## 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/bridge/initReplBridge.ts`
- `claude-code-source-code/src/bridge/envLessBridgeConfig.ts`
- `claude-code-source-code/src/bridge/replBridge.ts`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts`
- `claude-code-source-code/src/cli/transports/ccrClient.ts`
