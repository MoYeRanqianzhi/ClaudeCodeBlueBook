# 安全载体家族强请求清理运行时符合性治理与强请求清理反漂移验证治理分层速查表：positive control、verifier pattern、cleanup current gap、drift risk与governor question

## 1. 这一页服务于什么

这一页服务于 [226-安全载体家族强请求清理运行时符合性治理与强请求清理反漂移验证治理分层：为什么artifact-family cleanup stronger-request cleanup-runtime-conformance-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-anti-drift-verifier signer](../226-安全载体家族强请求清理运行时符合性治理与强请求清理反漂移验证治理分层.md)。

如果 `226` 的长文解释的是：

`为什么 stronger-request cleanup 当前即便看起来已经 runtime-conform，也仍不等于系统已具备长期 anti-drift verification，`

那么这一页只做一件事：

`把 repo 已有 verifier 正对照、stronger-request cleanup 当前控制簇与仍未被 verifier 接管的 drift class 压成一张矩阵。`

## 2. 强请求清理运行时符合性治理与强请求清理反漂移验证治理分层矩阵

| positive control / cleanup surface | verifier pattern | cleanup current gap | drift risk | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| `microCompact` source-of-truth test | derived truth is tied back to source truth by explicit test culture | stronger-request cleanup 暂无对等 source-of-truth drift test | metadata/executor drift may stay silent | who binds stronger-request cleanup source truth to a stable test oracle | `microCompact.ts:32-36` |
| `switchSession` atomic binding | structure forbids `sessionId` / `sessionProjectDir` drift by construction | cleanup metadata、scheduler、executor、receipt 仍可半独立变化 | plane-to-plane drift remains expressible | who makes cleanup family truth atomic where drift must not be representable | `state.ts:456-466` |
| `verifyAutoModeGateAccess` live re-verification | fresh read + current-context transform repair stale-vs-live divergence | stronger-request cleanup 暂无对等 live re-verifier | stale cleanup assumptions can survive mid-session | who re-reads cleanup truth against live state rather than trusting startup metadata | `getNextPermissionMode.ts:11-17`; `permissionSetup.ts:1078-1157` |
| `shouldSkipPersistence()` | write suppression guard | suppressing future writes still does not verify old carriers were deleted | suppression/deletion drift | who proves delete truth rather than only skip-write truth | `sessionStorage.ts:953-969` |
| `backgroundHousekeeping` | delayed admission / reschedule discipline | scheduling policy is visible, verifier policy is absent | temporal drift can remain unsignaled | who checks that startup wording, delayed admission and actual execution stay aligned over time | `backgroundHousekeeping.ts:31-80` |
| validation-error skip | safe abstention under explicit risky settings state | abstention reason is logged, but not promoted to verifier surface | deliberate skip and silent regression can be confused later | who distinguishes safe non-execution from unobserved drift | `cleanup.ts:575-584` |
| plans family | metadata consumed in storage/permission, not by cleanup executor | strongest cross-plane propagation gap still visible | policy truth and delete truth silently diverge | who makes `plansDirectory` the first anti-drift alarm instead of a recurring post-hoc surprise | `plans.ts:79-110`; `cleanup.ts:300-303` |
| `CleanupResult` | local outcome countability | count exists but no family-wide machine-comparable receipt | receipt drift and verifier blindness | who signs stronger-request cleanup family receipt so conformance can be compared over time | `cleanup.ts:33-45`; `cleanup.ts:575-597` |
| current visible naming surface | no `verifyCleanup*` / `reverifyCleanup*` path is visible | verifier intent is still implicit | drift remains researcher-discovered instead of system-discovered | who turns stronger-request cleanup verifier from inference into explicit interface | visible `src/` naming surface |

## 3. 三个最重要的判断问题

判断一句“当前 stronger-request cleanup 已经 conform，所以系统也已经 anti-drift-safe”有没有越级，先问三句：

1. 这里说的是一次 runtime outcome，还是长期 drift detection grammar
2. 当前风险属于 temporal、propagation、receipt，还是 stale-vs-live divergence
3. 这个风险现在是被系统主动抓住，还是仍主要靠阅读源码拼出来

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “这次执行过，所以未来也不会漂” | one conforming run != anti-drift verification |
| “有 skip guard，所以 verifier 已经存在” | safety abstention != drift detection |
| “有 `CleanupResult`，所以系统已经会报警” | local count != machine-comparable receipt |
| “plans 只是局部实现细节，不是 verifier 问题” | cross-plane propagation drift 正是 verifier 问题 |
| “repo 已经很安全了，cleanup 线自然也被同等级保护” | verifier culture exists elsewhere != verifier plane already attached here |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup-anti-drift grammar 不是：

`runtime conformance observed once -> therefore long-term drift is handled`

而是：

`source truth named -> verifier form chosen -> drift class mapped -> alarms fail loudly -> future divergence cannot stay silent`

只有这条链真正闭合，
stronger-request cleanup runtime-conformance 才不会继续停留在：

`这次看起来已经兑现，却没人正式保证将来再漂移时系统会自己发现。`
