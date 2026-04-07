# cleanupPeriodDays、housekeeping、plansDirectory、diagLogs与CleanupResult的强请求清理运行时符合性缺口

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `289` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup metadata 有没有存在，`

而是：

`谁能证明这些 metadata 在当前 runtime 中真的已经被兑现。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`metadata 不等于 runtime-conformance。`

这句话还不够硬。
所以这里单开一篇，
只盯住：

- `src/utils/settings/types.ts`
- `src/utils/settings/validationTips.ts`
- `src/utils/sessionStorage.ts`
- `src/utils/backgroundHousekeeping.ts`
- `src/utils/cleanup.ts`
- `src/utils/plans.ts`
- `src/utils/permissions/filesystem.ts`
- `src/screens/REPL.tsx`
- `src/main.tsx`
- `src/utils/diagLogs.ts`

把 stronger-request cleanup 的 declaration truth、admission truth、execution truth、skip truth、propagation truth、coverage truth 与 receipt truth 单独钉死。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 没有 stronger-request cleanup metadata。`

而是：

`Claude Code 已经有 stronger-request cleanup metadata，但 runtime-conformance 仍然是另一层：它取决于 suppress 是否已发生、cleanup 是否被调度、调度是否被后延、执行是否被 skip、plans metadata 是否真的被 executor 消费、diagnostics carrier 是否被纳入 cleanup coverage，以及结果是否被正式 surfaced。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| strong metadata language | `src/utils/settings/types.ts:325-333`; `src/utils/settings/validationTips.ts:46-53` | 为什么 metadata plane 给出了比 runtime 更强的 startup delete 语义 |
| immediate suppression | `src/utils/sessionStorage.ts:954-969` | 为什么 runtime 最先证明的是 transcript write suppression |
| delayed admission | `src/screens/REPL.tsx:3899-3906`; `src/main.tsx:2811-2818`; `src/utils/backgroundHousekeeping.ts:28-58,77-80` | 为什么 cleanup 进入 runtime 的方式本身就是延迟、可重排的 |
| intentional skip | `src/utils/cleanup.ts:575-584` | 为什么 runtime 会为了 fail-safe 原则而直接不执行 cleanup |
| propagation failure | `src/utils/plans.ts:79-106,164-233`; `src/utils/settings/types.ts:824-830`; `src/utils/permissions/filesystem.ts:245-255,1487-1494,1644-1652`; `src/utils/cleanup.ts:300-303` | 为什么 metadata 即使存在，也不自动保证 executor 跟随 |
| missing global receipt | `src/utils/cleanup.ts:33-44,575-597` | 为什么 `CleanupResult` 存在，却没有升格成 stronger-request conformance surface |
| uncovered diagnostics carrier | `src/utils/diagLogs.ts:11-20,27-60`; `src/utils/cleanup.ts:575-595` | 为什么某些 retained carrier 甚至还没有进入 visible cleanup coverage |

## 4. `cleanupPeriodDays=0` 先证明：一条很强的 metadata 句子，在 runtime 里至少要拆成 declaration、suppression 与 deletion 三层

`settings/types.ts` 与 `settings/validationTips.ts` 都把 `cleanupPeriodDays=0` 说得很强：

1. no transcripts are written
2. existing transcripts are deleted
3. at startup

但 `sessionStorage.ts` 的 `shouldSkipPersistence()` 立刻证明的只有：

`future transcript writes are suppressed`

这说明 stronger-request cleanup metadata 在 runtime 中至少会被拆成三层：

1. declaration truth
2. suppression truth
3. deletion truth

如果后两层没有单独被证明，
那么 metadata 再强，
也还不是 conformance receipt。

## 5. `REPL.tsx`、`main.tsx` 与 `backgroundHousekeeping.ts` 再证明：所谓 startup delete，在 runtime 中更像“安装一个延迟 cleanup 路径”

`REPL.tsx`
只在 `submitCount === 1` 后启动 housekeeping。

`main.tsx`
也只是后台导入 housekeeping，而不是同步给出 delete receipt。

`backgroundHousekeeping.ts`
则把时间结构写得更硬：

1. 初次运行延迟 10 分钟
2. 最近一分钟用户有交互就继续后延
3. 只有 `needsCleanup` 仍为真时才真正跑 cleanup

所以 stronger-request cleanup 的 runtime truth 更接近：

`startup admits a deferred cleanup path`

而不是：

`startup has already produced a delete receipt`

这不是简单的语义落差，
而是 admission truth 与 declaration truth 的明确分层。

## 6. `cleanup.ts` 的 validation guard 再证明：runtime 有时会为了更高阶安全而故意不符合纸面 metadata

`cleanup.ts:575-584`
明确写着：

1. settings 有 validation errors
2. 且用户显式设置了 `cleanupPeriodDays`
3. 那就 skip cleanup entirely

这里非常关键，
因为它说明 runtime-conformance 不是机械层。

它还要服从：

`anti-accidental-deletion fail-safe principle`

所以 stronger-request cleanup runtime truth 至少还要区分：

1. executed
2. delayed
3. skipped for safer semantics

也就是说，
这里真正被迫浮出水面的不是 bug，
而是：

`为什么“不执行”有时反而更忠于更高阶安全。`

## 7. plans family 继续说明：metadata 被部分消费，不等于 runtime executor 已 conform

`plansDirectory`
已经被：

1. settings plane 承认
2. storage plane 消费
3. permission plane 跟随
4. resume plane 复用

但 `cleanupOldPlanFiles()`
仍只清默认 `~/.claude/plans`。

这说明 stronger-request cleanup runtime-conformance 当前至少还存在：

`propagation gap`

也就是：

`metadata-consumed in some planes != executor-conformed in another plane`

从技术角度看，
这正是 runtime-conformance 比 metadata 更强的地方：

`它要求系统不只记得规则，还要真的在所有关键平面里按规则行动。`

## 8. `CleanupResult`、stale-worktree telemetry 与 diagnostics uncovered gap 最后说明：repo 已有局部 outcome 词汇，但还没有 stronger-request family 级 receipt

`cleanup.ts:33-44`
定义了 `CleanupResult`。

这说明作者已经知道：

`cleanup outcome is worth counting`

但 `cleanupOldMessageFilesInBackground()`
并没有把这些 stronger-request family 结果汇总、保存或投影；
反而只有 stale worktrees 获得了单独 telemetry。

与此同时，
`diagLogs.ts`
仍只定义 diagnostics writer 与 env-selected logfile，
没有进入 visible cleanup dispatcher coverage。

这说明当前 repo 的状态不是：

`不会描述 outcome`

而是：

`只会局部描述 outcome，还不会把 stronger-request family outcome 签成统一 conformance receipt；甚至某些 carrier 仍停留在 uncovered world。`

## 9. 从技术角度看这组代码给出的启示

如果把这组机制抽成技术启示，
至少有六条：

1. 成熟安全系统不会把 declaration truth 当作 runtime truth，而会把 admission、execution、skip 与 receipt 单独拆开
2. suppression、deletion、delay 与 receipt 是四个不同问题，任何强文案都不该把它们压成一句
3. propagation gap 是 runtime-conformance 的硬证据，因为它直接暴露出“规则被记住”与“规则被执行”之间的断层
4. local outcome vocabulary 的存在说明系统已经意识到自己需要 receipt，只是还没把 receipt 升格成 family-wide plane
5. uncovered diagnostics carrier 进一步证明 runtime-conformance 不只看执行对不对，还看 coverage 有没有被诚实声明
6. validation-driven intentional skip 说明更成熟的安全系统不会把“照文案执行”置于“避免误删”之上

## 10. 苏格拉底式自反诘问：我是不是又把“规则写好了”误当成了“规则已经兑现”

如果对这组代码做更严格的自我审查，
至少要追问五句：

1. 如果 `cleanupPeriodDays=0` 已经写得这么强，为什么我还说 conform 不成立？
   因为 declaration truth 不自动等于 execution truth。
2. 如果 `shouldSkipPersistence()` 已经在运行，为什么还不够？
   因为 write suppression 只证明 future path，被 delete 的 old carrier 仍需单独 receipt。
3. 如果 housekeeping 最终会跑，为什么还说 runtime 有裂缝？
   因为 delay、reschedule 与 admission gate 意味着“会跑”不等于“此刻已经完成”。
4. 如果 validation-error 下 intentional skip 是更安全的，为什么这不算已经符合？
   因为这恰恰说明 metadata 与 runtime 之间还需要一层更强的行为解释与签收。
5. 如果 `CleanupResult` 已经存在，为什么还说没有 receipt？
   因为 local return value 不是 surfaced stronger-request family receipt。

这组反问最终逼出一句更稳的判断：

`runtime-conformance 的关键，不在系统有没有动作，而在系统能不能诚实证明动作已经在正确时机、正确平面、正确覆盖范围内发生。`

## 11. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup metadata 一旦存在，runtime conformance 就自动成立。`

而是：

`cleanupPeriodDays=0` 的强文案、`shouldSkipPersistence()` 的即时停写、housekeeping 的延迟 admission、validation guard 的 intentional skip、plans family 的 propagation gap、`CleanupResult` 未被升级成统一 receipt，以及 diagnostics 仍处 uncovered world，已经共同展示出 stronger-request cleanup runtime-conformance 的独立存在；因此 artifact-family cleanup stronger-request cleanup-metadata-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-runtime-conformance-governor signer。`

因此：

`cleanup 线真正缺的，不只是“谁来把规则写成 metadata”，还包括“谁来证明这些 metadata 当前已经被运行时诚实兑现、覆盖并签收”。`
