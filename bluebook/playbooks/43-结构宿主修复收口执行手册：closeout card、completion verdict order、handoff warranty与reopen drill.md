# 结构宿主修复收口执行手册：closeout card、completion verdict order、handoff warranty与reopen drill

这一章不再解释结构宿主修复收口协议该消费哪些字段，而是把 Claude Code 式结构收口压成一张可持续执行的收口手册。

它主要回答五个问题：

1. 为什么结构宿主修复收口真正执行的不是“看起来恢复正常了”，而是 authority、resume、writeback 与 anti-zombie 的正式 closeout 顺序。
2. 宿主、CI、评审与交接怎样共享同一张结构 closeout card，而不是各自围绕 pointer、重连成功率与日志工作。
3. 应该按什么固定顺序执行结构 closeout，才能不让 breadcrumb、旁路写回与 stale writer 在完成阶段重新篡位。
4. 哪些 verdict reason 一旦出现就必须阻断 handoff、拒绝 closeout 并进入 reopen drill。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的恢复完成页”。

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
- `claude-code-source-code/src/cli/print.ts:5048-5072`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:578-619`

## 1. 第一性原理

结构宿主修复收口真正要执行的不是：

- pointer 还在
- reconnect 又成功了
- PUT 次数看起来不错

而是：

- authority、resume、writeback 与 anti-zombie 仍在围绕同一个结构真相面宣布完成、交接与 reopen

所以这层 playbook 最先要看的不是：

- closeout card 已经填完了

而是：

1. 当前 authority object 是否真的被 seal。
2. 当前恢复顺序是否真的被关闭，而不是只剩一次成功的 reconnect。
3. 当前 writeback 是否仍经过唯一主路径，而不是 telemetry 与 sidecar 旁路。
4. 当前 anti-zombie 是否真的留下 witness，而不是一句“我们已经处理过”。
5. 当前 handoff 与 reopen 是否仍围绕同一个 recovery boundary，而不是围绕旧路径与监控绿灯。

## 2. 共享收口卡最小字段

每次结构宿主修复收口，宿主、CI、评审与交接系统至少应共享：

1. `closeout_card_id`
2. `authority_object_after`
3. `authority_state_surface`
4. `seal_generation`
5. `resume_closure_order`
6. `writeback_path`
7. `writeback_sealed`
8. `anti_zombie_witness`
9. `boundary_closure`
10. `handoff_warranty`
11. `closeout_verdict`
12. `reopen_trigger`

四类消费者的分工应固定为：

1. 宿主看 authority object 与 writeback 是否仍唯一。
2. CI 看 resume 顺序、generation 与 anti-zombie witness 是否完整。
3. 评审看 breadcrumb、recovery asset 与 live truth 是否仍被清楚分层。
4. 交接看 later 团队能否围绕同一 authority state 安全接手与 reopen。

## 3. 固定完成判定顺序

### 3.1 先验 authority seal

先看：

1. 当前 query、task、session 或 remote worker 是否仍只有唯一 authority object。
2. breadcrumb、pointer 与 UI heuristic 是否仍没有充当真相面。
3. generation / status transition 是否仍能阻止 stale path 回写。

### 3.2 再验 resume closure order

再看：

1. restore / hydrate / adopt / clear stale 是否仍按正式顺序关闭。
2. metadata、worktree、content replacement 与 session adoption 是否仍按顺序完成。
3. terminal object 是否仍不会被 stale snapshot 或 late response 复活。

### 3.3 再验 writeback seal

再看：

1. `writeback_path` 是否仍是唯一主 chokepoint。
2. `worker_status`、`external_metadata` 与 merge/delete 语义是否仍受控。
3. 是否仍不存在绕过主写点的旁路 closeout。

### 3.4 再验 anti-zombie witness

再看：

1. `anti_zombie_projection` 是否有正式证据。
2. stale writer、duplicate control response 与 orphan state 是否仍被显式清退。
3. 当前完成结果是否仍能阻止旧 generation 复活。

### 3.5 最后验 boundary closure、handoff warranty 与 reopen drill

最后才看：

1. `recovery_boundary` 是否已经正式 closed。
2. `handoff_warranty` 是否足以让 later 团队在不依赖作者说明的前提下接手。
3. reopen 是否仍回到同一个 authority object 与 recovery boundary，而不是回到旧 pointer 与重连通过感。

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前结构 closeout：

1. `authority_not_sealed`
2. `resume_order_not_closed`
3. `writeback_not_sealed`
4. `anti_zombie_not_witnessed`
5. `boundary_not_closed`
6. `reconnect_only_closeout`
7. `handoff_not_ready`
8. `reopen_required`

## 5. 交接与 reopen 顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先停止新的 resume、adopt 与 remote reconnect，不再让旧资产继续写回。
2. 先把 closeout verdict 降级为 `monitor_only` 或 `reopen_required`。
3. 先把 pointer、sidecar 与 UI 投影降回 breadcrumb，不再让它们充当 authority。
4. 先回到上一个仍可验证的 authority object 与 writeback path。
5. 如果根因落在恢复顺序、单一写点或 anti-zombie witness，就回跳 `../guides/65` 做制度纠偏。

## 6. 最小 reopen 演练集

每轮至少跑下面六个结构宿主收口执行演练：

1. `authority_seal_recheck`
2. `resume_order_recheck`
3. `writeback_primary_recheck`
4. `stale_writer_clearance_recheck`
5. `boundary_closure_reopen`
6. `handoff_ready_replay`

## 7. 复盘记录最少字段

每次结构宿主收口失败或 reopen，至少记录：

1. `closeout_card_id`
2. `authority_object_after`
3. `seal_generation`
4. `resume_closure_order`
5. `writeback_path`
6. `anti_zombie_witness`
7. `boundary_closure`
8. `closeout_verdict`
9. `handoff_warranty`
10. `reopen_trigger`

## 8. 苏格拉底式检查清单

在你准备宣布“结构宿主修复已经正式收口”前，先问自己：

1. 当前 authority object 到底是什么，later 维护者能否不靠口述识别出来。
2. 当前完成依赖的是对象链，还是一组幸运发生的事件。
3. 当前写回真相到底从哪条路径回灌，是否仍有唯一 chokepoint。
4. anti-zombie 是证据对象，还是一句‘我们已经处理过’。
5. 如果今天 reopen，later 团队能否只靠我的收口卡恢复同一判断。

## 9. 一句话总结

真正成熟的结构宿主修复收口执行，不是让恢复看起来更顺，而是持续证明 authority、resume、writeback 与 anti-zombie 仍在共同宣布同一个结构真相面已经完成、可交接并可重开。
