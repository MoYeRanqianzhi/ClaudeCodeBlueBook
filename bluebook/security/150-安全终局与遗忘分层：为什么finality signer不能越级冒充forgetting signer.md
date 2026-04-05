# 安全终局与遗忘分层：为什么finality signer不能越级冒充forgetting signer

## 1. 为什么在 `149` 之后还必须继续写“终局与遗忘分层”

`149-安全完成与终局分层` 已经回答了：

`completion signer 只能对当前流程结束签字；finality signer 才配对“结果已被持久化并可被未来世界重新读回”签字。`

但如果继续追问，  
还会碰到最后一层更危险的跳跃：

`就算 finality 已成立，这是否已经等于系统现在就配忘记旧痕迹？`

Claude Code 源码给出的答案仍然是否定的。

因为它在多个表面都坚持了一条更硬的边界：

1. notification 当前项与队列，只能按 queue owner 的 timeout / invalidation / remove 规则清
2. `needsRefresh` 只能由 `refreshActivePlugins()` 正式消费，弱提示层明确不得 reset
3. bridge pointer 只在 stale / env gone / fatal reconnect 时清，transient 与 resumable 场景反而必须保留

这说明系统并不把：

`世界已经可被未来读回`

直接压成：

`旧痕迹现在就可以合法遗忘。`

所以 `149` 之后必须继续补的一层就是：

`安全终局与遗忘分层`

也就是：

`finality signer 只能证明真相已经成立；forgetting signer 才配决定哪些旧痕迹现在可以被安全抹除。`

## 2. 最短结论

Claude Code 当前源码至少展示了三类“finality 仍不等于 forgetting”边界：

1. notification trace  
   只有 notification queue owner 才能通过 timeout / invalidates / remove 收口  
   `src/context/notifications.tsx:45-75,193-214`
2. plugin refresh trace  
   `useManagePlugins` 明确禁止弱层 auto-refresh / reset `needsRefresh`，只有 `refreshActivePlugins()` 才消费它  
   `src/hooks/useManagePlugins.ts:292-304`  
   `src/utils/plugins/refresh.ts:62-76,123-136`
3. bridge recovery asset  
   pointer 只在 stale / env gone / fatal reconnect 时清，resumable / transient 场景必须保留  
   `src/bridge/bridgeMain.ts:1568-1578,2384-2405,2528-2540`

再叠加：

4. auto-refresh fallback  
   如果自动刷新失败，系统宁可把 `needsRefresh` 重新立起来，也不伪造 forgetting  
   `src/services/plugins/PluginInstallationManager.ts:146-166`

这些证据合在一起说明：

`Claude Code 不把“真相已经成立”直接推导成“旧痕迹现在可以删”；它坚持由更窄、更专门的 forgetting owner 决定何时遗忘。`

因此这一章的最短结论是：

`cleanup future design 若继续推进，不只要有 cleanup_restorable，还至少要有 cleanup_forget_allowed；finality signer 不能越级冒充 forgetting signer。`

再压成一句：

`真相成立，不等于记忆可以被删除。`

## 3. 第一性原理：为什么“能重读”仍不等于“可遗忘”

从第一性原理看，  
系统对某件事说“已 final”，  
回答的是：

`以后回来还能把它当真吗？`

但系统对某件事说“现在可以 forget”，  
回答的是另一问：

`删掉旧痕迹后，还会不会损害后续解释、重试、修复或追责？`

所以 finality 与 forgetting 回答的是两种不同问题：

1. truth preservation
2. trace disposal

如果把两者压成同一个 green state，  
系统就会制造三类典型幻觉：

1. persisted-means-disposable illusion  
   既然已持久化，就误当旧痕迹可删
2. final-means-harmless illusion  
   既然已 final，就误当残余风险已消失
3. future-readable-means-no-longer-needed illusion  
   既然未来还能读回，就误当当前 trace 可以安全蒸发

所以从第一性原理看：

`forgetting 不是 finality 的附属动作，而是另一层主权。`

## 4. notification queue 说明 even low-stakes surface 也有独立 forgetting owner

`src/context/notifications.tsx:45-75,193-214` 非常清楚：

1. 当前通知靠 queue owner 的 `processQueue()` 推进
2. 过期靠 `timeoutMs`
3. 替换靠 `invalidates`
4. 主动移除靠 `removeNotification(key)`

这说明 notification trace 的 forgetting power 从来不属于：

`任何看到 green state 的层`

而只属于：

`管理这条队列的人。`

从哲学上看，这很重要。  
因为即使是最轻量的 UI trace，  
Claude Code 也不接受：

`看到新状态 -> 顺手把旧提示擦掉`

它要求：

`按 owner / timeout / invalidation grammar 来忘记。`

## 5. `needsRefresh` 说明弱层看到 finality 也不配消费旧 trace

`src/hooks/useManagePlugins.ts:292-304` 写得几乎像一条宪法：

`Do NOT auto-refresh. Do NOT reset needsRefresh`

这说明 `useManagePlugins` 这个弱提示层很清楚自己的 ceiling：

1. 它可以提示
2. 它不配消费 `needsRefresh`

而 `src/utils/plugins/refresh.ts:62-76,123-136` 又明确：

1. `refreshActivePlugins()` 才真正消费 `plugins.needsRefresh`
2. 消费的同时会清 cache、重建状态，并把 `needsRefresh: false`

这意味着在插件路径上：

`finality signer` 和 `forgetting signer` 被显式拆开了。

弱层看到：

`某些结果似乎已经稳定`

仍然不配做：

`把 pending refresh trace 擦掉`

## 6. auto-refresh failure fallback 说明系统宁可保留旧痕迹，也不愿伪造合法遗忘

`src/services/plugins/PluginInstallationManager.ts:146-166` 进一步把这条边界写得更硬：

1. 尝试 `refreshActivePlugins()`
2. 若失败
3. 就 fallback 到 `needsRefresh: true`

这说明源码作者宁可：

`把旧 trace 重新立起来`

也不愿意说：

`既然我试过了，那就算忘掉它吧。`

这正是 forgetting sovereignty 最关键的地方：

`忘记不是“已经努力过”的奖励，而是“闭环被正确消费”的结果。`

## 7. bridge pointer 说明高价值恢复资产的 forgetting gate 更高

`src/bridge/bridgeMain.ts:1568-1578` 说明：

1. 环境真正 gone
2. pointer 已会 stale
3. 这时才 clear pointer

而 `src/bridge/bridgeMain.ts:2384-2405` 又说明：

1. session gone on server
2. 或 environment_id 缺失
3. 才清掉 resume pointer

最关键的是 `src/bridge/bridgeMain.ts:2528-2540`：

1. fatal reconnect failure 才清 pointer
2. transient failure 反而要保留 pointer
3. 因为“下次再试”本身就是 retry mechanism

这说明在高价值恢复资产上，  
系统更明确地区分：

1. truth 已改变
2. 资产是否仍对后续修复有用

也就是说：

`即使当前并不漂亮，只要未来重试仍依赖它，它就不配被 forget。`

## 8. 技术启示：future cleanup protocol 至少要继续拆哪三层 forgetting 词法

如果沿着 Claude Code 当前的 forgetting sovereignty 往前推，  
下一代 cleanup protocol 至少应继续拆成：

1. `cleanup_final`
   真相已成立，可被未来重读
2. `cleanup_trace_retained`
   旧痕迹必须继续保留，服务后续解释/修复/追责
3. `cleanup_forget_allowed`
   对应 owner 已确认旧 trace 可被安全移除

必要时还应再补：

4. `cleanup_retry_asset_retained`
   恢复资产仍然要留作下次重试
5. `cleanup_projection_hidden_only`
   仅允许从弱表面隐藏，不等于正式删除

否则系统极容易退回：

`一个 final 吃掉 trace retention、retry asset preservation 与 lawful forgetting`

这会让控制面重新滑回伪遗忘。

## 9. 用苏格拉底诘问法再追问一次

### 问：为什么 notification queue 重要？它不是小 UI 吗？

答：正因为它是最小 trace，它仍然要靠 owner / timeout / invalidation 才能忘记，这恰好证明 forgetting 是主权，不是顺手动作。

### 问：为什么 `needsRefresh` 这么关键？

答：因为源码明写了弱提示层不配 reset 它；如果弱层都能消费旧 trace，那就没有 forgetting sovereignty 可言。

### 问：为什么 bridge pointer 是更强的例子？

答：因为它不仅是旧痕迹，还是未来 retry asset。只要 retry 仍依赖它，finality 也不能越级要求把它删掉。

### 问：如果系统已经 future-readable，为什么还不能忘？

答：因为 forgetting 还要回答“删掉后会不会损害修复、追责和解释”，而这不是 finality signer 的职责。

### 问：如果要把这套 forgetting layering 再提高一倍，最该补什么？

答：不是再多写几句“已恢复”，  
而是把 final、trace-retained、forget-allowed、retry-asset-retained 的 ceiling 分别字段化，让不同 owner 只消费自己配消费的旧痕迹。

## 10. 一条硬结论

真正成熟的遗忘语义不是：

`既然已经 final，就把旧东西删了。`

而是：

`只有当旧痕迹不再服务未来判断时，它才配被忘记。`
