# cleanupPeriodDays、housekeeping、plansDirectory与CleanupResult的强请求运行时符合性缺口

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `193` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup metadata 有没有存在，`

而是：

`谁能证明这些 metadata 在当前 runtime 中真的已经被兑现。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`metadata 不等于 runtime-conformance。`

这句话还不够硬。
所以这里单开一篇，只盯住：

- `src/utils/settings/types.ts`
- `src/utils/settings/validationTips.ts`
- `src/utils/sessionStorage.ts`
- `src/utils/backgroundHousekeeping.ts`
- `src/utils/cleanup.ts`
- `src/utils/plans.ts`
- `src/screens/REPL.tsx`
- `src/main.tsx`

把 stronger-request cleanup 的 declaration truth、admission truth、execution truth、skip truth 与 receipt truth 单独钉死。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 没有 stronger-request cleanup metadata。`

而是：

`Claude Code 已经有 stronger-request cleanup metadata，但 runtime-conformance 仍然是另一层：它取决于 suppress 是否已发生、cleanup 是否被调度、调度是否被后延、执行是否被 skip，以及结果是否被正式 surfaced。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| strong metadata language | `src/utils/settings/types.ts:325-333`; `src/utils/settings/validationTips.ts:46-53` | 为什么 metadata plane 给出了比 runtime 更强的 startup delete 语义 |
| immediate suppression | `src/utils/sessionStorage.ts:954-969` | 为什么 runtime 最先证明的是 transcript write suppression |
| delayed admission | `src/screens/REPL.tsx:3903-3906`; `src/main.tsx:2813-2818`; `src/utils/backgroundHousekeeping.ts:24-58` | 为什么 cleanup 进入 runtime 的方式本身就是延迟、可重排的 |
| intentional skip | `src/utils/cleanup.ts:575-584` | 为什么 runtime 会为了 fail-safe 原则而直接不执行 cleanup |
| propagation failure | `src/utils/plans.ts:79-106`; `src/utils/cleanup.ts:300-303` | 为什么 metadata 即使存在，也不自动保证 executor 跟随 |
| missing global receipt | `src/utils/cleanup.ts:33-44,575-595` | 为什么 `CleanupResult` 存在，却没有升格成 stronger-request conformance surface |

## 4. `cleanupPeriodDays=0` 先证明：一条很强的 metadata 句子，在 runtime 里至少要拆成 declaration、suppression 与 deletion 三层

`settings/types.ts:325-333` 与 `validationTips.ts:46-53` 都把 `cleanupPeriodDays=0` 说得很强：

1. no transcripts are written
2. existing transcripts are deleted
3. at startup

但 `sessionStorage.ts:954-969` 的 `shouldSkipPersistence()` 立刻证明的只有：

`future transcript writes are suppressed`

这说明 stronger-request cleanup metadata 在 runtime 中至少会被拆成三层：

1. declaration truth
2. suppression truth
3. deletion truth

如果后两层没有单独被证明，
那么 metadata 再强，也还不是 conformance receipt。

## 5. `backgroundHousekeeping` 再证明：所谓 startup delete，在 runtime 中更像“安装一个延迟 cleanup 路径”

`REPL.tsx:3903-3906` 只在 `submitCount === 1` 后启动 housekeeping。

`main.tsx:2813-2818` 则在非 bare headless world 中后台导入 housekeeping。

`backgroundHousekeeping.ts:24-58` 更进一步把时间结构钉死：

1. 初次运行延迟 10 分钟
2. 最近一分钟用户有交互就继续后延
3. 只有 `needsCleanup` 仍为真时才真正跑 cleanup

所以 stronger-request cleanup 的 runtime truth 更接近：

`startup admits a deferred cleanup path`

而不是：

`startup has already produced a delete receipt`

## 6. `cleanup.ts` 的 validation guard 再说明：runtime 有时会为了更高阶安全而故意不符合纸面 metadata

`cleanup.ts:575-584` 明确写着：

1. settings 有 validation errors
2. 且用户显式设置了 `cleanupPeriodDays`
3. 那就 skip cleanup entirely

这里非常关键，
因为它说明 runtime-conformance 不是一个机械层。

它还要服从：

`anti-accidental-deletion fail-safe principle`

所以 stronger-request cleanup runtime truth 至少还要区分：

1. executed
2. delayed
3. skipped for safer semantics

## 7. plans family 继续说明：metadata 被部分消费，不等于 runtime executor 已 conform

`plansDirectory` 已经被：

1. settings plane 承认
2. storage plane 消费
3. permission plane 跟随

但 `cleanupOldPlanFiles()` 仍只清默认 home-root plans dir。

这说明 stronger-request cleanup runtime-conformance 当前至少还存在：

`propagation gap`

也就是：

`metadata-consumed in one plane != executor-conformed in another plane`

## 8. `CleanupResult` 与 stale worktree telemetry 最后说明：repo 已经拥有局部 outcome vocabulary，却还没有 stronger-request family 级 conformance receipt

`cleanup.ts:33-44` 定义了 `CleanupResult`。

这说明作者知道 cleanup outcome 值得计数。

但 `cleanup.ts:575-595` 的后台入口没有把这些 result 汇总、保存或投影；
反而只有 stale worktrees 获得了单独 telemetry。

这说明当前 repo 的状态不是：

`不会描述 outcome`

而是：

`只会局部描述 outcome，还不会把 stronger-request family outcome 签成统一 conformance receipt`

## 9. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup metadata 一旦存在，runtime conformance 就自动成立。`

而是：

`cleanupPeriodDays=0` 的强文案、`shouldSkipPersistence()` 的即时停写、housekeeping 的延迟 admission、validation guard 的 intentional skip、plans family 的 propagation gap，以及 `CleanupResult` 未被升级成统一 receipt，已经共同展示出 stronger-request cleanup runtime-conformance 的独立存在；因此 artifact-family cleanup stronger-request cleanup-metadata-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-runtime-conformance-governor signer。`

因此：

`cleanup 线真正缺的，不只是“谁来把规则写成 metadata”，还包括“谁来证明这些 metadata 当前已经被运行时诚实兑现并签收”。`
