# 协议全集、控制平面主路径与Consumer Subset：Claude Code的宿主三层治理

这一章回答五个问题：

1. 为什么 `controlSchemas.ts` 不能直接等于“Claude Code 已接入能力全集”。
2. 真正的权威控制平面主路径到底落在哪一层。
3. 为什么 `RemoteIO`、bridge、direct connect、`RemoteSessionManager` 必须按不同宽度理解。
4. 为什么同一套 runtime 真相必须允许不同消费者只拿到各自的子集。
5. 这套三层治理为什么比“所有宿主共享一份全量表示”更成熟。

## 0. 代表性源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-549`
- `claude-code-source-code/src/cli/structuredIO.ts:135-162`
- `claude-code-source-code/src/cli/structuredIO.ts:333-399`
- `claude-code-source-code/src/cli/structuredIO.ts:470-658`
- `claude-code-source-code/src/cli/print.ts:2830-2975`
- `claude-code-source-code/src/cli/remoteIO.ts:111-168`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts:132-391`
- `claude-code-source-code/src/server/directConnectManager.ts:40-200`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts:95-297`
- `claude-code-source-code/src/utils/sessionState.ts:92-135`
- `claude-code-source-code/src/state/onChangeAppState.ts:24-90`

## 1. 先说结论

Claude Code 的宿主设计，至少应按三层写：

1. 协议全集：
   - `controlSchemas.ts` 定义什么语义可以被正式表达。
2. 控制平面主路径：
   - `StructuredIO + print.ts + RemoteIO` 负责什么语义真正被执行、关联、取消、去重、回写。
3. Consumer Subset：
   - bridge、direct connect、`RemoteSessionManager` 以及不同状态消费者，只消费自己职责范围内的诚实子集。

所以 Claude Code 统一的其实不是：

- 所有宿主共享同一份全量表示

而是：

- 所有宿主共享同一份权威合同，再按对象和职责投射成不同宽度的消费面

## 2. 第一层：协议全集先固定语义坐标

`controlSchemas.ts` 的作用，不是证明“所有宿主都已完整支持”，而是先把控制语义的坐标系固定下来。

这里可见的 subtype 至少覆盖：

- `initialize`
- `can_use_tool`
- `set_permission_mode`
- `set_model`
- `set_max_thinking_tokens`
- `get_context_usage`
- `rewind_files`
- `cancel_async_message`
- `seed_read_state`
- `mcp_*`
- `apply_flag_settings`
- `get_settings`
- `elicitation`

尤其 `initialize` 本身已经把：

- hooks
- SDK MCP servers
- `systemPrompt`
- `appendSystemPrompt`
- agents
- prompt suggestions
- agent progress summaries

收进同一个装配点。

这说明 schema 层治理的是：

- 可表达的协议全集

而不是：

- 某个具体宿主此刻已经承诺的实现宽度

## 3. 第二层：真正的主路径在 `StructuredIO + print.ts`

Claude Code 的权威控制平面主路径，不在 schema 列表本身，而在真正执行协议闭环的那条路径。

### 3.1 `StructuredIO` 负责协议正确性

`StructuredIO` 维护的是：

- `pendingRequests`
- `resolvedToolUseIds`
- 单 writer 的 `outbound` FIFO
- duplicate / orphan response 防护
- hook 与宿主 permission request 的竞速

所以它承担的不是“序列化一层 JSON”，而是：

- 请求关联正确性
- 时序正确性
- 取消正确性
- 权限仲裁正确性

### 3.2 `print.ts` 负责真正执行控制副作用

`print.ts` 的 `control_request` 分发才是真正把 subtype 变成运行时副作用的地方。

它显式处理：

- `interrupt`
- `initialize`
- `set_permission_mode`
- `set_model`
- `set_max_thinking_tokens`
- `mcp_status`
- `get_context_usage`

并在这里把：

- AppState 变更
- model 覆写
- context usage 计算
- session metadata 更新

闭合进同一条主路径。

也就是说，真正决定“这条控制语义是否已经成为系统现实”的，不是 schema 被声明出来，而是它是否已经进入这条权威执行链。

### 3.3 `RemoteIO` 不是第二套协议，而是同一主路径的远程投射

`RemoteIO` 并没有重新发明 remote-only control protocol。

它做的是把同一条主路径继续投到远程 transport 上，并额外接上：

- `CCRClient.initialize()`
- internal event writer / reader
- `reportState(...)`
- `reportMetadata(...)`

所以远程层扩出来的是：

- durability
- 恢复
- transport 连续性

而不是：

- 一套新的控制语义

## 4. 第三层：Consumer Subset 是正式治理，不是能力缩水

如果继续往外看，不同宿主与不同消费者拿到的都只是子集。

### 4.1 bridge 是中等宽度子集

bridge 会先在 `handleIngressMessage(...)` 里把：

- `control_request`
- `control_response`
- `user`

分流开来，而不是原样转运所有消息。

`handleServerControlRequest(...)` 也只显式支持有限 subtype，未知请求直接回 error，避免 server 误以为请求仍在等待处理。

### 4.2 direct connect 与 `RemoteSessionManager` 更窄

这两层当前明显更接近：

- 最小宿主接入器

而不是：

- 完整 SDK host

它们聚焦在：

- `can_use_tool`
- `interrupt`

这类最关键但最小的闭环，因此应被写成“窄适配器子集”，而不是“系统整体能力很窄”。

### 4.3 `worker_status` / `external_metadata` 也是面向消费者的子集

同样的分层也出现在状态面：

- 事件流给出时间线真相
- `worker_status` / `external_metadata` 给出当前快照真相

这说明 consumer subset 不只存在于宿主适配器，还存在于：

- UI
- web session list
- resume path
- 搜索 / 检索层

各自消费 runtime 真相的方式里。

## 5. 为什么这不是缩水，而是治理分层

如果没有这三层，系统只会落进两种坏结果：

1. 每个宿主都重新定义一套私有语义，协议碎裂。
2. 强迫所有宿主一开始就支持全集，接入成本失控。

Claude Code 选择的是第三条路：

1. 先统一协议全集。
2. 再统一权威主路径。
3. 最后允许不同消费者诚实接入子集。

这种设计的收益有三点：

1. 声明权、执行权、消费权被拆开，假成功更少。
2. transport 与宿主适配可以复用同一语义字典。
3. 系统可以继续演化，而不用要求所有下游同步升级。

## 6. 这条三层治理和 prompt 设计其实是同一哲学

这条线和 prompt 设计的：

- contract
- request surface
- consumer subset

是同一套哲学。

也就是说，Claude Code 反对的不是：

- 单一权威

它反对的是：

- 让所有消费者共享单一全景表示

所以它才会同时出现：

- protocol transcript 而不是直接重放 UI transcript
- `initialize` 装配点而不是到处散落 prompt 注入
- bridge / direct connect / remote session 的不同宽度子集
- 事件流与快照回写的分离

## 7. 一句话总结

Claude Code 的宿主面真正成熟之处，不在于“schema 很全”，而在于它把协议全集、权威主路径与 consumer subset 明确分层，并坚持让每一层都只对自己的真相负责。
