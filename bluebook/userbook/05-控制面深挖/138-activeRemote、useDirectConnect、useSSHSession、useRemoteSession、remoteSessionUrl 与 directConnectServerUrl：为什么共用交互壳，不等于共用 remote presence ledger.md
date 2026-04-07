# `activeRemote`、`useDirectConnect`、`useSSHSession`、`useRemoteSession`、`remoteSessionUrl` 与 `directConnectServerUrl`：为什么共用交互壳，不等于共用 remote presence ledger

## 用户目标

135 已经把 direct connect 单独拆成：

- foreground remote runtime
- 而不是 remote presence store

137 又把 metadata 这条线继续拆成：

- “frontend 会读”更像跨前端 consumer path
- 不是当前 CLI foreground contract

但如果到这里停住，读者还是很容易在 REPL 层再犯一种压平错误：

- `useDirectConnect`
- `useSSHSession`
- `useRemoteSession`

最后都被塞进：

- `activeRemote`

于是正文就会滑成一句看似自然、实际上仍然太粗的话：

- “REPL 已经有一个统一的 remote 子系统，只是不同 transport 复用程度不同。”

这句不稳。

从当前源码看，`activeRemote` 统一的更像：

- turn-level interaction shell

而不是：

- remote presence ledger

所以这页要补的不是：

- “三种 remote mode 为何都能发消息和取消”

而是：

- “为什么共用交互壳，不等于共用 remote presence ledger”

## 第一性原理

更稳的提问不是：

- “既然 REPL 里都塞进了 `activeRemote`，它们为什么还不是同一种 remote mode？”

而是先问五个更底层的问题：

1. `activeRemote` 当前统一的到底是 interaction API，还是 authoritative state ledger？
2. 哪些字段只服务 turn loop，哪些字段才会被 footer / dialog / `/session` 当作长期存在面消费？
3. `direct connect` 与 `ssh remote` 共用 hook 形状，是否自动意味着共享 presence 账本？
4. REPL 源码里有没有把 “交互是 remote” 和 “处于 remote-session presence 模式” 明确分家？
5. bootstrap 级 display hint 和 `AppState` authoritative ledger 是不是同一回事？

只要这五轴先拆开，`activeRemote` 就不会再被写成：

- “统一 remote subsystem”

## 第一层：`activeRemote` 当前统一的是最小交互壳，不是最小存在账

`REPL.tsx` 里三条 hook 会先分别建起来：

- `useRemoteSession(...)`
- `useDirectConnect(...)`
- `useSSHSession(...)`

然后才选出：

- `activeRemote`

这层统一出来的 shape 很克制：

- `isRemoteMode`
- `sendMessage(...)`
- `cancelRequest()`
- `disconnect()`

这说明它首先回答的是：

- “当前 turn 应不应该走远端 transport”
- “取消时是不是该发远端 interrupt”

并不是在回答：

- “当前远端存在面有哪些 authoritative 字段”

所以 `activeRemote` 更像：

- least-common-denominator interaction shell

而不是：

- least-common-denominator presence ledger

## 第二层：REPL 在多个关键交互点只消费 `activeRemote.isRemoteMode`，消费的都是 turn-level 行为

`REPL.tsx` 继续往下看，这层边界会更清楚。

### 取消逻辑

按 `Esc` 取消时：

- 如果 `activeRemote.isRemoteMode`
- 就走 `activeRemote.cancelRequest()`

### 提交逻辑

决定当前 submit 是不是“现在就发”时：

- `activeRemote.isRemoteMode` 直接算进 `submitsNow`

### 远端 prompt 路径

真正进入 remote mode submit 时：

- 也是只判断 `activeRemote.isRemoteMode`

这些地方的共同点很明显：

- 它们都服务单个 turn 的输入、取消、loading、权限桥接
- 它们都不需要 `remoteSessionUrl`
- 也不需要 `remoteConnectionStatus`
- 更不需要 `remoteBackgroundTaskCount`

因此 `activeRemote` 当前被 REPL 消费的地方，基本都是：

- interaction loop concerns

不是：

- presence / visibility concerns

## 第三层：`useDirectConnect` 和 `useSSHSession` 是 sibling hook，因为它们共用的是 stream-json 交互壳

`useSSHSession.ts` 的文件头已经把这层关系写得非常直白：

- sibling to `useDirectConnect`
- same shape
- same REPL wiring
- only transport under the hood differs

再看两者的 hook 实现，也会发现它们消费的 props 几乎相同：

- `setMessages`
- `setIsLoading`
- `setToolUseConfirmQueue`
- `tools`

处理流程也几乎同构：

- 远端 message -> `convertSDKMessage(...)` -> append transcript
- permission request -> 合成 `ToolUseConfirm`
- session end -> `setIsLoading(false)`
- disconnect -> `gracefulShutdown(1)`

所以它们当前真正共享的是：

- stream-json turn interaction shell

而不是：

- 同一套远端存在账本

## 第四层：transport 差异被刻意压在 hook 下层，没有上推成 shared `AppState` ledger

这一步最关键。

`direct connect` 的 transport 是：

- WebSocket 到 claude server

`ssh remote` 的 transport 是：

- ssh child process + auth proxy + manager

但无论底层差异多大，

两者当前都有一个共同特征：

- 都没有 `useSetAppState()`
- 都没有去写 `remoteSessionUrl`
- 都没有去写 `remoteConnectionStatus`
- 都没有去写 `remoteBackgroundTaskCount`

也就是说，REPL 明确选择了：

- 把 transport 差异留在 hook / manager 下面
- 只把最小交互壳暴露给 `activeRemote`

而没有进一步把它们提升成：

- 可被多 surface 消费的 authoritative remote ledger

## 第五层：REPL 源码里本来就把“remote 交互”与“remote-session presence”分家

这一步能直接打掉“统一 remote 子系统”的误写。

`REPL.tsx` 里除了 `activeRemote` 这条线，

还有一条明确的 presence 线：

- `isRemoteSession = !!remoteSessionConfig`

这条线会继续影响：

- remote-session 专属命令过滤
- 是否加载本地 skills / plugin / MCP / IDE 旁路
- 以及其他 viewer / session 相关行为

也就是说，REPL 源码本身已经在说：

- `activeRemote.isRemoteMode` 只回答“交互是不是 remote”
- `isRemoteSession` 才在回答“是不是 remote-session presence 模式”

如果把这两条线重新压回一句：

- “都是 remote mode”

就会把作者已经拆开的边界重新压扁。

## 第六层：真正的 remote presence ledger 只在 `useRemoteSession()` 里建立

对比 `useRemoteSession.ts`，这层差异会更清楚。

`useRemoteSession()` 当前明确会：

- `useSetAppState()`
- 写 `remoteConnectionStatus`
- 写 `remoteBackgroundTaskCount`

而这些字段又会继续被：

- footer
- brief line / spinner
- `/session`

等 surface 消费。

所以 remote session 当前不是：

- “另一个也能发消息的 remote hook”

而是：

- 唯一真正建立了 remote presence ledger 的这条线

这和 `useDirectConnect()` / `useSSHSession()` 的 turn shell 定位是两码事。

## 第七层：`directConnectServerUrl` 只是 bootstrap 级 display hint，不是 `AppState` ledger

这一步最容易被误写成“它也有自己的远端字段”。

`bootstrap/state.ts` 确实定义了：

- `directConnectServerUrl`

`main.tsx` 的 direct connect 启动分支也会：

- `setDirectConnectServerUrl(_pendingConnect.url)`

但这里的注释和用途都很收敛：

- for display in header

它不是：

- `AppStateStore` 里的多 surface 状态字段
- 不会像 `remoteSessionUrl` 那样被 `/session`、footer 等长期消费

所以更稳的说法是：

- `directConnectServerUrl` is a bootstrap display hint
- not a presence ledger

## 第八层：`/session` 本身就是反证，它只认 `remoteSessionUrl`

`commands/session/session.tsx` 对这层边界写得非常直接：

- 没有 `remoteSessionUrl`
- 就提示 `Not in remote mode. Start with claude --remote`

这里最该注意的不是文案，

而是：

- `/session` 的“remote mode”实际上指向的是 remote-session presence mode
- 不是任何能走 `activeRemote` 的交互 remote mode

所以 direct connect / ssh 即便都能：

- remote send
- remote cancel
- remote permission bridge

它们仍然不会自动被 `/session` 视为：

- 同一种 remote presence ledger

## 第九层：因此 direct connect / ssh 共用交互壳，不等于它们共享同一种 remote presence truth

把前面几层压成一句，更稳的一句是：

- shared remote interaction shell, not shared remote presence truth

也就是说：

### `activeRemote` 当前统一的是

- 是否走远端提交
- 是否走远端取消
- 是否把远端权限请求桥接回本地 `ToolUseConfirm`
- 是否把远端 message 投影回 transcript

### `activeRemote` 当前没有统一的是

- `remoteSessionUrl`
- `remoteConnectionStatus`
- `remoteBackgroundTaskCount`
- footer / dialog / `/session` 所依赖的 authoritative ledger

所以 direct connect 与 ssh remote 现在更像：

- 共享同一张 REPL interaction adapter

而不是：

- 共享同一张 remote presence state table

## 第十层：为什么它不是 135 的重复页

135 讲的是：

- direct connect 自己为什么更像 foreground runtime

138 讲的是：

- 即使把 direct connect 放回 REPL 总体结构里，它和 ssh remote 共用的也只是 interaction shell，不是 presence ledger

一个讲：

- direct connect 自身边界

一个讲：

- REPL 顶层 abstraction 边界

所以 138 不是重写 135，

而是把主语从单一路径切到：

- REPL 顶层抽象

## 第十一层：最常见的四个假等式

### 误判一：既然 REPL 有 `activeRemote`，说明它已经有统一 remote subsystem

错在漏掉：

- `activeRemote` 只统一交互 API
- 没统一 presence ledger

### 误判二：`useDirectConnect` 与 `useSSHSession` 同 shape，就说明它们也该共享 `--remote` 的 footer / `/session`

错在漏掉：

- shared shell 不等于 shared authority

### 误判三：`directConnectServerUrl` 说明 direct connect 已经有自己的 remote presence state

错在漏掉：

- 它只是 bootstrap display hint
- 不是 `AppState` ledger

### 误判四：缺少 dedicated footer / dialog/store，只是 UI 还没做

错在漏掉：

- 缺的是 `remoteSessionUrl / remoteConnectionStatus / remoteBackgroundTaskCount` 这类 authority 字段

## 第十二层：stable / conditional / internal

### 稳定可见

- `activeRemote` 当前统一的是 `isRemoteMode/sendMessage/cancelRequest/disconnect`
- `useDirectConnect` 与 `useSSHSession` 是 sibling hook，共用 REPL 交互壳
- `useRemoteSession()` 当前才会写 `remoteConnectionStatus` / `remoteBackgroundTaskCount`
- `directConnectServerUrl` 当前只是 bootstrap display hint
- `/session` 当前只认 `remoteSessionUrl`

### 条件公开

- 如果 direct connect / ssh 将来开始写 `remoteSessionUrl`、连接态或后台任务账，它们才可能并入 presence ledger
- 给 direct connect / ssh 单独补一个 badge 或 header 提示，不等于它们已经拥有 remote presence truth
- `activeRemote` 的统一 shape 可以继续扩展，但只要不落到 `AppState` authoritative 字段，就仍然只是 interaction shell

### 内部 / 灰度层

- ssh transport 的更细实现仍压在 `SSHSessionManager` / child-process 细节里，当前顶层只暴露 sibling shell
- 将来会不会出现 direct connect / ssh 的独立 presence ledger，当前仓内没有稳定承诺
- REPL 顶层抽象未来是否会把 `activeRemote` 和 `isRemoteSession` 再重新组织，仍属实现演化空间

## 第十三层：苏格拉底式自审

### 问：我现在写的是 interaction API，还是 authoritative state ledger？

答：如果答不出来，就把 `activeRemote` 写过头了。

### 问：我是不是把 shared hook shape 偷换成了 shared presence truth？

答：如果是，就把 `useDirectConnect/useSSHSession` 的 sibling 关系写错了主语。

### 问：我是不是因为 `directConnectServerUrl` 存在，就断言 direct connect 已有远端状态账？

答：如果是，就把 display hint 和 ledger 混了。

### 问：我是不是又把 135 的 direct connect 自身边界拿来重写，而没有真正进入 REPL 顶层 abstraction？

答：如果是，就还没真正进入 138。

### 问：我是不是忽略了 `isRemoteSession` 这条单独存在的 presence 线？

答：如果是，就会把 REPL 已经拆开的两种 remote 语义重新压平。

## 源码锚点

- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/hooks/useSSHSession.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/bootstrap/state.ts`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/commands/session/session.tsx`
