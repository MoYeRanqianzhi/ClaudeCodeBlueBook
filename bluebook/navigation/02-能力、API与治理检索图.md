# 能力、API 与治理检索图

这一篇把“Claude Code 到底有多少能力表面”从单一功能表改成检索地图。

## 1. 能力全集不是一个平面

按当前源码快照，可见的能力至少分为七层：

1. 命令层：`src/commands/` 下可见 `86` 个一级命令目录，另有 `commit.ts`、`review.ts`、`security-review.ts`、`ultraplan.tsx` 等根命令。
2. 工具层：`src/tools/` 下可见 `42` 个一级工具目录，覆盖文件、shell、LSP、MCP、任务、团队、多 Agent、remote trigger、worktree 等。
3. 服务层：`src/services/` 下可见 `20` 个一级服务域，覆盖 API、compact、analytics、MCP、LSP、plugins、remote managed settings、team memory sync 等。
4. 协议层：`src/entrypoints/sdk/controlSchemas.ts`、`coreSchemas.ts`、`agentSdkTypes.ts` 暴露 SDK、control、session 与宿主接入表面。
5. 宿主层：`src/cli/structuredIO.ts`、`src/cli/remoteIO.ts`、bridge/direct-connect/remote-session 构成 host control plane。
6. 状态层：`Task.ts`、`query.ts`、`state/*`、session storage、worker metadata 共同维护运行时真相。
7. 治理层：账号、组织、GrowthBook、策略、allowlist、trusted device、remote managed settings、风控恢复共同约束运行时。

所以“功能支持”必须同时写“调用面、约束面、治理面”。

## 2. 关键源码锚点

- `claude-code-source-code/src/commands.ts:224-258`
- `claude-code-source-code/src/tools.ts:185-250`
- `claude-code-source-code/src/Tool.ts:158-179`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-121`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:578-660`
- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:112-180`
- `claude-code-source-code/src/cli/structuredIO.ts:59-173`
- `claude-code-source-code/src/cli/remoteIO.ts:227-238`
- `claude-code-source-code/src/Task.ts:6-124`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/services/mcp/MCPConnectionManager.tsx:1-1`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:1-1`

## 3. 按问题检索

| 如果你要回答的问题 | 优先看哪里 | 再看哪里 |
| --- | --- | --- |
| Claude Code 现在到底支持哪些命令域 | `api/01`、`api/06`、`api/07` | `05-功能全景与API支持.md` |
| Claude Code 到底暴露了哪些 builtin tools | `api/08` | `architecture/02`、`architecture/23` |
| 它如何做多 Agent / task / team | `guides/02` | `architecture/10`、`architecture/30` |
| 长任务为什么不该再写成多轮聊天 | `guides/06` | `architecture/34`、`philosophy/25` |
| 宿主如何接控制协议 | `api/13`、`api/14`、`api/15` | `architecture/13`、`architecture/15` |
| 宿主如何拿到恢复与状态真相 | `api/16`、`api/17`、`api/19`、`api/20` | `architecture/16`、`architecture/17`、`architecture/25` |
| prompt、知识、记忆从哪里注入 | `api/18`、`api/21` | `architecture/18`、`architecture/28`、`architecture/29` |
| plugin / MCP / MCPB / channels / LSP 到底边界在哪 | `api/22` | `architecture/27`、`philosophy/20` |
| 安全、治理、远程高安全链路如何理解 | `risk/README.md` | `architecture/19`、`risk/05`、`risk/11` |
| 目录结构为什么本身就在暴露能力拓扑 | `api/30` | `architecture/24`、`architecture/38` |

## 4. 功能全集和公开承诺不是一回事

在当前写法里，最容易犯的错误有三个：

1. 把源码里的入口直接写成公开承诺。
2. 把 schema 全集直接写成某个 adapter 已支持的子集。
3. 把产品成熟度直接写成协议支持度。

这三件事必须持续拆开。

## 5. 推荐目录协议

为了避免后续继续把主线写厚，这一轮采用如下目录协议：

- `bluebook/` 根目录：只保留主线判断和兼容入口。
- `bluebook/navigation/`：负责让读者定位问题，不承载细碎实现。
- `bluebook/api/`：负责回答“有哪些表面、字段、消息与边界”。
- `bluebook/architecture/`：负责回答“这些表面在运行时里如何闭环”。
- `bluebook/philosophy/`：负责回答“为什么要这样设计，而不是别样设计”。
- `bluebook/risk/`：负责回答“治理与风控如何约束这套系统”。

## 6. 这张图暴露出的当前空白

从检索视角看，当前最值得继续补强的是：

1. 源码目录级索引继续下沉到二级目录与代表性叶子模块。
2. SDK/control/session/remote 的统一接入矩阵继续补 subtype / recovery casebook。
3. prompt 魔力、安全分层、token 经济三者的同构关系继续回灌到主线与指南。
4. 源码先进性与热点大文件债务如何同时成立，继续补 chokepoint / leaf module casebook。
