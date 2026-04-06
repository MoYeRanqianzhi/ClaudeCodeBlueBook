# 结构宿主修复稳态纠偏再纠偏执行手册：recorrection card、freshness gate、stale worldview与reopen liability drill

这一章不再解释结构宿主修复稳态纠偏再纠偏协议该消费哪些字段，而是把 Claude Code 式结构 steady-state correction-of-correction protocol 压成一张可持续执行的 `recorrection card`。

它主要回答五个问题：

1. 为什么结构宿主修复稳态纠偏再纠偏真正执行的不是“系统又转绿了”，而是 authority、single-source、resume、event stream / state writeback、stale worldview、anti-zombie 与 reopen liability 的正式 recorrection 顺序。
2. 宿主、CI、评审与交接怎样共享同一张结构 `recorrection card`，而不是各自围绕 pointer、监控、archive prose 与作者说明工作。
3. 应该按什么固定顺序执行 `authority surface restitution`、`single-source reseal`、`resume lineage reproof`、`writeback custody rebinding`、`anti-zombie evidence restitution` 与 `reservation liability rebinding`，才能不让 split-brain、side write 与 zombie 风险重新复辟。
4. 哪些 `reject verdict` 一旦出现就必须阻断 handoff、拒绝 restored 并进入 `re-entry / reopen liability` drill。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的系统健康页”。

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

结构宿主修复稳态纠偏再纠偏真正要执行的不是：

- pointer 还在
- telemetry 又转绿了
- archive prose 更完整
- 作者说“应该没事了”

而是：

- authority、single-source、resume lineage、event stream / state writeback、stale worldview、ghost capability、anti-zombie 与 reservation 仍围绕同一个结构真相面正式宣布：现在可以无人继续盯防，同时仍保留合法 `re-entry / reopen` 责任边界

所以这层 playbook 最先要看的不是：

- `recorrection card` 已经填完了

而是：

1. 当前 recorrection object 是否真的仍被唯一 authority object 支撑。
2. 当前 `single-source reseal` 是否真的 seal，而不是只剩更整洁的目录叙事。
3. 当前 `resume lineage reproof` 与 `writeback custody rebinding` 是否仍经过唯一主路径，而不是 telemetry 与 sidecar 旁路。
4. 当前 `event stream / state writeback` 是否仍严格分层，freshness gate 是否先于 continuity 生效。
5. 当前 `anti-zombie evidence restitution` 是否真的让 later 团队无需作者口述即可消费同一结构真相。
6. 当前 `stale worldview` 与 `ghost capability` 是否仍被正式驱逐。
7. 当前 `reservation liability rebinding` 是否仍围绕同一个 recovery boundary，而不是围绕“以后再试一次”。

## 2. 共享 recorrection card 最小字段

每次结构宿主修复稳态纠偏再纠偏巡检，宿主、CI、评审与交接系统至少应共享：

1. `recorrection_card_id`
2. `authority_object_id`
3. `authoritative_path`
4. `single_source_refs`
5. `dependency_seam_status`
6. `resume_lineage_ref`
7. `writeback_primary_path`
8. `event_stream_writeback_split`
9. `freshness_gate_attested`
10. `stale_worldview_evidence`
11. `ghost_capability_eviction_state`
12. `anti_zombie_evidence_ref`
13. `archive_truth_ref`
14. `reopen_reservation_boundary`
15. `reservation_owner`
16. `reject_verdict`
17. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看 authority object 与 writeback 主路径是否仍唯一。
2. CI 看 single-source、resume 顺序、generation、event-stream-vs-state-writeback、freshness gate 与 anti-zombie 证据是否完整。
3. 评审看 pointer、recovery asset 与 live truth 是否仍被清楚分层。
4. 交接看 later 团队能否围绕同一 authority state 安全接手与 reopen。

## 3. 固定 reject verdict 顺序

### 3.1 先冻结假健康信号

先把 pointer 健康感、telemetry 转绿、archive prose 与作者说明一律降回投影，不允许这些信号先行充当 restored 证明。

### 3.2 再验 `authority surface restitution`

再看：

1. 当前 query、task、session 或 remote worker 是否仍只有唯一 authority object。
2. breadcrumb、pointer 与 UI heuristic 是否仍没有充当真相面。
3. generation / status transition 是否仍能阻止 stale path 回写。
4. 不同 host / consumer 是否仍只持有不同宽度的 authority projection，而不是各自宣布 present truth。

### 3.3 再验 `single-source reseal`

再看：

1. `single_source_refs` 是否仍指向唯一真相入口。
2. `dependency_seam_status` 是否仍阻止 seam regression 与重型旁路依赖复活。
3. 当前 recorrection 是否仍把目录美学降回结果，而不是把它当成原因。

### 3.4 再验 `resume lineage reproof`

再看：

1. restore、hydrate、adopt 与 clear stale 是否仍按正式顺序被复证。
2. `late_resume_detected`、`generation_regression_detected` 与 stale adoption 是否仍被禁止。
3. terminal object 是否仍不会被 stale snapshot 或 late response 复活。
4. `freshness_gate_attested` 是否仍先于 continuity 生效。

### 3.5 再验 `writeback custody rebinding`

再看：

1. `writeback_primary_path` 是否仍是唯一主 chokepoint。
2. `worker_status`、`external_metadata` 与 merge / delete 语义是否仍受控。
3. `event_stream_writeback_split` 是否仍严格成立。
4. 是否仍不存在绕过主写点的 side write。
5. `stale_worldview_evidence` 是否仍证明 validator、adapter 与 host consumer 没有站在 stale worldview 上继续签发允许。

### 3.6 再验 `anti-zombie evidence restitution`

再看：

1. `anti_zombie_evidence_ref` 是否仍有正式复证。
2. stale writer、duplicate control response 与 orphan state 是否仍被显式清退。
3. `ghost_capability_eviction_state` 是否仍证明 dead capability token 已经被 clear / evict / unpin。
4. 当前 reproof 是否仍能阻止旧 generation 复活。

### 3.7 最后验 `reservation liability rebinding` 与 `reject_verdict`

最后才看：

1. `reopen_reservation_boundary`、`reservation_owner` 与 `threshold_retained_until` 是否仍合法存在。
2. `reject_verdict` 是否与前六步对象一致。
3. 交接是否足以让 later 团队在无需补猜的前提下接手与降级。

更稳的最终 verdict 只应落在：

1. `steady_state_restituted`
2. `hard_reject`
3. `reentry_required`
4. `reopen_required`

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前结构 recorrection execution：

1. `recorrection_object_missing`
2. `authority_surface_missing`
3. `single_source_breached`
4. `resume_lineage_unproven`
5. `writeback_custody_missing`
6. `anti_zombie_evidence_missing`
7. `reservation_liability_unbound`
8. `stale_worldview_unchecked`
9. `ghost_capability_not_evicted`
10. `reopen_required`

## 5. re-entry 与 reopen liability 处理顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先停止新的 reconnect、adopt 与 remote resume，不再让旧资产继续写回。
2. 先把 verdict 降级为 `hard_reject`、`reentry_required` 或 `reopen_required`。
3. 先把 pointer、sidecar 与 UI 投影降回 breadcrumb，不再让它们充当 authority。
4. 先回到上一个仍可验证的 authority object、writeback path 与 fresh worldview，补完 seam audit、lineage reproof 与 anti-zombie evidence。
5. 如果根因落在 recorrection protocol 本身，就回跳 `../api/77` 做对象级修正。

## 6. 最小 drill 集

每轮至少跑下面六个结构宿主稳态纠偏再纠偏执行演练：

1. `authority_first_reject_replay`
2. `single_source_seam_audit_replay`
3. `resume_lineage_reproof_replay`
4. `writeback_custody_rebind_replay`
5. `anti_zombie_evidence_restitution_replay`
6. `reopen_liability_boundary_replay`
7. `stale_worldview_replay`
8. `ghost_capability_eviction_replay`

## 7. 复盘记录最少字段

每次结构宿主稳态纠偏再纠偏失败、再入场或 reopen，至少记录：

1. `recorrection_card_id`
2. `authority_object_id`
3. `authoritative_path`
4. `single_source_refs`
5. `resume_lineage_ref`
6. `writeback_primary_path`
7. `event_stream_writeback_split`
8. `stale_worldview_evidence`
9. `ghost_capability_eviction_state`
10. `anti_zombie_evidence_ref`
11. `archive_truth_ref`
12. `reopen_reservation_boundary`
13. `reject_verdict`
14. `verdict_reason`

## 8. 苏格拉底式检查清单

在你准备宣布“结构已完成稳态纠偏再纠偏执行”前，先问自己：

1. 我现在修回的是唯一 authority object，还是只是把入口感重新包装了一遍。
2. 我现在保住的是 `single-source + seam audit`，还是更漂亮的目录讲法。
3. 我现在保住的是 `resume lineage` 与 `writeback custody`，还是几次幸运 reconnect 的结果。
4. `event stream` 与 `state writeback` 有没有被重新混写。
5. validator、adapter 与 host consumer 现在看到的是 fresh worldview，还是 stale worldview。
6. 我现在归还的是 anti-zombie 证据，还是一段更会解释的 archive prose。
7. later 团队明天如果必须 reopen，依赖的是正式 boundary，还是一句“以后再试一次”。

## 9. 一句话总结

真正成熟的结构宿主修复稳态纠偏再纠偏执行，不是把健康感运行得更像制度，而是持续证明 authority、single-source、resume、event stream / state writeback、stale worldview、ghost capability、anti-zombie 与 reopen liability 仍围绕同一个结构真相面说真话。
