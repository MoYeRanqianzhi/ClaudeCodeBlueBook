# `Bridge Banner`、`QR`、`footer`、`session count` 与 `session list`：为什么 standalone remote-control 的 banner、状态行与会话列表不是同一种显示面

## 用户目标

不是只知道 Claude Code 的 standalone `claude remote-control` 会显示：

- `Connecting`
- `Ready`
- `Connected`
- `Reconnecting`
- `Remote Control Failed`
- `Capacity: x/y`
- QR 码
- `space to show QR code`
- `w to toggle spawn mode`
- 多条 session title / activity

而是先分清六类不同对象：

- 哪些是在 host 启动时打印的一次性 banner 事实。
- 哪些是在 host 生命周期中持续刷新的状态行。
- 哪些是在多会话宿主里显示的 session budget / mode line。
- 哪些是在多会话宿主里显示的 per-session 列表。
- 哪些是在 idle / attached 状态下承载下一步动作的 footer 与 QR。
- 哪些只是显示层交互提示，而不是状态本身。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“连接状态”：

- `Remote Control` banner
- `Connecting` spinner
- `Ready` / `Connected`
- `Capacity: 0/32`
- session bullet list
- QR 码和 footer 链接
- `space` / `w` hint

## 第一性原理

standalone remote-control 的显示面至少沿着四条轴线分化：

1. `Display Plane`：当前显示的是启动事实、宿主状态、会话预算、会话列表，还是动作提示。
2. `State Ownership`：这行信息属于整个 host、某一条附着 session，还是未来新会话的分配政策。
3. `Topology Projection`：single-session 与 multi-session 会把同一组底层状态投影成不同的显示面。
4. `Action Surface`：当前显示是在告诉你系统是什么状态，还是在提示你下一步可以按什么键、打开什么链接。

因此更稳的提问不是：

- “为什么这个 remote-control 界面显示这么多状态？”

而是：

- “这行内容到底在描述 host 事实、当前生命周期、session budget、某条 session，还是下一步动作；它是被 single-session 还是 multi-session 投影成现在这样？”

只要这四条轴线没先拆开，正文就会把 banner、状态行、QR、session list 与 hint 写成同一种显示面。

## 第一层：`printBanner` 打印的是启动事实，不是实时状态

### banner 先告诉你这台 host 是谁，不告诉你它现在连上了没有

`bridgeUI.ts` 的 `printBanner()` 启动时会打印：

- `Remote Control v...`
- `Spawn mode: ...`
- `Max concurrent sessions: ...`
- `Environment ID: ...`
- `Sandbox: Enabled`

然后才进入：

- connecting spinner

这说明 banner 回答的问题不是：

- 当前 bridge 是否已 attached

而是：

- 这台 standalone host 以什么配置启动

### 因而 banner 应被理解为 bootstrap fact surface

更稳的理解应是：

- banner = host facts
- 不是 lifecycle state

只要这一层没拆开，正文就会把：

- `Spawn mode: worktree`
- `Connected`

误写成同一种状态信息。

## 第二层：`Connecting`、`Ready`、`Connected`、`Reconnecting`、`Failed` 才是生命周期状态面

### `Connecting` 是启动前的 spinner surface

`bridgeUI.ts` 先渲染：

- `Connecting`

直到第一次 `updateIdleStatus()` 才停掉 spinner。

这说明：

- banner 已经出现
- 但 lifecycle 仍在 connecting

### `Ready` 与 `Connected` 也不是同一层

`updateIdleStatus()` 会把状态切成：

- `Ready`

并把：

- `activeSessionUrl = null`
- QR 切回 `connectUrl`

而 `setAttached()` 会把状态切成：

- `Connected`

并在 single-session 情况下把 QR 切向：

- `sessionUrl`

这说明：

- `Ready` 描述的是 host idle、可接新会话
- `Connected` 描述的是已有 session attached

### `Reconnecting` 与 `Failed` 又是独立的 failure-state surface

`updateReconnectingStatus()` 与 `updateFailedStatus()` 不是走普通 `renderStatusLine()` 流，而是单独清屏重绘。

这意味着：

- reconnecting / failed 不是普通 idle/attached 行上的一个标签
- 它们是单独的错误 / 恢复中显示面

## 第三层：`session count` 和 `mode line` 在 single-session 与 multi-session 下不是同一套投影

### multi-session 下显示的是 session budget + per-session list

`renderStatusLine()` 在 `sessionMax > 1` 时会显示：

- `Capacity: active/max`
- 当前 `spawnMode` 对 future sessions 的 mode hint
- 每条 session 的 title / activity bullet

这说明多会话宿主最重要的显示对象是：

- host 还有多少 slot
- 当前挂着哪些 session

### single-session 下则显示为 mode line + 短暂 tool activity

当 `sessionMax === 1` 时，界面不显示多条 bullet list，而是显示：

- `Single session · exits when complete`

或容量 1 的 mode line，再加一条：

- tool activity line

这说明 single-session 的显示面更像：

- 当前唯一会话的宿主状态

而不是：

- session fleet dashboard

### 所以 `Capacity: 1/1` 与 `Capacity: 7/32` 不是同一种显示语义

更稳的区分是：

- single-session：mode line 辅助解释 host lifecycle
- multi-session：session budget + fleet list

只要这一层没拆开，正文就会把：

- one-session host
- multi-session host

误写成只是数字不同。

## 第四层：`session list` 不是状态行的延长，而是多会话宿主的对象列表

### 每条 session 先以 URL 注册，再逐步补 title / activity

`bridgeMain.ts` 在会话启动时会先：

- `logger.addSession(...)`
- `logger.setAttached(...)`

然后异步：

- `fetchSessionTitle(...)`
- `logger.setSessionTitle(...)`

这说明 bullet list 里的每条项目并不是一次性生成的静态文本，而是：

- 先有 remote session 链接
- 再补上 title
- 再持续刷 activity

### 因而 `Attached` 只是列表项的临时占位，不是最终对象名

`bridgeUI.ts` 对没有 title 的项会先显示：

- `Attached`

有 title 后再替换成截断后的真实标题。

因此更稳的理解是：

- session list 展示的是 session object projection
- 状态行展示的是 host lifecycle projection

这两张面不应再被写成同一层“连接状态”。

## 第五层：`QR` 与 `footer` 承载的是下一步动作，不是状态词的重复

### idle 与 attached 的 footer 文案不同，说明它们在引导不同动作

`bridgeStatusUtil.ts` 明确区分：

- idle footer: `Code everywhere with the Claude app or ...`
- active footer: `Continue coding in the Claude app or ...`

这说明 footer 回答的问题不是：

- 系统现在是不是 connected

而是：

- 用户下一步该用哪条链接继续工作

### QR 也随着 host/topology 改变其目标对象

`bridgeUI.ts` 里：

- idle 时 QR 指向 `connectUrl`
- single-session attached 时 QR 指向 `sessionUrl`
- multi-session 则故意保留 environment connect URL

因此 QR 承载的不是纯状态词，而是：

- 下一跳 action target

这也是为什么第 26 页讲链接对象，而本页讲显示面对象。

## 第六层：`space` / `w` hint 是动作提示，不是状态本体

### `space` hint 只告诉你 QR 是否可切换

`renderStatusLine()` 在 footer 下显示：

- `space to show QR code`

或：

- `space to hide QR code`

这说明它不在描述：

- host 的 lifecycle state

而是在描述：

- 当前显示层还有什么交互动作

### `w` hint 只在 `spawnModeDisplay` 存在时才出现

`bridgeUI.ts` 只有在：

- `spawnModeDisplay` 非空

时才显示：

- `w to toggle spawn mode`

这进一步说明：

- hint surface 依赖 host 是否允许某种交互
- 它不是“Connected”状态的一部分

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| banner = 当前连接状态 | banner 是启动事实面 |
| `Ready` = `Connected` 只是文字不同 | 一个是 idle host，一个是 attached session |
| `Capacity: 1/1` = 多会话预算缩小版 | single-session 是不同的 host 投影 |
| session list = 状态行下半部分 | 它是多会话对象列表 |
| QR / footer = 状态词重复展示 | 它们承载的是下一步动作目标 |
| `space` / `w` = 状态本身 | 它们只是显示层交互提示 |

## stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | banner、Connecting/Ready/Connected/Reconnecting/Failed、session count、session list、QR、footer、`space` / `w` hint |
| 条件公开 | `w` hint 只在可切换时出现、single vs multi-session 不同投影、title 的异步补齐 |
| 内部/实现层 | shimmer / visual line 计数、OSC8 hyperlink 包装、debug log 行、status ticker 更新细节 |

## 源码锚点

- `claude-code-source-code/src/bridge/bridgeUI.ts`
- `claude-code-source-code/src/bridge/bridgeStatusUtil.ts`
- `claude-code-source-code/src/bridge/bridgeMain.ts`
