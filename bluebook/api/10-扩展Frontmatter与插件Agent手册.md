# 扩展 Frontmatter 与插件 Agent 手册

这一章回答五个问题：

1. Claude Code 的扩展面到底有哪些正式入口。
2. skills、legacy commands、agents、plugins 为什么能被看成同一套配置语言。
3. frontmatter 和 plugin manifest 各自负责什么层级。
4. plugin agent 为什么故意比本地 `.claude/agents/` agent 更受限。
5. 为什么这套扩展 API 的本质不是“插件中心”，而是“声明式 runtime 装配”。

## 1. 先说结论

Claude Code 的扩展面并不是几套彼此无关的子系统。

从源码看，它至少由三层共同组成：

1. 目录约定层：`commands/`、`agents/`、`skills/`、`output-styles/`、`workflows/`。
2. 配置语言层：Markdown + YAML frontmatter，以及 `plugin.json` manifest。
3. 运行时对象层：`Command`、`AgentDefinition`、`LoadedPlugin`、MCP/LSP/hook config。

也就是说，Claude Code 并不是“命令一套格式、技能一套格式、插件再一套完全不同的格式”。
它更像是把能力扩展收敛成一套统一的声明式装配语言。

关键证据：

- `claude-code-source-code/src/utils/frontmatterParser.ts:10-58`
- `claude-code-source-code/src/utils/frontmatterParser.ts:123-232`
- `claude-code-source-code/src/utils/markdownConfigLoader.ts:28-46`
- `claude-code-source-code/src/utils/markdownConfigLoader.ts:71-140`
- `claude-code-source-code/src/utils/markdownConfigLoader.ts:297-360`
- `claude-code-source-code/src/skills/loadSkillsDir.ts:185-315`
- `claude-code-source-code/src/skills/loadSkillsDir.ts:625-804`
- `claude-code-source-code/src/tools/AgentTool/loadAgentsDir.ts:73-99`
- `claude-code-source-code/src/tools/AgentTool/loadAgentsDir.ts:105-166`
- `claude-code-source-code/src/tools/AgentTool/loadAgentsDir.ts:541-748`
- `claude-code-source-code/src/utils/plugins/schemas.ts:385-570`
- `claude-code-source-code/src/utils/plugins/schemas.ts:623-898`
- `claude-code-source-code/src/utils/plugins/loadPluginCommands.ts:169-340`
- `claude-code-source-code/src/utils/plugins/loadPluginCommands.ts:520-940`
- `claude-code-source-code/src/utils/plugins/loadPluginAgents.ts:65-223`
- `claude-code-source-code/src/plugins/builtinPlugins.ts:1-18`
- `claude-code-source-code/src/types/command.ts:25-57`
- `claude-code-source-code/src/types/plugin.ts:48-78`

## 2. 目录约定先定义扩展槽位

### 2.1 Claude Code 预留的配置目录不是一个，而是一组

`markdownConfigLoader.ts` 里直接定义了 `CLAUDE_CONFIG_DIRECTORIES`：

- `commands`
- `agents`
- `output-styles`
- `skills`
- `workflows`
- 可选 `templates`

证据：

- `claude-code-source-code/src/utils/markdownConfigLoader.ts:28-38`

这意味着 Claude Code 从目录层就把“扩展”拆成多种能力槽位，而不是只留一个 plugin 入口。

### 2.2 这些目录遵循统一的向上发现与覆盖模型

`loadMarkdownFilesForSubdir(...)` 会：

- 读取 managed、user、project 多层来源。
- 从当前目录向上遍历到 git root / home 边界。
- 对 worktree 做 fallback 处理，避免主仓库 `.claude/` 丢失。
- 受 plugin-only policy 和 setting source enablement 影响。

证据：

- `claude-code-source-code/src/utils/markdownConfigLoader.ts:174-220`
- `claude-code-source-code/src/utils/markdownConfigLoader.ts:297-360`

所以扩展面的第一层 API 其实不是函数，而是“目录发现协议”。

## 3. frontmatter 是共享配置语法，而不是 skill 私有语法

### 3.1 `frontmatterParser.ts` 做的是通用解析，不是单模块私有解析

它提供：

- `parseFrontmatter(...)`
- `splitPathInFrontmatter(...)`
- `parsePositiveIntFromFrontmatter(...)`
- `coerceDescriptionToString(...)`

证据：

- `claude-code-source-code/src/utils/frontmatterParser.ts:123-175`
- `claude-code-source-code/src/utils/frontmatterParser.ts:177-289`
- `claude-code-source-code/src/utils/frontmatterParser.ts:291-320`

而 `FrontmatterData` 里已经出现大量跨对象共享字段：

- `allowed-tools`
- `description`
- `argument-hint`
- `when_to_use`
- `model`
- `skills`
- `user-invocable`
- `hooks`
- `effort`
- `context`
- `agent`
- `paths`
- `shell`

证据：

- `claude-code-source-code/src/utils/frontmatterParser.ts:10-58`

### 3.2 工具列表语义在 commands 与 agents 上故意不同

`markdownConfigLoader.ts` 把工具列表解析拆成两种：

- `parseAgentToolsFromFrontmatter(...)`
- `parseSlashCommandToolsFromFrontmatter(...)`

关键差异是：

- agent 缺失 `tools` 表示“所有工具”。
- slash command / skill 缺失 `allowed-tools` 表示“无显式授权工具”。

证据：

- `claude-code-source-code/src/utils/markdownConfigLoader.ts:71-140`

这说明 Claude Code 不是简单复用字符串字段，而是在共享语法之上保留对象级语义差异。

## 4. skills 与 legacy commands：共享一套 prompt-command 对象模型

### 4.1 `parseSkillFrontmatterFields(...)` 已经近似一套扩展 DSL

skills / commands 能解析的核心字段包括：

- `name`
- `description`
- `allowed-tools`
- `argument-hint`
- `arguments`
- `when_to_use`
- `version`
- `model`
- `disable-model-invocation`
- `user-invocable`
- `hooks`
- `context`
- `agent`
- `effort`
- `shell`

证据：

- `claude-code-source-code/src/skills/loadSkillsDir.ts:185-264`

这些字段最终会被收敛成一个 `Command` 对象，填入：

- `allowedTools`
- `argNames`
- `context`
- `agent`
- `effort`
- `paths`
- `hooks`
- `skillRoot`
- `getPromptForCommand(...)`

证据：

- `claude-code-source-code/src/skills/loadSkillsDir.ts:267-399`
- `claude-code-source-code/src/types/command.ts:25-57`

### 4.2 `skills/` 与 legacy `commands/` 只是两种装载来源

`getSkillDirCommands(...)` 说明：

- 新的 `skills/` 目录只接受 `skill-name/SKILL.md` 目录格式。
- legacy `commands/` 既支持单文件，也支持 `SKILL.md` 目录格式。
- 两者最终都落为 `Command`，只是 `loadedFrom` 不同。

证据：

- `claude-code-source-code/src/skills/loadSkillsDir.ts:482-622`
- `claude-code-source-code/src/skills/loadSkillsDir.ts:625-804`

### 4.3 `paths` 让 skill 变成条件性能力，而不是静态菜单项

`parseSkillPaths(...)` 与 conditional skill activation 说明：

- skill 可以声明 `paths`。
- 不匹配时不会立即进入可用技能集。
- 只有当会话操作到匹配路径时，skill 才被激活。

证据：

- `claude-code-source-code/src/skills/loadSkillsDir.ts:155-178`
- `claude-code-source-code/src/skills/loadSkillsDir.ts:771-804`
- `claude-code-source-code/src/skills/loadSkillsDir.ts:986-1046`

这说明 Claude Code 的扩展面不只声明“我能做什么”，还声明“我在何时应出现”。

## 5. agents：同样使用 frontmatter，但语义更像 worker definition

### 5.1 agent 的核心字段比 skill 更接近运行时 worker profile

Markdown agent 至少可声明：

- `name`
- `description`
- `tools`
- `disallowedTools`
- `skills`
- `model`
- `effort`
- `permissionMode`
- `mcpServers`
- `hooks`
- `maxTurns`
- `initialPrompt`
- `background`
- `memory`
- `isolation`

证据：

- `claude-code-source-code/src/tools/AgentTool/loadAgentsDir.ts:73-99`
- `claude-code-source-code/src/tools/AgentTool/loadAgentsDir.ts:541-748`

### 5.2 同一套 agent 定义还能从 JSON 进入

`AgentJsonSchema` 与 `parseAgentFromJson(...)` 说明：

- agent 并不绑定 Markdown。
- JSON 也可声明几乎同一组字段。
- 最终仍被装配成 `CustomAgentDefinition`。

证据：

- `claude-code-source-code/src/tools/AgentTool/loadAgentsDir.ts:73-103`
- `claude-code-source-code/src/tools/AgentTool/loadAgentsDir.ts:445-535`

这进一步说明 Claude Code 真正关心的是“agent definition object”，而不是“文件格式本身”。

### 5.3 agent 还会因为 memory 开关被动态改写工具集

若 agent 开启 memory，且 auto memory 启用，则系统会自动注入：

- `FileWrite`
- `FileEdit`
- `FileRead`

证据：

- `claude-code-source-code/src/tools/AgentTool/loadAgentsDir.ts:455-467`
- `claude-code-source-code/src/tools/AgentTool/loadAgentsDir.ts:662-674`

这说明扩展配置不是静态元数据，运行时会根据 feature 与环境做二次装配。

## 6. plugin manifest：把多组件扩展打成一个安装单位

### 6.1 plugin 不是只装 commands

`PluginManifestSchema` 暴露的组件面至少包括：

- `commands`
- `agents`
- `skills`
- `outputStyles`
- `hooks`
- `channels`
- `mcpServers`
- `lspServers`
- `settings`
- `userConfig`

证据：

- `claude-code-source-code/src/utils/plugins/schemas.ts:429-572`
- `claude-code-source-code/src/utils/plugins/schemas.ts:623-898`

### 6.2 plugin command 可以是路径、目录，也可以是 inline content

manifest 中 command 支持三种形式：

1. 路径
2. 路径数组
3. 对象映射 `name -> metadata`

而对象映射还能提供：

- `source`
- `content`
- `description`
- `argumentHint`
- `model`
- `allowedTools`

证据：

- `claude-code-source-code/src/utils/plugins/schemas.ts:375-452`
- `claude-code-source-code/src/utils/plugins/loadPluginCommands.ts:520-669`

这意味着 plugin manifest 已经是二阶扩展层，不只是“指向某个目录”。

### 6.3 plugin 还能携带 MCP、LSP 与用户配置

plugin manifest 中：

- `mcpServers` 支持 `.json`、MCPB、本地 inline、数组混合。
- `lspServers` 支持外部文件或 inline config。
- `userConfig` 支持敏感/非敏感值、类型约束、enable-time prompt。
- `channels` 则把 message channel 也纳入 manifest。

证据：

- `claude-code-source-code/src/utils/plugins/schemas.ts:537-572`
- `claude-code-source-code/src/utils/plugins/schemas.ts:623-703`
- `claude-code-source-code/src/utils/plugins/schemas.ts:706-820`
- `claude-code-source-code/src/utils/plugins/mcpPluginIntegration.ts:126-212`

所以 plugin manifest 本质上是在声明一个“小型能力包”。

## 7. plugin command / skill / agent 的装载语义

### 7.1 plugin command 与 skill 都会自动命名空间化

命名规则通常是：

- `pluginName:commandName`
- `pluginName:namespace:commandName`

skill 目录则通过目录名参与命名。

证据：

- `claude-code-source-code/src/utils/plugins/loadPluginCommands.ts:58-97`
- `claude-code-source-code/src/utils/plugins/loadPluginCommands.ts:687-838`

### 7.2 metadata override 能覆盖 Markdown frontmatter

当 plugin manifest 使用对象映射时，loader 会把 metadata 覆盖到 frontmatter 上：

- `description`
- `argument-hint`
- `model`
- `allowed-tools`

证据：

- `claude-code-source-code/src/utils/plugins/loadPluginCommands.ts:545-579`
- `claude-code-source-code/src/utils/plugins/loadPluginCommands.ts:621-653`

这再次证明“frontmatter”并不是唯一来源，而是统一对象模型的一个输入源。

## 8. plugin agent 的故意收权，是扩展 API 最重要的边界之一

`loadPluginAgents.ts` 里最关键的一段不是字段解析，而是字段忽略。

plugin agent 当前明确不解析：

- `permissionMode`
- `hooks`
- `mcpServers`

源码注释给出的理由非常明确：

- plugin 是第三方 marketplace 代码。
- 这些字段会把单个 agent 的控制力提升到超出用户安装时批准的范围。
- 更高权限的 agent 定义应当写在本地 `.claude/agents/`，而不是藏在 plugin 包里。

证据：

- `claude-code-source-code/src/utils/plugins/loadPluginAgents.ts:153-168`

与此同时，plugin 级 manifest 仍可提供 hooks 与 MCP servers。

这说明 trust boundary 的设计是：

1. plugin 安装时批准 manifest 级能力。
2. plugin 内部单个 agent 不能再偷偷升权。

## 9. built-in plugin 与 bundled skill 也不是同一层

`builtinPlugins.ts` 注释明确指出：

- built-in plugin 会出现在 `/plugin` UI。
- 用户可启用/禁用。
- 它们可提供多个组件，如 skills/hooks/MCP。

这和 bundled skills 不同。

证据：

- `claude-code-source-code/src/plugins/builtinPlugins.ts:1-18`
- `claude-code-source-code/src/plugins/builtinPlugins.ts:52-121`

所以 Claude Code 的扩展体系至少有三种成熟度层次：

1. bundled capability
2. built-in plugin
3. external / marketplace plugin

## 10. 从第一性原理看，这套扩展 API 在解决什么

如果回到 Claude Code 的 runtime 本质，这套扩展 API 在解决四个不可约问题：

1. 能力增长：新能力必须能增量接入，而不是每次都改核心 loop。
2. 信任分层：本地作者、组织策略、第三方 plugin 的权限边界必须不同。
3. 懒加载：并非所有扩展都该在启动时完整膨胀进 prompt。
4. 可装配：命令、skill、agent、MCP、hook、LSP 必须能拼接成同一个 runtime。

所以这套 API 的核心价值不是“插件多”，而是“扩展被做成了一门受边界约束的配置语言”。

## 11. 可信边界

需要明确四点：

1. plugin manifest schema 很宽，但出现字段不等于所有字段都已形成成熟生态。
2. plugin agent 当前被故意收权，不能把本地 `.claude/agents/` 能力直接外推到 marketplace agent。
3. skills / commands / agents 的共享 frontmatter 说明它们是统一语言，但各自默认值与安全语义并不相同。
4. 公开源码中仍受 plugin-only policy、setting source enablement、feature gate 共同影响，不能把“代码能解析”直接写成“任何用户都能稳定使用”。

## 12. 相关章节

- MCP 与远程：`03-MCP与远程传输.md`
- 工具协议：`08-工具协议与ToolUseContext.md`
- Agent 隔离编排：`../architecture/10-AgentTool与隔离编排.md`
- 权限全链路：`../architecture/11-权限系统全链路与Auto Mode.md`
- 扩展观哲学：`../philosophy/08-统一配置语言优于扩展孤岛.md`
