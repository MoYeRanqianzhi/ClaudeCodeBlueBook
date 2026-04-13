# diskOutput、sessionStorage、toolResultStorage、plans、fileHistory、sessionEnvironment、debug、diagLogs与cleanup的强请求清理家族宪法边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `445` 时，
真正需要被单独钉住的已经不是：

`这次 stronger-request cleanup 会不会误伤 live peer，`

而是：

`这些 stronger-request old cleanup carriers 为什么明显活在不同 cleanup constitution 里，而且这些 constitution 现在到底由哪些 root 与 gate 具体承载。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`stronger-request cleanup-isolation governor 不等于 stronger-request cleanup-constitution governor。`

这句话还不够硬。

所以这里单开一篇，只盯住：

- `src/utils/task/diskOutput.ts`
- `src/utils/permissions/filesystem.ts`
- `src/utils/sessionStorage.ts`
- `src/utils/toolResultStorage.ts`
- `src/utils/plans.ts`
- `src/utils/fileHistory.ts`
- `src/utils/sessionEnvironment.ts`
- `src/utils/debug.ts`
- `src/utils/diagLogs.ts`
- `src/utils/cleanup.ts`

把 repaired temp world、project-session sweep world、plural home-root worlds、host-external diagnostics world 与 hardcoded family dispatcher 并排，
逼出一句更硬的结论：

`Claude Code 已经明确展示：开始追问 stronger-request cleanup 不伤人，并不等于已经回答这些 old carriers 本来受哪部 cleanup 家法统治；carrier legal world 需要自己的治理层。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 现在有 cleanup，也已经开始直面 destructive noninterference。`

而是：

`Claude Code 已经在 stronger-request old cleanup surface 上公开展示至少四种不同 cleanup world：repaired session temp、project-session sweep、plural home-root constitutions 与 host-external diagnostics constitution。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| repaired temp world | `src/utils/task/diskOutput.ts:50-55`; `src/utils/permissions/filesystem.ts:1688-1700` | 为什么 live runtime task outputs 现在受 session-scoped temp law 管 |
| project-session sweep world | `src/utils/sessionStorage.ts:198-224`; `src/utils/toolResultStorage.ts:94-105`; `src/utils/cleanup.ts:155-190` | 为什么 transcripts 与 persisted tool-results 仍活在 project/session sweep law 里 |
| plans world | `src/utils/plans.ts:79-110`; `src/utils/cleanup.ts:300-303` | 为什么 plans 已暴露 write root 与 cleanup root 的 constitution split |
| home-root per-session worlds | `src/utils/fileHistory.ts:951-957`; `src/utils/sessionEnvironment.ts:15-22`; `src/utils/cleanup.ts:305-378` | 为什么 file-history 与 session-env 活在 per-session-dir law 里 |
| debug world | `src/utils/debug.ts:230-249`; `src/utils/cleanup.ts:382-428` | 为什么 debug logs 受 preserve-latest operational law 管 |
| host-external diagnostics world | `src/utils/diagLogs.ts:27-60` | 为什么 diagnostics 从 repo-local 视角看更像 external constitution |
| family-by-family dispatcher | `src/utils/cleanup.ts:575-598` | 为什么 visible cleanup plane 更像 stitched plural laws，而不是显式 constitution registry |

## 4. `diskOutput.ts` 与 `filesystem.ts` 先把 repaired temp constitution 钉死：task-output family 已被单独立法

`diskOutput.ts:50-55`
很短，
但它做的是一件非常“立法”的事：

1. task outputs 落在 `getProjectTempDir()/sessionId/tasks`
2. `sessionId` 被写进路径，而不是只放在文件名或内存状态里
3. 这意味着同一个 project temp world 之内，task-output family 被单独切出 session-scoped delete boundary

再看 `permissions/filesystem.ts:1688-1700`：

1. project temp dir 仍 intentionally allows reading files from all sessions in this project
2. 说明这个世界的关键不是“完全不可见”
3. 而是“shared-readable temp world 里，task outputs 仍要受更窄的 delete constitution 管”

这两处代码合在一起说明：

`task-output family already lives in a repaired session-scoped temp constitution, not in a generic temp-law blob`

也因此，
task outputs 的 noninterference repair 不能直接越级冒充：

`all stronger-request cleanup carriers now share the same law`

## 5. `sessionStorage`、`toolResultStorage` 与 `cleanupOldSessionFiles()` 再证明：persisted session carriers 仍活在 project-session sweep law

`sessionStorage.ts:198-224`
说明 transcript path 走：

`projects/<project>/<session>.jsonl`

`toolResultStorage.ts:94-105`
说明 tool-results 走：

`projectDir/sessionId/tool-results`

再看 `cleanup.ts:155-190`：

1. cleanup 会先进入 `projectsDir`
2. 再逐个进入每个 `projectDir`
3. 清理 `.jsonl`、`.cast`
4. 再深入 `sessionDir/tool-results`
5. 整体 gate 主要仍是 `mtime < cutoffDate`

这里最重要的事实不是：

`这些 carrier 一定有 bug`

而是：

`persisted conversational carriers currently live in a project-session sweep constitution, not in the repaired temp constitution`

换句话说，
同样是 stronger-request old cleanup carriers，
live runtime output 与 persisted transcript/tool-result 已经明确生活在不同 cleanup world。

## 6. `plans`、`fileHistory`、`sessionEnvironment` 与 `debug` 把问题继续推进：home-root 不是一部法律，而是多条子宪法并存

`plans.ts:79-110`
说明：

1. plans 默认落在 `~/.claude/plans`
2. 也可以通过 `settings.plansDirectory` 被改到 project root 内
3. 但 `cleanup.ts:300-303` 的 `cleanupOldPlanFiles()` 仍固定清默认 `join(getClaudeConfigHomeDir(), 'plans')`

这意味着：

`plans family already exposes a constitution split between write placement and visible cleanup root`

它不只是路径技巧，
而是 cleanup law 对齐关系本身尚未被完全明说。

再看 `fileHistory.ts:951-957` 与 `cleanup.ts:305-342`：

1. file-history 写在 `~/.claude/file-history/<sessionId>/`
2. cleanup 按 session directory 的 `mtime` 做 recursive rm

`sessionEnvironment.ts:15-22` 与 `cleanup.ts:346-378` 也一样：

1. session-env 写在 `~/.claude/session-env/<sessionId>/`
2. cleanup 也是按 session directory 的 `mtime` 做 recursive rm

最后再看 `debug.ts:230-249` 与 `cleanup.ts:382-428`：

1. debug log 默认落在 `~/.claude/debug/<sessionId>.txt`
2. 同时维护 `latest` symlink
3. cleanup 只删旧 `.txt`
4. 且明确保留 `latest`

这些代码合在一起说明：

`home-root world itself is constitutionally plural`

至少已经能分出：

1. plans default single-directory law
2. file-history per-session-dir law
3. session-env per-session-dir law
4. debug log plus preserve-latest operational law

所以：

`same broad root under ~/.claude does not imply same cleanup constitution`

## 7. `diagLogs.ts` 最后给出最强边界：有些 carrier 根本不在 repo-local cleanup constitution plane 里

`diagLogs.ts:27-60`
非常短，
但它把边界写得很硬：

1. diagnostics 只看 `CLAUDE_CODE_DIAGNOSTICS_FILE`
2. visible action 是 append line
3. repo-local 看不到与 `cleanup.ts` 对等的 diagnostics cleanup function

这说明 diagnostics carrier 当前不能被稳妥地归入：

1. repaired temp constitution
2. project-session sweep constitution
3. plural home-root constitutions

更稳的技术判断是：

`diagnostics currently appears as a host/env-selected external constitution from the repo-local viewpoint`

这使 stronger-request cleanup constitution 的边界一下子更硬：

`有些 old cleanup carrier 连家法世界都不在 repo-local visible cleanup plane 内。`

## 8. `cleanupOldMessageFilesInBackground()` 让缺口更具体：repo 知道 family plurality，却还没有 equally explicit constitution registry

`cleanup.ts:575-598`
当前做的是：

1. `cleanupOldMessageFiles()`
2. `cleanupOldSessionFiles()`
3. `cleanupOldPlanFiles()`
4. `cleanupOldFileHistoryBackups()`
5. `cleanupOldSessionEnvDirs()`
6. `cleanupOldDebugLogs()`
7. image caches、pastes、stale worktrees 等

这条 dispatcher 的价值很高。

因为它说明 repo 不是不知道 family plurality。
相反，
它非常知道。

真正的边界恰恰在于：

`visible cleanup plane knows how to dispatch plural families operationally, but does not yet expose an equally explicit constitution plane that explains why these laws differ`

换句话说，
当前显露出来的是：

`plural cleanup executors`

而还不是：

`fully signed plural cleanup constitutions`

## 9. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 只要已经开始追问 noninterference，就可以被视为 constitutionally settled`

而是：

`repo 已经在 repaired session temp world、project-session sweep world、plural home-root worlds、host-external diagnostics world 与 hardcoded family dispatcher 上，清楚展示了 stronger-request cleanup constitution 的独立存在；因此 artifact-family cleanup stronger-request cleanup-isolation-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-constitution-governor signer。`

因此：

`cleanup 线真正缺的，不只是“谁来证明这次 stronger-request cleanup 不会误伤 live peer”，还包括“谁来正式解释这些 stronger-request old carriers 为什么本来就生活在不同 cleanup law 里，以及这些 law 的 root、gate 与边界为什么配这样存在”。`
