# 恢复优先的双通道状态面：writeback、resume与reconnect一体化

这一章回答五个问题：

1. 为什么 `worker_status` / `external_metadata` 不应被写成遥测附属层。
2. `writeback` 为什么属于 durability 设计，而不是“多打一层状态上报”。
3. `resume`、`reconnect`、remote bridge 为什么都依赖这条状态面。
4. `WorkerStateUploader` 的 merge / retry / coalesce 语义为什么是恢复设计的一部分。
5. 这条线透露了怎样的第一性原理。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/sessionState.ts:92-135`
- `claude-code-source-code/src/state/onChangeAppState.ts:24-90`
- `claude-code-source-code/src/cli/print.ts:806-821`
- `claude-code-source-code/src/cli/print.ts:1863-1872`
- `claude-code-source-code/src/cli/print.ts:2450-2466`
- `claude-code-source-code/src/cli/print.ts:5049-5061`
- `claude-code-source-code/src/cli/remoteIO.ts:111-168`
- `claude-code-source-code/src/cli/transports/ccrClient.ts:459-537`
- `claude-code-source-code/src/cli/transports/ccrClient.ts:645-662`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:1-118`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:477-560`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:800-878`

## 1. 先说结论

Claude Code 的状态回写，真正维护的是：

- 可恢复的当前真相

而不只是：

- 供外部 UI 看的最佳努力遥测

判断标准很简单：

如果某个状态在失败、重启、恢复、换 transport 之后仍会被系统重新读回，并影响后续行为，那它就不是 telemetry，而是 durability surface。

`worker_status`、`requires_action_details`、`external_metadata` 在 Claude Code 里正是这种角色。

## 2. 状态回写从一开始就被当成权威快照面

### 2.1 `notifySessionStateChanged(...)` 决定当前阻塞点

`notifySessionStateChanged(...)` 不只通知 listener。

它还会：

- 在 `requires_action` 时写入 `pending_action`
- 在解除阻塞时用 `null` 清掉它
- 在 `idle` 时清掉 `task_summary`

这说明作者不愿把：

- 当前是否被卡住
- 当前阻塞详情是什么

留给下游自己从事件流反推。

### 2.2 `onChangeAppState(...)` 收口分散的 mode 变化

`onChangeAppState(...)` 明确把：

- `permission_mode`
- `is_ultraplan_mode`

镜像进 `external_metadata`。

关键不在“字段多了一份”，而在：

- 所有 `setAppState` 路径终于共享同一个 choke point

于是 Shift+Tab、slash command、rewind、bridge `set_permission_mode` 等分散入口，不再各自偷偷漂移。

### 2.3 turn 生命周期也显式驱动状态切换

`print.ts` 在权限弹窗、run 开始、run finally 结束时分别调用：

- `notifySessionStateChanged('requires_action', ...)`
- `notifySessionStateChanged('running')`
- `notifySessionStateChanged('idle')`

所以当前状态并不是“事后统计得出”，而是 turn runtime 主链亲自维护的正式信号。

## 3. `RemoteIO + CCRClient` 把当前真相变成可恢复事实

### 3.1 `RemoteIO` 负责接线

`RemoteIO` 初始化 CCR v2 后，会统一注册：

- command lifecycle -> `reportDelivery(...)`
- session state -> `reportState(...)`
- session metadata -> `reportMetadata(...)`

这说明 writeback 不是某个零散 feature 在偷偷上报，而是远程运行时的一条正式主路径。

### 3.2 `CCRClient.initialize()` 先恢复，再宣告当前 worker

`CCRClient.initialize()` 会并发做两件事：

1. 读取旧 worker state
2. `PUT /worker` 写入新的 `idle` 状态

同时主动清理：

- `pending_action`
- `task_summary`

这一步非常关键，因为 crash 前遗留的阻塞快照不会随着进程重启自动消失。

如果不清，新的 worker 会继承旧的“假阻塞真相”。

### 3.3 `reportState(...)` 与 `reportMetadata(...)` 是最后值语义

`CCRClient.reportState(...)` 明确按：

- 当前状态未变则去重
- details 独立写入 `requires_action_details`

来维护状态。

而 metadata 则走单独的 `reportMetadata(...)`。

这说明状态回写的目标不是复刻一条历史流，而是维护一份：

- 最新、可恢复、可覆写的权威快照

## 4. `WorkerStateUploader` 彻底暴露了 durability 取向

`WorkerStateUploader` 的设计几乎已经把“这不是遥测”写在脸上。

它的关键语义是：

- 1 个 inflight PUT
- 1 个 pending patch
- 无限重试直到成功或 close
- 重试前吸收新 patch
- top-level last value wins
- `external_metadata` / `internal_metadata` 走 RFC 7396 merge

这套机制要解决的不是：

- 指标尽量上报完整

而是：

- 多个独立 emitter 的部分更新不能互相覆盖
- transport 抖动后仍能收敛到一份最新真相
- `null` 删除语义必须被保留，旧状态必须能被明确擦除

这已经是标准的 durability design，而不是 analytics helper。

## 5. `resume` 与 `reconnect` 都直接依赖这条写回面

### 5.1 resume 不是“读回消息”就完了

`print.ts` 在 `--resume` 路径里会并发等待：

- `hydrateFromCCRv2InternalEvents(...)`
- `restoredWorkerState`

拿到 metadata 后，再通过 `externalMetadataToAppState(...)` 把：

- permission mode
- ultraplan
- model

反投回本地 `AppState`。

这说明 resume 需要的不只是 transcript，还需要：

- 当前真相快照

### 5.2 reconnect 明确拒绝“假连续性”

`remoteBridgeCore.ts` 在 `401` 恢复期间会：

- gate 住 flush
- rebuild transport
- 丢弃 stale `control_request`
- 丢弃 stale `control_response`
- 丢弃 stale `control_cancel_request`
- 丢弃 stale `result`

同时在不同消息上显式补写：

- `running`
- `requires_action`
- `idle`

源码注释甚至直接说明：

- v2 不再依赖服务端从事件流反推 `worker_status`

所以状态必须从这里主动写出。

这正说明系统的优先级是：

- 先保护 durable truth
- 再谈表面上的“看起来一直在线”

## 6. 这条线的第一性原理

Claude Code 在这里押注的是：

- 当前真相必须可恢复，而不是事后可观测

这和单纯 observability 的差别在于：

1. observability 关心你能不能解释过去发生了什么。
2. durability 关心系统重来一次时，还能不能继续站在正确的当前状态上。

因此它必须坚持三件事：

1. 当前状态要有权威快照。
2. 旧真相要能被显式清除。
3. 恢复窗口宁可丢弃 stale 写入，也不能制造假在线状态。

## 7. 一句话总结

Claude Code 的状态回写之所以高级，不在于它“上报得更全”，而在于它把 writeback、resume 与 reconnect 做成同一条 durability 主线，让当前真相在崩溃、恢复与换 transport 之后仍然可信。
