# `reusedPriorSession`、`previouslyFlushedUUIDs`、`createCodeSession` 与 `flushHistory`：为什么 v1 continuity ledger 与 v2 fresh-session replay 不是同一种 history contract

## 用户目标

183 已经把 bridge 初始历史账继续拆成：

- local seed
- real delivery ledger

186 又把 bridge 初始历史对象继续拆成：

- eligible replay projection
- model prompt authority

但如果正文停在这里，读者还是很容易把 v1 / v2 对历史 suppress 的处理继续写平：

- `previouslyFlushedUUIDs` 不就是“哪些历史已经发过”的通用账本吗？
- v1 会用它，v2 不用它，不就是实现偏好不同？
- 既然两边都在做 initial history flush，那一张“已发过历史消息”的账为什么不能复用？
- v2 既然也会重复 enable / disable，为什么反而明确拒绝这张账？

这句还不稳。

从当前源码看，这里至少还要继续拆开两种不同合同：

1. session continuity ledger
2. fresh-session replay

如果这两层不先拆开，后面就会把：

- `reusedPriorSession`
- `previouslyFlushedUUIDs`
- `createCodeSession(...)`
- `flushHistory(...)`

重新压成一句模糊的“历史去重策略”。

## 第一性原理

更稳的提问不是：

- “v1 为什么带着 `previouslyFlushedUUIDs`，v2 为什么不用它？”

而是先问六个更底层的问题：

1. 当前逻辑在回答“这次连接是否延续同一个 server session”，还是“这次只是把本地历史再投影到一个新 session”？
2. 当前 suppress 的根据是“server 已经持有这些 UUID”，还是“本地认为这些消息曾经在别处发过”？
3. 当前 path 在重用哪一个身份：同一个 session id，还是只重用本地消息集合？
4. 当前 fresh create 之后，旧的 flushed ledger 继续存在会帮忙，还是会误伤重发？
5. 当前差异的核心是 dedup 细节，还是 session continuity contract？
6. 我现在分析的是 183 的 delivery ledger，还是 v1 / v2 是否允许跨 transport incarnation 继承那张账？

只要这六轴不先拆开，后面就会把：

- continuity
- replay
- dedup

混成一张“历史过滤表”。

## 第一层：v1 里的 `previouslyFlushedUUIDs` 先回答“同一 server session 是否连续存在”

`replBridge.ts` 在 perpetual init 路径先尝试：

- `tryReconnectInPlace(prior.environmentId, prior.sessionId)`

若 `reusedPriorSession` 成立，
它会直接：

- 复用 `prior.sessionId`

随后代码马上写明：

- server already has all `initialMessages` from the prior CLI run
- therefore mark them as previously flushed

这说明 v1 里的 `previouslyFlushedUUIDs` 首先回答的问题不是：

- 本地历史里哪些消息通常不该再发

而是：

- 当前这个 server session 真的还是上一次那条 session，因此 server 已经拥有这些 UUID

所以更准确的理解不是：

- `previouslyFlushedUUIDs` 是可在任意 replay 中复用的泛化 suppress set

而是：

- 它是 session continuity ledger

## 第二层：v1 只有在 continuity 断掉时才会主动清空这张账

同一个文件里，
`doReconnect()` 的注释明确把恢复分成两种：

1. reconnect-in-place
2. fresh session fallback

前者会：

- `currentSessionId` 保持不变
- `previouslyFlushedUUIDs` 被 preserved

后者则在写新 pointer 之后明确：

- `previouslyFlushedUUIDs?.clear()`

旁边注释也写得很硬：

- UUIDs are scoped per-session on the server
- re-flushing to the new session is safe

这说明 v1 自己就已经承认：

- 这张账只有在 session continuity 成立时才有资格继承

一旦切成 fresh session，
旧账不但不能继续帮忙，
反而必须被清空。

所以更准确的结论不是：

- v1 只是“有时想保留，有时不想保留”

而是：

- v1 在用 clear / preserve 明确编码 continuity boundary

## 第三层：v1 在 initial flush 成功后才追加 ledger，说明它不是纯本地 suppress cache

`replBridge.ts` 的初始 flush 在真正 `writeBatch(events)` 之后，
只有当：

- `droppedBatchCount` 没有增加

才会把：

- `sdkMsg.uuid`

追加回：

- `previouslyFlushedUUIDs`

这再次说明它回答的问题不是：

- 本地大概觉得这些消息已经出现过

而是：

- 针对当前这条连续的 server session，哪些 UUID 已经在 ingress flush 中稳定送达

所以它当然可以在下一次同 session continuity 的 suppress 里继续被信任。

这也是为什么这张账比 183 那页里讲的“delivery ledger”还要再多一层：

- 它不仅记录 delivery
- 还隐含记录“delivery truth 绑定的是哪一条 server session”

## 第四层：v2 从一开始就明确拒绝这张 continuity ledger，因为它压根不承诺 continuity

`remoteBridgeCore.ts` 一上来就是：

- unconditional `createCodeSession(...)`

也就是：

- 总是 fresh server session

随后 `flushHistory(msgs)` 的注释直接写明：

- v2 always creates a fresh server session
- no session reuse
- no double-post risk
- unlike v1, we do NOT filter by `previouslyFlushedUUIDs`
- that set persists across REPL enable/disable cycles and would wrongly suppress history on re-enable

这段话很值钱，因为它把主语钉死了：

- v2 不是“暂时没接这张账”
- 而是“fresh-session contract 下，这张 continuity ledger 本来就不应该被继承”

所以更准确的理解不是：

- v2 缺少一套更完整的 dedup

而是：

- v2 在语义上拒绝 continuity ledger

## 第五层：因此 v1 / v2 的差异不是“要不要 suppress”，而是“Suppress 的真理基础是否成立”

如果只看表面，
两边都在做：

- initial history replay

很容易把差异写成：

- v1 会过滤
- v2 不过滤

这句太浅。

更准确的写法应该是：

- v1 的 suppress 依赖真实 session continuity
- v2 的 fresh create 破坏了这种 continuity
- 所以旧 ledger 会从“正确的 suppress 证据”变成“错误的遗漏来源”

也就是说，
差异不在于“技术上有没有 Set”，
而在于：

- suppress 的真理基础是否成立

## 第六层：这页不是 183 的重写，因为 183 讲的是“这张账是什么”，189 讲的是“这张账何时还能继承”

183 的核心句子是：

- `previouslyFlushedUUIDs` 是 real history delivery ledger

189 要补的句子则是：

- 即便是 real delivery ledger，它也不是跨所有 bridge incarnation 都可复用

换句话说：

- 183 问这张账的身份
- 189 问这张账的继承条件

如果不把“继承条件”单列，
读者就还是会自然假设：

- 只要某条消息曾被 flush 成功，今后所有 replay path 都应 suppress 它

而这恰好是 v2 明确否定的东西。

## 第七层：这页也不是 186 的附录，因为 186 讲的是 projection object，不是 continuity contract

186 已经明确：

- v1 / v2 共享 eligible-then-cap 形态

但 186 刻意把：

- `previouslyFlushedUUIDs`

压回 delivery / continuity 页面，
不让它吞掉：

- UI-only projection
- prompt authority

189 这一页正好承接这条 defer：

- 同样的 replay object
- 在 v1 / v2 下仍然不享有同一种 continuity contract

所以更准确的关系不是：

- 189 在重复讲 replay 对象

而是：

- 189 在讲 replay 发生时，那张 flushed ledger 能不能跨 session incarnation 被信任

## 第八层：因此更稳的写法不是“v1/v2 的 dedup 差异”，而是“continuity ledger 与 fresh-session replay 的合同分裂”

到这里更稳的写法已经不是：

- v1/v2 在 `previouslyFlushedUUIDs` 上实现不同

而应该明确拆成：

1. v1 reconnect-in-place
   continuity ledger 可继承
2. v1 fresh-session fallback
   旧 ledger 必须清空
3. v2 unconditional create
   continuity ledger 从语义上不成立
4. initial flush replay
   只能重新按 fresh session 发送

所以更准确的结论不是：

- `previouslyFlushedUUIDs` 是一张 bridge 通用 suppress 表

而是：

- 它只属于 continuity contract
- 不属于 fresh-session replay contract

## 稳定面与灰度面

本页只保护稳定不变量：

- v1 只有在真实 session continuity 成立时才继承 `previouslyFlushedUUIDs`
- v1 一旦 fresh create，就必须清空这张账
- v2 的 fresh-session contract 明确拒绝复用这张账
- 差异核心是 continuity truth，不是单纯 dedup 手法

本页刻意不展开的灰度层包括：

- v1 / v2 更广的 reconnect state machine
- `initialHistoryCap` 的数值与 replay 厚度
- `initialMessageUUIDs`、`recentPostedUUIDs` 等其他集合家族
- archive / environment recreation 的完整运维链

这些都相关，但不属于本页的 hard sentence。

## 苏格拉底式自审

### 问：为什么不能直接把这页写成“v1 会 dedup，v2 不会 dedup”？

答：因为那会把差异降成实现风格，而当前源码明确告诉你，v2 不复用这张账不是因为忘了做 dedup，而是因为 fresh server session 下那张 continuity ledger 已经失去真理基础。

### 问：为什么 183 还不够？

答：因为 183 只证明了 `previouslyFlushedUUIDs` 是真实 delivery ledger，没有继续证明“真实 delivery ledger 也不是跨所有 session incarnation 都能复用”。189 正在补这一句。

### 问：为什么这页不把 186 的 projection 也一起重讲？

答：因为那会把 continuity contract 再次稀释回 replay object 页面。189 的新增价值就在于：即便 replay object 相似，continuity ledger 也不一定可继承。
