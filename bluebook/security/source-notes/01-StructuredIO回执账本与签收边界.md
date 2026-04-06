# StructuredIO回执账本与签收边界

## 1. 为什么单开这一篇源码剖面

安全主线写到 `146-147` 时，  
一个越来越核心的问题浮出来了：

`Claude Code 到底凭什么判断某条 control_response 现在算正式 receipt？`

这个问题如果只停在主线长文里，  
很容易被压成抽象话术。  
所以这里单开一篇，只盯住：

- `src/cli/structuredIO.ts`
- `src/cli/print.ts`

把回执账本、签收边界、duplicate/orphan 处理与 stale-world teardown 拆给源码本身说话。

## 2. 先给最短判断

这组代码最重要的技术事实不是：

`Claude Code 能处理 control_response。`

而是：

`Claude Code 把 receipt 组织成了一条小型协议：pending ledger -> matching -> schema admissibility -> lifecycle close -> stale-world teardown -> orphan compensation。`

这说明 receipt 在这里不是一条普通消息，  
而是一次：

`对 request truth 的正式关账。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| pending ledger | `src/cli/structuredIO.ts:135-158,510-529` | 谁掌握 live request truth |
| receipt parse | `src/cli/structuredIO.ts:362-429` | 到达的 response 怎样从 arrival 变成 admissible receipt |
| stale prompt teardown | `src/cli/structuredIO.ts:323-330,401-409` | stronger signer 签收后如何驱逐旧世界 prompt |
| duplicate / orphan handling | `src/cli/structuredIO.ts:374-399` | 未知、重复、晚到 response 如何避免污染 current world |
| orphan compensation | `src/cli/print.ts:5238-5305` | orphaned permission 怎样被语义补偿地重新接回 |
| completion notification | `src/cli/print.ts:1357-1379` | 为什么有些闭环还需要独立 completion signer |
| lifecycle observability | `src/cli/structuredIO.ts:367-373`; `src/cli/print.ts:1998-2012,2244-2252` | 为什么 receipt 不只 resolve promise，还要关闭 lifecycle |

## 4. `pendingRequests` 不是缓存，而是活单账本

`StructuredIO` 一开始就声明了：

- `pendingRequests`
- `resolvedToolUseIds`
- `unexpectedResponseCallback`
- `onControlRequestResolved`

最关键的是 `pendingRequests`。  
它不只是一个等待 Promise 的技术容器，  
而是一张活单账本。

因为 `sendRequest()` 写入的不只是：

- `request_id`
- `resolve/reject`

还包括：

- 原始 request
- 可选 schema

这意味着：

`receipt signer` 在这里首先是 ledger owner。

没有这张账本，  
系统只能知道“有一条 response 到了”，  
却不知道：

1. 这张单是否仍然活着
2. 它是否已经被 abort
3. 当前 response 是不是晚到回声

## 5. `control_response` 处理链说明 arrival 不是 receipt

`processLine()` 处理 `control_response` 的顺序非常值得注意：

1. 若 payload 里有 `uuid`，先 `notifyCommandLifecycle(..., 'completed')`
2. 用 `request_id` 去找 pending request
3. 找不到时先检查 duplicate，再走 unexpected/orphan 路径
4. 找到了才继续删除 pending
5. 再根据 `subtype` 走 `error` 或 `success`
6. 若 request 带 schema，再执行 `schema.parse(result)`

这个顺序说明 Claude Code 的 receipt 不是“消息到达即可”，  
而至少要跨过三道窄门：

1. belonging
2. admissibility
3. closure

只要任何一门没过，  
这条 response 就还不是正式 signed receipt。

## 6. `resolvedToolUseIds` 说明系统在防“第二次签收”

源码里还有一个很容易被忽略、但非常高级的小设计：

`resolvedToolUseIds`

注释写得很直接：

`duplicate control_response deliveries` 会把同一 tool_use 再次推回对话，  
继而制造 duplicate assistant messages，最终导致 API 400。

这意味着系统真正防的不是“重复日志不好看”，  
而是：

`旧世界回音冒充第二次正式签收。`

因此 `resolvedToolUseIds` 的哲学本质是：

`once-receipted, no second receipt`

也就是：

`正式签收一旦成立，重复 arrival 只能被吸收，不能重写当前真相。`

## 7. `onControlRequestResolved` 说明签收后果必须写回旧世界

`onControlRequestResolved` 这条 hook 很重要。  
它的语义不是“再发一个成功事件”，  
而是：

`stronger signer 已接单，旧世界里的 stale prompt 该撤了。`

这让我们看到一个更硬的技术事实：

`receipt authority` 不只包含“我配判断这条回执是否成立”，  
还包含“我配让哪些旧 surface 因此闭嘴”。

如果没有这层后果写回，  
系统就会同时保留：

1. 已签收的 current world
2. 未撤场的 stale world

最终重新制造 projection split-brain。

## 8. orphan 路径说明补偿性接回不等于原始签收主权

当 `request_id` 找不到时，  
系统先走 `unexpectedResponseCallback`，  
再在 `print.ts` 里用：

- `toolUseID`
- unresolved tool lookup
- duplicate orphan guard

把 orphaned permission 重新接回一条可解释路径。

这里最值得记住的一条线是：

`系统愿意补救 orphan，但不允许 orphan observer 直接伪造正式签收。`

换句话说：

- orphan reconciler 有 compensating power
- 但 original receipt sovereignty 仍属于 live pending ledger owner

这是未来 cleanup 设计非常值得复用的一条边界。

## 9. completion notification 说明某些签收还分成两段

`print.ts` 里的 `elicitation_complete` 进一步证明：

有些流程不只需要 receipt，  
还需要独立 completion signer。

这意味着 Claude Code 当前已经默认接受一种更细的闭环模型：

1. request sent
2. receipt admitted
3. completion declared

这条模型对 future cleanup design 的技术启示很直接：

如果某类 cleanup 未来真的涉及跨 host、跨 transport、跨 projection 的异步收尾，  
那么它很可能也不该只靠同步 `success` 回执，  
而应拥有独立 completion event。

## 10. 这篇源码剖面给主线带来的三条技术启示

### 启示一

真正的 receipt signer 至少同时掌握：

- live pending truth
- subtype grammar truth
- lifecycle closure truth

### 启示二

duplicate absorption 与 orphan compensation 不是边角修补，  
而是防止旧世界二次改口的正式控制面能力。

### 启示三

stale-world teardown 不属于 UI 美化层，  
它属于 receipt 成立后的正式后果写回。

## 11. 一条硬结论

这组源码真正先进的地方不是“回执很多”，  
而是它已经把：

`回执属于谁、回执靠什么成立、回执成立后谁必须让位`

这三件事放进了同一条小协议里。
