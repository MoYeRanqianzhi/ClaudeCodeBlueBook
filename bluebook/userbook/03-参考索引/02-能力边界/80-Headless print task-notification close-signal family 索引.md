# Headless print task-notification close-signal family 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/91-<status>、statusless ping、emitTaskTerminatedSdk、enqueuePendingNotification 与 double-emit：为什么 headless print 的 task-notification 不是同一种关单信号.md`
- `05-控制面深挖/90-task-notification、<task-id>、<status>、emitTaskTerminatedSdk、enqueuePendingNotification 与 fall through to ask：为什么 headless print 的 task-notification 不是普通进度提示.md`

边界先说清：

- 这页不是 task runtime 全图。
- 这页不替代 90 对 dual-consumer envelope 的拆分。
- 这页只抓 terminal XML、statusless ping、direct SDK close 三种 close-signal family。

## 1. 五个关键对象总表

| 对象 | 作用 | 更接近什么 |
| --- | --- | --- |
| 带 `<status>` 的 XML notification | 可被 `print.ts` 解析成 SDK close | terminal XML close |
| statusless `task-notification` | 提示进展/阻塞，不关单 | progress / stall ping |
| `emitTaskTerminatedSdk(...)` | 不走 XML queue 时直接关单 | direct SDK close |
| suppress / `notified:true` 路径 | 解释为什么某些终态不再发 XML | close-path selector |
| anti-double-emit 注释 | 约束 close 只能走一条路 | close-signal invariant |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 所有 `task-notification` 都在表达“任务结束” | statusless ping 不是 close |
| 只要有 XML，SDK consumer 就会关单 | 只有带 `<status>` 的 terminal XML 才会触发 close |
| direct `emitTaskTerminatedSdk(...)` 是 XML close 的补发版 | 它负责“不走 XML close”的终态路径 |
| 双发更保险 | close signal 双发会污染 SDK 状态机 |
| 90 已经讲完 `task-notification` 了 | 90 讲双重消费者；这页讲 close-signal family |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | terminal XML、statusless ping、direct SDK close 不是同一种信号；close 只能走一条负责路径；statusless ping 不会给 SDK consumer 关任务 |
| 条件公开 | 是否带 `<status>`、是否 suppress XML、是否 pre-set `notified:true` 会改变终态信号的走法 |
| 内部/实现层 | 具体任务实现怎样构造 ping / close；状态归一化；branch 级别的 suppress 细节 |

## 4. 六个检查问题

- 这里讨论的是 envelope 被谁消费，还是哪种信号真的关单？
- 这条 `task-notification` 带 `<status>` 吗？
- 这条终态为什么不走 XML，而改走 direct SDK emit？
- 这里的 statusless 提示是在表达阻塞，还是在表达完成？
- 我是不是把 anti-double-emit 写成了“多发更稳”？
- 我是不是把 close-signal family 写成了 generic completion notification？

## 5. 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/tasks/LocalShellTask/LocalShellTask.tsx`
- `claude-code-source-code/src/utils/sdkEventQueue.ts`
- `claude-code-source-code/src/tasks/stopTask.ts`
- `claude-code-source-code/src/utils/swarm/inProcessRunner.ts`
