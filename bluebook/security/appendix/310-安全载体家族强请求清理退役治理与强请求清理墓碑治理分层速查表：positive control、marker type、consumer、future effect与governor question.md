# 安全载体家族强请求清理退役治理与强请求清理墓碑治理分层速查表：positive control、marker type、consumer、future effect与governor question

## 1. 这一页服务于什么

这一页服务于 [326-安全载体家族强请求清理退役治理与强请求清理墓碑治理分层](../326-安全载体家族强请求清理退役治理与强请求清理墓碑治理分层.md)。

如果 `326` 的长文解释的是：

`为什么“旧 stronger-request cleanup 世界何时结束”仍不等于“结束后留下什么最小残留事实继续约束未来解释”，`

那么这一页只做一件事：

`把 repo 现有的 tombstone 正对照，与 stronger-request cleanup 当前缺的 post-retirement marker grammar 压成一张矩阵。`

## 2. 强请求清理退役治理与强请求清理墓碑治理分层矩阵

| positive control / cleanup surface | marker type | consumer | future effect | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| orphaned message cleanup | explicit `tombstone` control signal | `utils/messages.ts`, `QueryEngine.ts`, `REPL.tsx`, transcript storage | removes orphaned message from UI and transcript; future stream consumers must not treat it as normal content | who signs that ended cleanup artifacts leave a control signal rather than disappearing silently | `query.ts:712-719`; `utils/messages.ts:2954-2957`; `QueryEngine.ts:757-760`; `REPL.tsx:2646-2648`; `sessionStorage.ts:1470-1473` |
| large transcript tombstone path | `MAX_TOMBSTONE_REWRITE_BYTES` + slow-path rewrite | session storage layer | keeps tombstone execution bounded instead of turning residue cleanup into OOM risk | who governs the safety limits of post-retirement residue cleanup | `sessionStorage.ts:121-123,925-945` |
| orphaned plugin version | `.orphaned_at` marker file | orphan GC, uninstall path, future cleanup passes | old version is marked as retired before eventual deletion | who decides the minimal machine marker for retired cleanup carriers | `cacheUtils.ts:23-24,149-176`; `pluginOperations.ts:523-547` |
| marker-driven search cutoff | grep/glob exclusion derived from `.orphaned_at` | `orphanedPluginFilter.ts`, `main.tsx` warmup path | future search/visibility world is constrained by the marker | who decides how tombstones continue shaping future reader behavior | `orphanedPluginFilter.ts:1-15,25-26,35-37,47-87`; `main.tsx:2544-2568` |
| model migration trace | migration timestamp fields | startup notification hook | explains why current world changed without restoring old world validity | who signs trace artifacts that remain only to explain a world change | `config.ts:427-438`; `useModelMigrationNotifications.tsx:5-8,21-33,49-50` |
| stronger-request cleanup current sunset world | no explicit cleanup-family tombstone grammar yet | unresolved | post-retirement interpretation may rely on researcher reconstruction | who decides what minimal marker old cleanup wording/path/receipt worlds must leave behind | `cleanup.ts:33-45,300-303,575-598`; `diagLogs.ts:14-60` |

## 3. 四个最重要的判断问题

判断一句“旧 stronger-request cleanup 世界已经 sunset，所以后续解释问题也解决了”有没有越级，先问四句：

1. 这里说的是退役时点，还是退役后的最小 marker
2. 当前留下的是人类说明、机器控制信号，还是根本没有留下 residue
3. 哪些 consumer 还会继续读取这个 marker
4. marker 是在约束未来解释，还是在偷偷恢复旧世界的 current validity

## 4. 最常见的六类误读

| 误读 | 实际问题 |
| --- | --- |
| “既然旧世界已退役，就该彻底消失” | no current truth != no residual governance |
| “marker 还在，就说明旧世界还有效” | residue != restored validity |
| “warning/timestamp 已经够了，不需要 tombstone” | human explanation != machine-consumable control signal |
| “`.orphaned_at` 只是清理辅助文件” | it is a governed post-retirement marker |
| “只要从 UI 消失，墓碑问题就结束了” | storage/search/recovery/audit may still need residue facts |
| “cleanup 线没写 tombstone，就说明这层不重要” | absence of grammar is exactly the governance gap |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup-tombstone grammar 不是：

`old world retired -> therefore nothing more needs to be said`

而是：

`old world retired -> minimal machine-consumable residue chosen -> consumer set defined -> future interpretation constrained`

只有这些层被补上，
stronger-request cleanup sunset-governance 才不会继续停留在：

`系统已经知道旧世界何时结束，却没人正式决定结束后还要留下什么最小残留事实。`
