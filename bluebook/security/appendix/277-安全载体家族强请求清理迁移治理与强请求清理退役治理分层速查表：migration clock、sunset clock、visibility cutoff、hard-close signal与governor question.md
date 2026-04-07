# 安全载体家族强请求清理迁移治理与强请求清理退役治理分层速查表：migration clock、sunset clock、visibility cutoff、hard-close signal与governor question

## 1. 这一页服务于什么

这一页服务于 [293-安全载体家族强请求清理迁移治理与强请求清理退役治理分层：为什么artifact-family cleanup stronger-request cleanup-migration-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-sunset-governor signer](../293-安全载体家族强请求清理迁移治理与强请求清理退役治理分层.md)。

如果 `293` 的长文解释的是：

`为什么“谁来决定旧 stronger-request 世界怎样过渡”仍不等于“谁来决定这个兼容世界何时正式结束”，`

那么这一页只做一件事：

`把 repo 现有 sunset 正对照，与 stronger-request cleanup 当前缺的终止制度压成一张矩阵。`

## 2. 强请求清理迁移治理与强请求清理退役治理分层矩阵

| positive control / cleanup surface | migration clock | sunset clock / hard-close signal | visibility / grace cutoff | cleanup current gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| startup migration registry | startup chain under `CURRENT_MIGRATION_VERSION` replays transition actions | none in the same registry; migration version does not declare retirement | no built-in current-world cutoff | stronger-request cleanup lacks explicit sunset registry for old law worlds | who decides when a migrated cleanup world stops counting as current truth instead of merely being updated | `main.tsx:323-345` |
| legacy model migration | migration timestamp written when settings are rewritten | provider-specific retirement date plus warning text | compatibility may still remain after migration | stronger-request cleanup has no equivalent retirement date for old wording / old promise worlds | who decides when old cleanup promises stop being legal to cite after migration has happened | `migrateLegacyOpusToCurrent.ts:13-57`; `deprecation.ts:21-25,33-61,66-100` |
| model notification surfaces | one-time notification only if migration timestamp is recent | persistent deprecation warning when deprecated model is still in use | warning repeats across runtime surfaces rather than single launch event | stronger-request cleanup has no split between migration notice and sunset warning | who decides whether cleanup users are seeing “just migrated” or “still on a retiring world” | `useModelMigrationNotifications.tsx:5-8,21-33,49-50`; `useDeprecationWarningNotification.tsx:6-27,29-42`; `main.tsx:2872-2895` |
| runtime compatibility remap | old explicit model strings still remap after migration | hard-close absent because opt-out and remap still exist | old world remains accepted in a compatibility path | stronger-request cleanup lacks explicit acceptance cutoff for old law / old receipt semantics | who decides when migrated cleanup worlds stop being accepted even as compatibility shims | `model.ts:549-554`; `migrateLegacyOpusToCurrent.ts:13-57` |
| orphaned plugin storage lifecycle | orphan marker records transition into old-world status | delete only after grace deadline passes | 7-day grace window before storage removal | stronger-request cleanup has no explicit grace deadline for retiring old cleanup carriers | who decides whether old cleanup carriers get grace, dual-read, or immediate retirement | `cacheUtils.ts:23-24,66-74,89-105,149-176` |
| orphaned plugin search visibility | disk state first reconciled by orphan GC | session treats orphan versions as non-current via exclusion cache | visibility cutoff happens before storage delete and stays frozen for the session | stronger-request cleanup has no explicit visibility cutoff for old promises / old paths | who decides when an old cleanup world may still exist on disk but no longer be surfaced as current | `orphanedPluginFilter.ts:1-15,25-26,35-37,47-87`; `main.tsx:2544-2568` |
| stronger-request cleanup current migration world | cleanup counters, background sweep, and home-root plan cleanup policy are visible | sunset date, hard-close rule, visibility cutoff, and post-grace invalidation are still absent | old cleanup carriers still lack a formal end-of-compatibility policy | stronger-request cleanup still has no formal distinction between migrated coexistence and retired non-current world | who decides when old startup wording, old home-root cleanup law, and old receipt semantics stop counting as current world rather than merely coexisting | `utils/cleanup.ts:33-45,300-303,575-597`; `utils/plans.ts:79-110` |

## 3. 三个最重要的判断问题

判断一句“migration 已经清楚，所以 sunset 也自然清楚”有没有越级，先问三句：

1. 这里说的是 transition event，还是 compatibility end date
2. 当前需要的是 one-time notice、persistent warning、visibility cutoff 还是 hard-close rule
3. 旧 promise、旧 path、旧 receipt 是仍在受治理地共存，还是已经从 current world 正式退役

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “迁移做完就算退役完成” | migration != sunset |
| “warning 出现了，所以硬关闭已经存在” | warning surface != hard-close authority |
| “旧世界还在磁盘上，所以它仍算当前世界” | storage presence != current-world legitimacy |
| “旧世界已经从搜索里消失，所以它已彻底不存在” | visibility cutoff != storage deletion |
| “CURRENT_MIGRATION_VERSION 已升级，所以兼容世界也自动结束” | migration registry != sunset registry |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup-sunset grammar 不是：

`migration defined -> sunset complete`

而是：

`migration object defined -> retirement clock defined -> warning/visibility/hard-close boundaries defined -> only then can sunset be said to exist`

只有这些层被补上，
stronger-request cleanup migration-governance 才不会继续停留在：

`系统已经知道旧世界怎样过渡，却没人正式决定这段过渡何时结束。`
