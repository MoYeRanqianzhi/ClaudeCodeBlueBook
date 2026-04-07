# refreshActivePlugins、reload-plugins与refreshPluginState的强请求清理重新激活治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `298` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 旧对象回来后应按哪组 current config truth 重新工作，`

而是：

`stronger-request cleanup 旧对象即便已经有了 current config truth，谁来决定这组 truth 何时真正接管 running session。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`reconfiguration governor 不等于 reactivation governor。`

这句话还不够硬。
所以这里单开一篇，
只盯住：

- `src/utils/plugins/refresh.ts`
- `src/commands/reload-plugins/index.ts`
- `src/commands/reload-plugins/reload-plugins.ts`
- `src/services/plugins/PluginInstallationManager.ts`
- `src/hooks/useManagePlugins.ts`
- `src/commands/plugin/ManagePlugins.tsx`
- `src/cli/print.ts`
- `src/state/AppStateStore.ts`

把 Layer-3 refresh primitive、interactive `needsRefresh`、background auto-refresh / manual-refresh split、headless auto-consume 与 `take effect` 句法并排，
直接钉死 stronger-request cleanup 线当前仍缺的不是 config truth 本身，
而是 `active-world takeover grammar`。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 reconfiguration，没有 reactivation。`

而是：

`Claude Code 在 plugin 线已经明确把“当前配置真相是什么”和“这组真相何时真正接管 running session”拆成两层；stronger-request cleanup 线当前缺的不是这种文化，而是这套 reactivation governance 还没被正式接到旧 cleanup artifact family 上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| Layer-3 reactivation primitive | `src/utils/plugins/refresh.ts:1-18,59-160` | 为什么 active world swap 是单独主权，不是 config save 的自然尾气 |
| user-initiated take-effect contract | `src/commands/reload-plugins/index.ts:1-16`; `src/commands/reload-plugins/reload-plugins.ts:1-56` | 为什么 `/reload-plugins` 是正式 reactivation command，而不是多余包装 |
| scenario-sensitive activation policy | `src/services/plugins/PluginInstallationManager.ts:52-60,123-180` | 为什么 new install 与 update 不共享同一 reactivation rule |
| interactive no-auto-refresh discipline | `src/hooks/useManagePlugins.ts:287-303` | 为什么 stale active world 只被显化，不被偷偷自动接管 |
| UI split between saved and applied | `src/commands/plugin/ManagePlugins.tsx:1631-1707` | 为什么 `saved` 与 `take effect` 是不同事实 |
| headless auto-consume path | `src/cli/print.ts:1733-1765,1881-1912`; `src/state/AppStateStore.ts:206-214` | 为什么 headless mode 可自动 reactivation，而 interactive mode 不行 |

## 4. `ManagePlugins` 先证明：`Configuration saved` 与 `take effect` 被明确写成两层事实

`src/commands/plugin/ManagePlugins.tsx:1631-1707`
很硬。

这段代码至少并列暴露了三种不同句法：

1. `Enabled and configured ... Run /reload-plugins to apply.`
2. `Enabled ... Run /reload-plugins to apply.`
3. `Configuration saved. Run /reload-plugins for changes to take effect.`

这说明 repo 公开承认：

1. enable truth
2. config truth
3. active-world effect truth

不是同一层。

这里最值钱的不是提示语存在，
而是提示语拒绝偷写 stronger claim。

它没有说：

`Configuration saved and activated`

而是明确说：

`for changes to take effect`

这是一种非常克制、也非常成熟的安全设计：

`只承认已经写入的 truth，不冒领尚未接管的 truth。`

## 5. `refreshActivePlugins()` 再证明：current active world 的接管不是顺手刷新，而是单独 Layer-3 choreography

`src/utils/plugins/refresh.ts:1-18`
第一行就把自己的角色写死：

`Layer-3 refresh primitive: swap active plugin components in the running session.`

这不是普通 helper 名字。
它已经在架构层回答了：

`谁负责把 persisted truth 带进当前运行世界。`

更关键的是它的工作内容并不是“再读一遍配置”：

1. 清全部 plugin caches
2. 清 orphan exclusions
3. 重新 `loadAllPlugins()`
4. 重建 commands / agents
5. 预热 MCP / LSP cache slot
6. 写回 `AppState.plugins`
7. 清空 `needsRefresh`
8. bump `mcp.pluginReconnectKey`
9. `reinitializeLspServerManager()`
10. `loadPluginHooks()`

这已经不是“重读一下配置”而已。
它是完整的 active-world reactivation choreography。

Claude Code 在这里展示的先进性是：

`它没有把“磁盘上的 current truth 已更新”偷写成“running session 当然也已经更新”，而是给 active takeover 留下了单独 primitive、单独回执与单独 side-effect choreography。`

## 6. `/reload-plugins` 再证明：reactivation 可以是一个单独的用户命令主权

`reload-plugins.ts` 与 `index.ts`
很硬。

这两处一起明确做了四件事：

1. 文档层把命令写成
   `Layer-3 refresh. Applies pending plugin changes to the running session`
2. 运行层显式调用 `refreshActivePlugins()`
3. 最终返回 `Reloaded: ...` 的 Layer-3 summary
4. remote mode 下先 `redownloadUserSettings()`，
   再用 `settingsChangeDetector.notifyChange('userSettings')`
   让 mid-session truth 先重新到位

这里最重要的事实不是 command 存在，
而是它的 contract 被明确写成：

`activate` / `Reloaded`

也就是说 repo 明确承认：

1. settings truth 可以先改
2. active truth 还没跟上
3. 必须再走一次显式 command 才能接管当前世界

而且它采取的是
`one attempt + fail-open`
语法，
允许用户重试。
这说明 Claude Code 这里追求的不是“绝不打断用户的自动魔法”，
而是“让 takeover 动作保持可见、可理解、可重试”。 

## 7. `useManagePlugins` 与 `PluginInstallationManager` 一起证明：同一 persisted truth，在不同 mode / scenario 下可被分配不同接管策略

`src/hooks/useManagePlugins.ts:287-303`
价值非常高。

这里只做两件事情：

1. 当 `needsRefresh` 为真时发通知：
   `Plugins changed. Run /reload-plugins to activate.`
2. 明确写注释：
   `Do NOT auto-refresh. Do NOT reset needsRefresh`

也就是说，
在 interactive mode 下，
repo 明确允许一种中间状态存在：

`current truth has changed, active world is stale`

而
`src/services/plugins/PluginInstallationManager.ts:123-180`
又把制度写得很清楚：

1. `new installs -> auto-refresh plugins`
2. `updates only -> set needsRefresh`
3. 如果 auto-refresh 失败，再 fallback 到 `needsRefresh`

这说明 repo 已经公开承认：

`reactivation policy is scenario-sensitive`

也就是说，
即便底层都属于 plugin state changed on disk，
系统仍继续问：

1. 这次是新安装还是更新
2. 现在更该自动接管，还是更该等待用户显式确认时机
3. 自动路径失败后怎样安全降级

这套设计的技术启示很直接：

`允许自动化，不等于放弃治理；真正先进的是把自动化也纳入显式制度，而不是让自动化偷偷取代制度。`

## 8. `print.ts` 与 `AppStateStore` 给出第三个强正例：headless mode 的 reactivation governance 可以与 interactive mode 完全不同

`src/cli/print.ts:1733-1765,1881-1912`
很值钱。

这里写得很清楚：

1. `CLAUDE_CODE_SYNC_PLUGIN_INSTALL=true` 时，
   installation 会在 first ask 前 resolve
2. resolve 后显式调用 `refreshPluginState()`
3. `refreshPluginState()` 再显式调用 `refreshActivePlugins()`
4. 注释直接写出：
   `plugins are guaranteed available on the first ask()`

而
`src/state/AppStateStore.ts:206-214`
更直接把制度压成一句：

`interactive mode, user runs /reload-plugins to consume; headless mode, refreshPluginState() auto-consumes via refreshActivePlugins()`

这等于直接证明：

1. same Layer-3 primitive
2. different operational context
3. different activation authority

这不是不一致，
恰恰是成熟治理：

`同一 takeover primitive，可以被不同 mode 的 governor 以不同 policy 消费。`

## 9. 更深一层的技术先进性：Claude Code 连“知道 truth 已变”与“宣布 world 已换”都继续拆开

如果把这组源码放在一起看，
Claude Code 在这层真正先进的地方至少有四点：

1. 它把 `saved`、`stale`、`activate`、`reloaded` 拆成不同词法层
2. 它给 active-world swap 单独分配了 Layer-3 primitive
3. 它让不同模式拥有不同 takeover policy
4. 它允许 fail-open / fallback，而不把一次失败偷偷伪装成已经接管

这说明 repo 的安全设计不是：

`尽量少给用户看到中间态`

而是：

`让每个中间态都只说到自己有权说的那一句。`

## 10. 苏格拉底式自我反思：如果我要把这层边界看得更准，最该防什么

第一问：

`我是不是把 save path 误判成了 activate path？`

如果是，
`ManagePlugins` 的文案已经直接反驳我。

第二问：

我是不是把 `needsRefresh` 误判成了 refreshed？

如果是，
`useManagePlugins` 的 notification-only policy 已经直接反驳我。

第三问：

`我是不是把 Layer-3 refresh primitive 看成普通 helper，而不是治理动作？`

如果是，
`refresh.ts` 文件头注释已经把这条误判直接封死。

第四问：

`我是不是又把 headless、interactive 与 background 压成一个统一规则了？`

如果是，
`PluginInstallationManager`、`print.ts` 与 `AppStateStore.ts` 的并排证据已经说明这是错的。

第五问：

`我是不是在 reactivation 层又偷偷带入了 readiness / continuity / recovery 的 stronger judgment？`

如果是，
我就需要立刻收手。
因为这一层最硬的纪律就是：

`只证明“这组 truth 是否接管了当前世界”，不越级证明“接管之后一切后续状态都已经被回答”。`
