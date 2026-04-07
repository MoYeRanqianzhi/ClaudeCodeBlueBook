# 安全载体家族强请求清理家族宪法治理与强请求清理制度理由治理分层速查表：carrier family、primary risk object、operational duty、host visibility与rationale drift

## 1. 这一页服务于什么

这一页服务于 [287-安全载体家族强请求清理家族宪法治理与强请求清理制度理由治理分层：为什么artifact-family cleanup stronger-request cleanup-constitution-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-rationale-governor signer](../287-安全载体家族强请求清理家族宪法治理与强请求清理制度理由治理分层.md)。

如果 `287` 的长文解释的是：

`为什么“不同 stronger-request old cleanup carriers 已活在不同 cleanup law 里”仍不等于“这些 law 的制度理由已经被清楚保存”，`

那么这一页只做一件事：

`把 stronger-request old cleanup family 背后的 risk object、operational duty、host visibility 与 rationale drift 压成一张矩阵。`

## 2. 强请求清理家族宪法治理与强请求清理制度理由治理分层矩阵

| carrier family | primary risk object | operational duty | host visibility | rationale drift | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| task outputs | same-project live clobber / path reachability / in-flight ENOENT | serve live runtime output without cross-session clobber | low to medium; project temp is shared-readable but still scoped for delete/write | low; reason is explicit in comment | who signs why live runtime output deserves repaired temp law | `diskOutput.ts:31-49`; `permissions/filesystem.ts:1688-1700`; `TaskOutput.ts:313-325` |
| persisted tool-results | large-output post-hoc inspection after execution | persist results instead of truncating them; allow preview/readback | medium; project-session persisted artifact | medium; reason is present but more implicit than task outputs | who signs why inspection duty keeps this family in project-session world | `toolResultStorage.ts:1-5,94-118`; `cleanup.ts:155-257` |
| transcripts / casts | continuity / replay / session history readability | preserve session record for later replay and continuity | medium; session persistence surface | medium; rationale inferred from placement and replay duty | who signs why continuity duty differs from tool-result inspection duty even in the same constitution world | `sessionStorage.ts:198-220`; `cleanup.ts:155-195` |
| plans | planning autonomy + current-session coordination + resume recovery | keep active plan artifact readable and recoverable; optionally project-root visible | medium to high; can move into project root | high; storage reason allows override, cleanup still assumes default root | who signs why plan family may leave home-root while cleanup executor still targets the old default world | `plans.ts:79-106,164-233`; `cleanup.ts:300-303` |
| file-history | restore edited-file safety net | keep per-session backups recoverable until retention expiry | medium; home-root restore surface | low to medium; law and duty are relatively aligned | who signs why restore backup should be bucketed by session dir and deleted as a whole | `fileHistory.ts:951-957`; `cleanup.ts:305-347` |
| session-env | execution-environment replay | reconstruct hook/env state deterministically for later commands | medium; home-root replay surface | low to medium; law and duty are relatively aligned | who signs why environment replay belongs in per-session home-root retention instead of project/session tree | `sessionEnvironment.ts:14-21,60-140`; `cleanup.ts:350-387` |
| debug logs | operational debugging / `/share` / bug-report support | preserve current and recent debug trail; keep `latest` pointer | high for debug operator; not generic product persistence | medium; operational duty explicit but separate from other retained carriers | who signs why debug must preserve a current operational surface while old files age out | `debug.ts:30-68,91-111,229-249`; `cleanup.ts:391-428` |
| diagnostics | no-PII host monitoring from within container | report issues to session-ingress through env-managed logfile | very high; host-visible external surface | not drift but constitutional exception; rationale belongs to host-monitoring world | who signs a carrier whose reason is host monitoring rather than repo-local persistence | `diagLogs.ts:11-20,27-60` |

## 3. 三个最重要的判断问题

判断一句“这些 stronger-request carrier family 已经有不同 cleanup constitution，所以理由也自然成立”有没有越级，先问三句：

1. 这里说的是 storage / cleanup root，还是 primary risk object 与 operational duty
2. 这个 family 的核心价值是 live runtime、inspection continuity、planning recovery、restore/replay，还是 host monitoring
3. 当前 executor、permission rule、resume path 与 storage override 是否仍然共享同一套理由

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “家法不同，所以理由一定也被系统建模了” | constitution != rationale |
| “tool-results 和 transcripts 都在 project-session world，所以理由差不多” | inspection duty != continuity/replay duty |
| “plans 能配置目录，所以 cleanup 自然会懂这个理由” | configurable storage != synchronized cleanup rationale |
| “file-history 和 session-env 都是 home-root/session-dir，所以是一回事” | restore backup != environment replay |
| “diagnostics 只是外接日志文件，不需要再解释理由” | host-monitoring rationale is still a signed governance question |

## 5. 技术启示四条

1. 分家法不等于分理由。
2. 同一法律世界里也可能住着不同 risk object。
3. 可配置存储最容易暴露 rationale drift。
4. host-visible carrier 会逼迫系统把“为什么存在”说得比“放在哪里”更清楚。

## 6. 一条硬结论

真正成熟的 stronger-request cleanup-rationale grammar 不是：

`carrier family split across multiple laws -> therefore the reasons are obvious`

而是：

`primary risk object named -> operational duty stated -> host visibility explained -> cleanup law justified -> drift checked`

只有这些层被补上，
stronger-request cleanup constitution 才不会继续停留在：

`系统已经把 old cleanup 分到不同 law 里，却没人正式解释这些 law 为什么成立、哪里已经开始理由漂移。`
