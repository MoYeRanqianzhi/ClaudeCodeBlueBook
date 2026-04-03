# 如何把结构宿主修复稳态纠偏再纠偏改写纠偏精修执行失真压回结构真相面：固定refinement顺序、merge、fail-closed与liability改写模板骨架

这一章不再解释结构宿主修复稳态纠偏再纠偏改写纠偏精修执行最常怎样失真，而是把 Claude Code 式结构 refinement execution distortion 压成一张可执行的 builder-facing 手册。

它主要回答五个问题：

1. 为什么结构 refinement execution distortion 真正要救回的不是一张更漂亮的 `host consumption card`，而是同一个结构真相面。
2. 怎样把假 `host consumption card`、假 `fresh merge`、假 `dirty git fail-closed` 与假 `reopen liability ledger` 压回固定 `refinement order`。
3. 哪些现象应被直接升级为硬拒收，而不是继续补 pointer、telemetry、archive prose 与作者说明。
4. 怎样把 `host consumption card`、`merge fail-closed block` 与 `reopen liability ticket` 重新压回对象级骨架。
5. 怎样用苏格拉底式追问避免把改写写成“把结构值班卡再做整洁一点”。

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
- `claude-code-source-code/src/cli/structuredIO.ts:362-657`
- `claude-code-source-code/src/utils/worktree.ts:1046-1172`
- `claude-code-source-code/src/cli/transports/SSETransport.ts:149-457`
- `claude-code-source-code/src/cli/ndjsonSafeStringify.ts:24-31`

## 1. 第一性原理

结构 refinement execution distortion 真正要救回的不是：

- 一张更完整的宿主消费卡
- 一份更整洁的 archive prose
- 一组更平静的 pointer / telemetry 信号

而是：

- later 维护者在作者缺席时，仍能围绕同一个 authority、single-source、lineage、fresh merge、anti-zombie、transport boundary、dirty git fail-closed 与 reopen boundary 说真话

所以更稳的纠偏目标不是：

- 先把结构叙事说圆

而是：

1. 先把假 `host consumption card` 降回解释信号。
2. 先把 authority 从 pointer、telemetry 与 archive prose 里救出来。
3. 先把 single-source、lineage 与 fresh merge 从“结果没坏”里救出来。
4. 先把 dirty git fail-closed 从“当前还能用”里救出来。
5. 最后才把 `reopen liability ledger` 从 reconnect 提示与作者记忆里救出来。

## 2. 固定 refinement 顺序

### 2.1 先冻结假 `host consumption card`

第一步不是补结构说明，而是：

1. 把 pointer、telemetry 转绿、archive prose 与作者说明一律降回投影。
2. 禁止 `reject_verdict=steady_state_chain_resealed` 在 authority object 复核之前生效。
3. 禁止“结果暂时没坏”继续充当结构真相面的替身。

最小冻结对象：

1. `host_consumption_card_id`
2. `refinement_session_id`
3. `authority_object_id`
4. `authoritative_path`
5. `externally_verifiable_head`
6. `single_source_ref`
7. `reject_verdict`
8. `verdict_reason`

### 2.2 再恢复 `authority head`

第二步要救回：

1. `authority_object_id`
2. `authoritative_path`
3. `externally_verifiable_head`
4. `writer_chokepoint`
5. `authority_restituted_at`

authority 首先信外部可验证的头部状态，而不是对象自述；没有这一步，后续一切都是在错误主语上修补。

### 2.3 再恢复 `single-source merge custody`

第三步要把唯一真相入口从目录叙事里救回：

1. `single_source_ref`
2. `writeback_primary_path`
3. `append_chain_ref`
4. `fresh_merge_contract`
5. `stale_finally_suppressed`
6. `merge_contract_attested`

目录更整洁不是 seam；只有单一写回路径与 fresh merge 契约仍成立，later 团队才不会继承第二真相。

### 2.4 再恢复 `lineage anti-zombie packet`

第四步要把时间维度上的真相救回：

1. `resume_lineage_ref`
2. `lineage_reproof_ref`
3. `anti_zombie_evidence_ref`
4. `orphan_duplicate_quarantined`
5. `assistant_sentinel_attested`
6. `lineage_break_detected_blocked`

`QueryGuard` 只能封住本地 async gap；它不能替代 authority、merge 与 anti-zombie 的正式复证。

### 2.5 再恢复 `transport fail-closed custody`

第五步要把 transport 与工作树真相从“当前没报错”里救回：

1. `transport_boundary_attested`
2. `dirty_git_fail_closed_attested`
3. `worktree_change_guard`
4. `unpushed_commit_guard`
5. `cleanup_skip_contract_attested`
6. `transport_fail_closed_attested_at`

没有这一步，later 团队拿到的仍是一条会在脏状态下继续制造第二真相的 reopen 路径。

### 2.6 最后恢复 `reopen liability ledger`

最后才把 future reopen 的正式能力救回：

1. `reopen_boundary`
2. `return_authority_object`
3. `return_writeback_path`
4. `threshold_retained_until`
5. `reopen_required_when`
6. `liability_scope`
7. `reopen_liability_attested_at`

不要反过来：

1. 不要先补 reconnect 提醒，再修 authority / merge / fail-closed。
2. 不要先让 telemetry 转绿，再修 dirty git guard。
3. 不要先让 later 团队放心，再修正式 boundary。

## 3. 硬拒收规则

出现下面情况时，应直接升级为硬拒收：

1. `refinement_session_missing`
2. `pointer_as_authority`
3. `head_not_externally_verifiable`
4. `single_source_ref_missing`
5. `fresh_merge_contract_missing`
6. `append_chain_ref_missing`
7. `anti_zombie_evidence_missing`
8. `transport_second_semantics_detected`
9. `dirty_git_fail_open`
10. `worktree_change_guard_failed`
11. `unpushed_commit_guard_failed`
12. `reopen_liability_missing`
13. `reopen_required_but_card_still_green`

## 4. 模板骨架

### 4.1 host consumption card 骨架

1. `host_consumption_card_id`
2. `refinement_session_id`
3. `authority_object_id`
4. `authoritative_path`
5. `externally_verifiable_head`
6. `single_source_ref`
7. `fresh_merge_contract`
8. `lineage_reproof_ref`
9. `anti_zombie_evidence_ref`
10. `transport_boundary_attested`
11. `dirty_git_fail_closed_attested`
12. `reopen_boundary`
13. `threshold_retained_until`
14. `reject_verdict`
15. `verdict_reason`

### 4.2 merge fail-closed block 骨架

1. `merge_fail_closed_block_id`
2. `authority_gap`
3. `single_source_gap`
4. `merge_gap`
5. `lineage_gap`
6. `anti_zombie_gap`
7. `transport_gap`
8. `fail_closed_gap`
9. `fallback_verdict`

### 4.3 reopen liability ticket 骨架

1. `reopen_liability_id`
2. `reopen_boundary`
3. `return_authority_object`
4. `return_writeback_path`
5. `threshold_retained_until`
6. `reopen_required_when`
7. `liability_scope`
8. `liability_owner`

## 5. 与 `casebooks/63` 的边界

`casebooks/63` 回答的是：

- 为什么结构 refinement execution 明明已经存在，仍会重新退回假 `host consumption card`、假 `fail-closed` 与假 `reopen liability`

这一章回答的是：

- 当这些假对象已经被辨认出来之后，具体该按什么固定 `refinement order` 把它们压回同一个结构真相面

也就是说，`casebooks/63` 负责：

- 识别结构 refinement execution 怎样被 pointer、telemetry、结果没坏与 reconnect 提示取代

而这一章负责：

- 把这些替代信号按 authority、merge、anti-zombie、fail-closed 与 liability 的对象顺序拆掉

## 6. 苏格拉底式检查清单

在你准备宣布“结构 refinement execution distortion 已纠偏完成”前，先问自己：

1. 我救回的是唯一 authority object，还是一张更正式的宿主消费卡。
2. 我现在保住的是 `single-source + fresh merge`，还是更漂亮的目录讲法与几次幸运 reconnect。
3. 我现在保住的是 `anti-zombie + fail-closed`，还是“当前没报错”的侥幸。
4. 我现在保留的是 future reopen 的正式 liability，还是一句“以后再试一次”。
5. later 团队明天如果必须 reopen，依赖的是正式 boundary，还是作者口述、旧入口与 retry 循环。

## 7. 一句话总结

真正成熟的结构 refinement execution 纠偏，不是把宿主消费卡写得更严，而是把 `authority head + single-source merge + lineage anti-zombie + transport fail-closed + reopen liability ledger` 继续拉回同一个结构真相面。
