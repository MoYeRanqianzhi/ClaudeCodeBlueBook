# 安全载体家族强请求清理制度理由治理与强请求清理元数据治理分层速查表：carrier family、naming surface、path helper、env contract与gap

## 1. 这一页服务于什么

这一页服务于 [383-安全载体家族强请求清理制度理由治理与强请求清理元数据治理分层](../383-安全载体家族强请求清理制度理由治理与强请求清理元数据治理分层.md)。

如果 `383` 的长文解释的是：

`为什么“系统已经知道不同 stronger-request old cleanup family 为什么存在不同 law”仍不等于“这些 why 已经被正式保存成统一 metadata plane”，`

那么这一页只做一件事：

`把 stronger-request old cleanup family 当前散落的 naming surface、path helper、env contract 与 metadata gap 压成一张矩阵。`

## 2. 强请求清理制度理由治理与强请求清理元数据治理分层矩阵

| carrier family | naming surface | path helper / carrier | env / contract surface | current metadata gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| task outputs | `tasks` family + local clobber-repair comment | `getTaskOutputDir() -> getProjectTempDir()/sessionId/tasks` | none beyond session identity; rationale stays in helper comment | truth explicit but still local to one helper/comment | who signs the jump from local explicit note to reusable family descriptor | `diskOutput.ts:33-49` |
| transcripts | `cleanupPeriodDays` transcript wording | `getProjectsDir()`, `getTranscriptPath()`, `getTranscriptPathForSession()` | none; continuity truth inferred from session persistence layout | continuity/replay truth still reconstructed across helpers and cleanup traversal | who signs a transcript family whose why is visible only through path composition and cleanup behavior | `settings/types.ts:325-332`; `sessionStorage.ts:198-224`; `cleanup.ts:575-598` |
| persisted tool-results | `tool-results` subdir constant + persisted-output vocabulary | `getSessionDir()`, `getToolResultsDir()`, `getToolResultPath()` | read allowance projected into permission plane | inspection truth is spread across header, constants, helpers, permission projection and cleanup traversal | who signs a family whose metadata is still a cross-file puzzle rather than a canonical descriptor | `toolResultStorage.ts:1-5,26-31,94-124`; `permissions/filesystem.ts:1656-1672`; `cleanup.ts:155-257` |
| plans | `plansDirectory` setting + plan slug naming | `getPlansDirectory()`, plan file naming, session plan matching | permission plane explicitly recognizes current-session plan files | settings/storage/permission/resume know the override, cleanup still mostly knows the default root | who signs cross-plane plan truth when no single metadata carrier keeps all planes aligned | `settings/types.ts:824-830`; `plans.ts:79-110,164-233`; `permissions/filesystem.ts:244-255,1487-1495,1644-1652`; `cleanup.ts:300-303` |
| file-history | `file-history` dir naming | `~/.claude/file-history/<sessionId>/` | none; restore duty inferred from backup directory semantics | stable naming exists, but duty still lives mostly in local code context | who signs restore-backup metadata beyond the directory name itself | `fileHistory.ts:951-957`; `cleanup.ts:305-347` |
| session-env | `session-env` dir naming + hook-file grammar | `getSessionEnvDirPath()`, `getHookEnvFilePath()` | `CLAUDE_ENV_FILE` and hook file loading order | replay truth spans env contract, helper names and loader semantics | who signs a family whose metadata is split between helper naming and env-loading contract | `sessionEnvironment.ts:15-22,25-31,60-143` |
| debug logs | debug level / file / path helpers | `getDebugFilePath()`, `getDebugLogPath()` | `DEBUG`, `DEBUG_SDK`, `--debug`, `--debug-file`, `CLAUDE_CODE_DEBUG_LOGS_DIR` | operational debugging truth is distributed across argv/env conventions and helper logic | who signs when argv/env convention becomes canonical metadata rather than incidental control flow | `debug.ts:30-68,91-111,216-235`; `cleanup.ts:391-428` |
| diagnostics | no-PII monitoring comment + event/log schema | `getDiagnosticLogFile()` via `CLAUDE_CODE_DIAGNOSTICS_FILE` | host-visible env-managed logfile contract | truth explicit but remains host-contract local, not repo-wide family metadata | who signs a family whose metadata root lives in env contract instead of repo-local registry | `diagLogs.ts:11-20,27-60` |
| cleanup dispatcher itself | ordered function names are the de facto registry | `cleanupOldMessageFilesInBackground()` | none | family list exists only as handwritten execution sequence | who turns execution order into metadata-driven family grammar | `cleanup.ts:575-598` |

## 3. 五个最快判断问题

判断一句

`系统已经知道为什么不同 family 要这样设计，所以 metadata 也已经在了`

有没有越级，先问五句：

1. 这里说的是 rationale，还是 canonical metadata carrier
2. 当前 family truth 是存在于 settings schema、path helper、permission projection、comment，还是 env/argv contract
3. 这些 truth 是否能被多平面共读，还是仍需研究者跨文件重建
4. 当前是不是把局部 explicit comment 偷写成全局 metadata plane
5. 当前是不是把 hand-written dispatcher 顺序偷写成 family registry

## 4. 最常见的六类误读

| 误读 | 实际问题 |
| --- | --- |
| `理由已经说清楚了，所以 metadata 不是问题` | rationale != metadata carrier |
| `注释很清楚，所以系统已经自描述` | local explicitness != shared descriptor |
| `有 settings 字段就代表全链 metadata 完整` | knob != grammar |
| `permission rule 能识别 family，所以 canonical metadata 一定存在` | partial projection != canonical source |
| `dispatcher 已按 family 调度，所以这就是 registry` | execution order != metadata plane |
| `稳定 helper 名字就已经足够防漂移` | stable local syntax != cross-plane propagation guarantee |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup-metadata grammar 不是：

`the system knows why -> therefore metadata already exists`

而是：

`family truth named -> canonical carrier chosen -> multiple planes consume the same descriptor -> drift becomes detectable`

只有这些层被补上，
stronger-request cleanup rationale 才不会继续停留在：

`系统已经知道不同 family 为什么存在不同 law，却没人正式把这些 why 保存成能被 settings、helpers、permissions、env contract 与 cleanup plane 共读的统一 metadata。`
