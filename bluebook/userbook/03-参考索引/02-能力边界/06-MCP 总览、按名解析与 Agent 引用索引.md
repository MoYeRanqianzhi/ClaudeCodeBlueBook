# MCP 总览、按名解析与 Agent 引用索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/17-MCP 配置、按名解析与 Agent 引用：为什么你看到的 server 不是 Agent 真能挂上的 server.md`
- `04-专题深潜/17-插件、MCP、技能、Hooks 与 Agents 运维专题.md`

## 1. MCP 的四层不同对象

| 层 | 核心问题 | 典型对象 | 最容易误判 |
| --- | --- | --- | --- |
| 配置层 | 当前哪些 server 被系统认作全局可见配置 | `getClaudeCodeMcpConfigs()` | 误写成最终可引用集合 |
| 解析层 | 哪些 server 能按名字被引用 | `getMcpConfigByName()` | 误写成和全局总览一样 |
| 连接层 | 当前 session 真正连上了哪些 client | `/mcp` -> `mcp.clients` | 误写成配置总表 |
| Agent 层 | 当前 agent 能不能再挂 MCP server | agent `mcpServers` | 误写成“字段存在就会生效” |

## 2. 三类最容易混淆的 server

| 对象 | 来自哪里 | 为什么不应混写 |
| --- | --- | --- |
| 普通全局 server | user/project/local/plugin/enterprise 等配置链 | 解决的是全局配置可见性 |
| 按名可引用 server | `getMcpConfigByName()` | 解决的是 agent string reference 能不能命中 |
| agent inline server | agent frontmatter `{ [name]: config }` | 解决的是 agent 自己临时再挂一个 server |

## 3. plugin-only `mcp` policy 的双层效果

| 层 | 当前效果 |
| --- | --- |
| 全局配置总览 | user/project/local 被跳过，但 plugin servers 仍可能保留 |
| 按名解析 | 会退化到只看 enterprise servers |
| Agent frontmatter | 非 admin-trusted agent 的 `mcpServers` 会被整段跳过 |

## 4. string 与 inline `mcpServers` 的区别

| 写法 | 真实语义 |
| --- | --- |
| string | 引用已有的按名可解析 server |
| inline object | 直接创建 agent-specific server，并在 agent 生命周期内连接/清理 |

## 5. `/mcp` 为什么不是唯一真相

| UI 里看到的对象 | 更准确的理解 |
| --- | --- |
| 普通 server 列表 | 当前 `mcp.clients` 派生的连接视图 |
| agent server 列表 | 从全部 agent 定义里额外提取出的 inline MCP servers |
| config location 一类信息 | 可能依赖更窄的按名解析链，不能倒推所有 server 都可引用 |

## 6. 五个高价值判断问题

- 我现在讨论的是全局配置总览、按名解析、当前 client，还是 agent frontmatter？
- 这是普通全局 server，还是 agent inline server？
- 当前 `mcp` surface 是否已被 plugin-only policy 锁窄？
- 这条 agent `mcpServers` 是 string 引用还是 inline 定义？
- 我是不是把 `/mcp` 菜单里看见的对象误写成了 agent 一定能挂上的对象？

## 源码锚点

- `claude-code-source-code/src/services/mcp/config.ts`
- `claude-code-source-code/src/utils/plugins/mcpPluginIntegration.ts`
- `claude-code-source-code/src/tools/AgentTool/runAgent.ts`
- `claude-code-source-code/src/tools/AgentTool/loadAgentsDir.ts`
- `claude-code-source-code/src/utils/plugins/loadPluginAgents.ts`
- `claude-code-source-code/src/components/mcp/MCPSettings.tsx`
- `claude-code-source-code/src/components/mcp/MCPListPanel.tsx`
- `claude-code-source-code/src/components/mcp/MCPAgentServerMenu.tsx`
