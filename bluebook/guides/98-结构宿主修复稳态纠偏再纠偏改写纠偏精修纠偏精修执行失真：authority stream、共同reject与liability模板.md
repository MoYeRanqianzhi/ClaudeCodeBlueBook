# 如何把结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行失真压回结构真相面：固定refinement correction refinement顺序、authority stream、共同reject与liability改写模板骨架

这一章不再解释结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行最常怎样失真，而是把 Claude Code 式结构 refinement correction refinement execution distortion 压成一张可执行的 builder-facing 手册。

它主要回答五个问题：

1. 为什么结构 refinement correction refinement execution distortion 真正要救回的不是一张更严的 cross-consumer `repair card`，而是同一个结构真相面。
2. 怎样把假 `repair card`、假共同 `reject` 语义与假 `reopen liability` 压回固定 `refinement correction refinement order`。
3. 哪些现象应被直接升级为共同硬拒收，而不是继续补 pointer 说明、telemetry 健康感与 reconnect 成功率。
4. 怎样把 `repair card`、`shared reject rebind block` 与 `long-horizon reopen liability ticket` 重新压回对象级骨架。
5. 怎样用苏格拉底式追问避免把改写写成“把结构运维卡再做严一点”。

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

这些锚点共同说明：

- 结构 refinement correction refinement execution 真正最容易失真的地方，不在 cross-consumer `repair card` 有没有写出来，而在 authority、lineage、fresh merge、single-source writeback、anti-zombie、transport boundary、dirty git fail-closed 与 reopen boundary 是否仍围绕同一个结构真相面消费 later 维护者的判断。

## 1. 第一性原理

结构 refinement correction refinement execution distortion 真正要救回的不是：

- 一张更完整的 `repair card`
- 一套更统一的健康页语言
- 一份更礼貌的 reopen 备注

而是：

- `authority surface -> lineage / fresh merge -> single-source writeback -> anti-zombie / transport / fail-closed -> shared reject semantics -> long-horizon reopen liability` 仍围绕同一个结构真相面继续被 later 团队复证

所以更稳的纠偏目标不是：

- 先把恢复叙事说圆

而是：

1. 先把假 `repair card` 降回结果信号，而不是让它充当主对象。
2. 先把 authority、head、lineage 与 merge 从 pointer、telemetry 与 reconnect 成功率里救出来。
3. 先把 single-source、anti-zombie、transport 与 fail-closed 从目录整洁度与“当前没报错”里救出来。
4. 先把共同 `reject` 语义从四类消费者各自的健康投影里救出来。
5. 最后才把 reopen boundary、guard 与 threshold 从作者记忆里救出来。

## 2. 固定 refinement correction refinement 顺序

### 2.1 先冻结假 `repair card`

第一步不是润色 `repair card`，而是冻结假修复信号：

1. 禁止 `reject_verdict=steady_state_chain_resealed` 在对象复核之前生效。
2. 禁止 pointer、telemetry、目录整洁度与 reconnect 成功率继续充当结构 truth proof。
3. 禁止作者说明、archive prose 与健康面板继续充当 later 维护者的 authority 代理。

最小冻结对象：

1. `repair_card_id`
2. `repair_session_id`
3. `authority_object_id`
4. `authoritative_path`
5. `externally_verifiable_head`
6. `resume_lineage_ref`
7. `repair_attestation_id`
8. `reject_verdict`
9. `verdict_reason`

### 2.2 再恢复 `authority surface`

第二步要把主语救回：

1. `authority_object_id`
2. `authoritative_path`
3. `externally_verifiable_head`
4. `writer_chokepoint`
5. `authority_surface_attested`

authority 不稳时，后续任何 merge、writeback 与 reopen 都可能绑在错误对象上。

### 2.3 再恢复 `lineage / fresh merge`

第三步要把同一条恢复真相救回：

1. `resume_lineage_ref`
2. `generation_ref`
3. `fresh_merge_contract_attested`
4. `stale_finally_suppressed`
5. `append_conflict_resolution_ref`
6. `lineage_fresh_merge_attested`

不要继续做的事：

1. 不要先看 reconnect 是否成功。
2. 不要先看结果没坏。
3. 不要先看 telemetry 是否仍绿。

### 2.4 再恢复 `single-source writeback`

第四步要把唯一写回真相从目录意图里救回：

1. `single_source_ref`
2. `writeback_primary_path`
3. `append_chain_ref`
4. `side_write_quarantined`
5. `single_source_writeback_attested`

没有这一步，精修纠偏仍会把结构 truth 写成“看起来像单源”的目录说明。

### 2.5 再恢复 `anti-zombie / transport / fail-closed`

第五步要把结构系统最值钱的防伪能力救回：

1. `anti_zombie_evidence_ref`
2. `transport_boundary_attested`
3. `single_message_semantics_attested`
4. `dirty_git_fail_closed_attested`
5. `worktree_change_guard`
6. `unpushed_commit_guard`
7. `fail_closed_surface_attested`

这里最关键的是：

- dirty worktree、unpushed commit 与 git 失败都应直接 fail-closed，而不是交给好运气。
- pointer 不是 authority，telemetry 不是 writeback，reconnect 不是 lineage proof。

### 2.6 再恢复 `shared reject semantics`

第六步要把四类消费者的拒收语言重新绑回同一个结构真相面：

1. `shared_reject_semantics_packet`
2. `consumer_projection_demoted`
3. `host_reject_condition`
4. `ci_reject_condition`
5. `review_reject_condition`
6. `handoff_reject_condition`
7. `shared_reject_semantics_attested`

这一步先回答：

- 宿主、CI、评审与交接到底是不是在围绕同一个 authority/merge/fail-closed 对象链说同一种 reject 语言

### 2.7 最后恢复 `long-horizon reopen liability`

最后才把 future reopen 的正式能力救回：

1. `reopen_boundary`
2. `return_authority_object`
3. `return_writeback_path`
4. `return_generation_floor`
5. `threshold_retained_until`
6. `reentry_required_when`
7. `reopen_required_when`
8. `long_horizon_reopen_liability_attested`

不要反过来：

1. 不要先补 reconnect 提醒，再修 authority surface。
2. 不要先让 pointer 继续存在，再修 lineage / merge。
3. 不要先让 later 团队“先接着用”，再修 fail-closed guard。

## 3. 共同硬拒收规则

出现下面情况时，应直接升级为共同硬拒收：

1. `repair_session_missing`
2. `authority_surface_unbound`
3. `externally_verifiable_head_missing`
4. `resume_lineage_broken`
5. `fresh_merge_unattested`
6. `single_source_unattested`
7. `side_write_unquarantined`
8. `anti_zombie_evidence_missing`
9. `transport_boundary_missing`
10. `dirty_git_fail_closed_false`
11. `shared_reject_semantics_split`
12. `threshold_retained_until_missing`

这些现象一旦出现，不要继续：

1. 补 pointer 说明
2. 补 telemetry 注释
3. 补“当前看起来还能用”的备注
4. 补“原作者知道怎么恢复”的说明

## 4. Builder-Facing 改写模板骨架

### 4.1 `structure_repair_card_rebind_block`

```md
- repair_session_id:
- authority_object_id:
- authoritative_path:
- externally_verifiable_head:
- resume_lineage_ref:
- fresh_merge_contract_attested:
- single_source_ref:
- anti_zombie_evidence_ref:
- dirty_git_fail_closed_attested:
- threshold_retained_until:
- current_verdict:
- verdict_reason:
```

### 4.2 `structure_shared_reject_rebind_block`

```md
- host_reject_condition:
- ci_reject_condition:
- review_reject_condition:
- handoff_reject_condition:
- consumer_projection_demoted:
- must_block_when:
- may_continue_only_when:
```

### 4.3 `structure_long_horizon_reopen_liability_ticket`

```md
- reopen_boundary:
- return_authority_object:
- return_writeback_path:
- return_generation_floor:
- reentry_required_when:
- reopen_required_when:
- threshold_retained_until:
```

## 5. 苏格拉底式自检

在你准备宣布“结构精修执行失真已经被纠偏”前，先问自己：

1. 我压回的是同一个结构真相面，还是一份更像先进系统的恢复叙事。
2. 我修回的是共同 `reject` 语言，还是四类角色终于都“感觉比较健康”的共识。
3. 我保留的是 formal reopen 能力，还是 reconnect 成功后的乐观希望。
4. later 团队是否能只凭这些块复原 authority、merge、writeback、fail-closed 与 threshold。
5. 我现在保护的是 Claude Code 的结构先进性，还是只是在模仿它的外观。
