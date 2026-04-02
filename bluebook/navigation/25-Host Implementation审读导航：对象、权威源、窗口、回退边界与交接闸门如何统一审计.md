# Host Implementation审读导航：对象、权威源、窗口、回退边界与交接闸门如何统一审计

这一篇不新增新的制度判断，而是回答一个更接近 builder 与 reviewer 现场的问题：

- 当团队已经有 host implementation playbook，也已经见过 implementation distortion casebook 之后，怎样把这些经验继续压成统一审读模板，让宿主、CI、评审与交接不再各自发明检查顺序。

它主要回答四个问题：

1. 为什么 Host Implementation 实施级失真层之后还必须继续长出 audit guide 层。
2. 为什么 Prompt、治理与结构三条线都需要把“检查点 + 失真样本”继续翻译成统一审读骨架。
3. 怎样让对象、权威源、窗口、回退边界与交接闸门先于 role-specific 视图被审读。
4. 怎样用苏格拉底式追问避免把这层写成“更多 checklist”和“更多流程表格”。

## 1. Prompt Host Implementation 审读模板

如果问题是：

- 怎样审读 Prompt host implementation 是否真的围绕 compiled request truth、stable bytes、lawful forgetting ABI 与 handoff guard 成立。
- 怎样避免宿主卡片、CI 绿灯、评审顺序与摘要包再次把 Prompt 魔力退回文案崇拜。

建议顺序：

1. `24`
2. `../guides/36`

这条线的核心不是：

- 再解释 prompt 为什么强

而是：

- 把 Prompt implementation 的真实审读顺序固定下来

## 2. 治理 Host Implementation 审读模板

如果问题是：

- 怎样审读治理 host implementation 是否真的围绕 decision window、control arbitration、Context Usage、rollback object 与 object-upgrade gate 成立。
- 怎样避免仪表盘转绿、审批结束、阈值安全与回退开关存在重新把治理退回局部 KPI。

建议顺序：

1. `24`
2. `../guides/37`

这条线的核心不是：

- 再补一轮治理总论

而是：

- 把治理 implementation 的真实审读顺序固定下来

## 3. 结构 Host Implementation 审读模板

如果问题是：

- 怎样审读结构 host implementation 是否真的围绕 authoritative path、recovery asset ledger、anti-zombie evidence、retained assets 与 rollback object 成立。
- 怎样避免门禁存在、恢复通过与危险路径口头化重新把源码先进性退回作者记忆。

建议顺序：

1. `24`
2. `../guides/38`

这条线的核心不是：

- 再赞美结构设计得多先进

而是：

- 把结构 implementation 的真实审读顺序固定下来

## 4. 一句话用法

如果：

- `24` 回答“这些检查点在真实执行里最常怎样重新失真”

那么：

- `25` 回答“怎样把这些失真反压成统一审读模板”

## 5. 苏格拉底式自检

在你准备宣布“团队已经会审 host implementation”前，先问自己：

1. 我统一的是判断顺序，还是只统一了表单格式。
2. 审读模板现在先锁的是对象真相，还是先看 role-specific 看板。
3. 哪些字段真的在约束未来判断，哪些只是为通过流程而存在。
4. 如果把原作者和资深 reviewer 都拿掉，后来者还能否沿同一模板做出相同判断。
