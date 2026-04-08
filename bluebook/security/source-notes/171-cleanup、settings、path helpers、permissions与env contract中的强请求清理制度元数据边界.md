# cleanup、settings、path helpers、permissions与env contract中的强请求清理制度元数据边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `320` 时，
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
| local explicit truth | `src/utils/task/diskOutput.ts:33-49`; `src/utils/diagLogs.ts:11-20,27-60` | 为什么有些 family 的理由虽很清楚，却仍主要停留在 local comments / helpers |
| cross-file puzzle truth | `src/utils/toolResultStorage.ts:1-5,94-118`; `src/utils/sessionStorage.ts:198-224`; `src/utils/cleanup.ts:155-257` | 为什么 tool-results / transcripts 的 truth 已经是跨模块拼图，而不是单点 descriptor |
| cross-plane propagation stress test | `src/utils/plans.ts:79-106,164-233`; `src/utils/settings/types.ts:824-830`; `src/utils/permissions/filesystem.ts:245-255,1487-1494,1644-1652`; `src/utils/cleanup.ts:300-303` | 为什么 plans family 最能暴露没有 metadata plane 时的传播失灵 |
| stable but still local truth | `src/utils/fileHistory.ts:951-957`; `src/utils/sessionEnvironment.ts:15-21,60-140`; `src/utils/debug.ts:30-68,91-111,230-249` | 为什么有些 family 暂时没失灵，也仍不等于已经 metadata 化 |

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

`diagLogs.ts:11-20,27-60`
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

但它当前看到的，
更接近：

`family truth 的局部投影`

而不是：

`family metadata plane 本身`

这是一个重要分界。

因为 partial projection 只说明某个平面吸收了部分制度真相，
并不说明：

1. 其他平面也在吸收同一份 truth
2. 这份 truth 有 canonical owner
3. drift 可以被系统自己核对

所以 permission plane 在这里更像：

`metadata absence 的佐证`

而不是：

`metadata already solved 的证据`

## 10. file-history、session-env 与 debug 继续证明：稳定 local truth 不等于已经 metadata 化

`fileHistory.ts`
说明 backups 首先服务 restore。

`sessionEnvironment.ts`
说明 session-env 首先服务 replay。

`debug.ts`
说明 debug 首先服务 operational debugging、`/share` 与 bug report。

这些 truth 都很清楚，
甚至相对稳定。

但它们仍主要以：

1. path helper
2. local cleanup helper
3. argv / env convention
4. comment

被局部保存。

这说明 metadata 问题不能被误写成：

`只有发生明显 drift 的 family 才算缺 metadata。`

更准确的说法是：

`即便暂时没有明显 drift，只要 truth 仍局部寄居、不能被多平面共享，它仍然没有完成 metadata 化。`

## 11. 从技术角度看，这组代码真正启示了什么

如果把这组机制抽成安全设计启示，
至少有六条：

1. 高级安全设计不会停在“系统有没有理由”，而会继续追问“这份理由被系统自己保存在哪里”
2. local explicit truth、cross-file puzzle truth 与 cross-plane propagation failure 是一条连续工程谱系，而不是三类无关问题
3. permission plane 是否在消费同一份 truth，是判断 metadata 是否真实存在的重要试金石
4. hand-written dispatcher 能证明系统知道 family plurality，但不能证明系统已经拥有 family grammar
5. host-visible no-PII diagnostics 说明 metadata 问题天然跨越 repo-local persistence 哲学，不能只靠 cleanup helper 自圆其说
6. 一个系统越先进、越多平面协同，就越需要 metadata plane，否则 implicit coordination 的成本会急剧上升

这也是 Claude Code 在这条线上的“先进性与边界”同时出现的原因：

`它已经足够复杂，所以 metadata 问题才真正变得重要。`

## 12. 苏格拉底式自反诘问：我是不是又把“线索很多”误认成了“系统已有自描述”

如果对这组代码做更严格的自我审查，
至少要追问五句：

1. 如果 comment、helper、schema、permission rule 已经到处都有 family truth，为什么我还说 metadata plane 不存在？
   因为 scattered signals 不等于 shared descriptor。
2. 如果 plans 只是 cleanup 没有跟上，是不是没必要上升到 metadata 问题？
   不是。它恰恰说明跨平面真相没有 canonical carrier。
3. 如果 diagnostics 的 env contract 已经很正式，为什么还不够？
   因为 env contract 只让 writer 知道怎么写，不保证其他平面知道怎样解释、核对和迁移这份 truth。
4. 如果系统当前仍然跑得通，metadata gap 会不会被夸大？
   不能这样说。absence of observed failure 不能证明 multi-plane alignment 已经形成。
5. 如果未来真的补了一份 descriptor，问题是否就结束？
   还没有。那时还要继续追问运行时是不是按那份 descriptor 在执行。

这组反问最终逼出一句更稳的判断：

`metadata 的关键不在“有没有线索”，而在“系统有没有一份自己会重复背诵的制度真相”。`

## 13. 一条硬结论

这组源码真正说明的不是：

`Claude Code 还没有 family-level governance。`

而是：

`Claude Code 已经拥有大量 stronger-request family-level truth，但这些 truth 仍主要寄居在 cleanup、settings、path helpers、permission projection、comment、argv / env contract 与 hardcoded dispatcher 的分散组合里；因此 artifact-family cleanup stronger-request cleanup-metadata-governor signer 仍必须独立于 artifact-family cleanup stronger-request cleanup-rationale-governor signer 被追问。`

因此：

`cleanup 线真正缺的，不只是“谁来解释这些 law 为什么成立”，还包括“谁来把这些为什么保存成系统自己会重复读取、传播并校验的 metadata plane”。`
