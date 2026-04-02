# 安全边界换届协议速查表：break trigger、old boundary disposition、required reset与forbidden fake continuity

## 1. 这一页服务于什么

这一页服务于 [85-安全边界换届协议：为什么连续性一旦断裂，系统必须显式archive旧边界、重绑新边界并重置所有会话级账本](../85-%E5%AE%89%E5%85%A8%E8%BE%B9%E7%95%8C%E6%8D%A2%E5%B1%8A%E5%8D%8F%E8%AE%AE%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E8%BF%9E%E7%BB%AD%E6%80%A7%E4%B8%80%E6%97%A6%E6%96%AD%E8%A3%82%EF%BC%8C%E7%B3%BB%E7%BB%9F%E5%BF%85%E9%A1%BB%E6%98%BE%E5%BC%8Farchive%E6%97%A7%E8%BE%B9%E7%95%8C%E3%80%81%E9%87%8D%E7%BB%91%E6%96%B0%E8%BE%B9%E7%95%8C%E5%B9%B6%E9%87%8D%E7%BD%AE%E6%89%80%E6%9C%89%E4%BC%9A%E8%AF%9D%E7%BA%A7%E8%B4%A6%E6%9C%AC.md)。

如果 `85` 的长文解释的是：

`为什么 continuity break 必须被治理成正式换届，`

那么这一页只做一件事：

`把不同 break trigger 到底如何处置旧边界、要求重置哪些 session-scoped 状态，以及哪些 continuity 说法绝不能继续保留压成一张 succession 矩阵。`

## 2. 边界换届协议矩阵

| break trigger | old boundary disposition | new boundary action | required reset | allowed continuity claim | forbidden fake continuity | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| reconnect in place 成功 | 旧边界不退役，继续作为 current boundary | 不创建新 session，只恢复 transport/work dispatch | 保留 session identity；transport seq 续接 | 允许说“同一边界续接成功” | 不应误说成新边界上任 | `replBridge.ts:391-418,588-604,634-645` |
| reconnect in place 失败，进入 Strategy 2 | 先 `archiveSession(currentSessionId)`，旧边界正式退役 | `createSession(...)` 创建 `newSessionId` 并替换 `currentSessionId` | bridge session id 对外发布要切换 | 只允许说“旧边界退役，新边界上任” | 绝不能把 new session 说成 old session 自然延续 | `replBridge.ts:743-791` |
| 新 session 切换完成 | 旧 session 不再承载任何 session-scoped 账本 | 新 session 成为唯一 current boundary | `lastTransportSequenceNum`、`recentInboundUUIDs`、title derivation latch、`previouslyFlushedUUIDs` | 允许说“新边界已绑定新账本” | 禁止把旧 session 的 seq、UUID dedup、title 派生状态带进新边界 | `replBridge.ts:792-827` |
| stale transport / stale handshake 在换届后返回 | 旧 transport / 旧 epoch 必须被剥夺发言资格 | 仅当前 generation 的 transport 可接线 | `v2Generation` 递增；stale handshake discard | 允许说“旧通道已失效” | 禁止旧 transport 重新代表新边界 | `replBridge.ts:620-645,1402-1413` |
| perpetual teardown | 旧边界不退役，server-side session 继续存活 | 本地只退出，不 stopWork、不 archive、不 clear pointer | 刷新 pointer mtime；丢弃本地 flush/transport | 只允许说“本地挂起，可恢复续接” | 不能误说成 clean retirement | `replBridge.ts:1595-1615` |
| non-perpetual clean exit | 旧边界正式退役 | send result 后 stopWork + archive + deregister | clear pointer，结束 crash recovery 声明 | 允许说“边界已正式结束” | 禁止保留 resume 假象或旧 pointer | `replBridge.ts:1618-1663` |
| stale / invalid pointer 读取 | 已无可信 current boundary，可视为恢复公证失效 | 清理 pointer，避免继续诱导 resume | clear invalid or >4h stale pointer | 只允许说“当前没有可信恢复边界” | 禁止继续把 stale pointer 当 current boundary 证据 | `bridgePointer.ts:76-113,190-202` |

## 3. 最短判断公式

看到一个 break 场景时，先问五句：

1. 这是 continuation、succession、suspension 还是 retirement
2. 旧边界是否已经被正式退役
3. 哪些 session-scoped ledger 必须 reset
4. 当前 pointer / transport / external observer 是否都已同步切换
5. 还有哪句 continuity 语言现在已经绝对不能再说

## 4. 最常见的五类伪换届

| 伪换届 | 会造成什么问题 |
| --- | --- |
| new session 建好但旧 session 未先 archive | 两个边界对象同时像 current |
| 换了 `currentSessionId` 但没 reset seq / UUID / title 派生状态 | 旧账本偷渡进新边界 |
| pointer 没改写或没清理 | crash recovery 继续指向错误边界 |
| stale transport 没被 generation guard 拦下 | 旧通道重新代表新边界 |
| suspend / retire 混成同一种 teardown | 用户与系统都无法判断是否还能恢复 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的不是：

`断了以后还能继续跑，`

而是：

`断了以后系统知道自己是在续接、换届、挂起还是退役，并且每一种都按不同制度动作处理。`
