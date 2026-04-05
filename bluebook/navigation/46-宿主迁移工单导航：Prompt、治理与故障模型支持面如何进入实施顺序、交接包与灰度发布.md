# 宿主迁移工单导航：Prompt、治理与故障模型支持面如何进入实施顺序、交接包与灰度发布

这一篇不再回答“宿主接入出了问题该怎样审读”，而是回答：

- 当 `compiled request truth`、`governance control plane object` 与故障模型结果面已经被压成支持面、反例与审读手册之后，团队该怎样把它们继续压成真正能执行的迁移工单、交接包与灰度发布顺序。

它主要回答五个问题：

1. 为什么宿主接入审读层之后，蓝皮书仍需要单独讨论“宿主迁移工单层”。
2. 为什么 Prompt 线如果不继续压成输入面冻结、协议重写、合法遗忘与继续资格的实施顺序，就会重新退回字符串接入。
3. 为什么治理线如果不继续压成 authority source、typed decision、decision window、continuation gate 与 rollback object 的实施顺序，就会重新退回 mode 面板与审批弹窗。
4. 为什么结构线如果不继续压成 authority state、anti-zombie 结果面、recovery boundary 与 writeback 主路径的实施顺序，就会重新退回恢复成功率与作者说明。
5. 怎样用苏格拉底式追问避免把这层写成“另一份迁移 checklist”。

## 1. Prompt 宿主迁移工单线

适合在这些问题下阅读：

- 怎样把宿主从 `systemPrompt` 字符串、raw transcript 与 summary 崇拜，迁到 `compiled request truth` 的正式消费。
- 怎样把 Prompt 审读结论继续压成迁移顺序、交接包与灰度发布门禁。

稳定阅读顺序：

1. `../guides/54`
2. `../playbooks/29`
3. `../api/51`

这条线的核心不是：

- 再做一次 Prompt 排查

而是：

- 把 Prompt 宿主接入重新写成从输入面冻结、协议真相、缓存解释到继续资格的正式迁移工单

## 2. 治理宿主迁移工单线

适合在这些问题下阅读：

- 怎样把宿主从 mode、仪表盘与提示文案，迁到 authority source、decision window、pending action 与 rollback object 的正式消费。
- 怎样把治理审读结论继续压成迁移顺序、交接包与灰度发布门禁。

稳定阅读顺序：

1. `../guides/55`
2. `../playbooks/30`
3. `../api/52`

这条线的核心不是：

- 再讲一遍统一定价治理

而是：

- 把治理宿主接入重新写成 authority source、typed decision、decision window、continuation gate 与 rollback object 的正式迁移工单

## 3. 故障模型宿主迁移工单线

适合在这些问题下阅读：

- 怎样把宿主从状态猜测、pointer 神化与恢复成功率，迁到 authority state、recovery boundary 与 anti-zombie 结果面的正式消费。
- 怎样把结构审读结论继续压成迁移顺序、交接包与灰度发布门禁。

稳定阅读顺序：

1. `../guides/56`
2. `../playbooks/31`
3. `../api/53`

这条线的核心不是：

- 再做一次恢复演练

而是：

- 把故障模型宿主接入重新写成 authority state、writeback 主路径、恢复资产边界与 anti-zombie 结果面的正式迁移工单

## 4. 为什么这层更适合落在 guides

因为这一层最关键的问题已经不是：

- 哪些支持面被误用了
- 哪些症状该排查

而是：

1. 老宿主应先拆哪一层旧假设。
2. 哪个对象必须先成为 single source。
3. 交接包至少要带哪些对象，才能不重新退回作者记忆。
4. 灰度发布时先开放哪一种投影，后开放哪一种控制权。
5. 哪些迁移顺序一旦颠倒，就会重新制造第二真相。

这些都更接近：

- builder-facing 的迁移工单层

## 5. 苏格拉底式自检

在你准备宣布“宿主迁移方案已经完整”前，先问自己：

1. 我写的是对象迁移顺序，还是又一份功能接入清单。
2. 交接包里留下的是正式对象，还是一段摘要和几张截图。
3. 灰度时我先开放的是只读真相面，还是过早开放了继续、回退与恢复控制权。
4. 如果 later 内部重构发生，宿主、CI 与交接系统是否还能继续围绕同一机制对象工作。
