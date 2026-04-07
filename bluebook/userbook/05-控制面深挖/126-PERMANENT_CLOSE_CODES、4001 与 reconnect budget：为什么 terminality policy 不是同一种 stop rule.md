# `PERMANENT_CLOSE_CODES`、`4001` 与 reconnect budget：为什么 terminality policy 不是同一种 stop rule

## 用户目标

125 已经把 transport recovery action-state contract 拆成：

- `handleClose(...)`
- `scheduleReconnect(...)`
- `reconnect()`
- `onReconnecting`
- `onClose`

继续往下读时，读者又很容易把 transport 层的 terminality policy 压成一句：

- 断开之后会重试几次
- 不行就算断了

于是正文就会滑成一句看似顺、实际上错误的话：

- “`4001`、`4003` 和普通断线，本质都是同一种 stop rule，只是预算次数不同。”

从当前源码看，这也不成立。

这里至少有三种不同的 terminality policy：

1. permanent close code immediate stop
2. `4001` compaction-aware special budget
3. ordinary transient reconnect budget

它们都在回答“还要不要继续 reconnect”，但不是同一种 stop rule。

## 第一性原理

更稳的提问不是：

- “它到底会不会重试？”

而是先问五个更底层的问题：

1. 当前 close 为什么发生？
2. 当前 close code 属于永久拒绝、暂时性 stale，还是普通 transient drop？
3. 当前预算是谁的预算？
4. 当前耗尽预算之后意味着什么？
5. 当前 stop 是 server-side rejection，还是 client-side retry policy 走到尽头？

只要这五轴先拆开，`4001`、`PERMANENT_CLOSE_CODES` 与普通 reconnect budget 就不会再被写成同一种“断线后重试几次”。

## 第一层：`PERMANENT_CLOSE_CODES` 回答的是 definitive rejection，不是 retry policy

`SessionsWebSocket.ts` 先定义了：

- `PERMANENT_CLOSE_CODES = new Set([4003])`

注释也直接写明：

- permanent server-side rejection
- stop reconnecting immediately

这说明这一层回答的问题不是：

- “当前预算还剩几次”

而是：

- “服务端已经明确告诉你，这种 close 不该再 reconnect”

所以 `4003 unauthorized` 的主语首先是：

- permanent rejection

不是：

- reconnect budget exhausted

## 第二层：`4001` 被单独拿出来，是因为它被视为 compaction-aware exception

紧接着源码又专门写了一段单独注释：

- `4001 (session not found)` is handled separately
- can be transient during compaction

而 `handleClose(closeCode)` 也真的先特判：

- `if (closeCode === 4001) { ... }`

并说明原因：

- server may briefly consider the session stale
- CLI worker is busy with compaction API call

所以 `4001` 回答的问题不是：

- “这条 session 已经 definitively unauthorized”

也不是：

- “这就是普通 transient 网络掉线”

它更接近：

- compaction-induced stale window exception

如果把它写成普通断线，正文就会把：

- close reason

和：

- retry bucket

压平。

## 第三层：`MAX_SESSION_NOT_FOUND_RETRIES` 不是 `MAX_RECONNECT_ATTEMPTS` 的别名

源码里有两套不同预算：

- `MAX_SESSION_NOT_FOUND_RETRIES = 3`
- `MAX_RECONNECT_ATTEMPTS = 5`

这已经明示了一件事：

- `4001` budget

和：

- ordinary reconnect budget

不是同一张表。

更具体地说：

### `4001`

- 用 `sessionNotFoundRetries`
- delay 还是 `RECONNECT_DELAY_MS * retries`
- 预算耗尽后才 `onClose`

### 普通 transient close

- 用 `reconnectAttempts`
- 只在 `previousState === 'connected'` 时才累加
- 预算耗尽后 `Not reconnecting` 再 `onClose`

所以更稳的写法应是：

- `4001` 不是“少两次普通重试”

而是：

- 另一种语义不同的 retry budget

## 第四层：普通 reconnect budget 的主语是 close-after-connected，而不是所有 close

`handleClose(...)` 里普通 transient reconnect 的条件不是只有：

- `reconnectAttempts < MAX_RECONNECT_ATTEMPTS`

它还要求：

- `previousState === 'connected'`

这一步很重要。

因为它说明普通 reconnect budget 回答的是：

- “一条已经连上的 transport，在掉线后值不值得继续尝试回连”

而不是：

- “任何 close 都可以拿这张预算表来决定”

如果把这一句漏掉，正文就会把：

- never fully connected

和：

- connected-then-dropped

写成同一种 stop rule。

## 第五层：三种 path 的 stop 原因完全不同

如果把前面几层压成一张表，会看到三条终止语义完全不同的 path：

### path A：permanent close code

- server-side definitive rejection
- immediate `onClose`
- 不谈 retry budget

### path B：`4001`

- server 可能短暂认为 session stale
- compaction-aware retry budget
- 有自己单独的 exhaustion 条件

### path C：ordinary transient close

- 只有在之前真的 connected 过才谈普通 retry
- 本质是 client-side reconnect policy

所以这三种 stop rule 并不是：

- 同一种 “断了以后重试几次”

而是：

- rejection
- stale exception
- post-connected transient retry policy

## 第六层：`onClose` 虽然统一出口，但不统一原因

125 已经讲过：

- `onClose` 只属于 terminal path

126 要再往前一步补一句：

- 统一落到 `onClose`

不等于：

- 统一因为同一种 terminality

因为当前至少有三种不同原因都能落到这里：

1. permanent close code immediate stop
2. `4001` special budget exhausted
3. ordinary reconnect budget exhausted / 不满足 reconnect 前提

所以 `onClose` 更像：

- terminal sink

不是：

- terminal reason label

## 第七层：`4001` 和 compaction 的关系是条件公开，不该外推出所有 stale

源码注释给出的理由很具体：

- during compaction
- server may briefly consider session stale

这说明当前更稳的写法应该是：

- `4001` 当前被作为 compaction-aware special case 处理

而不是：

- 所有 stale / session not found 都天然安全可重试

也就是说：

- 4001 的“可重试”

并不是一个抽象普遍原则，

而是：

- 建立在当前 compaction 语境上的 conditional policy

## 第八层：所以这页不是 reconnect 页，而是 terminality 页

如果把这页再压成一句，最稳的一句其实是：

- 不同 close code / close context 不是通过同一张 “重试次数表” 来决定 terminality

这也是为什么本页不该写成：

- recovery 继续页

而应写成：

- terminality policy 拆分页

## 第九层：为什么它不是 125 的重复页

125 讲的是：

- 哪条 path 会触发 `onReconnecting`
- 哪条会触发 `onClose`
- 哪条只是 force reconnect action

126 则更窄：

- 为什么进入 terminal path 的 policy bucket 不是同一种

一个讲：

- transport action-state contract

一个讲：

- terminality rule taxonomy

## 第十层：最常见的假等式

### 误判一：`4001` 就是普通 reconnect，只是预算更小

错在漏掉：

- 它被单独视为 compaction-aware stale exception

### 误判二：`4003` 也只是 budget 为 0 的 reconnect

错在漏掉：

- 它属于 permanent server-side rejection

### 误判三：所有 close 都能套 `MAX_RECONNECT_ATTEMPTS`

错在漏掉：

- 普通 reconnect 还要求 `previousState === 'connected'`

### 误判四：统一落到 `onClose` 就说明终止原因相同

错在漏掉：

- terminal sink 统一，不等于 terminal reason 统一

### 误判五：只要写成 “session not found 可重试” 就够了

错在漏掉：

- 当前这个可重试是 compaction 条件下的特例

## 第十一层：stable / conditional / internal

### 稳定可见

- permanent close code 当前会立即 stop reconnecting
- `4001` 当前被单独拿出，用 special budget 处理
- ordinary transient close 当前用另一张 reconnect budget
- `onClose` 是 terminal sink，但不自带 terminal reason 语义

### 条件公开

- `4001` 的 special handling 当前建立在 compaction stale window 语境上
- ordinary reconnect 只有 previous state 真正是 connected 才启用

### 内部 / 灰度层

- `MAX_SESSION_NOT_FOUND_RETRIES = 3`
- `MAX_RECONNECT_ATTEMPTS = 5`
- `RECONNECT_DELAY_MS`
- `4003` 当前是唯一 permanent code

这些常量和枚举更适合作为：

- 当前实现证据

而不是：

- 稳定对外承诺

## 第十二层：苏格拉底式自审

### 问：我现在写的是 rejection、stale exception，还是 ordinary transient retry？

答：如果答不出来，就说明又把 terminality bucket 混了。

### 问：我是不是把 `4001` 写成了“预算更小的普通 reconnect”？

答：如果是，就丢掉了 compaction 条件。

### 问：我是不是把 `onClose` 的统一出口写成了统一原因？

答：如果是，就把 sink 和 reason 混了。

### 问：我是不是把当前常量写成了稳定产品语义？

答：如果是，就把 gray implementation 写过头了。

## 源码锚点

- `claude-code-source-code/src/remote/SessionsWebSocket.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
