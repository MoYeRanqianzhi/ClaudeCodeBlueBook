# 故障模型宿主消费面手册：authority state、generation evidence、recovery boundary与anti-zombie projection

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式支持面让宿主消费结构故障模型。
2. 哪些属于宿主可写恢复/回退入口，哪些属于宿主可读状态投影，哪些仍然是 internal-only 反僵尸机制。
3. 为什么 authority state、generation evidence、recovery boundary 与 anti-zombie projection 必须被一起理解。
4. 为什么宿主不该把源码先进性理解成目录图、恢复成功率或作者说明。
5. 宿主开发者该按什么顺序接入这套故障模型支持面。

## 0. 关键源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:308-360`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/utils/QueryGuard.ts:55-93`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`
- `claude-code-source-code/src/bridge/bridgePointer.ts:42-184`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-142`
- `claude-code-source-code/src/cli/print.ts:2995-3028`

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `evolvable_kernel_object_boundary`

的单独公共对象。

但结构故障模型已经通过三层支持面被宿主间接而稳定地消费：

1. `rollback / recovery requests`
   - 宿主能写哪些恢复与回退动作。
2. `authority / state projections`
   - 宿主能看到哪些当前权威状态与阻塞状态。
3. `internal fault-model machinery`
   - 真正负责 generation guard、stale-safe merge、recovery boundary 与 anti-zombie 的内部机制。

更成熟的接入方式不是：

- 直接依赖内部状态机字段

而是：

- 消费已经外化出来的 authority state、recovery contract 与 fault-model projection

## 2. rollback / recovery requests：宿主可写恢复边界

当前最关键的结构恢复写入口包括：

1. `rewind_files`
2. `seed_read_state`

这两个入口回答的不是：

- 目录长什么样

而是：

1. 当前能否围绕某个对象回退。
2. 当前读状态缓存是否还能合法继续。

正确理解不是：

- 这是两个杂项 API

而是：

- 这是结构故障模型对宿主暴露出的最小恢复 / 回退 contract

## 3. authority state：宿主可读当前权威状态

宿主当前最该消费的 authority state 主要有：

1. `session_state_changed.state`
2. `external_metadata.permission_mode`
3. `external_metadata.pending_action`
4. `external_metadata.task_summary`

这些面共同回答：

1. 当前权威状态在哪里。
2. 当前是在运行、阻塞还是空闲。
3. 当前谁在阻塞后续动作。
4. 当前长任务的工作面是什么。

它们不是结构美学的替代品，而是：

- 当前故障模型的最小宿主投影

## 4. generation evidence：宿主应消费什么、不应消费什么

`QueryGuard` 与 task framework 真正保护的是：

1. 过去不会写坏现在。
2. stale finally 不会清理 fresh state。
3. stale task patch 不会覆盖 fresh task。

但这些 generation / stale-safe 机制当前主要仍在内部。

宿主最成熟的消费方式是：

1. 通过 `state + pending_action + task_summary` 消费它们的结果。
2. 通过回退 contract 和恢复 contract 消费其边界。
3. 不把 `_generation`、`updatedTaskOffsets`、`evictedTaskIds` 等内部字段当公共 ABI。

## 5. recovery boundary：宿主可见边界与 internal-only 细节

Claude Code 的恢复边界真正依赖：

1. `bridgePointer` 的 TTL 与 freshness。
2. `sessionIngress` 的 append-chain adopt / retry。
3. 读状态 cache 的 `seed_read_state` 边界。

这些都说明：

- recovery asset 是正式对象

但宿主正确消费的应是：

1. 当前是否可恢复。
2. 当前回退对象是否仍合法。
3. 当前恢复边界来自哪一类资产。

而不是：

1. pointer 文件路径
2. mtime / fanout 细节
3. append-chain 内部重试实现

## 6. anti-zombie projection：宿主真正该看到什么

宿主并不需要看到所有 anti-zombie 内部细节，但必须看到其结果投影：

1. 当前状态有没有被 stale writer 拒绝。
2. 当前恢复边界有没有清掉陈旧资产。
3. 当前回退动作能否围绕对象进行，而不是围绕文件列表瞎猜。

这意味着更成熟的支持面不该只是：

- 恢复成功率

而应是：

- stale writer evidence / recovery boundary / rollback outcome 的对象化投影

## 7. 三层支持矩阵

更稳的故障模型接入矩阵可以写成：

### 7.1 宿主可写

1. `rewind_files`
2. `seed_read_state`

### 7.2 宿主可读

1. `session_state_changed`
2. `permission_mode`
3. `pending_action`
4. `task_summary`
5. rollback / rewind 结果

### 7.3 不应直接依赖为公共 ABI

1. `QueryGuard._generation / _status`
2. stale patch / eviction 内部字段
3. `bridge-pointer.json` 路径、mtime、fanout 规则
4. append-chain adopt / retry 的内部实现
5. anti-zombie 内部拒收分支的全部细节

## 8. 接入顺序建议

更稳的顺序是：

1. 先接 `rewind_files / seed_read_state` 这类恢复与回退入口。
2. 再接 `session_state_changed / pending_action / task_summary` 这类 authority state 投影。
3. 再把 recovery boundary 与 anti-zombie outcome 组织进自己的 CI、交接与恢复面板。
4. 最后才把内部 generation / pointer / merge 细节当调试参考，而不是公共 ABI。

不要做的事：

1. 不要把结构先进性退回目录图展示。
2. 不要把恢复成功率当结构故障模型本体。
3. 不要让宿主自己推断 stale writer 是否发生。
4. 不要把 pointer / generation / merge patch 内部结构绑进长期契约。

## 9. 一句话总结

Claude Code 的故障模型支持面，不是目录说明书，而是“恢复 / 回退入口 + authority state 投影 + anti-zombie 结果面”共同组成的分层宿主消费面。
