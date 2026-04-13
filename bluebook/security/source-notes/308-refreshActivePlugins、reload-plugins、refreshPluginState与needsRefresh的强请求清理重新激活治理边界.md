# refreshActivePlugins、reload-plugins、refreshPluginState与needsRefresh的强请求清理重新激活治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `457` 时，
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
| Layer-3 reactivation primitive | `src/utils/plugins/refresh.ts:1-17,59-79,123-145` | 为什么 active world swap 是单独主权，不是 config save 的自然尾气 |
| user-initiated take-effect contract | `src/commands/reload-plugins/reload-plugins.ts:10-56` | 为什么 `/reload-plugins` 是正式 reactivation command，而不是多余包装 |
| scenario-sensitive activation policy | `src/services/plugins/PluginInstallationManager.ts:52-59,135-180` | 为什么 new install 与 update 不共享同一 reactivation rule |
| interactive no-auto-refresh discipline | `src/hooks/useManagePlugins.ts:287-303` | 为什么 stale active world 只被显化，不被偷偷自动接管 |
| UI split between saved and applied | `src/commands/plugin/ManagePlugins.tsx:1645-1707` | 为什么 `saved` 与 `take effect` 是不同事实 |
| headless auto-consume path | `src/cli/print.ts:1749-1769,3071-3080`; `src/state/AppStateStore.ts:209-215` | 为什么 headless mode 可自动 reactivation，而 interactive mode 不行 |

## 4. `ManagePlugins` 先证明：`Configuration saved` 与 `take effect` 被明确写成两层事实

`ManagePlugins.tsx:1645-1707`
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

`refresh.ts:1-17`
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

这已经不是“重读一下配置”而已。
它是完整的 active-world reactivation choreography。

Claude Code 在这里展示的先进性是：

`它没有把“磁盘上的 current truth 已更新”偷写成“running session 当然也已经更新”，而是给 active takeover 留下了单独 primitive、单独回执与单独 side-effect choreography。`

## 6. `/reload-plugins` 再证明：reactivation 可以是一个单独的用户命令主权

`reload-plugins.ts:10-56`
很硬。

这里一起明确做了四件事情：

1. remote mode 下先 `redownloadUserSettings()`
2. 必要时 `settingsChangeDetector.notifyChange('userSettings')`
3. 显式调用 `refreshActivePlugins()`
4. 最终返回 `Reloaded: ...` 的 Layer-3 summary

这里最重要的事实不是 command 存在，
而是它的 contract 被明确写成：

`take effect`

与

`Reloaded`

也就是说 repo 明确承认：

1. settings truth 可以先改
2. active truth 还没跟上
3. 必须再走一次显式 command 才能接管当前世界

而且它采取的是 `one attempt + fail-open` 语法，
允许用户重试。
这说明 Claude Code 这里追求的不是“绝不打断用户的自动魔法”，
而是“让 takeover 动作保持可见、可理解、可重试”。

## 7. `useManagePlugins` 与 `PluginInstallationManager` 一起证明：同一 persisted truth，在不同 mode / scenario 下可被分配不同接管策略

`useManagePlugins.ts:287-303`
价值非常高。

这里只做两件事情：

1. 当 `needsRefresh` 为真时发通知：`Plugins changed. Run /reload-plugins to activate.`
2. 明确写注释：`Do NOT auto-refresh. Do NOT reset needsRefresh`

也就是说，
在 interactive mode 下，
repo 明确允许一种中间状态存在：

`current truth has changed, active world is stale`

而
`PluginInstallationManager.ts:52-59,135-180`
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

`print.ts:1749-1769`
很值钱。

这里写得很清楚：

1. `refreshPluginState()` 是 headless-specific wrapper
2. 它显式调用 `refreshActivePlugins()`
3. 然后刷新 `currentCommands/currentAgents`

而
`print.ts:3071-3080`
又在 control-request reload 路径上继续做：

1. 先 re-pull user settings
2. 再 `refreshActivePlugins(setAppState)`

更关键的是
`AppStateStore.ts:209-215`
直接把制度压成一句：

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
Claude Code 在这层真正先进的地方至少有五点：

1. 它把 `saved`、`stale`、`activate`、`reloaded` 拆成不同词法层
2. 它给 active-world swap 单独分配了 Layer-3 primitive
3. 它让不同模式拥有不同 takeover policy
4. 它允许 fail-open / fallback，而不把一次失败偷偷伪装成已经接管
5. 它把 stale state 作为正式治理信号，而不是静默兼容期

这说明 repo 的安全设计不是：

`一旦 current truth 被写进磁盘，剩下的世界自然就会跟上。`

而是：

`truth 的声明、truth 的保存、truth 的接管、truth 的可用，都是不同层次的制度问题。`

## 10. 这篇源码剖面给主线带来的六条技术启示

1. repo 已经在 `take effect` 句法上明确展示：`persisted truth` 需要独立于 `active truth` 被治理。
2. repo 已经在 `refreshActivePlugins()` 上明确展示：active-world swap 必须被单独命名，而不是当作 save 的尾气。
3. repo 已经在 `needsRefresh` 上明确展示：stale signal 本身是一种治理事实，而不是纯 UX 文案。
4. repo 已经在 install / update / headless 三种路径上明确展示：同一 truth change 可以有不同 reactivation policy。
5. repo 已经在 `/reload-plugins` 上明确展示：reactivation 可以是一个单独的用户命令主权，而不是隐藏实现细节。
6. stronger-request cleanup 如果未来要长出 reactivation-governor plane，关键不只是“truth 已写入”，而是“谁在什么时候、以什么 mode policy 宣布 stale world 被 current truth 接管”。

## 11. 苏格拉底式自反诘问：我是不是又把“配置已经保存”误认成了“当前运行世界已经接管了这组 truth”

如果对这组代码做更严格的自我审查，
至少要追问六句：

1. 如果 reconfiguration grammar 已经足够强，为什么还要再拆 reactivation？
   因为 config truth 已闭合，不等于 running session 已按它工作。
2. 如果配置已保存，是不是就说明当前 active world 已替换？
   不是。saved 与 active swap 在 repo 里被显式拆开。
3. 如果用户已经看见 `Enabled and configured`，是不是就说明新 truth 已经 live？
   不是。UI 同时保留了 `Run /reload-plugins to apply.` 这条更强 gate。
4. 如果同一 truth change 在某些路径下会 auto-refresh，是不是就说明所有路径都该自动？
   不是。reactivation policy 本来就按 mode 与 scenario 分配。
5. 如果 headless 会自动 consume，是不是就说明 interactive 也该自动？
   不是。headless 与 interactive 的风险、时机和用户心智不同。
6. 如果 cleanup 线现在还没有显式 reactivation 代码，是不是说明这层还不值得写？
   恰恰相反。越是缺这层明确 grammar，越容易把“truth 已写好”偷写成“world 已换好”。

这一串反问最终逼出一句更稳的判断：

`reactivation 的关键，不在系统会不会让新 truth 最终生效，而在系统能不能正式决定它何时、以什么方式、在什么模式下接管当前运行世界。`

## 12. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 未来只要补出 reconfiguration governance，就已经足够成熟。`

而是：

`Claude Code 在 Layer-3 refresh primitive、interactive stale-signal discipline、scenario-sensitive activation policy 与 headless auto-consume path 上已经明确展示了 reactivation governance 的存在；因此 artifact-family cleanup stronger-request cleanup-reconfiguration-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-reactivation-governor signer。`

再压成一句：

`cleanup 线真正缺的不是“现在该按哪组 truth 工作”，而是“这组 truth 何时真正接管当前世界”。`
