# 治理宿主修复稳态纠偏再纠偏执行反例：假authority source、假window refreeze与假threshold rebinding

这一章不再回答“治理宿主修复稳态纠偏再纠偏执行该怎样运行”，而是回答：

- 为什么团队明明已经写了 `recorrection card`、`reject verdict order`、`window refreeze drill`、`capability liability` 与 `threshold rebinding drill`，仍会重新退回假 `authority source`、假窗口回冻、免费继续回魂、假责任托管与假 `threshold rebinding`。

它主要回答五个问题：

1. 为什么治理宿主修复稳态纠偏再纠偏执行最危险的失败方式不是“没有 recorrection card”，而是“recorrection card 存在，却仍围绕 mode 投影、usage dashboard 与保守建议工作”。
2. 为什么假 `authority source` 最容易把治理对象重新退回 mode 名字、UI 平静感与作者判断。
3. 为什么假 `window refreeze` 最容易把 `Context Usage`、`reserved buffer` 与窗口真相重新退回图表与经验观察。
4. 为什么免费继续回魂与假责任托管最容易把 `continuation pricing`、`capability liability` 与 `custody owner` 重新退回默认继续与运维备注。
5. 为什么假 `threshold rebinding` 最容易把 future reopen 的正式追责能力重新退回礼貌说明。

## 0. 代表性源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-619`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:337-348`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1407-1450`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1533-1541`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1735-1747`
- `claude-code-source-code/src/cli/structuredIO.ts:362-657`
- `claude-code-source-code/src/cli/print.ts:1052-1075`
- `claude-code-source-code/src/cli/print.ts:4568-4641`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:84-645`
- `claude-code-source-code/src/utils/permissions/permissions.ts:929-1318`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/utils/analyzeContext.ts:1098-1382`
- `claude-code-source-code/src/query/tokenBudget.ts:22-92`
- `claude-code-source-code/src/query.ts:1308-1518`

这些锚点共同说明：

- 治理宿主修复稳态纠偏再纠偏执行真正最容易失真的地方，不在 `recorrection card` 有没有写出来，而在 authority、ledger、window、pricing、capability liability 与 threshold 是否仍围绕同一个治理对象消费安全、成本、时间与责任。

## 1. 第一性原理

治理宿主修复稳态纠偏再纠偏执行最危险的，不是：

- 没有 `recorrection card`
- 没有 `window refreeze drill`
- 没有 `threshold rebinding drill`

而是：

- 这些东西已经存在，却仍然围绕 mode、usage dashboard、审批历史与“现在应该还能继续”运作

一旦如此，团队就会重新回到：

1. 看当前 mode 是不是恢复正常
2. 看 usage 图表是不是降下来了
3. 看审批历史是不是已经结束
4. 看现在能不能先继续自动化
5. 看交接单里有没有写“有问题再 reopen”

而不再围绕：

- 同一个治理对象

## 2. 假authority source：authority by mode projection

### 坏解法

- 宿主、CI 与评审只要看到 mode 名字没变、面板状态还绿、`reject_verdict=steady_state_restituted`，就默认 `authority source restitution` 已成立，不再检查 `authority_source_after`、`writer_chokepoint` 与 `mode_projection_demoted` 是否仍属于同一个治理对象。

### 为什么坏

- authority 不是“终于恢复正常”，而是“同一个治理对象重新接管定价与放权主权”。
- 一旦 authority 退回 mode 投影，团队就会重新容忍：
  - authority drift 被面板平静感掩盖
  - `reject_verdict` 被绿灯提前消费
  - threshold owner 被 later 团队兜底
- 这会让交互投影直接取代治理主权。

### Claude Code 式正解

- `reject verdict` 应先绑定 authority source 与 writer chokepoint，再宣布 `steady_state_restituted`。

### 改写路径

1. 把 mode 与 dashboard 绿灯降为投影信号。
2. 把 `authority_source_restitution + authority_source_after + writer_chokepoint` 提升为前提。
3. 任何没有 formal authority object 仍宣布 restored 的治理 recorrection 都判为 drift。

## 3. 假window refreeze：window truth by dashboard

### 坏解法

- 团队虽然承认 recorrection 要验证 `decision window refreeze`，但真正执行时只要看到 token 百分比回落、`Context Usage` 图表平了、tool/result 似乎没再膨胀，就默认窗口已经回冻，不再检查 `decision_window`、`context_usage_snapshot` 与 `reserved_buffer` 是否仍属于同一 formal object。

### 为什么坏

- window refreeze 保护的不是“图表好看了”，而是“什么能进入模型世界、还能停留多久”仍被同一窗口对象裁定。
- 一旦窗口真相退回 dashboard，团队就会最先误以为：
  - “usage 回落就说明 window 已冻结”
  - “reserved buffer 差不多够就不用再看 formal window”
- 这会把 decision window 降格成一张图表。

### Claude Code 式正解

- `Context Usage` 必须被继续当作 `decision window` 的正式投影，而不是 verdict 本身。

### 改写路径

1. 把 usage 百分比降为观察信号。
2. 把 `decision_window + context_usage_snapshot + reserved_buffer` 提升为正式对象。
3. 任何“图表回落即视为 window 已 refreeze”的治理 recorrection 都判为 drift。

## 4. 假责任托管：liability by ops note

### 坏解法

- 团队虽然写了 `capability liability recustody`，但真正执行时只要工单里写着“能力已重新托管”“先保守一点”，就默认 capability 已被正式托管，不再检查 `capability_release_scope`、`rollback_object`、`custody_owner` 与 `liability_owner` 是否仍在同一个 formal object 里被执行。

### 为什么坏

- capability liability 保护的不是“建议大家谨慎一点”，而是“扩张 scope 仍由同一个对象正式托管，并由同一个 owner 负责”。
- 一旦责任托管退回备注，团队就会最先误以为：
  - “主流程没问题就行”
  - “真有事 later 会处理”
  - “scope 应该差不多还是原来那个”
- 这会把安全设计与省 token 设计同时拆回一套不再可定价的背景噪音。

### Claude Code 式正解

- capability liability 应继续被当作正式对象，而不是背景告警与值班注释。

### 改写路径

1. 把托管说明降为操作层信号。
2. 把 `capability_release_scope + rollback_object + custody_owner + liability_owner` 提升为正式对象。
3. 任何把 recustody 当备注处理的治理 recorrection 都判为 drift。

## 5. 免费继续回魂与假threshold rebinding：repricing by inertia

### 坏解法

- 只要没有硬错误、用户没明确拒绝、token 看起来还够，宿主就默认 capability 仍可继续，不再围绕 `continuation_pricing_rebinding`、`settled_price`、`budget_policy_generation`、`authority_drift_trigger` 与 `threshold_retained_until` 判断未来继续是否仍值得付费、future reopen 是否仍可追责。

### 为什么坏

- continuation pricing 的本质是在持续判断“继续是否仍值得付费”，不是给“再试一次”找借口。
- threshold rebinding 的本质是在恢复 future reopen 的正式升级器，不是补一条更礼貌的说明。
- 一旦继续回魂与阈值重绑退回惯性，治理 recorrection execution 就会重新退回：
  - free continuation by habit
  - liability without owner
  - reopen without threshold
- 这正是安全设计与省 token 设计在再纠偏执行层重新脱钩的地方。

### Claude Code 式正解

- continuation 与 threshold 必须同时重新生效；没有 threshold，就只能 `hard_reject`、`liability_hold`、`reentry_required` 或 `reopen_required`。

### 改写路径

1. 禁止“还没报错”充当继续资格。
2. 把 `continuation_pricing_rebinding + settled_price + authority_drift_trigger + threshold_retained_until` 提升为正式对象。
3. 任何默认继续、却不再正式保留 threshold 的治理 recorrection 都判为 drift。

## 6. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在消费的是 authority source，还是 mode 面板。
2. 我现在消费的是 formal decision window，还是一张 usage dashboard。
3. 我现在消费的是 capability liability，还是一段托管说明。
4. 我现在保留的是 future reopen 的正式 threshold，还是一句“后面再看”。
5. 我现在保护的是治理对象的长期延续，还是一套更制度化的再纠偏感觉。

## 7. 一句话总结

真正危险的治理宿主修复稳态纠偏再纠偏执行失败，不是没跑 `recorrection card`，而是跑了 `recorrection card` 却仍在围绕假 `authority source`、假 `window refreeze`、假责任托管、免费继续回魂与假 `threshold rebinding` 消费治理世界。
