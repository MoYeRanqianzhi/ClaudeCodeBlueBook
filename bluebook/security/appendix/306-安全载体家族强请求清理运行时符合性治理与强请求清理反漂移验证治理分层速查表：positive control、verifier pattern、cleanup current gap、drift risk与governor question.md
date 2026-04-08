# 安全载体家族强请求清理运行时符合性治理与强请求清理反漂移验证治理分层速查表：positive control、verifier pattern、cleanup current gap、drift risk与governor question

## 1. 这一页服务于什么

这一页服务于 [322-安全载体家族强请求清理运行时符合性治理与强请求清理反漂移验证治理分层](../322-安全载体家族强请求清理运行时符合性治理与强请求清理反漂移验证治理分层.md)。

如果 `322` 的长文解释的是：

`为什么“这次 stronger-request cleanup 看起来已经 conform”仍不等于“系统已经拥有长期 anti-drift verifier”，`

那么这一页只做一件事：

`把 repo 现有的 verifier 正对照，与 stronger-request cleanup 当前缺口压成一张矩阵。`

## 2. 强请求清理运行时符合性治理与强请求清理反漂移验证治理分层矩阵

| positive control / cleanup surface | verifier pattern | cleanup current gap | drift risk | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| `microCompact` source-of-truth test | derived truth tested against source truth | cleanup 线暂无对等 source-of-truth drift test | metadata/executor drift may stay silent | who binds stronger-request cleanup source truth to an explicit drift test | `microCompact.ts:32-36` |
| `switchSession` atomic binding | structure forbids drift by forcing fields to change together | cleanup planes still change semi-independently | settings/storage/permission/executor may desynchronize | who makes cleanup family truth atomic where it must not drift | `bootstrap/state.ts:456-479` |
| `verifyAutoModeGateAccess` + CURRENT-state transform | stale cache vs live truth dual-read, then consequence applied to current context | cleanup 线暂无对等 live re-verifier | runtime may keep stale cleanup assumptions | who re-verifies cleanup family truth against live state rather than trusting stale metadata | `getNextPermissionMode.ts:11-17`; `permissionSetup.ts:1078-1157`; `bypassPermissionsKillswitch.ts:74-116` |
| interactive/headless cleanup admission | first-submit start + headless deferred import + 10-minute background run | admission exists, continuous re-check does not | mode/timing drift may recur without alarm | who distinguishes one-time admission from ongoing anti-drift verification | `REPL.tsx:3903-3906`; `main.tsx:2811-2818`; `backgroundHousekeeping.ts:28-80` |
| stronger-request cleanup current runtime | suppress guard + skip guard + local `CleanupResult` | these are conformance hints, not verifier grammar | temporal/skip/receipt drift remains visible but unsupervised | who turns stronger-request cleanup conformance symptoms into anti-drift verification | `sessionStorage.ts:954-969`; `cleanup.ts:33-45,575-598` |
| plans family | metadata consumed in storage/permission/resume but not cleanup executor | strongest propagation drift still visible | storage and cleanup worlds diverge silently | who makes plans family the first anti-drift alarm instead of a recurring post-hoc surprise | `plans.ts:79-110,164-233`; `cleanup.ts:300-303`; `filesystem.ts:244-255,1487-1495,1644-1652` |
| diagnostics family | host-visible writer contract is explicit | visible cleanup dispatcher still does not cover it | coverage drift may remain structurally invisible | who decides whether uncovered diagnostics world is intentional constitution or silent cleanup drift | `diagLogs.ts:14-60`; `cleanup.ts:587-595` |

## 3. 四个最重要的判断问题

判断一句“当前 stronger-request cleanup 已经 conform，所以系统也已经 anti-drift-safe”有没有越级，先问四句：

1. 这里说的是一次 runtime 结果，还是持续 verifier plane
2. 当前风险是 temporal、propagation、coverage、receipt，还是 stale-vs-live divergence
3. 这个风险现在是被系统主动抓，还是仍然主要靠研究者从源码里拼出来
4. 当前 surface 提供的是执行症状，还是对未来再次偏离的主动报警

## 4. 最常见的六类误读

| 误读 | 实际问题 |
| --- | --- |
| “这次执行成功，所以以后也不会漂移” | one conforming run != anti-drift verification |
| “有 skip guard，所以 verifier 已经有了” | safety guard != drift verifier |
| “有 `CleanupResult`，所以系统已经会报警” | local outcome count != verifier surface |
| “REPL/headless 都会启动 housekeeping，所以 anti-drift 已经成立” | admission != continuous re-verification |
| “plans 只是个局部偏差，不影响 verifier 层” | propagation gap is exactly the verifier alarm case |
| “注释里承认有 drift 风险，已经很够了” | risk awareness != verifier grammar |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup-anti-drift grammar 不是：

`runtime conformance observed once -> therefore long-term drift is handled`

而是：

`source truth named -> verifier pattern chosen -> drift alarms fail loudly -> future divergence cannot stay silent`

只有这些层被补上，
stronger-request cleanup runtime-conformance 才不会继续停留在：

`这次运行看起来已经符合，却没人正式保证将来再漂移时系统会自己发现。`
