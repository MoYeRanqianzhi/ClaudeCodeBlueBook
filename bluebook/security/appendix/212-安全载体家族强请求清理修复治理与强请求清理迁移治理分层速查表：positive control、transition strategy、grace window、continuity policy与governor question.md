# 安全载体家族强请求清理修复治理与强请求清理迁移治理分层速查表：positive control、transition strategy、grace window、continuity policy与governor question

## 1. 这一页服务于什么

这一页服务于 [228-安全载体家族强请求清理修复治理与强请求清理迁移治理分层：为什么artifact-family cleanup stronger-request cleanup-repair-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-migration-governor signer](../228-安全载体家族强请求清理修复治理与强请求清理迁移治理分层.md)。

如果 `228` 的长文解释的是：

`为什么“谁来决定怎么修 stronger-request cleanup drift”仍不等于“谁来决定修完后旧 law、旧 path、旧 receipt 怎样退场”，`

那么这一页只做一件事：

`把 repo 现有 migration 正对照，与 stronger-request cleanup 当前缺的 transition grammar 压成一张矩阵。`

## 2. 强请求清理修复治理与强请求清理迁移治理分层矩阵

| positive control / cleanup surface | transition strategy | grace / continuity policy | cleanup current gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| startup migration registry | explicit startup migration chain under version gate | ordered execution before steady-state world | stronger-request cleanup lacks equivalent startup migration plane | who decides when cleanup-law changes must run as formal startup migration rather than ad hoc patching | `main.tsx:323-345` |
| legacy model migration | source-selective rewrite + runtime remap + timestamp notice | only some sources rewritten; others preserved and remapped | stronger-request cleanup has no equivalent choice about old promises / old sources | who decides which stronger-request cleanup sources are rewritten, remapped, or left alone | `migrateLegacyOpusToCurrent.ts:13-57` |
| config-key migration | copy old key to new key, then delete old key, idempotently | preserves old truth until safe cutover | stronger-request cleanup lacks explicit old-law / old-knob handoff grammar | who decides how old cleanup wording or knobs hand off without silent loss or double-write | `migrateReplBridgeEnabledToRemoteControlAtStartup.ts:3-21` |
| plugin orphan retirement | orphan marker + 7-day grace window + deferred deletion | old world exits gradually, not instantly | stronger-request cleanup has no explicit grace-window policy for old law/path/receipt worlds | who decides whether old cleanup worlds get grace, dual-read, or immediate retirement | `cacheUtils.ts:23-24,52-74,89-105` |
| plan continuity | resume reuse + missing-file recovery + fork copy/new slug | continuity preserved while lineage/path changes | stronger-request cleanup has no explicit continuity policy for old plan-world artifacts | who decides how cleanup-related plan artifacts stay readable during migration | `plans.ts:153-255` |
| stronger-request cleanup current repair world | fix scheduler/executor/metadata/promise choices are becoming visible | old law exit strategy still absent | unresolved | who decides how repaired stronger-request cleanup law phases out the old world without new lies | `cleanup.ts:33-45,575-597`; `plans.ts:79-110`; `cleanup.ts:300-303` |

## 3. 三个最重要的判断问题

判断一句“repair 方案已经确定，所以迁移也自然清楚”有没有越级，先问三句：

1. 这里说的是 fix direction，还是 old world exit strategy
2. 当前 transition 需要 rewrite、runtime remap、grace window，还是 continuity-preserving copy/reuse
3. 旧 promise、旧 path、旧 receipt 是立即作废，还是应进入受治理的兼容期

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “修好了就直接切过去” | repair != migration |
| “迁移就是改文件” | migration also includes remap, notification, grace, continuity policy |
| “新 law 更正确，所以旧世界无需兼容期” | better law != zero-transition cost |
| “plans 只是恢复逻辑，和 cleanup migration 无关” | plans is a direct continuity positive control for migration governance |
| “plugin orphan grace 只是缓存细节” | it is a strong positive control for phased retirement of old worlds |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup-migration grammar 不是：

`repair chosen -> immediate cutover`

而是：

`repair direction chosen -> old world exit strategy chosen -> grace/remap/continuity policy defined -> only then can migration be said to exist`

只有这些层被补上，
stronger-request cleanup repair-governance 才不会继续停留在：

`系统已经知道该修什么，却没人正式决定修完后旧 law、旧 path、旧 receipt 怎样退场。`
