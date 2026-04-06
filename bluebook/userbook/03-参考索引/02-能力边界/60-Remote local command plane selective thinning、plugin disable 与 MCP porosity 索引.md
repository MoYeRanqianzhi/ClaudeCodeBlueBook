# Remote local command plane selective thinning、plugin disable 与 MCP porosity 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/71-useSkillsChange、useManagePlugins、MCPConnectionManager 与 useMergedCommands：为什么 remote session 的本地命令面不是持续增厚的本地 REPL，也不是完全冻结的远端镜像.md`
- `05-控制面深挖/70-disableSlashCommands、commands=[]、hasCommand 与 remote send：为什么关掉本地 slash 命令层，不等于 remote mode 失去 slash 文本入口.md`
- `05-控制面深挖/68-slash_commands、REMOTE_SAFE_COMMANDS、local-jsx fallthrough 与 remote send：为什么 remote session 的远端发布命令面、本地保留命令面与实际执行路由不是同一张命令表.md`

边界先说清：

- 这页不是 MCP 全景索引。
- 这页不是插件系统全景索引。
- 这页只抓 remote session 本地命令面为什么默认变薄、却仍保留局部合流孔道。

## 1. 三类结构总表

| 类别 | 回答的问题 | 典型对象 |
| --- | --- | --- |
| `Disabled Enrichers` | 哪些本地增厚链被关掉 | `useSkillsChange`、`useManagePlugins`、`useSwarmInitialization` |
| `Empty Defaults` | 初始是不是空壳起步 | `initialState.plugins` / `initialState.mcp` |
| `Porous Merge Paths` | 哪些状态仍可继续渗入命令面 | `MCPConnectionManager`、`mcp.commands`、`useMergedCommands` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| remote session 的本地命令面就是冻结快照 | 默认变薄，但 MCP 合流孔道仍在 |
| remote session 仍会自动跟随本地 skills / plugins 增厚 | 这些本地增厚链被主动关掉 |
| 既然还能合并 MCP commands，就说明还是本地满血 | 起跑仍是空壳，且多条本地 enrichers 已被禁 |
| “薄”只发生在 slash 命令 | swarm、Chrome prompt、IDE enrichers 也一起被压低 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | 远端模式会关掉一组本地增厚器；`mcp.commands` 仍有结构性合流路径 |
| 条件公开 | 是否真的有 MCP commands 注入、当前配置是否带来本地客户端/服务端变化 |
| 内部/实现层 | 动态 MCP 配置来源、具体 server 注入细节、hook 初始化顺序 |

## 4. 七个检查问题

- 我现在讨论的是本地自发生长链，还是 store 合流孔道？
- 当前 remote session 的 `plugins` / `mcp` 是不是空壳起步？
- `useSkillsChange` 有没有 cwd？
- `useManagePlugins` 有没有启用？
- `MCPConnectionManager` 是不是仍然在挂？
- 我是不是把“remote 薄”误写成“remote 冻结”了？
- 我是不是又把局部 MCP 孔道夸大成“本地满血”了？

## 5. 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/hooks/useSkillsChange.ts`
- `claude-code-source-code/src/hooks/useManagePlugins.ts`
- `claude-code-source-code/src/hooks/useSwarmInitialization.ts`
- `claude-code-source-code/src/services/mcp/MCPConnectionManager.tsx`
- `claude-code-source-code/src/services/mcp/useManageMCPConnections.ts`
- `claude-code-source-code/src/hooks/useMergedCommands.ts`
