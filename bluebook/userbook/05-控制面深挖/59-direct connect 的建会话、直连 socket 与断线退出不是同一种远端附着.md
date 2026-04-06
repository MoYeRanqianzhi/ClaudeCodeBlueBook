# `cc://`、`open`、`createDirectConnectSession`、`ws_url` 与 `fail-fast disconnect`：为什么 direct connect 的建会话、直连 socket 与断线退出不是同一种远端附着

## 用户目标

不是只知道：

- `claude connect <url>`
- `cc://...`
- `claude open <cc-url> -p`

这些入口都能把本地 Claude Code 接到另一台 server。

而是先拆开七类不同对象：

- 哪些是在说 CLI 启动时如何把 `cc://` 改写成真正要走的入口。
- 哪些是在说本地先向 server `POST /sessions` 建一条新 session。
- 哪些是在说建完之后真正用来跑流式收发的是 `ws_url`。
- 哪些是在说 server 可能反过来指定 `work_dir`，改写本地当前工作目录。
- 哪些是在说 direct connect 只支持最窄的一层 permission roundtrip 与 interrupt。
- 哪些是在说这条线断开后直接退出，而不是像 remote session 那样继续处理 reconnect / ownership。
- 哪些只是共享了同一个 REPL 壳，而不是共享了同一份远端合同。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“远端附着”：

- `cc://` / `cc+unix://`
- `open <cc-url>`
- `createDirectConnectSession(...)`
- `serverUrl`
- `session_id`
- `ws_url`
- `work_dir`
- `useDirectConnect(...)`
- `can_use_tool`
- `interrupt`
- `Server disconnected.`

## 第一性原理

direct connect 的“我现在连上的到底是什么”至少沿着六条轴线分化：

1. `Entry Rewrite`：CLI 当前在改写 URL 入口，还是已经进入具体运行模式。
2. `Session Factory`：当前是在向 server 申请创建一条 session，还是已经拿到了可用配置。
3. `Transport Locator`：当前拿到的是 session 标识，还是实际的 WebSocket 地址。
4. `Workspace Authority`：当前本地 cwd 是否仍由本地决定，还是被 server 返回的 `work_dir` 改写。
5. `Control Surface`：当前支持的是完整远端控制面，还是只有最小 permission roundtrip 与 interrupt。
6. `Failure Policy`：当前断开后应该本地重连、提示等待，还是直接 fail fast 退出。

因此更稳的提问不是：

- “direct connect 不就是另一种 remote session 吗？”

而是：

- “当前这条信息是在说入口改写、建会话、传输地址、工作目录、控制往返，还是断线处置；我现在到底是在拥有一条 remote session，还是只是在直连一台 server 给我的 socket 会话？”

只要这六条轴线没先拆开，正文就会把 direct connect 写成 remote session / SSH / assistant attach 的近义词。

这里也要主动卡住几个边界：

- 这页讲的是 direct connect 的建会话、transport 与 fail-fast 合同。
- 不重复 21 页对 host / viewer / health check 的会外入口总览。
- 不重复 28 页对 remote session client、viewer 与 bridge host 的高层工作流划分。
- 不重复 57 页对三种 remote hook 的总比较。
- 不重复 58 页对 attached viewer transcript / loading / title ownership 的拆分。

## 第一层：`cc://` 与 `open <cc-url>` 先回答的是“怎么进场”，不是“session 已经怎么跑”

### `cc://` 会先被 argv 改写，再决定走交互态还是 headless

`main.tsx` 先扫描 argv 里的：

- `cc://`
- `cc+unix://`

随后按是否带：

- `-p`
- `--print`

做两种改写：

- headless 时，重写到内部 `open <cc-url>`
- 交互态时，把 URL 解出后塞进 `_pendingConnect`

这说明它回答的问题不是：

- “当前 WebSocket 已经建立没有”

而是：

- “同一个 connect URL 最终应该把 CLI 送进哪一种入口壳”

### 所以 `open` 不是另一种 session 类型，而是同一条合同的 headless 壳

`main.tsx` 里能看到两条消费线：

- 交互态 `_pendingConnect?.url` 进入 `launchRepl(...)`
- headless `open <cc-url>` 进入 `runConnectHeadless(...)`

但两边在真正跑之前都会先调用：

- `createDirectConnectSession(...)`

只要这一层没拆开，正文就会把：

- connect URL 的入口壳
- server 创建出来的 session

写成同一种对象。

## 第二层：`createDirectConnectSession(...)` 讲的是“向 server 申请新会话”，不是“现在已经开始流式对话”

### 它先 `POST ${serverUrl}/sessions`

`createDirectConnectSession.ts` 说得很直白：

- `fetch(${serverUrl}/sessions, { method: 'POST', ... })`
- body 里带 `cwd`
- 可选带 `dangerously_skip_permissions`

这说明它回答的问题不是：

- “当前消息怎么走进 REPL”

而是：

- “我要向 direct-connect server 申请一条可用 session，并拿回接下来运行所需的配置”

### network / HTTP / schema failure 都在这里被折叠成 `DirectConnectError`

同一个函数里又把三类失败收口为：

- 无法连上 server
- HTTP 非 2xx
- 返回体不符合 `connectResponseSchema`

最后统一抛成：

- `DirectConnectError`

这说明 direct connect 的第一道用户可见失败不是 socket runtime，而是：

- session factory verdict

只要这一层没拆开，正文就会把：

- “没建出 session”
- “session 建出来但后来断线”

写成同一种连接失败。

## 第三层：`session_id`、`ws_url` 与 `work_dir` 是三种不同产物

### `session_id` 不是 transport，`ws_url` 也不是“展示用 ID”

`connectResponseSchema` 的返回很窄：

- `session_id`
- `ws_url`
- `work_dir?`

随后 `createDirectConnectSession(...)` 把它们拆进：

- `config.sessionId = data.session_id`
- `config.wsUrl = data.ws_url`
- `workDir = data.work_dir`

这说明它们回答的是三类不同问题：

- `session_id`：server 侧这条会话的标识
- `ws_url`：本地真正建立流式 transport 的地址
- `work_dir`：server 希望这条会话在什么目录下工作

### 信息条展示的是 `sessionId`，真正 connect 的却是 `wsUrl`

交互态 `main.tsx` 会显示：

- `Connected to server at ...`
- `Session: ${directConnectConfig.sessionId}`

但 `useDirectConnect(...)` 实际 log 的是：

- `Connecting to ${config.wsUrl}`

只要这一层没拆开，正文就会把：

- 给用户看的 session 标识
- 真正连 transport 的地址

写成同一种 locator。

## 第四层：`work_dir` 会改写本地 cwd，它不是“显示信息”，而是 workspace 主权回填

### interactive 与 headless 都会吃 `session.workDir`

无论是交互态 `_pendingConnect?.url`，还是 headless `open <cc-url>`，`main.tsx` 都会在拿到结果后检查：

- `if (session.workDir) { ... }`

然后执行：

- `setOriginalCwd(session.workDir)`
- `setCwdState(session.workDir)`

这说明它回答的问题不是：

- “server 顺手告诉你一个目录描述”

而是：

- “这条 direct-connect session 的工作目录，可能应该由 server 反向指定”

### 所以“我从本地哪个 repo 发起 connect”与“session 最终在哪个目录跑”不是同一个问题

更准确的理解应是：

- 本地 `cwd`：作为建会话请求参数发给 server
- server `work_dir`：作为最终会话工作目录反写回本地状态

只要这一层没拆开，正文就会把：

- request input
- session effective workspace

写成同一种 cwd。

## 第五层：`useDirectConnect(...)` 是薄 socket client，不是 remote session owner

### REPL 只是把它当成共享四元接口的一种实现

`REPL.tsx` 里 direct connect 只是在共享接口位上被接进来：

- `isRemoteMode`
- `sendMessage`
- `cancelRequest`
- `disconnect`

随后再和：

- `useRemoteSession`
- `useSSHSession`

一起被 `activeRemote` 选中。

这说明它回答的问题不是：

- “当前是不是 remote session owner”

而是：

- “这条 REPL 背后有没有一条 direct server socket，可以满足统一的远端输入/打断/断开接口”

### 它没有 58 页那套 history / title / ownership 分叉

`useDirectConnect.ts` 能看到的重点是：

- 收到 SDK message 后转换进本地 messages
- 重复 `init` 要 suppress
- session end 时收掉 loading
- permission request 进本地确认队列

看不到的则包括：

- `viewerOnly`
- `hasInitialPrompt`
- `useAssistantHistory`
- `updateSessionTitle(...)`

只要这一层没拆开，正文就会把 direct connect 误写成“另一种 attached remote session”。

## 第六层：direct connect 的控制面是窄的，不是 generic remote control plane

### 入站只专门接 `can_use_tool`

`directConnectManager.ts` 对 `control_request` 的处理非常硬：

- 如果 subtype 是 `can_use_tool`，交给本地权限确认队列
- 否则立即 `sendErrorResponse(...)`

旁边的注释也写得很清楚：

- 不认识的 subtype 要直接回错
- 避免 server 一直等一个永远不会来的 reply

这说明它回答的问题不是：

- “任何 control request 都能被 direct connect 这条线托管”

而是：

- “这条线只支持最窄的一层工具权限 roundtrip”

### 出站则只额外提供 `interrupt`

`cancelRequest()` 最终只做两件事：

- `managerRef.current?.sendInterrupt()`
- `setIsLoading(false)`

而 `sendInterrupt()` 也只是发：

- `type: 'control_request'`
- `request.subtype: 'interrupt'`

所以更准确的理解应是：

- 入站：最窄的 `can_use_tool`
- 出站：最窄的 `interrupt`

只要这一层没拆开，正文就会把 direct connect 写成完整 remote bridge controller。

## 第七层：`fail-fast disconnect` 是 direct connect 的运行时合同，不是 remote reconnect 的退化版

### 没连上与连上后断开，都会直接走退出

`useDirectConnect.ts` 的 `onDisconnected` 分两种提示：

- 从未连上：`Failed to connect to server at ${config.wsUrl}`
- 已经连上后断开：`Server disconnected.`

但两边最后都会：

- `gracefulShutdown(1)`

这说明它回答的问题不是：

- “当前是不是应该展示一个临时断线状态，等等看会不会自动回来”

而是：

- “这条 direct socket 一旦不可用，本地这次会话就直接判失败收口”

### 所以 direct connect 的第一性原理是 fail fast，不是 local watcher + reconnect

这条线里没有：

- 本地 watchdog reconnect
- reconnect budget
- title ownership recovery
- history refill

它更像：

- 一条直连 transport，连不上或掉了就结束本地进程

只要这一层没拆开，正文就会把：

- remote session 的 continuity
- direct connect 的 fail-fast

重新写成同一种“远端断线体验”。

## 第八层：stable、conditional 与 internal 三层要分开保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | direct connect 先建会话、再拿 `ws_url` 连 transport；`session_id`、`ws_url`、`work_dir` 不是同一种返回；断线后本地直接退出 |
| 条件公开 | `DIRECT_CONNECT` gate 下才有 `cc://` / `open`; `dangerously_skip_permissions` 会下传到建会话请求；direct connect 入站控制面只公开 `can_use_tool`，出站额外只发 `interrupt` |
| 内部/实现层 | duplicate init suppression、`control_response` / `keep_alive` / `post_turn_summary` 过滤细节、WebSocket headers typing cast、具体 message line splitting 方式 |

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `cc://` URL = 当前已经连上的 transport | 它先参与 argv 改写，再决定进交互态还是 `open` |
| `createDirectConnectSession(...)` = 已经开始流式对话 | 它先做 session factory，产出 `session_id` / `ws_url` / `work_dir` |
| `session_id` = 真正建立 socket 的地址 | transport 用的是 `ws_url` |
| 连到 server = 本地 cwd 不会变 | server 可回传 `work_dir` 改写本地工作目录状态 |
| direct connect 断线 = 会像 remote session 那样继续重连 | 这条线会 `gracefulShutdown(1)` |
| direct connect 的 control request = 完整远端控制面 | 入站只专门支持 `can_use_tool`，不认识的 subtype 会直接回错 |

## 七个检查问题

- 当前说的是 connect URL 的入口改写，还是 session 已经建出来了？
- 当前对象是 `serverUrl`、`session_id`，还是 `ws_url`？
- server 有没有通过 `work_dir` 反写这条会话真正的工作目录？
- 当前跑的是交互态 REPL，还是 `open <cc-url>` 的 headless 壳？
- 当前控制往返是在做最窄 permission roundtrip，还是在谈 generic remote control plane？
- 这次断开后应该期待 reconnect，还是应该直接退出？
- 我是不是又把 direct connect 写成 remote session attach 了？

## 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/server/createDirectConnectSession.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/server/types.ts`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
