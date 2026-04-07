# `createDirectConnectSession`、`DirectConnectSessionManager`、`useDirectConnect`、`remoteSessionUrl` 与 `replBridgeConnected`：为什么 direct connect 更像 foreground remote runtime，而不是 remote presence store

## 用户目标

132 已经把三条远端链路先粗分成：

- direct connect：更多只是前台事件投影
- remote session：event projection + partial shadow
- bridge：更接近 transcript / footer / dialog / store 对齐

134 又把 bridge 内部继续拆成：

- v1：local surface 仍在，但 worker-side chain 很薄
- v2：local surface + worker-side authoritative chain

但如果到这里停住，读者还是很容易把 direct connect 写成一句看似顺口、实际上仍然太粗的话：

- “它只是没有 bridge dialog / remote footer 的另一种远端模式。”

这句不稳。

从当前源码看，direct connect 缺的不是一两个 UI 组件，

而是：

- 它从启动合同开始，就没有被建模成一张可持续消费的 remote presence ledger

所以这一页要补的不是：

- “为什么 direct connect 的 UI 更薄”

而是：

- “为什么 direct connect 当前更像 foreground remote runtime，而不是 remote presence store”

## 第一性原理

更稳的提问不是：

- “direct connect 为什么没有 remote footer / bridge dialog？”

而是先问五个更底层的问题：

1. direct connect 启动时到底拿到了一份什么合同，是 presence ledger，还是只是一份交互传输配置？
2. direct connect 的运行态现在写进了哪张本地账，是 `AppState`，还是局部 hook ref / queue / transcript？
3. direct connect 当前的前台面是 dedicated store consumer，还是复用现成 transcript、loading、permission overlay？
4. direct connect 断线后当前是进入 reconnect / manage 语义，还是直接 terminal exit？
5. direct connect 当前有没有任何 authoritative 字段，能被 footer / dialog / `/session` 这类 surface 当作长期 presence 来消费？

只要这五轴先拆开，direct connect 就不会再被写成：

- “少几个状态字段的 remote viewer”

## 第一层：`createDirectConnectSession()` 给的是薄传输合同，不是 presence 合同

`createDirectConnectSession.ts` 当前返回的东西非常克制：

- `session_id`
- `ws_url`
- `work_dir`

转换后进入 `DirectConnectConfig` 的也只有：

- `serverUrl`
- `sessionId`
- `wsUrl`
- `authToken`

这一步最重要的不是“字段少”，

而是：

- 它没有 browser URL
- 没有 reconnect budget
- 没有 detached / resume ledger
- 没有 background-task count
- 没有 dedicated remote status

也就是说，direct connect 启动时交给 REPL 的更像：

- 一份 foreground interactive transport config

而不是：

- 一份可持续展示 remote presence 的 authoritative contract

这和 `--remote` 的起点已经不是同一类东西。

## 第二层：`main.tsx` 对 direct connect 的启动主语是“进入交互 TUI”，不是“挂上一张远端存在面”

`main.tsx` 在 direct connect 分支上的注释写得很直接：

- `claude connect <url> — full interactive TUI connected to a remote server`

启动时做的事情也很克制：

- 调 `createDirectConnectSession(...)`
- 可选地把 `workDir` 回写到当前 cwd
- `setDirectConnectServerUrl(...)`
- 插入一条 `Connected to server at ...` 的 info system message
- 带着 `directConnectConfig` 进入 `launchRepl(...)`

注意这里没做的事更关键：

- 没有写 `remoteSessionUrl`
- 没有切出一套 dedicated remote initial state
- 没有给 footer / dialog / `/session` 建立长期消费入口

对照同一文件的 `--remote` 分支，就能看见边界非常清楚：

- `--remote` 会生成 `remoteSessionUrl`
- 会把它写进 `remoteInitialState`
- 会显式为 footer indicator 留入口

所以 direct connect 这里的产品主语不是：

- “我现在有一张远端会话面板”

而是：

- “我现在正在一个前台 REPL 里直接和远端会话交互”

## 第三层：`useDirectConnect()` 当前只消费三类本地面，没有写任何 dedicated remote ledger

`useDirectConnect.ts` 的 props 已经把边界讲得很清楚：

- `setMessages`
- `setIsLoading`
- `setToolUseConfirmQueue`

它真正持有的运行态也很薄：

- `managerRef`
- `hasReceivedInitRef`
- `isConnectedRef`
- `toolsRef`

它没有：

- `useSetAppState()`
- `remoteConnectionStatus` 写路径
- `remoteBackgroundTaskCount` 写路径
- `replBridge*` 写路径

它对消息的处理也都落在本地现成 surface 上：

- session end -> `setIsLoading(false)`
- 远端普通消息 -> `convertSDKMessage(...)` 后追加进 transcript
- `can_use_tool` -> 合成 `ToolUseConfirm`，推进 permission queue
- allow / deny / abort -> 回发远端权限响应，并同步本地 queue / loading

因此 direct connect 当前真正消费的是：

- transcript
- loading shell
- permission overlay

不是：

- dedicated remote store

这就是“有事件，没有账本”。

## 第四层：`DirectConnectSessionManager` 会主动过滤 wire，不把它升格成 shared remote truth

如果只看 direct connect 是 WebSocket，很容易误写成：

- “远端发什么，本地就消费什么。”

但 `directConnectManager.ts` 实际上已经主动做了裁剪。

它会单独处理：

- `control_request.can_use_tool` -> permission callback

它会直接忽略：

- `control_response`
- `keep_alive`
- `control_cancel_request`
- `streamlined_text`
- `streamlined_tool_use_summary`
- `system.post_turn_summary`

剩下的消息才会进：

- `callbacks.onMessage(...)`

而 `onMessage(...)` 在 `useDirectConnect()` 里又还要经过：

- `convertSDKMessage(...)`

再投影进 transcript。

于是 direct connect 的 consumer path 不是：

- raw wire -> authoritative store

而是：

- raw wire -> filtered wire -> transcript / loading / permission projection

这一步已经足够说明：

- direct connect 当前不是一套 dedicated remote UI subsystem

## 第五层：`sdkMessageAdapter` 进一步证明它更多是 transcript projection，而不是状态账本

`sdkMessageAdapter.ts` 在 direct connect / remote session 这类路径里，对 system 事件的处理很克制：

- `system.init` -> 转成 transcript message
- `system.status` -> 条件转成 transcript message
- `compact_boundary` -> 转成 transcript message
- 其他 system subtype -> ignored

同时：

- success `result` -> ignored
- error `result` -> visible message

这说明 direct connect 当前回答的问题更像：

- “哪些远端事件值得让本地用户看见”

而不是：

- “哪些远端事件应该进入一张可长期复用的状态表”

换句话说，它是：

- transcript projection policy

不是：

- state ledger policy

## 第六层：footer、dialog、`/session` 这些 dedicated surface 都依赖别的 authoritative 账本，而 direct connect 根本没写进去

这一步最容易被忽略。

因为很多人会下意识觉得：

- “既然 direct connect 也是 remote mode，那应该只是还没把 UI 接完。”

但当前 repo 里，dedicated remote surface 都不是凭空长出来的，

而是：

- 先有账本
- 再有 UI

`AppStateStore.ts` 对这两套账定义得很清楚：

- remote session 线：`remoteSessionUrl`、`remoteConnectionStatus`、`remoteBackgroundTaskCount`
- bridge 线：整组 `replBridge*`

对应消费面也很明确：

- `PromptInputFooterLeftSide.tsx` 的 remote 链接只认 `remoteSessionUrl`
- `PromptInput.tsx` / `PromptInputFooter.tsx` / `BridgeDialog.tsx` 的 bridge 面只认 `replBridge*`
- `commands/session/session.tsx` 没有 `remoteSessionUrl` 就直接提示 `Not in remote mode`

而 direct connect 目前：

- 不写 `remoteSessionUrl`
- 不写 `remoteConnectionStatus`
- 不写 `remoteBackgroundTaskCount`
- 不写任何 `replBridge*`

所以结论不是：

- “direct connect 少接了几个 consumer”

而是：

- 它根本没有把自己提升成那些 consumer 所需要的 authoritative ledger

## 第七层：`REPL.tsx` 对 direct connect 的定位是 active remote runtime sibling，不是 viewer / presence 特例

`REPL.tsx` 把三类远端互动源并列起来：

- `useDirectConnect(...)`
- `useSSHSession(...)`
- `useRemoteSession(...)`

然后选出：

- `activeRemote`

这里最值得注意的不是“它们都算 remote”，

而是：

- `useDirectConnect` 和 `useSSHSession` 是 sibling
- 两者都更像 foreground interactive runtime transport
- `useRemoteSession` 才是另一种 viewer / session presence 语义

`useSSHSession.ts` 的文件头也把这层关系写得非常直白：

- 它是 `useDirectConnect` 的 sibling
- callback shape 相同，只是底层 transport 不同

所以 direct connect 当前的抽象中心更接近：

- interactive remote runtime

而不是：

- presence-bearing session viewer

## 第八层：断线语义是 terminal exit，而不是 reconnect / manage / detach

如果一条链路真的被设计成 remote presence store，

那你通常会期待：

- reconnect
- manage
- detach / resume
- status decay

但 `useDirectConnect.ts` 的 `onDisconnected()` 当前做的是：

- 打 stderr
- 区分“从未连上”和“连上后断开”
- `gracefulShutdown(1)`
- `setIsLoading(false)`

这是一种很明确的终止式语义：

- foreground runtime 结束了

它不是：

- “presence 还在，只是连接态变化了”

也正因为如此，direct connect 当前并不会自然长出：

- bridge dialog 那种“继续管理远端连接”
- remote session 那种“维持一张远端存在面”

## 第九层：所以 direct connect 当前更准确的定义是“前台远端运行时”

把前面几层压成一句，更稳的一句是：

- direct connect is a foreground remote runtime, not a remote presence store

也就是说它当前更像：

### 已经具备的

- 远端交互 transport
- transcript projection
- permission request queue
- loading lifecycle
- fatal disconnect handling

### 当前没有具备的

- dedicated remote presence ledger
- footer / dialog / `/session` 所依赖的 authoritative remote state
- reconnect / manage / detach / resume 语义
- background-task durable accounting

所以 direct connect 目前不是：

- “bridge / remote viewer 的简化 UI”

而是：

- “把远端 SDK 流裁剪后，接入本地 REPL 现成前台壳的一种运行模式”

## 第十层：为什么它不是 132、134 的重复页

### 它不是 132

132 讲的是三条链路对比：

- direct connect
- remote session
- bridge

135 讲的是 direct connect 自己为什么没有长成 dedicated remote presence store。

一个讲：

- cross-path split

一个讲：

- direct-connect internal contract boundary

### 它不是 134

134 讲的是 bridge 内部 v1 / v2 的 chain depth 分叉。

135 讲的是 direct connect 从启动合同、consumer path、disconnect semantics 到 dedicated surface 入口都属于另一种产品边界。

一个讲：

- bridge version split

一个讲：

- direct connect product / store split

## 第十一层：最常见的四个假等式

### 误判一：direct connect 只是 `--remote` 少写了一个 URL

错在漏掉：

- 它缺的不只是 `remoteSessionUrl`
- 它从合同、ledger、disconnect semantics 到 consumer path 都不是同一种设计

### 误判二：只要 transcript 里能看到远端事件，就等于已经有 remote state store

错在漏掉：

- transcript projection 和 authoritative ledger 不是一回事

### 误判三：bridge footer / dialog 只要稍微复用一下，也可以直接挂到 direct connect

错在漏掉：

- 这些 UI 先要有 `remoteSessionUrl` 或 `replBridge*` 这类可持续账本

### 误判四：断线后退出，只是当前 UI 没做完

错在漏掉：

- terminal exit 本身就是一种产品边界声明：这是 foreground runtime，不是可旁路管理的 presence

## 第十二层：stable / conditional / internal

### 稳定可见

- direct connect 启动合同当前只提供 `session_id / ws_url / work_dir`
- `useDirectConnect()` 当前只写 transcript、loading、permission queue
- `DirectConnectSessionManager` 当前会主动过滤多类 wire message
- dedicated remote footer / dialog / `/session` 当前都不消费 direct connect 自身状态
- 断线当前是 terminal `gracefulShutdown(1)`

### 条件公开

- 如果以后 direct connect 增加 browser URL、detach / resume、reconnect budget、background-task ledger，它才可能自然长出 dedicated remote surface
- 如果以后单独给 direct connect 增加 mode badge，那也只代表 mode affordance，不等于它已经拥有 authoritative presence store
- direct connect 与 ssh remote 共享一层 activeRemote 形状，但这不自动推出它们与 remote session / bridge 共享同一种前台状态消费链

### 内部 / 灰度层

- 当前过滤哪些 wire subtype、未来是否扩大 / 缩小 transcript 显示面
- direct connect 后续会不会演化出更厚的 reconnect / manage 语义
- direct connect server 自身的 session persistence 是否会被前台显式消费

这些更适合作为：

- 当前实现证据

而不是：

- 永不变化的产品承诺

## 第十三层：苏格拉底式自审

### 问：我现在写的是“有远端事件”，还是“有远端状态账本”？

答：如果答不出来，就把 projection 和 ledger 混了。

### 问：我是不是把 `claude connect <url>` 的 TUI 交互体验，偷换成了 `--remote` 那种 presence 体验？

答：如果是，就把 foreground runtime 和 remote presence 写成了一回事。

### 问：我是不是因为它也叫 remote mode，就默认 footer / dialog / `/session` 应该天然适用？

答：如果是，就漏掉了这些 surface 背后的 authoritative ledger 前提。

### 问：我是不是把 terminal disconnect 当成了“只是暂时没做 reconnect UI”？

答：如果是，就没有尊重当前产品边界。

### 问：我是不是又回到 132 的三路径总对比，而没有真正进入 direct connect 自身的合同厚度？

答：如果是，就还没真正进入 135。

## 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/server/createDirectConnectSession.ts`
- `claude-code-source-code/src/server/types.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/hooks/useSSHSession.ts`
- `claude-code-source-code/src/remote/sdkMessageAdapter.ts`
- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInput.tsx`
- `claude-code-source-code/src/commands/session/session.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
