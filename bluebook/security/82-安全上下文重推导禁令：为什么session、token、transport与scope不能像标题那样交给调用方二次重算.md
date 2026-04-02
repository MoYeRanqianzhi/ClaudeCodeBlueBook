# 安全上下文重推导禁令：为什么session、token、transport与scope不能像标题那样交给调用方二次重算

## 1. 为什么在 `81` 之后还要继续写“上下文重推导禁令”

`81-安全能力闭包绑定` 已经回答了：

`真正成熟的 capability system，最后保护的不是名字，而是上下文。`

但如果继续往下追问，  
还会碰到一个更锋利、也更接近安全边界本体的问题：

`哪些上下文可以重推导，哪些绝不能重推导？`

因为在一个复杂系统里，  
并不是所有东西都不能重算。

有些字段本来就只是派生值，  
重算不仅无害，  
反而更灵活。

但另一些字段一旦交给调用方自己重推导，  
就会从“方便”瞬间滑到：

`边界漂移。`

所以在 `81` 之后，  
安全专题必须再补一条更硬的禁令：

`安全上下文重推导禁令。`

也就是：

`成熟控制面必须明确区分：哪些只是 cosmetic / derived context，可以重算；哪些属于 authority-bearing context，绝不能交给后来者自己二次拼装。`

## 2. 最短结论

从源码看，Claude Code 已经在 bridge 子系统里把这条禁令写得相当明确：

1. `replBridgeHandle.ts` 直接写明：handle 捕获了创建 session 的 `sessionId` 与 `getAccessToken`，独立重推导会带来 token divergence 风险  
   `src/bridge/replBridgeHandle.ts:5-13`
2. `replBridge.ts` 多处反复强调 `currentSessionId stays the same`，说明 session identity 不是允许调用方随便换算的普通派生值  
   `src/bridge/replBridge.ts:390-418,593-604,729-740`
3. 同文件又特地把 `onServerControlRequest` 设计成闭包捕获 `transport/currentSessionId`，避免 callback 自己再把这些关键上下文线程化重建  
   `src/bridge/replBridge.ts:1191-1200`
4. `1512-1524` 甚至专门为 pointer write race 加注释，说明在 reconnect 非原子窗口里，错误的再次写入会把指针写回已归档旧 session  
   `src/bridge/replBridge.ts:1512-1524`
5. 但 `initReplBridge.ts` 对 session title 的处理却明确说它只是 cosmetic only，并允许按第 1 次和第 3 次 prompt 再推导  
   `src/bridge/initReplBridge.ts:247-257`

所以这一章的最短结论是：

`Claude Code 并不是反对一切重推导，而是反对对承载主权的上下文重推导。`

我把它再压成一句：

`标题可以重算，authority context 不可以。`

## 3. 源码已经说明：真正的分界线不是“能不能推导”，而是“推导错了会不会改写边界”

## 3.1 `replBridgeHandle.ts` 已经把禁令写成明文：`sessionId` 和 `getAccessToken` 不该交给调用方重建

`src/bridge/replBridgeHandle.ts:5-13` 是这一章的核心证据。

注释非常直白：

1. handle 的闭包捕获了创建该 session 的 `sessionId`
2. 也捕获了 `getAccessToken`
3. 如果独立重推导这些值，会有 token divergence 风险

这意味着作者并不只是觉得：

`handle 用起来更方便`

而是在明确地说：

`某些上下文一旦脱离 creator-bound closure，就可能变错。`

所以这里的禁令不是编码风格，  
而是：

`authority context integrity rule`

## 3.2 session identity 为什么不能重算：因为系统把它当成持续存在的控制对象，而不是一次性字符串

`src/bridge/replBridge.ts:390-418`、`593-604` 与 `729-740` 连起来很能说明问题。

这里作者反复强调：

1. `currentSessionId never mutates` 在某些 reconnect path 下成立
2. `currentSessionId stays the same`
3. in-place reconnect 的意义之一就是 URL 继续有效、历史不重发

这说明 `currentSessionId` 在这里承担的不是“一个好算的标识符”，  
而是：

`持续控制对象的身份连续性。`

如果把它当成“反正可以再推一个 session id”，  
就会破坏：

1. 同一控制对象的连续性
2. 同一移动端 URL 的有效性
3. 同一历史账本的延续性

因此 session identity 不是一般派生字段，  
而是：

`不应由调用方自由再生的边界对象。`

## 3.3 callback 也不能自由重建关键上下文，所以作者让它直接吃闭包

`src/bridge/replBridge.ts:1191-1200` 有一句很强的注释：

`captures transport/currentSessionId so the transport.setOnData callback below doesn't need to thread them through`

这句话看起来像实现细节，  
其实是本章非常重要的原则证据。

因为它说明作者已经明确意识到：

`如果让 callback 自己去线程化传递这些关键上下文，错误率和漂移风险都会上升。`

所以他们选择：

1. 直接在闭包里捕获
2. 让 callback 拿到正确上下文
3. 避免后来者在调用链上自己拼

这和“不要让调用方重建 authority context”是同一条哲学。

## 3.4 race 注释进一步证明：一旦关键上下文被错时重推导，系统会把旧边界重新写回去

`src/bridge/replBridge.ts:1512-1524` 极其有力量。

这里作者解释了一个具体风险：

1. `doReconnect()` 会非原子地重设 `currentSessionId/environmentId`
2. 如果某个 timer 在这个窗口里 fire
3. 它 fire-and-forget 的 pointer write 可能覆盖 reconnect 正在写的新值
4. 最终把 pointer 留在已经归档的旧 session 上

这说明重推导/重写的风险并不抽象。  
它不是“也许有点脏”，  
而是：

`旧边界对象会被重新认证成当前边界。`

这正是安全控制面最该避免的结构性错误。

## 3.5 与之形成鲜明对照的是 title：作者明确说它只是 cosmetic only，所以允许二次推导

`src/bridge/initReplBridge.ts:247-257` 给了一个非常好的反例。

这里 session title 会按优先级不断派生：

1. explicit initialName
2. `/rename`
3. last meaningful user message
4. generated slug

并且作者明确写了：

`Cosmetic only ... the model never sees it.`

这太重要了。  
因为它说明 Claude Code 团队并不是教条地反对重推导。  
他们其实已经在源码里给出了分界线：

1. cosmetic only 的上下文可以多次推导
2. authority-bearing 的上下文不该让调用方自己重推导

换句话说，  
这不是“保守派不许重算”，  
而是：

`按边界后果区分可重算上下文与不可重算上下文。`

## 3.6 第一性原理：真正不该重算的，从来不是值本身，而是它所代表的授权关系

如果从第一性原理追问：

`为什么 sessionId、token、transport、scope 这些东西这么敏感？`

因为它们不是普通数据。

它们背后都对应一条授权关系：

1. 这个请求属于哪个 session
2. 这个调用使用哪一套 token 语义
3. 这个消息写向哪个 transport
4. 这条状态属于哪个 scope / family

一旦这些东西由后来者自己重算，  
系统就相当于允许后来者重新回答：

`我现在到底代表谁、对谁说话、在谁的边界里行动。`

这才是最根本的问题。

所以真正不该重算的不是“值”，  
而是：

`值后面的授权关系。`

## 3.7 技术先进性：Claude Code 的成熟之处在于它已经会明确写出“哪些上下文不许重算”

从技术角度看，  
很多系统的问题不是没有 handle，  
而是没有明确的禁令。

Claude Code 在这点上更成熟：

1. 它有 handle
2. 它也有注释明确说明为什么不能重推导
3. 它还能给出允许重推导的反例（title）
4. 它甚至对 race 条件下的错写风险有具体注释

这说明它已经不是“凭感觉做封装”，  
而是在逐步形成一条真正可迁移的设计法则：

`authority-bearing context must remain creator-bound`

## 4. 安全上下文重推导禁令的最短规则

把这一章压成最短规则，就是下面六句：

1. cosmetic only 的上下文可以重推导
2. authority-bearing 的上下文不应交给调用方二次重算
3. session identity、token 语义、transport 指向和 scope 归属都属于高风险上下文
4. callback 若依赖关键上下文，应优先闭包捕获而不是线程化重建
5. race 窗口里的再次写入往往不是刷新，而是旧边界复活
6. 真正成熟的 handle 体系必须伴随“禁止重推导”的明确纪律

## 5. 苏格拉底式追问：这套系统还能怎样再向前推进

如果继续自问，  
下一步最值得做的三项升级会是：

1. 把“cosmetic only / authority-bearing”做成显式字段，而不只靠注释说明
2. 把 notifications future handle 也分出哪些 metadata 可重算、哪些 scope 不可重算
3. 把“禁止调用方重推导关键上下文”上升成统一安全控制台的公共设计规则和 code review checklist

所以这一章最终沉淀出的设计启示是：

`成熟安全系统真正保护的，不是某个值，而是该值背后的授权连续性。`
