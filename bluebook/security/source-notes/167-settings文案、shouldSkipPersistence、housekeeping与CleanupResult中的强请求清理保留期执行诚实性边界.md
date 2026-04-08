# settings文案、shouldSkipPersistence、housekeeping与CleanupResult中的强请求清理保留期执行诚实性边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `316` 时，
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
| runtime admission gating | `src/main.tsx:2811-2818`; `src/screens/REPL.tsx:3903-3906`; `src/utils/backgroundHousekeeping.ts:43-60,77-80` | 哪部分 truth 要等 startup path / first-submit / delay / recent-activity gate 放行 |
| wider visible cleanup coverage | `src/utils/cleanup.ts:155-257,300-347,350-428,575-598` | 实际 executor 当前 visibly 覆盖了哪些 carrier family |
| local receipt gap | `src/utils/cleanup.ts:33-45,575-598` | 为什么 `CleanupResult` 存在，却没有统一 surfaced receipt |
| uncovered diagnostics gap | `src/utils/diagLogs.ts:27-60` | 为什么 diagnostics carrier 当前只显露 writer，而未显露同层 honesty path |

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

但 `cleanup.ts:155-257,300-347,350-428,575-598`
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

`backgroundHousekeeping.ts:43-60,77-80`

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

`diagLogs.ts:27-60`
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

## 9. 为什么这一层不等于 `166` 的 retention-governance gate

这里必须单独讲清楚，
否则最容易把 `167` 误读成 `166` 的尾注。

`166` 问的是：

`谁来定义 stronger-request carriers 的 retention horizon、validation veto、future suppression、runtime admission 与 visible coverage。`

`167` 问的是：

`当前系统是否已经把这条 horizon 在 scope、timing、coverage 与 execution status 上诚实说清。`

所以：

1. `166` 的典型形态是 `cleanupPeriodDays`、validation veto、housekeeping admission、coverage declaration
2. `167` 的典型形态是 transcript-centered wording、startup wording、future-suppression truth、local-only `CleanupResult` 与 diagnostics uncovered honesty path

前者 guarding time law，
后者 guarding execution truth。

两者都很重要，
但不是同一个 signer。

## 10. 从技术角度看这组代码给出的启示

如果把这组机制抽成技术启示，
至少有六条：

1. law 的存在不等于 law 的诚实执行说明
2. scope honesty、timing honesty、coverage honesty 与 receipt honesty 都是安全问题
3. future suppression、past cleanup、deferred execution 与 surfaced receipt 必须分开说
4. wider executor coverage 需要对应的 wider honesty surface，否则“做得更多”会变成“说得更少”
5. local `CleanupResult` 的存在说明作者已经意识到 cleanup outcome 值得被计数，只是还没把它升格成 family-wide execution truth
6. 真正先进的安全设计不是把话说满，而是拒绝把 policy truth 冒充成 runtime truth

## 11. 苏格拉底式自反诘问：我是不是又把“规则写好了”误当成了“系统已经诚实说明了自己做到哪一步”

如果对这组代码做更严格的自我审查，
至少要追问六句：

1. 如果 retention law 已经存在，为什么我还说 honesty 层独立？
   因为 ought 不是 current runtime truth。
2. 如果 `cleanupPeriodDays=0` 已经 suppress 了 future writes，为什么还不够？
   因为 future suppression 不等于 past cleanup。
3. 如果 visible executor 覆盖范围很宽，为什么这不自动算 honest？
   因为用户文案并没有同步把更宽的 scope 说清。
4. 如果 startup path 最终会触发 housekeeping，为什么 timing 仍有 honesty gap？
   因为 eventual execution 不等于 startup completion。
5. 如果 `CleanupResult` 已经存在，为什么 receipt 仍是缺口？
   因为 local return value 不是 surfaced family-wide truth。
6. 如果 diagnostics 只是 env-selected file，为什么它还能构成 honesty 边界？
   因为没被说明的 coverage gap，本身就是 honesty gap。

这组反问最终逼出一句更稳的判断：

`retention-enforcement honesty 的关键，不在系统有没有动作，而在系统能不能诚实告诉你它现在到底已经做了什么、还没做什么、以及哪些载体仍在它的明说边界之外。`

## 12. 一条硬结论

这组源码真正说明的不是：

`Claude Code 已经有 cleanupPeriodDays、backgroundHousekeeping 与 cleanup executor，所以 stronger-request retention execution 已经被诚实说明。`

而是：

`Claude Code 已经把 stronger-request retention execution truth 裂成 declaration truth、future-suppression truth、runtime-admission truth、visible cleanup-coverage truth、execution-receipt truth 与 uncovered-carrier truth 多层；正因为这些层被分别写出，artifact-family cleanup stronger-request retention-governor signer 才仍不能越级冒充 artifact-family cleanup stronger-request retention-enforcement-honesty-governor signer。`

再压成一句：

`有时间法律，不等于有时间法律的诚实执行说明。`
