# `remoteSessionUrl`、brief line、bridge pill、bridge dialog 与 attached viewer：为什么它们不是同一种 surface presence

## 用户目标

如果继续往下读 remote session / bridge / attached viewer 相关代码，读者很容易把下面这些东西压成一句：

- footer 里有个 `remote`
- 有时会出现 `Remote Control active`
- 有时还能点开 bridge dialog
- attach 时 transcript 里还会写 `Attached to assistant session ...`
- brief mode 空闲时还会显示 `Reconnecting…` / `Disconnected`

于是正文就会滑成一句看似自然、实际上已经把多层 surface 压平的话：

- “这些都只是在不同地方提示我现在连着远端。”

这句不稳。

从当前源码看，它们回答的根本不是同一个问题。

至少有五种不同 surface：

1. `remoteSessionUrl` 这条 URL presence surface
2. brief line 这条 brief-only runtime projection surface
3. bridge pill 这条 coarse status surface
4. bridge dialog 这条 inspect / disconnect surface
5. attached viewer 这条 transcript-signed attachment surface

而这五种 surface 也不是来自同一张状态表的五种皮肤。

更准确地说，它们来自三组不同状态源：

- `remoteSessionUrl`
- `replBridge*`
- `viewerOnly + remoteConnectionStatus / remoteBackgroundTaskCount`

它们都长得像“远端存在”，但并不是同一种 presence。

## 第一性原理

更稳的提问不是：

- “远端连接状态到底看哪里？”

而是先问五个更底层的问题：

1. 这一面签名的对象是 URL、runtime state、bridge 状态，还是 transcript 事实？
2. 这一面回答的是“能不能打开”“现在是不是连上”“当前桥连到哪里”，还是“我作为 viewer 已附着到哪条 session”？
3. 这一面属于 `--remote`、always-on bridge，还是 attached viewer？
4. 这一面是持续订阅的运行态投影，还是 mount-time 捕获的静态 presence？
5. 这一面是给用户粗看、给用户检查、还是给 transcript 留痕？

只要这五轴先拆开，正文就不会再把所有“远端可见性”都写成同一种 surface presence。

## 第一层：`remoteSessionUrl` 只签 `--remote` URL presence，不签连接健康

`main.tsx` 的 `--remote` 路径很直接：

- 创建 remote session
- 生成 `remoteSessionUrl`
- 把它写进初始 `AppState`
- 同时加一条 `/remote-control is active. Code in CLI or at ${remoteSessionUrl}` 的 info message

而 footer 左侧的 `remote` pill 也不是持续订阅这个值，

它用的是：

- `useState(() => store.getState().remoteSessionUrl)`

并且注释明确写：

- set once in initialState
- never mutated
- lazy init captures immutable value without subscription

所以 `remoteSessionUrl` 当前回答的问题是：

- “这条 REPL 现在带着一个可在浏览器打开的 remote session URL 吗？”

它不回答：

- 当前 WS 是否仍连着
- 当前 attached viewer 是否存在
- 当前 bridge 是否 ready / connected / reconnecting

它也不是：

- `replBridgeSessionUrl`
- `replBridgeConnectUrl`

因此这层的主语是：

- URL presence

不是：

- connection health

## 第二层：brief line 签的是 brief-only 运行态投影，不是 URL presence

`BriefIdleStatus()` 只消费两组值：

- `remoteConnectionStatus`
- `remoteBackgroundTaskCount`

并把它们投成：

- 左边 `Reconnecting…` / `Disconnected`
- 右边 `N in background`

这条线既不读取：

- `remoteSessionUrl`
- `replBridgeConnectUrl`
- `replBridgeSessionUrl`

也不提供 inspect / disconnect 动作。

它在 REPL 里还受到严格 gate：

- `!showSpinner`
- `!isLoading`
- `!userInputOnProcessing`
- `!hasRunningTeammates`
- `isBriefOnly`
- `!viewedAgentTask`

所以 brief line 回答的问题其实是：

- “在 brief-only idle 这一刻，当前 remote runtime 有没有告警态，后台还有多少任务在跑？”

它不是：

- URL 面
- bridge 面
- transcript 宣告面

因此这一层更像：

- runtime projection surface

不是：

- remote identity surface

## 第三层：bridge pill 是 coarse summary，不是 bridge existence proof

`PromptInputFooter.tsx` 里的 `BridgeStatusIndicator` 先读：

- `replBridgeEnabled`
- `replBridgeConnected`
- `replBridgeSessionActive`
- `replBridgeReconnecting`
- `replBridgeExplicit`

然后再做两层裁剪：

1. failed state 根本不走 footer pill，而走 notification / dialog
2. 如果是 implicit bridge，且当前不是 reconnecting，pill 直接不显示

再加上 `PromptInput.tsx` 里导航也必须复制同一套 render condition，

说明 bridge pill 当前只是一条：

- coarse status summary surface

它不是：

- bridge 永远存在的证明

更不是：

- bridge 详情查看面

所以如果用户看到 footer 没有 pill，

并不能推出：

- 没有 bridge

它只能推出：

- 当前系统不愿意把 bridge 状态用这一颗 pill 暴露出来

## 第四层：bridge dialog 是 inspect / disconnect surface，不是 pill 的放大版

`BridgeDialog.tsx` 读的状态明显比 pill 厚得多：

- `replBridgeConnected`
- `replBridgeSessionActive`
- `replBridgeReconnecting`
- `replBridgeConnectUrl`
- `replBridgeSessionUrl`
- `replBridgeError`
- `replBridgeEnvironmentId`
- `replBridgeSessionId`
- `verbose`

而它对用户展示的内容也完全不是 pill 的同义重复：

- `displayUrl = sessionActive ? sessionUrl : connectUrl`
- 可切 QR code
- 可显示 `Environment` / `Session` ID
- 有 error
- 有 `d to disconnect`

也就是说 bridge dialog 回答的问题是：

- “当前 bridge 连到哪里、现在处于 ready 还是 active、能不能从这里断开、有哪些调试信息可以看？”

这和 bridge pill 的问题：

- “要不要给你一颗粗粒度状态 pill？”

完全不是同一层。

所以更稳的写法必须是：

- pill is summary
- dialog is inspect / disconnect

而不是：

- dialog 是 pill 的展开态

## 第五层：attached viewer 的主 signer 不是 URL，也不是 bridge，而是 transcript attach 事实

`main.tsx` 的 attach path 写得很明确：

- `createRemoteSessionConfig(..., viewerOnly=true)`
- 初始消息是 `Attached to assistant session ${id.slice(0, 8)}…`
- `assistantInitialState.isBriefOnly = true`
- `assistantInitialState.replBridgeEnabled = false`

这说明 attached viewer 从一开始就不是：

- `--remote` URL mode
- always-on bridge host

它更像：

- 已经附着到某条 assistant session 的 brief viewer

而这条事实主要是靠：

- transcript 里的 info message

来签名的。

它后续当然还会持续写：

- `remoteConnectionStatus`
- `remoteBackgroundTaskCount`

所以它可以在 brief line 上显示：

- `Reconnecting…`
- `Disconnected`
- `N in background`

但它仍然没有变成：

- `remoteSessionUrl`
- bridge dialog

而且 attach path 当前是显式把：

- `replBridgeEnabled = false`

写进初始状态的。

这说明 attached viewer 不是 bridge 的另一张壳，

而是设计上就和 bridge surface 分家的另一条线。

所以 attached viewer 的 presence signer 更准确地说是：

- transcript-signed attachment fact

不是：

- URL-presence fact

## 第六层：同样都“像远端”，但五种 surface 绑定的状态树槽位不同

`AppStateStore.ts` 其实已经把这些面拆开了：

### `--remote`

- `remoteSessionUrl`

### attached viewer runtime

- `remoteConnectionStatus`
- `remoteBackgroundTaskCount`

### always-on bridge

- `replBridgeConnected`
- `replBridgeSessionActive`
- `replBridgeReconnecting`
- `replBridgeConnectUrl`
- `replBridgeSessionUrl`
- `replBridgeEnvironmentId`
- `replBridgeSessionId`
- `replBridgeError`

这意味着源码的状态树本来就不是在维护一个统一的：

- `remotePresence`

而是在维护几条不同 surface 所需的不同事实。

如果正文还把它们压成一句：

- “都是远端状态”

那反而是把源码已经拆开的边界重新糊回去。

## 第七层：同一句文案，在不同链路里也可能不是同一种 surface

这一步也很容易被漏掉。

因为 bridge 和 `--remote` 都可能让用户看到一句很像的话：

- `/remote-control is active ...`

但当前实现里，它们的 surface 权重并不一样。

### bridge

bridge 这边走的是：

- `bridge_status`

并且有专门的 special-case 可见性处理。

### `--remote`

`--remote` 这边走的是：

- 普通 `info` system message

所以即便文案接近，

它们也不是：

- 同一种 transcript surface

一个更接近：

- bridge-owned status surface

一个更接近：

- remote-mode info line

这再次说明不能只按文案相似度来判断 surface 是否同一类。

## 第八层：`/session` 进一步证明 `remoteSessionUrl` 只是 `--remote` 这条 surface 链

`commands/session/session.tsx` 只读：

- `remoteSessionUrl`

没有它就直接提示：

- `Not in remote mode. Start with claude --remote`

这页既不认：

- `replBridgeSessionUrl`
- `replBridgeConnectUrl`

也不认 attached viewer 的 transcript 事实。

这进一步说明：

- `remoteSessionUrl` 属于 `--remote` / `/session` / footer `remote` pill 这一条 surface 链

不是：

- attached viewer 和 bridge 共享的公共 presence 标识

## 第九层：为什么它不是 25、26、129 的重复页

### 它不是 25

25 讲的是：

- settings
- `/remote-control`
- footer pill
- bridge dialog

为什么不是同一个按钮。

130 讲的是：

- `remoteSessionUrl`
- brief line
- bridge pill
- bridge dialog
- attached viewer

为什么不是同一种 surface presence。

一个讲：

- control / config / status / inspect surface

一个讲：

- presence surface taxonomy

### 它不是 26

26 讲的是：

- connect URL
- session URL
- environment ID
- session ID
- `remoteSessionUrl`

为什么不是同一种定位符。

130 讲的不是链接和 ID 的对象定位，

而是：

- 哪一面在签什么事实

一个讲：

- locator split

一个讲：

- visibility split

### 它不是 129

129 讲的是：

- 谁拥有恢复主权

130 讲的是：

- 谁在签可见性

一个讲：

- recovery ownership

一个讲：

- presence signing

## 第十层：最常见的假等式

### 误判一：footer 有 `remote` 就说明当前连接健康

错在漏掉：

- `remote` pill 只是 mount-time 捕获的 `remoteSessionUrl`

### 误判二：brief line 就是在展示 remote URL 状态

错在漏掉：

- 它只读 `remoteConnectionStatus` 和 `remoteBackgroundTaskCount`

### 误判三：bridge pill 缺席就说明没有 bridge

错在漏掉：

- implicit bridge 非 reconnecting 时，pill 会故意隐藏

### 误判四：bridge dialog 只是 bridge pill 的放大版

错在漏掉：

- dialog 负责 inspect / disconnect，并带 URL / QR / ID / error

### 误判五：attached viewer 的 presence 主要靠 URL

错在漏掉：

- attach path 当前主要用 transcript 里的 `Attached to assistant session ...` 做 signer

### 误判六：bridge 和 `--remote` 里出现相似文案，就说明它们属于同一种 surface

错在漏掉：

- bridge 这边是 `bridge_status`
- `--remote` 这边只是普通 `info`

## 第十一层：stable / conditional / internal

### 稳定可见

- `remoteSessionUrl` 当前只属于 `--remote` 这条 URL surface 链
- brief line 当前只属于 brief-only idle 的 runtime projection surface
- bridge pill 当前只提供 `Remote Control active/reconnecting` 这一类 coarse summary
- bridge dialog 当前承担 inspect / disconnect
- attached viewer 当前主要通过 transcript attach message 宣告 presence
- bridge 与 `--remote` 即便出现相近文案，当前也不属于同一种 transcript surface

### 条件公开

- bridge pill 只有 `replBridgeConnected && (replBridgeExplicit || replBridgeReconnecting)` 时才可见
- brief line 只有在 REPL 的 brief-only idle 条件满足时才挂载
- bridge dialog 的主 URL 会随着 `sessionActive` 在 `connectUrl` / `sessionUrl` 间切换
- attached viewer 虽然会持续更新 `remoteConnectionStatus`，但不会因此自动长出 `remoteSessionUrl`
- bridge 和 `--remote` 的 transcript 可见性还受各自消息类型与渲染规则影响

### 内部 / 灰度层

- footer `remote` pill 使用 `useState(() => store.getState().remoteSessionUrl)` 的 lazy capture，而不是 live subscription
- footer 导航要复制 bridge pill 的 render condition，避免 invisible selection stop
- `useReplBridge` 如何填充 / 清空 `replBridgeConnectUrl`、`replBridgeSessionUrl`、IDs，是 dialog surface 的实现细节
- `bridge_status` 的 special-case 可见性与普通 `info` message 的可见性差异，属于当前实现层证据

这些更适合作为：

- 当前实现证据

而不是：

- 对外稳定承诺

## 第十二层：苏格拉底式自审

### 问：我现在写的是 URL presence，还是 runtime projection？

答：如果答不出来，就把 `remoteSessionUrl` 和 brief line 混了。

### 问：我是不是把 bridge pill 的缺席写成了 bridge 的缺席？

答：如果是，就把 summary surface 写成 existence proof 了。

### 问：我是不是把 bridge dialog 写成了 pill 的展开态？

答：如果是，就把 inspect surface 和 summary surface 压平了。

### 问：我是不是把 attached viewer 写成了 `--remote` URL mode？

答：如果是，就漏掉了 transcript attach signer。

### 问：我是不是只看见文案像，就断言它们属于同一种 surface？

答：如果是，就把 `bridge_status` 和普通 `info` 混了。

### 问：我是不是把当前实现里的 lazy capture 或 render gate 写成了稳定产品合同？

答：如果是，就把 internal-gray 细节外推过头了。

## 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooter.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInput.tsx`
- `claude-code-source-code/src/components/BridgeDialog.tsx`
- `claude-code-source-code/src/components/Spinner.tsx`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/commands/session/session.tsx`
- `claude-code-source-code/src/components/messages/SystemTextMessage.tsx`
