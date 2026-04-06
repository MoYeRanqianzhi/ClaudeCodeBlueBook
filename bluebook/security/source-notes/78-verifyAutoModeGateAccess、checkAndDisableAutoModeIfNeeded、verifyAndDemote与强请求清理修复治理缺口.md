# verifyAutoModeGateAccess、checkAndDisableAutoModeIfNeeded、verifyAndDemote与强请求清理修复治理缺口

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `227` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 有没有 anti-drift verifier，`

而是：

`一旦 drift 已经被 verifier 抓住，Claude Code 现有子系统是怎样分配 repair sovereignty 的，而 stronger-request cleanup 为什么还缺这一层。`

如果这个问题只停在主线长文里，
最容易又被压成一句空话：

`verifier 不等于 governor。`

这句话还不够硬。

所以这里单开一篇，
只盯住：

- `src/utils/permissions/permissionSetup.ts`
- `src/utils/permissions/bypassPermissionsKillswitch.ts`
- `src/utils/permissions/getNextPermissionMode.ts`
- `src/utils/plugins/dependencyResolver.ts`
- `src/utils/plugins/pluginLoader.ts`
- `src/utils/cleanup.ts`
- `src/utils/plans.ts`

把 repo 里“发现 drift”与“施加 repair consequence”如何被拆开，
以及 stronger-request cleanup 线当前尚未长出的 repair grammar，
直接对照出来。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 不会在发现 drift 后采取行动。`

而是：

`Claude Code 在别的子系统里已经清楚地区分 detection、consequence application 与 repair scope；stronger-request cleanup 线当前缺的不是风险意识，而是同等级的 repair authority 分配。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| auto-mode verification | `src/utils/permissions/permissionSetup.ts:1078-1157` | 谁负责把 stale-vs-live divergence 识别出来 |
| auto-mode consequence application | `src/utils/permissions/bypassPermissionsKillswitch.ts:74-116` | 谁负责把 verifier 结果施加到 CURRENT app state 与 notification queue |
| local precheck without repair sovereignty | `src/utils/permissions/getNextPermissionMode.ts:11-17` | 为什么 detection 可离用户动作很近，却仍不等于 repair authority |
| plugin verify/demote split | `src/utils/plugins/dependencyResolver.ts:161-233`; `src/utils/plugins/pluginLoader.ts:3189-3195` | 为什么 repo 已显式拥有 verify + governance consequence + scope grammar |
| cleanup repair gap | `src/utils/cleanup.ts:33-45,575-597`; `src/utils/plans.ts:79-110`; `src/utils/cleanup.ts:300-303` | 为什么 stronger-request cleanup 线当前还没有对等 repair-governor plane |

## 4. auto-mode 先证明：repo 已经知道 verifier 只配“发现问题”，不配自己偷偷改世界

`permissionSetup.ts:1078-1157` 的 `verifyAutoModeGateAccess()` 已经很强，
它会：

1. fresh read dynamic config
2. 重新解释 circuit-breaker truth
3. 产出 `updateContext`
4. 产出 `notification`

但它仍然没有直接去：

1. 改写 app state
2. 推送 notification queue
3. 把 repair consequence 应用到 CURRENT world

这些治理后果被明确放到了：

`bypassPermissionsKillswitch.ts:74-116`

的 `checkAndDisableAutoModeIfNeeded()`。

更值钱的是，
这段 consequence application 还显式强调：

`Apply the transform to CURRENT context, not the stale snapshot`

这说明 repo 在这里的治理哲学非常清楚：

`不仅 verifier 可能面对 stale state，repair application 自己也可能因为异步等待而漂。`

所以 repo 连 consequence application 本身都被当成一类受治理对象。

## 5. `getNextPermissionMode` 再说明：就算 detection 离用户动作非常近，它也仍然不自动拥有 repair authority

`getNextPermissionMode.ts:11-17` 做的事情很窄：

1. 承认 cached truth 与 live gate 会 diverge
2. 在 local cycle 前避免错误 transition
3. 把 divergence 写进 debug trace

它不会决定：

1. 动态 config 要不要改
2. circuit breaker 是否继续存在
3. notification 应否出现
4. 作用域应否扩大到持久状态

这进一步说明：

`检测离动作再近，也不等于自动拥有 repair sovereignty。`

## 6. plugin 线给出更硬正例：`verifyAndDemote` 已经把 verification、consequence 与 scope 正式写进一个成熟 grammar

`dependencyResolver.ts:161-233`
最值钱的地方就在于命名和注释：

1. `verifyAndDemote`
2. fixed-point loop
3. does NOT mutate input
4. returns set of plugin IDs to demote plus errors

这说明 repo 已经显式承认：

1. verify 是一层
2. demote consequence 是一层
3. consequence 结果需要被独立传给后续 loader 消费

而
`pluginLoader.ts:3189-3195`
又进一步把 consequence scope 钉死为：

1. `if (demoted.has(p.source)) p.enabled = false`
2. `Demotion is session-local`
3. `does NOT write settings`

这里的技术含量在于，
repair governance 被具体拆成了三个问题：

1. 改变哪一层 truth
2. 持续多久
3. 哪一层绝不能被静默触碰

这正是 stronger-request cleanup 当前缺的东西。

## 7. 对照这些正例，stronger-request cleanup 当前尚未回答的不是“哪里 drift”，而是“谁来决定修哪一层”

stronger-request cleanup 当前已知至少有四类 drift：

1. temporal drift  
   startup wording 强于 actual scheduler timing
2. propagation drift  
   `plansDirectory` 被部分 plane 消费、未被 executor plane 跟随
3. receipt drift  
   `CleanupResult` 未升格成 surfaced family receipt
4. abstention drift  
   validation-error skip 当前只在 local logging / return path 上成立

但当前仍没有一处可见代码正式决定：

1. temporal drift 该修 scheduler，还是改 wording
2. propagation drift 该修 executor，还是限制 override semantics
3. receipt drift 该补 receipt surface，还是缩小 conformance promise
4. abstention drift 该改 executor，还是只提升 explainability layer

这些问题都不是 verifier 自己能回答的。

它们已经进入：

`repair governance`

层。

## 8. 这组源码给出的技术启示

Claude Code 的多重安全技术真正先进的地方，
不是“它有很多安全检查”，
而是：

`它把检查后的 consequence application 也当成受治理对象。`

这组源码给出的稳定技术启示至少有四条：

1. verifier 输出不能直接信任 stale snapshot，repair application 必须对 CURRENT state 生效
2. repair consequence 必须有 scope grammar，否则修复很容易越权污染持久 user intent
3. session-local demotion 是成熟 repair governance 的重要模式，因为它允许系统先恢复安全，再把 intent 修复交还给显式用户路径
4. cleanup 线如果以后要长出 repair-governor plane，关键不只是“多写一个修复函数”，而是明确 repair 作用在哪个 plane、持续多久、不能触碰哪层 truth

## 9. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 只要把 verifier 补出来，剩下的治理问题就会自然解决。`

而是：

`repo 在 auto-mode 与 plugin 两条线上已经明确展示了 detection、consequence application 与 repair scope 的分层治理；stronger-request cleanup 线当前缺的正是这种 repair-governor plane。`

因此：

`artifact-family cleanup stronger-request cleanup-anti-drift-verifier signer` 仍不能越级冒充 `artifact-family cleanup stronger-request cleanup-repair-governor signer`。

再压成一句：

`cleanup 线现在缺的不是“知道哪里错了”，而是“谁有权决定怎样改世界才算修对”。`
