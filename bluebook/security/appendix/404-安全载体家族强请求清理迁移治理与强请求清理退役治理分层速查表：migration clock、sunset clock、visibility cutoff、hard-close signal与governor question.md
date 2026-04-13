# 安全载体家族强请求清理迁移治理与强请求清理退役治理分层速查表：migration clock、sunset clock、visibility cutoff、hard-close signal与governor question

## 1. 这一页服务于什么

这一页服务于 [420-安全载体家族强请求清理迁移治理与强请求清理退役治理分层](../420-安全载体家族强请求清理迁移治理与强请求清理退役治理分层.md)。

如果 `420` 的长文解释的是：

`为什么“旧世界怎样过渡退出”仍不等于“旧世界从什么时候起正式不再算当前世界”，`

那么这一页只做一件事：

`把 repo 现有的 sunset 正对照，与 stronger-request cleanup 当前缺的 retirement clock 压成一张矩阵。`

## 2. 强请求清理迁移治理与强请求清理退役治理分层矩阵

| migration / sunset surface | sunset clock or cutoff | compatibility residue | cleanup current gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| startup migration registry | rerun clock only | old world may still live after migrations complete | stronger-request cleanup has no separate sunset registry | who decides when cleanup migration stops being “ongoing transition” and becomes “legacy world retired” | `main.tsx:323-346` |
| model deprecation registry | provider-specific retirement date | same old model retires on different providers at different times | stronger-request cleanup has no provider/surface-specific retirement truth | who signs cleanup-world retirement date per surface/provider/runtime | `deprecation.ts:21-25,33-100` |
| one-time migration notice | launch-local recent timestamp | tells user migration just happened, not that old world is gone | stronger-request cleanup has no explicit migration-notice vs sunset-warning split | who distinguishes “刚迁完” from “正式退役” in cleanup world | `useModelMigrationNotifications.tsx:5-50`; `migrateLegacyOpusToCurrent.ts:13-57` |
| sustained warning surface | runtime warning without hard-close | old world still visible enough to warn about | stronger-request cleanup has no ongoing sunset-warning surface | who keeps warning alive until old cleanup world truly stops counting as current truth | `useDeprecationWarningNotification.tsx:6-42`; `REPL.tsx:744-762`; `main.tsx:2872-2895` |
| legacy remap residue | sunset not yet hard-closed | runtime compatibility remains after source migration | stronger-request cleanup has no explicit compatibility-residue contract | who decides whether old cleanup semantics remain tolerated after migration | `model.ts:549-554`; `migrateLegacyOpusToCurrent.ts:13-57` |
| orphan storage retirement | 7-day grace window before deletion | old version stays on disk for a while | stronger-request cleanup has no storage-sunset clock for old law/path/receipt worlds | who decides whether old cleanup worlds get delayed hard-close on disk | `cacheUtils.ts:23-24,66-176` |
| orphan visibility filter | session-level grep/glob exclusion cache | visibility sunset can happen before storage sunset | stronger-request cleanup has no equivalent visibility-cutoff plane | who decides when old cleanup world stops being visible even before physical deletion | `orphanedPluginFilter.ts:1-91`; `main.tsx:2544-2568` |

## 3. 四个最重要的判断问题

判断一句

`旧 stronger-request cleanup 世界已经开始迁移，所以它也已经正式退役`

有没有越级，先问四句：

1. 这里说的是迁移动作，还是退役时钟
2. 当前 cut off 的是 warning、visibility、runtime acceptance，还是 storage existence
3. 兼容 residue 还活着，还是已经 hard-close
4. 当前 surface 表达的是“刚迁完”，还是“从现在起不再算当前世界”

## 4. 最常见的六类误读

| 误读 | 实际问题 |
| --- | --- |
| `迁移完成就等于退役完成` | migration clock != sunset clock |
| `有 deprecation warning 就等于已经退役` | warning surface != hard-close authority |
| `runtime remap 还在，所以 sunset 不存在` | residue proves layers are split, not absent |
| `磁盘上还在，所以它仍算当前世界` | visibility/current-truth cutoff may precede storage deletion |
| `migration version gate 足够正式，所以不用单独 sunset plane` | rerun gate != current-truth cutoff |
| `只要没有 manager object，sunset 就不算独立层` | separate clocks can exist without one obvious class |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup-sunset grammar 不是：

`migration underway -> therefore old world is retired`

而是：

`migration path exists -> retirement clock defined -> warning/visibility/runtime/storage cutoffs separated -> only then can old world be said to stop counting as current truth`

只有这些层被补上，
stronger-request cleanup migration-governance 才不会继续停留在：

`系统已经知道怎样带旧世界过渡，却没人正式决定这段过渡从什么时候起必须结束。`
