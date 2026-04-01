# 研究日志

## 当前基线

- 日期: `2026-04-01`
- 工作目录: `/home/mo/m/projects/cc/analysis`
- 研究源码: `claude-code-source-code/`
- 目标版本: `v2.1.88`

## 已确认结论

### A. 启动与入口

- CLI 先走 fast path，再决定是否 import `main.js`。
- `main.tsx` 是总控层，不只是 TUI 入口。
- init 显式区分 trust 前后的行为边界。

证据:

- `claude-code-source-code/src/entrypoints/cli.tsx:28-33`
- `claude-code-source-code/src/entrypoints/cli.tsx:95-185`
- `claude-code-source-code/src/main.tsx:585-855`
- `claude-code-source-code/src/entrypoints/init.ts:62-88`

### B. 核心 agent loop

- `QueryEngine` 管会话生命周期。
- `query.ts` 负责 streaming、tool use、fallback、compaction、recovery。
- transcript 在 query 前就会先落盘。

证据:

- `claude-code-source-code/src/QueryEngine.ts:209-333`
- `claude-code-source-code/src/QueryEngine.ts:430-463`
- `claude-code-source-code/src/query.ts:659-865`

### C. 能力系统

- tool 是统一执行原语。
- commands 与 skills 都被收敛进统一命令装配过程。
- skills 支持 frontmatter 声明权限、hooks、model、paths、agent。

证据:

- `claude-code-source-code/src/Tool.ts:362-792`
- `claude-code-source-code/src/commands.ts:445-517`
- `claude-code-source-code/src/skills/loadSkillsDir.ts:185-261`

### D. 扩展与边界

- MCP 是正式扩展总线，支持多 transport、多 config scope、policy/dedup。
- Remote session 与 Remote Control bridge 是两条不同远程路径。
- 多 Agent 建立在 task runtime 上，而不是 prompt hack。

证据:

- `claude-code-source-code/src/services/mcp/types.ts:9-27`
- `claude-code-source-code/src/services/mcp/config.ts:1258-1290`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts:87-141`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts:57-87`
- `claude-code-source-code/src/Task.ts:6-29`

### E. Session / state surface

- SDK 入口已经声明 `getSessionMessages`、`listSessions`、`getSessionInfo`、`renameSession`、`tagSession`、`forkSession` 等 session API，但在当前提取树里这些函数体仍是 stub，必须区分“文档化意图”和“当前可见实现”。
- control protocol 已经形成更完整的 runtime state surface，包括 `get_context_usage`、`rewind_files`、`seed_read_state`、`get_settings`。
- session/state 的后端不是单一 transcript，而是 transcript、metadata、layered memory、session memory、file history / rewind 的组合状态面。

证据:

- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts:167-272`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:175-519`
- `claude-code-source-code/src/utils/sessionStorage.ts:198-258`
- `claude-code-source-code/src/utils/sessionStorage.ts:4739-5105`
- `claude-code-source-code/src/utils/fileHistory.ts:45-320`

### F. Agent orchestration 与 isolation

- AgentTool 真正提供的是编排器，而不是薄的“再起一个模型调用”。
- 多 Agent 的核心不只是并发，而是上下文、权限、文件系统、历史链与环境的分层隔离。
- `createSubagentContext(...)`、worktree、remote isolation、sidechain transcript 与 cleanup 共同构成“隔离优先于并发”的实现基础。

证据:

- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx:318-764`
- `claude-code-source-code/src/tools/AgentTool/runAgent.ts:95-859`
- `claude-code-source-code/src/utils/forkedAgent.ts:253-625`
- `claude-code-source-code/src/tools/EnterWorktreeTool/EnterWorktreeTool.ts:52-127`
- `claude-code-source-code/src/tools/ExitWorktreeTool/ExitWorktreeTool.ts:67-320`

## 本轮输出

- 已建立蓝皮书主索引
- 已写四个核心章节初稿
- 已把“公开能力 vs gated/incomplete 能力”单独拆章，避免误导
- 已补“功能全景与 API 支持”主线章节
- 已补命令矩阵、SDK 控制协议、MCP/远程传输三篇接口文档
- 已补第一性原理与苏格拉底反思章节，以及内部迭代准则
- 已补 REPL、权限状态机、上下文压缩恢复链三篇架构深挖
- 已补 SDK 消息字典、控制请求矩阵、上下文经济学、安全观四篇专题文档
- 已补 PromptInput/消息渲染链、内置命令域索引、产品实验与演化方法
- 已补 `services/compact/*` 细拆、命令字段与可用性索引、构建期开关/运行期开关/兼容层专题
- 已补工具协议与 `ToolUseContext`、会话存储/记忆/回溯状态面、状态优先于对话三篇专题
- 已补会话与状态 API 手册，明确区分 SDK 文档化接口与当前提取实现边界
- 已补 AgentTool 与隔离编排专题，把 fork/background/worktree/remote 收拢成统一编排面
- 已补“隔离优先于并发”专题，并把第一性原理阅读路径显式映射到目录

## 下一步待办

- 补一章“权限系统全链路”深挖 `permissionSetup.ts` / `permissions.ts`
- 补一章“Skills / frontmatter / plugin agent”统一扩展范式
- 补一章“MCP 实战配置与集成范式”
- 补一章“多 Agent 协作模式与 prompt 模板”
- 补源码目录级索引表，把 `services/`、`tools/`、`commands/` 细分到二级目录
- 给 `SDKMessageSchema` 与 control subtype 做完整对照表
- 补 `REPL.tsx` / Ink 更细的 transcript mode、message actions、PromptInput 交互链
- 补命令索引的更细表格化版本与 workflow/dynamic skills 交叉核对
- 补 feature gate / runtime gate / compat shim 的统一时序与迁移图
- 继续把 session/state API 与子代理状态回收做成字段级索引与时序图

## 当前风险

- 这份源码不是完整内部 monorepo，不能把 gated/internal 痕迹直接当成公开事实。
- `query.ts` 仍有大量细节未拆完，尤其是 compact / reactive compact / media recovery 分支。
- plugin 市场能力的基础设施很完整，但现阶段不能夸大其生态成熟度。
- SDK 入口可见，但部分 `runtimeTypes` / `toolTypes` / `controlTypes` 源文件未在当前提取树中展开，接口分析需持续标注这层边界。
- `services/compact/*` 已明显显示多条 gated/ant-only 路径，不能把 cached microcompact、API-native clear edits 等直接当作所有 build 的公开能力。
- `commands/` 目录很多模块名与最终 slash name 可能不完全同名，虽然字段级索引已补，但 workflow/dynamic skills 仍需继续核实。
- session/state 面横跨 `sessionStorage.ts`、`fileHistory.ts`、SessionMemory、SDK control schema，后续必须继续防止“API、机制、产品行为”三层混写。
- session API 在 `agentSdkTypes.ts` 中的实现可见度仍不完整，后续写作必须继续强调“入口已声明”不等于“当前提取树里已有完整实现”。
- 多 Agent 隔离逻辑横跨 `AgentTool.tsx`、`runAgent.ts`、`forkedAgent.ts`、worktree tools，后续若继续细拆时应防止把“并发能力”和“隔离约束”混成一个概念。
