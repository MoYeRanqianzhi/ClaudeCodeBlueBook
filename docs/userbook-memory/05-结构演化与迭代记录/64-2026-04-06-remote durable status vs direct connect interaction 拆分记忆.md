# remote durable status vs direct connect interaction 拆分记忆

## 本轮继续深入的核心判断

59 到 63 已经把 direct connect 自己拆成四层：

- session factory
- control subset / shutdown
- transcript surface
- visible status surfaces
- transcript mode vs raw stream

但仍缺一层跨模式边界：

- remote session 的持续状态面
- direct connect 的当前交互态

如果不单独补这一批，正文会继续犯六种错：

- 把 `busy / waiting / idle` 写成远端连接态
- 把 `Reconnecting...` / `n in background` 写成当前 prompt 节奏
- 把 `remote` pill 写成工作态
- 把 `Connected to server at ...` 写成持续状态
- 把 remote session 的 `AppState` 写回链和 direct connect 的本地派生态混成一类
- 把两种远端模式都写成“只是文案不同”

## 苏格拉底式自审

### 问：为什么这批不能塞回第 30 页？

答：第 30 页回答的是：

- remote session 内部的连接告警、后台任务、viewerOnly、bridge reconnect

而本轮问题已经换成：

- remote session 与 direct connect 的状态来源为什么根本不是同一类

也就是：

- cross-mode state authority

不是：

- remote session internal status split

### 问：为什么这批不能塞回第 62 页？

答：第 62 页回答的是：

- direct connect 自己有哪些可见状态面

而本轮问题已经换成：

- 为什么 remote session 有 durable status，而 direct connect 主要只有 local interaction

也就是：

- durable vs local comparison

不是：

- direct connect visible surfaces

### 问：为什么这批不应写成 generic 远端状态比较页？

答：因为真正的新增量只在：

- 状态来源
- 持久性
- 消费范围

如果写成 generic 比较页，就会重新滑回：

- hook 总比较
- 或事件流总比较

而不是用户真正可用的状态来源边界。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/64-remoteSessionUrl、remoteConnectionStatus、remoteBackgroundTaskCount 与 busy_waiting_idle：为什么 remote session 的持续状态面和 direct connect 的当前交互面不是同一种状态来源.md`
- `bluebook/userbook/03-参考索引/02-能力边界/53-Remote durable status vs direct connect local interaction 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/64-2026-04-06-remote durable status vs direct connect interaction 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- remote session 把状态写进 `AppState`
- `BriefIdleStatus` / footer / remote pill 等会消费这些持续状态
- direct connect 主要只派生当前 TUI 的 `busy / waiting / idle`
- `Connected to server at ...` 只是启动提示
- `remote` pill 只是模式标记

### 不应写进正文的

- 30 页内部的 remote status 细分复述
- 62 页 direct connect 自身状态面复述
- 57 页 hook 总比较
- 61/63 的 transcript filtering 细节

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### `AppState` 写回链是本批第一根骨架

如果漏掉它，正文就无法把：

- durable status

和：

- local interaction state

稳稳分开。

### `BriefIdleStatus` 的多消费者性质是本批第二根骨架

如果漏掉它，正文会继续把 remote status 写成某个组件内部状态，而不是共享状态面。

### `Connected to server at ...` 与 `remote` pill 的“非工作态”身份是本批第三根骨架

如果漏掉它，正文就会继续把模式标记、启动提示和运行态混成一张面。

## 后续继续深入时的检查问题

1. 我当前讲的是状态来源，还是又滑回事件流/消息族？
2. 我是不是又把 `busy / waiting / idle` 写成 durable remote status？
3. 我是不是又把 `Reconnecting...` 写成当前 prompt loading？
4. 我是不是又把 `remote` pill 写成工作态？
5. 我是不是又把启动提示写成持续状态？
6. 我是不是又把两种远端模式写成只是文案不同？

只要这六问没先答清，下一页继续深入就会重新滑回：

- 30/62/63 复述

而不是用户真正可用的跨模式状态来源正文。
