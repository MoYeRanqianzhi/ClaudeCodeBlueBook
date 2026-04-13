# 安全载体家族强请求清理反漂移验证治理与强请求清理修复治理分层速查表：verifier surface、governance consequence、repair scope、cleanup current gap与governor question

## 1. 这一页服务于什么

这一页服务于 [418-安全载体家族强请求清理反漂移验证治理与强请求清理修复治理分层](../418-安全载体家族强请求清理反漂移验证治理与强请求清理修复治理分层.md)。

如果 `418` 的长文解释的是：

`为什么“谁来发现 stronger-request cleanup 漂移”仍不等于“谁来正式决定怎么修、修到哪一层、由谁承担代价”，`

那么这一页只做一件事：

`把 repo 现有的 verifier / governance consequence 正对照，与 stronger-request cleanup 当前缺的 repair grammar 压成一张矩阵。`

## 2. 强请求清理反漂移验证治理与强请求清理修复治理分层矩阵

| verifier surface | governance consequence surface | repair scope choice | cleanup current gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| `verifyAutoModeGateAccess()` | `checkAndDisableAutoModeIfNeeded()` applies state change + notification | CURRENT app-state transform + user-visible warning | stronger-request cleanup has drift symptoms but no equal-strength consequence plane | who takes verifier output and decides how cleanup world must change | `permissionSetup.ts:1078-1157`; `bypassPermissionsKillswitch.ts:74-116` |
| `getNextPermissionMode()` local divergence precheck | auto-mode circuit breaker / availability consequences live elsewhere | local refusal to enter mode without owning full repair sovereignty | cleanup line lacks even this split between precheck and repair authority | who distinguishes preflight truth exposure from repair sovereignty in cleanup | `getNextPermissionMode.ts:11-17`; `permissionSetup.ts:1078-1157` |
| `verifyAndDemote(...)` | `pluginLoader` disables demoted plugins | explicitly session-local, does NOT write settings | cleanup line has no analogous repair-scope decision | who decides whether cleanup repair should be session-local, persistent, receipt-local, or promise-local | `dependencyResolver.ts:172-233`; `pluginLoader.ts:3189-3195` |
| stronger-request cleanup temporal gap | currently no explicit repair governor | could mean repair scheduler or downgrade wording | unresolved | who decides whether to fix execution timing or weaken startup-delete promise | `settings/types.ts:325-332`; `backgroundHousekeeping.ts:28-80`; `cleanup.ts:575-598` |
| stronger-request cleanup propagation gap | currently no explicit repair governor | could mean executor follows `plansDirectory` or override gets narrowed | unresolved | who decides whether plan override is expanded to cleanup plane or constrained | `plans.ts:79-110`; `cleanup.ts:300-303` |
| stronger-request cleanup coverage gap | currently no explicit repair governor | could mean adding diagnostics cleaner or explicitly narrowing covenant | unresolved | who decides whether uncovered diagnostics world is a bug, an exception, or a separate law | `diagLogs.ts:14-60`; `cleanup.ts:587-595` |
| stronger-request cleanup receipt gap | currently no explicit repair governor | could mean promoting `CleanupResult`, adding receipt surface, or lowering claims | unresolved | who decides whether to add surfaced receipt or reduce conformance language | `cleanup.ts:33-45,575-598` |

## 3. 四个最重要的判断问题

判断一句

`verifier 已经找到 drift，所以修法方向也已经清楚`

有没有越级，先问四句：

1. 这里说的是 truth exposure，还是 governance consequence
2. 当前 repair scope 是 CURRENT-state、session-local、persistent，还是 promise-language-local
3. 这次 drift 暴露后，系统有没有一处正式代码决定“修哪一层、由谁承担代价”
4. 当前 proposed fix 改的是现实世界，还是只是把说法换得更保守

## 4. 最常见的六类误读

| 误读 | 实际问题 |
| --- | --- |
| `能发现 drift，就自然知道怎么修` | detection != repair sovereignty |
| `修复一定是改代码` | repair may also mean narrowing promises or changing scope |
| `plugin demotion 只是局部细节，和 cleanup 无关` | it is a direct governance-scope positive control |
| `只要把 verifier 补齐，repair grammar 就自然会出现` | verifier surface != consequence surface |
| `一处 gap 只会对应一处 fix` | temporal, propagation, coverage, and receipt gaps imply different repair choices |
| `改 wording 不算 repair` | promise demotion is itself a governed repair decision |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup repair grammar 不是：

`drift found -> obvious fix`

而是：

`drift exposed -> repair scope chosen -> governance consequence applied -> promise/capability world updated`

只有这些层被补上，
stronger-request cleanup anti-drift verification 才不会继续停留在：

`系统已经知道哪里漂了，却没人正式决定该由哪一层付费把它拉回正确世界。`
