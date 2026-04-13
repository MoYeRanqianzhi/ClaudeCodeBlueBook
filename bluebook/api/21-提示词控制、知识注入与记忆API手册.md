# 提示词控制、知识注入与记忆 API 手册

> Evidence mode
> - 当前 worktree 仍是 `mirror absent / public-evidence only`。
> - 更稳的最小读法，不是把所有 memory / attachment surface 都写成同级 `host-facing API`，而是先分三层：`host-facing formal surfaces`、`context artifacts`、`runtime carriers / projections`。
> - 除非 `guides/102` 或更高 owner 另行 promotion，本页不会把 `session memory / relevant memories / team context / mailbox / auto reminders` 写成“所有宿主都可稳定依赖”的公共承诺。

这一章回答四个问题：

1. Claude Code 通过哪些正式表面允许你控制 prompt。
2. 规则层、记忆层、附件层分别通过什么机制注入上下文。
3. 哪些是公开主路径，哪些更接近 runtime 内部能力。
4. 宿主或高级使用者应如何选择这些表面。

## 1. 先说结论

更稳的最小分层，不是“五类同级正式 API”，而是三种不同承认等级的表面：

1. `host-facing formal surfaces`
   - CLI flags
   - SDK initialize fields
   - agent / skill / frontmatter artifact
2. `context artifacts`
   - `CLAUDE.md`
   - `CLAUDE.local.md`
   - typed memory / `MEMORY.md`
3. `runtime carriers / projections`
   - session memory
   - nested memory / relevant memories
   - team context / mailbox / plan / auto mode reminders

如果继续把这三层压成 later maintainer 可直接复查的一张最小表，也只先问四格：

| surface family | 代表对象 | 更稳的读法 | 不该偷升成什么 |
|---|---|---|---|
| `host-facing formal surface` | CLI flags、SDK initialize、agent prompt artifact | 宿主可显式调用或配置的控制面 | 自动等于全部 runtime 上下文 |
| `context artifact` | `CLAUDE.md`、typed memory、`MEMORY.md` | 项目/用户侧可设计的上下文资产 | 自动等于宿主公开 API 或 host truth signer |
| `runtime carrier` | session memory、team context、mailbox | continuation carrier / late-bound context mover | admissible continuation witness |
| `runtime projection` | relevant memories、plan reminder、auto reminder | relevance / receipt-grade projection | 稳定公共 contract |

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

## 5. 规则与记忆文件：`context artifact`，不自动等于 `host-facing API`

`context.ts` 明确把 `CLAUDE.md` 注入到 user context。  
`claudemd.ts` 又定义了 managed/user/project/local 的加载顺序。  
`memdir.ts` 则定义了 typed memory / `MEMORY.md` 入口模型。

证据：

- `claude-code-source-code/src/context.ts:155-188`
- `claude-code-source-code/src/utils/claudemd.ts:1-26`
- `claude-code-source-code/src/memdir/memdir.ts:199-260`

因此，更稳的写法不是把它们直接并入“正式宿主 API”，而是先把它们读成：

1. 规则文件：
   - 协作约束、代码库习惯、团队规范
   - 更像 `rule artifact`
2. 持久记忆文件：
   - 跨会话长期知识
   - 更像 `durable context artifact`
3. session memory：
   - 当前会话连续性
   - 更像 `continuation carrier`

其中前两类更接近“用户或项目可显式设计的上下文资产”；
session memory 更像：

- runtime 提供的会话连续性机制

更硬一点说，`CLAUDE.md` 与 typed memory 也不该被直接写成“宿主现在能稳定调哪个 API 字段”；它们首先是被 runtime 消费的 context artifact，是否升级成 host-facing truth，还要看更上游 owner 有没有给出 promotion。

## 6. 附件层：高波动知识的晚绑定 `carrier / projection`

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

所以更稳的默认口径不是“附件 API 很多”，而是：

- nested memory 更像路径条件化的 context carrier
- relevant memories 更像 relevance projection
- team context / mailbox 更像协作态的 late-bound carrier
- plan / auto reminders 更像控制面 reminder，而不是独立 signer

若一条分析离开了这些最低口径，开始直接把 mailbox、team context 或 reminder 写成宿主稳定 ABI，本页就已经把 carrier 偷升成了 host-facing truth。

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

但这仍不等于“这些对象都属于同一等级的公开 API”。更稳的说法是：它们暴露了 context accounting 与 continuity 的线索，却未自动把每一种内部 carrier 都升格成所有宿主都该依赖的 formal contract。

## 8. 可用性边界

需要明确四点：

1. CLI flags 和 control initialize 字段属于正式公开表面。
2. agent / skill / frontmatter artifact 也更接近正式 prompt control surface。
3. `CLAUDE.md` / `.claude/*` / typed memory 更稳地属于 `context artifact`，而不是与 CLI/SDK 完全同级的 host-facing ABI。
4. session memory、relevant memories、team context、mailbox 与 reminder surface 更接近 runtime 内部或 gated `carrier / projection`，不应直接写成“所有宿主都可稳定依赖”的公共承诺。

## 9. 推荐选型

如果你的目标是：

1. 固化团队/项目规范：
   - 优先 `CLAUDE.md` / `.claude/*`
2. 临时补充本次任务约束：
   - 优先 `append-system-prompt`
3. 做宿主级系统注入：
   - 用 SDK initialize 的 `systemPrompt` / `appendSystemPrompt`
4. 维护跨会话长期知识：
   - 用 typed memory 一类 `durable context artifact`
5. 维护当前长会话连续性：
   - 让 session memory 一类 `continuation carrier` 负责，不要自己手搓超长摘要 prompt，也不要把 summary / attachment 偷当 witness

## 10. 第一性原理与苏格拉底自检

如果继续从第一性原理追问，本页最该反复问的不是“有多少 memory 功能”，而是：

1. 删掉这个 surface 后，宿主失去的是稳定控制能力，还是只失去一层提醒/搬运便利。
2. later consumer 若只拿到这个 surface，是否还得重答 `world-definition / tool-legality / next-action search`。
3. 这个 surface 是在签当前 truth，还是只在搬运已签过的 context。

若答案分别落在“只失去便利 / 仍要重答 / 只在搬运”，那它就更接近 `carrier / projection`，不该被写成 formal API。

## 11. 一句话总结

Claude Code 的 prompt 与知识注入控制面，不是一个字段，也不是一堆同级 API；更稳的读法是：CLI / SDK / agent artifact 负责显式控制，`CLAUDE.md` 与 typed memory 属于 `context artifact`，session memory 与 attachments 更接近 `carrier / projection`。
