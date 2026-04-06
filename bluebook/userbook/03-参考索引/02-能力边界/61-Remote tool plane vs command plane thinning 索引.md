# Remote tool plane vs command plane thinning 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/72-getTools、useMergedTools、mcp.tools 与 toolPermissionContext：为什么 remote session 的 tool plane 不会像 command plane 一样一起变薄.md`
- `05-控制面深挖/71-useSkillsChange、useManagePlugins、MCPConnectionManager 与 useMergedCommands：为什么 remote session 的本地命令面不是持续增厚的本地 REPL，也不是完全冻结的远端镜像.md`
- `05-控制面深挖/68-slash_commands、REMOTE_SAFE_COMMANDS、local-jsx fallthrough 与 remote send：为什么 remote session 的远端发布命令面、本地保留命令面与实际执行路由不是同一张命令表.md`

边界先说清：

- 这页不是工具系统总索引。
- 这页不是命令系统总索引。
- 这页只抓 remote session 下 `command plane` 与 `tool plane` 为什么不会同样变薄。

## 1. 三类对象总表

| 类别 | 回答的问题 | 典型对象 |
| --- | --- | --- |
| `Command Thinning` | 哪些本地命令增厚链被关掉 | `useSkillsChange`、`useManagePlugins` |
| `Tool Reassembly` | 本地工具池如何继续重算 | `getTools`、`useMergedTools`、`computeTools` |
| `MCP Porosity` | MCP 在哪边更直接渗透 | `mcp.tools`、`mcp.commands` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 命令面薄了，工具面也同样冻结 | 工具面仍会按 context 和 MCP 重算 |
| 工具面活着，所以命令面也还是满血 | 两者装配链不同 |
| MCP 在命令面和工具面的进入难度相同 | 工具面接入更直接 |
| remote 本地壳层只有一层厚度 | 至少要分 command plane / tool plane |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `command plane` 更薄，`tool plane` 更活 |
| 条件公开 | `toolPermissionContext.mode`、`mcp.tools` 是否有新产出 |
| 内部/实现层 | built-in tool gating、tool pool merge/filter 细节 |

## 4. 七个检查问题

- 我现在讨论的是命令面还是工具面？
- `initialTools` 是空，还是 `localTools` 仍会现算？
- `mcp.commands` 和 `mcp.tools` 是不是被不同装配链消费？
- 当前工具面是不是会跟随 permission mode 重算？
- 我是不是把 command thinning 外推成 tool freezing？
- 我是不是把 MCP porosity 说成在两边完全对称？
- 我是不是又把 remote 本地壳层写成单层结构了？

## 5. 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/hooks/useMergedTools.ts`
- `claude-code-source-code/src/services/mcp/useManageMCPConnections.ts`
- `claude-code-source-code/src/tools.ts`
- `claude-code-source-code/src/utils/toolPool.ts`
