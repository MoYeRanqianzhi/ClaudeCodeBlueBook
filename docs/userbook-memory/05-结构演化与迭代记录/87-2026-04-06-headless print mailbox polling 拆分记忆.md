# headless print mailbox polling 拆分记忆

## 本轮继续深入的核心判断

86 页已经把 `print` 的 team drain 协议拆开了。

下一步最自然不是再继续围绕 `SHUTDOWN_TEAM_PROMPT` 写更大总论，而是继续细拆：

- active teammate polling
- unread mailbox ingestion

因为这条 loop 才是用户最容易误解成“只是 passive inbox reader”的地方。

## 为什么这轮必须把 polling loop 单列

如果不单列，读者会把 86 的 drain 协议和 87 这条 polling loop 混成一句：

- input 关闭后，print 会等一等再退出

这太粗了。

更精确的真实结构是：

- 86 解释为什么它必须 drain
- 87 解释它在 drain 期间如何持续吸收 teammate mailbox 并折返进主 run loop

## 本轮最关键的新判断

### 判断一：loop 的持续条件是 active teammates，不是 unread

这意味着 headless print 不是“有信就处理、没信就停”，而是“只要 swarm 还活着，就持续等信”。

### 判断二：unread 在 print 里会被直接并回主 run loop

它不是先进本地 inbox `pending/processed` 状态机，而是：

- mark read
- format
- enqueue
- run

### 判断三：这条 loop 是 headless swarm runtime 的 ingestion loop

因此它更像宿主运行时的一部分，而不是额外附带的 inbox reader。

### 判断四：87 不应把 84/86 重新讲一遍

84 讲 host-path comparison，86 讲 team drain，87 讲 active polling + unread ingestion。三者必须保持分工。

## 苏格拉底式自审

### 问：为什么这轮不继续比较 print 和 useInboxPoller 的所有差异？

答：因为这轮主轴不是一般比较，而是 print 自己这条 loop 的语义。和 `useInboxPoller` 的差异只作为边界辅助，不作为主线。

### 问：为什么不把 `POLL_INTERVAL_MS` 放到正文核心？

答：因为 500ms 是实现参数，不是公开合同。正文核心是“以 active teammates 为持续条件”的 loop 语义。

### 问：为什么 87 值得单独成文，而不是附到 86 最后？

答：因为 86 讲 stop/drain 语义，87 讲 polling/ingestion 语义。前者回答“为什么不退出”，后者回答“它在等待期间具体怎么运作”。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/87-readUnreadMessages、markMessagesAsRead、enqueue、run、hasActiveInProcessTeammates 与 POLL_INTERVAL_MS：为什么 headless print 的 active teammate polling 不是被动 inbox reader.md`
- `bluebook/userbook/03-参考索引/02-能力边界/76-Headless print active teammate polling and unread mailbox loop 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/87-2026-04-06-headless print mailbox polling 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小改动：

- 长文层只补 87
- 索引层只补 76
- 记忆层只补 87

不把 81-87 重新揉成一篇大而散的 shutdown / headless 总论。

## 下一轮候选

1. 把 81-87 压成一张 termination family 七层导航图。
2. 单独拆 teammate pill strip、spinner tree、detail dialog 三种前台状态面的厚度差。
3. 单独拆 `print` 的 queue drain re-entry 与 `peek(isMainThread)` 保护语义。
