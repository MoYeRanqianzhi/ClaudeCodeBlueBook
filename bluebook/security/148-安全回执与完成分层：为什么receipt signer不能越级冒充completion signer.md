# 安全回执与完成分层：为什么receipt signer不能越级冒充completion signer

## 1. 为什么在 `147` 之后还必须继续写“回执与完成分层”

`147-安全回执签字权` 已经回答了：

`不是任何看到 response 的层都配宣布 receipt 成立；只有持有 live pending ledger、schema context 与 lifecycle closure 的 signer 才配正式签收。`

但如果再往前追问一步，  
还会碰到另一个极容易被混写的问题：

`就算 receipt signer 已经合法签收，这是否已经等于整个流程完成？`

Claude Code 源码给出的答案是否定的。

因为它同时存在：

1. `control_response`
2. `notifyCommandLifecycle(..., 'completed')`
3. `elicitation_complete`
4. orphaned permission reconciliation

这些信号若全被压成同一句：

`已经完成`

系统就会立刻退化成伪闭环。

所以 `147` 之后必须继续补的一层就是：

`安全回执与完成分层`

也就是：

`receipt signer 只配对“这张单已被合法接收并关账”签字；completion signer 才配对“这件事已经真正完成”签字。`

## 2. 最短结论

Claude Code 当前源码至少把“回执”与“完成”分成了三层不同对象：

1. request receipt  
   `control_response` 按 `request_id` 匹配原单并 resolve/reject  
   `src/cli/structuredIO.ts:362-429`
2. lifecycle completion  
   `notifyCommandLifecycle(..., 'completed')` 关闭命令级 lifecycle  
   `src/cli/structuredIO.ts:367-373`  
   `src/cli/print.ts:1998-2012,2244-2250`
3. semantic completion  
   `elicitation_complete` 明确宣告某个 elicitation 流程已真正走完  
   `src/cli/print.ts:1357-1379`

再叠加：

4. orphan reconciliation  
   某些晚到 response 还要先被补偿性接回语义路径，不能直接冒充 complete  
   `src/cli/structuredIO.ts:374-399`  
   `src/cli/print.ts:5238-5305`

这些证据合在一起说明：

`Claude Code 并不把“收到 response”“关掉 lifecycle”“真正完成语义流程”压成一个词。`

因此这一章的最短结论是：

`cleanup future design 若继续推进，也必须至少区分 cleanup_receipted、cleanup_lifecycle_closed 与 cleanup_completed，而不能让 receipt signer 越级冒充 completion signer。`

再压成一句：

`receipt 解决的是“这张单被接住了”，completion 解决的是“这件事真的做完了”。`

## 3. 第一性原理：为什么 receipt 永远不能自动等于 completion

从第一性原理看，  
一条控制面请求至少要跨过三个不同问题：

1. 它是否被正确接单
2. 它是否已退出当前在途状态
3. 它所代表的语义流程是否真正结束

这三问分别对应：

1. receipt
2. lifecycle completion
3. semantic completion

如果把三者压成同一句“完成了”，  
系统就会制造三类典型幻觉：

1. accept-as-done illusion  
   只要被接单就误当彻底完成
2. lifecycle-as-semantic illusion  
   只要命令 lifecycle 结束就误当语义流程终止
3. response-as-world-closure illusion  
   只要看到 response 就误当旧世界、弱表面与孤儿路径都已收口

所以从第一性原理看：

`completion 不是 response 的语气加强版，而是另一层 signer 的独立署名。`

## 4. `control_response` 只回答 receipt，不回答 full semantic completion

`src/cli/structuredIO.ts:362-429` 对 `control_response` 做了四件事：

1. 按 `request_id` 找原单
2. 删除 pending request
3. 按 `success/error` resolve/reject
4. 视需要做 `schema.parse()`

这条链足以证明：

`这张 request 被合法接住并关账。`

但它并不自动证明：

1. 更大流程已经完全结束
2. 所有外部参与者都已完成收尾
3. 所有弱表面都已同步撤场
4. 没有后续 completion signal 仍待发出

所以 `control_response` 的 ceiling 是：

`receipt truth`

而不是：

`full completion truth`

## 5. lifecycle completed 也只是中层签字，不等于语义完成

`src/cli/structuredIO.ts:367-373` 会在处理 `control_response` 时补：

`notifyCommandLifecycle(uuid, 'completed')`

而 `src/cli/print.ts:1998-2012,2244-2250` 也明确存在：

- `started`
- `completed`

这说明 Claude Code 很清楚：

`lifecycle close`

本身就是值得单独观测的一层。

但这层仍然不等于 full semantic completion。  
因为 lifecycle closed 只回答：

`这个命令级在途对象现在收口了没有`

却不自动回答：

`这项更大语义流程是否已经走到最终可宣布完成的状态`

因此 lifecycle signer 的上限是：

`command-level completion`

而不是：

`semantic-level completion`

## 6. `elicitation_complete` 直接证明 Claude Code 接受独立 completion signer

`src/cli/print.ts:1357-1379` 最关键的事实是：

Claude Code 没有满足于：

`既然已有 request/response，那就不再需要 completion notification。`

它反而专门注册了：

`ElicitationCompleteNotificationSchema`

收到后还会继续发出：

`system / elicitation_complete`

这说明源码作者明确接受一种更细的闭环哲学：

1. receipt 成立
2. 仍不等于 semantic completion
3. semantic completion 需要独立 signal

这对 future cleanup design 的启示非常直接：

某些 cleanup 若未来跨：

- host
- transport
- projection
- audit finalization

那它们极可能也应该有独立：

- `cleanup_complete`
- `cleanup_reconciled`
- `cleanup_audit_finalized`

这只是沿着现有 completion philosophy 做的推导，  
不是当前源码里已经存在这些 cleanup 事件。

## 7. orphan reconciliation 说明 even after receipt-like arrival，语义世界仍可能未闭环

`src/cli/structuredIO.ts:374-399` 与 `src/cli/print.ts:5238-5305` 最能说明：

`某条 response 已经 arrival`

仍然不自动等于：

`世界已经完成收口。`

因为 orphaned permission response 还必须继续经过：

1. duplicate guard
2. unresolved tool lookup
3. enqueue compensating handling

这说明即使 response 已到，  
系统仍然承认：

`当前语义世界可能还处在需要补偿接回的中间态。`

所以 orphan 路径从反面证明了：

`receipt-like arrival < receipt signer closure < semantic completion`

三者绝不能被压扁。

## 8. 技术启示：future cleanup protocol 至少要拆哪三层状态

如果沿着 Claude Code 当前的 completion layering 往前推，  
下一代 cleanup protocol 至少应拆成：

1. `cleanup_receipted`
   cleanup request 已被合法接单
2. `cleanup_lifecycle_closed`
   对应 cleanup command / operation 已退出在途状态
3. `cleanup_completed`
   更大语义流程已真正完成

必要时还应再补：

4. `cleanup_reconciled`
   orphan / late / duplicate cleanup signal 已完成补偿性收口
5. `cleanup_audit_finalized`
   最终审计材料已落定，可允许更强遗忘动作

否则系统极容易重新退回：

`一条 success 文案吃掉五层闭环`

这正是成熟控制面最该避免的伪完成。

## 9. 用苏格拉底诘问法再追问一次

### 问：为什么 `control_response` 不够？

答：因为它首先回答的是 request receipt，不是 full semantic completion。

### 问：为什么 `notifyCommandLifecycle(..., 'completed')` 也不够？

答：因为 lifecycle close 只说明这段命令级在途对象收口了，不自动证明更大语义流程已终结。

### 问：为什么 `elicitation_complete` 这么重要？

答：因为它直接证明 Claude Code 接受独立 completion signer，而不是把 completion 退化成 response 的附属语气。

### 问：orphan 路径为什么能证明 completion 必须分层？

答：因为 arrival 之后仍可能需要 transcript reconciliation；既然还要补偿接回，就说明世界尚未 full close。

### 问：如果要把这套 completion layering 再提高一倍，最该补什么？

答：不是再加几条绿色文案，  
而是把 receipt、lifecycle、completion、reconciliation、audit-finalization 的 ceiling 分别字段化，让每层 signer 只能说出自己的 truth ceiling。

## 10. 一条硬结论

真正成熟的完成语义不是：

`我已经收到回执，所以事情做完了。`

而是：

`我知道谁签了 receipt，也知道谁才配签 full completion。`
