# Headless print active teammate polling and unread mailbox loop 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/87-readUnreadMessages、markMessagesAsRead、enqueue、run、hasActiveInProcessTeammates 与 POLL_INTERVAL_MS：为什么 headless print 的 active teammate polling 不是被动 inbox reader.md`
- `05-控制面深挖/86-SHUTDOWN_TEAM_PROMPT、inputClosed、hasWorkingInProcessTeammates、waitForTeammatesToBecomeIdle 与 hasActiveInProcessTeammates：为什么 headless print 的 team drain 不是 interactive REPL 的直接缩小版.md`

边界先说清：

- 这页不是 headless print team drain 总论。
- 这页不替代 84 对 host-path 的比较，也不替代 86 对 inputClosed/team drain 的拆分。
- 这页只抓 headless `print` 在 active teammates 存在时如何持续轮询 unread mailbox 并把它折返进主 run loop。

## 1. 四步 loop 总表

| 步骤 | 判定/动作 | 语义 |
| --- | --- | --- |
| 1 | 判断 `hasActiveTeammates` | 只要 swarm 还活着，就继续 loop |
| 2 | `readUnreadMessages(...)` | 吸收新的 teammate 输出 |
| 3 | `markMessagesAsRead(...)` + `enqueue(...); run()` | 把 unread 并回主 run loop |
| 4 | 无 unread 时 `sleep(POLL_INTERVAL_MS)` | 维持活性，等待下一波输出 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 没有 unread，这条 loop 就该停 | 它的停止条件是 no active teammates |
| print 里 mark-read 的时机和 interactive poller 一样保守 | 这里是 immediate-read + enqueue/run |
| headless 也有同样的 `pending/processed` inbox 生命周期 | 那是 interactive poller / attachment bridge 的协议 |
| 这条 loop 只是被动收信 | 它在维持 active swarm runtime 的 ingestion loop |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | headless print 的 teammate mailbox loop 围绕 active teammates 持续运转，而不是围绕 unread 数量；unread 会被直接折返进主 run loop；这条逻辑不是 interactive poller 的直接缩小版 |
| 条件公开 | 只有 leader + swarm + active teammates 时才有意义；shutdown-approved cleanup 仍会在这条 loop 中触发；当前 run-loop 再入时机与 active teammate 数量会影响表现 |
| 内部/实现层 | 500ms 轮询间隔、peek/run 再入保护、immediate mark-read 的具体时机、XML wrapper 拼装细节 |

## 4. 六个检查问题

- 这里的持续条件是 unread，还是 active teammates？
- unread 是被缓冲进本地 inbox，还是直接折返进主 run loop？
- 这里 mark-read 发生在交付前，还是交付后？
- 这里是被动 inbox reader，还是 active swarm ingestion loop？
- 这条 loop 讲的是 86 的 team drain，还是更细的 unread absorption？
- 我是不是把 host path / drain path / polling path 混成一条了？

## 5. 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/hooks/useInboxPoller.ts`
- `claude-code-source-code/src/utils/teammate.ts`
