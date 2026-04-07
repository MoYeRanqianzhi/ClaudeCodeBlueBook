# `compacting`、boundary、timeout、`4001` 与 keep-alive：为什么 compaction recovery contract 不是同一种恢复信号

## 用户目标

67 已经拆过：

- `status=compacting` 会同时喂 transcript 与 timeout policy

126 又把 terminality policy 拆成：

- permanent rejection
- `4001` compaction-aware special budget
- ordinary reconnect budget

继续往下读时，读者还是很容易把 compaction 一侧的相邻对象压成一句：

- 远端进入 compacting
- timeout 会变长
- 可能会遇到 `4001`
- 最后又会出现 `compact_boundary`

于是正文就会滑成一句看似顺、实际上错误的话：

- “compaction 就是一种恢复状态；`compacting`、延长 timeout、`4001` 重试和 `compact_boundary` 只是同一件事的不同表现。”

从当前源码看，这也不成立。

这里至少有五种不同语义：

1. transcript-visible progress/status
2. keep-alive signal
3. local patience policy
4. transport stale-window exception
5. transcript rewrite completion marker

它们都和 compaction recovery 有关，但不是同一种恢复信号。

## 第一性原理

更稳的提问不是：

- “compaction 现在是不是还在恢复？”

而是先问五个更底层的问题：

1. 当前这个信号是在给用户看，还是在给 transport / timeout 层保活？
2. 当前这个信号是在说明“正在 compacting”，还是在说明“终于 compact 完了”？
3. 当前它改变的是 transcript、local timeout，还是 reconnect policy？
4. 当前 `4001` 代表的是失败、暂时 stale，还是 compaction special case？
5. 当前 keep-alive 到底是在防什么：warning、stale close，还是 transcript 断层？

只要这五轴先拆开，`status=compacting`、`COMPACTION_TIMEOUT_MS`、`4001` 与 `compact_boundary` 就不会再被压成同一种 compaction state。

## 第一层：`status=compacting` 首先是 progress/status，不是 completion

`compact.ts` 在 compaction 期间会持续：

- `statusSetter?.('compacting')`

而 `useRemoteSession.ts` 收到：

- `system.status`

后会把：

- `isCompactingRef.current = sdkMessage.status === 'compacting'`

同时这一类 status 仍会继续落到 transcript consumer。

所以 `status=compacting` 回答的问题首先是：

- 当前远端正在 compacting

它不是：

- 这次 compact 已经完成

更不是：

- 需要立刻 reconnect

所以如果把 `Status: compacting` 写成“恢复已经完成”的证明，正文从第一步就歪了。

## 第二层：重复 re-emit 的 `compacting` 还是 keep-alive，不是新的状态推进

`compact.ts` 的注释非常关键：

- Send keep-alive signals during compaction
- Two signals:
- PUT `/worker heartbeat`
- re-emit `'compacting'` status so SDK event stream stays active

也就是说，重复发：

- `compacting`

这件事在源码里并不是为了告诉你：

- “状态又前进了一步”

而是为了防止：

- server 把 session 当成 stale
- SDK event stream 因长时间无消息而断流

这一步的主语是：

- keep-alive

不是：

- progress delta

也正因为如此，`useRemoteSession.ts` 才会对：

- repeated `compacting`

做 special handling：

- 更新 `isCompactingRef`
- 但不重复 append message

所以更稳的写法应是：

- re-emitted compacting status 在这里更像保活脉冲

而不是：

- 新的一次 transcript state transition

## 第三层：`COMPACTION_TIMEOUT_MS` 改的是 local patience policy，不是 compaction truth

`useRemoteSession.ts` 先定义：

- `RESPONSE_TIMEOUT_MS = 60000`
- `COMPACTION_TIMEOUT_MS = 180000`

再在 send timeout 时依据：

- `isCompactingRef.current`

在两者间切换。

所以 `COMPACTION_TIMEOUT_MS` 回答的问题不是：

- “远端现在是不是 compacting”

而是：

- “本地 owner-side watchdog 在 compaction 窗口里该有多耐心”

也就是说，它属于：

- local patience policy

不是：

- remote compaction truth

如果把延长 timeout 写成：

- compaction 自己的状态变化

就又把 local control 和 remote status 混写了。

## 第四层：`4001` 不是 compaction status，而是 stale-window exception

126 已经讲过：

- `4001` 不是普通 reconnect
- 它是 compaction-aware special budget

这一页再往前压一层，就要把它和 `status=compacting` 明确拆开。

`status=compacting` 回答的是：

- 远端当前在 compacting

而 `4001` 回答的是：

- server 在这个窗口里可能短暂认为 session stale / not found

所以这两者并不是：

- 同一状态的两个显示层

而是：

- 一个是 progress/status signal
- 一个是 transport stale-window exception

如果把 `4001` 写成“compacting 的另一种状态词”，正文就会把 transcript 和 transport 完全压平。

## 第五层：`compact_boundary` 才是 transcript rewrite completion marker

`useRemoteSession.ts` 明确把：

- `sdkMessage.subtype === 'compact_boundary'`

当成：

- `isCompactingRef.current = false`

的完成信号。

`coreSchemas.ts` 也把 `compact_boundary` 定义成带：

- `compact_metadata`
- `preserved_segment`

的系统消息。

`QueryEngine.ts` 更进一步说明：

- compact boundary messages 要继续 yield 给 SDK
- boundary 会释放 pre-compaction messages 以便 GC

这说明 `compact_boundary` 回答的问题不是：

- “当前还在 compacting 吗？”

而是：

- “这次 transcript rewrite 已经达到了一个可持久化、可重放、可裁剪的边界”

它更接近：

- rewrite completion marker

不是：

- keep-alive
- timeout policy
- stale-window exception

## 第六层：所以 compaction recovery contract 其实是五张不同的表

如果把前面几层压成一张表，会得到：

### 表一：progress/status

- `status=compacting`

### 表二：keep-alive

- re-emit `compacting`
- session activity signal

### 表三：local patience

- `COMPACTION_TIMEOUT_MS`

### 表四：transport exception

- `4001` session not found retry budget

### 表五：rewrite completion

- `compact_boundary`

所以这页最核心的一句应是：

- compaction recovery 不是单一状态，而是一组不同层级的合同并行工作

而不是：

- “远端进入 compacting 态之后，其他都只是它的附带效果”

## 第七层：为什么 keep-alive 会同时防 warning 和 stale，但不是同一条合同

这一点最容易写糊。

因为 keep-alive 的确会同时影响两件事：

1. 让本地不要过早触发 timeout warning
2. 让服务端不要把 session 过早判成 stale

但更稳的写法仍然是：

- 同一个 keep-alive 动作，同时服务两条不同合同

而不是：

- warning suppress 和 stale-window retry 本来就是同一回事

换句话说：

- owner-side watchdog

和：

- server-side stale judgement

虽然会被同一个 `compacting` keep-alive 触达，

但它们仍然是两条不同的 policy layer。

## 第八层：为什么它不是 67、126 的重复页

### 它不是 67

67 讲的是：

- `status=compacting` 同时喂 transcript 和 timeout policy

127 则更窄：

- 为什么 compaction recovery 相关的五个对象不是同一种恢复信号

一个讲：

- consumer mapping

一个讲：

- recovery contract layering

### 它不是 126

126 讲的是：

- `4001`、permanent close code、ordinary reconnect budget 不是同一种 stop rule

127 则讲：

- `4001` 放进 compaction recovery 合同里之后，与 status/boundary/timeout/keep-alive 的关系是什么

一个讲：

- terminality taxonomy

一个讲：

- compaction-specific recovery contract

## 第九层：最常见的假等式

### 误判一：`status=compacting` 就是完整 compaction recovery 状态

错在漏掉：

- keep-alive
- timeout policy
- `4001`
- `compact_boundary`

### 误判二：重复 `compacting` 就说明状态在继续推进

错在漏掉：

- 这里更重要的是 keep-alive 语义

### 误判三：`COMPACTION_TIMEOUT_MS` 是远端状态的一部分

错在漏掉：

- 它是本地 watchdog 的 patience policy

### 误判四：`4001` 就是 compacting 的另一种状态词

错在漏掉：

- 它是 stale-window exception

### 误判五：`compact_boundary` 只是又一条状态消息

错在漏掉：

- 它是 transcript rewrite completion marker

## 第十层：stable / conditional / internal

### 稳定可见

- compaction 当前会显式发 `status='compacting'` 与 completion `compact_boundary`
- `useRemoteSession` 当前会在 compacting 窗口切到 `COMPACTION_TIMEOUT_MS`
- `4001` 当前在 `SessionsWebSocket` 内被视为 compaction-aware special case

### 条件公开

- repeated `compacting` 的 keep-alive 语义依赖当前 compaction 路径
- `4001` 的 special retry 建立在 stale-window / compaction 语境上
- `compact_boundary` 的 preserved segment 只在某些 compact 形态下存在

### 内部 / 灰度层

- 30s keep-alive cadence
- `COMPACTION_TIMEOUT_MS = 180000`
- `MAX_SESSION_NOT_FOUND_RETRIES = 3`
- `PUT /worker heartbeat` 是否启用还受环境条件影响
- 另一层 `WebSocketTransport` 对 `4001` 的语义并不相同

这些都更适合作为：

- 当前实现证据

而不是：

- 稳定对外合同

## 第十一层：苏格拉底式自审

### 问：我现在写的是 progress/status、keep-alive、patience、stale exception，还是 rewrite completion？

答：如果答不出来，就说明又把 compaction 合同压平了。

### 问：我是不是把 `4001` 写成了普通 reconnect，或者写成了 compacting 的另一层 UI？

答：如果是，就把 transport exception 写假了。

### 问：我是不是把 `compact_boundary` 写成了 “还在 compacting” 的证明？

答：如果是，就把 completion marker 和 progress signal 混了。

### 问：我是不是把当前常量和 cadence 写成了稳定产品语义？

答：如果是，就把 gray implementation 写过头了。

## 源码锚点

- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/services/compact/compact.ts`
- `claude-code-source-code/src/remote/SessionsWebSocket.ts`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
- `claude-code-source-code/src/QueryEngine.ts`
- `claude-code-source-code/src/cli/transports/WebSocketTransport.ts`
