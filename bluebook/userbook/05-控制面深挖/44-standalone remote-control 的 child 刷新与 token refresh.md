# `session token refresh`、child sync 与 `bridge/reconnect`：为什么 standalone remote-control 的 child 刷新、heartbeat 续租与 v2 重派发不是同一种 token refresh

## 用户目标

不是只知道 standalone `claude remote-control` 会：

- 给 child 注入 `CLAUDE_CODE_SESSION_ACCESS_TOKEN`
- 长任务里还会 refresh token
- heartbeat 也要继续成功
- v2 有时又会走 `bridge/reconnect`

而是先分清五类不同对象：

- 哪些是在给 child REPL 进程更新当前 session token。
- 哪些是在给 host 的 heartbeat 保留一份独立 token 账本。
- 哪些是在调度“何时该刷新”。
- 哪些是在 v1 路径里把新 token 直接同步进 child。
- 哪些是在 v2 路径里根本不把新 token直推给 child，而是改走 server re-dispatch。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“token refresh”：

- `sessionIngressTokens`
- `handle.accessToken`
- `handle.updateAccessToken(...)`
- `update_environment_variables`
- `CLAUDE_CODE_SESSION_ACCESS_TOKEN`
- `tokenRefresh.schedule(...)`
- `heartbeatWork(...)`
- `reconnectSession(...)`
- `v2Sessions`

## 第一性原理

standalone remote-control 的认证连续性至少沿着四条轴线分化：

1. `Auth Consumer`：当前 token 是给 child transport、host heartbeat，还是 server re-dispatch 用。
2. `Refresh Mechanism`：当前是直接把新 token 推给 child，还是通过 re-queue 让服务端重新下发。
3. `Runtime Version`：当前走的是 v1 child-sync path，还是 v2 reconnect path。
4. `Time`：当前处理的是初始 spawn 时的 token 注入，还是长任务中的 refresh / reschedule / cancel。

因此更稳的提问不是：

- “bridge 不是已经有 session token 了吗，为什么还要这么多 refresh 逻辑？”

而是：

- “这次刷新要服务的是 child、heartbeat，还是 server；它是直接同步 token，还是借 re-dispatch 换一份新 token；当前又处在 v1 还是 v2 路径？”

只要这四条轴线没先拆开，正文就会把 child refresh、heartbeat auth 与 v2 reconnect 写成同一种 token refresh。

## 第一层：`sessionIngressTokens` 与 `handle.accessToken` 不是同一份账本

### `sessionIngressTokens` 专门保留给 host heartbeat

`bridgeMain.ts` 一开始就单独维护：

- `sessionIngressTokens = new Map<string, string>()`

旁边注释明确写出：

- 这是给 heartbeat auth 用的 session ingress JWT
- 它要和 `handle.accessToken` 分开存

### 分开的原因不是冗余，而是 refresh scheduler 会覆盖 `handle.accessToken`

同一段注释继续说明：

- token refresh scheduler 最终会把 `handle.accessToken` 改成 OAuth token

因此如果 heartbeat 也偷用 `handle.accessToken`，它就会失去那份必须继续用于：

- `heartbeatWork(...)`

的 session-ingress JWT。

### 所以这两份对象根本服务不同 consumer

更准确的区分是：

- `sessionIngressTokens`：host 侧 heartbeat 的 session-token 账本
- `handle.accessToken`：child / handle 当前持有的“用于继续连 transport 的那份 token 状态”

只要这一层没拆开，正文就会把：

- “bridge 持有的 token”

写成只有一份的单账本。

## 第二层：refresh scheduler 调度的是“何时刷新”，不是“刷新后一定怎样传播”

### `createTokenRefreshScheduler(...)` 只负责时间，不负责最终传输策略

`jwtUtils.ts` 对 scheduler 的职责写得非常清楚：

- 在 token 临近过期前触发
- 调用 `onRefresh(sessionId, oauthToken)`
- 调用者自己负责把新 token 送到正确 transport

这说明 scheduler 回答的问题不是：

- v1 / v2 最终怎样换 token

而是：

- 何时该触发 refresh
- 失败时怎样 retry / cancel / invalidate generation

### 所以 “schedule” 与 “deliver” 不是同一步

`schedule(...)` 会：

- decode JWT expiry
- 安排 timer

`doRefresh(...)` 则只会：

- 取到新的 OAuth token
- 调 `onRefresh(...)`
- 再安排 follow-up refresh

因此更稳的理解应是：

- scheduler = refresh timing engine
- child sync / reconnect = refresh delivery strategy

只要这一层没拆开，正文就会把：

- 何时刷新
- 刷新后怎么传

写成同一个动作。

## 第三层：v1 路径的 refresh 是“把新 token 推进 child”

### v1 `onRefresh(...)` 直接走 `handle.updateAccessToken(oauthToken)`

`bridgeMain.ts` 在 `tokenRefresh` 的 `onRefresh` 里分支非常明确：

- 如果不是 v2 session
- 就直接 `handle.updateAccessToken(oauthToken)`

这说明 v1 的核心语义不是：

- 让服务端重新分派一条 work

而是：

- 现有 child 继续活着，只把它的 transport auth 更新掉

### `SessionHandle.updateAccessToken(...)` 也不是只改一个字段

`sessionRunner.ts` 里：

- 先改 `handle.accessToken`
- 再通过 stdin 写 `update_environment_variables`
- 把 `CLAUDE_CODE_SESSION_ACCESS_TOKEN` 推进 child 进程

这说明 v1 refresh 的核心不是：

- host 自己记住了新 token

而是：

- child REPL 进程必须实际收到新 token，下一次 `refreshHeaders` 才能继续成功

### `structuredIO.ts` 进一步说明这是 REPL 进程级 env update

child 侧 `StructuredIO` 收到：

- `update_environment_variables`

后会直接：

- 把变量写回 `process.env`

注释还强调：

- 这必须对 REPL process 本身可见
- 不是只给 Bash command 子进程看

因此更准确的理解应是：

- v1 refresh = host 通过 stdin 把新 token 同步进现存 child REPL

## 第四层：v2 路径的 refresh 不是 child sync，而是 `bridge/reconnect` 重派发

### `v2Sessions` 是整个分支切换的关键 gate

`bridgeMain.ts` 里会单独维护：

- `v2Sessions = new Set<string>()`

并明确写出：

- v2 children cannot use OAuth tokens
- onRefresh triggers server re-dispatch instead

### 因而 v2 `onRefresh(...)` 直接走 `reconnectSession(...)`

同一段 `onRefresh` 里，若 `sessionId` 在 `v2Sessions`：

- 记录日志
- 调 `api.reconnectSession(environmentId, sessionId)`

这说明 v2 的 refresh 问题不是：

- 如何把 OAuth token 注入 child

而是：

- 如何让服务端重新下发一份带新 JWT 的 work

### 所以 v1 和 v2 的 refresh 根本不是“同一动作，不同实现”

更准确的区分是：

- v1：现有 child 继续活着，host 直接给它喂新 token
- v2：现有 child 不吃这种 OAuth refresh，host 让 server 重派发 session work

只要这一层没拆开，正文就会把：

- `updateAccessToken(...)`
- `reconnectSession(...)`

写成一种“刷新实现细节”。

## 第五层：heartbeat 用的是 session token continuity，不跟着 v1 OAuth refresh 一起改账

### heartbeat 始终从 `sessionIngressTokens` 读 token

`bridgeMain.ts` 的 `heartbeatActiveWorkItems()` 会：

- 先按 `sessionId` 取 `sessionIngressTokens`
- 再用它打 `heartbeatWork(...)`

它不看：

- `handle.accessToken`

### 这说明 host heartbeat 的认证连续性和 child token 连续性是两条并行线

更稳的理解应是：

- child token continuity：看 `handle.updateAccessToken(...)` + stdin env update
- heartbeat continuity：看 `sessionIngressTokens` map 什么时候被 fresh JWT 替换

### 现有 session 被 re-dispatch 时，这两条线才一起被更新

`bridgeMain.ts` 在 `existingHandle` 分支收到 fresh work 时，会一起做：

- `existingHandle.updateAccessToken(secret.session_ingress_token)`
- `sessionIngressTokens.set(sessionId, secret.session_ingress_token)`
- `tokenRefresh.schedule(sessionId, secret.session_ingress_token)`

这说明真正让两条线重新对齐的不是普通 v1 OAuth refresh，而是：

- 服务端重新发回一份 fresh session-ingress token 的 work

## 第六层：cancel / cleanup 也必须分 session 做，不然长任务会留下错误的 refresh 时钟

### session 结束时会单独 cancel 自己的 refresh timer

`bridgeMain.ts` 在 `onSessionDone(...)` 里会：

- `sessionIngressTokens.delete(sessionId)`
- `tokenRefresh?.cancel(sessionId)`

这说明 refresh scheduler 不是 bridge 级单计时器，而是：

- per-session timing chain

### 全局 shutdown 时还会 `cancelAll()`

在 shutdown 路径里，`bridgeMain.ts` 还会：

- `tokenRefresh?.cancelAll()`

这说明 refresh 这条线的收口也不是“可有可无的计时器清理”，而是：

- 防止桥接退出后继续带着 stale refresh callbacks

## 第七层：稳定、条件与内部三层要分开保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | 长任务不会因为 token 过期就立刻静默失联、v1 child 可继续续跑、v2 会改走 reconnect |
| 条件公开 | `v2Sessions` 分支、existing-handle fresh token 更新、无 OAuth 时 refresh retry |
| 内部/实现层 | `sessionIngressTokens`、`handle.updateAccessToken`、`update_environment_variables`、scheduler generation / cancel 机制 |

这里尤其要避免两种写坏方式：

- 把所有 refresh 都写成“桥接自动续期”一句话带过
- 把 v2 re-dispatch 误写成“只是另一种 child env update”

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| bridge 只有一份 session token 状态 | `sessionIngressTokens` 与 `handle.accessToken` 分属不同 consumer |
| scheduler = token 被送进 child | scheduler 只决定何时 refresh，传播策略由 `onRefresh` 决定 |
| v1 refresh = v2 refresh | 一个是 child sync，一个是 server re-dispatch |
| `updateAccessToken(...)` = 改本地字段 | 它还会通过 stdin 把 env 更新推给 child REPL |
| heartbeat 跟着 child 的 token 字段跑 | heartbeat 单独读 `sessionIngressTokens` |
| 只要 refresh 过一次就不用再管 | scheduler 还会安排 follow-up refresh，session 结束时也要 cancel |

## 六个高价值判断问题

- 当前 token 要服务的是 child、heartbeat，还是 server re-dispatch？
- 当前处理的是 refresh timing，还是 refresh delivery？
- 现在走的是 v1 child sync，还是 v2 reconnect？
- 这次变化会不会同时更新 `sessionIngressTokens` 与 child env？
- 我是不是又把 scheduler 和 token 传播写成同一步？
- 我是不是又把 v2 reconnect 写成“另一种 updateAccessToken”？

## 源码锚点

- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/sessionRunner.ts`
- `claude-code-source-code/src/cli/structuredIO.ts`
- `claude-code-source-code/src/bridge/jwtUtils.ts`
- `claude-code-source-code/src/bridge/types.ts`
