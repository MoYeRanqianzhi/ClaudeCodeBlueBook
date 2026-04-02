# 结构宿主修复稳态执行手册：steady-state card、steady verdict order、archive custody、re-entry threshold与reopen reservation drill

这一章不再解释结构宿主修复稳态协议该消费哪些字段，而是把 Claude Code 式结构 steady state 压成一张可持续执行的稳态手册。

它主要回答五个问题：

1. 为什么结构宿主修复稳态真正执行的不是“系统还活着”，而是 authority、resume、writeback、archive、anti-zombie 与 reopen reservation 的正式 steady 顺序。
2. 宿主、CI、评审与交接怎样共享同一张结构 steady-state card，而不是各自围绕 pointer、监控与作者说明工作。
3. 应该按什么固定顺序执行 `authority continuity`、`resume continuity seal`、`writeback custody`、`anti-zombie dormancy`、`archive truth` 与 `reopen reservation boundary`，才能不让 zombie 风险重新复辟。
4. 哪些 steady verdict 一旦出现就必须阻断 handoff、拒绝 steady 并进入 archive / re-entry / reopen reservation drill。
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

结构宿主修复稳态真正要执行的不是：

- pointer 还在
- telemetry 又转绿了
- 作者说“应该没事了”

而是：

- authority、resume、writeback、anti-zombie 与 boundary 仍围绕同一个结构真相面正式宣布现在可以无人继续盯防，同时保留合法 reopen reservation

所以这层 playbook 最先要看的不是：

- steady-state card 已经填完了

而是：

1. 当前 authority continuity 是否真的仍被唯一 authority object 支撑。
2. 当前 resume 顺序是否真的 seal，而不是只剩几次幸运成功。
3. 当前 writeback 是否仍经过唯一主路径，而不是 telemetry 与 sidecar 旁路。
4. 当前 anti-zombie 是否真的进入可审计 archive，而不是一句“我们已经处理过”。
5. 当前 reopen reservation boundary 是否仍围绕同一个 recovery boundary，而不是围绕旧路径与作者记忆。

## 2. 共享 steady-state card 最小字段

每次结构宿主修复稳态巡检，宿主、CI、评审与交接系统至少应共享：

1. `steady_state_card_id`
2. `authority_object_id`
3. `authority_state_surface`
4. `writer_chokepoint`
5. `resume_continuity_seal`
6. `session_id_lineage`
7. `worktree_resume_path`
8. `writeback_path`
9. `writeback_custody`
10. `anti_zombie_dormancy`
11. `archive_truth`
12. `reopen_reservation_boundary`
13. `steady_verdict`
14. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看 authority object 与 writeback 是否仍唯一。
2. CI 看 resume 顺序、generation 与 archive 证据是否完整。
3. 评审看 breadcrumb、recovery asset 与 live truth 是否仍被清楚分层。
4. 交接看 later 团队能否围绕同一 authority state 安全接手与 reopen。

## 3. 固定 steady verdict 顺序

### 3.1 先验 `authority continuity`

先看：

1. 当前 query、task、session 或 remote worker 是否仍只有唯一 authority object。
2. breadcrumb、pointer 与 UI heuristic 是否仍没有充当真相面。
3. generation / status transition 是否仍能阻止 stale path 回写。

只要 authority 仍靠入口感维持，就不能 steady。

### 3.2 再验 `resume continuity seal`

再看：

1. restore、hydrate、adopt 与 clear stale 是否仍按正式顺序被 seal。
2. `late_resume_detected`、`generation_regression_detected` 与 stale adoption 是否仍被禁止。
3. terminal object 是否仍不会被 stale snapshot 或 late response 复活。

### 3.3 再验 `writeback custody`

再看：

1. `writeback_path` 是否仍是唯一主 chokepoint。
2. `worker_status`、`external_metadata` 与 merge/delete 语义是否仍受控。
3. 是否仍不存在绕过主写点的 side write。

writeback 如果还靠 telemetry 转绿证明，就不能 steady。

### 3.4 再验 `anti-zombie dormancy`

再看：

1. `anti_zombie_projection` 是否仍有正式 dormancy。
2. stale writer、duplicate control response 与 orphan state 是否仍被显式清退。
3. 当前 dormancy 是否仍能阻止旧 generation 复活。

这里不是“最近没再出事”，而是过去不会再写回现在。

### 3.5 再验 `archive truth`

再看：

1. `archive_pointer`、`retired_surface_hash` 与 `archive_truth_attested` 是否仍可审计。
2. 当前 archive 是否仍保存结构真相，而不是只剩一段归档说明。
3. author memory 是否已被 demote 成辅助背景，而不是唯一解释源。

### 3.6 最后验 `reopen reservation boundary` 与 `steady_verdict`

最后才看：

1. `recovery_boundary` 与 `reopen_reservation` 是否仍明确。
2. `reservation_owner` 与 `threshold_retained_until` 是否仍合法存在。
3. `steady_verdict` 是否与前五步对象一致。

如果没有 reservation，steady 就只是把 later 团队重新推回旧路径与作者记忆。

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前结构 steady state：

1. `authority_continuity_missing`
2. `resume_lineage_missing`
3. `writeback_custody_missing`
4. `side_write_risk_retained`
5. `anti_zombie_dormancy_missing`
6. `archive_truth_missing`
7. `reopen_reservation_boundary_missing`
8. `reopen_required`

## 5. archive custody、re-entry threshold 与 reopen reservation 顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先停止新的 reconnect、adopt 与 remote resume，不再让旧资产继续写回。
2. 先把 verdict 降级为 `steady_state_blocked`、`reentry_required` 或 `reopen_required`。
3. 先把 pointer、sidecar 与 UI 投影降回 breadcrumb，不再让它们充当 authority。
4. 先回到上一个仍可验证的 authority object 与 writeback path，补完 dormancy 与 archive truth。
5. 如果根因落在 steady-state 制度本身，就回跳 `../guides/74` 做对象级纠偏。

## 6. 最小 reopen reservation 演练集

每轮至少跑下面八个结构宿主稳态执行演练：

1. `authority_continuity_recheck`
2. `resume_lineage_replay`
3. `writeback_custody_recheck`
4. `stale_writer_dormancy_replay`
5. `duplicate_orphan_recheck`
6. `archive_truth_restore_replay`
7. `reentry_threshold_replay`
8. `reopen_reservation_boundary_replay`

## 7. 复盘记录最少字段

每次结构宿主稳态失败、再入场或 reopen，至少记录：

1. `steady_state_card_id`
2. `authority_object_id`
3. `resume_continuity_seal`
4. `writeback_custody`
5. `anti_zombie_dormancy`
6. `archive_truth`
7. `reopen_reservation_boundary`
8. `steady_verdict`
9. `verdict_reason`
10. `reentry_trigger`

## 8. 苏格拉底式检查清单

在你准备宣布“结构已经 steady”前，先问自己：

1. 当前 authority object 到底是什么，later 维护者能否不靠口述识别出来。
2. 当前 steady 依赖的是对象链，还是一组幸运发生的事件。
3. 当前写回真相到底从哪条路径回灌，是否仍有唯一 chokepoint。
4. archive truth 保留下来的，是结构真相，还是一段更好看的归档说明。
5. `reopen reservation boundary` 还在不在，如果不在，我是在进入稳态，还是在删除未来推翻当前状态的能力。

## 9. 一句话总结

真正成熟的结构宿主修复稳态执行，不是宣布“系统现在够稳了”，而是持续证明 authority 仍连续、resume 已 seal、writeback 仍被托管、anti-zombie 已 dormancy、archive 仍说真话，且 reopen reservation 仍然合法存在。
