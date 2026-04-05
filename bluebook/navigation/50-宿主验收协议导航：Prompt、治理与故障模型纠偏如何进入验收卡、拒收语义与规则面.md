# 宿主验收协议导航：Prompt、治理与故障模型纠偏如何进入验收卡、拒收语义与规则面

这一篇不再回答“宿主迁移失真该怎样纠偏”，而是回答：

- 当 `compiled request truth`、`governance control plane object` 与结构真相面的纠偏顺序、拒收规则与模板骨架已经被写出来之后，宿主、SDK、CI 与交接系统到底该消费哪些正式验收对象、拒收语义与规则字段，才能不重新退回经验判断。

它主要回答五个问题：

1. 为什么宿主迁移纠偏层之后，蓝皮书仍需要单独讨论“宿主验收协议层”。
2. 为什么 Prompt 线如果不继续压成 `compiled request truth`、`section registry`、`protocol transcript health` 与 `continue qualification` 的正式验收协议，就会重新退回截图交接与黑箱灰度。
3. 为什么治理线如果不继续压成 authority source、permission ledger、decision window、continuation gate 与 rollback object 的正式验收协议，就会重新退回 mode 面板与仪表盘。
4. 为什么结构线如果不继续压成 authority state、resume order、recovery boundary、writeback path 与 anti-zombie projection 的正式验收协议，就会重新退回 pointer、成功率与作者口述。
5. 怎样用苏格拉底式追问避免把这层写成“更细的 schema 汇总”。

## 1. Prompt 宿主验收协议线

适合在这些问题下阅读：

- 宿主、SDK、CI 与交接系统到底该围绕哪些正式对象验收 Prompt 接入，而不是继续围绕截图、摘要与 token 曲线判断。
- 哪些 reject reason 一旦出现就说明 Prompt 世界已经重新长出第二真相。

稳定阅读顺序：

1. `../api/54`
2. `../guides/57`
3. `../casebooks/28`

这条线的核心不是：

- 再讲一次 Prompt 纠偏

而是：

- 把 Prompt 纠偏真正压成宿主可消费的验收卡、拒收语义与规则面

## 2. 治理宿主验收协议线

适合在这些问题下阅读：

- 宿主、SDK、CI 与交接系统到底该围绕哪些正式对象验收统一定价控制面，而不是继续围绕 mode、弹窗与 token 图表判断。
- 哪些 reject reason 一旦出现就说明治理对象已经退回界面投影。

稳定阅读顺序：

1. `../api/55`
2. `../guides/58`
3. `../casebooks/29`

这条线的核心不是：

- 再讲一次治理纠偏

而是：

- 把治理纠偏真正压成宿主可消费的验收卡、拒收语义与规则面

## 3. 故障模型宿主验收协议线

适合在这些问题下阅读：

- 宿主、SDK、CI 与交接系统到底该围绕哪些正式对象验收结构真相面，而不是继续围绕 pointer、成功率与作者说明判断。
- 哪些 reject reason 一旦出现就说明恢复资产已经篡位、writeback 已经分叉或 anti-zombie 结果面已经缺席。

稳定阅读顺序：

1. `../api/56`
2. `../guides/59`
3. `../casebooks/30`

这条线的核心不是：

- 再讲一次结构纠偏

而是：

- 把结构纠偏真正压成宿主可消费的验收卡、拒收语义与规则面

## 4. 为什么这层更适合落在 api

因为这一层最关键的问题已经不是：

- 先修什么
- 哪种现象在说谎

而是：

1. 哪些对象必须被宿主正式消费。
2. 哪些字段必须是必填，而不是建议项。
3. 哪些 reject reason 应该跨宿主、CI、评审与交接共享。
4. 哪些内部实现不应被当成公共契约。

这些都更接近：

- host-consumable 的 contract 层与规则面层

## 5. 苏格拉底式自检

在你准备宣布“宿主验收协议已经完整”前，先问自己：

1. 我定义的是对象级 contract，还是一组更详细的经验判断。
2. 这些 reject reason 能否跨宿主、CI、评审与交接共享。
3. 宿主消费的是正式规则面，还是内部实现偶然泄漏出来的细节。
4. 如果 later 内部重构发生，这套验收协议是否仍然成立。
