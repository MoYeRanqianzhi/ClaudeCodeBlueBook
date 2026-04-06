# 源码目录级能力地图：commands、tools、services、状态与宿主平面

这页不该被读成“目录级能力大全”。

更稳的读法是：

1. 先看哪一层在宣布真相
2. 再看哪一层只是 consumer subset 或 transport shell
3. 再看哪一层最容易成为危险改动面
4. 最后才看目录数量、入口数量与文件体量

这一章不继续拆字段，而是回答四个问题：

1. Claude Code 的源码顶层到底分成了哪些能力平面。
2. `commands/`、`tools/`、`services/` 分别承担什么职责。
3. 为什么 `utils/` 与 `components/` 的体量本身就是架构信号。
4. 目录级地图怎样帮助我们补足“全部功能与 API 支持”的覆盖面。

## 0. 代表性源码锚点与本地扫描

源码锚点：

- `claude-code-source-code/src/commands.ts:224-320`
- `claude-code-source-code/src/tools.ts:193-367`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-220`
- `claude-code-source-code/src/cli/structuredIO.ts:135-162`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/Task.ts:6-124`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`

本地扫描（`2026-04-02`，工作区源码镜像）：

- `src/` 顶层可见 `53` 个一级入口
- `src/commands/` 可见 `86` 个目录 + `15` 个根命令文件，共 `101` 个顶层命令入口，文件总数约 `207`
- `src/tools/` 可见 `42` 个目录 + `1` 个根文件，共 `43` 个顶层工具入口，文件总数约 `184`
- `src/services/` 可见 `20` 个目录 + `16` 个根文件，共 `36` 个顶层服务入口，文件总数约 `130`
- `src/utils/` 文件总数约 `564`
- `src/components/` 文件总数约 `389`

这些数字本身不等于“产品承诺”，也不等于“源码质量更高”，但足以说明：

- Claude Code 的能力面远不是“几个命令 + 几个工具”
- 因此这页只拿它们定位平面与危险改动面，不拿它们直接宣布公开承诺

## 1. 先说结论

目录级看，Claude Code 至少由六个平面构成：

1. `commands/`：用户与宿主的显式控制平面
2. `tools/`：模型可调用的执行原语平面
3. `services/`：长生命周期子系统平面
4. `state/`、`Task.ts`、`query.ts`：运行时真相平面
5. `entrypoints/`、`cli/`、`remote/`、`server/`：宿主与 transport 平面
6. `utils/`、`components/`、`screens/`：不变量内核与前台控制面

这张图最重要的意义不是“目录很多”，而是：

- Claude Code 把控制、执行、治理、恢复、前台、宿主适配拆成了不同演化速度的平面
- 这页真正想回答的也不是“有哪些目录”，而是“哪一层在宣布真相、哪一层只是子集或投影、哪一层一改最危险”

## 2. `commands/` 是控制平面，不是 slash 外壳

`commands.ts` 已经说明两件事：

1. `INTERNAL_ONLY_COMMANDS` 与 `COMMANDS()` 共同定义了“源码存在面”。
2. 真正运行时命令面还会叠加 skills、plugins、workflow、dynamic skills。

因此 `commands/` 的 `101` 个顶层入口，不能只当成“一堆 slash 命令”。

更稳的读法不是继续把目录分成六类，而是先把命令面压成四个协议对象：

1. authority object
   - `COMMANDS()` 与 `getCommands()` 共同决定当前显式控制面
2. consumer subset
   - builtin、skills、plugins、workflows、dynamic skills 只会在特定运行时组合下进入当前可见子集
3. danger surface
   - 任何会改写命令装配、命令可见性、命令来源优先级的变更，都会直接改写显式控制面
4. reject path
   - 一旦命令行为开始可疑，第一条 reject path 不该回到某个子命令目录，而应先回 `COMMANDS()`、`getCommands()` 与来源拼装顺序

代表性表面只需要记住：

- 会话与状态：`clear / compact / resume / rewind / session`
- 配置与模式：`config / permissions / plan / model`
- 扩展与连接：`mcp / skills / plugin / bridge / ide`
- 协作与实验：`agents / tasks / voice`

如果要继续把 `commands/` 读成判断协议，至少要再问五件事：

1. authority object 是 `COMMANDS()` 还是 runtime assembly
2. 哪些命令只是 dynamic subset
3. 哪些 surface 明显受 gate / policy / consumer subset 影响
4. 哪个改动面最容易把显式控制面写坏
5. 如果命令行为不可信，第一条 reject path 应回到哪里

## 3. `tools/` 是动作原语平面，不是零散函数集合

`tools.ts` 把 `getAllBaseTools()`、`getTools()`、`assembleToolPool()` 写成统一真相，说明工具面不是插件式拼盘，而是正式 ABI。

这里最关键的不是枚举，而是 `tools.ts` 还进一步显式处理了：

- simple mode 裁剪
- REPL mode 原语隐藏
- deny rules 预过滤
- MCP 工具去重与 cache-stable 排序

也就是说：

- 工具面本身就已经带治理、可见性和 token/caching 约束
- 地图上真正值钱的不是记住多少工具，而是分清谁在定义动作 ABI，谁在裁切当前可见集，谁在给扩张继续收费

更稳的读法应先固定四个协议对象：

1. authority object
   - `Tool.ts` 宣布动作 ABI，`tools.ts` 宣布当前工具池真相
2. consumer subset
   - builtin、MCP、internal、mode-specific tools 都只是不同可见子集
3. danger surface
   - visible-set 裁切、deny rule、MCP 去重、cache-stable 排序一旦失真，就会直接破坏动作边界
4. reject path
   - 一旦工具语义开始漂移，第一条 reject path 应先回 `Tool.ts`、`getAllBaseTools()`、`getTools()` 与 `assembleToolPool()`

代表性动作面只需要记住：

- 工作区与执行原语：`BashTool / FileReadTool / FileEditTool / FileWriteTool`
- 搜索与外部信息：`GlobTool / GrepTool / WebFetchTool / WebSearchTool`
- 协作与任务编排：`AgentTool / Task* / Team*`
- 扩展与执行环境：`MCPTool / SkillTool / LSPTool / EnterWorktreeTool / RemoteTriggerTool`

继续往下压，`tools/` 也应固定成五问：

1. authority object 是 `Tool.ts` 还是 `tools.ts`
2. 哪些工具只是 visible subset，不是全部存在面
3. 哪些 internal / gated / MCP surface 不能直接写成主路径承诺
4. 哪类变更最容易破坏 fail-closed 与 visible-set discipline
5. 如果动作语义可疑，第一条 reject path 应回到哪个 ABI 入口

## 4. `services/` 是长生命周期子系统平面

如果 `commands/` 是显式控制面，`tools/` 是执行面，那么 `services/` 更像后台长期子系统。

这说明 Claude Code 的真正后台不是“模型调用器”，而是一组持续运行的长期子系统。

因此 `services/` 在地图上更接近长期定价、治理、记忆与同步子系统，而不是后台杂项目录。

更稳的读法应先固定四个协议对象：

1. authority object
   - 哪个文件在宣布子系统真相，例如 `api/sessionIngress`、`compact/compact.ts`、`SessionMemory/sessionMemory.ts`、`mcp/config.ts`
2. consumer subset
   - 哪些路径只拿到 continuation 投影、host 投影、UI 投影或观察投影
3. danger surface
   - 哪个 stale write / recovery object / config merge 最容易从这里潜入
4. reject path
   - 一旦子系统开始同时破坏安全、成本与继续资格，应先回 authority file，而不是先在 consumer 壳层打补丁

代表性子系统只需要记住：

- `api / compact / policyLimits`：请求真相、上下文与时间边界
- `SessionMemory / PromptSuggestion / AgentSummary`：continuation 资产
- `mcp / plugins / remoteManagedSettings / oauth`：外部能力与组织边界
- `lsp / voice / MagicDocs`：能力接入桥
- `analytics / internalLogging / notifier`：观测与辅助投影

继续往下压，`services/` 也不该只按目录组读，而应再问：

1. 哪个文件在宣布子系统真相
2. 哪些 consumer 只拿到 continuation 投影或 host 投影
3. 哪个 stale write / recovery object 最容易从这里潜入
4. 哪个改动面会同时破坏安全、成本与继续资格
5. future maintainer 第一条 reject path 应先回到哪个 authority file

## 5. `state/`、`Task.ts`、`query.ts` 才是运行时真相面与危险改动面

目录级地图如果只写 `commands/`、`tools/`、`services/`，还是会低估 Claude Code。

因为真正把这些平面粘成 runtime 的，是另一组核心文件：

### 5.1 `Task.ts`

`TaskType` 直接暴露：

- `local_bash`
- `local_agent`
- `remote_agent`
- `in_process_teammate`
- `local_workflow`
- `monitor_mcp`
- `dream`

这说明任务系统已经把本地执行、远程协作、workflow 与监控对象化。

### 5.2 `onChangeAppState.ts`

这里不是普通 store 订阅器，而是：

- permission mode 外化
- session metadata 同步
- model / view / config 写回

的单点扼流口。

### 5.3 `query/tokenBudget.ts`

token 预算不是“附带算法”，而是 turn runtime 的 continuation 决策器。

### 5.4 `StructuredIO`

`pendingRequests`、`resolvedToolUseIds`、统一 outbound FIFO 说明宿主协议也是 runtime 主路径，而不是外围包装。

所以目录级看，Claude Code 的真相并不住在某个单独目录里，而是住在：

- task
- state
- query
- host control

四条骨架文件中。

也正因为如此，真正危险的不是“改到大目录”，而是：

- 在 `Task` 上改坏任务真相
- 在 `state` 上写出过期投影
- 在 `query` 上把 continuation pricing 改成假连续性
- 在 `StructuredIO` 上把 host authority stream 写成错序回放

## 6. 为什么 `utils/` 与 `components/` 的体量本身是 hotspot 协议信号

本地扫描里：

- `src/utils/` 约 `564` 个文件
- `src/components/` 约 `389` 个文件

这两个数字的价值不在“文件多”，而在它们分别暗示：

### 6.1 `utils/` 是不变量内核

这里吸收的是：

- cache 规则
- session storage
- permissions
- task framework
- worktree
- message shaping

也就是最容易被很多团队散落到业务层的 invariant kernels。

### 6.2 `components/` + `screens/` 是前台控制面

Claude Code 前台不是 terminal 皮肤，而是：

- transcript truth
- sticky prompt
- footer status
- message actions
- teammate routing

的组合控制面。

所以目录体量本身不是评分器，而是在提醒你两类 hotspot 审查协议：

- 这套系统既不是“后端工具壳”，也不是“前端聊天壳”，而是双重 runtime
- 一个负责不变量与时间诚实，一个负责用户当前可见真相

更稳的审查顺序应是：

1. 改 `utils/` 时先问：会不会破坏 invariant kernel、cache boundary、session truth 或权限合同
2. 改 `components / screens` 时先问：会不会把用户当前可见真相写成投影、延迟或假连续性
3. 只有这两问过关，体量信号才值得继续被解释

## 7. 这张图怎样帮助补足“全部功能与 API 支持”

如果没有目录级地图，后续章节容易掉进三个坑：

1. 只盯 `commands`，低估 `services`
2. 只盯 `tools`，低估 `state/query/Task`
3. 只盯 schema，低估 `components/screens` 对用户可见真相的塑形

更好的用法是：

1. 先用本章判断问题属于哪个平面。
2. 再去 `23-30` 的 API atlas 查字段、公开度和宿主支持面。
3. 最后去 `architecture/` 与 `philosophy/` 找运行时机制与设计解释。

不要反过来把目录数量、对象数量或文件体量当成产品承诺；这些数字只负责把你送到正确的 authority / subset / danger surface。

## 8. 这张图真正该怎样被拿来拒收错误读法

如果要把这张图当 atlas lint，而不是导览册，至少要先拒收四种错读：

1. 只看 `commands` 就以为已经看懂控制面
2. 只看 `tools` 就把能力发布协议误写成工具大全
3. 只看 schema 与 transport 就把 host / state / frontend truth 全部漏掉
4. 只看目录数量与文件体量，就把热点信号误写成成熟度证据

更稳的使用顺序是：

1. 先找 authority object
2. 再找 consumer subset / projection
3. 再找 danger surface 与 second-truth risk
4. 最后才决定第一条 reject path 应回到哪个入口文件

## 9. 一句话总结

Claude Code 的目录级地图真正该留下的，不是“六个平面很多”，而是：commands 宣布显式控制面，tools 定义动作 ABI 与可见子集，services 维持长期定价与同步，state/query/Task 保存运行时真相，host control 管理 authority stream，frontend truth 维护用户当前可见世界。
