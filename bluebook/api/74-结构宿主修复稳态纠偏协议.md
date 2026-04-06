# 结构宿主修复稳态纠偏协议：authority rebind、resume lineage rebuild、writeback recustody、anti-zombie reproof、archive truth restitution与reopen reservation rebinding

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象让宿主、SDK、CI、评审与交接系统在结构 steady-state correction 之后消费同一个修正对象、拒收升级语义与长期 reopen 责任。
2. 哪些字段属于必须消费的结构 steady-state correction object，哪些属于 verdict 语义，哪些仍然不应被绑定成公共 ABI。
3. 为什么结构稳态纠偏协议不应退回 pointer 健康感、telemetry 转绿、archive prose 与作者说明。
4. 宿主开发者该按什么顺序消费这套结构 steady-state correction 规则面。
5. 哪些现象一旦出现应被直接升级为 `hard_reject`、`reentry_required` 或 `reopen_required`，而不是继续宣布结构已经重新稳定。

## 0. 关键源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/handlePromptSubmit.ts:430-517`
- `claude-code-source-code/src/utils/task/framework.ts:77-248`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:533-570`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/utils/sessionState.ts:1-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:50-92`
- `claude-code-source-code/src/cli/structuredIO.ts:362-657`
- `claude-code-source-code/src/cli/print.ts:5048-5072`

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `StructureRepairSteadyStateCorrectionContract`

的单独公共对象。

但结构宿主修复稳态纠偏实际上已经能围绕八类正式对象稳定成立：

1. `steady_correction_object`
2. `authority_rebind`
3. `resume_lineage_rebuild`
4. `writeback_recustody`
5. `anti_zombie_reproof`
6. `archive_truth_restitution`
7. `reservation_rebinding`
8. `correction_verdict`

更成熟的结构稳态纠偏方式不是：

- 只看 pointer 还在
- 只看 telemetry 重新转绿
- 只看 archive prose 更完整
- 只看作者说“现在应该没问题了”

而是：

- 围绕这八类对象消费结构真相面怎样把假稳态重新拉回同一个 authority、同一个 resume lineage、同一个 writeback 主路径、同一套 anti-zombie 证据与同一个 reopen reservation boundary

这一层真正保护的不是：

- “系统感觉又健康了”

而是：

- 作者退场后，later 维护者仍能仅凭正式对象重建同一结构判断

## 2. steady correction object 与 authority rebind

宿主应至少围绕下面对象消费结构纠偏真相：

### 2.1 steady correction object

1. `steady_correction_object_id`
2. `authority_object_id`
3. `correction_generation`
4. `corrected_at`
5. `shared_consumer_surface`

### 2.2 authority rebind

1. `authority_state_surface`
2. `writer_chokepoint`
3. `worktree_scope`
4. `authority_rebound_at`
5. `pointer_projection_demoted`

这些字段回答的不是：

- 当前哪个 pointer 看起来还最新

而是：

- 当前到底围绕哪个 authority object、以哪个结构边界完成了稳态纠偏

## 3. resume lineage rebuild 与 writeback recustody

结构宿主还必须显式消费：

### 3.1 resume lineage rebuild

1. `resume_lineage_ref`
2. `worktree_resume_path`
3. `return_lineage`
4. `resume_order_verified`
5. `late_resume_blocked`

### 3.2 writeback recustody

1. `writeback_primary_path`
2. `worker_status`
3. `external_metadata`
4. `side_write_detected`
5. `writeback_custody_state`

这说明宿主当前消费的不是：

- 一次 reconnect 成功
- 一串更漂亮的 telemetry

而是：

- `resume lineage rebuild + writeback recustody` 共同组成的结构稳态纠偏证明

## 4. anti-zombie reproof、archive truth restitution 与 reservation rebinding

结构稳态纠偏还必须消费：

### 4.1 anti-zombie reproof

1. `anti_zombie_evidence_ref`
2. `stale_writer_evidence`
3. `orphan_session_resolved`
4. `transition_legality_snapshot`
5. `reactivation_trigger_registered`

### 4.2 archive truth restitution

1. `archive_truth_ref`
2. `archive_pointer`
3. `retired_surface_hash`
4. `author_memory_not_required`
5. `archive_truth_restituted_at`

### 4.3 reservation rebinding

1. `reopen_reservation_boundary`
2. `recovery_boundary`
3. `reservation_owner`
4. `threshold_retained_until`
5. `return_writeback_path`

这里最重要的是：

- `anti_zombie`、`archive truth` 与 `reservation` 不是后台清扫动作，而是宿主可消费的正式纠偏结果

它们回答的不是：

- 以后是不是还能再试一次 reconnect

而是：

- zombie 风险是否已被正式复证并归档
- archive 是否仍保留结构真相而不是只剩 prose
- future reopen 是否仍保留可回跳的正式边界

## 5. correction verdict：必须共享的纠偏语义

更成熟的结构宿主稳态纠偏 verdict 至少应共享下面枚举：

1. `steady_state_restored`
2. `hard_reject`
3. `reentry_required`
4. `reopen_required`
5. `authority_rebind_missing`
6. `resume_lineage_unproven`
7. `writeback_recustody_missing`
8. `anti_zombie_reproof_missing`

这些 verdict reason 的价值在于：

- 把“结构真相面已经从假稳态纠偏回正式对象”翻译成宿主、CI、评审与交接都能共享的 correction 语义

## 6. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. pointer mtime
2. reconnect 按钮状态
3. telemetry 绿灯
4. 单次截图
5. archive prose 摘要
6. 作者口头说明
7. “最近没再出事”的健康感
8. 临时 sidecar 的存在感

它们可以是纠偏线索，但不能是纠偏对象。

## 7. 纠偏消费顺序建议

更稳的顺序是：

1. 先验 `steady_correction_object`
2. 再验 `authority_rebind`
3. 再验 `resume_lineage_rebuild`
4. 再验 `writeback_recustody`
5. 再验 `anti_zombie_reproof`
6. 再验 `archive_truth_restitution`
7. 最后验 `reservation_rebinding`
8. 再给 `correction_verdict`

不要反过来做：

1. 不要先看 pointer。
2. 不要先看监控转绿。
3. 不要先看作者是否主观放心。

## 8. 苏格拉底式检查清单

在你准备宣布“结构已完成稳态纠偏”前，先问自己：

1. 我现在修回的是同一个 authority object，还是只是把入口感重新包装了一遍。
2. 我现在保住的是 `resume lineage`，还是几次幸运成功的 reconnect。
3. 我现在托管的是唯一 writeback 主路径，还是监控转绿带来的安心感。
4. 我现在归档的是 anti-zombie 证据，还是一段更会解释的 archive 文本。
5. later 团队明天如果必须 reopen，依赖的是正式 boundary，还是一句“以后再试一次”。

## 9. 一句话总结

Claude Code 的结构宿主修复稳态纠偏协议，不是把健康感写成更正式的流程，而是 `authority rebind + resume lineage rebuild + writeback recustody + anti-zombie reproof + archive truth restitution + reopen reservation rebinding` 共同组成的规则面。
