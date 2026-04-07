# timeout watchdog、reconnect warning、reconnecting 与 disconnected：为什么 remote session 的 recovery lifecycle 不是同一种状态

## 用户目标

121 已经把 attach 后的 init 痕迹拆成：

- history banner replay
- live slash/bootstrap restore

继续往下读时，读者又很容易把 remote session 里另一组相邻概念压成一句：

- 长时间没消息会触发 timeout
- transcript 里会出现 reconnect warning
- 连接状态会变成 `reconnecting`
- 最后可能走到 `disconnected`

于是正文就会滑成一句似是而非的话：

- “remote session 的恢复就是检测超时后自动重连，warning、reconnecting 和 disconnected 只是同一件事的不同展示。”

从当前源码看，这也不成立。

这里至少有五种不同语义：

1. watchdog armed
2. heartbeat clear
3. timeout warning
4. recovery attempt / reconnecting state
5. terminal disconnect

它们都与恢复有关，但不是同一种 recovery lifecycle。

## 第一性原理

更稳的提问不是：

- “系统会不会自动重连？”

而是先问五个更底层的问题：

1. 当前是在判断“可能卡住”，还是“已经断开”？
2. 当前是在写 transcript warning，还是在改 connection status？
3. 当前 recovery edge 是宿主主动补救，还是 transport 已经终止？
4. 当前 loading false 是 recovery 中间态，还是终局 release？
5. 当前这套 watchdog/reconnect 逻辑是不是所有模式都启用？

只要这五轴先拆开，后面的 timeout、warning、reconnecting 与 disconnected 就不会再被写成一条单线流程。

## 第一层：`responseTimeoutRef` 回答的是 stuck detection，不是 disconnect

`useRemoteSession.ts` 先定义了：

- `RESPONSE_TIMEOUT_MS = 60000`
- `COMPACTION_TIMEOUT_MS = 180000`
- `responseTimeoutRef`

而注释直接写明：

- 这是 timer for detecting stuck sessions

所以这一步的主语不是：

- “连接是否已断开”

而是：

- “当前 remote session 看起来有没有长时间不再推进，需要进入补救逻辑”

这意味着 timeout 这一层首先是：

- watchdog

不是：

- disconnect detector

## 第二层：heartbeat clear 早于 echo filter，说明 watchdog 看的是 liveness，不是业务语义

`onMessage` 一进来，最先做的事情之一就是：

- 如果 `responseTimeoutRef.current` 存在，先 `clearTimeout(...)`

注释还专门强调：

- 这包括我们自己 POST 之后回来的 WS echo
- 必须在 echo filter 之前清理
- 否则 slow-to-stream agents 会误触发 unresponsive warning + reconnect

这说明 watchdog 层回答的不是：

- “这条消息是不是有业务价值”

而是：

- “只要 transport 仍然有任何消息在流动，就不该把会话当成 stuck”

所以：

- heartbeat clear

是 liveness contract，

不是 transcript contract。

## 第三层：timeout warning 是 transcript-visible remediation prompt，不是状态本体

当 timeout 回调真的触发时，代码会：

- `logForDebugging(...)`
- 创建一条 warning system message
- `setMessages(prev => [...prev, warningMessage])`
- 然后 `manager.reconnect()`

这意味着 warning 这一步回答的是：

- “向用户显化：系统认为会话可能卡住了，并且正在尝试补救”

它不是：

- `reconnecting` state 本体

更不是：

- `disconnected` terminal state

所以 transcript 里的 warning 应该写成：

- recovery prompt

而不是：

- authoritative transport state

## 第四层：`manager.reconnect()` 和 `setConnStatus('reconnecting')` 不是同一步

timeout 回调里直接做的是：

- `manager.reconnect()`

而把状态写成：

- `setConnStatus('reconnecting')`

的是 manager 回调：

- `onReconnecting()`

所以这里至少有两层：

1. recovery attempt action
2. reconnecting state projection

这两者在概念上不同：

- 一个是宿主发起的补救动作
- 一个是 transport 层回报“我现在处于重连中”，再被 UI 投影成状态

如果把它们写成同一件事，正文就会把：

- action edge

和：

- state edge

压平。

## 第五层：`onReconnecting()` 是中间恢复态，不是终局 release

`onReconnecting()` 里做了几件很有指向性的事：

- `setConnStatus('reconnecting')`
- 清掉 `runningTaskIdsRef`
- `writeTaskCount()`
- 清掉 `inProgressToolUseIDs`

注释解释原因也很直接：

- WS gap 可能让 `task_notification` 丢失
- missed `tool_result` 会让 spinner stale

这里的主语显然不是：

- “连接已经彻底死了”

而是：

- “进入一个 gap-aware 的中间恢复态，需要保守重置局部账本，避免旧状态继续漂移”

所以 reconnecting 是：

- intermediate recovery state

不是：

- terminal disconnected state

## 第六层：`onDisconnected()` 才是 terminal disconnect

和 reconnecting 形成对照的是：

- `onDisconnected()`

它会：

- `setConnStatus('disconnected')`
- `setIsLoading(false)`
- 清掉 running task IDs
- 清掉 in-progress tool IDs

这一步的主语是：

- 当前 remote connection 已经进入 disconnected terminal state

所以这里的 false 更接近：

- terminal release

而不是：

- timeout-induced intermediate pause

也不是：

- reconnecting gap handling

## 第七层：viewerOnly 显式跳过 timeout watchdog，说明 recovery lifecycle 是 host-conditional

`sendMessage(...)` 的最后，只在：

- `!config?.viewerOnly`

时才会启动 timeout。

注释也明确说：

- viewerOnly 模式下 remote agent 可能 idle-shut，重启时间可能超过 60s
- 因此不应该跑这套 timeout/reconnect 逻辑

这说明 recovery lifecycle 的覆盖面不是：

- 所有 remote session 一刀切

而是：

- 至少在 non-viewerOnly remote session 上，这套 watchdog / warning / reconnect 流程成立

viewerOnly 则条件跳过。

所以不能把这页写成：

- “remote session 普遍会经历同一套 timeout recovery”

## 第八层：compaction timeout 也说明 watchdog 不是单一阈值

`COMPACTION_TIMEOUT_MS = 180000` 的存在也很关键。

代码会根据：

- `isCompactingRef.current`

在：

- `RESPONSE_TIMEOUT_MS`
- `COMPACTION_TIMEOUT_MS`

之间切换。

这说明 watchdog 本身就不是：

- one-size-fits-all 60s threshold

而是会根据当前 host 侧对 remote worker 是否在 compacting 的判断，选择不同阈值。

因此 even within watchdog：

- normal waiting
- compaction waiting

也不是完全同一条 liveness contract。

## 第九层：所以 recovery 至少有五种 edge

把上面几层压实之后，更稳的总表是：

| edge | 当前回答什么 | 典型位置 |
| --- | --- | --- |
| watchdog armed | 是否开始观察 stuck 风险 | `setTimeout(RESPONSE_TIMEOUT_MS / COMPACTION_TIMEOUT_MS)` |
| heartbeat clear | 任意消息到达即清 watchdog | `clearTimeout(responseTimeoutRef)` |
| timeout warning | 向 transcript 写补救提示 | `createSystemMessage(...warning)` |
| recovery attempt / state | 发起 reconnect，并投影为 reconnecting | `manager.reconnect()` / `setConnStatus('reconnecting')` |
| terminal disconnect | 当前连接进入断开态并停表 | `onDisconnected()` + `setIsLoading(false)` |

所以真正该写成一句话的是：

- warning
- reconnect action
- reconnecting state
- disconnected state

不是同一种 recovery lifecycle。

## 第十层：当前源码能稳定证明什么，不能稳定证明什么

从当前源码可以稳定证明的是：

- timeout、warning、reconnect、reconnecting、disconnected 是分层发生的
- heartbeat clear 的位置刻意早于 echo filter
- reconnecting 与 disconnected 都会保守清理局部账本，但语义不同
- viewerOnly 当前会跳过 watchdog
- compaction 会切换到更长 timeout

从当前源码不能在这页稳定证明的是：

- reconnect 最终一定成功
- 所有 host 都会维持同样的 recovery edges
- future build 不会再把 reconnecting 细分成更多状态

所以这页最稳的结论必须停在：

- same recovery episode != same lifecycle edge

而不能滑到：

- remote session has one single reconnect state

## 第十一层：为什么 122 不能并回 119

119 的主语是：

- loading flag 自身的 lifecycle edges

122 的主语则已经换成：

- transport health 在 watchdog、warning、reconnect、reconnecting、disconnect 之间的恢复 edges

119 讲：

- waiting state transitions

122 讲：

- transport recovery transitions

不是一页。

## 第十二层：为什么 122 也不能并回 121

121 的主语是：

- attach 后恢复的是 transcript banner 还是 slash restore

122 的主语已经换成：

- timeout 后恢复的是 prompt、action、intermediate state 还是 terminal disconnect

一个讲：

- attach restore

一个讲：

- transport recovery

问题域已经变了。

## 第十三层：最常见的假等式

### 误判一：看到 warning 就说明已经 disconnected

错在漏掉：

- warning 只是 remediation prompt

### 误判二：`manager.reconnect()` 就是 reconnecting 状态本体

错在漏掉：

- 一个是动作，一个是状态投影

### 误判三：reconnecting 和 disconnected 只是同一状态深浅不同

错在漏掉：

- 一个是中间恢复态，一个是 terminal release

### 误判四：只要 remote session 都该跑同样的 timeout/reconnect 流程

错在漏掉：

- viewerOnly 当前显式 skip timeout

### 误判五：这页本质还是 loading false 的另一种写法

错在漏掉：

- 这里主角是 recovery edge，不是 bool flag 本身

## 第十四层：苏格拉底式自审

### 问：我现在写的是 watchdog、warning、attempt，还是 terminal disconnect？

答：如果答不出来，就说明又把 recovery lifecycle 写平了。

### 问：我是不是把 warning 写成了状态本体？

答：如果是，就没把 transcript prompt 和 transport state 分开。

### 问：我是不是把 reconnecting 写成了最终断开？

答：如果是，就混淆了中间恢复态和终局状态。

### 问：我是不是把 viewerOnly 也默认进了同样 watchdog 流程？

答：如果是，就漏掉了 skip timeout 的条件分叉。
