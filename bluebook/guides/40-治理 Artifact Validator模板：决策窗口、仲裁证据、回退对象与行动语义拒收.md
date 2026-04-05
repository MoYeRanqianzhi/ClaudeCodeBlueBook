# 治理 Artifact Validator模板：决策窗口、仲裁证据、回退对象与行动语义拒收

这一章不再解释治理 artifact 为什么重要，而是把它压成团队可复用 validator / linter 模板。

它主要回答五个问题：

1. 怎样判断治理 artifact 是否真的围绕同一 `governance object`、同一 `decision window` 与同一 `rollback object` 成立，而不是围绕状态色、计数与 verdict 成立。
2. 怎样把 `shared header`、`arbitration truth`、`failure semantics` 与 `handoff reject rule` 放进同一张校验卡。
3. 怎样让宿主、CI、评审与交接沿同一校验顺序消费治理 artifact。
4. 怎样识别“仪表盘转绿、审批结束、token 安全、交接写了状态”这类看似合规的漂移。
5. 怎样用苏格拉底式追问避免把治理 validator 退回 KPI 检查。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:235-1283`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts:244-300`
- `claude-code-source-code/src/query/tokenBudget.ts:1-82`
- `claude-code-source-code/src/utils/toolResultStorage.ts:367-860`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/utils/sessionState.ts:92-146`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

这些锚点共同说明：

- 安全设计与省 token 设计不是两套校验体系，而是同一条治理判断链在不同窗口上对“是否还有决策增益”的统一拒收机制。

## 1. 第一性原理

更成熟的治理 validator 不是：

- 面板更多

而是：

- 一旦没有 decision gain，系统会比人更早拒绝继续烧 token、继续看颜色、继续拖延交接

所以审读治理 artifact 时，最该先问的不是：

- 现在是不是已经转绿

而是：

- 当前这轮判断是否仍围绕同一个 `governance_object_id`

## 2. Governance Validator Header

任何治理 artifact validator 都先锁这一组 shared header：

```text
artifact_line_id:
governance_object_type:
governance_object_id:
current_state:
authority_source:
observed_window:
decision_window:
winner_source:
control_arbitration_truth:
context_usage_breakdown:
failure_semantics:
rollback_object:
object_upgrade_rule:
next_action:
```

团队规则：

1. 没有 `decision_window` 的治理卡，直接 `hard fail`。
2. 没有 `winner_source` 或 `control_arbitration_truth` 的仲裁结论，不算正式治理证据。
3. 没有 `rollback_object` 与 `next_action` 的交接卡，直接 `reject`。
4. 四类工件的 `governance_object_id`、`decision_window` 不一致，直接判定 `governance split-brain`。

## 3. Host Dashboard Gate

先审宿主是不是在消费判断链，而不是结果面：

```text
[ ] current_state 是否伴随 governance_object_id 展示
[ ] observed_window / decision_window 是否并排展示
[ ] rollback_object 是否已展示
[ ] next_action 是否已展示
[ ] 是否避免用状态色替代对象与窗口
```

直接判 drift 的情形：

1. 宿主只展示 `green / blocked / done`，没有 `decision_window`。
2. 宿主只展示 allow / deny，没有 `rollback_object`。
3. 宿主展示的是局部 KPI，而不是当前治理对象。

## 4. Arbitration Gate

任何仲裁附件都必须先证明它维护的是判断链，而不是统计面板：

```text
[ ] winner_source 是否存在
[ ] control_arbitration_truth 是否存在
[ ] failure_semantics 是否存在
[ ] object_upgrade_rule 是否存在
[ ] 计数与阈值是否仍能回到同一 governance object
```

团队规则：

1. ask 次数不能替代 `winner_source`。
2. token、latency、阈值图不能替代 `control_arbitration_truth`。
3. 审批结束不能替代 `failure_semantics`。

## 5. Context Usage 与升级闸门

治理 validator 必须同时审 `Context Usage` 和 `object upgrade`：

```text
[ ] context_usage_breakdown 是否能解释当前成本
[ ] 当前继续花 token 是否仍有 decision gain
[ ] object_upgrade_rule 是否点名
[ ] 不升级的风险是否点名
[ ] rollback_object 是否随升级同步更新
```

核心原则不是：

- 更省一点 token

而是：

- 在没有决策增益时，正式拒绝免费扩张

## 6. Review / Handoff Reject Gate

评审与交接必须围绕同一治理对象继续判断：

```text
[ ] review judgement 是否回链到 decision_window
[ ] review judgement 是否回链到 failure_semantics
[ ] handoff 是否写清 rollback_object
[ ] handoff 是否写清 next_action
[ ] 不读历史时，接手者是否仍知道该等、该退、该升对象
```

直接拒收条件：

1. 交接包只有状态总结，没有 `rollback_object`。
2. 交接包只有“现在卡住了”，没有 `next_action`。
3. 评审卡只有 verdict，没有 `decision_window` 与 `failure_semantics`。

## 7. Validator 输出等级

```text
HARD FAIL:
- governance_object_id 缺失或跨工件不一致
- decision_window 缺失
- rollback_object 缺失

LINT WARN:
- Context Usage 有图无判断
- 宿主只剩状态色
- 评审卡只剩 verdict

REWRITE TARGET:
- dashboard / arbitration attachment / review card / handoff package
```

真正成熟的治理 validator 不只是：

- 让颜色更可信

而是：

- 让没有判断链的颜色、计数与摘要根本不能继续夺权

## 8. 苏格拉底式检查清单

在你准备宣布“治理 artifact validator 已经成立”前，先问自己：

1. 我现在消费的是同一 decision window，还是只是在看结果有没有转绿。
2. 这次多花的 token 还能改变什么判断，还是只是在继续拖延。
3. arbitration truth 是否已经被统计面板偷换。
4. rollback object 是否已经比“先继续试试”更早被定义。
5. 如果删掉原作者解释，后来者是否仍能沿同一治理对象继续。
