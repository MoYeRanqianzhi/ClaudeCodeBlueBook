# 结构宿主修复稳态纠偏再纠偏改写纠偏精修协议：authority head covenant、single-source merge custody、lineage anti-zombie packet、transport fail-closed attestation、current-truth attestation 与 reopen liability ledger

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象，让宿主、CI、评审与交接在结构 rewrite correction 固定顺序已经被钉死之后，继续消费同一个结构真相面，而不是退回更工整的架构说明。
2. 哪些字段属于必须共享的宿主消费对象，哪些属于 `hard_reject / reentry / reopen` 语义，哪些仍不应被绑定成公共 ABI。
3. 为什么 Claude Code 的源码先进性来自 authority、single-source writeback、lineage、fresh merge、anti-zombie、transport boundary 与 dirty git fail-closed 这些正式结构对象，而不是“架构整洁度”。
4. 宿主开发者该按什么顺序消费这套结构 rewrite correction 精修协议。
5. 哪些现象一旦出现，应被直接升级为 `hard_reject`、`merge_reproof_required`、`transport_reseal_required`、`fail_closed_reseal_required` 或 `reopen_required`，而不是继续宣称结构已经重新稳定。

## 0. 关键源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/handlePromptSubmit.ts:430-517`
- `claude-code-source-code/src/utils/task/framework.ts:77-248`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:186-230`
- `claude-code-source-code/src/utils/conversationRecovery.ts:375-400`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-211`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/cli/structuredIO.ts:362-657`
- `claude-code-source-code/src/utils/worktree.ts:1046-1172`
- `claude-code-source-code/src/cli/transports/SSETransport.ts:149-457`
- `claude-code-source-code/src/cli/ndjsonSafeStringify.ts:24-31`

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `StructureRewriteCorrectionRefinementContract`

的单独公共对象。

但结构 rewrite correction 精修协议已经能围绕十类正式对象稳定成立：

1. `rewrite_refinement_session_object`
2. `false_surface_demotion_contract`
3. `authority_head_covenant`
4. `single_source_merge_custody`
5. `lineage_anti_zombie_packet`
6. `transport_fail_closed_custody`
7. `hard_reject_semantics_abi`
8. `current_truth_surface_attestation_packet`
9. `reopen_liability_ledger`
10. `rewrite_refinement_verdict`

本页的 `authority head / single-source merge / lineage anti-zombie / transport fail-closed / reopen liability` 只是结构 packet layer，不是新的 frontdoor chain；真正的前门仍应回到 `current-truth surface -> writer chokepoint -> freshness gate -> fail-closed boundary -> later reject path`。

更成熟的结构 rewrite correction 方式不是：

- 只看 pointer 还在
- 只看 telemetry 重新转绿
- 只看 architecture prose 更完整

而是：

- 围绕这十类对象继续消费同一个 authority object、同一条单一写回路径、同一份 lineage chain、同一份 fresh merge 契约、同一套 anti-zombie 证据、同一条 transport boundary 与同一个 reopen boundary

## 2. 第一性原理

Claude Code 的源码先进性不来自“目录漂亮”，而来自正式结构对象真的决定了谁能说真话：

1. `authority surface` 决定谁是唯一主语。
2. `single-source writeback` 决定哪些写回有资格进入真相链。
3. `lineage` 决定恢复的是不是同一个对象。
4. `fresh merge` 决定旧 finally、旧 append、旧 snapshot 能否迟到篡位。
5. `anti-zombie` 决定旧 generation 与孤儿 writer 是否真的失效。
6. `transport boundary` 决定远端、本地与 projection 只允许哪一种消息语义。
7. `dirty git fail-closed` 决定系统在脏状态下是否拒绝继续制造第二真相。
8. `reopen liability` 决定 later 团队能否正式反驳当前结构结论。

所以这一层真正保护的不是：

- “系统看起来又健康了”

而是：

- 作者退场之后，later 维护者仍能只凭正式对象重建同一结构判断

## 3. 会话、降级与 authority head 契约

结构宿主至少应围绕下面对象消费 rewrite correction 精修真相：

### 3.1 rewrite refinement session object

1. `refinement_session_id`
2. `rewrite_correction_session_id`
3. `authority_object_id`
4. `rewrite_generation`
5. `shared_consumer_surface`
6. `reprotocol_started_at`

### 3.2 false surface demotion contract

1. `demoted_surface_refs`
2. `pointer_not_authority`
3. `telemetry_not_evidence`
4. `archive_prose_not_truth`
5. `projection_only_refs`
6. `false_surface_frozen_at`

### 3.3 authority head covenant

1. `authority_object_id`
2. `authoritative_path`
3. `externally_verifiable_head`
4. `writer_chokepoint`
5. `authority_restituted_at`

这些对象回答的不是：

- 当前哪个入口看起来更新

而是：

- 当前到底先降级了哪些假 surface，并把哪一个 authority head 正式交还给 later 消费者

## 4. single-source merge 与 lineage anti-zombie 托管

结构宿主还必须显式消费：

### 4.1 single source merge custody

1. `single_source_ref`
2. `writeback_primary_path`
3. `append_chain_ref`
4. `side_write_quarantined`
5. `fresh_merge_contract`
6. `deletion_semantics_attested`
7. `stale_finally_suppressed`
8. `merge_contract_attested`

### 4.2 lineage anti zombie packet

1. `session_id_ref`
2. `transcript_path_ref`
3. `worktree_session_ref`
4. `generation_ref`
5. `resume_lineage_ref`
6. `lineage_reproof_ref`
7. `anti_zombie_evidence_ref`
8. `orphan_duplicate_quarantined`
9. `assistant_sentinel_attested`

这里最重要的是：

- `fresh merge` 不是 last-write-wins
- `lineage` 不是一次幸运 reconnect
- `anti-zombie` 不是“现在很安静”，而是旧 writer 与旧 generation 真的失去写回资格

## 5. transport、fail-closed 与 reopen 责任账本

结构宿主还必须显式消费：

### 5.1 transport fail closed custody

1. `transport_boundary_attested`
2. `bridge_transport_ref`
3. `writeback_transport_ref`
4. `single_message_semantics_attested`
5. `dirty_git_fail_closed_attested`
6. `worktree_change_guard`
7. `unpushed_commit_guard`
8. `cleanup_skip_contract_attested`

### 5.2 hard reject semantics abi

1. `hard_reject`
2. `merge_reproof_required`
3. `transport_reseal_required`
4. `fail_closed_reseal_required`
5. `reentry_required`
6. `reopen_required`
7. `pointer_as_authority`
8. `head_not_externally_verifiable`
9. `single_source_ref_missing`
10. `fresh_merge_contract_missing`
11. `anti_zombie_evidence_missing`
12. `transport_second_semantics_detected`
13. `dirty_git_fail_open`
14. `reopen_liability_missing`

### 5.3 current-truth surface attestation packet

1. `host_consumer_ref`
2. `ci_consumer_ref`
3. `reviewer_consumer_ref`
4. `handoff_consumer_ref`
5. `shared_consumer_surface`
6. `authority_generation`
7. `transport_generation`
8. `attested_at`

### 5.4 reopen liability ledger

1. `reopen_boundary`
2. `reservation_owner`
3. `threshold_retained_until`
4. `return_authority_object`
5. `return_writeback_path`
6. `return_generation_floor`
7. `reopen_required_when`
8. `dirty_git_fail_closed_attested`

这里最重要的是：

- `current-truth attestation` 不是“更多人都看过”，而是 display / event / handoff projection 继续被压回同一个 current-truth surface
- `transport boundary` 不是通信实现细节，而是结构真相面的一部分
- `dirty git fail-closed` 不是团队礼仪，而是正式结构对象
- `reopen liability ledger` 保护的是未来仍能沿同一 authority/writeback/boundary 链反驳当前结构状态

## 6. rewrite refinement verdict

结构 rewrite correction 精修协议还必须消费：

1. `steady_state_chain_resealed`
2. `hard_reject`
3. `merge_reproof_required`
4. `transport_reseal_required`
5. `fail_closed_reseal_required`
6. `reentry_required`
7. `reopen_required`
8. `shared_consumer_surface_broken`
9. `authority_head_missing`
10. `lineage_anti_zombie_broken`

这些 verdict reason 的价值在于：

- 把“结构真相面已经从 fixed rewrite correction order 继续压回正式共享对象”翻译成宿主、CI、评审与交接都能共同消费的 reject / escalation 语义

## 7. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. pointer mtime
2. reconnect 按钮状态
3. telemetry 绿灯
4. 单次截图
5. archive prose 摘要
6. 作者口头说明
7. “最近没再出事”的健康感
8. 临时 sidecar 的存在感

它们可以是线索，但不能是结构 rewrite correction 精修对象。

## 8. 消费顺序建议

更稳的顺序是：

1. 先验 `rewrite_refinement_session_object`
2. 再验 `false_surface_demotion_contract`
3. 再验 `authority_head_covenant`
4. 再验 `single_source_merge_custody`
5. 再验 `lineage_anti_zombie_packet`
6. 再验 `transport_fail_closed_custody`
7. 再验 `hard_reject_semantics_abi`
8. 再验 `current_truth_surface_attestation_packet`
9. 最后验 `reopen_liability_ledger`
10. 再给 `rewrite_refinement_verdict`

不要反过来做：

1. 不要先看 pointer。
2. 不要先看监控转绿。
3. 不要先看作者是否主观放心。

## 9. 苏格拉底式检查清单

在你准备宣布“结构已完成 rewrite correction 精修协议”前，先问自己：

1. 我现在修回的是同一个 authority object，还是只是把入口感重新包装了一遍。
2. 我现在保住的是 `single-source + fresh merge`，还是几次幸运 reconnect 的结果。
3. 我现在保住的是 `lineage + anti-zombie`，还是一张安静的 telemetry 面板。
4. 我现在保住的是 `transport boundary + dirty git fail-closed`，还是“当前没报错”的侥幸。
5. later 团队明天如果必须 reopen，依赖的是正式 reopen liability，还是一句“以后再试一次”。

## 10. 一句话总结

Claude Code 的结构 rewrite correction 精修协议，不是把健康感写成更正式的流程，而是 `authority_head_covenant + single_source_merge_custody + lineage_anti_zombie_packet + transport_fail_closed_custody + hard_reject_semantics_abi + reopen_liability_ledger` 共同组成的结构真相面。
