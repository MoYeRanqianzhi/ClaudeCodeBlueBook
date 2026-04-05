# 治理宿主修复稳态纠偏再纠偏改写纠偏精修执行反例：假host consumption card、假writeback round-trip与假reopen liability

这一章不再回答“治理 refinement execution 该怎样运行”，而是回答：

- 为什么团队明明已经写了 `host consumption card`、固定 `hard reject order` 与 `reopen liability drill`，仍会重新退回假 `host consumption card`、假 `authority-ledger covenant`、假 `writeback seam round-trip` 与假 `reopen liability ledger`。

它主要回答五个问题：

1. 为什么治理 refinement execution 最危险的失败方式不是“没有 host consumption card”，而是“card 存在，却仍围绕 mode 投影、usage dashboard、`pending_action` 幻觉与保守建议工作”。
2. 为什么假 `host consumption card` 最容易把 `governance_object_id`、`authority_source_after`、`permission_ledger_state` 与 `decision_window` 重新退回 calmer note。
3. 为什么假 `writeback seam round-trip` 最容易把 `requires_action -> pending_action -> session_state_changed`、`pending_permission_requests` 与宿主回写真相重新退回 UI calmness 与本地 enqueue 成功。
4. 为什么假 `reopen liability ledger` 最容易把 `capability_release_scope`、`liability_owner`、`authority_drift_trigger` 与 future reopen 的正式追责能力重新退回备注与默认继续。
5. 怎样用苏格拉底式追问避免把这些反例读成“把治理 host consumption card 再写严一点就好”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-619`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:337-348`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1407-1450`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1533-1541`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1735-1747`
- `claude-code-source-code/src/cli/structuredIO.ts:362-657`
- `claude-code-source-code/src/cli/print.ts:1052-1075`
- `claude-code-source-code/src/cli/print.ts:4568-4641`
- `claude-code-source-code/src/utils/permissions/permissions.ts:526-1318`
- `claude-code-source-code/src/utils/permissions/yoloClassifier.ts:1250-1312`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/utils/analyzeContext.ts:1098-1382`
- `claude-code-source-code/src/query/tokenBudget.ts:22-92`
- `claude-code-source-code/src/query.ts:1308-1518`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`

这些锚点共同说明：

- 治理 refinement execution 真正最容易失真的地方，不在 `host consumption card` 有没有写出来，而在 authority、ledger、window、pricing、classifier 成本、writeback seam、capability liability 与 threshold 是否仍围绕同一个治理对象继续统一定价一切扩张。

## 1. 第一性原理

治理 refinement execution 最危险的，不是：

- 没有 `host consumption card`
- 没有 `hard reject order`
- 没有 `reopen liability drill`

而是：

- 这些东西已经存在，却仍然围绕 mode、usage dashboard、审批平静感、`pending_action` 幻觉与“现在应该还能继续”运作

一旦如此，团队就会重新回到：

1. 看 mode 名字是不是恢复正常。
2. 看 usage 图表是不是降下来了。
3. 看审批 UI 是否看起来已经结束。
4. 看宿主好像没再报错就默认可以继续。

而不再围绕：

- 同一个 `governance_object_id + authority_source_after + permission_ledger_state + decision_window + settled_price + classifier_cost_priced + writeback_seam_attested + capability_release_scope + liability_owner + authority_drift_trigger + threshold_retained_until`

## 2. 假host consumption card：card by calm dashboard

### 坏解法

- 宿主、CI、评审与交接系统虽然都拿到了 `host_consumption_card_id` 与 `reject_verdict=steady_state_chain_resealed`，但真正执行时只要 mode 没炸、usage 更平静、输出更规整，就默认 `governance_object_id`、`authority_source_after`、`permission_ledger_state` 与 `decision_window` 仍围绕同一个治理对象成立。

### 为什么坏

- 治理 `host consumption card` 保护的不是“现在更像一张正式值班卡”，而是同一个治理对象重新接管 authority、window、pricing 与 liability。
- 一旦宿主消费卡退回 calmer dashboard，团队就会重新容忍：
  - `authority_source_after` 只是说明文字
  - `permission_ledger_state` 只是当前看起来没尾账
  - `decision_window` 只是 usage 回落
  - `reject_verdict` 被平静感提前消费
- 这会让 mode 与图表直接取代治理主权。

### Claude Code 式正解

- `reject verdict` 应先绑定同一个 `governance_object_id + authority_source_after + single_truth_chain_ref + permission_ledger_state + decision_window`，再宣布 `steady_state_chain_resealed`。


## 3. 假writeback seam round-trip：round-trip by UI quietness

### 坏解法

- 团队虽然承认 refinement execution 要验证 `requires_action_ref`、`pending_action_ref`、`session_state_changed_ref`、`pending_permission_requests` 与 `writeback_seam_attested`，但真正执行时只要看到 UI 上 pending action 消失、本地 enqueue 成功、worker 状态似乎回落，就提前落下 `steady_state_chain_resealed`，不再按固定顺序检查宿主 round-trip 是否真的完成。

### 为什么坏

- `requires_action -> pending_action -> session_state_changed` 是安全与成本共用的 writeback seam，不是 UI 小状态。
- `pending_permission_requests` 清零保护的不是“当前不忙”，而是 governance object 不再继承旧尾账。
- 一旦 writeback seam 退回 UI calmness，团队就会最先误以为：
  - “pending action 消失就说明 writeback 已完成”
  - “本地 enqueue 成功就说明宿主已经接收”
  - “worker metadata 更新了就说明治理真相已 round-trip”
- 这会让安全设计与省 token 设计同时退回一套不再可追的后台感觉。

### Claude Code 式正解

- `hard reject order` 必须先证明 `requires_action_ref + pending_action_ref + session_state_changed_ref + pending_permission_requests + writeback_seam_attested` 仍围绕同一个治理对象，再决定 `steady_state_chain_resealed`、`writeback_reseal_required` 或 `reopen_required`。


## 4. 假reopen liability：repricing by inertia

### 坏解法

- 只要没有硬错误、用户没明确拒绝、token 看起来还够，宿主就默认 capability 仍可继续，不再围绕 `capability_release_scope`、`liability_owner`、`authority_drift_trigger`、`threshold_retained_until` 与 `reopen_required_when` 判断未来继续是否仍值得付费、future reopen 是否仍可追责。

### 为什么坏

- continuation pricing 的本质是在持续判断“继续是否仍值得付费”，不是给“再试一次”找借口。
- reopen liability 的本质是在恢复 future reopen 的正式升级器，不是补一条更礼貌的说明。
- 一旦继续回魂与阈值保留退回惯性，治理 refinement execution 就会重新退回：
  - free continuation by habit
  - capability expansion without owner
  - reopen without threshold
- 这正是安全设计与省 token 设计在 refinement execution 层重新脱钩的地方。

### Claude Code 式正解

- `settled_price`、`classifier_cost_priced`、`capability_release_scope` 与 `reopen liability ledger` 必须同时重新生效；没有 threshold，就只能 `hard_reject`、`liability_hold`、`writeback_reseal_required`、`reentry_required` 或 `reopen_required`。


## 5. 为什么这会同时毁掉安全设计与省 token 设计

- Claude Code 的安全设计反对的是未定价的危险扩张。
- Claude Code 的省 token 设计反对的是未定价的低收益扩张。
- `writeback seam` 同时决定“当前为什么被拦”“当前是否还能继续”与“当前什么时候算真正 turn-over”；一旦这条 seam 丢失，安全与成本就会一起退回猜测状态。

这两者在 refinement execution 层会一起失效，因为假 `host consumption card`、假 `writeback seam round-trip` 与假 `reopen liability ledger` 会共同把统一定价控制面退回：

1. mode 是否看起来正常。
2. usage 是否看起来下降。
3. UI 是否看起来平静。
4. later 团队是否愿意先保守一点。

## 6. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在消费的是同一个治理对象，还是一张更漂亮的宿主消费卡。
2. 我现在消费的是 formal `decision window`，还是一张 usage dashboard。
3. 我现在消费的是 `writeback seam round-trip`，还是一种“应该已经写回去了”的感觉。
4. 我现在保留的是 future reopen 的正式 threshold，还是一句“后面再看”。
5. 我现在保护的是统一定价控制面，还是一套更制度化的默认继续。

## 7. 一句话总结

真正危险的治理宿主修复稳态纠偏再纠偏改写纠偏精修执行失败，不是没跑 `host consumption card`，而是跑了 `host consumption card` 却仍在围绕假 `host consumption card`、假 `writeback seam round-trip` 与假 `reopen liability` 消费治理世界。
