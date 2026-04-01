# 远程失败不是断线重连：401、Close Code与环境恢复的分层语义

这一章回答五个问题：

1. 为什么 Claude Code 的远程失败语义不能被写成“断了就重连”。
2. `SessionsWebSocket`、`remoteBridgeCore`、`replBridge`、`WebSocketTransport` 各自负责哪一层失败。
3. 为什么 `401`、`4001`、`4003`、`1002`、connect timeout、reconnect budget exhaustion 必须分层叙述。
4. 为什么 401 恢复期间要主动 drop 一部分消息。
5. 这些设计对远程 Agent runtime 的长期可用性意味着什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/remote/SessionsWebSocket.ts:21-36`
- `claude-code-source-code/src/remote/SessionsWebSocket.ts:234-299`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:456-588`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:824-878`
- `claude-code-source-code/src/bridge/replBridge.ts:887-965`
- `claude-code-source-code/src/bridge/initReplBridge.ts:192-215`
- `claude-code-source-code/src/cli/transports/WebSocketTransport.ts:38-58`
- `claude-code-source-code/src/bridge/envLessBridgeConfig.ts:13-33`

## 1. 先说结论

Claude Code 的远程失败语义至少分成五层：

1. 连接层：
   - close code
   - ping / keepalive
   - reconnect budget
2. 鉴权恢复层：
   - 401
   - OAuth refresh
   - transport rebuild
3. 会话存在性层：
   - `4001 session not found`
   - `4003 unauthorized`
   - `1002 protocol error`
4. 宿主状态层：
   - running / reconnecting / failed
   - stale pending_action 清理
5. 预检消毒层：
   - proactive refresh
   - expired-and-unrefreshable 直接 fail closed
   - connect / archive / heartbeat timeout budget

所以 Claude Code 的远程恢复不是：

- 连接断了再拨一次

而是：

- 先判断失败属于哪一层
- 再决定是预算恢复、鉴权恢复、环境重连，还是彻底失败

## 2. `SessionsWebSocket`：close code 是第一层失败语义

`SessionsWebSocket.ts` 把远程关闭原因明确分成三类：

### 2.1 永久失败

`PERMANENT_CLOSE_CODES` 当前至少包括：

- `4003 unauthorized`

命中后：

- 立即 `onClose`
- 不再尝试 reconnect

### 2.2 有预算的恢复

`4001 session not found` 被当成特殊情况：

- 可能是 compaction 期间的暂时失联
- 允许有限次重试
- 超过 `MAX_SESSION_NOT_FOUND_RETRIES` 才真正放弃

### 2.3 一般 reconnect

如果此前是 connected 且 reconnect budget 未耗尽：

- `scheduleReconnect(...)`

否则：

- `Not reconnecting`
- `onClose`

这意味着 Claude Code 的连接层不是二元布尔，而是：

- 永久失败
- 有预算恢复
- 一般重连

三类分级。

## 3. `remoteBridgeCore`：401 不是普通 close，而是 transport 语义变化

`remoteBridgeCore.ts` 对 transport close code 的处理最关键的区别是：

- `401` 不被当成普通 close，而是走 `recoverFromAuthFailure()`

这条路径会做：

1. 原子性抢占 `authRecoveryInFlight`
2. 切状态到 `reconnecting`
3. 刷 OAuth token
4. `fetchRemoteCredentials(...)`
5. 重置 `initialFlushDone`
6. `rebuildTransport(...)`

而 `rebuildTransport(...)` 的注释又把关键点说得很清楚：

- 每次 `/bridge` 都会 bump epoch
- 只换 JWT 不够
- 不 rebuild transport，旧 client 会继续心跳 stale epoch，最终 409

所以 401 在 Claude Code 里不是：

- 换个 token 继续

而是：

- 鉴权变化连带 transport epoch 一起变化

## 4. 为什么 401 恢复期间要主动 drop 消息

`remoteBridgeCore.ts` 在 `authRecoveryInFlight` 期间会主动丢弃：

- `control_request`
- `control_response`
- `control_cancel_request`
- `result`

这看起来激进，但其实是在保护控制环：

1. 旧 transport 已经陈旧。
2. 新 transport 还没完成 rebuild。
3. 此时继续写，只会制造 silent loss、stale epoch 或错误状态回写。

换句话说，Claude Code 这里选择的是：

- 宁可显式丢弃，也不制造“好像发出去了”的假成功

## 5. `replBridge` 与 `WebSocketTransport`：还有一层环境重连与超时预算

`replBridge.ts` 的 `handleTransportPermanentClose(...)` 又把失败语义往外推了一层：

- `1000` clean close：session 正常结束
- 其他永久 close：尝试 `reconnectEnvironmentWithSession()`
- reconnect 失败：显式 `failed` 并 teardown

而 `WebSocketTransport.ts` 还把：

- `1002 protocol error`
- `4001 session expired / not found`
- `4003 unauthorized`

都列为 transport permanent close codes。

`envLessBridgeConfig.ts` 又单独给出：

- `http_timeout_ms`
- `teardown_archive_timeout_ms`
- `connect_timeout_ms`

说明超时预算也是正式失败语义的一部分。

## 6. `initReplBridge`：失败并不只发生在 close 之后

`initReplBridge.ts` 还显式处理了另一类失败：

- token 已经过期，但本地还没意识到

注释说明得很清楚：

- 不做预刷新就会无谓制造大量 401
- refresh 失败后，如果 token 仍然过期，必须停止 guaranteed-fail API call
- 否则会形成 401 forever loop

这说明远程失败语义还包括：

- preflight failure avoidance

而不只是：

- post-close recovery

从第一性原理看，这一点非常重要。

因为一个成熟系统不该只会：

- 在失败后恢复

还应尽量做到：

- 在确定会失败时直接不发

## 7. 苏格拉底式追问

### 7.1 为什么不能把所有 close code 都当成“重连一下试试”

因为不同 close code 代表的不是同一种失败：

- 有的是权限被拒
- 有的是 session 暂时不可见
- 有的是 transport 协议本身失效

### 7.2 为什么 401 恢复不能只换 token

因为 epoch 和 transport 语义一起变了。

### 7.3 为什么恢复期间要 drop 控制消息

因为最危险的不是失败本身，而是：

- 在陈旧 transport 上继续制造成功错觉

### 7.4 为什么 expired token 要在发请求前就 fail closed

因为 guaranteed-fail path 不是“先试试看”这么简单，而是会把系统拖进无意义的 401 loop。

## 8. 一句话总结

Claude Code 的远程失败语义不是“断线重连”，而是一套把 close code、401、epoch、超时预算、环境恢复与预检消毒分层处理的恢复状态机。
