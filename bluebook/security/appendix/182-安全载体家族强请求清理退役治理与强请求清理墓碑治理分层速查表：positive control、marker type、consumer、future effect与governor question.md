# 安全载体家族强请求清理退役治理与强请求清理墓碑治理分层速查表：positive control、marker type、consumer、future effect与governor question

## 1. 这一页服务于什么

这一页服务于 [198-安全载体家族强请求清理退役治理与强请求清理墓碑治理分层：为什么artifact-family cleanup stronger-request cleanup-sunset-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-tombstone-governor signer](../198-安全载体家族强请求清理退役治理与强请求清理墓碑治理分层.md)。

如果 `198` 的长文解释的是：

`为什么“旧 stronger-request 世界何时结束”仍不等于“旧 stronger-request 世界结束后还留下什么最小残留标记”，`

那么这一页只做一件事：

`把 message tombstone、plugin marker、migration trace artifact 与 stronger-request cleanup current gap 压成一张矩阵。`

## 2. 强请求清理退役治理与强请求清理墓碑治理分层矩阵

| positive control / cleanup current gap | sunset decision | marker type | consumer | future effect | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| orphaned message world | old partial message no longer counts as current content | explicit `tombstone` control signal | `utils/messages` / `QueryEngine` / `REPL` / `sessionStorage` | removes UI/transcript residue and prevents stale replay | who decides what minimal post-retirement control artifact must still be emitted | `query.ts:713-719`; `utils/messages.ts:2954-2957`; `QueryEngine.ts:756-759`; `REPL.tsx:2646-2648`; `sessionStorage.ts:1466-1473,923-944` |
| plugin orphan world | old plugin version enters orphan/grace world | `.orphaned_at` marker | orphan cleanup + plugin operations | drives delayed delete and keeps orphan fact machine-readable | who decides what marker proves old cleanup world is retired but still awaiting later handling | `cacheUtils.ts:56-72,145-171`; `pluginOperations.ts:526-547` |
| marker-driven visibility world | old plugin version no longer belongs to current search world | marker-derived exclusion grammar | `orphanedPluginFilter` + `main.tsx` grep/glob cache | constrains future search/visibility before physical delete | who decides which marker continues to shape future read surfaces after retirement | `orphanedPluginFilter.ts:1-79`; `main.tsx:2546-2568` |
| model transition trace | model migration already happened | migration timestamp as tombstone-like marker | `useModelMigrationNotifications` | explains why current world just changed without rerunning migration | who decides what minimal trace must survive after transition so current runtime can still explain itself | `config.ts:428-438`; `useModelMigrationNotifications.tsx:1-33` |
| stronger-request cleanup current gap | sunset question is now visible | no explicit tombstone grammar yet | old path / old promise / old receipt world still lack formal marker consumer | future readers may know old world is retired but still lack machine-readable post-retirement clue | who decides what minimal marker must remain once old stronger-request cleanup world stops being current truth | current cleanup line evidence set |

## 3. 三个最重要的判断问题

判断一句“既然旧 stronger-request 世界已经退役，所以墓碑问题也自动解决了”有没有越级，先问三句：

1. 这里回答的是 `sunset decision`，还是 `marker type`
2. 当前系统只是知道旧世界何时结束，还是已经知道结束后靠什么最小残留物继续约束未来解释
3. 这个 residual artifact 是普通垃圾、普通通知，还是会继续被机器消费的 control artifact

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “对象退役了，所以应该无痕消失” | retirement != silent disappearance |
| “marker 还在，所以旧世界还有效” | marker presence != current-world validity |
| “只要有 warning 就够了” | warning surface != full tombstone grammar |
| “timestamp 只是脚本附带信息” | some timestamps act as post-transition trace artifacts |
| “删文件就是全部治理” | deletion does not answer what minimal historical fact must remain first |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup tombstone grammar 不是：

`old world retired -> therefore nothing more needs to be governed`

而是：

`old world retired -> minimal marker defined -> marker consumer defined -> future interpretation constrained`

只有这些层被补上，
stronger-request cleanup sunset-governance 才不会继续停留在：

`系统已经知道旧世界何时结束，却没人正式决定结束后要留下什么最小残留事实。`
