# 结构宿主修复监护执行手册：watch card、drift verdict order、handoff freeze与reopen drill

这一章不再解释结构宿主修复监护协议该消费哪些字段，而是把 Claude Code 式结构监护压成一张可持续执行的监护手册。

它主要回答五个问题：

1. 为什么结构宿主修复监护真正执行的不是‘看起来还正常’，而是 authority、resume、writeback、anti-zombie 与 boundary 的正式 watch 顺序。
2. 宿主、CI、评审与交接怎样共享同一张结构 watch card，而不是各自围绕 pointer、监控成功率与作者说明工作。
3. 应该按什么固定顺序执行结构监护，才能不让 breadcrumb、旁路写回与 stale writer 在 post-closeout 阶段重新篡位。
4. 哪些 drift reason 一旦出现就必须阻断 handoff、拒绝继续 watch 并进入 reopen drill。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的恢复观察页”。

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

结构宿主修复监护真正要执行的不是：

- pointer 还在
- 监控又转绿了
- 作者说‘应该没事了’

而是：

- authority、resume、writeback、anti-zombie 与 boundary 仍在围绕同一个结构真相面观察 drift、冻结 handoff 与决定 reopen

所以这层 playbook 最先要看的不是：

- watch card 已经填完了

而是：

1. 当前 authority object 是否真的仍被 watch。
2. 当前恢复顺序是否真的仍被 watch，而不是只剩一次成功的 reconnect。
3. 当前 writeback 是否仍经过唯一主路径，而不是 telemetry 与 sidecar 旁路。
4. 当前 anti-zombie 是否真的仍留下 watch 证据，而不是一句‘我们已经处理过’。
5. 当前 handoff 与 reopen 是否仍围绕同一个 recovery boundary，而不是围绕旧路径与监控绿灯。

## 2. 共享监护卡最小字段

每次结构宿主修复监护，宿主、CI、评审与交接系统至少应共享：

1. `watch_card_id`
2. `kernel_watch_id`
3. `authority_watch`
4. `resume_regression_watch`
5. `writeback_watch`
6. `anti_zombie_watch`
7. `boundary_quarantine`
8. `watch_verdict`
9. `drift_reason`
10. `handoff_status`
11. `watch_deadline`
12. `reopen_trigger`

四类消费者的分工应固定为：

1. 宿主看 authority object 与 writeback 是否仍唯一。
2. CI 看 resume 顺序、generation 与 anti-zombie watch 是否完整。
3. 评审看 breadcrumb、recovery asset 与 live truth 是否仍被清楚分层。
4. 交接看 later 团队能否围绕同一 authority state 安全接手与 reopen。

## 3. 固定漂移判定顺序

### 3.1 先验 authority watch

先看：

1. 当前 query、task、session 或 remote worker 是否仍只有唯一 authority object。
2. breadcrumb、pointer 与 UI heuristic 是否仍没有充当真相面。
3. generation / status transition 是否仍能阻止 stale path 回写。

### 3.2 再验 resume regression watch

再看：

1. restore / hydrate / adopt / clear stale 是否仍按正式顺序被观察。
2. metadata、worktree、content replacement 与 session adoption 是否仍没有 regress。
3. terminal object 是否仍不会被 stale snapshot 或 late response 复活。

### 3.3 再验 writeback watch

再看：

1. `writeback_path` 是否仍是唯一主 chokepoint。
2. `worker_status`、`external_metadata` 与 merge/delete 语义是否仍受控。
3. 是否仍不存在绕过主写点的 side write。

### 3.4 再验 anti-zombie watch

再看：

1. `anti_zombie_projection` 是否有正式证据。
2. stale writer、duplicate control response 与 orphan state 是否仍被显式清退。
3. 当前 watch 是否仍能阻止旧 generation 复活。

### 3.5 最后验 boundary quarantine 与 watch verdict

最后才看：

1. `recovery_boundary` 是否仍被正式隔离。
2. `watch_verdict` 是否与前四步对象一致。
3. reopen 是否仍回到同一个 authority object 与 recovery boundary，而不是回到旧 pointer 与重连通过感。

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前结构 watch：

1. `authority_drift_detected`
2. `resume_regression_detected`
3. `writeback_drift_detected`
4. `anti_zombie_regression_detected`
5. `boundary_drift_detected`
6. `handoff_blocked`
7. `reopen_required`
8. `watch_window_expired`

## 5. handoff freeze 与 reopen 顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先停止新的 reconnect、adopt 与 remote resume，不再让旧资产继续写回。
2. 先把 watch verdict 降级为 `handoff_blocked` 或 `reopen_required`。
3. 先把 pointer、sidecar 与 UI 投影降回 breadcrumb，不再让它们充当 authority。
4. 先回到上一个仍可验证的 authority object 与 writeback path。
5. 如果根因落在监护制度本身，就回跳 `../guides/68` 做制度纠偏。

## 6. 最小 reopen 演练集

每轮至少跑下面六个结构宿主监护执行演练：

1. `authority_watch_recheck`
2. `resume_regression_replay`
3. `side_write_injection`
4. `stale_writer_replay`
5. `boundary_quarantine_reopen`
6. `handoff_watch_replay`

## 7. 复盘记录最少字段

每次结构宿主监护失败或 reopen，至少记录：

1. `watch_card_id`
2. `kernel_watch_id`
3. `authority_watch`
4. `resume_regression_watch`
5. `writeback_watch`
6. `anti_zombie_watch`
7. `boundary_quarantine`
8. `watch_verdict`
9. `drift_reason`
10. `reopen_trigger`

## 8. 苏格拉底式检查清单

在你准备宣布“结构宿主修复已经 stable under watch”前，先问自己：

1. 当前 authority object 到底是什么，later 维护者能否不靠口述识别出来。
2. 当前监护依赖的是对象链，还是一组幸运发生的事件。
3. 当前写回真相到底从哪条路径回灌，是否仍有唯一 chokepoint。
4. anti-zombie 是证据对象，还是一句‘我们已经处理过’。
5. 如果今天 reopen，later 团队能否只靠我的 watch card 恢复同一判断。

## 9. 一句话总结

真正成熟的结构宿主修复监护执行，不是让团队‘再观察一下’，而是持续证明 authority、resume、writeback、anti-zombie 与 boundary 仍在共同监护同一个结构真相面。
