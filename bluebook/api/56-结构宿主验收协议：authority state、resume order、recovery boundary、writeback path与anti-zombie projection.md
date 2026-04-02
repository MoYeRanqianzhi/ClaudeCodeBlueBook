# 结构宿主验收协议：authority state、resume order、recovery boundary、writeback path与anti-zombie projection

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式对象让宿主、SDK、CI 与交接系统验收结构真相面。
2. 哪些字段属于必须消费的结构对象，哪些属于 reject 语义，哪些仍然不应被绑定成公共 ABI。
3. 为什么结构验收不应退回 pointer、成功率与恢复口述。
4. 宿主开发者该按什么顺序验收这套结构规则面。
5. 哪些现象一旦出现应被直接拒收，而不是继续灰度。

## 0. 关键源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/task/framework.ts:77-248`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:533-570`
- `claude-code-source-code/src/state/onChangeAppState.ts:50-92`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:450-529`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:824-880`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/tasks/RemoteAgentTask/RemoteAgentTask.tsx:484-506`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/cli/print.ts:5048-5067`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1735-1747`

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `StructureAcceptanceContract`

的单独公共对象。

但结构宿主验收实际上已经能围绕五类正式对象稳定成立：

1. `authority_state`
2. `resume_order`
3. `recovery_boundary`
4. `writeback_path`
5. `anti_zombie_projection`

更成熟的验收方式不是：

- 只看 pointer 文件
- 只看恢复成功率
- 只看 UI 已经正常

而是：

- 围绕这五类对象消费结构真相面是否仍然成立

## 2. authority state：最小验收对象

宿主应至少围绕下面对象验收结构真相：

1. `session_state_changed`
2. `pending_action`
3. `permission_mode`
4. `task_summary`
5. `worker_status`

这些字段回答的不是：

- 现在界面看起来是不是恢复了

而是：

- 当前唯一可信的结构状态面是什么

## 3. resume order：不能只看“恢复成功”

结构验收必须显式消费：

1. `switch_session`
2. `reset_session_file_pointer`
3. `restore_session_metadata`
4. `restore_worktree`
5. `adopt_resumed_session_file`
6. `restore_collapse_and_remote_tasks`

原因不是：

- 恢复步骤写得更细

而是：

- 结构真相面最危险的失败方式正是“恢复看起来成功，但顺序其实错了”

## 4. recovery boundary 与 writeback path

结构宿主还必须显式消费：

### 4.1 recovery boundary

1. `bridge_pointer_health`
2. `recovery_asset_inventory`
3. `adopt_or_fail_reason`
4. `remote_recovery_window`

### 4.2 writeback path

1. `writeback_delivery_state`
2. `external_metadata`
3. `worker_status`
4. `pending_patch_state`

这说明宿主当前消费的不是：

- 一组恢复入口
- 一条“请求成功”日志

而是：

- `recovery boundary + writeback path` 共同组成的结构主路径

## 5. anti-zombie projection：不能退回成功率

结构验收还必须消费：

1. `anti_zombie_projection`
2. `stale_writer_evidence`
3. `transition_legality_snapshot`
4. `degraded_path`
5. `rejected_outcome`

原因不是：

- debug 指标更多

而是：

- 结构先进性真正保护的是 stale writer、zombie outcome 与 split-brain 不会被误消费成成功

## 6. reject reason：必须共享的拒收语义

更成熟的结构宿主 reject reason 至少应共享下面枚举：

1. `heuristic_state_authority`
2. `resume_order_missing`
3. `pointer_as_truth`
4. `recovery_boundary_missing`
5. `writeback_not_authoritative`
6. `anti_zombie_projection_missing`
7. `success_rate_as_truth`
8. `sidecar_identity_as_live_state`

这些 reject reason 的价值在于：

- 把“看起来恢复好了”的错觉压成宿主、CI、评审与交接都能共享的拒收语义

## 7. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. pointer 文件路径本身
2. mtime / fanout 细节
3. `_generation` 内部字段
4. stale patch 内部数组
5. sidecar 存储实现
6. 请求成功率
7. 恢复按钮状态

它们可以是调试材料，但不能是验收对象。

## 8. 验收顺序建议

更稳的顺序是：

1. 先验 `authority_state`
2. 再验 `resume_order`
3. 再验 `recovery_boundary`
4. 再验 `writeback_path`
5. 最后验 `anti_zombie_projection`

不要反过来做：

1. 不要先看 pointer。
2. 不要先看成功率。
3. 不要先看 UI 是否恢复。

## 9. 一句话总结

Claude Code 的结构宿主验收协议，不是 pointer 与恢复按钮 API，而是 `authority state + resume order + recovery boundary + writeback path + anti-zombie projection` 共同组成的规则面。
