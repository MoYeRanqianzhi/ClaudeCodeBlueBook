# SDK 消息与 Control 闭环对照表

这一章回答五个问题：

1. control request 发出后，宿主通常会看到哪些 `SDKMessage` 回流。
2. 哪些 request 只会得到 `control_response`，哪些还会引出后续系统消息。
3. 为什么只看 request/response 不足以理解 Claude Code 的宿主协议。
4. 哪些闭环是确定的，哪些只是条件性事件。
5. 宿主接入时，应该如何按“请求 -> 响应 -> 后续消息”理解整条链。

## 1. 先说结论

Claude Code 的宿主控制协议不是单一 request/response 模型，而是闭环模型：

1. 宿主发 `control_request`
2. CLI 回 `control_response`
3. runtime 可能再发一串 `SDKMessage`

其中最重要的闭环至少有四类：

1. 初始化闭环：`initialize -> control_response -> system:init`
2. 权限闭环：`can_use_tool -> control_response / control_cancel_request -> session_state_changed / status / tool/task 相关消息`
3. 配置闭环：`set_permission_mode -> control_response -> system:status`
4. MCP / elicitation / task 闭环：`mcp_message`、`elicitation`、`stop_task` 等请求触发后续 system event，而不仅是一个 success ack

所以 Claude Code 的宿主协议不应被理解成 RPC，而应被理解成 control-loop protocol。

关键证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-549`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:578-647`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1457-1880`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/utils/sdkEventQueue.ts:1-121`
- `claude-code-source-code/src/cli/structuredIO.ts:362-429`
- `claude-code-source-code/src/cli/structuredIO.ts:469-773`
- `claude-code-source-code/src/cli/print.ts:1051-1076`

## 2. 闭环总表

| 宿主动作 | 直接响应 | 可能后续 SDK 消息 | 说明 |
| --- | --- | --- | --- |
| `initialize` | `control_response(success)` | `system:init` | 初始化不只返回 ack，还会同步 runtime 装配态 |
| `can_use_tool` | `control_response(success/error)` 或 `control_cancel_request` | `system:session_state_changed?` `system:status?` `tool_progress` `task_*` `tool_use_summary` | 权限只是控制点，后面还会进入执行链 |
| `set_permission_mode` | `control_response(success/error)` | `system:status` | 模式变化会通过 status message 回流 |
| `set_model` | `control_response(success/error)` | 条件性 `system:init` / 后续 result/model usage 变化 | 主要通过后续回合体现，不一定立刻有单独 system message |
| `set_max_thinking_tokens` | `control_response(success/error)` | 条件性后续 assistant/result 行为变化 | 主要作用在后续回合 |
| `get_context_usage` | `control_response(success)` | 无额外 SDK message | 典型“只回 response”请求 |
| `get_settings` | `control_response(success)` | 无额外 SDK message | 典型“只回 response”请求 |
| `mcp_status` | `control_response(success)` | 条件性后续 system/init 或连接状态消息 | 查询本身只回 response |
| `mcp_set_servers` | `control_response(success/error)` | 条件性后续 init / server status 变化 | 配置替换后，连接平面会继续演化 |
| `mcp_message` | `control_response(success/error)` | 条件性 `system:elicitation_complete` 等 | 请求可能引出更长的 MCP 交互链 |
| `reload_plugins` | `control_response(success)` | 条件性 status/init 风格后续变化 | 刷新后的 commands / agents / plugins 在 response 中已返回 |
| `stop_task` | `control_response(success/error)` | `system:task_notification` | 停止 task 后往往还有终态通知 |
| `hook_callback` | `control_response(success/error)` | 条件性 `hook_*` | hook callback 本身处在 hook 消息环里 |
| `elicitation` | `control_response(success/error)` | `system:elicitation_complete` | URL-mode elicitation 完成后会有单独消息 |

## 3. 初始化闭环

### 3.1 request 与 response

宿主先发 `initialize`，其 payload 决定：

- hooks
- sdk MCP servers
- system prompt patch
- agents
- prompt suggestion / agent progress summary 等功能

CLI 会先回一个 `control_response(success)`，带：

- `commands`
- `agents`
- `output_style`
- `available_output_styles`
- `models`
- `account`
- `pid?`
- `fast_mode_state?`

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-95`

### 3.2 response 之后还会有 `system:init`

`system:init` 则进一步把当前 runtime 装配态发给宿主，包括：

- agents
- tools
- mcp servers
- model
- permissionMode
- slash commands
- skills
- plugins

这说明初始化闭环不是“拿一份能力清单”就结束，而是“拿一份控制返回 + 一份会话运行态快照”。

证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1457-1494`

## 4. 权限闭环

### 4.1 request

当 runtime 需要宿主裁决时，会发：

- `control_request{subtype:'can_use_tool'}`

关键字段包括：

- `tool_name`
- `input`
- `permission_suggestions?`
- `blocked_path?`
- `decision_reason?`
- `tool_use_id`
- `agent_id?`

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-122`

### 4.2 response / cancel

宿主可回：

- `control_response(success)`
- `control_response(error)`
- 或在本地先决策时走 `control_cancel_request`

`StructuredIO` 对这三条路径都有专门处理：

- parse schema
- reject pending promise
- resolvedToolUseId 防 late duplicate

证据：

- `claude-code-source-code/src/cli/structuredIO.ts:362-429`
- `claude-code-source-code/src/cli/structuredIO.ts:490-504`

### 4.3 后续消息

权限闭环真正结束时，宿主可能还会看到：

- `system:session_state_changed`
- `system:status`
- `tool_progress`
- `task_started`
- `task_progress`
- `task_notification`
- `tool_use_summary`

也就是说，权限批准不是终点，而是执行链下一段的开关。

证据：

- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/utils/sdkEventQueue.ts:1-121`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1648-1777`

## 5. 配置闭环

### 5.1 `set_permission_mode`

这类 request 最容易被低估，因为它看起来像“设个值”。

但 `print.ts` 明确在 permission mode 变化后，会向 SDK output stream enqueue：

- `type:'system'`
- `subtype:'status'`
- `permissionMode:newMode`

所以 `set_permission_mode` 是标准闭环：

```text
request -> success/error response -> system:status
```

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:124-135`
- `claude-code-source-code/src/cli/print.ts:1051-1076`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1533-1542`

### 5.2 `set_model` / `set_max_thinking_tokens`

这两类请求当前更偏“作用在后续回合”：

- schema 层有明确定义
- 宿主会得到 success/error
- 但后续影响更多反映在 assistant/result/model usage 上，而不是立即生成单独的专属 SDK message

因此它们是“弱闭环”，不是“无闭环”。

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:137-155`

## 6. 查询类请求：通常只回 response

有一批 request 更接近查询 RPC：

- `get_context_usage`
- `get_settings`
- `rewind_files`
- `cancel_async_message`
- `mcp_status`
- `mcp_set_servers`
- `reload_plugins`

它们的共同特点是：

- 结构化 response 很重
- 额外 SDK message 较少，或只在状态变化时条件性出现

因此宿主不能假设“所有 request 都会产生事件流”，但也不能反过来把整个协议误写成纯 RPC。

## 7. 任务与 elicitation 闭环

### 7.1 task

当 request 或运行链触发 task 变化时，SDK side queue 还会额外发：

- `task_started`
- `task_progress`
- `task_notification`

所以一些 control request 虽然封套上只看到 success/error，但系统真相其实还在 task event 里继续流动。

证据：

- `claude-code-source-code/src/utils/sdkEventQueue.ts:1-121`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1694-1767`

### 7.2 elicitation

`elicitation` 的 success response 之后，对 URL-mode 流程还可能继续看到：

- `system:elicitation_complete`

这说明 request->response 并不总等于“业务已结束”。

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:522-545`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1779-1791`

## 8. 宿主接入的一个实践心法

宿主处理 Claude Code 协议时，最稳妥的心法不是：

- “每发一个 request，等一个 response 就结束”

而是：

- “每发一个 request，先等 response，再继续消费后续 SDKMessage，直到状态闭环完成”

否则最容易漏掉三类真相：

1. 模式变化后的 `system:status`
2. 权限批准后的 `session_state_changed` / `task_*`
3. URL-mode elicitation 之后的 completion 信号

## 9. 一句话总结

Claude Code 的宿主协议不是“请求-响应二元组”，而是“request / response / follow-on SDKMessage”共同组成的闭环。
