# cleanupPeriodDays、backgroundHousekeeping 与 CleanupResult 的运行时符合性缺口

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `161` 时，  
真正需要被单独钉住的已经不是：

`artifact-family policy 有没有被写进 settings 或 helper，`

而是：

`谁能证明这些 policy 在当前 runtime 里真的已经发生。`

如果这个问题只停在主线长文里，  
最容易被压成一句抽象判断：

`metadata 不等于 conformance。`

这句话仍然太抽象。  
所以这里单开一篇，只盯住：

- `src/utils/settings/types.ts`
- `src/utils/settings/validationTips.ts`
- `src/utils/sessionStorage.ts`
- `src/utils/backgroundHousekeeping.ts`
- `src/utils/cleanup.ts`
- `src/utils/plans.ts`
- `src/screens/REPL.tsx`
- `src/main.tsx`

把 `cleanupPeriodDays=0` 的强语义、housekeeping 的真实调度、validation skip、`plansDirectory` 的传播缺口，以及 `CleanupResult` 为何没有升格成正式回执，单独拆开。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 没有 cleanup policy。`

而是：

`Claude Code 已经有 policy signal，甚至有部分 metadata truth，但运行时符合性仍然是另一层：它取决于 suppress 是否已发生、cleanup 是否被调度、调度是否被延迟、执行是否被 skip，以及结果是否被正式保存。`

所以这一组文件真正暴露出的不是“有没有治理”，  
而是：

`治理为什么还没有被当前 runtime 诚实签收。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| startup delete metadata language | `src/utils/settings/types.ts:323-334`; `src/utils/settings/validationTips.ts:46-53` | 为什么 settings plane 给出了比 runtime 更强的 startup delete 语义 |
| immediate suppression | `src/utils/sessionStorage.ts:954-969` | 为什么 runtime 最先发生的是 transcript write suppression，而不是 delete receipt |
| delayed housekeeping | `src/utils/backgroundHousekeeping.ts:24-58`; `src/screens/REPL.tsx:3903-3906`; `src/main.tsx:2813-2818` | 为什么 cleanup 走的是延迟、可重排的 housekeeping 路线 |
| validation skip | `src/utils/cleanup.ts:575-584` | 为什么 runtime 会为了避免误删而故意不执行 cleanup |
| missing conformance receipt | `src/utils/cleanup.ts:33-44,575-595` | 为什么 `CleanupResult` 存在，却没有被提升成正式 family-by-family 回执 |
| plans propagation gap | `src/utils/plans.ts:79-110`; `src/utils/cleanup.ts:300-303` | 为什么 metadata 即使存在，也不自动保证 runtime executor 跟随 |

## 4. `cleanupPeriodDays=0` 先证明：同一句 policy signal，在 runtime 里至少会被拆成三层

`src/utils/settings/types.ts:323-334` 与 `src/utils/settings/validationTips.ts:46-53` 都把 `cleanupPeriodDays=0` 说得很强：

1. no transcripts are written
2. existing transcripts are deleted
3. at startup

但 `src/utils/sessionStorage.ts:954-969` 的 `shouldSkipPersistence()` 实际立刻保证的只有：

`no transcripts are written`

也就是：

`future-write suppression`

这说明同一句 policy signal 在 runtime 里至少已经被拆成三层：

1. declaration
2. write suppression
3. delete execution

如果后两层没有单独证明，  
那么 metadata 再清楚，也还不是 conformance receipt。

## 5. `backgroundHousekeeping` 再证明：所谓 startup，在 runtime 里其实是“进入一个延迟且可重排的 housekeeping 世界”

`src/screens/REPL.tsx:3903-3906` 说明：

1. 只有 `submitCount === 1`
2. 才会 `startBackgroundHousekeeping()`

这已经说明 interactive world 下的 cleanup 不是一进程启动就立刻发生。

`src/main.tsx:2813-2818` 对 headless world 也只是后台导入并启动 housekeeping。

`src/utils/backgroundHousekeeping.ts:24-58` 则把时间结构彻底钉死：

1. 初次运行延迟 10 分钟
2. 若最近一分钟用户有交互，则再次后延
3. 第一次真正执行 cleanup 只发生在 `needsCleanup` 仍为真时

所以所谓：

`deleted at startup`

在 runtime 里更准确地说是：

`startup installs a deferred cleanup path`

而不是：

`startup has already produced a delete receipt`

## 6. validation skip 说明：运行时有时会故意不符合纸面 policy，以守住更高阶的 fail-safe 原则

`src/utils/cleanup.ts:575-584` 明确写着：

1. 如果 settings 有 validation errors
2. 且用户显式设置了 `cleanupPeriodDays`
3. runtime 会直接 `return`

原因也写得很清楚：

`skip cleanup entirely rather than falling back to the default (30 days)`

这条代码特别值钱，  
因为它说明：

`runtime-conformance` 不是一个机械层。`

它不是拿到 metadata 就无条件执行，  
而是还要服从更高阶的：

`anti-accidental-deletion safety principle`

这意味着，如果未来真的要做 conformance signer，  
它绝不能只是一个“是否按文案做了”的布尔位，  
而必须能说清：

1. executed
2. skipped
3. skipped for which stronger safety reason

## 7. `CleanupResult` 再证明：当前 repo 甚至已经有了局部 conformance vocabulary，却没有把它正式挂到控制面上

`src/utils/cleanup.ts:33-44` 已经定义了：

`CleanupResult = { messages, errors }`

而且很多 cleanup 函数都返回这个类型。

这说明作者已经意识到：

`cleanup outcome is something worth counting`

但 `src/utils/cleanup.ts:575-595` 的后台入口并没有：

1. 汇总各 family 的 `CleanupResult`
2. 把它们保存成一个统一 conformance object
3. 返回给上层
4. 对外宣告某个 family 当前已 conform

反而只有 stale worktrees 被单独做了 telemetry。

这说明当前 repo 在 conformance 这一层的真实状态是：

`局部可数，但全局未签收。`

## 8. plans family 进一步证明：就算 metadata 已存在，runtime 也仍可能在某一执行面上不符合

`src/utils/plans.ts:79-110` 会消费 `plansDirectory`，  
`src/utils/cleanup.ts:300-303` 却仍只清默认：

`~/.claude/plans`

这条证据和 `cleanupPeriodDays=0` 的时间差不同。  
它暴露的不是：

`metadata 与 runtime 之间有调度延迟`

而是：

`metadata 已被某些平面消费，但另一些 runtime executor 根本没跟上`

所以 `161` 里真正值得被单独钉住的不是单一 delay，  
而是两类完全不同的 conformance gap：

1. temporal gap  
   `policy declared now, execution happens later or maybe never`
2. propagation gap  
   `policy consumed in one plane, ignored in another`

## 9. 这篇源码剖面给主线带来的四条技术启示

### 启示一

声明、调度、执行与回执必须继续拆层。  
否则“deleted at startup”这类强句子会同时冒充四种 truth。

### 启示二

fail-safe skip 不是反例，而是更高阶 runtime semantics。  
conformance signer 必须能解释“为什么这次没执行反而更安全”。

### 启示三

只要 `CleanupResult` 还没有被汇总成 family-by-family receipt，  
当前 repo 就仍缺正式的 runtime conformance surface。

### 启示四

plans family 说明：metadata 补出来之后，仍必须继续补 propagation proof。  
否则 descriptor 再漂亮，也仍然只是部分平面消费的纸面制度。

## 10. 一条硬结论

这组源码真正说明的不是：

`Claude Code 只要拥有 artifact-family metadata，就已经自动完成 runtime conformance。`

而是：

`Claude Code 当前的 runtime 已经明确展示出 temporal gap、propagation gap 与 receipt gap；因此 metadata signer 仍不能越级冒充 runtime-conformance signer。`

因此：

`运行时符合性不是 metadata 的附属说明，而是另一张必须被正式签发的控制面回执。`
