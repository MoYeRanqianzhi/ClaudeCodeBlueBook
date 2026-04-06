# cleanup、backgroundHousekeeping、settings与diagLogs-env选路的强请求保留期治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `187` 时，
真正需要被单独钉住的已经不是：

`谁能删掉某个 stronger-request old echo carrier，`

而是：

`谁来定义这类 stronger-request old echo carriers 本来该保留多久、validation 出错时谁有权停手、何时允许真正执行 cleanup，以及当前哪些 carrier actually 被纳入这条 retention 栈。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`stronger-request irreversible-erasure governor 不等于 stronger-request retention-governor。`

这句话还不够硬。
所以这里单开一篇，只盯住：

- `src/utils/settings/types.ts`
- `src/utils/settings/validationTips.ts`
- `src/utils/settings/settings.ts`
- `src/utils/backgroundHousekeeping.ts`
- `src/utils/cleanup.ts`
- `src/utils/diagLogs.ts`

把 retention declaration、intent honesty、runtime scheduling、covered carriers 与 uncovered carrier gap 并排，
逼出一句更硬的结论：

`Claude Code 已经明确展示：删除 stronger-request carrier 只解决 destruction event；只要 retention horizon、runtime admission 与 carrier coverage 仍由更高层 policy 栈控制，这条 stronger-request old echo 就还活在 retention-governance 问题里。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 能按 cutoff 删除一些能承载 stronger-request old echo 的文件。`

而是：

`Claude Code 明确把 stronger-request carrier retention 拆成 declaration、validation-honesty、scheduler、executor coverage 与 uncovered-carrier gap 五层。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| retention declaration | `src/utils/settings/types.ts:325-332` | 谁先定义 `cleanupPeriodDays` 及其默认/零值语义 |
| user-facing retention grammar | `src/utils/settings/validationTips.ts:48-54` | 产品语言怎样向用户解释 retention law |
| intent honesty guard | `src/utils/settings/settings.ts:871-875,984-1000`; `src/utils/cleanup.ts:575-584` | validation 出错时谁有权阻止默认 retention 接管 |
| runtime admission / delay | `src/utils/backgroundHousekeeping.ts:43-60,77-80` | cleanup 何时真正被允许运行 |
| covered retention execution | `src/utils/cleanup.ts:25-30,396-428,575-593` | 哪些 visible carriers 当前已经纳入 cleanup horizon |
| uncovered diagnostics gap | `src/utils/diagLogs.ts:27-60` | 为什么 diagnostics carrier 当前只显露 writer / env getter，而未显露同层 retention path |

## 4. `cleanupPeriodDays` 先写 stronger-request carrier 的时间法律，而不是让 delete operator 先说话

`src/utils/settings/types.ts:325-332` 很硬。

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

`validationTips.ts:48-54` 已经把 `cleanupPeriodDays` 的用户语法写得很明确：

1. 值必须 `0 或更大`
2. 正数表示保留天数
3. `0` 表示禁用 session persistence

但更强的边界来自：

`settings.ts:871-875,984-1000` 与 `cleanup.ts:575-584`

这里 repo 明确展示：

1. 系统会先检测用户是否在 raw settings 里显式写过 `cleanupPeriodDays`
2. 如果 settings validation 当前有错，而用户又显式写过这个 key
3. cleanup 会直接跳过，而不是退回默认 30 天偷偷接管

这条链条在 stronger-request 层非常关键。

因为它说明 repo 对旧 stronger-request carriers 的态度不是：

`反正以后总得删，那就默认继续删`

而是：

`如果 retention intent 当前不可信，就宁可不删，也不要让默认 policy 越级接管`

这条 honesty guard 显然强于 erase operator。

erase operator 只回答：

`I can delete`

retention governor 还回答：

`am I legitimately allowed to delete under the intended law?`

## 6. `backgroundHousekeeping` 再证明：retention governor 还要决定执行时机

`src/utils/backgroundHousekeeping.ts:43-60,77-80` 很值钱。

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

## 7. debug 是当前最硬的 covered carrier，diagnostics 是当前最硬的 uncovered gap

`src/utils/cleanup.ts:25-30,396-428,575-593` 给出了很硬的正控制面。

这里我们能清楚看到：

1. `cleanupPeriodDays` -> `getCutoffDate()`
2. `cleanupOldDebugLogs()` -> 删除旧 `.txt`
3. `cleanupOldMessageFilesInBackground()` -> 把 debug cleanup 纳入 generic background stack

这足以说明：

`能承载 stronger-request old echo 的 debug file 当前已经处在可见 retention stack 里`

但 diagnostics 不同。

`src/utils/diagLogs.ts:27-60` 只展示了：

1. 有一个 writer
2. writer 目标来自 `CLAUDE_CODE_DIAGNOSTICS_FILE`

在当前 repo 内部可见代码里，
我们没有看到与它对称的：

`repo-local diagnostics retention path`

这条负控制面极其关键。

因为它说明 stronger-request retention governance 当前至少还包含一个独立问题：

`which carriers are actually covered by the visible retention stack`

所以 `187` 的真正技术启示不是“retention horizon 已经统一”，
而是：

`retention governance is partially explicit and partially coverage-limited`

## 8. 为什么这一层不等于 `186` 的 irreversible-erasure gate

这里必须单独讲清楚，
否则最容易把 `187` 误读成 `186` 的尾注。

`186` 问的是：

`即便 old echo 已经离开 current audit surface，那些具体 carriers 是否已经被 destroy。`

`187` 问的是：

`即便某些具体 carriers 已经能被 destroy，谁来决定它们本来该保留多久、什么时候允许执行 cleanup、以及当前哪些 carrier actually 被纳入这条时间法律。`

所以：

1. `186` 的典型形态是 `truncate`、`unlink(filePath)`、old debug log delete
2. `187` 的典型形态是 `cleanupPeriodDays`、validation skip、delay/activity gate、carrier coverage gap

前者 guarding destruction event，
后者 guarding temporal legitimacy。

两者都很重要，
但不是同一个 signer。

## 9. 这篇源码剖面给主线带来的四条技术启示

### 启示一

repo 已经明确展示：

`retention grammar is declared before deletion happens`

### 启示二

repo 已经明确展示：

`validation honesty can veto cleanup even when deletion code exists`

### 启示三

repo 已经明确展示：

`runtime admission is part of retention governance, not a mere performance optimization`

### 启示四

repo 已经明确展示：

`carrier coverage itself is a governance question; debug is covered, diagnostics is only partially exposed`

这四句合起来，
正好说明为什么 cleanup 线未来不能把 stronger-request irreversible erasure 直接偷写成 stronger-request retention governance。

## 10. 一条硬结论

这组源码真正说明的不是：

`只要某些 stronger-request carriers 已经会被删掉，cleanup 线就已经知道 retention governance 是什么。`

而是：

`repo 已经在 cleanupPeriodDays declaration、raw-intent honesty guard、backgroundHousekeeping scheduling、debug carrier coverage 与 diagnostics env-selected coverage gap 上，清楚展示了 stronger-request retention governance 的独立存在；因此 artifact-family cleanup stronger-request irreversible-erasure-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request retention-governor signer。`

因此：

`cleanup 线真正缺的，不只是“谁来删 stronger-request old echo carrier”，还包括“谁来定义它们的 retention horizon、谁来决定现在是否允许 cleanup、以及谁来诚实说明当前哪些 carrier actually 已被纳入这条治理栈”。`
