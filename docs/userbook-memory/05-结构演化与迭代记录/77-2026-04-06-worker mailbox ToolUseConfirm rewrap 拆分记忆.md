# worker mailbox ToolUseConfirm rewrap 拆分记忆

## 本轮继续深入的核心判断

76 页已经拆开：

- REPL 里的本地阻塞容器家族
- 不共享同一治理闭环

但 76 还缺一个更细、也更容易误判的局部：

- `toolUseConfirmQueue` 里的某些条目
- 其实并不是当前 leader 自己的本地 ask

tmux worker mailbox ask 正是这个局部。

如果不单独补这一批，正文还会继续犯几种错：

- 把带 `workerBadge` 的条目写成 leader 自己的本地审批
- 把 worker 的 `pendingWorkerRequest` 写成另一种本地决策框
- 漏掉 continuation 真正在 worker callback 恢复
- 漏掉 leader 侧 `recheckPermission()` / `onUserInteraction()` 其实没有 worker permission state 意义

## 为什么这轮要单写 worker mailbox rewrap

这一批不只是 swarm 实现细节，因为它刚好卡在三层交界处：

1. worker 的本地 `PermissionContext`
2. leader 的本地 `ToolUseConfirm` UI 壳
3. mailbox response 回到 worker continuation

也就是说，它天然横跨：

- 74 的 approval shell vs authority
- 75 的 topology direction
- 76 的 local modal family

如果不单独拆，它会不断污染这三页的边界。

## 本轮最关键的新判断

### 判断一：ask 起点仍然在 worker，不在 leader

`handleSwarmWorkerPermission(...)` 先做的是：

- classifier 尝试
- `createPermissionRequest(...)`
- callback 注册
- mailbox 发送

所以 leader 不是 ask 的起点，只是 ask 的可视审批宿主。

### 判断二：worker 自己只显示 pending，不显示同款审批壳

worker 只写：

- `pendingWorkerRequest`

这意味着：

- worker 侧 UI 是 waiting indicator
- leader 侧 UI 才是 approval shell

### 判断三：leader 侧是 rewrap，不是本地 ask 重生

leader 侧 `useInboxPoller` 做的是：

- `findToolByName(getAllBaseTools(), parsed.tool_name)`
- 构造 `ToolUseConfirm`
- `workerBadge`
- no-op `recheckPermission()`
- mailbox response 出口

这是一层 rewrap，不是 leader 自己的 permission context 闭环。

### 判断四：真正 continuation 仍然在 worker callback

worker 侧通过：

- `useSwarmPermissionPoller`
- `processMailboxPermissionResponse(...)`

把 leader 的选择接回自己的 callback，再决定：

- `ctx.handleUserAllow(...)`
- `ctx.cancelAndAbort(...)`

所以最稳的表述应是：

- leader-visible approval shell
- worker-owned continuation

## 苏格拉底式自审

### 问：为什么这页不能塞回 76？

答：76 讲的是单个 REPL 宿主里的本地容器谱系。

本轮问题已经换成：

- 一个 worker ask 如何跨进程跑到 leader 的本地壳里

也就是：

- cross-process rewrap

不是：

- same-host modal family

### 问：为什么这页不能只在 75 里加个小节？

答：75 讲的是大拓扑：

- remote / direct / ssh / bridge

tmux worker 这页的核心不在“哪条远端家族”，而在：

- worker 起点
- leader 壳
- worker 回流

这是另一张更细的局部拓扑图。

### 问：为什么这批值得保留独立长文？

答：因为它正好解释了一个 UI 上非常强的误导：

- leader 看到的几乎是同款 `PermissionRequest`

但语义却不是同一个本地 ask。

这种“长得最像，却最不该混”的对象，非常值得单独拆页。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/77-swarmWorkerHandler、useInboxPoller、permissionSync、useSwarmPermissionPoller 与 workerBadge：为什么 tmux worker 的 mailbox ask 会在 leader 侧重包成 ToolUseConfirm，却不等于 leader 自己的本地审批.md`
- `bluebook/userbook/03-参考索引/02-能力边界/66-Worker mailbox ask、leader ToolUseConfirm rewrap 与 pendingWorkerRequest 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/77-2026-04-06-worker mailbox ToolUseConfirm rewrap 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小改动：

- 只把 77 作为 68-77 连续阅读链尾部的新节点
- 索引层只补一张 66

不去碰更早的大总览，避免目录噪音。

## 下一轮候选

1. 继续把 worker sandbox mailbox ask 与 `workerSandboxPermissions.queue` 单独拆页。
2. 压一张 74-77 的 approval shell / topology / modal family / worker rewrap 总索引。
3. 继续拆 swarm 多进程里 permission update 从 leader 选择到 worker context 应用的路径。
