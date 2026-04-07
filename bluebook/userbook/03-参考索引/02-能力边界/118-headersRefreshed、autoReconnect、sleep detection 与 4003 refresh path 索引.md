# `headersRefreshed`、`autoReconnect`、sleep detection 与 `4003` refresh path 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/129-headersRefreshed、autoReconnect、sleep detection 与 4003 refresh path：为什么 WebSocketTransport 的恢复主权不是 SessionsWebSocket 的镜像.md`
- `05-控制面深挖/125-handleClose、scheduleReconnect、reconnect()、onReconnecting 与 onClose：为什么 transport recovery action-state contract 不是同一种状态.md`
- `05-控制面深挖/128-SessionsWebSocket 4001、WebSocketTransport 4001 与 session not found：为什么它们不是同一种合同.md`

边界先说清：

- 这页不是 terminality 一般论。
- 这页不替代 125 的 action-state 页。
- 这页不替代 128 的 `4001` 语义分裂页。
- 这页只抓 `WebSocketTransport` 的恢复主权为什么不是 `SessionsWebSocket` 的镜像。

## 1. 两种恢复主权形状

| 组件 | 当前主语 | 典型位置 |
| --- | --- | --- |
| `SessionsWebSocket` | 组件内部自带的 reconnect / special retry policy | `handleClose(closeCode)` |
| `WebSocketTransport` | transport、`refreshHeaders`、caller 与更高层 session owner 共同分担的 recovery authority | `handleConnectionError(closeCode)`、`autoReconnect` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `refreshHeaders` 就是 `getAccessToken()` 的镜像 | `WebSocketTransport 4003` 允许外部 header 刷新改变 terminality，`SessionsWebSocket 4003` 当前不允许 |
| sleep detection 已经等于 session recovery | 它只重置 reconnect budget，session 仍可能被服务端判为 reaped |
| `autoReconnect: false` 说明 transport 更弱 | 这表示 caller 显式接管恢复主权 |
| `onClose` 触发就代表整个系统恢复结束 | 对某些 caller 来说，`onClose` 是更高层 recovery handoff |
| `WebSocketTransport` 只是 `SessionsWebSocket` 多了几个恢复分支 | 两者当前连 recovery owner 的分布结构都不同 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `WebSocketTransport` 当前显式允许 caller-owned recovery；`4003` 在 header 刷新成功时可继续 reconnect；`SessionsWebSocket` 当前仍把 `4003` 视为 permanent close |
| 条件公开 | `4003` salvage 依赖 `refreshHeaders` 与新 `Authorization`；sleep reset 依赖 gap 超阈值与 `autoReconnect=true`；更高层 environment/session 重建依赖具体 caller |
| 内部/灰度层 | sleep 阈值、10 分钟 budget、jitter、当前 permanent close code 列表、stdin 下发 token 的细节 |

## 4. 五个检查问题

- 我现在写的是 transport 自己的 retry，还是 caller / parent process 的 recovery？
- 我是不是把 `refreshHeaders` 草率写成了 `getAccessToken()` 的镜像？
- 我是不是把 sleep budget reset 误写成了 session resurrection？
- 我是不是把 `onClose` 误写成了整个系统的最终失败？
- 我是不是把 bridge caller 的恢复路径偷换成了所有 caller 的稳定合同？

## 5. 源码锚点

- `claude-code-source-code/src/cli/transports/WebSocketTransport.ts`
- `claude-code-source-code/src/remote/SessionsWebSocket.ts`
- `claude-code-source-code/src/cli/remoteIO.ts`
- `claude-code-source-code/src/bridge/sessionRunner.ts`
- `claude-code-source-code/src/bridge/replBridge.ts`
