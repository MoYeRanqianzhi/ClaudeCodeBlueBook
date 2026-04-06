# standalone remote-control 生命周期动词拆分记忆

## 本轮继续深入的核心判断

第 33 页已经拆开：

- disconnect dialog
- perpetual teardown
- pointer
- `--continue`

第 41 页已经拆开：

- transport URL
- secret
- token
- epoch

但 standalone remote-control 仍缺一层非常容易继续混写的 lifecycle verb 语义：

- `registerBridgeEnvironment`
- `pollForWork`
- `acknowledgeWork`
- `heartbeatWork`
- `stopWork`
- `archiveSession`
- `deregisterEnvironment`

如果不单独补这一批，正文会继续犯七种错：

- 把 register 和 poll 写成同一种启动
- 把 ack 和 heartbeat 写成同一种保活
- 把 stop、archive、deregister 写成同一种关闭
- 把 reconnect 写成主生命周期动作
- 把 single-session resume 的跳过逻辑写成实现噪音
- 把 environment、work、session 三层对象压成同一个“bridge state”
- 把内部生命周期 API 直接等同于用户可见按钮

## 苏格拉底式自审

### 问：为什么这批不能塞回第 33 页？

答：第 33 页解决的是：

- 用户看见的断开、退出、resume 轨迹

而本轮问题已经换成：

- 服务端生命周期 API 到底在操作哪一层对象

也就是从：

- user-facing shutdown / resume

继续下钻到：

- backend lifecycle verbs

所以需要新起一页。

### 问：为什么这批也不能塞回第 41 页？

答：第 41 页解决的是：

- bridge / child 靠什么 transport material 连起来

而本轮更偏：

- 连起来之后，环境、work、session 在生命周期里怎样演化

也就是：

- transport credential

之后的：

- lifecycle control verbs

所以不能再混回 41。

### 问：为什么不能把它写成“teardown 补充说明”？

答：因为真正需要拆开的不是：

- 退出时做了哪些清理

而是：

- 从 register 到 poll 到 ack 到 heartbeat 到 stop 的中途链条
- archive / deregister 又分别落在哪层对象上

如果只写 teardown 补充，claim / lease / archival 的骨架会继续丢失。

### 问：这批最该防的偷换是什么？

答：

- environment 注册 = work 领取
- claim = lease keepalive
- work 结束 = session 归档 = environment 下线
- reconnect = 正常主线

只要这四组没拆开，standalone remote-control 的生命周期正文就还会继续糊。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/42-register、poll、ack、heartbeat、stop、archive 与 deregister：为什么 standalone remote-control 的环境、work 与 session 生命周期不是同一种收口.md`
- `bluebook/userbook/03-参考索引/02-能力边界/31-Remote Control register、poll、ack、heartbeat、stop、archive 与 deregister 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/42-2026-04-06-standalone remote-control 生命周期动词拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- register/poll/ack/heartbeat/stop/archive/deregister 的对象边界
- reconnect 是恢复性旁路
- single-session resume 会故意跳过 archive+deregister
- work、session、environment 不属于同一生命周期层

### 不应写进正文的

- 所有 backoff 常量和日志节流细节
- poisoned work item 的全部异常枝节
- every shutdown branch 的 Promise 编排噪音
- diagnostics 埋点细节

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### `acknowledgeWork` 最容易被写坏

源码明确提醒：

- 不能太早 ack

这说明它不是“只要拿到 work 就立刻确认”，而是：

- 只有真正 commit to handle 时才 claim

### `stopWork` 与 `archiveSession` 正好构成 work/session 两层对照

这一组对照很值得保留。

否则正文会很容易退化成：

- 任务结束了，所以 session 也没了

这种错位叙事。

### `deregisterEnvironment` 是最外层收口，不是收尾默认同义词

尤其 single-session `--continue` 会跳过 archive+deregister，这一点必须留在记忆里持续提醒。

### `reconnectSession` 只能放在恢复旁路里

如果把它写成主线生命周期动作，整条 register/poll/ack/heartbeat 主线会被污染。

## 并行 agent 结果

本轮仍以主线本地源码复核为准，agent 结果只作旁证，不直接回灌正文。

## 后续继续深入时的检查问题

1. 我当前讲的是 environment、work，还是 session？
2. 我当前讲的是 claim、lease、stop、archive，还是 teardown？
3. 我是不是又把 reconnect 写成了主线动作？
4. 我是不是又把 stop、archive、deregister 写成同一种关闭？
5. 我是不是又把内部 API 动词直接翻译成了单个 UI 按钮？

只要这五问没先答清，下一页继续深入就会重新滑回：

- 生命周期混写
- 或恢复路径细节污染正文

而不是用户真正可用的 standalone remote-control 生命周期正文。
