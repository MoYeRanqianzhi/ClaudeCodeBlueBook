# Control 协议字段对照与宿主接入样例

这一章回答五个问题：

1. Claude Code control protocol 的核心封套字段到底有哪些。
2. 每类 control request / response 的关键字段应该如何理解。
3. 宿主接入时，最小可用 NDJSON 对话应该长什么样。
4. 哪些 response 是强结构化的，哪些只是通用 success / error 包装。
5. 为什么字段级理解对宿主集成是必要的，而不是“知道 subtype 名字”就够了。

## 1. 先说结论

Claude Code control protocol 的最小核心只有四个封套：

1. `control_request`: `type` + `request_id` + `request`
2. `control_response(success)`: `type` + `response.subtype='success'` + `response.request_id` + `response.response?`
3. `control_response(error)`: `type` + `response.subtype='error'` + `response.request_id` + `response.error`
4. `control_cancel_request`: `type` + `request_id`

在这个封套之下，真正区分语义的是：

- `request.subtype`
- 各 subtype 对应字段
- 宿主是否真的实现了这组字段的往返

关键证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:552-647`
- `claude-code-source-code/src/cli/structuredIO.ts:362-429`
- `claude-code-source-code/src/cli/structuredIO.ts:469-531`

## 2. 外层封套字段

### 2.1 `control_request`

固定字段只有三项：

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| `type` | `'control_request'` | 固定封套类型 |
| `request_id` | `string` | 请求关联键 |
| `request` | union object | 具体 subtype 负载 |

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:578-584`

### 2.2 `control_response(success)`

成功响应的固定字段：

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| `type` | `'control_response'` | 固定封套类型 |
| `response.subtype` | `'success'` | 成功响应 |
| `response.request_id` | `string` | 对应请求 ID |
| `response.response` | `record<string, unknown>?` | subtype 自己的响应体，可空 |

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:586-592`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:605-609`

### 2.3 `control_response(error)`

错误响应的固定字段：

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| `type` | `'control_response'` | 固定封套类型 |
| `response.subtype` | `'error'` | 错误响应 |
| `response.request_id` | `string` | 对应请求 ID |
| `response.error` | `string` | 错误文本 |
| `response.pending_permission_requests` | `SDKControlRequest[]?` | 可选，额外挂起权限请求 |

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:594-603`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:605-609`

### 2.4 `control_cancel_request`

取消封套只有：

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| `type` | `'control_cancel_request'` | 固定取消类型 |
| `request_id` | `string` | 要取消的请求 ID |

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:612-619`

## 3. 请求字段总表

下面只列“宿主最需要理解的字段”，不重复类型系统里已经显而易见的包装。

### 3.1 生命周期与运行配置

| subtype | 关键字段 | 说明 |
| --- | --- | --- |
| `initialize` | `hooks` `sdkMcpServers` `jsonSchema` `systemPrompt` `appendSystemPrompt` `agents` `promptSuggestions` `agentProgressSummaries` | 会话初始化与宿主能力注入 |
| `interrupt` | 无额外字段 | 中断当前回合 |
| `set_permission_mode` | `mode` `ultraplan?` | 修改权限模式，`ultraplan` 明显是 internal/CCR 痕迹 |
| `set_model` | `model?` | 设置后续回合模型 |
| `set_max_thinking_tokens` | `max_thinking_tokens` | 设置 extended thinking 上限 |
| `apply_flag_settings` | `settings` | 将设置写进 flag settings layer |
| `get_settings` | 无额外字段 | 拉取 merged settings |

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-157`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:464-519`

### 3.2 权限与安全

| subtype | 关键字段 | 说明 |
| --- | --- | --- |
| `can_use_tool` | `tool_name` `input` `permission_suggestions?` `blocked_path?` `decision_reason?` `title?` `display_name?` `tool_use_id` `agent_id?` `description?` | 宿主参与权限仲裁的主路径 |
| synthetic `can_use_tool` | `tool_name='SandboxNetworkAccess'` `input.host` `description` | sandbox 网络请求借用同一协议 |

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-122`
- `claude-code-source-code/src/cli/structuredIO.ts:723-752`

### 3.3 状态与会话修复

| subtype | 关键字段 | 说明 |
| --- | --- | --- |
| `get_context_usage` | 无额外字段 | 获取上下文窗口使用明细 |
| `rewind_files` | `user_message_id` `dry_run?` | 回滚某个 user message 后的文件改动 |
| `cancel_async_message` | `message_uuid` | 撤销尚未执行的异步用户消息 |
| `seed_read_state` | `path` `mtime` | 手工补种 read cache，避免 edit 校验失败 |
| `stop_task` | `task_id` | 停止运行中的 task |

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:175-361`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:455-462`

### 3.4 扩展与连接控制

| subtype | 关键字段 | 说明 |
| --- | --- | --- |
| `mcp_status` | 无额外字段 | 拉 MCP 连接状态 |
| `mcp_message` | `server_name` `message` | 发 JSON-RPC 给指定 MCP server |
| `mcp_set_servers` | `servers` | 替换动态管理的 MCP servers |
| `reload_plugins` | 无额外字段 | 重载 plugins |
| `mcp_reconnect` | `serverName` | 重新连接某个 MCP server |
| `mcp_toggle` | `serverName` `enabled` | 启停某个 MCP server |

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:157-173`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:374-452`

### 3.5 hook 与 elicitation

| subtype | 关键字段 | 说明 |
| --- | --- | --- |
| `hook_callback` | `callback_id` `input` `tool_use_id?` | 宿主执行 hook callback |
| `elicitation` | `mcp_server_name` `message` `mode?` `url?` `elicitation_id?` `requested_schema?` | 宿主处理 MCP 反问 |

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:363-372`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:522-545`

## 4. 响应字段总表

### 4.1 `initialize` response

`initialize` 是最重的 success payload 之一，关键字段包括：

- `commands`
- `agents`
- `output_style`
- `available_output_styles`
- `models`
- `account`
- `pid?`
- `fast_mode_state?`

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:77-95`

### 4.2 `get_context_usage` response

这是最重的状态类返回之一，核心字段包括：

- `categories`
- `totalTokens` / `maxTokens` / `rawMaxTokens` / `percentage`
- `gridRows`
- `model`
- `memoryFiles`
- `mcpTools`
- `deferredBuiltinTools?`
- `systemTools?`
- `systemPromptSections?`
- `agents`
- `slashCommands?`
- `skills?`
- `autoCompactThreshold?`
- `isAutoCompactEnabled`
- `messageBreakdown?`
- `apiUsage?`

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:205-305`

### 4.3 `rewind_files` response

字段：

- `canRewind`
- `error?`
- `filesChanged?`
- `insertions?`
- `deletions?`

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:318-328`

### 4.4 `cancel_async_message` response

字段：

- `cancelled`

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:341-349`

### 4.5 `mcp_status` response

字段：

- `mcpServers`

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:165-173`

### 4.6 `mcp_set_servers` response

字段：

- `added`
- `removed`
- `errors`

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:393-403`

### 4.7 `reload_plugins` response

字段：

- `commands`
- `agents`
- `plugins`
- `mcpServers`
- `error_count`

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:415-433`

### 4.8 `get_settings` response

字段：

- `effective`
- `sources[]`
- `applied?`

其中 `sources` 明确按低到高优先级排序，`applied` 则是 runtime-resolved values，不等于磁盘 merge 结果。

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:485-519`

### 4.9 `elicitation` response

字段：

- `action`
- `content?`

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:538-545`

## 5. 最小宿主接入样例

### 5.1 初始化

宿主发：

```json
{"type":"control_request","request_id":"req-init-1","request":{"subtype":"initialize","promptSuggestions":true}}
```

CLI 回：

```json
{"type":"control_response","response":{"subtype":"success","request_id":"req-init-1","response":{"commands":[],"agents":[],"output_style":"normal","available_output_styles":["normal"],"models":[],"account":{}}}}
```

### 5.2 权限请求

CLI 发：

```json
{"type":"control_request","request_id":"req-tool-1","request":{"subtype":"can_use_tool","tool_name":"Bash","input":{"command":"npm test"},"tool_use_id":"toolu_1"}}
```

宿主回：

```json
{"type":"control_response","response":{"subtype":"success","request_id":"req-tool-1","response":{"behavior":"allow","updatedInput":{"command":"npm test"}}}}
```

### 5.3 宿主取消

如果宿主或本地 hook 决策先完成，可以发：

```json
{"type":"control_cancel_request","request_id":"req-tool-1"}
```

这表示：

- 当前请求不再等待
- 对端不应继续持有旧 permission prompt

### 5.4 远程保活

transport 可发送：

```json
{"type":"keep_alive"}
```

但 `StructuredIO` 会直接忽略它，不把它当作产品消息。

证据：

- `claude-code-source-code/src/cli/structuredIO.ts:344-346`

## 6. 宿主最容易搞错的三个字段问题

### 6.1 看到 `response.response` 可空，就以为 success 没结构

这是错的。

很多 success payload 虽然封套层允许 record/optional，但具体 subtype 在 schema 层其实有很重的结构，只是当前 `control_response` 外层用通用包装承载。

### 6.2 看到 subtype 存在，就以为任何宿主都能发

这也是错的。

schema 定义的是协议全集，bridge / direct-connect / remote-session 只实现子集。

### 6.3 看到 `keep_alive` / `update_environment_variables`，就以为它们是用户可见消息

也不对。

这两类更接近 transport / runner 辅助信号，不应和业务事件混在同一层写作。

## 7. 一句话总结

Claude Code control protocol 的关键，不只是 subtype 名字，而是“通用封套 + subtype 字段 + 宿主是否真的实现这组字段往返”三者共同成立。
