# 结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行手册：repair card、共同 reject order 与 reopen drill

这一章不再解释结构 refinement correction repair protocol 该共享哪些字段，而是把 Claude Code 式结构 refinement correction repair protocol 压成一张可持续执行的 cross-consumer `repair card`。

它主要回答五个问题：

1. 为什么结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修真正执行的不是“系统又转绿了”，而是 authority、single-source、lineage、fresh merge、anti-zombie、transport、dirty git fail-closed 与 reopen liability 的正式顺序。
2. 宿主、CI、评审与交接怎样共享同一张结构 `repair card`，而不是各自围绕 pointer、telemetry、archive prose 与作者说明工作。
3. 应该按什么固定顺序执行 `repair session`、`authority surface`、`single-source writeback`、`lineage/fresh merge`、`anti-zombie restitution`、`transport/fail-closed`、`cross-consumer repair attestation`、`shared reject semantics` 与 `reopen liability`，才能不让 split-brain、side write 与 zombie 风险重新复辟。
4. 哪些 `reject order` 一旦出现就必须阻断 handoff、拒绝 restored 并进入 `re-entry / reopen` drill。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的系统健康页”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:186-230`
- `claude-code-source-code/src/utils/conversationRecovery.ts:375-400`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/utils/worktree.ts:1046-1172`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-211`
- `claude-code-source-code/src/cli/transports/SSETransport.ts:149-457`

## 1. 第一性原理

结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修真正要执行的不是：

- pointer 还在
- telemetry 又转绿了
- archive prose 更完整
- 作者说“应该没事了”

而是：

- authority surface、single-source writeback、resume lineage、fresh merge、anti-zombie evidence、transport boundary、dirty git fail-closed 与 reopen boundary 仍围绕同一个结构真相面正式宣布：现在可以无人继续盯防，同时仍保留合法 `re-entry / reopen` 责任边界

Claude Code 源码先进性的关键，不在目录整洁，而在它把：

1. authority 主语
2. writeback choke point
3. lineage reproof
4. fresh merge contract
5. anti-zombie evidence
6. transport boundary
7. fail-closed worktree guard

提前编码进系统结构，让 future maintainer 可以只凭对象而不是记忆 reopen 当前结论。

所以这层 playbook 最先要看的不是：

- `repair card` 已经填完了

而是：

1. 当前 `authority_object_id + externally_verifiable_head` 是否仍唯一。
2. 当前 `single-source writeback contract` 是否真的把唯一真相入口与主写回路径继续绑在一起。
3. 当前 `lineage + fresh merge` 是否仍阻止 stale finally、旧 append 与旧 snapshot 迟到篡位。
4. 当前 `anti-zombie restitution` 是否仍让旧 generation、旧 writer 与 orphan state 失去回写资格。
5. 当前 `fail-closed worktree contract` 是否仍保证脏工作树与未推送提交直接拒绝继续写。

## 2. 共享 repair card 最小字段

每次结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修巡检，宿主、CI、评审与交接系统至少应共享：

1. `repair_card_id`
2. `repair_attestation_id`
3. `reprotocol_session_id`
4. `authority_object_id`
5. `authoritative_path`
6. `externally_verifiable_head`
7. `writer_chokepoint`
8. `single_source_ref`
9. `writeback_primary_path`
10. `resume_lineage_ref`
11. `generation_guard_attested`
12. `fresh_merge_contract`
13. `anti_zombie_evidence_ref`
14. `transport_boundary_attested`
15. `dirty_git_fail_closed_attested`
16. `worktree_change_guard`
17. `unpushed_commit_guard`
18. `reopen_boundary`
19. `threshold_retained_until`
20. `reject_verdict`
21. `reopen_required_when`
22. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看 authority object 与 writeback 主路径是否仍唯一。
2. CI 看 lineage、fresh merge、anti-zombie、transport 与 fail-closed 顺序是否完整。
3. 评审看 pointer、telemetry 与 archive prose 是否仍被清楚降为投影。
4. 交接看 later 团队能否只凭 `repair card` 安全接手与 reopen。

## 3. 固定共同 reject order

### 3.1 先验 `repair_session_object`

先看当前准备宣布 refinement correction repair protocol 可执行的，到底是不是同一个 `authority_object_id`，而不是一份更正式的结构说明。

### 3.2 再验 `authority_surface_contract`

再看：

1. `authority_object_id`
2. `authoritative_path`
3. `externally_verifiable_head`
4. `writer_chokepoint`

这一步先回答：

- 当前真相主语到底是谁

### 3.3 再验 `single_source_writeback_surface`

再看：

1. `single_source_ref`
2. `writeback_primary_path`
3. `append_chain_ref`
4. `side_write_quarantined`
5. `single_source_writeback_attested`

这一步先回答：

- 现在有没有旁路写还能回魂

### 3.4 再验 `lineage_fresh_merge_surface`

再看：

1. `resume_lineage_ref`
2. `lineage_reproof_ref`
3. `generation_guard_attested`
4. `fresh_merge_contract`
5. `stale_finally_suppressed`
6. `delete_semantics_retained`

这一步先回答：

- later 团队恢复的是不是同一个对象链
- 旧 finally 与旧 append 现在还有没有篡位资格

### 3.5 再验 `anti_zombie_restitution_surface`

再看：

1. `anti_zombie_evidence_ref`
2. `stale_writer_evidence`
3. `orphan_duplicate_quarantined`
4. `archive_truth_ref`
5. `anti_zombie_restitution_attested`

这一步先回答：

- 旧 generation、旧 writer 与 orphan state 现在还有没有机会回魂

### 3.6 再验 `transport_fail_closed_surface`

再看：

1. `transport_boundary_attested`
2. `bridge_transport_ref`
3. `writeback_transport_ref`
4. `single_message_semantics_attested`
5. `dirty_git_fail_closed_attested`
6. `worktree_change_guard`
7. `unpushed_commit_guard`

这一步先回答：

- 当前 transport 还只允许一种消息语义吗
- 当前写回边界还是 fail-closed 吗

### 3.7 再验 `cross_consumer_repair_attestation`

再看：

1. `repair_attestation_id`
2. `authority_surface_ref`
3. `single_source_writeback_ref`
4. `lineage_fresh_merge_ref`
5. `anti_zombie_surface_ref`
6. `transport_fail_closed_surface_ref`
7. `consumer_projection_demoted`

这一步先回答：

- 四类消费者消费的是不是同一个结构对象，而不是四份相似解释

### 3.8 再验 `shared_reject_semantics_packet`

再看：

1. `hard_reject`
2. `pointer_as_authority`
3. `single_source_missing`
4. `lineage_reproof_missing`
5. `merge_reproof_required`
6. `anti_zombie_evidence_missing`
7. `transport_reseal_required`
8. `fail_closed_reseal_required`
9. `repair_attestation_rebuild_required`
10. `reentry_required`
11. `reopen_required`

这一步先回答：

- 现在到底应继续、回跳、重封，还是正式 reopen

### 3.9 最后验 `long_horizon_reopen_liability`

最后才看：

1. `reopen_boundary`
2. `return_authority_object`
3. `return_writeback_path`
4. `return_generation_floor`
5. `threshold_retained_until`
6. `reservation_owner`
7. `reentry_required_when`
8. `reopen_required_when`

更稳的最终 verdict 只应落在：

1. `steady_state_chain_resealed`
2. `hard_reject`
3. `merge_reproof_required`
4. `transport_reseal_required`
5. `fail_closed_reseal_required`
6. `repair_attestation_rebuild_required`
7. `reentry_required`
8. `reopen_required`

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前结构 refinement correction refinement execution：

1. `repair_session_missing`
2. `pointer_as_authority`
3. `authority_surface_self_report_only`
4. `single_source_missing`
5. `writeback_primary_path_unattested`
6. `lineage_reproof_missing`
7. `fresh_merge_contract_missing`
8. `stale_generation_can_write`
9. `anti_zombie_evidence_missing`
10. `transport_second_semantics_detected`
11. `dirty_git_fail_open`
12. `worktree_clean_unknown`
13. `unpushed_commit_guard_missing`
14. `repair_attestation_cross_consumer_mismatch`
15. `reopen_required`

## 5. re-entry 与 reopen 处理顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先停止新的 reconnect、adopt、remote resume 与写回，不再让旧资产继续回写。
2. 先把 verdict 降级为 `hard_reject`、`merge_reproof_required`、`transport_reseal_required`、`fail_closed_reseal_required`、`repair_attestation_rebuild_required`、`reentry_required` 或 `reopen_required`。
3. 先把 pointer、telemetry、archive prose 与 UI 投影降回 breadcrumb，不再让它们充当 authority。
4. 先回到上一个仍可验证的 authority object 与 writeback path，补完 head attestation、single-source writeback、lineage reproof、fresh merge、anti-zombie、transport reseal 与 fail-closed guard。
5. 只有当 `return_authority_object + return_writeback_path + return_generation_floor` 被重新验证后，才允许重新 handoff。
6. 如果根因落在 refinement correction repair protocol 本身，就回跳 `../api/92` 做对象级修正。

## 6. 最小 drill 集

每轮至少跑下面八个结构宿主稳态纠偏再纠偏改写纠偏精修纠偏精修执行演练：

1. `authority_surface_replay`
2. `single_source_writeback_replay`
3. `lineage_fresh_merge_replay`
4. `anti_zombie_replay`
5. `transport_boundary_replay`
6. `fail_closed_worktree_replay`
7. `cross_consumer_attestation_replay`
8. `reopen_liability_replay`

## 7. 复盘记录最少字段

每次结构宿主稳态纠偏再纠偏改写纠偏精修纠偏精修失败、再入场或 reopen，至少记录：

1. `repair_card_id`
2. `repair_attestation_id`
3. `authority_object_id`
4. `authoritative_path`
5. `writeback_primary_path`
6. `resume_lineage_ref`
7. `fresh_merge_contract`
8. `anti_zombie_evidence_ref`
9. `dirty_git_fail_closed_attested`
10. `reject_verdict`
11. `recovery_action_ref`
12. `reopen_required_when`

## 8. 苏格拉底式自检

在你准备宣布“结构 refinement correction repair protocol 已经进入 steady execution”前，先问自己：

1. 我现在让四类消费者共享的是同一个结构对象，还是四份看起来相似的恢复说明。
2. 我现在执行的是共同 `reject order`，还是宿主、CI、评审与交接各自的健康感觉。
3. 我现在保留的是 formal reopen boundary，还是一句“以后有问题再看”。
4. later 团队接手时依赖的是 authority、writeback、lineage、merge 与 fail-closed 对象，还是仍要回到 pointer、telemetry 与作者记忆。
5. 当前执行保护的是作者退场后的结构真相延续，还是只是在把 repair protocol 写成更体面的系统健康页。
