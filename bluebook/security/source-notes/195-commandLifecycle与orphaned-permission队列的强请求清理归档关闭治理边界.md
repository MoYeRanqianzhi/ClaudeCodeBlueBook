# commandLifecycle 与 orphaned-permission 队列的强请求清理归档关闭治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `344` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 线未来谁来决定 old echo 是否 no-more-duty，`

而是：

`stronger-request cleanup 线如果未来已经宣布 no-more-duty，谁来决定这条 old echo 什么时候已经从 active lifecycle / waiting / queue / observability 表面正式关闭。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`liability-release governor 不等于 archive-close governor。`

这句话还不够硬。
所以这里单开一篇，
只盯住：

- `src/cli/structuredIO.ts`
- `src/cli/print.ts`
- `src/utils/commandLifecycle.ts`

把 lifecycle `completed`、stale prompt cancellation、`orphaned-permission` queue non-admission 与 inline completed observability 并排，
逼出一句更硬的结论：

`Claude Code 已经在 old echo world 里明确展示：no-more-duty 只是责任判断；真正的 archive close 还要回答这条 echo 是否已经退出 active lifecycle、waiting surface、queue world 与 operator-facing observability surface。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 在一些地方会调用 completed。`

而是：

`Claude Code 明确把 old echo 的 no-more-duty judgment 与 active-surface closure 写成了不同动作：生命周期要单独关，旧等待面要单独撤，队列是否准入也要单独判断，operator-facing completed 还要按独立 contract 发布。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| lifecycle close on every `control_response` | `src/cli/structuredIO.ts:355-409` | 为什么 duplicates / orphans 即使已 no-more-duty 也要被正式 completed |
| lifecycle surface contract | `src/utils/commandLifecycle.ts:1-20` | 为什么 started / completed 本身是一条独立 active surface |
| stale prompt teardown | `src/cli/structuredIO.ts:400-409` | 为什么 stronger signer 还要主动撤掉旧 waiting prompt |
| orphan queue mode | `src/cli/print.ts:1936-1955` | 为什么 orphaned echo 是否进入 active queue 是单独问题 |
| compensate-or-refuse branch | `src/cli/print.ts:5241-5305` | 为什么 release 之后仍要继续回答 active re-entry surface 该怎么关 |
| inline completed observability | `src/cli/print.ts:2816-2824` | 为什么 operator-facing close 不是 release judgement 的附带物 |

## 4. `notifyCommandLifecycle(uuid, 'completed')` 先证明：archive-close 的第一层是 lifecycle close，不是语义比喻

`structuredIO.ts:355-409`
很硬。

源码逻辑非常直接：

1. 每个 `control_response` 都先拿 `uuid`
2. 然后调用
   `notifyCommandLifecycle(uuid, 'completed')`
3. 注释还明确写：
   `Close lifecycle for every control_response, including duplicates and orphans`

这条证据非常关键。

因为它说明 repo 不满足于：

`这条 old echo 已经 no-more-duty`

它还坚持：

`即便如此，这条 old echo 的 lifecycle surface 也必须被正式关账`

而
`commandLifecycle.ts:1-20`
又把这个 surface 明确抽成独立 listener contract。

这意味着 archive-close 在这里不是一个修辞，
而是：

`independent technical surface closure`

## 5. stale prompt cancellation 再证明：release 之后仍要单独撤掉旧 waiting surface

`structuredIO.ts:400-409`
很值钱。

当 `can_use_tool` resolved，
系统还要进一步：

`onControlRequestResolved(message.response.request_id)`

去 cancel claude.ai 侧 stale permission prompt。

这说明 no-more-duty judgment 之后，
repo 仍然认为自己还欠一件事：

`把旧等待表面正式撤场`

这显然不是 release judgment 自己会完成的事，
而是 archive-close 主权的一部分。

## 6. `orphaned-permission` queue 再证明：是否进入 active queue world 是 archive-close 的另一张票

`print.ts:1936-1955`
很硬。

源码明确把：

`orphaned-permission`

建成单独 queue mode，
并强调这类命令因为 carry side effects / orphanedPermission state，
必须 singly process。

这条线说明：

orphan echo 不只是“要不要补偿”的抽象对象，
它还是：

`是否被允许重新进入 active queue world`

的问题。

而
`handleOrphanedPermissionResponse()`
又给出对应分流：

1. still owe compensation -> enqueue
2. already handled / already resolved -> return false

这说明 archive-close 的关键不是“以后再也看不见”，
而是：

`不再 admission into active operational queue`

## 7. inline completed observability 再证明：operator-facing close 是独立 contract

`print.ts:2816-2824`
与
`commandLifecycle.ts:1-20`
合起来也很硬。

这里源码明确把：

1. non-user events are handled inline
2. started->completed in the same tick carries no information
3. therefore only fire `completed`

写成独立 observability discipline。

这条证据值钱的地方在于：

它说明：

`completed`

不是“差不多结束”的随手文案，
而是 current operator world 真的会接收的一条 surface signal。

既然如此，
就更不能把：

`我已不再欠旧 echo 责任`

偷写成：

`active surface 当然也会自动完成`

## 8. 为什么这层不等于 `194` 的 liability-release gate

这里必须单独讲清楚，
否则容易把 `195` 误读成 `194` 的尾注。

`194` 问的是：

`old echo 什么时候已经 no-more-duty。`

`195` 问的是：

`即便 no-more-duty 已成立，这条 old echo 什么时候已经正式退出 active lifecycle / waiting / queue / observability 表面。`

所以：

1. `194` 的典型形态是 duplicate ignore、unknown-response no-op、transcript-resolved amnesty、compensate-or-refuse
2. `195` 的典型形态是 lifecycle completed、stale prompt teardown、queue non-admission、inline completed contract

前者 guarding obligation closure，
后者 guarding active-surface closure。

两者都很重要，
但不是同一个 signer。

## 9. 从技术先进性看：Claude Code 不只把“责任关闭”做成伦理语法，还把“表面关闭”做成拓扑语法

从技术角度看，
Claude Code 在这里最先进的地方，
不是它“在一些地方会调 completed”，
而是它明确拒绝把：

`duty closed`

偷写成：

`surface closed`

这套设计至少体现了六个成熟点：

1. lifecycle close is a first-class control plane
2. waiting teardown is explicitly triggered, not left to passive decay
3. queue non-admission is governed separately from release verdict
4. operator-facing close has its own observability contract
5. duplicates/orphans also deserve explicit close semantics
6. ethical amnesty and topological exit are treated as different safety problems

它的哲学本质是：

`安全不只问“我还欠不欠这件旧事”，还问“这件旧事还占不占当前世界的位置”。`

## 10. 苏格拉底式自我反思：如果我把这一篇写得更强，我会在哪些地方越级

可以先问六个问题：

1. 如果 no-more-duty 已经等于 archive close，为什么 `StructuredIO` 还要对 duplicates / orphans 明确 `notifyCommandLifecycle(..., 'completed')`？
2. 如果 refuse old echo 已经足够，为什么 `onControlRequestResolved(...)` 还要专门去 cancel stale permission prompt？
3. 如果 old echo 已经 no-more-duty，为什么 `orphaned-permission` 还要保留单独 queue mode 和 non-admission 分流？
4. 如果责任已经关闭，为什么 operator-facing world 还要继续接收 `completed` surface？
5. 如果 archive-close 只是修辞比喻，为什么 `commandLifecycle` 要把它做成 listener contract？
6. 如果系统已经免责释放，为什么源码还要继续治理 waiting / queue / observability 这些 active surfaces？

这些反问共同逼出同一个结论：

`Claude Code 不只在治理旧 echo 还欠不欠责任，也在治理旧 echo 还占不占当前世界的活跃表面。`

## 11. 一条硬结论

这组源码真正说明的不是：

`系统已经不再欠旧回音责任，所以这件事自然就结束了。`

而是：

`系统先回答是否还欠责任，再单独回答它是否已经退出 lifecycle、waiting、queue 与 observability 世界。`

这正是 stronger-request cleanup 线下一步必须补齐的 archive-close grammar。
