# 会话持久化、TaskOutput 与 Sidechain 恢复图

这一章回答六个问题：

1. Claude Code 的持久化真相到底是什么。
2. transcript、sidechain transcript、task output 为什么不能混成一层。
3. `resume` 到底恢复了哪些状态，不只是消息。
4. CCR v1 ingress、CCR v2 internal-events 与本地 JSONL 是什么关系。
5. metadata、content replacement、context-collapse 为什么也要持久化。
6. 这套设计为什么说明 Claude Code 是可恢复 runtime，而不是聊天记录播放器。

## 1. 先说结论

Claude Code 的持久化真相至少分成四层：

1. 主会话 transcript
2. subagent / task sidechain transcript
3. task output sidecar
4. session metadata / snapshots

更准确地说：

- transcript 负责可恢复对话轨迹
- sidechain transcript 负责隔离子会话与后台任务
- `TaskOutput` 负责长输出与实时进度
- metadata / snapshots 负责把“恢复后仍应成立的运行时状态”带回来

所以 `resume` 恢复的不是“历史聊天”，而是：

- 消息链
- file history
- attribution
- context-collapse
- content replacements
- todos
- agent / mode / worktree
- session file ownership

关键证据：

- `claude-code-source-code/src/utils/sessionStorage.ts:232-258`
- `claude-code-source-code/src/utils/sessionStorage.ts:1408-1474`
- `claude-code-source-code/src/utils/sessionStorage.ts:1559-1689`
- `claude-code-source-code/src/utils/sessionStorage.ts:3479-3810`
- `claude-code-source-code/src/utils/sessionRestore.ts:99-157`
- `claude-code-source-code/src/utils/sessionRestore.ts:409-545`
- `claude-code-source-code/src/utils/conversationRecovery.ts:152-273`
- `claude-code-source-code/src/utils/conversationRecovery.ts:456-577`
- `claude-code-source-code/src/utils/task/TaskOutput.ts:32-388`
- `claude-code-source-code/src/tasks/LocalMainSessionTask.ts:107-120`
- `claude-code-source-code/src/tasks/LocalMainSessionTask.ts:358-416`
- `claude-code-source-code/src/tasks/LocalMainSessionTask.ts:254-281`

## 2. transcript 不是唯一真相，而是“轨迹层真相”

`recordTranscript(...)` 的职责并不是盲目 append。
它至少还在维护：

- dedup
- parent chain
- compact boundary 截断
- 只追踪前缀型已记录消息

这说明 transcript 的职责不是“把所有东西存下来”，而是：

- 维持一条可恢复、可继续的消息拓扑

同样地，`recordSidechainTranscript(...)` 也不是为了调试，而是正式的 sidechain 结构。
它让：

- 后台主会话
- subagent
- workflow

都能写到自己的独立 transcript，而不污染主线程会话。

## 3. `TaskOutput` 是第二条真相链，而不是 transcript 附件

`TaskOutput` 的设计重点很明确：

- file mode：stdout/stderr 直接进文件，JS 只轮询 tail 做 progress
- pipe mode：才走内存 buffer，必要时 spill 到磁盘

也就是说，长输出的单一真相源不是 transcript，而是 task output file。

这背后的原因很务实：

1. transcript 适合恢复语义，不适合承接大块 stdout
2. 任务进度需要 tail 轮询和字节/行数统计
3. 宿主要拿到 `outputPath` 后按需读取，而不是把整段输出塞回对话

所以 `TaskOutput` 与 transcript 之间的关系应该理解成：

- 平行持久化
- 在 task-notification 处重新关联

而不是“task output 是 transcript 的一个字段”。

## 4. metadata / snapshots 为什么也是恢复真相的一部分

如果只恢复消息，不恢复 metadata/snapshots，会直接丢失 runtime 真相。

当前可见的持久化对象至少包括：

- `custom-title`
- `tag`
- `agent-*`
- `mode`
- `worktree-state`
- `pr-link`
- file history snapshots
- attribution snapshots
- context-collapse commits
- context-collapse snapshot
- content replacement records

尤其要注意两类：

### 4.1 context-collapse

resume 恢复的不是“压缩前完整历史”，而是“当前有效上下文工作集”。
因此 context-collapse commit log 与 staged snapshot 必须被重建。

### 4.2 content replacements

tool result preview / content replacement 不只是 UI 优化，它会影响 prompt cache 稳定性和恢复后窗口形态。
所以它也必须按 sessionId / agentId 重新带回来。

## 5. resume 是两阶段恢复，不是一条函数

更准确的顺序是：

1. hydrate
2. deserialize / recovery
3. state restore
4. session adoption

### 5.1 hydrate

底层 transport 可能是三条：

- 本地 JSONL
- v1 session ingress
- CCR v2 internal-events

但不管来源是什么，都会先落回本地 transcript 文件树。

### 5.2 deserialize / recovery

`loadConversationForResume(...)` 会：

- load full log
- 反序列化消息
- 过滤 unresolved tool uses / orphan thinking / 空 assistant
- 检测 interrupted turn
- 必要时注入 synthetic continuation prompt
- 追加 session-start hook messages

### 5.3 state restore

`restoreSessionStateFromLog(...)` 再恢复：

- file history
- attribution
- context-collapse
- todos

### 5.4 session adoption

`processResumedConversation(...)` 再负责：

- switch session
- 恢复 agent / model
- 恢复 worktree
- 恢复 mode
- 接管原 transcript file

所以 resume 真正恢复的是“运行中的会话机器”，不是“一个历史数组”。

## 6. `/resume`、`--continue`、`--fork-session` 的差别

这三者最容易被混写。

### 6.1 `/resume`

更像 mid-session 或交互式会话切换。
它需要处理：

- 当前会话清理
- 新会话文件接管
- 前台 state 替换

### 6.2 `--continue`

更像启动时把旧会话重新接起来。
核心是：

- 继续沿用旧 session identity
- 后续继续写同一 transcript

### 6.3 `--fork-session`

这里不是“接管旧文件”，而是：

- 复制消息与恢复态
- 但保留新 sessionId

所以 fork 的语义不是恢复同一条会话，而是从既有 runtime truth 派生一条新分支。

## 7. metadata 为什么要 tail-optimized

这是很容易被忽略的工程点。

Claude Code 会在 exit / compact 后把 metadata 重新写到 EOF，原因不是美观，而是：

- 轻量 resume / list sessions 只扫头尾
- title / tag / mode / worktree 必须能在头尾命中
- 否则就要全量解析大文件

因此 metadata 是恢复体验的一部分，而不是装饰信息。

## 8. 背景主会话与 subagent 其实共享同一模型

`LocalMainSessionTask` 很能说明这个问题：

1. 背景主会话先把现有 messages 写进 sidechain transcript
2. 后续事件再增量写 sidechain transcript
3. task output symlink 指向独立 transcript / output path
4. task-notification 把 `outputPath` 暴露给宿主

这证明后台主会话不是 REPL 的附属 UI 功能，而是正式 sidechain runtime。

同样的模型也适用于：

- LocalAgentTask
- RemoteAgentTask
- forked agent

## 9. 对蓝皮书的启发

后续只要写恢复/持久化，就必须先分清四件事：

1. 这说的是 transcript 轨迹，还是 task output。
2. 这说的是主线程会话，还是 sidechain 会话。
3. 这说的是 transport，还是恢复语义。
4. 这说的是消息层，还是 metadata/snapshot 层。

如果这四个问题没拆开，最后一定会把 Claude Code 误写成“把 JSONL 读回来”。

## 10. 一句话总结

Claude Code 的持久化不是单一 transcript，而是一套由 transcript、sidechain、task output、metadata/snapshots 共同组成的可恢复 runtime 状态面。
