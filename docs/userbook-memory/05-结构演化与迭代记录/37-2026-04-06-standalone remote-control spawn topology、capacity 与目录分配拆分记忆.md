# standalone remote-control spawn topology、capacity 与目录分配拆分记忆

## 本轮继续深入的核心判断

第 27 页已经拆开：

- `/remote-control`
- `--remote-control`
- `claude remote-control`
- Remote Callout
- spawn mode 只属于 standalone host

但 standalone host 还缺一层非常容易继续混写的调度语义：

- `single-session`
- `same-dir`
- `worktree`
- `capacity`
- `create-session-in-dir`
- 运行时 `w`

如果不单独补这一批，正文会继续犯六种错：

- 把 `single-session` 写成 `same-dir` 的并发数特例
- 把 `capacity` 写成目录数 / worktree 数
- 把 `create-session-in-dir` 写成 spawn mode 的另一种名字
- 把 `worktree` 写成“所有会话都进 worktree”
- 把 `w` 写成当前会话迁移开关
- 把 resume 与 future host policy 混成一层

## 苏格拉底式自审

### 问：为什么这批不能塞回第 27 页？

答：第 27 页解决的是：

- 用户从哪一类入口进入 remote-control

而本轮问题已经换成：

- 进入 standalone host 后，它怎样分配会话、目录和并发位

也就是从：

- entrypoint boundary

继续下钻到：

- scheduling boundary

所以需要新起一页。

### 问：为什么这批也不能塞回第 26 页？

答：第 26 页解决的是：

- connect URL
- session URL
- environment / session ID

虽然那里会提到 single-session 与 multi-session 对 QR 的影响，但它关心的是：

- 指向哪个对象

本轮关心的是：

- 这些对象为什么会被分配成这样的宿主和目录拓扑

所以不能回并到定位符页。

### 问：这批最该防的偷换是什么？

答：

- topology = allocation
- capacity = allocation
- cwd anchor = spawn mode
- toggle future policy = migrate current sessions

只要这四组没拆开，standalone host 正文就还会继续糊。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/37-single-session、same-dir、worktree、capacity、create-session-in-dir 与 w：为什么 standalone remote-control 的 spawn topology、并发上限与前台 cwd 会话不是同一种调度.md`
- `bluebook/userbook/03-参考索引/02-能力边界/26-Remote Control spawn topology、capacity 与目录分配索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/37-2026-04-06-standalone remote-control spawn topology、capacity 与目录分配拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- `SpawnMode` 先定义 host topology
- `same-dir` / `worktree` 才定义 multi-session 的目录分配
- `capacity` 定义 active session budget
- `create-session-in-dir` 定义前台 cwd anchor
- `w` 只切 future policy
- resume 强制收窄到 `single-session`

### 不应写进正文的

- at-capacity poll interval 细节
- capacity wake / signal 实现
- worktree create timing analytics
- pointer refresh timer

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### `single-session` 不是 `same-dir` 的简化版

`types.ts` 先从定义上把：

- one session in cwd, bridge tears down when it ends

与：

- persistent server

区分开了。

`bridgeMain.ts` 的 lifecycle decision 又进一步证明：

- single-session 完成后直接 abort poll loop
- multi-session 则继续活着

这条必须保留在记忆里，防止正文偷写成“只是 capacity=1”。

### `create-session-in-dir` 最容易污染正文

它在源码里的对象非常清楚：

- pre-create an empty session on start
- current directory
- on by default

同时 worktree 模式下按需新会话又会进入 isolated worktrees。

所以最容易被写坏的，就是把 “初始 cwd 会话” 和 “后续按需 worktree 会话” 压成互斥关系。

### `w` 改的是 policy，不是 migration

`w` handler 只改：

- `config.spawnMode`
- display
- persisted project pref

没有任何现有 session 搬迁逻辑。

正文必须坚持写 “future allocation policy”，不能偷写成“会话迁移”。

### resume 与 spawn policy 属于不同层

`parseArgs()` 直接把：

- `--session-id` / `--continue`

与：

- `--spawn`
- `--capacity`
- `--create-session-in-dir`

设成互斥。

`bridgeMain.ts` 又把 resume precedence 放到最前面，强制 `single-session`。

这意味着正文不能把 resume 写成 spawn topology 的一种模式。

## 并行 agent 结果

本轮并行 agent 已确认：

- 新页最该切到 scheduling boundary，而不是回写 entrypoint boundary
- 第 27 页只负责“怎么进 standalone host”
- 新页负责“进来后怎样分配 host / cwd / worktree / slot”

## 后续继续深入时的检查问题

1. 我现在拆的是 host topology，还是 directory allocation？
2. 这段话是在说 active session budget，还是 cwd anchor？
3. 我是不是又把 `w` 写成了迁移已有会话？
4. 我是不是又把 resume 写成了 host policy 子模式？
5. 我是不是让 at-capacity 实现细节重新回流正文？

只要这五问没先答清，下一页继续深入就会重新滑回：

- 调度语义混写
- 或实现层节流细节污染正文

而不是用户真正可用的 standalone host 调度正文。
