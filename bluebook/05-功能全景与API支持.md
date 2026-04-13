# 功能全景与 API 支持

这一章回答两个 bridge 问题:

1. Claude Code 到底支持哪些能力面。
2. 这些能力分别通过什么接口暴露出来。

为了避免“看到一点功能就写一点功能”的碎片化，本章按 runtime 表面来组织；但它不再承担 capability 首答权，只承担 capability / API bridge。
能力全景层也继续继承 `问题分型 -> 工作对象 -> 控制面 -> 入口`；它只负责把正式 surface 与代表入口列成索引，不额外改判 `current admission` 或 `product promise`。用户侧能力地图统一回 `userbook/02`，host-facing truth 与 contract 统一回 `api/README`。

## 0. 先带着三条判断读功能表

这一章虽然在列能力面，但更稳的读法不是把它当“功能总清单”，而是先带着三句 bridge judgment 来读：

1. Prompt 线
   - 这些接口最终在帮助 later consumer 于 `verify / delegate / tool choice / resume / handoff` 时继续消费同一份 `compiled request truth`，而不是在 `resume / handoff / compaction` 后重判继续资格、把已排除路径重新拉回候选集
2. 治理线
   - 这些接口最终在决定什么扩张配进入当前世界，以及继续前有没有补齐 `repricing proof / lease checkpoint / cleanup`；`Context Usage` 不是功能前门答案，而是 `decision window` 投影
3. 源码质量线
   - 这些接口是主路径能力、consumer subset、hotspot kernel 入口，还是仍只配停在 mirror gap discipline 层；若继续追源码质量，还要先问复杂度是否落在合法中心、现在是否仍只有一个可写现在、later maintainer 是否仍保有正式 veto

如果不先带着这三句判断，本章就很容易重新退回：

- “能力很多”
- “接口很多”
- “好像什么都支持”

第一性原理上，接口面不是功能炫耀，而是 runtime 决定什么能进入模型、什么能进入当前世界、什么又能以何种代价持续存在的合法入口。

这里还应再多记一句：

- `continuity` 在功能表里也不是第九类接口表面；它只是交互、状态、远程与协作这些 surface 在 `Continuation / continuation pricing / re-entry` 上的时间轴读法。

所以本章里每列出一个“能力面”，都还要继续追问四次。最小顺序应固定为：

1. 入口是否存在
2. 当前公开实现是否闭合
3. 当前是否进入主路径或至少进入稳定子集
4. 当前是否已被允许，并且已形成可对外承诺的产品面

如果把功能表前门继续压成最短公式，也只剩三句：

1. 用户在问“我能看到什么、能怎么进入”时，先回 `userbook/02`。
2. 宿主在问“contract / schema / host-facing truth 是什么”时，先回 `api/README`。
3. 若还在问“到底算不算支持、算不算承诺”，先回 `09` 定控制面；若问题已经变成 route dispute，再回 `navigation/README` 分流，不要在 taxonomy 里找 verdict。

如果这四问还回答不清，就不要继续停在功能总览页：

1. 回 `09`
   - 先定义世界进入模型、扩张定价与当前真相保护。
2. 若争议已经变成 route dispute
   - 回 `navigation/README`；功能总览页不再替 later consumer 预排固定导航顺序。

## 1. 前门首答：先治理判定，再查接口索引

这一章的前门首答不再是“有多少接口层”，而是先回答三件事：

1. 这组入口是否仍在同一个 `compiled request truth` 内
2. 它当前是否通过 `decision window`，并在继续前补齐 `repricing proof / lease checkpoint / cleanup`，进入 `current admission`
3. 它是否已经从实现事实上升为可对外承诺的 `product promise`，且仍不逼 later consumer 重判继续资格，也不破坏 `one writable present`

只有这三问先稳定，接口 taxonomy 才有阅读价值。为避免“接口表面”抢占首答权，本章把接口面降格为四组索引：

1. 交互与执行
2. 宿主与控制
3. 远程与状态
4. 协作与扩展

它们只用于定位对象与源码证据，不直接产出“已支持/已承诺”的结论。真正的支持结论，仍由上面的治理判定给出；本页自己只做 bridge，不重发 capability first answer。

治理线里还要额外补一句：

- `Context Usage`、mode 条、token 百分比与 dashboard 投影都不是功能前门答案；它们只能在 `decision window / current admission / product promise` 已经分清后，作为宿主消费投影继续出现
- `Context Usage`、mode 条、token 百分比、dashboard 投影与 host replay 也不是治理说话面；若不能新增 `repricing / deny / cleanup` 决策增益，就只配当 `weak readback / tail evidence`，不配回判 `current admission`

因此下面的长表只负责给出代表入口与对象 truth，不再抢答“是否支持到哪一层”。更细的矩阵与对象总表，统一回到 `08`、`api/23`、`api/24` 与 `api/30`。

更稳的 first reject signal 也该先写在这里：

- mode 条、usage dashboard 与 UI 面板不是能力前门答案
- build-time 痕迹不是产品承诺
- transport shell 不是 current admission

## 2. 代表性能力面与对象 truth 索引（后读）

下面各节只保留代表入口，用来回答：

- 这一面确实存在什么正式对象
- 当前公开树里能看到哪些实现真相

进入索引前先过一遍首答顺序：

1. 先判 `current admission`
2. 再查实现闭合度
3. 最后才读分类细节

如果第一步还不清楚，先回治理页，不继续在 taxonomy 里找答案。

它们默认还没有替你回答：

- 当前是否进入主路径
- 当前是否已被允许
- 当前是否已形成产品承诺

### 2.1 交互与工作流控制

源码中同时存在三层命令面：

- `src/commands/` 下可见 `86` 个一级命令目录
- `COMMANDS()` 主列表作为 builtin 控制平面
- `getCommands()` 在运行时继续叠加 skills、plugins、workflow 与 dynamic skills

因此 Claude Code 的命令面不能只按 builtin slash command 理解。除此之外，它还会动态叠加:

- bundled skills
- builtin plugin skills
- skill dir commands
- workflow commands
- plugin commands
- plugin skills
- dynamic skills

证据:

- `claude-code-source-code/src/commands.ts:224-346`
- `claude-code-source-code/src/commands.ts:258-346`
- `claude-code-source-code/src/commands.ts:449-469`
- `claude-code-source-code/src/commands.ts:476-517`

这说明 slash command 不是旁路，而是产品的正式控制平面。

### 2.2 工具执行面

本地 `src/tools/` 一级目录中约有 `42` 个工具子目录，`getAllBaseTools()` 则定义了运行时基础工具全集。

其中稳定主路径工具包括:

- `BashTool`
- `FileReadTool`
- `FileEditTool`
- `FileWriteTool`
- `NotebookEditTool`
- `WebFetchTool`
- `WebSearchTool`
- `TodoWriteTool`
- `AgentTool`
- `SkillTool`
- `AskUserQuestionTool`
- MCP 资源与任务相关工具

证据:

- `claude-code-source-code/src/tools.ts:193-250`
- `claude-code-source-code/src/tools.ts:271-367`

### 2.3 命令/技能/插件三层能力面

`Command` 在类型层被明确分成三类:

- `prompt`
- `local`
- `local-jsx`

并带有:

- `availability`
- `isEnabled`
- `loadedFrom`
- `whenToUse`
- `allowedTools`
- `context`
- `agent`
- `effort`

证据:

- `claude-code-source-code/src/types/command.ts:25-57`
- `claude-code-source-code/src/types/command.ts:74-152`
- `claude-code-source-code/src/types/command.ts:175-206`

这意味着 Claude Code 的命令面本质上也是一套可组合的 API。

### 2.4 SDK / automation 面

SDK 公开入口 `agentSdkTypes.ts` 暴露了至少两类东西:

- 类型与 schema 导出的公共面
- 会话、查询、session 管理、SDK-MCP server 构造等函数面

显式可见函数包括:

- `tool(...)`
- `createSdkMcpServer(...)`
- `query(...)`
- `unstable_v2_createSession(...)`
- `unstable_v2_resumeSession(...)`
- `unstable_v2_prompt(...)`
- `getSessionMessages(...)`
- `listSessions(...)`
- `getSessionInfo(...)`
- `renameSession(...)`
- `tagSession(...)`
- `forkSession(...)`

证据:

- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:17-31`
- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:73-107`
- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:111-272`

### 2.5 宿主与控制协议面

`StructuredIO`、`controlSchemas.ts`、`print.ts` 共同说明：

- Claude Code 有正式的 `control_request` / `control_response` / `control_cancel_request` 协议。
- host 可以发 `interrupt`、`get_context_usage`、`mcp_status`、`mcp_set_servers`、`get_settings` 等控制请求。
- `StructuredIO` 内部显式维护 `pendingRequests`、`resolvedToolUseIds`、统一 FIFO outbound。

这意味着 Claude Code 的自动化面并不止于“脚本化 query”，还包括“宿主级控制平面”。

证据:

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-173`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:175-519`
- `claude-code-source-code/src/cli/structuredIO.ts:135-162`
- `claude-code-source-code/src/cli/structuredIO.ts:333-429`
- `claude-code-source-code/src/cli/structuredIO.ts:470-773`

### 2.6 MCP / transport 面

MCP 在 Claude Code 中既是 client 扩展总线，也是可反向暴露的 server 表面。

支持的 transport 类型至少包括:

- `stdio`
- `sse`
- `sse-ide`
- `http`
- `ws`
- `sdk`

证据:

- `claude-code-source-code/src/services/mcp/types.ts:10-26`
- `claude-code-source-code/src/services/mcp/types.ts:124-161`

### 2.7 远程与桥接面

远程执行面并不是单一 websocket，而是至少三条路径:

- `StructuredIO` 负责 control request/response 语义
- `RemoteIO` 负责 transport、session token、CCR v2、keepalive
- `DirectConnectSessionManager` 与 `RemoteSessionManager` 进一步把宿主面窄化成 direct-connect 与 remote-session 两类接入器

证据:

- `claude-code-source-code/src/cli/structuredIO.ts:135-162`
- `claude-code-source-code/src/cli/remoteIO.ts:31-42`
- `claude-code-source-code/src/cli/remoteIO.ts:111-168`
- `claude-code-source-code/src/server/directConnectManager.ts:40-210`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts:87-323`

### 2.8 状态回写与宿主真相面

Claude Code 的状态接口不只体现在：

- `SDKMessage`
- session API
- transcript / rewind

还体现在宿主真相回写面：

- `worker_status`
- `requires_action_details`
- `external_metadata.pending_action`
- `external_metadata.permission_mode`
- `external_metadata.model`

这说明它给宿主暴露的不是“只读消息流”，而是“消息流 + 可查询状态快照”的组合 API。

证据：

- `claude-code-source-code/src/utils/sessionState.ts:1-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:19-91`
- `claude-code-source-code/src/cli/transports/ccrClient.ts:476-545`
- `claude-code-source-code/src/cli/transports/ccrClient.ts:645-662`
- `claude-code-source-code/src/cli/remoteIO.ts:111-168`

### 2.9 提示词与上下文注入面

Claude Code 还有一层经常被低估的正式接口面：

- `--system-prompt`
- `--append-system-prompt`
- SDK `initialize.systemPrompt`
- SDK `initialize.appendSystemPrompt`
- agent `getSystemPrompt()`
- skill `getPromptForCommand(...)`
- attachment / reminder 注入

也就是说，prompt 在 Claude Code 中不是一段隐藏常量，而是一组可装配注入面。

但这层表面真正值钱的不是“可以注入多少 prompt”，而是这些入口最终都要回到请求装配控制面：`authority chain`、`section registry`、`protocol transcript` 与 `continuation qualification` 是否仍围绕同一个 `compiled request truth`。

证据:

- `claude-code-source-code/src/main.tsx:1343-1387`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-72`
- `claude-code-source-code/src/utils/systemPrompt.ts:27-121`
- `claude-code-source-code/src/skills/loadSkillsDir.ts:181-344`
- `claude-code-source-code/src/tools/AgentTool/loadAgentsDir.ts:474-731`

### 2.10 协作与 workflow 面

Claude Code 还有一层常被低估的正式接口面：

- coordinator system prompt
- worker / teammate prompt addendum
- `team_context` / `teammate_mailbox` attachments
- `task_started` / `task_progress` / `task_notification`
- workflow progress delta

这意味着它暴露的不只是“起一个 subagent”：

- 还有多 Agent 协作协议
- task 生命周期事件
- workflow 分阶段进度

证据：

- `claude-code-source-code/src/coordinator/coordinatorMode.ts:111-260`
- `claude-code-source-code/src/utils/messages.ts:3457-3490`
- `claude-code-source-code/src/utils/swarm/inProcessRunner.ts:871-1043`
- `claude-code-source-code/src/utils/sdkEventQueue.ts:1-118`
- `claude-code-source-code/src/utils/task/sdkProgress.ts:1-35`

### 2.11 恢复与持久化面

Claude Code 还有一层很容易被误算进“内部实现”的正式表面：

- transcript
- sidechain transcript
- `output_file`
- resume / continue
- file history / rewind

这说明它暴露的不是一次性执行 API，而是：

- 可恢复执行 API

证据：

- `claude-code-source-code/src/utils/sessionStorage.ts:1451-1545`
- `claude-code-source-code/src/utils/conversationRecovery.ts:456-541`
- `claude-code-source-code/src/utils/sessionRestore.ts:99-147`
- `claude-code-source-code/src/tasks/LocalMainSessionTask.ts:358-416`
- `claude-code-source-code/src/utils/task/TaskOutput.ts:32-110`

### 2.12 任务、工作流与服务平面

如果继续把“全部功能支持”往下压，会发现还有两层经常被漏写：

1. 任务与工作流面：
   - `TaskType` 当前显式区分 `local_bash`、`local_agent`、`remote_agent`、`in_process_teammate`、`local_workflow`、`monitor_mcp`、`dream`
   - `getAllTasks()` 当前显式注册 `LocalShellTask`、`LocalAgentTask`、`RemoteAgentTask`、`DreamTask`，并按 gate 注入 `LocalWorkflowTask` 与 `MonitorMcpTask`
2. 服务平面：
   - `src/services/` 当前至少可见约 `20` 个一级子域，覆盖 `api`、`compact`、`mcp`、`plugins`、`SessionMemory`、`remoteManagedSettings`、`policyLimits`、`analytics` 等

这意味着 Claude Code 的能力面不仅是“命令 + 工具 + SDK”，还包括：

- 后台任务对象模型
- workflow 执行与可视化
- 长生命周期服务子系统

证据：

- `claude-code-source-code/src/Task.ts:6-124`
- `claude-code-source-code/src/tasks.ts:1-39`
- `claude-code-source-code/src/services/`

### 2.13 对象 truth 与回链

前面的长表到这里应当停住。它们的职责只是把代表对象摆出来，避免蓝皮书把 runtime 缩成几个命令、几个工具和一条 `query()`。

如果继续追问“当前到底承诺到哪”，就不该让这些长表在前门里继续抢答，而应回到矩阵页和对象 truth 页：

- [能力平面、公开度与宿主支持矩阵](api/23-%E8%83%BD%E5%8A%9B%E5%B9%B3%E9%9D%A2%E3%80%81%E5%85%AC%E5%BC%80%E5%BA%A6%E4%B8%8E%E5%AE%BF%E4%B8%BB%E6%94%AF%E6%8C%81%E7%9F%A9%E9%98%B5.md)
- [命令、工具、会话、宿主与协作 API 全谱系](api/24-%E5%91%BD%E4%BB%A4%E3%80%81%E5%B7%A5%E5%85%B7%E3%80%81%E4%BC%9A%E8%AF%9D%E3%80%81%E5%AE%BF%E4%B8%BB%E4%B8%8E%E5%8D%8F%E4%BD%9CAPI%E5%85%A8%E8%B0%B1%E7%B3%BB.md)
- [源码目录级能力地图：commands、tools、services、状态与宿主平面](api/30-%E6%BA%90%E7%A0%81%E7%9B%AE%E5%BD%95%E7%BA%A7%E8%83%BD%E5%8A%9B%E5%9C%B0%E5%9B%BE%EF%BC%9Acommands%E3%80%81tools%E3%80%81services%E3%80%81%E7%8A%B6%E6%80%81%E4%B8%8E%E5%AE%BF%E4%B8%BB%E5%B9%B3%E9%9D%A2.md)

这些回链的价值不在新增字段，而在于把：

- 命令控制平面
- 工具执行平面
- 任务/团队协作平面
- worktree / remote / trigger 自动化平面
- query / session / control / remote 接入平面

重新放回同一张能力与接入地图，并按四层判断继续拆开。

## 3. API 支持的首答顺序（压缩版）

API 支持不按“至少七层”首答，而按四问首答：

1. 入口是否存在且语义明确
2. 实现是否在当前公开树里闭合成 `current-truth surface`
3. 是否进入主路径或稳定 `consumer subset`
4. 是否已经形成对外 `product promise`

只有四问过关，才允许把某个入口写成“支持”。否则最多写成“可见实现”或“声明痕迹”。

若需要排障或定位，再把对象投影到常见观察位即可：

- 人类命令与交互
- 工具/任务/结构化能力
- 宿主控制协议与状态回写
- 传输与远程接入
- 提示词注入、协作与生态扩展

这些观察位只是定位视角，不是前门结论本身。

## 4. 这章真正要纠正哪些判断误差

这章真正要纠正的，不是“知识不够多”，而是四类判断误差：

1. 不再只讲架构，而忽略命令、工具、SDK、MCP、远程这些正式接口面。
2. 不再把 public/gated/internal 混写，而是把接口边界、能力边界和产品边界分开。
3. 不再只看“模型如何调用工具”，而是把“外部宿主如何控制 CLI”也纳入 API 版图。
4. 不再把宿主集成只写成事件流，而是把状态回写、外部 metadata 与 consumer subset 也纳入 API 真相面。
5. 不再只问“有没有接口”，而开始问“它属于公共主路径、宿主主路径、声明先行还是产品受限”。

## 5. 仍然存在的边界

需要明确三点:

1. `agentSdkTypes.ts` 会 re-export `runtimeTypes`、`toolTypes`、`controlTypes` 等子模块，但这份提取源码里没有看到这些源码文件；因此本章对 SDK 的判断以入口、schema 和已知导出为准。
2. 出现于公开源码中的 schema 或函数名，不等于它已经是对外稳定承诺。
3. 被 `feature()` 或 GrowthBook gate 控制的接口，不应直接写成“所有用户都可用”。

## 6. 如果要继续把能力表读稳，优先回到哪里

如果你正在追问“Claude Code 到底暴露了哪些正式能力面”，优先回：

- [能力全集、公开度与成熟度矩阵](08-%E8%83%BD%E5%8A%9B%E5%85%A8%E9%9B%86%E3%80%81%E5%85%AC%E5%BC%80%E5%BA%A6%E4%B8%8E%E6%88%90%E7%86%9F%E5%BA%A6%E7%9F%A9%E9%98%B5.md)
- [命令与功能矩阵](api/01-%E5%91%BD%E4%BB%A4%E4%B8%8E%E5%8A%9F%E8%83%BD%E7%9F%A9%E9%98%B5.md)
- [内置命令域索引](api/06-%E5%86%85%E7%BD%AE%E5%91%BD%E4%BB%A4%E5%9F%9F%E7%B4%A2%E5%BC%95.md)
- [命令字段与可用性索引](api/07-%E5%91%BD%E4%BB%A4%E5%AD%97%E6%AE%B5%E4%B8%8E%E5%8F%AF%E7%94%A8%E6%80%A7%E7%B4%A2%E5%BC%95.md)
- [能力平面、公开度与宿主支持矩阵](api/23-%E8%83%BD%E5%8A%9B%E5%B9%B3%E9%9D%A2%E3%80%81%E5%85%AC%E5%BC%80%E5%BA%A6%E4%B8%8E%E5%AE%BF%E4%B8%BB%E6%94%AF%E6%8C%81%E7%9F%A9%E9%98%B5.md)
- [命令、工具、会话、宿主与协作 API 全谱系](api/24-%E5%91%BD%E4%BB%A4%E3%80%81%E5%B7%A5%E5%85%B7%E3%80%81%E4%BC%9A%E8%AF%9D%E3%80%81%E5%AE%BF%E4%B8%BB%E4%B8%8E%E5%8D%8F%E4%BD%9CAPI%E5%85%A8%E8%B0%B1%E7%B3%BB.md)
- [源码目录级能力地图：commands、tools、services、状态与宿主平面](api/30-%E6%BA%90%E7%A0%81%E7%9B%AE%E5%BD%95%E7%BA%A7%E8%83%BD%E5%8A%9B%E5%9C%B0%E5%9B%BE%EF%BC%9Acommands%E3%80%81tools%E3%80%81services%E3%80%81%E7%8A%B6%E6%80%81%E4%B8%8E%E5%AE%BF%E4%B8%BB%E5%B9%B3%E9%9D%A2.md)

如果你正在追问“宿主如何接入、控制、恢复与消费真相”，优先回：

- [Agent SDK 与控制协议](api/02-Agent%20SDK%E4%B8%8E%E6%8E%A7%E5%88%B6%E5%8D%8F%E8%AE%AE.md)
- [StructuredIO 与 RemoteIO 宿主协议手册](api/13-StructuredIO%E4%B8%8ERemoteIO%E5%AE%BF%E4%B8%BB%E5%8D%8F%E8%AE%AE%E6%89%8B%E5%86%8C.md)
- [Control 子类型与宿主适配矩阵](api/14-Control%E5%AD%90%E7%B1%BB%E5%9E%8B%E4%B8%8E%E5%AE%BF%E4%B8%BB%E9%80%82%E9%85%8D%E7%9F%A9%E9%98%B5.md)
- [Control 协议字段对照与宿主接入样例](api/15-Control%E5%8D%8F%E8%AE%AE%E5%AD%97%E6%AE%B5%E5%AF%B9%E7%85%A7%E4%B8%8E%E5%AE%BF%E4%B8%BB%E6%8E%A5%E5%85%A5%E6%A0%B7%E4%BE%8B.md)
- [SDK 消息与 Control 闭环对照表](api/16-SDK%E6%B6%88%E6%81%AF%E4%B8%8EControl%E9%97%AD%E7%8E%AF%E5%AF%B9%E7%85%A7%E8%A1%A8.md)
- [状态消息、外部元数据与宿主消费矩阵](api/17-%E7%8A%B6%E6%80%81%E6%B6%88%E6%81%AF%E3%80%81%E5%A4%96%E9%83%A8%E5%85%83%E6%95%B0%E6%8D%AE%E4%B8%8E%E5%AE%BF%E4%B8%BB%E6%B6%88%E8%B4%B9%E7%9F%A9%E9%98%B5.md)
- [MCP 与远程传输](api/03-MCP%E4%B8%8E%E8%BF%9C%E7%A8%8B%E4%BC%A0%E8%BE%93.md)

如果你正在追问“Prompt、记忆、扩展与生态怎样进入这套 runtime”，优先回：

- [系统提示词、Frontmatter 与上下文注入手册](api/18-%E7%B3%BB%E7%BB%9F%E6%8F%90%E7%A4%BA%E8%AF%8D%E3%80%81Frontmatter%E4%B8%8E%E4%B8%8A%E4%B8%8B%E6%96%87%E6%B3%A8%E5%85%A5%E6%89%8B%E5%86%8C.md)
- [提示词控制、知识注入与记忆 API 手册](api/21-%E6%8F%90%E7%A4%BA%E8%AF%8D%E6%8E%A7%E5%88%B6%E3%80%81%E7%9F%A5%E8%AF%86%E6%B3%A8%E5%85%A5%E4%B8%8E%E8%AE%B0%E5%BF%86API%E6%89%8B%E5%86%8C.md)
- [扩展 Frontmatter 与插件 Agent 手册](api/10-%E6%89%A9%E5%B1%95Frontmatter%E4%B8%8E%E6%8F%92%E4%BB%B6Agent%E6%89%8B%E5%86%8C.md)
- [MCP 配置与连接状态机](api/12-MCP%E9%85%8D%E7%BD%AE%E4%B8%8E%E8%BF%9E%E6%8E%A5%E7%8A%B6%E6%80%81%E6%9C%BA.md)
- [插件、Marketplace、MCPB、LSP与Channels接入边界手册](api/22-%E6%8F%92%E4%BB%B6%E3%80%81Marketplace%E3%80%81MCPB%E3%80%81LSP%E4%B8%8EChannels%E6%8E%A5%E5%85%A5%E8%BE%B9%E7%95%8C%E6%89%8B%E5%86%8C.md)

如果你正在追问“这些接口为什么要按这种方式设计”，优先回：

- [compact 算法与上下文管理细拆](architecture/08-compact%E7%AE%97%E6%B3%95%E4%B8%8E%E4%B8%8A%E4%B8%8B%E6%96%87%E7%AE%A1%E7%90%86%E7%BB%86%E6%8B%86.md)
- [会话存储、记忆与回溯状态面](architecture/09-%E4%BC%9A%E8%AF%9D%E5%AD%98%E5%82%A8%E8%AE%B0%E5%BF%86%E4%B8%8E%E5%9B%9E%E6%BA%AF%E7%8A%B6%E6%80%81%E9%9D%A2.md)
- [AgentTool 与隔离编排](architecture/10-AgentTool%E4%B8%8E%E9%9A%94%E7%A6%BB%E7%BC%96%E6%8E%92.md)
- [权限系统全链路与 Auto Mode](architecture/11-%E6%9D%83%E9%99%90%E7%B3%BB%E7%BB%9F%E5%85%A8%E9%93%BE%E8%B7%AF%E4%B8%8EAuto%20Mode.md)
- [ClaudeAPI 与流式工具执行](architecture/12-ClaudeAPI%E4%B8%8E%E6%B5%81%E5%BC%8F%E5%B7%A5%E5%85%B7%E6%89%A7%E8%A1%8C.md)
- [StructuredIO 与 RemoteIO 控制平面](architecture/13-StructuredIO%E4%B8%8ERemoteIO%E6%8E%A7%E5%88%B6%E5%B9%B3%E9%9D%A2.md)
- [Bridge 与宿主适配器分层](architecture/14-Bridge%E4%B8%8E%E5%AE%BF%E4%B8%BB%E9%80%82%E9%85%8D%E5%99%A8%E5%88%86%E5%B1%82.md)
- [宿主路径时序与竞速](architecture/15-%E5%AE%BF%E4%B8%BB%E8%B7%AF%E5%BE%84%E6%97%B6%E5%BA%8F%E4%B8%8E%E7%AB%9E%E9%80%9F.md)
- [远程恢复与重连状态机](architecture/16-%E8%BF%9C%E7%A8%8B%E6%81%A2%E5%A4%8D%E4%B8%8E%E9%87%8D%E8%BF%9E%E7%8A%B6%E6%80%81%E6%9C%BA.md)
- [宿主控制平面优于聊天外壳](philosophy/09-%E5%AE%BF%E4%B8%BB%E6%8E%A7%E5%88%B6%E5%B9%B3%E9%9D%A2%E4%BC%98%E4%BA%8E%E8%81%8A%E5%A4%A9%E5%A4%96%E5%A3%B3.md)
- [协议全集不等于适配器子集](philosophy/10-%E5%8D%8F%E8%AE%AE%E5%85%A8%E9%9B%86%E4%B8%8D%E7%AD%89%E4%BA%8E%E9%80%82%E9%85%8D%E5%99%A8%E5%AD%90%E9%9B%86.md)
- [显式失败优于假成功](philosophy/11-%E6%98%BE%E5%BC%8F%E5%A4%B1%E8%B4%A5%E4%BC%98%E4%BA%8E%E5%81%87%E6%88%90%E5%8A%9F.md)
- [闭环状态机优于单向请求](philosophy/12-%E9%97%AD%E7%8E%AF%E7%8A%B6%E6%80%81%E6%9C%BA%E4%BC%98%E4%BA%8E%E5%8D%95%E5%90%91%E8%AF%B7%E6%B1%82.md)
