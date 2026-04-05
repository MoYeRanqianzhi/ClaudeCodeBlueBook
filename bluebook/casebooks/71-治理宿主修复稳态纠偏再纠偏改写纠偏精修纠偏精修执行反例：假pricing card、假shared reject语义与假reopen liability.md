# 治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行反例：假pricing card、假shared reject语义与假reopen liability

这一章不再回答“治理 refinement correction refinement execution 该怎样运行”，而是回答：

- 为什么团队明明已经写了 `pricing card`、shared `reject order` 与 `reopen drill`，仍会重新退回假 `pricing card`、假 shared `reject` 语义与假 `reopen liability`。

它主要回答五个问题：

1. 为什么治理 refinement correction refinement execution 最危险的失败方式不是“没有 card”，而是“card 存在，却仍围绕 mode calmness、usage calmness、approval calmness、classifier 已跑过与继续惯性工作”。
2. 为什么假 `pricing card` 最容易把 `authority mode`、`action candidate`、`decision window`、`continuation gate`、`classifier pricing` 与 `repair attestation` 重新退回更保守的值班说明。
3. 为什么假 shared `reject` 语义最容易把宿主、CI、评审与交接重新拆成四套不同的继续标准。
4. 为什么假 `reopen liability` 最容易把 classifier 定价、writeback round-trip、ingress lineage 与 future reopen 的正式追责能力重新退回默认继续与责任模糊。
5. 怎样用苏格拉底式追问避免把这些反例读成“把治理值班卡再写严一点就好”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/Tool.ts:123-176`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-619`
- `claude-code-source-code/src/utils/permissions/PermissionMode.ts:111-181`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-1318`
- `claude-code-source-code/src/utils/permissions/yoloClassifier.ts:1175-1312`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/utils/analyzeContext.ts:918-1382`
- `claude-code-source-code/src/utils/sessionState.ts:15-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:4-112`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-211`

这些锚点共同说明：

- 治理 refinement correction refinement execution 真正最容易失真的地方，不在 `pricing card` 有没有写出来，而在 authority、action、window、continuation、classifier、reject、writeback、ingress、threshold 与 liability 是否仍围绕同一个治理对象继续统一定价一切扩张。

## 1. 第一性原理

治理 refinement correction refinement execution 最危险的，不是：

- 没有 `pricing card`
- 没有 shared `reject order`
- 没有 `reopen drill`

而是：

- 这些东西已经存在，却仍然围绕 mode 更安静、usage 更好看、审批窗口消失、classifier 跑过一次与“目前还没爆预算”运作

一旦如此，团队就会重新回到：

1. 看 mode 是不是恢复正常。
2. 看 usage 图是不是更低。
3. 看 `pending_action` 是否已经消失。
4. 看 classifier 是不是已经跑过。
5. 看 token 似乎还够不够。

而不再围绕：

- 同一个 `permission_mode_external + action_candidate_ref + decision_window + continuation_action + classifier_cost_usd + writeback_attested + ingress_head_uuid + threshold_retained_until + liability_owner`

## 2. 假pricing card：card by calmer dashboard

### 坏解法

- 宿主、CI、评审与交接系统虽然都拿到了 `pricing_card_id` 与 `shared_reject_verdict=steady_state_chain_resealed`，但真正执行时只要 mode calmer、usage 转绿、审批面板安静、宿主没继续报错，就默认 `permission_mode_external`、`action_candidate_ref`、`decision_window`、`continuation_action`、`classifier_cost_usd` 与 `repair_attestation_id` 仍围绕同一个治理对象成立。

### 为什么坏

- 治理 `pricing card` 保护的不是“现在更像一张正式控制卡”，而是 later 消费者仍在消费同一个统一定价控制对象。
- `control_request.can_use_tool` 证明先被定价的是动作候选，不是事后解释。
- `get_context_usage` 证明 `Context Usage` 先是 `decision window`，不是仪表盘装饰。
- `checkTokenBudget()` 证明 continuation 先是时间定价，不是默认免费续聊。
- classifier telemetry 证明安全判断本身也有成本，不应只留在埋点里。
- 一旦 card 退回 calmer dashboard，团队就会重新容忍：
  - `authority` 只是 mode 名字
  - `action candidate` 只是过程说明
  - `window` 只是图表百分比
  - `classifier` 只是安全感
  - `repair attestation` 只是“大家都同意了”

### Claude Code 式正解

- `shared_reject_verdict` 应先绑定同一个 `permission_mode_external + action_candidate_ref + decision_window + continuation_action + classifier_cost_usd + repair_attestation_id`，再宣布 `steady_state_chain_resealed`。

## 3. 假shared reject语义：reject by price blindness and role split

### 坏解法

- 宿主认为“没有 pending action 了，所以可以继续”。
- CI 认为“预算还没爆，所以不用 reject”。
- 评审认为“classifier 已经跑过一次，所以安全也差不多了”。
- 交接认为“ingress 能恢复，所以 later 团队接手时再补票也行”。

表面上四方都在复述同一张 `pricing card`，实际上他们消费的是四个不同对象：

1. UI blocker projection
2. budget projection
3. safety projection
4. restore projection

### 为什么坏

- shared `reject order` 保护的不是“大家都写了 reject 这个词”，而是四类消费者必须围绕同一个统一定价对象、同一条阻断链说话。
- 安全设计与省 token 设计真正同构的地方，不是它们都很保守，而是它们都拒绝未定价扩张。
- 一旦 shared `reject` 退回 price blindness，团队就会最先误以为：
  - “pending action 没了就说明 control object 健康”
  - “预算还够就说明继续值得”
  - “classifier 看过就说明 classifier 成本已经入账”
  - “恢复能成功就说明责任链也没断”

### Claude Code 式正解

- shared `reject order` 必须先证明 `permission_mode_external + action_candidate_ref + decision_window + continuation_action + classifier_cost_usd + writeback_attested + ingress_head_uuid` 仍围绕同一个治理对象，再决定 `steady_state_chain_resealed`、`pricing_reseal_required`、`classifier_pricing_unattested`、`reentry_required` 或 `reopen_required`。

## 4. 假reopen liability：liability by default continue and blurred ownership

### 坏解法

- 团队虽然写了 `reopen drill`，但真正保留责任时只是在工单里写“如果后面有问题再回滚”“目前还没超预算”“later 团队可继续保守一点”，却没有正式绑定 `classifier_cost_usd`、`writeback_attested`、`ingress_head_uuid`、`liability_owner`、`threshold_retained_until` 与 `reopen_required_when`。

### 为什么坏

- classifier 定价保护的不是“已经做过安全检查”，而是安全检查本身已被纳入成本链。
- writeback seam 保护的不是“宿主现在安静”，而是治理真相已经正式写回宿主。
- ingress lineage 保护的不是“恢复还能用”，而是 later 团队接回的是同一条责任链。
- 一旦 `reopen liability` 退回默认继续与责任模糊，治理 refinement correction refinement execution 就会重新退回：
  - free continuation
  - unpaid classifier
  - unowned liability
  - reopen by inertia

### Claude Code 式正解

- `reopen liability` 必须显式绑定 `classifier_cost_usd + writeback_attested + ingress_head_uuid + liability_owner + threshold_retained_until + reopen_required_when`，并把 later 团队应返回的治理对象写清楚。

## 5. 从更多角度看它为什么迷惑

这类假象之所以迷惑，至少有五个原因：

1. 它借用了 Claude Code 真正严格的外观：审批、usage、classifier、pending action、restore 都看起来像在认真治理。
2. 它满足了不同角色最容易满足的局部需求：宿主要不报错，CI 要不过线，评审要能解释，交接要能接上。
3. 它把统一定价控制面偷换成了多个看起来都合理的治理投影。
4. 它把 future reopen 的正式责任偷换成了“先保守一点”的值班态度。
5. 它把安全与节制的共同第一性原理偷换成了更像审慎的语气。

## 6. 苏格拉底式自检

在你准备宣布“治理精修执行没有漂移”前，先问自己：

1. 我现在共享的是同一个统一定价对象，还是四份彼此相像的治理投影。
2. 我现在共享的是同一条 `reject` 语义链，还是四个角色各自的继续阈值。
3. 我现在保留的是 formal reopen 能力，还是默认继续之后的补救愿望。
4. later 团队如果拿不到当前值班感觉，是否仍能只凭 card 复算 authority、pricing、writeback 与 threshold。
5. 我现在保护的是 Claude Code 的安全设计与省 token 设计，还是只是在模仿它们更谨慎的外观。
