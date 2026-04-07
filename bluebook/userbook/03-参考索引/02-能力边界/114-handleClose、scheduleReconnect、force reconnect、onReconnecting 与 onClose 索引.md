# `handleClose`、`scheduleReconnect`、force reconnect、`onReconnecting` 与 `onClose` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/125-handleClose、scheduleReconnect、reconnect()、onReconnecting 与 onClose：为什么 transport recovery action-state contract 不是同一种状态.md`
- `05-控制面深挖/122-timeout watchdog、reconnect warning、reconnecting 与 disconnected：为什么 remote session 的 recovery lifecycle 不是同一种状态.md`
- `05-控制面深挖/124-warning、连接态、force reconnect 与 viewerOnly：为什么 recovery signer 不是同一种恢复证明.md`

边界先说清：

- 这页不是 signer 页。
- 这页不替代 124。
- 这页不替代 122 的 lifecycle 语义页。
- 这页只抓 transport 层哪条 path 会发 `onReconnecting`，哪条会发 `onClose`，哪条只是 force reconnect action。

## 1. 五条 transport edge

| edge | 当前回答什么 | 典型位置 |
| --- | --- | --- |
| raw close handling | close event 进入后如何分类 | `handleClose(closeCode)` |
| close-driven reconnect | 是否进入 backoff reconnect | `scheduleReconnect(...)` |
| force reconnect action | 是否主动执行 repair reconnect | `reconnect()` |
| reconnecting projection | 共享状态何时进入 reconnecting | `onReconnecting` |
| terminal close projection | 共享状态何时进入 disconnected | `onClose` / `onDisconnected` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `reconnect()` 就等于 `onReconnecting()` | force reconnect 和 scheduleReconnect 不是同一路径 |
| socket close 了就一定会先 reconnecting | `handleClose(...)` 可能直接 `onClose` |
| `onClose` 只是 “reconnect 最后失败” | 永久 close code 或某些 non-connected close 也会直接走它 |
| timeout warning 后 UI 一定先显示 `Reconnecting…` | 当前实现不保证 force reconnect 会自然投成 `onReconnecting` |
| `disconnected` 是 reconnect action 的最后一步 | 它是 terminal close projection，不是 action 本身 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `onReconnecting` 属于 close-driven backoff；`onClose` 属于 terminal close；manager 把二者映射成 `onReconnecting` / `onDisconnected`；hook 再把它们投成共享状态面 |
| 条件公开 | `4001` 有单独 retry budget；普通 transient close 还要求 `previousState === 'connected'`；timeout warning 走 force reconnect，但当前实现不保证自然投成 `reconnecting` |
| 内部/灰度层 | retry 次数、delay 常量、500ms force reconnect、`handleClose(...)` early-return 顺序 |

## 4. 五个检查问题

- 我现在写的是 close-driven backoff，还是 force reconnect？
- 我是不是把 `onReconnecting` 当成所有 reconnect 的通用事件？
- 我是不是把 `onClose` 写成了所有 close 的直译？
- 我是不是把 timeout warning 后的 UI 变化写成了必然？
- 我是不是又把 signer 视角和 transport 视角混回去了？

## 5. 源码锚点

- `claude-code-source-code/src/remote/SessionsWebSocket.ts`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
