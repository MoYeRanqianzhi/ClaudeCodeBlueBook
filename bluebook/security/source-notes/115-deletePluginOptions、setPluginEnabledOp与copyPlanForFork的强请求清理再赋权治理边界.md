# deletePluginOptions、setPluginEnabledOp与copyPlanForFork的强请求清理再赋权治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `264` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 旧对象能不能回来，`

而是：

`stronger-request cleanup 旧对象即便回来了，谁来决定它回来后还拿不拿得回原来的资格。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`resurrection governor 不等于 re-entitlement governor。`

这句话还不够硬。
所以这里单开一篇，
只盯住：

- `src/utils/plugins/pluginOptionsStorage.ts`
- `src/services/plugins/pluginOperations.ts`
- `src/utils/plugins/pluginPolicy.ts`
- `src/utils/plugins/installedPluginsManager.ts`
- `src/utils/plans.ts`
- `src/screens/REPL.tsx`

把 repo 里现成的配置删除、重新 enable、policy blocking、scope legality、settings divergence 与 new-slug fork policy 并排，
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
| config/secret wipe on exit | `src/utils/plugins/pluginOptionsStorage.ts:201-204,210-272` | 为什么 last-scope uninstall 会显式抹掉旧配置与 secrets，使后续 comeback 不自动恢复旧配置资格 |
| explicit enable entitlement | `src/services/plugins/pluginOperations.ts:560-571,610-648,721-727` | 为什么对象回来不等于自动恢复 enabled entitlement |
| policy veto | `src/utils/plugins/pluginPolicy.ts:11-19`; `src/services/plugins/pluginOperations.ts:650-657` | 为什么更高主权仍可拒绝恢复旧资格 |
| scope / seat legality | `src/services/plugins/pluginOperations.ts:664-687` | 为什么 comeback 之后是否恢复原 scope seat 仍要经过 override legality 判断 |
| existence-vs-entitlement guard | `src/utils/plugins/installedPluginsManager.ts:827-830,859-861` | 为什么 installed metadata 存在并不自动等于 current effective installed / enabled truth |
| identity downgrade on return | `src/utils/plans.ts:239-257`; `src/screens/REPL.tsx:1790-1797` | 为什么内容回来时仍可能只获得 new identity，而不是 old identity |

## 4. plugin 线先证明：对象回来并不自动恢复旧配置、旧 secrets 与旧 enabled truth

`pluginOptionsStorage.ts:201-204`
先把 `deletePluginOptions()` 的制度边界写死：

1. 只在 LAST installation 被移除时调用
2. 不是每次 uninstall 都删
3. 因为 plugin 可能仍在其他 scope 存活

继续看
`pluginOptionsStorage.ts:210-272`：

1. settings side 会删 `pluginConfigs[pluginId]`
2. secure storage side 会删 `pluginSecrets[pluginId]`
3. 还会删 `${pluginId}/${server}` 这类 per-server composite keys
4. 最后 clear options cache

这说明 plugin comeback 之后，
系统不会自动假定：

`旧配置还有效`

或

`旧 secrets 还应继续被信任`

再看
`pluginOptionsStorage.ts:206-208`：
即便 keychain cleanup 失败，
repo 也明确不把 uninstall itself 回滚成失败。

这说明：

`对象离场`

和

`旧资格痕迹是否已被完全擦除`

本来就不是同一层事实。

接着看
`pluginOperations.ts:560-571`
与
`pluginOperations.ts:610-648`：

1. `setPluginEnabledOp()` 先 resolve `pluginId` 与 scope
2. 明确说明 settings declares intent
3. 不把 installed metadata 当成 entitlement truth 的最高主权

继续看
`pluginOperations.ts:721-727`：
真正的 enable / disable 是一笔单独的 settings write。

这说明：

`对象存在`

和

`对象被重新赋予 enabled truth`

是两层不同动作。

## 5. policy guard 与 scope legality 再证明：回来不等于重新被允许，也不等于重新占回旧位置

`pluginPolicy.ts:11-19`
把 policy guard 写得很直白：

1. `policySettings.enabledPlugins[pluginId] === false`
2. 即视为 blocked
3. install chokepoint、enable op 与 UI filters 都共用这份 truth

再看
`pluginOperations.ts:650-657`：
enable 前会直接挡住：

`Plugin "${pluginId}" is blocked by your organization's policy and cannot be enabled`

这说明：

`能回来`

和

`回来后还被允许`

不是同一问题。

但 re-entitlement 不只回答 allow / deny。
它还回答：

`回来后是不是仍占原来的 scope / precedence seat。`

`pluginOperations.ts:664-687`
在 explicit scope given but plugin is elsewhere 时，
会继续做 cross-scope legality 判断：

1. 若 absent from requested scope but present at another scope
2. 且这次不是合法 higher-precedence override
3. 则直接返回 wrong-scope guidance

这说明对象即便回来了，
系统也不会自动假定：

`它还是原来那个 scope 上的有效 seat。`

## 6. divergence guard 再证明：current entitlement 不是单看 object 在不在

`installedPluginsManager.ts:827-830`
写得很明白：

1. plugins are loaded from `settings.enabledPlugins`
2. 如果 `settings.enabledPlugins` 与 `installed_plugins.json` diverge
3. 则 `isPluginInstalled()` 返回 `false`

继续看
`installedPluginsManager.ts:859-861`：

1. same settings divergence guard as `isPluginInstalled`
2. if enabledPlugins was clobbered
3. treat as not-installed so the user can re-enable

这等于直接证明：

`disk / materialized existence`

和

`effective installed / enabled entitlement`

不是同一层 truth。

这条设计并不追求“更方便”，
它追求的是：

`不让 stale installation metadata 直接偷签 current entitlement。`

## 7. plan 线给出第二个强正例：内容回来仍可能只拿到新 identity，而不是原来的资格位

`plans.ts:239-257`
的 `copyPlanForFork()` 很清楚：

1. 复制 original content
2. 生成 `newSlug`
3. 写到 `newPlanPath`
4. 避免 original 与 forked sessions clobber

再看
`REPL.tsx:1790-1797`：

1. fork path 调 `copyPlanForFork()`
2. regular resume path 才调 `copyPlanForResume()`

这直接证明：

`内容回来`

不等于

`原身份回来`

从再赋权角度看，
这非常重要。
因为 identity 本身就是 entitlement 的一部分。

一个对象即便回来了，
也可能只被赋予：

`new seat, not old seat`

这正是 re-entitlement governance 的本体。

## 8. 这篇源码剖面给主线带来的五条技术启示

### 启示一

repo 已经在 plugin 线明确展示：

`return != configured`

### 启示二

repo 已经在 plugin 线明确展示：

`return != secrets trust`

### 启示三

repo 已经在 plugin 线明确展示：

`return != enabled`

### 启示四

repo 已经在 policy / scope / divergence guard 里明确展示：

`return != allowed`

也

`return != same seat`

### 启示五

repo 已经在 plan 线明确展示：

`return != same identity`

## 9. 苏格拉底式边界自校：什么才算真正的再赋权治理

### 诘问一

`如果对象已经被允许回来，为什么不让它自动恢复旧配置与旧 secrets？`

因为回来只证明：

`你重新被允许出现。`

它不证明：

`你旧时携带的 trust material 仍然可信。`

### 诘问二

`如果对象内容和 lineage 都成立，为什么还不能默认恢复 enabled truth？`

因为 enabled truth 是当前世界的积极担保，
不是历史事实的自然延伸。
它必须由当前规则重新签发。

### 诘问三

`如果 fork 时内容相同，为什么还要强行 new slug？`

因为系统要保护的不是 bytes，
而是 seat 的清晰边界。
不重新分 seat，
就容易把“复制内容”误写成“复制资格”。

## 10. 一条边界结论

对 stronger-request cleanup 线而言，
Claude Code 当前源码已经足够证明：

`复活治理回答“对象能不能回来”，再赋权治理回答“回来后恢复哪些旧资格、旧配置、旧身份与旧可用 truth”。`

但源码同样也提醒我们不要越级：

`别把 repo 某些子系统已经存在的 re-entitlement grammar，直接误写成 stronger-request cleanup 线已经拥有同等完备的 cleanup re-entitlement constitution。`
