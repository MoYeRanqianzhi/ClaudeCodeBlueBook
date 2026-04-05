# 结构宿主修复稳态纠偏执行手册：correction card、correction verdict order、archive restitution、re-entry threshold与reopen responsibility drill

这一章不再解释结构宿主修复稳态纠偏协议该消费哪些字段，而是把 Claude Code 式结构 steady-state correction 压成一张可持续执行的纠偏手册。

它主要回答五个问题：

1. 为什么结构宿主修复稳态纠偏真正执行的不是“系统还活着”，而是 authority、resume、writeback、archive、anti-zombie 与 reopen responsibility 的正式 correction 顺序。
2. 宿主、CI、评审与交接怎样共享同一张结构 correction card，而不是各自围绕 pointer、监控、archive prose 与作者说明工作。
3. 应该按什么固定顺序执行 `authority rebind`、`resume lineage rebuild`、`writeback recustody`、`anti-zombie reproof`、`archive truth restitution` 与 `reservation rebinding`，才能不让 zombie 风险重新复辟。
4. 哪些 correction verdict 一旦出现就必须阻断 handoff、拒绝 restored 并进入 re-entry threshold / reopen responsibility drill。
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

结构宿主修复稳态纠偏真正要执行的不是：

- pointer 还在
- telemetry 又转绿了
- archive prose 更完整
- 作者说“应该没事了”

而是：

- authority、resume、writeback、anti-zombie、archive 与 reservation 仍围绕同一个结构真相面正式宣布：现在可以无人继续盯防，同时仍保留合法 re-entry / reopen responsibility

所以这层 playbook 最先要看的不是：

- correction card 已经填完了

而是：

1. 当前 correction object 是否真的仍被唯一 authority object 支撑。
2. 当前 `resume lineage rebuild` 是否真的 seal，而不是只剩几次幸运 reconnect。
3. 当前 `writeback recustody` 是否仍经过唯一主路径，而不是 telemetry 与 sidecar 旁路。
4. 当前 `anti-zombie reproof` 与 `archive truth restitution` 是否真的让 later 团队无需作者口述即可消费同一结构真相。
5. 当前 `reservation rebinding` 是否仍围绕同一个 recovery boundary，而不是围绕旧路径与“以后再试一次”。

## 2. 共享 correction card 最小字段

每次结构宿主修复稳态纠偏巡检，宿主、CI、评审与交接系统至少应共享：

1. `steady_correction_object_id`
2. `authority_object_id`
3. `authority_rebind_state`
4. `resume_lineage_ref`
5. `writeback_primary_path`
6. `writeback_recustody_state`
7. `anti_zombie_evidence_ref`
8. `archive_truth_ref`
9. `reopen_reservation_boundary`
10. `correction_verdict`
11. `verdict_reason`
12. `reentry_trigger`

四类消费者的分工应固定为：

1. 宿主看 authority object 与 writeback 主路径是否仍唯一。
2. CI 看 resume 顺序、generation 与 archive 证据是否完整。
3. 评审看 pointer、recovery asset 与 live truth 是否仍被清楚分层。
4. 交接看 later 团队能否围绕同一 authority state 安全接手与 reopen。

## 3. 固定 correction verdict 顺序

### 3.1 先冻结假稳态信号

先把 pointer 健康感、telemetry 转绿、archive prose 与作者说明一律降回投影，不允许这些信号先行充当 restored 证明。

### 3.2 再验 `authority rebind`

再看：

1. 当前 query、task、session 或 remote worker 是否仍只有唯一 authority object。
2. breadcrumb、pointer 与 UI heuristic 是否仍没有充当真相面。
3. generation / status transition 是否仍能阻止 stale path 回写。

只要 authority 仍靠入口感维持，就不能 restored。

### 3.3 再验 `resume lineage rebuild`

再看：

1. restore、hydrate、adopt 与 clear stale 是否仍按正式顺序被 rebuild。
2. `late_resume_detected`、`generation_regression_detected` 与 stale adoption 是否仍被禁止。
3. terminal object 是否仍不会被 stale snapshot 或 late response 复活。

### 3.4 再验 `writeback recustody`

再看：

1. `writeback_primary_path` 是否仍是唯一主 chokepoint。
2. `worker_status`、`external_metadata` 与 merge/delete 语义是否仍受控。
3. 是否仍不存在绕过主写点的 side write。

writeback 如果还靠 telemetry 转绿证明，就不能 restored。

### 3.5 再验 `anti-zombie reproof`

再看：

1. `anti_zombie_evidence_ref` 是否仍有正式复证。
2. stale writer、duplicate control response 与 orphan state 是否仍被显式清退。
3. 当前 reproof 是否仍能阻止旧 generation 复活。

### 3.6 再验 `archive truth restitution`

再看：

1. `archive_truth_ref`、`archive_pointer` 与 `retired_surface_hash` 是否仍可审计。
2. 当前 archive 是否仍保存结构真相，而不是只剩一段归档说明。
3. author memory 是否已被 demote 成辅助背景，而不是唯一解释源。

### 3.7 最后验 `reservation rebinding` 与 `correction_verdict`

最后才看：

1. `reopen_reservation_boundary`、`reservation_owner` 与 `threshold_retained_until` 是否仍合法存在。
2. `correction_verdict` 是否与前六步对象一致。
3. 交接是否足以让 later 团队在无需补猜的前提下接手与降级。

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前结构 correction execution：

1. `steady_correction_object_missing`
2. `authority_rebind_missing`
3. `resume_lineage_unproven`
4. `writeback_recustody_missing`
5. `anti_zombie_reproof_missing`
6. `archive_truth_unrestored`
7. `reservation_boundary_unbound`
8. `reopen_required`

## 5. re-entry threshold 与 reopen responsibility 顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先停止新的 reconnect、adopt 与 remote resume，不再让旧资产继续写回。
2. 先把 verdict 降级为 `hard_reject`、`reentry_required` 或 `reopen_required`。
3. 先把 pointer、sidecar 与 UI 投影降回 breadcrumb，不再让它们充当 authority。
4. 先回到上一个仍可验证的 authority object 与 writeback path，补完 reproof 与 archive truth。
5. 如果根因落在 correction protocol 本身，就回跳 `../api/74` 做对象级修正。

## 6. 最小 drill 集

每轮至少跑下面七个结构宿主稳态纠偏执行演练：

1. `authority_rebind_recheck`
2. `resume_lineage_replay`
3. `writeback_recustody_recheck`
4. `anti_zombie_reproof_replay`
5. `archive_truth_restitution_replay`
6. `reentry_threshold_replay`
7. `reopen_responsibility_boundary_replay`

## 7. 复盘记录最少字段

每次结构宿主稳态纠偏失败、再入场或 reopen，至少记录：

1. `steady_correction_object_id`
2. `authority_object_id`
3. `resume_lineage_ref`
4. `writeback_primary_path`
5. `anti_zombie_evidence_ref`
6. `archive_truth_ref`
7. `reopen_reservation_boundary`
8. `correction_verdict`
9. `verdict_reason`
10. `reentry_trigger`

## 8. 苏格拉底式检查清单

在你准备宣布“结构已完成稳态纠偏执行”前，先问自己：

1. 我现在修回的是唯一 authority object，还是只是把入口感重新包装了一遍。
2. 我现在保住的是 `resume lineage`，还是几次幸运 reconnect 的结果。
3. 我现在托管的是唯一 writeback 主路径，还是监控转绿后的安心感。
4. 我现在归档的是 anti-zombie 证据，还是一段更会解释的 archive prose。
5. later 团队明天如果必须 reopen，依赖的是正式 boundary，还是一句“以后再试一次”。

## 9. 一句话总结

真正成熟的结构宿主修复稳态纠偏执行，不是把健康感运行得更像制度，而是持续证明 authority、resume、writeback、anti-zombie、archive 与 reservation 仍围绕同一个结构真相面说真话。
