# `session timeout`、watchdog、`SIGTERM`、`SIGKILL` 与 `failed remap`：为什么 bridge 的会话超时、收尾中断与请求 timeout 不是同一种 timeout

## 用户目标

不是只知道 standalone `claude remote-control` 里“session 太久会超时、退出 bridge 时也会 kill child、源码里还有各种 timeout”，而是先分清六类不同对象：

- 哪些是在给单条 session 设定最大运行时长。
- 哪些是在超时后主动把 session 标成 timed-out 再送 `SIGTERM`。
- 哪些只是 child 进程自己回报的原始 `interrupted` / `failed` / `completed` 结果。
- 哪些是在关桥时给所有 active session 的 graceful shutdown 宽限期。
- 哪些是在宽限期后做的 `SIGKILL` 强杀。
- 哪些虽然也叫 timeout，但其实只是 HTTP / archive / connect 请求预算，不属于这条会话级语义。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“bridge 超时”：

- `sessionTimeoutMs`
- per-session timeout watchdog
- `timedOutSessions`
- raw `interrupted`
- `failed`
- `handle.kill()`
- `handle.forceKill()`
- `shutdownGraceMs`
- HTTP timeout

## 第一性原理

bridge 的 timeout 至少沿着四条轴线分化：

1. `Target Object`：当前超时打在单条 session、整个 bridge shutdown，还是某个 HTTP 请求上。
2. `Timeout Meaning`：当前是在宣告“这条 session 跑太久了”，还是“给优雅退出一个等待窗口”，还是“请求预算到了”。
3. `Process Signal`：当前发的是 `SIGTERM` 这种可协商中断，还是 `SIGKILL` 这种强制终止。
4. `Status Mapping`：当前是沿用 child 原始退出状态，还是把原始 `interrupted` 重映射成更符合用户心智的 `failed`。

因此更稳的提问不是：

- “bridge 的 timeout 不就是超时然后 kill 吗？”

而是：

- “这次 timeout 打在 session、shutdown，还是请求；它是先给协商中断，还是直接强杀；最后用户看到的状态又是不是 child 原样上报的？”

只要这四条轴线没先拆开，正文就会把 session timeout、graceful shutdown 和 request timeout 写成同一种 timeout。

## 第一层：`sessionTimeoutMs` 是单条 session 的最大运行时长，不是 bridge 退出预算

### 它是 bridge config 里的 per-session watchdog 上限

`types.ts` 对 `sessionTimeoutMs` 的注释写得很清楚：

- `Per-session timeout in milliseconds. Sessions exceeding this are killed.`

`bridgeMain.ts` 也会从 CLI 解析：

- `--session-timeout`

并在每条 session spawn 后：

- 读取 `config.sessionTimeoutMs ?? DEFAULT_SESSION_TIMEOUT_MS`
- 启动 per-session timer

这说明它回答的问题不是：

- 关桥时要等子进程多久

而是：

- 单条 session 最多允许跑多久

### 所以它和 shutdown grace 不是一层对象

更准确的区分是：

- `sessionTimeoutMs`：运行态上限
- `shutdownGraceMs`：关桥时等待子进程自行退出的窗口

只要这一层没拆开，正文就会把“session 太久”和“退出 bridge 等一会儿”写成同一种 timeout。

## 第二层：timeout watchdog 的动作是“先记 timeout，再发 `SIGTERM`”，不是直接给出 `failed`

### watchdog 本身先记录 timeout，再走 `handle.kill()`

`bridgeMain.ts` 的 `onSessionTimeout(...)` 里会：

- 打 timeout 日志
- 记录 `tengu_bridge_session_timeout`
- `logger.logSessionFailed(...)`
- `timedOutSessions.add(sessionId)`
- `handle.kill()`

这说明 watchdog 回答的问题不是：

- 直接把 child 进程的最终状态改成 `failed`

而是：

- 先把“这条 session 是因为 timeout 被终止”这件事记下来
- 再走一次协商式终止

### 所以 timeout watchdog 与 child final status 之间还有一层映射

更稳的理解应是：

- timeout watchdog 先设置“解释框架”
- child 最终 close 事件再提供原始退出信号 / code

只要这一层没拆开，正文就会把 timeout 处理误写成：

- timer 一到，状态立刻就是 `failed`

## 第三层：child 原始 `interrupted` 不总等于用户最终看到的 `interrupted`

### `sessionRunner.ts` 里，`SIGTERM` / `SIGINT` 原始上报的是 `interrupted`

`sessionRunner.ts` 对 child `close` 事件的映射非常直接：

- `SIGTERM` / `SIGINT` -> `interrupted`
- `exit code 0` -> `completed`
- 其他非零 code -> `failed`

这说明 child 只报告：

- 它是被信号打断了，还是自己失败退出了

并不理解：

- 这次 `SIGTERM` 到底是用户断开、bridge shutdown，还是 timeout watchdog 触发的

### `bridgeMain.ts` 里才把 timeout-killed session 的 `interrupted` remap 成 `failed`

`onSessionDone(...)` 会检查：

- `const wasTimedOut = timedOutSessions.delete(sessionId)`

并在：

- `wasTimedOut && rawStatus === 'interrupted'`

时，把最终 `status` 改成：

- `failed`

这说明 bridge 主线程在做的，是：

- 用户语义层的状态重解释

而不是：

- child 原始结果透传

### 所以 raw `interrupted`、timeout-failed remap 与 shutdown interrupt 不是同一回事

更准确的区分是：

- raw `interrupted`：进程层事实
- timeout remap 后的 `failed`：bridge 层为了表达“超时失败”而做的用户语义映射

只要这一层没拆开，正文就会把：

- `SIGTERM`
- `interrupted`
- timeout failure

压成同一种状态。

## 第四层：graceful shutdown 里的 `kill()` 与 watchdog 的 `kill()` 看起来一样，但语义不同

### 二者都先发 `SIGTERM`，但触发原因不同

`sessionRunner.ts` 的 `handle.kill()` 都是：

- 给 child 发 `SIGTERM`（Windows 上用默认 kill）

但 `bridgeMain.ts` 里有两条不同入口：

- timeout watchdog 调 `handle.kill()`
- bridge shutdown 调 `handle.kill()`

这说明单看 signal 本身，并不能分辨：

- 这是 session 跑太久
- 还是 bridge 正在整体收尾

### 正因如此，bridge 才需要 `timedOutSessions` 这层旁账来做语义纠偏

更稳的理解应是：

- process signal 相同
- 但上层语义不同
- 所以 bridge 需要额外状态来修正最终解释

## 第五层：`SIGKILL` 只属于 shutdown 宽限期后的强杀，不属于普通 session timeout 的第一动作

### shutdown 路径会先等待，再 `forceKill()`

`bridgeMain.ts` 在 graceful shutdown 里会：

- 对 active sessions 先 `handle.kill()`
- `Promise.race([...done, sleep(shutdownGraceMs)])`
- 超过宽限期还没结束的，再 `handle.forceKill()`

### `forceKill()` 在 `sessionRunner.ts` 里明确对应 `SIGKILL`

`sessionRunner.ts` 的 `forceKill()`：

- 使用独立 `sigkillSent` 标记
- 非 Windows 下发 `SIGKILL`

这说明强杀回答的问题不是：

- 这条 session 正常 timeout 了没有

而是：

- bridge 正在收尾，但某些 child 不愿意在 grace window 内自行退出

### 所以 `SIGTERM` timeout path 与 `SIGKILL` shutdown path 不是同一条 kill 语义

更准确的区分是：

- session timeout：先记 timeout，再发 `SIGTERM`
- shutdown stuck child：先给 grace window，再发 `SIGKILL`

只要这一层没拆开，正文就会把所有 kill 都写成一种“超时后强杀”。

## 第六层：request timeout 不是 session timeout，最多只能作为旁边界

### HTTP / archive / connect timeout 属于请求预算，不属于会话命运

源码里当然存在很多：

- axios timeout
- archive timeout
- connect timeout

但这些回答的问题是：

- 某个 API call / connect phase 最多等多久

而不是：

- 单条 session 是否因运行过久而被定性为 timeout failure

### 所以 userbook 正文不应把整套 timeout taxonomy 混成一页

更稳的处理方式应是：

- 这页只写 session timeout / shutdown kill / failed remap
- 其他 request timeout 留在条件/内部层，必要时只用一句话提醒“不是同一种 timeout”

## 第七层：稳定、条件与内部三层要分开保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `--session-timeout`、session 超时会被明确记成失败、shutdown 有 graceful kill 再 force kill |
| 条件公开 | `timedOutSessions` 的 failed remap、`shutdownGraceMs` 的宽限语义 |
| 内部/实现层 | `SIGTERM` / `SIGKILL` 发送细节、Windows 分支、request timeout 常量 |

这里尤其要避免两种写坏方式：

- 把所有 timeout 都写成一页“超时参数大全”
- 把 child 原始状态直接当作用户最终看到的 bridge 状态

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `sessionTimeoutMs` = shutdownGraceMs | 一个是运行上限，一个是关桥时等待窗口 |
| timeout 到了 = 直接 `failed` | watchdog 先记 timeout，再发 `SIGTERM`，最终由 bridge remap |
| raw `interrupted` = 用户最终看到的 interrupted | timeout-killed session 会被 remap 成 `failed` |
| `kill()` 与 `forceKill()` 只是不同平台写法 | 一个对应协商式终止，一个对应 shutdown 后的强杀 |
| connect / HTTP timeout = session timeout | 那些是请求预算，不是单条 session 命运 |
| bridge 退出时的 `SIGTERM` = session timeout 的 `SIGTERM` | signal 相同，但上层语义不同 |

## 六个高价值判断问题

- 当前 timeout 打在 session、shutdown，还是请求预算上？
- 现在发的是 `SIGTERM` 还是 `SIGKILL`？
- 我看到的是 child 原始状态，还是 bridge remap 之后的用户状态？
- 这是运行过久，还是关桥收尾时的 graceful kill？
- 我是不是又把 request timeout 混进会话 timeout 正文了？
- 我是不是又把 raw `interrupted` 直接当成最终结论？

## 源码锚点

- `claude-code-source-code/src/bridge/types.ts`
- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/sessionRunner.ts`
