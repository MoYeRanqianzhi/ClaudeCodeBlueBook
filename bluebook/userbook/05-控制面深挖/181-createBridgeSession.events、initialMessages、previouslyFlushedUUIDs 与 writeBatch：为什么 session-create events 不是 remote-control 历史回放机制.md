# `createBridgeSession.events`、`initialMessages`、`previouslyFlushedUUIDs` 与 `writeBatch`：为什么 session-create events 不是 remote-control 历史回放机制

## 用户目标

180 已经把 teleport runtime 继续拆成：

- repo admission
- branch replay

但如果正文停在这里，读者还是很容易把 bridge create / hydrate 再写平：

- `createBridgeSession(...)` 既然明明有 `events` 参数，那 `/remote-control` 的历史不就是在建会话时一起发过去的吗？
- `initReplBridge(...)` 明明也拿到了 `initialMessages`，为什么还要把 `events` 写成空数组？
- 如果注释里说 session 可以 pre-populated with conversation history，为什么真正实现又在 ingress WebSocket 连上后再 flush？
- standalone `remote-control` 启动时预创建 empty session，和 REPL 带历史的建会话，到底是不是同一个 create contract？

这句还不稳。

从当前源码看，bridge 至少还分成两种不同 runtime contract：

1. session birth
2. history hydrate

如果这两层不先拆开，后面就会把：

- `createBridgeSession(... events ...)`
- `initialMessages`
- `previouslyFlushedUUIDs`
- `writeBatch(...)`

重新压成同一种“远端历史创建机制”。

## 第一性原理

更稳的提问不是：

- “远端 session 不就是创建时顺手把历史一起写进去吗？”

而是先问五个更底层的问题：

1. 当前逻辑在回答“先把 session object 生出来”，还是“把本地已有对话历史补写进 server”？
2. 当前历史写入走的是 `POST /v1/sessions` 的 `events`，还是 ingress transport 的 `writeBatch(...)`？
3. 当前失败会导致 session birth 根本不存在，还是只影响历史 hydrate / dedup？
4. 当前时序要求的是 session 一出生就能被 UI 看见，还是历史 persistence 完成后才宣布 `connected`？
5. 如果同属一条 remote-control 会话，为什么系统还要把 create-time events 与 post-connect flush 写成两套合同？

只要这五轴不先拆开，后面就会把：

- empty session seed
- later history flush

混成一句模糊的“create session with history”。

## 第一层：`createBridgeSession(...)` 暴露 `events`，不等于当前 bridge caller 用它做历史回放

`createSession.ts` 的 helper signature 明确接受：

- `events: SessionEvent[]`

request body 也会直接把：

- `events`

写进：

- `POST /v1/sessions`

这说明从 API 形状上看，`events` 回答的问题像是：

- 建 session 时附带哪些初始事件

但“API 支持这样写”并不自动推出：

- 当前 bridge caller 真把历史回放放在这里完成

因为继续看 in-tree caller 会发现：

- `initReplBridge(...)` 传的是 `events: []`
- `bridgeMain.ts` 预创建 initial session 也传 `events: []`

所以更准确的理解不是：

- bridge 历史默认由 session-create events 承担

而是：

- 当前 bridge caller 故意把 session birth 与 history hydrate 分开

## 第二层：`initReplBridge(...)` 明明拿着 `initialMessages`，却仍强制 `events: []`

`initReplBridge.ts` 入口参数里已经显式拿到：

- `initialMessages?: Message[]`
- `previouslyFlushedUUIDs?: Set<string>`

也就是说，REPL wrapper 在 create 之前就知道：

- 当前本地已经有一份对话历史

但真正传给 `createBridgeSession(...)` 的 wrapper 仍写死：

- `events: []`

这说明更准确的理解不是：

- “拿到历史之后，建会话时自然就会把它塞进 `events`”

而是：

- `initialMessages` 的存在
- 与 “历史是否通过 session-create events 发送”

本来就是两件不同的事。

如果系统要把历史直接并入 create request，
这里最该发生的就是：

- 把 `initialMessages` 转成 `SessionEvent[]`

但当前实现没有这么做。

所以 `initReplBridge(...)` 本身就是一条硬证据：

- 历史已知
- 仍不通过 create events 发送

## 第三层：`replBridge.ts` 注释明确承认，建会话事件不是历史回放机制

`replBridge.ts` 在 create session 前的注释写得非常硬：

- initial messages are NOT included as session creation events
- those use `STREAM_ONLY` persistence
- are published before the CCR UI subscribes
- so they get lost
- instead, initial messages are flushed via the ingress WebSocket once it connects

这段话直接把主语拆成了两层：

1. session creation events
2. ingress WebSocket flush

它回答的问题不是：

- “反正最后 server 那边都能看到消息，走哪条路都一样”

而是：

- 哪条 persistence path 能让历史在 UI 订阅时序下被可靠看见

所以更准确的结论不是：

- `events` 只是还没来得及被用起来

而是：

- 当前系统已经明确判定：`events` 不适合承担 `/remote-control` 的历史回放合同

## 第四层：真正的历史回放发生在 post-connect flush，不在 session birth 里

`replBridge.ts` 的 `onConnect` 分支里，只有在：

- `!initialFlushDone`
- `initialMessages.length > 0`

时才会启动历史注水。

它做的事情是：

- 先按 `isEligibleBridgeMessage(...)` 过滤
- 再排除 `previouslyFlushedUUIDs`
- 按 `initialHistoryCap` 收窄
- `toSDKMessages(...)`
- 补上 `session_id`
- 最终通过 `newTransport.writeBatch(events)` 发出去

这说明当前真正回答“如何把已有历史补写进 server”的不是：

- create request body 的 `events`

而是：

- ingress transport 连通之后的 `writeBatch(...)`

所以更准确的理解不是：

- session birth 顺手带出了历史 hydrate

而是：

- 先让 session object 活起来
- 再在 transport 已连通的条件下做 history flush

## 第五层：`previouslyFlushedUUIDs` 属于 hydrate dedup，根本不属于 create-time birth 语义

如果历史真是通过 `createBridgeSession.events` 在建会话时一次性写进去，
那么后面最自然的 dedup 锚点应当是：

- 已随 create request 成功送达的那些事件

但当前系统真正拿来做保护的是：

- `previouslyFlushedUUIDs`

它的职责是：

- 跨 CLI start 保留“哪些历史消息已经在 earlier flush 中成功写过”
- 避免 duplicate UUID 重新 poison server / kill WS

这说明 `previouslyFlushedUUIDs` 回答的问题不是：

- 建会话时已经把哪些初始事件播出去了

而是：

- later history flush 已经稳定落库了哪些消息

所以它天然属于：

- hydrate dedup ledger

不是：

- session birth ledger

## 第六层：`connected` 被延后到 flush 之后，本身就说明 history hydrate 是 create 之后的第二阶段

`replBridge.ts` 对 `connected` 的时机也写得很硬：

- 初始 flush 完成前，不调用 `onStateChange('connected')`
- 这样能防止新消息与历史消息在 server 端交错
- 也延迟 web UI 把 session 显示成 active，直到 history is persisted

如果 session-create events 真已经承担了历史回放合同，
那么最自然的时序应当是：

- 建会话成功
- transport 连上
- 直接进入 connected

但当前实现刻意不是这样。

它承认的是：

1. session birth
2. transport connect
3. history flush
4. gate drain
5. connected

这说明更准确的说法不是：

- connected = session object 已出生

而是：

- connected 还隐含了一层 “历史已经通过 ingress path 持久化”

因此 create 与 hydrate 从运行时语义上就是两段。

## 第七层：standalone `bridgeMain.ts` 的 empty session seed，也在旁证 create 与 hydrate 已被拆开

`bridgeMain.ts` 在 standalone remote-control 启动时两处都会：

- `createBridgeSession({ ..., events: [] })`

并明确把这条路径叫做：

- auto-create an empty session
- so the user has somewhere to type immediately

这说明 standalone 预创建初始会话回答的问题不是：

- 如何把一份既有本地历史一起注水到远端

而是：

- 用户一启动 host，就先有一个可输入的 session object

37 和 39 已经分别讲了：

- pre-create initial session 是当前目录的前台锚点
- `--name` 首先命名 initial session

181 再往下压的则是：

- 即便 session birth 本身已是 empty seed
- 历史 hydrate 仍在另一条 post-connect ingress 合同里

所以这页不能回写成 37 / 39 的附录。

## 第八层：为什么这页不是 54、37、39 或 180 的附录

### 不是 54 的附录

54 讲的是：

- transport rebuild
- initial flush
- flush gate
- sequence resume

它的主语是：

- transport continuity 状态机

181 讲的是：

- 为什么 create-time `events` 不承担 history hydrate

它的主语是：

- session birth 与 history persistence 的对象分层

54 里虽然出现了 initial flush，
但没有把：

- `createBridgeSession.events`
- `initReplBridge(... events: [])`
- `STREAM_ONLY persistence`

压成一条独立判断。

### 不是 37 的附录

37 讲的是：

- pre-created initial session 与 spawn topology / cwd anchor 的关系

181 讲的是：

- empty session seed 不是 later history hydrate

前者是调度与锚点，
后者是 create-vs-hydrate。

### 不是 39 的附录

39 讲的是：

- `--name`
- `permission-mode`
- `sandbox`
- session title inheritance

181 虽然借用了 initial session 这条旁证，
但要证明的不是 title seed，
而是：

- birth 事件与历史事件根本不是同一条写入机制

### 不是 180 的附录

180 讲的是：

- repo admission
- branch replay

181 讲的是：

- session birth
- history hydrate

180 是 teleport git contract 页，
181 是 bridge message persistence 页。

## 第九层：这页真正保护的 stable 面与 gray 面

本页真正稳定的判断只有四句：

1. `createBridgeSession(...)` 虽然暴露 `events`，但当前 bridge caller 实际传 `events: []`。
2. `initialMessages` 已在 REPL 入口可见，却被故意留到 post-connect ingress flush 再发送。
3. `replBridge.ts` 明确把 session creation events 判为不适合承担历史回放，因为 `STREAM_ONLY` 时序下 UI 会丢失它们。
4. `previouslyFlushedUUIDs` / `writeBatch(...)` 属于 later history hydrate ledger，而不是 session birth ledger。

而不该在正文里继续放大的灰度细节包括：

- `initialHistoryCap` 的具体阈值
- `droppedBatchCount` 与 retry 行为
- `recentPostedUUIDs` 的环形缓冲实现
- daemon / perpetual 模式下的细枝末节

这些会变，
但不会推翻本页那句更硬的 runtime 判断：

- session-create events 不是 remote-control 历史回放机制
