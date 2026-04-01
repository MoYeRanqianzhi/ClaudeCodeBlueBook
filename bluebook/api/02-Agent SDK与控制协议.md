# Agent SDK 与控制协议

这一章覆盖两层接口:

1. `agentSdkTypes.ts` 暴露给 SDK 使用者的入口。
2. `controlSchemas.ts` + `StructuredIO` 定义的宿主控制协议。

## 1. SDK 公开入口长什么样

`agentSdkTypes.ts` 明确把 SDK 公共面拆成:

- core types
- runtime types
- settings types
- tool types
- control protocol types

证据:

- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:1-31`

同时它暴露了一组高层函数:

- `tool(...)`
- `createSdkMcpServer(...)`
- `query(...)`
- `unstable_v2_createSession(...)`
- `unstable_v2_resumeSession(...)`
- `unstable_v2_prompt(...)`
- `getSessionMessages(...)`
- `listSessions(...)`
- `getSessionInfo(...)`
- `renameSession(...)`
- `tagSession(...)`
- `forkSession(...)`

证据:

- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:73-107`
- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:111-164`
- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:178-272`

## 2. 一个重要边界: 这份提取源码里的 SDK 面并不完整

`agentSdkTypes.ts` 入口 re-export 了:

- `./sdk/controlTypes.js`
- `./sdk/runtimeTypes.js`
- `./sdk/toolTypes.js`

但当前提取源码树中并没有看到这些源码文件。

这里更合理的解读是:

- 公开 SDK 面确实存在
- 本地提取源码主要保留了 schema 与入口
- 完整的生成类型或运行时封装未在本树中展开

所以本章对 SDK 的判断以“入口 + schema + 控制协议”为准，不会臆造缺失实现。

证据:

- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:17-31`

## 3. core schema 到底覆盖哪些对象

`coreSchemas.ts` 是 SDK 可序列化数据类型的单一真源。

在这份源码中可直接看到它覆盖:

- output format
- config / thinking / beta
- MCP server config/status
- permission model
- hook events / hook input / hook output
- slash command
- agent info / agent definition
- account info / model info
- session metadata
- SDK message union

证据:

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:17-337`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:385-972`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1016-1118`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1854-1875`

## 4. `SDKMessageSchema` 说明 SDK 是事件流，而不是单响应

`SDKMessageSchema` 不是简单的 assistant/user 二元组，而是一个大的消息联合体。

可见变体至少包括:

- assistant
- user
- result
- system
- partial assistant
- compact boundary
- status
- API retry
- local command output
- hook started/progress/response
- tool progress
- auth status
- task notification
- task started/progress
- session state changed
- files persisted

证据:

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1854-1875`

这说明 SDK 不是简单包了一层 `query(prompt)`，而是一个可观察运行时。

## 5. control protocol 是第二层接口

`controlSchemas.ts` 定义的是 SDK host 和 CLI 进程之间的控制协议。

### 5.1 初始化与基本控制

基础控制请求包括:

- `initialize`
- `interrupt`
- `can_use_tool`
- `set_permission_mode`
- `set_model`
- `set_max_thinking_tokens`
- `mcp_status`
- `get_context_usage`

证据:

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-183`

### 5.2 高阶控制请求

继续向下看，还包括:

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

证据:

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:308-545`

### 5.3 包装层

所有请求最终进入:

- `control_request`
- `control_response`
- `control_cancel_request`

证据:

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:552-619`

## 6. `StructuredIO` 让协议真正跑起来

如果说 `controlSchemas.ts` 定义了类型，`StructuredIO` 就定义了运行语义。

关键职责包括:

- 解析 NDJSON 输入流
- 管理 pending control requests
- 维护 resolved tool_use_id，避免重复响应污染会话
- 把 `control_request` 排队写出，避免和 stream event 乱序
- 实现 `sendRequest(...)`
- 将权限请求、hook callback、elicitation、MCP message 统一映射到宿主协议

证据:

- `claude-code-source-code/src/cli/structuredIO.ts:135-162`
- `claude-code-source-code/src/cli/structuredIO.ts:172-260`
- `claude-code-source-code/src/cli/structuredIO.ts:469-531`
- `claude-code-source-code/src/cli/structuredIO.ts:533-659`
- `claude-code-source-code/src/cli/structuredIO.ts:691-773`

## 7. 一个关键设计点: 权限请求是协议的一部分，而不是 UI 特例

`StructuredIO.createCanUseTool()` 直接把 `can_use_tool` 变成 SDK 宿主必须参与的正式控制请求。

而且它不是简单等待用户决定，它还会:

- 并行运行 PermissionRequest hooks
- 与 SDK permission prompt race
- 用 abort/cancel 请求回收落后的分支

证据:

- `claude-code-source-code/src/cli/structuredIO.ts:533-659`

这说明 Claude Code 把 permission adjudication 当作 protocol concern，而不是 terminal-only concern。

## 8. 对接方应该怎么理解这个协议

从第一性原理看，这个控制协议解决的是“宿主如何作为外部控制器接管 CLI runtime”的问题。

所以宿主要做的不只是显示文本，还要能处理:

- 初始化能力清单
- 权限请求
- hook callback
- 上下文占用查询
- MCP server 管理
- session settings 与 rewind
- elicitation
- task stop/cancel

如果宿主只接 `assistant text`，那它实际上只接入了 Claude Code 很小的一部分能力。

## 9. 下一步应补的内容

1. 把 `SDKMessageSchema` 变体整理成完整表格。
2. 给每个 control subtype 补“谁发起 / 谁响应 / 典型时机 / 是否 public-stable”。
3. 结合 `print.ts` 与 `RemoteIO` 画出 CLI-host 往返时序图。
