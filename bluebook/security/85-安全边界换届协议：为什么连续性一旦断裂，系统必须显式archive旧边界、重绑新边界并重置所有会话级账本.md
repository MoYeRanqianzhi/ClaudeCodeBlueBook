# 安全边界换届协议：为什么连续性一旦断裂，系统必须显式archive旧边界、重绑新边界并重置所有会话级账本

> Evidence mode
> - 当前 worktree 仍是 `mirror absent / public-evidence only`；本页继续消费既有归档源码锚点与前序研究结论，不把这里的源码行号冒充成本轮重新验证过的 live mirror。
> - 更稳的默认口径是：先把 `continuation / succession / suspension / retirement` 当作 boundary lifecycle 的 typed reading，再决定什么只算 `reopen eligibility`，什么才真能构成 `reopen authority`。

## 1. 为什么在 `84` 之后还要继续写“边界换届协议”

`84-安全失效边界复活禁令` 已经回答了：

`最危险的 failure 不是普通 stale state，而是已失效旧边界被重新认证成 current boundary。`

但如果继续往下追问，  
还会碰到一个更具体、也更接近控制面操作学的问题：

`既然旧边界不能复活，新边界应如何合法上任？`

因为安全系统不只要会：

1. 维持 continuity
2. 阻止失效边界复活

它还必须会：

`在 continuity 不再成立时，正式完成换届。`

否则就会出现最危险的伪动作：

`新边界已经生成，系统却还在假装它是旧边界的自然延续。`

所以在 `84` 之后，  
安全专题还必须再补一章，把“禁止旧边界复活”继续推进成更完整的制度问题：

`边界换届协议。`

也就是：

`成熟控制面不仅要保护同一边界的连续性，还必须在连续性断裂时显式处置旧边界、重建新边界，并重置所有会话级账本。`

## 2. 最短结论

从源码看，Claude Code 在 REPL bridge 里已经不只是在阻止旧边界复活，它还把新边界的就任流程写得很清楚：

1. 当 reconnect in place 不成立时，系统不会偷偷换一个新 session 冒充旧 session，而是先 `archiveSession(currentSessionId)`，再创建 `newSessionId`  
   `src/bridge/replBridge.ts:743-770`
2. 新 session 建立后，系统立刻替换 `currentSessionId`，并同步更新 bridge session id，让 peer dedup 和外部观察面切换到新边界  
   `src/bridge/replBridge.ts:788-791`
3. 作者明确把 `lastTransportSequenceNum`、`recentInboundUUIDs`、title derivation latch 都当成 session-scoped state，在换届后立即 reset  
   `src/bridge/replBridge.ts:792-814`
4. 新边界一确立，crash-recovery pointer 就会被重写到新 session；旧边界在 clean exit 时则会被 clear  
   `src/bridge/replBridge.ts:816-827,1660-1663`  
   `src/bridge/bridgePointer.ts:62-113,190-202`
5. 同一个源码文件还用 `v2Generation` 和 stale handshake discard 防止旧 transport 在换届后重新接回新边界  
   `src/bridge/replBridge.ts:620-645,1402-1413`
6. teardown 路径也明确区分：perpetual 模式是本地退出但 server-side 边界继续存在，因此刷新 pointer；非 perpetual clean exit 则是发送 result、archive、deregister、clear pointer 的正式退役流程  
   `src/bridge/replBridge.ts:1595-1663`

所以这一章的最短结论是：

`Claude Code 不只是保护 continuity，它还实现了一套显式的 succession protocol。`

我把它再压成一句：

`连续性可以续接，但一旦不能续接，就必须换届，不能混关。`

如果继续把边界换届再压成最短的 boundary lifecycle，也只该剩四格：

1. `continuation`
   - 同一边界继续生效，同一组 session-scoped ledger 继续有效。
2. `succession`
   - continuity 已断；旧边界先 archive，新边界再就任，并重绑 `window_floor_generation / pricing_floor_generation / liability_owner / reopen_required_when`。
3. `suspension`
   - 边界仍活着，只是本地 consumer 暂退；pointer 可以续租，但不等于正式退役。
4. `retirement`
   - result、archive、deregister、clear pointer 全部完成；旧边界不再拥有继续发言权。

更硬一点说，成熟控制面不只要会“保持同一边界”，还要会在这四个 lifecycle state 之间合法切换，避免 suspension 冒充 continuation、succession 冒充自然延长、retirement 冒充可恢复挂起。

如果继续把这四格和治理入口的 typed-state 一起读，最稳的最小交叉表也只先写成下面这样：

| authority lease | decision delta | cleanup trigger state | 更稳的 lifecycle 读法 | `reopen eligibility` | `reopen authority` |
|---|---|---|---|---|---|
| `same` | `zero` | `fired` | `continuation checkpoint`：还是同一边界，但没有新增 delta | 可以有；例如 resume handle、pointer 或 transcript 仍能把你带回原现场 | 没有新增 authority；只是继续消费原租约，不是重签 |
| `same` | `zero` | `owed / failed / unknown` | `suspension / freeze`：边界也许还活着，但收口条件未清 | 可以暂时存在，但只说明“有得回去看” | 不成立；先补 cleanup，再谈继续 |
| `changed` | `new` | `fired` | `succession`：旧边界已处置，新边界正式上任 | 可以有，但它只指向新边界 | 只能来自新 signer chain，不能继承旧 receipt |
| `changed / unknown` | `zero` | `fired` | `retirement`：旧边界已结束，没有合法续租 | 不应再写成 `yes`；最多只剩历史可读性 | 不成立；任何后续动作都要 fresh repricing / fresh authority |

更硬一点说，这张表故意把 `reopen eligibility` 和 `reopen authority` 拆开，是为了防止 pointer、summary、resume handle 或 status green 这类 carrier 偷偷代签 continue truth。能重新找到入口，不等于仍有权沿旧边界继续写现在。

## 3. 源码已经说明：成熟控制面必须把“续接失败”升级成“正式换届”

## 3.1 Strategy 2 不是普通 fallback，而是旧边界退役与新边界就任

`src/bridge/replBridge.ts:743-770` 很关键。

这里作者没有写成：

`reconnect 不行就 new 一个 session 凑合继续。`

而是非常明确地先做：

1. `archiveSession(currentSessionId)`
2. 之后才 `createSession(...)`

这说明在作者心里，  
新 session 的出现不是普通替代，  
而是：

`旧边界必须先退役，新边界才能合法上任。`

这就是典型的换届协议思维。  
它解决的不是“代码顺序优雅”，  
而是：

`避免两个边界对象同时被系统默认为 current。`

## 3.2 `currentSessionId = newSessionId` 还不够，外部可见身份也必须一起换届

`src/bridge/replBridge.ts:788-791` 说明一个很成熟的点：

系统不是只在局部变量里把 `currentSessionId` 改掉就结束，  
还会立即：

1. 把新 id 写回 peer dedup 相关记录
2. 让其他本地 peer 和外部观察面识别当前边界已经切换

这说明真正的换届不是内部变量赋值，  
而是：

`所有依赖 current boundary 的观察者都要同时切到新边界。`

否则就会出现：

1. 核心 runtime 认为自己在 session B
2. 旁路观察者仍以为当前还是 session A

这种裂脑本身就是安全问题。

## 3.3 真正难的地方不是换 session id，而是重置一整套 session-scoped 账本

`src/bridge/replBridge.ts:792-814` 是这章最有价值的证据之一。

这里作者显式重置了：

1. `lastTransportSequenceNum`
2. `recentInboundUUIDs`
3. `userMessageCallbackDone`

注释写得非常清楚：

1. SSE seq-num 是 session-scoped 的
2. inbound UUID dedup 也是 session-scoped 的
3. title derivation 也同样是 session-scoped 的

这说明 Claude Code 团队非常清楚：

`边界换届不是换一个主键值，而是整套会话级记忆与流水号都必须重新绑定。`

从第一性原理看，  
这意味着安全系统真正治理的不是对象名，  
而是：

`对象名 + 账本 + 派生策略 + 流水上下文`

如果这些旧账本被带入新边界，  
系统就会产生一种很隐蔽的伪连续性：

`边界已经换了，但会话级历史语义还在偷渡。`

## 3.4 pointer 改写不是 crash recovery 小细节，而是对“当前边界是谁”的正式公证

`src/bridge/replBridge.ts:816-827` 与 `src/bridge/bridgePointer.ts:62-113,190-202` 合起来看非常有意思。

源码里：

1. 初始 session 创建后会写 pointer  
   `src/bridge/replBridge.ts:479-488`
2. 换届后会立刻把 pointer 重写到新 session  
   `src/bridge/replBridge.ts:816-823`
3. clean exit 时会 clear pointer  
   `src/bridge/replBridge.ts:1660-1663`
4. pointer 读路径还会主动清理 schema invalid 或超时 4h 的 stale pointer  
   `src/bridge/bridgePointer.ts:76-113`

这说明 pointer 在这里的本质不是缓存，  
而是：

`当前边界身份的 crash-recovery 公证物。`

所以 pointer 改写也不是无关紧要的小维护，  
而是正式在声明：

`如果此刻进程崩掉，下一次恢复该承认谁是 current boundary。`

## 3.5 `v2Generation` 与 stale handshake discard 说明：旧 transport 也必须被剥夺复位资格

`src/bridge/replBridge.ts:620-645` 与 `1402-1413` 说明另一条很成熟的纪律：

换届不是只替换 session id，  
旧 transport 也必须被制度性排除。

这里作者通过：

1. `v2Generation++`
2. stale transport close
3. stale handshake discard

避免的不是普通连接竞争，  
而是：

`旧通道在新边界已经形成后，仍试图重新成为合法代表。`

所以 transport 的 stale guard 实际上是：

`边界换届之后的通道剥夺机制。`

这条机制非常重要，  
因为它说明成熟控制面不只会“扶正新边界”，  
还会：

`明文取消旧边界附着物的继续发言资格。`

## 3.6 perpetual 与 non-perpetual teardown 的分叉，揭示了“挂起”和“退役”不是一回事

`src/bridge/replBridge.ts:1595-1663` 其实写出了两种完全不同的制度：

第一种是 perpetual：

1. 本地退出
2. 不发送 result
3. 不 stopWork
4. 不 archive
5. 不 close server-side session
6. 只刷新 pointer mtime，保留后续 resume 可能

第二种是 non-perpetual clean exit：

1. 先发 result
2. 再 stopWork + archive
3. 再 close transport
4. 再 deregister environment
5. 最后 clear pointer

这说明 Claude Code 团队非常明确地区分了：

1. `suspend`  
   边界仍活着，只是本地进程退出
2. `retire`  
   边界正式结束，不再承认后续恢复

这正是边界换届协议的另一面。  
如果连退场类型都不区分，  
系统就无法准确回答：

`此刻到底是在留任、挂起、换届，还是退役。`

## 3.7 第一性原理：成熟系统至少要区分 continuation、succession、suspension、retirement 四种制度

如果把这章所有证据再压一层，  
Claude Code 实际上已经在源码里隐含地区分了四种制度状态：

1. `continuation`  
   原边界继续生效，例如 in-place reconnect
2. `succession`  
   原边界已退役，新边界正式上任，例如 archive old + create new
3. `suspension`  
   本地执行体退出，但边界在服务端仍存活，例如 perpetual teardown
4. `retirement`  
   边界正式结束，例如 archive + deregister + clear pointer

从第一性原理看，  
安全系统的成熟度往往取决于：

`它是否把这四种状态分开治理。`

很多系统的问题不是没有重连，  
而是把这四种状态全部压成：

`重新连一下。`

而 Claude Code 这里更成熟的地方在于，  
它已经开始把：

1. 续接
2. 换届
3. 挂起
4. 退役

写成不同的协议动作。

## 3.8 技术先进性：真正先进的不是 auto-reconnect，而是显式 succession discipline

从技术角度看，  
很多系统也有 reconnect、retry、resume。

但 Claude Code 在这里更先进的地方不是“也能重连”，  
而是：

1. 旧边界先 archive，再允许新边界出现
2. session-scoped ledger 明确 reset
3. crash-recovery pointer 显式改写或清除
4. stale transport 有 generation guard
5. suspend 与 retire 被明确区分

这些点合起来说明，  
它真正接近的不是“高可用技巧”，  
而是：

`对边界生命周期的制度化治理。`

## 4. 安全边界换届协议的最短规则

把这一章压成最短规则，就是下面七句：

1. 连续性断裂时，不能偷偷替换对象，必须显式换届
2. 换届前应先处置旧边界，最典型动作是 archive old boundary
3. 新边界上任后，所有 session-scoped ledger 都必须重绑或重置
4. pointer 不是缓存杂项，而是 current boundary 的恢复公证物
5. 旧 transport、旧 handshake、旧 timer 都必须被剥夺继续代表新边界的资格
6. suspend 与 retire 必须严格区分，不能继续共用一种 teardown 语义
7. 真正成熟的 reconnect 系统，本质上是 succession protocol，而不是网络补丁
8. `reopen eligibility` 与 `reopen authority` 必须分开；resume handle、pointer freshness 与摘要存在最多证明前者，绝不自动证明后者

## 5. 苏格拉底式追问：这套系统还能怎样再向前推进

如果继续自问，  
下一步最值得补的三项升级会是：

1. 把 `continuation / succession / suspension / retirement` 做成显式 boundary lifecycle enum，而不只靠注释分辨
2. 给 pointer、transport 与 session 统一增加 `epoch` / `boundary_generation`，把“谁已失效”从评论变成类型系统对象
3. 给统一安全控制台增加一张 boundary lifecycle 卡片，明确显示当前到底是在续接、换届、挂起还是退役

若再把自问压成更硬的三句，也只该剩：

1. 如果现在只剩 pointer、summary 或 resume button，我拥有的是入口资格，还是继续写权。
2. 如果 `decision delta = zero`，我是在 checkpoint 同一条 lease，还是在偷把旧 verdict 重新签一遍。
3. 如果 cleanup 还 `owed / failed / unknown`，为什么我还敢把这个状态写成“已可 reopen”。

所以这一章最终沉淀出的设计启示是：

`成熟安全控制面不仅要保护边界连续性，还必须在连续性结束时完成一场制度上清楚、账本上干净、观察面上同步的正式换届。`
