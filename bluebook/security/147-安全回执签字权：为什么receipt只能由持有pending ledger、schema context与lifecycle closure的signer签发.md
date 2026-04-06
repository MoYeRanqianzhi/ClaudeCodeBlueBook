# 安全回执签字权：为什么receipt只能由持有pending ledger、schema context与lifecycle closure的signer签发

## 1. 为什么在 `146` 之后还必须继续写“回执签字权”

`146-安全偏斜处置回执协议` 已经回答了：

`handoff 之后不能停在“消息发出去了”，而必须继续有 request_id、completion notification 与 orphan reconciliation 把闭环守住。`

但如果再往前追问一步，  
还会碰到一个更硬的问题：

`到底谁配说“这条 response 现在已经算正式 receipt”？`

因为“看见 response 抵达”并不等于：

1. 这条 response 真的属于当前仍存活的 request
2. 它的 subtype 与 payload 符合当前 signer 认可的 schema
3. 它足以关闭 lifecycle
4. 它有资格驱逐旧世界里的 stale prompt、stale pending 或 orphan shadow

如果这里没有正式的 receipt sovereignty，  
系统就会退化成一种常见但危险的幻觉：

`任何看到 response 的弱层都自以为可以宣布“已经签收”。`

这会立刻制造四类失真：

1. arrival illusion  
   看到消息到达，就误当 receipt 已成立
2. parse-free illusion  
   没有 schema 验证，也敢宣布成功签收
3. weak-surface closure illusion  
   弱层自己把 prompt 或 pending 擦掉，冒充正式 closure
4. orphan overreach illusion  
   orphan / duplicate / late response 还没被 reconcile，就被提前改口

所以 `146` 之后必须继续补的一层就是：

`安全回执签字权`

也就是：

`receipt 不是“谁先看见谁签”，而是只有同时持有 live request truth、subtype grammar truth 与 lifecycle closure truth 的 signer 才配签发。`

## 2. 最短结论

Claude Code 当前源码至少展示了 receipt sovereignty 的四个必要条件：

1. live request ledger  
   `pendingRequests` 持有“这张单子现在是否还活着”的真相  
   `src/cli/structuredIO.ts:135-158,510-529`
2. schema context  
   `control_response` 不只匹配 `request_id`，还会按 schema parse payload  
   `src/cli/structuredIO.ts:362-429`
3. lifecycle closure  
   receipt 会伴随 `notifyCommandLifecycle(..., 'completed')` 与 pending deletion  
   `src/cli/structuredIO.ts:362-429`
4. stale-world teardown authority  
   `onControlRequestResolved` 会驱动 stale permission prompt 撤场  
   `src/cli/structuredIO.ts:323-330,401-409`

这些证据合在一起说明：

`Claude Code 并不把 receipt 理解成“收到一条回信”，而是把它理解成“某个掌握活单、语法与闭环权的 signer 正式接单并关单”。`

因此这一章的最短结论是：

`cleanup future design 若继续推进，cleanup receipt signer 不应只是某个 UI surface、某条 callback 或某个 summary 文案，而必须明确绑定 pending cleanup ledger owner、cleanup schema owner 与 cleanup lifecycle closer。`

再压成一句：

`response 的可见性不是 receipt 的主权。`

## 3. 第一性原理：receipt 到底在签什么

从第一性原理看，  
receipt 签的从来不是：

`我看见了某条消息。`

它真正签的是三件事：

1. belonging  
   这条 response 属于哪张仍然存活的单
2. admissibility  
   这条 response 在当前 grammar / schema 下是否可被接受
3. closure effect  
   它一旦成立，哪些状态、提示、账本与动作资格必须随之改口

因此 receipt 的本质不是 observation，  
而是：

`对 closure truth 的一次正式署名。`

没有这层署名，  
系统最多只能说：

`某条 message 被观察到了。`

却不能说：

`这次 handoff 已被正式签收。`

## 4. `pendingRequests` 说明 live request truth 只能由 ledger owner 掌握

`src/cli/structuredIO.ts:135-158` 明确把待签收对象收进：

- `pendingRequests`
- `resolvedToolUseIds`
- `unexpectedResponseCallback`

到 `src/cli/structuredIO.ts:510-529`，  
每次 `sendRequest()` 都会：

1. 生成 `request_id`
2. 把 `request / resolve / reject / schema` 写入 `pendingRequests`
3. 在 `finally` 中删除该 pending 项

这说明 receipt 的第一主权，不在看到 response 的任何一层，  
而在：

`谁拥有 live pending ledger。`

因为只有它知道：

1. 这张单是否还活着
2. 它是否已经 abort
3. 它是否已被别的路径 resolve
4. 当前 response 到底是 current、late 还是 orphan

所以从源码可直接推出：

`没有 live pending ledger truth 的层，不配自称 receipt signer。`

## 5. `schema.parse` 说明 payload arrival 仍不等于 admissible receipt

`src/cli/structuredIO.ts:362-429` 处理 `control_response` 时并没有停在：

1. 找到 `request_id`
2. 然后直接 resolve

它还继续做了两层关键动作：

1. 根据 `subtype` 区分 `success / error`
2. 如果 request 挂了 schema，就在 receipt 边界执行 `schema.parse(result)`

这说明 Claude Code 的 receipt 不是：

`只要 request_id 对上就算签收。`

而是：

`request_id 对上，只证明 belonging；schema.parse 通过，才证明 admissibility。`

这层设计的哲学非常硬：

`签收权属于既懂“这是不是我的单”，又懂“这份回执在当前语法里是否合法”的层。`

这对 future cleanup design 的启示很直接：

1. cleanup receipt 不能只靠 generic success text
2. cleanup signer 必须同时持有 cleanup subtype grammar
3. 否则它只能观察回执抵达，不能正式签收回执

## 6. `notifyCommandLifecycle` 与 `onControlRequestResolved` 说明 receipt signer 还必须掌握 closure effect

`src/cli/structuredIO.ts:362-429` 在处理 `control_response` 时会先：

`notifyCommandLifecycle(uuid, 'completed')`

然后：

1. 删除 pending request
2. 对 `can_use_tool` 调用 `onControlRequestResolved`

而 `src/cli/structuredIO.ts:323-330,401-409` 的注释又明确写出：

`这个 resolved callback 用来通知 bridge 取消 claude.ai 上 stale permission prompt。`

这说明 receipt signer 不只是在决定：

`这条 response 合不合法`

它还在决定：

`一旦它合法，旧世界里哪些 surface 必须立刻撤场。`

因此真正的 receipt signer 还必须掌握：

1. lifecycle closure power
2. stale weak-surface teardown power

若缺这两者，  
该层即使看懂了 payload，  
也仍然不配说：

`receipt 已正式成立。`

因为它没有能力把 closure 的后果写回系统。

## 7. orphan reconciliation 说明弱层最多配做语义补偿，不配伪造正式签收

`src/cli/structuredIO.ts:374-399` 在找不到 `request_id` 时并没有直接宣布：

`这是垃圾。`

它会先：

1. 用 `resolvedToolUseIds` 吸收 duplicate late delivery
2. 再把剩余未知 response 交给 `unexpectedResponseCallback`

而 `src/cli/print.ts:5238-5305` 的 `handleOrphanedPermissionResponse()` 又继续做了更谨慎的补偿：

1. 检查 `toolUseID`
2. 防止 duplicate orphan 再处理
3. 去 transcript 里找 unresolved tool_use
4. 找到了才把它 enqueue 成 orphaned-permission

这里最值得注意的不是“系统很会补救”，  
而是它始终没有让 orphan observer 直接伪造：

`这条 receipt 已完整成立。`

它做的是：

`尝试把掉队回执重新接回一条仍然可解释的语义路径。`

所以从主权角度看：

`orphan reconciler 拥有的是 compensating handoff power，不是 original receipt sovereignty。`

## 8. 技术启示：下一代 cleanup receipt signer 至少要字段化什么

如果沿着 Claude Code 现有 receipt sovereignty 继续往前推，  
下一代 cleanup receipt signer 至少应显式字段化：

1. `receipt_owner`
   哪个 signer 层拥有正式签收权
2. `receipt_basis`
   它依赖哪本 pending ledger、哪组 schema、哪类 lifecycle truth
3. `receipt_scope`
   它签收的只是 arrival、admissibility，还是连 completion / teardown 一起签
4. `receipt_replaces`
   它成立后哪些 stale prompt、pending、warning、projection 必须撤场
5. `receipt_gap`
   当前还缺哪条 truth，因此最多只能说到哪一级 receipt

否则 cleanup design 依然会退回：

`有 response -> 看起来像成功 -> UI 自己收红字`

这正是成熟控制面最应该避免的伪闭环。

## 9. 用苏格拉底诘问法再追问一次

### 问：为什么“看到 response”不够？

答：因为看到 arrival 不等于知道它属于哪张活单，也不等于知道它在当前 schema 下可被接受。

### 问：为什么“request_id 对上了”仍然不够？

答：因为 request_id 只回答 belonging，不回答 admissibility，也不回答 closure effect。

### 问：为什么“schema.parse 通过了”还不够？

答：因为 parse 通过仍不等于旧世界 prompt、pending 与 lifecycle 已被正确撤场。

### 问：为什么 orphan reconciler 不该顺手拥有正式签收权？

答：因为它解决的是补偿性接回，不是原始 live request ledger 的 authoritative closure。

### 问：如果要把这套 receipt sovereignty 再提高一倍，最该补什么？

答：不是再加几条 success 文案，  
而是把 receipt owner、receipt basis、receipt scope 与 receipt gap 升格成正式协议字段，让弱层最多只能诚实地说出自己的 receipt ceiling。

## 10. 一条硬结论

真正成熟的 receipt signer 不是：

`先看到回信的人。`

而是：

`同时掌握活单账本、语法验收与闭环后果的人。`
