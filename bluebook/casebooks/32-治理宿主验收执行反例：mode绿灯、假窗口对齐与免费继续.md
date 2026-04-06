# 治理宿主验收执行反例：mode 绿灯、假窗口对齐与免费继续

这一章不再回答“治理宿主验收执行该怎样运行”，而是回答：

- 为什么团队明明已经写了验收卡、拒收字段和 cleanup 剧本，仍会重新退回 mode 绿灯、审批完成感、token 仪表盘与默认继续。

它主要回答五个问题：

1. 为什么治理宿主验收执行最危险的失败方式不是“没有执行卡”，而是“执行卡存在，却仍围绕交互投影工作”。
2. 为什么 mode 绿灯最容易把 `governance key` 重新退回 mode 名字与界面状态。
3. 为什么假窗口对齐最容易把安全与省 token 同时降格成仪表盘幻觉。
4. 为什么免费继续最容易把 `continuation pricing` 重新退回默认行为。
5. 怎样用苏格拉底式追问避免把这些反例读成“把审批界面再做清楚一点就好”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-619`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1407-1450`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1506-1531`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1735-1747`
- `claude-code-source-code/src/cli/structuredIO.ts:362-657`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:84-645`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:1035-1134`
- `claude-code-source-code/src/utils/permissions/permissions.ts:929-1318`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/utils/analyzeContext.ts:1098-1382`
- `claude-code-source-code/src/query/tokenBudget.ts:22-92`
- `claude-code-source-code/src/utils/QueryGuard.ts:29-121`
- `claude-code-source-code/src/query.ts:1308-1518`

这些锚点共同说明：

- 治理宿主验收执行真正最容易失真的地方，不在卡片有没有 authority、ledger 与 gate 字段，而在执行层是否仍围绕同一个治理对象给安全、成本、时间与 cleanup 定价。

## 1. 第一性原理

治理宿主验收执行最危险的，不是：

- 没有 authority 字段
- 没有 permission ledger
- 没有 cleanup 剧本

而是：

- 这些东西已经存在，却仍然围绕 mode、弹窗、颜色与 token 条运作

一旦如此，团队就会重新回到：

1. 看当前 mode 是什么
2. 看审批是不是点完了
3. 看 token 面板是不是转绿
4. 看还能不能再来一轮

而不再围绕：

1. 谁在声明边界
2. 当前 ask 是什么事务
3. 当前窗口如何解释安全与成本
4. 这轮继续值不值得付这个价格
5. 失败后该清什么、保什么、何时再进入

## 2. mode 绿灯：`governance key` 被 mode 名字替代

### 坏解法

- 宿主、CI 与评审只要看到 mode 名字对了、页面状态转绿，就默认治理主键已经对齐，不再检查 `sources / effective / applied` 是否仍一致。

### 为什么坏

- Claude Code 的治理控制面真正强大之处，在于 `governance key` 决定允许什么、看见什么、继续多久，而不是 mode 标签本身。
- 一旦执行层只看 mode 绿灯，就会重新容忍：
  - source 漂了却没人看见
  - dangerous rule 被 strip 了却以为仍有效
  - external mode 只是投影却被误当主权

### Claude Code 式正解

- `governance key` 应先于 mode 投影被消费；mode 只是结果表达，不是判断本体。

## 3. 假窗口对齐：`decision window` 被仪表盘偷换

### 坏解法

- 执行层只要看到 usage 百分比、剩余空间和压缩次数，就默认窗口已经对齐，不再检查 `status + pending_action + Context Usage` 是否仍属于同一窗口对象。

### 为什么坏

- Claude Code 的安全设计与省 token 设计共用同一个治理窗口；它不是“一个管安全、一个管成本”，而是同一对象在统一定价一切扩张。
- 一旦 `decision window` 被做成仪表盘：
  - 安全会退回审批完成感
  - 成本会退回 token 条颜色
  - 继续会退回“似乎还能跑”

### Claude Code 式正解

- `decision window` 应同时解释 authority、pending action、context usage 与 continuation，而不是只展示 usage 数字。

## 4. 免费继续：`continuation pricing` 被默认行为替代

### 坏解法

- 只要没有硬错误、用户没明确拒绝、token 似乎还够，宿主就默认继续，不再围绕 typed decision 与 decision gain 判断。

### 为什么坏

- Claude Code 的 continuation 机制本质上是在给时间与输出继续定价，而不是给“再试一次”找借口。
- 一旦执行层默认继续，就会同时做坏：
  - 安全边界，因为过期决定继续生效
  - 成本边界，因为 diminishing returns 失语
  - 交接边界，因为 later 会继承一条免费时间线

### Claude Code 式正解

- continuation 应围绕 `typed ask + decision window + continuation pricing` 判断，而不是围绕“目前没被阻止”。

## 5. 伪 cleanup：对象恢复被 mode 与文件动作替代

### 坏解法

- cleanup 看起来存在，实际只是把 mode 切回去、文件撤回去、页面关掉，而不明确 cleanup carrier 所指向的对象边界。

### 为什么坏

- cleanup 真正保护的是对象级恢复；文件动作与 mode 切换只是执行路径，不是治理真相。
- 一旦 cleanup 只剩模式与文件，later 维护者会知道“按哪个按钮退”，却不知道“退回哪个治理对象、清掉哪些 transient authority”。

### Claude Code 式正解

- cleanup 应先绑定对象边界，再落到 mode、文件与流程动作。

## 6. 假 reject：拒收存在却不保护扩张边界

### 坏解法

- 团队虽然写了 reject 字段，但真正拒收时仍只记“审批没过”“感觉风险大”或“这轮 token 太贵”，没有按顺序保护治理对象。

### 为什么坏

- 治理 reject 真正要先保护的是单一 authority、正式 ask、窗口时效与 cleanup 边界，而不是先保护交互体验。
- 一旦 reject 顺序消失，团队最容易在：
  - ledger 缺席时放过
  - duplicate / orphan response 时继续
  - baseline 不重置时误判事故

### Claude Code 式正解

- reject 应先拒收 `projection_usurpation`、`decision_window_collapse` 与 `free_expansion_relapse`，再谈 modal、体验与成本观感。

## 7. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在消费的是 `governance key`，还是 mode 名字。
2. 我现在消费的是 `decision window`，还是 usage 仪表盘。
3. 我现在继续的是正式 pricing，还是默认行为。
4. 我现在 cleanup 的是对象边界，还是 mode 与文件动作。
5. 我现在拒收的是扩张边界漂移，还是一段 later 才补写的说明。
6. 如果把 modal 和 dashboard 藏起来，团队是否仍知道当前 ask、当前窗口与下一步应该怎样处理。

## 8. 一句话总结

真正危险的治理宿主验收执行失败，不是没写执行卡，而是写了执行卡却仍在围绕 mode 绿灯、假窗口对齐与免费继续消费治理世界。
