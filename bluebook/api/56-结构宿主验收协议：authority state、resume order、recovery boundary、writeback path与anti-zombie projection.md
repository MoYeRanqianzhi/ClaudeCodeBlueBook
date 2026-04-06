# 结构宿主验收协议：authority object、per-host authority width、writeback path 与 anti-zombie evidence

Claude Code 当前没有公开一份单独名为 `StructureAcceptanceContract` 的对象，但结构宿主验收已经可以围绕一条更稳的 contract chain 稳定成立：

1. `authority object`
2. `per-host authority width`
3. `authoritative path`
4. `event-stream-vs-state-writeback`
5. `freshness gate`
6. `anti-zombie evidence`
7. `reopen boundary`

`authority state`、`resume order`、`recovery boundary` 与 `anti-zombie projection` 在这里都应降为对象链上的投影、re-entry proof 或证据面。

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

## 1. 必须消费的 contract 对象

### 1.1 `authority object`

宿主应至少围绕下面对象验收结构真相：

1. `session_state_changed`
2. `pending_action`
3. `permission_mode`
4. `task_summary`
5. `worker_status`

这些字段回答的不是：

- 现在界面看起来是不是恢复了

而是：

- 当前唯一可信的结构真相面是什么

### 1.2 `per-host authority width`

结构验收还必须显式消费：

1. `host_width_ref`
2. `consumer_scope`
3. `visible_authority_subset`
4. `forbidden_substitute_writer`

原因不是字段更细，而是：

- 不同 host / consumer 只能消费自己的合法 width，不能各自重建 current truth

### 1.3 `writeback path` 与 `event-stream-vs-state-writeback`

结构宿主还必须显式消费：

1. `writeback_primary_path`
2. `writeback_delivery_state`
3. `external_metadata`
4. `worker_status`
5. `pending_patch_state`
6. `event_stream_writeback_split`

这说明宿主当前消费的不是：

- 一条“请求成功”日志

而是：

- `authoritative path + state writeback` 共同组成的结构主路径

### 1.4 `freshness gate`

结构验收还必须显式消费：

1. `freshness_gate_ref`
2. `generation_guard_attested`
3. `stale_writer_evidence`
4. `adopt_or_fail_reason`
5. `remote_recovery_window`

这里最重要的判断是：

- `resume order` 不再独立成根对象；它只是 re-entry proof 的一个子证据

### 1.5 `anti-zombie evidence` 与 `reopen boundary`

结构验收还必须消费：

1. `anti_zombie_evidence_ref`
2. `transition_legality_snapshot`
3. `degraded_path`
4. `rejected_outcome`
5. `reopen_boundary`
6. `return_authority_object`

原因不是 debug 指标更多，而是：

- 结构先进性真正保护的是 stale writer、zombie outcome 与 split-brain 不会被误消费成成功

## 2. reject verdict：必须共享的拒收语义

更成熟的结构宿主 reject verdict 至少应共享下面枚举：

1. `heuristic_state_authority`
2. `authority_width_unbound`
3. `pointer_as_truth`
4. `writeback_not_authoritative`
5. `event_stream_rebuilds_present`
6. `freshness_gate_missing`
7. `anti_zombie_evidence_missing`
8. `success_rate_as_truth`
9. `reopen_boundary_unknown`

这些 reject verdict 的价值在于：

- 把“看起来恢复好了”的错觉压成宿主、CI、评审与交接都能共享的拒收语义

## 3. 不应直接绑定为公共 ABI 的对象

宿主不应直接把下面内容绑成长期契约：

1. pointer 文件路径本身
2. mtime / fanout 细节
3. `_generation` 内部字段
4. stale patch 内部数组
5. sidecar 存储实现
6. 请求成功率
7. 恢复按钮状态

它们可以是调试材料，但不能是验收对象。

## 4. 验收顺序建议

更稳的顺序是：

1. 先验 `authority object`
2. 再验 `per-host authority width`
3. 再验 `writeback path`
4. 再验 `freshness gate`
5. 再验 `anti-zombie evidence`
6. 最后验 `reopen boundary`

不要反过来做：

1. 不要先看 pointer。
2. 不要先看成功率。
3. 不要先看 UI 是否恢复。

## 5. 一句话总结

Claude Code 的结构宿主验收协议，不是 pointer 与恢复按钮 API，而是 `authority object + per-host authority width + writeback path + freshness gate + anti-zombie evidence + reopen boundary` 共同组成的规则面。
