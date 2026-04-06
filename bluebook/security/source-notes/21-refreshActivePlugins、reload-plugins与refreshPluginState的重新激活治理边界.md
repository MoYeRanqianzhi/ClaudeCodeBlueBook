# refreshActivePlugins、reload-plugins 与 refreshPluginState 的重新激活治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `170` 时，
真正需要被单独钉住的已经不是：

`cleanup 线未来谁来决定旧对象按哪组 current config truth 重新工作，`

而是：

`cleanup 线即便已经知道当前 config truth 是什么，谁来决定这组 truth 何时真正接管 running session。`

如果这个问题只停在主线长文里，
最容易被压成一句抽象判断：

`reconfiguration governor 不等于 reactivation governor。`

这句话还不够硬。
所以这里单开一篇，只盯住：

- `src/utils/plugins/refresh.ts`
- `src/commands/reload-plugins/reload-plugins.ts`
- `src/services/plugins/PluginInstallationManager.ts`
- `src/hooks/useManagePlugins.ts`
- `src/commands/plugin/ManagePlugins.tsx`
- `src/cli/print.ts`
- `src/state/AppStateStore.ts`

把 Layer-3 refresh primitive、interactive `needsRefresh`、background auto-refresh、headless auto-consume 与 `take effect` 句法并排，
逼出一句更硬的结论：

`Claude Code 已经在 plugin 线上明确展示：persisted config truth 并不自动回答它何时成为 current active world；cleanup 线当前缺的不是这种思想，而是这套 reactivation governance 还没被正式接到旧 path、旧 promise 与旧 receipt 世界上。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 reconfiguration，没有 reactivation。`

而是：

`Claude Code 在 plugin 线已经明确把“当前配置真相是什么”和“这组真相何时真正接管 running session”拆成两层；cleanup 线当前缺的不是文化，而是这套 reactivation governance 还没被正式接到旧 cleanup artifact family 上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| Layer-3 reactivation primitive | `src/utils/plugins/refresh.ts:1-177` | 为什么 active world swap 是单独主权，不是 config save 的自然尾气 |
| user-initiated take-effect contract | `src/commands/reload-plugins/reload-plugins.ts:10-56` | 为什么 `/reload-plugins` 是正式 reactivation command，而不是多余包装 |
| scenario-sensitive activation policy | `src/services/plugins/PluginInstallationManager.ts:50-180` | 为什么 new install 与 update 不共享同一 reactivation rule |
| interactive no-auto-refresh discipline | `src/hooks/useManagePlugins.ts:25-35,287-303` | 为什么 stale active world 只被显化，不被偷偷自动接管 |
| UI split between saved and applied | `src/commands/plugin/ManagePlugins.tsx:1645-1668,1700-1707` | 为什么 `saved` 与 `take effect` 是不同事实 |
| headless auto-consume path | `src/cli/print.ts:1733-1765,1881-1910`; `src/state/AppStateStore.ts:209-214` | 为什么 headless mode 可自动 reactivation，而 interactive mode 不行 |

## 4. `refreshActivePlugins()` 先证明：current active world 的接管不是顺手刷新，而是单独 Layer-3 choreography

`refresh.ts:1-177` 第一行就把自己的角色写死：

`Layer-3 refresh primitive: swap active plugin components in the running session.`

这不是普通 helper 名字。
它已经在架构层回答了：

`谁负责把 persisted truth 带进当前运行世界。`

更关键的是它的工作内容并不是“再读一遍配置”：

1. 清全部 plugin caches
2. 清 orphan exclusions
3. 重新 load plugins
4. 重建 commands / agents
5. 预热 MCP / LSP cache slot
6. 写回 `AppState.plugins`
7. 复位 `needsRefresh`
8. bump `pluginReconnectKey`
9. 重新初始化 LSP manager
10. 重载 hooks

这说明 repo 对 reactivation 的理解不是：

`current config truth 已经对，所以 active world 自然跟上。`

而是：

`active world 必须被显式接管。`

从 cleanup 研究角度看，
这给出的启示不是“以后也去写个 refresh 函数”，
而是：

`一旦 restored cleanup truth 需要从 persisted world 进入 running world，谁来 orchestrate full swap，本身就是 reactivation governance。`

## 5. `/reload-plugins` 再证明：reactivation 可以是一个单独的用户命令主权

`reload-plugins.ts:10-56` 很硬。

这段代码明确做了三件事：

1. 在某些远端模式下先重拉 user settings，让 pushed settings `take effect`
2. 再显式调用 `refreshActivePlugins()`
3. 最终返回 `Reloaded: ...` 的 Layer-3 summary

这里最重要的事实不是 command 存在，
而是它的 contract 被明确写成：

`take effect`

也就是说 repo 明确承认：

1. settings truth 可以先改
2. active truth 还没跟上
3. 必须再走一次显式 command 才能接管当前世界

这等于直接证明：

`reconfiguration`

和

`reactivation`

不是同一层。

## 6. `useManagePlugins` 与 `ManagePlugins` 一起证明：interactive mode 里，“stale” 和 “reactivated” 是两种不同状态

`useManagePlugins.ts:287-303` 价值非常高。

这里只做两件事情：

1. 当 `needsRefresh` 为真时发通知：`Plugins changed. Run /reload-plugins to activate.`
2. 明确写注释：`Do NOT auto-refresh. Do NOT reset needsRefresh`

也就是说，在 interactive mode 下，
repo 明确允许一种中间状态存在：

`current truth has changed, active world is stale`

而 `ManagePlugins.tsx:1645-1668,1700-1707` 又把同样的事实翻成用户句法：

1. `✓ Enabled and configured ... Run /reload-plugins to apply.`
2. `Configuration saved. Run /reload-plugins for changes to take effect.`

这说明 interactive 设计的先进性不在于“更自动”，
而在于：

`更诚实地承认 stale active world 可以暂时存在。`

它宁可让用户看见：

`saved but not yet active`

也不愿意偷偷替用户签一份 stronger claim：

`already reactivated`

## 7. `PluginInstallationManager` 给出第二组正例：同一种插件变化，repo 也会按场景分配不同 reactivation policy

`PluginInstallationManager.ts:50-180` 把制度写得很清楚：

1. `New installs -> auto-refresh plugins`
2. `Updates only -> set needsRefresh, show notification for /reload-plugins`
3. 如果 auto-refresh 失败，再 fallback 到 `needsRefresh`

这说明 repo 已经公开承认：

`reactivation policy is scenario-sensitive`

也就是说，
即便底层都属于 plugin state changed on disk，
系统仍继续问：

1. 这次是新安装还是更新
2. 现在更该自动接管，还是更该等待用户显式确认时机
3. 自动路径失败后如何降级到手动路径

这对 cleanup 线的技术启示非常强：
将来即便 restored cleanup truth 已经被重新配置，
也仍不自动说明：

`所有场景都该立刻自动 reactivation。`

## 8. `print.ts` 与 `AppStateStore` 给出第三个强正例：headless mode 的 reactivation governance 可以与 interactive mode 完全不同

`print.ts:1733-1765,1881-1910` 很值钱。

这里写得很清楚：

1. `CLAUDE_CODE_SYNC_PLUGIN_INSTALL=true` 时，installation 会在 first ask 前 resolve
2. resolve 后显式调用 `refreshPluginState()`
3. `refreshPluginState()` 再显式调用 `refreshActivePlugins()`
4. 注释直接写出：`before the first ask()` / `guaranteed available on the first ask()`

而 `AppStateStore.ts:209-214` 更直接把制度压成一句：

`interactive mode, user runs /reload-plugins to consume. In headless mode, refreshPluginState() auto-consumes via refreshActivePlugins().`

这等于直接证明：

1. same Layer-3 primitive
2. different trigger authority

这不是实现偶然，
而是正式的治理分配。

从第一性原理看，这条证据特别值钱。
它说明 reactivation 的本体不是某个固定按钮，
而是：

`谁配在当前 mode 下宣布 stale world 该被 current world 接管。`

## 9. 这篇源码剖面给主线带来的四条技术启示

### 启示一

repo 已经在 Layer-3 grammar 上明确展示：

`config truth != active world`

### 启示二

repo 已经在 interactive mode 上明确展示：

`stale notification != reactivation`

### 启示三

repo 已经在 background reconcile 上明确展示：

`same disk change != same activation policy`

### 启示四

repo 已经在 headless mode 上明确展示：

`same refresh primitive != same trigger authority`

这四句合起来，
正好说明为什么 cleanup 线未来不能把 reconfiguration governance 直接偷写成 complete reactivation。

## 10. 一条硬结论

这组源码真正说明的不是：

`cleanup 线未来只要补出 reconfiguration governance，就已经足够成熟。`

而是：

`repo 在 refreshActivePlugins、/reload-plugins、needsRefresh、mode-sensitive auto-refresh 与 headless auto-consume 路径上已经明确展示了 reactivation governance 的存在；因此 artifact-family cleanup reconfiguration-governor signer 仍不能越级冒充 artifact-family cleanup reactivation-governor signer。`

因此：

`cleanup 线真正缺的不是“谁来改写 current config truth”，而是“谁来决定这组 truth 何时真正接管当前运行世界”。`
