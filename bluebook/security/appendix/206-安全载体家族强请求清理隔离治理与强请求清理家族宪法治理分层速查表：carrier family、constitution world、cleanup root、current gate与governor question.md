# 安全载体家族强请求清理隔离治理与强请求清理家族宪法治理分层速查表：carrier family、constitution world、cleanup root、current gate与governor question

## 1. 这一页服务于什么

这一页服务于 [222-安全载体家族强请求清理隔离治理与强请求清理家族宪法治理分层：为什么artifact-family cleanup stronger-request cleanup-isolation-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-constitution-governor signer](../222-安全载体家族强请求清理隔离治理与强请求清理家族宪法治理分层.md)。

如果 `222` 的长文解释的是：

`为什么“当前 stronger-request cleanup 不误伤 live peer”仍不等于“不同 stronger-request old cleanup carriers 已经服从同一套 cleanup constitution”，`

那么这一页只做一件事：

`把 stronger-request old cleanup 当前分布的几种 cleanup world 压成一张矩阵。`

## 2. 强请求清理隔离治理与强请求清理家族宪法治理分层矩阵

| carrier family | constitution world | cleanup root | current gate | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| task outputs | repaired session-scoped temp constitution | `projectTempDir/sessionId/tasks` | scoped path + same-project clobber repair | who signs why live runtime output earned a dedicated temp law instead of the older project sweep | `TaskOutput.ts:313-325`; `diskOutput.ts:31-49`; `permissions/filesystem.ts:1688-1700` |
| transcripts + persisted tool-results | project-session sweep constitution | `projects/<project>/<session>` | project-root traversal + cutoff date + mtime sweep | who signs why persisted session carriers still live in project/session buckets rather than the repaired temp world | `sessionStorage.ts:198-220`; `toolResultStorage.ts:94-118`; `cleanup.ts:155-257` |
| plans | home-root single-directory constitution with project-root override pressure | default `~/.claude/plans` | `cleanupSingleDirectory('.md')` on default plans root | who signs the default-vs-override constitution, especially when visible cleanup still targets the default home-root world | `plans.ts:79-106`; `cleanup.ts:300-303` |
| file-history + session-env | home-root per-session-dir retention constitution | `~/.claude/file-history/<session>` / `~/.claude/session-env/<session>` | dir mtime + recursive rm | who signs why these operational persistence carriers are grouped by session dir and cleaned as whole directories | `fileHistory.ts:951-957`; `sessionEnvironment.ts:14-21`; `cleanup.ts:305-387` |
| debug logs | home-root operational-log constitution with latest-symlink preservation | `~/.claude/debug/<session>.txt` | age-based delete of old `.txt` files while preserving `latest` | who signs why debug carriers keep an operational `latest` surface instead of sharing the other home-root laws | `debug.ts:229-249`; `cleanup.ts:391-428` |
| diagnostics | host/env-selected external constitution | `CLAUDE_CODE_DIAGNOSTICS_FILE` | env-selected append-only writer; repo-local cleanup not visible | who signs a stronger-request old cleanup carrier whose root and retention plane may live outside repo-local cleanup | `diagLogs.ts:27-60` |
| visible cleanup dispatcher | stitched plural constitutions, not one explicit constitution plane | `cleanupOldMessageFilesInBackground()` | hardcoded family-by-family dispatch | who turns these heterogeneous cleaners into an explicit stronger-request cleanup constitution instead of a sequential call list | `cleanup.ts:575-595` |

## 3. 三个最重要的判断问题

判断一句“当前 stronger-request cleanup 已经不误伤 live peer，所以 cleanup constitution 也已经收口”有没有越级，先问三句：

1. 这里说的是 noninterference proof，还是 family-specific legal world
2. 这个 carrier 当前活在 temp、project-session、home-root，还是 host-external constitution
3. visible cleanup plane 是在执行一条统一 policy，还是只是在顺次 dispatch 几条不同家法

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “现在不误伤 live peer，所以 cleanup law 已统一” | noninterference != constitution closure |
| “task outputs 已修好，所以 stronger-request carriers 都已进 temp world” | repaired family != generalized constitution |
| “都由 cleanup.ts 触发，所以本来就是同一条 policy” | same dispatcher != same law |
| “都在 `~/.claude/*`，所以 plans/debug/file-history/session-env 是同一家法” | home-root still contains multiple constitutions |
| “diagnostics 只是外接文件，不算 cleanup constitution” | host-external carrier is still a constitutional question |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup-constitution grammar 不是：

`cleanup no longer hurts live peers -> therefore all old cleanup carriers share one law`

而是：

`carrier family identified -> legal world named -> cleanup root and gate justified -> override/external boundary explained -> only then can the constitution be said to exist`

只有中间这些层被补上，
cleanup stronger-request isolation 才不会继续停留在：

`它能回答这次 cleanup 会不会伤到人，却没人正式解释不同 stronger-request old cleanup carriers 为什么分别生活在不同 cleanup law 里。`
