# authoritative idle signal 拆分记忆

## 本轮继续深入的核心判断

96 已经把 `drainSdkEvents()` 的 flush ordering 拆出来了。

下一步最自然不是继续讲 flush 站位，而是继续往下压到：

- 这些 flush 最终为什么让 `session_state_changed(idle)` 变成 authoritative turn-over signal

因为这才是 96 那些顺序安排真正服务的目标。

## 为什么这轮必须把 idle signal 单列

如果不单列，读者会把 96 的结论停在：

- 这里有多次 drain

但更深一层真正关键的事实是：

- 多次 drain 不是目的
- 它们是在共同保护 idle 的可信度

## 本轮最关键的新判断

### 判断一：`heldBackResult` 是 idle 不得抢跑的最直接证据

没有它，这页会很容易被写成普通 finally 语义。

### 判断二：bg-agent do-while 退出是 idle 的外延前置条件

idle 不是 run() 局部结束，而是回合外延结束。

### 判断三：late task bookend 也属于 idle 合同的一部分

这句很值钱，因为它能把“后台 teardown 收口”也纳进 turn-over 定义。

### 判断四：`lastMessage` 过滤证明 idle 要“及时但不篡位”

这能把 host signal 和主结果语义同时守住。

### 判断五：authoritative idle 不是我从注释推出来的，而是 SDK schema 也明写了

这条补证很值钱，因为它把 97 从“运行时实现判断”升级成了“对外 schema 契约也重复声明”的结论。

## 为什么这轮不并回 96

96 讲 flush ordering。
97 讲 idle semantics。

主语再次变窄，不该揉回去。

## 苏格拉底式自审

### 问：为什么这轮最先该拆 `heldBackResult`？

答：因为它最直接地否定了“finally 到了就能 idle”的直觉。

### 问：为什么 late bookend 值得进入正文？

答：因为它说明 idle 的收口对象不仅是主结果，还包括后台 teardown 的补尾状态。

### 问：为什么 `lastMessage` 过滤能成为本页关键证据？

答：因为它证明系统追求的是“宿主可信任的 idle”，而不是“让 idle 变成最终主消息”。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/97-heldBackResult、bg-agent do-while、notifySessionStateChanged(idle)、lastMessage 与 authoritative turn over：为什么 headless print 的 idle 不是普通 finally 状态切换.md`
- `bluebook/userbook/03-参考索引/02-能力边界/86-Headless print authoritative idle signal 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/97-2026-04-06-authoritative idle signal 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小改动：

- 长文层只补 97
- 索引层只补 86
- 记忆层只补 97

不把 96-97 重新揉成一篇大的 idle/shutdown 总论。

## 下一轮候选

1. 单独拆 `lastMessage stays at the result` 为什么要排除 late-drained SDK-only system events。
2. 单独拆 `heldBackResult` 与 suggestionState 的关系，解释为什么 suggestion 也要等主结果真正发出后再记账。
3. 单独拆 headless `print` 的 idle 信号与 bridge/SDK consumer 的存活语义。
