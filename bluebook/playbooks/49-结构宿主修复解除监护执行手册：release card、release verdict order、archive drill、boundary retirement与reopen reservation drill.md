# 结构宿主修复解除监护执行手册：release card、release verdict order、archive drill、boundary retirement与reopen reservation drill

这一章不再解释结构宿主修复解除监护协议该消费哪些字段，而是把 Claude Code 式结构出监压成一张可持续执行的解除监护手册。

它主要回答五个问题：

1. 为什么结构宿主修复解除监护真正执行的不是“看起来已经稳定”，而是 authority、resume、writeback、archive、boundary 与 reopen reservation 的正式 release 顺序。
2. 宿主、CI、评审与交接怎样共享同一张结构 release card，而不是各自围绕 pointer、监控与作者说明工作。
3. 应该按什么固定顺序执行 authority release、resume stability seal、writeback release、anti-zombie archive、boundary retirement 与 reopen reservation，才能不让 zombie 风险重新复辟。
4. 哪些 release reason 一旦出现就必须阻断 handoff、拒绝 release 并进入 archive / retirement / reopen reservation drill。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的稳定放行页”。

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

结构宿主修复解除监护真正要执行的不是：

- pointer 还在
- 监控又转绿了
- 作者说“应该没事了”

而是：

- authority、resume、writeback、anti-zombie 与 boundary 仍围绕同一个结构真相面正式宣布现在可以停止额外盯防，同时保留合法 reopen reservation

所以这层 playbook 最先要看的不是：

- release card 已经填完了

而是：

1. 当前 authority object 是否真的仍被 release。
2. 当前恢复顺序是否真的 seal，而不是只剩几次幸运成功。
3. 当前 writeback 是否仍经过唯一主路径，而不是 telemetry 与 sidecar 旁路。
4. 当前 anti-zombie 是否真的进入可审计 archive，而不是一句“我们已经处理过”。
5. 当前 boundary retirement 与 reopen reservation 是否仍围绕同一个 recovery boundary，而不是围绕旧路径与监控绿灯。

## 2. 共享 release card 最小字段

每次结构宿主修复解除监护，宿主、CI、评审与交接系统至少应共享：

1. `release_card_id`
2. `kernel_watch_id`
3. `authority_object_after`
4. `authority_release_seal`
5. `resume_stability_seal`
6. `writeback_path`
7. `writeback_release_seal`
8. `anti_zombie_archive`
9. `boundary_retirement`
10. `reopen_reservation`
11. `release_verdict`
12. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看 authority object 与 writeback 是否仍唯一。
2. CI 看 resume 顺序、generation 与 archive 证据是否完整。
3. 评审看 breadcrumb、recovery asset 与 live truth 是否仍被清楚分层。
4. 交接看 later 团队能否围绕同一 authority state 安全接手与 reopen。

## 3. 固定 release verdict 顺序

### 3.1 先验 `authority_release_seal`

先看：

1. 当前 query、task、session 或 remote worker 是否仍只有唯一 authority object。
2. breadcrumb、pointer 与 UI heuristic 是否仍没有充当真相面。
3. generation / status transition 是否仍能阻止 stale path 回写。

只要 authority 仍靠入口感维持，就不能 release。

### 3.2 再验 `resume_stability_seal`

再看：

1. restore、hydrate、adopt 与 clear stale 是否仍按正式顺序被 seal。
2. `late_resume_detected`、`generation_regression_detected` 与 stale adoption 是否仍被禁止。
3. terminal object 是否仍不会被 stale snapshot 或 late response 复活。

### 3.3 再验 `writeback_release_seal`

再看：

1. `writeback_path` 是否仍是唯一主 chokepoint。
2. `worker_status`、`external_metadata` 与 merge/delete 语义是否仍受控。
3. 是否仍不存在绕过主写点的 side write。

writeback 如果还靠 telemetry 转绿证明，就不能 release。

### 3.4 再验 `anti_zombie_archive`

再看：

1. `anti_zombie_projection` 是否有正式 archive。
2. stale writer、duplicate control response 与 orphan state 是否仍被显式清退。
3. 当前 archive 是否仍能阻止旧 generation 复活。

这里不是“归档一份复盘”，而是归档“过去不会再写回现在”的结构证据。

### 3.5 最后验 `boundary_retirement` 与 `reopen_reservation`

最后才看：

1. `recovery_boundary` 是否仍被正式退休。
2. `reopen_reservation` 是否仍明确指出未来失稳时回到哪个 authority object 与 boundary。
3. `release_verdict` 是否与前四步对象一致。

如果没有 reservation，retirement 就只是把 later 团队重新推回旧路径与作者记忆。

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前结构 release：

1. `authority_release_missing`
2. `resume_stability_unsealed`
3. `writeback_release_missing`
4. `side_write_risk_retained`
5. `zombie_archive_missing`
6. `boundary_not_retired`
7. `pointer_release_detected`
8. `reopen_required`

## 5. archive、boundary retirement 与 reopen reservation 顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先停止新的 reconnect、adopt 与 remote resume，不再让旧资产继续写回。
2. 先把 verdict 降级为 `handoff_blocked` 或 `reopen_required`。
3. 先把 pointer、sidecar 与 UI 投影降回 breadcrumb，不再让它们充当 authority。
4. 先回到上一个仍可验证的 authority object 与 writeback path，补完 archive。
5. 如果根因落在 release 制度本身，就回跳 `../guides/71` 做制度纠偏。

## 6. 最小 reopen reservation 演练集

每轮至少跑下面六个结构宿主解除监护执行演练：

1. `authority_release_recheck`
2. `resume_stability_replay`
3. `writeback_release_recheck`
4. `anti_zombie_archive_replay`
5. `boundary_retirement_replay`
6. `reopen_reservation_replay`

## 7. 复盘记录最少字段

每次结构宿主解除监护失败或 reopen，至少记录：

1. `release_card_id`
2. `kernel_watch_id`
3. `authority_release_seal`
4. `resume_stability_seal`
5. `writeback_release_seal`
6. `anti_zombie_archive`
7. `boundary_retirement`
8. `reopen_reservation`
9. `release_verdict`
10. `verdict_reason`

## 8. 苏格拉底式检查清单

在你准备宣布“结构宿主修复已经 released”前，先问自己：

1. 当前 authority object 到底是什么，later 维护者能否不靠口述识别出来。
2. 当前 release 依赖的是对象链，还是一组幸运发生的事件。
3. 当前写回真相到底从哪条路径回灌，是否仍有唯一 chokepoint。
4. anti-zombie 是证据对象，还是一句“我们已经处理过”。
5. 如果今天 reopen，later 团队能否只靠我的 release card 恢复同一判断。

## 9. 一句话总结

真正成熟的结构宿主修复解除监护执行，不是宣布“现在够稳了”，而是持续证明 authority 可以 release、resume 已 seal、writeback 可以 release、anti-zombie 已 archive、boundary 可以 retirement，且 reopen reservation 仍然合法存在。
