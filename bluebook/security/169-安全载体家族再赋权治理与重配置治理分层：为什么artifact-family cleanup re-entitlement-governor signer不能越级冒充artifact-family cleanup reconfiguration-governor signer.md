# 安全载体家族再赋权治理与重配置治理分层：为什么artifact-family cleanup re-entitlement-governor signer不能越级冒充artifact-family cleanup reconfiguration-governor signer

## 1. 为什么在 `168` 之后还必须继续写 `169`

`168-安全载体家族复活治理与再赋权治理分层` 已经回答了：

`cleanup 线即便以后长出 re-entitlement governor，也还需要一层正式主权去决定旧对象回来后恢复哪些资格。`

但如果继续往下追问，  
还会碰到另一层很容易被误写成“资格回来就说明配置也一起回来了”的错觉：

`只要 re-entitlement governor 已经让旧对象重新获得 current seat，它就自动拥有了决定旧 options、旧 secrets、旧 channel config 与旧 payload 应怎样重新填写、重存、重刷新的主权。`

Claude Code 当前源码同样不能支持这种更强说法。

因为继续看：

1. `src/utils/plugins/pluginOptionsStorage.ts:90-193,282-309` 的 `savePluginOptions()` 与 `getUnconfiguredOptions()`
2. `src/utils/plugins/mcpbHandler.ts:141-339,742-757,894-902` 的 `loadMcpServerUserConfig()`、`saveMcpServerUserConfig()` 与 `needs-config`
3. `src/utils/plugins/mcpPluginIntegration.ts:290-317` 的 `getUnconfiguredChannels()`
4. `src/commands/plugin/PluginOptionsFlow.tsx:53-133` 的 `configured / skipped` outcome grammar
5. `src/commands/plugin/ManagePlugins.tsx:1645-1668,1700-1707` 的 `Enabled and configured`、`Enabled` 与 `Configuration saved. Run /reload-plugins...`

会发现 repo 已经清楚展示出：

1. `re-entitlement governance` 负责决定对象回来后是否重新获得 seat、scope、identity 与 enabled truth
2. `reconfiguration governance` 负责决定这个 seat 重新工作前，到底要重新声明、重新保存、重新校验哪些 options、secrets、channel config 与 payload

也就是说：

`artifact-family cleanup re-entitlement-governor signer`

和

`artifact-family cleanup reconfiguration-governor signer`

仍然不是一回事。

前者最多能说：

`这个旧对象重新获得了 current authority seat。`

后者才配说：

`它重新获得 seat 之后，哪些 current config truth 必须被重新填写、重新保存、重新验证，它才配开始工作。`

所以 `168` 之后必须继续补的一层就是：

`安全载体家族再赋权治理与重配置治理分层`

也就是：

`re-entitlement governor 负责让对象重新拿回资格；reconfiguration governor 才负责决定它拿回资格后如何重新具备可运行的配置真相。`

## 2. 先做一条谨慎声明：`artifact-family cleanup reconfiguration-governor signer` 仍是研究命名，不是源码现成类型

这里同样要先讲清楚：

`Claude Code 当前源码里并没有一个字面存在的类型叫 artifact-family cleanup reconfiguration-governor signer。`

这里的 `artifact-family cleanup reconfiguration-governor signer` 仍是研究命名。  
它不是在声称 cleanup 线已经有一个未公开的 reconfiguration manager，  
而是在说：

1. repo 已经在 plugin 线上明确把 `enabled` 与 `configured` 拆开
2. repo 已经在 config storage 线上明确把 `seat exists` 与 `config truth is valid` 拆开
3. cleanup 线如果未来真要把 re-entitlement world 做完整，也迟早要回答这些“它拿回 seat 之后，凭什么按哪组 current config 重新工作”的问题

因此 `169` 不是在虚构已有实现，  
而是在给更深的一层缺口命名：

`会再赋权，不等于会重配置。`

## 3. 最短结论

Claude Code 当前源码至少给出了五类“re-entitlement-governor signer 仍不等于 reconfiguration-governor signer”证据：

1. `savePluginOptions()` 会把 `sensitive` 与 `non-sensitive` option 分仓保存，并在两侧做反向 scrub；这说明 seat 已经存在，不等于当前 options truth 已经自动成立
2. `getUnconfiguredOptions()` 会对保存值重新做 schema 校验，只把失败字段重新交回 dialog；这说明“已 enable”与“仍缺配置”可以同时成立
3. `saveMcpServerUserConfig()` 对 channel/server config 复现同样的 split-save、schema-flip scrub 与 partial reconfigure 保留逻辑；这说明 per-server payload 也有自己的 reconfiguration governance
4. `loadMcpbFile()` 在 `forceConfigDialog` 或 validation 失败时直接返回 `needs-config`，而不是把对象存在或 seat 恢复偷写成 ready truth
5. `PluginOptionsFlow` 与 `ManagePlugins` 明确把 outcome 写成 `configured` / `skipped`，并区分 `✓ Enabled and configured ...` 与 `✓ Enabled ...`；之后又把 `Configuration saved` 与 `Run /reload-plugins ... to take effect` 分开，说明 config truth 自身也是单独治理层

因此这一章的最短结论是：

`re-entitlement governor 最多能说对象重新拿回资格；reconfiguration governor 才能说它拿回资格后按哪组 current config truth 重新工作。`

再压成一句：

`资格回来，不等于配置也回来。`

## 4. 第一性原理：re-entitlement governance 回答“它还配不配拿 seat”，reconfiguration governance 回答“这个 seat 凭哪组输入重新工作”

从第一性原理看，  
再赋权治理与重配置治理处理的是两个不同主权问题。

re-entitlement governor 回答的是：

1. 对象回来后是否重新获得 enabled truth
2. 是否重新获得当前 scope / precedence 位置
3. 是否重新获得原 identity，还是只拿到 new seat
4. 是否重新被 policy 允许
5. 是否重新进入可声明的 authority world

reconfiguration governor 回答的则是：

1. 哪些 options 仍被视作缺失
2. 哪些 secrets 必须重填，哪些应继续放在 secure storage
3. 哪些 plaintext 配置必须被 scrub
4. 哪些 per-server / per-channel config 仍需单独保存
5. 配置保存后，当前运行时是否已经按这组新 truth 生效

如果把这两层压成一句“反正它已经重新 enable 了”，  
系统就会制造五类危险幻觉：

1. enabled-means-configured illusion  
   只要对象重新获得 enabled truth，就误以为配置一定已经齐全
2. return-means-secret-restored illusion  
   只要 seat 回来，就误以为旧 secrets 可以自动继续用
3. partial-save-means-full-schema-valid illusion  
   只要刚保存了一次，就误以为整套 schema 都已经满足
4. saved-means-applied illusion  
   只要配置被写入 store，就误以为当前 active world 已经按它工作
5. authority-seat-means-operable illusion  
   只要对象被重新允许存在，就误以为它已经具备可运行事实

所以从第一性原理看：

`re-entitlement governor` 决定对象还配不配拿回 authority seat；  
`reconfiguration governor` 决定这个 seat 凭什么配置真相重新工作。

## 5. `savePluginOptions()` 给出最强正例：top-level option truth 不是 enable 的尾气，而是单独的重配置主权

`pluginOptionsStorage.ts:90-193` 很硬。

这段代码至少做了四件事情：

1. 按 `schema[key].sensitive` 把值拆到 `secureStorage` 与 `settings.pluginConfigs[pluginId].options`
2. 先写 `secureStorage`，失败就先不动 `settings.json`
3. 把本次应转去另一侧的 key 从旧 store scrub 掉
4. 只 scrub 本次 save 覆盖到的 key，避免 partial reconfigure 误删其他字段

这说明 Claude Code 并不把配置视作：

`对象重新被允许之后，顺手附带的一包数据。`

相反，  
它把 config truth 当成另一套需要被精确治理的 current state：

1. secret 去哪一侧存
2. 旧 plaintext 何时必须撤销
3. schema 翻转时哪一边拥有当前真相
4. 局部重配置时哪些旧值仍可保留

继续看 `getUnconfiguredOptions():282-309` 更关键。  
它直接对保存值重新做 `validateUserConfig()`，  
只要 validation 失败，就把失败字段重新整理成 `schema slice` 返回。

这等于直接证明：

`对象已经存在`

和

`对象已经具备可用配置`

不是同一层 truth。

## 6. `saveMcpServerUserConfig()` 再证明：per-server / per-channel config 也有自己的重配置治理

`mcpbHandler.ts:141-339` 把这件事做得更完整。

先看 `loadMcpServerUserConfig():141-162`：  
它把 `settings.pluginConfigs[pluginId].mcpServers[serverName]` 与  
`secureStorage.pluginSecrets[pluginId/serverName]` 合并读取。

再看 `saveMcpServerUserConfig():193-339`：  
它把 channel/server config 的重配置主权进一步做实为：

1. `sensitive` 与 `non-sensitive` 分仓
2. 先保 secure storage，再 scrub plaintext
3. schema 从 sensitive 变 non-sensitive 时，secure side 也要 scrub
4. 只 scrub 本次 save 涉及的 key，partial reconfigure 不误伤其他字段

这套 grammar 的先进性在于它不是只问：

`对象回没回来？`

而是继续问：

`这个 server 现在到底该凭哪组 current config truth 工作？`

更强的证据在 `mcpbHandler.ts:742-757,894-902`。  
这里在 `forceConfigDialog` 或 validation 失败时直接返回：

`status: 'needs-config'`

这说明 repo 明确承认：

1. object 已经可见
2. config truth 仍未闭合
3. 这不是异常尾巴，而是一个正式状态

这就是标准的：

`re-entitlement != reconfiguration`

## 7. `PluginOptionsFlow` 与 `ManagePlugins` 把这种分层直接写进 UI grammar：`enabled` 与 `configured` 是两个 outcome

`PluginOptionsFlow.tsx:53-133` 非常值钱。

它不是“enable 之后总弹一次框”，  
而是：

1. 先用 `getUnconfiguredOptions()` 找 top-level 仍缺字段
2. 再用 `getUnconfiguredChannels()` 找 channel/server 仍缺字段
3. 如果 `steps.length === 0`，就立刻 `onDone('skipped')`
4. 只有全部 step 保存完，才 `onDone('configured')`

这说明配置对 repo 来说不是 ornament，  
而是一套明确的 decision grammar：

`有没有仍未满足 schema 的 current config truth。`

而 `ManagePlugins.tsx:1645-1668` 更直接把它翻译成用户可见句法：

1. `✓ Enabled and configured ...`
2. `✓ Enabled ...`
3. `Configuration saved. Run /reload-plugins for changes to take effect.`

一旦 UI 层已经把这三句话并列存在，  
系统就在公开承认三件事：

1. `enabled` 不是 `configured`
2. `configured` 不是单纯的 enable 附件
3. `configuration saved` 甚至还不是最后的 running effect

这不是文案细节，  
而是治理分层已经上升到了 protocol surface。

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
2. configuration persistence
3. active runtime application

偷压成同一个时刻。

换句话说，  
Claude Code 不是把“多一层步骤”当作 UX 负担，  
而是把“不同层回答不同问题”当作安全诚实性的必要代价。

## 9. 技术先进性与哲学本质：Claude Code 真正先进的地方，是它拒绝让 authority seat 冒充 config truth

从技术角度看，Claude Code 在这条线上的先进性，  
不只是它有 config dialog、secret split 或 `/reload-plugins`。

更值钱的是它已经在多个点上承认：

1. seat 可以回来，但 config 仍缺
2. config 可以部分重填，但未必全 schema 有效
3. secrets 与 plaintext 不是同一种重配置对象
4. config 已经保存，但 active world 仍待 apply
5. channel/server config 与 top-level option 不是同一条 grammar

这背后的哲学本质是：

`真正成熟的系统，不会让“被允许工作”自动冒充“知道如何工作”。`

因此对 cleanup 线最关键的技术启示不是：

`给它补 re-entitlement grammar 就够了。`

而是：

`必须同时补 re-entitlement grammar 与 reconfiguration grammar。`

否则系统会停在另一种危险的半治理状态：

`大家都知道旧对象又被允许说话了，但没人能正式回答它现在该凭哪组配置、哪组 secrets、哪组 payload 重新说话。`

## 10. 苏格拉底式自诘：我的判断有没有再次越级

为了避免把“源码里有 dialog / save / validation”直接写成“cleanup 线只差照抄插件线”，  
这里必须主动追问自己四个问题。

### 第一问

`我是不是把任何一次 save 都当成 full reconfiguration 已经完成？`

不能这样写。  
当前源码明确支持 partial reconfigure，  
并且只 scrub 本次写入涉及的 key。  
所以更稳妥的说法是：

`repo 已经把 reconfiguration 做成显式 grammar，但它允许 config truth 分步闭合，而不是假定一次保存就等于万事完成。`

### 第二问

`re-entitlement governor 和 reconfiguration governor 一定要做成两个模块吗？`

也不能这么绝对。  
它们可以由同一实现承载，  
但回答的问题不同：  
一个回答“你还配不配拿 seat”，  
一个回答“这个 seat 现在凭哪组输入工作”。

### 第三问

`如果对象只拿回很弱的 seat，也还需要 reconfiguration governance 吗？`

只要 current world 仍要求它携带 options、secrets、channel config 或 payload 才能工作，  
就至少要回答：

`这些东西哪些必须重填、哪些继续有效、哪些必须被 scrub。`

这已经是 reconfiguration 问题。

### 第四问

`我是不是把 configuration saved 偷写成 current active world 已经按它工作？`

不能这样写。  
`Configuration saved. Run /reload-plugins for changes to take effect.` 已经明确说明：

1. persistence truth
2. active application truth

仍然是两层。

所以这一章最该继续约束自己的，  
不是再去发明新的 roadmap，  
而是始终把：

`seat restored`
`config saved`
`active world applied`

当成三个不同强度的事实。

## 11. 一条硬结论

这组源码真正说明的不是：

`Claude Code 只要决定了 cleanup 旧对象回来后重新获得资格，就已经自动拥有了治理它该按哪组 options、哪组 secrets、哪组 payload 重新工作的主权。`

而是：

`repo 在 savePluginOptions、getUnconfiguredOptions、saveMcpServerUserConfig、getUnconfiguredChannels、needs-config 与 PluginOptionsFlow/ManagePlugins 的 outcome grammar 上已经明确展示了 reconfiguration governance 的存在；因此 artifact-family cleanup re-entitlement-governor signer 仍不能越级冒充 artifact-family cleanup reconfiguration-governor signer。`

再压成最后一句：

`再赋权负责让对象重新拿回资格；重配置，才负责决定它拿回资格后凭什么重新工作。`
