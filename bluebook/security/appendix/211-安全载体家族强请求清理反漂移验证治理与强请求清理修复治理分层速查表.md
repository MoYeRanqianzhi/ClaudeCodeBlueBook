# 安全载体家族强请求清理反漂移验证治理与强请求清理修复治理分层速查表：verifier surface、governance consequence、repair scope、cleanup current gap与governor question

## 1. 这一页服务于什么

这一页服务于 [227-安全载体家族强请求清理反漂移验证治理与强请求清理修复治理分层：为什么artifact-family cleanup stronger-request cleanup-anti-drift-verifier signer不能越级冒充artifact-family cleanup stronger-request cleanup-repair-governor signer](../227-安全载体家族强请求清理反漂移验证治理与强请求清理修复治理分层.md)。

如果 `227` 的长文解释的是：

`为什么 stronger-request cleanup 的 drift 即便已被 verifier 揭露，也仍不等于系统已经正式决定怎么修、修到哪一层、代价由谁承担，`

那么这一页只做一件事：

`把 repo 现有 verifier/consequence/scope 正对照，与 stronger-request cleanup 当前缺的 repair grammar 压成一张矩阵。`

## 2. 强请求清理反漂移验证治理与强请求清理修复治理分层矩阵

| verifier surface | governance consequence surface | repair scope choice | cleanup current gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| `verifyAutoModeGateAccess()` | `checkAndDisableAutoModeIfNeeded()` applies transform to CURRENT app state and enqueues warning | current-session state + notification scope | stronger-request cleanup has drift symptoms but no equal-strength consequence plane | who takes cleanup verifier output and decides how current cleanup world must change | `permissionSetup.ts:1078-1157`; `bypassPermissionsKillswitch.ts:74-116` |
| `getNextPermissionMode()` local precheck | circuit-breaker/consequence live elsewhere | local refusal without owning full repair sovereignty | cleanup line lacks even this split between precheck and repair authority | who distinguishes preflight truth exposure from repair sovereignty in cleanup | `getNextPermissionMode.ts:11-17`; `permissionSetup.ts:1078-1157` |
| `verifyAndDemote(...)` | `pluginLoader` disables demoted plugins | explicitly session-local, `does NOT write settings` | cleanup line has no analogous repair-scope decision | who decides whether cleanup repair should be session-local, persistent, or promise-local | `dependencyResolver.ts:161-233`; `pluginLoader.ts:3189-3195` |
| stronger-request cleanup temporal drift | currently no explicit repair governor | could mean fixing scheduler, execution timing, wording, or adding deferred-cleanup receipt | unresolved | who decides whether startup-delete promise or runtime schedule should pay the repair cost | `settings/types.ts:325-333`; `backgroundHousekeeping.ts:31-80`; `cleanup.ts:575-597` |
| stronger-request cleanup propagation drift | currently no explicit repair governor | could mean executor follows `plansDirectory`, override is narrowed, or warning surface is added | unresolved | who decides whether plan override is expanded to cleanup plane or constrained | `plans.ts:79-110`; `cleanup.ts:300-303` |
| stronger-request cleanup receipt drift | currently no explicit repair governor | could mean promoting `CleanupResult`, adding surfaced receipt, or lowering conformance claims | unresolved | who decides whether to strengthen receipt surface or reduce promise strength | `cleanup.ts:33-45,575-597` |
| stronger-request cleanup abstention drift | currently no explicit repair governor | could mean keeping skip semantics but surfacing non-execution reason | unresolved | who decides whether safe abstention should change executor behavior or only promise/explainability layer | `cleanup.ts:575-584` |

## 3. 三个最重要的判断问题

判断一句“verifier 已经找到 drift，所以修法方向也已经清楚”有没有越级，先问三句：

1. 这里说的是 truth exposure，还是 governance consequence
2. 当前 repair scope 是 session-local、persistent，还是 promise-language-local
3. drift 暴露后，系统有没有一处正式代码决定“修哪一层、由谁承担代价”

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “能发现 drift，就自然知道怎么修” | detection != repair sovereignty |
| “repair 一定是改代码” | repair may also mean narrowing promises or changing scope |
| “plugin demotion 只是局部细节，和 cleanup 无关” | it is a direct governance-scope positive control |
| “只要补齐 verifier，repair grammar 就会自然出现” | verifier surface != consequence surface |
| “一处 gap 只会对应一处 obvious fix” | temporal, propagation, receipt, abstention gaps imply different repair choices |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup-repair grammar 不是：

`drift found -> obvious fix`

而是：

`drift exposed -> repair scope chosen -> consequence applied on the right plane -> promise/capability world updated without silently corrupting user intent`

只有这些层被补上，
stronger-request cleanup anti-drift verification 才不会继续停留在：

`系统已经知道哪里漂了，却没人正式决定该由哪一层付费把它拉回正确世界。`
