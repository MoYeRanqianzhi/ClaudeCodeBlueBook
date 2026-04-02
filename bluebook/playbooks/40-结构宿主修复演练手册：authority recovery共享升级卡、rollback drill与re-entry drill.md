# 结构宿主修复演练手册：authority recovery共享升级卡、rollback drill与re-entry drill

这一章不再解释结构宿主修复协议该消费哪些字段，而是把 Claude Code 式结构修复压成一张可长期重放、拒收、回滚与重入验证的演练手册。

它主要回答五个问题：

1. 为什么源码先进性不在模块命名与目录美学，而在 authority object、writeback 与 anti-zombie 是否能在故障后继续守住单一结构真相。
2. 宿主、CI、评审与交接怎样共享同一张结构修复升级卡，而不是各自围绕 pointer、日志、恢复成功率与作者说明工作。
3. 应该按什么固定顺序执行 authority recovery、resume replay order、writeback restoration、anti-zombie verdict 与 rollback/re-entry drill。
4. 哪些停止条件一旦出现就必须冻结当前结构修复，不允许 stale writer、旧 pointer 与旁路写回继续污染真相。
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

结构宿主修复演练真正要证明的不是：

- pointer 似乎又对了
- reconnect 似乎又成功了

而是：

- authority object、writeback 主路径与 anti-zombie 结果面仍在保护同一个结构真相

所以这层 playbook 最先要看的不是：

- 恢复过程看起来很顺

而是：

1. 当前 authority object 是否仍唯一，且 later 维护者也能识别。
2. 当前 resume 是否仍按正式顺序重放，而不是靠幸运重连拼出正确状态。
3. 当前 writeback 是否仍经过唯一主路径，而不是 telemetry、pointer 或 sidecar 旁路回灌。
4. 当前 anti-zombie verdict 是否仍能阻止 stale writer、late finally 与旧 generation 复活。
5. rollback 与 re-entry 是否仍恢复结构边界，而不是只恢复一种“看起来在线”的幻觉。

## 2. 共享升级卡与重入工件

每次结构宿主修复演练，至少应共享三类正式工件：

1. `shared_repair_upgrade_card`
2. `rollback_object`
3. `re_entry_ticket`

其中 `shared_repair_upgrade_card` 应固定包含：

1. `authority_object_id`
2. `authority_state_surface`
3. `generation`
4. `resume_order`
5. `recovery_boundary`
6. `breadcrumb_assets`
7. `writeback_path`
8. `worker_status`
9. `external_metadata`
10. `anti_zombie_projection`
11. `reject_reason`
12. `rollback_object`
13. `re_entry_condition`

四类消费者的分工应固定为：

1. 宿主看 authority object 与 writeback 是否仍唯一。
2. CI 看 `resume_order`、generation 与 anti-zombie 证据是否完整。
3. 评审看 breadcrumb、recovery asset 与 live truth 是否被清楚分层。
4. 交接看 later 团队能否围绕同一 authority state 继续恢复、回滚与重入。

## 3. 固定演练顺序

### 3.1 先验 authority recovery

先看：

1. 当前 authority object 是否从漂移状态回到正式对象。
2. `authority_state_surface` 是否仍能明确指出 live truth 在哪里。
3. 是否仍不存在 pointer、spinner 与日志繁荣篡位成真相面的情况。

### 3.2 再验 resume replay order

再看：

1. `resume_order` 是否仍显式包含 restore、hydrate、adopt 与 clear stale。
2. metadata、worktree、content replacement 与 session adoption 是否按正式顺序重放。
3. terminal object 是否仍不会被旧 snapshot、晚到 response 或 stale finally 复活。

### 3.3 再验 writeback restoration

再看：

1. `writeback_path` 是否仍经过唯一主 chokepoint。
2. `worker_status`、`external_metadata` 与 merge/delete 语义是否仍受控。
3. 是否仍不存在绕过正式写回路径的旁路恢复。

### 3.4 再验 anti-zombie verdict

再看：

1. `anti_zombie_projection` 是否有证据，而不是口头宣称。
2. stale writer、duplicate control response 与 orphan state 是否仍被显式拦截。
3. 当前恢复结果是否仍能阻止旧 generation 重新写回。

### 3.5 最后跑 rollback 与 re-entry drill

最后才看：

1. rollback 是否仍恢复到同一个 `recovery_boundary`。
2. `breadcrumb_assets` 是否真的被降回 breadcrumb，而不是继续担任 authority。
3. `re_entry_condition` 是否足以回答“可否继续、从哪继续、谁有权继续”。

## 4. 直接停止条件

出现下面情况时，应直接停止当前结构修复演练并拒收：

1. `breadcrumb_as_authority`
2. `resume_order_implicit`
3. `writeback_not_authoritative`
4. `anti_zombie_not_evidenced`
5. `reconnect_as_rollback`
6. `stale_writer_unblocked`
7. `boundary_reset_missing`
8. `telemetry_only_health`

## 5. 最小演练集

每轮至少跑下面六个结构宿主修复演练：

1. `authority_recovery_rebind`
2. `resume_order_replay`
3. `worker_writeback_restore`
4. `stale_finally_block`
5. `duplicate_orphan_control_response`
6. `rollback_reentry_after_recovery`

## 6. 复盘记录最少字段

每次结构宿主修复演练失败或回退，至少记录：

1. `authority_object_before`
2. `authority_object_after`
3. `generation_before`
4. `generation_after`
5. `resume_gap`
6. `writeback_gap`
7. `anti_zombie_gap`
8. `rollback_trigger`
9. `rollback_object`
10. `re_entry_condition`

## 7. 苏格拉底式检查清单

在你准备宣布“结构宿主修复演练已经稳定运行”前，先问自己：

1. 当前 authority object 到底是什么，later 维护者能否不靠口述识别出来。
2. 当前恢复依赖的是对象链，还是一组幸运发生的事件。
3. pointer 告诉我的还是 breadcrumb，还是它已经偷偷篡位成 authority。
4. 当前写回真相到底从哪条路径回灌，是否仍有唯一 chokepoint。
5. anti-zombie 是证据对象，还是一句“我们已经处理过”的说明。
6. rollback 回到的是结构边界，还是某个恰好还活着的进程状态。
7. 我修回的是 authority，还是只修回入口感。
8. 如果今天再次崩溃，later 团队能否只看这三张卡就重建同一判断。

## 8. 一句话总结

真正成熟的结构宿主修复演练，不是让恢复路径看起来更顺，而是持续证明 authority、resume、writeback 与 anti-zombie 仍在共同守住同一个结构真相面。
