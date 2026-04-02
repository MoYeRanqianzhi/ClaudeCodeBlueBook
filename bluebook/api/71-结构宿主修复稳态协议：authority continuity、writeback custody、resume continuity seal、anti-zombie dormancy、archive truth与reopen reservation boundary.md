# 结构宿主修复稳态协议：authority continuity、writeback custody、resume continuity seal、anti-zombie dormancy、archive truth与reopen reservation boundary

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象让宿主、SDK、CI、评审与交接系统在结构 release correction 之后消费无人盯防延续、写回托管与 reopen reservation boundary。
2. 哪些字段属于必须消费的结构 steady-state object，哪些属于 verdict 语义，哪些仍然不应被绑定成公共 ABI。
3. 为什么结构稳态协议不应退回 pointer 健康感、telemetry 转绿与作者说明。
4. 宿主开发者该按什么顺序消费这套结构 steady-state 规则面。
5. 哪些现象一旦出现应被直接升级为 steady-state blocked、authority split detected 或 reopen reservation triggered，而不是继续宣布系统还在正常响应。

## 0. 关键源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/handlePromptSubmit.ts:430-517`
- `claude-code-source-code/src/utils/task/framework.ts:77-248`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:533-570`
- `claude-code-source-code/src/state/onChangeAppState.ts:50-92`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/cli/structuredIO.ts:362-657`
- `claude-code-source-code/src/cli/print.ts:5048-5067`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:578-619`

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `StructureRepairSteadyStateContract`

的单独公共对象。

但结构宿主修复稳态实际上已经能围绕六类正式对象稳定成立：

1. `authority_continuity`
2. `resume_continuity_seal`
3. `writeback_custody`
4. `anti_zombie_dormancy`
5. `archive_truth`
6. `reopen_reservation_boundary`

更成熟的结构稳态方式不是：

- 只看 pointer 还在
- 只看 telemetry 重新转绿
- 只看作者说“现在应该没问题了”

而是：

- 围绕这六类对象消费结构真相面怎样在停止额外盯防之后，仍继续维持单一 authority、唯一写回主路径、可恢复 lineage 与 anti-zombie 能力

## 2. authority continuity：最小稳态对象

宿主应至少围绕下面对象消费结构稳态真相：

1. `authority_object_id`
2. `authority_state_surface`
3. `writer_chokepoint`
4. `worktree_scope`
5. `continuity_attested`
6. `steady_state_evaluated_at`

这些字段回答的不是：

- 当前哪个 pointer 看起来还最新

而是：

- 当前到底围绕哪个 authority object、以哪个结构边界进入了无人盯防稳态

## 3. resume continuity seal 与 writeback custody

结构宿主还必须显式消费：

### 3.1 resume continuity seal

1. `session_id_lineage`
2. `worktree_resume_path`
3. `bridge_pointer_scope`
4. `resume_order_verified`
5. `late_resume_blocked`

### 3.2 writeback custody

1. `writeback_path`
2. `worker_status`
3. `external_metadata`
4. `coalesced_patch_generation`
5. `side_write_detected`
6. `custody_attested`

这说明宿主当前消费的不是：

- 一次 reconnect 成功
- 一串更漂亮的 telemetry

而是：

- `resume continuity seal + writeback custody` 共同组成的结构稳态证明

## 4. anti-zombie dormancy、archive truth 与 reopen reservation boundary

结构稳态还必须消费：

### 4.1 anti-zombie dormancy

1. `anti_zombie_projection`
2. `orphan_session_resolved`
3. `stale_writer_blocked`
4. `dormancy_started_at`
5. `reactivation_trigger_registered`

### 4.2 archive truth

1. `archive_pointer`
2. `boundary_retirement_generation`
3. `retired_surface_hash`
4. `author_memory_not_required`
5. `archive_truth_attested`

### 4.3 reopen reservation boundary

1. `recovery_boundary`
2. `reopen_reservation`
3. `reservation_owner`
4. `threshold_retained_until`
5. `reopen_required`

这三组对象回答的不是：

- 现在是不是还能继续连上
- 之后如果有问题大家是不是再试一次

而是：

- zombie 风险是否已正式进入 dormant but recallable 的结构状态
- archive 是否仍保留结构真相，而不是只剩目录美学
- steady state 一旦失效，系统是否仍保留正式 reopen reservation boundary

## 5. steady-state verdict：必须共享的稳态语义

更成熟的结构宿主稳态 verdict 至少应共享下面枚举：

1. `steady_state`
2. `steady_state_blocked`
3. `authority_split_detected`
4. `resume_lineage_missing`
5. `side_write_risk_retained`
6. `archive_truth_missing`
7. `reopen_reservation_triggered`

这些 verdict reason 的价值在于：

- 把“released 之后结构仍继续说真话”翻译成宿主、CI、评审与交接都能共享的结构 post-watch 语义

## 6. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. pointer mtime
2. reconnect 按钮状态
3. telemetry 绿灯
4. PUT 次数
5. 目录美学描述
6. 单次截图
7. archive prose 摘要
8. 作者口头说明

它们可以是稳态线索，但不能是稳态对象。

## 7. 稳态消费顺序建议

更稳的顺序是：

1. 先验 `authority_continuity`
2. 再验 `resume_continuity_seal`
3. 再验 `writeback_custody`
4. 再验 `anti_zombie_dormancy`
5. 再验 `archive_truth`
6. 最后验 `reopen_reservation_boundary`

不要反过来做：

1. 不要先看 pointer。
2. 不要先看监控转绿。
3. 不要先看作者是否主观放心。

## 8. 苏格拉底式检查清单

在你准备宣布“结构已进入稳态”前，先问自己：

1. 我现在保护的是 authority continuity，还是某个还没失效的入口。
2. `resume continuity seal` 保住的是恢复 lineage，还是一次刚好成功的 reconnect。
3. `writeback custody` 托管的是唯一写回主路径，还是最近没有再写坏文件。
4. archive truth 保留下来的，是结构真相，还是一段更好看的归档说明。
5. `reopen reservation boundary` 还在不在，如果不在，我是在进入稳态，还是在删除未来推翻当前状态的能力。

## 9. 一句话总结

Claude Code 的结构宿主修复稳态协议，不是 release 之后的归档说明 API，而是 `authority continuity + resume continuity seal + writeback custody + anti-zombie dormancy + archive truth + reopen reservation boundary` 共同组成的规则面。
