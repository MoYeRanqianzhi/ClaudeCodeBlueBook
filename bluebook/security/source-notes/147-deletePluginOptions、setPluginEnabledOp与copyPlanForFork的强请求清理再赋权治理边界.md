# deletePluginOptions、setPluginEnabledOp与copyPlanForFork的强请求清理再赋权治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `296` 时，
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
| config/secret wipe on exit | `src/utils/plugins/pluginOptionsStorage.ts:201-208,210-272`; `src/services/plugins/pluginOperations.ts:528-540` | 为什么 last-scope uninstall 会显式抹掉旧配置与 secrets，使后续 comeback 不自动恢复旧配置资格 |
| explicit enable entitlement | `src/services/plugins/pluginOperations.ts:573-727` | 为什么对象回来不等于自动恢复 enabled entitlement |
| policy veto | `src/utils/plugins/pluginPolicy.ts:11-19`; `src/services/plugins/pluginOperations.ts:650-657` | 为什么更高主权仍可拒绝恢复旧资格 |
| scope / seat legality | `src/services/plugins/pluginOperations.ts:664-687`; `src/utils/plugins/installedPluginsManager.ts:827-830,859-861` | 为什么 comeback 之后是否恢复原 scope seat 仍要经过 legality 与 divergence guard 判断 |
| identity downgrade on return | `src/utils/plans.ts:233-257`; `src/screens/REPL.tsx:1790-1797` | 为什么内容回来时仍可能只获得 new identity，而不是 old identity |

## 4. plugin 线先证明：对象回来并不自动恢复旧配置、旧 secrets 与旧 enabled truth

`pluginOptionsStorage.ts:201-208`
先把 `deletePluginOptions()` 的制度边界写死：

1. 只在 LAST installation 被移除时调用
2. 不是每次 uninstall 都删
3. 因为 plugin 可能仍在其他 scope 存活
4. 即便 keychain cleanup 失败，也不把 uninstall itself 回滚成失败

继续看
`pluginOptionsStorage.ts:210-272`：

1. settings side 会删 `pluginConfigs[pluginId]`
2. secure storage side 会删 `pluginSecrets[pluginId]`
3. 还会删 `${pluginId}/${server}` 这类 per-server composite keys
4. 最后 clear options cache

再看
`pluginOperations.ts:528-540`
last-scope remove 时会显式联动：

1. `deletePluginOptions(pluginId)`
2. `deletePluginDataDir(pluginId)`

这说明 plugin comeback 之后，
系统不会自动假定：

`旧配置还有效`

或

`旧 secrets 还应继续被信任`

更重要的是，
repo 也不把 cleanup side-effect 的失败
反推成：

`旧资格应被保留`

这正是再赋权治理的第一条原则：

`对象回来之前，旧资格材料并不天然享有继续有效的推定。`

## 5. 显式 enable entitlement 再证明：对象回来不等于自动恢复 enabled truth

`pluginOperations.ts:573-727`
把 `setPluginEnabledOp()` 写成完整独立动作：

1. 先 resolve pluginId 与 scope
2. 再过 policy guard
3. 再过 cross-scope legality
4. 再判断当前 state / idempotency
5. 最后才写 `enabledPlugins`

这说明：

`对象存在`

和

`对象被重新赋予 enabled truth`

是两层不同动作。

系统宁可要求一笔新的 settings write，
也不允许从：

`它回来了`

直接偷推出：

`它又是 enabled 的了`

## 6. policy guard 与 scope legality 再证明：回来不等于重新被允许，也不等于重新占回旧位置

`pluginPolicy.ts:11-19`
把 policy guard 写得很直白：

1. `enabledPlugins[pluginId] === false`
2. 即视为 blocked
3. install chokepoint、enable op 与 UI filters 共用这份 truth

`pluginOperations.ts:650-657`
又在 enable 前直接挡住：

`Plugin "...\" is blocked by your organization's policy and cannot be enabled`

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

更进一步，
`installedPluginsManager.ts:827-830,859-861`
直接写出：

1. plugins are loaded from `settings.enabledPlugins`
2. 如果 `settings.enabledPlugins` 与 `installed_plugins.json` diverge
3. 就 treat as not-installed so the user can re-enable

这等于直接证明：

`disk / materialized existence`

和

`effective installed / enabled entitlement`

不是同一层 truth。

## 7. plan 线给出第二个强正例：内容回来仍可能只拿到 new identity，而不是原来的资格位

`plans.ts:233-257`
的 `copyPlanForFork()` 很清楚：

1. 复制 original content
2. 生成 `newSlug`
3. 写到 `newPlanPath`
4. 避免 original 与 forked sessions clobber

`REPL.tsx:1790-1797`
又把 fork / resume 两条路明确拆开：

1. fork path 调 `copyPlanForFork()`
2. regular resume path 才调 `copyPlanForResume()`

这直接证明：

`内容回来`

不等于

`原身份回来`

从再赋权角度看，
这非常重要。
因为 identity 本身就是 entitlement 的一部分。

如果系统连对象的名字 / seat 都重新分配了，
那它显然没有默认把旧资格整包带回。

## 8. 这篇源码剖面给主线带来的五条技术启示

### 启示一

repo 已经在 plugin options / secrets wipe 上明确展示：

`对象回来`

不自动意味着：

`旧 trust material 回来`

### 启示二

repo 已经在 `setPluginEnabledOp()` 上明确展示：

`return state`

与

`enabled entitlement`

必须分别签发。

### 启示三

repo 已经在 policy veto 与 scope legality 上明确展示：

`回来之后是否仍被允许`

与

`回来之后是否仍占旧 seat`

也是两层不同判断。

### 启示四

repo 已经在 divergence guard 上明确展示：

`materialized existence`

并不能偷签

`effective entitlement`

### 启示五

repo 已经在 `copyPlanForFork()` 上明确展示：

`内容回来`

甚至不自动等于

`identity 回来`

## 9. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 只要补出 resurrection governance，就已经足够成熟。`

而是：

`Claude Code 在 config wipe、explicit enable、policy veto、scope legality、divergence guard 与 new-identity fork policy 上已经明确展示了 re-entitlement governance 的存在；因此 artifact-family cleanup stronger-request cleanup-resurrection-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-re-entitlement-governor signer。`

再压成一句：

`cleanup 线真正缺的不是“谁来让旧对象回来”，而是“谁来决定它回来后恢复哪些旧资格”。`
