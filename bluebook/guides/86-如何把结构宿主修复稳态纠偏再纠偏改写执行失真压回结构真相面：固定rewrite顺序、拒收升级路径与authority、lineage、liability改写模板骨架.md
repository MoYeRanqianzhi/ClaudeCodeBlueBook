# 如何把结构宿主修复稳态纠偏再纠偏改写执行失真压回结构真相面：固定rewrite顺序、拒收升级路径与authority、lineage、liability改写模板骨架

这一章不再解释结构宿主修复稳态纠偏再纠偏改写执行最常怎样失真，而是把 Claude Code 式结构 rewrite-of-correction execution distortion 压成一张可执行的 builder-facing 手册。

它主要回答五个问题：

1. 为什么结构 rewrite execution distortion 真正要救回的不是一份更完整的架构说明，而是同一个结构真相面。
2. 怎样把假 `rewrite card`、假 `authority-first reject`、伪 `anti-zombie evidence` 与假 `reopen liability` 压回固定 `rewrite order`。
3. 哪些现象应被直接升级为硬拒收，而不是继续补 pointer、telemetry 与 architecture prose。
4. 怎样把 `rewrite card`、`authority seam rewrite block`、`lineage rewrite block` 与 `reopen liability ticket` 重新压回对象级骨架。
5. 怎样用苏格拉底式追问避免把改写写成“把目录和架构文档再做整洁一点”。

## 0. 代表性源码锚点

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

## 1. 第一性原理

结构 rewrite execution distortion 真正要救回的不是：

- 一份更漂亮的 architecture prose
- 一张更完整的 `rewrite card`
- 一组更平静的 pointer / telemetry 信号

而是：

- later 维护者在作者缺席时，仍能围绕同一个 authority、single-source seam、lineage、anti-zombie evidence 与 reopen boundary 说真话

所以更稳的纠偏目标不是：

- 先把结构叙事说圆

而是：

1. 先把假 `rewrite card` 降回结果信号。
2. 先把 authority 从 pointer、telemetry 与 architecture prose 里救出来。
3. 先把 single-source 与 writeback seam 从“目录更整洁”里救出来。
4. 先把 lineage 与 fresh merge 从“最终没坏”里救出来。
5. 先把 anti-zombie evidence 从 archive prose、日志截图与 suppressor 幻觉里救出来。
6. 最后才把 `reopen liability` 从 reconnect 提示与旧入口里救出来。

## 2. 固定 rewrite 顺序

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

### 2.4 再恢复 `lineage reproof + fresh merge`

第四步要把时间维度上的真相救回：

1. `lineage_reproof_ref`
2. `generation_guard_attested`
3. `fresh_merge_contract`
4. `delete_semantics_retained`
5. `stale_finally_blocked`
6. `lineage_rebound_at`

`QueryGuard` 只能封住本地 async gap；它不能替代 authority、seam 与 lineage 的正式复证。

### 2.5 再恢复 `anti-zombie evidence restitution`

第五步要把反 zombie 证据从健康感与解释文本里救回：

1. `anti_zombie_evidence_ref`
2. `stale_writer_evidence`
3. `orphan_duplicate_quarantined`
4. `transport_boundary_attested`
5. `archive_truth_ref`
6. `anti_zombie_rebound_at`

duplicate suppression、late-response ignore 与 transport unwrap 都只是抗损机制；它们不能代替正式证据。

### 2.6 最后恢复 `reopen liability rebinding`

最后才把 future reopen 的正式能力救回：

1. `reopen_boundary`
2. `reservation_owner`
3. `threshold_retained_until`
4. `return_writeback_path`
5. `dirty_git_fail_closed_attested`
6. `reopen_liability_rebound_at`

worktree stale cleanup 的保守跳过、dirty git 的一票否决与 transport 单一消息边界，都是 reopen liability 的外围守门面；没有它们，later 团队拿到的仍是一条会制造第二真相的 reopen 路径。

## 3. 硬拒收规则

出现下面情况时，应直接升级为硬拒收：

1. `rewrite_session_missing`
2. `pointer_as_authority`
3. `head_not_externally_verifiable`
4. `authority_surface_multi_home`
5. `single_source_ref_missing`
6. `writeback_primary_path_missing`
7. `namespace_boundary_unattested`
8. `fresh_merge_as_last_write_wins`
9. `delete_semantics_lost`
10. `queryguard_as_truth_substitute`
11. `anti_zombie_evidence_missing`
12. `transport_second_semantics_detected`
13. `worktree_not_fail_closed`
14. `reopen_boundary_missing`
15. `reopen_required_but_continue_allowed`

## 4. 模板骨架

### 4.1 rewrite card 骨架

1. `rewrite_card_id`
2. `rewrite_session_id`
3. `authority_object_id`
4. `authoritative_path`
5. `single_source_ref`
6. `writeback_primary_path`
7. `lineage_reproof_ref`
8. `fresh_merge_contract`
9. `anti_zombie_evidence_ref`
10. `reopen_boundary`
11. `reservation_owner`
12. `threshold_retained_until`
13. `reject_verdict`
14. `verdict_reason`

### 4.2 authority seam rewrite block 骨架

1. `authority_seam_rewrite_block_id`
2. `authority_gap`
3. `head_verifiability_gap`
4. `single_source_gap`
5. `writeback_gap`
6. `namespace_gap`
7. `lineage_gap`
8. `fresh_merge_gap`
9. `fallback_verdict`

### 4.3 reopen liability ticket 骨架

1. `reopen_liability_id`
2. `reopen_boundary`
3. `reservation_owner`
4. `threshold_retained_until`
5. `return_writeback_path`
6. `dirty_git_fail_closed_attested`
7. `reentry_required_when`
8. `reopen_required_when`

## 5. 与 `casebooks/57` 的边界

`casebooks/57` 回答的是：

- 为什么结构 rewrite execution 明明已经存在，仍会重新退回假 `rewrite card`

这一章回答的是：

- 当这些假对象已经被辨认出来之后，具体该按什么固定 `rewrite order` 把它们压回同一个结构真相面

也就是说，`casebooks/57` 负责：

- 识别结构真相怎样被更体面的健康信号替代

而这一章负责：

- 把这些替代信号按 authority、seam、lineage、anti-zombie 与 liability 的对象顺序拆掉

## 6. 苏格拉底式检查清单

在你准备宣布“结构 steady-state correction-of-correction rewrite execution distortion 已纠偏完成”前，先问自己：

1. 我救回的是唯一 authority object，还是一份更完整的架构说明。
2. 我现在保住的是 `single-source + writeback seam`，还是更整洁的目录与更平静的 pointer。
3. 我现在保住的是 `lineage + fresh merge`，还是“最终没坏”的结果导向。
4. 我现在保留的是 `anti-zombie evidence + transport boundary`，还是一组 suppressor 恰好没失手。
5. later 团队明天如果必须 reopen，依赖的是正式 boundary，还是 reconnect 提示与作者口述。

## 7. 一句话总结

真正成熟的结构宿主修复稳态纠偏再纠偏改写纠偏，不是把 pointer、telemetry 与 architecture prose 做得更稳，而是把假 `rewrite card`、假 `authority-first reject`、伪 `anti-zombie evidence` 与假 `reopen liability` 重新压回同一个结构真相面。
