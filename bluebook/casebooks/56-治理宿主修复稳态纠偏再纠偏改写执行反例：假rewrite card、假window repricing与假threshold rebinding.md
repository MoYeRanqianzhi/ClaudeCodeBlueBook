# 治理宿主修复稳态纠偏再纠偏改写执行反例：假rewrite card、假window repricing与假threshold rebinding

这一章不再回答“治理宿主修复稳态纠偏再纠偏改写执行该怎样运行”，而是回答：

- 为什么团队明明已经写了 `rewrite card`、`reject verdict order`、`window repricing drill`、`capability liability` 与 `threshold rebinding drill`，仍会重新退回假 `rewrite card`、假 `window repricing`、免费继续回魂与假 `threshold rebinding`。

它主要回答五个问题：

1. 为什么治理宿主修复稳态纠偏再纠偏改写执行最危险的失败方式不是“没有 rewrite card”，而是“rewrite card 存在，却仍围绕 mode 投影、usage dashboard 与保守建议工作”。
2. 为什么假 `rewrite card` 最容易把 `governance_object_id`、`authority_source_after`、`typed_decision_digest` 与 `permission_ledger_state` 重新退回 calmer note。
3. 为什么假 `window repricing` 与假 `reject verdict order` 最容易把 `decision_window`、`context_usage_snapshot`、`reserved_buffer` 与 `settled_price` 重新退回图表、直觉与惯性。
4. 为什么免费继续回魂与假 `threshold rebinding` 最容易把 `capability liability`、`liability_owner` 与 future reopen 的正式追责能力重新退回备注与默认继续。
5. 怎样用苏格拉底式追问避免把这些反例读成“把治理 rewrite 再写严一点就好”。

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

- 治理宿主修复稳态纠偏再纠偏改写执行真正最容易失真的地方，不在 `rewrite card` 有没有写出来，而在 authority、ledger、window、pricing、capability liability 与 threshold 是否仍围绕同一个治理对象继续统一定价一切扩张。

## 1. 第一性原理

治理宿主修复稳态纠偏再纠偏改写执行最危险的，不是：

- 没有 `rewrite card`
- 没有 `window repricing drill`
- 没有 `threshold rebinding drill`

而是：

- 这些东西已经存在，却仍然围绕 mode、usage dashboard、审批历史与“现在应该还能继续”运作

一旦如此，团队就会重新回到：

1. 看 mode 名字是不是恢复正常。
2. 看 usage 图表是不是降下来了。
3. 看审批历史是不是已经结束。
4. 看现在能不能先继续自动化。
5. 看交接单里有没有写“有问题再 reopen”。

而不再围绕：

- 同一个 `governance_object_id`

## 2. 假rewrite card：rewrite by calm dashboard

### 坏解法

- 宿主、CI、评审与交接系统虽然都拿到了 `rewrite_card_id` 与 `reject_verdict=steady_state_restituted`，但真正执行时只要 mode 没炸、输出更规整、dashboard 更平静，就默认 `governance_object_id`、`authority_source_after`、`typed_decision_digest` 与 `permission_ledger_state` 仍围绕同一个治理对象成立。

### 为什么坏

- 治理 `rewrite card` 保护的不是“现在更像一份正式治理说明”，而是同一个治理对象重新接管 authority、window、pricing 与 liability。
- 一旦 rewrite card 退回 calmer note，团队就会重新容忍：
  - `authority_source_after` 只是说明文字
  - `typed_decision_digest` 只是会后纪要
  - `permission_ledger_state` 只是当前看起来没尾账
  - `reject_verdict` 被平静感提前消费
- 这会让图表与运营感受直接取代治理主权。

### Claude Code 式正解

- `reject verdict` 应先绑定同一个 `governance_object_id + authority_source_after + permission_ledger_state`，再宣布 `steady_state_restituted`。


## 3. 假window repricing 与假reject顺序：verdict by usage calmness before price truth

### 坏解法

- 团队虽然承认 rewrite 要验证 `authority source restitution`、`decision window refreeze`、`continuation pricing rebinding` 与 `capability liability recustody`，但真正执行时只要看到 `Context Usage` 图表回落、reserved buffer 似乎够用、工具结果没再继续膨胀，就提前落下 `steady_state_restituted`，不再按固定顺序检查 `decision_window`、`context_usage_snapshot`、`reserved_buffer`、`continuation_gate`、`settled_price` 与 `budget_policy_generation`。

### 为什么坏

- 治理 rewrite 的 `reject verdict order` 保护的是“继续是否仍值得付费、仍被谁授权、仍由谁负责”，不是“图表已经好看了”。
- 一旦 reject 顺序退回 usage calmness，团队就会最先误以为：
  - “usage 回落就说明 window 已经重绑”
  - “reserved buffer 差不多够就说明继续可以默认放行”
  - “tool/result breakdown 还看得过去就不用再看 settled price”
- 这会让安全设计与省 token 设计同时退回一套不再可定价的背景噪音。

### Claude Code 式正解

- `reject verdict order` 必须先证明 authority、window、pricing 与 liability 仍围绕同一个治理对象，再决定 `steady_state_restituted`、`hard_reject`、`liability_hold`、`reentry_required` 或 `reopen_required`。


## 4. 免费继续回魂与假threshold rebinding：repricing by inertia

### 坏解法

- 只要没有硬错误、用户没明确拒绝、token 看起来还够，宿主就默认 capability 仍可继续，不再围绕 `capability_release_scope`、`liability_owner`、`authority_drift_trigger`、`threshold_retained_until` 与 `reopen_required_when` 判断未来继续是否仍值得付费、future reopen 是否仍可追责。

### 为什么坏

- continuation pricing 的本质是在持续判断“继续是否仍值得付费”，不是给“再试一次”找借口。
- threshold rebinding 的本质是在恢复 future reopen 的正式升级器，不是补一条更礼貌的说明。
- classifier 本身也必须被放进定价对象里；如果 safety classifier 的额外开销反而主导了预算，治理控制面就会在自我保护时自我膨胀。
- 一旦继续回魂与阈值重绑退回惯性，治理 rewrite execution 就会重新退回：
  - free continuation by habit
  - capability expansion without owner
  - reopen without threshold
- 这正是安全设计与省 token 设计在 rewrite execution 层重新脱钩的地方。

### Claude Code 式正解

- continuation 与 threshold 必须同时重新生效；没有 threshold，就只能 `hard_reject`、`liability_hold`、`reentry_required` 或 `reopen_required`。


## 5. 为什么这会同时毁掉安全设计与省 token 设计

- Claude Code 的安全设计反对的是未定价的危险扩张。
- Claude Code 的省 token 设计反对的是未定价的低收益扩张。
- `requires_action -> pending_action -> session_state_changed` 这条 writeback seam 同时决定“当前为什么被拦”“当前是否还能继续”与“当前什么时候算真正 turn-over”；一旦这条 seam 丢失，安全与成本就会一起退回猜测状态。

这两者在 rewrite execution 层会一起失效，因为假 `rewrite card`、假 `window repricing` 与假 `threshold rebinding` 会共同把统一定价控制面退回：

1. mode 是否看起来正常。
2. usage 是否看起来下降。
3. later 团队是否愿意先保守一点。

一旦如此，治理世界就不再是控制面，而只是：

1. 更体面的运营建议。
2. 更平静的图表。
3. 更难被追责的默认继续。

## 6. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在消费的是同一个治理对象，还是一张更漂亮的治理 rewrite 卡。
2. 我现在消费的是 formal decision window，还是一张 usage dashboard。
3. 我现在消费的是 settled price，还是一种“应该还能继续”的感觉。
4. 我现在保留的是 future reopen 的正式 threshold，还是一句“后面再看”。
5. 我现在保护的是统一定价控制面，还是一套更制度化的默认继续。

## 7. 一句话总结

真正危险的治理宿主修复稳态纠偏再纠偏改写执行失败，不是没跑 `rewrite card`，而是跑了 `rewrite card` 却仍在围绕假 `rewrite card`、假 `window repricing`、免费继续回魂与假 `threshold rebinding` 消费治理世界。
