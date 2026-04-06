# standalone remote-control consent、gate 与 effective mode 拆分记忆

## 本轮继续深入的核心判断

第 27 页已经拆开：

- `/remote-control`
- `--remote-control`
- `claude remote-control`
- `Remote Callout`

第 37 页已经拆开：

- `single-session`
- `same-dir`
- `worktree`
- `capacity`
- `create-session-in-dir`
- `w`

第 48 页已经拆开：

- headless worker startup verdict

但仍缺一层非常容易继续混写的 standalone host decision-layer：

- one-time consent
- account eligibility gate
- project saved spawn preference
- current effective mode precedence

如果不单独补这一批，正文会继续犯六种错：

- 把 `remoteDialogSeen` 与 `remoteControlSpawnMode` 写成同一种默认设置
- 把 multi-session gate 写成项目 preference
- 把 saved worktree pref 写成当前 effective mode
- 把 chooser 写成当前 mode 的直接签字
- 把 gate default `same-dir` 写成用户主动选择
- 把 resume 写成“不尊重项目默认”

## 苏格拉底式自审

### 问：为什么这批不能塞回第 27 页？

答：第 27 页解决的是：

- 哪条入口属于 REPL 内开桥
- 哪条入口属于 startup flag
- 哪条入口属于 standalone host
- `Remote Callout` 只属于 REPL first-run consent

而本轮问题已经换成：

- standalone host 自己内部是怎样从 consent / gate / preference 走到 final mode

也就是：

- decision layers inside standalone host

不是：

- entry matrix

### 问：为什么这批不能塞回第 37 页？

答：第 37 页解决的是：

- 这些 mode 各自是什么
- 它们在 topology / allocation / budget / anchor 上有什么差别

而本轮问题已经换成：

- 这次为什么落到这个 mode
- 这份 mode 到底来自 gate default、saved pref，还是 explicit flag / resume

也就是：

- source-of-truth hierarchy

不是：

- topology semantics

### 问：为什么这批不能并到第 48 页？

答：第 48 页解决的是：

- worker startup verdict：permanent / transient / non-fatal continue

而本轮关注的是：

- standalone interactive host 的 consent、gate 与 preference precedence

也就是：

- mode selection policy

不是：

- worker retryability

### 问：为什么不能把它写成“remote-control 默认设置大全”？

答：因为真正值得写进正文的不是：

- 所有 global / project config 字段
- analytics 事件
- flush logging 细节

而是：

- 哪些是一次性说明
- 哪些是资格门
- 哪些是 remembered preference
- 哪些才是本次 final mode

如果写成默认设置大全，正文会再次滑回实现参数目录学。

本轮 agent 旁证补了一条很关键的收束：

- 这页主线必须停在 `registerBridgeEnvironment(...)` 之前的本地决议层
- 不要把 registration failure wording 再混回这一页，否则会重新撞上 48 页与失败语义页

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/49-remoteDialogSeen、multi-session gate、ProjectConfig.remoteControlSpawnMode 与 effective spawnMode：为什么 standalone remote-control 的一次性说明、账号资格、项目偏好与当前模式不是同一个默认.md`
- `bluebook/userbook/03-参考索引/02-能力边界/38-Remote Control consent、multi-session gate、project spawn preference 与 effective mode 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/49-2026-04-06-standalone remote-control consent、gate 与 effective mode 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- `remoteDialogSeen` 是 one-time consent，不是 mode default
- multi-session gate 决定能不能进入 multi-session tree
- project preference 是候选输入，不是 final mode
- chooser 生成 preference，不是直接签字当前 effective mode
- resume 优先级高于 saved preference

### 不应写进正文的

- analytics 事件名
- flush/shutdown logging 细节
- readline / TTY 实现旁支
- 与 27 页重复的 REPL callout 细节
- 与 37 页重复的 topology 语义展开

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### `gate default` 是本批第一根骨架

如果不保留，正文会很容易把：

- gate on -> `same-dir`
- gate off -> `single-session`

重新写成“用户默认值”。

### `saved preference` 只是候选输入，不是 final mode

这是本批第二根骨架。

### `resume` 是 precedence tree 的短路器

这是本批第三根骨架。

若不持续提醒，正文会很容易把：

- “项目默认 worktree”

和：

- “这次恢复某一条既有 session”

重新写平。

## 并行 agent 处理策略

本轮继续按多 agent 旁路勘探执行：

- 一路找下一个非重复窄题
- 一路收敛 stable / conditional / internal 边界
- 一路看阅读路径怎么挂

主线程在本轮不等待 agent 结论先落笔，因为本批边界已由本地查重与源码 precedence 充分收敛。

已回收的 agent 进一步提示：

- 本页方向成立，但注册失败语义应继续留在别页
- 更后续的下一批可以转向 CCR v2 worker 的 `epoch / state restore / keep_alive / self-exit` 合同

## 后续继续深入时的检查问题

1. 我当前讲的是 entry matrix、mode semantics，还是 mode source hierarchy？
2. 我是不是又把 `remoteDialogSeen` 和 `remoteControlSpawnMode` 写成了同一种 remembered state？
3. 我是不是又把 gate default 写成了用户主动选择？
4. 我是不是又把 chooser 写成了当前 effective mode 的直接来源？
5. 我是不是又把 resume 这种 continuity short-circuit 写成了“系统没尊重配置”？
6. 我是不是又把正文滑回“默认设置大全”？

只要这六问没先答清，下一页继续深入就会重新滑回：

- 决策层级混写
- 或实现参数目录学污染正文

而不是用户真正可用的 standalone host decision-layer 正文。
