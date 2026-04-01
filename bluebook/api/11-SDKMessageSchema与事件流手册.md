# SDKMessageSchema 与事件流手册

这一章回答四个问题：

1. `SDKMessageSchema` 到底包含哪些正式消息变体。
2. Claude Code SDK 为什么输出的不是 answer stream，而是 session event stream。
3. 哪些消息是稳定公共面，哪些明显带有 internal / streamlined 痕迹。
4. 宿主应该怎样理解这些消息的运行语义，而不只是类型名。

## 1. 先说结论

Claude Code SDK 的消息面至少可以拆成六组：

1. 会话消息：`user`、`user replay`、`assistant`、`stream_event`。
2. 结果消息：`result(success|error)`。
3. 系统状态消息：`init`、`compact_boundary`、`status`、`api_retry`、`local_command_output`、`session_state_changed`。
4. hook / tool / auth 消息：`hook_*`、`tool_progress`、`auth_status`、`tool_use_summary`。
5. task / persistence 消息：`task_started`、`task_progress`、`task_notification`、`files_persisted`。
6. 附加引导消息：`rate_limit_event`、`elicitation_complete`、`prompt_suggestion`。

所以 SDK 的核心设计对象不是“把 Claude 回复给宿主”，而是“把 runtime 的事件脉搏持续暴露给宿主”。

关键证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1290-1302`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1347-1455`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1457-1602`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1604-1779`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1794-1880`

## 2. 消息族一：用户、助手与流式事件

### 2.1 `SDKUserMessageSchema`

字段核心是：

- 复用 `SDKUserMessageContentSchema`
- `uuid?`
- `session_id?`

这说明普通 user message 可以在某些场景下作为较轻量的输入镜像存在。

证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1290-1295`

### 2.2 `SDKUserMessageReplaySchema`

相比普通 user message，它显式多了：

- `uuid`
- `session_id`
- `isReplay: true`

它的意义不是“再发一次用户输入”，而是“把历史 user 节点以 replay 形式重新送进事件流”。

证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1297-1302`

### 2.3 `SDKAssistantMessageSchema`

关键字段包括：

- `type: 'assistant'`
- `message: APIAssistantMessagePlaceholder()`
- `parent_tool_use_id`
- `error?`
- `uuid`
- `session_id`

这里的 `parent_tool_use_id` 很重要，说明 assistant 消息不仅可以是主线程回复，也可以是对某个工具调用上下文的子回复。

证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1347-1355`

### 2.4 `SDKPartialAssistantMessageSchema`

它并不是“半成品 assistant”，而是：

- `type: 'stream_event'`
- `event: RawMessageStreamEventPlaceholder()`
- `parent_tool_use_id`
- `uuid`
- `session_id`

也就是说，流式阶段的公共语义不是“partial assistant text”，而是“原始流事件本身”。

证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1496-1504`

## 3. 消息族二：结果不是最后一句话，而是单轮执行摘要

### 3.1 success 结果

`SDKResultSuccessSchema` 至少带：

- `duration_ms`
- `duration_api_ms`
- `num_turns`
- `result`
- `stop_reason`
- `total_cost_usd`
- `usage`
- `modelUsage`
- `permission_denials`
- `structured_output?`
- `fast_mode_state?`

证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1407-1426`

### 3.2 error 结果

`SDKResultErrorSchema` 则用 subtype 区分：

- `error_during_execution`
- `error_max_turns`
- `error_max_budget_usd`
- `error_max_structured_output_retries`

并额外带：

- `errors: string[]`

证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1428-1455`

这表明 Claude Code 的 `result` 并不是“最终答案文本”，而是一个回合级执行报告。

## 4. 消息族三：系统状态面

### 4.1 `system:init`

`SDKSystemMessageSchema` 的内容非常重，至少包含：

- `agents`
- `apiKeySource`
- `claude_code_version`
- `cwd`
- `tools`
- `mcp_servers`
- `model`
- `permissionMode`
- `slash_commands`
- `output_style`
- `skills`
- `plugins`
- `fast_mode_state`

证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1457-1494`

这说明 SDK 一开始同步的不是“欢迎消息”，而是整个 runtime 装配态。

### 4.2 `system:compact_boundary`

关键字段是：

- `trigger: manual | auto`
- `pre_tokens`
- `preserved_segment?`

其中 `preserved_segment` 还带：

- `head_uuid`
- `anchor_uuid`
- `tail_uuid`

证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1506-1531`

因此 compact boundary 不是提示性文案，而是可恢复链上的结构边界。

### 4.3 `system:status`

`SDKStatusMessageSchema` 带：

- `status`
- `permissionMode?`

证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1533-1542`

### 4.4 `system:api_retry`

包含：

- `attempt`
- `max_retries`
- `retry_delay_ms`
- `error_status`
- `error`

证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1572-1588`

这说明 API 重试也是宿主可观测运行态，而不是内部透明处理。

### 4.5 `system:local_command_output`

这是对本地 slash command 的显式镜像：

- `content`
- `uuid`
- `session_id`

证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1590-1602`

## 5. 消息族四：hook / tool / auth

### 5.1 hook 三件套

hook 有三类消息：

- `hook_started`
- `hook_progress`
- `hook_response`

其中 progress/response 都包含：

- `stdout`
- `stderr`
- `output`

而 response 还带：

- `exit_code?`
- `outcome`

证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1604-1646`

### 5.2 `tool_progress`

关键字段：

- `tool_use_id`
- `tool_name`
- `parent_tool_use_id`
- `elapsed_time_seconds`
- `task_id?`

证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1648-1659`

### 5.3 `auth_status`

字段包括：

- `isAuthenticating`
- `output`
- `error?`

证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1661-1669`

这说明认证过程本身也被看成正式事件流，而不是单次阻塞前置。

### 5.4 `tool_use_summary`

这类消息用来把一批工具结果收敛成高层摘要：

- `summary`
- `preceding_tool_use_ids`

证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1769-1777`

## 6. 消息族五：task / persistence

### 6.1 `task_started`

关键字段：

- `task_id`
- `tool_use_id?`
- `description`
- `task_type?`
- `workflow_name?`
- `prompt?`

证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1715-1733`

### 6.2 `task_progress`

关键字段：

- `task_id`
- `description`
- `usage`
- `last_tool_name?`
- `summary?`

证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1750-1767`

### 6.3 `task_notification`

关键字段：

- `status: completed | failed | stopped`
- `output_file`
- `summary`
- `usage?`

证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1694-1713`

### 6.4 `files_persisted`

这是结果落盘层的事件：

- `files`
- `failed`
- `processed_at`

证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1672-1692`

## 7. 消息族六：额外运行信号

`SDKMessageSchema` 末尾还收进了：

- `rate_limit_event`
- `elicitation_complete`
- `prompt_suggestion`

证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1358-1367`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1779-1792`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1794-1806`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1854-1880`

这再次说明 SDK 不是只为主对话服务，而是在暴露一整套 session runtime 的附加信号。

## 8. 需要特别标注的 internal / non-mainline 痕迹

当前提取源码里能明显看到几类“应谨慎断言为公共稳定面”的消息：

1. `streamlined_text`
2. `streamlined_tool_use_summary`
3. `post_turn_summary`
4. `prompt_suggestion`

原因不是它们一定不能用，而是源码自己已经在描述里标出：

- `@internal`
- “streamlined output”
- 或明显依赖 feature / output mode

证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1369-1397`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1544-1570`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1794-1806`

## 9. 从第一性原理看：为什么是事件流，不是答案流

如果把 Claude Code 当作 coding agent runtime，而不是聊天函数，它至少要让宿主看到：

1. 当前初始化态
2. 流式生成中间态
3. 工具执行与 hook 进度
4. background task 生命周期
5. compact / retry / rate limit / auth 等恢复信号
6. 最终回合摘要

所以 SDKMessageSchema 的真正设计答案是：

宿主接入的不是“助手说了什么”，而是“runtime 发生了什么”。

## 10. 相关章节

- 粗粒度消息总览：`04-SDK消息与事件字典.md`
- Claude API 与流式执行：`../architecture/12-ClaudeAPI与流式工具执行.md`
- 会话与状态 API：`09-会话与状态API手册.md`
