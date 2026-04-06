# 安全载体家族迁移治理与退役治理分层速查表：migration decision、sunset decision、positive control、cleanup retirement gap与governor question

## 1. 这一页服务于什么

这一页服务于 [165-安全载体家族迁移治理与退役治理分层：为什么artifact-family cleanup migration-governor signer不能越级冒充artifact-family cleanup sunset-governor signer](../165-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E8%BF%81%E7%A7%BB%E6%B2%BB%E7%90%86%E4%B8%8E%E9%80%80%E5%BD%B9%E6%B2%BB%E7%90%86%E5%88%86%E5%B1%82%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88artifact-family%20cleanup%20migration-governor%20signer%E4%B8%8D%E8%83%BD%E8%B6%8A%E7%BA%A7%E5%86%92%E5%85%85artifact-family%20cleanup%20sunset-governor%20signer.md)。

如果 `165` 的长文解释的是：

`为什么决定新旧世界如何并存，与决定兼容期何时正式结束，仍然是两层治理主权，`

那么这一页只做一件事：

`把 repo 里现成的 migration decision / sunset decision 正例，与 cleanup 线当前仍缺的 retirement governance，压成一张矩阵。`

## 2. 迁移治理与退役治理分层矩阵

| line | migration decision | sunset decision | positive control | cleanup retirement gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| model string transition | decide which settings source to rewrite, which sources only remap, whether to emit one-time migration notice | decide which provider/date formally retires the old model and when warning becomes hard sunset clock | model migrations + deprecation warnings | cleanup line has no equivalent retirement date or end-of-compatibility clock | who decides when old cleanup promise/path/receipt stops being valid | `deprecation.ts`; `migrateLegacyOpusToCurrent.ts`; `migrateSonnet45ToSonnet46.ts`; `useModelMigrationNotifications.tsx`; `useDeprecationWarningNotification.tsx`; `main.tsx:2872-2892` |
| legacy runtime alias | decide legacy explicit strings still remap at runtime during transition | decide when that remap should cease to count as supported compatibility | `isLegacyModelRemapEnabled()` + legacy opus migration | cleanup line has no explicit stop-support switch for old cleanup semantics | when does compatibility end instead of continuing forever | `model.ts:552-554`; `migrateLegacyOpusToCurrent.ts:12-53` |
| plugin version turnover | decide old version becomes orphaned and enters grace world | decide visibility cutoff and 7-day deletion deadline | `.orphaned_at`, `CLEANUP_AGE_MS`, grep/glob exclusion warmup | cleanup line has no grace-window owner or visibility cutoff for old artifacts | who decides old cleanup artifacts first disappear from search and later from disk | `cacheUtils.ts:23-24,74-171`; `orphanedPluginFilter.ts`; `main.tsx:2546-2568` |
| one-shot migration execution | decide migration should run once and then stop rerunning | does not by itself decide old world is retired | `migrationCompleted`; `hasResetAutoModeOptInForDefaultOffer` | cleanup line could wrongly confuse “migration ran” with “old world closed” | what extra authority declares hard close after one-shot execution | `installedPluginsManager.ts:59-180`; `resetAutoModeOptInForDefaultOffer.ts:24-47` |
| cleanup line overall | may eventually decide dual-read, rewrite, remap, or continuity for old cleanup worlds | no explicit retirement clock, visibility cutoff, or hard-close owner is visible yet | sunset governance exists elsewhere in repo | old cleanup worlds still lack a formal retirement grammar | who governs end-of-compatibility for old plan path, old startup-delete language, and old receipt semantics | cleanup source cluster + positive controls above |

## 3. 三个最重要的判断问题

判断一句“cleanup migration 已经完整”有没有越级，先问三句：

1. 这只是 migration decision，还是已经明确兼容期何时结束
2. 旧 artifact 只是还在磁盘上，还是仍被当前系统承认为正式 truth
3. 如果旧世界只该暂时活着，那么截止时间、visibility cutoff 与 hard close 由谁决定

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “已经有 migration path，所以 sunset 自然也有了” | migration != sunset governance |
| “脚本跑过一次，旧世界就已经关停” | completion flag != retirement authority |
| “有 warning 就代表退役治理完整” | warning is only one surface, not the whole control plane |
| “旧文件还在，所以旧世界还算正式世界” | on-disk existence != continued validity |
| “只要 grace window 存在，就不用再问谁决定截止” | grace without a deadline owner is still under-governed |

## 5. 一条硬结论

真正成熟的 lifecycle grammar 不是：

`migration decision -> coexistence`

而是：

`migration decision -> assign sunset authority -> cut visibility -> end grace window -> hard close old world`

只有后面三层被补上，  
cleanup migration governance 才不会继续停留在“知道怎么带着旧世界往前走，却没人能正式宣布它何时该停”的半治理状态。
