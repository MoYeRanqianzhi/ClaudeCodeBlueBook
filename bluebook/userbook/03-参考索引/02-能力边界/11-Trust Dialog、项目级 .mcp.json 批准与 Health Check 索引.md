# Trust Dialog、项目级 .mcp.json 批准与 Health Check 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/22-Trust Dialog、项目级 .mcp.json 批准与 Health Check：为什么 skip trust dialog 不等于 project MCP 已被批准.md`
- `05-控制面深挖/14-来源信任、Trust Dialog 与 Plugin-only Policy：扩展面为何分级信任.md`
- `05-控制面深挖/17-MCP 配置、按名解析与 Agent 引用：为什么你看到的 server 不是 Agent 真能挂上的 server.md`
- `05-控制面深挖/21-Host、Viewer 与 Health Check：为什么 server、remote-control、assistant、doctor 不能写成同一类会外入口.md`

## 1. 对象边界总表

| 对象/入口 | 回答的问题 | 稳定性 | 是否经过 trust dialog | 是否经过项目 MCP 批准对话框 | 是否可能做 health check | 正文语气 |
| --- | --- | --- | --- | --- | --- | --- |
| 交互 REPL 启动 | 这个工作区能不能进入受信任交互会话 | 稳定公开 | 是 | trust 之后才可能进入 | 否 | 写成 workspace trust 主线 |
| `handleMcpjsonServerApprovals(...)` | 哪些 project `.mcp.json` server 被本地允许 | 内部实现支点 | 之前已过 trust | 是 | 否 | 写成批准层，不写成独立产品入口 |
| `claude doctor` | 宿主与安装/MCP 运行面是否健康 | 稳定公开 | 否 | 否 | 是 | 写成聚合配置驱动的宿主健康检查 |
| `claude mcp list` | merged-config 视角下哪些 server 可连 | 稳定公开 | 否 | 否 | 是 | 写成“先聚合过滤，再批量探活” |
| `claude mcp get` | 按名直取到的单个 server 是否可连 | 稳定公开 | 否 | 否 | 是 | 写成“先按名直取，再单点探活” |
| `claude mcp reset-project-choices` | 清空项目 MCP 批准/拒绝记录 | 稳定公开 | 否 | 否 | 否 | 写成选择状态重置 |
| non-interactive / bypass fallback | 没法弹 popup 时 project server 如何判定 | 条件分支 | 不一定 | 否 | 不一定 | 写成 fallback，不写默认主线 |

## 2. 三层问题分别是什么

| 层 | 真正的问题 |
| --- | --- |
| workspace trust | 这个交互工作区能不能进入受信任启动链 |
| project MCP approval | 这些 project-scope `.mcp.json` server 里哪些被当前操作者允许 |
| health-check | 这次命令是不是在探测宿主/MCP 是否健康可连 |

## 3. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `skip trust dialog` = 目录已经 trusted | 只说明当前入口没进入 trust UI |
| trust 通过 = `.mcp.json` server 已批准 | trust 之后才会进入项目 MCP 批准链 |
| `doctor` = 项目 MCP 批准器 | 它是宿主健康检查入口 |
| `mcp list|get` = 只读配置查看 | 它们会做 live health check |
| `mcp list` = `mcp get` 的批量版 | 前者先聚合过滤，后者先按名直取 |
| `mcp list|get` skip trust = true non-interactive | non-interactive 是启动模式；trust skip 是命令边界 |
| project server 出现在 health check 里 = 已持久批准 | health-check 与批准记录不是同一层 |
| 自动批准 = 交互对话框的等价物 | 它是 bypass / non-interactive 下的 fallback |

## 4. 五个高价值判断问题

- 这里说的是 workspace trust、project server approval，还是 health-check？
- 当前入口有没有真正执行 `showSetupScreens(...)`？
- 当前入口有没有真正进入 `handleMcpjsonServerApprovals(...)`？
- 当前入口拿 server 的方式，是聚合配置还是按名直取？
- 这里记录的是本地批准状态，还是只是在做连接探针？
- 我是不是把 non-interactive fallback 写成了所有 trust-skip 命令的共同语义？

## 5. 稳定面与内部面速记

| 类型 | 对象 |
| --- | --- |
| 稳定公开 | trust dialog、`doctor`、`mcp list`、`mcp get`、`mcp reset-project-choices` |
| 条件分支 | bypass auto-approve、non-interactive auto-approve |
| 内部实现支点 | `handleMcpjsonServerApprovals(...)`、`approvedProjectServers`、本地 settings 字段、`getMcpConfigByName()` |

## 6. 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/interactiveHelpers.tsx`
- `claude-code-source-code/src/bootstrap/state.ts`
- `claude-code-source-code/src/services/mcpServerApproval.tsx`
- `claude-code-source-code/src/services/mcp/utils.ts`
- `claude-code-source-code/src/services/mcp/config.ts`
- `claude-code-source-code/src/cli/handlers/mcp.tsx`
- `claude-code-source-code/src/components/MCPServerApprovalDialog.tsx`
- `claude-code-source-code/src/components/MCPServerMultiselectDialog.tsx`
