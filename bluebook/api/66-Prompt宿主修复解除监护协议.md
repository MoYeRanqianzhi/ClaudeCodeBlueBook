# Prompt宿主修复解除监护协议：Authority、Boundary、Transcript、Lineage、Continuation 与 residual reopen gate

这一章不是新的 Prompt 前门，而是 Prompt 主链已经成立之后的一条专题侧门：

- 它回答的不是“什么是 Prompt contract”，而是“在 post-watch / post-monitor 阶段，哪些 reopen 责任仍必须保留”

因此这页继续继承同一条 same-world compiler：

1. `Authority`
2. `Boundary`
3. `Transcript`
4. `Lineage`
5. `Continuation`
6. `Explainability`

## 0. 第一性原理

Prompt 宿主修复解除监护真正要宣布的不是：

- watch window 里最近没有告警
- watch note 已经写完整了
- handoff 包似乎还能继续读

而是：

- 当前世界已经不再需要额外盯防，但 residual reopen 的正式能力仍被保留

所以这页最先要看的不是：

- `watch release object` 已经存在

而是：

1. Authority 是否仍由同一个 winner 定义。
2. Boundary 是否仍保住 stable prefix 与 lawful forgetting。
3. Transcript 是否仍是模型真实消费的历史，而不是 watch note 的摘要版本。
4. Lineage 是否仍能让 later 团队不继承值班者记忆也继续接手。
5. Continuation 是否只是从“被监护资格”升级成“可继续资格”，而不是滑向默认继续。
6. residual reopen gate 是否仍保留，而不是跟着监护一起被删掉。

## 1. 哪些对象必须被消费

### 1.1 `Authority`

宿主至少应消费：

1. `authority_winner_ref`
2. `restored_request_object_id`
3. `compiled_request_hash`
4. `watch_window_id`

### 1.2 `Boundary`

宿主还必须消费：

1. `section_registry_snapshot`
2. `stable_prefix_boundary`
3. `lawful_forgetting_boundary`
4. `baseline_drift_ledger_seal`

### 1.3 `Transcript`

宿主还必须消费：

1. `protocol_truth_witness`
2. `transcript_boundary_attested`
3. `projection_demoted`

### 1.4 `Lineage`

宿主还必须消费：

1. `truth_lineage_ref`
2. `compaction_lineage_ref`
3. `resume_lineage_attested`
4. `handoff_release_warranty`

### 1.5 `Continuation`

宿主还必须消费：

1. `continuation_clearance`
2. `required_preconditions`
3. `rollback_boundary`
4. `residual_reopen_gate`
5. `clearance_expires_at`

### 1.6 `Explainability`

最后才允许暴露：

1. `release_card_id`
2. `release_verdict`
3. `release_reason`
4. `watch_note_ref`
5. `handoff_prose_ref`

`release card / watch note / prose` 只配当末端投影，不能再定义 released 与否。

## 2. 解除监护顺序建议

更稳的顺序是：

1. 先验 `Authority`
2. 再验 `Boundary`
3. 再验 `Transcript`
4. 再验 `Lineage`
5. 再验 `Continuation`
6. 最后才给 `Explainability`

不要反过来做：

1. 不要先看最近是否无事发生。
2. 不要先看 watch note 是否完整。
3. 不要先看 later 团队是否主观放心。

## 3. release verdict：必须共享的 post-watch 语义

更成熟的 Prompt 宿主解除监护 verdict 至少应共享下面枚举：

1. `released`
2. `release_blocked`
3. `monitor_extended`
4. `authority_recheck_required`
5. `boundary_unsealed`
6. `transcript_reconsume_required`
7. `continuation_not_cleared`
8. `residual_gate_missing`
9. `reopen_required`

更值得长期复用的 reject trio 仍是：

1. `authority_blur`
2. `transcript_conflation`
3. `continuation_story_only`

## 4. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. watch note 长文
2. “无告警时长”单值
3. handoff prose 摘要
4. raw transcript line count
5. compact 后页面长度
6. 最后一条消息文本
7. release 按钮状态
8. reviewer 自由文本安抚

它们可以是解除监护线索，但不能是解除监护对象。

## 5. 苏格拉底式检查清单

在你准备宣布“Prompt 宿主修复已经 released”前，先问自己：

1. 我现在 release 的是对象，还是一段更顺滑的值班叙事。
2. `stability witness` 证明的是稳定，还是只是平静。
3. `baseline drift ledger seal` 真的 seal 了 drift，还是只是暂时没人再看。
4. handoff release 释放的是 continuation object，还是一段摘要故事。
5. residual reopen gate 还在不在；如果不在，我是在 release，还是在删风险痕迹。

## 6. 一句话总结

Claude Code 的 Prompt 宿主修复解除监护协议，不是观察期结束说明 API，而是 `Authority + Boundary + Transcript + Lineage + Continuation` 共同证明“可以停止额外监护”，同时把 `residual reopen gate` 继续留在场上。
