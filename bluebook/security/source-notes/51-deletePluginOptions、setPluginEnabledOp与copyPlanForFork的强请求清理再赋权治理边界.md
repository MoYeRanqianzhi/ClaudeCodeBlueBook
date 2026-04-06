# deletePluginOptions、setPluginEnabledOp与copyPlanForFork的强请求清理再赋权治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `200` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 旧对象能不能回来，`

而是：

`stronger-request cleanup 旧对象即便回来了，谁来决定它回来后还拿不拿得回原来的资格。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`resurrection governor 不等于 re-entitlement governor。`

这句话还不够硬。
所以这里单开一篇，只盯住：

- `src/utils/plugins/pluginOptionsStorage.ts`
- `src/services/plugins/pluginOperations.ts`
- `src/utils/plugins/pluginPolicy.ts`
- `src/utils/plugins/installedPluginsManager.ts`
- `src/utils/plans.ts`

把 repo 里现成的配置删除、重新 enable、policy blocking、settings divergence 与 new-slug fork policy 并排，
直接钉死 stronger-request cleanup 线当前仍缺的不是 comeback 本身，
而是 `post-return qualification grammar`。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 resurrection，没有 re-entitlement。`

而是：

`Claude Code 在 plugin 与 plan 线上已经明确把“对象回来”和“回来后恢复哪些旧资格”拆成两层；stronger-request cleanup 线当前缺的不是这种文化，而是这套 re-entitlement governance 还没被正式接到旧 cleanup artifact family 上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| config/secret wipe on exit | `src/utils/plugins/pluginOptionsStorage.ts:210-267` | 为什么 last-scope uninstall 会显式抹掉旧配置与 secrets，使后续 comeback 不自动恢复旧配置资格 |
| explicit enable entitlement | `src/services/plugins/pluginOperations.ts:573-734` | 为什么对象回来不等于自动恢复 enabled entitlement |
| policy veto | `src/utils/plugins/pluginPolicy.ts:1-18`; `pluginOperations.ts:648-656` | 为什么更高主权仍可拒绝恢复旧资格 |
| existence-vs-entitlement guard | `src/utils/plugins/installedPluginsManager.ts:820-861` | 为什么 installed metadata 存在并不自动等于 current effective installed/enabled truth |
| identity downgrade on return | `src/utils/plans.ts:234-258` | 为什么内容回来时仍可能只获得 new identity，而不是 old identity |

## 4. plugin 线先证明：对象回来并不自动恢复旧配置与旧 secrets

`deletePluginOptions()` 是最硬的证据之一。
`pluginOptionsStorage.ts:210-267` 很清楚：

1. last installation 卸载时，会删 `settings.pluginConfigs[pluginId]`
2. 也会删 `secureStorage.pluginSecrets[pluginId]`
3. 连 per-server composite keys 也一起删

这说明 plugin comeback 之后，系统不会自动假定：

`旧配置还有效`

或

`旧 secrets 还应继续被信任`

也就是说：

`对象回来`

和

`旧配置 / 旧 secrets 跟着回来`

从源码一开始就不是同一件事。

## 5. `setPluginEnabledOp()` 再证明：对象回来后是否恢复 enabled state，是单独的再赋权动作

`pluginOperations.ts:573-734` 的 `setPluginEnabledOp()` 很关键。

这段代码回答的不是“插件是不是存在”。
它回答的是：

`插件该不该在某个 scope 上被重新赋予 enabled entitlement。`

这里的制度非常清楚：

1. 先 resolve `pluginId` 与 scope
2. 再过 policy guard
3. 再判断 scope precedence / override
4. 最后才写 `enabledPlugins`

这说明 repo 明确承认：

`对象存在`

和

`对象被重新赋予 enabled truth`

是两层主权。

从安全角度看，这种分层非常先进。
它防止系统因为“对象已回来”就越权替用户或策略层自动恢复旧启用资格。

## 6. policy guard 给出更强正例：回来不等于重新被允许

`pluginPolicy.ts:1-18` 的判断非常直白：

`policySettings.enabledPlugins[pluginId] === false`

就视为 blocked。

而 `setPluginEnabledOp()` 也直接在 enable 前挡住它。

这说明：

1. resurrection 不是 entitlement 的最高主权
2. 更高层的 policy 仍可拒绝 entitlement

换句话说：

`能回来`

和

`回来后还被允许`

不是同一问题。

这对 cleanup 线的技术启示非常强：
将来即便旧 path、旧 promise 或旧 receipt 可以被某种 recovery path 带回 current world，
也仍不自动说明它重新获得了原来那种强声明资格。

## 7. divergence guard 再证明：current entitlement 不是单看 object 在不在

`installedPluginsManager.ts:820-861` 很值钱。
它明确写出：

1. plugins are loaded from `settings.enabledPlugins`
2. 如果 `settings.enabledPlugins` 与 `installed_plugins.json` diverge，就返回 `false`
3. 甚至要 `treat as not-installed so the user can re-enable`

这等于直接证明：

`disk/materialized existence`

和

`effective installed / enabled entitlement`

不是同一层 truth。

这条设计并不追求“更方便”，
它追求的是：

`不让 stale installation metadata 直接偷签 current entitlement。`

## 8. plan 线给出第二个强正例：内容回来仍可能只拿到新 identity，而不是原来的资格位

`copyPlanForFork()` 在 `plans.ts:234-258` 很清楚：

1. 复制 original content
2. 生成 new slug
3. 明确避免 clobber original session

这说明 plan line 已经明确写出：

`内容回来`

不等于

`原身份回来`

从再赋权角度看，这非常重要。
因为 identity 本身就是 entitlement 的一部分。
一个对象即便回来了，也可能只被赋予：

`new seat, not old seat`

这正是 re-entitlement governance 的本体。

## 9. 这篇源码剖面给主线带来的四条技术启示

### 启示一

repo 已经在 plugin 线明确展示：

`return != configured`

### 启示二

repo 已经在 plugin 线明确展示：

`return != enabled`

### 启示三

repo 已经在 policy 与 divergence guard 里明确展示：

`return != allowed`

### 启示四

repo 已经在 plan 线明确展示：

`return != same identity`

这四句合起来，正好说明为什么 cleanup 线未来不能把 resurrection governance 直接偷写成 complete requalification。

## 10. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 只要补出 resurrection governance，就已经足够成熟。`

而是：

`repo 在 config/secret wipe、explicit enable entitlement、policy veto、existence-vs-entitlement guard 与 new-identity fork policy 上已经明确展示了 re-entitlement governance 的存在；因此 artifact-family cleanup stronger-request cleanup-resurrection-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-re-entitlement-governor signer。`

因此：

`cleanup 线真正缺的不是“怎样让对象回来”，而是“回来之后它还算不算原来那个被授权的对象”。`
