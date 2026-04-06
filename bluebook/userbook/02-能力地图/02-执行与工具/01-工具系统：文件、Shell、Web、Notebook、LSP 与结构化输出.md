# 工具系统：文件、Shell、Web、Notebook、LSP 与结构化输出

## 工具池是 Claude Code 的真实行动面

`src/tools.ts` 是工具世界的总注册点。它明确说明：

- 先确定基础工具集。
- 再按 feature gate、平台、权限模式、deny 规则过滤。
- 再与 MCP 工具池合并。

也就是说，用户真正给模型的是“被过滤后的工具池”，不是抽象能力。

## 稳定核心工具

这批工具构成发布构建里最常见的行动面：

- `Read`：读文件、图片、PDF、notebook。
- `Edit`：原地改文件。
- `Write`：创建或覆盖文件。
- `Bash`：执行 shell 命令。
- `Glob`：按模式找文件。
- `Grep`：按内容搜文件。
- `WebFetch`：抓 URL 内容。
- `WebSearch`：联网搜索。
- `NotebookEdit`：编辑 `.ipynb`。
- `TodoWrite`：维护会话级任务清单。
- `TaskStop` / `TaskOutput`：处理后台任务。
- `Skill`：调用斜杠技能。
- `StructuredOutput`：把最终输出收成结构化 JSON。

从设计上看，这些工具的分工很明确：

- 文件世界靠 `Read`、`Edit`、`Write`。
- 外部命令世界靠 `Bash`。
- 网络世界靠 `WebFetch`、`WebSearch`。
- 长任务治理靠 `TodoWrite`、`Task*`。

## 为什么同时保留 `Read`/`Edit`/`Write` 和 `Bash`

因为它们不是替代关系，而是不同成本模型：

- 用 `Read`/`Edit`/`Write`，系统能更强地约束意图和权限。
- 用 `Bash`，系统获得通用性，但要承担更重的命令安全与审批负担。

所以高质量使用方式不是“默认全用 shell”，而是：

- 精确文件操作优先用文件工具。
- 真正需要命令生态或复合脚本时再用 shell。

## 高价值但并非总是可见的工具

源码里还有很多条件性工具：

- `LSP`：定义、引用、hover、symbols。
- `EnterPlanMode` / `ExitPlanMode`。
- `EnterWorktree` / `ExitWorktree`。
- `TaskCreate` / `TaskGet` / `TaskUpdate` / `TaskList`。
- `SendMessage`、`TeamCreate`、`TeamDelete`。
- `CronCreate` / `CronDelete` / `CronList`。
- `RemoteTrigger`。
- `ListMcpResourcesTool` / `ReadMcpResourceTool`。
- `ToolSearch`。

这说明 Claude Code 的行动面远不止“读写代码”，还包含：

- 任务治理。
- 代理通信。
- 定时调度。
- worktree 隔离。
- 外部资源索引。

## MCP 工具为什么是特殊类

`assembleToolPool()` 会把内置工具和 MCP 工具合并，但仍保留两者的分层。

这带来两个关键效果：

1. 内置工具稳定，适合作为系统提示词缓存前缀的一部分。
2. MCP 工具可动态变化，不应把缓存稳定性建立在它们身上。

用户含义很简单：MCP 很强，但它是“外挂执行面”，不是 Claude Code 内核本身。

## 对用户的实践建议

### 改代码优先级

优先尝试 `Read`、`Edit`、`Write` 驱动的工作流，只在确实需要 shell 生态时再退到 `Bash`。

### 网络能力优先级

抓固定页面优先 `WebFetch`，需要当前信息优先 `WebSearch`。

### 复杂仓库优先级

有 LSP 就用 LSP；没有时退回 `Grep`、`Glob`、`Read`。

### 长任务优先级

当任务拆分、后台运行、任务面板能明显降低协调成本时，不要只靠自然语言维护待办。

## 源码锚点

- `src/tools.ts`
- `src/Tool.ts`
- `src/tools/FileReadTool/FileReadTool.ts`
- `src/tools/FileEditTool/FileEditTool.ts`
- `src/tools/FileWriteTool/FileWriteTool.ts`
- `src/tools/BashTool/BashTool.tsx`
- `src/tools/WebFetchTool/WebFetchTool.ts`
- `src/tools/WebSearchTool/WebSearchTool.ts`
- `src/tools/NotebookEditTool/NotebookEditTool.ts`
- `src/tools/LSPTool/LSPTool.ts`
- `src/tools/MCPTool/MCPTool.ts`
