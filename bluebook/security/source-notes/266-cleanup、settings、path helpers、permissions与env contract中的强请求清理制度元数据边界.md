# cleanup、settings、path helpers、permissions与env contract中的强请求清理制度元数据边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `415` 时，
真正需要被单独钉住的已经不是：

`different stronger-request cleanup family rationale 是否存在，`

而是：

`这些 rationale 现在到底靠什么被系统自己记住。`

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
- `src/utils/permissions/filesystem.ts`
- `src/utils/fileHistory.ts`
- `src/utils/sessionEnvironment.ts`
- `src/utils/debug.ts`
- `src/utils/diagLogs.ts`

把一个更贴近当前源码真相的判断钉死：

`Claude Code 当前不是“没有 cleanup metadata”，而是“已经有 plural family-local metadata microgrammar，但还没有 equally-strong canonical carrier”。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 缺少 stronger-request family truth。`

而是：

`Claude Code 已经让不同 stronger-request cleanup family 各自长出非常贴身的名字、路径、slug、tag、priority、pointer 与 env contract；问题不在于 truth 缺席，而在于这些 truth 还没有形成同等级的 shared metadata plane。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| hand-written family dispatcher | `src/utils/cleanup.ts:155-257,300-303,391-428,575-598` | 为什么 cleanup plane 当前仍更像手写 family execution，而不是 metadata-driven registry |
| local settings knobs | `src/utils/settings/types.ts:325-332,824-830` | 为什么对外公开的仍主要是 retention / plans 两个局部字段，而不是完整 family grammar |
| local explicit microgrammar | `src/utils/task/diskOutput.ts:33-55`; `src/utils/diagLogs.ts:5-12,14-20,27-60` | 为什么有些 family 的 truth 已非常显式，却仍主要停留在 module-local helper / contract |
| path-level grammar | `src/utils/toolResultStorage.ts:26-31,94-116`; `src/utils/sessionStorage.ts:202-225,247-258` | 为什么 tool-results / transcripts 已经拥有 naming grammar，却仍不是 shared descriptor |
| cross-plane propagation stress test | `src/utils/plans.ts:32-48,79-110,119-129,164-229`; `src/utils/permissions/filesystem.ts:244-255,1487-1495,1644-1652`; `src/utils/cleanup.ts:300-303` | 为什么 plans family 最能暴露 canonical carrier 缺位时的传播失灵 |
| stable but still local grammar | `src/utils/fileHistory.ts:951-957`; `src/utils/sessionEnvironment.ts:15-31,72-100,146-150`; `src/utils/debug.ts:44-56,91-101,230-249` | 为什么有些 family 即使暂时不失灵，也仍主要依靠 local microgrammar 生存 |

## 4. `cleanup.ts` 先证明：系统已经知道 family 有别，但这种“知道”仍主要停留在手写执行序列

`cleanupOldMessageFilesInBackground()`
会顺次调：

1. `cleanupOldMessageFiles()`
2. `cleanupOldSessionFiles()`
3. `cleanupOldPlanFiles()`
4. `cleanupOldFileHistoryBackups()`
5. `cleanupOldSessionEnvDirs()`
6. `cleanupOldDebugLogs()`
7. image caches、pastes、stale worktrees 等

这说明两件事：

1. 系统当然知道 stronger-request cleanup 不是单一家族
2. 但这个 plurality 当前主要仍以 hand-written function order 的形式存在

也就是说，
当前显露出来的是：

`family-specific execution`

还不是：

`metadata-driven family execution`

这一点非常关键。
因为它意味着系统已经 operationally 知道 family 有别，
却还没有 equally-strong 地回答：

`这些不同究竟被保存成了什么共享语法。`

## 5. `settings/types.ts` 再证明：当前公开的是局部 knob，不是完整 family grammar

`settings/types.ts:325-332`
公开的是：

`cleanupPeriodDays`

而且它还把 scope 压成：

`retain chat transcripts`

`settings/types.ts:824-830`
公开的是：

`plansDirectory`

这说明 settings plane 的确知道某些 family truth，
但它知道的方式仍然是：

1. 一个全局 retention knob
2. 一个特定 family 的路径 override

它没有系统性公开的是：

1. family-specific reader scope
2. operational duty
3. host visibility
4. current-pointer semantics
5. drift invariant

所以 settings plane 当前更像：

`some knobs`

而不是：

`cleanup family metadata grammar`

## 6. `diskOutput.ts`、`toolResultStorage.ts` 与 `sessionStorage.ts` 说明：repo 已经长出多套 path-level metadata microgrammar

`diskOutput.ts:33-55`
最硬的点不是 comment 本身，
而是：

1. non-clobber rationale 被直接写进 helper
2. `sessionId` 被固定进 `project-temp/sessionId/tasks`
3. first-call capture 被显式写出来抵抗 `/clear` drift

这是非常典型的：

`helper-local metadata microgrammar`

`toolResultStorage.ts:26-31,94-116`
又把 tool-results 编成：

1. `tool-results` subdir
2. `<persisted-output>` tag
3. `id.json|txt` 文件名

这是另一种：

`carrier-local naming grammar`

`sessionStorage.ts:202-225,247-258`
再把 transcript family 编成：

1. `${sessionId}.jsonl`
2. current session honor `sessionProjectDir`
3. subagent transcript 放在 `sessionId/subagents/.../agent-${agentId}.jsonl`

这说明当前系统并不是缺少 metadata，
而是：

`metadata already exists as multiple local grammars`

但这些 grammar 仍主要活在各自 helper 里，
还没有被提升成 shared descriptor。

## 7. `plans.ts` 与 permission plane 暴露最硬的事实：一旦 truth 要跨平面传播，local grammar 就不再够用

plans family 当前横跨：

1. slug cache
2. `plansDirectory`
3. main / agent filename grammar
4. current-session read/write allow rule
5. resume recovery
6. fork copy
7. cleanup executor

`plans.ts`
负责：

1. 生成 unique word slug
2. 定义 `{slug}.md` 与 `{slug}-agent-{agentId}.md`
3. 允许 `plansDirectory` override
4. 在缺文件时从 snapshot / message history 恢复 plan

`permissions/filesystem.ts`
又把：

1. `join(getPlansDirectory(), getPlanSlug())`
2. current-session read/write allow

写进 permission plane。

但 `cleanup.ts:300-303`
仍主要只清：

`~/.claude/plans`

这就是最硬的 metadata 证据：

`只要一个 family truth 同时跨 settings、storage、permissions、recovery 与 cleanup executor 传播，没有 canonical carrier，传播就会开始依赖人工纪律。`

这里真正值钱的判断不是“发现了一个点状 bug”，
而是：

`cross-plane truth has no equally-strong canonical carrier`

## 8. `fileHistory`、`sessionEnvironment`、`debug` 与 `diagLogs` 再证明：很多 family 已经有稳定微语法，但它们仍主要是 local self-description

`fileHistory.ts:951-957`
把 restore family 编成：

`~/.claude/file-history/<sessionId>/`

`sessionEnvironment.ts:15-31,72-100,146-150`
把 replay family 编成：

1. `session-env/<sessionId>/`
2. `setup-hook-0.sh` 之类 hook-file naming
3. `CLAUDE_ENV_FILE`
4. `HOOK_ENV_PRIORITY`

`debug.ts:44-56,91-101,230-249`
把 operational family 编成：

1. `DEBUG` / `DEBUG_SDK` / `--debug` / `--debug-file`
2. default `debug/<sessionId>.txt`
3. `latest` symlink

`diagLogs.ts:5-12,14-20,27-60`
又把 diagnostics 编成：

1. `DiagnosticLogEntry{timestamp, level, event, data}`
2. no-PII contract
3. `CLAUDE_CODE_DIAGNOSTICS_FILE`

这些都说明：

`Claude Code 并不是不会给制度命名。`

它其实很会命名。
问题是这些名字主要在局部 module 内生效，
还没有形成 equally-strong shared plane。

## 9. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup metadata 还不存在。`

而是：

`stronger-request cleanup metadata 已经以 plural microgrammar 的形式存在；真正缺的是当 family truth 需要跨平面传播时，谁来负责把这些 microgrammar 提升成系统自己的长期自描述。`

因此：

`artifact-family cleanup stronger-request cleanup-rationale-governor signer`
仍不能越级冒充
`artifact-family cleanup stronger-request cleanup-metadata-governor signer`。

最后把它压成一句：

`Claude Code 已经会在很多地方说自己，但它还没有同等强度地保证这些说法彼此保持同一份记忆。`
