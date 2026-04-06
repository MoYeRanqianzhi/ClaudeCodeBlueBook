# 命令、工具、会话、宿主与协作 API 全谱系

这一章回答四个问题：

1. Claude Code 的 API 全谱系到底覆盖哪些对象。
2. 命令、工具、会话、宿主控制、远程与协作之间怎样串成一条完整链。
3. 为什么这些 API 不是平行孤岛，而是共享同一 runtime contract。
4. 不同角色最小该掌握哪几条谱系。

## 0. 代表性源码锚点

- `claude-code-source-code/src/types/command.ts:25-57`
- `claude-code-source-code/src/types/command.ts:74-152`
- `claude-code-source-code/src/tools.ts:253-367`
- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:103-272`
- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:377-440`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-519`
- `claude-code-source-code/src/cli/structuredIO.ts:59-173`
- `claude-code-source-code/src/cli/remoteIO.ts:127-238`
- `claude-code-source-code/src/utils/sdkEventQueue.ts:8-126`
- `claude-code-source-code/src/tools/TaskCreateTool/TaskCreateTool.ts:48-1`
- `claude-code-source-code/src/tools/SendMessageTool/SendMessageTool.ts:520-917`
- `claude-code-source-code/src/utils/systemPrompt.ts:29-123`
- `claude-code-source-code/src/coordinator/coordinatorMode.ts:120-300`
- `claude-code-source-code/src/utils/attachments.ts:3521-3685`
- `claude-code-source-code/src/main.tsx:1497-1520`
- `claude-code-source-code/src/main.tsx:1635-1688`

## 1. 先说结论

Claude Code 的 API 全谱系至少有七条：

1. 命令谱系
2. 工具与权限谱系
3. 会话与状态谱系
4. 宿主控制谱系
5. 远程与适配器谱系
6. Prompt / 知识 / 记忆谱系
7. 协作与生态谱系

它们共享的不是同一组函数名，而是同一套 runtime contract：

- 有明确角色
- 有明确能力边界
- 有明确状态写回
- 有明确失败与恢复语义

如果把 API 全谱系前门继续压成最短公式，也只剩四句：

1. `same-world test`
   - 哪些 API 在帮助同一个请求对象、继续对象和 handoff 对象成立。
2. `decision window`
   - 哪些 API 在帮助宿主解释当前继续是否仍有制度收益。
3. `truth ladder + consumer subset`
   - 哪些 API 在宣布 truth，哪些只暴露宿主子集与适配器子集。
4. `failure semantics + rollback object`
   - 哪些 API 在宣布失败语义和回退边界，而不是只提供日志或文本结果。

## 2. 命令谱系

命令并不是“用户手动触发的一些别名”，而是一套带元数据的正式 API 对象。

关键字段包括：

- `type`
- `availability`
- `isEnabled`
- `loadedFrom`
- `whenToUse`
- `allowedTools`
- `context`
- `agent`
- `effort`
- `getPromptForCommand(...)`

这说明命令谱系实际上横跨三类场景：

1. 纯交互命令
2. prompt 注入命令
3. 本地 / JSX / 插件 / skill 动态命令

## 3. 工具与权限谱系

工具谱系不是“模型能调哪些函数”，而是一套平台 ABI。

关键对象包括：

- `Tool`
- `ToolUseContext`
- `getTools(...)`
- `assembleToolPool(...)`
- deny / allow rules

其中最关键的两点是：

1. 工具在进入模型前就会被 deny rule 过滤。
2. built-in tools 与 MCP tools 会按 cache-stable order 重新排序和合并。

也就是说，工具谱系和权限谱系从一开始就是耦合的，而不是先给模型全量能力，再在调用时补拦截。

## 4. 会话与状态谱系

会话谱系至少有三层：

1. query / session runtime 入口：
   - `query`
   - `unstable_v2_createSession`
   - `unstable_v2_resumeSession`
   - `unstable_v2_prompt`
2. SDK session 资产入口：
   - `getSessionMessages`
   - `listSessions`
   - `getSessionInfo`
   - `renameSession`
   - `tagSession`
   - `forkSession`
3. 运行时状态入口：
   - transcript
   - `worker_status`
   - `external_metadata`
   - context usage
   - rewind / restore

这条谱系最重要的判断是：

- Claude Code 的 session 不是“聊天记录文件”，而是运行时状态与执行资产管理面。

## 5. 宿主控制谱系

宿主控制谱系至少包含：

- `initialize`
- `control_request`
- `control_response`
- `control_cancel_request`
- `SDKMessage`
- snapshot / recovery

它真正暴露的是：

1. 命令闭环
2. 事件时间线
3. 当前真相回写
4. 恢复后重建

所以宿主接入的不是简单 answer stream，而是 control-loop runtime。

如果宿主控制页还只被读成“SDK 能发什么消息”，就还没抓住这里真正值钱的东西：

- 这套谱系首先在保护 `same-world test`
- 然后在外化 `decision window`
- 最后才在交付 UI 可见结果

其中 `initialize` 特别关键，因为它会同时装配：

- hooks
- MCP servers
- prompt 注入
- agents
- prompt suggestions / progress summaries

也就是说，prompt、agents、hooks、MCP 在宿主侧不是分散配置，而是在控制谱系起点收束。

### 5.1 这里的 snapshot / recovery 不是可有可无的补充

如果只写 control 与 event，宿主仍然无法回答三个关键问题：

1. 当前 turn 现在是 `idle`、`running` 还是 `requires_action`
2. 当前 authoritative truth 是哪份 `worker_status` / `external_metadata`
3. 远程重连或 resume 之后，哪些状态需要从 transcript / session 资产面重建

所以 Claude Code 的宿主谱系至少同时包含：

- request / response 闭环
- 事件时间线
- 当前快照真相
- 恢复后的重建真相

## 6. 远程与适配器谱系

远程相关能力至少有三条实现路径：

1. `StructuredIO` / `RemoteIO`
2. bridge / remote control
3. direct connect / remote session manager

这里最重要的不是“都能远程”，而是：

- 它们共享控制语义
- 但支持面宽度不同

因此必须持续区分：

1. 协议全集
2. 主控制平面
3. 具体 adapter 子集

而 `connectRemoteControl(...)` 又进一步说明，remote 不是“远程 transport 包一下”，而是要求宿主能够：

- `write()` Claude Code 事件
- `sendResult()`
- 消费 `inboundPrompts()`

换句话说，远程控制本质上是在延长同一条 control-loop。

### 6.1 remote handle 本身已经说明它不是 transport wrapper

`connectRemoteControl(...)` 返回的句柄要求宿主能处理：

- `write(msg: SDKMessage)`
- `sendResult()`
- `sendControlRequest(...)`
- `sendControlResponse(...)`
- `sendControlCancelRequest(...)`
- `inboundPrompts()`
- `controlRequests()`
- `permissionResponses()`
- `onStateChange(...)`

这说明 remote 接入不是把文本搬到远端，而是把整条 control-loop 和状态迁移到远程 session。

## 7. Prompt / 知识 / 记忆谱系

Prompt 相关 API 绝不只是：

- `--system-prompt`

它至少还包括：

- `--append-system-prompt`
- SDK `initialize.systemPrompt`
- agent `getSystemPrompt()`
- skill `getPromptForCommand(...)`
- attachments
- `CLAUDE.md`
- relevant memories
- session memory

这条谱系说明，Claude Code 的 prompt 能力本质上是：

- 契约装配 API

而不是：

- 某段固定文案

## 8. 协作与生态谱系

协作谱系包括：

- coordinator prompt
- teammate addendum
- `team_context`
- `teammate_mailbox`
- `task_started`
- `task_progress`
- `task_notification`

生态谱系则包括：

- plugins
- marketplace
- MCPB
- channels
- LSP

这两条谱系合在一起，解释了为什么 Claude Code 不是“单 Agent + 一堆工具”，而是“可治理、可协作、可迁移的 runtime”。

## 9. 最小宿主闭环

对宿主开发者来说，最小可用闭环不是“一次 `query()` 调用”，而是五段：

1. 用 `initialize` 装配 prompt、hooks、agents、MCP。
2. 用 `query()` 或 session 入口驱动 runtime。
3. 处理 `control_request` / `control_response` / `control_cancel_request`。
4. 消费 `SDKMessage`、`task_*`、`session_state_changed` 等事件。
5. 在 remote / recovery 场景里继续处理状态回写与 `inboundPrompts()`。

## 10. 三种角色的最小阅读集

### 9.1 使用者

- `../05`
- `../08`
- `../guides/01`
- `../guides/02`
- `../guides/03`

### 9.2 宿主开发者

- `02`
- `09`
- `13`
- `14`
- `16`
- `17`
- `20`
- `23`

### 9.3 平台构建者

- `23`
- `24`
- `../architecture/18`
- `../architecture/19`
- `../architecture/30`
- `../philosophy/18`
- `../philosophy/19`
- `../philosophy/20`

## 11. 一句话总结

Claude Code 的 API 不是命令、工具、会话、宿主和协作几套平行列表，而是一条从角色合同到状态闭环再到治理边界的完整谱系。
