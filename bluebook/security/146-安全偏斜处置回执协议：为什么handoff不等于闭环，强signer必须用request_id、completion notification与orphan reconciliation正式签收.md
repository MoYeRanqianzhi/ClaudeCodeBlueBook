# 安全偏斜处置回执协议：为什么handoff不等于闭环，强signer必须用request_id、completion notification与orphan reconciliation正式签收

## 1. 为什么在 `145` 之后还必须继续写“处置回执协议”

`145-安全偏斜处置移交协议` 已经回答了：

`当弱层先看到 skew 而自己又没有对应算子主权时，它不应越权执行，而应通过 abstain、forward、rerun-full-gate 或 adapter-internalize 把权交给更强 signer。`

但如果继续追问，  
还会碰到一个更靠近工程闭环的问题：

`移交以后，弱层如何知道更强 signer 真的收到了、处理了、拒绝了，还是已经掉进了沉默黑洞？`

因为 handoff 本身只解决：

`话筒交出去了`

却没有回答：

`台上的人有没有真正接住、说完、或者明确拒绝接。`

如果这里没有正式回执协议，  
系统就会立刻退化成：

1. 弱层以为强层会处理
2. 强层以为弱层会继续等
3. 中途掉线、重复、孤儿响应没人兜底
4. 最后所有人都以为“应该差不多完成了”

所以 `145` 之后必须继续补的一层就是：

`安全偏斜处置回执协议`

也就是：

`成熟安全系统不仅要求弱层把处置权交出去，还要求强 signer 用可追踪的 receipt、completion 与 orphan reconciliation 把这次接单正式签收。`

## 2. 最短结论

Claude Code 当前源码已经展示出至少五种与“回执闭环”直接相关的机制：

1. `request_id` + `pendingRequests`  
   handoff 不是 fire-and-forget，而是进入显式待签收账本  
   `src/cli/structuredIO.ts:135-158,510-529`
2. `control_response`  
   强 signer 以 `request_id` 回执 success / error，并关闭 request lifecycle  
   `src/cli/structuredIO.ts:362-429`
3. `onControlRequestResolved`  
   一个 signer 接单成功后，还会通知另一个弱层撤掉 stale prompt  
   `src/cli/structuredIO.ts:323-330,401-409`
4. `elicitation_complete` notification  
   有些闭环不只靠 response，还靠 completion notification 明确签收完成  
   `src/cli/print.ts:1357-1379`
5. `unexpectedResponseCallback` + `handleOrphanedPermissionResponse`  
   即使回执晚到、重复、孤儿化，系统也不直接丢弃，而要尝试 reconcile  
   `src/cli/structuredIO.ts:374-399`  
   `src/cli/print.ts:5241-5303`

这些证据合在一起说明：

`Claude Code 的 handoff 不是“把权交出去就算完”，而是“把权交出去以后，还必须有 receipt、completion 与 orphan recovery 一起守住闭环”。`

因此这一章的最短结论是：

`cleanup future design 若继续推进，除了 field matrix、operator matrix、authority matrix 与 handoff matrix，还必须有 receipt matrix，明确 request_id、completion signal、late response、duplicate response 与 orphaned completion 该如何被正式签收。`

再压成一句：

`没有回执的移交，不叫闭环，只叫希望。`

## 3. 第一性原理：为什么真正的移交闭环不只需要“交付”，还需要“签收”

如果一个系统说：

`我已经把请求发出去了。`

这不等于：

`这次处置已经完成了。`

从第一性原理看，  
一个真正的控制面闭环至少要有三层动作：

1. dispatch  
   请求被发出
2. receipt  
   目标 signer 明确接单或拒单
3. completion  
   目标 signer 明确宣布处理完成、处理失败或需要补偿

缺其中任何一层，  
系统都会陷入不同类型的幻觉：

1. 没有 receipt  
   dispatch illusion
2. 没有 completion  
   in-flight forever illusion
3. 没有 orphan recovery  
   dropped-world illusion

所以从第一性原理看：

`handoff protocol 解决的是“谁来处理”，receipt protocol 解决的则是“处理这件事有没有被正式签收”。`

## 4. `pendingRequests` 说明 Claude Code 不把移交当成 fire-and-forget

`src/cli/structuredIO.ts:135-158` 一开始就说明：

1. 所有待回执的 control request 都进入 `pendingRequests`
2. `request_id` 是主键
3. `resolvedToolUseIds` 又单独记录已经被正常权限流处理过的 tool_use

到 `src/cli/structuredIO.ts:510-529`，  
每次发送 control request 时都会：

1. 生成 `request_id`
2. 把 request / resolve / reject / schema 放进 `pendingRequests`
3. finally 再清理这个请求

这说明 Claude Code 的哲学不是：

`我把消息丢给下游就算完。`

而是：

`我把消息交给下游后，还要把它挂进账本，直到被明确 resolve / reject / abort。`

对 cleanup future design 的直接启示是：

1. cleanup handoff 若未来存在
2. 不应只是一条临时事件
3. 更合理的是进入某种 pending cleanup ledger

## 5. `control_response` 是标准 receipt，不只是“回了一条消息”

`src/cli/structuredIO.ts:362-429` 展示了 Claude Code 最典型的 receipt protocol：

1. 收到 `control_response`
2. 先 `notifyCommandLifecycle(uuid, 'completed')`
3. 再用 `request_id` 去 `pendingRequests` 里找原单
4. 找到后删除待处理项
5. 根据 `subtype` 决定 reject 还是 resolve
6. 若有 schema，还会在 receipt 边界做 `schema.parse(result)`

这说明 `control_response` 在这里承担的不是普通消息语义，  
而是：

`正式签收语义`

它同时完成了三件事：

1. 匹配原单
2. 给出 verdict
3. 关闭 lifecycle

所以从控制面角度看：

`request_id + control_response` 就是一套最小 receipt protocol。

## 6. `onControlRequestResolved` 说明一个 signer 的签收会触发另一个弱层撤场

`src/cli/structuredIO.ts:323-330` 定义了：

`setOnControlRequestResolved(callback)`

注释写得很清楚：

1. 当 `can_use_tool` 的 control_response 从 SDK consumer 回来
2. 这个 callback 会被调用
3. 用途是通知 bridge 取消 claude.ai 上那个 stale permission prompt

到 `src/cli/structuredIO.ts:401-409`，  
如果当前请求确实是 `can_use_tool`，  
这个 resolved callback 会在真正 receipt 之后触发。

这说明 Claude Code 的闭环不只关心：

`强 signer 有没有接单`

还关心：

`一旦强 signer 已签收，旁边那些旧世界里还挂着的弱表面是否必须同时撤场。`

这对 cleanup future design 非常重要。  
未来 cleanup signer 一旦签收成功，  
也应明确：

1. 哪些 stale notification 要撤
2. 哪些旧 pending 状态要取消
3. 哪些弱 surface 需要同步改口

## 7. `completion notification` 说明有些闭环不能只靠 response，还要靠显式完成事件

`src/cli/print.ts:1357-1379` 展示了另一种更强的签收模式：

1. MCP client 注册 `ElicitationCompleteNotificationSchema`
2. 收到 completion notification 后
3. 会执行 notification hooks
4. 再输出一个正式的 `system` message：
   `subtype: 'elicitation_complete'`
   携带 `mcp_server_name`
   `elicitation_id`
   `uuid`
   `session_id`

这说明 Claude Code 并不把所有闭环都压成：

`一次 request + 一次 response`

而是承认：

`某些流程需要独立的 completion signer。`

这类 completion notification 的价值在于：

1. 它不只是 verdict
2. 它是“流程已真正走完”的显式签字

对 cleanup future design 的启示是：

某些 cleanup 未来也许不应只靠同步 response 宣布完成，  
而更应该拥有：

1. `cleanup_complete`
2. `cleanup_reconciled`
3. `cleanup_audit_finalized`

这只是沿着现有 completion notification 哲学做的推导，  
不是当前源码中已经存在 cleanup notification。

## 8. `unexpectedResponseCallback` 与 orphan reconciliation 说明 Claude Code 不把晚到回执直接当垃圾

### 8.1 StructuredIO 不直接把未知 response 扔掉，而是给它一次补救路径

`src/cli/structuredIO.ts:374-399` 在 `request_id` 找不到时并没有立刻宣告世界结束：

1. 先检查这是否只是 duplicate delivery
2. 若已 resolvedToolUseIds 包含这个 toolUseID，就忽略
3. 否则如果存在 `unexpectedResponseCallback`
4. 就把这个 response 交给它

这说明 Claude Code 承认：

`某些回执虽然已经脱离了原 pending ledger，但仍可能值得被补偿性接住。`

### 8.2 `handleOrphanedPermissionResponse` 就是那条补偿性接单路径

`src/cli/print.ts:5241-5303` 则把这条 orphan 路彻底写实了：

1. 只处理 success + `toolUseID`
2. 先避免 duplicate orphan 重处理
3. 再尝试在 transcript 里找到 unresolved `tool_use`
4. 找到后把这次 orphaned permission 入队
5. 后续由专门的 `orphaned-permission` 模式去处理

这非常关键。  
因为它说明 Claude Code 对 orphan receipt 的哲学不是：

`账本里没有就当垃圾。`

而是：

`账本里没了，但若还能恢复语义上下文，就要补偿性 reconcile。`

## 9. 生命周期回执说明：receipt 不只给业务逻辑看，还要给控制台看

`src/cli/print.ts:2006-2008` 会在 batch 执行前：

1. `notifyCommandLifecycle(uuid, 'started')`

`src/cli/print.ts:2248-2250` 则在 batch 结束后：

1. `notifyCommandLifecycle(uuid, 'completed')`

再结合 `src/cli/structuredIO.ts:367-373`，  
`control_response` 也会在带 uuid 时触发 completed lifecycle。

这说明 Claude Code 的 receipt protocol 还有一层更细的目标：

`不仅让业务 promise resolve/reject，还让控制台/生命周期系统同步获得 started-completed 签收。`

所以在设计上，它已经把“回执”从纯数据流推进到了“可观测 lifecycle”。

## 10. 一张更完整的 receipt protocol

综合以上源码，可以把 Claude Code 当前的 receipt grammar 压成这样：

1. request enters pending ledger via `request_id`
2. stronger signer returns `control_response`
3. lifecycle gets explicit `started/completed`
4. some flows additionally require completion notification
5. late / duplicate / orphan responses go through reconciliation logic
6. resolved receipt may trigger stale weak-surface teardown

这张表说明：

`Claude Code 的闭环不是单点回包，而是一套 receipt + completion + reconciliation 的复合协议。`

## 11. 对 cleanup future design 的直接启示

cleanup future rollout 若继续往前推，  
最值得补的一张协议图已经很明确：

1. cleanup_request_id
2. cleanup_pending_ledger
3. cleanup_response / cleanup_error
4. cleanup_complete notification
5. orphaned cleanup receipt reconciliation
6. resolved cleanup -> stale weak surface teardown

这些对象都是沿着现有 receipt 哲学做的推导，  
不是当前源码里已经存在 cleanup receipt protocol。

## 12. 我们当前能说到哪一步，不能说到哪一步

基于当前可见源码，  
我们可以稳妥地说：

1. Claude Code 已经拥有相当成熟的 receipt / completion / orphan reconciliation 机制
2. handoff 在这里并不是 fire-and-forget，而是被挂进 request_id 与 lifecycle 账本里继续追踪

但我们不能说：

1. cleanup receipt protocol 已经正式存在
2. cleanup completion notification 已经被工程化实现

所以这一章的结论必须压在：

`Claude Code 已展示出从 handoff 继续推进到 receipt protocol 的工程哲学；cleanup future design 若继续成熟，下一步最值得补的就是这张 receipt matrix。`

## 13. 苏格拉底式追问：如果这章还要继续提高标准，还缺什么

还可以继续追问六个问题：

1. cleanup complete 到底该是 response 还是独立 notification
2. cleanup orphan receipt 的重放窗口与去重键应如何设计
3. cleanup receipt 是否需要单独 audit ID 以便和 action ledger 对齐
4. lifecycle `started/completed` 是否足够，是否还需要 `acknowledged/reconciled`
5. resolved cleanup receipt 后，哪些 stale surface 必须同步撤场
6. conformance tests 是否应覆盖 orphaned cleanup response 的补偿性接单

这些问题说明：

`145` 解决的是“话筒如何交出去”，`146` 解决的则是“交出去以后，谁来明确说一句‘我接住了，而且我已经处理完了’”。`
