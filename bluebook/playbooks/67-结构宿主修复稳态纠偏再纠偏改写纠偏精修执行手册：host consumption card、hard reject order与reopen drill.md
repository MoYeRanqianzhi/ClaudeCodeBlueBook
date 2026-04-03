# 结构宿主修复稳态纠偏再纠偏改写纠偏精修执行手册：host consumption card、hard reject order与reopen drill

这一章不再解释结构 refinement protocol 该消费哪些字段，而是把 Claude Code 式结构 rewrite correction refinement protocol 压成一张可持续执行的 `host consumption card`。

它主要回答五个问题：

1. 为什么结构宿主修复稳态纠偏再纠偏改写纠偏精修真正执行的不是“系统又转绿了”，而是 authority、single-source、lineage、fresh merge、anti-zombie、transport、dirty git fail-closed 与 reopen liability 的正式顺序。
2. 宿主、CI、评审与交接怎样共享同一张结构 `host consumption card`，而不是各自围绕 pointer、telemetry、archive prose 与作者说明工作。
3. 应该按什么固定顺序执行 `refinement session`、`false surface demotion`、`authority head covenant`、`single-source merge custody`、`lineage anti-zombie packet`、`transport fail-closed custody`、`hard reject semantics`、`cross-consumer attestation` 与 `reopen liability ledger`，才能不让 split-brain、side write 与 zombie 风险重新复辟。
4. 哪些 `hard reject` 一旦出现就必须阻断 handoff、拒绝 restored 并进入 `re-entry / reopen` drill。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的系统健康页”。

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

结构宿主修复稳态纠偏再纠偏改写纠偏精修真正要执行的不是：

- pointer 还在
- telemetry 又转绿了
- archive prose 更完整
- 作者说“应该没事了”

而是：

- authority、single-source writeback、lineage、fresh merge、anti-zombie、transport boundary、dirty git fail-closed 与 reopen boundary 仍围绕同一个结构真相面正式宣布：现在可以无人继续盯防，同时仍保留合法 `re-entry / reopen` 责任边界

所以这层 playbook 最先要看的不是：

- `host consumption card` 已经填完了

而是：

1. 当前 refinement session 是否仍由唯一 `authority_object_id + externally_verifiable_head` 支撑。
2. 当前 `single-source merge custody` 是否真的把唯一真相入口与 fresh merge 契约继续绑在一起。
3. 当前 `lineage anti-zombie packet` 是否仍让旧 generation、旧 writer 与 duplicate/orphan state 失去篡位资格。
4. 当前 `transport fail-closed custody` 是否仍保证远端与本地只允许一种消息语义，而且脏工作树直接拒绝继续写。
5. 当前 `reopen liability ledger` 是否仍让 later 团队可以正式反驳当前结构结论。

## 2. 共享 host consumption card 最小字段

每次结构宿主修复稳态纠偏再纠偏改写纠偏精修巡检，宿主、CI、评审与交接系统至少应共享：

1. `host_consumption_card_id`
2. `refinement_session_id`
3. `rewrite_correction_session_id`
4. `authority_object_id`
5. `authoritative_path`
6. `externally_verifiable_head`
7. `single_source_ref`
8. `writeback_primary_path`
9. `lineage_reproof_ref`
10. `fresh_merge_contract`
11. `anti_zombie_evidence_ref`
12. `transport_boundary_attested`
13. `dirty_git_fail_closed_attested`
14. `worktree_change_guard`
15. `unpushed_commit_guard`
16. `reopen_boundary`
17. `shared_consumer_surface`
18. `reject_verdict`
19. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看 authority object 与 writeback 主路径是否仍唯一。
2. CI 看 single-source、lineage、fresh merge、anti-zombie、transport 与 fail-closed 顺序是否完整。
3. 评审看 pointer、recovery asset 与 live truth 是否仍被清楚分层。
4. 交接看 later 团队能否只凭 `host consumption card` 安全接手与 reopen。

## 3. 固定 hard reject 顺序

### 3.1 先验 `rewrite_refinement_session_object`

先看当前准备宣布 refinement 成立的，到底是不是同一个 `authority_object_id`，而不是一份更正式的结构说明。

### 3.2 再验 `false_surface_demotion_contract`

再看：

1. `pointer_not_authority` 是否仍成立。
2. `telemetry_not_evidence` 是否仍成立。
3. `archive_prose_not_truth` 与 `projection_only_refs` 是否仍防止投影篡位。

### 3.3 再验 `authority_head_covenant`

再看：

1. `authority_object_id` 与 `authoritative_path` 是否仍唯一。
2. `externally_verifiable_head` 是否仍比对象自述更优先。
3. breadcrumb、pointer 与恢复提示是否仍没有充当真相面。

### 3.4 再验 `single_source_merge_custody`

再看：

1. `single_source_ref` 与 `writeback_primary_path` 是否仍锁在同一主写点。
2. `fresh_merge_contract` 是否仍保留删除语义。
3. `stale_finally_suppressed` 是否仍阻止旧 finally、旧 append 与旧 snapshot 迟到篡位。

### 3.5 再验 `lineage_anti_zombie_packet`

再看：

1. `resume_lineage_ref` 与 `lineage_reproof_ref` 是否仍让恢复链只沿唯一主路径前进。
2. `anti_zombie_evidence_ref` 是否仍有正式复证。
3. `orphan_duplicate_quarantined` 与 `assistant_sentinel_attested` 是否仍让 duplicate/orphan state 无法回魂。

### 3.6 再验 `transport_fail_closed_custody`

再看：

1. `transport_boundary_attested` 是否仍保证远端、本地与 projection 只允许一种消息语义。
2. `dirty_git_fail_closed_attested` 是否仍保证脏状态直接拒绝继续写。
3. `cleanup_skip_contract_attested` 是否仍阻止“清理时顺手继续写”的假安全。

### 3.7 再验 `hard_reject_semantics_abi` 与 `cross_consumer_attestation_packet`

再看：

1. `hard_reject`、`merge_reproof_required`、`transport_reseal_required`、`fail_closed_reseal_required`、`reentry_required`、`reopen_required` 是否仍围绕对象链触发。
2. `shared_consumer_surface` 是否仍让宿主、CI、评审与交接消费同一组 verdict。

### 3.8 最后验 `reopen_liability_ledger` 与 `reject_verdict`

最后才看：

1. `reopen_boundary`、`return_authority_object` 与 `return_writeback_path` 是否仍正式保留。
2. `threshold_retained_until` 是否仍让 future reopen 不是一句礼貌备注。
3. `reject_verdict` 是否与前七步对象完全一致。

更稳的最终 verdict 只应落在：

1. `steady_state_chain_resealed`
2. `hard_reject`
3. `merge_reproof_required`
4. `transport_reseal_required`
5. `fail_closed_reseal_required`
6. `reentry_required`
7. `reopen_required`

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前结构 refinement execution：

1. `refinement_session_missing`
2. `pointer_as_authority`
3. `head_not_externally_verifiable`
4. `authority_surface_multi_home`
5. `single_source_ref_missing`
6. `fresh_merge_contract_missing`
7. `anti_zombie_evidence_missing`
8. `transport_second_semantics_detected`
9. `dirty_git_fail_open`
10. `reopen_liability_missing`
11. `reopen_required_but_continue`

## 5. re-entry 与 reopen 处理顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先停止新的 reconnect、adopt 与 remote resume，不再让旧资产继续写回。
2. 先把 verdict 降级为 `hard_reject`、`merge_reproof_required`、`transport_reseal_required`、`fail_closed_reseal_required`、`reentry_required` 或 `reopen_required`。
3. 先把 pointer、telemetry、archive prose 与 UI 投影降回 breadcrumb，不再让它们充当 authority。
4. 先回到上一个仍可验证的 authority object 与 writeback path，补完 head attestation、single-source merge、lineage anti-zombie、transport reseal 与 fail-closed guard。
5. 如果根因落在 refinement protocol 本身，就回跳 `../api/86` 做对象级修正。

## 6. 最小 drill 集

每轮至少跑下面八个结构宿主稳态纠偏再纠偏改写纠偏精修执行演练：

1. `refinement_session_replay`
2. `authority_head_replay`
3. `single_source_merge_replay`
4. `lineage_antizombie_replay`
5. `transport_fail_closed_replay`
6. `hard_reject_escalation_replay`
7. `reentry_boundary_replay`
8. `reopen_liability_replay`

## 7. 复盘记录最少字段

每次结构宿主稳态纠偏再纠偏改写纠偏精修失败、再入场或 reopen，至少记录：

1. `host_consumption_card_id`
2. `refinement_session_id`
3. `rewrite_correction_session_id`
4. `authority_object_id`
5. `authoritative_path`
6. `externally_verifiable_head`
7. `single_source_ref`
8. `writeback_primary_path`
9. `lineage_reproof_ref`
10. `fresh_merge_contract`
11. `anti_zombie_evidence_ref`
12. `transport_boundary_attested`
13. `dirty_git_fail_closed_attested`
14. `worktree_change_guard`
15. `unpushed_commit_guard`
16. `reopen_boundary`
17. `shared_consumer_surface`
18. `reject_verdict`
19. `verdict_reason`

## 8. 苏格拉底式检查清单

在你准备宣布“结构已完成稳态纠偏再纠偏改写纠偏精修执行”前，先问自己：

1. 我现在修回的是唯一 authority object，还是只是把入口感重新包装了一遍。
2. 我现在保住的是 `single-source + fresh merge`，还是几次幸运 reconnect 的结果。
3. 我现在保住的是 `lineage + anti-zombie`，还是一张安静的 telemetry 面板。
4. 我现在保住的是 `transport boundary + dirty git fail-closed`，还是“当前没报错”的侥幸。
5. later 团队明天如果必须 reopen，依赖的是正式 reopen liability，还是一句“以后再试一次”。

## 9. 一句话总结

真正成熟的结构宿主修复稳态纠偏再纠偏改写纠偏精修执行，不是把健康感运行得更像制度，而是持续证明 authority、single-source merge、lineage、anti-zombie、transport、dirty git fail-closed 与 reopen liability 仍围绕同一个结构真相面说真话。
