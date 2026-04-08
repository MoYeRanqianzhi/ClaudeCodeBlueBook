# duplicate与orphan response分流中的强请求清理免责释放治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `343` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 线未来谁来决定 old request identity 什么时候才配开始遗忘，`

而是：

`即便 old identity 已经开始淡出，谁来决定系统现在是否仍欠 late duplicate/orphan echo 任何补偿义务。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`forgetting governor 不等于 liability-release governor。`

这句话还不够硬。
所以这里单开一篇，
只盯住：

- `src/cli/structuredIO.ts`
- `src/cli/print.ts`

把 duplicate ignore、unknown-response no-op、orphaned permission compensate-or-refuse、`already resolved in transcript` 与 stale prompt cancellation 并排，
逼出一句更硬的结论：

`Claude Code 已经在 permission/control-response world 里明写：late echo 到来时，系统处理的不是“还记不记得它”，而是“现在还欠不欠它责任”。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 为了避免重复执行做了一点去重。`

而是：

`Claude Code 明确拒绝把 forgetting 自动压平成 amnesty；它用一套 no-more-duty judgment、compensate-or-refuse branching 与 stale-surface teardown grammar 来管理旧责任什么时候才正式关闭。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| duplicate refusal | `src/cli/structuredIO.ts:374-391` | 为什么 duplicate control_response 被忽略不是因为系统忘了，而是因为它已不再欠第二次补偿 |
| unknown-response no-op | `src/cli/structuredIO.ts:391-398` | 为什么没有 live pending basis 时也能形成 no-more-duty judgment |
| orphaned compensate-or-refuse | `src/cli/print.ts:5241-5305` | 为什么 orphan echo 不是统一忽略，而要重新判断当前是否仍欠它责任 |
| already handled / transcript resolved | `src/cli/print.ts:5267-5284` | 为什么 refusal 要踩在 handled fact 或 stronger transcript truth 上 |
| stale prompt cancellation | `src/cli/structuredIO.ts:400-409` | 为什么免责释放不只是 return false，而还要主动关闭旧 waiting surface |

## 4. duplicate ignore 先证明：免责释放不是“我忘了”，而是“我已不再欠第二次责任”

`structuredIO.ts:374-391`
很值钱。

这里当 `pendingRequests` 已经找不到 request 时，
repo 并不会立刻把它压成单纯的缺失噪音。

它会继续追问：

1. 这是不是一条 duplicate `control_response`
2. 它的 `toolUseID` 是否已经在 `resolvedToolUseIds`
3. 若是，就明确写出
   `Ignoring duplicate control_response for already-resolved ...`

这条线非常关键。

因为它说明 refusal 的根据不是：

`我不认识你`

而是：

`我认识你，而且知道你已经被正式处理，所以我不再欠你第二次补偿`

这就是 liability release 的原型。

## 5. unknown-response no-op 再证明：没有当前 basis，也是一种 obligation judgment

`structuredIO.ts:391-398`
同样很硬。

当 request not found，
而且 duplicate-resolved check 也过不去时，
repo 最终走向：

`Ignore responses for requests we don't know about`

这条路径很容易被误读成：

`系统只是忘了。`

但从控制面设计看，
更稳的读法其实是：

`当前世界已经没有足够强的 live basis 去重新承担这条旧义务。`

也就是说，
这不是 forgetting judgment，
而是：

`not enough current basis to owe more`

这种 no-op 之所以值钱，
就在于它把免责释放从“必须记得很清楚才能拒绝”，
推进到：

`就算现在没有 live carrier，系统仍可基于 current basis insufficiency 拒绝重开旧责任`

## 6. orphaned permission 分流再证明：真正成熟的 release grammar 是 compensate-or-refuse

`print.ts:5241-5305`
是这一层最硬的控制面。

`handleOrphanedPermissionResponse()`
没有把 orphaned permission 当成一团异常噪音。

它明确维护：

`handledToolUseIds`

然后执行三路分流：

1. `already handled`
   直接跳过 duplicate orphan replay
2. `already resolved in transcript`
   拒绝重新接回，因为更强 truth 已经成立
3. `findUnresolvedToolUse(...)`
   成功时，才把 orphaned permission `enqueue`

这条结构说明一件很重要的事：

`orphan response` 不是“异常情况”；
它恰好暴露了系统最真实的 liability-release grammar。

因为只有在这里，
源码才被迫正面回答：

`这条旧 echo 到底还欠不欠它一次补偿接回？`

## 7. `already resolved in transcript` 特别值钱：免责释放必须踩在更强 truth 上

`print.ts:5279-5284`
的价值，
不在于多了一句 debug 文案。

真正关键的是：

`already resolved in transcript`

把 refusal 的根据从：

`这里现在没东西`

提升成了：

`在更强读者表面上，这件事已经被正式解决`

这带来一个很深的哲学边界：

`免责释放`
不是
`弱记忆消退`
的自然副产品，
而是
`更强 truth 已经足以关闭本地旧责任`
的制度结果。

这也是为什么：

`safe enough to forget`

绝不能被偷写成：

`no longer owe compensation`

## 8. stale prompt cancellation 最后证明：release 不只是拒绝，还包括旧责任面的主动收口

`structuredIO.ts:400-409`
很容易被忽略，
但它其实极硬。

当 SDK consumer 已经解决了 request，
`onControlRequestResolved(...)`
会通知 bridge 去：

`cancel the stale permission prompt on claude.ai`

这说明 liability release 不只是一句逻辑结论：

`我不再处理这条旧 echo`

它还包括一条主动动作：

`把因为这条旧责任而残留在外部 surface 上的等待面一起关掉`

这让 release 从被动 refusal，
升级成 active teardown：

1. 旧义务关闭
2. 旧等待面撤场
3. 外部表面不再被旧状态继续占位

## 9. 技术启示：为什么这套分流值得学

如果把这组设计抽成技术启示，
至少有四条：

1. duplicate guard 最稳的写法不是 absence check，而是 positive resolved proof
2. orphan path 不该被降格成异常分支，它往往是 obligation grammar 的正门
3. refusal 最好踩在 stronger truth 上，而不是踩在“这里现在没对象了”上
4. true release 最好伴随 stale-surface teardown，而不是只返回一个 false

换句话说，
Claude Code 的先进性不只是“多写了几层判断”，
而是它把旧回音治理成了：

`remember enough to classify -> classify whether duty remains -> compensate or refuse -> close residual surfaces`

## 10. 用苏格拉底式反问压缩这一层

如果我想继续把这一层做得更硬，
至少要反复问自己五句：

1. 我现在说的是
   `还能不能识别它`
   还是
   `还欠不欠它责任`
   ？
2. 如果 duplicate ignore 只是 dedupe trick，
   为什么 refusal 需要 `already-resolved` 这种正向事实？
3. 如果 unknown-response no-op 只是“系统忘了”，
   为什么 orphan path 还要重新追问 unresolved transcript basis？
4. 如果 `already resolved in transcript` 只是日志话术，
   为什么它足以阻止旧 echo 重新接管 current world？
5. 如果免责释放已经成立，
   为什么系统还需要主动 cancel stale permission prompt？

这些问题逼出的结论只有一句：

`Claude Code 已经把 late echo 处理从“记忆问题”升级成“义务关闭问题”；而 stronger-request cleanup 线下一步真正该补的，不是继续重复 forgetting，而是把这种 obligation-closure grammar 正式写出来。`
