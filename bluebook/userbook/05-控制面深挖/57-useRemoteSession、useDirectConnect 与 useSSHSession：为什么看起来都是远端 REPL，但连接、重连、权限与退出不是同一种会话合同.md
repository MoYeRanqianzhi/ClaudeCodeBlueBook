# `useRemoteSession`、`useDirectConnect` 与 `useSSHSession`：为什么看起来都是远端 REPL，但连接、重连、权限与退出不是同一种会话合同

## 用户目标

不是只知道 Claude Code 里“`--remote`、`connect/open`、`ssh` 最后都能进一个远端 REPL”，而是先分清六类不同对象：

- 哪些只是把当前 REPL 包成同一个四元接口。
- 哪些通过远端 session WebSocket / Sessions API 驱动。
- 哪些直接连到一台 Claude Code server。
- 哪些其实是 SSH child process 与 auth proxy 在后面跑。
- 哪些会主动重连，哪些一断就直接退出。
- 哪些会接管 title、interrupt、timeout watchdog，哪些不会。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“远端连接”：

- `useRemoteSession`
- `useDirectConnect`
- `useSSHSession`
- `isRemoteMode / sendMessage / cancelRequest / disconnect`
- `viewerOnly`
- `hasInitialPrompt`
- `sendInterrupt()`
- `gracefulShutdown(1)`

## 第一性原理

看起来同样是“远端 REPL”，实际至少沿着五条轴线分化：

1. `Transport Shape`：当前背后是 Sessions API + WebSocket、server 直连 WebSocket，还是 SSH child process。
2. `Ownership`：当前本地客户端是否拥有 title rewrite、interrupt、timeout watchdog 这些上层动作。
3. `Reconnect Policy`：当前是主动重连、提示后重连，还是一旦断开就直接失败退出。
4. `Permission Contract`：当前远端权限请求是完整 remote-session 合同，还是只支持 `can_use_tool` 这一条窄路径。
5. `Exit Surface`：当前断开后暴露给用户的是 reconnect warning、server disconnected，还是 remote stderr + exit code。

因此更稳的提问不是：

- “反正最后都能连到远端，不就是同一种 remote mode 吗？”

而是：

- “这次远端 REPL 背后到底是谁在连、谁在重连、谁在回答权限请求、谁在断开时宣布失败；当前本地客户端又是否真的拥有上层控制权？”

只要这五条轴线没先拆开，正文就会把 `useRemoteSession`、`useDirectConnect` 与 `useSSHSession` 写成同一种远端会话。

这里也要主动卡住一个边界：

- 这页讲的是三种远端会话 hook 的运行时合同差异
- 不重复 21 页对 host / viewer / health check 会外入口的总览
- 不重复 28 页对 remote session client、viewer 与 bridge host 的高层工作流划分
- 不重复 30 页对 `viewerOnly` ownership 与远端运行态面的拆分
- 这页也不是所有远端入口的 CLI 旗标索引

## 第一层：三条线先被压成同一个 REPL 接口，但这只是表面统一

### `REPL.tsx` 只消费一个四元接口

`REPL.tsx` 会分别创建：

- `useRemoteSession(...)`
- `useDirectConnect(...)`
- `useSSHSession(...)`

然后统一折成：

- `isRemoteMode`
- `sendMessage`
- `cancelRequest`
- `disconnect`

再用 `activeRemote` 选择当前生效的一条。

这说明 REPL 回答的问题不是：

- 三条线是否真是同一种远端协议

而是：

- 在 UI 层面，当前要不要显示成“有一个远端会话对象”

### 所以接口相同，不等于生命周期相同

更准确的理解应是：

- 同一个 hook result shape：为了让 REPL 统一消费
- 不同的 transport / reconnect / permission / exit 语义：仍然各自存在

只要这一层没拆开，正文就会把“相同接口”误写成“相同合同”。

## 第二层：`useRemoteSession` 背后是 remote session client 合同，不是普通 server socket

### 它通过 `RemoteSessionManager` 驱动一条现成 session

`useRemoteSession` 的底层对象是：

- `RemoteSessionManager`
- `SessionsWebSocket`

它解决的问题不是：

- 怎么连一台任意 Claude Code server

而是：

- 怎么附着或拥有一条现成的 remote session

### 这条线还区分 `viewerOnly` 与 `hasInitialPrompt`

`createRemoteSessionConfig(...)` 里有两个直接影响用户体验的字段：

- `viewerOnly`
- `hasInitialPrompt`

它们的后果分别是：

- `viewerOnly` 时不接管 title、timeout watchdog、`Ctrl+C` interrupt
- `hasInitialPrompt` 时，REPL 初始就把 `isExternalLoading` 设成 true，表示远端已经在处理首问

这说明它回答的问题不是：

- “是不是只要连上远端就都一样”

而是：

- “当前本地 REPL 是这条 session 的 owner，还是附着 viewer；首问又是不是远端已经先在跑”

### 所以 `useRemoteSession` 是 session ownership 合同

更准确的理解应是：

- 这条线的核心对象是 remote session
- transport 只是它的实现手段之一

只要这一层没拆开，正文就会把 `useRemoteSession` 与 direct-connect 写成同一种 socket client。

## 第三层：`useDirectConnect` 背后是 server 直连合同，不是 session ownership 合同

### 它直接连一台 server，而不是先走 session ownership 那套外围对象

`useDirectConnect` 的底层对象是：

- `DirectConnectSessionManager`
- 直接拿 `wsUrl`

`main.tsx` 里 `claude connect <url>` / `open <cc-url>` 的入口也很直接：

- 先 `createDirectConnectSession(...)`
- 再把拿到的 `directConnectConfig` 喂给 REPL

这说明它回答的问题不是：

- 如何接入一条 claude.ai remote session

而是：

- 如何把当前 REPL 直接接到一台 Claude Code server

### 所以断开语义是 fail-fast，而不是“尽量继续拥有这条 session”

`useDirectConnect` 的 `onDisconnected` 行为很硬：

- 从未连上 -> 打印 `Failed to connect to server`
- 连上后断开 -> 打印 `Server disconnected.`
- 然后 `gracefulShutdown(1)`

它并没有像 `useRemoteSession` 那样：

- 先发 warning message
- 再尝试 `manager.reconnect()`

所以更准确的理解应是：

- direct connect：server socket 存活合同
- remote session：session ownership 合同

只要这一层没拆开，正文就会把 direct connect 误写成另一种 `--remote`。

## 第四层：`useSSHSession` 背后是 SSH child process 合同，不是 WebSocket 合同

### 它不是自己创建 transport，而是接手一个已经准备好的 SSH session

`useSSHSession.ts` 顶部注释写得很明白：

- sibling to `useDirectConnect`
- same shape
- 但驱动的是 SSH child process
- ssh process 与 auth proxy 在 hook 运行前就已经准备好

这说明它回答的问题不是：

- 怎么在 hook 里自己创建一个 WebSocket 连接

而是：

- 怎么把已经启动的 SSH child process 接进 REPL

### 所以它的断开面会带上 remote stderr 与 exit code

`useSSHSession` 的 `onDisconnected` 会：

- 判断是否曾经成功 connected
- 读 `session.getStderrTail()`
- 按 exit code / signal 拼出最终错误消息
- `gracefulShutdown(1, ..., { finalMessage: msg })`

这说明它回答的问题不是：

- “server socket 是否断了”

而是：

- “远端 shell / process 到底怎样退出，stderr 是否该直接暴露给用户”

### 它还有一套自己的 reconnect 提示面

`useSSHSession` 的 `onReconnecting(attempt, max)` 会：

- 写一条 transcript system message
- 明示 `SSH connection dropped — reconnecting (attempt X/Y)...`

所以更准确的理解应是：

- SSH 线是 process-oriented remote session
- WebSocket 线是 socket-oriented remote session

只要这一层没拆开，正文就会把 SSH 断线和 server socket 断线写成同一种退出。

## 第五层：三条线都能收权限请求，但合同宽度并不一样

### `useRemoteSession` 走的是完整 remote session permission path

`useRemoteSession` 能：

- 接 `onPermissionRequest`
- 处理 `onPermissionCancelled`
- 通过 `respondToPermissionRequest(...)` 回 allow/deny
- 同时还会处理 remote session 特有的 title ownership、viewerOnly、timeout watchdog

这说明它处理的不是：

- 一个孤立的权限弹窗

而是：

- 整条 remote session 里的权限与 ownership 合同

### `useDirectConnect` 与 `useSSHSession` 都只把 `can_use_tool` 当成窄路径

两条线都有：

- duplicate init suppression
- `onPermissionRequest`
- `respondToPermissionRequest(...)`

但它们背后的 manager 都明显更窄：

- DirectConnect 对不认识的 `control_request` subtype 会直接发 protocol `error`
- SSH 这条线则主要围绕 child process 的 permission ask / answer 与 reconnect / disconnect

这说明它们回答的问题不是：

- 所有 remote session control plane

而是：

- 在这条 transport 下，最小可用的 permission roundtrip 是什么

### 所以“都能批准权限”不等于“都是同一种控制面”

更准确的理解应是：

- remoteSession：ownership + permission + reconnect contract
- directConnect / ssh：transport-specific permission roundtrip

只要这一层没拆开，正文就会把三条线都写成“远端权限模式”。

## 第六层：重连策略也不是同一层对象

### `useRemoteSession` 是 watchdog 驱动的 subscription reconnect

它会：

- 清 response timeout
- 在超时后加一条 warning message
- 然后 `manager.reconnect()`

并且：

- `viewerOnly` 时会跳过这条主动 timeout watchdog

这说明它回答的问题不是：

- 任意网络断了以后怎么都重试

而是：

- session subscription stale 时，本地是否作为 owner 主动修复这条附着链

### `useDirectConnect` 根本没有这一层 owner-side watchdog

它一旦断开，就：

- 打印失败信息
- `gracefulShutdown(1)`

所以这条线更像：

- fail-fast direct socket

### `useSSHSession` 则把重连尝试显式写进 transcript

它会：

- `onReconnecting(attempt, max)`
- 注入 warning system message
- 说明当前是 SSH connection dropped

所以更准确的区分是：

- remoteSession：owner-side watchdog reconnect
- directConnect：no reconnect contract in hook
- SSH：child-process reconnect attempts surfaced as transcript message

只要这一层没拆开，正文就会把所有“远端断线后怎么办”写成一种 reconnect。

## 第七层：title ownership 与 interrupt authority 只属于部分远端线

### `useRemoteSession` 才有 title ownership 这层合同

当：

- `!config.hasInitialPrompt`
- `!config.viewerOnly`

时，`useRemoteSession` 会：

- `generateSessionTitle(...)`
- `updateSessionTitle(...)`

旁边注释直接说：

- viewerOnly 时 remote agent owns the session title

这说明 title ownership 回答的问题不是：

- 当前是不是任何一种远端模式

而是：

- 当前本地客户端是不是这条 remote session 的上层 owner

### interrupt authority 也只属于 owner 线，或 transport-specific interrupt 线

- `useRemoteSession.cancelRequest()` 会在非 viewerOnly 时发 `cancelSession()`
- `useDirectConnect.cancelRequest()` 会发 `sendInterrupt()`
- `useSSHSession.cancelRequest()` 也会发 `sendInterrupt()`

这说明三条线都可能有 interrupt，但语义不同：

- remoteSession 的 interrupt 受 viewerOnly ownership 约束
- directConnect / ssh 的 interrupt 是 transport-local action

只要这一层没拆开，正文就会把“都能 Ctrl+C”写成同一种 authority。

## 第八层：stable、conditional 与 internal 三层要分开保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | 三条线共享同一个 REPL 四元接口，但 `useRemoteSession`、`useDirectConnect`、`useSSHSession` 的连接、重连、权限和退出合同不同 |
| 条件公开 | `viewerOnly` / `hasInitialPrompt` 改写 `useRemoteSession` 的 ownership；direct connect 对不支持的 control request 会回错；SSH 断开时会按是否曾成功连接与 exit code 决定是否展示 remote stderr |
| 内部/实现层 | duplicate init suppression ref、managerRef wiring、auth proxy 创建时机、底层 child/session manager 的实现细节 |

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 三条 hook 结果形状相同 = 会话合同相同 | 只是 REPL 统一消费，同形不等于同约 |
| `useRemoteSession` = `useDirectConnect` | 一个是 session ownership，一个是 server socket |
| `useDirectConnect` = `useSSHSession` | 一个是 WebSocket 直连，一个是 SSH child process |
| 所有远端断线都会先重连 | direct connect fail-fast，SSH 与 remote session 各有自己的重连/退出面 |
| 所有远端模式都拥有 title rewrite | 只有非 viewerOnly 的 remote session owner 才接管 title |
| 所有权限请求都属于同一控制面 | remoteSession 的权限合同明显比 directConnect/ssh 更宽 |

## 七个检查问题

- 当前远端 REPL 背后是 session WebSocket、server 直连，还是 SSH child process？
- 这里的“不一样”是在接口层，还是在生命周期层？
- 当前客户端是否拥有 title、interrupt、timeout watchdog 这些上层动作？
- 这条线断开后是应该重连、显示 warning，还是直接退出？
- 这条线处理的是完整 remote session permission contract，还是最小 permission roundtrip？
- 当前退出面应该暴露 server disconnected，还是 remote stderr + exit code？
- 我是不是又把三种远端线写成同一种 remote mode 了？

## 源码锚点

- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/hooks/useSSHSession.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/main.tsx`
