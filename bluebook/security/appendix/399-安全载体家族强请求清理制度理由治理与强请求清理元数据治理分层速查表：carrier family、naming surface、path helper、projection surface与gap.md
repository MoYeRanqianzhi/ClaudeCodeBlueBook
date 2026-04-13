# 安全载体家族强请求清理制度理由治理与强请求清理元数据治理分层速查表：carrier family、naming surface、path helper、projection surface与gap

## 1. 这一页服务于什么

这一页服务于 [415-安全载体家族强请求清理制度理由治理与强请求清理元数据治理分层](../415-安全载体家族强请求清理制度理由治理与强请求清理元数据治理分层.md)。

如果 `415` 的长文解释的是：

`为什么“系统已经知道不同 stronger-request old cleanup family 为什么存在不同 law”仍不等于“这些 why 已经被正式登记成系统自己的 metadata plane”，`

那么这一页只做一件事：

`把不同 stronger-request old cleanup family 当前实际拥有的 naming surface、path helper、projection surface 与 metadata gap 压成一张矩阵。`

## 2. 强请求清理制度理由治理与强请求清理元数据治理分层矩阵

| carrier family | naming surface | path helper / carrier | projection surface | current metadata gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| task outputs | `tasks` family + anti-clobber / `/clear` drift comment | `getTaskOutputDir() -> getProjectTempDir()/sessionId/tasks` | project-temp read allowance | truth explicit and strong, but still local to one helper/comment | who signs the jump from local anti-clobber grammar to shared family descriptor | `diskOutput.ts:33-55`; `permissions/filesystem.ts:1688-1700` |
| transcripts / subagents | `${sessionId}.jsonl`、`subagents/.../agent-${agentId}.jsonl` | `getTranscriptPath()`、`getTranscriptPathForSession()`、`getAgentTranscriptPath()` | `sessionProjectDir` atomic coupling for current-session path truth | continuity truth lives in path grammar, not in a shared family descriptor | who signs continuity metadata beyond local path composition | `sessionStorage.ts:202-225,247-258` |
| persisted tool-results | `tool-results` subdir + `<persisted-output>` tag + `${id}.json|txt` | `getToolResultsDir()`、`getToolResultPath()` | permission read allowance + cleanup traversal by literal subdir | inspection truth is spread across header, constants, helpers and cleanup | who signs when inspection metadata stops being a cross-file puzzle | `toolResultStorage.ts:1-5,26-31,94-116`; `permissions/filesystem.ts:1656-1672`; `cleanup.ts:155-257` |
| plans | `plansDirectory` + word slug + `-agent-` suffix | `getPlansDirectory()`、`getPlanFilePath()`、resume/fork copy helpers | `isSessionPlanFile()` read/write allow rules | settings/storage/permission/recovery know the truth, cleanup still mostly knows the default root | who signs a family whose cross-plane truth has no single canonical carrier | `settings/types.ts:824-830`; `plans.ts:32-48,79-110,119-129,164-229`; `permissions/filesystem.ts:244-255,1487-1495,1644-1652`; `cleanup.ts:300-303` |
| file-history | `file-history/<sessionId>/` | backup dir under `~/.claude/file-history/<sessionId>/` | none beyond local restore convention | stable naming exists, but restore duty still lives mostly in local code context | who signs restore metadata beyond the directory name itself | `fileHistory.ts:951-957`; `cleanup.ts:305-347` |
| session-env | `session-env/<sessionId>/` + `setup-hook-0.sh` grammar | `getSessionEnvDirPath()`、`getHookEnvFilePath()` | `CLAUDE_ENV_FILE` + hook load order + `HOOK_ENV_PRIORITY` | replay truth is split between env contract, file naming and sort order | who signs a family whose metadata is half env contract, half file grammar | `sessionEnvironment.ts:15-31,72-100,146-150` |
| debug logs | `--debug-file`、`CLAUDE_CODE_DEBUG_LOGS_DIR`、`${sessionId}.txt`、`latest` | `getDebugFilePath()`、`getDebugLogPath()` | argv/env enable surface + cleanup preserves `latest` by literal name | operational current-pointer truth exists, but not as a shared family descriptor | who signs when debug current-pointer semantics become canonical metadata | `debug.ts:44-56,91-101,230-249`; `cleanup.ts:391-428` |
| diagnostics | `DiagnosticLogEntry{timestamp,level,event,data}` | env-selected logfile via `getDiagnosticLogFile()` | `CLAUDE_CODE_DIAGNOSTICS_FILE` + no-PII host contract | truth explicit but local to host contract, not repo-wide family grammar | who signs a family whose metadata root lives outside repo-local cleanup world | `diagLogs.ts:5-12,14-20,27-60` |
| cleanup dispatcher | ordered cleanup function names | `cleanupOldMessageFilesInBackground()` | none | family plurality is known operationally, not metadata-driven | who turns hand-written execution order into shared family grammar | `cleanup.ts:575-598` |

## 3. 五个最快判断问题

判断一句

`系统已经知道为什么不同 family 要这样设计，所以 metadata 也已经在了`

有没有越级，先问五句：

1. 这里说的是制度理由，还是制度自我记忆
2. 当前 truth 住在 canonical carrier，还是只住在 local helper / comment / argv/env contract
3. 哪些平面真在消费同一份 truth，哪些只是 partial projection
4. 当前是不是把稳定命名偷写成了 shared descriptor
5. 当前是不是把 hand-written dispatcher 顺序偷写成了 policy registry

## 4. 最常见的六类误读

| 误读 | 实际问题 |
| --- | --- |
| `理由已经说清楚了，所以 metadata 不是问题` | rationale != metadata self-memory |
| `注释很清楚，所以系统已经自描述` | local explicitness != shared descriptor |
| `有 settings 字段就代表全链 metadata 完整` | knob != grammar |
| `permission rule 能识别 family，所以 canonical metadata 一定存在` | projection != source-of-truth |
| `dispatcher 已按 family 调度，所以这就是 registry` | execution order != metadata plane |
| `局部微语法已经很多，所以不再需要治理层` | plural microgrammar != shared canonical carrier |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup metadata grammar 不是：

`the system knows why -> therefore metadata already exists`

而是：

`family truth named -> canonical carrier chosen where needed -> multiple planes consume the same descriptor -> drift becomes inspectable`

只有这些层被补上，
stronger-request cleanup rationale 才不会继续停留在：

`制度已经会解释自己，却还没有把自己的解释登记成系统可持续复读的自我记忆。`
