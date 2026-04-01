# Control 子类型与宿主适配矩阵

这一章回答五个问题：

1. Claude Code 当前可见的 control subtype 全集到底有哪些。
2. 哪些 subtype 属于完整宿主协议，哪些只是某些适配器的窄子集。
3. `StructuredIO`、bridge、direct connect、remote session 各自真正支持什么。
4. 为什么“schema 已定义”不等于“所有宿主都已支持”。
5. 宿主集成时，应该如何避免把协议全集和适配器子集混写。

## 1. 先说结论

从 `controlSchemas.ts` 看，当前可见的 control request subtype 至少包括：

- `initialize`
- `interrupt`
- `can_use_tool`
- `set_permission_mode`
- `set_model`
- `set_max_thinking_tokens`
- `mcp_status`
- `get_context_usage`
- `rewind_files`
- `cancel_async_message`
- `seed_read_state`
- `hook_callback`
- `mcp_message`
- `mcp_set_servers`
- `reload_plugins`
- `mcp_reconnect`
- `mcp_toggle`
- `stop_task`
- `apply_flag_settings`
- `get_settings`
- `elicitation`

但这些 subtype 并不是被所有宿主等量支持。

更准确的理解是：

1. `StructuredIO` 定义完整协议全集。
2. `RemoteIO` 复用同一协议，仅扩 transport 与远程状态同步。
3. bridge 支持的是“中等宽度子集”。
4. direct connect 与 `RemoteSessionManager` 支持的是“窄子集”。

关键证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-549`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:552-647`
- `claude-code-source-code/src/cli/structuredIO.ts:470-773`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts:243-391`
- `claude-code-source-code/src/server/directConnectManager.ts:81-200`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts:153-297`

## 2. 全集：schema 层已经定义了什么

如果只看 schema，当前 control request 至少可以分成六组。

### 2.1 会话初始化与运行配置

- `initialize`
- `interrupt`
- `set_permission_mode`
- `set_model`
- `set_max_thinking_tokens`
- `apply_flag_settings`
- `get_settings`

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-157`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:455-519`

### 2.2 权限与安全

- `can_use_tool`
- `control_cancel_request`
- `update_environment_variables`

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:97-124`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:605-632`

### 2.3 状态与会话修复

- `get_context_usage`
- `rewind_files`
- `cancel_async_message`
- `seed_read_state`
- `stop_task`

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:175-351`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:435-452`

### 2.4 扩展与连接控制

- `mcp_status`
- `mcp_message`
- `mcp_set_servers`
- `reload_plugins`
- `mcp_reconnect`
- `mcp_toggle`

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:157-173`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:374-452`

### 2.5 hook 与 MCP 反问

- `hook_callback`
- `elicitation`

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:351-372`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:522-549`

### 2.6 保活与环境刷新

- `keep_alive`
- `update_environment_variables`

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:624-632`

## 3. 适配矩阵：谁真正支持什么

下面这张表只写“源码里明确可见的实现”，不把 schema 定义直接当成宿主已支持事实。

| 控制能力 | `StructuredIO` / 本地 SDK host | bridge | direct connect | `RemoteSessionManager` |
| --- | --- | --- | --- | --- |
| `initialize` | 有完整 schema 与请求封装语义 | 支持，且返回最小 capabilities | 未见显式处理 | 未见显式处理 |
| `can_use_tool` | 支持，且有 hook race / cancel / duplicate 防护 | 支持，作为桥接权限主路径 | 支持 | 支持 |
| `interrupt` | 支持 schema 与请求发送 | 支持 | 支持 | 支持 |
| `set_model` | 支持 schema | 支持 | 未见显式处理 | 未见显式处理 |
| `set_max_thinking_tokens` | 支持 schema | 支持 | 未见显式处理 | 未见显式处理 |
| `set_permission_mode` | 支持 schema | 支持，但受 policy verdict 约束 | 未见显式处理 | 未见显式处理 |
| `get_context_usage` | 支持 schema | 未见桥接适配 | 未见 | 未见 |
| `get_settings` / `apply_flag_settings` | 支持 schema | 未见桥接适配 | 未见 | 未见 |
| `rewind_files` / `seed_read_state` / `cancel_async_message` / `stop_task` | 支持 schema | 未见桥接适配 | 未见 | 未见 |
| `mcp_*` / `reload_plugins` / `mcp_message` | 支持 schema | 未见桥接适配 | 未见 | 未见 |
| `hook_callback` / `elicitation` | 支持 | 未见桥接适配 | 未见 | 未见 |
| `control_cancel_request` | 支持 | 支持 | 作为入站过滤，不见主动语义 | 支持入站取消通知 |
| `keep_alive` | 支持消息类型但语义上忽略 | 支持输运保活 | 过滤 | 由底层 WS/ping 保活，不作产品消息 |

## 4. `StructuredIO`：协议全集所在层

`StructuredIO` 通过 `sendRequest(...)`、`pendingRequests`、schema parse 和 abort 处理，具备完整 control-request 框架。

当前代码里它显式提供的方法或控制能力包括：

- `createCanUseTool(...)`
- `createHookCallback(...)`
- `handleElicitation(...)`
- `createSandboxAskCallback()`
- `sendMcpMessage(...)`

这说明它不是“仅支持权限弹窗”，而是完整宿主协议的执行层。

证据：

- `claude-code-source-code/src/cli/structuredIO.ts:470-531`
- `claude-code-source-code/src/cli/structuredIO.ts:533-658`
- `claude-code-source-code/src/cli/structuredIO.ts:661-773`

## 5. bridge：中等宽度子集，而不是完整全集

### 5.1 bridge 的入站 control request 支持面

`handleServerControlRequest(...)` 当前明确支持：

- `initialize`
- `set_model`
- `set_max_thinking_tokens`
- `set_permission_mode`
- `interrupt`

其他未知 subtype 会回 error，避免 server 一直挂起等待回复。

证据：

- `claude-code-source-code/src/bridge/bridgeMessaging.ts:235-391`

### 5.2 bridge 的权限回调仍然主要围绕 `can_use_tool`

`useReplBridge.tsx` 中为交互权限 handler 构建的 `BridgePermissionCallbacks` 只围绕四个动作：

- `sendRequest(...)` 发 `can_use_tool`
- `sendResponse(...)` 回 success response
- `cancelRequest(...)` 发 `control_cancel_request`
- `onResponse(...)` 挂 request-id 级 handler

也就是说，bridge 在产品上最重的一条 control path 仍然是权限仲裁。

证据：

- `claude-code-source-code/src/bridge/bridgePermissionCallbacks.ts:3-27`
- `claude-code-source-code/src/hooks/useReplBridge.tsx:367-385`
- `claude-code-source-code/src/hooks/useReplBridge.tsx:538-581`

### 5.3 outbound-only bridge 故意拒绝可变更请求

如果 bridge 运行在 outbound-only 模式：

- `initialize` 仍必须成功
- 其他 mutable request 明确回 error

这说明 bridge 设计者很清楚“宿主路径存在”和“该会话允许入站控制”是两回事。

证据：

- `claude-code-source-code/src/bridge/bridgeMessaging.ts:265-283`

## 6. direct connect：最薄宿主子集

`DirectConnectSessionManager` 当前显式支持的控制语义非常窄：

- 入站只处理 `can_use_tool`
- 未知 control request 回 error
- 出站只主动发 `interrupt`
- `control_response`、`keep_alive`、`control_cancel_request`、streamlined message 都被过滤掉

这说明 direct connect 更像“极薄宿主镜像层”，而不是完整 SDK host。

证据：

- `claude-code-source-code/src/server/directConnectManager.ts:81-112`
- `claude-code-source-code/src/server/directConnectManager.ts:144-200`

## 7. `RemoteSessionManager`：远程会话客户端子集

`RemoteSessionManager` 的控制语义也明显窄于 schema 全集：

- 入站只正式处理 `can_use_tool`
- `control_cancel_request` 会通知宿主取消 pending prompt
- `control_response` 只记日志
- 出站只主动发 permission response 和 `interrupt`

它的职责更接近“remote session client”，而不是“完整 control protocol host”。

证据：

- `claude-code-source-code/src/remote/RemoteSessionManager.ts:146-214`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts:247-297`

## 8. 为什么这个矩阵重要

这张矩阵真正要解决的不是“列 subtype 名字”，而是纠正三种常见误解：

1. 误把 schema 全集写成所有宿主都已支持。
2. 误把 bridge 的中等宽度子集写成“只做权限 prompt”。
3. 误把 direct connect / remote session manager 这些窄适配器写成完整 SDK host。

## 9. 当前边界

需要继续保守三点：

1. 这里的矩阵基于当前提取源码可见实现，不代表内部宿主或未来构建必然一致。
2. 某些 subtype 在 schema 层已定义，但未在当前 bridge/direct-connect/remote-session 代码里看到显式适配，不应擅自补全。
3. `RemoteIO` 不是独立宿主适配器，而是协议全集在远程 transport 上的投射层，因此不应和 direct connect / `RemoteSessionManager` 简单并列为同一抽象层。

## 10. 一句话总结

Claude Code 的 control subtype 应该按“协议全集 -> 控制平面 -> 宿主适配器子集”三层理解，而不是看见 schema 就默认所有宿主都已完整支持。
