# 治理宿主修复演练反例：governance key 假恢复、假窗口重置与免费重入

这一章不再回答“治理宿主修复演练该怎样运行”，而是回答：

- 为什么团队明明已经写了 repair card、rollback drill 与 re-entry drill，仍会重新退回 mode 恢复、面板刷新与继续一轮试试看。

它主要回答五个问题：

1. 为什么治理宿主修复演练最危险的失败方式不是“没有 repair card”，而是“repair card 存在，却仍围绕交互投影工作”。
2. 为什么治理主键假恢复最容易把治理主权重新退回 mode 标签、页面状态与口头解释。
3. 为什么假窗口重置最容易把安全设计与省 token 设计同时降格成仪表盘刷新与统计重置。
4. 为什么免费重入最容易把 `continuation pricing` 重新退回默认继续。
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
- `claude-code-source-code/src/query.ts:1308-1518`
- `claude-code-source-code/src/services/compact/autoCompact.ts:72-182`

这些锚点共同说明：

- 治理宿主修复演练真正最容易失真的地方，不在 repair card 有没有字段，而在执行层是否仍围绕同一个 `governance key`、同一条 `externalized truth chain`、同一个 `decision window` 与同一个 `continuation pricing` 对象消费安全、成本、时间与回退。

## 1. 第一性原理

治理宿主修复演练最危险的，不是：

- 没有 repair card
- 没有 window reset
- 没有 re-entry ticket

而是：

- 这些东西已经存在，却仍然围绕 mode、仪表盘、审批完成感与“还能再来一轮”运作

一旦如此，团队就会重新回到：

1. 看当前 mode 是不是恢复了
2. 看面板是不是刷新了
3. 看 token 似乎是不是又降下来了
4. 看现在还能不能继续

而不再围绕：

- 同一个 `governance key -> externalized truth chain -> decision window -> continuation pricing -> durable-vs-transient cleanup`

## 2. governance key 假恢复：repair 退回 mode 标签与页面状态

### 坏解法

- 宿主、CI 与评审只要看到 mode 名字对了、审批结束了、页面状态转绿，就默认 repair 已经完成，不再检查 `governance key`、effective settings 与 writer choke point 是否仍一致。

### 为什么坏

- Claude Code 的治理控制面真正强大之处，在于 `governance key` 决定允许什么、看见什么、继续多久，而不是 mode 标签本身。
- 一旦 repair 退回 mode 恢复，就会重新容忍：
  - source 漂了却没人看见
  - externalized mode 只是投影却被误当主权
  - writer choke point 漂移却只剩页面成功感
- 这样看起来像恢复了安全，实际却只是恢复了交互投影。

### Claude Code 式正解

- repair 应先恢复 `governance key`，再恢复 mode 投影。

## 3. externalized truth chain 漂白：typed ask 退回审批历史

### 坏解法

- 团队虽然写了 `permission_ledger`，但真正演练时只看审批是否点完、请求是否消失，不再检查 typed ask、decision reason、pending request、duplicate response 与 orphan state 是否仍被同一条 `externalized truth chain` 收口。

### 为什么坏

- ledger rebuild 保护的不是“审批做没做完”，而是“扩张理由是否仍可追溯、当前世界是否仍被同一条 truth chain 宣布”。
- 一旦 `externalized truth chain` 退回审批历史，团队就会最先误以为：
  - “记录还在，应该没问题”
  - “弹窗关了，说明修好了”
- 这会把安全设计与省 token 设计同时拆回一套无法定价的点击历史。

### Claude Code 式正解

- typed ask、decision reason 与 externalized truth 应先恢复为同一个对象，再谈审批完成感。

## 4. 假窗口重置：decision window reset 退回仪表盘刷新

### 坏解法

- 执行层只要看到 usage 百分比刷新、context bar 下降、compact 触发过，就默认 `decision_window_reset` 已经完成，不再检查当前 request、pending action、visible capability、generation 与 context usage 是否仍属于同一窗口。

### 为什么坏

- Claude Code 的安全设计与省 token 设计共用同一个治理窗口；它不是“一个管权限、一个管成本”，而是同一对象在统一定价一切扩张与当前世界准入。
- 一旦窗口重置退回面板刷新：
  - 安全会退回审批完成感
  - 成本会退回数字变小
  - 继续会退回“似乎还能跑”
- 这会让安全与省 token 一起失语。

### Claude Code 式正解

- decision window reset 应先恢复同一窗口对象，再谈仪表盘变化与 token 下降。

## 5. 免费重入：continuation pricing 被默认继续篡位

### 坏解法

- 只要没有硬错误、用户没明确拒绝、token 看起来还够，宿主就默认重入，不再围绕 gain 判断、typed decision 与 re-entry condition。

### 为什么坏

- Claude Code 的 continuation gate 本质上是在给时间与输出继续定价，而不是给“再试一次”找借口。
- 一旦 repair drill 默认重入，就会同时做坏：
  - 安全边界，因为过期决定继续生效
  - 成本边界，因为 diminishing returns 失语
  - 交接边界，因为 later 会继承一条免费时间线
- 这正是安全设计与省 token 设计在 repair drill 层重新脱钩的地方。

### Claude Code 式正解

- re-entry 应围绕 `continuation pricing` 结果，而不是围绕“目前没被阻止”。

## 6. 假恢复：durable assets 与 transient authority 被动作感替代

### 坏解法

- rollback 与恢复看起来存在，实际只是把 mode 切回去、文件撤回去、页面关掉、再跑一次 compact，而不明确哪些是 `durable assets`、哪些是应被清退的 `transient authority`。

### 为什么坏

- 治理恢复真正保护的是对象级清账；mode 切换、文件动作与 compact 只是执行路径，不是它的真相。
- 一旦恢复只剩操作动作，later 维护者会知道“按哪个按钮退”，却不知道“保留哪个资产、清退哪个旧主权”。
- 这会让 resume / reopen 变成旧 authority 的免费续租，而不是对象级 cleanup。

### Claude Code 式正解

- 恢复应先点名 `durable assets after` 与 `transient authority cleared`，再落到 mode、文件与流程动作。

## 7. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在消费的是 `governance key`，还是 mode 名字。
2. 我现在消费的是 `externalized truth chain` 与 typed ask，还是审批历史。
3. 我现在消费的是 `decision window`，还是 usage 仪表盘。
4. 我现在重入的是正式 pricing gate，还是默认行为。
5. 我现在保护的是 `durable assets vs transient authority` 的边界，还是一串更顺滑的恢复动作。

## 8. 一句话总结

真正危险的治理宿主修复演练失败，不是没写 repair card，而是写了 repair card 却仍在围绕 `governance key` 假恢复、假窗口重置与免费重入消费治理世界。
