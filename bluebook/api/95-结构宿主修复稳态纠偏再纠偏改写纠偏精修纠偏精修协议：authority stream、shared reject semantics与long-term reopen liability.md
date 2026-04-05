# 结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修协议：authority stream、shared reject semantics 与 long-term reopen liability

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象，让宿主、CI、评审与交接在结构 refinement correction refinement fixed order 已被钉死之后，继续消费同一个结构 repair truth，而不是退回更工整的架构说明、pointer 健康感与 reconnect 成功率。
2. 哪些字段属于必须共享的 protocol object，哪些属于共同 `hard_reject / reentry / reopen` 语义，哪些仍不应被绑定成公共 ABI。
3. 为什么 Claude Code 的源码先进性来自 authority stream、lineage/fresh merge、single-source writeback、anti-zombie、transport boundary 与 dirty git fail-closed 这些正式 protocol object，而不是“架构整洁度”。
4. 宿主开发者该按什么顺序消费这套结构 refinement correction refinement 精修协议。
5. 哪些现象一旦出现，应被直接升级为 `hard_reject`、`merge_reproof_required`、`shared_reject_rebind_required`、`reentry_required` 或 `reopen_required`，而不是继续宣称结构已经重新稳定。

## 0. 关键源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:186-230`
- `claude-code-source-code/src/utils/conversationRecovery.ts:375-400`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/utils/worktree.ts:1046-1172`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-211`
- `claude-code-source-code/src/cli/transports/SSETransport.ts:149-457`

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `StructureRefinementCorrectionRefinementProtocol`

的单独公共对象。

但结构 refinement correction refinement fixed order 已经能围绕九类正式对象稳定成立：

1. `repair_session_object`
2. `repair_authority_stream`
3. `lineage_fresh_merge_surface`
4. `single_source_writeback_surface`
5. `anti_zombie_restitution_surface`
6. `transport_fail_closed_surface`
7. `shared_reject_semantics_packet`
8. `cross_consumer_repair_attestation`
9. `long_horizon_reopen_liability`

更成熟的结构 refinement correction refinement 方式不是：

- 只看 pointer 还在
- 只看 telemetry 重新转绿
- 只看 archive prose 更完整

而是：

- 围绕这九类对象继续消费同一个 authority stream、同一条 lineage/fresh merge、同一条 single-source writeback、同一套 anti-zombie/transport/fail-closed 证据、同一条 shared reject semantics、同一份 cross-consumer repair attestation 与同一个 threshold liability

这套对象面应被理解成一个 ordered protocol stream，而不是若干孤立诊断值：

1. 先决 authority
2. 再决 lineage
3. 再决 merge
4. 再决 writeback
5. 再决 fail-closed
6. 最后才决 reopen

## 2. 第一性原理

结构世界真正先进，不是目录更整洁，而是：

1. `authority stream` 继续只有一个主语。
2. `lineage + fresh merge` 证明恢复的是不是同一个对象，而不是一次 last-write-wins 的幸运结果。
3. `single-source writeback` 必须覆盖读侧与写侧，不能只做成只读单源。
4. `anti-zombie` 证明旧 generation、旧 writer、旧 snapshot 已无法回写。
5. `transport boundary + fail-closed worktree` 证明系统在脏状态与漂移状态下拒绝继续制造第二真相。
6. `shared reject semantics` 决定宿主、CI、评审与交接是否真的围绕同一条 fail-closed 语言说话。
7. `reopen liability` 证明 later 团队仍能沿同一 authority/writeback/boundary 链正式反驳当前结构结论。

所以结构 refinement correction refinement 真正要被宿主消费的不是恢复叙事，而是 authority、merge、writeback、anti-zombie、transport、fail-closed 与 reopen 边界继续可验证地成立。

## 3. repair session object 与 authority stream

结构宿主应至少围绕下面对象消费 refinement correction refinement 真相：

### 3.1 repair session object

1. `repair_session_id`
2. `reprotocol_session_id`
3. `refinement_session_id`
4. `authority_object_id`
5. `repair_generation`
6. `shared_consumer_surface`
7. `repair_started_at`

### 3.2 repair authority stream

1. `authority_object_id`
2. `authoritative_path`
3. `externally_verifiable_head`
4. `writer_chokepoint`
5. `authority_stream_attested`

这些字段回答的不是：

- 当前哪个入口看起来更像真相

而是：

- 当前到底把哪个 authority stream 正式交还给 later 维护者

## 4. lineage / fresh merge 与 single-source writeback surface

结构宿主还必须显式消费：

### 4.1 lineage fresh merge surface

1. `resume_lineage_ref`
2. `lineage_reproof_ref`
3. `generation_guard_attested`
4. `fresh_merge_contract`
5. `stale_finally_suppressed`
6. `delete_semantics_retained`
7. `fresh_merge_surface_attested`

### 4.2 single source writeback surface

1. `single_source_ref`
2. `writeback_primary_path`
3. `append_chain_ref`
4. `side_write_quarantined`
5. `single_source_writeback_attested`

这里最重要的是：

- `lineage` 不是一次幸运 reconnect
- `fresh merge` 不是 last-write-wins
- `single-source` 不是目录审美

## 5. anti-zombie / transport / fail-closed 与 shared reject semantics

结构宿主还必须显式消费：

### 5.1 anti zombie restitution surface

1. `anti_zombie_evidence_ref`
2. `stale_writer_evidence`
3. `orphan_duplicate_quarantined`
4. `archive_truth_ref`
5. `anti_zombie_restitution_attested`

### 5.2 transport fail closed surface

1. `transport_boundary_attested`
2. `bridge_transport_ref`
3. `writeback_transport_ref`
4. `single_message_semantics_attested`
5. `dirty_git_fail_closed_attested`
6. `worktree_change_guard`
7. `unpushed_commit_guard`
8. `transport_fail_closed_surface_attested`

### 5.3 shared reject semantics packet

1. `hard_reject`
2. `merge_reproof_required`
3. `fail_closed_reseal_required`
4. `shared_reject_rebind_required`
5. `reentry_required`
6. `reopen_required`
7. `consumer_projection_demoted`

这里最重要的是：

- pointer 只是 breadcrumb，不是 authority stream
- transport 只接受单一消息语义，不是 projection 的自由发挥空间
- `dirty git fail-closed` 不是团队礼仪，而是正式结构对象
- `shared reject semantics` 不是四类消费者各自的健康标准

## 6. cross-consumer repair attestation 与 long-horizon reopen liability

结构宿主还必须显式消费：

### 6.1 cross consumer repair attestation

1. `repair_attestation_id`
2. `authority_stream_ref`
3. `lineage_fresh_merge_ref`
4. `single_source_writeback_ref`
5. `anti_zombie_surface_ref`
6. `transport_fail_closed_surface_ref`
7. `shared_reject_semantics_ref`
8. `repair_attested_at`

### 6.2 long horizon reopen liability

1. `reopen_boundary`
2. `return_authority_object`
3. `return_writeback_path`
4. `return_generation_floor`
5. `threshold_retained_until`
6. `reentry_required_when`
7. `reopen_required_when`
8. `liability_owner`

这里最重要的是：

- `repair attestation` 不是“团队都认同这个结构”
- `reopen liability` 不是“以后再 reconnect 看看”
- later 团队必须能只凭对象、边界与责任链复算当前结论

## 7. 宿主消费顺序

更稳的宿主消费顺序应固定为：

1. `repair_session_object`
2. `repair_authority_stream`
3. `lineage_fresh_merge_surface`
4. `single_source_writeback_surface`
5. `anti_zombie_restitution_surface`
6. `transport_fail_closed_surface`
7. `shared_reject_semantics_packet`
8. `cross_consumer_repair_attestation`
9. `long_horizon_reopen_liability`

不要反过来：

1. 不要先看 pointer 是否还在，再看 authority。
2. 不要先看结果没坏，再看 merge / lineage。
3. 不要先看 telemetry 是否转绿，再看 fail-closed。
4. 不要先写 reopen 提示，再看 threshold 与 liability owner。

## 8. 共同 reject / escalation 语义

出现下面情况时，应直接升级为共同 reject 或 escalation：

1. `repair_session_missing`
2. `authority_stream_broken`
3. `lineage_fresh_merge_missing`
4. `single_source_writeback_missing`
5. `anti_zombie_evidence_missing`
6. `transport_boundary_missing`
7. `dirty_git_fail_closed_false`
8. `shared_reject_semantics_missing`
9. `threshold_retained_until_missing`

## 9. 苏格拉底式自检

在你准备宣布“结构精修精修协议已经对象化”前，先问自己：

1. 我共享的是同一个结构真相面，还是四份彼此相像的健康说明。
2. 我共享的是同一条 reject 语义链，还是不同消费者各自的健康标准。
3. 我保留的是 future reopen 的正式能力，还是一句“以后有问题再看”。
4. later 团队接手时依赖的是对象、边界与责任，还是仍要回到 pointer、telemetry、reconnect 提示与作者记忆。
5. 我现在保护的是 Claude Code 的结构先进性，还是只是在把它写成更像先进系统的 prose。
