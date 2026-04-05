# 插件、MCP、技能、Hooks 与 Agents 运维专题

## 用户目标

不是只知道这些扩展层“存在”，而是能在真实工作中稳地管理它们：

- 我当前有哪些 skills / hooks / agents
- 插件安装后，什么时候真正对当前会话生效
- MCP 服务器怎么启停、重连和审计
- 哪些入口是在管理包，哪些入口是在管理能力

## 第一性原理

扩展运维面不是一个入口，而是五种不同对象：

- 可见能力清单：`/skills`
- 事件插针清单：`/hooks`
- 代理配置清单：`/agents`
- 扩展包管理：`/plugin`
- 外部服务器管理：`/mcp`

与它们紧邻但角色不同的，是：

- 当前会话刷新：`/reload-plugins`
- repo/workflow 安装入口：`/install-github-app`、`/install-slack-app`

所以更稳的提问不是“哪个更强”，而是：

- 我现在是在管理包
- 管理服务器
- 看当前暴露出的能力
- 还是让本会话吃到刚刚安装的变更

如果你还想分清 `claude plugin ...`、`claude mcp ...`、`claude agents` 这些会外 root commands 与 `/plugin`、`/mcp`、`/agents` 这些会内面板的层级差异，应继续看 `19-会外控制台与会内面板专题.md`。

## 正确入口

### `/skills`

这是稳定公开的技能可见面。

它做的不是“生成技能”，而是：

- 列出当前会话可用的 skills
- 基于当前 commands 上下文展示已暴露出来的技能面

更准确地说，它解决的是“我现在有哪些可调用工作流”。

还要再补一条边界：

- `/skills` 菜单看到的是当前命令上下文里被挑出来的一部分技能面
- 不应把它误写成“所有 bundled/builtin skills 的完整目录”

### `/hooks`

这是稳定公开的 hook 配置可见面。

它会基于当前会话的 permission context 获取工具池，再把这些工具名交给 `HooksConfigMenu`。

这意味着 `/hooks` 看的不是抽象配置宇宙，而是：

- 当前会话、当前权限下，哪些 tool events 上挂了什么 hooks

所以它更接近只读观察面，不是主要编辑面。

### `/agents`

这是稳定公开的 agent 配置可见面。

它同样会基于当前 permission context 取当前工具池，再交给 `AgentsMenu`。

所以 `/agents` 看的不是“理论上所有 agent schema”，而是当前会话真实可管理的 agent 配置面。

源码还显示一个容易写错的边界：

- plugin agents 会被刻意弱化，某些 frontmatter 字段不会按自定义 agent 的强度生效
- 因此 `/agents` 里的“看见 agent”不等于“所有 agent 都同等可塑”

### `/plugin`

这是稳定公开的插件包管理面。

它的关键词不是“技能”，而是：

- 插件包
- marketplace
- aliases: `plugins` / `marketplace`
- immediate 管理动作

所以 `/plugin` 解决的是：

- 插件安装、启停、版本与来源

而不是直接代替 `/skills`、`/hooks` 或 `/mcp`。

### `/mcp`

这是稳定公开的 MCP 服务器管理面。

它同样是 immediate 命令，而且支持：

- `enable`
- `disable`
- `reconnect`

源码还能确认一个细节：

- 批量启停时会显式跳过 `ide` 这个 client

所以 `/mcp` 管的是“服务器与连接状态”，不是 repo 规则库。

还要避免另一种常见混写：

- 用户面的 `/mcp` 是“管理 MCP servers”
- 不是“让 Claude Code 反过来充当 MCP server”的内部入口

### `/reload-plugins`

这条线必须被单独写出来。

它不是安装器，而是：

- 把 pending plugin changes 应用到当前 session

源码能确认：

- `supportsNonInteractive: false`
- 在 `CLAUDE_CODE_REMOTE` / remote mode 下，可能先重新拉 user settings
- 最终回报的是插件、skills、agents、hooks、plugin MCP/LSP servers 的刷新计数
- SDK 宿主不走文本 prompt，而走专门的 `query.reloadPlugins()` 控制请求

所以用户应该把它理解成：

- 当前会话吃变更的刷新面

而不是：

- 插件重装命令

## 隐藏的运行时合同

### `/plugin` 管包，`/skills` `/hooks` `/agents` 管暴露结果

这是这一层最重要的分工。

如果混写，读者会误以为：

- 装了 plugin 就等于已经理解当前 skills/hooks/agents 暴露面

其实并不是。

### `/reload-plugins` 只刷新当前 session

所以“磁盘上已经装好”不等于“这条会话已经吃到变更”。

更精确地说，它是在做当前 session 的 Layer-3 激活 / 换栈，而不是重新安装 marketplace 插件。

### `/mcp` 管的是 server，不是 repo 约定

当你在写项目工作方法、验证习惯、团队协作步骤时，通常应该去：

- skills
- hooks
- CLAUDE.md

而不是去 `/mcp`。

### `/hooks` 与 `/agents` 都受当前 permission context 影响

这意味着它们展示的是：

- 当前会话真实可用的运维面

而不是与当前权限无关的全局幻想。

### 日常运维链路是串联的，不是平铺的

更稳的实际顺序通常是：

- `/plugin`：安装 / 启停 / 配置插件包
- `/reload-plugins`：让当前 session 吃到变更
- `/skills`、`/hooks`、`/agents`：看新的暴露结果
- `/mcp`：处理 server 的启停、鉴权与重连

### plugin-only policy 会覆盖扩展来源选择

`strictPluginOnlyCustomization`、`allowManagedHooksOnly`、`disableAllHooks` 这类设置会改写：

- 你能从哪里自定义
- 哪些 hooks 还能生效

所以这条线不是只有能力面，还有组织治理面。

## 最容易误用的点

### 把 `/plugin` 当 `/skills`

一个管包，一个管当前可见工作流。

### 把 `/skills` 当完整技能目录

它展示的是当前被挑出来的技能面，不是“仓里一切技能”的权威总表。

### 把 `/mcp` 当 repo 规则库

MCP 更适合接外部能力，不适合存本地方法论。

### 插件刚装完就以为当前会话已经吃到变更

很多时候还需要 `/reload-plugins`。

### 把 `/reload-plugins` 当“重新安装插件”

它做的是当前 session refresh，不是安装流程。

### 把 `/mcp` 写成 Claude Code 的 MCP server 模式

用户面的 `/mcp` 在管理外部 servers；Claude Code 自己充当 MCP server 是另一条内部入口。

### 把 `/install-github-app`、`/install-slack-app` 当作扩展层本体

它们更接近外部平台接入，不是 `plugin/MCP/skills/hooks/agents` 这条日常运维主线。

## 稳定面与条件面

### 稳定主线

- `/skills`
- `/hooks`
- `/agents`
- `/plugin`
- `/mcp`
- `/reload-plugins`

### 条件或治理覆盖面

- `strictPluginOnlyCustomization`
- `allowManagedHooksOnly`
- `disableAllHooks`
- plugin 携带的 MCP / LSP servers
- remote mode 下 `/reload-plugins` 的 settings 重拉逻辑

### 相邻但不应混成同一主题

- `/install-github-app`
- `/install-slack-app`

## 用户策略

更稳的扩展运维路径通常是：

1. 先用 `/skills`、`/hooks`、`/agents` 看当前会话到底暴露了什么。
2. 需要管理插件包时，再进 `/plugin`。
3. 需要启停或重连外部服务器时，再进 `/mcp`。
4. 插件装好或配置改动后，如果当前 session 还没吃到变更，再跑 `/reload-plugins`。
5. 一旦涉及组织策略，先默认“能不能自定义”和“我该选哪一层自定义”不是同一个问题。

## 源码锚点

- `src/commands/skills/index.ts`
- `src/commands/skills/skills.tsx`
- `src/commands/hooks/index.ts`
- `src/commands/hooks/hooks.tsx`
- `src/commands/agents/index.ts`
- `src/commands/agents/agents.tsx`
- `src/commands/plugin/index.tsx`
- `src/commands/mcp/index.ts`
- `src/commands/mcp/mcp.tsx`
- `src/commands/reload-plugins/index.ts`
- `src/commands/reload-plugins/reload-plugins.ts`
- `src/utils/settings/pluginOnlyPolicy.ts`
- `src/utils/settings/types.ts`
