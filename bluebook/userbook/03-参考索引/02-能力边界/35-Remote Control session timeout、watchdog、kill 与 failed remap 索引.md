# Remote Control `session timeout`、watchdog、kill 与 `failed remap` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/46-session timeout、watchdog、SIGTERM、SIGKILL 与 failed remap：为什么 bridge 的会话超时、收尾中断与请求 timeout 不是同一种 timeout.md`
- `05-控制面深挖/42-register、poll、ack、heartbeat、stop、archive 与 deregister：为什么 standalone remote-control 的环境、work 与 session 生命周期不是同一种收口.md`

## 1. 六类 timeout / kill 对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Session Runtime Limit` | 单条 session 最多能跑多久 | `sessionTimeoutMs` |
| `Timeout Watchdog` | 超时后先怎样记账再发信号 | `timedOutSessions`、`onSessionTimeout` |
| `Raw Process Status` | child 原始是 interrupted / failed / completed 吗 | `SessionDoneStatus` |
| `Bridge Remap` | bridge 要不要把 raw interrupted 改写成 failed | timeout failed remap |
| `Graceful Shutdown Kill` | 关桥时先怎样协商式终止 | `handle.kill()` |
| `Forced Shutdown Kill` | grace window 结束后怎样强杀 | `handle.forceKill()` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `sessionTimeoutMs` = shutdownGraceMs | 一个是运行上限，一个是关桥等待窗口 |
| timeout 到了 = 直接 `failed` | watchdog 先记 timeout，再发 `SIGTERM`，最终 bridge remap |
| raw `interrupted` = 最终 interrupted | timeout-killed session 会被 remap 成 `failed` |
| `kill()` = `forceKill()` | 一个是 `SIGTERM`，一个是 grace 后 `SIGKILL` |
| request timeout = session timeout | 一个是请求预算，一个是会话命运 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `--session-timeout`、超时失败、shutdown graceful kill + force kill |
| 条件公开 | `timedOutSessions` remap、`shutdownGraceMs` |
| 内部/实现层 | signal 发送细节、Windows 分支、各类 HTTP timeout 常量 |

## 4. 六个高价值判断问题

- 当前 timeout 打在 session、shutdown，还是请求预算上？
- 现在发的是 `SIGTERM` 还是 `SIGKILL`？
- 我看到的是 raw status，还是 bridge remap 后的状态？
- 这是运行过久，还是关桥收尾？
- 我是不是又把 request timeout 混进会话 timeout？
- 我是不是又把 raw `interrupted` 当成最终结论？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/types.ts`
- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/sessionRunner.ts`
