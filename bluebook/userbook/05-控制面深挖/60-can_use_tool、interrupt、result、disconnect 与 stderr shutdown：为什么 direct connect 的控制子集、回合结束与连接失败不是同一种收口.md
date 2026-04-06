# `can_use_tool`、`interrupt`、`result`、`disconnect` 与 `stderr shutdown`：为什么 direct connect 的控制子集、回合结束与连接失败不是同一种收口

## 用户目标

不是只知道 direct connect 里：

- 有时会弹权限确认
- 按 `Escape` 能停
- 一轮结束后 loading 会消失
- 断线时会看到报错并退出

而是先拆开七类不同对象：

- 哪些是在说 SDK 协议全集里本来允许什么 control request。
- 哪些是在说 direct connect 实际只承接其中的窄子集。
- 哪些是在说本地权限弹层只是对远端请求的合成投影。
- 哪些是在说 `interrupt` 只是取消当前回合，而不是断开连接。
- 哪些是在说 `result` 只是 turn end，不等于 transport close。
- 哪些是在说真正的 transport death 会写固定 stderr 并触发退出。
- 哪些只是协议线上发生过，但故意不进入可见状态面。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“关闭”：

- unsupported `control_request`
- `can_use_tool`
- `PermissionRequest` overlay
- `interrupt`
- `result`
- `disconnect()`
- `Server disconnected.`
- `Failed to connect to server at ...`
- `control_response`
- `keep_alive`

## 第一性原理

direct connect 的“这次为什么停、为什么没显示、为什么退出”至少沿着六条轴线分化：

1. `Protocol Surface`：SDK schema 允许什么控制消息。
2. `Implemented Subset`：direct connect 实际只处理哪些控制消息。
3. `Permission Projection`：远端权限请求怎样被本地合成为 UI overlay。
4. `Turn Control`：当前是在 cancel 当前回合，还是在结束整个连接。
5. `Turn Completion`：当前只是收到 `result`，还是 transport 已经死掉。
6. `Visible State Surface`：哪些协议事件会进入正文/overlay/stderr，哪些只停在内部过滤层。

因此更稳的提问不是：

- “direct connect 这次怎么又关闭了？”

而是：

- “当前发生的是 unsupported request 被回错、权限请求被本地投影、当前回合被 interrupt、当前 turn 已收到 result，还是 socket 真正断了；用户看到的是 transcript、overlay、stderr，还是根本不会看到？”

只要这六条轴线没先拆开，正文就会把 direct connect 的控制子集、回合收口和连接失败写成同一个动作。

这里也要主动卡住几个边界：

- 这页讲的是 direct connect 的控制子集、权限投影与退出传播。
- 不重复 59 页对 `cc://`、`createDirectConnectSession(...)`、`ws_url` 与 `work_dir` 的 session factory 语义。
- 不重复 57 页对三种 remote hook 的总比较。
- 不重复 56 页对 remote bridge 控制交接的总论。
- 不重复 58 页 attached viewer 的 transcript / loading / title ownership。

## 第一层：协议全集比 direct connect 实际支持面更宽

### SDK control schema 里不只有 `can_use_tool`

`controlSchemas.ts` 能看到的控制请求族至少包括：

- `initialize`
- `interrupt`
- `can_use_tool`
- `set_permission_mode`
- `set_model`
- `set_max_thinking_tokens`

这说明协议层回答的问题不是：

- “direct connect 当前会处理什么”

而是：

- “SDK 会话总体可能出现哪些控制请求”

### 但 `DirectConnectSessionManager` 对入站只正式处理 `can_use_tool`

`directConnectManager.ts` 对 `control_request` 的处理非常硬：

- 如果 subtype 是 `can_use_tool`，进入本地权限处理
- 否则直接 `sendErrorResponse(...)`

而且注释明确写了目的：

- 避免 server 永远等不到 reply

这说明 unsupported `control_request` 回错通常不是：

- “server 实现坏了”

而是：

- direct connect 故意只实现了一个窄控制子集

只要这一层没拆开，正文就会把“协议允许”和“当前 direct connect 真承接了什么”写成同一层能力。

## 第二层：权限弹层是本地合成投影，不是远端 transcript 本体

### `can_use_tool` 会被包装成本地 `ToolUseConfirm`

`useDirectConnect.ts` 收到权限请求后会做三步：

- `findToolByName(...)`，本地能识别就用本地 tool
- 识别不了就 `createToolStub(...)`
- 再用 `createSyntheticAssistantMessage(...)` 造一条本地 assistant message 形状，塞进 `toolUseConfirmQueue`

这说明它回答的问题不是：

- “远端已经把真实 assistant transcript 原封不动发给你了”

而是：

- “本地为了复用现有权限 UI，把远端权限请求投影成一条可消费的确认对象”

### 所以本地看到的权限弹层不等于远端真的发来一条普通 assistant 消息

更准确的理解应是：

- 远端：发一个 `can_use_tool` 控制请求
- 本地：合成 assistant/tool_use 外形，驱动 `PermissionRequest` overlay

只要这一层没拆开，正文就会把：

- 权限弹层
- transcript 正文

写成同一种消息来源。

## 第三层：`interrupt` 取消的是当前回合，不是整个连接

### REPL 在 remote mode 下优先把 `Escape` 送到 `cancelRequest()`

`REPL.tsx` 里，当当前处在 remote mode 时：

- `activeRemote.cancelRequest()`

对于 direct connect，这条线最后会走到：

- `sendInterrupt()`
- `setIsLoading(false)`

### outbound `interrupt` 是一条显式控制请求，不等于 socket close

`directConnectManager.ts` 发出的内容是：

- `type: 'control_request'`
- `request.subtype: 'interrupt'`

这说明它回答的问题不是：

- “本地是不是要主动断开 direct server socket”

而是：

- “当前回合要不要被中断”

只要这一层没拆开，正文就会把：

- cancel 当前 turn
- 断开整个 direct connect

写成同一种停止。

## 第四层：`result` 只说明一轮结束，不说明连接结束

### `isSessionEndMessage(...)` 在 direct connect 下只拿来关 loading

`sdkMessageAdapter.ts` 里：

- `isSessionEndMessage(msg) => msg.type === 'result'`

而 `useDirectConnect.ts` 收到这类消息时只先做：

- `setIsLoading(false)`

然后仍然继续把消息转换后送进本地 transcript。

这说明它回答的问题不是：

- “当前 direct connect 会话已经结束”

而是：

- “这一轮请求已经有了回合级结果”

### 所以 turn end 与 transport end 不是同一种收口

更准确的理解应是：

- `result`：当前回合结束
- transport close：整个 direct socket 不可用

只要这一层没拆开，正文就会把：

- 一轮完成
- 整条连接死亡

写成同一种结束。

## 第五层：真正的连接失败只投影成固定 stderr 与退出，不是一张持续更新的状态面

### `onDisconnected` 区分“从未连上”与“连上后掉线”

`useDirectConnect.ts` 里，`onDisconnected` 会看：

- `isConnectedRef.current`

然后分两种文案：

- 从未连上：`Failed to connect to server at ...`
- 连上后掉线：`Server disconnected.`

但两边最后都会：

- `gracefulShutdown(1)`

### `onError` 只进 debug，不直接变成用户可见状态

`onError` 本身只：

- `logForDebugging(...)`

不负责把信息上屏。

这说明 direct connect 的用户可见失败面不是：

- 一张实时更新的 server health dashboard

而是：

- 固定 stderr 文案 + 进程退出

只要这一层没拆开，正文就会把：

- protocol error
- transport close
- stderr failure text

写成同一种状态更新。

## 第六层：协议线上发生过的很多事，故意不进入用户可见面

### manager 会主动滤掉一批消息族

`directConnectManager.ts` 在转发消息前会跳过：

- `control_response`
- `keep_alive`
- `control_cancel_request`
- `streamlined_text`
- `streamlined_tool_use_summary`
- `system.post_turn_summary`

`sdkMessageAdapter.ts` 也会对未知类型：

- 记录 debug
- `return { type: 'ignored' }`

### 再加上一层 duplicate init suppression，本地看见的永远比线上的少

`useDirectConnect.ts` 又额外做了：

- duplicate `system.init` suppression

因此更准确的理解应是：

- 线上协议事件很多
- REPL 故意只暴露少数高价值投影

只要这一层没拆开，正文就会把：

- “没显示在 UI”
- “协议层什么都没发生”

写成同一件事。

## 第七层：REPL 对 direct server 的感知面很窄，不应脑补成完整远端状态板

### 用户主要只会通过三种面看到 direct connect

当前源码里，用户感知 direct connect 的主入口很窄：

- 启动时 main 注入一条 `Connected to server at ...` 的 system message
- 运行中 transcript 接收转换后的普通消息
- 权限请求时弹本地 `PermissionRequest` overlay
- 断线时 stderr 文案 + 退出

这说明本页真正回答的问题不是：

- “direct server 的完整运行态到底有哪些字段”

而是：

- “哪些协议事件会被投影到用户面，哪些不会”

只要这一层没拆开，正文就会把 direct connect 想象成另一张 remote session status 面板。

## 第八层：stable、conditional 与 internal 三层要分开保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | direct connect 只正式承接窄控制子集；`interrupt`、`result` 与 transport close 不是同一种收口；用户主要通过 system message、permission overlay 与 stderr 感知 direct connect |
| 条件公开 | 权限 UI 取决于本地是否能识别 tool；`Failed to connect` 与 `Server disconnected` 取决于是否曾成功连接；只有 remote mode 下 `Escape` 才会走 `cancelRequest()` |
| 内部/实现层 | synthetic assistant message、tool stub、duplicate init suppression、filtered message families、`onError` 仅进 debug |

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| unsupported `control_request` = server bug 或消息丢了 | 这是 direct connect 的显式子集边界，manager 会直接回 error |
| 权限弹层 = 远端发来了一条普通 assistant 消息 | 本地是在合成一个可供 `PermissionRequest` 消费的投影 |
| `interrupt` = 断开 direct connect | 它只取消当前回合 |
| 收到 `result` = 连接结束 | 这只代表当前回合结束 |
| `Server disconnected.` = 远端 stderr 原样回显 | 这是 hook 本地写出的固定 stderr 文案 |
| UI 没显示 `control_response` / `keep_alive` = 线上什么都没发生 | 这些消息被故意过滤掉了 |

## 七个检查问题

- 当前说的是协议全集，还是 direct connect 实际实现的子集？
- 现在看到的是 transcript 正文，还是本地合成的 permission overlay？
- 当前动作是在 interrupt 当前 turn，还是 transport 已经关闭？
- 这只是收到 `result`，还是整个 direct socket 已经死掉？
- 当前失败提示来自远端 stderr，还是本地 hook 自己写的 stderr？
- 这是协议线上真的没发生，还是被过滤后不显示？
- 我是不是又把 direct connect 写成完整 remote control plane 了？

## 源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/remote/remotePermissionBridge.ts`
- `claude-code-source-code/src/remote/sdkMessageAdapter.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
