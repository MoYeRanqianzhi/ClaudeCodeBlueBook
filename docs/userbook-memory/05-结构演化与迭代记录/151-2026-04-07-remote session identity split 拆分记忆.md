# remote session identity split 拆分记忆

## 本轮继续深入的核心判断

145 和 146 已经把 remote bit、URL、viewerOnly 的粗边界拆开了。

但正文还缺一个更细的 identity 结论：

- `remote.session_id` 并不自动等于当前前端真正附着和拥有的那条远端 session

本轮要补的更窄一句是：

- assistant viewer、remote TUI、footer link、`/session` pane 与 `StatusLine` 分别消费的是不同的 session 身份账

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 `StatusLine.remote.session_id` 写成远端 target session 真值
- 把 `remoteSessionUrl` 写成所有 session 身份的统一入口
- 把 “attached 到远端 session” 写成 “拥有这条 session 的本地主权”

这三种都会把：

- bootstrap session
- transport session
- connect URL
- ownership

重新压扁。

## 本轮最关键的新判断

### 判断一：`StatusLine.remote.session_id` 只直接读本地 `getSessionId()`

### 判断二：assistant viewer 会 `setIsRemoteMode(true)`，但不会 `switchSession(targetSessionId)`

### 判断三：remote TUI 会 `switchSession(createdSession.id)`，因此本地与远端身份更接近对齐

### 判断四：footer remote pill 与 `/session` pane 依赖的是 `remoteSessionUrl`，不是 transport `sessionId`

### 判断五：`viewerOnly` 体现的是主权收窄，不是 session 不存在

## 苏格拉底式自审

### 问：为什么这页不是 145 的附录？

答：因为 145 讲的是 URL affordance 缺席，这页讲的是 session identity ledger 本身分裂成多张账。

### 问：为什么一定要把 `switchSession(...)` 写出来？

答：因为不把它写出来，就看不出 remote TUI 与 assistant viewer 的本地 session 对齐策略根本不同。

### 问：为什么一定要把 `viewerOnly` 拉进来？

答：因为不写它，就会把“附着远端 session”误写成“拥有远端主权”。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/151-getSessionId、switchSession、StatusLine、assistant viewer、remoteSessionUrl 与 useRemoteSession：为什么 remote.session_id 可见，不等于当前前端拥有那条 remote session.md`
- `bluebook/userbook/03-参考索引/02-能力边界/140-getSessionId、switchSession、StatusLine、assistant viewer、remoteSessionUrl 与 useRemoteSession 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/151-2026-04-07-remote session identity split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 151
- 索引层只补 140
- 记忆层只补 151

不回写 145、146。

## 下一轮候选

1. 继续拆 assistant viewer 的 history / lazy-load / presence surface，避免把 viewer 的 session 身份和 transcript 所有权混成一页。
2. 继续拆 `system/init` 里的 session metadata 为什么仍不能直接被写成 session presence truth。
