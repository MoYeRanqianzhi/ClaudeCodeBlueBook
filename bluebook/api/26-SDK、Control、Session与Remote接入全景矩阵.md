# SDK、Control、Session 与 Remote 接入全景矩阵

这一章把 Claude Code 的宿主接入表面收拢成一张矩阵。

核心结论：

- Claude Code 的外部接入不是单一 `query()` API，而是由 query/session surface、control surface、event surface、remote surface 四层共同组成。

## 1. 关键源码锚点

- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:103-272`
- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:276-441`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-519`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1697-1854`
- `claude-code-source-code/src/cli/structuredIO.ts:59-173`
- `claude-code-source-code/src/cli/structuredIO.ts:333-514`
- `claude-code-source-code/src/cli/remoteIO.ts:127-238`

## 2. 四个接入平面

### 2.1 Query / Session 平面

`agentSdkTypes.ts` 可见的 query/session 入口至少包括：

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

这说明 SDK 既覆盖 one-shot，也覆盖持久会话与会话管理。

### 2.2 Control 平面

`controlSchemas.ts` 明确把宿主协议做成：

- `control_request`
- `control_response`
- `control_cancel_request`

而且 `initialize` 不是薄薄一层配置，它本身就携带：

- hooks
- sdk MCP servers
- `systemPrompt`
- `appendSystemPrompt`
- agents
- prompt suggestions
- agent progress summaries

### 2.3 Event 平面

`coreSchemas.ts` 表明宿主收到的不是“最终回答”，而是一整族运行时事件，包括：

- `SDKMessage`
- `task_started`
- `task_progress`
- `task_notification`
- `system:init`
- `session_state_changed`

### 2.4 Remote 平面

`connectRemoteControl(...)`、`StructuredIO`、`RemoteIO` 三者共同表明，Claude Code 还支持把 query/event/control 搬到远程会话里持续运行。

## 3. 接入矩阵

| 接入面 | 主要入口 | 作用 | 关键边界 |
| --- | --- | --- | --- |
| 单轮调用 | `query(...)` | 一次 prompt 驱动的 runtime 入口 | 不等于完整宿主协议 |
| 持久会话 | `unstable_v2_createSession` / `resumeSession` | 多轮状态连续性 | `unstable_v2_*` 说明仍在演进 |
| 会话读写 | `getSessionMessages` / `listSessions` / `forkSession` 等 | 会话资产管理 | 多个函数当前在提取树里仍是 stub |
| 宿主控制 | `control_request` / `control_response` | 中断、授权、设置、扩展、恢复治理 | 需要双端闭环 |
| 事件消费 | `SDKMessage` + `task_*` | 观察执行过程与状态变化 | 不能误写成 answer stream |
| 远程桥接 | `connectRemoteControl(...)` | 保持远程会话连续性 | 与普通 transport 不是同一层 |
| 传输层 | `StructuredIO` / `RemoteIO` | 本地结构化 IO 与远程 transport | transport plane 不等于 control plane |

## 4. 为什么 `initialize` 比看上去更重要

很多人会把 `initialize` 当成“开会话前先配一下”。

但从字段看，它实际上控制了五件大事：

1. hook 路由
2. MCP 装配
3. prompt 注入
4. agent 注入
5. 输出提示与摘要行为

所以 Claude Code 的 prompt、agents、MCP、hooks 并不是四个彼此分离的子系统，而是在 `initialize` 这个装配点收束。

## 5. 为什么 control protocol 比普通 RPC 更宽

`StructuredIO` 里专门处理了：

- pending request
- duplicate control response
- resolved tool use IDs
- unified outbound ordering
- permission response 注入

这说明 Claude Code 的宿主协议不是“请求一下，返回一个 JSON”。  
它要维持的是：

- 时序一致性
- 权限生命周期
- 消息队列顺序
- 重复响应防护

## 6. 为什么 session surface 很关键

如果只有 `query()`，宿主能做的是“调用一下 Claude Code”。

有了 session 系列 API，宿主才真的能做：

- 会话浏览
- 会话恢复
- 会话命名和打标
- 会话 fork
- 长流程调试

也就是说，Claude Code 对外暴露的是会话资产，而不只是回答文本。

## 7. 为什么 remote control 不是 transport 包装

`connectRemoteControl(...)` 返回的句柄明确要求宿主：

- `write(msg: SDKMessage)`
- `sendResult()`
- 消费 `inboundPrompts()`
- 消费 `controlRequests()`

这意味着 remote control 的本质不是“远程收发文本”，而是：

- 把 query() 产生的 event 流写回远程会话
- 把远程用户输入重新送回本地 query runtime
- 在父进程维持 session 连续性

## 8. 最小接入策略

### 8.1 只想做本地自动化

优先理解：

- `query(...)`
- `initialize`
- `control_request` / `control_response`
- `SDKMessage`

### 8.2 想做 IDE / host integration

还需要补上：

- `StructuredIO`
- 事件流消费
- snapshot / recovery
- session 管理面

### 8.3 想做远程协作或云端宿主

还需要补上：

- `connectRemoteControl(...)`
- `RemoteIO`
- `worker_status` / `external_metadata`
- adapter subset 与恢复路径

## 9. 三个常见误读

1. 把 SDK 写成“answer stream”
2. 把 control protocol 写成“普通 RPC”
3. 把 remote 接入写成“transport 适配”

这三个误读都会让 Claude Code 看起来比真实设计更薄。

## 10. 一句话总结

Claude Code 的宿主接入面不是一个 `query()` 函数，而是一套由 session、control、event 与 remote continuity 共同构成的多平面 runtime protocol。
