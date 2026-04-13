# duplicate与orphan response分流中的强请求清理免责释放治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `470` 时，
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

`Claude Code 已经在 old request echo world 里明确展示：是否还记着 old identity，只是问题的一半；更强的一半是，系统是否仍欠这条 echo 任何补偿或续作义务。`

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
| stale prompt cancellation | `src/cli/structuredIO.ts:401-409` | 为什么 stronger signer 还要主动撤掉旧世界继续等待的责任面 |
| orphaned replay refusal | `src/cli/print.ts:5241-5304` | 为什么 orphaned echo 有时值得补偿接回，有时又被正式拒绝 |
| transcript-resolved amnesty | `src/cli/print.ts:5279-5284` | 为什么 transcript-level stronger truth 可以释放 further compensation duty |

## 4. `processLine()` 先证明：duplicate ignore 不是“我忘了”，而是“我已不再欠第二次责任”

`src/cli/structuredIO.ts:374-392`
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

`src/cli/structuredIO.ts:395-398`
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

`src/cli/print.ts:5241-5304`
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

## 7. `already resolved in transcript` 最能说明：免责释放依赖更强 truth，不依赖简单遗忘

`src/cli/print.ts:5279-5284`
特别值钱。

这里系统不是说：

`我不记得了，所以算了`

而是说：

`already resolved in transcript`

所以：

`return false`

也就是说，
免责释放建立在：

`更强 transcript truth 已经存在`

而不是建立在：

`某些 old identity 已开始被 forget`

这正是 liability-release governor 比 forgetting governor 更强的地方：

它不只关心 memory，
它关心 stronger truth 是否已经足以关闭责任。

## 8. stale prompt cancellation 再证明：release signer 会主动撤销旧世界继续等待的义务面

`src/cli/structuredIO.ts:401-409`
很值钱。

当 `can_use_tool` 请求 resolved 后，
系统会通知 bridge：

`onControlRequestResolved(...)`

去 cancel claude.ai 侧 stale permission prompt。

这条证据非常关键。

因为它说明 release signer 不是只是：

`消极地不再处理`

而是：

`积极地撤销旧世界继续等待的责任面`

这正是 active liability release，
不是 passive forgetting。

## 9. 为什么这层不等于 `320` 的 forgetting gate

这里必须单独讲清楚，
否则容易把 `321` 误读成 `320` 的尾注。

`320` 问的是：

`old request identity 什么时候开始安全淡出。`

`321` 问的是：

`即便 old identity 还保留着，或即便它开始淡出了，系统现在还欠不欠这条 old echo 任何补偿义务。`

所以：

1. `320` 的典型形态是 retained IDs、bounded eviction、anti-duplicate memory
2. `321` 的典型形态是 duplicate ignore、orphan compensate-or-refuse、transcript-resolved amnesty、stale prompt teardown

前者 guarding memory disposition，
后者 guarding obligation closure。

两者都很重要，
但不是同一个 signer。

## 10. 更深一层的技术先进性：Claude Code 真正谨慎的地方，不是“开始忘掉它就算免责”，而是“没有补偿义务关闭判断，就绝不让遗忘语法冒充免责语法”

这组源码给出的技术启示至少有六条：

1. forgetting grammar 之外，还必须再长一层 liability-release grammar。
2. duplicate / unknown / orphan late echo 都应进入 compensate-or-refuse grammar。
3. transcript-level stronger truth 可成为 no-more-duty judgment 的独立依据。
4. stale waiting surfaces 应被视为 residual obligation surface，而不是单纯 UI 噪音。
5. retained memory 与 residual duty closure 必须分别治理。
6. 真正成熟的安全系统宁可继续保留一点记忆，也不愿在没有正式判断“已不再欠它”之前把遗忘偷写成免责。

## 11. 苏格拉底式自反诘问：我是不是又把“现在可以开始忘掉它”误认成了“现在已经彻底不再欠它任何责任”

如果对这组代码做更严格的自我审查，
至少要追问六句：

1. 如果 forgetting 已经等于免责释放，为什么 `handleOrphanedPermissionResponse()` 还要专门区分“already handled”与“already resolved in transcript”？
   因为是否再欠补偿义务，需要单独判断，不是由 memory state 自动推出。
2. 如果 no pending request 已经等于 no more duty，为什么 unknown response 还要先走 `unexpectedResponseCallback` 的补偿分流？
   因为 live ledger 清空不等于所有旧 echo 都已失去解释资格。
3. 如果 old request identity 还保留着，就一定说明还欠旧义务吗？
   也不对，因为 retained memory 可能只是为了 anti-duplicate guard，而不是为了继续承担补偿责任。
4. 如果 duplicate 已经被识别出来，为什么 repo 还要明确写 `Ignoring duplicate ...` 而不是简单沉默？
   因为 release judgment 本身需要被制度化，而不是靠偶然没处理来碰运气。
5. 如果 transcript 已经给出 stronger truth，为什么 stale prompt 还要额外被取消？
   因为 release 不只是判断 truth，还包括主动关闭旧责任面。
6. 如果 cleanup 线还没正式长出 liability-release grammar，是不是说明这层只是异常分流？
   恰恰相反。越是把它当异常分流，越容易让“开始忘掉它”偷签“彻底不再欠它任何责任”。`

这一串反问最终逼出一句更稳的判断：

`liability release 的关键，不在旧 identity 还记不记得，而在系统能不能正式决定旧 echo 现在是否已经不再值得补偿接回。`

## 12. 一条硬结论

这组源码真正说明的不是：

`只要补出 old-request memory 的 safe forgetting grammar，stronger-request cleanup 线就已经知道什么时候不再对旧 echo 负有责任。`

而是：

`repo 已经在 StructuredIO 的 duplicate/unknown-response ignore、print.ts 的 orphan compensate-or-refuse 分流、already resolved in transcript 的更强 truth amnesty，以及 stale permission prompt cancellation 上，清楚展示了 stronger-request liability-release governance 的独立存在；因此 artifact-family cleanup stronger-request forgetting-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request liability-release-governor signer。`

因此：

`开始忘掉它`

不等于

`彻底不再欠它`

而真正成熟的 stronger-request cleanup control plane，
必须在这两者之间再长出一层正式 liability-release signer。
