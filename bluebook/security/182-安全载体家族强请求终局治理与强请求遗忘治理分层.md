# 安全载体家族强请求终局治理与强请求遗忘治理分层：为什么artifact-family cleanup stronger-request finality-governor signer不能越级冒充artifact-family cleanup stronger-request forgetting-governor signer

## 1. 为什么在 `181` 之后还必须继续写 `182`

`181-安全载体家族强请求完成治理与强请求终局治理分层` 已经回答了：

`resumed stronger request 当前已经完成`

不等于

`这份完成以后回来时仍然成立。`

但如果继续往下追问，
还会碰到另一层同样容易被偷写的错觉：

`只要 resumed stronger request 已经跨过更强终局门槛，系统就可以立刻忘掉与这条 request 相关的旧 identity / old response memory，不再需要保留任何“已处理过”的痕迹。`

Claude Code 当前源码同样不能支持这种更强说法。

因为继续看：

1. `src/cli/structuredIO.ts:145-183` 的 `resolvedToolUseIds`
2. `src/cli/structuredIO.ts:286-289,374-401,497-501` 的 `trackResolvedToolUseId()`、duplicate ignore 与 abort path
3. `src/cli/structuredIO.ts:133-183` 的 `MAX_RESOLVED_TOOL_USE_IDS` 与 oldest eviction
4. `src/cli/print.ts:2768-2782` 的 `handledOrphanedToolUseIds`
5. `src/cli/print.ts:5238-5305` 的 `handleOrphanedPermissionResponse()`

会发现 repo 已经清楚展示出：

1. `stronger-request finality governance` 负责决定 resumed stronger request 是否已经 current-final / future-readable enough
2. `stronger-request forgetting governance` 负责决定这条已终局 request 的 identity、duplicate-suppression memory 与 orphan-absorption memory 什么时候才配被忘掉

也就是说：

`artifact-family cleanup stronger-request finality-governor signer`

和

`artifact-family cleanup stronger-request forgetting-governor signer`

仍然不是一回事。

前者最多能说：

`这条 resumed stronger request 的结果现在已经 future-readable enough to trust。`

后者才配说：

`与这条 request 相关的 old identity / duplicate-response memory 现在已经可以安全遗忘，而不会让旧世界回音重新污染 current world。`

所以 `181` 之后必须继续补的一层就是：

`安全载体家族强请求终局治理与强请求遗忘治理分层`

也就是：

`stronger-request finality governor 决定这份结果以后回来时是否仍然成立；stronger-request forgetting governor 才决定这条 request 的 anti-duplicate memory 什么时候可以安全消退。`

## 2. 先做三条谨慎声明

第一条：

`Claude Code 当前源码里并没有一个字面存在的类型叫 artifact-family cleanup stronger-request forgetting-governor signer。`

这里的 `artifact-family cleanup stronger-request forgetting-governor signer` 仍是研究命名。
它不是在声称 cleanup 线已经有一个未公开的 resumed-request forgetting manager，
而是在说：

1. repo 已经明确拒绝“终局成立后立刻遗忘”
2. repo 已经把 anti-duplicate memory 做成 bounded retained state
3. cleanup 线未来若只补 stronger-request finality，而不补 post-finality forgetting grammar，仍会留下“何时才配真正忘掉 old request identity”的缺口

第二条：

这里的 `forgetting`

不是在说：

`系统永远不应该遗忘。`

恰恰相反，
源码已经展示出一种更成熟的 forgetting discipline：

`not immediate forgetting, but bounded, delayed, risk-aware forgetting`

也就是：

1. 先保留 enough memory 防 duplicate/orphan pollution
2. 再在单独的 budget / eviction rule 下逐步遗忘

第三条：

这里也不是把：

`resolvedToolUseIds`

直接等同于所有 forgetting grammar。

真正要说的是：

`它是一个很硬的正对照，足以证明 finality 不自动等于 forgetting。`

## 3. 最短结论

Claude Code 当前源码至少给出了五类“stronger-request finality-governor signer 仍不等于 stronger-request forgetting-governor signer”证据：

1. `resolvedToolUseIds` 会在 request 正常 resolved 或被 hook/abort 截断后仍继续保留 `tool_use_id`，说明 finality 之后仍需 retained identity memory
2. `processLine()` 在遇到 late/duplicate `control_response` 时，会用 `resolvedToolUseIds` 明确忽略已处理 response，说明 current-final truth 仍需要 anti-duplicate forgetting gate 保护
3. `injectControlResponse()` 与 aborted path 都会在真正删除 pending request 前先 `trackResolvedToolUseId()`，说明“活单账本关闭”不等于“可立即忘掉 request identity”
4. `MAX_RESOLVED_TOOL_USE_IDS = 1000` 与 oldest eviction 说明 forgetting 是单独受预算控制的 bounded policy，而不是 finality 的自动副作用
5. `handleOrphanedPermissionResponse()` 还要保留 `handledToolUseIds` 来跳过 duplicate orphaned permission，并在 transcript 已 resolved 时拒绝重新接回；说明 even after stronger finality，系统仍不能立刻忘掉 old request identity

因此这一章的最短结论是：

`stronger-request finality governor 最多能说 resumed stronger request 的结果以后回来时仍然成立；stronger-request forgetting governor 才能说与这条 request 相关的 anti-duplicate / anti-orphan memory 什么时候已经可以安全消退。`

再压成一句：

`future-readable enough to trust，不等于 safe enough to forget。`

## 4. 第一性原理：finality 回答“以后回来还能不能当真”，forgetting 回答“这份真相现在能不能不再记着旧世界的回音风险”

从第一性原理看，
强请求终局治理与强请求遗忘治理处理的是两个不同主权问题。

stronger-request finality governor 回答的是：

1. 当前 completion 是否已跨过更强持久化/turn-over/readback 门槛
2. future reader 回来时能否继续读回同一 truth
3. 现在这条 resumed stronger request 是否已经 enough to trust later
4. transport illusion 是否已被排除
5. 当前 settled truth 是否已经可被更强 reader 接受

stronger-request forgetting governor 回答的则是：

1. 与这条 request 相关的 identity memory 现在是否还能删
2. duplicate response / orphan response 的回音风险是否已经足够低
3. 哪些“已处理过”的痕迹必须继续保留
4. 何时才配从 retained tombstone-ish memory 过渡到 bounded eviction
5. 忘掉这些痕迹后，会不会让旧世界重新污染 current world

如果把这两层压成一句“已经 final 了”，
系统就会制造五类危险幻觉：

1. final-means-forget-now illusion
   只要 future-readable truth 已成立，就误以为 old request identity 可以立刻忘掉
2. settled-means-no-duplicate-risk illusion
   只要结果已经 settled，就误以为 duplicate/orphan response 不会再来
3. no-pending-means-no-memory illusion
   只要 pending request 已删掉，就误以为 related request memory 也可一并删掉
4. future-readable-means-no-tombstone illusion
   只要以后回来还能读回，就误以为不再需要已处理 ID 的 tombstone-ish retention
5. final-once-means-safe-to-evict illusion
   只要 finality 成立一次，就误以为 eviction 现在已无风险

所以从第一性原理看：

`stronger-request finality governance` 管的是 future-readable settled truth；
`stronger-request forgetting governance` 管的是 old-request memory safe-to-evict threshold。

再用苏格拉底式反问压一次：

1. 如果 finality 已经等于 forgetting，为什么 `resolvedToolUseIds` 还要在 original response handled 之后继续保留？
   因为 final truth 仍可能遭遇旧世界 duplicate echo。
2. 如果 pending request 删除后就能安全忘掉一切，为什么 abort path 还要先 `trackResolvedToolUseId()` 再 reject？
   因为活单账本关闭不等于回音风险已经消失。
3. 如果 request 已经 future-readable enough，为什么 orphaned permission 还要额外维护 `handledToolUseIds`？
   因为“以后回来还能读回”不自动回答“旧孤儿回包会不会再闯进 current world”。

## 5. `resolvedToolUseIds` 先证明：stronger finality 成立后，系统仍刻意保留“已处理过”的 request identity

`structuredIO.ts:145-183` 很硬。

源码注释直接解释了 `resolvedToolUseIds` 的本体：

1. 正常 permission flow resolved 之后也要保留
2. hook abort 之后也要保留
3. duplicate `control_response` 到来时，靠它阻止 orphan handler 重新处理
4. 否则会制造 duplicate assistant messages，最终 API 400

这条证据极其关键。

因为它说明 repo 明确接受一条很成熟的 post-finality discipline：

`你已经处理完了，不代表你已经可以忘掉。`

也就是说，
系统宁可保留一份 bounded old-request memory，
也不愿让旧世界回音二次改口。

这正是 forgetting governance 的本体：

`not whether truth is settled, but whether the world is safe to stop remembering the old request`

## 6. `trackResolvedToolUseId()`、`injectControlResponse()` 与 abort path 再证明：live ledger close 不等于 safe-to-forget

`structuredIO.ts:286-289,374-401,497-501` 更硬。

这里有三条特别值钱的线：

1. `injectControlResponse()` 在删除 pending request 前先 `trackResolvedToolUseId()`
2. 正常 `control_response` path 在 `pendingRequests.delete(...)` 之前也先 `trackResolvedToolUseId()`
3. abort path 在 reject 前同样先 `trackResolvedToolUseId()`

这三条线合起来非常重要。

因为它们明确说明：

`pendingRequests`

这张活单账本关闭之后，
系统并没有说：

`好了，可以把这条 request 的一切都忘掉。`

相反，
它做的是：

1. 先从 live ledger 退场
2. 再进入 retained dedupe memory

这正是一条典型的分层主权：

`ledger close`

不是

`forgetting authorized`

## 7. bounded eviction 再证明：forgetting 不是 finality 的自动副作用，而是一条单独预算化政策

`MAX_RESOLVED_TOOL_USE_IDS = 1000`

与 oldest eviction 非常值钱。

因为它说明 repo 对 forgetting 的态度不是：

`一完成就忘`

也不是：

`永远不忘`

而是：

`bounded retained memory, then explicit eviction`

这是一个非常成熟的技术启示。

因为它把 forgetting 从一种情绪化动作，
变成一条预算化、风险化、可解释的 policy。

从第一性原理看，
这比“final 了就删”先进得多。

因为系统真正在治理的是：

`忘掉会不会让旧世界回来污染当前世界`

而不是：

`对象看起来是不是已经结束`

## 8. `handleOrphanedPermissionResponse()` 再证明：even after stronger finality，系统仍不能立刻忘掉 orphan/duplicate 风险

`print.ts:5238-5305` 很硬。

这里 repo 明确维护了：

`handledToolUseIds`

并给出两条非常关键的规则：

1. 已 handled 的 orphaned permission 若再来，直接跳过
2. 若 transcript 里已经 resolved，也拒绝重新接回

注释更是直接说：

如果没有这个 guard，
duplicate orphaned permission 会导致同一 tool 多次执行，
并让 messages array 里出现 duplicate tool_use IDs，最终 API 400。

这条证据非常值钱。

因为它说明：

即便 original request 在更强意义上已经 final enough，
系统仍然不认为：

`现在已经 safe to forget the old request identity`

否则 duplicate orphaned response 依然会重新污染 current world。

所以这里最硬的技术启示是：

`final truth still needs anti-replay memory before it earns forgetting`

## 9. 为什么这层不等于 `181` 的 finality gate

这里必须单独讲清楚，
否则容易把 `182` 误读成 `181` 的尾注。

`181` 问的是：

`resumed stronger request 的结果以后回来时是否仍然成立。`

`182` 问的是：

`即便这份结果以后回来时仍然成立，系统现在能不能停止记住这条 old request 的 anti-duplicate identity。`

所以：

1. `181` 的典型形态是 `tool_result`、`files_persisted`、`idle`、`state_restored`
2. `182` 的典型形态是 `resolvedToolUseIds`、`handledToolUseIds`、duplicate ignore、oldest eviction

前者 guarding future-readable truth，
后者 guarding safe forgetting。

两者都很重要，
但不是同一个 signer。

## 10. 一条硬结论

这组源码真正说明的不是：

`只要 resumed stronger request 已经获得 stronger finality，cleanup 线就已经可以自然忘掉与它相关的旧 identity 与 duplicate-risk memory。`

而是：

`repo 已经在 StructuredIO 的 resolvedToolUseIds、trackResolvedToolUseId()、pendingRequests delete 前的 retained dedupe memory、bounded oldest eviction，以及 print.ts 的 handledOrphanedToolUseIds / duplicate orphan guard 上，清楚展示了 stronger-request forgetting governance 的独立存在；因此 artifact-family cleanup stronger-request finality-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request forgetting-governor signer。`

因此：

`cleanup 线真正缺的，不只是“谁来宣布 resumed stronger request 的结果以后仍然成立”，还包括“谁来宣布与它相关的 old request identity 现在终于已经安全到可以忘掉”。`
