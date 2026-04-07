# `StructuredIO`、`RemoteIO`、`setInternalEventReader`、`setInternalEventWriter` 与 `flushInternalEvents`：为什么 headless transport 的协议宿主不等于同一种恢复厚度

## 用户目标

20 已经说明：

- `print` 不是没有 UI 的 REPL
- `StructuredIO` / `RemoteIO` 是 headless 宿主合同

162 又说明：

- `print` resume 的下游消费者是 `StructuredIO` / `RemoteIO`
- 不是 `<REPL />`

167 再往前推进了一层：

- `restoredWorkerState` 不是普遍 resume 合同
- metadata readback 不等于 local consumption

但如果正文停在这里，读者还是很容易把另一层关键差别压平：

- 既然 `print` 最后都拿到的是 `StructuredIO` / `RemoteIO`
- 那它们顶多只是“远端版 / 本地版”的同一种协议宿主
- resume、transcript 持久化、shutdown flush 只是顺手多出来的细节

这句还不稳。

从当前源码看，headless transport 至少还要继续拆成三层：

1. protocol runtime
   当前 headless turn 能不能说结构化控制协议
2. recovery ledger
   transcript / subagent state 能不能通过 internal events 被持久化并回读
3. persistence backpressure
   shutdown / idle 前会不会显式观测和冲刷这本恢复账

如果这三层不先拆开，`StructuredIO` 和 `RemoteIO` 就会继续被写成：

- 同一种 runtime，只是 transport 不同

而当前实现不是这么组织的。

## 第一性原理

更稳的提问不是：

- “为什么 remote headless 比本地 headless 更厚？”

而是先问五个更底层的问题：

1. 当前对象解决的是 protocol runtime，还是 recovery ledger？
2. 当前状态是 stdout/client-visible stream，还是 frontend 不可见的 internal event ledger？
3. 当前能力只是能跑 turn，还是还能在 resume 时重建 foreground / subagent transcript？
4. 当前 shutdown 只是把结果流发完，还是还要等待恢复账落盘？
5. 如果协议宿主、恢复账本和持久化背压各自回答的问题都不同，为什么还要把它们写成同一种 transport thickness？

只要这五轴不先拆开，后面就会把：

- `StructuredIO`
- `RemoteIO`
- `setInternalEventReader(...)`
- `setInternalEventWriter(...)`
- `flushInternalEvents()`
- `internalEventsPending`

重新压成一句模糊的“headless remote transport”。

## 第一层：`StructuredIO` 默认回答的是 protocol runtime，不是 recovery thickness

`StructuredIO` 自己先给出的是一套很克制的默认值：

- `restoredWorkerState = Promise.resolve(null)`
- `flushInternalEvents() => Promise.resolve()`
- `internalEventsPending => 0`

这说明 `StructuredIO` 先回答的问题不是：

- “当前宿主是否带着恢复账本”

而是：

- “当前 headless turn 有没有一个结构化输入输出协议壳”

也就是说，`StructuredIO` 的基线合同更接近：

- control request / control response
- structured stdin / stdout
- headless protocol runtime

不是：

- resume-capable recovery transport

所以这里最该防住的第一句假等式就是：

- 能跑 headless protocol = 已经具备同样厚度的恢复能力

## 第二层：`RemoteIO` 不是换掉协议宿主，而是在同一家族里加厚恢复账本

`RemoteIO` 没有推翻 `StructuredIO` 的 protocol runtime 身份。

它做的是在同一宿主家族里再叠一层厚度：

- 创建 `CCRClient`
- 把 `initialize()` 挂到 `restoredWorkerState`
- 注册 `setInternalEventWriter(...)`
- 注册 foreground / subagent 的 `setInternalEventReader(...)`
- override `flushInternalEvents()`
- override `internalEventsPending`

所以 `RemoteIO` 回答的问题已经不只是：

- 当前 turn 能不能说结构化协议

而是：

- 当前宿主是不是还带着一条恢复账本
- 能不能在 turn 间 / shutdown 时知道这本账有没有积压

因此更准确的说法不是：

- `RemoteIO` 只是“多一个远端输出目标”

而是：

- `RemoteIO` = `StructuredIO` family + recovery-thick transport overlay

## 第三层：`sessionStorage` 说明 reader / writer 讲的是恢复账本，不是普通可见消息流

这里最关键的证据不在 `print.ts`，而在 `sessionStorage.ts`。

### `setInternalEventWriter(...)` 先把 transcript 持久化改写成另一套账本

源码注释直接写：

- transcript messages are written as internal worker events
- instead of going through v1 Session Ingress

而 `Project.setInternalEventWriter(...)` 还会把 flush cadence 改成 remote 更快的间隔。

这说明 writer 回答的问题不是：

- “怎样把当前消息继续发给前台”

而是：

- “怎样把 transcript 持久化到账本里，供后续 resume 使用”

### `setInternalEventReader(...)` 也不是普通 stream reader，而是 resume reader

`setInternalEventReader(...)` 的注释写得很直接：

- `hydrateFromCCRv2InternalEvents()` 会用它去抓 foreground 和 subagent internal events
- 用来 reconstruct conversation state on reconnection

这说明 reader 回答的问题也不是：

- “前台现在还能不能继续看到消息”

而是：

- “resume 时能不能从 compaction boundary 之后把会话状态重新拼回来”

### `CCRClient` 更进一步把两本账分开命名

`writeEvent(...)` 的注释写：

- frontend clients 可见

`writeInternalEvent(...)` 的注释写：

- NOT visible to frontend clients
- needed for session resume

再加上：

- `readInternalEvents()`
- `readSubagentInternalEvents()`

明确只为 session resume 服务，

这就把两类账本写得非常清楚：

1. client-visible event stream
2. recovery-only internal event ledger

所以这里最重要的一句是：

- 协议宿主能发消息，不等于它已经带着恢复账本

## 第四层：`hydrateFromCCRv2InternalEvents()` 又证明这本账的厚度不只覆盖 foreground，还覆盖 subagent transcript

`hydrateFromCCRv2InternalEvents(...)` 不只是把 foreground transcript 写回本地。

它还会：

- 调 subagent reader
- 按 `agent_id` 分组
- 把每个 agent 的 transcript 写进各自文件

而且注释里明确说：

- server returns events starting from the latest compaction boundary

这意味着 recovery ledger 回答的问题已经不是：

- “能不能把当前主线程对话补回来”

而是：

- compaction 后的 foreground / subagent 会话残余，能不能一起被恢复

所以同属 headless transport family，

`RemoteIO` 的恢复厚度显然已经比 base `StructuredIO` 厚得多。

## 第五层：`print.ts` 在 shutdown / idle 边界上也显式承认这本恢复账的背压

如果前面几层还可以被误写成“只是多一个 resume helper”，

那 `print.ts` 的 turn-over 逻辑会进一步说明这不是附带小功能。

### shutdown 诊断里专门记 `internal_events_pending`

`run_state_at_shutdown` 会记录：

- `worker_status`
- `internal_events_pending`

这说明系统在 shutdown 视角里已经把这本 internal event ledger 当成：

- 需要单独观察的 backpressure source

而不是：

- 普通输出流的一个无关实现细节

### finally 里先 `flushInternalEvents()`，再进入 `idle`

`print.ts` 在 finally flush 阶段会先：

- `await structuredIO.flushInternalEvents()`

然后才：

- `notifySessionStateChanged('idle')`

这说明 turn-over 在 remote-thick transport 上回答的问题不是：

- “结果流发完没”

而是：

- “恢复账有没有先被冲刷完，能不能安全进入 idle / 下一轮 resume”

这一步非常关键，因为它证明：

- persistence backpressure 已经进入 runtime close discipline

而不是停留在某个隐藏 helper 里。

## 第六层：因此 headless transport 至少要拆成 protocol runtime、recovery ledger 与 persistence backpressure 三层

把前面几层合起来，更稳的写法应该是：

1. protocol runtime 账
   `StructuredIO` 先保证 headless turn 能说结构化协议
2. recovery ledger 账
   `RemoteIO` + internal-event reader / writer 让 transcript 和 subagent state 进入可回读账本
3. persistence backpressure 账
   `internalEventsPending` / `flushInternalEvents()` 让 shutdown 与 idle 显式等待这本账收口

所以更准确的结论不是：

- `RemoteIO` 只是更厚一点的 `StructuredIO`

而是：

- 同一 headless protocol family 内部，本来就存在不同恢复厚度

## 第七层：为什么这页不是 20、162、167 或 88 的附录

### 不是 20 的附录

20 的主语是：

- headless vs interactive host switch

168 的主语是：

- 同属 headless transport family，为什么恢复厚度仍然不同

### 不是 162 的附录

162 的主语是：

- print host vs REPL host family

168 的主语已经换成：

- `StructuredIO` family 内部的 thin vs thick transport

### 不是 167 的附录

167 的主语是：

- metadata readback bag vs local consumption sink

168 不再比较 metadata key，而是比较：

- protocol shell
- recovery ledger
- persistence backpressure

### 不是 88 的附录

88 的主语是：

- headless print queue re-entry 的单消费者模型

168 不讲 flush ordering 本身，而讲：

- 为什么有些 transport 根本没有这本账可 flush
- 有些 transport 则必须把它纳入 shutdown discipline

## 第八层：稳定、条件与灰度边界

### 稳定可见

- `StructuredIO` 默认没有恢复厚度：`restoredWorkerState = null`、`flushInternalEvents()` no-op、`internalEventsPending = 0`。
- `RemoteIO` 会注册 internal-event reader / writer，并 override flush / pending。
- `print.ts` 会在 shutdown/idle 边界显式冲刷 internal event ledger。

### 条件公开

- 这条恢复厚度主要只在 CCR v2 remote/headless transport 上成立。
- v1 ingress hydrate 可以恢复 transcript，但不提供同厚度的 internal-event ledger。

### 内部/灰度层

- `REMOTE_FLUSH_INTERVAL_MS`、pending count 的具体阈值、pagination / retry 细节，仍是实现层。
- internal event ledger 的具体 payload 形状、compaction 边界后的残留规则，也不应被外推成稳定产品合同。

## 苏格拉底式自审

### 问：为什么一定要把 `StructuredIO` 的默认 no-op 写出来？

答：因为不先写这个，读者会误以为 flush / pending / readback 是 headless 的天然属性，而不是 remote-thick transport 的附加账本。

### 问：为什么一定要把 `setInternalEventReader/Writer(...)` 拉进来？

答：因为这两个注册点最直接地说明：现在讨论的不是普通消息流，而是恢复账本。

### 问：为什么一定要写 subagent transcript？

答：因为这能证明恢复厚度不是只给 foreground 做的小补丁，而是扩展到多 agent transcript 的恢复账。

### 问：为什么一定要写 `internalEventsPending`？

答：因为没有这个背压信号，`flushInternalEvents()` 很容易被误写成“临退场顺手做一下”，而不是 runtime close discipline 的一部分。

### 问：这页会不会重新卷回 50 的 worker lifecycle？

答：不会。50 讲的是 init / heartbeat / keep_alive / self-exit 的存活合同；168 只讲 headless transport 内部的恢复厚度。
