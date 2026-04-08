# `writeMessages`、`writeSdkMessages`、`initialMessageUUIDs`、`recentPostedUUIDs` 与 `flushGate`：为什么 REPL path 与 daemon path 不是同一种 bridge write contract

## 用户目标

55 已经把 bridge 的多层防重拆成：

- outbound echo filter
- inbound replay guard
- viewer local echo guard

189 已经把 continuity contract 拆成：

- v1 continuity ledger
- v2 fresh-session replay

但如果正文停在这里，读者还是很容易把 bridge 的两个写入口继续写平：

- `writeMessages(...)` 和 `writeSdkMessages(...)` 不都是把消息写进同一个 bridge transport 吗？
- 它们最后都走 `writeBatch(...)`，为什么不能算同一种 write contract？
- `recentPostedUUIDs` 既然两边都在用，差别是不是只是一个先做转换、一个不做转换？
- `flushGate`、`initialMessageUUIDs` 这些东西真的属于不同合同，还是只是 REPL path 的实现细节？

这句还不稳。

从当前源码看，这里至少还要继续拆开两种不同对象：

1. REPL write contract
2. daemon write contract

如果这两层不先拆开，后面就会把：

- `writeMessages(...)`
- `writeSdkMessages(...)`
- `initialMessageUUIDs`
- `recentPostedUUIDs`
- `flushGate`

重新压成一句模糊的“bridge 写消息接口”。

## 第一性原理

更稳的提问不是：

- “两个 write 函数最后不都在发 SDK message 吗？”

而是先问六个更底层的问题：

1. 当前入口拿到的是内部 `Message[]`，还是已经成形的 `SDKMessage[]`？
2. 当前 path 是否背负一批 startup `initialMessages`，因此需要 initial-history suppress？
3. 当前 path 会不会遭遇 initial flush 尚未完成的窗口，因此需要 `flushGate`？
4. 当前入口在回答“哪些本地消息应被转换后写入”，还是“daemon 已经产出的 SDKMessage 如何直接发出”？
5. 当前 path 的 dedup 集合是在服务相同问题，还是只是碰巧共享一部分 echo suppress？
6. 我现在分析的是 write contract，还是 55/189 已经讨论过的 dedup / continuity 家族？

只要这六轴不先拆开，后面就会把：

- REPL write path
- daemon write path
- local echo suppress

混成一张“统一 bridge 写入表”。

## 第一层：`writeMessages(...)` 先是 REPL path，它处理的是内部 `Message[]`，不是现成 SDK payload

`replBridge.ts` 的 `writeMessages(messages)` 会先做：

- `isEligibleBridgeMessage(m)`
- `!initialMessageUUIDs.has(m.uuid)`
- `!recentPostedUUIDs.has(m.uuid)`

随后才：

- `toSDKMessages(filtered)`
- 给每条事件补 `session_id`
- `transport.writeBatch(events)`

这说明 `writeMessages(...)` 回答的问题首先是：

- REPL 内部消息哪些能进入 bridge
- 以及它们如何在写入前被转换成 SDK payload

它不是在回答：

- 一批已经是 SDKMessage 的对象如何直接发出

更准确地说：

- 这是 internal-message write contract

不是 generic transport sink。

## 第二层：`writeSdkMessages(...)` 先是 daemon path，它明确跳过转换，也没有 initial-history filter

`replBridge.ts` 自己已经把 `writeSdkMessages(messages)` 的主语写得很硬：

- daemon path
- query() already yields `SDKMessage`
- skip conversion
- no `initialMessageUUIDs` filter
- no `flushGate`

函数体也只保留：

- `!recentPostedUUIDs.has(m.uuid)`
- 给事件补 `session_id`
- `transport.writeBatch(events)`

这说明 `writeSdkMessages(...)` 回答的问题不是：

- REPL path 里哪些历史 / eligible message 需要被挑出来再转换

而是：

- daemon 已经产出的 SDK payload 如何在 echo suppress 之后直接写出

所以更准确的理解不是：

- 它只是 `writeMessages(...)` 少了一个 `toSDKMessages(...)`

而是：

- 它从入口对象形状开始，就在回答另一种 write contract

## 第三层：`initialMessageUUIDs` 只属于 REPL path，因为 daemon path 明确“没有 initial messages”

在 `replBridge.ts` 里，
`initialMessageUUIDs` 来自：

- `initialMessages`

而 `writeMessages(...)` 明确会用它做 suppress。

但 `writeSdkMessages(...)` 的注释又直接写了：

- daemon has no initial messages
- no `initialMessageUUIDs` filter

这说明 `initialMessageUUIDs` 回答的问题首先是：

- REPL 启动时已经存在的本地初始历史，哪些不该在 live write path 里再发一次

它不是 bridge 写入接口的通用前置条件。

因此更准确的结论不是：

- daemon path 只是暂时没接这个过滤器

而是：

- daemon path 从 contract 上就没有这层 initial-history suppress

## 第四层：`flushGate` 也只属于 REPL path，因为只有它会遇到 initial flush 的握手窗口

`replBridge.ts` 还明确写着：

- start the flush gate before connect() to cover the WS handshake window
- `writeMessages()` 在这个窗口里可能排队

而 `writeSdkMessages(...)` 的注释又明确说：

- daemon never starts it
- no initial flush

这说明 `flushGate` 回答的问题不是：

- 所有 bridge 写入口都需要一个统一的排队器

而是：

- REPL path 因为有 initial history replay / handshake 窗口，才需要把 live writes 暂存

所以更准确的理解不是：

- daemon path 只是没复用这层实现

而是：

- 它在合同上就没有这层历史注水窗口

## 第五层：`recentPostedUUIDs` 在两条 path 中共享，但共享的是 echo suppress，不是全部 write contract

两条 path 都会：

- 用 `recentPostedUUIDs` 做过滤
- 在发出前把新 UUID 追加进去

这说明它们确实共享一部分东西：

- echo suppress family

但更准确的结论不是：

- 既然共享这张集合，就说明 write contract 也相同

而是：

- 共享的是 echo filtering 这一层局部机制
- 不共享的是入口对象、initial-history suppress、`flushGate` 语义与转换责任

所以不能把：

- shared `recentPostedUUIDs`

误听成：

- same write contract

## 第六层：`remoteBridgeCore.ts` 进一步说明，这不是 v1 特例，而是 bridge host family 里的稳定分裂

`remoteBridgeCore.ts` 也有同样的两条入口：

- `writeMessages(messages)`
- `writeSdkMessages(messages: SDKMessage[])`

其中 `writeMessages(...)` 仍然会做：

- `isEligibleBridgeMessage`
- `!initialMessageUUIDs.has(...)`
- `!recentPostedUUIDs.has(...)`

而 `writeSdkMessages(...)` 仍然只做：

- `!recentPostedUUIDs.has(...)`

这说明更准确的理解不是：

- 这只是 v1 `replBridge.ts` 里的一段局部分叉

而是：

- REPL path vs daemon path 的 write contract 分裂
- 在 bridge host family 里本来就是稳定模式

## 第七层：因此更稳的写法不是“两个 write 函数最后都发事件”，而是“同一 transport sink，不等于同一 write contract”

到这里更稳的写法已经不是：

- `writeMessages(...)` 和 `writeSdkMessages(...)` 本质一样

而应该明确拆成：

1. `writeMessages(...)`
   internal `Message[]`
   eligible filter
   initial-history suppress
   `flushGate`
   conversion to SDK
2. `writeSdkMessages(...)`
   already-formed `SDKMessage[]`
   echo suppress only
   no `initialMessageUUIDs`
   no `flushGate`
   direct batch write

所以更准确的结论不是：

- 两者只是实现细节不同

而是：

- 它们共享同一个 transport sink
- 但不是同一种 bridge write contract

## 第八层：为什么这页不是 55 或 189 的附录

55 讲的是：

- 多层 dedup family 为什么不是同一种去重

189 讲的是：

- continuity ledger 为什么不能跨 fresh session 继承

190 这一页更窄地关心的是：

- bridge 的两个写入口为什么从入口对象到 suppress / gate 语义都不一样

所以三页虽然共享：

- `recentPostedUUIDs`
- `initialMessageUUIDs`

但主语不同：

- 55 问 dedup family taxonomy
- 189 问 continuity contract
- 190 问 write contract split

## 第九层：`190` 只结束 outbound write trunk，不结束整条 bridge 线

这页如果停在这里，

读者最容易再犯一个结构误判：

- `190` 既然已经写到 write contract，那 bridge 线应该就到此为止

但更稳的 handoff 是：

- `190` 只结束 outbound write trunk
- 紧接着 bridge 会转入 `191` 的 ingress triage root
- 再分到 `192` 的 read-side continuity 与 `193 -> 206` 的 control / blocked-state 分支

所以 `190` 的正确位置不是：

- bridge terminal

而是：

- 通往 post-connect runtime 问题的最后一个 outbound zoom

## 稳定面与灰度面

本页只保护稳定不变量：

- `writeMessages(...)` 是 REPL/internal-message write contract
- `writeSdkMessages(...)` 是 daemon/direct-SDK write contract
- `initialMessageUUIDs` 与 `flushGate` 只属于前者
- `recentPostedUUIDs` 只是共享的 echo suppress 层，不足以抹平两条合同

本页刻意不展开的灰度层包括：

- continuity ledger 的继承条件
- `recentInboundUUIDs` 的全部 inbound edge case
- `flushGate` 的完整状态机
- viewer 侧 echo / render contract

这些都相关，但不属于本页的 hard sentence。

## 苏格拉底式自审

### 问：为什么不能把这页写成“daemon path 没有 initial messages”那么简单？

答：因为 `no initial messages` 只是差异的一部分；真正新增的句子是两条 path 从入口对象形状开始，就在回答不同的写入合同。

### 问：为什么 `recentPostedUUIDs` 的共享不足以说明它们本质相同？

答：因为共享的是 echo suppress 这一层局部机制，不是 initial-history suppress、`flushGate`、转换责任和输入对象形状。

### 问：为什么这页不该继续写成 continuity 主题？

答：因为那会回卷到 189；190 的新增价值在于把“bridge 怎么写消息”本身拆开，而不是继续讨论哪张 ledger 能继承。
