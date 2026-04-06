# trust dialog 与项目级 .mcp.json 批准边界拆分记忆

## 本轮继续深入的核心判断

上一批已经拆清了：

- host / viewer / health-check
- `/mcp` 总览 vs 按名解析
- trust dialog vs 来源信任 / plugin-only policy

但正文里仍缺一批专门回答：

- 为什么 `skip trust dialog` 不等于 project MCP 已被批准
- 为什么 `.mcp.json` 批准必须从 workspace trust 中再拆一层
- 为什么 `doctor` / `mcp list|get` 虽然碰到 project server，却不能替代交互批准流

如果不补这一批，正文会继续犯三种错：

- 把 trust 当成项目 server 逐项批准
- 把 health-check 当成批准器
- 把 non-interactive fallback 当成所有 trust-skip 入口的共同语义

## 苏格拉底式自审

### 问：为什么这批不能塞回 `14-来源信任、Trust Dialog 与 Plugin-only Policy`？

答：第 14 页回答的是：

- 扩展来源为何被分级信任
- plugin-only policy 与 hooks 总闸如何分层

而本轮问题已经变成：

- 交互 trust 之后为何还要再弹项目 MCP 批准
- `skip trust dialog` 在 health-check 场景下到底意味着什么
- fallback auto-approve 与交互批准到底差在哪

这不再是“来源信任”，而是：

- 启动 trust
- 项目 server 批准
- 健康检查路径

三层运行时对象的分离。

### 问：为什么这批也不能塞回 `17-MCP 配置、按名解析与 Agent 引用`？

答：第 17 页回答的是：

- `/mcp` 菜单
- 全局配置总览
- 按名解析
- Agent `mcpServers`

对象错位。

本轮的核心却是：

- project-scope server 有没有被批准
- health-check 命令碰到 project server 时是否等于批准

它关注的是：

- server 是否能进入批准集合

而不是：

- server 是否能进入按名解析或 Agent 引用

所以不能硬并。

### 问：为什么这批要放在 `21-Host、Viewer 与 Health Check` 后面？

答：第 21 页先把：

- host
- viewer
- health-check

这三种会外对象拆开了。

但它仍没回答：

- 当 health-check 入口写着 skip trust dialog 时
- 这个 trust skip 与真正的 non-interactive fallback 有什么区别
- 它与 project `.mcp.json` 批准层又是什么关系

因此第 22 页应作为第 21 页的“更窄一刀”：

- 不是再讲 host/viewer
- 而是继续收窄 health-check 与 trust / approval 的边界

### 问：这批最该防的假并列是什么？

答：

- workspace trust = project server approval
- `doctor` = 项目 MCP 向导
- `mcp list|get` = 只读配置查看
- `mcp list` = `mcp get` 的批量版
- trust skip = 已 trusted
- trust skip = non-interactive
- auto-approve = 交互批准

只要这六组没先拆开，正文就会把三个对象层写回同一锅。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/22-Trust Dialog、项目级 .mcp.json 批准与 Health Check：为什么 skip trust dialog 不等于 project MCP 已被批准.md`
- `bluebook/userbook/03-参考索引/02-能力边界/11-Trust Dialog、项目级 .mcp.json 批准与 Health Check 索引.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- `showSetupScreens(...)` 只属于交互启动链
- trust 通过后才会执行 `handleMcpjsonServerApprovals(...)`
- 项目 MCP 批准状态单独落在本地 settings
- `reset-project-choices` 只重置项目 MCP 选择
- `doctor` / `mcp list|get` 会 skip trust dialog 且带 health-check 副作用
- `approvedProjectServers` 与原始 `projectServers` 不是同一张表
- auto-approve 是 bypass / non-interactive fallback

### 不应写进正文的

- 429 / 多 Agent 超时等本轮调度噪音
- 过多 UI 组件层细节，比如 Select、快捷键、Byline 等实现
- migration 历史本身
- `STATE.isInteractive` 的所有旁支调用点

这些内容只保留为作者判断依据，不回流正文。

## 本轮特殊注意

### `skip trust dialog` 与 true non-interactive 必须分开写

源码里：

- true non-interactive 由 `-p`、`--sdk-url`、`--init-only`、stdout 非 TTY 等启动条件决定
- `doctor` / `mcp list|get` 则是各自帮助文本单独声明 trust skip

因此正文不能偷写成：

- “凡是 skip trust dialog 的命令都属于 non-interactive”

### 批准状态是本地操作者状态，不是仓库状态

批准对话框写入的是：

- `localSettings`

所以本页必须把“当前操作者本地选择”写在前面，避免正文重新滑回：

- “项目已经批准了这些 server”

### `.mcp.json` 目录向上遍历值得保留

这条很容易被漏写，但它直接决定：

- 批准对象不止当前目录
- health-check 命令可能碰到来自父目录链的 project server

因此适合保留在正文。

### `mcp list` / Doctor 与 `mcp get` 的不对称必须写清

并行源码复核后，最关键的新结论是：

- `mcp list` 与 Doctor runtime 主要吃的是聚合配置链
- 这条链里的 project servers 会先收窄成 `approvedProjectServers`
- `mcp get` 却走 `getMcpConfigByName()` 按名直取，不经过这层收窄

这条不对称非常重要，因为它直接证明：

- “某命令能对 project server 做 health check”

不能偷换成：

- “该 project server 已进入 approved 集合”

## 后续继续深入时的检查问题

1. 我当前讲的是 workspace trust、project server approval，还是 health-check？
2. 这里是否真的进入了 `showSetupScreens(...)`？
3. 这里是否真的进入了项目 MCP 批准对话框？
4. 这里拿 server 的方式是聚合配置，还是按名直取？
5. 这里是显式批准记录，还是 fallback auto-approve？
6. 我是不是把 trust skip、health check 与 non-interactive 写成了一回事？

只要这六问没先答清，正文就会继续把：

- trust
- `.mcp.json` 批准
- health-check
- fallback

混写成一个假的“项目 MCP 已经安全通过”状态。
