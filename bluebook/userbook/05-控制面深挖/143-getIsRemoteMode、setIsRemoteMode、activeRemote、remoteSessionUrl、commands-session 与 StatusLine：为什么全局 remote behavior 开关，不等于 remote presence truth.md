# `getIsRemoteMode`、`setIsRemoteMode`、`activeRemote`、`remoteSessionUrl`、`commands/session` 与 `StatusLine`：为什么全局 remote behavior 开关，不等于 remote presence truth

## 用户目标

141 已经把：

- `remoteSessionUrl`
- `remoteConnectionStatus`
- `remoteBackgroundTaskCount`

拆成了 remote-session presence ledger。

但如果继续往下不补这一页，读者还是很容易把另一层东西重新压进这张账：

- `getIsRemoteMode()`
- `setIsRemoteMode(...)`

因为从表面看，它们也会影响很多地方：

- 通知是否显示
- 状态线是否挂 remote tag
- `/session` 命令是否显隐
- footer 的 mode part 是否压掉

于是正文就会滑成一句看似合理、实际上仍然过快的话：

- “既然这么多地方都看 `getIsRemoteMode()`，那它就是系统里的 remote truth。”

这句不稳。

从当前源码看，`getIsRemoteMode()` 更像：

- 全局 remote behavior 开关

而不是：

- remote presence truth

所以这页要补的不是：

- “`getIsRemoteMode()` 有哪些用途”

而是：

- “为什么它被广泛消费，也仍然不等于 presence truth”

## 第一性原理

更稳的提问不是：

- “`getIsRemoteMode()` 不就是 remote 状态吗？”

而是先问五个更底层的问题：

1. `getIsRemoteMode()` 当前回答的是“系统如何行为”，还是“远端存在面有哪些 authoritative 字段”？
2. 当前谁在写 `setIsRemoteMode(...)`，又是谁根本不写？
3. 哪些 consumer 只需要一个远程运行环境布尔值，哪些 consumer 明确需要 `remoteSessionUrl` 这种 presence 账？
4. `activeRemote.isRemoteMode`、`getIsRemoteMode()`、`remoteSessionUrl` 是不是同一层 remote 语义？
5. 为什么同一个 `/session` 命令会出现“命令显隐看一层、pane 内容再看一层”的双重 gate？

只要这五轴先拆开，`getIsRemoteMode()` 就不会再被写成：

- “全局 remote truth”

## 第一层：`getIsRemoteMode()` 本质上只是 bootstrap 布尔位，不是一张状态账

`bootstrap/state.ts` 里的实现非常直接：

- `getIsRemoteMode()` 只是 `return STATE.isRemoteMode`
- `setIsRemoteMode(value)` 只是 `STATE.isRemoteMode = value`

这一步最关键的不是“它简单”，

而是：

- 它没有附带 URL
- 没有连接状态
- 没有后台任务计数
- 没有任何细粒度 presence 语义

也就是说它先天回答的就是：

- “当前是不是处于某种 remote 运行环境”

而不是：

- “这张 remote 存在面现在长什么样”

## 第二层：当前只有 remote-session 路径会显式写 `setIsRemoteMode(true)`，direct connect 并不会

`main.tsx` 的启动路径已经把这层边界写得很清楚。

### remote session / assistant attach

在：

- assistant attach
- `--remote` TUI

这两类路径里，代码都会显式：

- `setIsRemoteMode(true)`

### direct connect

direct connect 的启动分支则只会：

- `setDirectConnectServerUrl(...)`
- 启动 REPL

并不会：

- `setIsRemoteMode(true)`

这意味着 `getIsRemoteMode()` 当前并不是：

- “所有 remote 交互模式的总开关”

而更接近：

- “某些被系统归类为 remote-session / remote backend 语义的全局环境开关”

所以如果把 direct connect / ssh remote 也直接压进这层，

就会把：

- active remote shell

和：

- global remote behavior environment

混成一层。

## 第三层：`activeRemote.isRemoteMode` 与 `getIsRemoteMode()` 正好说明“交互 remote”与“系统 remote 环境”不是一回事

`REPL.tsx` 里三条 hook 最终会汇总成：

- `activeRemote`

它回答的是：

- 当前 turn 是否该走 remote send/cancel/permission shell

所以 direct connect / ssh remote 完全可以：

- `activeRemote.isRemoteMode === true`

但与此同时，

如果主启动路径没有写：

- `setIsRemoteMode(true)`

那全局 `getIsRemoteMode()` 仍然不一定为真。

这就说明当前系统里至少有两层不同的 remote 语义：

1. turn-level remote interaction
2. global remote behavior environment

它们不是同一层，

更不等于：

- remote presence truth

## 第四层：很多 consumer 看 `getIsRemoteMode()`，是因为它们只需要“要不要在本地继续做这件事”

这一层很容易被误读成：

- “既然很多地方都看它，那它就是主状态源。”

但看几个典型 consumer 就会发现，它们其实只需要一个布尔开关。

### 启动通知

`useStartupNotification.ts` 里：

- `if (getIsRemoteMode()) return`

它要回答的问题只是：

- 当前是不是本地运行环境，是否还该弹本地启动通知

### footer mode part

`PromptInputFooterLeftSide.tsx` 里：

- `!getIsRemoteMode()` 才显示本地 permission mode part

这里要回答的也只是：

- 当前本地 mode 文案还有没有意义

### status line

`StatusLine.tsx` 里：

- `getIsRemoteMode()` 为真时加上 remote session id

它回答的也只是：

- 当前是不是远端会话环境

这些地方都只需要：

- global behavior branch

并不需要：

- `remoteSessionUrl`
- `remoteConnectionStatus`
- `remoteBackgroundTaskCount`

所以它们广泛使用 `getIsRemoteMode()`，

并不能推出：

- 它就是 presence truth

## 第五层：`/session` 命令的双重 gate 恰好证明了“命令显隐”和“presence truth”不是同一层

这是这一页最值钱的证据之一。

`commands/session/index.ts` 里：

- 命令是否显示，看的是 `getIsRemoteMode()`

但真正的 pane 实现 `commands/session/session.tsx` 里又会继续判断：

- `if (!remoteSessionUrl) { Not in remote mode. Start with claude --remote }`

也就是说，系统当前明确把 `/session` 拆成了两层：

### 第 1 层：能不能把这个命令露出来

- 看 global remote behavior flag

### 第 2 层：当前是不是真的有 remote-session presence 可展示

- 看 `remoteSessionUrl`

如果 `getIsRemoteMode()` 就是 presence truth，

这第二层检查根本没必要存在。

所以 `/session` 的双重 gate 反过来证明：

- `getIsRemoteMode()` 不是 presence truth

## 第六层：这也解释了为什么 `remoteSessionUrl` 才是 pane / footer / brief line 真正认的那张账

把上一页 141 的结论接过来，这里就更清楚了。

当前 repo 里真正面向 presence 的 consumer 读的是：

- `remoteSessionUrl`
- `remoteConnectionStatus`
- `remoteBackgroundTaskCount`

而不是：

- `getIsRemoteMode()`

这三张账回答的是：

- remote session URL 在哪
- viewer WS 当前连接态是什么
- 后台任务数是多少

`getIsRemoteMode()` 回答的则只是：

- 系统要不要切到 remote 行为模式

所以它们不是：

- 同一个状态源的粗细不同视图

而是：

- 根本不同层级的 remote 语义

## 第七层：因此“被很多地方消费”只是说明它是 global behavior switch，不说明它是 authoritative ledger

把前面几层压成一句，更稳的一句是：

- widely consumed does not mean authoritatively descriptive

也就是说：

### `getIsRemoteMode()` 当前描述的是

- 是否切换到远端运行环境
- 是否停掉一批本地通知 / 推荐 / 本地 mode 显示
- 是否给某些全局 surface 加一个 remote 环境分支

### `getIsRemoteMode()` 当前不描述的是

- remote session URL
- 连接态
- 远端后台任务数
- 哪种 remote mode 的 presence surface 真的存在

所以它被广泛使用，

只说明：

- 它是一个全局行为开关

不说明：

- 它已经足够承担 presence truth

## 第八层：为什么这页不是 141 的重复

141 讲的是：

- remote-session presence ledger 为什么本来就不通用

143 讲的是：

- `getIsRemoteMode()` 为什么也不能被误认成那张 truth

一个讲：

- authoritative ledger 的专属边界

一个讲：

- global behavior flag 的边界

所以 143 不是重写 141，

而是把“不是同一张账”继续压成：

- “这个布尔位甚至不是账”

## 第九层：最常见的四个假等式

### 误判一：`getIsRemoteMode()` 被很多地方看，所以它就是系统里的 remote truth

错在漏掉：

- 它只提供布尔环境位
- 不提供 presence 细节

### 误判二：只要 `activeRemote.isRemoteMode` 为真，`getIsRemoteMode()` 也该同步为真

错在漏掉：

- 一个是 turn-level interaction shell
- 一个是 global behavior flag

### 误判三：`/session` 命令能显示出来，就说明当前一定有 remote-session presence 可看

错在漏掉：

- 命令显隐和 pane 内容是双重 gate

### 误判四：`getIsRemoteMode()` 和 `remoteSessionUrl` 只是同一状态源的粗细不同投影

错在漏掉：

- 一个是布尔环境位
- 一个是 authoritative presence field

## 第十层：stable / conditional / internal

### 稳定可见

- `getIsRemoteMode()` / `setIsRemoteMode()` 当前只是 bootstrap 布尔位
- remote-session 路径当前会显式 `setIsRemoteMode(true)`
- direct connect 启动分支当前不会写这个开关
- 多个 consumer 当前只把它当 global behavior branch
- `/session` 当前用双重 gate 区分命令显隐与 presence 内容

### 条件公开

- 将来系统完全可能让更多 remote mode 也写 `setIsRemoteMode(true)`，但那仍不自动推出它就是 presence truth
- `getIsRemoteMode()` 的消费者很多，容易持续制造误读；这是结构性条件，不是一次性例外
- 如果以后直接把 `getIsRemoteMode()` 和某些 presence ledger 绑定得更紧，这页的边界会变化，但当前代码还没这样做

### 内部 / 灰度层

- 当前仓内没有对外承诺说 `getIsRemoteMode()` 的语义永远只限 behavior flag
- 它和 `remoteSessionUrl` / `activeRemote` 之间的分层更多是实现事实，而不是显式 public contract
- 这类“广泛被消费的简单布尔位”最容易在未来演化中被误扩权

## 第十一层：苏格拉底式自审

### 问：我现在写的是全局行为开关，还是 authoritative presence truth？

答：如果答不出来，就会把 `getIsRemoteMode()` 写过头。

### 问：我是不是把“消费者很多”偷换成了“描述力足够强”？

答：如果是，就忽略了它只有一个布尔位。

### 问：我是不是把 `activeRemote.isRemoteMode` 和 `getIsRemoteMode()` 当成了同一层 remote 语义？

答：如果是，就把 REPL turn shell 和全局环境位混了。

### 问：我是不是忽略了 `/session` 的双重 gate？

答：如果是，就会错过“命令显隐”和“pane presence 内容”这条最值钱的分界线。

### 问：我是不是又回到 141 的 ledger 页面，而没有真正回答“为什么这个布尔位不是账”？

答：如果是，就还没真正进入 143。

## 源码锚点

- `claude-code-source-code/src/bootstrap/state.ts`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/hooks/notifs/useStartupNotification.ts`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
- `claude-code-source-code/src/components/StatusLine.tsx`
- `claude-code-source-code/src/commands/session/index.ts`
- `claude-code-source-code/src/commands/session/session.tsx`
