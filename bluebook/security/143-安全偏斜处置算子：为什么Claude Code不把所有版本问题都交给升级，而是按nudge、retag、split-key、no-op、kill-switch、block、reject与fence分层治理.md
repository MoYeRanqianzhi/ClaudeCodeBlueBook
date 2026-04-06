# 安全偏斜处置算子：为什么Claude Code不把所有版本问题都交给升级，而是按nudge、retag、split-key、no-op、kill-switch、block、reject与fence分层治理

## 1. 为什么在 `142` 之后还必须继续写“偏斜处置算子”

`142-安全版本偏斜治理` 已经回答了：

`Claude Code 治理的不是一个抽象的“旧版本”，而是 app 可见性偏斜、compat tag 错位、grammar 错版、配置代际分流与 transport generation skew 这些不同错位对象。`

但如果继续追问，  
还会碰到另一个更工程化的问题：

`既然不同 skew object 已经被分型，那系统到底按什么处置算子来对付它们？`

因为“把对象分清”只完成了一半。  
另一半是：

`针对不同错位，应该提示、翻译、冻结、分键、no-op、阻断、拒绝，还是直接丢弃陈旧世界？`

如果没有这层处置语法，  
分类学就仍然很容易退化回：

1. 遇到问题先提示升级
2. 真不行再随手加个兼容判断
3. 最后把真正危险的 stale world 当成普通异常收掉

所以 `142` 之后必须继续补的一层就是：

`安全偏斜处置算子`

也就是：

`成熟安全系统不仅要知道“错位属于哪一类”，还要知道“这类错位该用哪一种固定动作去治理”。`

## 2. 最短结论

Claude Code 当前源码已经展示出至少八种相对清晰的偏斜处置算子：

1. `nudge`  
   app 可见性滞后时提醒升级，但不阻断会话  
   `src/hooks/useReplBridge.tsx:607-614`
2. `retag / translate`  
   `session_*` / `cse_*` 错位时重写 costume，而不是误判 foreign  
   `src/bridge/sessionIdCompat.ts:25-57`
3. `split-key`  
   新旧代际读不同配置键，而不是共用一把旧钥匙  
   `src/bridge/pollConfigDefaults.ts:77-80`
4. `no-op`  
   当前 transport 不支持某能力时，明示这一路径是 no-op  
   `src/bridge/replBridgeTransport.ts:51-66`
5. `kill-switch`  
   过渡 shim 被正式建模成可退场协议部件  
   `src/bridge/bridgeEnabled.ts:132-145`
6. `block`  
   CLI version floor 不满足时，直接不让进入路径  
   `src/bridge/initReplBridge.ts:410-420,456-460`
7. `reject`  
   grammar version 错了就直接拒绝输入  
   `src/bridge/workSecret.ts:5-18`
8. `fence / discard stale world`  
   新一轮 generation 出现后，旧握手与旧 refresh 直接失效  
   `src/bridge/replBridge.ts:1373-1426`  
   `src/bridge/jwtUtils.ts:121-123,176-183`

这些证据合在一起说明：

`Claude Code 的工程成熟度，不只在于它知道世界会错位，还在于它把错位后的治理动作做成了一套相对稳定的操作语法。`

因此这一章的最短结论是：

`cleanup future rollout 若想真正成熟，不应只有字段设计、capability negotiation 与 skew taxonomy，还必须明确为不同 skew object 分配固定 remediation operator。`

再压成一句：

`安全升级的高级形态，不是“看到偏斜再临时想办法”，而是“偏斜一出现就能落到预定算子上”。`

## 3. 第一性原理：为什么真正的升级治理不是“给出解释”，而是“执行正确动作”

如果一个系统能说清楚：

`这里是 visibility skew。`

这还不等于它真的会治理这个 skew。

从第一性原理看，  
一个成熟的安全控制面必须把每类错位继续压成：

1. admission action
2. display action
3. translation action
4. stale-world disposal action

否则再漂亮的 taxonomy 也只是：

1. 文档上的分类
2. 调试时的口头解释
3. 代码里的临时 if/else

所以从第一性原理看：

`治理的完成态不是“能描述异常”，而是“异常一旦出现，系统会自动落到正确动词”。`

## 4. `nudge`：当错位只是可见性问题时，系统不应越级阻断

`src/hooks/useReplBridge.tsx:607-614` 清楚展示了 `nudge` 算子：

1. v2 bridge 仍然初始化成功
2. 只在 transcript 中追加一条 bridge status message
3. 可选附加：
   `Please upgrade to the latest version of the Claude mobile app to see your Remote Control sessions.`

这配合 `src/bridge/envLessBridgeConfig.ts:156-164` 的 `shouldShowAppUpgradeMessage()`，  
说明 Claude Code 把 app 过旧治理成：

`提示型算子`

而不是：

`路径阻断型算子`

这很关键。  
因为它体现出一个高级原则：

`当底层真相已成立、只是上层可见性滞后时，系统应该修补认知，而不是误伤能力。`

## 5. `retag / translate`：当错位只是 costume 不同，系统应重写外衣而不是重写身份

`src/bridge/sessionIdCompat.ts:25-57` 给出 `retag / translate` 的最纯粹形式：

1. `toCompatSessionId()`
2. `toInfraSessionId()`

这里最重要的不是字符串转换本身，  
而是背后的哲学：

`当错位只发生在兼容层 costume 上，治理动作不该是 deny，而该是 translate。`

`src/bridge/replBridge.ts:392-401` 又把这种哲学推进到 reconnect path：

1. pre-poll 不知道 gate state
2. 就尝试 `[sessionId, infraId]` 两种 candidate
3. retag 对已经是目标 form 的 ID 是 no-op

这说明成熟的 translate 算子还有两个特征：

1. 不要求调用方先知道全部 gate 状态
2. 自身应幂等

对 cleanup future design 的启示很大。  
如果未来 cleanup object 也会在不同 surface 之间换 carrier / tag，  
更安全的动作往往不是“重新解释对象”，  
而是：

`先把对象翻回当前层真正认得的 costume。`

## 6. `split-key` 与 `no-op`：当代际对象并不对等时，不应强迫共享同一接口

### 6.1 `split-key`：不让新旧客户端争同一把配置钥匙

`src/bridge/pollConfigDefaults.ts:77-80` 写得很直白：

1. `session_keepalive_interval_v2_ms`
2. `pre-v2 clients read the old key`
3. `new clients ignore it`

这就是一个很成熟的 `split-key` 算子。

它承认：

`当对象已经分代，继续共用同一 key 反而会制造解释混乱。`

### 6.2 `no-op`：部分路径缺能力时，要把缺失建模成“有意不做”

`src/bridge/replBridgeTransport.ts:51-66` 明确把多处 v1 path 标成：

1. `reportState`  
   `v2 only; v1 is a no-op`
2. `reportMetadata`  
   `v2 only; v1 is a no-op`
3. `reportDelivery`  
   `v2 only; v1 is a no-op`

这说明 Claude Code 并没有把“当前代际不支持”的情况伪装成“接口统一成功”，  
而是把它正式建模成：

`这条动词在当前代际上存在，但故意不执行。`

这非常重要。  
因为 `no-op` 不是偷懒，  
它其实是在说：

`我们知道这个动作属于更高代际，但当前对象不配承担它。`

## 7. `kill-switch`：过渡协议部件不是永恒遗产，而应拥有退出权

`src/bridge/bridgeEnabled.ts:132-145` 里的 `isCseShimEnabled()` 很有代表性：

1. `cse_* -> session_*` retag shim 不是偷偷存在
2. 它有显式 kill-switch
3. 默认开启，直到 server/frontend 真正跟上

这说明 Claude Code 把 compatibility shim 理解成：

`带退场计划的过渡部件`

而不是：

`历史包袱，先加上再说`

这类算子的哲学价值很高。  
因为没有 kill-switch 的 compat 层，  
几乎一定会变成：

1. 永久附着
2. 谁也不敢删
3. 最后与新世界一起共存成双重真相

## 8. `block` 与 `reject`：不是所有强动作都一样，路径资格和输入合法性应分开

### 8.1 `block`：路径资格不成立，就不允许进入

`src/bridge/initReplBridge.ts:410-420,456-460` 的 `version_too_old` 属于很纯粹的 `block`：

1. 检查 min version
2. 不满足就 failed
3. 不让进入路径

这里治理的对象是：

`当前运行体是否有资格进入这条远程控制路径`

### 8.2 `reject`：输入 grammar 非法，就不接受输入

`src/bridge/workSecret.ts:5-18` 的 `Unsupported work secret version` 则属于 `reject`：

1. 不是路径选择问题
2. 而是输入对象本身非法
3. 所以直接抛错拒绝

这组区分特别值得保留。  
因为很多系统会把两者都压成 generic error，  
但 Claude Code 隐含做的是：

1. `block` 处理 actor/path 资格
2. `reject` 处理 object grammar 合法性

对 cleanup future design 来说，  
这提醒我们：

1. cleanup contract version 过低也许该 `block`
2. cleanup signer envelope 错版也许该 `reject`

两者不应混成一种失败语义。

## 9. `fence`：当陈旧世界仍可能回魂时，系统必须主动切断它的后续写权

### 9.1 transport generation fencing

`src/bridge/replBridge.ts:1373-1426` 已经展示了很清楚的 `fence` 算子：

1. 任意新 transport 都 bump generation
2. 旧 v2 handshake resolve 后先对比 generation
3. 不匹配就：
   `discarding stale handshake`
   `t.close()`

这说明系统治理的不是异常，  
而是：

`旧世界的延迟归来`

### 9.2 token refresh generation fencing

`src/bridge/jwtUtils.ts:121-123,176-183` 又把相同哲学用在 JWT refresh 上：

1. schedule / cancel 都 bump generation
2. `doRefresh()` await 之后重新检查 generation
3. 过期就直接：
   `stale ... skipping`

这里的重点在于：

`fence` 不只用于 transport，也用于后续异步调度链。

### 9.3 flush gate：不让 closed uploader 把旧世界的 silent loss 带进新世界

`src/bridge/remoteBridgeCore.ts:482-487` 则把 `fence` 进一步推进到写队列：

1. 旧 transport epoch 一旦 stale，下一次写/heartbeat 会 409
2. 如果不先 `flushGate.start()`
3. 旧 uploader 可能 closed 后 silent no-op
4. 导致 permanent silent message loss

这说明更成熟的 `fence` 不只是“丢弃旧对象”，  
还包括：

`在世界切换期间先关闸，避免旧世界最后再写一笔假账。`

## 10. 一张可迁移的 remediation operator 选择表

综合以上源码，可以压出一张简单但很有用的规则：

1. visibility skew -> `nudge`
2. routing / costume skew -> `retag / translate`
3. generation-diverged config / client family -> `split-key`
4. feature absent on lower generation -> `no-op`
5. temporary compat bridge -> `kill-switch`
6. actor/path not qualified -> `block`
7. object grammar invalid -> `reject`
8. stale world still writing -> `fence`

这张表的价值在于，  
它把“升级治理”从松散经验变成了：

`一套可以被复制到其他高风险语义迁移中的动作语法。`

## 11. 对 cleanup future design 的直接启示

cleanup 未来若真的进入多宿主、多代际生态，  
最值得借用的不是某一个具体字段，  
而是这套处置学：

### 11.1 不要凡事都提示升级

有些问题该提示，  
但有些问题其实应该：

1. translate
2. split-key
3. block
4. reject
5. fence

### 11.2 cleanup rollout 也应有自己的 operator matrix

更成熟的 cleanup migration 设计，很可能需要明确：

1. cleanup visibility skew -> `nudge`
2. cleanup carrier skew -> `retag / translate`
3. cleanup weak-surface support gap -> `no-op` / downgrade
4. cleanup compat shim -> `kill-switch`
5. cleanup contract floor mismatch -> `block`
6. cleanup proof envelope mismatch -> `reject`
7. cleanup stale ack / stale signer -> `fence`

这些对象是基于现有 operator 哲学做的推导，  
不是当前源码中已经存在 cleanup-specific operator。

## 12. 我们当前能说到哪一步，不能说到哪一步

基于当前可见源码，  
我们可以稳妥地说：

1. Claude Code 已拥有一套相当清晰的 skew remediation operator grammar
2. 这套 grammar 跨 bridge、compat、credential、async scheduling 多层复用

但我们不能说：

1. cleanup operator matrix 已经正式编码
2. cleanup-specific `block / reject / fence` 已经存在实现

所以必须把结论压在这一层：

`Claude Code 已展示出从“偏斜分类”走向“偏斜处置语法”的工程成熟度；cleanup future design 最值得抄的，不只是 taxonomy，而是这种 operator-first 的治理方法。`

## 13. 苏格拉底式追问：如果这章还要继续提高标准，还缺什么

还可以继续追问六个问题：

1. cleanup proof mismatch 到底属于 `block` 还是 `reject`
2. 哪些 cleanup weak surface 更适合 `no-op`，哪些必须 loud downgrade
3. cleanup compat shim 应该由谁持有 kill-switch
4. cleanup generation fencing 是否应绑定 audit ledger
5. split-key 与 optional-field 何时该同时使用，何时只能选一种
6. operator matrix 是否应进入 conformance tests，防止未来回退成“都提示升级”

这些问题说明：

`版本偏斜治理回答的是“不同错位对象是什么”，偏斜处置算子回答的则是“对象一旦错位，系统必须说哪个动词”。`
