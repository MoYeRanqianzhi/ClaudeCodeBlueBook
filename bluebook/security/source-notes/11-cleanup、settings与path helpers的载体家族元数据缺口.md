# cleanup、settings 与 path helpers 的载体家族元数据缺口

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `160` 时，  
真正需要被单独钉住的已经不是：

`不同 artifact family 有没有制度理由，`

而是：

`这些制度理由为什么还没有被升级成统一可复用的 metadata plane。`

如果这个问题只停在主线长文里，  
最容易被压成一句抽象口号：

`family truth 仍然分散。`

这句话仍然太虚。  
所以这里单开一篇，只盯住：

- `src/utils/cleanup.ts`
- `src/utils/settings/types.ts`
- `src/utils/task/diskOutput.ts`
- `src/utils/permissions/filesystem.ts`
- `src/utils/toolResultStorage.ts`
- `src/utils/sessionStorage.ts`
- `src/utils/plans.ts`
- `src/utils/fileHistory.ts`
- `src/utils/sessionEnvironment.ts`

把 artifact-family truth 当前散落在哪些 helper、哪些 schema 字段、哪些 cleanup 函数，以及为什么这仍不等于 metadata plane，单独拆开。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 没有 family truth。`

而是：

`Claude Code 已经有足够多 family truth，但这些 truth 仍主要以 helper composition、局部 schema 与硬编码 dispatcher 的形式存在，还没有长成统一的 artifact-family metadata grammar。`

所以这一组文件真正暴露出的，不是“有没有治理”，  
而是：

`治理为什么还不够自描述。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| cleanup dispatcher | `src/utils/cleanup.ts:575-595` | 为什么 cleanup plane 目前更像硬编码调用链，而不是 registry 驱动的 family policy plane |
| global retention knob | `src/utils/cleanup.ts:25-29`; `src/utils/settings/types.ts:325-333` | 为什么当前 retention schema 主要暴露全局 cutoff，而不是 per-family metadata |
| task-output family truth | `src/utils/task/diskOutput.ts:33-55` | 为什么 task outputs 的关键制度 truth 主要活在注释与 path helper |
| scratchpad family truth | `src/utils/permissions/filesystem.ts:381-423,1488-1506,1645-1684` | 为什么 scratchpad truth 主要活在 path helper 与 permission plane |
| persisted output family truth | `src/utils/toolResultStorage.ts:27,94-118`; `src/utils/sessionStorage.ts:198-225`; `src/utils/cleanup.ts:155-257` | 为什么 tool-results / transcripts 的 truth 被拆在 path helper、read rule 与 cleanup traversal |
| plan-family metadata gap | `src/utils/plans.ts:79-110,164-233`; `src/utils/settings/types.ts:824-830`; `src/utils/cleanup.ts:300-303` | 为什么 plans family 最容易暴露 metadata propagation failure |
| restore / replay family truth | `src/utils/fileHistory.ts:728-741,951-957`; `src/utils/sessionEnvironment.ts:15-30,60-134`; `src/utils/cleanup.ts:305-387` | 为什么 file-history / session-env 虽相对稳定，却仍未被统一描述 |

## 4. `cleanupOldMessageFilesInBackground()` 先证明：系统已经知道 family 有别，但仍通过硬编码顺序管理它们

`src/utils/cleanup.ts:575-595` 的后台 cleanup 入口很关键。

它会依次执行：

1. `cleanupOldMessageFiles()`
2. `cleanupOldSessionFiles()`
3. `cleanupOldPlanFiles()`
4. `cleanupOldFileHistoryBackups()`
5. `cleanupOldSessionEnvDirs()`
6. 以及 debug logs、image caches、pastes、stale worktrees 等其他 cleanup

这段代码清楚说明两件事：

1. 作者当然知道不同 artifact family 需要不同 executor
2. 但 executor 目前仍是手写调度，而不是从统一 family registry 中读出

这意味着 cleanup plane 当前已经具备：

`family-specific execution`

却还不具备：

`family-specific metadata-driven execution`

也就是说，  
系统知道“要分开删谁”，  
但还没有正式保存“为什么分开、分开的共同字段是什么、哪一项变化后其他平面也必须同步更新”。

## 5. `cleanupPeriodDays` 再证明：settings plane 公开的是局部 knob，不是完整 grammar

`src/utils/cleanup.ts:25-29` 的 `getCutoffDate()` 只消费：

`cleanupPeriodDays`

`src/utils/settings/types.ts:325-333` 也只把它描述为：

`Number of days to retain chat transcripts...`

这说明当前 settings plane 在 retention 这条线上公开的是：

1. 一个全局天数阈值
2. 它对 transcript persistence 的用户文案

但没有公开的是：

1. family-specific retention owner
2. family-specific cleanup root
3. family-specific reader scope
4. family-specific drift invariant

也就是说，  
用户能看到的 policy knob 并不等于系统内部拥有的完整 family metadata grammar。

## 6. task outputs / scratchpad 说明：有真理，但真理主要寄居在 helper 中

`src/utils/task/diskOutput.ts:33-55` 把 task outputs 的关键 truth 写在：

1. `getTaskOutputDir()` path helper
2. 注释中的 non-clobber rationale
3. first-call session capture 约束

`src/utils/permissions/filesystem.ts:381-423,1488-1506,1645-1684` 则把 scratchpad truth 写在：

1. `getScratchpadDir()`
2. `isScratchpadPath()`
3. current-session read/write allow rule

这说明 live-session families 的制度 truth 当然存在，  
但这些 truth 当前主要寄居在：

`path helper + permission helper + comments`

而不是：

`shared descriptor that multiple subsystems can consume without reconstructing meaning`

这是 metadata gap 的第一种形态：

`truth exists, but exists locally.`

## 7. tool-results / transcripts 说明：一旦 family truth 跨入 persisted world，local truth 很快会变成拼图 truth

`src/utils/toolResultStorage.ts:27,94-118` 给出了：

1. `TOOL_RESULTS_SUBDIR`
2. `getToolResultsDir()`
3. `getToolResultPath()`

`src/utils/sessionStorage.ts:198-225` 给出了：

1. `getProjectsDir()`
2. `getTranscriptPath()`
3. `getTranscriptPathForSession()`

`src/utils/cleanup.ts:155-257` 则负责真正的 project-root cleanup traversal。

`src/utils/permissions/filesystem.ts:1645-1667` 又只在读权限层面单独承认 tool-results。

这说明 persisted families 的制度 truth 已经被拆成：

1. path naming truth
2. directory hierarchy truth
3. read-allow truth
4. cleanup traversal truth

这已经不是“local truth”那么简单，  
而是：

`cross-file puzzle truth`

系统仍能工作，  
但理由与执行的对应关系已经需要跨模块重建。  
这正是 metadata plane 尚未成型的典型征兆。

## 8. plans family 再给出最强证据：没有 metadata plane 时，propagation 会天然失灵

`src/utils/settings/types.ts:824-830` 把 `plansDirectory` 公开为用户可调字段。

`src/utils/plans.ts:79-110` 让 `getPlansDirectory()` 真正消费这个字段。

`src/utils/permissions/filesystem.ts:245-254,1645-1652` 让 `isSessionPlanFile()` 与 plan-file read rule 继续围绕当前 session 的 plan artifact 工作。

`src/utils/plans.ts:164-233` 又让 resume recovery 正式依赖 plan file。

但 `src/utils/cleanup.ts:300-303` 的 `cleanupOldPlanFiles()` 仍只扫：

`~/.claude/plans`

这说明一件非常具体的事：

`plan-family truth 已经跨越 settings、storage、permission 与 recovery 四个平面，但 cleanup 平面仍未自动继承。`

如果存在显式 metadata plane，  
这类 propagation 应该更容易做到自动或至少集中校验；  
现在之所以失灵，  
正是因为 family truth 还没有被正式保存成同一份 descriptor。

## 9. file-history / session-env 说明：暂时没有失灵，不代表已经有 metadata

`src/utils/fileHistory.ts:728-741,951-957` 的 backup path truth 与 `src/utils/sessionEnvironment.ts:15-30,60-134` 的 env replay truth 目前看起来都比较稳定。

`src/utils/cleanup.ts:305-387` 也能对它们做相对一致的 per-session retention cleanup。

但这里仍然不能轻易得出：

`family metadata plane 已经存在`

因为更准确的状态其实是：

1. 这些 family 的 truth 目前还没有发生明显 propagation failure
2. 但它们的 truth 依旧分散在各自模块与 cleanup helper 中
3. 系统并没有显式描述“restore family”或“replay family”的共同字段

所以它们证明的是：

`metadata plane 还没有显式长出来，只是这些家族暂时没像 plans 一样把问题暴露得那么尖。`

## 10. 这篇源码剖面给主线带来的四条技术启示

### 启示一

只要 cleanup 调度还是手写 dispatch list，  
family truth 就仍然主要依赖实现纪律，而不是显式 policy grammar。

### 启示二

当 family truth 横跨 settings、path helper、permission、resume 与 cleanup 时，  
没有 metadata plane 的系统几乎一定会出现 propagation blind spot。

### 启示三

`plansDirectory` 与 `cleanupOldPlanFiles()` 的不对称不是孤立 bug 线索，  
而是元数据缺口第一次被源码自己显影。

### 启示四

真正成熟的做法不只是再加 helper，  
而是把 artifact-family truth 提升为：

1. 可被多平面共读
2. 可被 drift invariant 校验
3. 可被 settings 与 executor 一起消费

的显式 descriptor。

## 11. 一条硬结论

这组源码真正说明的不是：

`Claude Code 已经缺少 artifact-family 级治理。`

而是：

`Claude Code 已经拥有 artifact-family 级治理，但这套治理的 truth 仍主要寄居在 cleanup、settings 与 path helpers 的分散组合里，还没有被正式提升成 artifact-family metadata plane。`

因此：

`artifact-family cleanup metadata signer` 这一层必须独立于 `artifact-family cleanup rationale signer` 被追问；否则制度理由依然只能靠阅读者事后拼回，而不能由系统自己持续复述。
