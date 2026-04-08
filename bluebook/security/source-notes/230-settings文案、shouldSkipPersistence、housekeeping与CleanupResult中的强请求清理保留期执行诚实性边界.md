# settings文案、shouldSkipPersistence、housekeeping与CleanupResult中的强请求清理保留期执行诚实性边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `379` 时，
真正需要被单独钉住的已经不是：

`谁来定义 stronger-request old echo carriers 的 retention horizon，`

而是：

`谁来诚实说明这条 retention horizon 当前在 scope、timing、coverage 与 execution status 上到底执行到哪里。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`stronger-request retention-governor 不等于 stronger-request retention-enforcement-honesty-governor。`

这句话还不够硬。
所以这里单开一篇，只盯住：

- `src/utils/settings/types.ts`
- `src/utils/settings/validationTips.ts`
- `src/skills/bundled/updateConfig.ts`
- `src/utils/sessionStorage.ts`
- `src/main.tsx`
- `src/screens/REPL.tsx`
- `src/utils/backgroundHousekeeping.ts`
- `src/utils/cleanup.ts`
- `src/utils/diagLogs.ts`

把 declaration wording、future suppression、deferred execution、visible cleanup coverage、local receipt gap 与 uncovered diagnostics gap 并排，
逼出一句更硬的结论：

`Claude Code 已经明确展示：retention law 已经存在，但 law 的当前执行说明仍需另一层 honesty governor；否则 stronger-request old echo carriers 的 scope、timing、coverage 与 execution status 会继续被过窄、过满、过少或部分缺席地表达。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 已经有 cleanupPeriodDays、backgroundHousekeeping 与 cleanup executor。`

而是：

`Claude Code 已经把 stronger-request retention execution truth 裂成 declaration truth、future-suppression truth、runtime-admission truth、visible cleanup-coverage truth、execution-receipt truth 与 uncovered-carrier truth 六层。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| transcript-centered declaration wording | `src/utils/settings/types.ts:325-332`; `src/utils/settings/validationTips.ts:48-54`; `src/skills/bundled/updateConfig.ts:96-99` | 当前对用户声明的 retention scope 与 timing 是什么 |
| immediate future suppression | `src/utils/sessionStorage.ts:954-969` | 哪部分 truth 会立刻生效 |
| runtime admission gating | `src/main.tsx:2811-2818`; `src/screens/REPL.tsx:3903-3906`; `src/utils/backgroundHousekeeping.ts:43-80` | 哪部分 truth 要等 startup path / first-submit / delay / recent-activity gate 放行 |
| wider visible cleanup coverage | `src/utils/cleanup.ts:155-190,300-303,305-428,575-596` | 实际 executor 当前 visibly 覆盖了哪些 carrier family |
| local receipt gap | `src/utils/cleanup.ts:33-40,575-596` | 为什么 `CleanupResult` 存在，却没有统一 surfaced receipt |
| uncovered diagnostics gap | `src/utils/diagLogs.ts:27-53` | 为什么 diagnostics carrier 当前只显露 writer，而未显露同层 honesty path |

## 4. declaration wording 先把 scope 说窄了：用户看到的是 transcripts，executor 做的却更宽

`src/utils/settings/types.ts:325-332`
写的是：

`Number of days to retain chat transcripts`

`validationTips.ts:48-54`
写的是：

`days to retain transcripts`

`updateConfig.ts:96-99`
也继续写：

`Days to keep transcripts`

这组 declaration wording 很一致。

但 `cleanup.ts:155-190,300-303,305-428,575-596`
的 visible executor coverage 明显更宽，
至少包含：

1. session `.jsonl/.cast`
2. tool-results
3. plans
4. file-history
5. session-env
6. debug logs
7. image caches
8. pastes
9. stale worktrees

这条张力非常值钱。

因为它说明 stronger-request retention-enforcement honesty 的第一种核心问题，
不是 declaration `说太多`，
反而是 declaration `说太少`。

也就是说，
当前用户侧 retention wording 仍不足以诚实覆盖 visible executor scope。

## 5. declaration wording 又把 timing 说满了：用户看到的是 startup delete，runtime 实际却是延迟与分模式 admission

`settings/types.ts:331-332`
与
`validationTips.ts:52-54`
都写：

`existing transcripts are deleted at startup`

但 visible runtime truth 至少裂成三半。

第一半是：

`sessionStorage.ts:954-969`

这里 `shouldSkipPersistence()` 会在 `cleanupPeriodDays === 0` 时立刻 suppress future transcript writes。

第二半是：

`main.tsx:2811-2818`

这里 startup path 只是异步 import `backgroundHousekeeping`，没有同步 delete receipt。

第三半是：

`REPL.tsx:3903-3906`

与

`backgroundHousekeeping.ts:43-80`

这些路径共同说明：

1. REPL 要等 first submit
2. housekeeping 还要先等 `10 minutes`
3. 最近有交互还会继续推迟
4. `needsCleanup` 只允许一轮 one-shot first cleanup

所以 stronger-request retention-enforcement honesty 的第二种核心问题，
正好与 scope 相反：

`timing 被说得过满了。`

也就是说，
当前 visible runtime 并不足以支持把这条语句直接理解成：

`process start -> synchronous cleanup complete`

## 6. `shouldSkipPersistence()` 是一条正控制面，但它只诚实回答 future suppression

`sessionStorage.ts:954-969`
说明：

1. 未来 transcript writes 可以立刻停
2. materialize path 也尊重同一 guard
3. `cleanupPeriodDays=0` 与其他 suppress path 共用同一开关

这是一个重要正控制面。

因为它至少保证：

`from now on, do not write new transcript carriers`

但 stronger-request retention-enforcement honesty 的问题恰恰在这里继续显露：

这条 positive control 只能诚实说明：

`future-write suppression truth`

却不能单独诚实说明：

`past stronger-request carriers have already been cleaned`

所以如果没有更高一层 honesty governor，
`disables persistence entirely`

这样的 declaration wording 就很容易把两半 truth 压成一个过强结论。

## 7. wider cleanup coverage 与 local receipt gap 一起证明：系统会做事，但没把做了什么统一说清

`cleanup.ts`
明明为各 cleanup function 定义了：

`CleanupResult = { messages, errors }`

并且 visible executor coverage 已经很广。

但 `cleanupOldMessageFilesInBackground()`
最终做的是：

1. 顺序 await 各 cleanup
2. 自己只返回 `Promise<void>`
3. 不把 aggregated result 回传给 caller
4. 只对 stale worktrees 特别发 telemetry

这意味着 stronger-request retention-enforcement honesty 当前缺的，
不是“有没有执行能力”，
而是：

`有没有一条统一 execution receipt 去把 wider coverage 诚实表达到上层`

否则用户只能同时面对三种不对称：

1. declaration wording 说得太窄
2. execution timing 说得太满
3. execution receipt 又说得太少

## 8. diagnostics 继续构成最硬的 uncovered-carrier gap

`diagLogs.ts:27-53`
只告诉我们：

1. diagnostics entry 会被 append 到一个 logfile
2. 路径来自 `CLAUDE_CODE_DIAGNOSTICS_FILE`
3. 当前 repo-local code 公开的是 writer，不是同层 honesty path

就当前 repo 内部可见代码而言，
我们还看不到与之同层的：

`declared diagnostics retention wording`

或

`visible diagnostics execution receipt`

这条 gap 极其关键。

因为它说明 stronger-request retention-enforcement honesty 当前不仅缺：

`what has already executed`

还缺：

`which carriers are even honestly named inside the visible execution story`

所以 diagnostics 在这里不是旁支，
而是 strongest negative control。

## 9. 为什么这一层不等于 `229` 的 retention-governance gate

这里必须单独讲清楚，
否则最容易把 `230` 误读成 `229` 的尾注。

`229` 问的是：

`谁来定义 stronger-request carriers 的 retention horizon、validation veto、future suppression、runtime admission 与 visible coverage。`

`230` 问的是：

`当前系统是否已经把这条 horizon 在 scope、timing、coverage 与 execution status 上诚实说清。`

所以：

1. `229` 的典型形态是 `cleanupPeriodDays`、validation veto、housekeeping admission、coverage declaration
2. `230` 的典型形态是 transcript-centered wording、startup wording、future-suppression truth、local-only `CleanupResult` 与 diagnostics uncovered honesty path

前者 guarding time law，
后者 guarding execution truth。

两者都很重要，
但不是同一个 signer。

## 10. 从技术先进性看：成熟安全系统为什么要把“有法律”与“把执法说清”拆开

这组源码给出的设计启示至少有六条：

1. law 的存在不等于 law 的诚实执行说明
2. future suppression、past cleanup、deferred execution 必须分开说
3. wider executor coverage 需要对应的 wider honesty surface
4. receipt 不是统计细节，而是 execution truth 的签字面
5. 没被说明的 coverage gap，本身就是 honesty gap
6. declare / admit / execute / report 应该是四个不同的安全层

它的哲学本质是：

`成熟安全系统不仅关心自己做没做，还关心自己是否诚实说明了做到哪里。`

## 11. 一条硬结论

这组源码真正说明的不是：

`只要 retention policy 已经被定义，系统当前就已经诚实说明了这条 policy 怎样被执行。`

而是：

Claude Code 已经在 transcript-centered declaration wording、startup delete wording、future-suppression truth、wider executor coverage、local-only `CleanupResult` 与 diagnostics uncovered gap 上，清楚展示了 stronger-request retention-enforcement-honesty governance 的独立存在；因此 `artifact-family cleanup stronger-request retention-governor signer` 仍不能越级冒充 `artifact-family cleanup stronger-request retention-enforcement-honesty-governor signer`。
