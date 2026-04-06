# remote local command plane selective thinning 拆分记忆

## 本轮继续深入的核心判断

第 70 页已经拆开：

- `disableSlashCommands` 会杀掉本地 slash 命令层
- 但不自动杀掉 remote slash 文本入口

但还缺一层更接近“remote 本地壳层总体设计”的解释：

- remote session 的本地命令面不是冻结
- 也不是本地满血
- 而是默认变薄，同时保留局部 MCP 合流孔道

如果不单独补这一批，正文还会继续犯六种错：

- 把 remote session 写成完全冻结快照
- 把 remote session 写成本地 REPL 的轻微皮肤变化
- 漏掉 `useSkillsChange` 在 remote 时直接失效
- 漏掉 `useManagePlugins` 在 remote 时直接停掉
- 漏掉 `MCPConnectionManager` 仍然挂着
- 把 MCP 局部孔道夸大成“本地仍然满血”

## 本轮最关键的源码纠偏

### 纠偏一：被关掉的是“本地自发生长链”，不是所有合流点

最关键的结构区别在于：

- `useSkillsChange` 拿不到 cwd
- `useManagePlugins` 被 `enabled: !isRemoteSession` 关掉
- `useSwarmInitialization` 也被关掉

这说明 remote session 不再像本地 REPL 那样靠本地 project root、plugin disk 状态、team context 自己继续长厚。

### 纠偏二：默认初始状态确实从空壳起步

`initialState` 里：

- `plugins.commands = []`
- `mcp.commands = []`

这让“默认薄”不是一种感觉，而是初始化层面的事实。

### 纠偏三：但 `MCPConnectionManager` 仍然保留一个实际孔道

这一轮最重要的新增不是“又发现一个被关的东西”，而是反过来发现：

- `MCPConnectionManager` 没被 remote 关掉
- `useManageMCPConnections` 仍会写 `mcp.commands`
- `useMergedCommands` 仍会把它们并回本地命令面

所以更准确的结构不是：

- frozen

而是：

- selectively porous

## 苏格拉底式自审

### 问：为什么这批不能塞回第 70 页？

答：第 70 页回答的是：

- 一个显式旗标怎样切掉本地 slash 命令层，但保留 remote 文本入口

本轮问题已经换成：

- remote session 整体本地命令壳层的生长机制与残余孔道

也就是：

- shell-thinning architecture

不是：

- disableSlashCommands semantics

### 问：为什么这批必须强调“不是冻结”？

答：因为如果不强调这一点，前几批写完后很容易形成一个假总论：

- remote session 的本地命令面就是初始 `filterCommandsForRemoteMode(...)` 之后的静态快照

而 MCP 这条仍然活着的合流路径恰恰反证了这一点。

### 问：为什么这批又不能夸张成“remote 其实还是满血本地”？

答：因为本轮另一半证据同样强：

- skills watcher 关了
- plugin loader 关了
- swarm init 关了
- Chrome/IDE enrichers 被空 client 列表压平

所以它只是保留局部孔道，不是满血恢复本地壳层。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/71-useSkillsChange、useManagePlugins、MCPConnectionManager 与 useMergedCommands：为什么 remote session 的本地命令面不是持续增厚的本地 REPL，也不是完全冻结的远端镜像.md`
- `bluebook/userbook/03-参考索引/02-能力边界/60-Remote local command plane selective thinning、plugin disable 与 MCP porosity 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/71-2026-04-06-remote local command plane selective thinning 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- `useSkillsChange` 为什么在 remote 里失去 cwd
- `useManagePlugins` 为什么在 remote 里被禁用
- 初始 `plugins` / `mcp` 为什么是空壳
- `MCPConnectionManager` 为什么仍然挂着
- `mcp.commands` 为什么仍能通过 `useMergedCommands` 渗回命令面

### 不应写进正文的

- 第 68/69/70 页关于 slash 路由的整段复述
- 具体某个 MCP server 注入了哪些 commands
- 对“为什么产品故意保留这个孔道”的猜测性心理分析
- 过细的 AppState 其他字段枚举

这些继续只留在记忆层。

## 下一轮继续深入的候选问题

1. remote mode 下本地 tool plane 与 command plane 的 thinning / porosity 是否一致，还是出现新的错位？
2. `viewerOnly`、`disableSlashCommands`、`REMOTE_SAFE_COMMANDS`、MCP porosity 四者能否再汇总成“本地解释权最小化”专题？
3. remote session 与 direct connect 在“本地壳层厚度”上的差异，是否值得单独拉出跨模式对照？

只要这三问没答清，后续继续深入时仍容易把：

- remote 的本地命令壳层

重新写成两个错误极端之一：

- “冻结”
- “满血”
