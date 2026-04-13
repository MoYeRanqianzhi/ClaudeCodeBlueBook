# 故障模型宿主消费面手册：current-truth claim projection、authority-width candidate、freshness verdict、rollback receipts 与 anti-zombie evidence

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式支持面让宿主消费结构故障模型的 `current-truth claim projection`、`per-host authority width` 候选与 `freshness evidence`。
2. 哪些属于宿主可写恢复/回退入口，哪些属于宿主可读 `current-truth claim / authority-width` 投影与 `rollback boundary receipt`，哪些仍然是 internal-only 的 stale-writer / anti-zombie 机制。
3. 为什么 `current-truth claim projection`、`per-host authority width`、`freshness evidence` 与 `anti-zombie evidence` 必须被一起理解。
4. 为什么宿主不该把源码先进性理解成目录图、恢复成功率或作者说明。
5. 宿主开发者该按什么顺序接入这套故障模型支持面。

## 0. 关键源码锚点

当前 `.worktrees/mainloop` 仍处于 `mirror absent / public-evidence only`，下列源码路径只能作为归档锚点与后续复核入口，不能写成当前 worktree 已直接验证的 live evidence。

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
2. `current-truth claim / per-host authority width projections`
   - 宿主能看到哪些当前权威状态、阻塞状态与合法消费宽度。
3. `freshness evidence / stale-writer machinery`
   - 真正负责 generation guard、stale-safe merge、recovery asset non-sovereignty 与 anti-zombie 的内部机制，但宿主更该消费其 host-facing projection、cleanup witness 与 rollback receipt candidate。

因此本页更稳的 claim state 只到这里：公开 artifact 与既有归档材料支持我们把 `rewind_files / seed_read_state`、`session_state_changed / pending_action / task_summary` 等面读成结构故障模型的宿主消费候选。
像 `per-host authority width`、`freshness gate`、`recovery asset non-sovereignty` 这样的对象边界，当前仍应保留为 `host-facing truth candidate / internal-only candidate / unknown`，而不是升格成已核实的对象事实。
待源码镜像回场后，再把这些候选从 public-evidence claim-state 升格为经本地镜像核验的 host-facing truth 与公共 ABI 边界。

更成熟的接入方式不是：

- 直接依赖内部状态机字段

而是：

- 消费已经外化出来的 `current-truth claim / per-host authority width` 投影、recovery contract、freshness evidence、cleanup witness 与 rollback boundary receipt candidate

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

- 这是结构故障模型对宿主暴露出的最小恢复 / 回退 contract，也是 `rollback eligibility object` 与 `read-state continuation eligibility evidence` 的最小来源

## 3. current-truth claim / per-host authority width：宿主可读当前状态投影

宿主当前最该消费的 `current-truth claim / per-host authority width` 投影主要有：

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

## 4. freshness evidence：宿主应消费什么、不应消费什么

`QueryGuard` 与 task framework 真正保护的是：

1. 过去不会写坏现在。
2. stale finally 不会清理 fresh state。
3. stale task patch 不会覆盖 fresh task。

但这些 generation / stale-safe 机制当前主要仍在内部。

宿主最成熟的消费方式是：

1. 通过 `state + pending_action + task_summary` 消费它们的结果。
2. 通过 `freshness outcome projection / cleanup residue object / rollback legality snapshot` 消费其结果对象，而不是自己推断 stale writer 是否发生。
3. 通过回退 contract 和恢复 contract 消费其边界。
4. 不把 `_generation`、`updatedTaskOffsets`、`evictedTaskIds` 等内部字段当公共 ABI。

## 5. recovery asset non-sovereignty：宿主可见边界、cleanup witness 与 internal-only 细节

Claude Code 的恢复边界真正依赖：

1. `bridgePointer` 的 TTL 与 freshness。
2. `sessionIngress` 的 append-chain adopt / retry。
3. 读状态 cache 的 `seed_read_state` 边界。

这些都说明：

- `recovery asset` 更稳地说只先构成 `recovery-asset boundary / asset-class evidence candidate`

但宿主正确消费的应是：

1. 当前是否可恢复。
2. 当前回退对象是否仍合法。
3. 当前恢复边界来自哪一类资产。
4. 当前 cleanup 到底撤掉了哪类陈旧资产，并留下什么 `cleanup residue object`。

而不是：

1. pointer 文件路径
2. mtime / fanout 细节
3. append-chain 内部重试实现

## 6. anti-zombie projection：宿主真正该看到什么

宿主并不需要看到所有 anti-zombie 内部细节，但必须看到其结果投影：

1. `freshness evidence / projection`
   - 当前状态有没有被 stale writer 拒绝。
2. `cleanup witness / residue object`
   - 当前恢复边界有没有清掉陈旧资产。
3. `rollback witness / boundary receipt candidate`
   - 当前回退动作能否围绕对象进行，而不是围绕文件列表瞎猜。

这意味着更成熟的支持面不该只是：

- 恢复成功率

而应是：

- stale writer evidence / recovery asset non-sovereignty / rollback outcome 的对象化投影

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
5. `freshness outcome projection`
6. `cleanup residue object`
7. `rollback / rewind boundary receipt candidate`

### 7.3 不应直接依赖为公共 ABI

1. `QueryGuard._generation / _status`
2. stale patch / eviction 内部字段
3. `bridge-pointer.json` 路径、mtime、fanout 规则
4. append-chain adopt / retry 的内部实现
5. anti-zombie 内部拒收分支的全部细节

## 8. 接入顺序建议

更稳的顺序是：

1. 先接 `rewind_files / seed_read_state` 这类恢复与回退入口。
2. 再接 `session_state_changed / pending_action / task_summary` 这类 current-truth claim 投影。
3. 再把 `freshness outcome projection / cleanup residue object / rollback boundary receipt candidate` 组织进自己的 CI、交接与恢复面板。
4. 最后才把内部 generation / pointer / merge 细节当调试参考，而不是公共 ABI。

不要做的事：

1. 不要把结构先进性退回目录图展示。
2. 不要把恢复成功率当结构故障模型本体。
3. 不要让宿主自己推断 stale writer 是否发生。
4. 不要把 pointer / generation / merge patch 内部结构绑进长期契约。

## 9. 一句话总结

Claude Code 的故障模型支持面，不是目录说明书，而是“恢复 / 回退入口 + current-truth claim 投影 + freshness evidence / cleanup witness / rollback boundary receipt candidate + recovery asset non-sovereignty 边界”共同组成的分层宿主消费面。
