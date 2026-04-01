# SDK 消息与事件字典

本章只做一件事：把 `SDKMessageSchema` 可见的消息族梳理成可查表。

## 1. 为什么这章重要

如果只看 `query(prompt)`，你会误以为 SDK 只返回 assistant 文本。  
但 `SDKMessageSchema` 明确表明，Claude Code 输出的是一条运行时事件流。

证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1854-1875`

## 2. 核心消息族

### 2.1 用户与助手消息

- `SDKUserMessageSchema`
- `SDKUserMessageReplaySchema`
- `SDKAssistantMessageSchema`
- `SDKPartialAssistantMessageSchema`

证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1290-1299`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1347-1355`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1496-1503`

含义：

- 不仅有最终消息，还有 replay 和 stream_event。

### 2.2 结果消息

- `SDKResultSuccessSchema`
- `SDKResultErrorSchema`

证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1407-1451`

含义：

- 最终结果会带 duration、cost、usage、permission denials、structured output 等摘要信息。

### 2.3 系统初始化与状态消息

- `SDKSystemMessageSchema` (`subtype: init`)
- `SDKCompactBoundaryMessageSchema`
- `SDKStatusMessageSchema`
- `SDKAPIRetryMessageSchema`
- `SDKLocalCommandOutputMessageSchema`

证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1457-1494`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1506-1542`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1572-1602`

含义：

- 宿主能看到会话初始化、compact boundary、API retry 和本地命令输出，不只是模型文本。

### 2.4 Hook 相关消息

- `SDKHookStartedMessageSchema`
- `SDKHookProgressMessageSchema`
- `SDKHookResponseMessageSchema`

证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1604-1646`

含义：

- hook 执行本身也是可观测运行时事件。

### 2.5 Tool / task / auth 相关消息

- `SDKToolProgressMessageSchema`
- `SDKAuthStatusMessageSchema`
- `SDKTaskNotificationMessageSchema`
- `SDKTaskStartedMessageSchema`
- `SDKTaskProgressMessageSchema`
- `SDKToolUseSummaryMessageSchema`

证据：

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1648-1777`

含义：

- 任务系统、认证状态、工具进度都能进入宿主 UI/日志。

## 3. 这些消息分别解决什么问题

| 消息族 | 解决的问题 |
| --- | --- |
| user / assistant / partial | 对话与流式显示 |
| result | 单轮最终统计与状态 |
| system/init/status | 宿主初始化与状态同步 |
| compact / api_retry | 长会话与恢复路径可见化 |
| hook_* | hook 过程可观测 |
| tool_progress | 长工具调用进度 |
| task_* | 背景任务生命周期 |
| auth_status | 登录/认证中间态 |

## 4. 一个重要认识

这套消息设计说明 Claude Code SDK 的真正目标不是“让外部程序获取模型回复”，而是“让外部宿主接入 Claude Code runtime 的运行脉搏”。

也就是说，SDK 输出的不是 answer stream，而是 session event stream。

## 5. 下一步待补

1. 把每个消息的字段再整理成更细的字段字典。
2. 区分 public、@internal、streamlined 输出中的消息变体。
3. 补一张“典型一轮对话可能发出哪些消息”的时序图。
