# Trust Dialog、项目级 .mcp.json 批准与 Health Check：为什么 skip trust dialog 不等于 project MCP 已被批准

## 用户目标

不是只知道 Claude Code “有 workspace trust、`.mcp.json` 和 `doctor` / `mcp list|get`”，而是先分清四件事：

- `skip trust dialog` 到底跳过了什么，为什么它不等于“这个目录已经被信任”。
- 项目级 `.mcp.json` server 的批准状态，为什么不是 workspace trust 的附属字段。
- `doctor` 与 `mcp list|get` 为什么会碰到 `.mcp.json` server，却仍然不等于交互式批准流。
- 真正的 non-interactive / bypass fallback，为什么又是另一层，而不是 health-check 的别名。

如果这四件事不先拆开，读者最容易把下面这些对象混成一锅“项目 MCP 已经过安全检查”：

- 交互启动期的 Trust Dialog
- trust 之后才出现的 `.mcp.json` 批准对话框
- `enabledMcpjsonServers` / `disabledMcpjsonServers` / `enableAllProjectMcpServers`
- `doctor`
- `mcp list`
- `mcp get`
- `mcp reset-project-choices`
- non-interactive / bypass 下的自动批准分支

## 第一性原理

Claude Code 在这里治理的不是同一个问题，而是三种不同问题：

1. 这个工作区能不能进入交互会话的受信任状态。
2. 这个项目来源的 `.mcp.json` server，当前操作者愿不愿意启用。
3. 这次命令是在做交互启动，还是在做宿主/MCP 健康检查。

因此更稳的提问不是：

- “这个项目的 MCP 到底批没批准？”

而是：

- “我现在卡在 workspace trust、project server approval，还是 health-check 运行面？”

只要不先拆开这三层，`skip trust dialog` 就会被误写成“所有安全门都已经过去”。

## 第一层：Trust Dialog 是交互工作区边界，不是项目 MCP 批准页

### 交互会话先过 `showSetupScreens(...)`

`main.tsx` 很明确：

- 只有 `!isNonInteractiveSession` 才会进入 `showSetupScreens(...)`
- 这说明 Trust Dialog 属于交互启动链
- 它不是所有 root command 共用的一般开关

### 交互模式里，Trust Dialog 总是先于项目 MCP 批准

`interactiveHelpers.tsx` 的注释和执行顺序很直接：

- interactive session 总是显示 trust dialog
- trust boundary 与 permission mode 分离
- `bypassPermissions` 只影响工具权限，不等于 workspace trust

更关键的是顺序：

1. `checkHasTrustDialogAccepted()` 未通过时，渲染 `TrustDialog`
2. trust 通过后，`setSessionTrustAccepted(true)`
3. 如果 settings 没错误，再执行 `handleMcpjsonServerApprovals(root)`

所以 `.mcp.json` server 批准不是 trust dialog 的一个选项，而是：

- trust 之后的第二道交互门

### `skip trust dialog` 不能反推“这个目录已被 trust”

这一点最容易误判。

对用户更稳的表述应是：

- trust dialog 被跳过，只说明当前入口没有进入交互 trust UI

而不是：

- 这个目录已经被 trust 过
- 或者当前 session 一定写入了 trust 状态
- 或者 trust 之后的其他 setup dialog 也一并完成

## 第二层：项目级 `.mcp.json` 批准是单独的本地决策层

### 批准对象是 project-scope server，不是整个工作区

`handleMcpjsonServerApprovals(root)` 做的事很清楚：

- 先取 `getMcpConfigsByScope('project')`
- 再筛 `getProjectMcpServerStatus(serverName) === 'pending'`
- 一个时走单 server dialog
- 多个时走 multiselect dialog

所以这层回答的不是：

- “这个 repo 是否可信”

而是：

- “这些 project-scope MCP server 里，哪些愿意启用”

### 批准状态单独落在本地 settings

批准对话框的实现也很清楚：

- 允许单个 server：写入 `enabledMcpjsonServers`
- 拒绝单个 server：写入 `disabledMcpjsonServers`
- 允许当前项目后续全部 server：写入 `enableAllProjectMcpServers`

并且它们写入的是：

- `localSettings`

这说明项目 MCP 批准的真实对象是：

- 当前操作者本地对 project-scope server 的启用/禁用决策

而不是：

- 仓库级 trust 标志
- 共享给所有协作者的 repo 状态

### `reset-project-choices` 重置的是项目 MCP 选择，不是 workspace trust

`claude mcp reset-project-choices` 会清空：

- `enabledMcpjsonServers`
- `disabledMcpjsonServers`
- `enableAllProjectMcpServers`

并提示下次启动 Claude Code 时重新询问批准。

这条命令的存在本身就说明：

- project MCP approval 是独立可重置的持久状态
- 它不等于 trust dialog 的通过状态

### `.mcp.json` 也不是“只看当前目录”

`getMcpConfigsByScope('project')` 会：

- 从当前 `cwd` 一路向上走到文件系统根
- 再按从高层目录到当前目录的顺序合并
- 越靠近 `cwd` 的 `.mcp.json` 优先级越高

所以项目级 MCP 批准问题的真实对象是：

- 当前工作路径链上的 project-scope server 集合

而不是：

- 仅仅当前目录那一个 `.mcp.json`

## 第三层：Health Check 会碰 `.mcp.json`，但不等于交互批准流

### `doctor`、`mcp list`、`mcp get` 都明确写着 skip trust dialog

`main.tsx` 的帮助文本把三件事写得很直接：

- `doctor` skip trust dialog
- `mcp list` skip trust dialog
- `mcp get` skip trust dialog
- 并且会为 health checks 拉起 `.mcp.json` 里的 `stdio` server

这已经足够说明：

- 这些命令属于 health-check 路径
- 不属于交互 setup dialog 路径

### `mcp list` / `mcp get` 是探活，不是静态读文件

`cli/handlers/mcp.tsx` 里：

- `mcp list` 先 `getAllMcpConfigs()`
- 然后打印 `Checking MCP server health...`
- 再对每个 server 执行 `checkMcpServerHealth()`
- 而 `checkMcpServerHealth()` 继续调 `connectToServer()`

`mcp get` 也不是只看配置：

- 先 `getMcpConfigByName(name)`
- 再立刻做 `checkMcpServerHealth(name, server)`

因此它们碰到 `.mcp.json` server 的方式是：

- 连接探针
- 宿主健康检查

不是：

- 替用户跑一遍交互批准对话框

### `mcp list` 与 `mcp get` 碰到的 project server，本来也不是同一集合

这是另一条非常容易写错的边界。

`mcp list` 先走：

- `getAllMcpConfigs()`

而 `getAllMcpConfigs()` 内部仍先基于：

- `getClaudeCodeMcpConfigs()`

这条聚合链会先把 project servers 过滤成：

- `approvedProjectServers`

再参与后续合并。

所以对 project-scope server 来说，`mcp list` 更接近：

- 先看“哪些 server 已进入聚合配置”
- 再批量做 health check

但 `mcp get` 不同。

它先走：

- `getMcpConfigByName(name)`

而这条函数按名字直查：

- enterprise
- local
- project
- user

其中 project 这一支不是从 `approvedProjectServers` 里拿，而是直接从：

- `getMcpConfigsByScope('project')`

返回的 project servers 里按名命中。

因此更准确的结论是：

- `mcp list` 看的是“先聚合过滤，再批量探活”
- `mcp get` 看的是“先按名直取，再单点探活”

这意味着：

- 某个 pending / rejected 的 project server
- 在 `mcp list` 或 Doctor runtime 里可能看不到
- 但在 `mcp get <name>` 里仍可能被直接探活

这再次说明：

- “命令能碰到 server”
- 并不等于
- “server 已经过项目批准层”

### `doctor` 是宿主诊断入口，不是项目 MCP 批准器

`doctor` 的帮助文本虽然提到 auto-updater，但它的入口特征更关键：

- 单独创建 root
- 走 `doctorHandler(root)`
- 明确带着 trust skip 警告

因此对这一页来说，更重要的结论不是它检查多少项，而是：

- 它属于宿主健康检查入口
- 不是替代 trust / approval dialog 的设置向导

并且它和 `mcp get` 也不是同一条链。

Doctor runtime 通过：

- `MCPConnectionManager`
- `useManageMCPConnections`

进入聚合配置链，先吃到：

- `getClaudeCodeMcpConfigs(...)`

再过滤 disabled server 后异步连接。

因此它更接近：

- 聚合配置 + 运行态连接管理

而不是：

- 单点按名探活

Doctor 里与 MCP 相关的结果至少有两层：

- 配置/解析错误
- 运行态 tools / context warning

所以它不应被写成：

- `mcp get` 的 UI 版

### 所以 “health check 触碰到了 server” 不等于 “server 已批准”

这是本页最重要的结论。

更稳的判断应是：

- health-check 命令在探测 server 是否可连
- project approval 在决定这些 project server 是否进入批准集合
- workspace trust 在决定交互工作区是否进入受信任启动链

三者对象不同，不能互相偷换。

## 第四层：真正的 fallback 是 non-interactive / bypass，不是 health-check 别名

### `getProjectMcpServerStatus(...)` 的自动批准是专门的 fallback 分支

`services/mcp/utils.ts` 很明确：

- 若已记录到 `disabledMcpjsonServers`，返回 `rejected`
- 若已记录到 `enabledMcpjsonServers` 或 `enableAllProjectMcpServers`，返回 `approved`
- 否则才进入 fallback 判断

这说明：

- 自动批准不是第一优先级
- 它是在没有显式批准记录时的补位逻辑

### bypass 分支不是 trust 通过，更不是 repo 自批

源码注释写得非常硬：

- `hasSkipDangerousModePermissionPrompt()` 只读 user/local/flag/policy
- 明确不读 `projectSettings`
- 原因是 repo 不能替用户接受 bypass dialog

所以这条分支的真实含义是：

- 用户已经在可信来源上接受过 bypass dangerous mode
- 因此在不能弹 popup 时，允许 project MCP 自动判为 `approved`

它不是：

- 项目自己宣布自己可信
- 或 trust dialog 的另一种皮肤

### true non-interactive 也不是 “一切 skip trust 的命令”

`bootstrap/state.ts` 和 `main.tsx` 里，non-interactive 的判定是：

- `-p/--print`
- `--init-only`
- `--sdk-url`
- 或 stdout 非 TTY

因此更准确的说法是：

- true non-interactive 是启动模式判定
- `doctor` / `mcp list|get` 的 trust skip 是具体命令帮助文本声明的运行时边界

两者相关，但不是同一个布尔量。

换句话说：

- “skip trust dialog” 不自动推出 `getIsNonInteractiveSession() === true`
- 也不自动推出项目 server 进入 auto-approved fallback

### 进入 merged config 的 project server，本来也要先过批准判断

`getClaudeCodeMcpConfigs()` 会先构造：

- `projectServers`

然后只把：

- `getProjectMcpServerStatus(name) === 'approved'`

的对象放入：

- `approvedProjectServers`

再并到最终配置里。

所以系统内部的真实语义是：

- project-scope server 与 “可进入合并配置的 project server”
- 本来就是两张表

这再次说明：

- trust skip、health check、project approval
- 不应被写成一层

但这里还要再补一句：

- `approvedProjectServers` 只约束聚合配置主链
- 它不自动约束 `getMcpConfigByName()` 这种按名直取路径

所以正文里更稳的句式应是：

- “大多数聚合健康检查路径只看到 approved project servers”
- “按名探活的 `mcp get` 仍可能直接命中 project scope server”

而不要写成：

- “所有 health-check 命令都只会看到 approved project servers”

## 第五层：稳定公开面、条件面与内部实现也不能混写

### 可以写成稳定公开能力的

- 交互启动会先经过 workspace trust
- `doctor` / `mcp list|get` 明确 skip trust dialog
- `mcp reset-project-choices` 是公开重置入口

这些都是用户可见且帮助文本或命令对象稳定可见的事实。

### 应写成“带源码支撑的运行时边界”，不要抬成独立用户功能的

- `handleMcpjsonServerApprovals(root)`
- `approvedProjectServers`
- `enabledMcpjsonServers` / `disabledMcpjsonServers`
- `setSessionTrustAccepted(true)`

这些很重要，但它们回答的是：

- 运行时如何分层

而不是：

- 用户菜单上有一个叫这个名字的功能

### 应写成 fallback / 条件分支，不写成默认主线的

- bypass dangerous mode 下的 auto-approve
- true non-interactive 下的 auto-approve

它们很关键，但正文语气应是：

- “在不能弹 popup 的 session class 里，系统如何降级”

而不是：

- “项目 MCP 本来就会自动批准”

## 最后的判断公式

遇到 “skip trust dialog” 一类表述时，先问四个问题：

1. 当前入口是在做交互启动，还是只在做 health check？
2. 当前结论说的是 workspace trust，还是 project `.mcp.json` server approval？
3. 这里有没有真正进入 `handleMcpjsonServerApprovals(...)` 这条交互批准链？
4. 这里是不是只落到了 bypass / non-interactive 的 fallback 分支？

只有这四问先答清，才不会把：

- trust
- project approval
- health-check
- non-interactive fallback

误写成同一个“项目 MCP 已经安全通过”的状态。

## 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/interactiveHelpers.tsx`
- `claude-code-source-code/src/services/mcpServerApproval.tsx`
- `claude-code-source-code/src/services/mcp/utils.ts`
- `claude-code-source-code/src/services/mcp/config.ts`
- `claude-code-source-code/src/cli/handlers/mcp.tsx`
- `claude-code-source-code/src/components/MCPServerApprovalDialog.tsx`
- `claude-code-source-code/src/components/MCPServerMultiselectDialog.tsx`
- `claude-code-source-code/src/bootstrap/state.ts`
