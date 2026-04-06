# settings文案、sessionStorage、backgroundHousekeeping、cleanup与diagLogs的强请求保留期执行诚实性边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `188` 时，
真正需要被单独钉住的已经不是：

`谁来定义 stronger-request old echo carriers 的 retention horizon，`

而是：

`谁来诚实说明这条 retention horizon 当前在 scope、timing、coverage 与 execution status 上到底执行到哪里。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`stronger-request retention governor 不等于 stronger-request retention-enforcement-honesty governor。`

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

把 declaration wording、future suppression、deferred execution、visible cleanup coverage 与 uncovered diagnostics gap 并排，
逼出一句更硬的结论：

`Claude Code 已经明确展示：retention law 已经存在，但 law 的当前执行说明仍需另一层 honesty governor；否则 stronger-request old echo carriers 的 scope、timing 与 coverage 会继续被过窄、过满或部分缺席地表达。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 已经有 cleanupPeriodDays、backgroundHousekeeping 与 cleanup executor。`

而是：

`Claude Code 已经把 stronger-request retention execution truth 裂成 declaration truth、future-suppression truth、runtime-admission truth、visible cleanup-coverage truth 与 uncovered-carrier truth 五层。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| transcript-centered declaration wording | `src/utils/settings/types.ts:325-332`; `src/utils/settings/validationTips.ts:48-54`; `src/skills/bundled/updateConfig.ts:96-99` | 当前对用户声明的 retention scope 与 timing 是什么 |
| immediate future suppression | `src/utils/sessionStorage.ts:953-980` | 哪部分 truth 会立刻生效 |
| runtime admission gating | `src/main.tsx:2811-2818`; `src/screens/REPL.tsx:3903-3906`; `src/utils/backgroundHousekeeping.ts:43-60,77-80` | 哪部分 truth 要等 mode / first-submit / delay / recent-activity gate 放行 |
| wider visible cleanup coverage | `src/utils/cleanup.ts:155-257,300-347,350-428,575-595` | 实际 executor 当前 visibly 覆盖了哪些 carrier family |
| uncovered diagnostics gap | `src/utils/diagLogs.ts:27-60` | 为什么 diagnostics carrier 当前只显露 writer，而未显露同层 honesty path |

## 4. declaration wording 先把 scope 说窄了：用户看到的是 transcripts，executor 做的却更宽

`src/utils/settings/types.ts:325-332` 写的是：

`Number of days to retain chat transcripts`

`validationTips.ts:48-54` 写的是：

`days to retain transcripts`

`updateConfig.ts:96-99` 也继续写：

`Days to keep transcripts`

这组 declaration wording 很一致。

但 `cleanup.ts:155-257,300-347,350-428,575-595` 的 visible executor coverage 明显更宽，
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
不是 declaration “说太多”，
反而是 declaration “说太少”。

也就是说，
当前用户侧 retention wording 仍不足以诚实覆盖 visible executor scope。

## 5. declaration wording 又把 timing 说满了：用户看到的是 startup delete，runtime 实际却是延迟与分模式 admission

`settings/types.ts:331-332` 与 `validationTips.ts:52-54` 都写：

`existing transcripts are deleted at startup`

但 visible runtime truth 至少裂成两半。

第一半是：

`sessionStorage.ts:953-980`

这里 `shouldSkipPersistence()` 会在 `cleanupPeriodDays === 0` 时立刻 suppress future transcript writes。

第二半是：

`main.tsx:2811-2818`

`REPL.tsx:3903-3906`

`backgroundHousekeeping.ts:43-60,77-80`

这些路径共同说明：

1. headless bookkeeping 是 fire-and-forget
2. REPL 要等 first submit
3. housekeeping 还要先等 `10 minutes`
4. 最近有交互还会继续推迟

所以 stronger-request retention-enforcement honesty 的第二种核心问题，
正好与 scope 相反：

`timing 被说得过满了。`

也就是说，
当前 visible runtime 并不足以支持把这条语句直接理解成：

`process start -> synchronous cleanup complete`

## 6. `shouldSkipPersistence()` 是一条正控制面，但它只诚实回答 future suppression

`sessionStorage.ts:953-980` 说明：

1. 未来 transcript writes 可以立刻停
2. 而且 materialize path 也尊重同一 guard

这是一个重要正控制面。

因为它至少保证：

`from now on, do not write new transcript carriers`

但 stronger-request retention-enforcement honesty 的问题恰恰在这里继续显露：

这条 positive control 只能诚实说明：

`future-write suppression truth`

却不能单独诚实说明：

`past stronger-request carriers have already been cleaned`

所以如果没有更高一层 honesty governor，
“disables persistence entirely” 这样的 declaration wording 就很容易把两半 truth 压成一个过强结论。

## 7. wider cleanup coverage 与 missing receipt 一起证明：系统会做事，但没把做了什么统一说清

`cleanup.ts` 明明为各 cleanup function 定义了：

`CleanupResult = { messages, errors }`

并且 visible executor coverage 已经很广。

但 `cleanupOldMessageFilesInBackground()` 最终做的是：

1. 顺序 await 各 cleanup
2. 自己只返回 `Promise<void>`
3. 不把 aggregated result 回传给 caller

这意味着 stronger-request retention-enforcement honesty 当前缺的，
不是“有没有执行能力”，
而是：

`有没有一条统一 execution receipt 去把 wider coverage 诚实表达到上层。`

否则用户只能同时面对两种不对称：

1. declaration wording 说得太窄
2. execution receipt 又说得太少

## 8. diagnostics 继续构成最硬的 uncovered-carrier gap

`diagLogs.ts:27-60` 只告诉我们：

1. diagnostics entry 会被 append 到一个 logfile
2. 路径来自 `CLAUDE_CODE_DIAGNOSTICS_FILE`

就当前 repo 内部可见代码而言，
我们还看不到与之同层的：

`declared diagnostics retention wording`

或

`visible diagnostics retention receipt`

这条 gap 极其关键。

因为它说明 stronger-request retention-enforcement honesty 当前不仅缺：

`what has already executed`

还缺：

`which carriers are even honestly named inside the visible execution story`

所以 diagnostics 在这里不是旁支，
而是 strongest negative control。

## 9. 为什么这一层不等于 `187` 的 retention-governance gate

这里必须单独讲清楚，
否则最容易把 `188` 误读成 `187` 的尾注。

`187` 问的是：

`谁来定义 stronger-request carriers 的 retention horizon、validation gate、runtime admission 与 visible coverage。`

`188` 问的是：

`当前系统是否已经把这条 horizon 在 scope、timing、coverage 与 execution status 上诚实说清。`

所以：

1. `187` 的典型形态是 `cleanupPeriodDays`、`rawSettingsContainsKey()`、background scheduler、visible debug cleanup
2. `188` 的典型形态是 transcript-centered wording、startup-delete wording、future suppression、wider executor coverage、missing unified receipt、diagnostics opacity

前者 guarding temporal law，
后者 guarding temporal truthfulness。

两者都很重要，
但不是同一个 signer。

## 10. 一条硬结论

这组源码真正说明的不是：

`只要 stronger-request retention governance 已经存在，系统就已经诚实说明了当前 stronger-request old echo carriers 的 retention execution status。`

而是：

`repo 已经在 transcript-centered declaration wording、startup-delete timing wording、future-suppression truth、wider cleanup coverage 与 diagnostics uncovered gap 上，清楚展示了 stronger-request retention-enforcement honesty 的独立存在；因此 artifact-family cleanup stronger-request retention-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request retention-enforcement-honesty-governor signer。`

因此：

`cleanup 线真正缺的，不只是“谁来定义 stronger-request carriers 的 retention law”，还包括“谁来诚实说明这条 law 当前到底覆盖了什么、何时真正执行、何时只是 future suppression、何时仍是部分显化”。`
