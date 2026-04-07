# `headersRefreshed`、`autoReconnect`、sleep detection 与 `4003` refresh path：为什么 `WebSocketTransport` 的恢复主权不是 `SessionsWebSocket` 的镜像

## 用户目标

128 已经把同一个 `4001 session not found` 拆成了两种不同合同：

- `SessionsWebSocket 4001`
- `WebSocketTransport 4001`

但继续往下读时，读者仍然很容易再压成另一句表面更细、实际上仍然过粗的话：

- `WebSocketTransport` 只是比 `SessionsWebSocket` 多了几个恢复分支
- 它们本质上都还是 transport 自己负责恢复
- 差别只是一个能 refresh header，一个会检测 sleep

这句也不稳。

从当前源码看，`WebSocketTransport` 的恢复不是单一 owner 的动作，

而是至少四层主权混在一起：

1. transport 自己的 backoff / replay / reconnect budget
2. `refreshHeaders` 提供者的认证修复权
3. caller 通过 `autoReconnect` 的接管权
4. 更上层 caller 在 terminal close 之后做 session / environment 重建的主权

而且它维护的也不只是：

- “这个 session 眼下是不是还可见”

它还要维护：

- 读写连续性
- replay buffer
- reconnect budget
- auth rollover 之后的继续写入能力

而 `SessionsWebSocket` 的恢复主权则明显更内聚。

所以这页要补的不是：

- “它们谁更能重连”

而是：

- “它们各自把恢复主权交给了谁”

## 第一性原理

更稳的提问不是：

- “`WebSocketTransport` 到底会不会自动恢复？”

而是先问五个更底层的问题：

1. 谁能修复认证材料：transport 自己，还是外部 token signer？
2. 谁能决定 budget 继续、重置还是放弃？
3. 谁能关掉 transport 内部恢复，改由 caller 接管？
4. terminal close 之后，谁还能继续重建 session / environment？
5. 当前看到的是 reconnect attempt，还是更高一层的 recovery handoff？

只要这五轴先拆开，`WebSocketTransport` 就不会再被误写成：

- “`SessionsWebSocket` 的增强版镜像”

## 第一层：`SessionsWebSocket` 的恢复主权大体是内聚在组件内部的

`SessionsWebSocket.ts` 当前给出的恢复面非常集中：

- `getAccessToken()` 每次 `connect()` 前取新 token
- `4003` 属于 permanent close
- `4001` 走 compaction-aware special budget
- 普通断开走 `MAX_RECONNECT_ATTEMPTS`
- caller 主要收到 `onReconnecting` / `onClose`

也就是说，这一层更像：

- fixed-strategy subscription client

而不是：

- caller-coordinated recovery control plane

caller 可以观察恢复开始和终止，

但并没有看到类似：

- `autoReconnect: false`
- `headersRefreshed`
- sleep budget reset

这种把恢复主权拆出去的接口。

## 第二层：`WebSocketTransport` 从类型定义起就承认“恢复可以属于 caller”

`WebSocketTransportOptions` 顶部注释直接写了：

- `autoReconnect?: boolean`
- when false, the caller has its own recovery mechanism
- 例子就是 REPL bridge poll loop

这句话非常关键。

它说明 `WebSocketTransport` 从设计上就不是一个必然自洽、自我闭环的恢复体。

它允许：

- transport 内部恢复

也允许：

- caller 明确关闭 transport 内部恢复，然后自己接管

所以更准确的主语是：

- recovery authority is configurable

不是：

- transport always owns recovery

## 第三层：`refreshHeaders` 不是 `SessionsWebSocket.getAccessToken()` 的镜像

这是最容易被误判的一步。

因为两边看上去都像：

- 重连前重新拿 token

但当前语义并不一样。

### `SessionsWebSocket`

- `getAccessToken()` 只在下一次 `connect()` 前被读取
- `4003` 直接属于 `PERMANENT_CLOSE_CODES`
- 没有 “`4003` 因为 header 更新成功而被赦免” 的分支

### `WebSocketTransport`

`handleConnectionError(closeCode)` 里有一段非常明确的特判：

- `closeCode === 4003`
- 且存在 `refreshHeaders`
- 且新 `Authorization` 与旧值不同

这时：

- `headersRefreshed = true`
- 不走 permanent close
- 继续 schedule reconnect

也就是说这层在回答的不是：

- “401/403/4003 一来就 stop”

而是：

- “当前 unauthorized 能否被外部认证刷新动作挽回”

所以 `refreshHeaders` 的本质更接近：

- external auth repair authority

不是：

- `SessionsWebSocket.getAccessToken()` 的同构替身

## 第四层：`WebSocketTransport` 会在一般 reconnect 路径里再次把 header 修复权交给外部

`4003` refresh path 还不是全部。

在一般 reconnect 分支里，`WebSocketTransport` 还会在真正排 reconnect 之前再次执行：

- `refreshHeaders()`

并把 fresh headers merge 回当前连接头。

这意味着它不是只在：

- unauthorized

这种 close 上依赖外部 signer，

而是在：

- ordinary reconnect path

里也承认 token / header material 可能由外部系统变更。

因此 `WebSocketTransport` 的恢复链条天然是双层的：

1. transport 负责 retry、backoff、message replay
2. 外部 provider 负责把“下一次尝试”变成带新凭据的尝试

## 第五层：sleep detection 重置的是 budget，不是 session 身份

`WebSocketTransport.ts` 的 sleep detection 注释写得很清楚：

- 如果 gap 过大，认为机器可能睡眠过
- reset reconnection budget and retry
- 但如果 session was reaped during sleep，server 会返回 permanent close code `4001/1002`

这句话的关键就在于它拆开了两件事：

### transport 能做的

- 重开一段 reconnect window
- 把 budget 从头算
- 再试一次连接

### transport 不能保证的

- 原 session 仍然存在
- 原 environment 没被 reaped
- 服务端会把这次 reconnect 当成同一条活着的 session

所以 sleep detection 的真实主语是：

- budget reset authority

不是：

- session resurrection authority

如果把这一步误写成：

- “sleep 之后 transport 会自动恢复原 session”

就把 budget repair 和 session repair 混成了一件事。

## 第六层：父进程可能才是真正的 token 修复 signer

这一步在 `remoteIO.ts` 和 `bridge/sessionRunner.ts` 里能看得更清楚。

`remoteIO.ts` 的 `refreshHeaders()` 会重新读取：

- session ingress token
- environment runner version

而 `sessionRunner.ts` 又会在 token 更新时把新的值通过 stdin 发给子进程：

- `update_environment_variables`
- `CLAUDE_CODE_SESSION_ACCESS_TOKEN`

然后子进程下一次 `refreshHeaders()` 再把它捡起来。

所以在这一层里，真正修复认证材料的人往往不是 transport，

而是：

- parent process / runner / token source

`WebSocketTransport` 只是：

- 接受外部修好的材料
- 再拿它执行下一次连接尝试

这和 `SessionsWebSocket` 那种更内聚的 “自己在 `connect()` 前拿 token” 很不一样。

## 第七层：`autoReconnect: false` 说明 transport 可以主动放弃恢复主权

`handleConnectionError(closeCode)` 在 permanent close 之外还有另一条很关键的分流：

- 如果 `!autoReconnect`
- 直接 `state = 'closed'`
- `onCloseCallback?.(closeCode)`

这说明有些 caller 并不希望 transport 自己一直 retry。

它们更想要的是：

- transport 尽快把 terminal close 交还出来
- caller 自己决定下一步是重建、轮询、换 session 还是彻底放弃

所以这里的 `onClose` 不是简单的：

- “socket 终于失败了”

更像：

- “transport 把恢复 baton 交回 caller”

这也是 `SessionsWebSocket` 当前没有给出的恢复形状。

## 第八层：有些 caller 在 terminal close 之后还会继续做更高一层的恢复

`bridge/replBridge.ts` 里对 `setOnClose` 的注释进一步说明了这一点。

它明确写：

- `autoReconnect:true` 时，transient drop 由 transport 内部处理
- `setOnClose` 只在 clean close、permanent rejection 或 10 分钟 budget exhausted 时触发

而一旦触发 terminal close，bridge 层做的事情不是“接受结束”，而是：

- `wakePollLoop()`
- `reconnectEnvironmentWithSession()`

也就是说在 bridge caller 这一层，terminal `onClose` 甚至不是最后的 recovery sink，

它只是：

- transport-owned recovery 的结束点
- caller-owned environment/session recovery 的起点

这与 `SessionsWebSocket.onClose` 的语义重心明显不同。

`SessionsWebSocket.onClose` 更接近：

- 本组件恢复策略用尽后的终局通知

而 `WebSocketTransport.onClose` 在某些 caller 里更接近：

- recovery authority handoff signal

## 第九层：因此 `WebSocketTransport` 的恢复主权是分层合同，不是 `SessionsWebSocket` 的镜像

把前面几层压成一句，最稳的一句其实是：

- `WebSocketTransport` is a layered recovery authority contract

大致可以拆成：

### transport 自己拥有

- ping / keepalive
- 连接健康检测
- replay buffer
- 写入连续性
- reconnect backoff
- reconnect budget
- sleep 后 budget reset

### 外部 header provider 拥有

- auth material repair
- `4003` 是否还能被救回来

### caller 拥有

- 是否关闭内部 auto reconnect
- terminal `onClose` 后是否继续接管

### 更高层 session / environment owner 拥有

- 是否重新建环境
- 是否重新排 work
- 是否换 session / epoch / ingress

而 `SessionsWebSocket` 的当前恢复合同显然更集中：

- `4001` special budget
- ordinary reconnect budget
- permanent `4003`
- caller mostly observe, not re-own

所以两者不是：

- same recovery owner, more branches

而是：

- different ownership topology

## 第十层：为什么它不是 125、126、128 的重复页

### 它不是 125

125 讲的是：

- `handleClose`
- `scheduleReconnect`
- `reconnect()`
- `onReconnecting`
- `onClose`

这些 action / state 为什么不是同一种 transport 状态。

129 讲的是：

- 谁拥有这些动作背后的修复权

一个讲：

- recovery action-state

一个讲：

- recovery ownership topology

### 它不是 126

126 讲的是：

- permanent close
- `4001`
- reconnect budget

为什么不是同一种 terminality rule。

129 讲的是：

- 就算都是 reconnect / close，谁在修 token、谁在重置预算、谁在接管恢复

一个讲：

- stop rule

一个讲：

- recovery owner

### 它不是 128

128 讲的是：

- 同一个 `4001` 在两个组件里不是同一种合同

129 讲的是：

- 即便不只看 `4001`，`WebSocketTransport` 的恢复主权结构也不是 `SessionsWebSocket` 的镜像

一个讲：

- same code, different semantics

一个讲：

- same broad problem space, different authority distribution

## 第十一层：最常见的假等式

### 误判一：`refreshHeaders` 就是 `getAccessToken()` 的另一种写法

错在漏掉：

- `WebSocketTransport 4003` 可以因为 header 刷新成功而不再被视为 terminal
- `SessionsWebSocket 4003` 当前没有这条例外

### 误判二：sleep detection 已经等于 session recovery

错在漏掉：

- 它只重置 budget
- 服务端仍可能以 `4001/1002` 告诉你原 session 已经被 reaped

### 误判三：`autoReconnect: false` 说明 transport 更弱

错在漏掉：

- 这其实是把恢复主权显式交给 caller

### 误判四：`onClose` 一旦触发就说明整个系统恢复结束

错在漏掉：

- 对某些 caller 来说，`onClose` 恰恰是更高层 recovery 的起点

### 误判五：`WebSocketTransport` 只是 `SessionsWebSocket` 的增强版

错在漏掉：

- 两者当前连恢复 owner 的分布方式都不同

## 第十二层：stable / conditional / internal

### 稳定可见

- `WebSocketTransport` 当前显式支持 caller-owned recovery：`autoReconnect` 可以关闭内部重连
- `WebSocketTransport` 当前把 `4003` 做成 conditional terminality：header 刷新成功时可继续 reconnect
- `SessionsWebSocket` 当前仍把 `4003` 视为 permanent close，且没有对等的 caller handoff 开关

### 条件公开

- `4003` 只有在存在 `refreshHeaders` 且 `Authorization` 真正变化时才会被挽回
- sleep detection 只有在 gap 超过阈值、且 transport 本身仍负责 auto reconnect 时才会重置 budget
- bridge 这类 caller 只有在 terminal close 之后，才会继续做 environment/session 级 recovery

### 内部 / 灰度层

- `SLEEP_DETECTION_THRESHOLD_MS`
- `DEFAULT_RECONNECT_GIVE_UP_MS = 600_000`
- jitter 算法
- 当前 permanent close code 列表
- token 通过 stdin `update_environment_variables` 下发，再被 `refreshHeaders` 捡起

这些更适合作为：

- 当前实现证据

而不是：

- 对外稳定承诺

## 第十三层：苏格拉底式自审

### 问：我是不是把 auth repair 写成了 transport 自己修好？

答：如果是，就漏掉了 `refreshHeaders` 的外部 signer。

### 问：我是不是把 budget reset 写成了 session resurrection？

答：如果是，就把 sleep detection 写过头了。

### 问：我是不是把 `onClose` 误写成整个系统的最终失败？

答：如果是，就把 caller-owned recovery handoff 漏掉了。

### 问：我是不是把 `WebSocketTransport` 和 `SessionsWebSocket` 仅仅写成“分支多寡不同”？

答：如果是，就还没拆出 ownership topology。

### 问：我是不是把 bridge caller 的恢复路径偷换成了所有 caller 的稳定合同？

答：如果是，就把 caller-specific recovery 外推成了全局规则。

## 源码锚点

- `claude-code-source-code/src/cli/transports/WebSocketTransport.ts`
- `claude-code-source-code/src/cli/transports/HybridTransport.ts`
- `claude-code-source-code/src/remote/SessionsWebSocket.ts`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/cli/remoteIO.ts`
- `claude-code-source-code/src/bridge/sessionRunner.ts`
- `claude-code-source-code/src/bridge/replBridge.ts`
