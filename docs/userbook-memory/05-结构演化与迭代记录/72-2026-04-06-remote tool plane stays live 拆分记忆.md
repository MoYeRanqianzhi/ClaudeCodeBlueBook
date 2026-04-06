# remote tool plane stays live 拆分记忆

## 本轮继续深入的核心判断

第 71 页已经拆开：

- remote session 的本地命令面默认变薄
- 但仍保留局部 MCP 孔道

但还缺一个更容易误判的层面：

- command plane 变薄
- 不等于 tool plane 同样变薄

如果不单独补这一批，正文还会继续犯五种错：

- 把命令面变薄外推成工具面冻结
- 把 `initialTools: []` 写成工具池为空
- 漏掉 `getTools(toolPermissionContext)` 仍在本地现算
- 漏掉 `computeTools()` 会刻意从 store fresh-state 重算
- 把 `mcp.tools` 与 `mcp.commands` 写成同一条孔道

## 本轮最关键的源码纠偏

### 纠偏一：`initialTools=[]` 不等于本地工具池为空

最关键的新事实是：

- remote session 路径确实传 `initialTools: []`

但 REPL 自己仍会计算：

- `localTools = getTools(toolPermissionContext)`

所以 remote tool plane 不是空池，而是：

- built-in tools reassembled locally

### 纠偏二：工具面被显式设计成 mid-query 可重算

`computeTools()` 的注释和实现都非常关键，它明确说明：

- `useManageMCPConnections` 会异步更新 `appState.mcp`
- 所以工具列表不能只信 render 时闭包

这和命令面明显不是同一种思路。

### 纠偏三：`mcp.tools` 的渗透比 `mcp.commands` 更直接

命令面还要经过更多 UI / discoverability / slash routing 层；工具面则更直接走：

- `assembleToolPool(state.toolPermissionContext, state.mcp.tools)`
- `mergeAndFilterTools(...)`

所以“MCP 还能进 remote 本地壳层”这件事，在工具面上比命令面更强。

## 苏格拉底式自审

### 问：为什么这批不能塞回第 71 页？

答：第 71 页回答的是：

- remote session 的本地命令壳层为何既不冻结也不满血

本轮问题已经换成：

- 为什么 `tool plane` 与 `command plane` 不同厚度

也就是：

- plane mismatch

不是：

- local command shell thinning

### 问：为什么这批必须单写？

答：因为用户实际最容易用错的是：

- “既然命令面没了，我以为工具也没了”

这不是命令页的小补充，而是一个单独的使用层误判。

### 问：为什么必须强调 `toolPermissionContext`？

答：因为工具面的本地生命力，很大一部分就来自：

- `toolPermissionContext`
- `mcp.tools`

如果不把这两个写出来，正文就无法解释为什么工具面仍然是 live 的。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/72-getTools、useMergedTools、mcp.tools 与 toolPermissionContext：为什么 remote session 的 tool plane 不会像 command plane 一样一起变薄.md`
- `bluebook/userbook/03-参考索引/02-能力边界/61-Remote tool plane vs command plane thinning 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/72-2026-04-06-remote tool plane stays live 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- `initialTools=[]` 与 `localTools` 现算的区别
- `useMergedTools` 如何装配工具池
- `computeTools()` 为什么刻意读 fresh store state
- `mcp.tools` 为什么会比 `mcp.commands` 更直接渗透
- command plane / tool plane 为什么不能混写

### 不应写进正文的

- 第 71 页对 command plane thinning 的整段复述
- 完整 permission request / approval 生命周期
- 具体某个 built-in tool 的 `isEnabled()` 细节
- 对产品设计动机的猜测性叙述

这些继续只留在记忆层。

## 下一轮继续深入的候选问题

1. remote session 下 `toolPermissionContext` 的变化源，是否值得单独拆成“本地工具面主权”专题？
2. command plane / tool plane / status plane 三者能否继续汇总成“remote 本地壳层三厚度模型”？
3. direct connect 的 tool plane 厚度是否又是另一种分布，值得和 remote session 单独对照？

只要这三问没答清，后续继续深入时仍容易把：

- remote 的本地工具面

误写成：

- 命令面的附属影子
