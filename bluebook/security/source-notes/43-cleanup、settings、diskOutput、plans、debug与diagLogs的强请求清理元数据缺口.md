# cleanup、settings、diskOutput、plans、debug与diagLogs的强请求清理元数据缺口

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `192` 时，
真正需要被单独钉住的已经不是：

`different stronger-request family rationale 已经存在，`

而是：

`这些 rationale 为什么还没有被升级成统一、可传播、可防漂移的 metadata plane。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`family truth 仍然分散。`

这句话还不够硬。
所以这里单开一篇，只盯住：

- `src/utils/cleanup.ts`
- `src/utils/settings/types.ts`
- `src/utils/task/diskOutput.ts`
- `src/utils/toolResultStorage.ts`
- `src/utils/sessionStorage.ts`
- `src/utils/plans.ts`
- `src/utils/fileHistory.ts`
- `src/utils/sessionEnvironment.ts`
- `src/utils/debug.ts`
- `src/utils/diagLogs.ts`

把 stronger-request family truth 当前散落在哪些 helper、哪些 schema、哪些 comment、哪些 dispatcher 里，以及为什么这仍不等于 metadata plane，单独钉死。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 没有 stronger-request family truth。`

而是：

`Claude Code 已经有足够多 stronger-request family truth，但这些 truth 仍主要以 helper composition、local comments、局部 schema 与硬编码 dispatcher 的形式存在，还没有长成统一的 cleanup metadata grammar。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| hardcoded family dispatcher | `src/utils/cleanup.ts:575-595` | 为什么 cleanup plane 目前更像手写调用链，而不是 family registry |
| local retention knobs | `src/utils/settings/types.ts:325-333,824-830` | 为什么当前 schema 公开的是零散 knobs，而不是完整 family metadata |
| local explicit truth | `src/utils/task/diskOutput.ts:31-49`; `src/utils/diagLogs.ts:11-20,27-60` | 为什么有些 family 的理由虽清楚，却仍主要停留在 local comments/helpers |
| cross-file puzzle truth | `src/utils/toolResultStorage.ts:1-5,94-118`; `src/utils/sessionStorage.ts:198-220`; `src/utils/cleanup.ts:155-257` | 为什么 tool-results / transcripts 的 truth 已经是跨模块拼图，而不是单点 descriptor |
| propagation failure | `src/utils/plans.ts:79-106,164-233`; `src/utils/cleanup.ts:300-303`; `src/utils/settings/types.ts:824-830` | 为什么 plans family 最能暴露没有 metadata plane 时的传播失灵 |
| stable but still local truth | `src/utils/fileHistory.ts:951-957`; `src/utils/sessionEnvironment.ts:14-21,60-140`; `src/utils/debug.ts:30-68,97-108,229-249` | 为什么有些 family 暂时没失灵，也仍不等于已经 metadata 化 |

## 4. `cleanupOldMessageFilesInBackground()` 先证明：系统已经知道 family 有别，但知道有别不等于保存成 policy plane

`cleanup.ts:575-595` 会依次调：

1. `cleanupOldMessageFiles()`
2. `cleanupOldSessionFiles()`
3. `cleanupOldPlanFiles()`
4. `cleanupOldFileHistoryBackups()`
5. `cleanupOldSessionEnvDirs()`
6. `cleanupOldDebugLogs()`
7. 其他 image caches、pastes、stale worktrees 等

这说明两件事：

1. 系统当然知道 family 有别
2. 但这个“有别”当前主要以 hand-written call order 的形式存在

也就是说，
当前显露出来的是：

`family-specific execution`

而不是：

`metadata-driven family execution`

## 5. settings plane 再证明：当前公开的是局部 knob，不是完整 grammar

`settings/types.ts:325-333` 公开的是：

`cleanupPeriodDays`

`settings/types.ts:824-830` 公开的是：

`plansDirectory`

它们说明当前 schema 的确承认某些 family truth，
但承认方式仍是：

1. 一个全局 retention 数值
2. 一个特定 family 的路径 override

系统没有公开的是：

1. family-specific reader scope
2. recovery duty
3. retention owner
4. host visibility
5. drift invariant

所以当前 schema plane 更像：

`some knobs`

而不是：

`family metadata grammar`

## 6. task outputs / diagnostics 说明：truth 可以非常显式，但仍然只是 local truth

`diskOutput.ts:31-49` 已经把 task-output family 的 truth 写得非常清楚：

1. same-project clobber risk
2. repaired temp path
3. `/clear` path drift

`diagLogs.ts:11-20,27-60` 也把 diagnostics family 的 truth 写得非常清楚：

1. host monitoring
2. no-PII
3. env-selected logfile

但这两类 family 共同暴露的事实是：

`truth can be explicit and still remain local`

也就是说，
“注释很清楚”与“metadata plane 已存在”之间仍然差着一个系统自描述层。

## 7. tool-results / transcripts / plans 继续说明：一旦 family truth 跨入多平面，metadata 缺口就会从 local truth 变成 puzzle truth，最终变成 propagation failure

`toolResultStorage.ts`、`sessionStorage.ts` 与 `cleanup.ts` 让 tool-results / transcripts 的 truth 分散在：

1. file header
2. path helper
3. persistence helper
4. cleanup traversal

这已经是：

`cross-file puzzle truth`

`plans` 更进一步。
它的 truth 同时跨越：

1. settings
2. storage
3. permissions
4. resume recovery
5. cleanup

而当前最硬的现象是：

`plansDirectory` 已经能改写 storage world，cleanup 仍只清默认 home-root world。

这说明没有 metadata plane 时，
family truth 的演化路径通常会经历三步：

1. local truth
2. puzzle truth
3. propagation failure

## 8. 一条硬结论

这组源码真正说明的不是：

`Claude Code 还没有 family-level governance。`

而是：

`Claude Code 已经拥有大量 stronger-request family-level truth，但这些 truth 仍主要寄居在 cleanup、settings、helper 与 comments 的分散组合里；因此 artifact-family cleanup stronger-request cleanup-metadata-governor signer 仍必须独立于 artifact-family cleanup stronger-request cleanup-rationale-governor signer 被追问。`

因此：

`cleanup 线真正缺的，不只是“谁来解释这些 law 为什么成立”，还包括“谁来把这些为什么保存成系统自己会重复读取、传播并校验的 metadata plane”。`
