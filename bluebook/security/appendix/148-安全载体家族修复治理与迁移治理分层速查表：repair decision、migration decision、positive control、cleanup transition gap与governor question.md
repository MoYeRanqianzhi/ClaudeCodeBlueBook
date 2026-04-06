# 安全载体家族修复治理与迁移治理分层速查表：repair decision、migration decision、positive control、cleanup transition gap与governor question

## 1. 这一页服务于什么

这一页服务于 [164-安全载体家族修复治理与迁移治理分层：为什么artifact-family cleanup repair-governor signer不能越级冒充artifact-family cleanup migration-governor signer](../164-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E4%BF%AE%E5%A4%8D%E6%B2%BB%E7%90%86%E4%B8%8E%E8%BF%81%E7%A7%BB%E6%B2%BB%E7%90%86%E5%88%86%E5%B1%82%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88artifact-family%20cleanup%20repair-governor%20signer%E4%B8%8D%E8%83%BD%E8%B6%8A%E7%BA%A7%E5%86%92%E5%85%85artifact-family%20cleanup%20migration-governor%20signer.md)。

如果 `164` 的长文解释的是：

`为什么决定怎么修，与决定旧世界怎样平滑退场，仍然是两层治理主权，`

那么这一页只做一件事：

`把 repo 里现成的 repair decision / migration decision 正例，与 cleanup 线当前仍缺的 transition governance，压成一张矩阵。`

## 2. 修复治理与迁移治理分层矩阵

| line | repair decision | migration decision | positive control | cleanup transition gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| model string updates | decide old explicit model strings should no longer be the stable user-facing truth | decide which settings source to rewrite, which to leave pinned, whether to remap at runtime, whether to notify once | model migrations in `main.tsx` + `migrations/*` | cleanup line still lacks explicit old-world transition policy | who decides which old cleanup promises remain temporarily valid | `main.tsx:323-341`; `migrateSonnet1mToSonnet45.ts`; `migrateLegacyOpusToCurrent.ts`; `migrateSonnet45ToSonnet46.ts` |
| config key rename | decide old key is the wrong governance home | decide when to copy old key, when to delete it, and how to stay idempotent | `migrateBypassPermissionsAcceptedToSettings.ts`; `migrateReplBridgeEnabledToRemoteControlAtStartup.ts` | cleanup line has no equivalent old-key / new-key transition grammar yet | should cleanup fixes rewrite old config, dual-read both, or deprecate with grace | migration files above |
| plugin structure repair | decide plugin metadata / dependency world should change | decide V1→V2 file migration, legacy cache cleanup, orphan grace window, demotion consequences | `installedPluginsManager.ts`; `cacheUtils.ts`; plugin demote path | cleanup line has no explicit grace window for old path / old receipts | who assigns orphan / grace periods for cleanup artifacts | `installedPluginsManager.ts:96-213`; `cacheUtils.ts:20-99`; plugin verify/demote cluster |
| plan artifact continuity | decide plan path / slug semantics should avoid clobber | decide reuse old slug on resume, generate new slug on fork, recover missing plan from snapshots/history | `copyPlanForResume()` / `copyPlanForFork()` | cleanup line still lacks explicit old-plan-path transition policy | how should old home-root vs new project-root plan worlds coexist | `plans.ts:150-248` |
| cleanup line overall | can identify need to fix metadata / scheduler / executor / promise | no explicit cleanup migration governor is visible | migration governance exists elsewhere in repo | old cleanup world exit is not yet formalized | who governs compatibility windows, old receipts, and path phaseout | cleanup source cluster + positive controls above |

## 3. 三个最重要的判断问题

判断一句“cleanup 修法已经完整”有没有越级，先问三句：

1. 这只是 repair decision，还是已经明确了旧世界怎样退场
2. 旧值、旧路径、旧缓存、旧承诺是否仍会继续在系统里活一段时间
3. 如果答案是会，它们的兼容期、作废条件与通知责任由谁决定

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “修法确定了，迁移自然就会跟着走” | repair != migration governance |
| “新规则更正确，所以旧世界应立刻消失” | maybe grace/remap/notification are needed |
| “迁移就是改一个文件” | migration may include runtime remap, orphan retention, and phased cleanup |
| “旧值还在只是技术债，不算治理问题” | old-world coexistence is exactly a governance problem |
| “cleanup 线没有迁移代码，所以不需要迁移治理” | absence of code may indicate absence of ownership, not absence of need |

## 5. 一条硬结论

真正成熟的 transition grammar 不是：

`repair decision -> ship new rule`

而是：

`repair decision -> assign migration authority -> govern old-world exit -> keep claims and execution honest during transition`

只有中间两层被补上，  
cleanup repair governance 才不会继续停留在“只知道新世界正确，却不知道旧世界如何有序退场”的半治理状态。
