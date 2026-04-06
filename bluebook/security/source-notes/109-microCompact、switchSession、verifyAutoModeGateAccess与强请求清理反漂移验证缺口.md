# microCompact、switchSession、verifyAutoModeGateAccess与强请求清理反漂移验证缺口

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `258` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 当前这次有没有 runtime-conform，`

而是：

`Claude Code 自己已经掌握了哪些成熟 verifier 技术，而 stronger-request cleanup 为什么仍停在“符合性控制簇”而不是“反漂移验证簇”。`

如果这个问题只停在主线长文里，
最容易再次被压成一句抽象判断：

`cleanup 缺 verifier。`

这句话不够硬。

所以这里单开一篇，
只盯住：

- `src/services/compact/microCompact.ts`
- `src/bootstrap/state.ts`
- `src/utils/permissions/getNextPermissionMode.ts`
- `src/utils/permissions/permissionSetup.ts`
- `src/utils/sessionStorage.ts`
- `src/utils/backgroundHousekeeping.ts`
- `src/utils/cleanup.ts`
- `src/utils/plans.ts`
- `src/utils/diagLogs.ts`

把 repo 已经显性写出的三种 anti-drift 正例，
和 stronger-request cleanup 当前仍停留在 conformance cluster 的状态，
直接对照出来。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 不知道什么叫 drift。`

而是：

`Claude Code 很知道什么叫 drift，而且已经在别处做出了测试型、结构型与运行时重验证型三种 anti-drift verifier；stronger-request cleanup 线今天真正缺的，不是风险意识，而是把同等级 verifier grammar 正式接上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| source-of-truth test verifier | `src/services/compact/microCompact.ts:32-36` | 为什么 repo 已承认 derived truth 必须被拉回 source truth |
| atomic anti-drift structure | `src/bootstrap/state.ts:456-466` | 为什么 repo 已承认某些 pairwise state 关系必须从结构上防漂移 |
| live re-verification | `src/utils/permissions/getNextPermissionMode.ts:11-17`; `src/utils/permissions/permissionSetup.ts:1078-1157` | 为什么 repo 已承认 stale cache 与 live truth 会分叉，因此需要 fresh read 与当前上下文修正 |
| stronger-request cleanup conformance cluster | `src/utils/sessionStorage.ts:954-969`; `src/utils/backgroundHousekeeping.ts:31-80`; `src/utils/cleanup.ts:33-45,575-597`; `src/utils/plans.ts:79-110`; `src/utils/cleanup.ts:300-303`; `src/utils/diagLogs.ts:11-20,27-60` | 为什么 cleanup 线当前仍主要是在表达 conformance symptom，而不是 verifier grammar |

## 4. `microCompact` 先证明：真正成熟的 verifier 会把“源真相”和“派生真相”直接绑进 source-of-truth culture

`microCompact.ts:32-36` 的注释非常值钱：

`Drift is caught by a test asserting equality with the source-of-truth.`

这句话同时承认了四件事：

1. 有 source truth
2. 有 derived truth
3. drift 是预期风险
4. verifier 必须显式做出来

也就是说，
repo 在这里根本没有把 drift 当成“偶尔才会发生的低概率事故”，
而是把它当成设计时必须被制度化的工程现实。

这就是第一种成熟 verifier grammar：

`drift is expected -> test is explicit`

而 stronger-request cleanup 当前更像：

`drift is visible -> verifier is still inferred`

## 5. `switchSession` 再证明：有些 drift 不该留给测试补，而应被 atomic structure 直接封死

`state.ts:456-466` 把 `sessionId` 与 `sessionProjectDir` 的关系写得非常彻底：

`always change together`

`cannot drift out of sync`

这里的先进性在于，
它没有满足于“以后加个校验”。
它更进一步问：

`这种 drift 是否连表达机会都不该被允许存在。`

于是 `switchSession(sessionId, projectDir)` 的存在，
就把某类 drift 直接从状态机语法里删除了。

这就是第二种成熟 verifier grammar：

`structure forbids drift`

对 stronger-request cleanup 来说，
这条启示非常重要，
因为今天 cleanup 的 metadata、scheduler、executor、coverage 与 receipt 仍可半独立变化，
所以 drift 仍有表达机会。

## 6. `verifyAutoModeGateAccess` 再证明：更高阶的 verifier 会主动复核 stale-vs-live divergence，而不是等用户先踩坑

`getNextPermissionMode.ts:11-17` 已经明说：

`cached isAutoModeAvailable`

与

`live isAutoModeGateEnabled()`

会 diverge。

而 `permissionSetup.ts:1078-1157` 不是只写一段解释注释就算完，
它真的做了三件事：

1. fresh read dynamic config
2. 更新 circuit-breaker truth
3. 返回一个对 CURRENT context 生效的 transform，防止异步等待期间把旧模式写回当前世界

这不是普通的 guard，
而是非常成熟的运行时 verifier 设计：

`承认 stale/live 会分叉 -> 当场 fresh read -> 再对当前世界做修正`

这就是第三种成熟 verifier grammar：

`live re-verification against divergence`

## 7. 与这三种正例对照，stronger-request cleanup 当前暴露出的不是“偶发 bug”，而是 verifier grammar 还没接线

stronger-request cleanup 当前当然不是毫无控制。

它已经有：

1. `shouldSkipPersistence()`
   把 `cleanupPeriodDays=0` 先兑现成 future-write suppression
2. `backgroundHousekeeping`
   把 cleanup 执行放进 delayed admission / reschedule world
3. `cleanupOldMessageFilesInBackground()`
   在 validation errors + explicit `cleanupPeriodDays` 时 deliberate skip
4. `CleanupResult`
   把局部 outcome 变成可计数对象
5. `diagLogs`
   把 host-visible diagnostics truth 明确写成 no-PII env contract

这些机制都是真实的安全设计，
而且已经很有层次。

但它们的共同边界也很清楚：

`它们在表达当前 runtime 做了什么，却还没有表达未来若再漂移谁会主动报警。`

最典型样本就是 `plansDirectory`。

`plans.ts:79-110` 已经把 plans truth 提升成正式 metadata knob，
而 `cleanup.ts:300-303` 却仍让 `cleanupOldPlanFiles()` 只扫默认 `~/.claude/plans`。

`diagLogs.ts` 又给出另一种平行样本：

1. diagnostics truth 明确存在
2. writer contract 清楚
3. 但 visible cleanup dispatcher 根本不覆盖它

这说明 strongest drift 不是：

`系统没有 policy`

而是：

`policy 已进入某些 plane，但没有 verifier 持续检查 executor plane 与 covered-family set 是否仍与 policy 同步。`

## 8. 这组源码给出的技术启示

Claude Code 的多重安全技术真正先进的地方，
不是“它有很多安全功能”，
而是：

`它会根据 drift class 选择不同 proof form。`

源码在这里给出的稳定技术启示至少有五条：

1. 当风险是 derived truth 偏离 source truth 时，最优解往往是 source-of-truth test
2. 当风险是几个字段绝不能脱钩时，最优解往往是 atomic structure
3. 当风险是 stale cache 与 live truth 会动态分叉时，最优解往往是 live re-verification
4. 当风险已经显影在多个 cleanup plane 之间时，只继续加 guard 不够，还要给 drift 指定 proof surface
5. 当 covered-family set 本身可能漂移时，coverage 也必须被当成 verifier 问题，而不是文档尾注

所以 stronger-request cleanup 当前最核心的不足，
并不是“还差一个更严格的删除器”，
而是：

`还差一个把 cleanup truth 漂移从“研究者可见”升级成“系统自见”的 verifier 面。`

## 9. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 目前没有 verifier，只是因为 Claude Code 安全体系还不成熟。`

而是：

`repo 安全体系恰恰已经很成熟，成熟到它在别处明确展示了三种 anti-drift grammar；也正因为如此，stronger-request cleanup 当前仍缺对等 verifier plane 这件事，才不是小缺口，而是一个被成熟对照系明确照亮的结构缺口。`

因此：

`artifact-family cleanup stronger-request cleanup-runtime-conformance-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-anti-drift-verifier signer。`

再压成一句：

`cleanup 线现在缺的不是“再多做一次删除”，而是“谁来持续证明删除真相没有重新漂回旧世界”。`
