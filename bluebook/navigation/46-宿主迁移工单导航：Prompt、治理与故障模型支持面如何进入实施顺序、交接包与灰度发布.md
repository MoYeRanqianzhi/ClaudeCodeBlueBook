# 宿主迁移工单导航：request compiler、governance key 与 current-truth writeback 如何进入实施顺序、交接包与灰度发布

这篇聚焦迁移次序本身。

- 核心问题不是再列一份接入清单，而是当 `request compiler / message lineage / projection consumer / continuation qualification`、`governance key / externalized truth chain / decision window / continuation pricing` 与 `current-truth surface / current-truth writeback / freshness gate / ghost capability` 已经成立后，团队该按什么顺序把它们写进宿主、CI 与交接系统，才不会重新制造第二真相。
- 读这篇时要抓住四个门槛：哪一个对象必须先成为 single source、哪一种投影只能先只读开放、哪一种控制权必须后开放、哪一种继续/回退资格一旦抢跑就会让旧世界重新篡位。

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

- 把 Prompt 宿主接入重新写成从 request compiler 输入面、消息血缘冻结、协议转录、缓存解释到继续资格的正式迁移工单

## 2. 治理宿主迁移工单线

先问：

- 怎样把宿主从 mode、仪表盘与提示文案，迁到 governance key、externalized truth chain、decision window、continuation pricing 与 cleanup 的正式消费。
- 怎样把治理审读结论继续压成迁移顺序、交接包与灰度发布门禁。

成立证据：

1. `../guides/55`
2. `../playbooks/30`
3. `../api/52`

这条线的核心不是：

- 再堆一遍治理字段或控制台名词

而是：

- 把治理宿主接入重新写成 governance key、externalized truth chain、typed ask、decision window、continuation pricing 与 durable-vs-transient cleanup 的正式迁移工单，并禁止 host 从 mode 条、token 条与 `pending_action` 文案反推当前真相

## 3. 当前真相保护宿主迁移工单线

先问：

- 怎样把宿主从状态猜测、pointer 神化与恢复成功率，迁到 current-truth surface、current-truth writeback、freshness gate、recovery asset non-sovereignty 与 ghost capability 结果面的正式消费。
- 怎样把结构审读结论继续压成迁移顺序、交接包与灰度发布门禁。

成立证据：

1. `../guides/56`
2. `../playbooks/31`
3. `../api/53`

这条线的核心不是：

- 再做一次恢复演练

而是：

- 把当前真相保护宿主接入重新写成 current-truth surface、current-truth writeback、recovery asset non-sovereignty、freshness gate 与 ghost capability 结果面的正式迁移工单

## 4. 迁移工单必须守住的门槛

真正要命的不是工单写得不够长，而是对象进入宿主前没有先过门槛：

1. 前置单一真相
   - 老宿主应先拆哪一层旧假设，哪个对象必须先成为 single source。
2. 只读投影优先
   - 灰度时应先开放哪一种 read-only projection，先让宿主、CI 与交接系统学会消费同一真相。
3. 控制权后开放
   - 哪一种 approve / continue / rollback / recovery control 必须等到前两步稳定后才配开放。
4. 继续资格最后发放
   - 哪些 continuation、回退与恢复资格一旦提前发放，就会让旧主语重新越权。
5. 最小交接包
   - 交接包至少要带哪些正式对象，才能不重新退回口头交接。

### 顺序错了会怎样

迁移最常见的失败，不是对象不存在，而是顺序倒了：

1. 先开放控制权、后统一真相
   - 结果是每个宿主都带着旧假设宣布自己理解对了。
2. 先发继续资格、后做只读投影
   - 结果是系统继续了，但没有任何消费者还围绕同一对象继续。
3. 先交接摘要、后补正式对象
   - 结果是交接包看起来完整，实际上没有 single source 可供后续灰度与回退复用。

## 5. 苏格拉底式自检

在你准备宣布“宿主迁移方案已经完整”前，先问自己：

1. 我写的是对象迁移顺序，还是又一份功能接入清单。
2. 交接包里留下的是正式对象，还是一段摘要和几张截图。
3. 灰度时我先开放的是只读真相面，还是过早开放了继续、回退与恢复控制权。
4. 如果后续内部重构发生，宿主、CI 与交接系统是否还能继续围绕同一机制对象工作。
