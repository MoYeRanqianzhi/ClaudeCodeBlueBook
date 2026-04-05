# 结构宿主修复协议：authority recovery、resume replay order、writeback restoration、anti-zombie verdict与boundary reset

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象让宿主、SDK、CI、评审与交接系统消费结构执行纠偏。
2. 哪些字段属于必须消费的结构 repair object，哪些属于 reject escalation 语义，哪些仍然不应被绑定成公共 ABI。
3. 为什么结构修复协议不应退回 pointer 修补、重连碰碰运气与日志繁荣。
4. 宿主开发者该按什么顺序消费这套结构修复规则面。
5. 哪些现象一旦出现应被直接升级为 hard reject 或 rollback required，而不是继续灰度。

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
- `claude-code-source-code/src/cli/print.ts:5048-5067`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:578-619`

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `StructureRepairContract`

的单独公共对象。

但结构宿主修复实际上已经能围绕五类正式对象稳定成立：

1. `authority_recovery`
2. `resume_replay_order`
3. `writeback_restoration`
4. `anti_zombie_verdict`
5. `boundary_reset`

更成熟的修复方式不是：

- 只看 pointer 还在
- 只做一次 reconnect
- 只看日志变多了

而是：

- 围绕这五类对象消费结构真相面怎样恢复成同一个 authority object

## 2. authority recovery：最小修复对象

宿主应至少围绕下面对象消费结构修复真相：

1. `repair_object_id`
2. `authority_object_before`
3. `authority_object_after`
4. `authority_state`
5. `generation`
6. `writer_chokepoint`

这些字段回答的不是：

- 现在恢复入口还在不在

而是：

- 当前到底把哪个 authority 漂移修回了哪个正式结构边界

## 3. resume replay order 与 writeback restoration

结构宿主还必须显式消费：

### 3.1 resume replay order

1. `switch_reset_done`
2. `restore_metadata_done`
3. `restore_worktree_done`
4. `adopt_resumed_session_done`
5. `clear_stale_done`

### 3.2 writeback restoration

1. `writeback_path`
2. `worker_status`
3. `external_metadata`
4. `merge_semantics`
5. `last_writer`

这说明宿主当前消费的不是：

- 一次重连动作
- 一串日志记录

而是：

- `resume_replay_order + writeback_restoration` 共同组成的结构修复对象

## 4. anti-zombie verdict 与 boundary reset

结构修复还必须消费：

### 4.1 anti-zombie verdict

1. `anti_zombie_projection`
2. `stale_writer_evidence`
3. `duplicate_or_orphan_control_state`
4. `transition_legality_snapshot`
5. `degraded_path`

### 4.2 boundary reset

1. `rollback_object`
2. `recovery_boundary`
3. `breadcrumb_demoted`
4. `re_entry_condition`

这两组对象回答的不是：

- 现在是不是又能连上了
- 监控是不是恢复正常了

而是：

- stale path 是否已被正式清退
- 当前回退是否仍围绕同一个结构真相面发生

## 5. reject escalation：必须共享的升级语义

更成熟的结构宿主修复 escalation 至少应共享下面枚举：

1. `breadcrumb_as_authority`
2. `resume_order_implicit`
3. `writeback_not_authoritative`
4. `anti_zombie_not_evidenced`
5. `reconnect_as_rollback`
6. `stale_writer_unblocked`
7. `boundary_reset_missing`
8. `telemetry_only_health`

这些 escalation reason 的价值在于：

- 把“看起来已经修好了”的结构幻觉压成宿主、CI、评审与交接都能共享的升级语义

## 6. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. pointer mtime
2. sidecar 文件存在性
3. 恢复成功率
4. spinner / loading UI
5. PUT 次数
6. 重连按钮状态
7. 目录美学描述
8. 作者口头说明

它们可以是修复线索，但不能是修复对象。

## 7. 修复顺序建议

更稳的顺序是：

1. 先验 `authority_recovery`
2. 再验 `resume_replay_order`
3. 再验 `writeback_restoration`
4. 再验 `anti_zombie_verdict`
5. 最后验 `boundary_reset`

不要反过来做：

1. 不要先看 pointer。
2. 不要先看日志繁荣。
3. 不要先看 reconnect 是否暂时可用。

## 8. 一句话总结

Claude Code 的结构宿主修复协议，不是 pointer / reconnect 修补 API，而是 `authority recovery + resume replay order + writeback restoration + anti-zombie verdict + boundary reset` 共同组成的规则面。
