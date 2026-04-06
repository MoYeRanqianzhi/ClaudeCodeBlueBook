# 安全载体家族复活治理与再赋权治理分层：为什么artifact-family cleanup resurrection-governor signer不能越级冒充artifact-family cleanup re-entitlement-governor signer

## 1. 为什么在 `167` 之后还必须继续写 `168`

`167-安全载体家族墓碑治理与复活治理分层` 已经回答了：

`cleanup 线即便以后长出 resurrection governor，也还需要一层正式主权去决定哪些旧对象可以重新回到 current world。`

但如果继续往下追问，  
还会碰到另一层很容易被误写成“对象回来就说明它原来的资格也一起回来了”的错觉：

`只要 resurrection governor 已经让旧对象重新出现，它就自动拥有了决定旧 identity、旧配置、旧 secrets、旧 scope 与旧可用资格是否一起恢复的主权。`

Claude Code 当前源码同样不能支持这种更强说法。

因为继续看：

1. `src/utils/plugins/pluginOptionsStorage.ts:210-267` 的 `deletePluginOptions()`
2. `src/services/plugins/pluginOperations.ts:573-734` 的 `setPluginEnabledOp()`
3. `src/utils/plugins/pluginPolicy.ts:1-18` 的 policy guard
4. `src/utils/plugins/installedPluginsManager.ts:820-861` 的 settings divergence guard
5. `src/utils/plans.ts:234-258` 的 `copyPlanForFork()`

会发现 repo 已经清楚展示出：

1. `resurrection governance` 负责决定对象能否重新回到 current world
2. `re-entitlement governance` 负责决定对象回来之后是否重新获得旧 identity、旧 scope、旧 secrets、旧配置与旧可用资格

也就是说：

`artifact-family cleanup resurrection-governor signer`

和

`artifact-family cleanup re-entitlement-governor signer`

仍然不是一回事。

前者最多能说：

`这个旧对象可以重新出现。`

后者才配说：

`它重新出现之后，算不算原来那个被授权、被配置、被允许继续工作的对象。`

所以 `167` 之后必须继续补的一层就是：

`安全载体家族复活治理与再赋权治理分层`

也就是：

`resurrection governor 负责让对象回来；re-entitlement governor 才负责决定它回来之后恢复哪些旧资格。`

## 2. 先做一条谨慎声明：`artifact-family cleanup re-entitlement-governor signer` 仍是研究命名，不是源码现成类型

这里同样要先讲清楚：

`Claude Code 当前源码里并没有一个字面存在的类型叫 artifact-family cleanup re-entitlement-governor signer。`

这里的 `artifact-family cleanup re-entitlement-governor signer` 仍是研究命名。  
它不是在声称 cleanup 线已经有一个未公开的 re-entitlement manager，  
而是在说：

1. repo 在 plugin 与 plan 线上已经展示出对象回来不等于资格回来
2. “回来”与“恢复旧资格”是两个不同问题
3. cleanup 线如果未来真要把 resurrection world 做完整，也迟早要回答这些“回来后还算不算原来那个对象”的问题

因此 `168` 不是在虚构已有实现，  
而是在给更深的一层缺口命名：

`会复活，不等于会再赋权。`

## 3. 最短结论

Claude Code 当前源码至少给出了五类“resurrection-governor signer 仍不等于 re-entitlement-governor signer”证据：

1. `pluginOptionsStorage.ts:210-267` 的 `deletePluginOptions()` 会在 last-scope uninstall 时删除  
   `settings.pluginConfigs[pluginId]`  
   与  
   `secureStorage.pluginSecrets[pluginId]`  
   这说明对象即便后来重新回来，旧配置与旧 secrets 也不自动随之返回
2. `pluginOperations.ts:573-734` 的 `setPluginEnabledOp()` 说明 enable/disable 是单独 settings write；  
   插件可被安装、materialize、refresh，但是否重新获得 enabled state 仍要经过独立写入
3. `pluginPolicy.ts:1-18` 明确写出 org-blocked plugins 不能被 install 或 enable；  
   这说明对象即便能回来，也未必恢复旧 entitlement，policy guard 仍是更高主权
4. `installedPluginsManager.ts:820-861` 明确承认  
   `installed_plugins.json` 与 `settings.enabledPlugins` 若 diverge，系统会把插件视作 not-installed so the user can re-enable`；  
   这说明 disk/materialized return 不等于 effective entitlement return
5. `plans.ts:234-258` 的 `copyPlanForFork()` 会用 new slug，而不复用 original slug；  
   这说明内容可以回来，但不自动恢复旧 identity，这同样是一种 re-entitlement 分层

因此这一章的最短结论是：

`resurrection governor 最多能说对象能回来；re-entitlement governor 才能说它回来之后恢复什么旧资格。`

再压成一句：

`会回来，不等于还是原来那个被授权的它。`

## 4. 第一性原理：resurrection governance 回答“能否回来”，re-entitlement governance 回答“回来后恢复哪些资格”

从第一性原理看，  
复活治理与再赋权治理处理的是两个不同主权问题。

resurrection governor 回答的是：

1. 哪些历史对象允许重新回到 current world
2. 需要什么 evidence 才能回来
3. 回到的是哪一层 world
4. 是否沿原 lineage 回来
5. 是否应该避免 clobber

re-entitlement governor 回答的则是：

1. 对象回来后是否恢复旧 enabled state
2. 是否恢复旧 secrets
3. 是否恢复旧 pluginConfigs / options
4. 是否恢复旧 scope / precedence 位置
5. 是否恢复旧 identity，还是只给它一个新的 current seat

如果把这两层压成一句“反正它已经回来了”，  
系统就会制造五类危险幻觉：

1. return-means-enabled illusion  
   只要对象回来，就误以为它自动恢复旧可用资格
2. return-means-configured illusion  
   只要对象回来，就误以为旧配置与 secrets 也自动回来
3. return-means-same-scope illusion  
   只要对象回来，就误以为它自动回到原来的 scope 和 precedence
4. return-means-same-identity illusion  
   只要内容回来，就误以为对象还是旧 identity
5. existence-means-entitlement illusion  
   只要对象存在于 disk/materialized world，就误以为它有 current effective entitlement

所以从第一性原理看：

`resurrection governor` 决定对象能否重新出现；  
`re-entitlement governor` 决定对象回来之后恢复什么旧资格，或者只给它一个更弱的新资格。

## 5. plugin 线给出最强正例：插件可以回来，但旧 options / secrets / enabled state 不会自动一起回来

`deletePluginOptions()` 非常关键。  
`pluginOptionsStorage.ts:210-267` 明确写出：

1. last installation 卸载时会清 `settings.pluginConfigs[pluginId]`
2. 同时清 `secureStorage.pluginSecrets[pluginId]`
3. 包括 per-server composite keys 也一起删

这说明插件对象即便后来重新 install、重新 materialize、重新 refresh，  
也不自动等于：

`旧配置回来`

或

`旧 secrets 回来`

继续看 `setPluginEnabledOp()`：  
`pluginOperations.ts:573-734` 明确把 enable/disable 做成单独的 settings write。

这里的关键不是“能不能 enable”，  
而是：

`对象存在`

和

`对象被重新赋予 enabled entitlement`

是两层动作。

从技术角度看，这非常值钱。  
它把：

1. resurrection of object
2. re-entitlement of object

拆成了两个 chokepoint，  
避免系统把“东西回来了”误写成“它还能继续按旧资格工作”。

## 6. policy guard 再证明：即便对象能回来，更高主权仍可拒绝恢复旧资格

`pluginPolicy.ts:1-18` 很硬。  
这里直接写出：

`Policy-blocked plugins cannot be installed or enabled by the user at any scope`

而 `setPluginEnabledOp()` 也在前段就检查：

`if (enabled && isPluginBlockedByPolicy(pluginId)) return blocked`

这说明：

1. resurrection 不是 entitlement 的最高主权
2. 就算对象回来，policy 仍可拒绝恢复旧资格

也就是说，  
“对象回来”回答的是存在问题，  
“对象回来后还能不能被继续允许使用”回答的是 entitlement 问题。

这对于 cleanup 线是极其强的启示。  
将来即便旧 path、旧 promise 或旧 receipt 可以被某种 recovery path 带回 current world，  
也仍然不自动说明：

`它重新获得了原来的强声明资格。`

## 7. `installed_plugins.json` 与 `enabledPlugins` 的 divergence guard 给出另一组正例：materialized world 与 effective entitlement world 本来就不是同一层

`installedPluginsManager.ts:820-861` 直接写出两条很值钱的注释：

1. `Plugins are loaded from settings.enabledPlugins`
2. 如果 `settings.enabledPlugins` 与 `installed_plugins.json` diverge，`return false`

甚至更强地写出：

`treat as not-installed so the user can re-enable`

这说明 repo 明确承认：

1. 一个 plugin 可以在 installation metadata 世界里存在
2. 但只要 `enabledPlugins` 没恢复，它仍不算 current effective plugin

这就是非常标准的：

`resurrection != re-entitlement`

从第一性原理看，  
这意味着系统把：

1. object existence
2. object entitlement

拆成了两个不同真相面。  
这比“一回来就全都算恢复”安全得多，因为它防止 stale metadata 借尸还魂。

## 8. plan 线给出第二个强正例：plan content 可以回来，但 fork policy 明确拒绝恢复原 identity entitlement

`copyPlanForFork()` 在 `plans.ts:234-258` 非常值钱。

它做了三件事情：

1. 复制 original content
2. 生成 new slug
3. 避免 original 与 forked session clobber

这说明 plan line 明确写出：

`内容回来`

并不等于

`原身份、原 ownership、原 path entitlement 全部回来`

相反，  
repo 选择的是：

`让内容回来，但不给它原来的 identity seat。`

这正是 re-entitlement governance 的本体。

也就是说，  
即便 resurrection 已成立，  
系统仍要继续决定：

`回来的是 old identity 还是 new identity。`

而这件事显然不该由 resurrection governor 顺手偷签。

## 9. 技术先进性：Claude Code 真正先进的地方，是它把“对象回来”与“资格回来”继续拆成两层受管真相

从技术角度看，Claude Code 在这条线上的先进性，  
不只是它能 recovery、能 refresh、能 reinstall。  
更值钱的是它已经在多个子系统里承认：

1. return != enabled
2. return != configured
3. return != same scope
4. return != same identity
5. return != same secrets

这背后的设计启示非常强：

`真正成熟的系统，不只知道怎样把对象从历史世界带回来，还知道回来之后必须重新判断它值不值得拿回旧资格。`

因此对 cleanup 线最关键的技术启示不是：

`给它补 recovery path 就够了。`

而是：

`必须同时补 resurrection grammar 和 re-entitlement grammar。`

否则系统会停在另一种危险的半治理状态：

`大家都知道旧对象回来了，但没人知道它回来后是否还配说原来那么强的话、拿原来那么高的资格。`

## 10. 苏格拉底式自诘：我的判断有没有再次越级

为了避免把“源码里有 enable/config/policy 逻辑”直接写成“cleanup 线只差照抄插件线”，  
这里必须主动追问自己四个问题。

### 第一问

`我是不是把任何重新 enable 都当成 re-entitlement 的全部？`

不能这样写。  
re-entitlement 可能还包括 secrets、配置、scope、identity 与 stronger claims。  
enable 只是其中一部分。

### 第二问

`resurrection governor 和 re-entitlement governor 一定要做成两个模块吗？`

也不能这么绝对。  
它们可以由同一实现承载，  
但回答的问题不同：  
一个回答“回来没有”，  
一个回答“回来后恢复什么资格”。

### 第三问

`如果 cleanup 线将来只有很弱的恢复路径，还需要 re-entitlement governance 吗？`

只要旧 path、旧 promise 或旧 receipt 可能重新被 current world 接纳，  
就至少要回答：

`它回来后算不算原来那个被信任、被允许、被赋权的对象。`

这已经是 re-entitlement 问题。

### 第四问

`我真正该继续约束自己的是什么？`

是这句：

`不要把 enabled、configured、same-scope、same-identity 与 same-secret return 混成同一个 re-entitlement 事件。`

当前更稳妥的说法只能是：
repo 已经在 plugin 与 plan 线上明确展示：

1. return != enabled
2. return != same identity
3. return != same config / same secret

因此本章能成立的是：

`resurrection != re-entitlement`

不能偷加的 stronger claim，
则是：

`任何资格恢复都已经被单一 entitlement event 完整回答。`

## 11. 一条硬结论

这组源码真正说明的不是：

`Claude Code 只要决定了 cleanup 旧对象怎样回来，就已经自动拥有了治理它回来后是否恢复旧身份、旧配置、旧 secrets 与旧资格的主权。`

而是：

`repo 在 deletePluginOptions、setPluginEnabledOp、policy blocking、settings divergence guard 与 copyPlanForFork 的 new-slug policy 上已经明确展示了 re-entitlement governance 的存在；因此 artifact-family cleanup resurrection-governor signer 仍不能越级冒充 artifact-family cleanup re-entitlement-governor signer。`

再压成最后一句：

`复活负责把对象带回来；再赋权，才负责决定它回来后还能拿回多少原来的资格。`
