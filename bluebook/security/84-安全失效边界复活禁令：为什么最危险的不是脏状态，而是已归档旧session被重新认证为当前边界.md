# 安全失效边界复活禁令：为什么最危险的不是脏状态，而是已归档旧session被重新认证为当前边界

## 1. 为什么在 `83` 之后还要继续写“失效边界复活禁令”

`83-安全授权连续性` 已经把前面的链条压成一句话：

`真正需要被保护的，不是字段值本身，而是它背后的授权连续性。`

但如果继续追问，还会出现一个比“连续性被打断”更具体、更危险的问题：

`连续性被打断之后，旧边界会不会被重新写回当前系统？`

这件事一旦发生，问题就不再是普通 stale state。

因为 stale state 只是“旧信息还没消失”，  
而旧边界复活是：

`一个已经被归档、过期、撤回或失效的控制对象，被重新认证成当前合法边界。`

这就是为什么安全专题还必须再补一章：

`安全失效边界复活禁令。`

## 2. 最短结论

从 bridge 相关源码看，Claude Code 已经在多个位置把这条禁令写成了显式工程纪律：

1. `doReconnect()` 一开始就提升 `v2Generation`，明确要让 in-flight 的 stale transport / handshake 失效，避免它们在重连后继续指向死 session  
   `src/bridge/replBridge.ts:617-623`
2. `stopWork` await 期间如果 poll loop 已经拿到新 `currentWorkId`，代码会立刻放弃后续 archive，防止把新 transport 正在连接的 session 销毁  
   `src/bridge/replBridge.ts:653-673`
3. 在 `registerBridgeEnvironment` await 之后，如果 `transport` 已恢复，也会在 `tryReconnectInPlace/archiveSession` 前直接退出，避免误杀新边界  
   `src/bridge/replBridge.ts:718-727`
4. Strategy 2 明确先 `archiveSession(currentSessionId)`，因为旧 session 已经是 orphaned object，不能继续以当前边界身份存活  
   `src/bridge/replBridge.ts:743-748`
5. pointer refresh timer 又专门防 race，避免旧 pointer 把 now-archived old session 重写成当前指针  
   `src/bridge/replBridge.ts:1512-1524`
6. `bridgeMain.ts` 在 resume path 上发现 session 已不存在时会清指针；fatal reconnect failure 也才允许清 pointer，transient failure 则故意保留 retry 通道  
   `src/bridge/bridgeMain.ts:2385-2398,2524-2534`
7. shutdown path 也明确指出：若准备保留 resume 能力，就不能 archive + deregister；反之环境已 gone 时必须清 pointer，否则 resume hint 会变成谎言  
   `src/bridge/bridgeMain.ts:1515-1577`

所以这一章的最短结论是：

`成熟安全系统不仅要防边界漂移，还要防已经失效的旧边界被重新认证为当前边界。`

## 3. Claude Code 源码已经把“旧边界复活”当成独立风险，而不是普通脏状态

## 3.1 stale transport 不是旧连接问题，而是可能把消息重新发向死 session

`src/bridge/replBridge.ts:617-623` 很关键。

在环境重连开始时，代码立刻提升 `v2Generation`，注释写得很明白：

`环境正在被重建，晚到的 stale transport 如果还继续接入，会被指到 dead session。`

这说明作者担心的不是“多来了一条旧连接”，  
而是：

`已经失效的边界对象会被旧 transport 重新挂接进当前控制面。`

所以这里的 generation bump，本质是：

`失效边界复活防护。`

## 3.2 poll loop 若已自救成功，就必须放弃 archive，否则会把新边界当旧边界误删

`src/bridge/replBridge.ts:653-673` 更进一步说明，`stopWork` 等待期间，系统始终承认边界可能已经变化。

如果这时 `currentWorkId` 被别的路径更新，  
代码会直接：

1. 认为 poll loop 已经恢复
2. 放弃继续走 archive path
3. 避免 destroy 新 transport 正在连接的 session

这说明 Claude Code 不把 reconnect 写成“一旦进入就执行到底”。  
它承认：

`当前准备清理的对象，可能已经不再是当前边界。`

一旦这个判断成立，  
后续 cleanup 必须立刻让位。

## 3.3 `transport !== null` 的短路，本质上是在阻止新边界被旧修复流程杀死

`src/bridge/replBridge.ts:718-727` 的保护也属于同一类。

环境重新注册回来后，  
如果发现 `transport` 已经存在，  
代码会直接退出，  
不再继续 `tryReconnectInPlace` 或 `archiveSession`。

这里最重要的不是短路本身，  
而是它背后的判断：

`旧修复流程不再拥有处理当前边界的资格。`

换句话说，  
当新边界已经成形，  
旧修复分支必须主动放弃对它的处置权。

## 3.4 Strategy 2 先 archive old session，等于在语义上宣布“旧边界已被正式撤销”

`src/bridge/replBridge.ts:743-748` 直接写明：

1. 旧 session 已 orphaned
2. 它绑定的是 dead env 或已被 reconnect reject
3. 因此必须先 archive

这非常重要。

因为它说明 archive 不是垃圾回收动作，  
而是：

`正式取消旧边界继续充当当前对象的资格。`

如果没有这一步，  
系统就会留下一个最危险的模糊区：

`旧 session 虽然理论上失效，但在控制面上仍像“也许还能继续用”。`

Claude Code 在这里没有留下这种灰区。

## 3.5 pointer race 的真正危险，不是写旧数据，而是把 archived object 再次立为 current pointer

`src/bridge/replBridge.ts:1512-1524` 是这一章最强的证据之一。

注释直接指出：

1. `doReconnect()` 会非原子地更新 `environmentId/sessionId`
2. 如果 pointer refresh timer 在窗口内触发
3. 旧写入可能覆盖新 pointer
4. 最终把指针留在 now-archived old session

这已经不需要任何抽象化解释了。  
作者自己就把 failure mode 命名成：

`旧 session 被重新写回当前指针。`

所以这里的风险不是 stale UI，  
而是：

`revival of revoked boundary`

## 3.6 resume path 的本质，不是“尽量帮用户继续”，而是“只在边界仍真实存在时才允许继续”

`src/bridge/bridgeMain.ts:2385-2398` 与 `2524-2534` 连起来很有力量。

它们说明：

1. 如果 server 上 session 已不存在，pointer 就必须被清除
2. 如果 reconnect failure 是 transient，就保留 pointer 作为 retry mechanism
3. 只有 fatal failure 才清 pointer

这说明 pointer 不是便利缓存，  
而是一个带资格语义的边界句柄。

它能否继续存在，  
取决于：

`旧边界是否仍有被正式恢复的可能。`

一旦没有这个可能，  
继续保留 pointer 就是在为旧边界复活制造入口。

## 3.7 shutdown path 更直接：错误的 archive+deregister 会把 resume command 说成谎言

`src/bridge/bridgeMain.ts:1515-1577` 非常值得重视。

这里作者明确写道：

1. 若当前模式允许 resume，就不能 archive + deregister
2. 否则打印出来的 resume command 会变成 lie
3. 但一旦环境真的 gone，又必须 archive / deregister 并清 pointer，因为此时 pointer 已 stale

这段代码说明系统真正想维护的不是“用户体验的一致性”，  
而是：

`恢复入口与真实边界状态之间的语义一致性。`

如果入口说能恢复，  
底层边界就必须真的还能恢复。  
否则这个入口本身就是一种错误授权。

## 4. 第一性原理：为什么“旧边界复活”比普通 stale state 更危险

从第一性原理看，  
普通 stale state 主要造成的是：

1. 误导
2. 延迟
3. 多一步确认成本

但旧边界复活会造成更严重的后果：

1. 已撤销对象重新获得当前身份
2. 已归档会话重新成为操作目标
3. 已失效通道重新接收控制消息
4. 已不存在的恢复入口继续被承诺为有效

所以它不是“显示错了”。  
它是：

`边界撤销被回滚。`

这也是为什么它必须被单独命名为安全问题。

## 5. 技术先进性：Claude Code 先进在它已经把“防复活”写进时序控制里

这部分的先进性主要体现在五点：

1. 它有 stale generation guard，而不是等旧 transport 自己消失
2. 它在 await 窗口里持续重新检查“当前边界是否已经变化”
3. 它把 archive 写成边界撤销动作，而不只是资源清理
4. 它把 pointer 看成资格对象，而不是普通缓存文件
5. 它明确区分 transient retry 与 fatal invalidation，避免过早清除恢复资产，也避免无资格复活

这说明 Claude Code 的 bridge 安全性已经不是“重连做得稳”这么简单，  
而是：

`它在用时序与对象生命周期共同守住边界撤销的不可逆性。`

## 6. 给下一代控制面的技术启示

如果把这一章压成设计规则，可以得到六条：

1. 任何被 archive / revoke / expire 的边界对象，都不应再被低层计时器、旧 callback 或旧 pointer 重新写成 current
2. 所有 reconnect / retry path 都应在每个 await 之后重新确认“我要操作的还是不是当前边界”
3. archive 不只是释放资源，还应被视为撤销当前身份资格
4. pointer / resume token / retry handle 都应有显式 invalidation policy
5. transient retry 与 fatal invalidation 必须分开，否则要么过早断恢复，要么错误保留复活入口
6. “恢复入口是否仍然真实”本身就是安全承诺，不得与底层事实脱钩

## 7. 苏格拉底式追问：这章还能逼出什么更深的判断

### 7.1 如果旧对象只是 stale，为什么作者要反复阻止 archive path 与 pointer write race

因为系统担心的不是旧信息残留，  
而是：

`旧对象被再次授予当前身份。`

### 7.2 如果 resume command 只是提示，为什么源码会说错误提示会成为 lie

因为恢复入口本身就携带授权含义。  
一条不存在的恢复入口，不是差文案，  
而是错误授权。

### 7.3 如果 pointer 只是缓存，为什么 transient failure 要保留、fatal failure 才清

因为 pointer 真正承载的是：

`这条边界是否仍可被正式恢复`

而不是简单的“上次 sessionId 记忆”。

## 8. 最终沉淀

这一章把 `83` 再往下压了一层：

1. `83` 说明真正保护对象是授权连续性
2. `84` 进一步说明最危险的 continuity failure 不是断裂本身
3. 而是已经撤销的旧边界被重新认证成当前边界

所以这一章最终沉淀出的规则是：

`一旦边界已被正式失效，任何旧路径都不得把它重新写回 current。`
