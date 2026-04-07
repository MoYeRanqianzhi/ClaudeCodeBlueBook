# watchdog、warning、reconnecting 与 disconnected 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/122-timeout watchdog、reconnect warning、reconnecting 与 disconnected：为什么 remote session 的 recovery lifecycle 不是同一种状态.md`
- `05-控制面深挖/119-sendMessage、onPermissionRequest、onAllow、result、cancelRequest 与 onDisconnected：为什么 direct connect 的 setIsLoading(true_false) 不是同一种 loading lifecycle.md`
- `05-控制面深挖/121-useAssistantHistory、fetchLatestEvents(anchor_to_latest)、pageToMessages、useRemoteSession onInit 与 handleRemoteInit：为什么 history init banner 回放与 live slash 恢复不是同一种 attach 恢复语义.md`

边界先说清：

- 这页不是 remote session 全状态机。
- 这页不替代 119 的 loading lifecycle。
- 这页不替代 121 的 attach restore semantics。
- 这页只抓 watchdog、warning、reconnect、reconnecting、disconnect 为什么不是同一种 recovery edge。

## 1. 五种 recovery edge

| edge | 当前回答什么 | 典型位置 |
| --- | --- | --- |
| watchdog armed | 是否开始观察 stuck 风险 | `setTimeout(RESPONSE_TIMEOUT_MS / COMPACTION_TIMEOUT_MS)` |
| heartbeat clear | 任意消息到达即清 watchdog | `clearTimeout(responseTimeoutRef)` |
| timeout warning | 向 transcript 写补救提示 | `createSystemMessage(...warning)` |
| recovery attempt / state | 发起 reconnect，并投影为 reconnecting | `manager.reconnect()` / `setConnStatus('reconnecting')` |
| terminal disconnect | 当前连接进入断开态并停表 | `onDisconnected()` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| warning 出现就说明已经 disconnected | warning 只是 remediation prompt |
| `manager.reconnect()` 就是 reconnecting 状态本体 | 一个是动作，一个是回调后的状态投影 |
| recovery 页本质还是 loading 页 | loading false 只是其中一个副作用，不是主语 |
| 所有 remote session 都跑同样的 watchdog | viewerOnly 当前显式跳过 timeout watchdog |
| reconnecting 和 disconnected 只是同一状态深浅不同 | 一个是中间恢复态，一个是 terminal release |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | timeout watchdog、warning、reconnect、reconnecting、disconnected 当前是分层发生的；reconnecting/disconnected 都会清局部账本 |
| 条件公开 | watchdog 只在非 viewerOnly 路径启动；compaction 时 timeout 会切到更长窗口 |
| 内部/灰度层 | reconnect 是否成功、是否再细分更多状态、未来是否把 warning/recovery 策略改成别的宿主合同 |

## 4. 五个检查问题

- 当前写的是 watchdog、warning、attempt，还是 terminal disconnect？
- 我是不是把 warning 写成了状态本体？
- 我是不是把 reconnecting 写成了最终断开？
- 我是不是把 loading false 当成这页的主角？
- 我有没有把 viewerOnly 也默认进了同样 recovery 流程？

## 5. 源码锚点

- `claude-code-source-code/src/hooks/useRemoteSession.ts`
