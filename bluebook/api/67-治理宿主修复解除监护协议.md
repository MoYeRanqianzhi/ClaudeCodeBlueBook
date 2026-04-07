# 治理宿主修复解除监护协议：governance key、typed ask、decision window、continuation pricing 与治理侧 reopen liability

这一章不是新的高阶前门，而是治理主链已经成立之后的一条治理侧门：

- 它回答的不是“统一定价治理为什么成立”，而是“在 post-watch / post-monitor 阶段，治理对象怎样合法解除额外看护，同时仍保留治理侧 residual liability”

因此这页继续继承同一条治理主链：

1. `governance key`
2. `externalized truth chain`
3. `typed ask`
4. `decision window`
5. `continuation pricing`
6. `durable-transient cleanup`

## 0. 第一性原理

治理解除监护真正要宣布的不是：

- mode 现在看着很稳
- usage 面板重新转绿
- later 团队愿意先保守一点

而是：

- 当前治理对象已经不再需要额外看护，但治理侧 residual liability 仍被保留

所以这页最先要看的不是：

- `authority release` 或 `reopen liability record` 已经出现

而是：

1. `governance key` 是否仍由同一 authority source 链定义。
2. `externalized truth chain` 是否仍忠实外化当前窗口和状态。
3. `typed ask` 是否已清尾，而不是只是看起来没有 modal 了。
4. `decision window` 是否真的退出，而不是只让 usage 条消退。
5. `continuation pricing` 是否真的结算，而不是把时间重新免费化。
6. `durable-transient cleanup` 是否真的释放了隔离与残留责任，而不是把 liability 只留在说明里。

## 1. 必须消费的治理 post-watch 对象

### 1.1 `governance key`

宿主至少应消费：

1. `governance_object_id`
2. `authority_source_before_release`
3. `authority_source_after_release`
4. `effective_settings_projection`
5. `writer_chokepoint`

### 1.2 `externalized truth chain`

宿主还必须消费：

1. `session_state_changed`
2. `worker_status`
3. `external_metadata`
4. `release_generation`
5. `release_evaluated_at`

### 1.3 `typed ask`

宿主还必须消费：

1. `typed_decision_digest`
2. `permission_ledger_state`
3. `pending_permission_requests`
4. `late_permission_response`
5. `residue_cleared`

### 1.4 `decision window`

宿主还必须消费：

1. `decision_window`
2. `pending_action_cleared`
3. `context_usage_snapshot`
4. `reserved_buffer`
5. `window_exit_attested`

### 1.5 `continuation pricing`

宿主还必须消费：

1. `continuation_settlement`
2. `token_budget_result`
3. `settled_price`
4. `next_action_allowed`
5. `settlement_expires_at`

### 1.6 `durable-transient cleanup`

最后才允许暴露：

1. `quarantine_scope`
2. `rollback_object`
3. `baseline_reset_required`
4. `quarantine_cleared`
5. `reopen_liability_record`

这里最重要的是：

- `reopen liability` 在这一页只属于治理对象链的尾段责任，不是 Prompt `Continuation` 的通用别名，也不是结构 `reservation boundary` 的跨页主语

## 2. release verdict：必须共享的治理侧语义

更成熟的治理宿主解除监护 verdict 至少应共享下面枚举：

1. `released`
2. `release_blocked`
3. `monitor_extended`
4. `free_continuation_rejected`
5. `quarantine_not_released`
6. `dashboard_release_rejected`
7. `reopen_liability_retained`
8. `reopen_required`

更值得长期复用的治理 reject trio 仍是：

1. `projection_usurpation`
2. `decision_window_collapse`
3. `free_expansion_relapse`

## 3. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. runtime internal mode 全集
2. dashboard 颜色
3. token 百分比单值
4. 审批弹窗 UI 状态
5. `allow: boolean`
6. later 团队的保守建议
7. 内部 classifier 细节
8. 口头补写的观察说明

它们可以是解除监护线索，但不能是解除监护对象。

## 4. 解除监护顺序建议

更稳的顺序是：

1. 先验 `governance key`
2. 再验 `externalized truth chain`
3. 再验 `typed ask`
4. 再验 `decision window`
5. 再验 `continuation pricing`
6. 最后验 `durable-transient cleanup`

不要反过来做：

1. 不要先看 mode 面板。
2. 不要先看 usage 图表。
3. 不要先看 later 团队是否主观放心。

## 5. 苏格拉底式检查清单

在你准备宣布“治理宿主修复已经 released”前，先问自己：

1. 我现在 release 的是治理对象，还是一段更顺滑的运营叙事。
2. `decision window` 真的退出了吗，还是只是仪表盘安静了。
3. `continuation pricing` 真的结算了吗，还是又把时间默认免费化了。
4. `reopen liability` 还在治理尾段里吗，还是已经漂成跨页借词。
5. 如果把面板、modal 和说明文字都藏起来，later 团队是否仍知道该如何继续治理判断。

## 6. 一句话总结

Claude Code 的治理宿主修复解除监护协议，不是观察期结束审批 API，而是 `governance key + externalized truth chain + typed ask + decision window + continuation pricing + durable-transient cleanup` 在 post-watch 阶段的治理侧结算与 residual liability 保留。
