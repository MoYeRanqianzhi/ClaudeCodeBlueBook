# 安全授权连续性：为什么session、token、transport与scope真正需要被保护的不是值，而是其背后的授权连续性

## 1. 为什么在 `82` 之后还要继续写“授权连续性”

`82-安全上下文重推导禁令` 已经回答了：

`不是所有上下文都不能重算，真正被禁止的是对 authority-bearing context 的二次重算。`

但如果继续往下追问，  
还会遇到一个更底层的问题：

`为什么这些上下文一旦重算就会变得危险？`

答案并不只是：

`因为它们重要。`

更准确地说，  
它们之所以重要，是因为它们承载的不是单个字段值，  
而是一条正在持续生效的授权关系。

所以在 `82` 之后，  
安全专题还必须再补一章，把“禁止重推导”继续压缩成一条更本质的原则：

`授权连续性。`

也就是：

`成熟控制面真正需要保护的，不是 sessionId、token、transport、scope 这些值本身，而是它们共同维持的“当前是谁、正通过哪条通道、在谁的边界里继续行动”的连续性。`

## 2. 最短结论

从源码看，Claude Code 在 bridge 子系统里已经反复表明：

1. `replBridgeHandle.ts` 明说 handle 闭包捕获创建 session 的 `sessionId` 与 `getAccessToken`，独立重推导会带来 staging/prod token divergence  
   `src/bridge/replBridgeHandle.ts:5-13`
2. `replBridge.ts` 把 reconnect-in-place 的核心收益写得非常具体：`currentSessionId stays the same`，用户手机上的 URL 继续有效，`previouslyFlushedUUIDs` 被保留，所以历史不会重发  
   `src/bridge/replBridge.ts:588-604`
3. 同文件还反复强调 Strategy 1 成功时 `currentSessionId` 不变，说明 session identity 不是随便换一个等值字符串就行  
   `src/bridge/replBridge.ts:391-418,729-744`
4. callback wiring 直接闭包捕获 `transport/currentSessionId`，避免回调链自己再线程化重建  
   `src/bridge/replBridge.ts:1190-1200`
5. pointer refresh race 的注释明确写出：错时写回会把指针留在已经归档的旧 session 上  
   `src/bridge/replBridge.ts:1512-1524`
6. 与之形成对照的是 title 和 `/status` 摘要：它们是 cosmetic / summary surface，可以重新派生，也会主动把用户导向真正的信息面  
   `src/bridge/initReplBridge.ts:247-257`  
   `src/utils/status.tsx:95-114`  
   `src/hooks/notifs/useIDEStatusIndicator.tsx:119-123,147-150`

所以这一章的最短结论是：

`Claude Code 真正保护的不是字段值正确性，而是授权连续性。`

我把它再压成一句：

`值只是载体，连续性才是主权对象。`

## 3. 源码已经说明：控制面真正怕的不是“值算错”，而是“边界连续性被悄悄换掉”

## 3.1 `replBridgeHandle.ts` 已经把 token / session 看成连续关系，而不是独立参数

`src/bridge/replBridgeHandle.ts:5-13` 的注释几乎就是这一章的设计宣言。

这里作者没有说：

`handle 只是帮你少传几个参数。`

而是直接说：

1. handle 的闭包捕获了创建该 session 的 `sessionId`
2. 也捕获了创建它时使用的 `getAccessToken`
3. 如果独立重推导这些值，会产生 staging/prod token divergence

这说明系统真正怕的不是“字符串值不一样”，  
而是：

`后来的调用以为自己还在代表原来的授权主体，实际上已经切到了另一套 credential 语义。`

这就是典型的授权连续性问题。  
值没有一定变错，  
但：

`谁在以谁的名义继续行动`  

已经漂了。

## 3.2 reconnect-in-place 保护的也不是 sessionId 这个字符串，而是同一控制对象的连续存在

`src/bridge/replBridge.ts:588-604` 把 reconnect 的两条路径写得很清楚。

Strategy 1 的收益不是抽象的“复用一下旧值”，  
而是：

1. `currentSessionId stays the same`
2. 手机端 URL 继续有效
3. `previouslyFlushedUUIDs` 被保留，所以历史不会重发

这三件事合在一起说明：

`currentSessionId` 在这里承载的不是普通标识符，  
而是：

1. 当前控制对象是谁
2. 这个对象对外的可寻址身份是什么
3. 这个对象已经拥有了哪一段消息账本

所以 reconnect-in-place 的本质不是“保值”，  
而是：

`保住同一条授权与账本链。`

## 3.3 Strategy 1 与 Strategy 2 的分叉，本质上是在区分“连续续存”和“正式换届”

`src/bridge/replBridge.ts:391-418` 与 `729-744` 进一步把这件事写透了。

一方面，  
作者多次强调 Strategy 1 成功时：

`currentSessionId never mutates`  
`currentSessionId stays the same`

另一方面，  
当环境真正不再可复用时，  
系统不会偷偷换一个新 session 假装还是原来的那个，  
而是：

1. 明确承认 env 已经变了
2. archive old session
3. 再创建 fresh session

这说明 Claude Code 并不是单纯追求“尽量恢复服务”，  
它更在乎：

`恢复是续接原边界，还是正式建立新边界。`

这正是成熟安全控制面的一个标志：

`连续性可以被维护，但不能被伪造。`

## 3.4 callback 直接闭包捕获 `transport/currentSessionId`，保护的是动作的通道连续性

`src/bridge/replBridge.ts:1190-1200` 有一句很关键的注释：

`captures transport/currentSessionId so the transport.setOnData callback below doesn't need to thread them through`

这意味着作者在避免的不是代码啰嗦，  
而是：

`控制回调在后续调用链上重新拼装关键上下文。`

因为一旦允许 callback 自己去拿：

1. 当前该写向哪个 transport
2. 当前该归属哪个 session

系统就在默认：

`这个动作属于哪条通道、哪条会话，可以由后来者重新解释。`

而 Claude Code 的做法正相反。  
它把这些东西直接锁进闭包，  
保证一条控制动作继续沿着创建时那条授权通道发出。

所以这里保护的不是参数传递便利性，  
而是：

`动作通道的连续性。`

## 3.5 pointer race 注释说明：连续性一旦被错时改写，旧边界会被重新认证

`src/bridge/replBridge.ts:1512-1524` 是这一章最锋利的证据。

作者明确写出：

1. `doReconnect()` 会非原子地重设 `currentSessionId/environmentId`
2. 如果 pointer refresh timer 正好在这个窗口里触发
3. 它 fire-and-forget 的写入可能覆盖 reconnect 自己写的新值
4. 最终把 pointer 留在已归档旧 session 上

这不是普通意义上的“脏写入”。  
它的危险在于：

`已归档边界对象被重新写回成当前边界对象。`

从第一性原理看，  
这就是授权连续性的反面：

`系统失去了对“现在到底是哪一个边界对象在继续生效”的控制。`

因此 race 的本质也不是一致性瑕疵，  
而是：

`边界复活风险。`

## 3.6 title 和 `/status` 摘要之所以允许重推导，是因为它们不承担授权连续性

`src/bridge/initReplBridge.ts:247-257` 对 title 的态度非常明确：

`Cosmetic only`

它允许 title 根据首轮 prompt、第三轮 prompt 和 slug fallback 再次派生，  
因为 title 只影响 claude.ai 的会话列表展示，  
不决定：

1. 当前 session 是谁
2. 当前 transport 指向哪
3. 当前 token 语义属于哪一套授权

同样，  
`src/utils/status.tsx:95-114` 也把 MCP 信息压成计数摘要，  
`src/hooks/notifs/useIDEStatusIndicator.tsx:119-123,147-150` 甚至直接把通知写成：

`/status for info`

这说明这些 surface 的职责更接近：

1. 提示
2. 摘要
3. 路由

而不是主权级控制对象本身。

所以 Claude Code 的真正分层逻辑是：

1. 承载授权连续性的对象必须保持 creator-bound continuity
2. display / summary surface 可以重新投影、重新命名、重新压缩

## 3.7 第一性原理：真正被保护的，是“当前谁在谁的边界里继续做事”

如果把上面所有证据再压一层，  
授权连续性其实回答的是四个问题：

1. `actor continuity`  
   当前代表谁继续行动
2. `channel continuity`  
   当前通过哪条 transport / callback 链继续行动
3. `ledger continuity`  
   当前延续的是哪一条历史、URL、pointer 与 flushed UUID 账本
4. `scope continuity`  
   当前动作仍然属于哪个 session / family / authority scope

一旦这些连续性被错误重建，  
系统即便还有“差不多相同”的值，  
也已经失去：

`我现在是在延续原边界，还是在冒充原边界。`

这才是安全控制面真正保护的对象。

## 3.8 技术先进性：Claude Code 已经不再停留在“字段正确”，而是在保护 continuity object

从技术角度看，  
Claude Code 在这里的先进性不只是：

1. 有 reconnect
2. 有 handle
3. 有提示文案

更关键的是，  
这些零件被同一个原则串起来了：

1. 能续接原边界，就续接原边界
2. 不能续接时，要显式 archive 再新建
3. 关键动作要吃 creator-bound closure
4. 摘要层只做投影，不冒充权威边界
5. race 条件要按“旧边界复活风险”来理解，而不是当普通脏写

很多系统做到第三步就停了，  
Claude Code 的成熟之处在于它已经开始接近第四步和第五步。

## 4. 安全授权连续性的最短规则

把这一章压成最短规则，就是下面六句：

1. 真正需要保护的不是字段值，而是字段背后的授权连续性
2. session continuity、token continuity、transport continuity 与 scope continuity 都属于同一类安全对象
3. in-place reconnect 的价值不是省重连，而是保住同一条授权与账本链
4. 无法续接原边界时，必须显式 archive old boundary，再创建 new boundary
5. display / summary / routing surface 可以重投影，但不应承载主权级连续性
6. race 一旦会让 archived boundary 重新变成 current boundary，就不是小 bug，而是安全级故障

## 5. 苏格拉底式追问：如果再做一代，哪里还能继续加强

如果继续自问，  
这套系统还可以怎样更进一步？

第一个追问是：

`既然源码已经在保护连续性，为什么 continuity class 还主要靠注释表达？`

这说明下一代控制面最值得补的是显式类型：

1. `cosmetic`
2. `derived summary`
3. `authority-bearing continuity`

第二个追问是：

`既然 archived boundary revival 这么危险，为什么 pointer 还只是普通写入对象，而不是带 epoch/tombstone 的 continuity token？`

这说明还可以把：

1. `session_epoch`
2. `archived_at`
3. `continuity_owner`
4. `revival_forbidden`

做成正式字段。

第三个追问是：

`既然 /status 和 notification 已经承认自己只是摘要层，为什么统一安全控制台还没有把“当前只是 summary，不是 authority source”做成显式 badge？`

这说明展示层也还能继续进化。

所以这一章最后沉淀出的设计启示是：

`成熟安全系统真正要保住的，不是值的一致，而是授权关系在时间上的连续。`
