# Rollout证据消费API手册：worker_status、external_metadata、Context Usage与回退对象边界

这一章回答五个问题：

1. 宿主到底该消费哪些正式 API / 状态面，才能把 rollout 证据做成可运营、可回退的知识面。
2. 为什么 `worker_status`、`external_metadata`、`session_state_changed`、`Context Usage` 与 control 事件必须挂回同一条治理链。
3. 哪些字段属于正式可消费 surface，哪些仍只能停在宿主自建 envelope 或 internal hint。
4. 为什么回退边界必须先按对象写入证据，而不是按文件或 commit 写入。
5. 宿主开发者该按什么顺序接入这套 rollout 证据消费面。

## 0. 第一性原理

Claude Code 当前并没有公开一份单独名为：

- `rollout_evidence`

的 API 对象。

但这不意味着宿主该自己发明一条 rollout 世界观。更稳的做法是把现有正式外化面，压回同一条治理判断链：

1. `governance key`
2. `externalized truth chain`
3. `typed ask`
4. `decision window`
5. `continuation pricing`
6. `durable-transient cleanup`

`Rollout 证据消费 API` 不是第七个根对象，它只是宿主按这条链组合消费正式 surface 的纪律。

## 1. 正式 surface、宿主 envelope 与 internal hint

更准确地说，rollout 证据面应分成三层：

1. 正式可消费 surface
   - `session_state_changed`
   - `worker_status`
   - `external_metadata`
   - `requires_action_details`
   - `Context Usage`
   - control request / response / cancel
2. 宿主自建 envelope
   - observed window
   - object card
   - evidence card
   - cleanup card
3. internal hints
   - `promptCacheBreakDetection` 细项
   - bridge pointer 文件
   - task framework 内部 patch / eviction 细节

这三层必须分开写。否则宿主很容易把内部实现细节误当成公共契约。

## 2. 把 rollout 证据挂回 canonical governance chain

### 2.1 `governance key`

宿主在 rollout 场景里，至少仍要承认：

1. `permission_mode`
2. `model`
3. `is_ultraplan_mode`

这些字段回答的不是“面板当前显示什么模式”，而是：

- 当前 rollout 到底围绕哪种边界和执行上下文在继续

### 2.2 `externalized truth chain`

宿主必须先消费：

1. `worker_status`
2. `session_state_changed`
3. `external_metadata`

这三组字段共同回答：

- 当前 worker 在做什么
- 当前 turn 是否已经正式结束
- 当前模式、摘要、阻塞信息怎样被正式外化

如果宿主不先消费这三组 surface，就只能靠 transcript、event replay 或作者说明自己拼“当前真相”。

### 2.3 `typed ask`

rollout 证据还必须独立消费：

1. `request_id`
2. `tool_use_id`
3. `pending_action`
4. request / response / cancel race
5. winner side
6. latency

关键问题不是：

- 有无 ask

而是：

- ask 是否仍是同一事务
- 谁在何时以何种结果赢下仲裁

### 2.4 `decision window`

`Context Usage`、budget 决策与当前状态一起回答的不是：

- 最终花了多少 token

而是：

- 这轮继续花 token 是否还有制度收益

因此宿主至少应把下面字段并排写成同一窗口：

1. `Context Usage`
2. observed window
3. `continuationCount`
4. `diminishingReturns`
5. current `pending_action`
6. current `worker_status`

`Context Usage` 首先是 `decision window` 的诚实投影，不是成本账单页。

### 2.5 `continuation pricing`

宿主还必须显式消费：

1. continue / stop / upgrade judgement
2. `continuationCount`
3. `diminishingReturns`
4. stop reason
5. upgrade reason

这里最重要的不是“现在还能不能跑”，而是：

- 继续到底还值不值得付这个时间价格

### 2.6 `durable-transient cleanup`

最后还必须写清：

1. `rollback_object_type`
2. `rollback_object_id`
3. `retained_assets`
4. `dropped_stale_writers`
5. evidence refs

这回答的不是“回退了哪些文件”，而是：

- 当前 cleanup 在恢复哪个对象
- 哪些资产保留，哪些 stale writer 已被清掉

## 3. 宿主最小 rollout record

更稳的宿主接法，不是等待产品将来提供一个单独 API，而是先在现有正式 surface 上建立最小 record：

```text
record_header:
- record_id
- governance_key_ref
- truth_chain_ref
- typed_ask_ref
- decision_window_ref
- continuation_pricing_ref
- cleanup_carrier_ref

current_truth:
- worker_status
- session_state_changed
- external_metadata

decision_window:
- context_usage
- observed_window
- continuation_count
- diminishing_returns
- judgement

control_evidence:
- request_id
- tool_use_id
- pending_action
- winner_source
- latency

cleanup:
- rollback_object_type
- rollback_object_id
- retained_assets
- dropped_stale_writers
- evidence_refs
```

这份 record 里：

- 左边的字段名可以由宿主自定
- 右边的数据来源应尽量来自正式 surface

## 4. First Reject Signals

这页真正值钱的 reject trio 只有三条：

1. 把 `Context Usage` 当成账单页
2. 把 event replay 当成当前真相
3. 把文件回退当成对象回退

它们分别对应：

1. `decision_window_collapse`
2. `externalized_truth_chain_missing`
3. `cleanup_not_object`

## 5. 宿主接入顺序

如果你要让宿主真正消费 rollout 证据，建议顺序是：

1. 先接 `worker_status + session_state_changed + external_metadata`
2. 再接 `request_id + tool_use_id + pending_action + winner_source`
3. 再接 `Context Usage + observed_window + continuation judgement`
4. 最后再把 cleanup 对象和 internal hints 作为附件接进来

不要反过来：

1. 先抓内部 diff
2. 再去猜当前状态

那样很容易把细节看得很多，却仍然不知道当前到底该继续、暂停、升级还是 cleanup。

## 6. 宿主实现者的五条纪律

1. 不要只消费 assistant 最终输出，忽略 `worker_status` 与 `session_state_changed`。
2. 不要自己猜 permission mode，优先消费 `external_metadata` 的 authoritative snapshot。
3. 不要把 token 总量当成全部成本证据，优先补上 `decision window`。
4. 不要把 internal hints 直接升格成公共稳定契约。
5. 不要把 cleanup 写成文件列表，优先写成对象边界与 retained assets。

## 7. 苏格拉底式追问

在你准备宣布“rollout 证据消费已经稳定”前，先问自己：

1. 我消费的是同一条治理链，还是几张状态卡的并列拼贴。
2. `pending_action` 在这里还是事务对象，还是只剩一句“卡住了”。
3. `Context Usage` 在这里是在解释 decision window，还是只在提醒成本压力。
4. cleanup 恢复的是当前对象，还是一组文件文本。
5. 如果把 event replay 和 dashboard 藏起来，宿主是否仍知道现在该继续、停止还是 cleanup。

## 8. 一句话总结

Claude Code 的 rollout 证据消费 API，并不是一个单独 endpoint，而是把 `worker_status + external_metadata + session_state_changed + control evidence + Context Usage + cleanup boundary` 组合挂回同一条治理判断链的消费纪律。
