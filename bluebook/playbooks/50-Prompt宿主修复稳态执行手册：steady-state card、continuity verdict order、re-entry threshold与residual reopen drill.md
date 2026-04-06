# Prompt宿主修复稳态执行手册：Authority、Boundary、Transcript、Lineage、Continuation 与 Explainability 稳态回归

这一章不再把 `steady-state card` 当成 Prompt 稳态的主语，而是把 Claude Code 式 Prompt steady state 压回一条 same-world compiler 母线：

1. `Authority`
2. `Boundary`
3. `Transcript`
4. `Lineage`
5. `Continuation`
6. `Explainability`

它主要回答五个问题：

1. 为什么 Prompt 的魔力在稳态里执行的不是“最近一直很稳”，而是同一个世界仍被同一条编译链持续见证。
2. 宿主、CI、评审与交接怎样共享同一条 Prompt 稳态判断链，而不是各自围绕 `card / summary / handoff prose` 工作。
3. 应该按什么固定顺序执行 Authority、Boundary、Transcript、Lineage、Continuation 与 Explainability。
4. 哪些信号一旦出现就必须冻结 continuation、阻断 handoff，并进入 re-entry 或 residual reopen。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的 release 后观察表”。

## 0. 第一性原理

Prompt 宿主修复稳态真正要执行的不是：

- release 之后最近很平静
- compact summary 现在还读得通
- later 团队主观上觉得应该能继续

而是：

- 同一个 `authority winner -> boundary bundle -> protocol transcript -> lineage chain -> continuation qualification` 仍在共同定义同一个世界

因此这层 playbook 最先要看的不是：

- steady-state card 已经填完了

而是：

1. 当前谁还是定义这次 Prompt 世界的唯一 `authority winner`。
2. 当前哪些字节仍配作为同一世界的合法前缀与合法遗忘边界。
3. 当前 `protocol transcript` 是否仍是模型实际消费的历史，而不是 display transcript 的安静版本。
4. 当前 `truth lineage / compaction lineage / resume lineage` 是否仍在共同见证同一身份链。
5. 当前 `continuation qualification` 是否仍在保护同一个 current work、required assets 与 rollback boundary。
6. 所有 `card / verdict / note / prose` 是否都仍被降在 Explainability 末端。

## 1. 共享稳态记录只该服务这条链

更稳的共享记录，不是先列 `steady-state card` 字段，而是先按同一条母线归档：

### 1.1 Authority

1. `authority_winner_ref`
2. `restored_request_object_id`
3. `compiled_request_hash`
4. `authority_attested_at`

### 1.2 Boundary

1. `section_registry_snapshot`
2. `stable_prefix_boundary`
3. `lawful_forgetting_boundary`
4. `cache_break_budget`
5. `boundary_attested_at`

### 1.3 Transcript

1. `protocol_transcript_ref`
2. `tool_pairing_health`
3. `transcript_boundary_attested`
4. `display_projection_demoted`

### 1.4 Lineage

1. `truth_lineage_ref`
2. `compaction_lineage_ref`
3. `resume_lineage_attested`
4. `lineage_attested_at`

### 1.5 Continuation

1. `current_work_ref`
2. `required_assets`
3. `rollback_boundary`
4. `continue_qualification`
5. `token_budget_ready`
6. `reopen_threshold`

### 1.6 Explainability

1. `steady_state_card_id`
2. `steady_verdict`
3. `verdict_reason`
4. `handoff_prose_ref`

最后这一组只负责解释，不负责定义世界。

## 2. 固定稳态顺序

### 2.1 先验 `Authority`

先看当前准备宣布 steady 的，到底是不是同一个 `authority winner` 与同一个 `restored_request_object`。

只要 authority 不清楚，就不能进入 steady state。

### 2.2 再验 `Boundary`

再看 `section registry`、`stable prefix boundary`、`lawful forgetting boundary` 与 `cache break budget` 是否仍共同成立。

Prompt 的魔力保护的不是平静感，而是前缀资产与合法遗忘边界仍然成立。

### 2.3 再验 `Transcript`

再看当前 steady 所依赖的，究竟是不是同一个 `protocol transcript`。

只要 display transcript、summary prose、handoff prose 还能夺权，steady 就还没有成立。

### 2.4 再验 `Lineage`

再看 `truth lineage`、`compaction lineage` 与 `resume lineage` 是否仍共同见证同一身份链。

lineage 不成立，later 团队就会重新退回作者记忆与临场解释。

### 2.5 再验 `Continuation`

再看：

1. `continue_qualification` 是否仍然成立。
2. `current_work_ref`、`required_assets` 与 `rollback_boundary` 是否仍围绕同一 continuation object。
3. `reopen_threshold` 是否仍保留未来反对当前状态的正式能力。

没有 threshold 的继续，不叫 steady，只叫默认冲动。

### 2.6 最后才给 `Explainability`

最后才看：

1. `steady-state card`
2. `steady_verdict`
3. `verdict_reason`
4. `handoff prose`

这四类内容都只能作为 Explainability 末端投影发放，不能反向定义 Authority、Boundary、Transcript、Lineage 或 Continuation。

## 3. 直接阻断条件

出现下面情况时，应直接阻断当前 Prompt steady state：

1. `authority_blur`
2. `boundary_unsealed`
3. `transcript_conflation`
4. `lineage_unproven`
5. `continuation_story_only`
6. `reopen_threshold_missing`

## 4. continuation patrol 与 re-entry 顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先冻结新的 continuation 与 handoff，不再让 later 团队消费当前 steady-state 工件。
2. 先把 verdict 降级为 `steady_state_blocked` 或 `reentry_required`。
3. 先回到上一个仍可验证的 authority winner、boundary bundle 与 protocol transcript。
4. 先补新的 lineage、qualification 与 threshold，再允许重新发放 steady verdict。
5. 如果根因落在 release correction 制度本身，就回跳 `../guides/72` 做对象级纠偏。

## 5. 最小 residual reopen 演练集

每轮至少跑下面六个 Prompt 宿主稳态演练：

1. `authority_winner_recheck`
2. `boundary_bundle_reseal`
3. `protocol_transcript_reconsume`
4. `lineage_resume_reproof`
5. `continuation_qualification_recheck`
6. `reopen_threshold_replay`

## 6. 苏格拉底式检查清单

在你准备宣布“Prompt 已经 steady”前，先问自己：

1. 我现在保护的是 authority winner，还是一份更像样的稳态卡。
2. 我现在保护的是 stable prefix 与 lawful forgetting，还是一次暂时没出 cache break 的好运气。
3. 我现在保护的是 protocol transcript，还是一段更顺滑的 handoff prose。
4. 我现在保留的是 continuation qualification 与 reopen threshold，还是一句“后面继续就行”。
5. 如果把 card、verdict、note 与 prose 全部藏起来，later 团队是否仍能围绕同一世界继续判断。

## 7. 一句话总结

真正成熟的 Prompt 宿主修复稳态执行，不是宣布“released 之后一直很稳”，而是持续证明同一个 `Authority -> Boundary -> Transcript -> Lineage -> Continuation` 仍在共同定义世界，而 `Explainability` 只在末端诚实解释。
