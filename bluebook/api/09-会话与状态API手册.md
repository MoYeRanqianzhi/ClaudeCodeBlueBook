# 会话与状态 API 手册

这一章回答四个问题：

1. Claude Code 的 session/state surface 到底暴露了哪些正式入口。
2. 哪些是 SDK 文档化能力，哪些在当前提取源码里只是声明而未落实现。
3. transcript、metadata、memory、rewind 如何给这些 API 提供后端支撑。
4. 为什么这些接口的本质不是“聊天历史查询”，而是运行时状态管理。

## 1. 先说结论

Claude Code 的会话与状态 API 至少分成两层：

1. SDK 入口层：`getSessionMessages`、`listSessions`、`getSessionInfo`、`renameSession`、`tagSession`、`forkSession`。
2. control protocol 层：`get_context_usage`、`rewind_files`、`seed_read_state`、`get_settings`。

但当前提取源码里有一个很重要的不对称：

- `agentSdkTypes.ts` 已经把 session API 的语义和签名写出来了。
- 同一文件里这些函数当前仍全部 `throw new Error('...not implemented in the SDK')`。
- `controlSchemas.ts` 则已经给出了很完整的请求/响应 schema，且能直接对照 runtime 行为。

这意味着蓝皮书必须把两层事实分开：

1. “文档化意图”已经存在。
2. “当前提取树里可直接看到的 SDK 实现”并不完整。

关键证据：

- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:167-272`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:175-519`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1812-1851`
- `claude-code-source-code/src/utils/sessionStorage.ts:198-258`
- `claude-code-source-code/src/utils/sessionStorage.ts:1408-1533`
- `claude-code-source-code/src/utils/sessionStorage.ts:2690-2817`
- `claude-code-source-code/src/utils/sessionStorage.ts:3842-3915`
- `claude-code-source-code/src/utils/sessionStorage.ts:4739-5105`
- `claude-code-source-code/src/utils/listSessionsImpl.ts:439-454`
- `claude-code-source-code/src/utils/claudemd.ts:1-26`
- `claude-code-source-code/src/services/SessionMemory/sessionMemory.ts:76-452`
- `claude-code-source-code/src/utils/fileHistory.ts:45-320`
- `claude-code-source-code/src/cli/print.ts:4520-4565`

## 2. SDK 入口层：已经声明的 session API

### 2.1 `getSessionMessages(sessionId, options?)`

文档字符串给出的语义很明确：

- 从 session 的 JSONL transcript 读取消息。
- 通过 `parentUuid` 链构建会话链。
- 默认返回 user/assistant 消息，`includeSystemMessages` 可额外包含 system。
- 支持 `dir`、`limit`、`offset`。

但在当前提取源码里，函数体仍是 stub。

证据：

- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:167-183`

### 2.2 `listSessions(options?)`

文档字符串给出的语义包括：

- 指定 `dir` 时列出该项目目录及其 git worktrees 的会话。
- 不指定时可跨项目列出。
- 支持 `limit` / `offset` 分页。

而 runtime 侧的 `listSessionsImpl(...)` 也能看到对应设计：

- 有 `dir`、`limit`、`offset`、`includeWorktrees`。
- 当有分页时先做 stat-only 候选排序，再读有限量内容。
- 无分页时直接 read-all-then-sort。

证据：

- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:185-208`
- `claude-code-source-code/src/utils/listSessionsImpl.ts:439-454`

### 2.3 `getSessionInfo(sessionId, options?)`

这个接口的文档语义是：

- 只读单个 session 文件，不像 `listSessions` 那样扫全目录。
- 文件不存在、是 sidechain session、或拿不到可提取 summary 时返回 `undefined`。

其返回类型 `SDKSessionInfo` 的字段已经在 schema 里展开：

- `sessionId`
- `summary`
- `lastModified`
- `fileSize`
- `customTitle`
- `firstPrompt`
- `gitBranch`
- `cwd`
- `tag`
- `createdAt`

证据：

- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:210-224`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1812-1851`

### 2.4 `renameSession(sessionId, title, options?)`

文档字符串已经说明它的产品语义：

- 向 session JSONL 追加一条 custom-title entry。
- 这是 metadata mutation，不是整文件重写。

从 `sessionStorage.ts` 的 metadata 持久化模式看，这类设计是成立的：

- title/tag/PR link 都按 append-only 元信息写入 transcript。
- compaction 后还会重新 append metadata，保证 `/resume` 的 tail window 能看见它。

证据：

- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:226-238`
- `claude-code-source-code/src/utils/sessionStorage.ts:2753-2817`

### 2.5 `tagSession(sessionId, tag, options?)`

语义同样很清晰：

- tag 可设置或清空。
- 当前 session 的 tag 会被缓存到内存态，保证界面与后续 re-append 可立即可见。

证据：

- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:240-252`
- `claude-code-source-code/src/utils/sessionStorage.ts:2690-2699`
- `claude-code-source-code/src/utils/sessionStorage.ts:2731-2737`

### 2.6 `forkSession(sessionId, options?)`

这里最值得注意的不是“新建会话”，而是它对 fork 语义的定义：

- 复制 transcript 消息到新 session。
- 重新映射消息 UUID。
- 保留 `parentUuid` 链。
- 支持 `upToMessageId` 从对话中的某一点分叉。
- fork 后不复制 undo history。

这已经说明 Claude Code 把 session fork 当作状态分叉，而不是简单复制聊天内容。

证据：

- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:254-272`

## 3. runtime 后端如何支撑这些 session API

### 3.1 transcript 是 append-only JSONL，而不是内存对话缓存

核心路径模型包括：

- `getTranscriptPath()`
- `getTranscriptPathForSession(sessionId)`
- `getAgentTranscriptPath(agentId)`

此外子代理 transcript 会写到 `sessionId/subagents/...` 树下。

证据：

- `claude-code-source-code/src/utils/sessionStorage.ts:198-258`

### 3.2 `recordTranscript(...)` 维护的是链，不是平铺日志

它会：

1. 清洗消息。
2. 读取当前 session 已有 UUID 集。
3. 仅写入新消息。
4. 维持 parent chain。
5. 对 compact 后的 boundary 做特殊处理，避免链断裂或指回旧 UUID。

证据：

- `claude-code-source-code/src/utils/sessionStorage.ts:1408-1449`
- `claude-code-source-code/src/utils/sessionStorage.ts:3842-3867`

### 3.3 session metadata 被当成恢复索引而非装饰

当前可见的 metadata surface 至少包括：

- `tag`
- custom title
- agent name / color / mode
- worktree session
- PR link
- lastPrompt

而 `readLiteMetadata(...)` 只读 JSONL 头尾大约 64KB，就能提取：

- `firstPrompt`
- `gitBranch`
- `isSidechain`
- `projectPath`
- `teamName`
- `customTitle`
- `summary`
- `tag`
- `agentSetting`
- PR 字段

证据：

- `claude-code-source-code/src/utils/sessionStorage.ts:2690-2817`
- `claude-code-source-code/src/utils/sessionStorage.ts:4739-4813`

### 3.4 `listSessions` 背后的优化目标是“可恢复检索”，不是“扫完整日志”

`getSessionFilesLite(...)` 与 `enrichLogs(...)` 的设计说明：

- 候选集先靠 stat 拿到。
- 再按需补全 head/tail metadata。
- sidechain 和 team session 会被过滤掉。

所以 `listSessions` 的目标不是全文检索，而是快速恢复可见的顶层会话空间。

证据：

- `claude-code-source-code/src/utils/sessionStorage.ts:4970-5105`
- `claude-code-source-code/src/utils/listSessionsImpl.ts:439-454`

## 4. control protocol 层的状态 API

### 4.1 `get_context_usage`

这是 Claude Code 最完整的 runtime state introspection surface 之一。

它返回的不只是 token 总数，还包括：

- `categories`
- `totalTokens` / `maxTokens` / `rawMaxTokens` / `percentage`
- 可视化用 `gridRows`
- `model`
- `memoryFiles`
- `mcpTools`
- `deferredBuiltinTools`
- `systemTools`
- `systemPromptSections`
- `agents`
- `slashCommands`
- `skills`
- `autoCompactThreshold`
- `isAutoCompactEnabled`
- `messageBreakdown`
- `apiUsage`

从第一性原理看，它回答的是“当前工作集到底由什么构成”，而不是“当前对话用了多少 token”。

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:175-305`

### 4.2 `rewind_files`

这个接口说明 Claude Code 的回退面是文件级状态，而不是消息级删除。

schema 层给出的参数只有：

- `user_message_id`
- `dry_run`

返回值则强调：

- `canRewind`
- `error`
- `filesChanged`
- `insertions`
- `deletions`

而 runtime 侧 `handleRewindFiles(...)` 清楚显示：

- 先检查 file checkpointing 是否启用。
- 再检查该 message 是否存在可恢复 checkpoint。
- `dry_run` 只返回 diff stats。
- 真正 rewind 通过 `fileHistoryRewind(...)` 恢复文件。

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:308-328`
- `claude-code-source-code/src/cli/print.ts:4520-4565`
- `claude-code-source-code/src/utils/fileHistory.ts:63-78`

### 4.3 `seed_read_state`

这是一个非常典型的“状态修复式 API”。

它的作用不是读文件，而是：

- 向 `readFileState` cache 注入一条 `path + mtime` 记录。
- 解决先前 Read 因 snip 或上下文裁剪被移出后，后续 Edit 校验会误判的问题。
- 仍保留 mtime stale-check，不是无条件绕过验证。

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:351-360`

### 4.4 `get_settings`

这个接口暴露的是配置状态面，而不是静态配置文件内容。

它至少分成三层：

- `effective`: 磁盘 merge 后的有效配置。
- `sources`: 各来源原始配置，按低到高优先级排列。
- `applied`: 再经过 env override、session state、model default 后，真正会送到 API 的运行态值。

这也是为什么它不应被理解成“读取 settings.json”。

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:475-519`

## 5. 状态 API 之外，还有几层状态面

session/state surface 并不只存在于 SDK 和 control protocol。

源码里还至少能看到三层配套状态面：

1. 分层 memory：managed / user / project / local `CLAUDE.md`。
2. session memory：`{projectDir}/{sessionId}/session-memory/summary.md`。
3. file history：message 级 snapshot 与 rewind。

证据：

- `claude-code-source-code/src/utils/claudemd.ts:1-26`
- `claude-code-source-code/src/utils/permissions/filesystem.ts:258-270`
- `claude-code-source-code/src/services/SessionMemory/sessionMemory.ts:183-452`
- `claude-code-source-code/src/utils/fileHistory.ts:45-320`

这也解释了为什么 Claude Code 的状态 API 不能被缩写成“会话列表 + 历史消息”。

## 6. 从第一性原理看，这些 API 在解决什么

如果回到蓝皮书主线里的六个不可约问题，这组 API 其实分别在解决：

1. 观察：`get_context_usage` 让宿主看到当前工作集组成。
2. 记忆：`getSessionMessages`、`listSessions`、`getSessionInfo` 对外暴露可恢复历史。
3. 行动后的修复：`rewind_files` 把文件状态纳入可回退面。
4. 恢复：`forkSession`、`tagSession`、`renameSession` 让会话身份、分支与导航成为正式能力。
5. 稳定编辑：`seed_read_state` 维护读写校验链不断裂。
6. 控制：`get_settings` 把“当前实际生效配置”从黑盒变成可查询状态。

所以 Claude Code 的 session/state API 本质上是在暴露 runtime truth，而不是附带提供几个历史查询函数。

## 7. 可信边界与当前不足

必须明确四点：

1. `agentSdkTypes.ts` 中这些 session API 在当前提取树里仍是 stub，不能直接写成“已完整可调用”。
2. `SDKSessionInfoSchema` 描述了返回结构，但并不自动等于稳定承诺。
3. `rewind_files` 依赖 file checkpointing；而 SDK 场景下 checkpointing 还受环境变量控制。
4. memory、session memory、file history 虽然共同构成状态面，但它们不是同一层 API，不应混写成单一“会话系统”。

## 8. 相关章节

- 状态机制深挖：`../architecture/09-会话存储记忆与回溯状态面.md`
- 多 Agent 隔离编排：`../architecture/10-AgentTool与隔离编排.md`
- 第一性原理主线：`../06-第一性原理与苏格拉底反思.md`
- 状态设计哲学：`../philosophy/06-状态优先于对话.md`
