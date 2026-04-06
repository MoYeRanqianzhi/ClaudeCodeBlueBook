# standalone remote-control flags 与 title 继承拆分记忆

## 本轮继续深入的核心判断

第 18 页已经拆开：

- CLI 根入口
- flag
- 启动模式

第 27 页已经拆开：

- 入口矩阵
- 会内开桥
- standalone host

第 37 页已经拆开：

- spawn topology
- capacity
- cwd anchor

但 standalone host 还缺一层非常容易继续混写的 flag / 继承语义：

- `--name`
- `--permission-mode`
- `--sandbox`
- server title fetch
- first-user-message fallback

如果不单独补这一批，正文会继续犯六种错：

- 把 `--name` 写成 host display name
- 把 `--name` 写成 future sessions 的全局默认标题
- 把 `permission-mode` 和 `sandbox` 写成同一种安全策略
- 把 sandbox 写成 session metadata
- 把 title 回填链写成 `--name` 的延长
- 把 initial session seed 与 spawned session defaults 混成一层

## 苏格拉底式自审

### 问：为什么这批不能塞回第 18 页？

答：第 18 页解决的是：

- CLI flags 在根入口层属于什么对象

而本轮问题已经换成：

- 当这些 flags 落到 standalone remote-control host 时，分别继承到哪一层对象

也就是从：

- root flag catalog

继续下钻到：

- host/session inheritance

所以需要新起一页。

### 问：为什么这批也不能塞回第 37 页？

答：第 37 页解决的是：

- host topology
- allocation
- capacity

而本轮更偏：

- 这些 host-level flags 怎样进入 session object 和 child runtime

也就是：

- topology

之后的：

- session policy inheritance

所以不能再混回 37。

### 问：这批最该防的偷换是什么？

答：

- host flag = session metadata
- title seed = title fallback
- permission policy = runtime constraint
- initial session = all future sessions

只要这四组没拆开，standalone host 正文就还会继续糊。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/39-name、permission-mode、sandbox 与 session title：为什么 standalone remote-control 的 host flags、session 默认策略与标题回填不是同一种继承.md`
- `bluebook/userbook/03-参考索引/02-能力边界/28-Remote Control name、permission-mode、sandbox 与 title 回填索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/39-2026-04-06-standalone remote-control flags 与 title 继承拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- `--name` 是 initial session title seed
- `--permission-mode` 是 session default policy
- `--sandbox` 是 child runtime constraint
- server title 优先于 first-message fallback
- `--name` 不等于所有 future sessions 的默认标题

### 不应写进正文的

- `titledSessions` 集合细节
- `updateBridgeSessionTitle(...)` 的竞争时序
- `CLAUDE_CODE_FORCE_SANDBOX` 的实现细节
- debug log / title fetch 的失败噪音

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### `--name` 最容易被写坏

它在 help 里写成：

- Name for the session

而不是：

- Name for the host

同时实际只在 pre-create initial session 时进入：

- `title: name`

所以正文必须写“initial session seed”，不能偷写成 “host name”。

### `permission-mode` 同时落在 create-session 和 child spawn

这使它成为最像 host-wide session default 的 flag。

如果漏掉其中一层，正文就会把它写成“只影响服务器”或“只影响本地 child”的半真半假描述。

### sandbox 与 permissionMode 正好形成反例对照

- `permissionMode` 进入 request body
- `sandbox` 不进入 request body
- `sandbox` 只进入 child env

这组对照是正文里最值得保留的第一性原理骨架。

### title 回填链必须和 `--name` 分离

spawned sessions 上的标题链是：

- server title
- if absent, first user message derive

这意味着：

- `--name` 并不统摄所有 title surface

如果这条不在 memory 里持续提醒，正文很容易重新把 title 讲平。

## 并行 agent 结果

本轮并行 agent 主要用于确认：

- 这条线值得独立成页
- 它与入口矩阵、spawn topology、display surface 不重复

如有延迟返回，只作为 memory 继续深化，不回灌本轮正文主线。

## 后续继续深入时的检查问题

1. 我现在拆的是 session object，还是 child runtime？
2. 这条 flag 影响的是 initial session，还是所有 spawned sessions？
3. 这里讲的是 title seed，还是 title fallback？
4. 我是不是又把 sandbox 写成了服务端 metadata？
5. 我是不是又把 `--name` 写成 host name？

只要这五问没先答清，下一页继续深入就会重新滑回：

- flags 混写
- 或时序细节污染正文

而不是用户真正可用的 standalone host 继承正文。
