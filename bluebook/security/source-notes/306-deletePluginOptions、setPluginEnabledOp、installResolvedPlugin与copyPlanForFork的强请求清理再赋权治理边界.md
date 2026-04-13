# deletePluginOptions、setPluginEnabledOp、installResolvedPlugin与copyPlanForFork的强请求清理再赋权治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `455` 时，
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
- `src/utils/plugins/pluginInstallationHelpers.ts`
- `src/utils/plans.ts`
- `src/screens/REPL.tsx`

把 repo 里现成的配置删除、显式 enable、policy blocking、settings divergence、closure-level entitlement write 与 new-slug fork policy 并排，
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
| config / secret wipe on exit | `src/utils/plugins/pluginOptionsStorage.ts:201-272`; `src/services/plugins/pluginOperations.ts:523-540` | 为什么 last-scope uninstall 会显式抹掉旧配置与 secrets，使后续 comeback 不自动恢复旧配置资格 |
| explicit enable entitlement | `src/services/plugins/pluginOperations.ts:573-727` | 为什么对象回来不等于自动恢复 enabled entitlement |
| policy veto | `src/utils/plugins/pluginPolicy.ts:11-19`; `src/services/plugins/pluginOperations.ts:650-657` | 为什么更高主权仍可拒绝恢复旧资格 |
| existence-entitlement divergence | `src/utils/plugins/installedPluginsManager.ts:827-830,859-861` | 为什么 disk existence 与 effective current entitlement 不是同一层 truth |
| closure-level re-entitlement | `src/utils/plugins/pluginInstallationHelpers.ts:330-339,361-367,414-437` | 为什么再赋权有时是关系闭包的统一 settings write，而不是单对象 presence 推论 |
| identity downgrade on return | `src/utils/plans.ts:233-257`; `src/screens/REPL.tsx:1790-1797` | 为什么内容回来时仍可能只获得 new identity，而不是 old identity |

## 4. plugin 线先证明：对象回来并不自动恢复旧配置、旧 secrets 与旧 enabled truth

`pluginOptionsStorage.ts:201-272`
先把 `deletePluginOptions()` 的制度边界写死：

1. 只在 LAST installation 被移除时调用
2. 不是每次 uninstall 都删
3. 因为 plugin 可能仍在其他 scope 存活
4. 即便 keychain cleanup 失败，也不把 uninstall itself 回滚成失败

更关键的是它实际清掉了：

1. `settings.pluginConfigs[pluginId]`
2. `secureStorage.pluginSecrets[pluginId]`
3. `${pluginId}/${server}` 这类 per-server composite keys

再看
`pluginOperations.ts:523-540`
last-scope remove 时又会显式联动：

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

`setPluginEnabledOp()` 的结构非常关键。
它在 `pluginOperations.ts:573-727` 明确把 enable / disable 写成独立动作：

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

## 6. policy guard 与 divergence guard 再证明：回来不等于重新被允许，也不等于重新成为有效 installed truth

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

换句话说，
Claude Code 在这里宁可把“磁盘上明明有对象”降级成“对当前资格世界而言仍算没装”，
也不愿意让 existence 越级冒充 entitlement。

## 7. `installResolvedPlugin()` 给出更深一层正例：有些 entitlement 不是逐对象恢复，而是按关系闭包统一重签

`pluginInstallationHelpers.ts:330-339`
对 core install logic 的描述很关键。

它明确说：

1. 先 resolve transitive dependency closure
2. 然后 `Writes the entire closure to enabledPlugins in one settings update`
3. 再 materialize each closure member

`361-367`
又先加上 root plugin policy guard；
`414-437`
再对 transitive dependencies 做 blocked-dependency guard，
最后才统一把 `closureEnabled` 写回 settings。

这说明一件比旧版更深的事：

`再赋权有时不是“单个对象回来后恢复单个资格”，而是“整个关系闭包必须被统一重签，且任一 blocked dependency 都足以否决整包资格恢复”。`

这对 stronger-request cleanup 的启示非常硬：

`如果 cleanup object 的旧资格本来就依赖一整组旧 relation bundle，那么 comeback 后的 re-entitlement 也不能只盯一个孤立对象。`

## 8. plan 线给出第二个强正例：内容回来仍可能只拿到 new identity，而不是原来的资格位

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

## 9. 这篇源码剖面给主线带来的七条技术启示

1. comeback 不是 entitlement package return。
2. old config / secrets trust 必须被单独治理，而不是跟着 object presence 自动复活。
3. enabled truth 需要被重新签字，不能从“对象回来”偷推出来。
4. higher governance 可以继续 veto post-return qualification，这恰恰说明资格恢复不是 resurrection 的自然尾巴。
5. existence-truth 与 entitlement-truth 必须分账，不可混写。
6. 有些资格恢复不是单对象问题，而是 closure-level re-sign 问题。
7. stronger-request cleanup 如果未来要长出 re-entitlement-governor plane，关键不只是“让对象回来”，而是明确哪些旧资格根本不应该跟着回来。

## 10. 为什么这些正对照会反过来暴露 stronger-request cleanup 的当前缺口

和这些成熟 re-entitlement grammar 对照，
stronger-request cleanup 线当前真正缺的已经不是：

`旧对象能不能回来`

而是：

`旧对象回来后还算不算原来那个被授权的对象`

更具体地说，
现在还没有哪一层正式决定：

1. 旧 startup wording comeback 后是否恢复原来的强声明 seat
2. 旧 cleanup law comeback 后是否继续带着旧 config / old trust material
3. 旧 promise vocabulary comeback 后是否仍保有旧 enabled truth
4. 旧 receipt objects comeback 后是否还是 old identity，还是 new seat
5. 哪些旧 relation bundle 应整包重签，哪些必须拆开重签

这意味着 stronger-request cleanup 当前虽然已经开始显露 resurrection-governance，
却还没有谁正式回答：

`谁来决定回来之后它还算不算原来那个被授权的对象。`

## 11. 苏格拉底式自反诘问：我是不是又把“对象回来了”误认成了“它原来的全部资格也回来了”

如果对这组代码做更严格的自我审查，
至少要追问六句：

1. 如果 resurrection grammar 已经足够强，为什么还要再拆 re-entitlement？
   因为对象能回来，不等于它原来的资格也一起回来。
2. 如果 disk / materialized world 已经恢复，是不是就说明 enabled truth 也恢复了？
   不是。enabled truth 仍要经过独立 settings write。
3. 如果 plan 内容能恢复，是不是就说明 old identity 也恢复了？
   不是。`copyPlanForFork()` 明确证明 content return 与 identity return 可以分开。
4. 如果 policy 没有阻止 comeback，是不是就说明它自动允许 old entitlement 恢复？
   也不对。policy veto 只是更高层拒绝条件，不等于 entitlement 已被重新签发。
5. 如果旧 config / secrets 还没被完全删干净，是不是就说明它们仍然可信？
   不能这样推。成熟系统恰恰会把 trust material 的回归单独治理。
6. 如果 cleanup 线现在还没有显式再赋权代码，是不是说明这层还不值得写？
   恰恰相反。越是缺这层明确 grammar，越容易把“对象回来”偷写成“旧资格整包归位”。

这一串反问最终逼出一句更稳的判断：

`re-entitlement 的关键，不在对象会不会回来，而在系统能不能正式决定回来之后哪些旧权利还配继续属于它。`

## 12. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 未来只要补出 resurrection governance，就已经足够成熟。`

而是：

`Claude Code 在 old config / secrets wipe、explicit enabled write、policy veto、divergence guard、closure-level entitlement write 与 new-slug identity fallback 上已经明确展示了 re-entitlement governance 的存在；因此 artifact-family cleanup stronger-request cleanup-resurrection-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-re-entitlement-governor signer。`

再压成一句：

`cleanup 线真正缺的不是“怎么让旧对象回来”，而是“谁来决定回来之后它还算不算原来那个被授权的对象”。`
