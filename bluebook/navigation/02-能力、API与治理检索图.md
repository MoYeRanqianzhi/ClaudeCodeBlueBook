# 能力、API 与治理检索图

这一篇把“Claude Code 到底有多少能力表面”从单一功能表改成检索地图。

## 0. 先带着三条判断使用这张检索图

这张图虽然在回答“从哪里找”，但更稳的用法仍然要先带着三条判断：

1. Prompt 线提醒你：
   - 先分清你要找的是“能力存在的痕迹”，还是“什么已经合法进入模型当前可见世界”。
2. 治理线提醒你：
   - 先分清你要找的是“有哪些接口”，还是“哪些扩张当前被价格秩序允许进入当前世界”。
3. 源码质量线提醒你：
   - 先分清你要找的是“正式权威面”，还是“宿主子集、声明先行与公开镜像缺口”。

否则，这张图很容易重新退回一张更大的功能清单。

这里还应再固定一条 continuity 检索纪律：

- 检索 `compact / resume / memory / handoff` 时，先把它们看成三条母线在时间维度上的 consumer，不把它们先写成第四类能力平面。
- 更稳的分法是：`continue qualification` 回 Prompt 线，`continuation pricing` 回治理线，`recovery non-sovereignty / anti-zombie` 回源码质量线。

所以用这张检索图时，最稳的起手式不是“Claude Code 有没有 X”，而是先问：

1. 我现在要找的是存在性、可见性、被允许，还是产品承诺
2. 我现在要找的是权威入口，还是宿主子集 / 声明先行 / mirror gap

如果这两个问题还回答不清，就先不要留在检索图里：

1. 先回 `navigation/05`
   - 校正你到底在模仿功能表、治理表，还是控制面
2. 再回 `navigation/15`
   - 先找第一条反证信号与 first reject path
3. 最后回 `navigation/41`
   - 确认高阶结论是否已经压回第一性原理

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
| `compact / resume / memory / handoff` 为什么不是第四母线 | `09`、`navigation/05`、`navigation/15` | `navigation/41`、`userbook/02-能力地图/01-运行时主链/04-05`、`userbook/05-控制面深挖/03` |
| prompt 为什么强到不像单段 system prompt | `09`、`philosophy/84` | `architecture/82`、`guides/99`、`playbooks/77`、`casebooks/73` |
| 如果想先抓三条最高阶判断，而不是先读功能表 | `09`、`philosophy/84-87` | `guides/99-102`、`playbooks/77-79` |
| plugin / MCP / MCPB / channels / LSP 到底边界在哪 | `api/22` | `architecture/27`、`philosophy/20` |
| 安全、治理、远程高安全链路如何理解 | `risk/README.md` | `architecture/19`、`risk/05`、`risk/11` |
| 目录结构为什么本身就在暴露能力拓扑 | `api/30` | `architecture/24`、`architecture/38` |
| 为什么安全、治理与省 token 应该共读 | `09`、`philosophy/85` | `architecture/83`、`guides/100`、`playbooks/78`、`casebooks/74` |
| 为什么公开镜像仍然值得学 | `architecture/33`、`architecture/38` | `philosophy/23`、`navigation/03` |
| 如果想在公开镜像条件下稳当地判断源码质量 | `guides/102`、`philosophy/87` | `architecture/38`、`architecture/63`、`architecture/84` |

## 4. 功能全集和公开承诺不是一回事

在当前写法里，最容易犯的错误有三个：

1. 把源码里的入口直接写成公开承诺。
2. 把 schema 全集直接写成某个 adapter 已支持的子集。
3. 把产品成熟度直接写成协议支持度。

这三件事必须持续拆开。

对 continuity 检索尤其要先拆开三件事：

1. `summary / snapshot / pointer / archive` 只是 recovery asset，不自动拥有 present verdict。
2. `resume success`、状态转绿、标题匹配都只是结果词，不自动证明 `freshness gate` 还在。
3. `memory / compact / export` 只是不同 consumer，不自动代表同一层 signer。

## 5. 推荐目录协议

为了避免把主线、检索、深文和开发记忆重新混在一起，本书当前采用如下目录分工：

- `bluebook/` 根目录：只保留主线判断和兼容入口。
- `bluebook/navigation/`：负责让读者定位问题，不承载细碎实现。
- `bluebook/api/`：负责回答“有哪些表面、字段、消息与边界”。
- `bluebook/architecture/`：负责回答“这些表面在运行时里如何闭环”。
- `bluebook/philosophy/`：负责回答“为什么要这样设计，而不是别样设计”。
- `bluebook/risk/`：负责回答“治理与风控如何约束这套系统”。

## 6. 如何稳地使用这张图

如果你想用这张图避免误读，先固定四次自问：

1. 我现在要回答的是能力存在、当前可见、当前被允许，还是产品承诺？
2. 我现在更需要进入能力平面，还是先回到三条高阶判断？
3. 我现在需要的是字段级接口、运行时闭环，还是设计哲学解释？
4. 我现在看到的是公共主路径、宿主子集，还是公开镜像里的声明与缺口？

再加一问：

5. 我是不是又把 `Context Usage`、mode 条、token 百分比或 dashboard 投影误当成治理真相，而没有先回到 `decision window`、current admission 与 product promise 的分层判断？

如果问题仍偏“Claude Code 支不支持 X”，先回：

- `04-公开能力与隐藏能力.md`
- `05-功能全景与API支持.md`
- `08-能力全集、公开度与成熟度矩阵.md`

如果问题已偏“为什么要这样设计”，先回：

- `09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md`
- `philosophy/84-87`

如果问题已偏“公开镜像里怎样稳地下判断”，先回：

- `guides/102-如何给公开镜像做源码质量证据分级：public artifact ceiling、contract、registry、current-truth surface、consumer subset、hotspot kernel 与 mirror gap discipline.md`
