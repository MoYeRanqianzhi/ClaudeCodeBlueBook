# savePluginOptions、saveMcpServerUserConfig与PluginOptionsFlow的强请求清理重配置治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `329` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 旧对象回来后还配不配占原来的 authority seat，`

而是：

`它即便重新占住了一张 current seat，谁来决定它现在应按哪组 options、哪组 secrets、哪组 payload 与哪组 channel config 重新工作。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`re-entitlement governor 不等于 reconfiguration governor。`

这句话还不够硬。
所以这里单开一篇，
只盯住：

- `src/utils/plugins/pluginOptionsStorage.ts`
- `src/utils/plugins/mcpbHandler.ts`
- `src/utils/plugins/mcpPluginIntegration.ts`
- `src/commands/plugin/PluginOptionsFlow.tsx`
- `src/commands/plugin/ManagePlugins.tsx`

把 split-save、missing-config、`needs-config`、`configured / skipped` 与 `take effect` grammar 并排，
直接钉死 stronger-request cleanup 线当前仍缺的不是 comeback seat，
而是 `current config truth governance`。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 re-entitlement，没有 reconfiguration。`

而是：

`Claude Code 在 plugin 线已经明确把“对象重新拿到 seat”和“对象当前按哪组 config truth 重新工作”拆成两层；stronger-request cleanup 线当前缺的不是这种治理文化，而是这套 reconfiguration grammar 还没有被正式接到旧 cleanup carrier family 上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| top-level option source truth | `src/utils/plugins/pluginOptionsStorage.ts:90-193` | 为什么 option truth 要按 sensitive / non-sensitive split-save，而不是随 returned seat 自动继承 |
| top-level config closure | `src/utils/plugins/pluginOptionsStorage.ts:282-309` | 为什么对象可以已经存在，但 schema 仍判它 unconfigured |
| per-server payload source truth | `src/utils/plugins/mcpbHandler.ts:141-339` | 为什么 server / channel payload 也有单独的 split-save、scrub 与 secure-first grammar |
| formal `needs-config` state | `src/utils/plugins/mcpbHandler.ts:742-757,894-902` | 为什么 forced reconfigure / validation failed 不被偷写成 ready truth |
| per-channel missing-config discovery | `src/utils/plugins/mcpPluginIntegration.ts:290-317` | 为什么 channel completeness 是单独 decision surface |
| flow-level closure grammar | `src/commands/plugin/PluginOptionsFlow.tsx:53-133` | 为什么 `configured` 与 `skipped` 是两个正式 outcome |
| UI-level apply grammar | `src/commands/plugin/ManagePlugins.tsx:1645-1668,1700-1707` | 为什么 `Enabled`、`Enabled and configured` 与 `Configuration saved` 是三种不同事实 |

## 4. `savePluginOptions()` 先证明：top-level options 不是 authority seat 的尾气，而是单独的 current source truth

`savePluginOptions():90-193`
最值钱的地方不是“能把值写进去”，
而是它明确拒绝以下偷换：

`seat 回来了 -> option truth 自然也回来了`

这段代码至少同时治理四个问题：

1. `sensitive` key 必须进 `secureStorage`
2. `non-sensitive` key 进入 `settings.pluginConfigs[pluginId].options`
3. 本次 save 已迁到另一侧的 key 必须从旧侧 scrub 掉
4. partial reconfigure 不能因为一次局部 save 就把其他字段误删

这里最先进的设计不是“秘密分仓”，
而是：

`双侧 current truth 如何保持不自相矛盾。`

尤其
`secureStorage FIRST`
这一条非常关键。
它不是普通实现顺序，
而是一种安全哲学声明：

`宁可暂时保留旧 fallback，也不要因为 keychain 失败把 current config truth 搞成双侧都不可信。`

## 5. `getUnconfiguredOptions()` 再证明：配置完整性是单独 decision surface

`getUnconfiguredOptions():282-309`
的价值经常被低估。

它并不只是一个 UI helper。
它本质上在做一件治理性的事情：

`判定 current seat 是否已经具备足够 config truth。`

这段代码先读当前保存值，
再跑 `validateUserConfig()`，
最后只把失败字段重新打包回 schema slice。

这说明 repo 清楚承认：

1. 对象已经存在
2. schema 仍可能不满足
3. 这不是异常，而是正式可被继续处理的状态

也就是说，在 Claude Code 里：

`configured`

不是对象存在的自然副产物，
而是一种需要被单独验证的 truth class。

## 6. `saveMcpServerUserConfig()` 把同一治理逻辑推进到 per-server / per-channel payload

`mcpbHandler.ts:141-339`
让这条线变得更硬。

`loadMcpServerUserConfig():141-162`
先把：

1. `settings.pluginConfigs[pluginId].mcpServers[serverName]`
2. `secureStorage.pluginSecrets[pluginId/serverName]`

合并成当前读取视图。

然后
`saveMcpServerUserConfig():193-339`
再明确规定：

1. sensitive / non-sensitive split
2. secure-first write order
3. schema flip 时的反向 scrub
4. partial reconfigure 的最小影响面

这说明 repo 并不把：

`channel / server config`

看成 top-level option 的附属细节。
它承认：

`不同 surface 的 payload truth 也需要独立治理。`

更强的是
`mcpbHandler.ts:742-757,894-902`
在两条路径上都明确返回：

`status: 'needs-config'`

而且同时带上：

1. `configSchema`
2. `existingConfig`
3. `validationErrors`

这等于直接证明：

`object visible`

和

`payload configuration ready`

不是同一件事。

## 7. `PluginOptionsFlow` 与 `ManagePlugins` 再证明：`seat`、`closure`、`apply` 是三层不同事实

`getUnconfiguredChannels():290-317`
很硬。
它对每个 channel：

1. 读取保存值
2. 跑 `validateUserConfig()`
3. 只要失败，就把该 channel 放进 `unconfigured` 列表

这使
`PluginOptionsFlow.tsx:53-133`
可以在 mount 时直接构造 step list：

1. top-level unconfigured options
2. per-channel unconfigured config

如果没有 step，
立刻 `onDone('skipped')`；
全部 step 完成后，
才 `onDone('configured')`。

这说明 flow 层对配置真相的理解，
不是：

`要么 enabled，要么 disabled`

而是至少三段：

1. object has seat
2. config truth unresolved
3. config truth closed

`ManagePlugins.tsx:1645-1668,1700-1707`
甚至把这套分层直接公开写成结果句法：

1. `Enabled and configured`
2. `Enabled`
3. `Configuration saved. Run /reload-plugins for changes to take effect.`

一旦这三句话同时存在，
整个 repo 就在公开承认：

1. `enabled != configured`
2. `configured != applied`
3. `saved != take effect`

## 8. 更深一层的技术先进性：Claude Code 连“当前配置来源”与“当前运行世界是否消费了它”都继续拆开

这组源码真正先进的地方，
并不只是“把 secret 藏进 secure storage”，
而是它在多个层面同时拒绝三种危险偷换：

1. `seat restored -> therefore config restored`
2. `config saved -> therefore config closed`
3. `config closed -> therefore runtime already uses it`

更具体地说，
它已经把下面几件事制度化：

1. `source truth` 必须有明确归属
2. `closure truth` 必须能被单独验证
3. `stale truth` 必须能被 scrub
4. `save truth` 与 `apply truth` 必须继续分层

这是一条非常成熟的设计思路：

`当前输入真相被持久化`

不等于

`当前运行世界已经在按这组真相工作`

## 9. 这篇源码剖面给主线带来的五条技术启示

### 启示一

repo 已经在 top-level option line 明确展示：

`current config truth`

需要独立于 authority seat 被治理。

### 启示二

repo 已经在 per-server / per-channel line 明确展示：

`payload truth`

也需要独立于 object seat 被治理。

### 启示三

repo 已经在 `needs-config` 上明确展示：

`visible`

并不等于

`ready`

### 启示四

repo 已经在 `configured / skipped` 上明确展示：

`config closure`

本身就是正式 outcome，
而不是 enabled truth 的附带尾气。

### 启示五

repo 已经在 `Configuration saved...take effect` 上明确展示：

`saved truth`

和

`applied truth`

也必须继续拆层。

## 10. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 只要补出 re-entitlement governance，就已经足够成熟。`

而是：

`Claude Code 在 split-save、needs-config、configured/skipped 与 save-vs-apply grammar 上已经明确展示了 reconfiguration governance 的存在；因此 artifact-family cleanup stronger-request cleanup-re-entitlement-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-reconfiguration-governor signer。`

再压成一句：

`cleanup 线真正缺的不是“谁来让旧对象重新占 seat”，而是“谁来决定它占住 seat 之后按哪组 current truth 继续工作”。`
