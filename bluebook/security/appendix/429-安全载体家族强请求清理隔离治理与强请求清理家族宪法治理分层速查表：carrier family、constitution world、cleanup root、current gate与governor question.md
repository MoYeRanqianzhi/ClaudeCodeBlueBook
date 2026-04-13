# 安全载体家族强请求清理隔离治理与强请求清理家族宪法治理分层速查表：carrier family、constitution world、cleanup root、current gate与governor question

## 1. 这一页服务于什么

这一页服务于 [445-安全载体家族强请求清理隔离治理与强请求清理家族宪法治理分层](../445-安全载体家族强请求清理隔离治理与强请求清理家族宪法治理分层.md)。

如果 `445` 的长文解释的是：

`为什么 stronger-request cleanup 即便已经开始追问 noninterference，也仍不等于已经回答这些不同 old cleanup carriers 本来受哪部 cleanup law 管，`

那么这一页只做一件事：

`把 carrier family、constitution world、cleanup root、current gate 与 governor question 压成一张矩阵。`

## 2. 强请求清理隔离治理与强请求清理家族宪法治理分层矩阵

| carrier family | constitution world | cleanup root | current gate | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| task outputs | repaired session-scoped temp world | `getProjectTempDir()/sessionId/tasks` | scoped path by `sessionId` inside shared-readable project temp space | 谁来解释“共享可读 temp 世界里为什么 task outputs 要单独受 session-scoped law 管” | `src/utils/task/diskOutput.ts:50-55`; `src/utils/permissions/filesystem.ts:1688-1700` |
| transcripts | project-session sweep world | `projects/<project>/<session>.jsonl/.cast` | file-age cleanup under project directory | 谁来解释 continuity carrier 为什么继续留在 project/session retention world | `src/utils/sessionStorage.ts:198-224`; `src/utils/cleanup.ts:155-190` |
| persisted tool-results | project-session subdir world | `projectDir/sessionId/tool-results` | session-dir traversal + mtime sweep | 谁来解释 inspection carrier 为什么没有被提升进 repaired temp world | `src/utils/toolResultStorage.ts:94-105`; `src/utils/cleanup.ts:155-190` |
| plans | default home-root single-directory world with optional project-root write override | default `~/.claude/plans`; optional `settings.plansDirectory` under project root | visible cleanup only sweeps default `~/.claude/plans/*.md` | 谁来解释 write root 与 cleanup root 不完全重合时，究竟哪一条 law 才是 authoritative | `src/utils/plans.ts:79-110`; `src/utils/cleanup.ts:300-303` |
| file-history | home-root per-session-dir world | `~/.claude/file-history/<sessionId>/` | recursive dir rm by dir mtime | 谁来解释 restore backup world 为什么受 per-session-dir law 管 | `src/utils/fileHistory.ts:951-957`; `src/utils/cleanup.ts:305-342` |
| session-env | home-root per-session-dir world | `~/.claude/session-env/<sessionId>/` | recursive dir rm by dir mtime | 谁来解释 environment replay world 为什么与 file-history 相似却仍是独立 family | `src/utils/sessionEnvironment.ts:15-22`; `src/utils/cleanup.ts:346-378` |
| debug logs | home-root log-plus-symlink world | `~/.claude/debug/<sessionId>.txt` plus `latest` symlink | delete old `.txt`, preserve `latest` symlink | 谁来解释 operational debugging world 为什么自带 preserve-latest rule | `src/utils/debug.ts:230-249`; `src/utils/cleanup.ts:382-428` |
| diagnostics | host/env-selected external world | `CLAUDE_CODE_DIAGNOSTICS_FILE` | host-selected append-only sink visible from repo-local plane | 谁来解释 external diagnostics carrier 为什么不与 repo-local cleanup families 同法 | `src/utils/diagLogs.ts:27-60` |
| cleanup dispatcher | stitched plural-law execution plane | no single root | hardcoded sequential dispatch by family | 谁来解释为什么同一 background executor 调度多种 law，却没有显式 constitution registry | `src/utils/cleanup.ts:575-598` |

## 3. 三个最重要的判断问题

判断一句“现在 stronger-request cleanup 已开始证明不误伤，所以家法也已经收口”有没有越级，先问三句：

1. 当前回答的是 delete noninterference，还是 carrier legal-world assignment
2. 当前证据说明的是某个 family 的 root/gate，还是整个 cleanup plane 的统一 constitution
3. 当前 visible cleanup plane 只是会 dispatch，还是也会解释为什么这些 family 分别受不同 law 管

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “既然删不伤人，家法当然已经成立” | isolation proof != constitution proof |
| “task outputs 已 session-scoped，所以别的 family 也自然同法” | one-family repair != all-family law |
| “都在 `projects/` 或都在 `~/.claude/`，说明本来就是一个世界” | same broad root != same cleanup gate |
| “同一个 background cleanup 在调度它们，所以 law 已统一” | same dispatcher != same constitution |
| “diagnostics 在外部路径，所以不算 cleanup constitution 问题” | external world is still part of the total security surface |

## 5. 技术启示四条

1. destructive system 需要同时显化 `root` 与 `gate`，否则 law world 会被路径相似性偷平。
2. shared-readable world 里的 family-specific repair，不能替代整个 cleanup plane 的 constitution explanation。
3. home-root family 常常不是一部法，而是多条子宪法并存。
4. 背景调度器可以统一执行，但不能顺手冒充统一立法机关。

## 6. 一条硬结论

真正成熟的 stronger-request cleanup constitution grammar 不是：

`cleanup has started to prove noninterference -> therefore all families already live under one settled law`

而是：

`carrier family identified -> constitution world named -> cleanup root and gate explained -> law difference justified -> then isolation proof and constitution proof each speak within their own boundary`

只有中间这些层被补上，
`cleanup-isolation` 才不会继续越级冒充：

`cleanup-constitution`
