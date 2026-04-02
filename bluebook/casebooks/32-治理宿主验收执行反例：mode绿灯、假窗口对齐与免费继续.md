# 治理宿主验收执行反例：mode绿灯、假窗口对齐与免费继续

这一章不再回答“治理宿主验收执行该怎样运行”，而是回答：

- 为什么团队明明已经写了 authority source、permission ledger、decision window、continuation gate 与 rollback 剧本，仍会重新退回 mode 绿灯、审批完成感、token 仪表盘与默认继续。

它主要回答五个问题：

1. 为什么治理宿主验收执行最危险的失败方式不是“没有执行卡”，而是“执行卡存在，却仍围绕交互投影工作”。
2. 为什么 mode 绿灯最容易把 authority source 重新退回 mode 名字与界面状态。
3. 为什么假窗口对齐最容易把安全与省 token 同时降格成仪表盘幻觉。
4. 为什么免费继续最容易把 continuation gate 重新退回默认行为。
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

- 治理宿主验收执行真正最容易失真的地方，不在卡片有没有 authority、ledger 与 gate 字段，而在执行层是否仍围绕同一个治理对象消费安全、成本、时间与回退。

## 1. 第一性原理

治理宿主验收执行最危险的，不是：

- 没有 authority 字段
- 没有 permission ledger
- 没有 rollback 剧本

而是：

- 这些东西已经存在，却仍然围绕 mode、弹窗、颜色与 token 条运作

一旦如此，团队就会重新回到：

1. 看当前 mode 是什么
2. 看审批是不是点完了
3. 看 token 面板是不是转绿
4. 看还能不能再来一轮

而不再围绕：

- 同一个治理对象

## 2. mode 绿灯：authority source 被 mode 名字替代

### 坏解法

- 宿主、CI 与评审只要看到 mode 名字对了、页面状态转绿，就默认 authority source 已经对齐，不再检查 source / effective / applied 是否仍一致。

### 为什么坏

- Claude Code 的治理控制面真正强大之处，在于 authority source 决定允许什么、看见什么、继续多久，而不是 mode 标签本身。
- 一旦执行层只看 mode 绿灯，就会重新容忍：
  - source 漂了却没人看见
  - dangerous rule 被 strip 了却以为仍有效
  - external mode 只是投影却被误当主权
- 这样会把治理从对象级判断重新退回 UI 投影崇拜。

### Claude Code 式正解

- authority source 应先于 mode 投影被消费；mode 只是结果表达，不是判断本体。

### 改写路径

1. 把 mode 转绿降为投影级信号。
2. 把 source / effective / applied 对齐提升为通过前提。
3. 任何只看 mode 绿灯的治理宿主验收都判为 drift。

## 3. 假窗口对齐：Context Usage 仪表盘冒充 decision window

### 坏解法

- 执行层只要看到 usage 百分比、剩余空间和压缩次数，就默认 decision window 对齐，不再检查 `Context Usage + pending action + state` 是否仍属于同一窗口对象。

### 为什么坏

- Claude Code 的安全设计与省 token 设计共用同一个治理窗口；它不是“一个管安全、一个管成本”，而是同一对象在统一定价一切扩张。
- 一旦 decision window 被做成仪表盘：
  - 安全会退回审批完成感
  - 成本会退回 token 条颜色
  - 继续会退回“似乎还能跑”
- 这会让安全与省 token 一起失语。

### Claude Code 式正解

- decision window 应同时解释 authority、pending action、context usage 与 continuation，而不是只展示 usage 数字。

### 改写路径

1. 把 usage 百分比降为窗口投影。
2. 把 `decision_window + pending_action + context_usage_snapshot` 提升为正式对象。
3. 任何只看仪表盘的治理对齐都判为 drift。

## 4. 免费继续：continuation gate 被默认行为替代

### 坏解法

- 只要没有硬错误、用户没明确拒绝、token 似乎还够，宿主就默认继续，不再围绕 typed decision 与 gain 判断。

### 为什么坏

- Claude Code 的 continuation gate 本质上是在给时间与输出继续定价，而不是给“再试一次”找借口。
- 一旦执行层默认继续，就会同时做坏：
  - 安全边界，因为过期决定继续生效
  - 成本边界，因为 diminishing returns 失语
  - 交接边界，因为 later 会继承一条免费时间线
- 这正是安全设计与省 token 设计在执行层一起失真的地方。

### Claude Code 式正解

- continuation 应围绕 typed decision、decision window 与 token budget result，而不是围绕“目前没被阻止”。

### 改写路径

1. 禁止“还没报错”充当继续资格。
2. 把 `continuation_gate` 提升为正式执行门。
3. 任何默认继续的治理宿主验收都判为 drift。

## 5. 伪回退：rollback object 重新退回 mode 与文件动作

### 坏解法

- 回退看起来存在，实际只是把 mode 切回去、文件撤回去、页面关掉，而不明确 `rollback_object`。

### 为什么坏

- rollback 真正保护的是对象级恢复；文件动作与 mode 切换只是其执行路径，不是它的真相。
- 一旦回退只剩模式与文件，later 维护者会知道“按哪个按钮退”，却不知道“退回哪个治理对象”。

### Claude Code 式正解

- rollback 应先绑定对象边界，再落到 mode、文件与流程动作。

### 改写路径

1. 把 file rewind 与 mode toggle 降为次级动作。
2. 把 `rollback_object` 提升为回退主对象。
3. 任何只剩 mode / 文件回退的治理 rollback 都判为 drift。

## 6. 假 reject：reject reason 存在却不保护扩张边界

### 坏解法

- 团队虽然写了 reject 字段，但真正拒收时仍只记“审批没过”“感觉风险大”或“这轮 token 太贵”，没有把 authority、ledger、window 与 gate 按顺序保护起来。

### 为什么坏

- 治理 reject 真正要先保护的是单一 authority、正式 ledger、窗口时效与继续边界，而不是先保护交互体验。
- 一旦 reject 顺序消失，团队最容易在：
  - ledger 缺席时放过
  - duplicate/orphan response 时继续
  - baseline 不重置时误判事故
- 这会让 reject 看起来更严格，实际却更空。

### Claude Code 式正解

- reject 应先拒收 authority 漂移、窗口失效与对象级回退缺席，再谈 modal、体验与成本观感。

### 改写路径

1. 把 `mode_only_authority / missing_permission_ledger / decision_window_unbound / continuation_threshold_only / rollback_not_object` 固定成正式顺序。
2. 禁止 later 复盘补写 reject 取代现场判定。
3. 任何“有 reject 词表、没对象级拒收顺序”的治理宿主验收都判为 drift。

## 7. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在消费的是 authority source，还是 mode 名字。
2. 我现在消费的是 decision window，还是 usage 仪表盘。
3. 我现在继续的是正式 gate，还是默认行为。
4. 我现在回退的是 `rollback_object`，还是 mode 与文件动作。
5. 我现在拒收的是扩张边界漂移，还是一段 later 才补写的说明。

## 8. 一句话总结

真正危险的治理宿主验收执行失败，不是没写执行卡，而是写了执行卡却仍在围绕 mode 绿灯、假窗口对齐与免费继续消费治理世界。
