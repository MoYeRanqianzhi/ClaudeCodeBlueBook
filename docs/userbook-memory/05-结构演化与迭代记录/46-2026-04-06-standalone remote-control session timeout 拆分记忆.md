# standalone remote-control session timeout 拆分记忆

## 本轮继续深入的核心判断

第 42 页已经拆开：

- environment/work/session lifecycle verbs

第 45 页已经拆开：

- work intake validity / ack / routing

但 standalone remote-control 仍缺一层非常容易继续混写的 session-timeout 语义：

- `sessionTimeoutMs`
- timeout watchdog
- `timedOutSessions`
- raw `interrupted`
- `handle.kill()`
- `handle.forceKill()`
- `shutdownGraceMs`

如果不单独补这一批，正文会继续犯六种错：

- 把 `sessionTimeoutMs` 和 `shutdownGraceMs` 写成同一种 timeout
- 把 watchdog 到点写成直接 `failed`
- 把 raw `interrupted` 当成最终用户状态
- 把 `kill()` 与 `forceKill()` 写成同一种终止
- 把请求 timeout 混进会话 timeout 正文
- 把 timeout-killed session 与 shutdown-killed session 写成同一种 interrupted

## 苏格拉底式自审

### 问：为什么这批不能塞回第 42 页？

答：第 42 页解决的是：

- 生命周期动词在 environment/work/session 三层分别操作什么

而本轮问题已经换成：

- 同一条 session 在“跑太久”与“桥接收尾”两种 kill 路径里，最终为什么会呈现不同状态

也就是：

- lifecycle verbs

继续下钻到：

- session outcome semantics under timeout/kill

所以需要新起一页。

### 问：为什么不能把它写成“timeout 大全”？

答：因为真正值得写进正文的不是：

- 所有 connect/http/archive timeout 常量

而是：

- 会话运行上限
- watchdog 语义
- raw status 到 bridge status 的 remap

如果写成“timeout 大全”，正文会马上被实现参数噪音污染。

### 问：这批最该防的偷换是什么？

答：

- runtime timeout = shutdown grace
- raw interrupted = final interrupted
- SIGTERM = SIGKILL
- request timeout = session timeout

只要这四组没拆开，standalone remote-control 的 timeout 正文就还会继续糊。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/46-session timeout、watchdog、SIGTERM、SIGKILL 与 failed remap：为什么 bridge 的会话超时、收尾中断与请求 timeout 不是同一种 timeout.md`
- `bluebook/userbook/03-参考索引/02-能力边界/35-Remote Control session timeout、watchdog、kill 与 failed remap 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/46-2026-04-06-standalone remote-control session timeout 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- `sessionTimeoutMs` 是 runtime limit，不是 shutdown grace
- watchdog 先记 timeout，再发 `SIGTERM`
- timeout-killed session 会由 bridge remap 成 `failed`
- `SIGKILL` 只属于 grace 结束后的强杀

### 不应写进正文的

- 所有 HTTP timeout 常量
- connect / archive timeout 的实现预算
- every Windows signal fallback detail
- request-layer timeout 配置总表

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### `timedOutSessions` 是这一批最值得保留的骨架

它把：

- raw child `interrupted`

和：

- bridge 层用户语义 `failed`

拆开了。

### `kill()` 与 `forceKill()` 的区别不在平台，而在语义

这是本轮第二根骨架。

若不持续提醒，正文很容易把两个 kill 重新写平。

### 这批必须主动排除 request timeout

否则它会迅速把整页拉回“参数大全”，破坏正文纯度。

## 并行 agent 结果

本轮 agent 给出的同向结论是：

- session timeout / watchdog / kill 这条线值得独立成页
- 但整套 connect/http/archive timeout 不值得并成一页正文

因此本轮正文继续按窄题处理。

## 后续继续深入时的检查问题

1. 我当前讲的是 session runtime limit，还是 shutdown grace？
2. 我当前讲的是 raw process status，还是 bridge remap 后的用户状态？
3. 我是不是又把 `kill()` 与 `forceKill()` 写成了同一种终止？
4. 我是不是又把 request timeout 混进会话 timeout？
5. 我是不是又把 timeout-killed session 写成了普通 interrupted？

只要这五问没先答清，下一页继续深入就会重新滑回：

- timeout 语义混写
- 或参数噪音污染正文

而不是用户真正可用的 bridge session-timeout 正文。
