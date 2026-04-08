# StructuredIO与orphaned permission处理链的强请求清理遗忘治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `342` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 线未来谁来决定 continued stronger cleanup request 的结果以后回来时仍然成立，`

而是：

`stronger-request cleanup 线如果未来已经确认这份结果 future-readable enough，谁来决定与这条 request 相关的 old identity 什么时候才配安全遗忘。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`finality governor 不等于 forgetting governor。`

这句话还不够硬。
所以这里单开一篇，
只盯住：

- `src/cli/structuredIO.ts`
- `src/cli/print.ts`

把 `resolvedToolUseIds`、`trackResolvedToolUseId()`、duplicate ignore、bounded eviction 与 `handledOrphanedToolUseIds` / orphaned permission dedupe 并排，
逼出一句更硬的结论：

`Claude Code 已经在 continued stronger-cleanup world 里明确展示：final truth 建立后，系统仍会保留一段 bounded anti-duplicate memory；真正的 forgetting 要等 duplicate/orphan replay 风险被单独压住之后才成立。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 为了避免 API 400 做了一点去重。`

而是：

`Claude Code 明确拒绝把 stronger-request finality 自动压平成 immediate forgetting；它用一套 retained identity memory 和 bounded eviction grammar 来保护 current world 不被 old-world echoes 二次污染。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| retained post-resolution identity memory | `src/cli/structuredIO.ts:145-183` | 为什么 final/resolved tool_use 仍要继续被记住 |
| ledger close vs remembering | `src/cli/structuredIO.ts:283-289,374-401,497-501` | 为什么 pending ledger 关闭后仍要先 track resolved ID |
| bounded forgetting budget | `src/cli/structuredIO.ts:133-183` | 为什么 forgetting 不是即时删除，而是 bounded eviction |
| orphaned replay suppression | `src/cli/print.ts:2766-2778,5241-5305` | 为什么 orphaned permission 也需要 handled-ID memory |
| transcript-resolved guard | `src/cli/print.ts:5282-5283` | 为什么 final truth 在 transcript 成立后，系统仍不允许旧回包重新接管 current world |

## 4. `resolvedToolUseIds` 先证明：当前最强终局之后，系统仍然故意保留 old-request identity

`structuredIO.ts:145-183`
很值钱。

这里注释已经写得非常直接：

1. normal permission flow resolved 后要保留 `tool_use_id`
2. hook abort 后也要保留
3. duplicate `control_response` 到来时，要靠它阻止 orphan handler 重处理
4. 否则 duplicate assistant messages 会污染 transcript，并触发 API 400

这条证据极其关键。

因为它说明源码作者公开接受一条很硬的 post-finality discipline：

`final truth established`

不等于

`safe to forget the old request identity`

系统宁可保留一份 bounded tombstone-ish memory，
也不让 old-world echoes 二次改口。

## 5. `trackResolvedToolUseId()` 再证明：ledger close 之后还有一层 retained memory

`structuredIO.ts:283-289,374-401,497-501`
更硬。

三条路径都指向同一件事：

1. bridge 注入 control response 时，先 `trackResolvedToolUseId()`，再删 pending request
2. 正常 response path 也是先 `trackResolvedToolUseId()`，再删 pending request
3. abort path 也是先 `trackResolvedToolUseId()`，再 reject / finally delete

这说明 repo 明确把：

`live pending ledger`

和

`retained anti-duplicate memory`

拆成两层。

也就是说，
即便当前活单已经关账，
系统仍然公开承认：

`现在还不该把它彻底忘掉`

这正是 forgetting governance 的独立存在。

## 6. duplicate ignore 再证明：即便 live request 已删，old echo 仍然危险

`structuredIO.ts:374-401`
很硬。

当 `pendingRequests` 里已经找不到 request 时，
repo 不会直接说：

`那就说明这事已经结束，可以忽略一切旧响应。`

它还会继续追问：

1. 这是不是 duplicate `control_response`
2. `toolUseID` 是否已经出现在 `resolvedToolUseIds`
3. 若是，必须明确忽略，否则就会把 duplicate assistant messages 再次推入会话

这说明 forgetting 不只是：

`别再看它`

而是：

`在遗忘之前，先把晚到的旧回音安全消音`

更关键的是，
这里连风险后果都写得很具体：

`duplicate assistant messages`

和

`API 400`

这让 forgetting 不再是抽象记忆哲学，
而是 current-world integrity 的一部分。

## 7. `handleOrphanedPermissionResponse()` 再证明：即便 transcript 已经 final，系统仍不允许 orphan echo 越权复活

`print.ts:2766-2778,5241-5305`
很硬。

这里 repo 明确维护：

`handledOrphanedToolUseIds`

并强行执行三条规则：

1. session loop 外先创建一个跨回包复用的 handled-ID set
2. 若 `handledToolUseIds.has(toolUseID)`，duplicate orphaned permission 直接跳过
3. 若 `findUnresolvedToolUse(toolUseID)` 找不到，说明 transcript 已 resolved，也拒绝重新接回

尤其：

`already handled`

和

`already resolved in transcript`

这两句 debug 词法非常值钱。

因为它们直接说明：

1. final truth 可以已经存在于 transcript surface
2. 但当前 surface 仍需 retained anti-replay guard
3. “别再处理它”本身就是 forgetting plane 的制度动作，而不是 finality plane 的附属注脚

## 8. oldest eviction 再证明：真正的 forgetting 不是 finality 的自然副作用，而是一条单独预算化政策

`MAX_RESOLVED_TOOL_USE_IDS = 1000`

与 oldest eviction 非常值钱。

因为它说明 repo 对 forgetting 的哲学不是：

1. `resolved -> delete immediately`
2. `resolved -> retain forever`

而是：

`resolved -> retain as anti-duplicate memory -> evict under a bounded policy`

这是一种非常成熟的工程选择。

因为它把 forgetting 从“看起来结束了就删”这种冲动动作，
变成：

`风险、内存与重复回包窗口之间的平衡策略`

## 9. 用苏格拉底式反问压缩这一层的核心

如果我想继续把这一层做得更硬，
至少要反复问自己五句：

1. 我现在说的是
   `以后回来还能不能当真`
   还是
   `现在能不能把旧身份忘掉`
   ？
2. `resolvedToolUseIds`
   如果只是实现细节，
   为什么 normal resolved、hook abort 与 duplicate ignore 都要依赖它？
3. pending request
   如果删掉就等于安全遗忘，
   为什么系统还要先 `trackResolvedToolUseId()`？
4. transcript
   如果已经 resolved，
   为什么 orphaned permission 还要继续维护 handled-ID guard？
5. 就算 forgetting 已经成立，
   我能否因此直接跳过下一层“旧 echo 现在还欠不欠任何补偿义务”？

这些问题合起来逼出的结论只有一句：

`Claude Code 不只在治理这份结果以后回来时是否仍然成立，也在治理这份结果相关的旧身份什么时候才配真正退场。`
