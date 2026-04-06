# MCP 配置、按名解析与 Agent 引用：为什么你看到的 server 不是 Agent 真能挂上的 server

## 用户目标

不是只知道 Claude Code “有 `/mcp` 和 agent `mcpServers`”，而是先看清四件事：

- `/mcp` 菜单到底在展示什么，为什么它不是唯一的 MCP 真相。
- 全局 MCP 配置总览与按名字解析 server，为什么不是同一张表。
- agent frontmatter 里引用已有 server 与内联定义 server，为什么走的是两条不同路径。
- `strictPluginOnlyCustomization['mcp']`、enterprise exclusive control、agent source trust 分别锁住哪一层。

如果这四件事不先拆开，读者最容易把下面这些对象混成一锅“可用 MCP server”：

- `/mcp` 菜单里的普通 server
- `/mcp` 菜单里的 agent-specific server
- `getClaudeCodeMcpConfigs()` 返回的全局配置集合
- `getAllMcpConfigs()` 继续并入的 claude.ai / connector 集合
- `getMcpConfigByName()` 可按名引用的集合
- agent frontmatter `mcpServers` 的 string 引用
- agent frontmatter `mcpServers` 的 inline 定义

## 第一性原理

Claude Code 治理 MCP 的方式，不是维护一张“server 总表”，而是拆成至少四层不同对象：

1. 配置层：哪些 server 配置被系统承认为全局可见。
2. 解析层：哪些 server 能被名字解析成可引用对象。
3. 连接层：当前 session 实际连上了哪些 client。
4. Agent 层：当前 agent 能不能再挂自己的 MCP server。

因此更稳的提问不是：

- “这个 server 在不在 MCP 里？”

而是：

- 它是在全局配置总览里、按名可引用里、当前 client 列表里，还是仅在 agent frontmatter 候选里？

只要不先分清这四层，`/mcp` 就会被误写成唯一真相。

## 第一层：`/mcp` 菜单展示的是连接视图，不是配置总表

### `/mcp` 先看当前 `mcp.clients`

`/mcp` 命令进入的是 `MCPSettings`。

这条 UI 先读取：

- 当前 `mcp.clients`

再把它们变成：

- `servers`

因此 `/mcp` 的默认对象是：

- 当前 session 的 MCP client / server 视图

而不是：

- 一张不分来源、不分连接状态的配置总表

### `MCPSettings` 还会把 agent-specific server 单列出来

`MCPSettings` 还会从全部 agent 定义里提取：

- `agentMcpServers`

并在 `MCPListPanel` 里把它们作为另一类对象单独列出。

这说明 `/mcp` 菜单里本来就至少有两类不同对象：

- 普通 server / client
- agent-specific MCP server

所以 userbook 不能把 `/mcp` 简化成：

- “所有 MCP server 的列表”

### `/mcp` 的“看见 server”不等于“这个 server 可被 Agent 按名引用”

这是本页最重要的结论。

`/mcp` 展示的是当前 client 视图与 agent-specific 视图的合成结果。

但 agent frontmatter 若用字符串引用已有 server，真正走的是：

- `getMcpConfigByName()`

因此：

- UI 可见 server
- 按名可引用 server

本来就不是同一层。

## 第二层：全局配置总览与按名解析不是同一张表

### `getClaudeCodeMcpConfigs()` 负责全局配置总览

这条链会组合：

- enterprise 配置
- user / project / local 配置
- plugin MCP servers

并做：

- enterprise exclusive control
- project approval
- policy filtering
- plugin 去重

所以这层更像：

- Claude Code 视角下“当前全局可见的 MCP 配置集合”

### 但它不是最终的“所有 MCP”

源码还明确分了另一层：

- `getAllMcpConfigs()`

它会在 `getClaudeCodeMcpConfigs()` 之外，再并入：

- claude.ai / connector 一类 server

所以 userbook 更稳的写法应是：

- Claude Code 内部至少有“本地 Claude Code 配置总览”和“继续并入 connector 后的更大全局集合”两层

而不是：

- “一个函数返回全部 MCP 真相”

### `getMcpConfigByName()` 的集合比全局配置总览更窄

`getMcpConfigByName()` 的按名解析顺序是：

- enterprise
- local
- project
- user

它不会像全局总览那样把 plugin servers、dynamic / built-in servers、claude.ai servers 都视为同一层按名可引用对象。

这意味着：

- 你在 `/mcp` 菜单里看见的 server
- 不一定能被 agent frontmatter 用字符串名字直接引用

## 第三层：plugin-only `mcp` policy 在总览层与按名层的效果不同

### 全局配置总览在 plugin-only 下仍会保留 plugin servers

当 `strictPluginOnlyCustomization['mcp']` 生效时：

- user / project / local 配置会被跳过
- 但 plugin MCP servers 仍会被装进全局配置总览

所以 plugin-only `mcp` 的正确心智不是：

- “只剩 enterprise”

而是：

- “用户自定义来源被锁住，但 plugin 仍可作为全局配置来源”

### 按名解析在 plugin-only 下却更严格

`getMcpConfigByName()` 在 `mcp` 被锁成 plugin-only 时，会直接退化到：

- 只返回 enterprise servers

这就形成了一个非常容易误写的错位：

- 全局总览里仍可能有 plugin servers
- 但 agent frontmatter 的 string 引用却按名拿不到它们

所以 userbook 必须明确写出：

- plugin-only `mcp` policy 在“全局可见面”和“按名可引用面”上不是同一语义

## 第四层：Agent frontmatter `mcpServers` 里，string 与 inline 是两条不同路径

### string 引用：依赖 `getMcpConfigByName()`

当 agent frontmatter 写的是字符串：

- 它不是新建 server
- 而是按名字去全局配置里查一个已有 server

所以它的真实前提是：

- 这个 server 必须先存在于“按名可引用集合”

而不是只存在于：

- `/mcp` 菜单
- 普通 client 列表
- 更宽的全局配置总览

### inline 定义：绕过按名查找，直接当 agent-specific server 建立

当 agent frontmatter 写的是：

- `{ [name]: config }`

它走的不是按名查找，而是：

- 直接把这个定义当作 agent-specific server
- 运行时连接
- agent 结束后清理

所以这条链的心智应是：

- string 是“引用已有 server”
- inline 是“临时给 agent 再挂一个自己的 server”

### `/mcp` 菜单把 inline agent server 单列出来，正说明它不是普通全局 server

`extractAgentMcpServers(...)` 只提取 agent frontmatter 里的 inline MCP servers，并把：

- string references

明确跳过。

这说明 `/mcp` UI 自己也在承认：

- agent inline server
- 全局可见 server

不是同一对象。

## 第五层：agent source trust 决定 frontmatter MCP 能不能继续往下走

### 非 admin-trusted agent，在 plugin-only `mcp` 下会整段跳过 frontmatter MCP

`runAgent.ts` 的初始化逻辑很明确：

- 如果 `mcp` 被锁成 plugin-only
- 且 agent source 不是 admin-trusted
- 就整段跳过这个 agent 的 frontmatter MCP servers

这意味着：

- agent 本身还在
- 但它附带的 MCP 面可以被整体剥掉

### 所以 “agent 有 `mcpServers`” 不等于 “运行时一定会挂上”

更准确的判断顺序应是：

1. 这个 agent 来源是否允许。
2. 这是 string 引用还是 inline 定义。
3. 如果是 string，引到的名字是否属于按名可引用集合。
4. 当前 `mcp` surface 是否已被 policy 锁窄。

只要少看其中一步，就会把 agent 的 MCP 行为写成假的必然关系。

## 第六层：plugin agents 是另一个特例

### plugin agent 文件里的 `mcpServers` 本身就会被忽略

这条边界非常容易被漏掉。

plugin agent 文件里的：

- `permissionMode`
- `hooks`
- `mcpServers`

当前是故意不解析的。

原因很清楚：

- plugin 的 manifest / install 才是这类能力提升的信任边界
- 不能让某个埋在 plugin `agents/` 里的文件静默扩大 agent 权限

所以更稳的 userbook 写法应是：

- plugin agent 不等于普通 `.claude/agents/` agent
- “plugin source 是 admin-trusted” 也不等于 “plugin agent 文件里写的 `mcpServers` 会生效”

## 最容易误写的八件事

### 误写 1

“`/mcp` 菜单就是全部 MCP 配置总表。”

更准确的写法：`/mcp` 主要是当前 client 视图，并单列 agent-specific server。

### 误写 2

“全局配置总览与按名解析本来就是同一张表。”

更准确的写法：按名解析集合明显更窄。

### 误写 3

“plugin-only `mcp` 生效后，plugin MCP servers 也会从所有视图里消失。”

更准确的写法：全局总览里仍可能保留 plugin servers，但按名引用会更严格。

### 误写 4

“只要 `/mcp` 里看得到 server，agent 就能按名字引用。”

更准确的写法：string 引用要过 `getMcpConfigByName()` 这层更窄的集合。

### 误写 5

“agent frontmatter 里的 string 与 inline `mcpServers` 没本质区别。”

更准确的写法：前者引用已有 server，后者新建 agent-specific server。

### 误写 6

“agent 有 `mcpServers` 字段，运行时就一定会挂上。”

更准确的写法：还要过 source trust 与 `mcp` surface policy。

### 误写 7

“plugin source 是 admin-trusted，所以 plugin agent 文件里的 `mcpServers` 肯定能生效。”

更准确的写法：plugin agent 文件里的 `mcpServers` 本身就会被忽略。

### 误写 8

“claude.ai / connector servers、plugin servers、enterprise servers、agent inline servers 都是同一类 MCP server。”

更准确的写法：它们在全局总览、按名解析、UI 展示与 agent 挂载上的层级不同。

## 稳定事实与降级写法

### 可以写成稳定 userbook 事实的

- MCP 至少有配置、按名解析、连接、Agent 挂载四层不同对象
- `/mcp` 不是唯一真相，它展示的是当前 session 的 MCP 视图
- `getClaudeCodeMcpConfigs()` 与 `getMcpConfigByName()` 不是同一集合
- string 与 inline `mcpServers` 走的是两条不同链
- `mcp` surface 被锁窄时，agent 的 MCP 面可能被整体剥掉

### 应降级为实现细节或维护记忆的

- plugin MCP servers 当前如何被 namespaced
- 哪些 server 被归到 `dynamic` 或 connector 分组
- `MCPStdioServerMenu` 如何回填 config location
- claude.ai / connector 拉取、去重和 proxy URL 还原细节

这些适合作为源码证据，但不应写成长期稳定产品承诺。

## 源码锚点

- `claude-code-source-code/src/services/mcp/config.ts`
- `claude-code-source-code/src/utils/plugins/mcpPluginIntegration.ts`
- `claude-code-source-code/src/tools/AgentTool/runAgent.ts`
- `claude-code-source-code/src/tools/AgentTool/loadAgentsDir.ts`
- `claude-code-source-code/src/utils/plugins/loadPluginAgents.ts`
- `claude-code-source-code/src/components/mcp/MCPSettings.tsx`
- `claude-code-source-code/src/components/mcp/MCPListPanel.tsx`
- `claude-code-source-code/src/components/mcp/MCPAgentServerMenu.tsx`
- `claude-code-source-code/src/components/mcp/MCPStdioServerMenu.tsx`
