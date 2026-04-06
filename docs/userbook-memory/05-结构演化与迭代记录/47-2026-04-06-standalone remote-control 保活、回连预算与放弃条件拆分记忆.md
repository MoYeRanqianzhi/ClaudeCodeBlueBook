# standalone remote-control 保活、回连预算与放弃条件拆分记忆

## 本轮继续深入的核心判断

第 31 页已经拆开：

- bridge 的状态词
- 恢复厚度
- 动作上限

第 42 页已经拆开：

- environment / work / session lifecycle verbs

第 46 页已经拆开：

- session runtime timeout
- watchdog / kill / failed remap

但 standalone remote-control 还缺一层非常容易继续混写的 host-liveness 语义：

- seek-work poll
- at-capacity heartbeat
- at-capacity poll backstop
- reconnecting backoff
- connection/general give-up budgets
- sleep reset

如果不单独补这一批，正文会继续犯六种错：

- 把 poll cadence 写成 retry budget
- 把满载 heartbeat 写成断线重试
- 把 `reconnecting` 写成 child session timeout
- 把 connection/general 两类 give-up 写成同一种失败累计
- 把 sleep reset 写成已恢复成功
- 把 `poll_due` 这种内部落点写成用户可见故障

## 苏格拉底式自审

### 问：为什么这批不能塞回第 31 页？

答：第 31 页解决的是：

- `active`
- `reconnecting`
- `failed`
- `Connect URL`
- `Session URL`
- `outbound-only`

也就是：

- 状态词看起来像什么
- 恢复厚度有多厚
- 动作上限在哪里

而本轮问题已经换成：

- 为什么桥会一直 `reconnecting`
- 为什么有时会自己 `Reconnected`
- 为什么系统 sleep 后预算会清零
- 为什么最终会 `giving up`

也就是：

- liveness budget and retry semantics under poll / heartbeat / backoff

所以需要新起一页。

### 问：为什么这批不能塞回第 42 页？

答：第 42 页的 heartbeat 解决的是：

- work 生命周期里有哪些动词
- 谁在 register / poll / ack / heartbeat / stop / archive / deregister

而本轮 heartbeat 问题已经换成：

- 它为什么在 poll outage 时还要继续发 heartbeat
- 它如何与 at-capacity poll 组合
- 它怎样避免 lease 在 backoff sleep 期间过期

所以主题已经从：

- lifecycle verbs

换成了：

- liveness preservation under reconnect/backoff

不能回塞。

### 问：为什么此前“`poll_due` 不值得单开一页”，现在却值得起新批？

答：因为真正值得独立成页的不是：

- `poll_due` 这个单一内部原因

而是整组用户会感知到的 host-liveness 语义：

- seek-work poll
- heartbeat mode
- reconnecting surface
- give-up budgets
- sleep reset

`poll_due` 只是其中一个内部落点。

### 问：为什么不能把它写成“poll / heartbeat 参数大全”？

答：因为真正值得写进正文的不是：

- 每个 GrowthBook 字段
- 每个 jitter / cap 常量
- `reclaim_older_than_ms`
- `session_keepalive_interval_v2_ms`

而是：

- bridge 在保什么
- reconnecting 为什么不等于 timeout
- sleep reset 与 give up 为什么是相反判定

如果写成参数大全，正文会再次被作者记忆和实现噪音污染。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/47-poll、heartbeat、reconnecting、give up 与 sleep reset：为什么 bridge 的保活、回连预算与放弃条件不是同一种重试.md`
- `bluebook/userbook/03-参考索引/02-能力边界/36-Remote Control poll、heartbeat、reconnecting、give up 与 sleep reset 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/47-2026-04-06-standalone remote-control 保活、回连预算与放弃条件拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- seek-work poll 是工作发现 cadence，不是 give-up budget
- at-capacity heartbeat 与 at-capacity poll 是并行保活，不是二选一
- `reconnecting` 是 host backoff 的展示面，不是 child timeout
- connection/general 是两条不同的 give-up track
- sleep reset 是预算重算，不是恢复成功

### 不应写进正文的

- 全部 GrowthBook poll config 字段解释
- jitter / cap 公式细节
- `reclaim_older_than_ms`
- `session_keepalive_interval_v2_ms`
- telemetry event 名称总表
- REPL transport 的全部内部旁支

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### `heartbeat before sleep` 是这一批最值得保留的骨架

它解释了：

- 为什么桥在 `reconnecting` 时不一定已经丢 lease
- 为什么 poll 出错与 work lease 失活不是同一种失败

### `sleep reset` 与 `give up` 必须写成相反判定

若不持续提醒，正文很容易把：

- 睡眠回来重新给预算

和：

- 故障持续太久正式放弃

重新写平。

### `poll_due` 只能当内部落点，不能当正文主角

这是本轮第三根骨架。

## 并行 agent 处理策略

本轮继续按多 agent 旁路勘探执行：

- 一路评估这组 host-liveness 语义是否值得独立成页
- 一路评估 stable / conditional / internal 边界
- 一路评估命名、索引与阅读路径挂载

主线程不等待这些旁证返回才落笔，因为本轮批次边界已经能由源码锚点充分收敛。

目前已回收的 agent 旁证有两条值得吸收：

- 这批确实值得独立成页，因为对象已经是 bridge host 的 poll supervisor / liveness control，而不是 page 31 的状态词展示层、page 42 的 lifecycle verbs、page 45 的 intake contract 或 page 46 的 session timeout。
- `stable` 面应收得更保守：直接用户可见的稳定面只保留 `reconnecting`、`Reconnected` 与最终 `giving up`；seek-work poll cadence 更适合降到条件公开层。
- `路径 52` 的顺序应挂成 `36 -> 31 -> 42 -> 47`，先补状态词层，再补 lifecycle object，再进入本批的 liveness budget 层。

## 后续继续深入时的检查问题

1. 我当前讲的是 work discovery cadence，还是 error budget？
2. 我当前讲的是 heartbeat keepalive，还是 backoff UI？
3. 我是不是又把 `reconnecting` 写成了 child session timeout？
4. 我是不是又把 sleep reset 写成了恢复成功？
5. 我是不是又把 `poll_due` 这种内部原因抬成正文主角？
6. 我是不是又把 poll config 写回了参数大全？

只要这六问没先答清，下一页继续深入就会重新滑回：

- retry 语义混写
- 或实现参数污染正文

而不是用户真正可用的 bridge host-liveness 正文。
