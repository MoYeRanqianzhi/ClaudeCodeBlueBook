# 宿主迁移工单导航：message lineage、governance key 与 current-truth surface 如何进入实施顺序、交接包与灰度发布

这篇聚焦迁移次序本身。

- 核心问题不是再列一份接入清单，而是当 `message lineage / projection consumer / continuation qualification`、`governance key / externalized truth chain / decision window / continuation pricing` 与 `current-truth surface / freshness gate / ghost capability` 已经成立后，团队该按什么顺序把它们写进宿主、CI 与交接系统，才不会重新制造第二真相。
- 读这篇时要抓住三件事：哪一个对象必须先成为 single source、哪一种控制权必须后开放、哪一种交接包一旦缺失就会把系统重新推回口头交接。

## 1. Prompt 宿主迁移工单线

先问：

- 怎样把宿主从 `systemPrompt` 字符串、raw transcript 与 summary 崇拜，迁到 `message lineage / protocol transcript / continuation object` 的正式消费。
- 怎样把 Prompt 审读结论继续压成迁移顺序、交接包与灰度发布门禁。

成立证据：

1. `../guides/54`
2. `../playbooks/29`
3. `../api/51`

这条线的核心不是：

- 再做一次 Prompt 排查

而是：

- 把 Prompt 宿主接入重新写成从消息血缘冻结、协议转录、缓存解释到继续资格的正式迁移工单

## 2. 治理宿主迁移工单线

先问：

- 怎样把宿主从 mode、仪表盘与提示文案，迁到 governance key、externalized truth chain、decision window、continuation pricing 与 cleanup 的正式消费。
- 怎样把治理审读结论继续压成迁移顺序、交接包与灰度发布门禁。

成立证据：

1. `../guides/55`
2. `../playbooks/30`
3. `../api/52`

这条线的核心不是：

- 再讲一遍统一定价治理

而是：

- 把治理宿主接入重新写成 governance key、externalized truth chain、typed ask、decision window、continuation pricing 与 durable-vs-transient cleanup 的正式迁移工单

## 3. 当前真相保护宿主迁移工单线

先问：

- 怎样把宿主从状态猜测、pointer 神化与恢复成功率，迁到 current-truth surface、freshness gate、recovery boundary 与 ghost capability 结果面的正式消费。
- 怎样把结构审读结论继续压成迁移顺序、交接包与灰度发布门禁。

成立证据：

1. `../guides/56`
2. `../playbooks/31`
3. `../api/53`

这条线的核心不是：

- 再做一次恢复演练

而是：

- 把故障模型宿主接入重新写成 current-truth surface、writeback 主路径、恢复资产边界、freshness gate 与 ghost capability 结果面的正式迁移工单

## 4. 迁移工单必须守住的门槛

真正要命的不是工单写得不够长，而是对象进入宿主前没有先过门槛：

1. 前置单一真相：老宿主应先拆哪一层旧假设，哪个对象必须先成为 single source。
2. 最小交接包：交接包至少要带哪些对象，才能不重新退回口头交接。
3. 灰度开放顺序：灰度时先开放哪一种只读投影，后开放哪一种控制权。
4. 禁止提前开放：哪些继续、回退与恢复控制一旦抢跑，就会重新制造第二真相。

## 5. 苏格拉底式自检

在你准备宣布“宿主迁移方案已经完整”前，先问自己：

1. 我写的是对象迁移顺序，还是又一份功能接入清单。
2. 交接包里留下的是正式对象，还是一段摘要和几张截图。
3. 灰度时我先开放的是只读真相面，还是过早开放了继续、回退与恢复控制权。
4. 如果后续内部重构发生，宿主、CI 与交接系统是否还能继续围绕同一机制对象工作。
