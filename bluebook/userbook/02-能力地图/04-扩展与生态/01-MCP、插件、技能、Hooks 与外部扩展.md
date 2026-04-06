# MCP、插件、技能、Hooks 与外部扩展

## Claude Code 的扩展不是一个点，而是四层

从源码看，外部扩展至少有四层：

1. 技能。
2. 插件。
3. MCP 服务器。
4. Hooks。

它们解决的不是同一类问题。

## 技能：最轻量的工作流扩展

技能是最贴近“给 Claude 一套固定做法”的扩展形态。

来源包括：

- bundled skills。
- 项目技能目录。
- 插件内 skills。
- 动态技能。

技能最重要的优点不是“内容可复用”，而是它已经被挂进正式命令空间，且可以声明：

- 允许的工具。
- 建议模型。
- hooks。
- `inline` 还是 `fork`。
- 是否用户可直接调用。

## 插件：把多种扩展打包成可开关单元

`src/plugins/builtinPlugins.ts` 说明插件和单独技能的差别在于：

- 插件可以暴露多个组件。
- 插件可在 `/plugin` UI 中启停。
- 插件可以带 hooks、skills、MCP servers。

所以插件更像“一个可管理的扩展包”，而不是单条命令。

## MCP：把 Claude Code 接到外部系统

`src/services/mcp/client.ts`、`src/commands/mcp/index.ts`、`src/tools/MCPTool/MCPTool.ts` 表明 MCP 是外部系统接入的正式边界。

它解决的是：

- Claude Code 原生工具不覆盖的系统能力。
- 资源枚举与资源读取。
- 外部 API、数据库、SaaS、企业系统的统一接入。

对用户来说，MCP 的正确位置是：

- 当你需要 Claude Code 越过本机与本仓库边界时。
- 当你希望扩展能力而不改 Claude Code 本体时。

## Hooks：把运行时关键事件暴露给外部脚本

`src/utils/hooks/*`、`src/commands/hooks/index.ts` 说明 Hooks 不是简单脚本回调，而是围绕关键事件构建的扩展层。

它们可以出现在：

- 用户提交 prompt 之前或之后。
- 工具调用前后。
- 任务创建等事件点。

这让 Claude Code 不只是“自己行动”，还可以和外部治理脚本、验证逻辑、上下文采集逻辑形成闭环。

## 用户该怎样选扩展层

### 先用技能

当问题只是“我想固定一套做法”。

### 再用插件

当你需要把多条能力打成一个可启停单元。

### 再用 MCP

当你需要真正接到外部系统。

### 最后用 Hooks

当你想拦截、改写、补充运行时流程。

## 源码锚点

- `src/skills/loadSkillsDir.ts`
- `src/skills/bundledSkills.ts`
- `src/skills/bundled/index.ts`
- `src/plugins/builtinPlugins.ts`
- `src/commands/plugin/index.tsx`
- `src/commands/mcp/index.ts`
- `src/services/mcp/client.ts`
- `src/tools/MCPTool/MCPTool.ts`
- `src/utils/hooks/AsyncHookRegistry.ts`
- `src/commands/hooks/index.ts`
