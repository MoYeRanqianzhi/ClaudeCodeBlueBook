# Tools 二级目录 Atlas：执行原语、交互控制、任务编排、扩展桥接与延迟暴露边界

这一章回答五个问题：

1. `tools/` 往二级目录拆开后，到底分成了哪些工具族群。
2. 哪些工具是真正的执行原语，哪些是控制面工具，哪些是扩展桥接或内部工具。
3. 工具的可见性治理、延迟暴露、权限过滤与消费者子集是怎样收口的。
4. 哪些工具目录最容易被误读，从而把安全、token 或协作写坏。
5. 平台设计者该按什么顺序阅读 `tools/`。

## 0. 本地扫描与代表性锚点

本地扫描（`2026-04-02`，源码镜像）：

- `src/tools/` 可见 `42` 个一级子目录
- `src/tools/` 根目录可见 `1` 个根文件
- 文件数较高的目录包括：
  - `AgentTool`：约 `20` 个文件
  - `BashTool`：约 `18` 个文件
  - `PowerShellTool`：约 `14` 个文件
  - `plugin` 不在这里，说明插件生命周期与工具定义被刻意分开

代表性源码锚点：

- `claude-code-source-code/src/tools.ts:193-367`
- `claude-code-source-code/src/tools/ToolSearchTool/ToolSearchTool.ts:1-120`
- `claude-code-source-code/src/tools/BashTool/BashTool.tsx:1-120`
- `claude-code-source-code/src/tools/PowerShellTool/PowerShellTool.tsx:1-120`
- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx:1-120`
- `claude-code-source-code/src/tools/REPLTool/primitiveTools.ts:1-120`
- `claude-code-source-code/src/tools/MCPTool/MCPTool.ts:1-120`

## 1. 先说结论

`tools/` 不是“很多模型函数”目录。

更准确地说，它是 Claude Code 的动作原语平面，至少可以拆成六组：

1. 工作区与 shell 执行原语
2. 搜索、检索与外部信息原语
3. 认知控制与交互原语
4. 任务、团队与编排原语
5. 扩展、资源与桥接原语
6. 环境自动化与内部测试原语

这张 atlas 最关键的意义不是：

- 工具有多少

而是：

- 哪些工具能直接进入 prompt surface，哪些工具会被 mode / deny rule / REPL / ToolSearch 裁剪掉

## 2. 真正的权威入口不是工具目录，而是 `tools.ts`

阅读 `tools/` 最稳的入口不是随机打开某个工具目录，而是先看：

- `getAllBaseTools()`
- `getTools()`
- `assembleToolPool()`

因为这里统一处理了：

1. built-in tools 集合
2. simple mode / REPL mode 子集
3. blanket deny 预过滤
4. built-in 与 MCP dedupe
5. built-in prefix 与 MCP suffix 的 cache-stable 排序

这意味着：

- 工具目录只是定义层
- 真正的工具可见面，要到 `tools.ts` 才能看清

## 3. 工作区与 Shell 执行原语

核心目录：

- `BashTool/`
- `PowerShellTool/`
- `FileReadTool/`
- `FileEditTool/`
- `FileWriteTool/`
- `NotebookEditTool/`

主要职责：

1. 直接操作工作区
2. 提供 shell / file / notebook 原语
3. 在工具级实现 path validation、mode validation、sandbox 与 destructive warnings

主要消费者：

- 主线程 query
- REPL mode 内部 primitive VM

最容易误读的边界：

1. `BashTool` / `PowerShellTool` 不是同类小包装，而是各自带完整安全与模式语义。
2. `FileRead/Edit/Write` 不是简单 CRUD，它们是 permission-aware tool surface。
3. REPL mode 开启时，这些 primitive 可能被 `REPLTool` 隐藏成内部能力，而非对模型直接暴露。

## 4. 搜索、检索与外部信息原语

核心目录：

- `GlobTool/`
- `GrepTool/`
- `WebFetchTool/`
- `WebSearchTool/`
- `ToolSearchTool/`

主要职责：

1. 目录 / 文件 / 文本搜索
2. web 获取与 web 搜索
3. 对 deferred tools 做检索与显式选择

最关键的特殊工具：

- `ToolSearchTool`

因为它说明：

- Claude Code 并不要求模型一开始就看见所有工具

而是允许：

- 先通过 ToolSearch 找到 deferred tools，再决定暴露什么

最容易误读的边界：

1. `ToolSearchTool` 不是普通搜索工具，而是工具可见性控制面的组成部分。
2. `WebFetch` / `WebSearch` 也受模式、预算与 host 能力影响，不是永远等价公开能力。
3. embedded search tools 存在时，`Glob/Grep` 甚至可能从 built-in 列表中被裁掉。

## 5. 认知控制与交互原语

核心目录：

- `TodoWriteTool/`
- `AskUserQuestionTool/`
- `BriefTool/`
- `ConfigTool/`
- `EnterPlanModeTool/`
- `ExitPlanModeTool/`
- `EnterWorktreeTool/`
- `ExitWorktreeTool/`

主要职责：

1. 让模型显式请求用户输入或切换计划模式
2. 让模型进入新的对象边界，如 worktree / plan
3. 把原本容易写成 prompt 技巧的能力收口成正式工具

最容易误读的边界：

1. 这组工具不是“交互体验小功能”，而是对象升级与治理控制面。
2. `ConfigTool` 并不是总可见；它还受用户类型和 mode 影响。
3. `Enter/ExitPlanMode` 与 `Enter/ExitWorktree` 更接近对象升级原语，而不是 UI 快捷操作。

## 6. 任务、团队与编排原语

核心目录：

- `AgentTool/`
- `SendMessageTool/`
- `TaskCreate/Get/List/Update/Stop/OutputTool/`
- `TeamCreateTool/`
- `TeamDeleteTool/`

主要职责：

1. 生成 subagent / fork / resume 语义
2. 把 task 当成正式对象，而不是附属输出
3. 支持 team / swarm / multi-agent 协作

最容易误读的边界：

1. `AgentTool` 不是“多开几个线程”，而是完整的任务对象与恢复语义。
2. task 族工具只有在 feature / mode 打开时才出现，说明它们也是 consumer subset。
3. `SendMessageTool` 是任务间控制面，不是普通聊天能力。

## 7. 扩展、资源与桥接原语

核心目录：

- `MCPTool/`
- `ListMcpResourcesTool/`
- `ReadMcpResourceTool/`
- `McpAuthTool/`
- `LSPTool/`
- `SkillTool/`

主要职责：

1. 访问外部 MCP 服务器与资源
2. 访问 LSP / language intelligence
3. 调用本地 / bundled / marketplace skill

最容易误读的边界：

1. MCP tool 存在，不等于当前 host / scope / policy 一定支持。
2. `SkillTool` 不是简单命令别名，它会把 prompt artifact 与权限附带进来。
3. `LSPTool` 的存在仍然受 feature 和 host 配置影响，不是默认主路径。

## 8. 环境自动化与内部测试原语

核心目录：

- `RemoteTriggerTool/`
- `ScheduleCronTool/`
- `SleepTool/`
- `SyntheticOutputTool/`
- `testing/TestingPermissionTool.tsx`
- `shared/`

主要职责：

1. 远程触发、计划调度、等待
2. 生成合成输出或测试权限路径
3. 放置工具间共享逻辑

最容易误读的边界：

1. `testing/` 明确是内部测试 surface，不是正式公开工具面。
2. `shared/` 不是正式工具，而是跨工具辅助层。
3. `SyntheticOutputTool` 等内部工具的存在，不等于产品公开承诺。

## 9. Tools 的四个治理信号

`tools.ts` 暴露了四个非常关键的治理信号：

1. simple mode 是正式 consumer subset
2. REPL mode 会隐藏 primitive tools
3. deny rule 会在模型看到工具前先过滤
4. built-in / MCP 排序为 prompt cache 稳定性服务

这意味着：

- 工具治理先于工具调用

也是 Claude Code 安全与省 token 设计的重要来源。

## 10. 推荐阅读顺序

更稳的 `tools/` 阅读顺序是：

1. `tools.ts`：先看真实工具池怎样被装配
2. `BashTool` / `File*Tool`：再看执行原语
3. `ToolSearchTool`：再看 deferred visibility
4. `AgentTool` / task 族：再看多 agent 与对象升级
5. `MCPTool` / `SkillTool` / `LSPTool`：最后看扩展桥接

## 11. 一句话总结

`tools/` 二级目录 atlas 真正统一的，不是“模型能调用哪些工具”，而是“哪些动作原语会在什么模式、什么消费者、什么治理条件下被看见和被允许”。
