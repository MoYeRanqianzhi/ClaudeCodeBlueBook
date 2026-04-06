# direct connect visible status surfaces 拆分记忆

## 本轮继续深入的核心判断

第 61 页已经拆开：

- 哪些远端消息会进 transcript
- 哪些会被过滤
- 哪些会被去重

但第 61 页回答的是：

- message families 到 transcript surface 的投影链

不是：

- 用户当前实际看到的几张状态面为什么不是同一张板

而 direct connect 的用户面依然很容易被混写成一张“远端状态板”：

- 本地启动提示
- transcript 状态事件
- tab status 的 `busy / waiting / idle`
- approval overlay
- fatal stderr disconnect

如果不单独补这一批，正文会继续犯六种错：

- 把 main 注入的连接提示写成远端 init
- 把 transcript 里的 `Status: ...` 写成 REPL 当前总状态
- 把 `busy / waiting / idle` 写成远端 status subtype
- 把 approval overlay 写成 transcript 状态消息
- 把 `waiting` 误写成远端卡住
- 把 fatal stderr 文案写成普通状态消息

## 苏格拉底式自审

### 问：为什么这批不能塞回第 61 页？

答：第 61 页回答的是：

- 哪些消息会不会进 transcript

而本轮问题已经换成：

- 用户现在看到的状态到底来自哪张面

也就是：

- visible status surfaces

不是：

- transcript projection rules

### 问：为什么这批不能塞回第 60 页？

答：第 60 页回答的是：

- control subset
- interrupt
- shutdown

而本轮问题已经换成：

- startup hint、tab status、overlay 与 stderr 这几张可见面之间的边界

也就是：

- visible surface partition

不是：

- control / shutdown semantics

### 问：为什么这批不应写成 generic “远端状态页”？

答：因为 direct connect 的关键不是：

- 远端内部到底有哪些状态词

而是：

- 哪几种不同来源的状态，被用户同时看见

如果写成 generic 状态页，就会把：

- 远端事件
- 本地派生态
- overlay
- stderr

重新混成一张板。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/62-Connected to server、Remote session initialized、busy_waiting_idle、PermissionRequest 与 stderr disconnect：为什么 direct connect 的可见状态面不是同一张远端状态板.md`
- `bluebook/userbook/03-参考索引/02-能力边界/51-Direct connect visible status surface 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/62-2026-04-06-direct connect visible status surfaces 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- `Connected to server at ...` 是本地启动提示
- `Remote session initialized` / `Status: ...` 是 transcript 里的离散事件
- `busy / waiting / idle` 是 REPL 本地派生 tab status
- approval overlay 是单独的等待面
- disconnect 文案走 stderr fatal surface

### 不应写进正文的

- 61 页的 message filtering 细则
- 60 页的 control subset / interrupt / shutdown 细节
- 59 页的 session factory / `ws_url` / `work_dir`
- 对远端内部状态机的过度脑补

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### “同像但不同源”是本批第一根骨架

如果漏掉它，正文就会把：

- startup hint
- transcript status
- local tab status

重新写成一张统一状态板。

### approval overlay 不是“状态消息”

如果漏掉它，正文会继续把：

- waiting

错误地全都归因为远端状态更新。

### fatal stderr 必须和 transcript 状态完全剥离

如果漏掉它，正文就会把 disconnect 文案继续写成：

- 又一条普通状态消息

## 后续继续深入时的检查问题

1. 我当前讲的是 visible surface，还是又滑回 transcript filtering？
2. 我是不是又把本地启动提示写成远端 init？
3. 我是不是又把 `busy / waiting / idle` 写成远端 status subtype？
4. 我是不是又把 approval overlay 写成状态消息？
5. 我是不是又把 fatal stderr 写成普通状态消息？
6. 我是不是又把 direct connect 写成单一状态板？

只要这六问没先答清，下一页继续深入就会重新滑回：

- 60/61 复述

而不是用户真正可用的可见状态面正文。
