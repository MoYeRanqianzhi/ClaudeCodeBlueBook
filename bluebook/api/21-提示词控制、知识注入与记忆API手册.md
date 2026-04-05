# 提示词控制、知识注入与记忆 API 手册

这一章回答四个问题：

1. Claude Code 通过哪些正式表面允许你控制 prompt。
2. 规则层、记忆层、附件层分别通过什么机制注入上下文。
3. 哪些是公开主路径，哪些更接近 runtime 内部能力。
4. 宿主或高级使用者应如何选择这些表面。

## 1. 先说结论

Claude Code 至少暴露了五类与“提示词和知识注入”相关的正式表面：

1. CLI flags：
   - `--system-prompt`
   - `--append-system-prompt`
   - `--system-prompt-file`
   - `--append-system-prompt-file`
   - `--add-dir`
2. SDK initialize：
   - `systemPrompt`
   - `appendSystemPrompt`
   - `agents`
   - `sdkMcpServers`
3. agent / skill / frontmatter：
   - custom agent `getSystemPrompt()`
   - skill frontmatter
   - `.claude/commands` / `.claude/agents` / `.claude/skills`
4. 规则与记忆文件：
   - `CLAUDE.md`
   - `CLAUDE.local.md`
   - typed memory / `MEMORY.md`
5. 运行时附件：
   - nested memory
   - relevant memories
   - team context
   - mailbox
   - plan / auto mode reminders

代表性证据：

- `claude-code-source-code/src/main.tsx:976-988`
- `claude-code-source-code/src/main.tsx:1343-1387`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-75`
- `claude-code-source-code/src/utils/systemPrompt.ts:41-122`
- `claude-code-source-code/src/context.ts:155-188`
- `claude-code-source-code/src/utils/claudemd.ts:1-26`
- `claude-code-source-code/src/utils/attachments.ts:817-913`

## 2. CLI 表面：最直接的 prompt 控制入口

从 `main.tsx` 可以确认，CLI 级正式入口至少包括：

- `--system-prompt`
- `--append-system-prompt`
- 对应 file 版本
- `--add-dir`
- `--mcp-config`
- `--agents`
- `--plugin-dir`

证据：

- `claude-code-source-code/src/main.tsx:976-988`
- `claude-code-source-code/src/main.tsx:1343-1387`

它们的职责并不相同：

1. `--system-prompt`
   - 更接近完全替换或高度主导本轮角色说明。
2. `--append-system-prompt`
   - 更适合补充约束，不破坏默认前缀结构。
3. `--add-dir`
   - 让额外目录参与 `CLAUDE.md` / `.claude/*` 发现。

更稳妥的使用方式通常是：

- 规则层用 `CLAUDE.md`
- 一次性任务补充用 `append-system-prompt`
- 只有明确要重定义角色时才用 `system-prompt`

## 3. SDK initialize：宿主控制的正式协议面

`SDKControlInitializeRequestSchema` 明确允许宿主传入：

- `hooks`
- `sdkMcpServers`
- `jsonSchema`
- `systemPrompt`
- `appendSystemPrompt`
- `agents`
- `promptSuggestions`
- `agentProgressSummaries`

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-75`

这说明 SDK 宿主并不是只能喂一个 user prompt，它还能在初始化时决定：

- 额外 system prompt
- 追加 prompt
- agent definition
- SDK-side MCP server

也就是说，Claude Code 的宿主集成面天然支持：

- prompt contract 注入

而不是仅支持：

- 对话输入

## 4. agent / skill / frontmatter：把 prompt 做成可组合 artifact

`buildEffectiveSystemPrompt()` 说明 agent prompt 会作为正式层参与优先级合并。  
此外，`markdownConfigLoader.ts` 又说明 `.claude/commands`、`.claude/agents`、`.claude/skills` 都是可发现的 markdown artifact。

证据：

- `claude-code-source-code/src/utils/systemPrompt.ts:41-122`
- `claude-code-source-code/src/utils/markdownConfigLoader.ts:28-46`
- `claude-code-source-code/src/utils/markdownConfigLoader.ts:108-140`

这意味着 Claude Code 的 prompt surface 不只是字符串字段，还包括：

- agent definition
- skill frontmatter
- command prompt artifact

这是它和“单一 system prompt 产品”的一个关键区别。

## 5. 规则与记忆文件：正式但分层的知识注入面

`context.ts` 明确把 `CLAUDE.md` 注入到 user context。  
`claudemd.ts` 又定义了 managed/user/project/local 的加载顺序。  
`memdir.ts` 则定义了 typed memory / `MEMORY.md` 入口模型。

证据：

- `claude-code-source-code/src/context.ts:155-188`
- `claude-code-source-code/src/utils/claudemd.ts:1-26`
- `claude-code-source-code/src/memdir/memdir.ts:199-260`

因此，知识注入面至少还包括：

1. 规则文件：
   - 协作约束、代码库习惯、团队规范
2. 持久记忆文件：
   - 跨会话长期知识
3. session memory：
   - 当前会话连续性

其中只有前两类更接近“用户可显式设计的知识 API”；  
session memory 更像：

- runtime 提供的会话连续性机制

## 6. 附件层：高波动知识的晚绑定注入 API

`attachments.ts` 统一注册并生成各种 attachment：

- nested memory
- dynamic skill
- skill listing
- plan / auto mode
- teammate mailbox
- team context

证据：

- `claude-code-source-code/src/utils/attachments.ts:817-913`

更进一步，relevant memories 是异步预取并按 budget 注入：

- `claude-code-source-code/src/utils/attachments.ts:2245-2424`
- `claude-code-source-code/src/utils/attachments.ts:2520-2540`

这类表面和 CLI flags 的不同在于：

- 它们不是“你显式传进来的 prompt 文本”
- 而是 runtime 在适当时机注入的结构化知识提醒

## 7. 会话与状态 API 也会暴露知识面线索

`get_context_usage` 的 response 不只给 token 统计，还包含：

- `memoryFiles`

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:175-220`

此外，SDK V2 入口还公开了：

- `unstable_v2_createSession`
- `unstable_v2_resumeSession`
- `unstable_v2_prompt`
- `getSessionMessages`
- `listSessions`
- `getSessionInfo`

证据：

- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:124-260`

这说明知识层并不只是输入问题，也和：

- session continuity
- context accounting
- transcript replay

直接相关。

## 8. 可用性边界

需要明确三点：

1. CLI flags 和 control initialize 字段属于正式公开表面。
2. `CLAUDE.md` / `.claude/*` 规则系统也属于正式主路径。
3. session memory、relevant memories、部分 attachment 行为更接近 runtime 内部或 gated 机制，不应直接写成“所有宿主都可稳定依赖”的公共承诺。

## 9. 推荐选型

如果你的目标是：

1. 固化团队/项目规范：
   - 优先 `CLAUDE.md` / `.claude/*`
2. 临时补充本次任务约束：
   - 优先 `append-system-prompt`
3. 做宿主级系统注入：
   - 用 SDK initialize 的 `systemPrompt` / `appendSystemPrompt`
4. 维护跨会话长期知识：
   - 用 typed memory
5. 维护当前长会话连续性：
   - 让 session memory 负责，不要自己手搓超长摘要 prompt

## 10. 一句话总结

Claude Code 的 prompt 与知识注入 API，不是一个字段，而是一组分层表面：CLI、SDK initialize、agent/skill artifact、规则文件、记忆文件和运行时附件共同组成了它的上下文控制面。
