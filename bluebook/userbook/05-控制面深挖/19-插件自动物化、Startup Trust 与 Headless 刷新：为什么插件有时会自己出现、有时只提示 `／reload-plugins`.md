# 插件自动物化、Startup Trust 与 Headless 刷新：为什么插件有时会自己出现、有时只提示 `/reload-plugins`

## 用户目标

不是只知道 Claude Code “有时会自动装插件，有时会提示 `/reload-plugins`”，而是先看清四件事：

- 插件从 settings 意图变成磁盘物化，为什么在不同宿主里走不同路径。
- startup trust 为什么会拦住交互 REPL 的插件自动安装。
- background marketplace install、headless install、`CLAUDE_CODE_SYNC_PLUGIN_INSTALL` 为什么不是同一条刷新链。
- 为什么同样是“插件变了”，交互模式常常只提示待刷新，而 headless 路径却可能直接 refresh。

如果这四件事不先拆开，读者最容易把下面这些对象混成一锅“插件自动刷新”：

- `performStartupChecks()`
- `performBackgroundPluginInstallations()`
- `installPluginsForHeadless()`
- `refreshActivePlugins()`
- `needsRefresh`
- `CLAUDE_CODE_SYNC_PLUGIN_INSTALL`
- `CLAUDE_CODE_PLUGIN_SEED_DIR`
- workspace trust / Trust Dialog

## 第一性原理

插件从“用户希望它存在”变成“当前会话真的能用”，至少要经过四层：

1. 意图层：settings 声明插件和 marketplace。
2. 物化层：marketplace / plugin 被同步或安装到磁盘缓存。
3. 激活层：当前 session 的 active components 被刷新。
4. 暴露层：skills / hooks / agents / plugin MCP / LSP 真正出现在当前会话里。

不同宿主真正分歧的，不是“认不认插件”，而是：

- 哪一层允许自动前进
- 哪一层必须显式由用户确认

因此更稳的提问不是：

- “为什么这个环境里插件自己装好了，那个环境里却没生效？”

而是：

- 它卡在 startup trust、磁盘物化，还是当前 session 激活层？

只要不先分清这四层，就会把自动安装、自动刷新和手动 `/reload-plugins` 写成同一件事。

## 第一层：交互 REPL 的 startup plugin path 先过 trust，再做后台物化

### 交互 startup checks 不是无条件运行

`performStartupChecks()` 的注释写得很直接：

- 只有在 REPL 里
- 且当前工作区 trust 已被接受后
- 才会继续启动后台插件安装检查

这意味着交互 REPL 的插件自动物化首先受：

- workspace trust

控制。

所以 userbook 里更稳的写法应是：

- 未信任工作区时，交互 REPL 不会替你自动推进插件安装链

而不是：

- “启动后插件总会自动同步”

### trust 在这里卡的不是 UI，而是后台安装资格

这条边界很重要。

之前 trust/policy 页面更多解释的是：

- 为什么仓内扩展不能默认被信任

这里要再补一句：

- plugin startup checks 本身就是在 trust 通过后才启动的后台动作

所以 trust 不只是“你能不能执行项目 hooks / skills”，也会影响：

- 交互会话是否允许继续推进插件自动物化

## 第二层：seed marketplace 与 background install 推进的是“物化层”，不是当前会话激活层

### `registerSeedMarketplaces()` 先让种子市场进入已声明世界

无论交互 startup 还是 headless install，都会先尝试：

- `registerSeedMarketplaces()`

这一步解决的问题不是：

- 当前会话立刻可用

而是：

- 让种子 marketplace 先进入后续 diff / reconcile 能看见的 declared state

所以它本质上属于：

- 意图层与物化层之间的准备动作

### `performBackgroundPluginInstallations()` 主要推进 marketplace / plugin 的物化

这条后台路径做的关键事情是：

- 先对 declared 与 materialized marketplaces 做 diff
- 再后台 reconcile marketplace
- 根据安装或更新结果，决定是 auto-refresh 还是只标记 `needsRefresh`

所以它首先是：

- 后台物化链

而不是：

- 当前 session 的默认刷新链

### 因此“marketplace 装好了”仍不等于“当前会话已吃到变更”

这正是为什么 `performBackgroundPluginInstallations()` 会分成两条后续：

- 新安装：尝试 auto-refresh
- 仅更新：只标记 `needsRefresh`

这说明：

- 物化完成
- 当前会话已激活

在这条链里仍然是两步，不是一件事。

## 第三层：交互 REPL 与 headless 的自动行为不一样

### 交互 REPL 主线：尽量不偷偷换当前会话

在交互 REPL 里，设计偏向于：

- 先告诉你插件状态变了
- 再由你决定何时跑 `/reload-plugins`

这和上一轮 `/reload-plugins` 页面是一致的：

- 交互主线默认不自动做 Layer-3 swap

### 但 background install 对“新安装”会更激进一些

如果后台安装的是：

- 新 marketplace / 新 plugin

源码会尝试：

- 直接 `refreshActivePlugins()`

因为否则初始 cache-only load 很容易留下：

- plugin not found
- stale command / agent / MCP 结果

所以这条自动刷新更像：

- 为了修复启动期 race 和首轮可用性而开的自动补偿

而不是：

- 交互主线的一般规律

### 只有“更新已有 marketplace”时，才更倾向退回 `needsRefresh`

源码把“新装”和“更新”分开处理，本身就在表达一个产品判断：

- 新装更像“现在不用就会坏”
- 更新更像“你可以自己挑时机应用”

这是 userbook 很值得保留的一层心智。

## 第四层：headless / print 走的是另一条自动安装与刷新链

### `installPluginsForHeadless()` 是 headless 的物化器

这条路径的注释已经说得很清楚：

- 它是 headless / CCR 模式下的 plugin installation
- 不依赖交互 AppState UI
- 目标是让 headless 环境也能完成 marketplace / plugin 物化

所以它不是：

- 交互 REPL startup checks 的简化版

而是：

- 非交互宿主自己的安装器

### headless 路径会在需要时主动 refresh 当前会话引用

`print.ts` 里明确写了：

- `CLAUDE_CODE_SYNC_PLUGIN_INSTALL` 可以让安装在 first query 之前完成
- 完成后会调用 `refreshPluginState()`
- 它再进一步走 `refreshActivePlugins()`

这说明 headless 的设计目标是：

- 尽量在第一问前就把插件结果准备好

因此 headless 和交互 REPL 的差异可以直接写成：

- headless 更强调首问前可用
- 交互更强调当前用户何时接受刷新

### `CLAUDE_CODE_SYNC_PLUGIN_INSTALL` 不是另一个插件管理面，而是宿主时序开关

这点尤其容易误写。

它真正改变的是：

- 插件安装何时完成
- 是否在 first ask 之前等待
- setup 阶段是否跳过 plugin prefetch 以避免 race

所以更稳的写法应是：

- 同一插件链路在不同宿主里的时序策略开关

而不是：

- “又一种插件安装功能”

## 第五层：`needsRefresh` 不是物化失败，而是“自动链在这里停住了”

### `needsRefresh` 常常意味着“已经推进到磁盘，但没有继续自动激活”

交互 REPL、seed marketplace 变化、background update 等路径里，都会出现：

- 设 `needsRefresh: true`

这类写法的共同含义更接近：

- 自动链已经把某些状态推进到了磁盘或声明层
- 但当前 session 不再继续自动换栈

所以 userbook 更稳的写法应是：

- `needsRefresh` 主要是自动链中断在激活层之前的标志

而不是：

- “插件安装失败”

### 这也是为什么通知文案会统一导向 `/reload-plugins`

因为对产品来说，真正缺的不是：

- 再装一次

而是：

- 把当前 session 切换到新的 active components

## 第六层：自动链与手动链共享同一个 Layer-3 primitive

### `refreshActivePlugins()` 是共同底座

不管是：

- `/reload-plugins`
- background install 后自动 refresh
- headless / print 的 refreshPluginState

最终都围绕同一个核心 primitive：

- `refreshActivePlugins()`

这意味着 userbook 可以稳写：

- 自动刷新和手动刷新不是两套完全不同系统
- 它们只是对同一个 Layer-3 primitive 采用了不同触发策略

### 所以真正应区分的是“谁触发它”，不是“它是什么”

更准确的判断顺序应是：

1. 当前是交互 REPL、background install，还是 headless。
2. 当前是否已经通过 trust。
3. 当前链路只推进物化，还是也推进激活。
4. 若没推进激活，是否只留下 `needsRefresh` 等待用户。

## 最容易误写的八件事

### 误写 1

“启动后插件总会自动安装并自动生效。”

更准确的写法：交互 REPL 先受 trust 约束，且常常只推进到待刷新，不保证自动激活。

### 误写 2

“`performStartupChecks()` 就是 `/reload-plugins` 的后台版。”

更准确的写法：它更偏 startup trust + 后台物化入口，不是单纯的 Layer-3 refresh。

### 误写 3

“seed marketplace 一出现，当前会话就已经能用新插件了。”

更准确的写法：seed 更像声明/物化准备动作，当前 session 仍可能只被标记成 `needsRefresh`。

### 误写 4

“background install 成功后一定只会提示 `/reload-plugins`。”

更准确的写法：新安装可能会 auto-refresh，更新已有 marketplace 更可能退回 `needsRefresh`。

### 误写 5

“headless / print 和交互 REPL 的插件刷新策略一样。”

更准确的写法：headless 更强调首问前可用，交互更强调显式刷新。

### 误写 6

“`CLAUDE_CODE_SYNC_PLUGIN_INSTALL` 是又一条插件安装功能入口。”

更准确的写法：它主要是宿主时序开关。

### 误写 7

“`needsRefresh` 就表示插件坏了或 marketplace reconcile 失败。”

更准确的写法：很多时候它只是自动链停在激活层之前。

### 误写 8

“自动刷新和 `/reload-plugins` 是完全不同的内部机制。”

更准确的写法：它们共享同一个 Layer-3 refresh primitive，只是触发者不同。

## 稳定事实与降级写法

### 可以写成稳定 userbook 事实的

- 插件自动出现至少涉及 trust、物化、激活三层不同门
- 交互 REPL 的 startup plugin path 先过 trust
- seed / background install 主要推进物化层，不天然等于当前会话已激活
- headless 与交互 REPL 的自动刷新策略不同
- 自动刷新与手动 `/reload-plugins` 共享同一 Layer-3 refresh primitive

### 应降级为实现细节或维护记忆的

- seed marketplace 的具体覆写规则
- zip cache 模式与 unsupported source 的跳过条件
- `applyPluginMcpDiff()` 的内部行为
- `setup.ts` 如何跳过 plugin prefetch 以避免 race
- timeout 相关环境变量的精确语义

这些都适合作为源码证据，但不应写成长期稳定产品承诺。

## 源码锚点

- `claude-code-source-code/src/utils/plugins/performStartupChecks.tsx`
- `claude-code-source-code/src/services/plugins/PluginInstallationManager.ts`
- `claude-code-source-code/src/utils/plugins/headlessPluginInstall.ts`
- `claude-code-source-code/src/utils/plugins/refresh.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/hooks/useManagePlugins.ts`
- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/setup.ts`
