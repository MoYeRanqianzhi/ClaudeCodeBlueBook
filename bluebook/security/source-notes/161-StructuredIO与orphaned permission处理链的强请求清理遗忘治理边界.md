# StructuredIO 与 orphaned permission 处理链的强请求清理遗忘治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `310` 时，
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
| retained post-resolution identity memory | `src/cli/structuredIO.ts:149-183` | 为什么 final/resolved tool_use 仍要继续被记住 |
| ledger close vs remembering | `src/cli/structuredIO.ts:283-289,374-401,497-501` | 为什么 pending ledger 关闭后仍要先 track resolved ID |
| bounded forgetting budget | `src/cli/structuredIO.ts:130-183` | 为什么 forgetting 不是即时删除，而是 bounded eviction |
| orphaned replay suppression | `src/cli/print.ts:2766-2778,5241-5305` | 为什么 orphaned permission 也需要 handled-ID memory |
| transcript-resolved guard | `src/cli/print.ts:5279-5284` | 为什么 final truth 在 transcript 成立后，系统仍不允许旧回包重新接管 current world |

## 4. `resolvedToolUseIds` 先证明：当前最强终局之后，系统仍然故意保留 old-request identity

`structuredIO.ts:149-183`
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

## 9. 为什么这层不等于 `160` 的 stronger finality gate

这里必须单独讲清楚，
否则容易把 `161` 误读成 `160` 的尾注。

`160` 问的是：

`continued stronger cleanup request 的结果以后回来时是否仍然成立。`

`161` 问的是：

`即便这份结果以后回来时仍然成立，系统现在能不能停止记住与它相关的 old request identity。`

所以：

1. `160` 的典型形态是 `sendResult()`、`files_persisted`、`idle`、`state_restored`
2. `161` 的典型形态是 `resolvedToolUseIds`、`handledOrphanedToolUseIds`、duplicate ignore、bounded eviction

前者 guarding future-readable truth，
后者 guarding safe forgetting。

两者都很重要，
但不是同一个 signer。

## 10. 从技术先进性看：Claude Code 不只把“结果仍真”做成终局语法，还把“旧回音何时无害”做成遗忘语法

从技术角度看，
Claude Code 在这里最先进的地方，
不是它“为了避免 API 400 加了几个 Set”，
而是它明确拒绝把：

`future-readable finality`

偷写成：

`safe forgetting`

这套设计至少体现了六个成熟点：

1. split live ledger from retained dedupe memory
2. treat late duplicates as a governance problem, not only a transport bug
3. keep a separate orphan-suppression memory beside transcript finality
4. model forgetting as bounded policy instead of automatic side effect
5. admit that stale echoes stay dangerous after truth has settled
6. make anti-replay memory part of safety, not a debugging afterthought

它的哲学本质是：

`安全不只问“结果以后回来时还真不真”，还问“与这份结果有关的旧回音什么时候才真正不再危险”。`

## 11. 苏格拉底式自我反思：如果我把这一篇写得更强，我会在哪些地方越级

可以先问六个问题：

1. 如果 final truth 建立后就可以立刻遗忘，为什么 `resolvedToolUseIds` 还要继续保留已处理的 `tool_use_id`？
2. 如果 pending request 被删掉就等于已经忘掉，为什么 `trackResolvedToolUseId()` 还要在 delete 之前先记一遍？
3. 如果 duplicate `control_response` 只是底层噪音，为什么源码要专门把它升级成 retained set + ignore branch？
4. 如果 transcript 已 resolved 就已经万事大吉，为什么 orphaned permission path 还要继续靠 `handledOrphanedToolUseIds` 和 transcript-resolved guard 阻断回包复活？
5. 如果 bounded eviction 只是实现细节，为什么作者要把 `MAX_RESOLVED_TOOL_USE_IDS` 与 oldest eviction 明写成稳定 policy？
6. 如果 future-readable enough 已经等于 safe enough to forget，为什么系统还要继续防 duplicate / orphan / replay echo？

这些反问共同逼出同一个结论：

`Claude Code 不只在治理结果以后回来时是否仍真，也在治理这份真相周围的旧回音何时才真正可以无害地消退。`

## 12. 一条硬结论

这组源码真正说明的不是：

`只要补出 continued stronger-request 的 stronger finality，stronger-request cleanup 线就已经知道何时可以忘掉与它相关的 old request identity。`

而是：

repo 已经在 `StructuredIO` 的 `resolvedToolUseIds`、`trackResolvedToolUseId()`、duplicate ignore、bounded oldest eviction，以及 `print.ts` 的 `handledOrphanedToolUseIds` / transcript-resolved guard 上，清楚展示了 stronger-request forgetting governance 的独立存在；因此 `artifact-family cleanup stronger-request finality-governor signer` 仍不能越级冒充 `artifact-family cleanup stronger-request forgetting-governor signer`。
