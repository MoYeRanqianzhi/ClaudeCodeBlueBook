# 安全恢复留痕纪律：为什么auto-close失败、transient failure与人工确认挂起都必须保留可重试痕迹

## 1. 为什么在 `55` 之后还要继续写“恢复留痕纪律”

`55-安全恢复自动验证门槛` 已经回答了：

`只有当系统同时拥有动作、读回和 signer 主权时，才配 auto-close；否则必须停留在人工确认态。`

但如果继续往下一层追问，  
还会出现一个更微妙却更重要的问题：

`当 auto-close 失败、transient failure 出现，或者系统已经退回人工确认态之后，这些“未闭环的恢复”是否会被继续保留下来？`

因为如果控制面在这里做错，  
即便它前面所有判断都正确，  
最后仍会在状态面上制造一种非常危险的假象：

1. 它没有真恢复
2. 但失败痕迹被静默抹掉了
3. 用户再回来时看不到需要继续完成的修复
4. 于是未解决的问题被系统伪装成“已经过去”

所以在 `55` 之后，  
统一安全控制台还必须再补一条制度：

`恢复留痕纪律。`

也就是：

`任何未闭环的恢复，都必须留下可重试、可追溯、可再次进入的痕迹，而不是随着超时、页面关闭或一次失败静默消失。`

## 2. 最短结论

从源码看，Claude Code 已经在多个地方非常明确地选择了：

`保留痕迹，而不是假忘记。`

最典型的证据有五类：

1. plugin auto-refresh 失败后，显式回退到 `needsRefresh=true`  
   `src/services/plugins/PluginInstallationManager.ts:146-165`
2. `/reload-plugins` 路径明确要求“Do NOT reset needsRefresh”  
   `src/hooks/useManagePlugins.ts:288-303`
3. MCP automatic reconnection 会保留 `pending`、`reconnectAttempt`、`maxReconnectAttempts`，并在最终失败时落成 `failed`  
   `src/services/mcp/useManageMCPConnections.ts:387-442,453-460`
4. bridge transient reconnect failure 明确保留 pointer，要求用户重试  
   `src/bridge/bridgeMain.ts:2524-2539`
5. crash-recovery pointer 会立即写入并按小时刷新，保证长会话或二次崩溃后仍有 trail  
   `src/bridge/bridgeMain.ts:2700-2728`

所以这一章的最短结论是：

`成熟控制面不只知道什么时候不能自动关环，还知道未关上的环必须留下什么痕迹。`

我会把这条结论再压成一句话：

`未完成的恢复必须可见地遗留，而不是礼貌地消失。`

## 3. 源码已经清楚表明：Claude Code 更倾向于“保留未闭环痕迹”

## 3.1 plugin auto-refresh 失败不会假装没事，而是显式回退到 `needsRefresh`

`src/services/plugins/PluginInstallationManager.ts:146-165` 很关键。  
当 auto-refresh 失败时，代码并没有：

1. 吞掉错误
2. 清掉告警
3. 假装用户稍后自己会知道

相反，它会：

1. `logError(refreshError)`
2. debug 记录 `Auto-refresh failed`
3. `clearPluginCache(...)`
4. `setAppState(... needsRefresh: true)`

这说明在作者眼里，  
auto-close 失败后的正确行为不是：

`把自动化做过的痕迹藏起来`

而是：

`把系统重新推回一个用户可见、可再次修复的挂起态。`

这就是恢复留痕纪律最直接的一种实现。

## 3.2 `/reload-plugins` 路径明确要求“不要自动抹掉待修复状态”

`src/hooks/useManagePlugins.ts:288-303` 里有一句特别重要：

`Do NOT auto-refresh. Do NOT reset needsRefresh — /reload-plugins consumes it via refreshActivePlugins().`

这句话几乎可以直接上升成控制面公理。  
因为它在明确表达：

1. 当前还有未闭环恢复
2. 这个挂起状态不能被自动清掉
3. 只能由正确的 repair path 真正消费它

这说明 `needsRefresh` 在这里不是普通 UI 标志，  
而是：

`未闭环恢复的持久痕迹。`

## 3.3 MCP automatic reconnection 会把失败过程显式外化成状态，而不是悄悄重试到忘记

`src/services/mcp/useManageMCPConnections.ts:387-442,453-460` 展示了另一种很成熟的留痕策略。

在 automatic reconnection 过程中，系统会：

1. 先把 server 状态标成 `pending`
2. 写入 `reconnectAttempt`
3. 写入 `maxReconnectAttempts`
4. 每轮失败后继续 backoff
5. 最终成功则收敛到 connected
6. 最终失败则显式落成 `failed`

这说明在作者看来，  
重试过程本身也是控制面状态的一部分。  
它不该被隐藏成：

`要么瞬间成功，要么什么都没发生`

而应该被外化成：

`当前正在重试第几次、还剩多少次、最后是否放弃。`

这正是成熟系统与“悄悄重试一会儿然后无声失败”的系统之间的根本区别。

## 3.4 bridge reconnect 的 transient 失败会故意保留 pointer，确保用户还能回来

`src/bridge/bridgeMain.ts:2524-2539` 是这一章最有力的证据之一。  
这里明确写出：

1. transient reconnect failure 不应 deregister
2. fatal 才清 pointer
3. transient failure 必须“keep the pointer”
4. 这样下次启动还能重试

并且直接把用户指向：

`try running the same command again`

这说明对 bridge 域来说，  
作者不是把“失败重试”看成一次性事件，  
而是看成：

`一个必须跨进程、跨时间保留下来的恢复 trail。`

如果没有这个 pointer，  
控制面即使知道这次失败是 transient，  
用户下次回来时也等价于：

`什么都不知道。`

## 3.5 crash-recovery pointer 甚至会主动刷新，防止“留痕本身过期”

`src/bridge/bridgeMain.ts:2700-2728` 更进一步。  
这里不只是在出事后被动保留 pointer，  
而是在 session 正常运行时就：

1. 立即写 pointer
2. 每小时刷新一次
3. 保证长会话 crash 后仍有 fresh trail

这一点非常先进。  
因为它说明作者已经意识到：

`留痕如果不持续保鲜，最终仍会变成失效留痕。`

也就是说，  
恢复控制面真正要保留的不是某条“历史记录”，  
而是：

`一条仍然可用于恢复的活痕迹。`

## 3.6 通知系统本身也说明：痕迹删除必须是显式动作

`src/context/notifications.tsx:78-116,193-212` 再次证明一件事：

1. 通知不会因为“系统也许大概好了”就自己消失
2. 删除要么靠 timeout 到点
3. 要么靠 `invalidates`
4. 要么靠显式 `removeNotification`

这说明哪怕在最表层的 UI 提示层，  
Claude Code 也已经在坚持：

`痕迹的消失必须有明确原因。`

这条思路完全可以继续上升到更高层恢复状态对象。

## 4. 第一性原理：忘记失败，本身就是一种伪恢复

如果从第一性原理追问：

`为什么恢复失败后的留痕也要上升成一条安全原则？`

因为控制面的根本任务不是让界面看起来干净，  
而是：

`让未解决问题继续保持可被解决。`

一旦系统把未闭环恢复静默抹掉，  
它就在做两件危险的事：

1. 让用户失去继续修复的入口
2. 把未解决问题伪装成已经过去

所以恢复留痕纪律真正保护的是这条公理：

`任何未闭环恢复都必须保持再次进入的可能性。`

这句话也可以压成更短的一句：

`未完成修复必须可回访。`

## 5. 我给统一安全控制台的恢复留痕纪律

我会把它分成四条规则。

## 5.1 auto-close 失败时，必须退回挂起态，而不是清空状态

例如：

1. plugin auto-refresh 失败  
   -> 回退到 `needsRefresh`
2. 自动重连失败  
   -> 落成 `failed`

也就是说，  
系统应从：

`attempted`

退回到：

`pending` / `failed` / `manual confirmation required`

而不是退回到：

`nothing happened`

## 5.2 transient failure 必须保留可重试锚点

例如：

1. bridge pointer
2. reconnect attempt counter
3. pending status

这类对象的真正作用不是记录历史，  
而是：

`告诉系统和用户：这条恢复链还可以从哪里重新进入。`

## 5.3 留痕必须比通知寿命更长

通知可以超时、被覆盖、被替换。  
但未闭环恢复的核心状态不应只寄存在通知层。

否则一旦通知消失，  
用户就会误以为问题也消失了。

所以真正的恢复留痕应优先落在：

1. AppState
2. pointer
3. reconnectAttempt / needsRefresh 这类显式状态字段

## 5.4 留痕对象应同时服务于“重试”和“解释”

成熟系统里的痕迹不应只用于 debug。  
它还应当回答两个问题：

1. 下一步怎么重试
2. 为什么上次没有闭环

这意味着痕迹对象必须能被产品化消费，  
而不只是藏在日志里。

## 6. 我给恢复留痕的最低语法

我会把控制面里的未闭环恢复语法压成：

`未闭环原因 + 当前挂起状态 + 再次进入入口`

例如：

1. `Auto-refresh failed; manual reload required · /reload-plugins`
2. `Reconnect exhausted; server marked failed · /mcp`
3. `Transient bridge failure; session may still be resumable · rerun /remote-control`

这类句式的价值在于：

1. 不否认失败
2. 不抹掉痕迹
3. 立刻给出再进入入口

## 7. 技术先进性与技术启示

这一章最重要的技术判断是：

`Claude Code 的先进性不只在于它能恢复，更在于它已经在多个关键域里实现了“恢复失败不静默蒸发”的留痕设计。`

这对其他 Agent 平台构建者的直接启示有四条：

1. 重试状态应产品化，不应只留在日志
2. 挂起态字段比 toast 更重要
3. pointer / pending / attempt count 是安全控制对象，不只是工程细节
4. 未闭环恢复的痕迹必须可跨时间保留

## 8. 哲学本质

这一章更深层的哲学是：

`真正诚实的系统，不只承认失败，还拒绝替失败做体面收尸。`

很多系统表面上很平静，  
不是因为它们真的恢复了，  
而是因为它们把失败留下的痕迹扫掉了。  
Claude Code 现有源码里那些 `needsRefresh`、`pending`、`failed`、pointer、retry count、manual rerun hint，  
其实共同指向一条很成熟的哲学：

`失败如果还没被解决，就不应被系统忘记。`

从第一性原理看，  
这保护的是下面这条公理：

`控制面不得把“未完成的恢复”通过遗忘伪装成“已完成的恢复”。`

## 9. 苏格拉底式反思：这一章最容易犯什么错

### 9.1 会不会留痕太多，导致界面充满旧失败

会。  
所以关键不是无限保留，  
而是：

`保留仍然具有再进入价值的痕迹。`

### 9.2 会不会把所有留痕都做成低优先级，最后没人看到

也会。  
所以留痕对象至少要和默认修复入口重新绑定，  
不能只埋进日志或详情页。


## 10. 结语

`55` 回答的是：哪些闭环配 auto-close，哪些必须人工确认。  
这一章继续推进后的结论则是：

`只要恢复还没闭环，系统就必须显式留下可重试、可解释、可回访的痕迹，而不是把它静默抹掉。`

这意味着 Claude Code 更深层的安全启示之一是：

`成熟控制面不仅知道什么时候不能自动宣布恢复，也知道在没有恢复时必须留下什么。`
