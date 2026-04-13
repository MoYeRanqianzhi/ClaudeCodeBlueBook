# StructuredIO与orphaned permission处理链的强请求清理遗忘治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `469` 时，
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

把 `resolvedToolUseIds`、`trackResolvedToolUseId()`、bounded eviction 与 `handledOrphanedToolUseIds` / orphaned permission dedupe 并排，
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
| ledger close vs remembering | `src/cli/structuredIO.ts:286-289,374-401,497-501` | 为什么 pending ledger 关闭后仍要先 track resolved ID |
| bounded forgetting budget | `src/cli/structuredIO.ts:133-183` | 为什么 forgetting 不是即时删除，而是 bounded eviction |
| orphaned replay suppression | `src/cli/print.ts:2768-2782,5241-5304` | 为什么 orphaned permission 也需要 handled-ID memory |
| transcript-resolved guard | `src/cli/print.ts:5279-5284` | 为什么 final truth 在 transcript 成立后，系统仍不允许旧回包重新接管 current world |

## 4. `resolvedToolUseIds` 先证明：当前最强终局之后，系统仍然故意保留 old-request identity

`src/cli/structuredIO.ts:145-183`
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

`src/cli/structuredIO.ts:286-289,374-401,497-501`
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

## 6. oldest eviction 再证明：真正的 forgetting 不是 finality 的自然副作用，而是一条单独预算化政策

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

## 7. `handleOrphanedPermissionResponse()` 再证明：即便 final truth 已成立，系统仍不允许 orphan echo 越权复活 old request

`src/cli/print.ts:2768-2782,5241-5304`
很硬。

这里 repo 明确维护：

`handledOrphanedToolUseIds`

并强行执行三条规则：

1. session loop 外先创建一个跨回包复用的 handled-ID set
2. 若 `handledToolUseIds.has(toolUseID)`，duplicate orphaned permission 直接跳过
3. 若 `findUnresolvedToolUse(toolUseID)` 找不到，说明 transcript 已 resolved，也拒绝重新接回

这条路径非常值钱。

因为它直接说明：

even after final truth exists elsewhere，
系统仍然不认为：

`现在可以忘掉这个 old request 的 anti-replay memory`

否则 duplicate orphaned response 会重新触发同一 tool 执行，
把 current world 再次拖回 stale world。

## 8. 为什么这层不等于 `319` 的 stronger finality gate

这里必须单独讲清楚，
否则容易把 `320` 误读成 `319` 的尾注。

`319` 问的是：

`continued stronger cleanup request 的结果以后回来时是否仍然成立。`

`320` 问的是：

`即便这份结果以后回来时仍然成立，系统现在能不能停止记住与它相关的 old request identity。`

所以：

1. `319` 的典型形态是 `tool_result`、`sendResult()`、`files_persisted`、`idle`、`state_restored`
2. `320` 的典型形态是 `resolvedToolUseIds`、`handledOrphanedToolUseIds`、duplicate ignore、bounded eviction

前者 guarding future-readable truth，
后者 guarding safe forgetting。

两者都很重要，
但不是同一个 signer。

## 9. 更深一层的技术先进性：Claude Code 真正谨慎的地方，不是“终局成立了就该马上忘掉”，而是“没有回音风险阈值，就绝不让终局语法冒充遗忘语法”

这组源码给出的技术启示至少有六条：

1. finality grammar 之外，还必须再长一层 forgetting grammar。
2. final truth 成立后仍可能需要 retained identity memory。
3. live pending ledger close 和 safe forgetting 必须分层治理。
4. bounded oldest eviction 是治理策略，不是实现边角。
5. orphan / duplicate suppression memory 应被视为安全边界的一部分。
6. 真正成熟的安全系统宁可多记一会儿，也不愿在没有压低旧回音风险之前把“以后仍真”误签成“现在可忘”。`

## 10. 苏格拉底式自反诘问：我是不是又把“它以后回来时仍然成立”误认成了“现在已经可以不再记住它”

如果对这组代码做更严格的自我审查，
至少要追问六句：

1. 如果 finality 已经等于 forgetting，为什么 `resolvedToolUseIds` 还要在 original response handled 之后继续保留？
   因为 final truth 仍可能遭遇旧世界 duplicate echo。
2. 如果 pending request 删除后就能安全忘掉一切，为什么 abort path 还要先 `trackResolvedToolUseId()` 再 reject？
   因为活单账本关闭不等于回音风险已经消失。
3. 如果 request 已经 future-readable enough，为什么 orphaned permission 还要额外维护 `handledToolUseIds`？
   因为“以后回来还能读回”不自动回答“旧孤儿回包会不会再闯进 current world”。
4. 如果 forgetting 只是清理动作，为什么源码还要给它 `MAX_RESOLVED_TOOL_USE_IDS` 这种单独预算？
   因为 forgetting 是政策，不是自然蒸发。
5. 如果 transcript 已 resolved 就足够，为什么 `already resolved in transcript` 仍只意味着拒绝重接，而不意味着立刻清空 memory？
   因为 transcript truth 与 anti-replay memory 不是同一层。
6. 如果 cleanup 线还没正式长出 forgetting grammar，是不是说明这层只是保留缓存的小问题？
   恰恰相反。越是把它当小缓存问题，越容易让“以后仍真”偷签“现在可忘”。`

这一串反问最终逼出一句更稳的判断：

`forgetting 的关键，不在结果以后能不能读回，而在系统能不能正式决定与这条结果相关的旧回音风险什么时候已经低到可被遗忘。`

## 11. 一条硬结论

这组源码真正说明的不是：

`只要补出 continued stronger-request 的 stronger finality，stronger-request cleanup 线就已经知道何时可以忘掉与它相关的 old request identity。`

而是：

`repo 已经在 StructuredIO 的 resolvedToolUseIds、trackResolvedToolUseId()、bounded oldest eviction，以及 print.ts 的 handledOrphanedToolUseIds / transcript-resolved guard 上，清楚展示了 stronger-request forgetting governance 的独立存在；因此 artifact-family cleanup stronger-request finality-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request forgetting-governor signer。`

因此：

`以后仍真`

不等于

`现在可忘`

而真正成熟的 stronger-request cleanup control plane，
必须在这两者之间再长出一层正式 forgetting signer。
