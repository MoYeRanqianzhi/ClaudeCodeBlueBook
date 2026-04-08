# TaskOutput、diskOutput、toolResultStorage、concurrentSessions与cronTasksLock中的强请求清理隔离边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `348` 时，
真正需要被单独钉住的已经不是：

`谁来更诚实地说明 stronger-request cleanup retention law 当前执行到哪里，`

而是：

`谁来证明这条 law 真正进入 destructive cleanup 时，不会误伤同项目里仍在运行、仍在读取或仍在写入这些 carrier 的 live peer。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`stronger-request retention-enforcement honesty governor 不等于 stronger-request cleanup-isolation governor。`

这句话还不够硬。
所以这里单开一篇，只盯住：

- `src/utils/task/TaskOutput.ts`
- `src/utils/task/diskOutput.ts`
- `src/utils/permissions/filesystem.ts`
- `src/utils/toolResultStorage.ts`
- `src/utils/cleanup.ts`
- `src/utils/concurrentSessions.ts`
- `src/utils/cronTasksLock.ts`
- `src/utils/cronScheduler.ts`

把历史 side effect、局部 isolation repair、shared-readable temp space、older cleanup sweep world、live-session ledger 与 single-owner positive control 并排，
逼出一句更硬的结论：

`Claude Code 已经明确展示：知道 cleanup 现在怎样执行，不等于已经证明 cleanup 对 live peers 无害；非干扰性需要自己的治理层。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 有 cleanup、也有一些并发账本。`

而是：

`Claude Code 已经在 task-output family 上做过 cleanup-isolation repair，也已经在 cron scheduler 上展示过 same-project single-owner governance，但当前更广的 stronger-request cleanup path 还没有公开展示与之等强的 generalized live-peer proof。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| historical live-peer side effect | `src/utils/task/TaskOutput.ts:313-324` | cleanup 过去怎样伤到同项目 live peer |
| repaired task-output isolation | `src/utils/task/diskOutput.ts:33-55` | 哪个 carrier family 已被提升成 session-scoped isolation architecture |
| shared readable temp space | `src/utils/permissions/filesystem.ts:1688-1700` | 为什么共享读面不自动等于共享删面安全 |
| persisted tool-results layout | `src/utils/toolResultStorage.ts:94-118` | persisted outputs 现在仍活在哪个 cleanup world |
| visible project/session sweep | `src/utils/cleanup.ts:155-257,300-348,350-428,575-596` | cleanup 怎样继续进入更广的 carrier families |
| live-session ledger | `src/utils/concurrentSessions.ts:49-109,163-204` | 系统其实已经有哪些“谁还活着”的账本 |
| single-owner positive control | `src/utils/cronTasksLock.ts:1-15,49-57,100-170`; `src/utils/cronScheduler.ts:40-44` | repo 在别的 same-project multi-session 子系统里怎样正式证明 noninterference |

## 4. `TaskOutput` 先把事故痕迹留下：cleanup 真可能伤到 same-project live peer

`TaskOutput.ts:313-324`
不是抽象猜测，
而是直接告诉我们：

1. output file 读时可能 `ENOENT`
2. 一个已知历史解释是
   `another Claude Code process in the same project deleted it during startup cleanup`
3. 系统专门把这条解释写成 diagnostic string 返回，而不是静默吞掉

这条证据说明 stronger-request cleanup isolation 在源码作者心里不是理论风险，
而是已经发生过的：

`cross-session live-peer interference`

所以从 stronger-request 角度说，
execution honesty 即使成立，
也仍然不能替代 noninterference proof。

## 5. `diskOutput.ts` 再证明：repo 已经在一个 family 上把 isolation 升级成 architecture repair

`diskOutput.ts:33-55`
很硬。

这里 repo 明确写：

1. task output dir 现在走 `getProjectTempDir()/sessionId/tasks`
2. 之所以把 `sessionId` 放进路径
3. 是因为 same-project concurrent sessions 过去会 clobber each other's output files
4. `sessionId` 只在 first call 捕获，以避免 `/clear` 造成 path drift，让老任务的 output path 失联

这条注释的价值不只是在“解释一个路径”。

它真正说明：

`repo 已经做过 family-specific cleanup isolation repair`

也就是说，
当前 stronger-request cleanup isolation 缺的不是想象力，
而是：

`repair 是否被推广成 generalized governance`

## 6. `tool-results` 仍活在更旧的 cleanup world 里

`toolResultStorage.ts:94-118`
说明：

1. persisted tool results 仍落在 `projectDir/sessionId/tool-results`
2. 这是 session-specific path，但仍属于按 project tree 组织的 cleanup world

再看 `cleanup.ts:155-257`，
visible cleanup 会：

1. 进入 `projectDir`
2. 再进入每个 `sessionDir`
3. 深入 `tool-results`
4. 按 `mtime` 删除文件

这里我不需要直接断言：

`tool-results 一定仍会误伤 live peer`

更稳的判断已经足够强：

`current source shows no visible tool-results isolation proof matching the strength of task-output repair`

也就是说，
task-output family 与 tool-results family 当前活在两种不同强度的 cleanup constitution 里。

## 7. broader cleanup sweep 让问题升级：visible coverage 变宽了，但 noninterference proof 没同步变宽

`cleanup.ts:300-348,350-428,575-596`
继续说明：

1. plans
2. file-history
3. session-env
4. debug logs
5. image caches
6. pastes
7. stale worktrees

都已经被带入 visible cleanup coverage。

这条证据的意义很大。

因为它说明 stronger-request cleanup 当前的问题不是：

`系统没有把旧 carrier 纳入 cleanup`

而是：

`系统把越来越多 carrier 纳入 cleanup，但公开可见的 isolation proof 没有同步展示出同等级扩张`

于是 stronger-request cleanup isolation 的问题，
就从 task-output 历史事故推进成了 broader artifact-family governance 问题。

## 8. `concurrentSessions` 与 `cronTasksLock` 再给一条正对照：repo 明明知道怎样做同项目 noninterference primitive

`concurrentSessions.ts:49-109,163-204`
已经把 live-session ledger 搭好了：

1. `~/.claude/sessions/<pid>.json`
2. 记录 `sessionId`、`cwd`、`startedAt`
3. 能探测 pid 是否 still alive
4. 能清理 stale pid files

这说明 cleanup path 当前缺的绝不是：

`系统完全不知道还有没有 live peer`

问题恰恰在于：

`cleanup.ts` 的 projects/session sweep 没有 visible consult this ledger before deletion`

再看 `cronTasksLock.ts:1-15,49-57,100-170`
与 `cronScheduler.ts:40-44`：

1. 多个 Claude sessions 在同一 project directory 时
2. cron scheduler 明确要求 only one owner
3. 用 single-owner lock
4. 再加 PID liveness probe
5. stale owner 死掉后才允许 takeover

这条对照非常值钱。

因为它说明 cleanup isolation 当前缺的不是：

`repo 不会做 same-project multi-session coordination`

也不是：

`repo 没有 lock / liveness / takeover pattern`

而是：

`cleanup path 没有公开展示与 cron scheduler 等强度的 coordination constitution`

## 9. 从技术先进性看：成熟安全系统为什么要把“更诚实地说清楚”与“不会误伤别人”拆开

这组源码给出的设计启示至少有六条：

1. honesty answer is not noninterference proof
2. one-family repair should not impersonate generalized cleanup constitution
3. shared-readable surfaces require stricter delete proof, not looser proof
4. live-session ledger only counts when destructive paths visibly consult it
5. single-owner coordination primitives elsewhere are architectural evidence, not automatic governance here
6. age-based cleanup is not the same thing as live-peer-safe cleanup

它的哲学本质是：

`成熟安全系统不仅要说明自己做了什么，还要证明自己不会伤到仍然活着的别的对象。`

## 10. 一条硬结论

这组源码真正说明的不是：

`只要 stronger-request cleanup law 当前被更诚实地说明，系统就已经知道怎样保证同项目 live peers 不受影响。`

而是：

repo 已经在 `TaskOutput` 的历史事故、`diskOutput.ts` 的 session-scoped repair、`permissions/filesystem.ts` 的 shared-readable temp space、`toolResultStorage.ts` 的旧 sweep world、`concurrentSessions.ts` 的 live-session ledger 与 `cronTasksLock.ts` 的 single-owner positive control 上，清楚展示了 stronger-request cleanup isolation governance 的独立存在；因此 `artifact-family cleanup stronger-request retention-enforcement-honesty-governor signer` 仍不能越级冒充 `artifact-family cleanup stronger-request cleanup-isolation-governor signer`。
