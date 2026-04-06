# `getTools`、`useMergedTools`、`mcp.tools` 与 `toolPermissionContext`：为什么 remote session 的 tool plane 不会像 command plane 一样一起变薄

## 用户目标

不是只知道 remote session 里：

- 本地 `commands` 会默认变薄
- slash UI 会被裁薄
- 一部分本地命令增厚链会被关掉

而是继续追问一个更关键的错位：

- 为什么 `command plane` 已经明显变薄了，`tool plane` 却没有按同样方式一起塌掉？
- 为什么 remote session 的工具池还会继续跟着 `toolPermissionContext`、`mcp.tools`、store 状态变化而重算？
- 这是不是意味着 remote session 的“本地壳层”在工具面和命令面上不是同一种厚度？

如果这些问题不先拆开，读者最容易落入两个新的误判：

- “既然本地命令面变薄了，本地工具面也应该同步冻结。”
- “既然本地工具面还在重算，那本地命令面也应该一样保持满血。”

源码同样不支持这两个结论。

## 第一性原理

remote session 里：

- `command plane`
- `tool plane`

不是同一条装配链。

更准确地说，它们至少沿着三条轴线分离：

1. `Source Shape`：命令面更多来自 `localCommands / plugins.commands / mcp.commands`，工具面更多来自 `getTools(...) / initialTools / mcp.tools`。
2. `Refresh Mechanism`：命令面的本地增厚更依赖 cwd watcher / plugin loader，工具面更依赖 permission context 与 store 里的 MCP tool 状态。
3. `Runtime Recompute`：工具面被显式设计成可中途重算；命令面更多是 UI / discoverability 壳层。

更稳的提问不是：

- “remote session 的本地壳层到底是厚还是薄？”

而是：

- “我现在讨论的是 command plane 还是 tool plane；如果把两者写成同一种本地壳层，会把哪条装配链说错？”

只要这三条轴线不先拆开，正文就会把 remote session 的本地解释权写平。

这里也先卡住边界：

- 这页讲的是 remote session 下 command plane / tool plane 的厚度错位。
- 不重复 71 页对本地命令壳层 selective thinning 的总论。
- 不展开 tool approval / permission request 的完整交互链。
- 不展开 direct connect 对照，只聚焦 remote session。

## 第一层：remote session 的初始 `initialTools` 本来就是空的，但这不等于本地工具池为空

### `main.tsx` 在 remote session 路径里传给 REPL 的 `initialTools` 是 `[]`

无论是：

- attach assistant session
- 新建 remote session

`main.tsx` 传给 `launchRepl(...)` 的都是：

- `initialTools: []`

这说明 remote session 并不是把一整套“启动时预装好的工具池”带进来。

### 但 `REPL.tsx` 自己仍会重新算出 `localTools`

`REPL.tsx` 同时又会做：

- `const localTools = useMemo(() => getTools(toolPermissionContext), ...)`

然后：

- `combinedInitialTools = [...localTools, ...initialTools]`

因为 `initialTools` 在 remote session 路径里是空数组，所以更准确的结构其实是：

- 工具池不是“完全没有”
- 而是“本地 built-in tools 重新按当前 `toolPermissionContext` 现算”

这一步和 command plane 的默认变薄逻辑已经不同。

只要这一层没拆开，读者就会把 `initialTools: []` 误写成“本地工具池为空”。

## 第二层：工具面从一开始就绑定 `toolPermissionContext`，不是绑定 project-root-based 命令 watcher

### `localTools` 的核心输入是 `toolPermissionContext`

`REPL.tsx` 里 `localTools` 的计算依赖于：

- `toolPermissionContext`
- `proactiveActive`
- `isBriefOnly`

而不是：

- `getProjectRoot()`
- `useSkillsChange(...)`
- plugin command loader

这说明 tool plane 的本地刷新来源更接近：

- 当前权限模式
- 当前会话状态
- 当前内建工具 gating

而不是：

- 本地 skill 文件变化
- plugin command 盘面变化

### 所以 command plane 被关掉的那批增厚链，并不会自动带着 tool plane 一起停

71 页已经说明 remote session 会关掉：

- `useSkillsChange`
- `useManagePlugins`
- 若干本地 enrichers

但这些关闭点并不直接决定：

- `getTools(toolPermissionContext)`

是否重算。

这就是第一层根本错位：

- command plane 更依赖本地命令来源刷新
- tool plane 更依赖运行时 permission/context 重算

## 第三层：工具面不仅继续合流，而且被显式设计成“中途重算”

### `useMergedTools(...)` 明确把 `initialTools`、`mcp.tools` 和 `toolPermissionContext` 合并

`useMergedTools.ts` 的签名是：

- `initialTools`
- `mcpTools`
- `toolPermissionContext`

内部先：

- `assembleToolPool(toolPermissionContext, mcpTools)`

再：

- `mergeAndFilterTools(initialTools, assembled, toolPermissionContext.mode)`

这说明工具面不是一张简单列表，而是一条：

- built-in tools
- 加 MCP tools
- 再按 mode 过滤

的运行时装配链。

### `computeTools()` 还会刻意绕过闭包，用 store 的新值重算

`REPL.tsx` 在后面又显式写了一个：

- `computeTools()`

注释里直接说：

- `useManageMCPConnections` 会异步填充 `appState.mcp`
- store 里的 MCP 状态可能比 render 时闭包更新
- 这也兼做 mid-query tool list updates

然后它实际做：

- `assembleToolPool(state.toolPermissionContext, state.mcp.tools)`
- `mergeAndFilterTools(combinedInitialTools, assembled, state.toolPermissionContext.mode)`

这说明 tool plane 被设计成：

- 可中途刷新
- 可跟随异步 MCP tools 变化
- 可跟随 permission mode 变化

这和 command plane 的“默认变薄”又是不同一层设计。

只要这一层没拆开，正文就会继续把工具面写成命令面的附庸。

## 第四层：MCP 在工具面上的孔道，比在命令面上还更直接

### `useManageMCPConnections(...)` 同时写 `mcp.tools` 和 `mcp.commands`

`useManageMCPConnections.ts` 在同一段状态更新里同时维护：

- `updatedTools`
- `updatedCommands`

最后一起写回：

- `mcp.tools`
- `mcp.commands`

### 但工具面少了一层“本地命令壳层”的摩擦

命令面至少还要经过：

- `localCommands`
- `plugins.commands`
- `mcp.commands`
- `disableSlashCommands`
- 以及若干 slash UI / routing 规则

而工具面更直接：

- `mcp.tools`
- `toolPermissionContext`
- `assembleToolPool(...)`
- `mergeAndFilterTools(...)`

因此更准确地说：

- MCP 在工具面上的渗透，比在命令面上更直、更持续

这也是为什么 remote session 的本地壳层不能只看 command plane。

## 第五层：因此 remote session 里会出现“命令面变薄，但工具面仍持续活着”的厚度错位

把前几层合起来，更准确的结构是：

### command plane 倾向于

- 关闭 cwd-based watcher
- 关闭 plugin loader
- 默认从空 `plugins.commands` / `mcp.commands` 起步
- 在 discoverability 层表现为变薄

### tool plane 倾向于

- 仍由 `getTools(toolPermissionContext)` 现算内建工具
- 仍由 `mcp.tools` 继续渗透
- 仍可在中途依据 store 状态重算
- 仍跟随 `toolPermissionContext.mode` 变化

所以 remote session 的本地壳层更准确的总论不是：

- “本地能力统一变薄”

而是：

- “命令面更薄，工具面更活”

这就是本页最核心的结论。

## 第六层：这会带来哪些真实使用误判

### 误判一：本地命令面薄了，说明本地工具面也被冻结

错在把：

- command discoverability

误当成：

- tool availability

### 误判二：工具面还在重算，说明命令面也应该继续满血

错在把：

- `getTools(...)` / `mcp.tools`

误当成：

- `useSkillsChange` / plugin command loader

### 误判三：remote session 的本地壳层只有一层厚度

错在漏掉：

- command plane
- tool plane

本来就不是同一条装配链

### 误判四：MCP 在命令面和工具面上的进入难度相同

错在漏掉：

- 工具面走的是更直接的 assemble/merge 路径

## 第七层：稳定、条件与内部边界

### 稳定可见

- remote session 的 command plane 和 tool plane 不会同样地变薄。
- `getTools(toolPermissionContext)`、`useMergedTools(...)`、`mcp.tools` 这条链仍然活着。
- tool plane 被设计成可中途重算。

### 条件公开

- 当前 `toolPermissionContext.mode` 如何变化，会直接影响工具面厚度。
- 是否真的有 `mcp.tools` 注入，取决于 MCP 连接管理链后续产出。
- 这页不替远端批准结果做承诺，只描述本地工具池装配结构。

### 内部 / 实现层

- 各个 built-in tool 的具体 `isEnabled()` 细节。
- `mergeAndFilterTools(...)` 的内部去重规则。
- 具体哪种 remote 事件会如何改写 `toolPermissionContext`。

## 第八层：最稳的记忆法

把 remote session 的本地壳层拆成两句：

- `command plane is thinner`
- `tool plane is still live`

再补一句：

- 两者都能接到 MCP，但工具面的接入更直接、更持续

只要这三句没有一起记住，后续分析就会继续把 remote session 写成一张单层壳。

## 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/hooks/useMergedTools.ts`
- `claude-code-source-code/src/services/mcp/useManageMCPConnections.ts`
- `claude-code-source-code/src/tools.ts`
- `claude-code-source-code/src/utils/toolPool.ts`
