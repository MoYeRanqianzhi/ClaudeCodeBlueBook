# REPL 与 Ink 交互架构

## 1. 先说结论

Claude Code 的 REPL 不是一个薄 UI 壳，而是本地交互 runtime 的 orchestration layer。  
它一头连着 React/Ink 终端组件，一头连着：

- tool pool
- command pool
- MCP 连接
- plugin 管理
- task / background session
- transcript / compact / rewind
- permission mode 与 prompt input

关键证据：

- `claude-code-source-code/src/screens/REPL.tsx:572-599`
- `claude-code-source-code/src/screens/REPL.tsx:618-640`

## 2. REPL 的角色不是“渲染消息”，而是“装配交互现场”

`REPL(...)` 入口参数已经说明它要接收的不是简单文本，而是一整套运行时部件：

- 初始命令
- 初始工具
- 初始消息
- 初始文件历史与内容替换
- 初始 MCP clients / dynamic MCP config
- main thread agent definition
- remote/direct-connect/ssh session 配置
- thinking config

证据：

- `claude-code-source-code/src/screens/REPL.tsx:572-598`

这意味着 REPL 的本质不是聊天组件，而是 session 容器。

## 3. 它如何把本地状态装成“可执行工作面”

REPL 挂载后会同时读取大量 app state 切片：

- `toolPermissionContext`
- `mcp`
- `plugins`
- `agentDefinitions`
- `fileHistory`
- `tasks`
- `elicitation`
- `queuedCommands`

证据：

- `claude-code-source-code/src/screens/REPL.tsx:618-639`

同时它会在前台持续做几件事：

- 监听技能变更并重载命令
- 监听 proactive 状态影响工具集
- 管理 plugin startup checks
- 同步 IDE / MCP / Chrome / LSP / rate limit 等提示

证据：

- `claude-code-source-code/src/screens/REPL.tsx:680-699`
- `claude-code-source-code/src/screens/REPL.tsx:783-800`
- `claude-code-source-code/src/screens/REPL.tsx:744-768`

这说明 REPL 是“本地交互控制台”，而不是单纯的 message view。

## 4. 工具池和命令池如何在 REPL 里组装

### 4.1 工具池

REPL 先得到 `localTools`，再和初始工具、MCP 工具继续合并：

- `localTools = getTools(toolPermissionContext)`
- `combinedInitialTools = [...localTools, ...initialTools]`
- `mergedTools = useMergedTools(combinedInitialTools, mcp.tools, toolPermissionContext)`

证据：

- `claude-code-source-code/src/screens/REPL.tsx:696`
- `claude-code-source-code/src/screens/REPL.tsx:778-781`
- `claude-code-source-code/src/screens/REPL.tsx:811-829`

`useMergedTools()` 本身明确写着，REPL 和 `runAgent` 共享 `assembleToolPool()` 这条纯函数装配路径。

证据：

- `claude-code-source-code/src/hooks/useMergedTools.ts:8-13`
- `claude-code-source-code/src/hooks/useMergedTools.ts:20-44`

这很关键：前台 REPL 和后台/子 agent 不是两套工具系统。

### 4.2 命令池

命令合并同样分层：

- `localCommands`
- plugin commands
- MCP commands

最后再根据 `disableSlashCommands` 决定是否清空。

证据：

- `claude-code-source-code/src/screens/REPL.tsx:680-685`
- `claude-code-source-code/src/screens/REPL.tsx:831-835`

所以 REPL 看到的命令表是动态装配结果，而不是固定列表。

## 5. `getToolUseContext()` 是 REPL 最关键的桥

这段代码非常重要，因为它把 React/Ink 会话状态桥接成 query/runtime 能直接消费的 `ToolUseContext`。

它会做几件关键事：

1. 从 store 重新计算工具池，避免闭包里拿到过期工具。
2. 把 fresh MCP clients / resources 放入 options。
3. 暴露 `refreshTools()`，支持 mid-query 动态更新。
4. 把 UI 能力、notification、message selector、compact progress、resume、content replacement 等全塞进 context。

证据：

- `claude-code-source-code/src/screens/REPL.tsx:2392-2410`
- `claude-code-source-code/src/screens/REPL.tsx:2411-2523`

这说明 `ToolUseContext` 在 REPL 场景下几乎就是“前台 runtime 句柄”。

## 6. REPL 如何处理后台化和会话升级

`handleBackgroundQuery()` 显示，前台会话不是终点。REPL 可以把当前会话转成后台 session：

- 先 abort 前台 query
- 清理 task notifications
- 重新生成 toolUseContext / system prompt / user/system context
- 调 `startBackgroundSession(...)`

证据：

- `claude-code-source-code/src/screens/REPL.tsx:2525-2574`

这体现的不是 UI 技巧，而是 Claude Code 的核心哲学：  
前台只是协调层，执行可以迁移到后台。

## 7. 初始消息与权限模式是原子切换的

REPL 在处理某些初始消息时，会原子地：

- 清空旧会话
- 设置 permission mode
- 写入 allowed prompt 规则
- 在 auto 模式下立即 strip dangerous permissions
- 存储 pending plan verification

证据：

- `claude-code-source-code/src/screens/REPL.tsx:3064-3089`

这进一步说明 REPL 持有真正的运行时控制权，而不是只把事件往下转发。

## 8. PromptInput 只是入口，但它被接到整个 runtime 上

底部渲染中，`PromptInput` 接收的不是几个简单 prop，而是一整套 session 能力：

- `getToolUseContext`
- `toolPermissionContext`
- `commands`
- `agents`
- `messages`
- `mcpClients`
- `onSubmit`
- `onAgentSubmit`

证据：

- `claude-code-source-code/src/screens/REPL.tsx:4903-4906`

所以输入框不是表层组件，而是整个 runtime 的控制终端。

## 9. 它为什么用 Ink，而不是简单 readline

从 REPL 文件规模和依赖看，Ink 在这里不是为了“炫 UI”，而是因为 Claude Code 需要一个能承载这些交互对象的终端应用框架：

- 消息列表
- 异步工具进度
- 权限弹窗
- transcript 模式
- message actions
- survey / notifications
- background hint
- MCP elicitation dialog

换句话说，Claude Code 的 REPL 已经不是 line editor，而是终端工作台。

## 10. 一句话总结

REPL 在 Claude Code 里不是“聊天界面”，而是把 React/Ink、工具池、命令池、权限系统、后台任务、MCP、会话恢复焊接在一起的前台 orchestration layer。
