# 安全载体家族强请求清理退役治理与强请求清理墓碑治理分层速查表：positive control、marker type、consumer、future effect与governor question

## 1. 这一页服务于什么

这一页服务于 [421-安全载体家族强请求清理退役治理与强请求清理墓碑治理分层](../421-安全载体家族强请求清理退役治理与强请求清理墓碑治理分层.md)。

如果 `421` 的长文解释的是：

`为什么“旧世界何时正式结束”仍不等于“旧世界结束后还留下什么最小机器可消费事实”，`

那么这一页只做一件事：

`把 repo 现有的 tombstone 正对照，与 stronger-request cleanup 当前缺的 residue governance 压成一张矩阵。`

## 2. 强请求清理退役治理与强请求清理墓碑治理分层矩阵

| positive control | marker type | consumer | future effect | cleanup current gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| orphaned assistant messages after streaming fallback | explicit `tombstone` message | stream handler + `QueryEngine` + transcript remover | old partial assistant state stops counting and is routed to deletion instead of silent drift | stronger-request cleanup has no explicit post-retirement control message for old carrier objects | who signs the minimal machine signal that says an old cleanup carrier must now be removed, not re-read | `query.ts:712-723`; `utils/messages.ts:2954-2957`; `QueryEngine.ts:757-760`; `REPL.tsx:2646-2648`; `sessionStorage.ts:1470-1473` |
| tombstoned transcript entry | tombstone-targeted UUID removal + bounded rewrite rule | `REPL.tsx` + `sessionStorage.ts` | UI and transcript both rewrite the world; oversized history is refused for safety | stronger-request cleanup has no bounded rewrite contract for old wording/path/receipt residue | who decides the consumer set, rewrite budget and failure ceiling for cleanup tombstones | `sessionStorage.ts:121-123,925-945,1470-1473` |
| orphaned plugin version | `.orphaned_at` dotfile marker | orphan GC + uninstall path | old version stays in grace world, then becomes deletable | stronger-request cleanup has no orphan-marker plane for retired law/path/receipt worlds | who signs delayed hard-close and second-stage cleanup after the old cleanup world already stopped being current | `cacheUtils.ts:23-24,66-176`; `pluginOperations.ts:523-547` |
| marker-driven search exclusion | glob exclusion derived from orphan marker | `orphanedPluginFilter.ts` + `main.tsx` | old version can stop being visible before physical deletion | stronger-request cleanup has no visibility-cutoff marker for retired carriers | who decides that an old cleanup world is no longer visible even while bytes or traces still exist | `orphanedPluginFilter.ts:1-91`; `main.tsx:2544-2568` |
| model migration trace | migration timestamp trace artifact | startup notification hook | current runtime gets a minimal explanation of why the world just changed | stronger-request cleanup has no trace-artifact contract for explaining cleanup regime changes | who signs the smallest historical note that must survive a cleanup-world transition | `config.ts:427-438`; `useModelMigrationNotifications.tsx:5-50` |

## 3. 四个最重要的判断问题

判断一句

`旧 stronger-request cleanup 世界已经退役，所以后事也已经自动被治理`

有没有越级，先问四句：

1. 当前说的是 sunset boundary，还是 post-retirement marker grammar
2. 当前留下的是 human warning，还是 machine-consumable residue
3. 当前 marker 只记过去，还是还会继续约束 future visibility / recovery / audit world
4. 当前 residual fact 由哪一层签字，又由哪一层负责二次清除或 resurrection gate

## 4. 最常见的六类误读

| 误读 | 实际问题 |
| --- | --- |
| `旧世界已经结束，所以不再需要任何残留事实` | sunset != tombstone |
| `有 warning 或 note 就等于已经有完整墓碑治理` | human explanation != machine-consumable marker |
| `marker 还在，所以旧世界仍然有效` | residue expresses invalidity; it does not restore current truth |
| `只要把对象删掉就够了` | deletion alone cannot govern future interpretation, recovery or audit |
| ` .orphaned_at 只是垃圾清理细节` | marker is an active control surface for grace, exclusion and delayed delete |
| `timestamp 只是产品提示字段，和安全治理无关` | trace artifact is a minimal post-transition fact consumed by runtime logic |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup-tombstone grammar 不是：

`old world retired -> therefore all cleanup aftermath is implicitly handled`

而是：

`old world retired -> minimal residue type chosen -> machine consumers defined -> future effect bounded -> second-stage cleanup / resurrection authority separated`

只有这些层被补上，
stronger-request cleanup sunset-governance 才不会继续停留在：

`系统已经知道何时关门，却没人正式决定门后还要挂什么告示。`
