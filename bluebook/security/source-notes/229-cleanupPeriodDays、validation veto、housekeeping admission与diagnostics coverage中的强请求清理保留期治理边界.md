# cleanupPeriodDays、validation veto、housekeeping admission与diagnostics coverage中的强请求清理保留期治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `378` 时，
真正需要被单独钉住的已经不是：

`谁能删掉某个 stronger-request old echo carrier，`

而是：

`谁来定义这类 stronger-request old echo carriers 本来该保留多久、validation 出错时谁有权停手、何时允许真正执行 cleanup、从现在起哪些 future writes 应被立即压住，以及当前哪些 carriers 实际被纳入这条 retention law。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`stronger-request irreversible-erasure governor 不等于 stronger-request retention-governor。`

这句话还不够硬。
所以这里单开一篇，只盯住：

- `src/utils/settings/types.ts`
- `src/utils/settings/validationTips.ts`
- `src/utils/settings/settings.ts`
- `src/utils/sessionStorage.ts`
- `src/utils/backgroundHousekeeping.ts`
- `src/utils/cleanup.ts`
- `src/utils/diagLogs.ts`

把 retention declaration、validation veto、future suppression、runtime admission、visible cleanup coverage、local outcome vocabulary 与 uncovered diagnostics gap 并排，
逼出一句更硬的结论：

`Claude Code 已经明确展示：删除 stronger-request carrier 只解决 destruction event；只要 retention horizon、user-intent honesty、runtime admission、coverage boundary 与 family-wide receipt 仍由更高层 policy 栈控制，这条 stronger-request old echo 就还活在 retention-governance 问题里。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 能按 cutoff 删除一些能承载 stronger-request old echo 的文件。`

而是：

`Claude Code 明确把 stronger-request carrier retention 拆成 declaration、validation-veto、future-suppression、scheduler-admission、visible executor coverage、local result vocabulary 与 uncovered-carrier gap 七层。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| retention declaration | `src/utils/settings/types.ts:325-332` | 谁先定义 `cleanupPeriodDays` 及其默认 / 零值语义 |
| user-facing retention grammar | `src/utils/settings/validationTips.ts:48-54` | 产品语言怎样向用户解释 retention law |
| intent honesty veto | `src/utils/settings/settings.ts:871-875,984-1004`; `src/utils/cleanup.ts:575-584` | validation 出错时谁有权阻止默认 retention 接管 |
| future-write suppression | `src/utils/sessionStorage.ts:954-969` | 为什么 `cleanupPeriodDays=0` 先证明的是 transcript writes suppression |
| runtime admission / delay | `src/utils/backgroundHousekeeping.ts:43-80` | cleanup 何时真正被允许运行 |
| covered retention execution | `src/utils/cleanup.ts:23-40,93-131,155-190,300-303,305-428,575-596` | 哪些 visible carriers 当前已经纳入 cleanup horizon，以及结果如何只停留在 local vocabulary |
| uncovered diagnostics gap | `src/utils/diagLogs.ts:27-53` | 为什么 diagnostics carrier 当前只显露 writer / env getter，而未显露同层 retention owner |

## 4. `cleanupPeriodDays` 先写 stronger-request carrier 的时间法律，而不是让 delete operator 先说话

`src/utils/settings/types.ts:325-332`
很硬。

这里 repo 先把：

1. retention unit 写成天
2. 默认值写成 `30`
3. 下界写成 `0`
4. `0` 的强语义写成 `disable session persistence entirely`

这说明 stronger-request old echo carrier 的保留期主权，
首先不是：

`cleanupOldDebugLogs()` 或 `cleanupOldSessionFiles()`

而是：

`settings declaration`

也就是说，
retention 在 repo 当前公开结构里首先是一条：

`law of time`

而不是：

`fact of deletion`

## 5. `validationTips.ts` 与 `rawSettingsContainsKey()` 再证明：retention governance 还要负责用户意图诚实

`src/utils/settings/validationTips.ts:48-54`
已经把 `cleanupPeriodDays` 的用户语法写得很明确：

1. 值必须 `0 或更大`
2. 正数表示保留天数
3. `0` 表示禁用 session persistence entirely：不写新 transcript，且 startup 文案宣称删除旧 transcript

但更强的边界来自：

`src/utils/settings/settings.ts:871-875,984-1004`

与

`src/utils/cleanup.ts:575-584`

这里 repo 明确展示：

1. 系统会先检测用户是否在 raw settings 里显式写过 `cleanupPeriodDays`
2. 如果 settings validation 当前有错，而用户又显式写过这个 key
3. cleanup 会直接跳过，而不是退回默认 30 天偷偷接管

这条链条在 stronger-request 层非常关键。

因为它说明 repo 对旧 stronger-request carriers 的态度不是：

`反正以后总得删，那就默认继续删`

而是：

`如果 retention intent 当前不可信，就宁可不删，也不要让默认 policy 越级接管`

这条 honesty veto 显然强于 erase operator。

## 6. `shouldSkipPersistence()` 再证明：future-write suppression 不是 past-carrier cleanup

`src/utils/sessionStorage.ts:954-969`
说明：

1. `cleanupPeriodDays===0` 会进入 shared guard
2. 这条 guard 同时保护 `appendEntry` 与 `materializeSessionFile`
3. 它的目标是 suppress all transcript writes

这是一条重要正控制面，
因为它至少证明：

`from now on, do not write new transcript carriers`

但也正因为它只做到这里，
所以它反而把另一条边界逼得更清楚：

`future-write suppression truth`

不等于

`past stronger-request carriers have already been cleaned`

## 7. `backgroundHousekeeping` 再证明：retention governor 还要决定 cleanup 何时被 admitted

`src/utils/backgroundHousekeeping.ts:43-80`
很值钱。

这里 repo 把 generic cleanup 明确放进：

1. `10 minutes after start`
2. recent activity gating
3. `needsCleanup` one-shot admission

这说明 stronger-request old echo carriers 即便已经属于某条 cleanup horizon，
repo 仍在继续追问：

`现在是不是一个合适的 cleanup moment`

也就是说，
retention governance 当前不只是：

`define cutoff`

还包括：

`admit or defer runtime execution`

这正是 stronger-request erasure 自己并不回答的问题。

## 8. `cleanup.ts` 再证明：repo 已经有 visible cleanup stack，但还没有 family-wide receipt

`src/utils/cleanup.ts:23-40`
先把 `getCutoffDate()` 写成所有 executor 共享的时间阈值。

接着：

- `93-131` 清 message / error / MCP logs
- `155-190` 清 session `.jsonl/.cast`
- `300-303` 清 plans
- `305-428` 清 file-history backups、session-env 与 debug logs
- `575-596` 用 background dispatcher 把这些 executor 串起来，并继续清 image caches、pastes 与 stale worktrees

这足以说明：

`能承载 stronger-request old echo 的多类本地 carrier 当前已经处在 visible retention stack 里`

但同一个文件又展示出另一条重要边界：

虽然定义了
`CleanupResult = { messages, errors }`，
`cleanupOldMessageFilesInBackground()` 自己只返回 `Promise<void>`，
也没有把局部结果聚合成 surfaced family-wide receipt。

这说明 repo 当前的状态不是：

`没有 cleanup outcome vocabulary`

而是：

`已经有 local outcome vocabulary，但还没有把 stronger-request retention execution 正式签成统一 receipt`

## 9. `diagLogs.ts` 最后说明：coverage gap 本身就是 retention governance 问题

`src/utils/diagLogs.ts:27-53`
只告诉我们：

1. diagnostics entry 会被 append 到一个 logfile
2. 路径来自 `CLAUDE_CODE_DIAGNOSTICS_FILE`
3. repo-local code 当前公开展示的是 writer，而不是同层 retention owner

就当前 repo 内部可见代码而言，
这条 stronger-request diagnostics carrier 已经至少说明：

`there exists a writer`

却还没有同层说明：

`there exists a repo-local retention owner`

这不是一个小缺口，
而是 retention governance 本身的一部分。

因为 coverage boundary 不清楚，
就无法诚实地说：

`this retention law already governs all stronger-request carriers`

## 10. 从技术先进性看：成熟安全系统为什么要把“能删”与“该删”拆开

这组源码给出的设计启示至少有六条：

1. delete path does not define time law
2. explicit user intent can outrank defaults
3. future-write suppression should not impersonate past cleanup
4. scheduler admission is part of governance, not a side detail
5. coverage boundary itself must be named honestly
6. local cleanup counters are weaker than surfaced family-wide receipts

它的哲学本质是：

`成熟安全系统不仅关心你能不能删，还关心你凭什么现在就删。`

## 11. 一条硬结论

这组源码真正说明的不是：

`只要 stronger-request old echo carrier 已经能被 delete / truncate / aged-out，retention governance 也就已经自动成立。`

而是：

repo 已经在 `cleanupPeriodDays` declaration、validation veto、future-write suppression、housekeeping admission、visible cleanup stack 与 diagnostics coverage gap 上，清楚展示了 stronger-request retention governance 的独立存在；因此 `artifact-family cleanup stronger-request irreversible-erasure-governor signer` 仍不能越级冒充 `artifact-family cleanup stronger-request retention-governor signer`。
