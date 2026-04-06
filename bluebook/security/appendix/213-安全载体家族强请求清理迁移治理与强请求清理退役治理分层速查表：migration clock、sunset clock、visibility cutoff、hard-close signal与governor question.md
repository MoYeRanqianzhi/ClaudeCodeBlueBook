# 安全载体家族强请求清理迁移治理与强请求清理退役治理分层速查表：migration clock、sunset clock、visibility cutoff、hard-close signal与governor question

## 1. 这一页服务于什么

这一页服务于 [229-安全载体家族强请求清理迁移治理与强请求清理退役治理分层：为什么artifact-family cleanup stronger-request cleanup-migration-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-sunset-governor signer](../229-安全载体家族强请求清理迁移治理与强请求清理退役治理分层.md)。

如果 `229` 的长文解释的是：

`为什么“旧 stronger-request 世界怎样被带过渡”仍不等于“旧 stronger-request 世界从什么时候起正式不再算当前世界”，`

那么这一页只做一件事：

`把 migration clock、sunset clock、visibility cutoff 与 hard-close signal 压成一张矩阵。`

## 2. 强请求清理迁移治理与强请求清理退役治理分层矩阵

| positive control / cleanup current gap | migration clock | sunset clock | visibility cutoff / hard-close signal | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| legacy model migration | migration timestamp when user is moved to new default | provider-specific retirement date for old model | deprecation warning becomes the active hard-close signal | who decides when old stronger-request promise moves from “migrated” to “retired” | `migrateLegacyOpusToCurrent.ts:13-57`; `deprecation.ts:28-100`; `useModelMigrationNotifications.tsx:5-50`; `useDeprecationWarningNotification.tsx:6-42` |
| config-key handoff | old key copied to new key once | old key no longer accepted after handoff | deletion of old key + idempotent stop condition | who decides when old cleanup wording / key stops being honored at all | `migrateReplBridgeEnabledToRemoteControlAtStartup.ts:3-21` |
| plugin orphan world | version marked orphaned now | 7-day deadline before physical delete | grep/glob exclusion removes current-session visibility before delete | who decides whether old stronger-request cleanup world first loses visibility, then storage, or both at once | `cacheUtils.ts:23-24,52-74,89-105`; `orphanedPluginFilter.ts:1-15,35-38`; `main.tsx:2544-2568` |
| migration completed flags / timestamps | one-shot “migration already ran” lifecycle | do not themselves define retirement | none by themselves; only prove transition happened | who distinguishes migration completion from actual retirement | `main.tsx:323-345`; migration timestamp patterns |
| plans continuity | resume/fork continuity strategy keeps old plan world usable during transition | no explicit stronger-request cleanup sunset signal yet | continuity preserved; hard-close not yet defined | who decides when old plan path / old cleanup promise stops being resumable or recoverable | `plans.ts:153-255` |
| stronger-request cleanup current gap | migration / grace questions are now visible | no explicit sunset clock yet | old wording/path/receipt hard-close still absent | who decides when repaired stronger-request cleanup fully retires the old world rather than merely coexisting with it | current cleanup line evidence set |

## 3. 三个最重要的判断问题

判断一句“迁移已经有了，所以旧 stronger-request 世界也已经正式结束”有没有越级，先问三句：

1. 这里说的是 migration clock，还是 sunset clock
2. 当前旧世界只是被带过渡，还是已经从当前 visibility / acceptance surface 被切掉
3. 旧 artifact 还在磁盘上、还在 remap、还在 warning world 时，它究竟算不算 current truth

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “迁移脚本跑过一次，所以旧世界已经退役” | migration completion != sunset |
| “旧 artifact 还在磁盘上，所以仍然有效” | storage presence != current-world validity |
| “warning 已出现，所以退役治理已经足够” | warning surface != full sunset authority |
| “grace window 只是技术延迟，不是治理” | grace window is a core sunset decision |
| “visibility cutoff 只是搜索细节” | visibility sunset is often the first real retirement step |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup-sunset grammar 不是：

`migration arranged -> therefore old world is over`

而是：

`migration path exists -> compatibility period governed -> visibility cutoff governed -> hard-close signal governed`

只有这些层被补上，
stronger-request cleanup migration-governance 才不会继续停留在：

`系统已经知道旧世界怎样过渡，却没人正式决定旧世界从什么时候起不再算当前世界。`
