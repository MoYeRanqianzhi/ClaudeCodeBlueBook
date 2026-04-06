# 安全载体家族重配置治理与重新激活治理分层：为什么artifact-family cleanup reconfiguration-governor signer不能越级冒充artifact-family cleanup reactivation-governor signer

## 1. 为什么在 `169` 之后还必须继续写 `170`

`169-安全载体家族再赋权治理与重配置治理分层` 已经回答了：

`cleanup 线即便以后长出 reconfiguration governor，也还需要一层正式主权去决定旧对象拿回 seat 后按哪组 current config truth 重新工作。`

但如果继续往下追问，
还会碰到另一层很容易被误写成“配置写好了就说明当前运行世界已经按它工作了”的错觉：

`只要 reconfiguration governor 已经决定了 current options、current secrets、current payload，它就自动拥有了决定这些 truth 何时进入 active session、何时真的接管 commands / agents / hooks / MCP / LSP 的主权。`

Claude Code 当前源码同样不能支持这种更强说法。

因为继续看：

1. `src/utils/plugins/refresh.ts:1-177` 的 `Layer-3 refresh primitive`
2. `src/commands/reload-plugins/reload-plugins.ts:10-56` 的 `take effect` grammar
3. `src/services/plugins/PluginInstallationManager.ts:50-180` 的 `new installs auto-refresh / updates only -> needsRefresh`
4. `src/hooks/useManagePlugins.ts:25-35,287-303` 的 `Do NOT auto-refresh`
5. `src/commands/plugin/ManagePlugins.tsx:1645-1668,1700-1707` 的 `Configuration saved. Run /reload-plugins for changes to take effect.`
6. `src/cli/print.ts:1733-1765,1881-1910` 与 `src/state/AppStateStore.ts:209-214` 的 headless auto-consume path

会发现 repo 已经清楚展示出：

1. `reconfiguration governance` 负责决定当前配置真相是什么
2. `reactivation governance` 负责决定这组真相何时真正进入 current active world

也就是说：

`artifact-family cleanup reconfiguration-governor signer`

和

`artifact-family cleanup reactivation-governor signer`

仍然不是一回事。

前者最多能说：

`对象现在该按哪组 current config truth 工作。`

后者才配说：

`这组 current config truth 现在是否已经真正接管运行中的 current session。`

所以 `169` 之后必须继续补的一层就是：

`安全载体家族重配置治理与重新激活治理分层`

也就是：

`reconfiguration governor 负责改写 current config truth；reactivation governor 才负责决定这组 truth 何时真正进入 active world。`

## 2. 先做一条谨慎声明：`artifact-family cleanup reactivation-governor signer` 仍是研究命名，不是源码现成类型

这里同样要先讲清楚：

`Claude Code 当前源码里并没有一个字面存在的类型叫 artifact-family cleanup reactivation-governor signer。`

这里的 `artifact-family cleanup reactivation-governor signer` 仍是研究命名。
它不是在声称 cleanup 线已经有一个未公开的 reactivation manager，
而是在说：

1. repo 已经把 Layer 3 明确命名为 active components world
2. repo 已经把 `Configuration saved` 与 `take effect` 拆开
3. repo 已经把 interactive mode、background install 与 headless mode 的激活路径做成不同制度

因此 `170` 不是在虚构已有实现，
而是在给更深的一层缺口命名：

`会重配置，不等于会重新激活。`

## 3. 最短结论

Claude Code 当前源码至少给出了五类“reconfiguration-governor signer 仍不等于 reactivation-governor signer”证据：

1. `ManagePlugins.tsx` 明确写出 `Configuration saved. Run /reload-plugins for changes to take effect.`；这说明 config persistence 不自动等于 active effect
2. `refresh.ts` 直接把 `refreshActivePlugins()` 命名为 `Layer-3 refresh primitive: swap active plugin components in the running session`；这说明 running-session reactivation 是单独 chokepoint
3. `useManagePlugins.ts` 明确写出 `Do NOT auto-refresh`、`Do NOT reset needsRefresh`；interactive mode 下，配置改写后是否进入 active world 是独立主权
4. `PluginInstallationManager.ts` 区分 `new installs -> auto-refresh` 与 `updates only -> needsRefresh`；这说明即便底层改动同属 plugin changes，reactivation policy 也不是统一自动发生
5. `print.ts` 与 `AppStateStore.ts` 又展示了另一条正例：headless mode 可在 `before first ask()` 自动 `refreshPluginState()`，说明 reactivation governance 可以按运行模式单独分配

因此这一章的最短结论是：

`reconfiguration governor 最多能说当前配置真相已经改写；reactivation governor 才能说这组真相是否已经真正成为 running session truth。`

再压成一句：

`配置写好了，不等于已经重新生效。`

## 4. 第一性原理：reconfiguration governance 回答“现在该按哪组 truth 工作”，reactivation governance 回答“这组 truth 何时真正接管当前世界”

从第一性原理看，
重配置治理与重新激活治理处理的是两个不同主权问题。

reconfiguration governor 回答的是：

1. 哪些 options / secrets / payload 属于当前真相
2. 哪些值必须被 scrub
3. 哪些 channel/server config 仍算缺失
4. 哪些 store 持有 current truth
5. schema 当前是否已经闭合

reactivation governor 回答的则是：

1. 这组 truth 是否已经进入 running session
2. 哪个时刻触发 active component swap
3. commands / agents / hooks / MCP / LSP 是否已按新 truth 重载
4. interactive / background / headless 各自采用哪种激活策略
5. stale active world 何时失效、何时被 current world 接管

如果把这两层压成一句“反正配置已经保存”，
系统就会制造五类危险幻觉：

1. saved-means-live illusion
   只要配置落盘，就误以为当前 session 已按它运行
2. disk-change-means-active-swap illusion
   只要磁盘世界变化，就误以为 active components 已被替换
3. one-policy-fits-all-modes illusion
   误以为 interactive、background、headless 必须用同一激活制度
4. schema-valid-means-running-valid illusion
   只要 config grammar 成立，就误以为 runtime grammar 也已闭合
5. notification-means-reactivation illusion
   只要系统发了“changes detected”提示，就误以为激活已经完成

所以从第一性原理看：

`reconfiguration governor` 决定当前 truth 长什么样；
`reactivation governor` 决定这组 truth 何时真正成为 current active world。

## 5. `ManagePlugins` 先证明：`Configuration saved` 与 `take effect` 被明确写成两层事实

`ManagePlugins.tsx:1645-1668,1700-1707` 很硬。

这段代码至少并列暴露了三种不同句法：

1. `✓ Enabled and configured ... Run /reload-plugins to apply.`
2. `✓ Enabled ... Run /reload-plugins to apply.`
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

`saved`

之后还需要：

`take effect`

从 cleanup 研究角度看，
这条 distinction 非常关键。
因为将来旧 path、旧 promise、旧 receipt 即便已经完成 reconfiguration，
也仍不自动说明：

`当前运行世界已经按这组新 truth 接管。`

## 6. `refreshActivePlugins()` 再证明：running-session reactivation 是单独的 Layer-3 主权

`refresh.ts:1-177` 几乎把这件事明写出来了。

文件头第一句就是：

`Layer-3 refresh primitive: swap active plugin components in the running session.`

随后又把 world 显式分成三层：

1. Layer 1: intent
2. Layer 2: materialization
3. Layer 3: active components

这等于直接证明：

`config truth 已经被写好`

并不自动等于

`running session 已经接管这组 truth`

更强的是 `refreshActivePlugins():72-190` 实际做的事情：

1. `clearAllCaches()`
2. `clearPluginCacheExclusions()`
3. 重新 `loadAllPlugins()`
4. 重建 commands / agents
5. 重新填充 MCP / LSP cache slot
6. 写回 `AppState.plugins`
7. 清空 `needsRefresh`
8. bump `mcp.pluginReconnectKey`
9. `reinitializeLspServerManager()`
10. `loadPluginHooks()`

这已经不是“重读一下配置”而已。
它是完整的 active-world reactivation choreography。

这说明 reactivation governance 的本体不是：

`承认哪组 truth 对`

而是：

`什么时候允许当前 session 从旧 active world 切换到新 active world。`

## 7. `useManagePlugins` 与 `PluginInstallationManager` 给出更强制度证据：reactivation policy 会随场景变化

`useManagePlugins.ts:25-35,287-303` 写得很直白：

1. initial mount 是 initial Layer-3 load
2. post-mount refresh 统一走 `/reload-plugins -> refreshActivePlugins()`
3. `needsRefresh` 只发通知
4. `Do NOT auto-refresh`
5. `Do NOT reset needsRefresh`

这说明在 interactive mode 下，
repo 明确拒绝把：

`detected config change`

直接偷写成：

`already reactivated`

`PluginInstallationManager.ts:50-180` 又给出第二组强证据：

1. `new installs -> auto-refresh plugins`
2. `updates only -> set needsRefresh`
3. auto-refresh 失败再 fallback 到 `needsRefresh`

这说明 even within plugin world，
reactivation governance 也不是单一自动规则。
它会继续问：

1. 这次变化属于新 install 还是 update
2. 当前场景更适合自动接管还是延后到用户明确触发
3. auto path 失败后谁来兜底

从技术角度看，这非常先进。
它承认：

`same reconfiguration fact`

在不同 operational context 里，
可以对应不同的 reactivation authority。

## 8. headless 路径给出第三个正例：reactivation governance 甚至会因运行模式不同而切换制度

`print.ts:1733-1765,1881-1910` 与 `AppStateStore.ts:209-214` 非常值钱。

这里写得很清楚：

1. `CLAUDE_CODE_SYNC_PLUGIN_INSTALL=true` 时，installation 会在 first ask 之前 resolve
2. resolve 后显式调用 `refreshPluginState()`
3. `refreshPluginState()` 再调用 `refreshActivePlugins()`
4. `AppStateStore` 注释明确写出：interactive mode 用户手动 `/reload-plugins` 消费；headless mode 由 `refreshPluginState()` auto-consume

这说明 repo 已经公开承认：

`reactivation policy is mode-sensitive`

也就是说：

1. interactive mode: explicit user-initiated reactivation
2. headless sync mode: auto reactivation before first query

这里最值钱的技术启示是：
系统并没有因为两边都最终走 `refreshActivePlugins()`，
就假装这两边拥有同一套 activation sovereignty。

相反，
它把：

`谁来触发 reactivation`

继续单独分配给了 mode-specific governance。

## 9. 技术先进性与哲学本质：Claude Code 真正先进的地方，是它拒绝让 persisted truth 自动篡位成 running truth

从技术角度看，Claude Code 在这条线上的先进性，
不只是有 `/reload-plugins` 命令。

更值钱的是它已经在多个点上承认：

1. persisted config truth 不是 running truth
2. Layer 3 是独立 control plane
3. interactive / background / headless 的激活制度可以不同
4. notification、state flag 与 active swap 不是同一件事
5. stale active world 需要显式接管，而不是默认自然消失

这背后的哲学本质是：

`真正成熟的系统，不会让“现在应该如此”自动冒充“当前世界已经如此”。`

因此对 cleanup 线最关键的技术启示不是：

`给它补 reconfiguration grammar 就够了。`

而是：

`必须同时补 reconfiguration grammar 与 reactivation grammar。`

否则系统会停在另一种危险的半治理状态：

`大家都知道旧对象已经按新 truth 被重写了，但没人能正式回答：当前运行世界现在到底还是旧的，还是已经被新的接管。`

## 10. 苏格拉底式自诘：我的判断有没有再次越级

为了避免把“源码里有 refresh 函数 / reload 命令”直接写成“cleanup 线只差照抄插件线”，
这里必须主动追问自己四个问题。

### 第一问

`我是不是把任何 “saved” 都当成了 “active”？`

不能这样写。
当前源码已经公开把 `saved` 与 `take effect` 分成两层。

### 第二问

`reconfiguration governor 和 reactivation governor 一定要做成两个模块吗？`

也不能这么绝对。
它们可以由同一实现承载，
但回答的问题不同：
一个回答“现在该按哪组 truth”，
一个回答“这组 truth 现在是否已经接管 active world”。

### 第三问

`headless auto-consume 是否说明这两层其实没有边界？`

不能这样写。
它恰恰说明：

`同一个 Layer-3 primitive，可以被不同模式下的不同 authority trigger。`

这不是边界消失，
而是边界被更清楚地制度化。

### 第四问

`我是不是把 notification、needsRefresh flag 与 refreshActivePlugins 混成了同一个事件？`

不能这样写。
通知只是在说：

`active world is stale`

而 `refreshActivePlugins()` 才是在做：

`swap active world`

所以这一章最该继续约束自己的，
就是始终把：

`config rewritten`
`active world stale`
`active world reactivated`

当成三个不同强度的事实。

## 11. 一条硬结论

这组源码真正说明的不是：

`Claude Code 只要决定了 cleanup 旧对象回来后按哪组 current config truth 重新工作，就已经自动拥有了治理这组 truth 何时真正进入 running session 的主权。`

而是：

`repo 在 refreshActivePlugins 的 Layer-3 grammar、/reload-plugins 的 take-effect contract、useManagePlugins 的 needsRefresh discipline、PluginInstallationManager 的 mode-sensitive refresh policy 与 print.ts 的 headless auto-consume path 上已经明确展示了 reactivation governance 的存在；因此 artifact-family cleanup reconfiguration-governor signer 仍不能越级冒充 artifact-family cleanup reactivation-governor signer。`

再压成最后一句：

`重配置负责改写真相；重新激活，才负责让这组真相真正接管当前世界。`
