# 结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行手册：per-host authority width card、shared reject order、freshness gate与reopen drill

这一章不再解释结构 refinement correction refinement protocol 该共享哪些字段，而是把 Claude Code 式结构 refinement correction refinement protocol 压成一张可持续执行的 cross-consumer `authority width card`。

它主要回答五个问题：

1. 为什么结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修真正执行的不是“系统又转绿了”，而是 `authority object -> per-host authority width -> event stream / state writeback -> freshness gate -> stale worldview -> ghost capability -> fail-closed reopen liability` 的正式顺序。
2. 宿主、CI、评审与交接怎样共享同一张结构 `authority width card`，而不是各自围绕 pointer、telemetry、archive prose 与临时说明工作。
3. 应该按什么固定顺序执行 `authority width`、`event-stream/state-writeback split`、`freshness-gated lineage`、`stale-worldview/ghost-capability eviction`、`transport/fail-closed`、`shared reject` 与 `reopen drill`，才能不让 split-brain、side write 与 zombie 风险重新复辟。
4. 哪些 `shared reject order` 一旦出现就必须阻断 handoff、拒绝 restored 并进入 `re-entry / reopen`。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成更细的系统健康页。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:186-400`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-211`
- `claude-code-source-code/src/utils/worktree.ts:1046-1172`
- `claude-code-source-code/src/cli/transports/SSETransport.ts:149-457`

## 1. 第一性原理

结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修真正要执行的不是：

- pointer 还在
- telemetry 又转绿了
- archive prose 更完整
- 当前看起来已经很稳定

而是：

- `authority object` 是否仍只通过一个正式 present-truth surface 宣布当前世界。
- 每个 host 消费的是不是同一 authority object 的合法 `per-host authority width`，而不是自己额外宣布一份 current state。
- `event stream` 是否仍只保存时间线，`state writeback` 是否仍独占 present truth。
- `freshness gate` 是否仍先于 continuity 生效，`stale worldview` 与 `ghost capability` 是否仍在写回前就被驱逐。
- `dirty git fail-closed` 与 worktree guard 是否仍把“过去写坏现在”挡在写回前面。

Claude Code 的源码先进性之所以成立，不在目录更整洁，而在它把：

1. truth 先于 projection
2. 现在时态先于恢复资产
3. future maintainer 是正式消费者
4. fail-closed 是结构对象本身

提前编码进 authority、width、writeback、freshness 与 eviction 纪律。

## 2. 共享 authority width card 最小字段

每次结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修巡检，宿主、CI、评审与交接系统至少应共享：

1. `authority_width_card_id`
2. `repair_attestation_id`
3. `reprotocol_session_id`
4. `authority_object_id`
5. `authoritative_path`
6. `externally_verifiable_head`
7. `per_host_authority_width`
8. `writeback_primary_path`
9. `event_stream_writeback_split`
10. `freshness_gate_attested`
11. `resume_lineage_ref`
12. `lineage_reproof_ref`
13. `stale_worldview_evidence`
14. `ghost_capability_eviction_state`
15. `anti_zombie_evidence_ref`
16. `transport_boundary_attested`
17. `dirty_git_fail_closed_attested`
18. `worktree_change_guard`
19. `unpushed_commit_guard`
20. `shared_reject_verdict`
21. `threshold_retained_until`
22. `reopen_required_when`
23. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看 `authority object`、`per_host_authority_width` 与 `writeback_primary_path` 是否仍唯一。
2. CI 看 `event stream / state writeback`、`freshness gate`、`stale worldview`、`ghost capability`、transport 与 fail-closed 顺序是否完整。
3. 评审看 pointer、telemetry 与 archive prose 是否仍被清楚降为投影。
4. 交接看 later 团队能否只凭 card 安全接手与 reopen。

## 3. 固定 shared reject order

### 3.1 先验 `repair_session_object`

先看当前准备宣布 protocol 可执行的，到底是不是同一个 `authority_object_id`，而不是一份更正式的结构说明。

### 3.2 再验 `authority_object_and_width_surface`

再看：

1. `authority_object_id`
2. `authoritative_path`
3. `externally_verifiable_head`
4. `per_host_authority_width`
5. `writer_chokepoint`

这一步先回答：

- 当前真相主语到底是谁
- 不同 host 消费的是不是同一个 authority object 的合法 width

### 3.3 再验 `event_stream_writeback_split_and_freshness_gate`

再看：

1. `writeback_primary_path`
2. `event_stream_writeback_split`
3. `freshness_gate_attested`
4. `resume_lineage_ref`
5. `lineage_reproof_ref`
6. `stale_finally_suppressed`

这一步先回答：

- `event stream` 有没有在偷做 `state writeback`
- 旧 finally、旧 append 与旧 snapshot 是否在写回前就已被 freshness gate 剥夺 authority

### 3.4 再验 `stale_worldview_and_ghost_capability_eviction`

再看：

1. `stale_worldview_evidence`
2. `ghost_capability_eviction_state`
3. `anti_zombie_evidence_ref`
4. `stale_writer_evidence`
5. `orphan_duplicate_quarantined`

这一步先回答：

- 当前判断站在的是 fresh worldview，还是 stale worldview
- dead capability token、旧 pin、旧 authority width 与 orphan state 是否仍被正式驱逐

### 3.5 再验 `transport_fail_closed_and_shared_reject`

再看：

1. `transport_boundary_attested`
2. `single_message_semantics_attested`
3. `dirty_git_fail_closed_attested`
4. `worktree_change_guard`
5. `unpushed_commit_guard`
6. `shared_reject_verdict`

这一步先回答：

- transport 还只允许一种消息语义吗
- 当前写回边界还是 fail-closed 吗
- 共同 reject 是否已经覆盖 `event_stream_usurped_present`、`stale_worldview_unchecked`、`ghost_capability_not_evicted` 与 `per_host_projection_claimed_authority`

### 3.6 最后验 `long_horizon_reopen_liability`

最后才看：

1. `reopen_boundary`
2. `return_authority_object`
3. `return_writeback_path`
4. `return_generation_floor`
5. `threshold_retained_until`
6. `reentry_required_when`
7. `reopen_required_when`

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前结构执行并拒绝 handoff：

1. `authority_object_missing`
2. `per_host_projection_claimed_authority`
3. `event_stream_usurped_present`
4. `freshness_gate_missing`
5. `stale_worldview_unchecked`
6. `ghost_capability_not_evicted`
7. `transport_boundary_missing`
8. `dirty_git_fail_closed_false`
9. `repair_attestation_rebuild_required`

## 5. reopen drill 最小顺序

一旦 verdict 升级为 `reentry_required` 或 `reopen_required`，最低顺序应固定为：

1. 冻结当前 `authority width card`，禁止把 pointer 健康感与 telemetry 转绿继续当真。
2. 保存 `authority_object_id`、`per_host_authority_width`、`writeback_primary_path`、`event_stream_writeback_split`、`freshness_gate_attested`、`stale_worldview_evidence`、`ghost_capability_eviction_state` 与 `dirty_git_fail_closed_attested`。
3. 先重建 `authority object + per-host authority width`，再重建 `event stream / state writeback + freshness gate`，最后才考虑重新写回。
4. 明确 `return_authority_object`、`return_writeback_path` 与 `reopen_required_when`，禁止把 reopen 写成“之后再看”。

## 6. 苏格拉底式自检

在你准备宣布“结构 protocol 已经执行完毕”前，先问自己：

1. 我共享的是同一个结构真相面，还是四份彼此相像的健康说明。
2. 我共享的是同一条 `shared reject order`，还是不同消费者各自的健康标准。
3. 我保留的是 future reopen 的正式能力，还是一句“以后有问题再看”。
4. later 团队接手时依赖的是 `authority object`、`per-host authority width`、`freshness gate` 与 eviction 状态，还是仍要回到 pointer、telemetry 与 reconnect 提示。
5. `event stream` 与 `state writeback` 有没有被重新混写。
6. validator、adapter 与 host consumer 现在看到的是 fresh worldview，还是 stale worldview。
7. 我现在保护的是 Claude Code 的结构先进性，还是只是在把它写成更像先进系统的 prose。

## 7. 一句话总结

真正成熟的结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行，不是把结构写得更像制度，而是持续证明 `authority object`、`per-host authority width`、`event stream / state writeback`、`freshness gate`、`stale worldview` 与 `ghost capability` 仍在共同保护同一个 present truth。
