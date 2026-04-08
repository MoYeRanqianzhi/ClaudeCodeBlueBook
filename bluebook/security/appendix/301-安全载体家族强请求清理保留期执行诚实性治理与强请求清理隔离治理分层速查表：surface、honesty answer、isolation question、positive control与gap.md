# 安全载体家族强请求清理保留期执行诚实性治理与强请求清理隔离治理分层速查表：surface、honesty answer、isolation question、positive control与gap

## 1. 这一页服务于什么

这一页服务于 [317-安全载体家族强请求清理保留期执行诚实性治理与强请求清理隔离治理分层](../317-安全载体家族强请求清理保留期执行诚实性治理与强请求清理隔离治理分层.md)。

如果 `317` 的长文解释的是：

`为什么 stronger-request cleanup 即便已经被更诚实地说明，也仍不等于已经被证明对 same-project live peers 无害，`

那么这一页只做一件事：

`把 repo 里现成的 honesty answer、isolation question、positive control 与 current gap 压成一张矩阵。`

## 2. 强请求清理保留期执行诚实性治理与强请求清理隔离治理分层矩阵

| surface | honesty answer already available | isolation question still open | positive control | current gap | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| historical task-output failure | system now honestly preserves the historical failure mode instead of silently swallowing ENOENT | who proves another same-project session's cleanup can no longer delete a live task output | diagnostic string explicitly names same-project startup cleanup | incident memory exists, but incident memory != noninterference proof | `TaskOutput.ts:313-324` |
| repaired task-output family | task-output cleanup/isolation problem has been made visible and concretely repaired in one family | who generalizes that repair strength beyond `tasks/` | `getProjectTempDir()/sessionId/tasks` session-scoped architecture | family-specific repair != family-wide proof | `diskOutput.ts:33-55` |
| shared project temp surface | repo honestly declares project temp as cross-session readable | who proves delete operations inside a shared-readable world are live-peer safe | shared-read policy is explicit rather than implicit | shared read surface still needs stricter delete discipline | `permissions/filesystem.ts:1688-1700` |
| persisted tool-results | executor coverage can honestly include session-scoped tool-results under project tree | who proves mtime-based sweep will not remove a carrier still relied on by another live peer | session-specific path exists | visible cleanup still sweeps by directory + age, with no visible live-peer consultation | `toolResultStorage.ts:94-118`; `cleanup.ts:155-257` |
| broader old cleanup carriers | system can honestly say cleanup touches plans, file-history, session-env, debug logs, image caches, pastes, stale worktrees | who proves those broader carriers are cleaned without harming same-project live sessions | cleanup functions are explicit and visible | wider execution coverage != wider isolation proof | `cleanup.ts:300-348,350-428,575-598` |
| live-session knowledge | repo already knows which sessions are alive and can sweep stale PID files | who connects that knowledge to destructive cleanup decisions | `~/.claude/sessions/<pid>.json` ledger + PID probe | ledger exists, but cleanup path does not visibly consume it | `concurrentSessions.ts:49-109,163-204` |
| same-project coordination primitive | repo already knows how to elect exactly one owner in a same-project multi-session world | who elects the cleanup owner when multiple sessions share a carrier world | scheduler lock with `O_EXCL`, PID liveness probe, stale takeover | positive control exists elsewhere, but not yet as visible cleanup governance | `cronTasksLock.ts:1-15,49-57,100-170`; `cronScheduler.ts:40-44` |

## 3. 五个最快判断问题

判断一句

`当前 stronger-request cleanup 已经被更诚实地说明，所以可以视为安全隔离`

有没有越级，先问五句：

1. 这里回答的是 execution truth，还是 live-peer noninterference proof
2. 当前证据说明的是某个 family 已修，还是整个 cleanup carrier world 已被证明无害
3. 当前 cleanup path 有没有 visibly consult live-session ledger、owner lease 或等强 primitive
4. 当前 shared-readable surface 是否被偷写成 shared-safe-delete surface
5. 当前 positive control 是不是只存在于别处，而没有正式进入 cleanup governor

## 4. 最常见的六类误读

| 误读 | 实际问题 |
| --- | --- |
| `cleanup truth 说清了，所以 cleanup 就安全了` | honesty answer != isolation proof |
| `task outputs 已经改成 session-scoped，所以全部 family 都已隔离` | one-family repair != generalized cleanup constitution |
| `同项目 temp space 可跨 session 读，所以删也没关系` | shared-readable surface still needs delete-boundary proof |
| `repo 既然有 concurrentSessions，就说明 cleanup 肯定 consult 它` | ledger exists != ledger consumed |
| `cron scheduler 已有 single-owner lock，所以 cleanup 自然也有` | positive control elsewhere != cleanup governor here |
| `mtime sweep 只删旧文件，所以 live peer 自然不会受伤` | age-based deletion != liveness-aware deletion |

## 5. 技术启示五条

1. 诚实说明执行状态，不等于证明执行无害。
2. 一处 family-specific repair 不能自动代表全局 noninterference。
3. shared-readable surface 需要更强的 delete proof，而不是更弱。
4. live-session ledger 与 owner lease 只有被 destructive path 消费时才算治理成立。
5. age-based cleanup 不是 live-peer-safe cleanup 的同义词。

## 6. 一条硬结论

真正成熟的 stronger-request cleanup-isolation grammar 不是：

`cleanup truth honestly reported -> therefore no live peer was harmed`

而是：

`carrier family identified -> live peers knowable -> owner or liveness signal consulted -> cleanup executed -> noninterference demonstrated`

只有中间这些层被补上，
cleanup stronger-request retention-enforcement honesty 才不会继续停留在：

`它能更诚实地说明 stronger-request cleanup 现在执行到了哪里，却没人正式证明这次执行不会误伤同项目 live peer 仍在依赖的 carrier。`
