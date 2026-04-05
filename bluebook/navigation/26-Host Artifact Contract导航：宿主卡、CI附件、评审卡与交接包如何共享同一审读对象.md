# Host Artifact Contract导航：宿主卡、CI附件、评审卡与交接包如何共享同一审读对象

这一篇不新增新的制度判断，而是回答一个更接近宿主实现、CI 接线与团队协作现场的问题：

- 当团队已经有 host implementation audit guide 之后，怎样把这些审读模板继续压成正式工件协议，让宿主卡、CI 附件、评审卡与交接包不再各自长出一套不同字段。

它主要回答四个问题：

1. 为什么 Host Implementation 审读模板层之后仍需要单独讨论 host artifact contract 层。
2. 为什么 Prompt、治理与结构三条线都需要把 shared header 继续翻译成正式工件协议。
3. 怎样让宿主卡、CI 附件、评审卡与 handoff package 共享同一审读对象，只保留不同展开深度。
4. 怎样用苏格拉底式追问避免把这层写成“更多字段”和“更多表单”。

## 1. Prompt Host Artifact Contract

适合在这些问题下阅读：

- 怎样让 Prompt 线的宿主卡、CI 附件、评审卡与 handoff package 都围绕 compiled request truth、stable bytes、lawful forgetting ABI 与 next-step guard 生成。
- 怎样避免 Prompt 工件再次退回原文 prompt、宿主卡片、CI 绿灯与摘要包四套局部真相。

稳定阅读顺序：

1. `25`
2. `../api/37`

这条线的核心不是：

- 再补一份 Prompt 审读模板

而是：

- 把 Prompt implementation 的 shared header 升格成正式工件协议

## 2. 治理 Host Artifact Contract

适合在这些问题下阅读：

- 怎样让治理线的宿主卡、CI 附件、评审卡与 handoff package 都围绕 current object、decision window、winner source、failure semantics 与 rollback object 生成。
- 怎样避免治理工件再次退回仪表盘、阈值图、审批记录与口头交接四套局部 KPI。

稳定阅读顺序：

1. `25`
2. `../api/38`

这条线的核心不是：

- 再补一轮治理审读心法

而是：

- 把治理 implementation 的 shared header 升格成正式工件协议

## 3. 结构 Host Artifact Contract

适合在这些问题下阅读：

- 怎样让结构线的宿主卡、CI 附件、评审卡与 handoff package 都围绕 authoritative path、recovery asset ledger、anti-zombie evidence、retained assets 与 rollback object 生成。
- 怎样避免结构工件再次退回目录图、恢复成功率、规则说明与作者讲解四套局部真相。

稳定阅读顺序：

1. `25`
2. `../api/39`

这条线的核心不是：

- 再补一份结构审读模板

而是：

- 把结构 implementation 的 shared header 升格成正式工件协议

## 4. 一句话用法

如果：

- `25` 回答“怎样统一审读”

那么：

- `26` 回答“怎样把统一审读真正落成宿主卡、CI 附件、评审卡与交接包的正式协议”

## 5. 苏格拉底式自检

在你准备宣布“团队已经拥有统一 host artifact contract”前，先问自己：

1. 四类工件共享的是同一审读对象，还是只是名字看起来相似的四套表单。
2. 哪些字段是真正的 shared contract，哪些只是某个角色的展开投影。
3. 我是在减少不同角色之间的未来分歧，还是在制造新的字段装饰。
4. 如果原作者离开，后来者是否还能仅凭这些工件独立完成判断、回退与交接。
