# task outputs、tool-results、transcripts 与 plans 的清理家族宪法

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `158` 时，  
真正需要被单独拆开的已经不是：

`cleanup 有没有隔离，`

而是：

`为什么不同 artifact family 现在明显活在不同的 cleanup constitution 里？`

如果这个问题只停在主线长文里，  
很容易被压成一句抽象的 “多宪法并存”。  
所以这里单开一篇，只盯住：

- `src/utils/task/diskOutput.ts`
- `src/utils/toolResultStorage.ts`
- `src/utils/sessionStorage.ts`
- `src/utils/plans.ts`
- `src/utils/permissions/filesystem.ts`
- `src/utils/cleanup.ts`

把 task outputs、scratchpad、tool-results、transcripts、plans、file-history、session-env 的 storage scope 与 cleanup root 拆给源码本身说话。

## 2. 先给最短判断

这组代码最重要的技术事实不是：

`Claude Code 现在有没有 cleanup policy。`

而是：

`Claude Code 当前已经展示出多种 artifact-family cleanup constitution 并存，而不是一个统一的删除宪法。`

因为它同时暴露出四种明显不同的制度形态：

1. session-scoped temp constitution  
   task outputs、scratchpad
2. project-session sweep constitution  
   transcripts、tool-results
3. home-root single-directory constitution  
   plans
4. home-root per-session-dir constitution  
   file-history、session-env

这意味着当前系统至少已经把：

`cleanup isolation`

和

`cleanup constitution design`

拆成两层。

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| task-output family | `src/utils/task/diskOutput.ts:33-55` | 为什么 task outputs 拥有 session-scoped temp constitution |
| scratchpad family | `src/utils/permissions/filesystem.ts:381-423` | 为什么 scratchpad 也归入 current-session temp constitution |
| tool-results family | `src/utils/toolResultStorage.ts:94-118`; `src/utils/cleanup.ts:196-250` | 为什么 persisted outputs 仍留在 project-session sweep 世界 |
| transcript family | `src/utils/sessionStorage.ts:198-215`; `src/utils/cleanup.ts:181-195` | 为什么 transcript/cast 仍服从 project-root top-level sweep |
| plans family | `src/utils/plans.ts:79-110`; `src/utils/cleanup.ts:300-303` | 为什么 plans 默认走 home-root single-directory cleanup |
| backup/env families | `src/utils/fileHistory.ts:951-957`; `src/utils/cleanup.ts:305-387` | 为什么 file-history 和 session-env 形成另一类 home-root per-session retention constitution |

## 4. task outputs 与 scratchpad 先证明：session-scoped temp constitution 是真实存在的

`src/utils/task/diskOutput.ts:33-55` 把 task outputs 定义为：

`getProjectTempDir()/sessionId/tasks`

它不仅用 sessionId 下沉到路径，  
而且把原因直接写在注释里：

`concurrent sessions in the same project don't clobber each other's output files`

`src/utils/permissions/filesystem.ts:381-423` 又把 scratchpad 定义为：

`getProjectTempDir()/sessionId/scratchpad`

并且：

1. `ensureScratchpadDir()` 明确创建 owner-only dir
2. `isScratchpadPath()` 只承认当前 session path

这说明至少这两个 family 已经服从同一类 cleanup constitution：

`session-scoped temp constitution`

它的核心不是 mtime，也不是项目级 sweep，  
而是：

`先把边界做小，再谈清理。`

## 5. tool-results 与 transcripts 说明 project-session sweep 仍是另一种治理模型

`src/utils/toolResultStorage.ts:94-118` 说明 tool-results 落在：

`projectDir/sessionId/tool-results`

`src/utils/sessionStorage.ts:198-215` 说明 transcript/cast 落在：

- `projectDir/<session>.jsonl`
- `projectDir/<session>.cast`

而 `src/utils/cleanup.ts:155-257` 则说明这类 family 被清理时，  
首先不是看 session-scoped temp constitution，  
而是：

1. 进入 `~/.claude/projects/<project>`
2. 清顶层 transcript/cast
3. 再清各 sessionDir 的 `tool-results`

这就是另一类治理模型：

`project-session sweep constitution`

它的核心不是：

`path already isolated enough`

而是：

`project is the sweep root, session is the bucket, mtime is the gate`

这和 task outputs/scratchpad 的 temp-dir constitution 显然不是同一套家法。

## 6. plans 又说明：有些 family 根本不生活在 project/session tree 里

`src/utils/plans.ts:79-110` 说明：

1. plans 默认落在 `~/.claude/plans`
2. 只有显式 `plansDirectory` 时才可能进入 project root
3. 还带有 “must stay within project root” 的校验

`src/utils/cleanup.ts:300-303` 说明 cleanup 对 plans 做的是：

`cleanupSingleDirectory(plansDir, '.md')`

这说明 plans family 默认服从的不是：

- temp-dir session constitution
- project-session sweep constitution

而是：

`home-root single-directory markdown constitution`

这里最有价值的技术启示是：

`plan family 的存储理由和 cleanup 理由并不是从 session artifact 逻辑推出来的，而是从 planning subsystem 的单独产品地位推出来的。`

## 7. file-history 与 session-env 再展示一种不同家法：home-root per-session-dir retention

`src/utils/fileHistory.ts:951-957` 说明 file-history backups 在：

`~/.claude/file-history/<sessionId>/`

`src/utils/cleanup.ts:305-347` 则按 sessionDir mtime 递归清理它。

`src/utils/cleanup.ts:350-387` 对 `session-env` 目录也采用了类似模式：

`~/.claude/session-env/<session>/`

这又不是 plan 的 single-directory cleanup，  
而是：

`home-root per-session-dir retention constitution`

也就是说，  
Claude Code 至少已经存在三种不同的 home-root cleanup law：

1. plans
2. file-history
3. session-env

其中 plans 是 single-dir，  
后两者是 per-session-dir。

## 8. 这篇源码剖面给主线带来的三条技术启示

### 启示一

Claude Code 的 cleanup 不是一条统一 pipeline，  
而是多个 artifact family 各自长出的 cleanup constitution。

### 启示二

真正值得继续研究的，不是“为什么不统一”，  
而是“为什么这些差异存在，以及它们是否被清楚建模”。

### 启示三

当一个系统已经进入多宪法并存状态时，  
更高阶的工程问题不再是修某个 bug，  
而是给每个 family 的 cleanup law 找到正式的 constitution signer。

## 9. 一条硬结论

这组源码真正说明的不是：

`cleanup isolation 一旦存在，就足以解释全仓库的删除规则`

而是：

`task outputs、scratchpad、tool-results、transcripts、plans、file-history 与 session-env 当前处在多种 cleanup constitution 并存的世界里。`

因此：

`cleanup-isolation signer 仍不能越级冒充 artifact-family cleanup constitution signer。`
