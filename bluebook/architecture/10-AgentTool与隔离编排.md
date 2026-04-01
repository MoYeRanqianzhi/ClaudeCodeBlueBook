# AgentTool 与隔离编排

这一章回答五个问题：

1. Claude Code 的多 Agent 到底是不是“多开几个子任务”。
2. AgentTool 如何在 teammate、fork、background、worktree、remote 之间路由。
3. 子代理的上下文、权限、MCP、transcript、worktree 如何被隔离。
4. 为什么 sidechain transcript 与 worktree cleanup 是编排架构的一部分。
5. 为什么 Claude Code 真正押注的是隔离优先，而不是并发优先。

## 1. 先说结论

Claude Code 的 AgentTool 不是一个“帮模型再叫一个模型”的薄封装。

它实际上同时承担了六层职责：

1. 选择编排路径：普通 subagent、team teammate、fork worker、remote agent。
2. 选择执行形态：同步、异步、后台、远程。
3. 选择隔离等级：上下文隔离、权限隔离、文件系统隔离、远程隔离。
4. 组装 worker runtime：system prompt、tool pool、MCP、hooks、skills、thinking config。
5. 持久化 sidechain 状态：subagent transcript、metadata、output file、task registry。
6. 负责退出清理：MCP cleanup、hook cleanup、read cache cleanup、worktree cleanup、shell task cleanup。

关键证据：

- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx:81-155`
- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx:217-220`
- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx:261-336`
- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx:430-685`
- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx:686-764`
- `claude-code-source-code/src/tools/AgentTool/runAgent.ts:95-217`
- `claude-code-source-code/src/tools/AgentTool/runAgent.ts:248-329`
- `claude-code-source-code/src/tools/AgentTool/runAgent.ts:347-479`
- `claude-code-source-code/src/tools/AgentTool/runAgent.ts:500-859`
- `claude-code-source-code/src/utils/forkedAgent.ts:47-68`
- `claude-code-source-code/src/utils/forkedAgent.ts:253-304`
- `claude-code-source-code/src/utils/forkedAgent.ts:345-462`
- `claude-code-source-code/src/utils/forkedAgent.ts:489-625`
- `claude-code-source-code/src/tools/EnterWorktreeTool/EnterWorktreeTool.ts:52-127`
- `claude-code-source-code/src/tools/ExitWorktreeTool/ExitWorktreeTool.ts:67-224`

## 2. AgentTool 的输入面已经暴露出“编排器”本质

`AgentTool` 输入面里最关键的字段不是 `prompt`，而是这些控制字段：

- `subagent_type`
- `model`
- `run_in_background`
- `name`
- `team_name`
- `mode`
- `isolation`
- `cwd`

这意味着它从 schema 层就不只是“执行任务”，而是在描述：

- 用谁执行
- 在哪执行
- 是否后台执行
- 是否进入团队/命名路由
- 是否隔离文件系统或切换 cwd

证据：

- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx:81-125`

## 3. 编排路由：同一个入口，至少四条路径

### 3.1 teammate 路径

当 `team_name` 与 `name` 同时存在时，AgentTool 进入 teammate spawn 路径：

- 会走 `spawnTeammate(...)`
- 绑定 name 到 agentId，供 `SendMessage` 路由
- 对 in-process teammate 与 tmux teammate 的生命周期做不同限制

证据：

- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx:261-316`
- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx:700-712`

### 3.2 fork 路径

当 `subagent_type` 省略且 fork gate 开启时，会走 fork worker 路径：

- 继承父 system prompt，而不是用独立 agent prompt。
- 继承父工具定义前缀，以争取 prompt cache 命中。
- 用 `buildForkedMessages(...)` 复制父消息上下文。
- 有递归 fork guard，防止 fork child 再次 fork。

证据：

- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx:318-336`
- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx:483-541`
- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx:603-633`

### 3.3 remote 路径

当 `effectiveIsolation === 'remote'` 时：

- 会先检查 remote eligibility。
- 再通过 CCR / teleport 路径创建远程 session。
- 本地只持久化 remote task identity 与 output file。

这说明 remote 不是 transport 细节，而是编排层显式选择的隔离级别。

证据：

- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx:430-482`

### 3.4 background 路径

是否异步运行，不只取决于 `run_in_background`：

- agent definition 可强制 background。
- coordinator / fork / kairos / proactive 等运行态也可强制 async。
- async agent 会注册 task、output file、abort controller，并以 detached lifecycle 运行。

证据：

- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx:555-568`
- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx:686-764`

## 4. 隔离不是一个开关，而是四层叠加

### 4.1 上下文隔离：`createSubagentContext(...)`

Claude Code 默认把子代理当成隔离上下文，而不是共享上下文。

默认行为包括：

- `readFileState` 克隆
- `abortController` 创建 child controller
- `getAppState` 包装成避免 permission prompt 的版本
- 大多数 mutation callback 变成 no-op
- `contentReplacementState` 默认克隆，保证 prompt cache 稳定
- `queryTracking.depth` 递增

证据：

- `claude-code-source-code/src/utils/forkedAgent.ts:253-304`
- `claude-code-source-code/src/utils/forkedAgent.ts:345-462`

这一步非常关键，因为它说明“子代理”在默认语义上并不是主线程的共享线程，而是受控分支。

### 4.2 文件系统隔离：worktree

当选择 `isolation: "worktree"` 时：

- AgentTool 会先为 agent 创建独立 worktree。
- fork + worktree 还会额外注入 path translation notice。
- 执行结束后只在确认无变更时删除 worktree；有变更则保留。

证据：

- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx:579-603`
- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx:643-685`

这不是“临时目录”语义，而是“隔离代码现场，同时保留成果”的语义。

### 4.3 执行隔离：后台任务与未链接 abort controller

在 `runAgent(...)` 里：

- async agent 默认拿新的 abort controller，而不是共享父 controller。
- permissions 也会根据 async / bubble mode 做不同 shaping。
- tool allow rules 可单独收口到 agent 级。

证据：

- `claude-code-source-code/src/tools/AgentTool/runAgent.ts:412-479`
- `claude-code-source-code/src/tools/AgentTool/runAgent.ts:520-529`

### 4.4 环境隔离：remote

remote isolation 解决的是“同一台机器内隔离还不够”的场景。

它把：

- 执行环境
- session 身份
- 任务生命周期

整体委托给远端 CCR 环境，只把本地状态压缩成 task metadata。

证据：

- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx:430-482`
- `claude-code-source-code/src/utils/sessionStorage.ts:305-340`

## 5. worker runtime 是重新装配的，不是继承父线程对象

### 5.1 工具池独立装配

AgentTool 在进入 `runAgent(...)` 前，会按 worker 自己的 permission mode 重新 assemble tool pool。

这意味着：

- worker 不直接继承父线程被裁剪后的工具视图。
- worker 的 tool surface 可以根据 agent 定义重新收口。
- fork path 才是例外，它会走 `useExactTools` 以换 prompt cache 命中。

证据：

- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx:568-577`
- `claude-code-source-code/src/tools/AgentTool/runAgent.ts:500-518`

### 5.2 agent-specific MCP 是加法，不是全局共享表

`runAgent(...)` 会：

- 读取 agent frontmatter 里的 MCP servers。
- 与父 MCP clients 合并。
- 只清理 agent 自己新增的 inline MCP client。

这表明 agent 拥有自己的扩展环境，而不是只能吃父线程现成配置。

证据：

- `claude-code-source-code/src/tools/AgentTool/runAgent.ts:95-217`
- `claude-code-source-code/src/tools/AgentTool/runAgent.ts:648-665`

### 5.3 为了成本与安全，某些上下文会被主动省略

`runAgent(...)` 对 Explore / Plan 一类只读 agent 会主动省掉：

- `claudeMd`
- `gitStatus`

理由不是功能缺失，而是：

- 这些 agent 不该继承昂贵且可能陈旧的上下文。
- 真要需要，它们应自己读取 fresh state。

证据：

- `claude-code-source-code/src/tools/AgentTool/runAgent.ts:385-410`

## 6. transcript、metadata、resume：多 Agent 也是正式状态面

### 6.1 sidechain transcript 是正式持久化对象

`runAgent(...)` 在 query loop 前后会：

- 先写 `initialMessages`
- 再逐条写 recordable message
- 用 `lastRecordedUuid` 维持 parent chain

证据：

- `claude-code-source-code/src/tools/AgentTool/runAgent.ts:732-805`

这说明 subagent 不是黑盒子；它也有自己的可恢复状态链。

### 6.2 agent metadata 负责恢复正确执行环境

每个 agent 至少会持久化：

- `agentType`
- `worktreePath`
- `description`

这让 resume 时可以恢复：

- 正确 agent 路由
- 正确 cwd / worktree
- 正确任务描述

证据：

- `claude-code-source-code/src/utils/sessionStorage.ts:264-303`
- `claude-code-source-code/src/tools/AgentTool/runAgent.ts:738-742`

## 7. cleanup 不是附属代码，而是编排语义的闭环

### 7.1 runAgent 的退出清理

退出时会做：

- agent MCP cleanup
- session hooks cleanup
- prompt cache tracking cleanup
- `readFileState` 清空
- transcript subdir mapping 清空
- todos entry 清理
- 背景 shell tasks 清理

证据：

- `claude-code-source-code/src/tools/AgentTool/runAgent.ts:816-859`

### 7.2 worktree 的用户级进入与退出是 fail-closed 的

`EnterWorktreeTool` 与 `ExitWorktreeTool` 说明 worktree 不是内部黑魔法，而是产品级隔离工具。

尤其 `ExitWorktreeTool` 的几个选择很关键：

- state 无法可靠判断时，默认拒绝 remove。
- 有未提交文件或新增 commit 时，默认拒绝 remove。
- `keep` 会恢复当前 session 到原目录，但保留 worktree 成果。

证据：

- `claude-code-source-code/src/tools/EnterWorktreeTool/EnterWorktreeTool.ts:77-119`
- `claude-code-source-code/src/tools/ExitWorktreeTool/ExitWorktreeTool.ts:67-224`
- `claude-code-source-code/src/tools/ExitWorktreeTool/ExitWorktreeTool.ts:250-320`

## 8. 从第一性原理看：为什么这是“隔离编排”而不是“并发编排”

如果只追求并发，最便宜的做法是：

1. 所有子任务共享上下文。
2. 所有子任务共享文件系统。
3. 所有结果写进同一条日志。
4. 所有权限决策沿用父线程。

Claude Code 没这么做，反而处处在加隔离层：

- 克隆 `readFileState`
- 克隆 `contentReplacementState`
- 创建 worktree
- 远程化 agent
- sidechain transcript
- agent-specific metadata
- fail-closed cleanup

这说明它真正优化的目标不是“把更多 agent 跑起来”，而是“把更多 agent 跑起来后，主状态仍然不坏”。

## 9. 相关章节

- 状态面：`09-会话存储记忆与回溯状态面.md`
- 会话与状态 API：`../api/09-会话与状态API手册.md`
- 设计哲学：`../philosophy/07-隔离优先于并发.md`
- 第一性原理主线：`../06-第一性原理与苏格拉底反思.md`
