# diskOutput、toolResultStorage、sessionStorage、plans、fileHistory、sessionEnvironment、debug与diagLogs中的强请求清理制度理由边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `319` 时，
真正需要被单独钉住的已经不是：

`different stronger-request old cleanup carriers 现在住在哪个 cleanup world，`

而是：

`这些 cleanup world 为什么成立，以及当前实现有没有开始偏离这些理由。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`stronger-request cleanup constitution 不等于 stronger-request cleanup rationale。`

这句话还不够硬。
所以这里单开一篇，只盯住：

- `src/utils/task/diskOutput.ts`
- `src/utils/toolResultStorage.ts`
- `src/utils/sessionStorage.ts`
- `src/utils/plans.ts`
- `src/utils/fileHistory.ts`
- `src/utils/sessionEnvironment.ts`
- `src/utils/debug.ts`
- `src/utils/diagLogs.ts`
- `src/utils/cleanup.ts`

把 live non-clobber、persisted inspection、continuity / replay、planning recovery、restore backup、environment replay、operational debugging 与 host monitoring 并排，
逼出一句更硬的结论：

`Claude Code 已经明确展示：stronger-request old cleanup family 不只住在不同 law 里，还服务不同 risk object；因此 constitution proof 仍不能替代理由 proof。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 现在把 stronger-request carriers 分到了不同 cleanup constitution。`

而是：

`Claude Code 已经在 stronger-request old cleanup surface 上公开展示至少七种不同制度理由，而且其中 plans family 已经显露出 rationale drift。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| live non-clobber rationale | `src/utils/task/diskOutput.ts:33-49` | 为什么 task-output family 被推向 repaired temp law |
| persisted inspection rationale | `src/utils/toolResultStorage.ts:1-5,94-118` | 为什么 tool-results 需要被持久化而不是只留在 live runtime |
| continuity / replay rationale | `src/utils/sessionStorage.ts:198-224` | 为什么 transcripts / casts 继续住在 session persistence tree |
| planning recovery rationale + drift | `src/utils/plans.ts:79-106,164-233`; `src/utils/cleanup.ts:300-303` | 为什么 plans family 既要自治又要恢复，以及为什么 cleanup reason 还没有完全跟上 |
| restore / replay rationale | `src/utils/fileHistory.ts:951-957`; `src/utils/sessionEnvironment.ts:15-21,60-140`; `src/utils/cleanup.ts:305-387` | 为什么 file-history 与 session-env 虽同居 home-root/session-dir world，但服务不同 duty |
| operational debugging rationale | `src/utils/debug.ts:30-68,91-111,230-249`; `src/utils/cleanup.ts:391-428` | 为什么 debug logs 不是 generic retained artifact，而是 operational surface |
| host monitoring rationale | `src/utils/diagLogs.ts:11-20,27-60` | 为什么 diagnostics family 更接近 host-visible monitoring world |

## 4. `diskOutput.ts` 先把 strongest rationale 钉死：task outputs 的 law 是被 live clobber 风险逼出来的

`diskOutput.ts:33-49`
最值钱的地方，
不是它用了 `sessionId/tasks`，
而是它把理由写得很直白：

1. same-project concurrent sessions 曾经互相 clobber output files
2. startup cleanup 曾经导致 live read path ENOENT
3. `/clear` 还会造成 path drift

这说明 task-output family 的主要 risk object 是：

`live runtime non-clobber + path reachability`

所以它被推向 repaired temp law 不是一种路径风格，
而是 risk-object-driven rationale。

## 5. `toolResultStorage` 与 `sessionStorage` 继续证明：project-session persistence world 内部也有不同理由

`toolResultStorage.ts:1-5`
直接写出：

`persisting large tool results to disk instead of truncating them`

这说明 tool-results 首先服务的是：

`inspection after execution`

而 `sessionStorage.ts:198-224`
把 transcripts / casts 放进 session persistence tree，
更接近：

`continuity / replay / history readability`

所以虽然两者都活在 project-session world，
但理由其实已经分开：

1. tool-results 是 inspection rationale
2. transcripts 是 continuity rationale

也就是说：

`same constitution != same rationale`

## 6. `plans.ts` 把 drift 边界暴露得最彻底：planning autonomy 与 cleanup default world 已经不再完全一致

`plans.ts:79-106,164-233`
共同说明：

1. plans 默认在 `~/.claude/plans`
2. 可通过 `plansDirectory` 移到 project root
3. 当前 session 仍把它当 active artifact 读
4. resume 还会尝试恢复缺失的 plan

这意味着 plan family 的理由至少有三层：

1. planning autonomy
2. active coordination
3. resume recovery

但 `cleanup.ts:300-303`
仍只清默认：

`~/.claude/plans`

这里最硬的技术判断不是“发现了一个具体 bug”，
而是：

`plan family 的 storage reason 已经允许 project-root world，但 cleanup reason 还没有等强度进入这个新世界。`

这就是 stronger-request cleanup rationale 当前最典型的 drift boundary。

## 7. `fileHistory`、`sessionEnvironment`、`debug` 与 `diagLogs` 再说明：old cleanup world 的理由至少还分 restore、replay、operational 与 host-monitoring 四支

`fileHistory.ts:951-957`
说明 backups 首先服务：

`restore edited files`

`sessionEnvironment.ts:15-21,60-140`
说明 session-env 首先服务：

`replay execution environment`

`debug.ts:30-68,91-111,230-249`
说明 debug 首先服务：

`operational debugging / /share / bug reports`

`diagLogs.ts:11-20,27-60`
说明 diagnostics 首先服务：

`monitor issues from within the container`，且必须 no-PII

这些理由彼此完全不同。

所以 stronger-request old cleanup 当前至少生活在这样一个世界里：

1. some carriers protect restore safety
2. some carriers preserve replay continuity
3. some carriers preserve operational traceability
4. some carriers report host-visible no-PII telemetry

这说明 “old cleanup” 本身并不是一个足够细的理由类别。

## 8. `cleanupOldMessageFilesInBackground()` 继续说明：repo 已把 plural laws 串起来执行，但还没有同等显式地串起 plural rationales

`cleanup.ts:575-598`
当前把：

1. transcript / tool-results
2. plans
3. file-history
4. session-env
5. debug logs
6. image caches / pastes / stale worktrees

顺次 dispatch。

这说明 repo 很清楚：

`cleanup world is operationally plural`

但 visible plane 当前更像：

`plural executors stitched together`

还不是：

`plural rationales explicitly signed and re-stated`

所以 stronger-request cleanup rationale 当前最真实的缺口，
不是“完全没有理由”，
而是：

`这些理由还没有被同等显式地制度化为一层独立 plane。`

## 9. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup law 只要分家完成，制度理由自然也就清楚了。`

而是：

`live non-clobber、persisted inspection、continuity / replay、planning recovery、restore backup、environment replay、operational debugging 与 host monitoring 已经共同展示出 stronger-request cleanup rationale 的独立存在；因此 artifact-family cleanup stronger-request cleanup-constitution-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-rationale-governor signer。`

因此：

`cleanup 线真正缺的，不只是“不同 stronger-request family 现在住在哪条 law 里”，还包括“谁来正式解释这些 law 为什么成立，以及哪里已经开始理由漂移”。`
