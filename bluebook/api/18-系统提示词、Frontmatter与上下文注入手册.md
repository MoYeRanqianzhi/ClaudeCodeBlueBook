# 系统提示词、Frontmatter 与上下文注入手册

这一章回答五个问题：

1. Claude Code 的“prompt 面”到底通过哪些正式入口暴露出来。
2. system prompt、append prompt、agent prompt、skill prompt、attachment 注入分别位于哪一层。
3. frontmatter 怎样把 prompt、tools、hooks、model、agent 装成统一声明面。
4. 为什么 Claude Code 的 prompt API 不是一个字符串参数，而是一组注入面。
5. 哪些部分应被视为稳定公共面，哪些更像 runtime 内部装配细节。

## 1. 先说结论

Claude Code 的 prompt 面不是单一 `systemPrompt: string`，而是至少六层注入面：

1. CLI/SDK 显式 prompt 注入：
   - `--system-prompt`
   - `--append-system-prompt`
   - SDK `initialize.systemPrompt`
   - SDK `initialize.appendSystemPrompt`
2. 主线程 agent prompt：
   - custom agent `getSystemPrompt()`
   - built-in agent `getSystemPrompt({ toolUseContext })`
3. skill / prompt command prompt：
   - `getPromptForCommand(...)`
   - frontmatter 决定 allowed tools / hooks / model / effort / context
4. 默认 system prompt sections：
   - environment
   - language
   - output style
   - memory
   - MCP instructions
   - session-specific guidance
5. attachment / reminder 注入：
   - agent list delta
   - deferred tools delta
   - MCP instructions delta
   - skill discovery
6. runtime 追加注入：
   - teammate addendum
   - proactive addendum
   - assistant addendum
   - memory prompt

所以 Claude Code 的 prompt API 更接近“上下文注入系统”，而不是“给模型塞一段咒语”。

关键证据：

- `claude-code-source-code/src/main.tsx:1343-1387`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-72`
- `claude-code-source-code/src/utils/systemPrompt.ts:27-121`
- `claude-code-source-code/src/constants/prompts.ts:444-579`
- `claude-code-source-code/src/skills/loadSkillsDir.ts:181-344`
- `claude-code-source-code/src/tools/AgentTool/loadAgentsDir.ts:474-731`
- `claude-code-source-code/src/utils/attachments.ts:1-260`

## 2. prompt 优先级与覆盖顺序

`buildEffectiveSystemPrompt(...)` 已经把优先级写得非常明确：

1. `overrideSystemPrompt`
2. coordinator prompt
3. main-thread agent prompt
4. custom system prompt
5. default system prompt
6. `appendSystemPrompt`

但还有两个容易漏掉的细节：

1. proactive 模式下，agent prompt 不是替换 default，而是追加在 default 之后。
2. built-in agent 和 custom agent 的取 prompt 方式不同，前者可读 `toolUseContext`，后者通常返回静态字符串。

证据：

- `claude-code-source-code/src/utils/systemPrompt.ts:27-121`

## 3. CLI / SDK 的显式注入面

### 3.1 CLI flags

`main.tsx` 显式支持：

- `--system-prompt`
- `--system-prompt-file`
- `--append-system-prompt`
- `--append-system-prompt-file`

并在启动阶段做：

- flag/file 互斥校验
- 文件读取
- teammate/proactive/assistant 追加注入

证据：

- `claude-code-source-code/src/main.tsx:1343-1387`
- `claude-code-source-code/src/main.tsx:2168-2208`

### 3.2 SDK initialize

SDK `initialize` 也把 prompt 面正式暴露给宿主：

- `systemPrompt`
- `appendSystemPrompt`
- `agents`
- `promptSuggestions`
- `agentProgressSummaries`

这意味着 SDK host 不只是“提交用户消息”，也能参与 runtime prompt 装配。

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-72`

## 4. 默认 system prompt 不是一段大字符串，而是分段装配

`constants/prompts.ts` 说明默认 system prompt 至少由三类分段组成：

1. 静态段：
   - intro
   - system
   - doing tasks
   - actions
   - using your tools
   - tone and style
   - output efficiency
2. 边界标记：
   - `SYSTEM_PROMPT_DYNAMIC_BOUNDARY`
3. 动态段：
   - session guidance
   - memory
   - language
   - output style
   - MCP instructions
   - scratchpad
   - token budget
   - brief/proactive 等

这直接说明 Claude Code 的 prompt 面是“分区装配”而不是“手写巨 prompt”。

证据：

- `claude-code-source-code/src/constants/prompts.ts:114-115`
- `claude-code-source-code/src/constants/prompts.ts:444-579`

## 5. Frontmatter 是 prompt API 的声明层

### 5.1 skills / prompt commands

`parseSkillFrontmatterFields(...)` 暴露出一组高度统一的字段：

- `allowed-tools`
- `argument-hint`
- `arguments`
- `when_to_use`
- `model`
- `disable-model-invocation`
- `hooks`
- `context`
- `agent`
- `effort`
- `shell`

随后 `createSkillCommand(...)` 再把这些字段转成真正的 prompt command。

这说明 prompt 不只是正文 markdown，还包括一整套声明式运行语义。
同时也要区分两种 markdown：

1. skill / slash command body
   - 通常展开成 task / user message 层
2. agent body
   - 进入 agent 的 system prompt 层

同样是 markdown artifact，但被注入到不同层，这正是 Claude Code prompt DSL 最关键的分层之一。

证据：

- `claude-code-source-code/src/skills/loadSkillsDir.ts:181-344`

### 5.2 agents

agent markdown / JSON 也有自己的 prompt-facing fields：

- `description`
- `prompt`
- `model`
- `effort`
- `permissionMode`
- `maxTurns`
- `tools`
- `disallowedTools`
- `skills`
- `initialPrompt`
- `mcpServers`
- `hooks`
- `memory`
- `isolation`

其中最关键的是：`getSystemPrompt()` 返回的并不总是原始 prompt，memory 开启时还会拼接 memory prompt。

证据：

- `claude-code-source-code/src/tools/AgentTool/loadAgentsDir.ts:474-731`

## 6. attachment / reminder 也是 prompt API

Claude Code 有一批重要上下文并不直接塞进 system prompt，而是通过 attachment / reminder 进入会话：

- agent list delta
- deferred tools delta
- MCP instructions delta
- skill discovery
- plan / task / todo / memory / IDE 选择等提醒

这背后至少有两个目的：

1. 减少 prompt cache bust
2. 把动态信息从静态 prefix 里拆出去

最典型的两个例子：

1. Agent list 改从 attachment 进，而不是内联在 tool description 里。
2. MCP instructions 改走 delta attachment，避免 late connect 直接改 system prompt。

证据：

- `claude-code-source-code/src/tools/AgentTool/prompt.ts:48-64`
- `claude-code-source-code/src/tools/ToolSearchTool/prompt.ts:24-45`
- `claude-code-source-code/src/constants/prompts.ts:345-358`
- `claude-code-source-code/src/utils/attachments.ts:1-260`

## 7. 这套 prompt API 为什么强

从接口设计看，它强在三点：

1. prompt 与 runtime 语义绑定：
   - 不是只改话术，还能改 tools / hooks / context / agent / model
2. prompt 与缓存经济绑定：
   - 静态 prefix、动态 boundary、attachment delta 都在保护 cache
3. prompt 与角色绑定：
   - coordinator、worker、fork、proactive、自定义 agent 拿到的不是同一份说明书

这意味着 Claude Code 的 prompt API，本质上是“角色化运行时装配 API”。

## 8. 可信边界

需要明确四点：

1. CLI flags 与 SDK initialize 字段，属于较明确的公共面。
2. skills / agents 的 frontmatter 字段，在公开源码里可见，但部分字段受 feature / source / trust boundary 约束。
3. attachment / delta 机制大量体现了 runtime 内部优化，不应简单上升为所有宿主的稳定承诺。
4. prompt 字符串本身随版本变化很大，真正更稳定的是装配顺序、角色分层和注入机制。

## 9. 相关章节

- `02-Agent SDK与控制协议.md`
- `10-扩展Frontmatter与插件Agent手册.md`
- `17-状态消息、外部元数据与宿主消费矩阵.md`
- `../architecture/18-提示词装配链与上下文成形.md`
- `../philosophy/14-提示词魔力来自运行时而非咒语.md`
