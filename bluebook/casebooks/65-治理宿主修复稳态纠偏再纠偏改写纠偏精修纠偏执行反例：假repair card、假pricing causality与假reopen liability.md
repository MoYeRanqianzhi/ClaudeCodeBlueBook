# 治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏执行反例：假repair card、假pricing causality与假reopen liability

这一章不再回答“治理 refinement correction execution 该怎样运行”，而是回答：

- 为什么团队明明已经写了 `repair card`、固定 `reject order` 与 `reopen liability drill`，仍会重新退回假 `repair card`、假 `pricing causality` 与假 `reopen liability`。

它主要回答五个问题：

1. 为什么治理 refinement correction execution 最危险的失败方式不是“没有 repair card”，而是“card 存在，却仍围绕 mode 投影、usage dashboard、`pending_action` 幻觉与保守建议工作”。
2. 为什么假 `repair card` 最容易把 `governance_object_id`、`authority_source_after`、`permission_ledger_state` 与 `decision_window` 重新退回 calmer note。
3. 为什么假 `pricing causality` 最容易把 `settled_price`、`classifier_cost_priced`、`continuation_gate` 与 `writeback_seam_attested` 重新退回 dashboard 曲线、本地成功提示与“现在应该还能继续”的感觉。
4. 为什么假 `reopen liability` 最容易把 `capability_release_scope`、`liability_owner`、`authority_drift_trigger` 与 future reopen 的正式追责能力重新退回备注与默认继续。
5. 怎样用苏格拉底式追问避免把这些反例读成“把治理 repair card 再写严一点就好”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-619`
- `claude-code-source-code/src/utils/permissions/permissions.ts:526-1318`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/utils/analyzeContext.ts:1098-1382`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-211`

这些锚点共同说明：

- 治理 refinement correction execution 真正最容易失真的地方，不在 `repair card` 有没有写出来，而在 authority、ledger、window、pricing、classifier 成本、writeback seam、ingress/restore lineage、capability liability 与 threshold 是否仍围绕同一个治理对象继续统一定价一切扩张。

## 1. 第一性原理

治理 refinement correction execution 最危险的，不是：

- 没有 `repair card`
- 没有 `reject order`
- 没有 `reopen liability drill`

而是：

- 这些东西已经存在，却仍然围绕 mode、usage dashboard、审批平静感、`pending_action` 幻觉与“现在应该还能继续”运作

一旦如此，团队就会重新回到：

1. 看 mode 名字是不是恢复正常。
2. 看 usage 图表是不是降下来了。
3. 看审批 UI 是否看起来已经结束。
4. 看宿主好像没再报错。
5. 看 later 团队是否愿意先保守一点。

而不再围绕：

- 同一个 `governance_object_id + authority_source_after + permission_ledger_state + decision_window + settled_price + classifier_cost_priced + writeback_seam_attested + capability_release_scope + threshold_retained_until`

## 2. 假repair card：card by calmer dashboard

### 坏解法

- 宿主、CI、评审与交接系统虽然都拿到了 `repair_card_id` 与 `reject_verdict=steady_state_chain_resealed`，但真正执行时只要 mode 恢复正常、usage 图表转绿、审批窗口消失，就默认 `governance_object_id`、`authority_source_after`、`permission_ledger_state` 与 `decision_window` 仍围绕同一个治理对象成立。

### 为什么坏

- `repair card` 保护的不是“现在更像一张正式治理卡”，而是 later 消费者仍在消费同一个统一定价控制对象。
- 一旦修正卡退回 calmer dashboard，团队就会重新容忍：
  - `authority_source_after` 只是面板状态
  - `permission_ledger_state` 只是 UI calmness
  - `decision_window` 只是图表百分比
  - `reject_verdict` 先于对象复核生效
- 这会让 dashboard 曲线直接取代治理对象链。

### Claude Code 式正解

- `reject verdict` 应先绑定同一个 `governance_object_id + authority_source_after + permission_ledger_state + decision_window`，再宣布 `steady_state_chain_resealed`。

### 改写路径

1. 把 mode 平静感、usage 转绿与审批窗口消失降为次级信号。
2. 把 `governance_object_id + authority_source_after + permission_ledger_state + decision_window` 提升为前提。
3. 任何先看 dashboard、后看对象链的治理 refinement correction execution 都判为 drift。

## 3. 假pricing causality：price by calmness

### 坏解法

- 团队虽然承认 refinement correction execution 要检查 `settled_price`、`budget_policy_generation`、`classifier_cost_priced`、`writeback_seam_attested`、`pending_permission_requests` 与 `adopted_server_uuid`，但真正执行时只要 usage 下降、审批 UI 静了、本地 `enqueue()` 成功、later 团队也没反对，就提前落下 `steady_state_chain_resealed`，不再按固定顺序检查真实的 pricing causality、classifier pricing 与 writeback round-trip。

### 为什么坏

- `settled_price` 保护的不是“现在看起来还省”，而是未来继续已经被正式定价。
- `classifier_cost_priced` 保护的不是“安全系统已经看过”，而是 classifier 本身也在成本链里。
- `writeback_seam_attested` 保护的不是“UI 已经安静”，而是 `requires_action -> pending_action -> session_state_changed` 的正式 round-trip。
- 一旦 pricing causality 退回 calmness，团队就会最先误以为：
  - “usage 降了就说明现在值得继续”
  - “classifier 跑过了就说明已经入账”
  - “本地 patch 发出去了就说明 writeback 已完成”
- 这会把统一定价控制面退回运营感觉。

### Claude Code 式正解

- `reject order` 必须先证明 `settled_price + classifier_cost_priced + writeback_seam_attested + pending_permission_requests + adopted_server_uuid` 仍围绕同一个治理对象，再决定 `steady_state_chain_resealed`、`ledger_reseal_required`、`writeback_reseal_required` 或 `reopen_required`。

### 改写路径

1. 把 usage 曲线、本地成功提示与“看起来还省”降为观察信号。
2. 把 `pricing/classifier/writeback/ingress` 提升为正式对象。
3. 任何“dashboard 已安静即视为控制面 round-trip 完成”的治理 refinement correction execution 都判为 drift。

## 4. 假reopen liability：repricing by inertia

### 坏解法

- 只要没有硬错误、用户没明确拒绝、token 看起来还够，宿主就默认 capability 仍可继续，不再围绕 `capability_release_scope`、`liability_owner`、`authority_drift_trigger`、`threshold_retained_until` 与 `reopen_required_when` 判断未来继续是否仍值得付费、future reopen 是否仍可追责。

### 为什么坏

- continuation pricing 的本质是在持续判断“继续是否仍值得付费”，不是给“再试一次”找借口。
- reopen liability 的本质是在恢复 future reopen 的正式升级器，不是补一条更礼貌的说明。
- 一旦继续回魂与阈值保留退回惯性，治理 refinement correction execution 就会重新退回：
  - free continuation by habit
  - capability expansion without owner
  - reopen without threshold
- 这正是安全设计与省 token 设计在 refinement correction execution 层重新脱钩的地方。

### Claude Code 式正解

- `settled_price`、`classifier_cost_priced`、`capability_release_scope` 与 `reopen liability ledger` 必须同时重新生效；没有 threshold，就只能 `hard_reject`、`ledger_reseal_required`、`writeback_reseal_required`、`reentry_required` 或 `reopen_required`。

### 改写路径

1. 禁止“还没报错”充当继续资格。
2. 把 `settled_price + classifier_cost_priced + capability_release_scope + liability_owner + authority_drift_trigger + threshold_retained_until` 提升为正式对象。
3. 任何默认继续、却不再正式保留 threshold 的治理 refinement correction execution 都判为 drift。

## 5. 为什么这会同时毁掉安全设计与省 token 设计

- Claude Code 的安全设计反对的是未定价的危险扩张。
- Claude Code 的省 token 设计反对的是未定价的低收益扩张。
- `writeback seam + ingress lineage` 同时决定“当前为什么被拦”“当前是否还能继续”与“当前什么时候算真正 turn-over”；一旦这条链丢失，安全与成本就会一起退回猜测状态。

这两者在 refinement correction execution 层会一起失效，因为假 `repair card`、假 `pricing causality` 与假 `reopen liability` 会共同把统一定价控制面退回：

1. mode 是否看起来正常。
2. usage 是否看起来下降。
3. UI 是否看起来平静。
4. later 团队是否愿意先保守一点。

## 6. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在消费的是同一个治理对象，还是一张更漂亮的修正卡。
2. 我现在消费的是 formal `decision window + settled price`，还是一张 usage dashboard。
3. 我现在消费的是 `writeback seam + ingress lineage`，还是一种“应该已经写回去了”的感觉。
4. 我现在保留的是 future reopen 的正式 threshold，还是一句“后面再看”。
5. 我现在保护的是统一定价控制面，还是一套更制度化的默认继续。

## 7. 一句话总结

真正危险的治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏执行失败，不是没跑 `repair card`，而是跑了 `repair card` 却仍在围绕假 `repair card`、假 `pricing causality` 与假 `reopen liability` 消费治理世界。
