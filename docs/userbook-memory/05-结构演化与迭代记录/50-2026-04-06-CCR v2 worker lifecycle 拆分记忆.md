# CCR v2 worker lifecycle 拆分记忆

## 本轮继续深入的核心判断

第 20 页已经拆开：

- `StructuredIO` / `RemoteIO`
- headless 宿主 I/O 合同

第 41 页已经拆开：

- `sdkUrl`
- `sessionIngressUrl`
- `environmentSecret`
- session access token
- `workerEpoch`

第 44 页已经拆开：

- token refresh
- child sync
- bridge reconnect

第 48 页已经拆开：

- headless startup verdict

但还缺一层非常容易继续混写的 CCR v2 worker lifecycle：

- generation claim
- state restore
- worker heartbeat
- ingress `keep_alive`
- epoch / auth triggered self-exit

如果不单独补这一批，正文会继续犯六种错：

- 把 `workerEpoch` 是什么对象和它何时导致旧代退场写成同一个问题
- 把 `PUT /worker` 与 `GET /worker` 写成同一种初始化
- 把 worker heartbeat 与 ingress `keep_alive` 写成同一种保活
- 把 token expired exit 与 epoch mismatch 写成同一种退场原因
- 把普通 request failure 写成 worker 死亡
- 把 uploader 常量与 wiring 细节重新污染正文

## 苏格拉底式自审

### 问：为什么这批不能塞回第 20 页？

答：第 20 页解决的是：

- headless / print 的宿主合同
- `RemoteIO` 把会话放进结构化远端宿主

而本轮问题已经换成：

- 这一代 CCR v2 worker 怎样完成 init / restore / liveness / exit

也就是：

- worker lifecycle contract

不是：

- host I/O contract

### 问：为什么这批不能塞回第 41 页？

答：第 41 页解决的是：

- 这些 URL / 密钥 / token / epoch 分别是什么对象

而本轮问题已经换成：

- `workerEpoch` 怎样参与 init、heartbeat 与 supersede exit
- `keep_alive` 与 `/worker/heartbeat` 为什么不是同一种保活

也就是：

- object semantics 深一层的 lifecycle semantics

不是：

- credential / identifier taxonomy

### 问：为什么这批不能塞回第 44 页？

答：第 44 页解决的是：

- child token refresh
- heartbeat 续租
- bridge reconnect

而本轮关注的是：

- CCR v2 worker 自己怎样登记、恢复、保活与自退

也就是：

- worker-local lifecycle

不是：

- bridge / child token-refresh semantics

### 问：为什么不能写成“CCRClient 实现大全”？

答：因为真正值得写进正文的不是：

- uploader batch size
- flush window
- wiring race
- retry 常数

而是：

- 当前代是否完成登记
- 是否成功恢复上一代状态
- 保活打在哪条链路
- 为什么旧代会被新代或 auth verdict 顶掉

如果写成实现大全，正文会再次掉回作者记忆与参数噪音。

本轮 agent 旁证补了一条关键收束：

- 真正适合进 userbook 主面的，其实主要是 partial state restore 与 self-exit / graceful handoff
- `worker heartbeat` 与 `keep_alive` 更适合保留成支撑这些主现象的内部机制

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/50-worker epoch、state restore、worker heartbeat、keep_alive 与 self-exit：为什么 CCR v2 worker 的初始化、保活与代际退场不是同一种存活合同.md`
- `bluebook/userbook/03-参考索引/02-能力边界/39-Remote Control worker epoch、state restore、heartbeat、keep_alive 与 self-exit 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/50-2026-04-06-CCR v2 worker lifecycle 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- generation claim、state restore、worker heartbeat、`keep_alive`、self-exit 的层次分离
- epoch mismatch 与 auth-triggered self-exit 的区别
- 普通 request failure 不等于 worker 死亡

### 不应写进正文的

- uploader batching / queue size
- callback wiring 顺序竞态
- 具体 heartbeat / keep_alive 毫秒数
- diagnostics 事件名
- GET retry 常数

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### `PUT /worker` 与 `GET /worker` 必须写成两种初始化动作

这是本批第一根骨架。

### `keep_alive` 与 `/worker/heartbeat` 是两条不同保活链

这是本批第二根骨架。

### auth-triggered self-exit 不等于 epoch mismatch

这是本批第三根骨架。

如果不持续提醒，正文很容易把所有退出都重新写成：

- epoch mismatch

### reader-facing 主次要再压一层

这是本批第四根骨架。

也就是：

- 主面：partial state restore、self-exit / graceful handoff
- 次面：heartbeat、`keep_alive` 作为支撑机制

## 并行 agent 处理策略

本轮继续按多 agent 旁路勘探执行：

- 一路判断这批是否与 20 / 41 / 44 重复
- 一路收敛 stable / conditional / internal 边界
- 一路为下一批预选更后续的 worker / bridge 主题

主线程仍不等待 agent 才落笔，因为本地源码锚点已经足够收敛本批边界。

## 后续继续深入时的检查问题

1. 我当前讲的是对象分类，还是 worker lifecycle？
2. 我是不是又把 state restore 和 generation claim 写成了同一种 init？
3. 我是不是又把 `keep_alive` 和 worker heartbeat 写成了同一种保活？
4. 我是不是又把 token/auth exit 写成了 epoch mismatch？
5. 我是不是又把普通 request failure 抬成了 worker 死亡？
6. 我是不是又把正文滑回 `CCRClient` 实现大全？

只要这六问没先答清，下一页继续深入就会重新滑回：

- worker lifecycle 混写
- 或实现细节污染正文

而不是用户真正可用的 CCR v2 worker 生命周期正文。
