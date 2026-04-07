# `PERMANENT_CLOSE_CODES`、`4001` 与 reconnect budget 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/126-PERMANENT_CLOSE_CODES、4001 与 reconnect budget：为什么 terminality policy 不是同一种 stop rule.md`
- `05-控制面深挖/125-handleClose、scheduleReconnect、reconnect()、onReconnecting 与 onClose：为什么 transport recovery action-state contract 不是同一种状态.md`

边界先说清：

- 这页不是 reconnect path 页。
- 这页不替代 125。
- 这页只抓 terminality bucket 为什么不是同一种 stop rule。

## 1. 三种 terminality bucket

| bucket | 当前回答什么 | 典型位置 |
| --- | --- | --- |
| permanent rejection | 这类 close 是否应立即停止 reconnect | `PERMANENT_CLOSE_CODES` |
| stale exception | `4001` 是否作为 compaction-aware special case 重试 | `MAX_SESSION_NOT_FOUND_RETRIES` |
| ordinary transient retry | 已连通过的普通掉线还要不要继续回连 | `MAX_RECONNECT_ATTEMPTS` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `4001` 就是预算更小的普通 reconnect | 它是 compaction-aware stale exception |
| `4003` 只是 budget 为 0 的 reconnect | 它属于 permanent server-side rejection |
| 所有 close 都能套普通 reconnect budget | 还要求 `previousState === 'connected'` |
| 统一落到 `onClose` 就说明终止原因相同 | terminal sink 统一，不等于 terminal reason 统一 |
| “session not found 可重试” 就够了 | 当前这个可重试建立在 compaction 语境上 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | permanent close code 当前会立即 stop reconnecting；`4001` 当前被单独 special-handle；ordinary transient close 当前走另一张 budget；`onClose` 是 terminal sink 但不自带 terminal reason |
| 条件公开 | `4001` 特判建立在 compaction stale window 语境上；ordinary reconnect 只有 previous state 真是 connected 时才启用 |
| 内部/灰度层 | retry 次数常量、delay 常量、当前 permanent code 列表 |

## 4. 五个检查问题

- 我现在写的是 permanent rejection、stale exception，还是 ordinary transient retry？
- 我是不是把 `4001` 写成了普通 reconnect 的小预算版本？
- 我是不是把 `onClose` 的统一出口写成了统一原因？
- 我是不是把 previousState 条件漏掉了？
- 我是不是把当前常量写成了稳定产品语义？

## 5. 源码锚点

- `claude-code-source-code/src/remote/SessionsWebSocket.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
