# 安全载体家族强请求清理修复治理与强请求清理迁移治理分层速查表：positive control、transition strategy、grace window、continuity policy与governor question

## 1. 这一页服务于什么

这一页服务于 [451-安全载体家族强请求清理修复治理与强请求清理迁移治理分层](../451-安全载体家族强请求清理修复治理与强请求清理迁移治理分层.md)。

如果 `451` 的长文解释的是：

`为什么“谁来决定怎么修 stronger-request cleanup drift”仍不等于“谁来决定修完后旧 law、旧 path、旧 receipt 怎样退场”，`

那么这一页只做一件事：

`把 repo 现有的 migration 正对照，与 stronger-request cleanup 当前缺的 transition grammar 压成一张矩阵。`

## 2. 强请求清理修复治理与强请求清理迁移治理分层矩阵

| positive control / cleanup surface | transition strategy | grace / continuity policy | cleanup current gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| startup migration registry | explicit startup migration chain | ordered execution under migration version gate | stronger-request cleanup lacks an equivalent startup migration plane | 谁决定 cleanup-law changes 何时必须以 formal startup migration 运行，而不是 ad hoc patching | `main.tsx:323-346` |
| legacy model migration | source rewrite + runtime remap + timestamp notification | only some sources rewritten; others preserved and remapped | stronger-request cleanup has no equivalent choice about old promises / old sources | 谁决定哪些 cleanup sources 应被 rewrite、remap 或留存 | `migrateLegacyOpusToCurrent.ts:13-57` |
| config-key migration | copy old key to new key, then delete old key, idempotently | preserves old truth until safe cutover | stronger-request cleanup lacks explicit old-key / old-law handoff grammar | 谁决定旧 cleanup wording 或 knobs 如何 hand off to new ones without double-write or silent loss | `migrateReplBridgeEnabledToRemoteControlAtStartup.ts:3-21` |
| plugin orphan cleanup | orphan marker + 7-day grace window + deferred deletion | old world exits gradually, not instantly | stronger-request cleanup has no explicit grace-window policy for old law/path/receipt worlds | 谁决定旧 cleanup worlds 是否有 grace、dual-read，还是 immediate retirement | `cacheUtils.ts:23-24,69-105` |
| plan continuity | resume reuse + missing-file recovery + fork copy/new slug | continuity preserved while ownership/path lineage changes | stronger-request cleanup has no explicit transition policy for old plan-world artifacts | 谁决定旧 cleanup-related plan artifacts 在 migration 期间如何保持可读与可恢复 | `plans.ts:164-255` |
| stronger-request cleanup current repair world | fix scheduler/executor/metadata/promise choices are becoming visible | old law exit strategy still absent | unresolved | 谁决定 repaired stronger-request cleanup law 如何 phased out the old world without new lies | `cleanup.ts:575-598`; `plans.ts:79-110`; `cleanup.ts:300-303`; `diagLogs.ts:14-60` |

## 3. 四个最重要的判断问题

判断一句

`repair 方案已经确定，所以迁移也自然清楚`

有没有越级，先问四句：

1. 这里说的是 fix direction，还是 old world exit strategy
2. 当前 transition 需要 rewrite、runtime remap、grace window，还是 continuity-preserving copy / reuse
3. 旧 promise、旧 path、旧 receipt 是立即作废，还是应进入受治理的兼容期
4. 当前 proposed migration 改的是现值，还是在安排旧世界如何不制造新谎言地退场

## 4. 最常见的六类误读

| 误读 | 实际问题 |
| --- | --- |
| `修好了就直接切过去` | repair != migration |
| `迁移就是改文件` | migration also includes remap, notification, grace, continuity policy |
| `新 law 更正确，所以旧世界无需兼容期` | better law != zero-transition cost |
| `plans 只是恢复逻辑，和 cleanup migration 无关` | plans is a direct continuity positive control for migration governance |
| `plugin orphan grace 只是缓存细节` | it is a strong positive control for phased retirement of old worlds |
| `只要 old value 不再被默认读取，迁移就结束了` | remap/ignore != governed retirement |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup migration grammar 不是：

`repair chosen -> immediate cutover`

而是：

`repair direction chosen -> old world exit strategy chosen -> grace/remap/continuity policy defined -> only then can migration be said to exist`

只有这些层被补上，
stronger-request cleanup repair-governance 才不会继续停留在：

`系统已经知道该修什么，却没人正式决定修完后旧 law、旧 path、旧 receipt 怎样退场。`
