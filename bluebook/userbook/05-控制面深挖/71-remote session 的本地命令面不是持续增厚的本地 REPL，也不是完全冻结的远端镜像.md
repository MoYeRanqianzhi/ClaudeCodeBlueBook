# `useSkillsChange`、`useManagePlugins`、`MCPConnectionManager` 与 `useMergedCommands`：为什么 remote session 的本地命令面不是持续增厚的本地 REPL，也不是完全冻结的远端镜像

## 用户目标

不是只知道 remote session 里：

- 有一份本地 `commands`
- 远端 `init` 会裁它
- slash 输入还能继续走 remote send

而是继续往下拆：

- remote session 的本地命令面为什么不会像本地 REPL 一样继续热增厚？
- 为什么它又不是一张完全冻结、只剩初始远端安全命令的死表？
- skills、plugins、MCP、IDE、Chrome prompt 这些本地增厚链，到底哪些被关，哪些还留着孔道？

如果这些问题不先拆开，读者最容易落入两个相反但都错误的极端：

- “remote session 就是一张完全冻结的远端命令镜像。”
- “remote session 仍然和本地 REPL 一样，会继续把本地技能、插件、MCP、IDE 能力都热接进来。”

源码不支持这两个极端结论。

## 第一性原理

remote session 的本地命令面更像一块：

- `default-thin`
- `selectively porous`

的本地壳层。

也就是：

1. 一组典型的本地增厚器被主动关掉。
2. 初始 `plugins` / `mcp` 状态从空壳起步。
3. 但并不是所有合流点都被封死，尤其 `mcp.commands` 仍然保留注入孔道。

更稳的提问不是：

- “remote session 的命令面是本地还是远端？”

而是：

- “哪些本地增厚链被关掉了，哪些 store 合流点仍然活着；如果不分开写，会把它错写成‘冻结’还是‘满血本地’？”

只要这三层不先拆开，正文就会把 remote session 的本地命令面写扁。

这里也先卡住边界：

- 这页讲的是 interactive remote session 的本地命令面。
- 不重复 68/69/70 页对 slash 路由与 `disableSlashCommands` 的拆分。
- 不展开远端 `slash_commands` 自身的消费者合同。
- 不展开 headless `-p` 的非交互装配路径。

## 第一层：skills 热重载这条本地增厚链，在 remote session 里被明确切断

### `useSkillsChange(...)` 在 remote session 下拿到的是 `undefined cwd`

`REPL.tsx` 里写得很直接：

- `useSkillsChange(isRemoteSession ? undefined : getProjectRoot(), setLocalCommands)`

而 `useSkillsChange.ts` 又在两个关键回调里都先做：

- `if (!cwd) return`

所以一旦进入 remote session：

- skill 文件变动不会触发基于 project root 的本地命令重扫
- GrowthBook refresh 也不会基于 cwd 重新跑 `getCommands(cwd)`

这说明 remote session 的本地命令面不会像本地 REPL 一样继续因为：

- skill 文件变化
- 本地项目命令刷新

而自动增厚。

只要这一层没拆开，正文就会高估 remote session 对本地技能变化的跟随能力。

## 第二层：插件管理这条本地增厚链也被主动关掉，而且默认从空壳起步

### 初始 `plugins` 状态本来就是空的

`main.tsx` 构造 `initialState` 时，`plugins` 默认就是：

- `enabled: []`
- `disabled: []`
- `commands: []`

这说明 remote session 并不是带着一整套本地插件命令面起跑。

### `useManagePlugins({ enabled: !isRemoteSession })` 又把插件加载器关掉

`REPL.tsx` 对插件管理的调用是：

- `useManagePlugins({ enabled: !isRemoteSession })`

而 `useManagePlugins.ts` 在两个关键 `useEffect` 里都先做：

- `if (!enabled) return`

于是 remote session 下：

- 初始插件加载不会跑
- `needsRefresh` 提示链也不会跑

因此更准确的说法不是：

- “remote session 永远不可能出现插件命令”

而是：

- “它默认从空插件命令面起步，且不会像本地 REPL 那样主动加载 / 刷新本地插件命令”

这比“完全冻结”更准确，也比“和本地一样会热加载插件”更准确。

## 第三层：不只是命令，几条本地会话增厚器也一起被关掉

`REPL.tsx` 里，remote session 还会系统性地关掉几类本地 enrichers：

- `performStartupChecks(...)` 在 `isRemoteSession` 时直接 `return`
- `useSwarmInitialization(..., { enabled: !isRemoteSession })`
- `usePromptsFromClaudeInChrome(isRemoteSession ? EMPTY_MCP_CLIENTS : mcpClients, ...)`
- `useIdeLogging(isRemoteSession ? EMPTY_MCP_CLIENTS : mcp.clients)`
- `useIdeSelection(isRemoteSession ? EMPTY_MCP_CLIENTS : mcp.clients, ...)`

这些不一定都直接往 `commands` 里塞东西，但它们共同说明了一个设计方向：

- remote session 会主动压低本地宿主侧的自发生长能力

也就是说这不是单点规则，而是一种系统性倾向：

- 本地壳层要变薄

只要这一层没拆开，读者就会把 remote session 的“薄”误判成只发生在 slash command 这一个对象上。

## 第四层：但 `MCPConnectionManager` 没有被 remote session 关掉

### `MCPConnectionManager` 在 REPL 外壳里始终挂着

`REPL.tsx` 在主布局外层直接包了一层：

- `<MCPConnectionManager ...>`

这里没有：

- `isRemoteSession ? null : ...`

的分支。

### `MCPConnectionManager` 内部也没有 `enabled: !isRemoteSession`

`MCPConnectionManager.tsx` 只是无条件调用：

- `useManageMCPConnections(dynamicMcpConfig, isStrictMcpConfig)`

而 `useManageMCPConnections(...)` 本身也只收配置参数，不收 remote-mode 开关。

这说明在 remote session 里，本地壳层并不是所有增厚器都停了：

- MCP 连接管理这条链仍然在跑

这就是本页最关键的“不是完全冻结”的证据。

## 第五层：因此 `mcp.commands` 仍然可能继续渗进本地命令面

### `useManageMCPConnections(...)` 会把拿到的 commands 写进 `AppState.mcp.commands`

`useManageMCPConnections.ts` 在更新状态时明确有：

- `commands === undefined ? mcp.commands : [...reject(...), ...commands]`

最后写回：

- `mcp.commands: updatedCommands`

这说明 MCP 命令不是只在启动前装一次，而是由连接管理链继续写进共享状态。

### `useMergedCommands(...)` 又会把 `mcp.commands` 和本地命令面继续合流

`REPL.tsx` 对命令面的构造是：

- `localCommands`
- 再合 `plugins.commands`
- 再合 `mcp.commands`

而 `useMergedCommands.ts` 本身只是：

- 结构性地 `uniqBy([...initialCommands, ...mcpCommands], 'name')`

它并不知道也不关心当前是否 remote session。

因此只要 `mcp.commands` 进了 store，本地命令面在结构上就仍然是：

- porous

而不是：

- sealed

只要这一层没拆开，正文就会把 remote session 错写成一张不可再变的命令快照。

## 第六层：所以 remote session 的本地命令面更准确的定义是“默认薄、局部可渗透”

把前几层合起来，更准确的结构是：

### 被关掉的本地增厚链

- skills watcher / GrowthBook re-filter 这条基于 cwd 的本地命令刷新链
- plugin manager 的初始加载与 refresh 提示链
- swarm 初始化
- Chrome prompt 注入
- IDE logging / selection 这类本地 IDE enrichers

### 仍然活着的合流孔道

- `MCPConnectionManager`
- `useManageMCPConnections`
- `mcp.commands -> useMergedCommands -> commands`

所以它既不是：

- “和本地 REPL 一样，什么都继续热接进来”

也不是：

- “初始 `filterCommandsForRemoteMode(...)` 之后就再也不会动”

而是：

- 一块默认变薄、但仍允许部分 store/MCP 注入的本地命令壳层

## 第七层：这会带来哪些真实使用误判

### 误判一：remote session 的本地命令面就是初始远端安全命令表

错在漏掉：

- `mcp.commands` 仍可能继续合流进来

### 误判二：remote session 仍然会自动跟随本地 skill / plugin 变化

错在漏掉：

- `useSkillsChange` 没有 cwd
- `useManagePlugins` 被禁用

### 误判三：remote session 的“薄”只体现在 slash commands

错在漏掉：

- swarm、Chrome prompt、IDE enrichers 这些本地增厚器也一起被关

### 误判四：既然还有 MCP 合流，那 remote session 本地命令面就是满血本地

错在漏掉：

- 它起跑时 `plugins` / `mcp` 默认空壳
- 主动增厚的几条本地链已被关闭

## 第八层：稳定、条件与内部边界

### 稳定可见

- remote session 会主动关掉一组本地增厚器。
- 初始 `plugins` / `mcp` 状态默认是空壳。
- `mcp.commands` 这条 store 合流孔道仍然活着。

### 条件公开

- 是否真的有 MCP commands 继续进来，要看本地 MCP 连接管理链后续有没有产出。
- 插件 / 技能 / IDE enrichers 的具体厚度取决于当前模式是否 remote。
- 这页不替远端能力做承诺，只描述本地壳层结构。

### 内部 / 实现层

- 各种 hook 的具体初始化顺序。
- `dynamicMcpConfig` 的来源与细分。
- 具体某个 MCP server 会注入哪些 prompt commands。

## 第九层：最稳的记忆法

把 remote session 的本地命令面记成一句话：

- `thin by default, porous by MCP`

再补一句：

- 它关掉的是本地自发生长链，不是所有状态合流孔道。

只要这两句没有一起记住，后续分析就会重新滑回：

- “remote 就是冻结”

或

- “remote 其实还是本地满血”

这两个都不对。

## 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/hooks/useSkillsChange.ts`
- `claude-code-source-code/src/hooks/useManagePlugins.ts`
- `claude-code-source-code/src/hooks/useSwarmInitialization.ts`
- `claude-code-source-code/src/services/mcp/MCPConnectionManager.tsx`
- `claude-code-source-code/src/services/mcp/useManageMCPConnections.ts`
- `claude-code-source-code/src/hooks/useMergedCommands.ts`
