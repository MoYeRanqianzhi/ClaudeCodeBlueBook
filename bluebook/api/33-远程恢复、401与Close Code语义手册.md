# 远程恢复、401与Close Code语义手册

这一章回答五个问题：

1. Claude Code 的远程 API 面怎样表达不同类型的失败。
2. `4001`、`4003`、`1002`、`401` 在当前实现里各自意味着什么。
3. 哪些失败会触发 reconnect，哪些失败会直接结束会话。
4. 为什么 401 恢复要同时重建 transport，而不是只换 token。
5. 宿主与平台实现者如何避免把远程失败都写成“连接断开”。

## 1. 关键源码锚点

- `claude-code-source-code/src/remote/SessionsWebSocket.ts:21-36`
- `claude-code-source-code/src/remote/SessionsWebSocket.ts:234-299`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:456-588`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:824-878`
- `claude-code-source-code/src/bridge/replBridge.ts:887-965`
- `claude-code-source-code/src/bridge/initReplBridge.ts:192-215`
- `claude-code-source-code/src/cli/transports/WebSocketTransport.ts:38-58`
- `claude-code-source-code/src/bridge/envLessBridgeConfig.ts:13-33`

## 2. 先说结论

Claude Code 当前可见的远程失败语义至少分成五类：

1. 永久拒绝：
   - `4003 unauthorized`
   - `1002 protocol error`
2. 有预算的临时失联：
   - `4001 session not found`
3. 鉴权恢复：
   - `401`
   - OAuth refresh + `fetchRemoteCredentials` + transport rebuild
4. 环境级重连：
   - reconnect budget exhausted 后的 env reconnect
5. 预检失败避免：
   - token 已经过期且 refresh 失败
   - connect timeout / archive timeout / heartbeat budget

如果把这些全写成“断线重连”，就会抹掉：

- 权限问题
- compaction 窗口问题
- stale epoch 问题
- 环境失效问题
- guaranteed-fail preflight 问题

## 3. close code 对照：不要混成一个“close”事件

### 3.1 `4003`

当前实现中属于：

- permanent close

处理方式：

- 不重连
- 直接 `onClose`

### 3.2 `4001`

当前实现中属于：

- session temporarily not found with retry budget

处理方式：

- 有限次 `scheduleReconnect(...)`
- 超预算后再放弃

### 3.3 `1002`

在 `WebSocketTransport.ts` 中被归入：

- permanent server-side rejection

处理方式：

- transport 立即 closed
- 不做 auto reconnect

### 3.4 `401`

在 `remoteBridgeCore.ts` 中被归入：

- auth recovery path

处理方式：

- 不直接标记 dead
- 走 `recoverFromAuthFailure()`

## 4. 401 恢复的最小正确理解

当前实现不是：

1. 收到 401
2. 刷个 token
3. 继续

而是：

1. 抢占 `authRecoveryInFlight`
2. 切到 `reconnecting`
3. 刷 OAuth token
4. 拉 fresh remote credentials
5. 重置 `initialFlushDone`
6. rebuild transport

原因在源码里已经写得很清楚：

- 每次 `/bridge` 都会 bump epoch
- JWT 变了，transport 也必须一起变

所以对外正确理解应该是：

- 401 是 transport-semantic change，不只是 auth token change

## 5. 401 恢复期间的 API 现实：部分消息会被故意丢弃

恢复窗口里当前实现会 drop：

- `control_request`
- `control_response`
- `control_cancel_request`
- `result`

这意味着宿主或平台如果自己封装远程桥接，不应假设：

- 恢复期间发出去的控制消息一定还能被接受

更稳的做法是：

- 恢复完成后再恢复控制环

## 6. reconnect 预算和 timeout 也是正式语义

`envLessBridgeConfig.ts` 把几类 timeout 单独做成配置：

- `http_timeout_ms`
- `teardown_archive_timeout_ms`
- `connect_timeout_ms`

这说明 Claude Code 的远程失败并不是“等默认网络栈超时”。

它有正式预算：

- 初始化多久没 connect 算超时
- teardown 归档最多给多久
- 普通 HTTP 请求最多等多久

所以 timeout 在这里不是工具层杂项，而是：

- 远程语义的一部分

## 7. 预检失败避免：有些失败不该等 401 才暴露

`initReplBridge.ts` 里有一段很成熟的设计：

1. 如果 OAuth token 已经过期，先主动 refresh。
2. 如果 refresh 失败且 token 仍然过期，直接跳过 guaranteed-fail API call。
3. 把状态显式落成 `failed`，避免进入 401 forever loop。

这说明 Claude Code 的远程失败语义不只覆盖：

- close 之后怎么恢复

还覆盖：

- 哪些请求根本不该继续发送

所以更准确的说法不是：

- 失败后重试

而是：

- 失败前先消灭 guaranteed-fail path

## 8. 对宿主实现者的最小规则

如果你要消费或复刻 Claude Code 的远程桥接，至少要遵守五条规则：

1. 把 `4001`、`4003`、`1002`、`401` 分开处理
2. 不要把 401 当成单纯 token refresh
3. 恢复期间不要强行维持旧控制环写入
4. 把 reconnect budget exhaustion 和 env reconnect 分开记录
5. 对 timeout 使用显式预算，不要只靠默认 socket 超时
6. 对 expired-and-unrefreshable token 直接 fail closed，不要进入 guaranteed-fail loop

## 9. 一句话总结

Claude Code 的远程恢复 API 不是“close 后重连”这么简单，而是一套把 close code、401、epoch、timeout 和环境重连分层表达的失败语义系统。
