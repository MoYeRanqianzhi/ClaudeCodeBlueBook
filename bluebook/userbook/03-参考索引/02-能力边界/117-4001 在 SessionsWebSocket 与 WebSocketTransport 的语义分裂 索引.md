# `4001` 在 `SessionsWebSocket` 与 `WebSocketTransport` 的语义分裂 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/128-SessionsWebSocket 4001、WebSocketTransport 4001 与 session not found：为什么它们不是同一种合同.md`
- `05-控制面深挖/126-PERMANENT_CLOSE_CODES、4001 与 reconnect budget：为什么 terminality policy 不是同一种 stop rule.md`
- `05-控制面深挖/127-compacting、boundary、timeout、4001 与 keep-alive：为什么 compaction recovery contract 不是同一种恢复信号.md`

边界先说清：

- 这页不是 terminality 一般论。
- 这页不替代 126。
- 这页不替代 127 的 compaction 合同页。
- 这页只抓同一个 `4001` 在两个组件里为什么不是同一种 session-not-found 合同。

## 1. 两种 `4001` 合同

| 组件 | 当前回答什么 | 典型位置 |
| --- | --- | --- |
| `SessionsWebSocket` | compaction stale-window 下是否给一条 special retry 窗口 | `MAX_SESSION_NOT_FOUND_RETRIES` |
| `WebSocketTransport` | 当前 transport session 是否已 expired / reaped，应立即 closed | `PERMANENT_CLOSE_CODES` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `4001` 在任何 transport 里都该可重试 | `WebSocketTransport` 当前把它放进 permanent close family |
| `4001` 在任何 transport 里都该直接 stop | `SessionsWebSocket` 当前把它 special-handle 为 compaction stale-window exception |
| 同一个 code 共享同一个协议真义，只是 retry policy 不同 | 当前解释它的是不同组件、不同资源对象、不同恢复主权 |
| 最后都 `onClose` 就说明终止语义一致 | close sink 一致，不等于 contract reason 一致 |
| “session not found” 这四个词已经足够解释行为差异 | 还要看当前组件把它放进哪个 contract bucket |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `SessionsWebSocket` 当前把 `4001` 单独 special-handle；`WebSocketTransport` 当前把 `4001` 放进 permanent close family；因此 “4001 是否可重试” 当前是组件语义，不是全局固定真义 |
| 条件公开 | `SessionsWebSocket 4001` 建立在 compaction stale window 上；`WebSocketTransport 4001` 的 permanent close 还受 `headersRefreshed` / `autoReconnect` 等路径条件影响 |
| 内部/灰度层 | retry 次数常量、sleep detection、budget reset、当前 permanent code 列表 |

## 4. 五个检查问题

- 我现在写的是 `SessionsWebSocket 4001`，还是 `WebSocketTransport 4001`？
- 我是不是把同一个 code 错写成了同一个合同？
- 我是不是把 compaction stale window 外推成了全局 `4001` 规律？
- 我是不是只看了最终 `onClose`，就断言终止语义相同？
- 我是不是把当前实现常量写成了稳定产品合同？

## 5. 源码锚点

- `claude-code-source-code/src/remote/SessionsWebSocket.ts`
- `claude-code-source-code/src/cli/transports/WebSocketTransport.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/services/compact/compact.ts`
