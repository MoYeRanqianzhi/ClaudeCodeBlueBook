# 如何把结构宿主修复稳态纠偏再纠偏改写纠偏执行失真压回结构真相面：固定rewrite correction顺序、fresh merge、transport与liability改写模板骨架

这一章不再解释结构宿主修复稳态纠偏再纠偏改写纠偏执行最常怎样失真，而是把 Claude Code 式结构 rewrite-correction execution distortion 压成一张可执行的 builder-facing 手册。

它主要回答五个问题：

1. 为什么结构 rewrite correction execution distortion 真正要救回的不是一份更完整的架构说明，而是同一个结构真相面。
2. 怎样把假 authority surface、假 fresh merge、假 transport boundary、假 fail-closed worktree 与假 `reopen liability` 压回固定 `rewrite correction order`。
3. 哪些现象应被直接升级为硬拒收，而不是继续补 pointer、telemetry 与 architecture prose。
4. 怎样把 `rewrite correction card`、`fresh merge transport block` 与 `reopen liability ticket` 重新压回对象级骨架。
5. 怎样用苏格拉底式追问避免把改写写成“把目录和架构文档再做整洁一点”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/handlePromptSubmit.ts:430-517`
- `claude-code-source-code/src/utils/task/framework.ts:77-248`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:186-230`
- `claude-code-source-code/src/utils/conversationRecovery.ts:375-400`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-211`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/utils/toolResultStorage.ts:749-838`
- `claude-code-source-code/src/utils/worktree.ts:1046-1172`
- `claude-code-source-code/src/cli/transports/SSETransport.ts:156-160`
- `claude-code-source-code/src/cli/transports/SSETransport.ts:448-457`
- `claude-code-source-code/src/cli/ndjsonSafeStringify.ts:24-31`

## 1. 第一性原理

结构 rewrite correction execution distortion 真正要救回的不是：

- 一份更漂亮的 architecture prose
- 一张更完整的 `rewrite correction card`
- 一组更平静的 pointer / telemetry 信号

而是：

- later 维护者在作者缺席时，仍能围绕同一个 authority、single-source seam、lineage、fresh merge、anti-zombie evidence、transport boundary、fail-closed worktree 与 reopen boundary 说真话

所以更稳的纠偏目标不是：

- 先把结构叙事说圆

而是：

1. 先把假 authority surface 降回解释信号。
2. 先把 authority 从 pointer、telemetry 与 architecture prose 里救出来。
3. 先把 single-source 与 writeback seam 从“目录更整洁”里救出来。
4. 先把 lineage 与 fresh merge 从“最终没坏”里救出来。
5. 先把 anti-zombie evidence 从 archive prose、日志截图与 suppressor 幻觉里救出来。
6. 先把 transport boundary 与 dirty-git fail-closed 从“当前没报错”里救出来。
7. 最后才把 `reopen liability` 从 reconnect 提示与旧入口里救出来。

## 2. 固定 rewrite correction 顺序

### 2.1 先冻结假健康信号

第一步不是补架构说明，而是：

1. 把 pointer、telemetry 转绿、archive prose 与作者说明一律降回投影。
2. 禁止 `reject_verdict=steady_state_restituted` 在 authority object 复核之前生效。
3. 禁止“结果暂时没坏”继续充当结构真相面的替身。

### 2.2 再恢复 `authority surface`

第二步要救回：

1. `authority_object_id`
2. `authoritative_path`
3. `externally_verifiable_head`
4. `writer_chokepoint`
5. `authority_restituted_at`

authority 首先信外部可验证的头部状态，而不是对象自述；没有这一步，后续一切都是在错误主语上修补。

### 2.3 再恢复 `single-source writeback seam`

第三步要把唯一真相入口从目录叙事里救回：

1. `single_source_ref`
2. `writeback_primary_path`
3. `append_chain_ref`
4. `side_write_quarantined`
5. `namespace_boundary_attested`
6. `seam_resealed_at`

目录更整洁不是 seam；只有单一写回路径仍成立，later 团队才不会继承第二真相。

### 2.4 再恢复 `lineage reproof`

第四步要把时间维度上的真相救回：

1. `lineage_reproof_ref`
2. `generation_guard_attested`
3. `resume_lineage_ref`
4. `lineage_rebound_at`
5. `lineage_break_detected_blocked`

`QueryGuard` 只能封住本地 async gap；它不能替代 authority、seam 与 lineage 的正式复证。

### 2.5 再恢复 `fresh merge contract`

第五步要把“结果没坏”重新压回 merge 契约：

1. `fresh_merge_contract`
2. `append_chain_ref`
3. `delete_semantics_retained`
4. `stale_finally_suppressed`
5. `merge_contract_attested`

没有这一步，系统只是暂时没坏，不代表旧 finally、旧 append 与旧 snapshot 已经失去篡位能力。

### 2.6 再恢复 `anti-zombie evidence restitution`

第六步要把反 zombie 证据从健康感与解释文本里救回：

1. `anti_zombie_evidence_ref`
2. `stale_writer_evidence`
3. `orphan_duplicate_quarantined`
4. `archive_truth_ref`
5. `anti_zombie_rebound_at`

duplicate suppression、late-response ignore 与归档说明都不能代替正式证据。

### 2.7 再恢复 `transport boundary attestation`

第七步要把 transport 从“当前没报错”里救回：

1. `transport_boundary_attested`
2. `bridge_transport_ref`
3. `writeback_transport_ref`
4. `single_message_semantics_attested`
5. `transport_resealed_at`

transport 不只是通信实现细节，而是结构真相面的一部分。

### 2.8 再恢复 `dirty-git fail-closed`

第八步要把工作树真相从“应该没事”里救回：

1. `dirty_git_fail_closed_attested`
2. `worktree_change_guard`
3. `unpushed_commit_guard`
4. `cleanup_skip_contract_attested`
5. `fail_closed_rebound_at`

没有这一步，later 团队拿到的仍是一条会在脏状态下继续制造第二真相的 reopen 路径。

### 2.9 最后恢复 `reopen liability rebinding`

最后才把 future reopen 的正式能力救回：

1. `reopen_boundary`
2. `reservation_owner`
3. `threshold_retained_until`
4. `return_writeback_path`
5. `return_authority_object`
6. `reopen_liability_rebound_at`

不要反过来：

1. 不要先补 reconnect 提醒，再修 authority / merge / transport。
2. 不要先让 telemetry 转绿，再修 fail-closed worktree。
3. 不要先让 later 团队放心，再修正式 boundary。

## 3. 硬拒收规则

出现下面情况时，应直接升级为硬拒收：

1. `rewrite_correction_session_missing`
2. `pointer_as_authority`
3. `head_not_externally_verifiable`
4. `authority_surface_multi_home`
5. `single_source_ref_missing`
6. `writeback_primary_path_missing`
7. `namespace_boundary_unattested`
8. `lineage_reproof_missing`
9. `fresh_merge_as_last_write_wins`
10. `delete_semantics_lost`
11. `anti_zombie_evidence_missing`
12. `transport_second_semantics_detected`
13. `worktree_not_fail_closed`
14. `reopen_boundary_missing`
15. `reopen_required_but_continue_allowed`

## 4. 模板骨架

### 4.1 rewrite correction card 骨架

1. `rewrite_correction_card_id`
2. `rewrite_correction_session_id`
3. `authority_object_id`
4. `authoritative_path`
5. `externally_verifiable_head`
6. `single_source_ref`
7. `writeback_primary_path`
8. `lineage_reproof_ref`
9. `fresh_merge_contract`
10. `anti_zombie_evidence_ref`
11. `transport_boundary_attested`
12. `dirty_git_fail_closed_attested`
13. `reopen_boundary`
14. `reject_verdict`
15. `verdict_reason`

### 4.2 fresh merge transport block 骨架

1. `fresh_merge_transport_block_id`
2. `authority_gap`
3. `single_source_gap`
4. `lineage_gap`
5. `fresh_merge_gap`
6. `anti_zombie_gap`
7. `transport_gap`
8. `fail_closed_gap`
9. `fallback_verdict`

### 4.3 reopen liability ticket 骨架

1. `reopen_liability_id`
2. `reopen_boundary`
3. `reservation_owner`
4. `threshold_retained_until`
5. `return_writeback_path`
6. `return_authority_object`
7. `dirty_git_fail_closed_attested`
8. `reopen_required_when`

## 5. 与 `casebooks/60` 的边界

`casebooks/60` 回答的是：

- 为什么结构 rewrite correction execution 明明已经存在，仍会重新退回假 authority surface、假 fresh merge、假 transport boundary、假 fail-closed worktree 与假 `reopen liability`

这一章回答的是：

- 当这些假对象已经被辨认出来之后，具体该按什么固定 `rewrite correction order` 把它们压回同一个结构真相面

也就是说，`casebooks/60` 负责：

- 识别结构真相怎样被更体面的 rewrite correction 工件替代

而这一章负责：

- 把这些替代信号按 authority、seam、lineage、fresh merge、anti-zombie、transport、fail-closed 与 liability 的对象顺序拆掉

## 6. 苏格拉底式检查清单

在你准备宣布“结构 steady-state correction-of-correction rewrite correction execution distortion 已纠偏完成”前，先问自己：

1. 我救回的是唯一 authority object，还是一份更完整的架构说明。
2. 我现在保住的是 `single-source + writeback seam`，还是更整洁的目录与更平静的 pointer。
3. 我现在保住的是 `lineage + fresh merge`，还是“最终没坏”的结果导向。
4. 我现在保留的是 `anti-zombie evidence + transport boundary + fail-closed worktree`，还是一组 suppressor 恰好没失手。
5. later 团队明天如果必须 reopen，依赖的是正式 boundary，还是 reconnect 提示与作者口述。

## 7. 一句话总结

真正成熟的结构宿主修复稳态纠偏再纠偏改写纠偏，不是把 pointer、telemetry 与 architecture prose 做得更稳，而是把假 authority surface、假 fresh merge、假 transport boundary、假 fail-closed worktree 与假 `reopen liability` 重新压回同一个结构真相面。
