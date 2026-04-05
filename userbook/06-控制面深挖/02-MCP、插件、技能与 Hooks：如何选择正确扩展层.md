# MCP、插件、技能与 Hooks：如何选择正确扩展层

## 第一性原理

Claude Code 需要解决一个根本矛盾：

- 用户希望它快速学会新的工作流。
- 但系统又不能把每个新需求都做成内核代码。

于是源码里形成了四层扩展结构：

1. 技能。
2. 插件。
3. MCP。
4. Hooks。

它们不是四种叫法，而是四个不同抽象层级。

## 技能：最快的工作流封装层

技能的本质是“把一套 prompt 工作法变成正式命令对象”。它最适合：

- 复用流程。
- 注入方法论。
- 约束工具白名单。
- 指定推荐模型或 fork 上下文。

如果你的目标只是“让 Claude 以后按这套办法做”，优先级应当是技能，而不是插件或 MCP。

## 插件：把多种扩展打包成可管理单元

插件与单个技能的差异，在 `builtinPlugins.ts` 中写得很清楚：

- 插件可在 `/plugin` UI 中开关。
- 插件可以带多条 skills。
- 插件也可以带 hooks 和 MCP servers。
- 插件是“可管理包”，不是单个提示词。

因此插件适合：

- 你有一组相关能力要一起启停。
- 你希望通过市场或安装源分发。
- 你不只提供技能，还提供其他扩展组件。

## MCP：外部系统边界

MCP 不是“更多技能”，而是“把 Claude Code 接到外部工具宇宙”。

`services/mcp/client.ts` 体现的几个关键点：

- Claude Code 直接兼容 stdio、SSE、streamable HTTP、WebSocket 等传输。
- MCP 工具、prompts、resources 都是正式对象。
- 有独立认证、OAuth 刷新、会话过期恢复、输出截断、资源读取等逻辑。
- MCP 工具会进入合并后的工具池，但仍保持自己是外部能力。

如果你的目标是“接数据库、SaaS、浏览器、企业平台、内部服务”，优先级应该是 MCP。

## Hooks：运行时事件的插针层

Hooks 解决的问题和前面三者都不一样。它们不主要负责“给 Claude 新能力”，而是负责：

- 在关键事件前后插入逻辑。
- 阻止继续。
- 追加上下文。
- 接入外部治理脚本。

所以 Hooks 适合：

- 验证。
- 审计。
- 策略拦截。
- 自动补上下文。
- 团队内统一流程约束。

## 选择树

### 只想固化一套工作方式

先用技能。

### 想让一组技能、hooks、MCP 一起出现并可管理

用插件。

### 想连接 Claude Code 之外的系统

用 MCP。

### 想在现有流程关键节点插手

用 Hooks。

## `/mcp` 与 `/plugin` 的用户面意义

源码里的 `/mcp` 和 `/plugin` 都是 `local-jsx` 管理界面，说明这两条扩展路径都已经被视为正式控制面，而不是配置文件彩蛋。

一个重要细节是：

- 某些构建里 `/mcp` 会重定向到插件管理视图。

这表明产品视角里，插件与 MCP 并不是完全分离的用户心智，而是逐渐进入统一扩展治理面。

## 稳定面与灰度面

### 相对稳定

- skills 作为命令源
- 插件 UI 和插件注册机制
- MCP 配置、连接、工具池合并
- hook 事件注册与异步执行框架

### 需要谨慎区分

- MCP skills 相关能力
- remote skill search
- 某些 marketplace、discovery、自动推荐能力
- 某些内置插件或内置技能只在特定条件下启用

## 苏格拉底反诘

### 问：为什么不所有扩展都做成 MCP

答：因为很多需求只是工作流复用，不需要跨进程、传输层、认证层和资源层。

### 问：为什么不所有扩展都做成插件

答：插件太重。单个工作法更适合技能。

### 问：为什么不只靠 hooks

答：hooks 更适合插手运行时，不适合表达完整能力面或外部工具契约。

## 源码锚点

- `src/skills/loadSkillsDir.ts`
- `src/skills/bundledSkills.ts`
- `src/plugins/builtinPlugins.ts`
- `src/commands/plugin/plugin.tsx`
- `src/commands/mcp/mcp.tsx`
- `src/services/mcp/client.ts`
- `src/tools/MCPTool/MCPTool.ts`
- `src/utils/hooks/*`
