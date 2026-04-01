# StructuredIO 与 RemoteIO 宿主协议手册

这一章回答五个问题：

1. Claude Code 的 SDK host 到底通过什么协议和 CLI worker 协作。
2. `StructuredIO` 真正负责的是什么，为什么它不只是 permission prompt 通道。
3. `RemoteIO` 相比 `StructuredIO` 多出来的远程语义有哪些。
4. direct connect、remote session、CCR 这些远程形态和本地 SDK 协议是什么关系。
5. 为什么这条宿主面应该被理解成“控制平面”，而不是“把 assistant 文本接出去”。

## 1. 先说结论

Claude Code 的宿主协议面至少有五层：

1. 封套层：`user` / `assistant` / `system` / `control_request` / `control_response` / `control_cancel_request` / `keep_alive` / `update_environment_variables`。
2. 关联层：`request_id`、schema 校验、`pendingRequests`、`resolvedToolUseIds`。
3. 仲裁层：权限请求、hook 与宿主竞速、late duplicate/orphan response、防重放。
4. 扩展层：`mcp_message`、`elicitation`、sandbox network ask、settings/context/state 类控制请求。
5. 传输层：`StructuredIO`、`RemoteIO`、direct connect、`RemoteSessionManager`、`SessionsWebSocket`。

所以宿主接入 Claude Code 时，拿到的不是“回答流接口”，而是一条双向控制协议。

关键证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-173`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:175-519`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:552-647`
- `claude-code-source-code/src/cli/structuredIO.ts:135-162`
- `claude-code-source-code/src/cli/structuredIO.ts:333-429`
- `claude-code-source-code/src/cli/structuredIO.ts:470-773`
- `claude-code-source-code/src/cli/remoteIO.ts:35-240`
- `claude-code-source-code/src/server/directConnectManager.ts:40-210`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts:87-323`
- `claude-code-source-code/src/remote/SessionsWebSocket.ts:74-403`

## 2. 协议封套：不是只有 `SDKMessage`

### 2.1 stdin / stdout 都是联合消息面

`controlSchemas.ts` 明确把宿主协议拆成：

- `SDKControlRequestSchema`
- `SDKControlResponseSchema`
- `SDKControlCancelRequestSchema`
- `SDKKeepAliveMessageSchema`
- `SDKUpdateEnvironmentVariablesMessageSchema`
- `StdoutMessageSchema`
- `StdinMessageSchema`

这说明 SDK host 与 CLI worker 交换的不是单一消息类型，而是一个控制协议联合体。

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:552-647`

### 2.2 `StructuredIO` 读写的是 NDJSON 控制流

`StructuredIO` 构造时拿到的是 `AsyncIterable<string>`，内部按换行切分，再把每一行解析成 `StdinMessage | SDKMessage`。

因此它的抽象对象是：

- line-delimited JSON input
- schema-aware control state
- SDK message replay

而不是“终端里顺手收点文本”。

证据：

- `claude-code-source-code/src/cli/structuredIO.ts:135-170`
- `claude-code-source-code/src/cli/structuredIO.ts:215-258`

## 3. control request 子类型全景

如果按功能归类，当前可见的 control request 至少可以拆成五组。

### 3.1 生命周期与运行配置

- `initialize`
- `interrupt`
- `set_permission_mode`
- `set_model`
- `set_max_thinking_tokens`
- `apply_flag_settings`
- `get_settings`

这组请求说明宿主不只是在“发 prompt”，而是在改 runtime 配置。

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-157`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:455-519`

### 3.2 权限与安全协商

- `can_use_tool`
- `control_cancel_request`
- `update_environment_variables`
- synthetic `SandboxNetworkAccess`

这里最关键的不是 subtype 数量，而是宿主被纳入了权限仲裁链。

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:97-124`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:615-629`
- `claude-code-source-code/src/cli/structuredIO.ts:348-359`
- `claude-code-source-code/src/cli/structuredIO.ts:723-752`

### 3.3 状态与会话控制

- `get_context_usage`
- `rewind_files`
- `cancel_async_message`
- `seed_read_state`
- `stop_task`

这组请求说明宿主可以读 runtime 状态，也可以显式修正运行时前提。

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:175-351`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:435-452`

### 3.4 扩展与连接管理

- `mcp_status`
- `mcp_message`
- `mcp_set_servers`
- `reload_plugins`
- `mcp_reconnect`
- `mcp_toggle`

这说明宿主还能够控制连接平面与插件装配面。

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:157-173`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:374-452`

### 3.5 hook 与 elicitation

- `hook_callback`
- `elicitation`

这两类请求说明 Claude Code 允许宿主介入“扩展执行”与“MCP 向用户反问”。

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:351-372`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:522-549`

## 4. `StructuredIO`：请求关联与乱序防护层

### 4.1 `pendingRequests` + `request_id`

`StructuredIO` 通过 `pendingRequests` 保存尚未完成的控制请求，并用 `request_id` 做请求关联。

`sendRequest(...)` 会：

1. 构造 `control_request`
2. 放入统一 `outbound` FIFO
3. 注册 pending promise
4. 在 finally 中移除 pending

证据：

- `claude-code-source-code/src/cli/structuredIO.ts:137-162`
- `claude-code-source-code/src/cli/structuredIO.ts:470-531`

### 4.2 `outbound` 和主循环共用一条 FIFO

注释写得很明确：

- `sendRequest()` 和 `print.ts` 共用同一条 queue
- drain loop 是唯一 writer
- 这样可以防止 `control_request` 抢在已排队的 `stream_event` 前面

这不是实现细节，而是协议时序保证。

证据：

- `claude-code-source-code/src/cli/structuredIO.ts:160-162`
- `claude-code-source-code/src/cli/print.ts:1021-1023`

### 4.3 `resolvedToolUseIds` 专门防 late duplicate

`StructuredIO` 维护 `resolvedToolUseIds`，目的非常直接：

- 避免 WebSocket reconnect 后重复到达的 `control_response`
- 避免把重复 assistant/tool 结果再次推回 transcript
- 避免 API 侧报 `tool_use ids must be unique`

证据：

- `claude-code-source-code/src/cli/structuredIO.ts:149-155`
- `claude-code-source-code/src/cli/structuredIO.ts:362-399`

### 4.4 orphan response 也有专门处理口

如果 `control_response` 到来时本地已经没有 pending request：

- 先看是不是已解析过的 `toolUseID`
- 不是的话，再走 `unexpectedResponseCallback`

也就是说，作者明确预期“响应可能迟到、重复、失配”。

证据：

- `claude-code-source-code/src/cli/structuredIO.ts:269-273`
- `claude-code-source-code/src/cli/structuredIO.ts:374-399`

## 5. 取消与权限竞速是协议一等语义

### 5.1 abort 会显式发 `control_cancel_request`

`sendRequest(...)` 监听 signal，一旦 abort：

- 立刻 enqueue `control_cancel_request`
- 本地立即 reject promise
- 先记录 resolved tool use，防止后续迟到响应再次被处理

所以取消不是 UI 层补丁，而是正式协议动作。

证据：

- `claude-code-source-code/src/cli/structuredIO.ts:490-504`

### 5.2 hook 和 SDK host 会并行竞速

`createCanUseTool(...)` 并不是“先跑 hook，再问宿主”，而是：

- hook evaluation 后台启动
- SDK host permission prompt 立即发出
- 两者 `Promise.race(...)`
- 谁先决策谁赢，输家被 abort/忽略

这是非常强的设计信号：Claude Code 不把宿主权限 UI 看成同步阻塞弹窗，而看成 runtime 仲裁节点。

证据：

- `claude-code-source-code/src/cli/structuredIO.ts:561-639`

### 5.3 bridge 能直接注入 `control_response`

`injectControlResponse(...)` 用于 bridge 胜出时把 claude.ai 的权限回答喂回 SDK 流程，并且会顺带给 SDK consumer 发一个 `control_cancel_request`，避免宿主侧回调悬挂。

证据：

- `claude-code-source-code/src/cli/structuredIO.ts:275-309`

## 6. `RemoteIO`：同一协议上的远程增强层

### 6.1 不是新协议，而是 `StructuredIO` 的 transport 扩展

`RemoteIO extends StructuredIO`，说明远程模式并没有重新发明宿主协议，只是替换了输入输出承载。

证据：

- `claude-code-source-code/src/cli/remoteIO.ts:35-50`
- `claude-code-source-code/src/cli/print.ts:5199-5232`

### 6.2 transport、session token、header refresh 都在这里

`RemoteIO` 会：

- 读取 session ingress token
- 注入 `Authorization`
- 注入 environment runner version
- 为重连准备动态 header refresh
- 通过 `getTransportForUrl(...)` 选 transport

证据：

- `claude-code-source-code/src/cli/remoteIO.ts:54-93`

### 6.3 CCR v2 把 transcript/internal events 接进远程会话

开启 CCR v2 后，`RemoteIO` 还会：

- 初始化 `CCRClient`
- 注册 internal event writer
- 注册 foreground/subagent internal event reader
- 报告 command delivery、session state、metadata

因此远程不是“只把输出流过去”，而是把运行状态也接出去。

证据：

- `claude-code-source-code/src/cli/remoteIO.ts:111-168`
- `claude-code-source-code/src/cli/remoteIO.ts:217-240`

### 6.4 `keep_alive` 只是一种输运保活，不进入 UI 真相

`RemoteIO` 的注释明确说明：

- `keep_alive` 只是为了防 upstream proxy / session ingress 回收空闲会话
- `StructuredIO` 会直接忽略它
- `Query.ts`、web、iOS、Android 也不会把它当用户可见消息

证据：

- `claude-code-source-code/src/cli/remoteIO.ts:174-196`
- `claude-code-source-code/src/cli/structuredIO.ts:344-346`

## 7. 其他宿主适配器：same protocol, narrower surface

### 7.1 `DirectConnectSessionManager` 是最薄的一层

direct connect 侧只做几件事：

- WebSocket 收 `StdoutMessage`
- 只专门处理 `can_use_tool`
- 过滤 `control_response` / `keep_alive` / `control_cancel_request` / streamlined 消息
- 发送 `user`
- 回发 `control_response`
- 发送 `interrupt`

这说明 direct connect 不是完整 worker 控制面，而是窄化后的宿主镜像。

证据：

- `claude-code-source-code/src/server/directConnectManager.ts:40-210`

### 7.2 `RemoteSessionManager` 是“WS 接收 + HTTP 发送 + 权限往返”

它的职责被源码注释直接写出来：

- WebSocket 订阅消息
- HTTP POST 发送用户事件
- 权限请求/响应流转

而且当前只对 `can_use_tool` 做正式处理，其余未知 subtype 会回 error。

证据：

- `claude-code-source-code/src/remote/RemoteSessionManager.ts:87-214`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts:217-323`
- `claude-code-source-code/src/utils/teleport/api.ts:353-417`

### 7.3 `SessionsWebSocket` 处理的是远程连接可靠性

它负责：

- headers 认证
- reconnect backoff
- `4001 session not found` 的特殊重试
- `4003 unauthorized` 的永久关闭
- ping interval
- `sendControlResponse(...)`
- `sendControlRequest(...)`

证据：

- `claude-code-source-code/src/remote/SessionsWebSocket.ts:74-139`
- `claude-code-source-code/src/remote/SessionsWebSocket.ts:231-299`
- `claude-code-source-code/src/remote/SessionsWebSocket.ts:325-403`

## 8. 当前边界

需要明确三点：

1. `StructuredIO` 是最完整的宿主协议层，但 direct connect 与 remote session manager 当前只实现了其中较窄的一部分，尤其聚焦 `can_use_tool` 与 `interrupt`。
2. `update_environment_variables`、CCR internal events、bridge echo、streamlined output 里混有明显 host-specific 或 internal 语义，不能直接写成稳定公共承诺。
3. 看到 control subtype schema，不等于每个宿主都已完整支持这一 subtype。

## 9. 一句话总结

Claude Code 的宿主集成面，本质上不是“assistant 文本怎么输出”，而是“runtime 如何通过显式控制协议把权限、状态、取消、扩展和远程输运统一暴露给外部宿主”。
