# duplicate 与 orphan response 分流中的强请求清理免责释放治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `311` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 线未来谁来决定 old request identity 什么时候开始可以安全淡出，`

而是：

`stronger-request cleanup 线如果未来已经进入 forgetting 阶段，谁来决定旧 duplicate/orphan echo 什么时候已经不再值得补偿接回。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`forgetting governor 不等于 liability-release governor。`

这句话还不够硬。
所以这里单开一篇，
只盯住：

- `src/cli/structuredIO.ts`
- `src/cli/print.ts`

把 duplicate ignore、unknown-response ignore、orphan compensate-or-refuse、`already resolved in transcript` 与 stale prompt cancellation 并排，
逼出一句更硬的结论：

`Claude Code 已经在 old request echo world 里明确展示：是否还保不保留 old-request memory，只是问题的一半；更强的一半是，系统是否仍欠这条 echo 任何补偿或续作义务。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 能跳过重复回包。`

而是：

`Claude Code 明确把“还保不保留 old-request memory”与“还欠不欠 old echo 补偿义务”拆成两层，并把后者写成了 compensate-or-refuse grammar。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| duplicate ignore after resolved | `src/cli/structuredIO.ts:374-392` | 为什么 duplicate echo 在更强 truth 已成立后不再创造第二次义务 |
| unknown-response ignore | `src/cli/structuredIO.ts:395-398` | 为什么对 unknown old echo 可以在无更强理由时直接 no-op |
| stale prompt cancellation | `src/cli/structuredIO.ts:400-409` | 为什么 stronger signer 还要主动撤掉旧世界继续等待的责任面 |
| orphaned replay refusal | `src/cli/print.ts:5241-5305` | 为什么 orphaned echo 有时值得补偿接回，有时又被正式拒绝 |
| transcript-resolved amnesty | `src/cli/print.ts:5282-5283` | 为什么 transcript-level stronger truth 可以释放 further compensation duty |

## 4. `processLine()` 先证明：duplicate ignore 不是“我忘了”，而是“我已不再欠第二次责任”

`structuredIO.ts:374-392`
很值钱。

这里 duplicate `control_response` 并不是因为系统“找不到状态”才被跳过。

恰恰相反，
系统正是因为：

1. 认出了 `toolUseID`
2. 知道它已经在 `resolvedToolUseIds`
3. 明确判断这是旧世界的重复交付

才会：

`Ignoring duplicate control_response ...`

这条证据非常关键。

因为它说明这不是 memory failure，
而是 duty judgment：

`我知道你是谁，也知道你已被正式处理，所以我现在不再欠你第二次补偿。`

## 5. unknown-response ignore 再证明：no-more-duty decision 是单独存在的

`structuredIO.ts:395-398`
更硬。

当 request not found，
且没有更强 compensating basis 时，
系统直接：

`Ignore responses for requests we don't know about`

这条线很值钱。

因为它说明 no-more-duty decision 不是只能发生在“记得很清楚的 duplicate”上；
它也可以发生在：

`当前控制面里已经没有足够强的 live basis 去重新承担这条旧义务`

这就是 release governor 的另一面：

`not enough current basis to owe more`

## 6. orphaned permission 分流再证明：补偿与免责释放是同一控制面的两种合法结果

`print.ts:5241-5305`
很硬。

`handleOrphanedPermissionResponse()` 不是一条简单的补偿通道。

它同时展示了：

1. 若仍能找到 unresolved tool_use
   就 `enqueue orphaned permission`
2. 若 `handledToolUseIds.has(toolUseID)`
   就 `already handled -> return false`
3. 若 `findUnresolvedToolUse(toolUseID)` 失败
   就 `already resolved in transcript -> return false`

这条分流极其关键。

因为它说明 repo 已经明确把：

`还欠补偿`

和

`已经免责释放`

写成同一条控制面的两个合法分支。

换句话说，
release 不是 absence of logic，
而是 explicit branch outcome。

## 7. `already resolved in transcript` 与 stale prompt cancellation 再证明：免责释放建立在更强 truth 上，而且会主动收口责任表面

`print.ts:5282-5283`
很值钱。

这里拒绝 orphaned replay 的关键不是：

`我懒得处理`

而是：

`already resolved in transcript`

也就是说，
免责释放不是建立在简单遗忘上，
而是建立在：

`更强 truth 已经存在`

这一点非常关键。

`structuredIO.ts:400-409`
则补上了 release 的另一半。

当 `can_use_tool` 请求 resolved 后，
系统会通过：

`onControlRequestResolved(...)`

去 cancel claude.ai 侧 stale permission prompt。

这说明 liability release 不只是消极地 `return false`，
还会：

`主动撤掉旧责任面`

这正是成熟 release grammar 和普通 ignore 的区别。

## 8. 为什么这层不等于 `161` 的 forgetting gate

这里必须单独讲清楚，
否则容易把 `162` 误读成 `161` 的尾注。

`161` 问的是：

`与 continued stronger cleanup request 相关的 old identity 什么时候开始可以安全淡出。`

`162` 问的是：

`即便 old identity 现在开始可以安全淡出，系统是否还欠 late echo 一次补偿或续作责任。`

所以：

1. `161` 的典型形态是 retained memory、bounded eviction、duplicate suppression
2. `162` 的典型形态是 compensate-or-refuse、unknown-response ignore、stale prompt cancellation、no-more-duty judgment

前者 guarding memory disposition，
后者 guarding obligation closure。

两者都很重要，
但不是同一个 signer。

## 9. 从技术先进性看：Claude Code 不只把“开始忘掉”做成记忆语法，还把“已经不再欠责任”做成义务语法

从技术角度看，
Claude Code 在这里最先进的地方，
不是它“能跳过重复回包”，
而是它明确拒绝把：

`forgetting`

偷写成：

`amnesty`

这套设计至少体现了六个成熟点：

1. duplicate detection is not yet obligation closure
2. stronger truth can justify refusal better than mere memory loss
3. unknown-response no-op is a governed no-basis judgment
4. compensate-or-refuse is a first-class grammar
5. stale surfaces need active teardown after duty ends
6. memory fade and duty end are treated as different safety problems

它的哲学本质是：

`安全不只问“还记不记得这件旧事”，还问“对这件旧事现在还欠不欠责任”。`

## 10. 苏格拉底式自我反思：如果我把这一篇写得更强，我会在哪些地方越级

可以先问六个问题：

1. 如果 old identity 开始可以淡出，就等于系统已经免责释放，为什么 duplicate `control_response` path 还要先认出它已 resolved 才拒绝第二次处理？
2. 如果 forgetting 已经足够，为什么 orphaned permission 还要区分 unresolved tool_use 与 `already resolved in transcript`？
3. 如果 no-more-duty 只是被动忽略，为什么 `onControlRequestResolved(...)` 还要主动 cancel stale permission prompt？
4. 如果系统真的只是“不记得了”，为什么 duplicate ignore 的 debug 文案还会强调 `already-resolved toolUseID`？
5. 如果 unknown-response no-op 只是实现细节，为什么它恰好落在“没有更强 compensating basis”这个制度语境里？
6. 如果 `return false` 已经可以由 forgetting 层解释，为什么源码还要给 refusal 分支配上 handled/transcript-resolved 这类更强 truth basis？

这些反问共同逼出同一个结论：

`Claude Code 不只在治理 old request memory 怎么消退，也在治理 old echo 责任怎么关闭。`

## 11. 一条硬结论

这组源码真正说明的不是：

`只要补出 continued stronger-request 的 forgetting grammar，stronger-request cleanup 线就已经知道何时不再欠旧 echo 责任线程。`

而是：

repo 已经在 duplicate `control_response` ignore、unknown-response ignore、`handleOrphanedPermissionResponse()` 的 compensate-or-refuse 分流，以及 `onControlRequestResolved(...)` 对 stale permission prompt 的主动收口上，清楚展示了 stronger-request liability-release governance 的独立存在；因此 `artifact-family cleanup stronger-request forgetting-governor signer` 仍不能越级冒充 `artifact-family cleanup stronger-request liability-release-governor signer`。
