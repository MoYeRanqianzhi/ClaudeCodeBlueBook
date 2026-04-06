# Tools 二级目录 Atlas：执行原语、交互控制、任务编排、扩展桥接与延迟暴露边界

这一章回答五个问题：

1. `tools/` 往二级目录拆开后，到底分成了哪些工具族群。
2. 哪些工具是真正的执行原语，哪些是控制面工具，哪些是扩展桥接或内部工具。
3. 工具的可见性治理、延迟暴露、权限过滤与消费者子集是怎样收口的。
4. 哪些工具目录最容易被误读，从而把安全、token 或协作写坏。
5. 平台设计者该按什么顺序阅读 `tools/`。

## 0. 代表性锚点与 authority ladder

代表性源码锚点：

- `claude-code-source-code/src/tools.ts:193-367`
- `claude-code-source-code/src/tools/ToolSearchTool/ToolSearchTool.ts:1-120`
- `claude-code-source-code/src/tools/BashTool/BashTool.tsx:1-120`
- `claude-code-source-code/src/tools/PowerShellTool/PowerShellTool.tsx:1-120`
- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx:1-120`
- `claude-code-source-code/src/tools/REPLTool/primitiveTools.ts:1-120`
- `claude-code-source-code/src/tools/MCPTool/MCPTool.ts:1-120`

这页不再先靠文件数解释自己，而是先给一条 authority ladder：

1. `Tool.ts`
2. `tools.ts`
3. `ToolSearchTool`
4. `AgentTool / Task*`
5. `MCPTool / SkillTool / LSPTool`

## 1. 先说结论

`tools/` 不是“很多模型函数”目录，而是 Claude Code 的动作原语平面。

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

- authority file：
  - `BashTool`、`PowerShellTool`、`FileRead/Edit/Write`
- consumer subset：
  - REPL primitive VM、mode-specific 隐藏工具只是特殊子集
- danger surface：
  - path validation、mode validation、sandbox 与 destructive warnings 一旦失真，会直接破坏动作边界
- first reject path：
  - 一旦工作区语义开始漂移，先回各原语 authority 文件，不先改 UI 壳层

## 4. 搜索、检索与外部信息原语

- authority file：
  - `ToolSearchTool`、`GlobTool`、`GrepTool`、`WebFetchTool`、`WebSearchTool`
- consumer subset：
  - deferred tools、embedded search、host-specific web 能力都只是可见性子集
- danger surface：
  - 把搜索工具误写成永远主路径，会直接写坏 deferred visibility 与能力定价
- first reject path：
  - 一旦模型似乎一开始就“知道所有工具”，先回 `ToolSearchTool` 与 visible-set 裁切

## 5. 认知控制与交互原语

- authority file：
  - `TodoWriteTool`、`AskUserQuestionTool`、`ConfigTool`、`Enter/ExitPlanModeTool`、`Enter/ExitWorktreeTool`
- consumer subset：
  - 用户类型、mode 与对象边界决定当前哪些控制原语可见
- danger surface：
  - 把对象升级原语误写成体验小功能，会直接写坏治理控制面
- first reject path：
  - 一旦 plan / worktree / ask-user 开始像 UI 快捷操作，先回这些 tool 的 authority 文件

## 6. 任务、团队与编排原语

- authority file：
  - `AgentTool`、`Task*`、`Team*`、`SendMessageTool`
- consumer subset：
  - feature / mode / host 决定 task、team、worker 细节是否进入当前工具池
- danger surface：
  - 把对象化任务语义退回成“多开几个线程”，最容易破坏恢复与协作边界
- first reject path：
  - 一旦多 Agent 行为开始像线程技巧，先回 `AgentTool` 与 task 族 authority 文件

## 7. 扩展、资源与桥接原语

- authority file：
  - `MCPTool`、`McpAuthTool`、`SkillTool`、`LSPTool`
- consumer subset：
  - host、scope、policy、feature 决定扩展桥接是否进入当前世界
- danger surface：
  - 把 bridge tool 误当默认主路径，会直接写坏 capability governance
- first reject path：
  - 一旦扩展能力看起来像无条件公开面，先回这些 bridge tool 的 authority 文件与 visible-set 裁切

## 8. 环境自动化与内部测试原语

- authority file：
  - `RemoteTriggerTool`、`ScheduleCronTool`、`SleepTool`
- consumer subset：
  - `testing/`、`SyntheticOutputTool`、`shared/` 只构成内部或辅助子集
- danger surface：
  - 把内部测试面误写成正式公开工具面，最容易制造假承诺
- first reject path：
  - 一旦环境自动化开始看起来像默认产品面，先回 visible-set 与 internal-only 边界

## 9. Tools 的四个治理信号

`tools.ts` 暴露了四个非常关键的治理信号：

1. simple mode 是正式 consumer subset
2. REPL mode 会隐藏 primitive tools
3. deny rule 会在模型看到工具前先过滤
4. built-in / MCP 排序为 prompt cache 稳定性服务

这意味着：

- 工具治理先于工具调用

也是 Claude Code 安全与省 token 设计的重要来源。

## 10. Reject 顺序

更稳的 `tools/` reject 顺序是：

1. 先回 `Tool.ts / tools.ts`
2. 再回 deferred visibility 与 execution 原语
3. 再回 task / agent / team authority
4. 最后才看扩展桥接和环境自动化子集

## 11. 一句话总结

`tools/` 二级目录 atlas 真正统一的，不是“模型能调用哪些工具”，而是“哪些动作原语会在什么模式、什么消费者、什么治理条件下被看见和被允许”。
