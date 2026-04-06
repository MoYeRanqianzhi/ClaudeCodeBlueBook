# Headless print queue re-entry and single-consumer pump 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/88-running、peek(isMainThread)、drainCommandQueue、setOnEnqueue、cron onFire 与 post-finally recheck：为什么 headless print 的 queue re-entry 不是普通事件订阅器.md`
- `05-控制面深挖/87-readUnreadMessages、markMessagesAsRead、enqueue、run、hasActiveInProcessTeammates 与 POLL_INTERVAL_MS：为什么 headless print 的 active teammate polling 不是被动 inbox reader.md`

边界先说清：

- 这页不是 headless print mailbox loop 总论。
- 这页不替代 87 对 active teammate polling / unread ingestion 的拆分。
- 这页只抓 `enqueue -> run -> finally -> peek recheck` 这一层的 single-consumer pump 语义。

## 1. 五个关键对象总表

| 对象 | 作用 | 更接近什么 |
| --- | --- | --- |
| `running` | 单消费者互斥 | run mutex |
| `drainCommandQueue()` | 实际 drain 主线程队列 | single consumer |
| `setOnEnqueue` / cron `onFire` / orphaned callback | 外部 kick `run()` | explicit re-entry trigger |
| `subscribeToCommandQueue()` in `print.ts` | 只观察 `'now'` priority interrupt，不负责 idle drain | interrupt observer |
| post-finally `peek(isMainThread)` | 防 stranded queue item | race repair |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `enqueue(...)` 之后自然会有人处理 | 这里没有像 REPL 那样负责 idle drain 的 subscriber |
| `running` 只是忙闲状态 | 它首先是单消费者互斥锁 |
| finally 后再 `peek(...)` 只是优化 | 它是在修 stranded queue race |
| UDS / cron / orphaned callback 是三套完全不同的 queue 语义 | 它们都复用 `enqueue + run()` 这一显式再入模式 |
| `print.ts` 里也有 `subscribeToCommandQueue()`，所以它和 REPL 一样 | `print.ts` 的订阅只服务 `'now'` 中断；REPL 的 `useQueueProcessor()` 才负责 idle drain |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | headless `print` 的主线程队列是显式再入驱动的 single-consumer pump，没有像 REPL 那样的 idle-drain subscriber；`running` 保护单消费者；post-finally `peek(...)` 是关键补偿 |
| 条件公开 | UDS / cron / orphaned callback 各自有不同 trigger 条件；并非每个 enqueue 来源都会立刻 `run()`；`waitingForAgents`、proactive tick、`!inputClosed` 等门槛会改变何时 kick `run()` |
| 内部/实现层 | `runPhase`、batching helper、flush/drain 顺序、predicate 细节、`'now'` interrupt observer、具体 queue source wiring |

## 4. 六个检查问题

- 这里的外部来源是在 enqueue，还是在真正 drain？
- `run()` 是被动订阅触发，还是被显式 kick？
- `running` 保护的是 UI 忙闲，还是 consumer 互斥？
- 这里看到的 subscriber，是负责中断，还是负责 idle drain？
- 这次 `peek(isMainThread)` 是读取业务状态，还是修 race？
- 这里讨论的是 87 的 mailbox ingestion，还是 88 的 queue pump？
- 我是不是把 explicit re-entry 写成 passive subscription 了？

## 5. 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/utils/messageQueueManager.ts`
- `claude-code-source-code/src/hooks/useQueueProcessor.ts`
- `claude-code-source-code/src/utils/queueProcessor.ts`
