# 结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏执行手册：state writeback repair card、freshness gate、reject order与reopen drill

这一章不再解释结构 refinement correction protocol 该共享哪些字段，而是把 Claude Code 式结构 refinement correction protocol 压成一张可持续执行的 `repair card`。

它主要回答五个问题：

1. 为什么结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏真正执行的不是“系统又转绿了”，而是 `authority object -> state writeback -> event stream split -> freshness gate -> stale worldview -> ghost capability -> fail-closed reopen liability` 的正式顺序。
2. 宿主、CI、评审与交接怎样共享同一张结构 `repair card`，而不是各自围绕 pointer、telemetry、archive prose 与临时恢复感工作。
3. 应该按什么固定顺序执行 `authority surface`、`single-source writeback`、`lineage/freshness reproof`、`stale-worldview/ghost-capability eviction`、`transport/fail-closed`、`reject semantics` 与 `reopen liability`，才能不让 split-brain、side write 与 zombie 风险重新复辟。
4. 哪些 `reject order` 一旦出现就必须阻断 handoff、拒绝 restored 并进入 `re-entry / reopen` drill。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的系统健康页”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:186-230`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/utils/worktree.ts:1046-1172`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-211`

## 1. 第一性原理

结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏真正要执行的不是：

- pointer 还在
- telemetry 又转绿了
- archive prose 更完整
- 当前没有再报错

而是：

- `state writeback` 是否仍是唯一 present truth surface。
- `event stream` 是否仍只保存时间线，不能临时重建当前世界。
- `freshness gate` 是否仍先于 continuity 生效，旧 head、旧 generation、旧 pointer 会不会在写回前就被剥夺 authority。
- `stale worldview` 是否仍不能继续签发允许，`ghost capability` 是否仍不能冒充 live authority。
- `fail-closed worktree` 是否仍把脏工作树与未推送提交挡在写回前面。

所以这层 playbook 最先要看的不是：

- `repair card` 已经填完了

而是：

1. 当前 correction object 是否仍由唯一 `authority_object_id + externally_verifiable_head` 支撑。
2. 当前 `single-source writeback contract` 是否真的把唯一真相入口与主写回路径继续绑在一起。
3. 当前 `event_stream_writeback_split + freshness_gate_attested` 是否仍阻止 stale finally、旧 append 与旧 snapshot 迟到篡位。
4. 当前 `stale_worldview_evidence + ghost_capability_eviction_state` 是否仍让旧判断与旧能力失去回写资格。
5. 当前 `fail-closed worktree contract` 是否仍保证脏工作树与未推送提交直接拒绝继续写。

## 2. 共享 repair card 最小字段

每次结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏巡检，宿主、CI、评审与交接系统至少应共享：

1. `repair_card_id`
2. `reprotocol_session_id`
3. `authority_object_id`
4. `authoritative_path`
5. `externally_verifiable_head`
6. `single_source_ref`
7. `writeback_primary_path`
8. `event_stream_writeback_split`
9. `freshness_gate_attested`
10. `resume_lineage_ref`
11. `lineage_reproof_ref`
12. `generation_guard_attested`
13. `stale_worldview_evidence`
14. `ghost_capability_eviction_state`
15. `anti_zombie_evidence_ref`
16. `transport_boundary_attested`
17. `dirty_git_fail_closed_attested`
18. `worktree_change_guard`
19. `unpushed_commit_guard`
20. `reopen_boundary`
21. `threshold_retained_until`
22. `reject_verdict`
23. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看 authority object 与 writeback 主路径是否仍唯一。
2. CI 看 `event stream / state writeback`、`freshness gate`、`stale worldview`、`ghost capability`、transport 与 fail-closed 顺序是否完整。
3. 评审看 pointer、telemetry 与 archive prose 是否仍被清楚降为投影。
4. 交接看 later 团队能否只凭 `repair card` 安全接手与 reopen。

## 3. 固定 reject order

### 3.1 先验 `reprotocol_session_object`

先看当前准备宣布 refinement correction 完成的，到底是不是同一个 `authority_object_id`，而不是一份更正式的结构说明。

### 3.2 再验 `authority_surface_contract`

再看：

1. `authority_object_id`
2. `authoritative_path`
3. `externally_verifiable_head`
4. `writer_chokepoint`

这一步先回答：

- 当前真相主语到底是谁

### 3.3 再验 `single_source_writeback_contract`

再看：

1. `single_source_ref`
2. `writeback_primary_path`
3. `event_stream_writeback_split`
4. `append_chain_ref`
5. `side_write_quarantined`

这一步先回答：

- 现在有没有旁路写还能回魂
- `event stream` 有没有在偷做 `state writeback`

### 3.4 再验 `lineage_freshness_reproof`

再看：

1. `resume_lineage_ref`
2. `lineage_reproof_ref`
3. `generation_guard_attested`
4. `fresh_merge_contract_attested`
5. `freshness_gate_attested`
6. `stale_finally_suppressed`

这一步先回答：

- later 团队恢复的是不是同一个对象链
- `fresh merge` 的本体是不是 freshness gate 先剥夺旧 writer 的 authority，而不是 merge 更聪明

### 3.5 再验 `stale_worldview_and_ghost_capability_eviction`

再看：

1. `stale_worldview_evidence`
2. `ghost_capability_eviction_state`
3. `anti_zombie_evidence_ref`
4. `stale_writer_evidence`
5. `orphan_duplicate_quarantined`

这一步先回答：

- 当前判断站在的是 fresh worldview，还是 stale worldview
- dead capability token、旧 pin 与旧 authority width 还有没有机会回魂

### 3.6 再验 `transport_fail_closed_contract`

再看：

1. `transport_boundary_attested`
2. `single_message_semantics_attested`
3. `dirty_git_fail_closed_attested`
4. `worktree_change_guard`
5. `unpushed_commit_guard`

这一步先回答：

- 当前 transport 还只允许一种消息语义吗
- 当前写回边界还是 fail-closed 吗

### 3.7 再验 `reject_semantics_packet`

再看：

1. `hard_reject`
2. `merge_reproof_required`
3. `freshness_gate_reseal_required`
4. `stale_worldview_reproof_required`
5. `ghost_capability_eviction_required`
6. `transport_reseal_required`
7. `fail_closed_reseal_required`
8. `reentry_required`
9. `reopen_required`

### 3.8 最后验 `long_horizon_reopen_liability`

最后才看：

1. `reopen_boundary`
2. `return_authority_object`
3. `return_writeback_path`
4. `return_generation_floor`
5. `threshold_retained_until`
6. `reentry_required_when`
7. `reopen_required_when`

更稳的最终 verdict 只应落在：

1. `steady_state_chain_resealed`
2. `hard_reject`
3. `merge_reproof_required`
4. `freshness_gate_reseal_required`
5. `stale_worldview_reproof_required`
6. `ghost_capability_eviction_required`
7. `transport_reseal_required`
8. `fail_closed_reseal_required`
9. `reentry_required`
10. `reopen_required`

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前结构 refinement correction execution：

1. `reprotocol_session_missing`
2. `pointer_as_authority`
3. `single_source_missing`
4. `event_stream_usurped_present`
5. `freshness_gate_missing`
6. `stale_generation_can_write`
7. `stale_worldview_unchecked`
8. `ghost_capability_not_evicted`
9. `anti_zombie_evidence_missing`
10. `transport_second_semantics_detected`
11. `dirty_git_fail_open`
12. `reopen_required_but_continue`

## 5. re-entry 与 reopen 处理顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先停止新的 reconnect、adopt 与 remote resume，不再让旧资产继续写回。
2. 先把 verdict 降级为 `hard_reject`、`merge_reproof_required`、`freshness_gate_reseal_required`、`stale_worldview_reproof_required`、`ghost_capability_eviction_required`、`transport_reseal_required`、`fail_closed_reseal_required`、`reentry_required` 或 `reopen_required`。
3. 先把 pointer、telemetry、archive prose 与 UI 投影降回 breadcrumb，不再让它们充当 authority。
4. 先回到上一个仍可验证的 authority object 与 writeback path，补完 `event_stream_writeback_split`、`freshness_gate_attested`、`lineage_reproof_ref`、`stale_worldview_evidence`、`ghost_capability_eviction_state`、transport reseal 与 fail-closed guard。
5. 如果根因落在 refinement correction protocol 本身，就回跳 `../api/89` 做对象级修正。

## 6. 最小 drill 集

每轮至少跑下面八个结构宿主稳态纠偏再纠偏改写纠偏精修纠偏执行演练：

1. `authority_surface_replay`
2. `event_stream_writeback_replay`
3. `freshness_gate_replay`
4. `stale_worldview_replay`
5. `ghost_capability_eviction_replay`
6. `anti_zombie_replay`
7. `transport_boundary_replay`
8. `reopen_liability_replay`

## 7. 复盘记录最少字段

每次结构宿主稳态纠偏再纠偏改写纠偏精修纠偏失败、再入场或 reopen，至少记录：

1. `repair_card_id`
2. `reprotocol_session_id`
3. `authority_object_id`
4. `authoritative_path`
5. `writeback_primary_path`
6. `event_stream_writeback_split`
7. `freshness_gate_attested`
8. `stale_worldview_evidence`
9. `ghost_capability_eviction_state`
10. `anti_zombie_evidence_ref`
11. `reject_verdict`
12. `verdict_reason`

## 8. 苏格拉底式检查清单

在你准备宣布“结构已完成稳态纠偏再纠偏改写纠偏精修纠偏执行”前，先问自己：

1. 我现在修回的是唯一 authority object，还是只是把入口感重新包装了一遍。
2. 我现在保住的是 `state writeback`，还是只是在等 `event stream` 暂时别来篡位。
3. 我现在保住的是 `freshness gate`，还是几次幸运 reconnect 的结果。
4. 我现在驱逐的是 `stale worldview` 与 `ghost capability`，还是只是在看一张安静的 telemetry 面板。
5. later 团队明天如果必须 reopen，依赖的是正式 reopen liability，还是一句“以后再试一次”。

## 9. 一句话总结

真正成熟的结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏执行，不是把健康感运行得更像制度，而是持续证明 `state writeback` 仍是唯一 present truth surface，`event stream` 不篡位、`freshness gate` 先剥夺旧 authority、`stale worldview` 与 `ghost capability` 不得继续冒充 live authority。
