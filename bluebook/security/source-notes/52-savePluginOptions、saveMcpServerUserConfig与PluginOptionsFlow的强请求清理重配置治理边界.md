# savePluginOptions、saveMcpServerUserConfig与PluginOptionsFlow的强请求清理重配置治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `201` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 旧对象回来后还拿不拿得回 seat，`

而是：

`stronger-request cleanup 旧对象即便重新拿回了 seat，谁来决定它现在应按哪组 options、哪组 secrets、哪组 channel config 重新工作。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`re-entitlement governor 不等于 reconfiguration governor。`

这句话还不够硬。
所以这里单开一篇，只盯住：

- `src/utils/plugins/pluginOptionsStorage.ts`
- `src/utils/plugins/mcpbHandler.ts`
- `src/utils/plugins/mcpPluginIntegration.ts`
- `src/commands/plugin/PluginOptionsFlow.tsx`
- `src/commands/plugin/ManagePlugins.tsx`

把 top-level options、per-server config、`needs-config` state、`configured / skipped` outcome 与 `/reload-plugins` apply grammar 并排，
直接钉死 stronger-request cleanup 线当前仍缺的不是 comeback seat，
而是 `current config truth grammar`。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 re-entitlement，没有 reconfiguration。`

而是：

`Claude Code 在 plugin 线已经明确把“对象拿回 seat”和“对象按哪组 current config 重新工作”拆成两层；stronger-request cleanup 线当前缺的不是这种文化，而是这套 reconfiguration governance 还没被正式接到旧 cleanup artifact family 上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| top-level option persistence | `src/utils/plugins/pluginOptionsStorage.ts:90-193` | 为什么 option truth 要按敏感性拆仓、双向 scrub，而不是随 enable 自动继承 |
| top-level config completeness | `src/utils/plugins/pluginOptionsStorage.ts:282-309` | 为什么对象可以已经存在，但 schema 仍判它 unconfigured |
| per-server config persistence | `src/utils/plugins/mcpbHandler.ts:141-339` | 为什么 channel/server payload 也有单独的 split-save 与 scrub grammar |
| formal `needs-config` state | `src/utils/plugins/mcpbHandler.ts:742-757,894-902` | 为什么 validation failed / force reconfigure 不被偷写成 ready truth |
| per-channel missing-config discovery | `src/utils/plugins/mcpPluginIntegration.ts:290-317` | 为什么 channel config completeness 是单独 decision surface |
| flow-level outcome split | `src/commands/plugin/PluginOptionsFlow.tsx:53-133` | 为什么 `configured` 与 `skipped` 是两个正式 outcome |
| UI grammar split | `src/commands/plugin/ManagePlugins.tsx:1645-1668,1700-1707` | 为什么 `Enabled`、`Enabled and configured` 与 `Configuration saved` 是三种不同事实 |

## 4. `savePluginOptions()` 先证明：top-level options 不是 authority seat 的尾气，而是单独的 current truth

`savePluginOptions():90-193` 最值钱的地方不是“能把值写进去”，
而是它明确拒绝以下偷换：

`seat 回来了 -> option truth 自然也回来了`

这段代码至少同时治理四个问题：

1. `sensitive` key 必须进 `secureStorage`
2. `non-sensitive` key 进 `settings.pluginConfigs[pluginId].options`
3. 本次 save 已迁到另一侧的 key 必须从旧侧 scrub
4. partial reconfigure 不能因为一次局部 save 就把其他字段误删

这里最先进的设计不是“秘密单独存”，
而是：

`双侧当前真相如何保持不自相矛盾。`

尤其 `secureStorage FIRST` 这一条非常关键。
它不是一般的实现顺序，
而是一种安全哲学声明：

`宁可暂时保留旧 plaintext fallback，也不要因为 keychain 失败把 current config truth 弄成双侧都不可信。`

## 5. `getUnconfiguredOptions()` 再证明：配置完整性是单独 decision surface

`getUnconfiguredOptions():282-309` 的价值经常被低估。

它并不只是一个 UI helper。
它本质上在做一件治理性的事情：

`判定 current seat 是否已经具备足够 config truth。`

这段代码先读当前保存值，
再跑 `validateUserConfig()`，
只把失败字段重新打包回 schema slice。

这说明 repo 清楚承认：

1. 对象已经存在
2. schema 仍然不满足
3. 这不是异常，而是正式可继续处理的状态

也就是说，
在 Claude Code 里：

`configured`

不是对象存在的自然副产物，
而是一种需要被单独验证的 truth class。

## 6. `saveMcpServerUserConfig()` 把同一治理逻辑推进到 per-server / per-channel payload

`mcpbHandler.ts:141-339` 让这条线变得更硬。

`loadMcpServerUserConfig():141-162` 先把：

1. `settings.pluginConfigs[pluginId].mcpServers[serverName]`
2. `secureStorage.pluginSecrets[pluginId/serverName]`

合并成当前视图。

然后 `saveMcpServerUserConfig():193-339` 再精确规定：

1. sensitive/non-sensitive split
2. secure-first write order
3. schema flip 时的反向 scrub
4. partial reconfigure 的最小影响面

这一套设计说明 repo 并不把：

`channel/server config`

看成 top-level option 的附属细节。
它承认：

`不同 surface 的 payload truth 也需要独立治理。`

更强的是 `mcpbHandler.ts:742-757,894-902`。
这里在两条路径上都明确返回：

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

## 7. `getUnconfiguredChannels()`、`PluginOptionsFlow` 与 `ManagePlugins` 再证明：`enabled`、`configured`、`applied` 是三层不同事实

`getUnconfiguredChannels():290-317` 很硬。
它对每个 channel：

1. 读取保存值
2. 跑 `validateUserConfig()`
3. 只要失败，就把该 channel 放进 `unconfigured` 列表

这使 `PluginOptionsFlow.tsx:53-133` 可以在 mount 时直接构造 step list：

1. top-level unconfigured options
2. per-channel unconfigured config

如果没有 step，
立刻 `onDone('skipped')`；
全部 step 完成后，
才 `onDone('configured')`。

这说明 flow 层对配置真相的理解，不是：

`要么 enabled，要么 disabled`

而是至少三段：

1. object seat restored
2. config truth unresolved
3. config truth closed

`ManagePlugins.tsx:1645-1668` 甚至把这套分层直接公开写成结果句法：

1. `Enabled and configured`
2. `Enabled`
3. `Configuration saved. Run /reload-plugins for changes to take effect.`

一旦这三句话同时存在，
整个 repo 就在公开承认：

1. `enabled != configured`
2. `configured != active applied`
3. config 保存本身也是另一种 truth，不该被 enable 文案吞掉

## 8. 更深一层的技术先进性：Claude Code 连“配置已保存”与“配置已生效”都继续拆开

`ManagePlugins.tsx:1663-1668,1700-1707` 明确写出：

`Configuration saved. Run /reload-plugins for changes to take effect.`

这说明 repo 在 config line 上甚至没有止步于：

`seat` vs `config`

它还继续承认：

`config saved` vs `config applied to active world`

也不是同一件事。

从技术角度看，这非常先进。
它避免系统把：

1. authority restoration
2. config persistence
3. active application

压成一句虚假的“已经可以用了”。

## 9. 一条硬结论

这组源码真正说明的不是：

`cleanup 线未来只要补出 re-entitlement governance，就已经足够成熟。`

而是：

`repo 在 savePluginOptions、saveMcpServerUserConfig、getUnconfiguredOptions、getUnconfiguredChannels、PluginOptionsFlow 与 ManagePlugins 的 outcome grammar 上已经明确展示了 reconfiguration governance 的存在；因此 artifact-family cleanup stronger-request cleanup-re-entitlement-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-reconfiguration-governor signer。`

因此：

`cleanup 线真正缺的不是“谁来让旧对象重新拿到 seat”，而是“谁来决定它拿回 seat 之后必须按哪组 current config truth 重新工作”。`
