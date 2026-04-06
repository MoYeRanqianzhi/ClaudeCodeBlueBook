# Remote Control token refresh、child sync 与 heartbeat 认证索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/44-session token refresh、child sync 与 bridge reconnect：为什么 standalone remote-control 的 child 刷新、heartbeat 续租与 v2 重派发不是同一种 token refresh.md`
- `05-控制面深挖/41-sdk-url、sessionIngressUrl、environmentSecret、session access token 与 workerEpoch：为什么 standalone remote-control 的 URL、密钥、令牌与传输纪元不是同一种连接凭证.md`
- `05-控制面深挖/42-register、poll、ack、heartbeat、stop、archive 与 deregister：为什么 standalone remote-control 的环境、work 与 session 生命周期不是同一种收口.md`

## 1. 五类 refresh 对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Refresh Timing` | 什么时候该触发 refresh | `createTokenRefreshScheduler` |
| `Child Token Sync` | 现有 child 怎样收到新 token | `handle.updateAccessToken`、`update_environment_variables` |
| `Heartbeat Auth Ledger` | host heartbeat 继续用哪份 token | `sessionIngressTokens` |
| `v1 Refresh Delivery` | 现有 child 怎样继续跑 | direct child sync |
| `v2 Refresh Delivery` | 为什么改走 re-dispatch | `bridge/reconnect` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| bridge 只有一份 token 状态 | child 与 heartbeat 各有账本 |
| scheduler = token 已经同步到 child | scheduler 只负责 timing |
| v1 refresh = v2 refresh | 一个走 child sync，一个走 reconnect |
| `updateAccessToken` = 改本地字段 | 它还会把 env update 推进 child REPL |
| heartbeat 跟着 child token 走 | heartbeat 单独读 `sessionIngressTokens` |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | 长任务 token 连续性、v1 child 持续运行、v2 reconnect 刷新 |
| 条件公开 | `v2Sessions` 分支、existing-handle fresh token 更新、无 OAuth 时 retry |
| 内部/实现层 | `sessionIngressTokens`、`update_environment_variables`、generation/cancel 机制 |

## 4. 六个高价值判断问题

- 当前 token 服务的是 child、heartbeat，还是 server？
- 这是 refresh timing，还是 refresh delivery？
- 走的是 v1 child sync，还是 v2 reconnect？
- 这次变化会不会同时更新 heartbeat token 与 child env？
- 我是不是又把 scheduler 和 token 传播写成同一步？
- 我是不是又把 v2 reconnect 写成了 child env update？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/sessionRunner.ts`
- `claude-code-source-code/src/cli/structuredIO.ts`
- `claude-code-source-code/src/bridge/jwtUtils.ts`
- `claude-code-source-code/src/bridge/types.ts`
