# diskOutput、sessionStorage、toolResultStorage、cleanup、debug与diagLogs的强请求清理家族宪法边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `190` 时，
真正需要被单独钉住的已经不是：

`这次 stronger-request cleanup 会不会误伤 live peer，`

而是：

`为什么 stronger-request old echo carriers 当前明显活在不同 cleanup constitution 里。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`stronger-request cleanup isolation governor 不等于 stronger-request cleanup constitution governor。`

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

把 repaired temp world、project-session sweep world、home-root retention worlds 与 host-external diagnostics world 并排，
逼出一句更硬的结论：

`Claude Code 已经明确展示：stronger-request old echo 并不生活在单一 cleanup law 里；因此 noninterference proof 仍不能替代 family constitution proof。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 现在有 cleanup，也已经知道不能误伤 live peer。`

而是：

`Claude Code 已经在 stronger-request old echo surface 上公开展示至少四种不同 cleanup world：repaired session temp、project-session sweep、home-root retention 与 host-external diagnostics。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| repaired temp world | `src/utils/task/diskOutput.ts:31-49`; `src/utils/permissions/filesystem.ts:1688-1700` | 为什么 live runtime task output 现在服从 session-scoped temp constitution |
| project-session sweep world | `src/utils/sessionStorage.ts:198-220`; `src/utils/toolResultStorage.ts:94-118`; `src/utils/cleanup.ts:155-257` | 为什么 transcripts 与 persisted tool-results 仍服从 project-rooted retention sweep |
| home-root plan/debug/backup/env worlds | `src/utils/plans.ts:79-106`; `src/utils/fileHistory.ts:951-957`; `src/utils/sessionEnvironment.ts:14-21`; `src/utils/debug.ts:229-249`; `src/utils/cleanup.ts:300-428` | 为什么离开 project tree 后，home-root cleanup 仍继续分裂成不同子宪法 |
| host-external diagnostics world | `src/utils/diagLogs.ts:27-60` | 为什么 diagnostics carrier 甚至不生活在 repo-local visible cleanup plane |
| family-by-family dispatcher | `src/utils/cleanup.ts:575-595` | 为什么 visible cleanup plane 更像 stitched plural laws，而不是一个显式 constitution registry |

## 4. `diskOutput.ts` 先把 repaired temp constitution 钉死：task-output family 已经被单独立法

`diskOutput.ts:31-49` 的价值不只是在“换了路径”。

它真正说明：

1. task outputs 现在落在 `getProjectTempDir()/sessionId/tasks`
2. 把 same-project concurrent-session clobber 明确写进注释
3. 还把 `/clear` 之后 sessionId 漂移的风险一起写进同一段 constitution note

这意味着 task-output family 当前服从的法律不是普通 retention sweep，
而是：

`repaired session-scoped temp constitution`

再看 `permissions/filesystem.ts:1688-1700`：

1. project temp dir 仍 intentionally allows reading files from all sessions in this project
2. 说明这个 constitution 的关键不是“别人绝对碰不到”
3. 而是“read world 可以共享，delete/write boundary 仍要单独受治理”

所以 stronger-request cleanup constitution 在 task-output family 上已经非常具体：

`shared-readable temp world + scoped delete discipline`

## 5. `sessionStorage`、`toolResultStorage` 与 `cleanup.ts` 再证明：persisted carrier family 仍活在 project-session sweep world

`sessionStorage.ts:198-220` 说明 transcript/cast 走：

`projects/<project>/<session>.jsonl/.cast`

`toolResultStorage.ts:94-118` 说明 persisted tool-results 走：

`projects/<project>/<session>/tool-results`

`cleanup.ts:155-257` 则说明 cleanup 处理这类 carrier 时会：

1. 先进入 `projects/<project>`
2. 清顶层 transcript/cast
3. 再深入每个 sessionDir 的 `tool-results`
4. 主要用 cutoff date 与 mtime 做 gate

这里不需要提前写成 bug 句。
更稳的判断已经足够强：

`persisted session carriers currently live in a project-session sweep constitution, not in the repaired temp constitution.`

这说明 stronger-request old echo 一旦被持久化进 transcript/tool-results，
它面对的已经不是 task-output family 的那条家法。

## 6. `plans`、`file-history`、`sessionEnvironment` 与 `debug` 再把问题推进：home-root 也不是一个统一世界

`plans.ts:79-106` 说明：

1. plans 默认落在 `~/.claude/plans`
2. 也可被 `plansDirectory` 改到 project root
3. visible cleanup 仍只在 `cleanup.ts:300-303` 里清默认 `plans` 根目录

`fileHistory.ts:951-957` 与 `sessionEnvironment.ts:14-21` 说明：

1. file-history 落在 `~/.claude/file-history/<sessionId>/`
2. session-env 落在 `~/.claude/session-env/<sessionId>/`
3. cleanup 对它们按 session dir mtime 做 recursive rm  
   `cleanup.ts:305-387`

`debug.ts:229-249` 与 `cleanup.ts:391-428` 又说明：

1. debug log 落在 `~/.claude/debug/<sessionId>.txt`
2. 同时维护 `latest` symlink
3. cleanup age-based delete old `.txt`，但保留 `latest`

这些代码合在一起说明：

`home-root world itself is constitutionally plural`

至少已经能分出：

1. plan single-directory constitution
2. file-history / session-env per-session-dir constitution
3. debug-log operational constitution with latest-symlink preservation

这已经远远超出“cleanup 会不会误伤”的问题，
而是明确进入：

`different family, different law`

## 7. `diagLogs.ts` 最后给出最强边界：有些 stronger-request old echo carrier 根本不在 repo-local cleanup constitution 内

`diagLogs.ts:27-60` 很短，
但信息量极高。

它告诉我们：

1. diagnostics 只看 `CLAUDE_CODE_DIAGNOSTICS_FILE`
2. visible action 是 append line
3. repo-local 看不到与 `cleanup.ts` 对等的 diagnostics cleanup function

这说明 diagnostics carrier 当前不能被稳妥地归入：

1. repaired temp constitution
2. project-session sweep constitution
3. home-root retention constitution

更稳的技术判断是：

`diagnostics currently appears as a host/env-selected external constitution from the repo-local viewpoint`

这使 stronger-request cleanup constitution 的边界一下子变得更硬：

`有些 old echo carrier 连法律世界都不在 repo-local visible cleanup plane 里。`

## 8. `cleanupOldMessageFilesInBackground()` 让缺口更具体：repo 知道 family 有别，但现在只是把它们顺次 dispatch，而不是显式签成统一 constitution plane

`cleanup.ts:575-595` 现在做的是：

1. `cleanupOldMessageFiles()`
2. `cleanupOldSessionFiles()`
3. `cleanupOldPlanFiles()`
4. `cleanupOldFileHistoryBackups()`
5. `cleanupOldSessionEnvDirs()`
6. `cleanupOldDebugLogs()`
7. image caches、pastes、stale worktrees 等

这条 dispatcher 非常值钱。

因为它说明 repo 并不是完全不知道 family 有别。
相反，它非常知道。

问题恰恰在于：

`visible cleanup plane knows family plurality operationally, but does not yet expose an equally explicit stronger-request constitution plane that explains why these laws differ.`

换句话说，
当前显露出来的是：

`plural cleanup executors`

但还不是：

`fully signed plural cleanup constitutions`

## 9. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 只要不误伤 live peer，就已经可以被视为 constitutionally complete。`

而是：

`repaired temp world、project-session sweep world、home-root plural worlds 与 host-external diagnostics world 已经共同展示出 stronger-request old echo carriers 的 constitutional plurality；因此 artifact-family cleanup stronger-request cleanup-isolation-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-constitution-governor signer。`

因此：

`cleanup 线真正缺的，不只是“谁来证明 stronger-request cleanup 没伤到 live peer”，还包括“谁来正式解释这些 old echo carrier 为什么分别活在不同 cleanup law 里”。`
