# 安全恢复合法性：为什么只要剩余可恢复性仍在，系统就必须禁止destructive cleanup

## 1. 为什么在 `68` 之后还要继续写“恢复合法性”

`68-安全恢复错误路径禁令` 已经回答了：

`系统不只要给出 dominant repair path，还必须主动禁止邻近 wrong path。`

但如果再追问一步，  
就会逼近恢复安全里最核心的一类 wrong path：

`destructive cleanup。`

也就是那些看起来像“清爽收尾”，  
实则会提前销毁恢复能力的动作：

1. `archiveSession`
2. `deregisterEnvironment`
3. `clearBridgePointer`
4. 自动消费 `needsRefresh`
5. 继续沿用旧缓存、旧 closure、旧凭据去“重连”

所以在 `68` 之后，  
统一安全控制面还必须补一条更深的原则：

`恢复合法性。`

也就是：

`只要对象仍保留剩余可恢复性，系统就必须把 destructive cleanup 视为非法动作。`

这里的“剩余可恢复性”不是抽象口号，  
而是源码里反复出现的几类现实资产：

1. `resume` 价值
2. `retry` 价值
3. `fresh pointer / fresh anchor` 价值
4. `needsRefresh` 这类待消费恢复信号
5. 仍可被正确重建的 fresh config / fresh credential 路径

## 2. 最短结论

从源码看，Claude Code 已经反复把这条原则写成实现细节：

1. 如果 bridge session 仍可 `--continue`，就跳过 `archive + deregister + clear pointer`  
   `src/bridge/bridgeMain.ts:1515-1537`
2. 如果 resume reconnect 只是 transient failure，就保留 pointer，不允许把 retry 机制自己删掉  
   `src/bridge/bridgeMain.ts:2524-2540`
3. 如果 REPL poll loop 已经自行恢复，就停止后续 stop/archive/rebuild，避免销毁刚恢复的 session  
   `src/bridge/replBridge.ts:653-672,718-727`
4. 如果是 perpetual teardown，就本地退出而不向服务端宣告结束，并刷新 pointer，保留下次重连能力  
   `src/bridge/replBridge.ts:1595-1615`
5. 如果 plugins 只是 updated 而不是 fresh install，就只设置 `needsRefresh`，明确禁止自动刷新与提前 reset  
   `src/hooks/useManagePlugins.ts:32-35,287-303`  
   `src/services/plugins/PluginInstallationManager.ts:166-178`
6. 如果 MCP config / auth 变化，就要先拆旧 timer、旧 onclose、旧缓存，再走 fresh reconnect；错误顺序本身就是恢复破坏  
   `src/services/mcp/useManageMCPConnections.ts:782-808,1093-1100`  
   `src/services/mcp/client.ts:2147-2155`

所以这一章的最短结论是：

`恢复系统最危险的错误，不是没去修，而是在恢复能力还存在时，过早做了不可逆清理。`

我把它再压成一句话：

`cleanup 不是默认合法动作，cleanup 必须等到 recoverability 被正式耗尽。`

## 3. 源码已经说明：Claude Code 到处都在保护剩余可恢复性

## 3.1 bridge 可恢复时，`archive + deregister + clear pointer` 都不合法

`src/bridge/bridgeMain.ts:1515-1537` 是最直白的一段证据。

作者明确写到：

1. single-session 模式
2. 已知 `initialSessionId`
3. 且不是 fatal exit

这三个条件同时满足时，  
系统直接跳过：

1. `archiveSession`
2. `deregisterEnvironment`
3. 后续 `clearBridgePointer`

理由也写得非常清楚：

`否则打印出来的恢复命令会变成谎言。`

这句话很重要。  
它说明 cleanup 在这里不是“更整洁”，  
而是：

`会直接销毁仍然存在的 resume 价值。`

同文件 `src/bridge/bridgeMain.ts:1573-1577` 又反过来表明：  
只有当环境真的被注销、pointer 才正式失去代表性时，  
清 pointer 才是合法动作。

也就是说，  
cleanup 的合法性不是由“现在准备退出了”决定，  
而是由：

`resume 是否仍然真实`

决定。

## 3.2 pointer 不是垃圾文件，而是恢复能力本身

`src/bridge/bridgePointer.ts:22-34` 已经把 pointer 的角色说得很明确：

1. session 创建后立即写入
2. 运行期间持续 refresh
3. clean shutdown 才清理
4. crash / kill -9 / terminal closed 时故意保留
5. 下次启动靠它触发恢复提示

同文件 `src/bridge/bridgePointer.ts:56-60,76-82` 进一步说明：

1. pointer 的 mtime 就是 staleness data 本身
2. stale / invalid 才该被删除
3. 删除 stale pointer 的目的，是避免反复用假恢复入口误导用户

所以 pointer 在这里不是待清理杂物，  
而是：

`被制度化保存的恢复权利。`

这条设计的哲学含义很深：

`成熟控制面不会把恢复证据当脏状态，而会把它当受保护资产。`

## 3.3 resume reconnect 失败时，transient 与 fatal 必须分开决定 cleanup 合法性

`src/bridge/bridgeMain.ts:2384-2398` 已经说明：  
只有当 session 在服务端确实不存在，  
pointer 才被判为 stale 并清掉。

更关键的是 `src/bridge/bridgeMain.ts:2524-2540`。

这里作者明确写到：

1. transient reconnect failure 时 `Do NOT deregister`
2. 否则 retry 会变得不可能
3. pointer 也只在 `fatal` 时清
4. transient failure 还要保留“下次再试”的提示

这说明系统并不是简单按“失败了就清理”处理，  
而是在判断：

`这次失败，是恢复能力耗尽了，还是只是本次尝试失败了？`

如果只是后者，  
那么：

1. `deregisterEnvironment` 非法
2. `clearBridgePointer` 非法
3. “请重试同一命令”才是合法路径

这就是恢复合法性的精髓：

`失败不等于可恢复性归零。`

## 3.4 REPL 重连链也在反复禁止“抢先清理”

`src/bridge/replBridge.ts:617-727` 是另一条很强的证据链。

这里的 `doReconnect()` 在多个 await 窗口后都重复检查：

1. poll loop 是否已经恢复
2. transport 是否已经被新路径重建
3. teardown 是否已经开始

尤其是 `src/bridge/replBridge.ts:653-672` 和 `718-727`：  
如果等待 `stopWork` 或 `registerBridgeEnvironment` 期间，  
poll loop 已经拿到 fresh work、恢复了 transport，  
函数会直接停止后续动作并“defer to it”。

为什么？

因为继续往下走就会触发：

1. `archiveSession`
2. fresh session creation
3. 更多 cleanup / replacement

而这些动作会把“已经恢复好的对象”再摧毁一次。

这说明恢复系统最成熟的地方，  
恰恰不是它会重建多少对象，  
而是：

`它知道什么时候必须停止重建。`

## 3.5 perpetual teardown 说明“干净退出”并不总比“保留恢复轨迹”更高级

`src/bridge/replBridge.ts:1595-1615` 更进一步。

这里作者明确规定 perpetual teardown 是 `LOCAL-ONLY`：

1. 不发 result
2. 不调 `stopWork`
3. 不关闭 transport
4. 只停止本地 poll
5. 刷新 pointer mtime
6. 把服务端 session 留给下次启动去 `reconnectSession`

这几乎是在反工程直觉：

`不是所有退出都应该尽量清理干净。`

因为对恢复系统来说，  
有时“干净”意味着：

`把将来唯一能接上的那条线也一起剪断。`

所以这里真正被提升为高阶原则的是：

`保留可恢复性，比追求当前回合的整洁退出更重要。`

## 3.6 plugins 的 `needsRefresh` 不是脏位，而是待消费的恢复信号

`src/hooks/useManagePlugins.ts:32-35,287-303` 很值得写进这一章。

作者明确说：

1. state changed on disk 时只发通知
2. `Do NOT auto-refresh`
3. `Do NOT reset needsRefresh`
4. 真正消费它的入口只能是 `/reload-plugins`

同样，  
`src/services/plugins/PluginInstallationManager.ts:166-178` 也表明：

1. marketplace updated 时
2. 系统只设置 `needsRefresh`
3. 由用户决定何时 `/reload-plugins`

而 `src/services/plugins/PluginInstallationManager.ts:145-164` 又说明：  
即便 fresh install 触发的 auto-refresh 失败，  
系统也会降级回：

`保留 needsRefresh`

而不是把失败路径静默抹平。

这说明 `needsRefresh` 在这里不是普通状态位，  
而是：

`尚未被合法消费的恢复能力。`

提前 reset 它，  
等于把修复权提前宣告完成，  
这正是一种 destructive cleanup。

## 3.7 MCP 侧进一步说明：错误顺序的 cleanup 会主动制造伪恢复

`src/services/mcp/useManageMCPConnections.ts:782-808` 直接列出了 stale client cleanup 前必须先排掉的三类 hazard：

1. 旧 reconnect timer 可能带着 old config 再次触发
2. 旧 `onclose` closure 可能带着 old config 重新抢写状态
3. `clearServerCache` 可能在错误对象上诱发无意义连接

同文件 `src/services/mcp/useManageMCPConnections.ts:1093-1100` 又说明：  
disable server 时必须先把 disabled state 落盘，  
再去清 cache，  
因为 `onclose` 的判断读的是 disk state。

`src/services/mcp/client.ts:2147-2155` 则把 reconnect 的合法顺序写死：

1. `clearKeychainCache()`
2. `clearServerCache(...)`
3. `connectToServer(...)`

作者甚至明确说：  
如果不先清 keychain cache，  
subprocess 会一直使用 stale cached credentials，  
永远意识不到 token 已被移除。

这说明在 MCP 这一层，  
恢复合法性进一步变成了：

`只有按正确顺序清理旧凭据、旧缓存与旧闭包，fresh reconnect 才合法。`

错序 cleanup 并不是小 bug，  
而是会直接制造伪恢复。

## 4. 第一性原理：recoverability 是资产，不是副作用

如果从第一性原理追问：

`为什么系统要如此克制 cleanup？`

因为恢复系统里最珍贵的，  
往往不是当前已经成功的状态，  
而是：

`下一次仍然能成功的可能性。`

只要这份可能性还存在，  
就对应着某种受保护资产：

1. pointer
2. session binding
3. retry window
4. pending refresh signal
5. fresh credential path
6. 尚未被销毁的旧对象与新对象切换顺序

所以 recovery legality 的第一性原理可以压成一句：

`recoverability is an asset.`

进一步展开，就是：

1. 不是所有旧状态都该立刻删
2. 不是所有失败都该立刻 terminalize
3. 不是所有“我能清掉它”都等于“我现在有资格清掉它”

因此一条成熟的恢复规则，  
至少要同时回答四个问题：

1. 当前还剩哪种 recoverability
2. 哪个对象承载这份 recoverability
3. 什么 cleanup 会摧毁它
4. 何时 cleanup 才重新合法

## 5. 苏格拉底式自问：为什么“保留恢复能力”比“立刻清爽”更重要

### 5.1 既然旧对象可能已经出错，为什么不尽快清掉

因为“旧对象出错”和“旧对象已无恢复价值”不是同一句话。

一个 session 可以暂时失败，  
但仍可 resume；  
一个 plugin 状态可以过期，  
但 `needsRefresh` 仍是真实信号；  
一个 pointer 可以旧，  
但在 TTL 内仍是唯一合法入口。

### 5.2 cleanup 不是更安全吗

不是。

如果 cleanup 发生得太早，  
它会把系统从“可恢复失败”推进到“不可恢复失败”。

这种 cleanup 不增加安全，  
只增加不可逆损失。

### 5.3 那是不是永远都不该清理

也不是。

这条原则不是“拒绝 cleanup”，  
而是：

`cleanup 必须晚于 recoverability 的正式失效。`

比如：

1. env 真正 deregister 后，pointer 清理合法
2. session 真正不存在后，resume prompt 清理合法
3. `/reload-plugins` 正式消费 `needsRefresh` 后，信号清理合法
4. fatal reconnect failure 确认后，旧 retry path 才可关闭

### 5.4 这条原则会不会让系统变得保守、拖沓

会更克制，但不会更拖沓。

真正拖慢系统的，  
往往不是“多保留一条恢复线索”，  
而是：

`过早清理后，用户只能从更长的冷启动路径重新来过。`

## 6. 技术先进性与技术启示

这一章最重要的技术判断是：

`Claude Code 的先进性不只在于它会做恢复，而在于它把“何时不该清理”也做成了正式工程规则。`

它先进的地方有五点：

1. 把 pointer、needsRefresh、retry window 这些对象当恢复资产，而不是 UI 噪音
2. 把 transient failure 与 fatal failure 对 cleanup 合法性的影响明确分开
3. 把 cleanup 的时序条件写进实现，而不是留给调用者猜
4. 在 bridge、REPL、plugins、MCP 四条链上重复贯彻同一原则
5. 宁可保留恢复轨迹，也不为了“干净”而提前摧毁 future recovery

对其他 Agent 平台构建者的直接启示有六条：

1. 把 recoverability object 显式建模出来，不要把它们藏在实现细节里
2. 所有 destructive cleanup 都要绑定 release condition
3. 区分“本次尝试失败”和“未来恢复能力耗尽”
4. 把 retry mechanism 本身当成受保护资产
5. 让 stale cleanup 与 fatal cleanup 使用不同证据门槛
6. 把“会不会把恢复路径自己删掉”作为每个 cleanup PR 的审查问题

## 7. 我给统一安全控制面的新增字段

如果把这一章产品化，  
我会要求每个恢复对象至少再补四个字段：

1. `remaining_recoverability`
2. `protected_recovery_object`
3. `forbidden_destructive_cleanup`
4. `cleanup_release_condition`

这样系统才不只是告诉用户“现在坏了没”，  
还能告诉用户：

`当前还有什么恢复资产在被保护、哪些清理动作现在不合法、以及何时它们才会重新合法。`

## 8. 一条硬结论

对 Claude Code 这类恢复控制面来说，  
最危险的 cleanup 不是删错东西，  
而是：

`在恢复能力还存在时，过早把未来唯一合法的恢复入口一起删掉。`

所以比“错误路径禁令”更深一层的原则是：

`只要剩余可恢复性仍在，destructive cleanup 就不是收尾动作，而是新的破坏动作。`
