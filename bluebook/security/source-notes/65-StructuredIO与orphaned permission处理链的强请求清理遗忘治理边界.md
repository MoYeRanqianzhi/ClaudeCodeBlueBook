# StructuredIO 与 orphaned permission 处理链的强请求清理遗忘治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `214` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 线未来谁来决定 continued stronger cleanup request 的结果以后回来时仍然成立，`

而是：

`stronger-request cleanup 线如果未来已经确认这份结果 future-readable enough，谁来决定与这条 request 相关的 old identity 什么时候才配安全遗忘。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`finality governor 不等于 forgetting governor。`

这句话还不够硬。
所以这里单开一篇，只盯住：

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
| orphaned replay suppression | `src/cli/print.ts:2768-2782,5238-5305` | 为什么 orphaned permission 也需要 handled-ID memory |
| transcript-resolved guard | `src/cli/print.ts:5278-5283` | 为什么 final truth 在 transcript 成立后，系统仍不允许旧回包重新接管 current world |

## 4. `resolvedToolUseIds` 先证明：当前最强终局之后，系统仍然故意保留 old-request identity

`structuredIO.ts:145-183` 很值钱。

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

`structuredIO.ts:286-289,374-401,497-501` 更硬。

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

`print.ts:2768-2782,5238-5305` 很硬。

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

## 8. 为什么这层不等于 `64` 的 stronger finality gate

这里必须单独讲清楚，
否则容易把 `65` 误读成 `64` 的尾注。

`64` 问的是：

`continued stronger cleanup request 的结果以后回来时是否仍然成立。`

`65` 问的是：

`即便这份结果以后回来时仍然成立，系统现在能不能停止记住与它相关的 old request identity。`

所以：

1. `64` 的典型形态是 `tool_result`、`files_persisted`、`idle`、`state_restored`
2. `65` 的典型形态是 `resolvedToolUseIds`、`handledOrphanedToolUseIds`、duplicate ignore、bounded eviction

前者 guarding future-readable truth，
后者 guarding safe forgetting。

两者都很重要，
但不是同一个 signer。

## 9. 这篇源码剖面给主线带来的四条技术启示

### 启示一

repo 已经明确展示：

`final truth can require post-finality retained memory`

### 启示二

repo 已经明确展示：

`closing the live ledger is weaker than authorizing forgetting`

### 启示三

repo 已经明确展示：

`forgetting is budgeted eviction, not automatic deletion`

### 启示四

repo 已经明确展示：

`duplicate/orphan suppression is a first-class safety layer, not cleanup garnish`

这四句合起来，
正好说明为什么 stronger-request cleanup 线未来不能把 continued stronger-request finality 直接偷写成 continued stronger-request forgetting。

## 10. 一条硬结论

这组源码真正说明的不是：

`只要补出 continued stronger-request 的 stronger finality，stronger-request cleanup 线就已经知道何时可以忘掉与它相关的 old request identity。`

而是：

`repo 已经在 StructuredIO 的 resolvedToolUseIds、trackResolvedToolUseId()、bounded oldest eviction，以及 print.ts 的 handledOrphanedToolUseIds / transcript-resolved guard 上，清楚展示了 stronger-request forgetting governance 的独立存在；因此 artifact-family cleanup stronger-request finality-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request forgetting-governor signer。`

因此：

`stronger-request cleanup 线真正缺的，不只是“谁来宣布 continued stronger-request 的结果以后仍然成立”，还包括“谁来宣布与它相关的 old identity 现在已经安全到可以忘掉”。`
