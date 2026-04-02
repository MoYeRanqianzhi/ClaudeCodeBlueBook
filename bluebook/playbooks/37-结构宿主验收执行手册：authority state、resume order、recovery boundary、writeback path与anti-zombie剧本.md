# 结构宿主验收执行手册：authority state、resume order、recovery boundary、writeback path与anti-zombie剧本

这一章不再解释结构宿主验收协议该消费哪些字段，而是把 Claude Code 式结构验收压成一张可持续执行的验收手册。

它主要回答五个问题：

1. 为什么结构宿主验收真正执行的不是“目录好不好看”或“恢复成不成功”，而是 authority state、resume order、writeback path 与 anti-zombie 结果面。
2. 宿主、CI、评审与交接怎样共享同一张结构验收卡，而不是各自围绕 pointer、spinner 与成功率工作。
3. 应该按什么固定顺序执行结构宿主验收，才能不让 breadcrumb、sidecar 或 stale writer 篡位。
4. 哪些 reject reason 一旦出现就必须停止恢复、拒绝交接并进入回退。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“更细的恢复流程图”。

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

结构宿主验收真正要执行的不是：

- UI 里有 loading
- pointer 文件还在
- 恢复成功率看起来不错

而是：

- 当前 authority object、resume order、recovery boundary、writeback path 与 anti-zombie projection 仍在围绕同一个结构真相面成立

所以这层 playbook 最先要看的不是：

- 恢复似乎成功了

而是：

1. 当前 authority object 是否唯一。
2. 当前恢复是否按正式顺序重新采纳对象。
3. 当前 breadcrumb 是否仍只是 breadcrumb，而没有篡位成 live truth。
4. 当前 writeback 是否仍是正式真相回灌路径。
5. 当前 anti-zombie 结果面是否仍能防 stale writer、late finally 与复活的 terminal object。

## 2. 共享验收卡最小字段

每次结构宿主验收，宿主、CI、评审与交接系统至少应共享：

1. `authority_object`
2. `authority_state`
3. `generation`
4. `resume_order`
5. `recovery_boundary`
6. `writeback_path`
7. `recovery_assets`
8. `breadcrumb_assets`
9. `anti_zombie_projection`
10. `control_protocol_health`
11. `reject_reason`
12. `consumer_verdict`

四类消费者的分工应固定为：

1. 宿主看 authority object 与 writeback 是否仍唯一。
2. CI 看 resume/adopt 顺序、generation 与 protocol health 是否完整。
3. 评审看 breadcrumb、recovery asset 与 live truth 是否被清楚分层。
4. 交接看 later 接手者能否围绕同一 authority state 继续恢复与判断。

## 3. 固定执行顺序

### 3.1 先验 authority object

先看：

1. 当前 query、task、session 或 remote worker 是否仍有唯一 authority object
2. UI heuristic 是否仍没有充当真相面
3. generation / status transition 是否仍能阻止 stale path 回写

### 3.2 再验 resume order

再看：

1. restore / hydrate / adopt 是否仍有显式顺序
2. metadata、worktree、content replacement 与 context collapse 是否仍按正式顺序恢复
3. terminal object 是否仍不会被 stale snapshot 复活

### 3.3 再验 recovery boundary

再看：

1. 当前恢复边界是否仍指向正式对象，而不是一串消息或一个 pointer
2. breadcrumb asset 与 recovery asset 是否仍被清楚区分
3. 交接系统是否仍知道 later 应该从哪里重新进入

### 3.4 再验 writeback path

再看：

1. `WorkerStateUploader` 是否仍是正式写回路径
2. worker status、external metadata 与 merge/delete 语义是否仍受控
3. 是否仍不存在绕过主写点的旁路写回

### 3.5 最后验 anti-zombie projection

最后才看：

1. stale finally、late response、重复恢复与旧 pointer 是否仍不能复活旧对象
2. duplicate/orphan control response 是否仍被显式处理
3. 当前恢复结果是否仍可被 later 消费，而不是只剩“刚才看起来成功”

## 4. 直接拒收条件

出现下面情况时，应直接拒收当前结构宿主实现：

1. `ui_heuristic_authority`
2. `resume_order_missing`
3. `pointer_usurps_truth`
4. `writeback_telemetry_only`
5. `anti_zombie_missing`
6. `stale_writer_unblocked`
7. `duplicate_orphan_silent`
8. `recovery_boundary_unknown`

## 5. 拒收升级与回退顺序

看到 reject reason 之后，更稳的处理顺序是：

1. 先停止新的 resume、adopt 与 remote reconnect，不再让旧资产继续写回。
2. 先把 pointer、sidecar 与 UI 投影降回 breadcrumb，不再让它们充当 authority。
3. 先回到上一个仍可验证的 authority object 与 writeback path。
4. 先重新跑 hydrate / restore / adopt 顺序，再重建 anti-zombie projection。
5. 如果根因落在恢复顺序、单一写点或结构边界，就回跳 `../guides/59` 做制度纠偏。

## 6. 回退演练集

每轮至少跑下面六个结构宿主验收演练：

1. `stale finally`
2. `terminal task revive`
3. `pointer stale but session alive`
4. `worker reconnect hydrate`
5. `duplicate_orphan_control_response`
6. `sidecar_only_recovery`

## 7. 复盘记录最少字段

每次结构宿主验收失败或回退，至少记录：

1. `authority_object`
2. `authority_state`
3. `generation`
4. `resume_order_gap`
5. `recovery_boundary_gap`
6. `writeback_path_gap`
7. `anti_zombie_gap`
8. `reject_reason`
9. `rollback_action`
10. `re_entry_condition`

## 8. 苏格拉底式检查清单

在你准备宣布“结构宿主验收已经稳定运行”前，先问自己：

1. 当前 authority object 到底是什么。
2. 哪些字段是 last-wins，哪些对象必须按 append-order 解释。
3. 当前恢复依赖的是对象集，还是一串消息流。
4. 当前 pointer 告诉我的是“现在是什么”，还是“上次在哪里”。
5. 当前真相是从哪条 writeback path 回灌的。
6. 如果丢掉一部分中间事件，最终 authority state 是否仍正确。
7. 是否存在任何旁路写回会绕过主 choke point。
8. 如果今天崩溃重连，later 团队能否只靠验收卡恢复同一判断。

## 9. 一句话总结

真正成熟的结构宿主验收执行，不是让恢复路径看起来更顺，而是持续证明 authority object、resume order、recovery boundary、writeback path 与 anti-zombie projection 仍然是同一个结构真相面。
