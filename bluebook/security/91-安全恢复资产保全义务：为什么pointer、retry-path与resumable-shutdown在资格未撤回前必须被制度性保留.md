# 安全恢复资产保全义务：为什么pointer、retry-path与resumable-shutdown在资格未撤回前必须被制度性保留

## 1. 为什么在 `90` 之后还要继续写“恢复资产保全义务”

`90-安全恢复资格清理权限` 已经回答了：

`clear pointer 不是普通 housekeeping，而是恢复资格的撤回权。`

但如果继续往下追问，  
还会碰到另一个同样重要、但方向相反的问题：

`在恢复资格尚未正式撤回前，系统又必须保留什么？`

因为如果只讨论：

1. 谁能清
2. 何时能清
3. 谁不能提前清

还不够。

安全系统还必须进一步承认：

`某些对象在资格未撤回前，不只是“暂时不该清”，而是“应被制度性保留”。`

在 Claude Code 的恢复链里，  
至少下面这些东西都已经不只是普通状态残留：

1. pointer
2. retry path
3. resumable shutdown 留下的 session/environment
4. perpetual suspend 留下的 REPL bridge pointer

这些对象一旦被错误撤销，  
系统损害的就不只是实现优雅性，  
而是：

`用户仍真实存在的恢复利益。`

所以在 `90` 之后，  
安全专题还必须再补一章，把“撤回权”继续推进成“保全义务”：

`恢复资产保全义务。`

也就是：

`成熟控制面不仅要谨慎撤回恢复资格，还必须在资格尚未被正式撤回前，主动保护那些承载恢复机会的对象不被错误抹掉。`

## 2. 最短结论

从源码看，Claude Code 已经把部分恢复对象当成应被制度性保留的资产：

1. resumable shutdown 路径直接 early return，不 archive、不 deregister、不 clear pointer，因为继续保留这些对象本身就是恢复承诺成立的前提  
   `src/bridge/bridgeMain.ts:1515-1538`
2. transient reconnect failure 明确要求保留 pointer，因为 `next launch re-prompts — that IS the retry mechanism`  
   `src/bridge/bridgeMain.ts:2524-2534`
3. REPL perpetual teardown 不是“不管它”，而是显式刷新 pointer mtime，让长时会话在下一次启动时仍保持 fresh recoverability  
   `src/bridge/replBridge.ts:1595-1615`
4. pointer 写入本身也被注释为 `kill -9 at any point after this leaves a recoverable trail`，说明它不是调试产物，而是 crash recovery 资产  
   `src/bridge/replBridge.ts:479-488`
5. stale/invalid pointer 才会被清；说明默认规则不是“尽量清”，而是“只有当资产已不再真实时才允许撤回”  
   `src/bridge/bridgePointer.ts:76-113`
6. fresh start 时会清 leftover pointer，是因为主流程已经明确决定当前不走 resume flow，这时保留旧资产只会制造 stale promise  
   `src/bridge/bridgeMain.ts:2316-2326`

所以这一章的最短结论是：

`Claude Code 不只在治理何时撤回恢复资格，它也在治理何时必须保全恢复资产。`

我把它再压成一句：

`未被正式撤回的恢复机会，必须有资产托底。`

## 3. 源码已经说明：某些恢复对象在资格未撤回前应被视为受保护资产

## 3.1 resumable shutdown 的 early return，本质上是在保全一整套恢复资产

`src/bridge/bridgeMain.ts:1515-1538` 很关键。

这里主流程并不是简单地说一句：

`这里先不清。`

它实际上同时保留了四类东西：

1. session 继续存活
2. environment 继续存活
3. pointer 继续存在
4. `--continue` 提示继续为真

这说明 resumable shutdown 不是“暂缓清理”，  
而是：

`把一整套恢复资产完整保留下来。`

这套资产任何一环丢掉，  
恢复承诺都会变脆甚至变假。

所以这已经超出了“别误删”的层次，  
进入了：

`必须保全`

的层次。

## 3.2 transient reconnect failure 里 pointer 被保留，不是容错宽松，而是明确的资产保护

`src/bridge/bridgeMain.ts:2524-2534` 的注释几乎把这一章的题眼写出来了：

`The session may still be resumable — try running the same command again.`

以及：

`next launch re-prompts — that IS the retry mechanism`

这两句合起来说明：

1. pointer 在这里不是旁路文件
2. 它就是 retry mechanism 的一部分
3. 清掉它，不是“少一个缓存”
4. 而是直接拆掉用户的下一步恢复路径

所以 transient failure 下保留 pointer 不是“保守一点别删”，  
而是：

`系统在保护一个仍然真实存在的恢复资产。`

## 3.3 REPL perpetual teardown 里的 mtime refresh 说明：资产不只要保留，还要持续保鲜

`src/bridge/replBridge.ts:1595-1615` 很有意思。

如果只是“不清 pointer”就够了，  
作者其实不需要额外 refresh mtime。  
但源码明确还做了：

1. `writeBridgePointer(...)`
2. 目的就是避免长时会话在下次启动时看起来 stale

这说明对 Claude Code 来说，  
恢复资产保护不只是：

`别删`

还包括：

`别让它因为时间腐蚀而失去资格。`

从第一性原理看，  
这已经是非常成熟的资产观：

`真正被保护的对象不只是存在性，还有可用性。`

## 3.4 pointer 在 crash 路径里被写成 “recoverable trail”，说明它属于事故恢复资产

`src/bridge/replBridge.ts:479-488` 对 pointer 的定义非常值得重视。

注释没有把它写成：

`用于下次可能参考`

而是明确写成：

`kill -9 at any point after this leaves a recoverable trail`

这说明 pointer 在作者心里是：

`事故恢复资产`

它的意义不是提高便利性，  
而是确保在非正常终止后，  
仍有一条可追索的恢复路径。

而事故恢复资产天然就应受到比普通状态更高一级的保全要求。

## 3.5 stale/invalid 才清，说明资产保护的默认哲学是“先保留，后证明失效”

`src/bridge/bridgePointer.ts:76-113` 给出了一个很明确的哲学：

1. schema invalid -> clear
2. TTL stale -> clear
3. 否则保留

这意味着默认规则不是：

`先清掉，除非证明还该留`

而是：

`先保留，除非证明已不再真实。`

这是一条非常关键的安全哲学。  
因为在恢复资产场景里，  
错误清掉的代价通常比错误多留一步更高。

所以 Claude Code 在这里实际上已经在实行：

`preserve by default, revoke on proof`

## 3.6 fresh start 清 leftover pointer，反而说明保全义务也必须服从当前主路径

`src/bridge/bridgeMain.ts:2316-2326` 看似是清理逻辑，  
其实反过来也证明了保全义务的边界。

当当前这次启动明确：

1. 不走 `--continue`
2. 不打算恢复旧边界

那么旧 pointer 就不再是“当前用户仍在追索的恢复资产”，  
而会变成：

`stale env lingering past relevance`

也就是说，  
恢复资产并不是永远都该保留。

它只在一个前提下受保护：

`当前主路径仍承认它是活的恢复机会。`

这也让保全义务更精确：

`不是无条件保留，而是只对仍然真实的恢复机会保留。`

## 3.7 第一性原理：恢复资格如果没有资产托底，就会退化成空头承诺

如果从第一性原理看，  
“仍可恢复”其实是一句资格声明。  
但资格声明要成立，  
必须有可被用户继续追索的对象托底：

1. 有 pointer
2. 有 session
3. 有 environment
4. 有 retry path
5. 有不被提前清理的 carrier

如果这些资产不存在，  
那么“仍可恢复”就只是：

`空头 promise`

这也解释了为什么恢复资格保全义务不能被视为附属逻辑。  
它实际上是 promise honesty 的物质基础。

## 3.8 技术先进性：Claude Code 已经开始把 recoverability asset 当成受保护对象

从技术角度看，  
很多系统在恢复问题上只做两类事情：

1. 失败后重试
2. 失败后清理

但 Claude Code 这里更成熟的地方在于：

1. 它会在某些路径上显式保护资产不被撤回
2. 会为长时会话刷新资产 freshness
3. 会把 retry mechanism 明确绑定到 pointer 保留
4. 会把 resumable shutdown 明确写成 preserve path
5. 会在 fresh start 时只清“当前已不再相关”的旧资产

这说明它已经不是在“做恢复功能”，  
而是在：

`治理恢复资产的保全义务。`

## 4. 安全恢复资产保全义务的最短规则

把这一章压成最短规则，就是下面七句：

1. 未被正式撤回的恢复资格，必须有可追索资产托底
2. pointer、retry path、resumable shutdown 留下的 session/env 都属于恢复资产
3. 资产保护不只是不删，还包括保持 freshness
4. transient failure 场景默认应保护恢复资产
5. suspend/resumable 场景应优先保全资产，而不是优先清理
6. stale/invalid 证明成立前，不应轻易撤销资产
7. 成熟控制面不只会撤权，也会在该保留时制度性保全恢复利益

## 5. 苏格拉底式追问：这套系统还能怎样再向前推进

如果继续自问，  
下一步最值得补的三项升级会是：

1. 把 recoverability asset 显式建模成对象，例如 `pointer`, `retry_mechanism`, `resume_hint`, `recoverable_session`
2. 给每种资产标明 `preservation_owner`、`expiry_basis` 和 `revocation_condition`
3. 在统一安全控制台里直接展示“当前哪些恢复资产仍被保护、为什么被保护、何时会失去保护”

所以这一章最终沉淀出的设计启示是：

`成熟安全系统不仅要防错误撤权，还必须在撤权条件未成立前主动保全用户仍真实拥有的恢复资产。`
