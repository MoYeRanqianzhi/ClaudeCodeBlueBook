# 治理 Artifact反例：窗口卡退回状态色、仲裁附件退回计数与交接包失去回退对象

这一章不再收集“治理 contract 本身设计错”的反例，而是收集治理 artifact 已经存在之后最常见的工件级失真样本。

它主要回答五个问题：

1. 为什么治理 artifact 明明已经有窗口卡、仲裁附件、评审卡与交接包，团队仍然会退回状态色、阈值、审批计数与状态摘要四套局部 KPI。
2. 为什么治理 artifact 最容易被退化成“看起来都有材料，但判断链已经断掉”。
3. 哪些坏解法最容易让 decision window、winner source、failure semantics 与 rollback object 失去权威。
4. 怎样把这些坏解法改写回 Claude Code 式共享 artifact 消费。
5. 怎样用苏格拉底式追问避免把这一章读成“有人没按流程填卡”。

## 0. 第一性原理

治理 artifact 层最危险的，不是：

- 没有工件

而是：

- 工件已经存在，却只剩不同面板和不同结论，没有人再围绕同一 governance object 继续判断

这样一来，系统虽然已经能要求：

1. `governance_object_id`
2. `decision_window`
3. `winner_source`
4. `failure_semantics`
5. `rollback_object`
6. `object_upgrade_rule`

团队却依旧回到：

- 看颜色
- 看阈值
- 看 ask 次数
- 看状态摘要

## 1. 窗口卡退回状态色 vs decision window

### 坏解法

- 宿主卡虽然存在，但主要展示绿色/红色、blocked/unblocked，不再展示 `decision_window` 与 `next_action`。

### 为什么坏

- 状态色只能说明“看起来怎么样”，不能说明“这轮还能改变什么判断”。
- 一旦 `decision_window` 从宿主卡消失，治理对象就会退回结果面。
- 后来者会把等待误解成停滞，把停滞误解成失败。

### Claude Code 式正解

- 宿主卡必须先锁 `governance_object_id`、`decision_window`、`rollback_object` 与 `next_action`。
- 颜色只能是 projection，不能替代窗口。

### 改写路径

1. 把颜色降为辅助字段。
2. 把 `decision_window` 提到宿主卡第一段。
3. 强制宿主卡回答“当前还能改变什么判断”。

## 2. CI 附件退回阈值与计数 vs arbitration / failure semantics

### 坏解法

- CI 附件虽然存在，但主要只给 token 阈值、latency 阈值、ask 次数，不再给 `control_arbitration_truth` 与 `failure_semantics`。

### 为什么坏

- 阈值和次数只能告诉你成本面，不能告诉你谁赢了仲裁、失败会退化到哪里。
- 没有 arbitration truth，CI 附件会退回统计附件。
- 没有 failure semantics，CI 会重新退回事后解释。

### Claude Code 式正解

- CI 附件必须同时给出 `winner_source`、`control_arbitration_truth`、`failure_semantics` 与 `object_upgrade_rule`。
- 统计只能帮助解释，不能替代判断链。

### 改写路径

1. 把 `winner_source` 固定为 CI 附件前段字段。
2. 把 failure semantics 从日志中提升为正式列。
3. 任何只有计数没有仲裁链的附件都判为 drift。

## 3. 评审卡退回 verdict 说明 vs governance object

### 坏解法

- 评审卡虽然存在，但 reviewer 主要写“这轮应该放行/阻断”，不再点名 `governance_object_id`、`decision_window` 与 `rollback_object`。

### 为什么坏

- verdict 是判断结果，不是判断对象。
- 一旦评审卡不再锁 object 和 window，它就会退回意见卡。
- 后来者会得到结论，却得不到结论成立的前提。

### Claude Code 式正解

- 评审卡必须先回答 object、window、winner、failure semantics，再给出 verdict。
- verdict 只能是 shared header 的投影。

### 改写路径

1. 把 `governance_object_id` 与 `decision_window` 固定为评审卡第一段。
2. 要求 verdict 必须引用 shared header。
3. 把“建议”降到 object judgement 之后。

## 4. 交接包失去回退对象 vs next action

### 坏解法

- 交接包虽然存在，但主要只说明“当前卡住了”“等用户反馈”，不再给 `rollback_object`、`next_action` 与 `re_entry_conditions`。

### 为什么坏

- 这会让交接重新退回状态摘要。
- 没有 rollback object，后来者无法判断失败时退回哪里。
- 没有 next action，后来者无法判断现在该等、该停还是该升级对象。

### Claude Code 式正解

- 交接包必须先交 `governance_object_id`、`decision_window`、`rollback_object`、`next_action`。
- retained assets 只能补充，不得替代这些对象字段。

### 改写路径

1. 把 `rollback_object` 移到交接包第一段。
2. 把 `next_action` 写成正式字段而不是备注。
3. 任何缺 `re_entry_conditions` 的交接包都判为 drift。

## 5. 四件套同时存在却仍然失真

### 坏解法

- 宿主卡、CI 附件、评审卡、交接包四件套都存在，但它们分别围绕颜色、阈值、verdict 与状态摘要，不再共享同一个 governance object。

### 为什么坏

- 这会制造四份彼此相关却互不约束的治理真相。
- 工件存在性会掩盖判断链断裂。
- 团队会误以为 contract 已落地，实际上 shared governance object 已经死亡。

### Claude Code 式正解

- 四件套必须先共享同一个 `artifact_line_id + governance_object_id + decision_window + rollback_object`。
- 差异只允许出现在 projection，不允许出现在 shared header。

### 改写路径

1. 把 shared header 单独抽出来比对。
2. 检查四件套是否围绕同一个 decision window。
3. 任何 rollback object 不一致的工件组都判为 drift。

## 6. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在消费的是同一 governance object，还是颜色、阈值、verdict 与状态摘要四种替身。
2. 这些工件共享的是同一判断链，还是只是都写了治理两个字。
3. 如果失败发生，后来者能否仅靠工件知道该停、该退还是该升级对象。
4. 我是在修工件，还是在重新修回 shared governance object。
