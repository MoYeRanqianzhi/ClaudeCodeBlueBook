# cleanupPeriodDays、validation veto、housekeeping admission与diagnostics coverage中的强请求清理保留期治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `410` 时，
真正需要被单独钉住的已经不是：

`谁能删掉某个 stronger-request old echo carrier，`

而是：

`谁来定义这类 stronger-request old echo carriers 本来该保留多久、validation 出错时谁有权停手、何时允许真正执行 cleanup、从现在起哪些 future writes 应被立即压住，以及当前哪些 carriers actually 被纳入这条 retention law。`

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
| future-write suppression | `src/utils/sessionStorage.ts:954-970` | 为什么 `cleanupPeriodDays=0` 先证明的是 transcript writes suppression |
| runtime admission / delay | `src/utils/backgroundHousekeeping.ts:43-80` | cleanup 何时真正被允许运行 |
| covered retention execution | `src/utils/cleanup.ts:23-40,93-131,155-190,300-303,305-428,575-598` | 哪些 visible carriers 当前已经纳入 cleanup horizon，以及结果如何只停留在 local vocabulary |
| uncovered diagnostics gap | `src/utils/diagLogs.ts:27-60` | 为什么 diagnostics carrier 当前只显露 writer / env getter，而未显露同层 retention owner |

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

`src/utils/sessionStorage.ts:954-970`
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

这正是 retention governance 比单一 erasure 机制更强的地方：

它要求系统把“以后不再写”与“以前写过的东西何时合法清掉”分别回答。

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

`src/utils/cleanup.ts:23-30`
先把 `getCutoffDate()` 写成所有 executor 共享的时间阈值。

接着：

- `93-131` 清 message / error / MCP logs
- `155-190` 清 session `.jsonl/.cast`
- `300-303` 清 plans
- `305-348` 清 file-history backups
- `350-428` 清 session-env 与 debug logs
- `575-598` 用 background dispatcher 把这些 executor 串起来，并继续清 image caches、pastes 与 stale worktrees

这足以说明：

`能承载 stronger-request old echo 的多类本地 carrier 当前已经处在 visible retention stack 里`

但同一个文件又展示出另一条重要边界：

`src/utils/cleanup.ts:33-40`

虽然定义了
`CleanupResult = { messages, errors }`，
但 `cleanupOldMessageFilesInBackground()` 自己只返回 `Promise<void>`，
也没有把局部结果聚合成 surfaced family-wide receipt。

这说明 repo 当前的状态不是：

`没有 cleanup outcome vocabulary`

而是：

`已经有 local outcome vocabulary，但还没有把 stronger-request retention execution 正式签成统一 receipt`

## 9. `diagLogs.ts` 最后说明：coverage gap 本身就是 retention governance 问题

`src/utils/diagLogs.ts:27-60`
只告诉我们：

1. diagnostics entry 会被 append 到一个 logfile
2. 路径来自 `CLAUDE_CODE_DIAGNOSTICS_FILE`
3. repo-local code 当前公开展示的是 writer，而不是同层 retention owner

就当前 repo 内部可见代码而言，
我们还看不到与之同层的：

`declared diagnostics retention horizon`

或

`visible diagnostics cleanup dispatcher`

这条 gap 极其关键。

因为它说明 stronger-request retention governance 当前不仅要回答：

`delete path 有没有`

还要回答：

`哪些 carrier actually 在 visible retention law 里`

所以这篇源码剖面最重要的负结论不是：

`diagnostics 永久不清`

而是：

`repo-local stronger-request retention stack 对 diagnostics 的 owner / admission / receipt 当前并未在同层显露。`

## 10. 为什么这一层不等于 `260` 的 irreversible-erasure gate

这里必须单独讲清楚，
否则最容易把 `261` 误读成 `260` 的尾注。

`260` 问的是：

`即便 old echo 已经离开 current audit surface，那些具体 carriers 是否已经被 destroy。`

`261` 问的是：

`即便某些具体 carriers 已经能被 destroy，谁来决定它们本来该保留多久、validation 出错时谁有权停手、什么时候允许执行 cleanup、future writes 是否应立刻被 suppress、以及当前哪些 carriers actually 被纳入这条时间法律。`

所以：

1. `260` 的典型形态是 debug logfile materialization、generic retention delete、transcript truncate、workspace unlink
2. `261` 的典型形态是 time law declaration、validation veto、future suppression、runtime admission、covered-vs-uncovered carrier governance

前者 guarding carrier destruction，
后者 guarding temporal legitimacy。

两者都很重要，
但不是同一个 signer。

## 11. 一条硬结论

这组源码真正说明的不是：

`只要 old stronger-request carrier 已经能被 delete / truncate / aged-out，stronger-request cleanup 线就已经知道它本来该保留多久。`

而是：

`Claude Code 已经在 settings/types.ts 的 retention declaration、validationTips.ts 的 public retention grammar、settings.ts / cleanup.ts 的 intent honesty veto、sessionStorage.ts 的 future-write suppression、backgroundHousekeeping.ts 的 runtime admission、cleanup.ts 的 visible executor stack 与 diagLogs.ts 的 uncovered diagnostics gap 上，清楚展示了 stronger-request retention governance 的独立存在；因此 artifact-family cleanup stronger-request irreversible-erasure-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request retention-governor signer。`
