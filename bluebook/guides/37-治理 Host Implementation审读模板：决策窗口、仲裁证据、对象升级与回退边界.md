# 治理 Host Implementation审读模板：决策窗口、仲裁证据、对象升级与回退边界

这一章不再解释治理 host implementation 为什么重要，而是把它压成团队可复用审读模板。

它主要回答五个问题：

1. 怎样判断治理 implementation 是否真的围绕 decision window、control arbitration 与 rollback object 成立，而不是围绕仪表盘与按钮结果成立。
2. 怎样把 Context Usage、failure semantics、object-upgrade gate 与 handoff gate 放进同一张审读卡。
3. 怎样让宿主、CI、评审与交接沿同一审读顺序消费治理 implementation。
4. 怎样识别“仪表盘转绿、审批结束、阈值安全、回退开关存在”这类看似合规的假实现。
5. 怎样用苏格拉底式追问避免把安全与省 token 审读退回 KPI 评论。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:235-1283`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts:244-300`
- `claude-code-source-code/src/query/tokenBudget.ts:1-82`
- `claude-code-source-code/src/utils/toolResultStorage.ts:367-860`
- `claude-code-source-code/src/utils/sessionState.ts:92-146`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

这些锚点共同说明：

- 安全与省 token 不是两套独立优化，而是同一条治理判断链在不同资产、不同窗口上的统一定价问题。

## 1. 第一性原理

更成熟的治理 implementation 不是：

- 仪表盘更全

而是：

- 不同角色在不同时间点，仍然依赖同一 decision window、同一 arbitration truth 与同一 rollback boundary 继续判断

所以审读治理 implementation 时，最该先问的不是：

- 现在是不是已经转绿

而是：

- 当前这轮判断到底还有没有决策增益

## 2. Governance Implementation Header

任何治理 implementation 审读都先填这一张统一 header：

```text
审读对象:
current object:
current state:
authority source:
control arbitration truth:
observed window:
decision window:
Context Usage:
failure semantics:
rollback object:
object-upgrade rule:
next action:
```

团队规则：

1. 没有 decision window 的治理卡，不算正式治理卡。
2. 没有 winner source 的审批结论，不算正式仲裁证据。
3. 没有 rollback object 的 handoff，不算正式治理交接。

## 3. Host Dashboard Audit

先审宿主是不是在消费判断链，而不是结果面：

```text
[ ] 宿主展示 current object，而不是只展示 allow / deny
[ ] observed window 已点名
[ ] decision window 已点名
[ ] current state 与 blocked state 已并排展示
[ ] rollback object 已展示
```

常见假实现：

1. 只展示状态，不展示窗口。
2. 只展示 percentage，不展示 blocked state 与 pending action。
3. 只展示结果，不展示回退对象。

宿主审读的关键不是“面板够不够丰富”，而是：

- 它有没有把治理重新压成结果 dashboard

## 4. Arbitration Audit

审批与治理结论必须先过仲裁审读：

```text
[ ] winner source 已点名
[ ] loser cancel 已点名
[ ] request / response / cancel 链已点名
[ ] waiting time 已点名
[ ] authority source 能解释最终 judgement
```

团队规则：

1. ask 次数不能替代 arbitration truth。
2. 审批结束不能替代 winner source。
3. “现在已经放行”不能替代 failure semantics。

## 5. Context Usage Audit

Context Usage 必须和运行态一起消费：

```text
[ ] percentage 已展示
[ ] message / tool / memory breakdown 已展示
[ ] blocked state 已展示
[ ] near-capacity 建议已展示
[ ] pending action 已展示
```

如果它只剩一张成本图，那么治理 implementation 已经退回：

- 局部 KPI

## 6. Object Upgrade Audit

治理 implementation 更稳的升级顺序是：

1. 先问 decision gain 是否仍存在
2. 再问当前 object 是否仍值得继续
3. 再问是否应升级到 compact / task / worktree / session
4. 最后才决定继续烧 token

对象升级审读卡：

```text
[ ] object-upgrade rule 是否点名
[ ] 触发器是否点名
[ ] 不升级的风险是否点名
[ ] 升级后保留资产是否点名
[ ] rollback object 是否同步更新
```

## 7. Rollback Boundary Audit

治理实现不能只靠回退开关存在：

```text
[ ] rollback object 已点名
[ ] retained assets 已点名
[ ] re-entry 条件已点名
[ ] failure semantics 与 rollback boundary 一致
[ ] 交接里能直接继续判断
```

任何“先继续再说，坏了再退”的默认策略，都应被判定为：

- 治理 implementation 失真

## 8. 常见自欺

看到下面信号时，应提高警惕：

1. 用仪表盘转绿替代 decision window。
2. 用审批结束替代 arbitration truth。
3. 用阈值安全替代 Context Usage 判断。
4. 用回退开关存在替代 rollback object。
5. 用“功能没出错”替代 failure semantics。

## 9. 审读记录卡

```text
审读对象:
current object:
decision window:
winner source:
Context Usage:
failure semantics:
rollback object:
object-upgrade rule:
当前最像哪类失真:
- 转绿替代判断 / 审批替代仲裁 / 阈值替代窗口 / 回退开关替代对象
下一步应重写的是:
- dashboard / arbitration trace / context panel / rollback handoff
```

## 10. 苏格拉底式检查清单

在你准备宣布“治理 host implementation 已经成立”前，先问自己：

1. 我现在消费的是 decision window，还是只是在看结果是否转绿。
2. 这次审批结束，是否真的等于仲裁真相已经成立。
3. 当前多花的 token 还能改变什么判断，还是只是继续拖延。
4. rollback object 是否已经比“先继续一下试试”更早被定义。
5. 我统一的是治理 implementation 真相，还是只统一了一套 dashboard。
