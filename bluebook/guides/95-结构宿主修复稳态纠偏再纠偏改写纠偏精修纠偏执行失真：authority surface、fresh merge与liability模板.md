# 如何把结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏执行失真压回结构真相面：固定refinement correction顺序、authority surface、fresh merge与liability改写模板骨架

这一章不再解释结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏执行最常怎样失真，而是把 Claude Code 式结构 refinement correction execution distortion 压成一张可执行的 builder-facing 手册。

它主要回答五个问题：

1. 为什么结构 refinement correction execution distortion 真正要救回的不是一张更完整的 `repair card`，而是同一个结构真相面。
2. 怎样把假 `repair card`、假 `fresh merge` 与假 `reopen liability` 压回固定 `refinement correction order`。
3. 哪些现象应被直接升级为硬拒收，而不是继续补 pointer、telemetry、archive prose 与作者说明。
4. 怎样把 `repair card`、`structure truth rebind block` 与 `long-horizon reopen liability ticket` 重新压回对象级骨架。
5. 怎样用苏格拉底式追问避免把改写写成“把结构 repair card 再做整洁一点”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:186-230`
- `claude-code-source-code/src/utils/conversationRecovery.ts:375-400`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/utils/worktree.ts:1046-1172`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-211`

这些锚点共同说明：

- 结构 refinement correction execution 真正最容易失真的地方，不在 `repair card` 有没有写出来，而在 authority、single-source writeback、lineage、fresh merge、anti-zombie、transport boundary、dirty git fail-closed 与 reopen boundary 是否仍围绕同一个结构真相面消费 later 维护者的判断。

## 1. 第一性原理

结构 refinement correction execution distortion 真正要救回的不是：

- 一份更漂亮的 architecture prose
- 一张更完整的 `repair card`
- 一组更平静的 pointer / telemetry 信号

而是：

- later 维护者在作者缺席时，仍能围绕同一个 `authority surface -> single-source writeback -> lineage resume contract -> fresh merge contract -> anti-zombie restitution packet -> transport boundary contract -> fail-closed worktree contract -> long-horizon reopen liability` 说真话

所以更稳的纠偏目标不是：

- 先把结构叙事说圆

而是：

1. 先把假 `repair card` 降回解释信号。
2. 先把 authority 从 pointer、telemetry 与 archive prose 里救出来。
3. 先把 single-source、lineage 与 fresh merge 从“结果没坏”里救出来。
4. 先把 anti-zombie、transport 与 fail-closed 从“当前没报错”里救出来。
5. 最后才把 `long-horizon reopen liability` 从 reconnect 提示与作者记忆里救出来。

## 2. 固定 refinement correction 顺序

### 2.1 先冻结假 `repair card`

第一步不是补结构说明，而是冻结假修复信号：

1. 把 pointer、telemetry 转绿、archive prose 与作者说明一律降回投影。
2. 禁止 `reject_verdict=steady_state_chain_resealed` 在 authority object 复核之前生效。
3. 禁止“结果暂时没坏”继续充当结构真相面的替身。

最小冻结对象：

1. `repair_card_id`
2. `repair_session_id`
3. `authority_object_id`
4. `authoritative_path`
5. `externally_verifiable_head`
6. `single_source_ref`
7. `reject_verdict`
8. `verdict_reason`

### 2.2 再恢复 `authority surface`

第二步要把主语救回：

1. `authority_object_id`
2. `authoritative_path`
3. `externally_verifiable_head`
4. `writer_chokepoint`
5. `authority_surface_attested`

authority 首先信外部可验证的头部状态，而不是对象自述。

### 2.3 再恢复 `single-source writeback`

第三步要把唯一真相入口从目录叙事里救回：

1. `single_source_ref`
2. `writeback_primary_path`
3. `append_chain_ref`
4. `side_write_quarantined`
5. `single_source_writeback_attested`

目录更整洁不是 seam；只有单一写回路径仍成立，later 团队才不会继承第二真相。

### 2.4 再恢复 `lineage resume contract`

第四步要把时间维度上的真相救回：

1. `resume_lineage_ref`
2. `lineage_reproof_ref`
3. `generation_guard_attested`
4. `lineage_break_detected_blocked`
5. `lineage_resume_contract_attested`

`QueryGuard` 只能封住本地 async gap；它不能替代 authority、seam 与 lineage 的正式复证。

### 2.5 再恢复 `fresh merge contract`

第五步要把“结果没坏”重新压回 merge 契约：

1. `fresh_merge_contract`
2. `append_chain_ref`
3. `delete_semantics_retained`
4. `stale_finally_suppressed`
5. `fresh_merge_contract_attested`

没有这一步，系统只是暂时没坏，不代表旧 finally、旧 append 与旧 snapshot 已经失去篡位能力。

### 2.6 再恢复 `anti-zombie restitution packet`

第六步要把反 zombie 证据从健康感与解释文本里救回：

1. `anti_zombie_evidence_ref`
2. `stale_writer_evidence`
3. `orphan_duplicate_quarantined`
4. `archive_truth_ref`
5. `anti_zombie_restitution_attested`

duplicate suppression、late-response ignore 与归档说明都不能代替正式证据。

### 2.7 再恢复 `transport boundary contract`

第七步要把 transport 从“当前没报错”里救回：

1. `transport_boundary_attested`
2. `bridge_transport_ref`
3. `writeback_transport_ref`
4. `single_message_semantics_attested`
5. `transport_boundary_contract_attested`

transport 不只是通信实现细节，而是结构真相面的一部分。

### 2.8 再恢复 `fail-closed worktree contract`

第八步要把工作树真相从“应该没事”里救回：

1. `dirty_git_fail_closed_attested`
2. `worktree_change_guard`
3. `unpushed_commit_guard`
4. `cleanup_skip_contract_attested`
5. `fail_closed_worktree_contract_attested`

没有这一步，later 团队拿到的仍是一条会在脏状态下继续制造第二真相的 reopen 路径。

### 2.9 最后恢复 `long-horizon reopen liability`

最后才把 future reopen 的正式能力救回：

1. `reopen_boundary`
2. `return_authority_object`
3. `return_writeback_path`
4. `threshold_retained_until`
5. `reopen_required_when`
6. `liability_owner`
7. `long_horizon_reopen_liability_attested`

不要反过来：

1. 不要先补 reconnect 提醒，再修 authority / merge / fail-closed。
2. 不要先让 telemetry 转绿，再修 transport 与 dirty git guard。
3. 不要先让 later 团队放心，再修正式 boundary。

## 3. 硬拒收规则

出现下面情况时，应直接升级为硬拒收：

1. `repair_session_missing`
2. `pointer_as_authority`
3. `head_not_externally_verifiable`
4. `authority_surface_multi_home`
5. `single_source_ref_missing`
6. `writeback_primary_path_missing`
7. `lineage_resume_contract_missing`
8. `fresh_merge_as_last_write_wins`
9. `delete_semantics_lost`
10. `anti_zombie_evidence_missing`
11. `transport_second_semantics_detected`
12. `dirty_git_fail_open`
13. `worktree_change_guard_failed`
14. `unpushed_commit_guard_failed`
15. `long_horizon_reopen_liability_missing`
16. `reopen_required_but_card_still_green`

## 4. 模板骨架

### 4.1 repair card 骨架

1. `repair_card_id`
2. `repair_session_id`
3. `authority_object_id`
4. `authoritative_path`
5. `externally_verifiable_head`
6. `single_source_ref`
7. `writeback_primary_path`
8. `lineage_resume_contract_ref`
9. `fresh_merge_contract`
10. `anti_zombie_evidence_ref`
11. `transport_boundary_attested`
12. `dirty_git_fail_closed_attested`
13. `reopen_boundary`
14. `threshold_retained_until`
15. `reject_verdict`
16. `verdict_reason`

### 4.2 structure truth rebind block 骨架

1. `structure_truth_rebind_block_id`
2. `authority_gap`
3. `single_source_gap`
4. `lineage_gap`
5. `fresh_merge_gap`
6. `anti_zombie_gap`
7. `transport_gap`
8. `fail_closed_gap`
9. `liability_gap`
10. `fallback_verdict`

### 4.3 long-horizon reopen liability ticket 骨架

1. `long_horizon_reopen_liability_id`
2. `reopen_boundary`
3. `return_authority_object`
4. `return_writeback_path`
5. `threshold_retained_until`
6. `reopen_required_when`
7. `liability_scope`
8. `liability_owner`

## 5. 为什么这会让源码先进性退回目录美学

- Claude Code 的源码先进性从来不在“目录是不是更整洁”，而在 authority、single-source seam、fresh merge、anti-zombie、transport boundary、fail-closed 与 reopen boundary 是否先于 later 维护者的心理感受生效。
- 假 `repair card` 会把结构对象退回 architecture prose。
- 假 `fresh merge` 会把结构判断退回结果没坏。
- 假 `reopen liability` 会把未来责任退回 reconnect 提示与作者记忆。

一旦这几件事同时发生，源码先进性剩下的就不再是结构真相面，而只是：

1. 更整洁的目录叙事。
2. 更好看的健康信号。
3. 更依赖作者记忆的 later handoff。

pointer 只是 breadcrumb，transport 只是单一消息语义边界；它们一旦被误当 authority，结构先进性就会退回投影崇拜。

## 6. 与 `casebooks/66` 的边界

`casebooks/66` 回答的是：

- 为什么结构 refinement correction execution 明明已经存在，仍会重新退回假 `repair card`、假 `fresh merge` 与假 `reopen liability`

这一章回答的是：

- 当这些假对象已经被辨认出来之后，具体该按什么固定 `refinement correction order` 把它们压回同一个结构真相面

也就是说，`casebooks/66` 负责：

- 识别结构真相怎样被更体面的 repair 工件替代

而这一章负责：

- 把这些替代信号按 authority、seam、lineage、fresh merge、anti-zombie、transport、fail-closed 与 liability 的对象顺序拆掉

## 7. 苏格拉底式检查清单

在你准备宣布“结构 refinement correction execution distortion 已纠偏完成”前，先问自己：

1. 我救回的是唯一 authority object，还是一张更正式的 repair card。
2. 我现在保住的是 `single-source + fresh merge`，还是更漂亮的目录讲法与几次幸运 reconnect。
3. 我现在保住的是 `anti-zombie + fail-closed`，还是“当前没报错”的侥幸。
4. 我现在保留的是 future reopen 的正式 liability，还是一句“以后再试一次”。
5. later 团队明天如果必须 reopen，依赖的是正式 boundary，还是作者口述、旧入口与 retry 循环。

## 8. 一句话总结

真正成熟的结构 refinement correction execution 纠偏，不是把 repair card 写得更严，而是把 `authority surface + single-source writeback + lineage resume contract + fresh merge contract + anti-zombie restitution packet + transport boundary contract + fail-closed worktree contract + long-horizon reopen liability` 继续拉回同一个结构真相面。
