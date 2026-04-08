# 插件安装、待刷新与当前会话激活：为什么 `/reload-plugins` 不是安装器

## 用户目标

不是只知道 Claude Code “有 `/plugin` 和 `/reload-plugins`”，而是先看清四件事：

- 插件被安装、被启用、被标记待刷新、被当前 session 真正吃到，为什么不是同一回事。
- `/plugin`、`claude plugin ...`、`/reload-plugins`、SDK `reload_plugins` control request 分别在管哪一层。
- 为什么很多 UI 文案都在反复说 “Run /reload-plugins to apply”。
- 哪些刷新是自动发生的，哪些必须由当前用户或宿主显式触发。

如果这四件事不先拆开，读者最容易把下面这些对象混成一锅“插件已经生效”：

- settings 里的启用意图
- 磁盘上的 marketplace / plugin 物化结果
- `needsRefresh`
- `/plugin` 界面里的 pending toggles / update 标记
- `/reload-plugins`
- headless / CCR 的自动刷新
- SDK `query.reloadPlugins()`
- 当前 session 里的 commands / agents / hooks / plugin MCP / LSP

## 第一性原理

Claude Code 治理插件，不是只有“装了”或“没装”两个状态，而是至少分成三层：

1. 意图层：settings 里声明用户想启用什么插件。
2. 物化层：marketplace / plugin 文件是否已经同步到磁盘缓存。
3. 激活层：当前 session 的 AppState 是否已换成新的 commands / agents / hooks / MCP / LSP 结果。

因此更稳的提问不是：

- “这个插件到底装没装好？”

而是：

- 它只是被声明、已经落盘，还是已经被当前 session 激活？

只要不先分清这三层，`/reload-plugins` 就会被误写成“安装器”。

## 第一层：`/plugin` 与 `claude plugin ...` 主要改的是意图层和物化层

### `/plugin` 管的是插件包与配置动作

在用户心智上，`/plugin` 的主要职责是：

- 安装
- 启停
- 更新
- 配置

它处理的是插件包与设置意图，而不是立刻替换当前 session 的所有扩展面。

### `claude plugin ...` 与 `/plugin` 也不是同一层结果

会外的 root command 更像：

- 直接改配置或落盘物化

而会内的 `/plugin` 则是：

- 以当前会话 UI 操作这些插件包对象

两者都可能让磁盘状态变化，但都不自动等价于：

- 当前 session 已经换成新插件结果

### 所以“已经安装/启用”不等于“当前会话已经激活”

这就是为什么插件 UI、市场安装流和配置保存流里会不断提示：

- Run `/reload-plugins` to apply

这类提示本身已经说明：

- 磁盘变化
- 当前会话激活

在产品语义上本来就是两层。

## 第二层：`needsRefresh` 与 pending 状态是“待应用”，不是“已激活”

### `needsRefresh` 的含义是“当前 session 落后于磁盘状态”

`useManagePlugins` 的注释已经把这个设计说得很清楚：

- 插件状态在磁盘上变了
- 不自动刷新当前 session
- 只通知用户去跑 `/reload-plugins`

所以 `needsRefresh` 的更准确心智是：

- 当前 session 还没吃到最新 Layer-3 结果

而不是：

- “插件加载失败”或“插件尚未安装”

### UI 里的 pending toggles / update 标记也不是已激活结果

`ManagePlugins.tsx` 里有一整套：

- `pendingToggles`
- `pendingUpdate`
- 配置保存后待应用提示

这些状态的共同点都是：

- 插件包意图已经改变
- 但当前 session 还没切换到新的激活结果

因此 userbook 更稳的写法应是：

- pending 状态描述的是“待应用到当前 session”

而不是：

- “插件已经完成刷新”

## 第三层：`/reload-plugins` 是 Layer-3 refresh，不是安装流程

### 命令本体已经把它定义成“当前 session 刷新”

`/reload-plugins` 的命令定义写得很直接：

- Activate pending plugin changes in the current session
- 这是一条 `local` 命令
- `supportsNonInteractive: false`

它的对象不是：

- 安装 marketplace
- 下载插件包
- 改用户长期配置

而是：

- 把 pending plugin changes 应用到正在运行的当前 session

### `refreshActivePlugins()` 真正做的是 Layer-3 swap

`refresh.ts` 对这条能力的定义更明确：

- Layer 1: intent
- Layer 2: materialization
- Layer 3: active components

`/reload-plugins` 调到的 `refreshActivePlugins()` 负责的是：

- 清缓存
- 重新加载 plugin commands
- 重新加载 agent definitions
- 重新加载 plugin hooks
- 重新填充 plugin MCP / LSP 结果
- bump `pluginReconnectKey`
- 把 `needsRefresh` 消费掉

这说明 `/reload-plugins` 的真实语义是：

- 当前 session 的激活层换栈

而不是：

- 一条重新安装插件的命令

## 第四层：自动刷新只在特定路径出现，交互主线并不自动刷新

### 交互主线故意不自动刷新

`useManagePlugins` 的设计已经很明确：

- 磁盘状态变了，只发通知
- 不自动刷新
- 统一要求用户显式运行 `/reload-plugins`

这是一个刻意的产品选择，不是遗漏。

更稳的写法应是：

- 在交互 REPL 里，当前 session 是否刷新，由用户显式决定

### 自动刷新主要出现在 headless 与后台安装路径

源码里自动走 `refreshActivePlugins()` 的主要是：

- headless / print 路径
- background marketplace install 成功后

这说明：

- 自动刷新不是默认会内交互主线
- 而是某些宿主或后台流程为了保持一致性而走的特例

### 所以“系统有时会自动好、有时要手动跑 `/reload-plugins`”不是矛盾

这只是说明不同宿主的刷新策略不同：

- 交互主线：通知你手动刷新
- 某些 headless / auto-install 路径：系统代你刷新

## 第五层：SDK 不把 `/reload-plugins` 当文本命令，而当控制请求

### SDK 宿主走的是 `reload_plugins` control request

`/reload-plugins` 的命令定义里已经明确写了：

- SDK callers 不走文本 prompt
- 而是走 `query.reloadPlugins()`

`controlSchemas.ts` 也专门为它定义了：

- `reload_plugins` request
- 返回结构化的 commands / agents / plugins 等结果

这意味着：

- SDK 视角里的 plugin refresh
- REPL 视角里的 slash command refresh

是同一语义、不同宿主接口。

### 所以 `/reload-plugins` 不是“只能在会内手打”的唯一入口

更准确的写法是：

- 对人类用户，它是 slash command
- 对 SDK 宿主，它是控制面请求

这再次说明它的本质是：

- session refresh primitive

而不是：

- 一条普通的用户文本工作流命令

## 第六层：remote / CCR 路径下，刷新前还可能先重拉用户设置

### remote 模式下 `/reload-plugins` 有一个额外前置动作

`reload-plugins.ts` 里写得很明确：

- 当 `CLAUDE_CODE_REMOTE` 或 remote mode 打开
- 且相关 feature 开启
- 会先 `redownloadUserSettings()`

它这样做的目的不是改 `/reload-plugins` 的本质，而是：

- 让当前远端 session 先同步到最新 user settings
- 再做 Layer-3 refresh

### 所以 remote 模式下的刷新是“两步走”

1. 先让意图层更接近最新远端设置。
2. 再刷新当前 session 的激活层。

这属于非常重要但不宜过度泛化的边界：

- 对普通用户可以写成“remote 模式下刷新前可能先同步设置”
- 不应把具体 settingsSync 细节写成永久稳定合同

## 第七层：`/reload-plugins` 刷新的结果面本来就是多对象，不只是 plugin 自己

### 它会刷新的是“插件带来的暴露结果”

命令返回值和 `refreshActivePlugins()` 都说明，它关心的不是：

- 只统计插件包数量

而是：

- skills / commands
- agents
- hooks
- plugin MCP servers
- plugin LSP servers

所以 `/reload-plugins` 的正确心智是：

- 刷新插件包对当前会话暴露出来的整组结果

而不是：

- “把 plugin 目录再扫一遍而已”

### 这也是为什么“插件、MCP、技能、Hooks 与 Agents 运维”专题里的几个面必须连着看

因为 `/reload-plugins` 的真正对象不是 `/plugin` 自己，而是：

- `/plugin` 改动之后
- `/skills` `/hooks` `/agents` `/mcp`

这些面最终会看到的新暴露结果。

## 最容易误写的八件事

### 误写 1

“插件装好了，就说明当前会话已经吃到变更。”

更准确的写法：安装 / 启用只说明意图层或物化层变化，当前 session 还可能没激活。

### 误写 2

“`needsRefresh` 说明插件坏了或加载失败了。”

更准确的写法：它通常只说明磁盘状态变了，但当前 session 还没刷新。

### 误写 3

“`/reload-plugins` 是插件安装器。”

更准确的写法：它是当前 session 的 Layer-3 refresh。

### 误写 4

“交互模式里插件变化会自动刷新，不需要用户介入。”

更准确的写法：交互主线故意只通知，不自动刷新。

### 误写 5

“headless / SDK 路径和 REPL 的刷新语义完全一样。”

更准确的写法：语义一致，但入口和自动化程度不同。

### 误写 6

“`/reload-plugins` 只影响 plugin 自己，不影响 skills / agents / hooks / MCP。”

更准确的写法：它刷新的就是插件带来的整组暴露结果。

### 误写 7

“remote 模式下 `/reload-plugins` 只是普通本地刷新。”

更准确的写法：在某些 remote 条件下，它还可能先同步用户设置。

### 误写 8

“UI 里出现 Run `/reload-plugins` to apply，只是提示文案，不代表对象层级差异。”

更准确的写法：反复出现这句文案，正说明‘配置变化’和‘当前会话激活’本来就是两层。

## 稳定事实与降级写法

### 可以写成稳定 userbook 事实的

- 插件至少有意图、物化、当前会话激活三层状态
- `/reload-plugins` 是当前 session 的 refresh primitive，不是安装器
- 交互主线不会自动刷新，只会提示用户手动运行 `/reload-plugins`
- `/reload-plugins` 刷新的不是插件包本身，而是插件带来的 commands / agents / hooks / plugin MCP / LSP 结果
- SDK 与 REPL 在语义上共享这条刷新能力，但入口不同

### 应降级为实现细节或维护记忆的

- 哪些缓存会被 clear
- `pluginReconnectKey` 的具体用途
- remote 模式下 settingsSync 的精确触发条件
- background install、seed marketplace、zip cache 的内部时序

这些都适合作为源码证据，但不应写成长期稳定产品承诺。

## 源码锚点

- `claude-code-source-code/src/commands/reload-plugins/index.ts`
- `claude-code-source-code/src/commands/reload-plugins/reload-plugins.ts`
- `claude-code-source-code/src/utils/plugins/refresh.ts`
- `claude-code-source-code/src/hooks/useManagePlugins.ts`
- `claude-code-source-code/src/commands/plugin/ManagePlugins.tsx`
- `claude-code-source-code/src/commands/plugin/BrowseMarketplace.tsx`
- `claude-code-source-code/src/QueryEngine.ts`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts`
- `claude-code-source-code/src/services/plugins/PluginInstallationManager.ts`
- `claude-code-source-code/src/utils/plugins/performStartupChecks.tsx`
