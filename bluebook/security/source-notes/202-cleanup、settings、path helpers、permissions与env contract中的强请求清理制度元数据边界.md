# cleanup、settings、path helpers、permissions与env contract中的强请求清理制度元数据边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `351` 时，
真正需要被单独钉住的已经不是：

`different stronger-request family rationale 已经存在，`

而是：

`这些 rationale 为什么还没有被升级成统一、可传播、可防漂移、可多平面共读的 metadata plane。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`family truth 仍然分散。`

这句话还不够硬。
所以这里单开一篇，
只盯住：

- `src/utils/cleanup.ts`
- `src/utils/settings/types.ts`
- `src/utils/task/diskOutput.ts`
- `src/utils/toolResultStorage.ts`
- `src/utils/sessionStorage.ts`
- `src/utils/plans.ts`
- `src/utils/fileHistory.ts`
- `src/utils/sessionEnvironment.ts`
- `src/utils/permissions/filesystem.ts`
- `src/utils/debug.ts`
- `src/utils/diagLogs.ts`

把 stronger-request family truth 当前散落在哪些 helper、哪些 schema、哪些 permission rule、哪些 comment、哪些 resume path、哪些 dispatcher 与哪些 env contract 里，以及为什么这仍不等于 metadata plane，单独钉死。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 没有 stronger-request family truth。`

而是：

`Claude Code 已经有足够多 stronger-request family truth，但这些 truth 仍主要以 local helper、局部 schema、permission projection、argv/env convention、comment 与硬编码 dispatcher 的形式存在，还没有长成统一 stronger-request cleanup metadata grammar。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| hardcoded family dispatcher | `src/utils/cleanup.ts:575-598` | 为什么 cleanup plane 当前更像手写 family call list，而不是 metadata-driven registry |
| local retention knobs | `src/utils/settings/types.ts:325-333,824-830` | 为什么当前 schema 公开的是零散 knobs，而不是完整 family grammar |
| local explicit truth | `src/utils/task/diskOutput.ts:33-49`; `src/utils/diagLogs.ts:11-20,27-53` | 为什么有些 family 的理由虽很清楚，却仍主要停留在 local comments / helpers |
| cross-file puzzle truth | `src/utils/toolResultStorage.ts:1-5,94-118`; `src/utils/sessionStorage.ts:198-224`; `src/utils/cleanup.ts:155-257` | 为什么 tool-results / transcripts 的 truth 已经是跨模块拼图，而不是单点 descriptor |
| cross-plane propagation stress test | `src/utils/plans.ts:79-106,164-233`; `src/utils/settings/types.ts:824-830`; `src/utils/permissions/filesystem.ts:245-255,1487-1494,1644-1652`; `src/utils/cleanup.ts:300-303` | 为什么 plans family 最能暴露没有 metadata plane 时的传播失灵 |
| stable but still local truth | `src/utils/fileHistory.ts:951-957`; `src/utils/sessionEnvironment.ts:15-21,60-140`; `src/utils/debug.ts:30-68,91-111,216-230` | 为什么有些 family 暂时没失灵，也仍不等于已经 metadata 化 |

## 4. `cleanupOldMessageFilesInBackground()` 先证明：系统已经知道 family 有别，但知道有别不等于保存成 policy plane

`cleanup.ts:575-598`
会依次调：

1. `cleanupOldMessageFiles()`
2. `cleanupOldSessionFiles()`
3. `cleanupOldPlanFiles()`
4. `cleanupOldFileHistoryBackups()`
5. `cleanupOldSessionEnvDirs()`
6. `cleanupOldDebugLogs()`
7. 其他 image cache、paste、stale worktree 等 cleanup

这说明两件事：

1. 系统当然知道 stronger-request cleanup 不是单一家族
2. 但这个“有别”当前主要仍以 hand-written call order 的形式存在

也就是说，
当前显露出来的是：

`family-specific execution`

而不是：

`metadata-driven family execution`

这正是 metadata 问题的起点。

系统已经知道谁和谁不同，
但它还没有 equally-strong 地回答：

`这些不同究竟被保存成了什么统一语法。`

## 5. settings plane 再证明：当前公开的是局部 knob，不是完整 grammar

`settings/types.ts:325-333`
公开的是：

`cleanupPeriodDays`

`settings/types.ts:824-830`
公开的是：

`plansDirectory`

它们说明当前 schema 的确承认某些 family truth，
但承认方式仍是：

1. 一个全局 retention knob
2. 一个特定 family 的路径 override

系统没有公开的是：

1. family-specific reader scope
2. operational duty
3. recovery duty
4. host visibility
5. drift invariant

所以当前 schema plane 更像：

`some knobs`

而不是：

`family metadata grammar`

## 6. task outputs 与 diagnostics 说明：truth 可以非常显式，但仍然只是 local truth

`diskOutput.ts:33-49`
已经把 task-output family 的 truth 写得非常清楚：

1. same-project clobber risk
2. repaired temp path
3. `/clear` path drift

`diagLogs.ts:11-20,27-53`
也把 diagnostics family 的 truth 写得非常清楚：

1. host monitoring
2. no-PII
3. env-selected logfile

但这两类 family 共同暴露的事实是：

`truth can be explicit and still remain local`

也就是说，
“注释很清楚”与“metadata plane 已存在”之间，
仍然差着一层系统自描述工程。

## 7. tool-results 与 transcripts 继续说明：同一 constitution world 内部也可能只有 puzzle truth，而没有 shared descriptor

`toolResultStorage.ts`、`sessionStorage.ts` 与 `cleanup.ts`
让 tool-results / transcripts 的 truth 分散在：

1. file header
2. subdir constant
3. path helper
4. persistence helper
5. cleanup traversal

这已经不是单点真相，
而是：

`cross-file puzzle truth`

而更微妙的地方在于：

1. tool-results 偏 inspection
2. transcripts 偏 continuity / replay
3. 两者却同住在 project-session cleanup world

所以这里暴露的不是“没有 truth”，
而是：

`truth exists, but still needs reconstruction`

这就说明 stronger-request cleanup 当前更接近：

`researcher-readable composition`

而不是：

`machine-readable family descriptor`

## 8. plans family 再往前走一步：metadata 缺口最容易在跨平面传播时被显影

plans family 的 truth 同时横跨：

1. settings
2. storage
3. permissions
4. resume recovery
5. cleanup

而当前最硬的现象是：

`plansDirectory` 已经能改写 storage / permission / resume 世界，而 cleanup 仍只清默认 home-root world。

这里最有价值的技术判断不是单纯“发现了一个 bug”，
而是：

`只要 family truth 横跨多个平面，如果没有统一 metadata plane，传播就只能依赖实现纪律，而不能依赖系统自描述。`

从安全设计角度看，
这比单点路径 bug 更深。

因为它暴露的是：

`cross-plane truth has no canonical carrier`

也就是：

`制度真相已经开始跨平面流动，但还没有一个被所有平面共同承认的制度载体。`

## 9. permission plane 再证明：部分投影不等于 metadata 已存在

`permissions/filesystem.ts`
已经明确知道 plans family 在当前 session 下有哪些 read/write allowance。

这说明 permission plane 并非完全失明。

但它展示出来的，
更接近：

`partial projection`

而不是：

`canonical descriptor`

也就是说，
permission plane 目前只是在消费某些已经传播过来的 truth，
并不能倒推出：

`系统已经拥有一份统一 metadata plane。`

因为同一条 truth 能否同时被 settings、storage、permissions、resume 与 cleanup 共读，
才是更强的问题。

## 10. debug / diagnostics 再补最后一刀：argv、env 与 host contract 也会承载制度真相，但仍然只是局部语法

`debug.ts`
继续把 truth 分散在：

1. argv gating
2. env checks
3. comment
4. path helper
5. cleanup helper

`diagLogs.ts`
继续把 truth 分散在：

1. no-PII comment
2. env-selected logfile contract
3. host-visible monitoring surface

这说明 stronger-request cleanup metadata 问题天然不只发生在 repo-local file tree 里，
而是会延伸到：

`argv/env/host contract world`

但这并不自动意味着 metadata 已经存在。

更准确地说，
它说明的是：

`family truth 的寄居地越来越多，越需要 shared grammar；否则系统越先进，implicit coordination 成本越高。`

## 11. 技术启示与苏格拉底式反问

这组源码给出的设计启示至少有六条：

1. local explicit truth 不等于 shared metadata truth
2. helper composition 不等于 system-readable descriptor
3. partial projection 不等于 canonical carrier
4. plural dispatcher 不等于 plural metadata governance
5. cross-plane propagation gap 是 metadata 缺失最硬的实证形式
6. 系统越多平面协同，越不能只靠注释、路径和 convention 维持制度真相

如果再用苏格拉底式方法反问自己，
这一层最该守住的三句自我约束是：

1. `我是不是把“局部 truth 很清楚”偷写成“系统已经会自述”？`
2. `我是不是把“某个平面已经消费 truth”偷写成“所有平面都在消费同一份 truth”？`
3. `我是不是把“当前没炸”偷写成“metadata gap 已经不存在”？`

只要这三问里有一问还不能稳答，
metadata plane 就还没有真正成立。

## 12. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup rationale 只要已经存在，系统自然就已经拥有 metadata。`

而是：

`stronger-request cleanup 当前已经拥有大量 family-specific truth，但这些 truth 仍主要停留在 helper、schema、permission projection、comment、argv/env 与 hand-written dispatcher 的分布式世界里；因此 artifact-family cleanup stronger-request cleanup-rationale-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-metadata-governor signer。`
