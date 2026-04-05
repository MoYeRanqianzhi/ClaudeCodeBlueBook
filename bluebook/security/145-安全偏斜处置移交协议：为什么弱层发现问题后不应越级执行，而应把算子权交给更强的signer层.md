# 安全偏斜处置移交协议：为什么弱层发现问题后不应越级执行，而应把算子权交给更强的signer层

## 1. 为什么在 `144` 之后还必须继续写“处置移交协议”

`144-安全偏斜算子主权` 已经回答了：

`不同 remediation operator 必须绑定到不同 signer 边界，不能由任意层随意选择。`

但如果继续追问，  
还会碰到一个更动态、更贴近真实工程的问题：

`当弱层先看见 skew，而它自己又没有该 operator 的主权时，系统应该怎么办？`

这不是细枝末节。  
因为现实系统里，最先看见问题的层往往不是最有权处理问题的层：

1. UI 先看见可见性问题
2. compat adapter 先看见 costume mismatch
3. transport adapter 先看见 higher-generation feature 缺失
4. bridge messaging 先收到 mutating request，但真正 policy truth 在别的边界

如果这些层一律选择：

`我先自己处理掉`

就会立刻出现：

1. 越权阻断
2. 越权拒绝
3. 越权改口
4. 假成功

所以 `144` 之后必须继续补的一层就是：

`安全偏斜处置移交协议`

也就是：

`成熟安全系统不仅规定谁配做哪个动作，还规定弱层在先看到问题时应如何 abstain、forward、rerun-full-gate 或 internalize translation，把处置权合法交给更强边界。`

## 2. 最短结论

Claude Code 当前源码已经清楚展示出至少四种 handoff pattern：

1. `abstain-with-isolation`  
   cosmetic nudge 失败时不污染外层 init failure  
   `src/hooks/useReplBridge.tsx:607-620`
2. `adapter-internalize`  
   compat translation 留在 adapter 内部，让上层继续传“自己手上的对象”  
   `src/bridge/createSession.ts:357-360`  
   `src/bridge/remoteBridgeCore.ts:971-982`
3. `forward-to-stronger-signer`  
   hooks 先试；若不响应，再转给 SDK consumer / control protocol  
   `src/cli/print.ts:1256-1262`
4. `rerun-full-gate-at-strong-boundary`  
   弱层只做预过滤/避免 dead button，真正 gate 由更强 handler 重跑  
   `src/cli/print.ts:1666-1670`  
   `src/bridge/bridgeMessaging.ts:328-340`

这些证据合在一起说明：

`Claude Code 的成熟度不只在于“算子主权分清了”，还在于它知道弱层见到问题时，不是抢权，而是移交。`

因此这一章的最短结论是：

`cleanup future design 若继续推进，除了 operator matrix 与 authority matrix，还必须有 handoff protocol，明确弱层发现 skew 后应当 abstain、translate internally、forward 还是把 full gate 交给更强层重跑。`

再压成一句：

`控制面的高级形态，不是每层都更聪明，而是每层都知道什么时候该闭嘴、该转交。`

## 3. 第一性原理：为什么“先看到”不等于“先处置”

很多系统默认：

`谁先看到问题，谁先处理。`

这是危险的。

从第一性原理看，  
“观察权”和“处置权”并不是同一种权：

1. 观察权回答：`我看见了什么`
2. 处置权回答：`我配对此做哪种改动`

弱层最常见的错误不是没看到问题，  
而是把“看到了”误当成“配处理了”。

所以成熟系统一定要在主权之后继续建立一层协议：

1. 我先看到问题时，是否该 abstain
2. 若我只懂 costume，是否应 internalize translation
3. 若我只懂 hint，是否应 forward
4. 若我只会预判，是否应把 full gate 交给 stronger boundary 重跑

所以从第一性原理看：

`handoff protocol 保护的不是效率，而是防止观察层冒充裁决层。`

## 4. `abstain-with-isolation`：弱层可以发提示，但不能污染更强失败语义

`src/hooks/useReplBridge.tsx:607-620` 很有代表性：

1. v2-only upgrade nudge 自己包在 try/catch 里
2. 注释明确写：
   `Own try/catch so a cosmetic GrowthBook hiccup doesn't hit the outer init-failure handler`
3. 也就是说：
   cosmetic nudge 失败 != init failure

这说明展示层的 handoff 协议是：

1. 你可以观察到 visibility skew
2. 你可以发 nudge
3. 但你不配把自己的异常升级成系统级 init failure

这就是一种非常成熟的 `abstain-with-isolation`：

`我做我的弱动作，但若我自己失败，不得污染更强层的真相签字。`

对 cleanup future design 的启示很直接：

1. 某些 cleanup disclosure UI 可以先行提示
2. 但 UI 自身失败不应被上翻成 cleanup signer failure

## 5. `adapter-internalize`：只懂 costume 的层，不应要求所有上游都先学会 costume

### 5.1 `createSession()` 直接把 retag 吞在 adapter 内部

`src/bridge/createSession.ts:357-360` 写得非常清楚：

1. compat gateway 只接受 `session_*`
2. v2 caller 传原始 `cse_*`
3. `retag here so all callers can pass whatever they hold`

这说明它没有选择：

`要求所有调用方都先学会 compat costume 规则`

而是选择：

`由最懂 compat gateway 的 adapter 把 costume translation 内部化`

### 5.2 `remoteBridgeCore` 又说明 internalize 也可以按语义场景不同而变体

`src/bridge/remoteBridgeCore.ts:971-982` 进一步说明：

1. archive 的 compatId 不是全局缓存
2. 而是每次 fresh compute
3. 因为这里的 compatId 只是 server URL path segment

这说明 handoff 协议不只是：

`把 translation 放进 adapter`

还包括：

`由 adapter 自己决定 translation 是缓存型还是现算型`

因为它最懂当前场景究竟需要哪一种。

所以从 handoff 角度看：

`adapter-internalize` 的本质是：上游保留对象直觉，下游 adapter 承担 costume debt。`

## 6. `forward-to-stronger-signer`：弱层先试，但最终签字权留给更强层

`src/cli/print.ts:1256-1262` 是一个特别好的例子：

1. `registerElicitationHandlers()`
2. hooks run first
3. if no hook responds
4. request is forwarded to the SDK consumer via the control protocol

这说明 Claude Code 并不是：

`谁先截到 elicitation，谁就一定负责到底`

而是：

1. 本地 hook 有权先尝试更近场的解决
2. 如果没解决
3. 继续移交给更强、更正式的 SDK consumer / control protocol

这是一种很成熟的逐级 handoff：

`弱近场可先试，但正式签字权留在更强控制层。`

对 cleanup future design 也很有价值。  
很多 cleanup action 都可能存在同样路径：

1. 本地弱层先提供 hint
2. 若未闭环
3. 必须继续 forward 给正式 contract signer

## 7. `rerun-full-gate-at-strong-boundary`：弱层最多做预过滤，正式裁决必须重跑

### 7.1 capability passthrough 不是 security boundary

`src/cli/print.ts:1666-1670` 直接写明：

1. 这里只是 capabilities passthrough with allowlist pre-filter
2. `Not a security boundary`
3. `handler re-runs the full gate`
4. 目的只是 `avoid dead buttons`

这说明在 Claude Code 的哲学里，  
弱层做 pre-filter 并不等于它获得了真正 gate authority。

它只是在说：

`我先做一个弱判断，减少明显无效的表面动作，但真正的许可裁决必须在更强 handler 边界再跑一遍。`

### 7.2 `set_permission_mode` 也不在消息层直接自判，而是依赖 callback verdict

`src/bridge/bridgeMessaging.ts:328-340` 又从另一条路径证明同一哲学：

1. 当前层不直接 import 具体 gate 逻辑
2. 而是通过 `onSetPermissionMode` callback 拿 policy verdict
3. 如果 callback 没注册
4. 就 explicit error，而不是 silent false-success

这说明 message/control boundary 的 handoff 协议是：

1. 我可以收请求
2. 我可以包装回复
3. 但真正的 policy truth 必须由更强的 policy signer 给出 verdict

所以这里体现的是：

`rerun-full-gate-at-strong-boundary`

而不是：

`弱层先算过一遍就算数`

## 8. `abstain-when-not-the-right-route`：有些层最正确的动作就是不接手

`src/cli/print.ts:1258-1273` 还有一个非常重要的细节：

1. SDK MCP servers 被排除在本地 elicitation handler 之外
2. 原因是它们 `route through SdkControlClientTransport`

这说明 handoff 协议还有一种更纯粹的形式：

`我知道这件事不是走我这条路，所以我连接手都不接手。`

这种 `abstain-when-not-the-right-route` 很容易被忽略，  
但其实非常高级。  
因为它体现出：

`正确的系统不一定什么都接；有时最安全的动作就是承认“这条路不归我管”。`

## 9. 一张更完整的 handoff protocol

综合以上源码，可以压出一张更完整的协议：

1. weak UI surface 发现 cosmetic skew -> `abstain-with-isolation`
2. adapter 发现 costume mismatch -> `adapter-internalize`
3. local hook / weak local actor 先试 -> `forward-to-stronger-signer`
4. weak prefilter / weak gate hint -> `rerun-full-gate-at-strong-boundary`
5. route 不归我管 -> `abstain-when-not-the-right-route`

这张表的价值在于，  
它把安全控制面的动作学又往前推进了一步：

`不仅知道该用什么 operator，也知道当我无权用 operator 时该怎么把权交出去。`

## 10. 对 cleanup future design 的直接启示

cleanup future rollout 若继续深化，  
最值得补的一张图不再只是：

1. field matrix
2. operator matrix
3. authority matrix

而是：

`cleanup handoff matrix`

一个更成熟的 cleanup 设计很可能需要明确：

1. weak cleanup disclosure surface 失败时如何与 signer failure 隔离
2. cleanup carrier mismatch 应由哪个 adapter 内部化
3. 本地 hint / auto-fix 失败后何时 forward 给正式 cleanup signer
4. 哪些 weak cleanup pre-check 必须在 stronger boundary 重跑 full gate
5. 哪些 route 根本不归当前层接手

这些都是基于现有 handoff 哲学做的推导，  
不是当前源码中已经存在 cleanup-specific handoff protocol。

## 11. 我们当前能说到哪一步，不能说到哪一步

基于当前可见源码，  
我们可以稳妥地说：

1. Claude Code 不只是分配 operator 主权
2. 它还在多个地方展示了“弱层发现问题后如何合法移交”的协议意识

但我们不能说：

1. cleanup handoff protocol 已被正式编码
2. cleanup weak-surface / strong-signer 交接已经工程化完成

所以这一章的结论必须压在：

`Claude Code 已展示出从 operator sovereignty 继续推进到 handoff protocol 的工程哲学；cleanup future design 若要继续成熟，下一步最值得补的就是这张 handoff matrix。`

## 12. 苏格拉底式追问：如果这章还要继续提高标准，还缺什么

还可以继续追问六个问题：

1. cleanup UI nudge 与 cleanup signer failure 的隔离边界应如何建模
2. cleanup adapter internalize 应走缓存型 translation 还是现算型 translation
3. cleanup weak pre-check 何时必须在 stronger boundary 全量重跑
4. 哪些 cleanup auto-fix 允许“先试后 forward”，哪些不允许先试
5. 哪些 cleanup route 必须显式 abstain，而不是 fallback 接手
6. conformance tests 是否应验证“弱层失败不得污染强层 verdict”

这些问题说明：

`144` 解决的是“谁配说哪个动词”，`145` 解决的则是“当不配说的人先看见问题时，他该如何把话筒交出去”。`
