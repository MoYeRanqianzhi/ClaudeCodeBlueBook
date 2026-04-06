# 安全载体家族反漂移验证与修复治理分层：为什么artifact-family cleanup anti-drift verifier signer不能越级冒充artifact-family cleanup repair-governor signer

## 1. 为什么在 `162` 之后还必须继续写 `163`

`162-安全载体家族运行时符合性与反漂移验证分层` 已经回答了：

`cleanup 线即便某次运行看起来符合，也还不等于系统已经具备长期 anti-drift verification。`

但如果继续往下追问，  
还会碰到下一层更容易被偷写成同一动作的错觉：

`只要 verifier 已经发现 drift，它就等于自动拥有了修复主权。`

Claude Code 当前源码仍然不能支持这种更强的说法。

因为继续看 `permissions/permissionSetup.ts`、`permissions/bypassPermissionsKillswitch.ts`、`permissions/getNextPermissionMode.ts`、`plugins/dependencyResolver.ts`、`plugins/pluginLoader.ts`，再对照 `cleanup.ts`、`plans.ts`、`backgroundHousekeeping.ts` 会发现：

1. repo 在别的子系统里已经把“发现 divergence”和“决定如何修复/降级/封禁”拆成了不同层
2. cleanup 线当前仍缺这条更高阶分工
3. 也就是说，`anti-drift verifier` 与 `repair governor` 仍不是同一角色

这说明：

`artifact-family cleanup anti-drift verifier signer`

和

`artifact-family cleanup repair-governor signer`

仍然不是一回事。

前者最多能说：

`这里已经 drift 了，或者现在缺少足够的证据证明它没有 drift。`

后者才配说：

`面对这个 drift，系统应该修 metadata、修 scheduler、修 executor、修 permission plane，还是修改文案、降低承诺、直接熔断某条 capability。`

所以 `162` 之后必须继续补的一层就是：

`安全载体家族反漂移验证与修复治理分层`

也就是：

`artifact-family cleanup anti-drift verifier signer 只能发现和揭露 drift；artifact-family cleanup repair-governor signer 才能决定如何修、修到哪一层、代价由谁承担。`

## 2. 先做一条谨慎声明：`artifact-family cleanup repair-governor signer` 仍是研究命名，不是源码现成类型

这里同样要先讲清楚：

`Claude Code 当前源码里并没有一个字面存在的类型叫 artifact-family cleanup repair-governor signer。`

这里的 `artifact-family cleanup repair-governor signer` 仍然只是研究命名。  
它不是在声称仓库里已有一套 cleanup governor 接口只差文档，  
而是在说：

1. repo 的其他子系统已经展示出 verification 与 remediation / demotion / circuit-breaking 并不相同
2. cleanup 线今天真正缺的不是“有没有 bug”，而是 drift 一旦被 verifier 报警后，谁来行使 repair governance
3. 所以更高阶的问题已经不是“谁来发现 drift”，而是“发现以后谁来做制度性处置”

因此 `163` 不是在虚构已有实现，  
而是在给另一个真实缺口命名：

`发现问题，不等于拥有修问题的主权。`

## 3. 最短结论

Claude Code 当前源码至少给出了六类“anti-drift verifier signer 仍不等于 repair-governor signer”证据：

1. `verifyAutoModeGateAccess()` 负责发现 stale-vs-live divergence，  
   但真正把结果应用到 app state、通知用户、踢出模式的是别的层  
   `permissionSetup.ts:1078-1150`  
   `bypassPermissionsKillswitch.ts:74-107`
2. `getNextPermissionMode.ts:7-17` 只负责在本地模式切换前承认 divergence 风险，  
   它并不拥有“禁用 auto mode”这类治理主权
3. plugin 线里 `verifyAndDemote(...)` 的命名本身就把 verifier 与 demotion governance 分开了  
   `dependencyResolver.ts:177-233`  
   `pluginLoader.ts:3192-3194`
4. `microCompact` 的 test 只负责抓 drift，  
   并不决定一旦失败后该回滚派生值、改 source-of-truth，还是改断言
5. cleanup 线当前连 verifier 都还没完全显式化，  
   更没有谁正式决定 plans propagation gap 应修 executor、修 metadata，还是降级 `plansDirectory` 承诺
6. 因此 cleanup 线今天最缺的不是又一个 detector，  
   而是 drift 报警后的 repair governance grammar

因此这一章的最短结论是：

`verifier signer 最多能说“这里不对了”；repair-governor signer 才能说“该由哪一层付出代价把它重新拉回正确世界”。`

再压成一句：

`发现偏离，不等于拥有纠偏主权。`

## 4. 第一性原理：verifier 回答“哪里错了”，repair governor 回答“谁来承担修复代价”

从第一性原理看，  
verifier 与 repair governor 处理的是两类根本不同的问题。

verifier 回答的是：

1. 有没有 drift
2. drift 在哪一层
3. 证据是否充分
4. 当前是否应拒绝继续宣称“没问题”
5. 哪些 truth 已经分叉

repair governor 回答的则是：

1. 应该修 metadata，还是修 runtime
2. 应该修 scheduler，还是修 executor
3. 应该扩大 receipt，还是缩小文案承诺
4. 应该做兼容迁移，还是立即熔断
5. 修复成本由哪个 control plane 承担

如果把这两层压成一句“检测到问题就修”，  
系统就会制造五类危险幻觉：

1. detection-means-authority illusion  
   能发现问题，就误以为自动拥有修复主权
2. failing-check-means-obvious-fix illusion  
   测试一红，就误以为修哪一层是不言自明的
3. stronger-promise-means-keep-promise-at-all-costs illusion  
   文案已经写强了，就误以为只能修执行器，不能考虑降级承诺
4. one-gap-one-fix illusion  
   看见一处 drift，就误以为只对应一个局部代码修复
5. verifier-neutrality illusion  
   误以为 verifier 发现的结果天然中立，不会隐含治理方向选择

所以从第一性原理看：

`verifier` 是 truth exposure；  
`repair governor` 是 repair sovereignty。

## 5. `verifyAutoModeGateAccess` 与 `checkAndDisableAutoModeIfNeeded` 先给出一个非常强的正例：发现 divergence 和做治理处置已经被显式拆层

`permissions/permissionSetup.ts:1078-1150` 的 `verifyAutoModeGateAccess()` 负责：

1. 读 fresh config
2. 对比 stale cache 与 live gate
3. 产出 `updateContext` 与 `notification`

这已经是一位典型的 verifier。

但真正的治理处置并不在这里结束。  
`permissions/bypassPermissionsKillswitch.ts:74-107` 的 `checkAndDisableAutoModeIfNeeded()` 会：

1. 调用 `verifyAutoModeGateAccess()`
2. 把结果真正应用到 current app state
3. 决定是否发出高优先级 notification
4. 决定用户是否还留在这个 mode world

这说明 repo 已经明确知道：

`verify`

和

`apply governance consequence`

不是同一个动作。

也就是说：

`verifier` 先告诉你真相，  
`governor` 再决定真相出现后应如何改变世界。

cleanup 线今天正好缺的就是这第二步。

## 6. `getNextPermissionMode` 再说明：有些 verifier 甚至只负责在切换前揭露风险，仍不配决定最终治理策略

`permissions/getNextPermissionMode.ts:7-17` 很关键。  
它明确写出：

`cached isAutoModeAvailable` 与 live `isAutoModeGateEnabled()` `can diverge`

于是它在本地 cycle 逻辑里做的只是：

1. 同时检查 cached 与 live gate
2. 如果不一致，就不允许继续无脑切过去
3. 记录 reason

但它并不拥有：

1. 修改 dynamic config
2. 解除 circuit breaker
3. 决定用户应该收到哪种 remediation
4. 决定是否要降级整个 feature promise

这说明 even when verification is inline,  
它也仍然不等于 repair governance。

cleanup 线若未来长出 `verifyCleanupPolicyAlignment()`，  
也同样不应自动拥有：

`修 metadata 还是修 executor`

这种更高阶主权。

## 7. plugin 线给出第二个更硬的正例：`verifyAndDemote` 这个命名本身就证明 verifier 与治理后果可以并列，但仍不是同一件事

`plugins/dependencyResolver.ts:177-233` 暴露出一个很有价值的命名：

`verifyAndDemote`

它至少说明两件事：

1. 先有 `verify`  
   发现 dependency truth 是否成立
2. 再有 `demote`  
   决定不再让某些 plugin 继续保持 enabled status

`pluginLoader.ts:3192-3194` 还会真正消费这个结果：

`if (demoted.has(p.source)) p.enabled = false`

这说明 repo 里已经存在另一种成熟修复治理语法：

`verification result -> governance consequence -> capability state update`

cleanup 线现在缺的，  
恰恰不是再多一处注释说明 drift 很危险，  
而是：

`当 drift 被 verifier 暴露时，到底谁配 demote promise、disable path、gate feature，或要求新的 receipt 才能重新宣称安全。`

## 8. 对照这些正例，cleanup 线今天最缺的不是再证明 drift，而是修复主权应如何分层

`162` 已经把 cleanup 线的 drift 风险钉得足够清楚：

1. `cleanupPeriodDays=0` 有 temporal gap
2. `plansDirectory` 有 propagation gap
3. `CleanupResult` 有 receipt gap

但现在仍没有一处代码回答：

1. 若 temporal gap 被认为过强，  
   是该修 scheduler，还是把文案从 `deleted at startup` 降级成 `scheduled for startup housekeeping`
2. 若 propagation gap 持续存在，  
   是该让 executor 跟随 `plansDirectory`，还是限制 `plansDirectory` 的治理范围
3. 若 receipt gap 被视为不可接受，  
   是该增强 `CleanupResult` surface，还是降低系统对 cleanup conformance 的自我描述

这三类问题都不是 verifier 自己能回答的。  
它们已经进入：

`repair governance`

层。

所以 `163` 的核心判断就是：

`cleanup 线真正缺的不只是 verifier grammar，而是 verifier 触发后由谁行使治理性修复主权。`

## 9. 技术先进性：Claude Code 真正先进的不是“检测器很多”，而是它在别处已经承认“发现问题”和“改变世界”必须分层

从技术角度看，Claude Code 在这条线上真正先进的地方，不是它检测器多。  
更值钱的是它已经在别处承认：

1. `verifyAutoModeGateAccess()` 不是 `checkAndDisableAutoModeIfNeeded()`
2. stale-vs-live divergence 暴露后，还要有 app-state governance
3. dependency verification 之后，还要有 demotion consequence

这背后的设计启示非常强：

`成熟系统不是把 detection 和 remediation 混在一个函数里，而是让 truth exposure 与 authority exercise 各自有边界。`

也正因如此，  
cleanup 线今天更该继续向这个方向补课：

1. verifier 负责暴露 drift
2. repair governor 负责决定修复策略
3. receipt / documentation plane 负责更新承诺语言

## 10. 哲学本质：真正成熟的真相治理，不只要会揭露失真，还要会分配修复责任

`162` 的哲学本质是：

`真相必须能持续自校。`

`163` 的哲学本质则更进一步：

`真相一旦发现自己偏离，还必须知道谁来负责拉回。`

也就是说，  
成熟系统最终必须长出四层能力：

1. 说出规则
2. 证明当前执行
3. 持续校正漂移
4. 对漂移后的修复主权做清晰分配

只要第四层缺失，  
系统就还会停留在一种危险的半治理状态：

`它知道自己出了问题，但没人被正式授权决定怎么修。`

所以 `163` 的哲学要点不是官僚化，  
而是提醒一个更硬的原则：

`没有修复主权分配的验证，最终只会把告警堆成新的噪音。`

## 11. 苏格拉底式自诘：我的判断有没有再次越级

为了避免把“cleanup 线现在还缺 repair governor”直接写成“repo 当前没有治理能力”，  
这里必须主动追问自己四个问题。

### 第一问

`我是不是把“verifier 不等于 governor”误写成了两者必须永远完全分离？`

不能这样写。  
更谨慎的说法是：

`两者可以在某些小系统里被同一模块持有，但它们在逻辑上回答的问题不同，因此不应被默认偷写成同一层。`

### 第二问

`我是不是把 auto-mode / plugin 的例子直接等同于 cleanup 线本体？`

也不能这样写。  
这些例子不是证明 cleanup 应逐字复制它们，  
而是证明 repo 已经存在“验证”和“治理后果”分层的文化与模式。

### 第三问

`如果 verifier 很强，真的还需要单独 repair governor 吗？`

仍然需要。  
因为 verifier 只会告诉你：

`哪里错了`

它不会自然告诉你：

`应修改规则、修改执行器、修改承诺语言，还是直接熔断 feature`

这些都是治理选择。

### 第四问

`我真正该继续约束自己的是什么？`

是这句：

`不要把 repair loci 已经可枚举，误写成 repair authority 已经被正式分配。`

当前更稳妥的说法只能是：
verifier 能告诉你 drift 出现了，
但它不会自然告诉你应修改规则、修改执行器、修改承诺语言，还是直接熔断 feature。

因此本章能成立的是：

`verification != repair governance`

不能偷加的 stronger claim，
则是：

`repo 已经把 cleanup repair authority 明确挂到了某个现成 control plane 上。`

## 12. 一条硬结论

这组源码真正说明的不是：

`Claude Code 只要补出 cleanup anti-drift verifier，就已经自动具备了完整的 cleanup 治理能力。`

而是：

`repo 在其他子系统里已经明确把 verification 与 governance consequence 分层；因此 artifact-family cleanup anti-drift verifier signer 仍不能越级冒充 artifact-family cleanup repair-governor signer。`

再压成最后一句：

`验证负责揭露偏离；治理，才负责决定谁为纠偏付账。`
